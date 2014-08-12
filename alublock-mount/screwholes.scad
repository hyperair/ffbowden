include <options.scad>
use <MCAD/shapes/polyhole.scad>
use <MCAD/motors/stepper.scad>
use <MCAD/fasteners/nuts_and_bolts.scad>


module motorscrewholes ()
{
    screwhole_dist = motorScrewSpacing (stepper_model);
    half_screwhole_dist = screwhole_dist / 2;

    nuthole_z_elevation = [
        [0, alublock_dimensions[0] + backplate_thickness / 2],
        [screwhole_dist, strut_fanfacing_min_thickness]
    ];

    for (x=[-half_screwhole_dist, half_screwhole_dist])
    for (y=[0, screwhole_dist])
    translate ([x, y, -epsilon]) {
        polyhole (d=screw_size + 0.3 * length_mm, h=100 * length_mm);

        translate ([0, 0, lookup (y, nuthole_z_elevation)])
        scale ([1, 1, 100])
        nutHole (size=screw_size, clearance=0.3 * length_mm);
    }
}

motorscrewholes ();
