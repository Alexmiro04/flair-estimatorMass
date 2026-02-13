#include "myCtrl.h"
#include <Matrix.h>
#include <MatrixDescriptor.h>
#include <Vector3D.h>
#include <TabWidget.h>
#include <CheckBox.h>
#include <Quaternion.h>
#include <Layout.h>
#include <LayoutPosition.h>
#include <GroupBox.h>
#include <DoubleSpinBox.h>
#include <DataPlot1D.h>
#include <cmath>
#include <Euler.h>
#include <iostream>
#include <Label.h>
#include <Vector3DSpinBox.h>
#include <Pid.h>

using std::string;
using namespace flair::core;
using namespace flair::gui;
using namespace flair::filter;

MyController::MyController(const LayoutPosition *position, const string &name) : ControlLaw(position->getLayout(),name,4)
{
    first_update = true;

    // Input matrix
    input = new Matrix(this, 4, 6, floatType, name);

    // Matrix descriptor for logging. It should be always a nx1 matrix. 
    MatrixDescriptor *log_labels = new MatrixDescriptor(7, 1);
    log_labels->SetElementName(0, 0, "x_error");
    log_labels->SetElementName(1, 0, "y_error");
    log_labels->SetElementName(2, 0, "z_error");
    log_labels->SetElementName(3, 0, "yaw_error");
    log_labels->SetElementName(4, 0, "mass_ref");
    log_labels->SetElementName(5, 0, "mass_estimated");
    log_labels->SetElementName(6, 0, "mass_error");
    state = new Matrix(this, log_labels, floatType, name);
    delete log_labels;

    // m_hat = 0.9;       // initial value of mass   

    //Kp.x = 7.5;   Kp.y = 7.5;   Kp.z = 15.5;  
    //Kd.x = 7;   Kd.y = 7;   Kd.z = 10;  
    

    g = 9.81;    

    // GUI for custom PID
    GroupBox *gui_customPID = new GroupBox(position, name);
    GroupBox *general_parameters = new GroupBox(gui_customPID->NewRow(), "General parameters");
    deltaT_custom = new DoubleSpinBox(general_parameters->NewRow(), "Custom dt [s]", 0, 1, 0.001, 4);
    mass = new DoubleSpinBox(general_parameters->LastRowLastCol(), "Mass [kg]", 0, 10, 0.01, 4, 1.2);
    k_motor = new DoubleSpinBox(general_parameters->LastRowLastCol(), "Motor constant", 0, 50, 0.01, 4, 29.5870);
    sat_pos = new DoubleSpinBox(general_parameters->NewRow(), "Saturation pos", 0, 10, 0.01, 3);
    sat_att = new DoubleSpinBox(general_parameters->LastRowLastCol(), "Saturation att", 0, 10, 0.01, 3);
    sat_thrust = new DoubleSpinBox(general_parameters->LastRowLastCol(), "Saturation thrust", 0, 10, 0.01, 3);
    km = new DoubleSpinBox(general_parameters->NewRow(), "Km adaptation", 0, 5, 0.01, 4, 0.1);
    m_init = new DoubleSpinBox(general_parameters->LastRowLastCol(), "Initial mass [kg]", 0, 10, 0.01, 4, 1.2);
    mass_ref = new DoubleSpinBox(general_parameters->LastRowLastCol(), "Mass reference [kg]", 0, 10, 0.01, 4, 1.2);
    sigma_mod = new DoubleSpinBox(general_parameters->NewRow(), "Sigma adapt", 0, 1, 0.001, 4, 0.01);

    // Custom cartesian position controller
    GroupBox *custom_position = new GroupBox(gui_customPID->NewRow(), "Custom position controller");
    Kp_pos = new Vector3DSpinBox(custom_position->NewRow(), "Kp_pos", 0, 100, 0.1, 3);
    Kd_pos = new Vector3DSpinBox(custom_position->LastRowLastCol(), "Kd_pos", 0, 100, 0.1, 3);
    Ki_pos = new Vector3DSpinBox(custom_position->LastRowLastCol(), "Ki_pos", 0, 100, 0.1, 3);

    // Custom attitude controller
    GroupBox *custom_attitude = new GroupBox(gui_customPID->NewRow(), "Custom attitude controller");
    Kp_att = new Vector3DSpinBox(custom_attitude->NewRow(), "Kp_att", 0, 100, 0.1, 3);
    Kd_att = new Vector3DSpinBox(custom_attitude->LastRowLastCol(), "Kd_att", 0, 100, 0.1, 3);
    Ki_att = new Vector3DSpinBox(custom_attitude->LastRowLastCol(), "Ki_att", 0, 100, 0.1, 3);



    // Visualize on real time plot
    //massPlot = new DataPlot1D(gui_customPID->NewRow(), "Mass Estimation", 0.0f, 2.0f);
    //massPlot->AddCurve(state->Element(4, 0), DataPlot::Red, "Ref Mass");
    //massPlot->AddCurve(state->Element(5, 0), DataPlot::Blue, "Estimated Mass");

    //errorPlot = new DataPlot1D(gui_customPID->LastRowLastCol(), "Error Estimation", -1.0f, 1.0f);
    //errorPlot->AddCurve(state->Element(6, 0), DataPlot::Red, "Error m");


    resetMassButton = new PushButton(gui_customPID->NewRow(), "Reset Mass Estimation");


    AddDataToLog(state);
}

