include <MCAD/units/metric.scad>
include <MCAD/motors/stepper.scad>

bowden_tube_diameter = M4;
bowden_trap_height = 13 * length_mm;

stepper_model = Nema17;
stepper_size = NemaLengthMedium;
screw_size = M3;

// [x,y] from side view
alublock_dimensions = [15 * length_mm, 12.5 * length_mm];

// distance between alublock base to centre point of screwholes
screw_base_offset = 8;

backplate_thickness = 5 * length_mm;
topplate_thickness = 5 * length_mm;
strut_thickness = 10 * length_mm;
strut_fanfacing_min_thickness = 2 * length_mm;

heatbreaktube_dia = M6;

// offset from middle
heatbreaktube_offset = [6.98, -alublock_dimensions[0] / 2 + 5];

// globally calculated variables -- don't modify
overall_width = motorScrewSpacing (stepper_model) + 3 * screw_size;
overall_depth = alublock_dimensions[0] + backplate_thickness;
overall_height = overall_width;
topplate_surface_z = topplate_thickness + alublock_dimensions[1];
mount_bottom = max (screw_base_offset - 1.5 * screw_size, 0);
strut_height = overall_height + mount_bottom - topplate_surface_z;

heatbreaktube_position = (
    [overall_width / 2, alublock_dimensions[0] / 2, 0] +
    concat (heatbreaktube_offset, [0])
);
