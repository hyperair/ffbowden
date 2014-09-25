include <MCAD/units/metric.scad>

function mm (x) = length_mm (x);

planet_teeth = 8;
sun_teeth = 13;
ring_teeth = sun_teeth + planet_teeth * 2;

helix_angle = 40;
circular_pitch = mm (5);
planet_thickness = mm (10);
planet_hub_d = 0;
rim_width = mm (20);
pressure_angle = 23;

planet_bore = M3;
screw_depth = planet_bore * 0.6;
screw_head_d = planet_bore * 2;
nut_protrusion = mm (0.5);      // to push out the bearing

motor_shaft_d = M5;
sun_bore = motor_shaft_d;
sun_thickness = mm (10);
sun_collar_thickness = M8;
sun_hub_thickness = sun_thickness + sun_collar_thickness;
sun_hub_d = sun_teeth * circular_pitch / PI;

n_planets = 3;
// carrier settings
carrier_wall_thickness = mm (2);
carrier_arm_width = mm (5);
carrier_thickness = mm (4);

// error checking
if ((sun_teeth + ring_teeth) % n_planets != 0)
echo (str ("ERROR: sun_teeth + ring_teeth = ", sun_teeth + ring_teeth,
        " which is not divisible by ", n_planets));

echo (str ("Gear ratio = 1:", (sun_teeth + ring_teeth) / sun_teeth));