MyController::~MyController()
{
    delete state;
}

void MyController::UpdateFrom(const io_data *data)
{
    float current_time = double(GetTime())/1000000000-initial_time;
    float thrust = 0.0;
    Vector3Df u, tau;

    if(deltaT_custom->Value() == 0)
    {
        delta_t = (float)(data->DataDeltaTime())/1000000000;
    }
    else
    {
        delta_t = deltaT_custom->Value();
    }
   
    if(first_update)
    {
        initial_time = double(GetTime())/1000000000;
        first_update = false;

        m_hat = m_init->Value(); // Set initial mass estimation
    }

    if (resetMassButton->Clicked()) 
    {
        m_hat = m_init->Value(); // Reset estimated mass to initial value
    }
 

    // Obtain state
    input->GetMutex();
    Vector3Df pos_error(input->Value(0, 0), input->Value(1, 0), input->Value(2, 0));
    Vector3Df vel_error(input->Value(0, 1), input->Value(1, 1), input->Value(2, 1));
    Vector3Df xppd(input->Value(0, 5), input->Value(1, 5), input->Value(2, 5)); // Desired position in x, y, z
    Quaternion q(input->Value(0, 2), input->Value(1, 2), input->Value(2, 2), input->Value(3, 2)); 
    Vector3Df omega(input->Value(0, 3), input->Value(1, 3), input->Value(2, 3));
    float yaw_ref = input->Value(0, 4);
    input->ReleaseMutex();

    // Get tunning parameters from GUI
    Vector3Df Kp_pos_val(Kp_pos->Value().x, Kp_pos->Value().y, Kp_pos->Value().z);
    Vector3Df Kd_pos_val(Kd_pos->Value().x, Kd_pos->Value().y, Kd_pos->Value().z);
    Vector3Df Ki_pos_val(Ki_pos->Value().x, Ki_pos->Value().y, Ki_pos->Value().z);
    Vector3Df Kp_att_val(Kp_att->Value().x, Kp_att->Value().y, Kp_att->Value().z);
    Vector3Df Kd_att_val(Kd_att->Value().x, Kd_att->Value().y, Kd_att->Value().z);
    Vector3Df Ki_att_val(Ki_att->Value().x, Ki_att->Value().y, Ki_att->Value().z);
    float km_adapt = km->Value();


    // How to obtain desired acceleration?

    float sigma_a = sigma_mod->Value();

    // Adaptation law for mass estimation
    //float m_hat_dot = - km_adapt * ( vel_error.x * (xppd.x - Kp_pos_val.x*pos_error.x - Kd_pos_val.x*vel_error.x) + vel_error.y * (xppd.y - Kp_pos_val.y*pos_error.y - Kd_pos_val.y*vel_error.y) + vel_error.z * (xppd.z - Kp_pos_val.z*pos_error.z - Kd_pos_val.z*vel_error.z + g)) - sigma_a*(m_hat - m_init->Value());

    // Adaptation law for mass estimation using only vertical dynamics (Z axis).
    // This keeps the estimator tied to the thrust channel where mass is directly observable.
    float phi_z = xppd.z + Kp_pos_val.z * pos_error.z + Kd_pos_val.z * vel_error.z - g;
    float m_hat_dot = km_adapt * (vel_error.z * phi_z) - sigma_a * (m_hat - m_init->Value());

    const float mhat_dot_max = 0.4f; // kg/s (0.2–0.8)
    if(m_hat_dot >  mhat_dot_max) m_hat_dot =  mhat_dot_max;
    if(m_hat_dot < -mhat_dot_max) m_hat_dot = -mhat_dot_max;

    // Integration part (Euler method)
    m_hat += m_hat_dot * delta_t;

    // Projection to keep a physically meaningful estimate and avoid adaptation runaway.
    const float min_mass = 0.3f;
    const float max_mass = 5.0f;
    if (m_hat < min_mass) m_hat = min_mass;
    if (m_hat > max_mass) m_hat = max_mass;

   
    // std::cout << "m_hat: " << m_hat << " m_tilde: " << m_tilde << std::endl; // Print the error in mass estimation

    // Cartesian custom controller

    // PD controller for position control
    // u.x = Kp_pos_val.x*pos_error.x + Kd_pos_val.x*vel_error.x;
    // u.y = Kp_pos_val.y*pos_error.y + Kd_pos_val.y*vel_error.y;
    // u.z = Kp_pos_val.z*pos_error.z + Kd_pos_val.z*vel_error.z;

    // PD controller for position control with mass compensation
    // u.x = mass->Value()*( + Kp_pos_val.x*pos_error.x + Kd_pos_val.x*vel_error.x);
    // u.y = mass->Value()*( + Kp_pos_val.y*pos_error.y + Kd_pos_val.y*vel_error.y);
    // u.z = mass->Value()*( + Kp_pos_val.z*pos_error.z + Kd_pos_val.z*vel_error.z + g);

    // PD controller for position control with mass compensation and desired acceleration
    // u.x = mass->Value()*(xppd.x + Kp_pos_val.x*pos_error.x + Kd_pos_val.x*vel_error.x);
    // u.y = mass->Value()*(xppd.y + Kp_pos_val.y*pos_error.y + Kd_pos_val.y*vel_error.y);
    // u.z = mass->Value()*(xppd.z + Kp_pos_val.z*pos_error.z + Kd_pos_val.z*vel_error.z - g);

    // PD controller for position control with mass adaptation and desired acceleration
    u.x = xppd.x + Kp_pos_val.x*pos_error.x + Kd_pos_val.x*vel_error.x;
    u.y = xppd.y + Kp_pos_val.y*pos_error.y + Kd_pos_val.y*vel_error.y;
    u.z = xppd.z + Kp_pos_val.z*pos_error.z + Kd_pos_val.z*vel_error.z;

    float ctrl_z = m_hat * u.z; // This is the thrust needed to control the z position before saturation
    u.Saturate(sat_pos->Value());

    
    std::cout << "error x: " << pos_error.x << " error y: " << pos_error.y << " error z: " << pos_error.z << std::endl;

    // Attitude custom controller
    Euler rpy = q.ToEuler();    
    tau.x = Kp_att_val.x*(rpy.roll + u.y) + Kd_att_val.x*omega.x;
    tau.y = Kp_att_val.y*(rpy.pitch - u.x) + Kd_att_val.y*omega.y;
    tau.z = Kp_att_val.z*(rpy.YawDistanceFrom(yaw_ref)) + Kd_att_val.z*omega.z;
    applyMotorConstant(tau);
    tau.Saturate(sat_att->Value());

    // Compute custom thrust
    //float comp_mg = -mass->Value()*g; // This is the thrust needed to counteract gravity. Based on the default PID, it should be -0.397918 in Fl-Air simulator.  
    float comp_mg = -m_hat*g; // This is the thrust needed to counteract gravity. Based on the default PID, it should be -0.397918 in Fl-Air simulator.  
    thrust = comp_mg + ctrl_z; // This is the thrust needed to counteract gravity and control the z position
    //if(thrust < -sat_att->Value())
    //{
    //   thrust = -sat_att->Value();
    //}
    //else if(thrust >= 0)
    //{
    //    thrust = 0; 
    //}

    // Apply motor constant to thrust
    // This is the thrust needed to counteract gravity and control the z position
    // Changes sat_att to sat_thrust to avoid confusion

    applyMotorConstant(thrust);
    float thrust_sat = sat_thrust->Value();
    if(thrust > 0) thrust = 0; // Negative thrust is going up
    if(thrust < -thrust_sat) thrust = -thrust_sat;

    // ---------------------------------------------------------

    // Debug thrust value
    // std::cout << "Thrust comp: " << comp_mg/k_motor->Value() << " ctrl_z: " << ctrl_z << " thrust: " << thrust << "z-error: " << pos_error.z << std::endl;

    // Send controller output
    output->SetValue(0, 0, tau.x);
    output->SetValue(1, 0, tau.y);
    output->SetValue(2, 0, tau.z);
    output->SetValue(3, 0, thrust);
    output->SetDataTime(data->DataTime());

    // Log state (example). 
    // Modify the log_labels matrix in the constructor to add more variables.
    state->GetMutex();
    state->SetValue(0, 0, pos_error.x);
    state->SetValue(1, 0, pos_error.y);
    state->SetValue(2, 0, pos_error.z);
    state->SetValue(3, 0, rpy.YawDistanceFrom(0));
    state->SetValue(4, 0, mass_ref->Value()); // Reference mass
    state->SetValue(5, 0, m_hat); // Estimated mass
    state->SetValue(6, 0, mass_ref->Value() - m_hat); // Error in mass estimation
    state->SetDataTime(data->DataTime());
    state->ReleaseMutex();

    ProcessUpdate(output);
}

