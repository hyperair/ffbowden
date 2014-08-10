include <MCAD/units/metric.scad>
include <MCAD/motors/stepper.scad>

bowden_tube_diameter = M4;

stepper_model = Nema17;
stepper_size = NemaLengthMedium;
screw_size = M3;

// [x,y] from side view
alublock_dimensions = [15 * length_mm, 15 * length_mm];

backplate_thickness = 5 * length_mm;
topplate_thickness = 5 * length_mm;
strut_thickness = 11 * length_mm;
strut_fanfacing_min_thickness = 2 * length_mm;

heatbreaktube_dia = M6;

// offset from middle
heatbreaktube_offset = [0, 0];
