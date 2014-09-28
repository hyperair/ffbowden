use <gears.scad>
use <carrier.scad>
use <under-carrier.scad>
use <MCAD/hardware/bearing.scad>
use <MCAD/fasteners/metric_fastners.scad>
include <MCAD/motors/stepper.scad>
include <MCAD/fasteners/nuts_and_bolts.scad>

include <options.scad>

sun_gear ();

place_planets () {
    planet_gear ();

    %translate ([0, 0, planet_thickness])
    mirror (Z)
    bolt (dia=planet_bore, len=mm (15));

    %translate ([0, 0, -nut_protrusion])
    flat_nut (dia=planet_bore);
}

annulus_gear ();

translate ([0, 0, -(nut_protrusion + carrier_thickness)]) {
    carrier ();

    %rotate (carrier_angle, Z) {
        translate ([0, 0, carrier_thickness])
        mirror (Z)
        bolt (dia=motor_shaft_d, len=mm (30));

        translate ([0, 0, -carrier_hub_thickness])
        flat_nut (dia=motor_shaft_d);
    }
}

translate ([0, 0, sun_thickness + nut_protrusion]) {
    under_carrier ();

    place_planets ()
    bearing (model=planet_bearing);
}

translate ([0, 0, sun_hub_thickness + motor_extra_standoff])
motor (model=Nema17);