void MyController::Reset(void)
{
    first_update = true;
}

void MyController::SetValues(Vector3Df pos_error, Vector3Df vel_error, Quaternion currentQuaternion, Vector3Df omega, float yaw_ref, float xppd, float yppd, float zppd)
{
    // Set the input values for the controller. 
    // This function is called from the main controller to set the input values.
    input->GetMutex();
    input->SetValue(0, 0, pos_error.x);
    input->SetValue(1, 0, pos_error.y);
    input->SetValue(2, 0, pos_error.z);

    input->SetValue(0, 1, vel_error.x);
    input->SetValue(1, 1, vel_error.y);
    input->SetValue(2, 1, vel_error.z);

    input->SetValue(0, 2, currentQuaternion.q0);
    input->SetValue(1, 2, currentQuaternion.q1);
    input->SetValue(2, 2, currentQuaternion.q2);
    input->SetValue(3, 2, currentQuaternion.q3);

    input->SetValue(0, 3, omega.x);
    input->SetValue(1, 3, omega.y);
    input->SetValue(2, 3, omega.z);

    // Set yaw reference
    input->SetValue(0, 4, yaw_ref);

    input->SetValue(0, 5, xppd);
    input->SetValue(1, 5, yppd);
    input->SetValue(2, 5, zppd);

    input->ReleaseMutex();



}

void MyController::applyMotorConstant(Vector3Df &signal)
{
    float motor_constant = k_motor->Value();
    signal.x = signal.x/motor_constant;
    signal.y = signal.y/motor_constant;
    signal.z = signal.z/motor_constant;
}

void MyController::applyMotorConstant(float &signal)
{
    float motor_constant = k_motor->Value();
    signal = signal/motor_constant;
}

void MyController::plotEstimatedMass(const LayoutPosition *position) {

    GroupBox *plots_group = new GroupBox(position, "Estimation monitoring");

    DataPlot1D *massPlot = new DataPlot1D(plots_group->NewRow(), "Estimated Mass", 0, 4);
    massPlot->AddCurve(state->Element(4, 0), DataPlot::Red, "Ref Mass");
    massPlot->AddCurve(state->Element(5, 0), DataPlot::Blue, "Estimated Mass");

    DataPlot1D *errorPlot = new DataPlot1D(plots_group->LastRowLastCol(), "Estimation error", -1, 1);
    errorPlot->AddCurve(state->Element(6, 0), DataPlot::Red, "Error m");
}