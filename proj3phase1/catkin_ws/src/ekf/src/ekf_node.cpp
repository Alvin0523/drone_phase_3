#include <iostream>
#include <ros/ros.h>
#include <ros/console.h>
#include <sensor_msgs/Imu.h>
#include <sensor_msgs/Range.h>
#include <nav_msgs/Odometry.h>
#include <Eigen/Eigen>

using namespace std;
using namespace Eigen;
ros::Publisher odom_pub;
MatrixXd Q = MatrixXd::Identity(12, 12);
MatrixXd Rt = MatrixXd::Identity(6,6);

// Additional state variables (README: add them in the same file)
VectorXd x = VectorXd::Zero(15);   // [p(3), rpy(3), v(3), b_g(3), b_a(3)]
MatrixXd P = MatrixXd::Identity(15, 15);
bool      initialized = false;
ros::Time last_imu_time;
Vector3d  t_cam_in_imu;            // set in main()

Matrix3d euler2rot(double roll, double pitch, double yaw) {
    return (AngleAxisd(yaw,   Vector3d::UnitZ())
          * AngleAxisd(pitch, Vector3d::UnitY())
          * AngleAxisd(roll,  Vector3d::UnitX())).toRotationMatrix();
}
Vector3d rot2rpy(const Matrix3d &R) {
    return Vector3d(atan2(R(2,1), R(2,2)),
                    atan2(-R(2,0), sqrt(R(2,1)*R(2,1) + R(2,2)*R(2,2))),
                    atan2(R(1,0), R(0,0)));
}
Matrix3d eulerRateMatrix(double roll, double pitch) {
    double sr=sin(roll), cr=cos(roll), tp=tan(pitch), cp=cos(pitch);
    Matrix3d W;
    W << 1, sr*tp, cr*tp,  0, cr, -sr,  0, sr/cp, cr/cp;
    return W;
}

void imu_callback(const sensor_msgs::Imu::ConstPtr &msg)
{
    // Implement EKF prediction here:
    if (!initialized) return;

    ros::Time t_now = msg->header.stamp;
    double dt = (t_now - last_imu_time).toSec();
    last_imu_time = t_now;
    if (dt <= 0.0 || dt > 1.0) return;

    Vector3d omega(msg->angular_velocity.x, msg->angular_velocity.y, msg->angular_velocity.z);
    Vector3d accel(msg->linear_acceleration.x, msg->linear_acceleration.y, msg->linear_acceleration.z);

    Vector3d rpy = x.segment<3>(3);
    Vector3d v   = x.segment<3>(6);
    Vector3d b_g = x.segment<3>(9);
    Vector3d b_a = x.segment<3>(12);

    Vector3d omega_c = omega - b_g;
    Vector3d accel_c = accel - b_a;

    double roll=rpy(0), pitch=rpy(1), yaw=rpy(2);
    Matrix3d R = euler2rot(roll, pitch, yaw);
    Matrix3d W = eulerRateMatrix(roll, pitch);
    Vector3d g(0.0, 0.0, 9.81);

    // State propagation (Euler integration)
    x.segment<3>(0) += v * dt;
    x.segment<3>(3) += W * omega_c * dt;
    x.segment<3>(6) += (R * accel_c - g) * dt;
    // b_g, b_a: random walk model — no change

    // Continuous Jacobian F (15x15)
    double sr=sin(roll), cr=cos(roll), sp=sin(pitch), cp=cos(pitch), sy=sin(yaw), cy=cos(yaw);
    Matrix3d Rx, Ry, Rz, dRxdr, dRydp, dRzdy;
    Rx  <<  1,  0,   0,    0,  cr, -sr,   0, sr, cr;
    Ry  << cp,  0,  sp,    0,   1,   0, -sp,  0, cp;
    Rz  << cy,-sy,   0,   sy,  cy,   0,   0,  0,  1;
    dRxdr << 0,0,0,  0,-sr,-cr,  0,cr,-sr;
    dRydp << -sp,0,cp,  0,0,0,  -cp,0,-sp;
    dRzdy << -sy,-cy,0,  cy,-sy,0,  0,0,0;

    MatrixXd F = MatrixXd::Zero(15, 15);
    F.block<3,3>(0, 6)  = Matrix3d::Identity();
    F.block<3,3>(3, 9)  = -W;
    F.block<3,1>(6, 3)  = (Rz*Ry*dRxdr)  * accel_c;
    F.block<3,1>(6, 4)  = (Rz*dRydp*Rx)  * accel_c;
    F.block<3,1>(6, 5)  = (dRzdy*Ry*Rx)  * accel_c;
    F.block<3,3>(6, 12) = -R;

    MatrixXd F_t = MatrixXd::Identity(15, 15) + F * dt;

    // Noise input matrix U (15x12): noise = [n_gyro, n_accel, n_bg, n_ba]
    MatrixXd U = MatrixXd::Zero(15, 12);
    U.block<3,3>(3,  0) = -W;
    U.block<3,3>(6,  3) = -R;
    U.block<3,3>(9,  6) = Matrix3d::Identity();
    U.block<3,3>(12, 9) = Matrix3d::Identity();

    MatrixXd V_t = U * dt;
    P = F_t * P * F_t.transpose() + V_t * Q * V_t.transpose();
}

