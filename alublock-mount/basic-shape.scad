include <options.scad>
include <MCAD/units/metric.scad>
include <MCAD/motors/stepper.scad>
use <MCAD/shapes/polyhole.scad>
use <MCAD/shapes/triangles.scad>
use <MCAD/fasteners/nuts_and_bolts.scad>
use <screwholes.scad>

module basic_alublock_mount ()
{
    width = overall_width;

    difference () {
        // basic shapen
        cube ([width, overall_depth, topplate_surface_z]);

        translate ([-epsilon, -epsilon, -epsilon])
        cube ([width + epsilon * 2,
                alublock_dimensions[0] + epsilon,
                alublock_dimensions[1] + epsilon]);
    }

    translate ([0, 0, topplate_surface_z]) {
        fan_strut ();

        translate ([width - strut_thickness, 0, 0])
        fan_strut ();
    }
}

module alublock_mount ()
{
    difference () {
        basic_alublock_mount ();

        // screw holes
        translate ([overall_width / 2, 0, screw_base_offset])
        mirror (Y)
        rotate (90, X)
        motorscrewholes ();

        // cooling tube hole
        translate (concat (heatbreaktube_offset, [0]))
        translate ([overall_width / 2, alublock_dimensions[0] / 2, 0])
        polyhole (d=heatbreaktube_dia, h=100 * length_mm);
    }
}

module fan_strut ()
{
    height = strut_height;
    base_length = overall_depth;

    rotate (90, Z)
    rotate (90, X) {
        translate ([strut_fanfacing_min_thickness, 0, 0])
        triangle (
            o_len = height,
            a_len = base_length - strut_fanfacing_min_thickness,
            depth = strut_thickness
        );

        cube ([strut_fanfacing_min_thickness, height, strut_thickness]);
    }
}

alublock_mount ();
