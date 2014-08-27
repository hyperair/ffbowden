include <options.scad>
include <MCAD/units/metric.scad>
include <MCAD/motors/stepper.scad>
use <MCAD/shapes/polyhole.scad>
use <MCAD/shapes/triangles.scad>
use <MCAD/fasteners/nuts_and_bolts.scad>
use <screwholes.scad>

module basic_alublock_mount_shape ()
{
    width = overall_width;

    difference () {
        // basic shape
        translate ([0, 0, mount_bottom])
        cube ([width, overall_depth, overall_height - mount_bottom]);

        translate ([-epsilon, -epsilon, -epsilon])
        cube ([width + epsilon * 2,
                alublock_dimensions[0] + epsilon,
                alublock_dimensions[1] + epsilon]);
    }
}

module alublock_mount ()
{
    difference () {
        basic_alublock_mount_shape ();

        // screw holes
        translate ([overall_width / 2, 0, screw_base_offset])
        mirror (Y)
        rotate (90, X)
        motor_screwholes ();

        // cooling tube hole
        translate (heatbreaktube_position)
        polyhole (d=heatbreaktube_dia, h=100 * length_mm);

        // bowden trap screwholes
        translate (heatbreaktube_position)
        bowden_trap_screwholes ();
    }
}

translate ([0, 0, overall_height])
rotate (180, X)
alublock_mount ();
