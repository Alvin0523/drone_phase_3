#include "camodocal/gpl/EigenQuaternionParameterization.h"

#include <cmath>

namespace camodocal
{

bool
EigenQuaternionParameterization::Plus(const double* x,
                                      const double* delta,
                                      double* x_plus_delta) const
{
    const double norm_delta =
        sqrt(delta[0] * delta[0] + delta[1] * delta[1] + delta[2] * delta[2]);
    if (norm_delta > 0.0)
    {
        const double sin_delta_by_delta = (sin(norm_delta) / norm_delta);
        double q_delta[4];
        q_delta[0] = sin_delta_by_delta * delta[0];
        q_delta[1] = sin_delta_by_delta * delta[1];
        q_delta[2] = sin_delta_by_delta * delta[2];
        q_delta[3] = cos(norm_delta);
        EigenQuaternionProduct(q_delta, x, x_plus_delta);
    }
    else
    {
        for (int i = 0; i < 4; ++i)
        {
            x_plus_delta[i] = x[i];
        }
    }
    return true;
}

bool
EigenQuaternionParameterization::PlusJacobian(const double* x,
                                               double* jacobian) const
{
    jacobian[0] =  x[3]; jacobian[1]  =  x[2]; jacobian[2]  = -x[1];  // NOLINT
    jacobian[3] = -x[2]; jacobian[4]  =  x[3]; jacobian[5]  =  x[0];  // NOLINT
    jacobian[6] =  x[1]; jacobian[7] = -x[0]; jacobian[8] =  x[3];  // NOLINT
    jacobian[9] = -x[0]; jacobian[10]  = -x[1]; jacobian[11]  = -x[2];  // NOLINT
    return true;
}

bool
EigenQuaternionParameterization::Minus(const double* y,
                                       const double* x,
                                       double* y_minus_x) const
{
    // q = y * conj(x), stored as [x,y,z,w]
    double q[4];
    q[0] = y[3]*(-x[0]) + y[0]*x[3] + y[1]*(-x[2]) - y[2]*(-x[1]);
    q[1] = y[3]*(-x[1]) - y[0]*(-x[2]) + y[1]*x[3] + y[2]*(-x[0]);
    q[2] = y[3]*(-x[2]) + y[0]*(-x[1]) - y[1]*(-x[0]) + y[2]*x[3];
    q[3] = y[3]*x[3] - y[0]*(-x[0]) - y[1]*(-x[1]) - y[2]*(-x[2]);
    const double norm = sqrt(q[0]*q[0] + q[1]*q[1] + q[2]*q[2]);
    const double scale = norm > 0.0 ? 2.0 * atan2(norm, q[3]) / norm : 2.0;
    y_minus_x[0] = q[0] * scale;
    y_minus_x[1] = q[1] * scale;
    y_minus_x[2] = q[2] * scale;
    return true;
}

bool
EigenQuaternionParameterization::MinusJacobian(const double* x,
                                                double* jacobian) const
{
    // 3x4 matrix (transpose of PlusJacobian)
    jacobian[0]  =  x[3]; jacobian[1]  = -x[2]; jacobian[2]  =  x[1]; jacobian[3]  = -x[0];  // NOLINT
    jacobian[4]  =  x[2]; jacobian[5]  =  x[3]; jacobian[6]  = -x[0]; jacobian[7]  = -x[1];  // NOLINT
    jacobian[8]  = -x[1]; jacobian[9]  =  x[0]; jacobian[10] =  x[3]; jacobian[11] = -x[2];  // NOLINT
    return true;
}

}
