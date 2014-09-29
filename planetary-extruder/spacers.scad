include <MCAD/units/metric.scad>
include <options.scad>
use <MCAD/gears/involute_gears.scad>
use <MCAD/shapes/polyhole.scad>
include <MCAD/gears/stepper.scad>

module spacer (id, width=-1, h=-1)
{
    width = (width < id) ? max (id + mm (2) , id * 2) : width;

    linear_extrude (height=h, flat=(h < 0))
    difference () {
        square ([width, width], center=true);
        polyhole (d=id, h=-1);
    }
}

spacer_width = sqrt ((M3 * 2.5 * M3 * 2.5) / 2);

module motor_mount_spacer ()
{
    spacer (id=M3 + mm (0.3), width=spacer_width, h=motor_mount_spacer_length);
}

module output_mount_spacer ()
{
    spacer (id=M3 + mm (0.3), width=spacer_width, h=output_mount_spacer_length);
}

for (i=[0:3])
translate ([(spacer_width + mm (1)) * i, 0, spacer_width / 2]) {
    rotate (90, X)
    motor_mount_spacer ();

    translate ([0, output_mount_spacer_length + mm (1), 0])
    rotate (90, X)
    output_mount_spacer ();
}
