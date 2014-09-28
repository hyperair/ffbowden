use <gears.scad>
use <split.scad>

include <MCAD/units/metric.scad>
include <options.scad>

total_annulus_d = annulus_teeth * circular_pitch / PI * 1.2 +
    annulus_rim_width + mm (10);

split_flip (
    normal = Z,
    translation = [total_annulus_d, 0, 0]
)
translate ([0, 0, -annulus_thickness / 2])
annulus_gear ();
