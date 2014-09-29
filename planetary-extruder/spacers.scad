include <MCAD/units/metric.scad>
include <options.scad>
use <MCAD/gears/involute_gears.scad>
use <MCAD/shapes/polyhole.scad>
include <MCAD/gears/stepper.scad>

module spacer (id, od=-1, h=-1)
{
    od = (od < id) ? max (id + mm (2), id * 2) : od;

    linear_extrude (height=h, flat=(h < 0))
    difference () {
        circle (d=od, $fn=4);
        polyhole (d=id, h=-1);
    }
}

module motor_mount_spacer ()
{
    standoff = sun_collar_thickness +
        lookup (NemaRoundExtrusionHeight, stepper_model) +
        motor_extra_standoff - motor_mount_thickness;

    spacer (id=M3 + mm (0.3), od=M3 * 2.5, h=standoff);
}

module output_mount_spacer ()
{
}

motor_mount_spacer ();
