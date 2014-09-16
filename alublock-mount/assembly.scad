use <alublock-mount.scad>
use <bowden-trap.scad>
include <options.scad>

use <MCAD/units/metric.scad>

translate ([extruder_spacing/2 - hbtpos_for_side ("right")[0], 0, 0]) {
    alublock_mount ("right");
    translate ([0, 0, overall_height])
    translate (hbtpos_for_side ("right"))
    bowden_trap ();
}

translate ([-(extruder_spacing/2 -
            (overall_width - hbtpos_for_side ("left")[0])),
        0, 0])
translate ([-overall_width, 0, 0]) {
    alublock_mount ("left");

    translate ([0, 0, overall_height])
    translate (hbtpos_for_side ("left"))
    bowden_trap ();
}

%translate ([-overall_width * 2.5 / 2, 0, 0])
cube (concat ([overall_width * 2.5], alublock_dimensions));
