use <MCAD/hardware/bearing.scad>
include <MCAD/motors/stepper.scad>
include <MCAD/units/metric.scad>
include <MCAD/units/us.scad>
include <MCAD/fasteners/nuts_and_bolts.scad>

function mm (x) = length_mm (x);
function inch (x) = length_inch (x);

// bowden settings (copied from alublock-mount)
bowden_trap_screw_spacing = mm (15);
output_gear_elevation = mm (5);

// gear teeth ratio
planet_teeth = 13;
sun_teeth = 11;
annulus_teeth = sun_teeth + planet_teeth * 2;

// bearings
planet_bearing = 623;
output_bearing = 625;

// common gear settings
helix_angle = 40;
circular_pitch = mm (5);
rim_width = mm (20);
pressure_angle = 23;

// planet settings
n_planets = 3;
planet_bore = M3;
planet_thickness = mm (10);
planet_hub_d = 0;
screw_depth = planet_bore * 0.6;
screw_head_d = planet_bore * 2;
nut_protrusion = mm (0.5);      // to push out the bearing

// sun settings
motor_shaft_d = M5;
sun_bore = motor_shaft_d;
sun_thickness = mm (10);
sun_collar_thickness = M8;
sun_hub_thickness = sun_thickness + sun_collar_thickness;
sun_pitch_d = sun_teeth * circular_pitch / PI;
sun_pitch_r = sun_pitch_d / 2;
sun_outer_r = sun_pitch_r + circular_pitch / PI;
sun_outer_d = sun_outer_r * 2;
sun_hub_d = sun_outer_d;

// carrier settings
carrier_wall_thickness = mm (4);
carrier_arm_width = mm (5);
carrier_thickness = mm (4);
carrier_hub_thickness = METRIC_NUT_THICKNESS[motor_shaft_d] +
    carrier_wall_thickness;

// annulus settings
annulus_thickness = mm (10);
annulus_rim_width = mm (8);
screw_size = M3;
motor_extra_standoff = mm (2);

annulus_pitch_d = annulus_teeth * circular_pitch / PI;
annulus_pitch_r = annulus_pitch_d / 2;

annulus_outer_radius = annulus_pitch_r + circular_pitch / PI + mm (0.3);
annulus_screw_orbit_radius = annulus_outer_radius + annulus_rim_width / 2;
annulus_rim_outer_radius = annulus_outer_radius + annulus_rim_width;


gear_ratio = 1 + annulus_teeth / sun_teeth;

// motor settings
stepper_model = Nema17;

// mount
motor_mount_thickness = mm (4);
output_mount_thickness = bearingWidth (output_bearing);
output_rim_width = mm (2);
motor_mount_wall_thickness = mm (2);
motor_mount_arm_width = max (
    lookup (NemaEdgeRoundingRadius, stepper_model),
    METRIC_NUT_AC_WIDTHS[3] + motor_mount_wall_thickness * 2
);

// animation
sun_angle = $t * 360 * gear_ratio;
carrier_angle = sun_angle / gear_ratio;
annulus_angle = 0;

// spacer settings
motor_mount_spacer_length = sun_collar_thickness +
    lookup (NemaRoundExtrusionHeight, stepper_model) +
    motor_extra_standoff - motor_mount_thickness;

output_mount_spacer_length = nut_protrusion + carrier_hub_thickness +
    METRIC_NUT_THICKNESS[motor_shaft_d];

// output gear dimensions
output_gear_od = mm (10);
output_gear_hob_od = mm (6);
filament_size = mm (1.75);

// pov = from the bottom, with gear pointing up
filament_path_offset = [
    output_gear_hob_od + filament_size / 2,
    mm (8.3)                      //elevation
];
bowden_trap_mount_thickness = mm (3);
bowden_trap_wall_thickness = mm (2.5);
bowden_trap_thread_d = mm (9.7);
bowden_trap_width = mm (10);

// misc settings
nut_tolerance = mm (0.1);
screwhole_tolerance = mm (0.3);

// resolution
$fa = 1;
$fs = 0.4;

// error checking
if ((sun_teeth + annulus_teeth) % n_planets != 0)
echo (str ("ERROR: sun_teeth + annulus_teeth = ", sun_teeth + annulus_teeth,
        " which is not divisible by ", n_planets));

echo (str ("Gear ratio = 1:", gear_ratio));
