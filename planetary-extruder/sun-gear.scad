use <gears.scad>
include <options.scad>

if (sun_outer_d > sun_hub_d)
sun_gear ();

else
translate ([0, 0, sun_hub_thickness])
rotate (180, X)
sun_gear ();
