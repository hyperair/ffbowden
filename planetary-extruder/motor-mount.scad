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

module motor_screw_holes ()
{
    screw_offset = motorScrewSpacing (stepper_model) / 2;

    for (x=[-1, 1])
    for (y=[-1, 1])
    translate ([x * screw_offset, y * screw_offset, -epsilon])
    polyhole (d=M3, h=-1);
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
            polyhole (d=M3 + mm (0.3), h=-1);
        }

        translate ([0, 0, -epsilon])
        place_annulus_screwholes ()
        nutHole (size=M3);
    }
}

module cross_arms ()
{
    for (angle=[45, -45])
    hull ()
    rotate (angle, Z) {
        translate ([annulus_screw_orbit_radius, 0, 0])
        circle (d=lookup (NemaEdgeRoundingRadius, stepper_model));

        translate ([-annulus_screw_orbit_radius, 0, 0])
        circle (d=lookup (NemaEdgeRoundingRadius, stepper_model));
    }
}

motor_mount ();
