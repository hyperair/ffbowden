include <options.scad>
include <MCAD/units/metric.scad>
include <MCAD/motors/stepper.scad>
use <MCAD/shapes/polyhole.scad>
use <MCAD/shapes/triangles.scad>
use <MCAD/fasteners/nuts_and_bolts.scad>

module poly_bolt_hole (size, length, tolerance=+0.0001, proj=-1)
{
    polyhole (d=size, h=length + tolerance);
    nutHole (size=size, tolerance=tolerance);
}

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

            translate ([0, 0, backplate_thickness + epsilon])
            mirror (Z)
            poly_bolt_hole (size=screw_size,
                length=backplate_thickness + epsilon * 2);
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

        translate ([0, depth/2, -epsilon] + concat (heatbreaktube_offset, [0]))
        polyhole (d=heatbreaktube_dia, h=topplate_thickness + epsilon*2);
    }
}

module fan_strut ()
{
    height = lookup (NemaSideSize, stepper_model) - alublock_dimensions[1] -
    topplate_thickness;

    base_length = alublock_dimensions[0] + backplate_thickness;

    difference () {
        rotate (-90, Z)
        mirror (X)
        rotate (90, X)
        translate ([0, 0, -strut_thickness/2])
        union () {
            translate ([strut_fanfacing_min_thickness, 0, 0])
            triangle (
                o_len = height,
                a_len = base_length - strut_fanfacing_min_thickness,
                depth = strut_thickness
            );

            cube ([strut_fanfacing_min_thickness, height, strut_thickness]);
        }

        translate (
            [
                0,
                strut_fanfacing_min_thickness + 3 * length_mm,
                motorScrewSpacing (stepper_model) - topplate_thickness -
                alublock_dimensions[1] / 2
            ]
        )
        rotate (90, X)
        rotate (90, Z)
        poly_bolt_hole (
            size = screw_size,
            length = base_length
        );
    }
}

fan_strut ();
