include <MCAD/units/metric.scad>
include <MCAD/motors/stepper.scad>

bowden_tube_diameter = 4 * length_mm;
stepper_model = Nema17;
stepper_size = NemaLengthMedium;
screw_size = M3;

// [x,y] from side view
alublock_dimensions = [15 * length_mm, 15 * length_mm];

backplate_thickness = 5 * length_mm;
topplate_thickness = 5 * length_mm;
strut_thickness = 10 * length_mm;

heatbreaktube_dia = M6;
