#ifndef MYCTRL_H
#define MYCTRL_H

#include <Object.h>
#include <ControlLaw.h>
#include <Vector3D.h>
#include <Quaternion.h>
#include <DataPlot1D.h>
#include <PushButton.h>



namespace flair {
    namespace core {
        class Matrix;
        class io_data;
    }
    namespace gui {
        class LayoutPosition;
        class DoubleSpinBox;
        class CheckBox;
        class Label;
        class Vector3DSpinBox;
    }
    namespace filter {
        // If you prefer to use a custom controller class, you can define it here.
        // ...
    }
}

namespace flair {
    namespace filter {
        class MyController : public ControlLaw
        {
            public :
                MyController(const flair::gui::LayoutPosition *position, const std::string &name);
                ~MyController();
                void UpdateFrom(const flair::core::io_data *data);
                void Reset(void);
                void SetValues(flair::core::Vector3Df pos_error, flair::core::Vector3Df vel_error, flair::core::Quaternion currentQuaternion, flair::core::Vector3Df omega, float yaw_ref, float xppd, float yppd, float zppd);
                void applyMotorConstant(flair::core::Vector3Df &signal);
                void applyMotorConstant(float &signal);
                void plotEstimatedMass(const flair::gui::LayoutPosition *position);

            private : 
                float delta_t, initial_time;
                float g = 9.81;
                float m_hat;
                bool first_update;

                flair::core::Matrix *state;
                flair::gui::Vector3DSpinBox *Kp_pos, *Kd_pos, *Ki_pos, *Kp_att, *Kd_att, *Ki_att;
                flair::gui::DoubleSpinBox *deltaT_custom, *mass, *k_motor, *sat_pos, *sat_att, *sat_thrust,*km, *m_init, *mass_ref, *sigma_mod;
                flair::gui::DataPlot1D *massPlot, *errorPlot;
                flair::gui::PushButton *resetMassButton;
        };
    }    
}

#endif // MYCTRL_H