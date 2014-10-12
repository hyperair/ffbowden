include <options.scad>
include <MCAD/units/metric.scad>
include <MCAD/motors/stepper.scad>
use <MCAD/shapes/polyhole.scad>
use <MCAD/shapes/triangles.scad>
use <MCAD/fasteners/nuts_and_bolts.scad>
use <screwholes.scad>
use <bowden-trap.scad>

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

function hbtpos_for_side (side = "left") = (
    side == "left" ?
    heatbreaktube_position :
    side == "right" ?
    [
        overall_width - heatbreaktube_position[0],
        heatbreaktube_position[1],
        heatbreaktube_position[2]
    ] :
    "ERROR"
);

module alublock_mount (side="left")
{
    hbtpos = hbtpos_for_side (side);

    difference () {
        union () {
            basic_alublock_mount_shape ();
            translate (hbtpos + [0, 0, alublock_dimensions[1]])
            cylinder (d=pneumatic_wall_thickness * 2 + pneumatic_thread_dia,
                h=pneumatic_thread_depth);

            if (side == "right")
            sideplate ();
        }

        // screw holes
        translate ([overall_width / 2, 0, screw_base_offset])
        mirror (Y)
        rotate (90, X)
        motor_screwholes ();

        // cooling tube hole
        translate (hbtpos)
        polyhole (d=pneumatic_thread_dia, h=100 * length_mm);

        // chop off extras that will hit the fan
        translate ([0, -overall_depth, 0])
        cube ([overall_width, overall_depth,
                overall_height + pneumatic_thread_depth]);
    }

    module sideplate ()
    {
        // endstop pusher
        translate ([
                overall_width,
                alublock_dimensions[0],
                motorWidth (model=stepper_model) - sideplate_z_offset_from_top
            ])
        mirror (X)
        cube ([
                sideplate_thickness,
                sideplate_length,
                sideplate_height
            ]);

        // strut
        translate ([
                overall_width,
                alublock_dimensions[0],
                0,
            ])
        mirror (X)
        hull () {
            translate ([
                    0, 0,
                    motorWidth (model=stepper_model) -
                    sideplate_z_offset_from_top
                ])
            cube ([
                    sideplate_thickness,
                    backplate_thickness,
                    sideplate_height
                ]);

            translate ([0, 0, overall_height])
            cube ([
                    sideplate_thickness * 2,
                    backplate_thickness,
                    epsilon
                ]);
        }
    }
}

// left mount
rotate (90, X)
alublock_mount ("left");

// right mount
translate ([0, 2 * length_mm, overall_width])
rotate (90, Y)
alublock_mount ("right");
