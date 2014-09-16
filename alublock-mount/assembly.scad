use <alublock-mount.scad>
use <bowden-trap.scad>
include <options.scad>

alublock_mount ("right");
translate ([0, 0, overall_height])
translate (hbtpos_for_side ("right"))
bowden_trap ();
