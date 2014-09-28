include <MCAD/motors/stepper.scad>
include <options.scad>

module stepper_face_shape ()
{
    width = motorWidth (model=stepper_model);
    rounding_offset = sqrt ((width * width + width * width) / 4) -
        lookup (NemaEdgeRoundingRadius, stepper_model) / 2;

    difference () {
        square ([width, width], center=true);

        #for (angle=[45:90:360+45])
        rotate (angle, Z)
        translate ([rounding_offset, -width / 2])
        square ([width, width]);
    }
}

module motor_mount ()
{
    stepper_face_shape ();
}

stepper_face_shape ();

motor (stepper_model);
