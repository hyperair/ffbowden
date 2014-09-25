use <MCAD/gears/involute_gears.scad>
use <MCAD/hardware/bearing.scad>
use <MCAD/shapes/polyhole.scad>
include <MCAD/fasteners/nuts_and_bolts.scad>
include <MCAD/units/metric.scad>

use <gears.scad>
include <options.scad>


module carrier ()
{
    planet_displacement = gear_spacing (
        circular_pitch, sun_teeth, planet_teeth);

    planet_holder_od = (bearingOuterDiameter (planet_bearing) +
        carrier_wall_thickness);

    hub_d = METRIC_NUT_AC_WIDTHS[motor_shaft_d] + carrier_wall_thickness * 2;
    hub_t = METRIC_NUT_THICKNESS[motor_shaft_d] + carrier_wall_thickness;

    module basic_shape () {
        offset (delta=-2, join_type="round")
        offset (delta=+2, join_type="round")
        for (i=[0:2])
        hull () {
            circle (d=hub_d);

            place_planet (i)
            circle (d=planet_holder_od);
        }
    }

    module hub () {
        translate ([0, 0, carrier_thickness - hub_t])
        cylinder (d=hub_d, h=hub_t);
    }

    difference () {
        union () {
            linear_extrude (height=carrier_thickness)
            basic_shape ();
            hub ();
        }

        // nuthole
        translate ([0, 0, carrier_thickness - METRIC_NUT_THICKNESS[motor_shaft_d]])
        scale ([1, 1, 100])
        nutHole (motor_shaft_d);

        // bore
        translate ([0, 0, carrier_thickness - hub_t - epsilon])
        polyhole (d=motor_shaft_d, h=hub_t + epsilon * 2);

        // planet bearings
        place_planets () {
            translate ([0, 0, -epsilon])
            polyhole (d = bearingOuterDiameter (planet_bearing),
                h = hub_t + epsilon * 2);

            %bearing (model=planet_bearing);
        }
    }
}

translate ([0, 0, carrier_thickness])
mirror (Z)
carrier ();
