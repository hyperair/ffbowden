use <alublock-mount.scad>
use <bowden-trap.scad>
include <options.scad>

alublock_mount ();
translate ([0, 0, overall_height])
translate (heatbreaktube_position)
bowden_trap ();
