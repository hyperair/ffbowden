include <options.scad>
use <MCAD/shapes/polyhole.scad>
use <MCAD/motors/stepper.scad>


module motorscrewholes ()
{
    screwhole_dist = motorScrewSpacing (stepper_model);
    half_screwhole_dist = screwhole_dist / 2;

    for (x=[-half_screwhole_dist, half_screwhole_dist])
    for (y=[0, screwhole_dist])
    translate ([x, y, -epsilon])
    polyhole (d=screw_size, h=100 * length_mm);
}

motorscrewholes ();
