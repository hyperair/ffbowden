include <options.scad>
include <MCAD/units/metric.scad>
include <MCAD/motors/stepper.scad>
use <MCAD/shapes/polyhole.scad>
use <MCAD/fasteners/nuts_and_bolts.scad>

module backplate ()
{
    width = lookup (NemaSideSize, stepper_model);
    height = alublock_dimensions[1] + topplate_thickness;

    difference () {
        translate ([-width/2, 0, 0])
        cube ([width, backplate_thickness, height]);

        rotate (90, X)
        mirror (Z)
        for (i=[1, -1]) {
            translate (
                [
                    i * motorScrewSpacing(stepper_model)/2,
                    (
                        motorWidth (stepper_model) -
                        motorScrewSpacing (stepper_model)
                    ) / 2,
                    -epsilon
                ]
            )
            union () {
                polyhole (d=screw_size, h=backplate_thickness + epsilon * 2);

                translate ([0, 0, backplate_thickness + epsilon * 2])
                mirror (Z)
                nutHole (size=screw_size, tolerance=0);
            }
        }
    }
}

module topplate ()
{
    width = lookup (NemaSideSize, stepper_model);
    depth = alublock_dimensions[0];

    difference () {
        translate ([-width/2, 0, 0])
        cube ([width, depth, topplate_thickness]);
    }
}
