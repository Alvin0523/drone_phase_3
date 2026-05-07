# Implementation Notes — Project 3 Phase 1

## Files Changed

| File | What was done |
|---|---|
| `catkin_ws/src/tag_detector/src/pnp.hpp` | Implemented DLT PnP algorithm (TODO block) |
| `catkin_ws/src/ekf/src/ekf_node.cpp` | Added global state variables; implemented `imu_callback` (prediction) and `odom_callback` (correction) |
| `catkin_ws/src/ekf/CMakeLists.txt` | Changed `-std=c++11` → `-std=c++14` (Boost compatibility) |
| `catkin_ws/src/tag_detector/CMakeLists.txt` | Changed `-std=c++11` → `-std=c++14` (Boost compatibility) |
| `catkin_ws/src/tag_detector/src/tag_detector_node.cpp` | `using namespace aruco` → `using namespace ::aruco`; `aruco::CameraParameters` → `::aruco::CameraParameters` (OpenCV 4.13 namespace conflict) |
| `catkin_ws/pixi.toml` | Added `ros-noetic-cv-bridge`, `ros-noetic-aruco`, `eigen = "3.*"`; added `launch` and `download-bag` tasks |

---

## DLT PnP (`pnp.hpp`)

The Direct Linear Transform solves for the world-to-camera transform `[R|t]` from n ≥ 6 point correspondences.

**Projection model** (after K normalisation):
```
u_n = (u - cx) / fx,  v_n = (v - cy) / fy
```
Each point contributes 2 rows to matrix A:
```
[X, Y, Z, 1,  0, 0, 0, 0, -u_n X, -u_n Y, -u_n Z, -u_n]
[0, 0, 0, 0,  X, Y, Z, 1, -v_n X, -v_n Y, -v_n Z, -v_n]
```

**Steps:**
1. Build A (2n × 12)
2. SVD of A — solution is last column of V (smallest singular value)
3. Reshape into 3 × 4 matrix M = [A\_mat | t\_raw]
4. Fix global sign: `if det(A_mat) < 0` flip sign
5. SVD of A\_mat to enforce SO(3): `R = U * V^T`, scale `T = t_raw / mean(singular values)`

---

## EKF (`ekf_node.cpp`)

### State vector (15-dim)
```
x = [p(3),  rpy(3),  v(3),  b_g(3),  b_a(3)]
     pos    attitude  vel   gyro bias  accel bias
```

### Added globals
- `x`, `P` — state and covariance
- `initialized`, `last_imu_time` — timing and init guard
- `t_cam_in_imu = [0.05, 0.05, 0.0]` — camera origin in IMU frame
- Helper functions: `euler2rot`, `rot2rpy`, `eulerRateMatrix`

### Prediction (`imu_callback`)

Corrected IMU: `ω_c = ω - b_g`,  `a_c = a - b_a`

State propagation (Euler integration):
```
p    ← p + v·dt
rpy  ← rpy + W(roll,pitch)·ω_c·dt
v    ← v + (R·a_c - g)·dt
b_g, b_a  unchanged  (random walk)
```

Continuous Jacobian F (15 × 15) key blocks:
```
F[p,  v]   = I
F[rpy, b_g]= -W
F[v,  rpy] = [dR/droll·a_c | dR/dpitch·a_c | dR/dyaw·a_c]
F[v,  b_a] = -R
```

Discrete: `F_t = I + F·dt`

Noise input U (15 × 12), noise order `[n_gyro, n_accel, n_bg, n_ba]`:
```
U[rpy, n_gyro]  = -W
U[v,   n_accel] = -R
U[b_g, n_bg]    = I
U[b_a, n_ba]    = I
```

Covariance propagation:
```
V_t = U·dt
P ← F_t·P·F_t^T + V_t·Q·V_t^T
```

### Correction (`odom_callback`)

`odom_ref` from tag\_detector is the raw solvePnP output (world-to-camera transform):
- position = `t`  (world origin in camera frame)
- orientation = `R^{cam}_{world}`

Convert to IMU pose in world:
```
R_world_cam = R_cam_world^T
p_cam       = -R_world_cam · t
R_world_imu = R_world_cam · Rcam^T      (Rcam = R^{imu}_{cam})
p_imu       = p_cam - R_world_imu · t_cam_in_imu
rpy_imu     = rot2rpy(R_world_imu)
```

Measurement `z = [p_imu; rpy_imu]` (6-dim)

Jacobian H (6 × 15): identity blocks at positions [0:3,0:3] and [3:6,3:6]

Kalman update:
```
innov = z - H·x    (yaw wrapped to [-π, π])
S = H·P·H^T + Rt
K = P·H^T·S^{-1}
x ← x + K·innov
P ← (I - K·H)·P
```

### Tuning parameters

| Matrix | Initial value | Role |
|---|---|---|
| `Q[0:6, 0:6]` | `0.01·I` | Gyro + accel noise |
| `Q[6:12,6:12]`| `0.01·I` | Bias random walk |
| `Rt[0:3,0:3]` | `0.1·I` | Position measurement noise |
| `Rt[3:6,3:6]` | `0.1·I` | Attitude measurement noise |

Increase Q to trust IMU less (smoother but slower to correct). Increase Rt to trust visual less (smoother but more IMU drift).

---

## How to Run

```bash
# 1. Download rosbag (one-time)
pixi run download-bag

# 2. Build
pixi run build

# 3. Launch EKF + tag_detector + RViz
pixi run launch
```