// Rotation from the camera frame to the IMU frame.
Eigen::Matrix3d Rcam;
void odom_callback(const nav_msgs::Odometry::ConstPtr &msg)
{
    // Implement EKF correction here:
    // Fixed camera/IMU extrinsic used for the conversion:
    // camera origin expressed in the IMU frame = (0.05, 0.05, 0.0)
    // camera-to-IMU rotation = Quaternion(0, 1, 0, 0) in (w, x, y, z) order
    // equivalent rotation matrix:
    //     [ 1,  0,  0]
    //     [ 0, -1,  0]
    //     [ 0,  0, -1]

    // tag_detector publishes solvePnP output: world-to-camera transform
    //   position    = t  (world origin in camera frame)
    //   orientation = R  (R^{cam}_{world})
    Vector3d t_wc(msg->pose.pose.position.x,
                  msg->pose.pose.position.y,
                  msg->pose.pose.position.z);
    Quaterniond q_wc(msg->pose.pose.orientation.w,
                     msg->pose.pose.orientation.x,
                     msg->pose.pose.orientation.y,
                     msg->pose.pose.orientation.z);
    Matrix3d R_cam_world = q_wc.toRotationMatrix();

    // Invert to get camera pose in world frame
    Matrix3d R_world_cam = R_cam_world.transpose();
    Vector3d p_cam       = -R_world_cam * t_wc;

    // Apply camera-to-IMU extrinsic
    // Rcam = R^{imu}_{cam}, so R^{world}_{imu} = R^{world}_{cam} * Rcam^T
    Matrix3d R_world_imu = R_world_cam * Rcam.transpose();
    Vector3d p_imu       = p_cam - R_world_imu * t_cam_in_imu;
    Vector3d rpy_imu     = rot2rpy(R_world_imu);

    // Measurement z = [p_imu; rpy_imu]
    VectorXd z(6);
    z.segment<3>(0) = p_imu;
    z.segment<3>(3) = rpy_imu;

    // Initialise state on first visual measurement
    if (!initialized) {
        x.setZero();
        x.segment<3>(0) = p_imu;
        x.segment<3>(3) = rpy_imu;
        P = MatrixXd::Identity(15, 15);
        P.block<3,3>(0,  0) *= 0.1;
        P.block<3,3>(3,  3) *= 0.1;
        P.block<3,3>(6,  6) *= 1.0;
        P.block<3,3>(9,  9) *= 0.01;
        P.block<3,3>(12,12) *= 0.01;
        last_imu_time = msg->header.stamp;
        initialized   = true;
        return;
    }

    // Measurement Jacobian H (6x15): identity blocks for p and rpy
    MatrixXd H = MatrixXd::Zero(6, 15);
    H.block<3,3>(0, 0) = Matrix3d::Identity();
    H.block<3,3>(3, 3) = Matrix3d::Identity();

    VectorXd innov = z - H * x;
    while (innov(5) >  M_PI) innov(5) -= 2.0 * M_PI;
    while (innov(5) < -M_PI) innov(5) += 2.0 * M_PI;

    MatrixXd S = H * P * H.transpose() + Rt;
    MatrixXd K = P * H.transpose() * S.inverse();
    x += K * innov;
    P  = (MatrixXd::Identity(15, 15) - K * H) * P;

    // Publish fused odometry
    nav_msgs::Odometry odom;
    odom.header.stamp    = msg->header.stamp;
    odom.header.frame_id = "world";
    odom.pose.pose.position.x = x(0);
    odom.pose.pose.position.y = x(1);
    odom.pose.pose.position.z = x(2);
    Quaterniond q_out(euler2rot(x(3), x(4), x(5)));
    odom.pose.pose.orientation.w = q_out.w();
    odom.pose.pose.orientation.x = q_out.x();
    odom.pose.pose.orientation.y = q_out.y();
    odom.pose.pose.orientation.z = q_out.z();
    odom.twist.twist.linear.x = x(6);
    odom.twist.twist.linear.y = x(7);
    odom.twist.twist.linear.z = x(8);
    odom_pub.publish(odom);
}

int main(int argc, char **argv)
{
    ros::init(argc, argv, "ekf");
    ros::NodeHandle n("~");
    ros::Subscriber s1 = n.subscribe("imu", 1000, imu_callback);
    ros::Subscriber s2 = n.subscribe("tag_odom", 1000, odom_callback);
    odom_pub = n.advertise<nav_msgs::Odometry>("ekf_odom", 100);
    Rcam = Quaterniond(0, 1, 0, 0).toRotationMatrix();
    t_cam_in_imu = Vector3d(0.05, 0.05, 0.0);
    cout << "R_cam" << endl << Rcam << endl;
    // Q: process noise covariance. Rt: visual measurement noise covariance.
    // You should tune these parameters for a stable filter.
    Q.topLeftCorner(6, 6) = 0.01 * Q.topLeftCorner(6, 6);
    Q.bottomRightCorner(6, 6) = 0.01 * Q.bottomRightCorner(6, 6);
    Rt.topLeftCorner(3, 3) = 0.1 * Rt.topLeftCorner(3, 3);
    Rt.bottomRightCorner(3, 3) = 0.1 * Rt.bottomRightCorner(3, 3);
    Rt.bottomRightCorner(1, 1) = 0.1 * Rt.bottomRightCorner(1, 1);

    ros::spin();
}
