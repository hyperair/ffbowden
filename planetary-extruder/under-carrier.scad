use <gears.scad>
use <MCAD/hardware/bearing.scad>
use <MCAD/shapes/polyhole.scad>
include <options.scad>

module under_carrier ()
{
    difference () {
        hull ()
        place_planets ()
        cylinder (
            d = bearingOuterDiameter (planet_bearing) + carrier_wall_thickness * 2,
            h = carrier_thickness
        );

        place_planets ()
        translate ([0, 0, -epsilon])
        polyhole (
            d = bearingOuterDiameter (planet_bearing),
            h = carrier_thickness + epsilon * 2
        );

        translate ([0, 0, -epsilon])
        polyhole (
            d = sun_hub_d + mm (3),
            h = carrier_thickness + epsilon * 2
        );
    }
}

under_carrier ();
