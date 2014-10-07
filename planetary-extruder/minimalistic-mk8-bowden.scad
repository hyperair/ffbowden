use <motor-mount.scad>
use <MCAD/shapes/polyhole.scad>
include <options.scad>

module mk8_bowden_trap_mount (side="right") {
    bowden_trap_barrel_od = (bowden_trap_thread_d +
        bowden_trap_wall_thickness * 2);
    overall_thickness = max (bowden_trap_barrel_od + filament_path_offset[1],
        bowden_trap_mount_thickness);

    intersection () {
        difference () {
            union () {
                linear_extrude (height=bowden_trap_mount_thickness)
                square ([motorWidth (stepper_model),
                        motorWidth (stepper_model)],
                    center=true);

                place_filament_path (side)
                cylinder (
                    d = bowden_trap_thread_d + bowden_trap_wall_thickness * 2,
                    h = motorWidth (stepper_model),
                    center = true
                );
            }

            place_motor_screws ()
            polyhole (d=M3, h=overall_thickness + epsilon * 2);

            translate ([0, 0, mm (2)])
            place_motor_screws ()
            polyhole (d=M3 * 2, overall_thickness + epsilon * 2);

            translate ([0, 0, -epsilon])
            cylinder (
                d = lookup (NemaRoundExtrusionDiameter, stepper_model),
                h = overall_thickness + epsilon * 2
            );

            place_filament_path (side)
            polyhole (d=bowden_trap_thread_d, h=motorWidth (stepper_model));
        }

        linear_extrude (height=overall_thickness)
        stepper_face_shape ();

        translate ([0, -motorWidth (stepper_model)/2 + bowden_trap_width, 0])
        translate (-motorWidth (stepper_model) * [0.5, 1, 0])
        cube ([motorWidth (stepper_model), motorWidth (stepper_model),
            overall_thickness]);
    }
}

module place_filament_path (side="right")
{
    x_mul = (side == "left") ? 1 : -1;

    translate ([x_mul * filament_path_offset[0], 0, filament_path_offset[1]])
    rotate (90, X)
    children ();
}

mk8_bowden_trap_mount ("left");

translate ([0, motorWidth (stepper_model) / 2, 0])
mk8_bowden_trap_mount ("right");
