include <options.scad>
use <MCAD/shapes/polyhole.scad>
use <MCAD/motors/stepper.scad>
use <MCAD/fasteners/nuts_and_bolts.scad>


module motorscrewholes ()
{
    screwhole_dist = motorScrewSpacing (stepper_model);
    half_screwhole_dist = screwhole_dist / 2;

    nuthole_z_elevation = alublock_dimensions[0] +
    backplate_thickness_under_nut;

    for (x=[-half_screwhole_dist, half_screwhole_dist])
    translate ([x, 0, -epsilon]) {
        polyhole (d=screw_size + 0.3 * length_mm, h=100 * length_mm);

        translate ([0, 0, nuthole_z_elevation])
        scale ([1, 1, 100])
        nutHole (size=screw_size, clearance=0.3 * length_mm);
    }
}

motorscrewholes ();
