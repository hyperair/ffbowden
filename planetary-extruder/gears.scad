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
            helix_angle = helix_angle,
            roundsize = 0
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
    rotate (sun_angle, Z)
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
            helix_angle = -helix_angle,
            roundsize = 0
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
    planet_gear_ratio = sun_teeth / planet_teeth;
    planet0_angle = 180 + half_tooth_angle; //planet orientation at 0°
    orbit_angle = carrier_angle + i / n_planets * 360;
    distance = sun_teeth * (orbit_angle - sun_angle) / 360;
    add_planet_angle = distance / planet_teeth * 360;
    planet_angle = planet0_angle + add_planet_angle;

    rotate (orbit_angle, Z)
    translate ([planet_displacement, 0, 0])
    rotate (planet_angle, Z)
    children ();
}

module place_planets ()
{
    for (i = [0:n_planets-1])
    place_planet (i)
    children ();
}

module annulus_gear ()
{
    difference () {
        gear (
            number_of_teeth = annulus_teeth,
            circular_pitch = convertcp (circular_pitch),
            pressure_angle = pressure_angle,
            backlash = 0,
            clearance = mm (0.3),

            gear_thickness = 0,
            rim_thickness = annulus_thickness,
            rim_width = annulus_rim_width,
            hub_diameter = 0,
            herringbone = true,
            helix_angle = helix_angle,
            internal = true,
            roundsize = 0
        );

        place_annulus_screwholes ()
        translate ([0, 0, -epsilon])
        polyhole (d=screw_size, h=annulus_thickness + epsilon * 2);

        place_annulus_screwholes (motor_mount=false)
        translate ([0, 0, annulus_thickness + epsilon])
        mirror (Z)
        nutHole (size=screw_size);
    }
}

module place_annulus_screwholes (motor_mount=true, non_motor_mount=true)
{
    annulus_pitch_d = annulus_teeth * circular_pitch / PI;
    annulus_pitch_r = annulus_pitch_d / 2;

    outer_radius = annulus_pitch_r + circular_pitch / PI + mm (0.3);
    screw_orbit_radius = outer_radius + annulus_rim_width / 2;

    // for motor mount
    if (motor_mount)
    for (angle=[45:90:360+45])
    rotate (angle, Z)
    translate ([screw_orbit_radius, 0, 0])
    children ();

    // for non-motor mount
    if (non_motor_mount)
    for (angle=[0:90:360])
    rotate (angle, Z)
    translate ([screw_orbit_radius, 0, 0])
    children ();
}

sun_gear ();

place_planets ()
planet_gear ();

annulus_gear ();
