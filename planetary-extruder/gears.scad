use <MCAD/gears/involute_gears.scad>
use <MCAD/shapes/polyhole.scad>
include <MCAD/fasteners/nuts_and_bolts.scad>
include <MCAD/units/metric.scad>
include <options.scad>

module planet_gear ()
{
    difference () {
        gear (
            number_of_teeth = planet_teeth,
            circular_pitch = convertcp (circular_pitch),
            pressure_angle = pressure_angle,
            backlash = 0,
            clearance = mm (0.3),

            gear_thickness = planet_thickness,
            rim_thickness = planet_thickness,
            rim_width = rim_width,
            hub_thickness = planet_thickness,
            hub_diameter = planet_hub_d,
            bore_diameter = 0,
            herringbone = true,
            helix_angle = helix_angle
        );

        // bore
        translate ([0, 0, -epsilon])
        polyhole (d = planet_bore, h = planet_thickness + epsilon * 2);

        // screwhead
        translate ([0, 0, planet_thickness - screw_depth])
        polyhole (d = screw_head_d, h = planet_thickness);

        // nuthole
        translate ([0, 0, -nut_protrusion])
        nutHole (planet_bore);
    }
}

module sun_gear ()
{
    difference () {
        gear (
            number_of_teeth = sun_teeth,
            circular_pitch = convertcp (circular_pitch),
            pressure_angle = pressure_angle,
            backlash = 0,
            clearance = mm (0.3),

            gear_thickness = sun_thickness,
            rim_thickness = sun_thickness,
            rim_width = rim_width,
            hub_thickness = sun_hub_thickness,
            hub_diameter = sun_hub_d,
            bore_diameter = 0,
            circles = 7,
            herringbone = true,
            helix_angle = -helix_angle
        );

        translate ([0, 0, -epsilon])
        polyhole (d = sun_bore, h = sun_hub_thickness + epsilon * 2);

        translate ([sun_bore/2, 0, sun_thickness + sun_collar_thickness/2])
        rotate (90, Y)
        union () {
            hull ()
            {
                nutHole (M3);

                translate ([-100, 0, 0])
                nutHole (M3);
            }

            // screwhole
            translate ([0, 0, -sun_bore/2])
            polyhole (d=M3, h=sun_hub_d);
        }
    }
}

module place_planet (i)
{
    planet_displacement = gear_spacing (circular_pitch, sun_teeth,
        planet_teeth);
    half_tooth_angle = 360 / planet_teeth / 2;
    gear_ratio = sun_teeth / planet_teeth;
    angle = $t * 360 + i / n_planets * 360;

    rotate (angle, Z)
    translate ([planet_displacement, 0, 0])
    rotate (180 + half_tooth_angle + angle * gear_ratio, Z)
    children ();
}

module place_planets ()
{
    for (i = [0:n_planets-1])
    place_planet (i)
    children ();
}

sun_gear ();

place_planets ()
planet_gear ();
