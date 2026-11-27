# MRAC-e — Adaptive mass estimation for a quadrotor

This controller implements an online inverse-mass estimator based on Model Reference Adaptive Control with e-modification (MRAC-e). The estimated mass is used to compensate a PD position controller during payload variations.

**Source:** `myCtrl (14).cpp` — C++ / Fl-AIR (Framework libre AIR).

**Reference:** A. Millan et al., *Control architecture for uncertainties’ system compensation using adaptive control theory and neural networks*, IEEE/ASME AIM 2026, [doi:10.1109/AIM65483.2026.11658116](https://doi.org/10.1109/AIM65483.2026.11658116), Section III, equations (7), (10)–(17).

## 1. Control architecture

The adaptive algorithm does not replace the position controller. It estimates a physical parameter that scales the controller output.

```text
Position/velocity errors + desired acceleration
       |                         |
       v                         v
  PD controller (nu) ------> MRAC-e estimator
       |                         |
       |                    estimated mass
       +------------+------------+
                    v
             u = mass_hat * nu
               |           |
            u_x,u_y       u_z
               |           |
        Attitude PD     Thrust command
               +-----------+
                     v
                 Fl-AIR output
```

The estimator uses vertical tracking errors, while the estimated mass is used in all three position axes.

## 2. Source code organization

Line numbers refer to the supplied source file.

| Function / block | Lines | Purpose |
| --- | --- | --- |
| `MyController()` | 29–82 | Creates the input matrix, GUI parameters, logs and reset button. |
| `UpdateFrom()` | 89–229 | Executes one control iteration. |
| Time step and initialization | 91–121 | Obtains the sampling interval and initializes or resets the estimate. |
| Input and GUI parameters | 123–142 | Reads feedback and controller gains. |
| PD and adaptive estimation | 144–173 | Computes the virtual control, updates inverse mass and applies compensation. |
| Attitude and thrust | 175–198 | Computes and limits the output commands. |
| Outputs and logging | 205–228 | Sends four commands and records the estimator behavior. |
| `Reset()` | 231–234 | Sets the first-update flag. |
| `SetValues()` | 236–269 | Receives state and reference information from the main controller. |
| `applyMotorConstant()` | 271–283 | Divides commands by the configured motor constant. |
| `plotEstimatedMass()` | 285–296 | Displays mass estimates and estimation error. |

## 3. Input and output interface

`SetValues()` populates a 4 × 6 matrix. Each column represents a different input:

| Column | Input | Meaning |
| --- | --- | --- |
| 0 | `pos_error` | Position tracking error (x, y, z). |
| 1 | `vel_error` | Velocity tracking error (x, y, z). |
| 2 | `currentQuaternion` | Attitude quaternion (q0, q1, q2, q3). |
| 3 | `omega` | Angular velocity. |
| 4 | `yaw_ref` | Desired yaw. |
| 5 | `xppd`, `yppd`, `zppd` | Desired translational acceleration. |

`UpdateFrom()` returns four actuator-level controller commands: `tau.x`, `tau.y`, `tau.z`, and `thrust`. These are scaled using the motor constant and limited before being passed to Fl-AIR. They are not four individual rotor forces.

## 4. Mathematical formulation and implementation

### 4.1. PD position controller

The paper defines the unknown parameter as

$$\Theta=\frac{1}{m},\qquad \hat m=\frac{1}{\hat\Theta}.$$

In the paper's coordinate and error convention, the nominal virtual control is

$$\boldsymbol\nu=\ddot{\boldsymbol p}_d-K_p\boldsymbol e_p-K_d\dot{\boldsymbol e}_p+\boldsymbol g.$$

The actual code computes (lines 144–146):

```cpp
float nu_x = xppd.x + Kp_pos_val.x*pos_error.x + Kd_pos_val.x*vel_error.x;
float nu_y = xppd.y + Kp_pos_val.y*pos_error.y + Kd_pos_val.y*vel_error.y;
float nu_z = xppd.z + Kp_pos_val.z*pos_error.z + Kd_pos_val.z*vel_error.z - g;
```

The signs differ from the paper. The upstream error definitions and vertical-axis convention must be checked in the main controller before claiming exact mathematical equivalence.

### 4.2. Sliding variable

```cpp
const float s = vel_error.z + lambda * pos_error.z;
```

This combines position and velocity errors, corresponding structurally to

$$s_z=\dot e_z+\lambda_a e_z.$$

### 4.3. Adaptive law with e-modification

Equation (13) of the paper proposes

$$\dot{\hat\Theta}=\gamma\frac{s_z\nu_z}{\hat\Theta}-\sigma_a|s_z|(\hat\Theta-\Theta_0).$$

The corresponding implementation is (lines 150–154):

```cpp
float theta_0_val = 1.0f / theta_0->Value();
const float theta_safe = (theta_hat < 0.05f) ? 0.05f : theta_hat;
float theta_hat_dot = -gamma * (s * phi_z / theta_safe)
                    - sigma * std::abs(s) * (theta_hat - theta_0_val);
```

Here `phi_z` is computed identically to `nu_z`. The first term adapts the inverse mass using the tracking error and control signal. The second term is the e-modification, which pulls the estimate towards its nominal value when the sliding error is nonzero. When `s` is zero, both terms vanish.

The first term in the code has a negative sign, unlike equation (13). Its consistency depends on the upstream signal conventions; this cannot be established from this source file alone.

### 4.4. Discrete-time integration and limits

The adaptive law is integrated using forward Euler:

$$\hat\Theta_{k+1}=\hat\Theta_k+\Delta t\,\dot{\hat\Theta}_k.$$

The code first clips the derivative to ±0.9, then integrates and limits the inverse mass to [0.2, 3.5] kg⁻¹. This corresponds to an estimated mass between approximately 0.286 and 5 kg. The denominator floor of 0.05 protects the adaptation calculation against division by a very small parameter.

These are implementation safeguards, not a proof that the discrete-time system with saturation satisfies the continuous-time theorem.

### 4.5. Mass compensation

```cpp
float mass_ctrl_hat = 1.0f / theta_hat;
u.x = mass_ctrl_hat * nu_x;
u.y = mass_ctrl_hat * nu_y;
u.z = mass_ctrl_hat * nu_z;
```

This implements the principle of equation (7):

$$\boldsymbol u=\hat m\boldsymbol\nu.$$

The current iteration's updated estimate is used to compute the control. The lateral components are used in the Euler-angle attitude controller; the vertical component is saved before position saturation and processed separately as thrust. The attitude commands and thrust are then scaled and limited.

## 5. Parameters and initialization

The GUI allows tuning without recompilation. The following are constructor defaults, not verified flight-test settings.

| GUI / code parameter | Meaning | Default in source |
| --- | --- | --- |
| `km` | Adaptation gain γ | 0.1 |
| `sigma_mod` | e-modification gain σ | 0.01 |
| `lambda_s` | Sliding variable coefficient λ | 1.0 |
| `theta_init` | Initial **mass** in kg, inverted internally | 1.2 |
| `theta_0` | Nominal **mass** in kg, inverted internally | 1.0 |
| `mass_ref` | Reference mass for logging, kg | 1.2 |
| `k_motor` | Motor command scaling constant | 29.5870 |
| `Kp_pos`, `Kd_pos` | Position gains | Read from GUI |
| `Kp_att`, `Kd_att` | Attitude gains | Read from GUI |
| `deltaT_custom` | Sampling interval override | If zero, use incoming data interval |

`Reset Mass Estimation` sets `theta_hat = 1/theta_init`. The ordinary `Reset()` only sets `first_update`; a file-scope initialization flag means a finite estimate can be retained across that reset. Both mass GUI fields used as denominators and the motor constant must be strictly positive.

## 6. Monitoring

The state log contains the position and yaw errors, reference mass, nominal mass, estimated mass, and mass estimation error. Despite the labels `theta_0`, `theta_hat` and `theta_error`, the logged entries are in **mass units (kg)**, not inverse-mass units.

`mass_ref` is only used for visualization and comparison. The true payload mass is not supplied to the adaptation law.

## 7. Practical notes and scope of the paper

- In Table I of the paper, the reported values are k_pz = 3, k_dz = 1.5, λ_a = 1. These do not satisfy both gain relationships used to simplify the MRAC-e proof. The actual flight settings need to be confirmed from the saved GUI configuration; the proof does not directly cover the reported gain combination.
- Theorem 1 assumes constant inverse mass during continuous evolution. The payload experiment uses piecewise-constant masses; a jump in true mass changes the estimation error immediately and requires additional analysis at the transition.
- Derivative clipping, parameter clipping, command saturation and numerical integration are additional practical implementation details.
- The controller uses Euler angles for attitude feedback after converting the received quaternion. It is not a quaternion-error attitude controller.
- The supplied file is a component of a larger Fl-AIR project. It depends on `myCtrl.h`, Fl-AIR headers, an upstream controller and hardware configuration. No standalone build or live flight validation is provided by this README.

## 8. Recommended walkthrough

Start with `SetValues()`, then open `UpdateFrom()` at lines 144–173. Follow the PD output → sliding variable → adaptive law → Euler integration → mass compensation. Finally, show `plotEstimatedMass()` and the GUI controls. This covers the essential method without walking through every framework-specific line.
