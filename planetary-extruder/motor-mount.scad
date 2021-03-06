include <MCAD/motors/stepper.scad>
use <MCAD/shapes/polyhole.scad>
use <MCAD/fasteners/nuts_and_bolts.scad>
include <options.scad>
use <gears.scad>

module stepper_face_shape ()
{
    width = motorWidth (model=stepper_model);
    rounding_offset = sqrt ((width * width + width * width) / 4) -
        lookup (NemaEdgeRoundingRadius, stepper_model) / 2;

    difference () {
        square ([width, width], center=true);

        // corner cutouts
        for (angle=[45:90:360+45])
        rotate (angle, Z)
        translate ([rounding_offset, -width / 2])
        square ([width, width]);
    }
}

module place_motor_screws ()
{
    screw_offset = motorScrewSpacing (stepper_model) / 2;

    for (x=[-1, 1])
    for (y=[-1, 1])
    translate ([x * screw_offset, y * screw_offset, -epsilon])
    children ();
}

module motor_screw_holes ()
{
    place_motor_screws ()
    polyhole (d=M3 + screwhole_tolerance, h=-1);
}

module motor_mount ()
{
    difference () {
        linear_extrude (motor_mount_thickness)
        difference () {
            union () {
                stepper_face_shape ();
                cross_arms ();
            }

            // center hole
            polyhole (
                d = lookup (NemaRoundExtrusionDiameter, stepper_model) + mm (0.3),
                h = -1
            );

            motor_screw_holes ();

            place_annulus_screwholes ()
            polyhole (d=M3 + screwhole_tolerance, h=-1);
        }

        translate ([0, 0, -epsilon])
        place_annulus_screwholes ()
        nutHole (size=M3, tolerance=nut_tolerance);
    }
}

module cross_arms ()
{
    for (angle=[45, -45])
    hull ()
    rotate (angle, Z) {
        translate ([annulus_screw_orbit_radius, 0, 0])
        circle (d=motor_mount_arm_width);

        translate ([-annulus_screw_orbit_radius, 0, 0])
        circle (d=motor_mount_arm_width);
    }
}

module output_mount ()
{
    difference () {
        linear_extrude (height=output_mount_thickness)
        difference () {
            union () {
                stepper_face_shape ();

                rotate (45, Z)
                cross_arms ();
            }

            motor_screw_holes ();

            // annulus screw holes
            rotate (45, Z)
            place_annulus_screwholes ()
            polyhole (d=M3 + mm (0.3), h=-1);

            // bearing hole
            polyhole (d=bearingOuterDiameter (output_bearing), h=-1);
        }

        // nut holes for the motor
        place_motor_screws ()
        nutHole (size=M3);
    }
}

motor_mount ();

translate ([annulus_pitch_d * 1.5, 0, 0])
output_mount ();
