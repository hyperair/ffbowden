include <options.scad>
use <basic-shape.scad>

translate ([0, alublock_dimensions[1], 0])
backplate ();

translate ([0, 0, alublock_dimensions[0]])
topplate ();

for (strut_side=[1, -1])
translate ([strut_side * motorScrewSpacing (stepper_model) / 2, 0,
        alublock_dimensions[0] + topplate_thickness])
fan_strut ();
