#include <Eigen/Dense>
#include <vector>
#include <iostream>
#include <opencv2/opencv.hpp>

void solvePnP(
    const std::vector<cv::Point3f> &pts_3,
    const std::vector<cv::Point2f> &pts_2,
    const cv::Mat &K,
    Eigen::Matrix3d &R,
    Eigen::Vector3d &T
) {
    // Minimum number of points required by DLT is 6
    size_t n = pts_3.size();
    if (n < 6 || pts_3.size() != pts_2.size()) {
        std::cerr << "Not enough points or mismatch in number of 2D and 3D points." << std::endl;
        return;
    }

    // TODO: Implement the DLT PnP Algorithm

    double fx = K.at<double>(0,0), fy = K.at<double>(1,1);
    double cx = K.at<double>(0,2), cy = K.at<double>(1,2);

    // 1. Construct the matrix A (2n x 12)
    Eigen::MatrixXd A(2*n, 12);
    for (size_t i = 0; i < n; i++) {
        double X = pts_3[i].x, Y = pts_3[i].y, Z = pts_3[i].z;
        double u = (pts_2[i].x - cx) / fx;  // normalised image coords
        double v = (pts_2[i].y - cy) / fy;
        A.row(2*i)   << X, Y, Z, 1,  0, 0, 0, 0, -u*X, -u*Y, -u*Z, -u;
        A.row(2*i+1) << 0, 0, 0, 0,  X, Y, Z, 1, -v*X, -v*Y, -v*Z, -v;
    }

    // 2. Solve Ax = 0 using SVD — solution is last column of V
    Eigen::JacobiSVD<Eigen::MatrixXd> svd(A, Eigen::ComputeFullV);
    Eigen::VectorXd x = svd.matrixV().col(11);

    // 3. Extract R and T from the 12-vector (row-major [R|t])
    Eigen::Matrix3d M;
    M << x(0), x(1), x(2),
         x(4), x(5), x(6),
         x(8), x(9), x(10);
    Eigen::Vector3d t_raw(x(3), x(7), x(11));

    // Fix global sign so points are in front of the camera (det > 0)
    if (M.determinant() < 0) { M = -M; t_raw = -t_raw; }

    // 4. Enforce SO(3) constraint on R via SVD of M
    Eigen::JacobiSVD<Eigen::Matrix3d> svd_M(M, Eigen::ComputeFullU | Eigen::ComputeFullV);
    R = svd_M.matrixU() * svd_M.matrixV().transpose();
    if (R.determinant() < 0) {
        Eigen::Matrix3d diag = Eigen::Matrix3d::Identity();
        diag(2,2) = -1;
        R = svd_M.matrixU() * diag * svd_M.matrixV().transpose();
    }
    T = t_raw / svd_M.singularValues().mean();
}
