include <options.scad>
use <MCAD/shapes/polyhole.scad>

$fs = 0.2;

module bowden_trap ()
{
    difference () {
        basic_shape ();

        bowden_tube ();
        bowden_tube_escapement ();
        screwholes ();
    }

    module basic_shape ()
    {
        chamfer_size = bowden_trap_thickness / 2;
        screwmount_wall_thickness = 2 * length_mm;

        screw_mount ();
        barrel ();

        translate ([0, 0, bowden_trap_screwmount_height])
        barrel_fillet ();

        module screw_mount ()
        hull ()
        for (i=[1, -1])
        translate ([i * bowden_trap_screw_spacing / 2, 0, 0])
        cylinder (
            d = screw_size + screwmount_wall_thickness * 2,
            h = 2 * length_mm
        );

        module barrel ()
        {
            cylinder (
                d = bowden_trap_od,
                h = bowden_trap_height - chamfer_size
            );
            translate ([0, 0, bowden_trap_height - chamfer_size])
            cylinder (
                d1 = bowden_trap_od,
                d2 = bowden_trap_od - chamfer_size * 2,
                h = chamfer_size
            );
        }

        module barrel_fillet ()
        {
            fillet_size = bowden_trap_od / 10;

            intersection () {
                cylinder (
                    d1 = bowden_trap_od + fillet_size * 2,
                    d2 = bowden_trap_od,
                    h = fillet_size
                );

                scale ([1, 1, 100])
                screw_mount ();
            }
        }
    }

    module bowden_tube ()
    translate ([0, 0, -epsilon])
    polyhole (d=bowden_tube_diameter, h=bowden_trap_height + epsilon * 2);

    module bowden_tube_escapement ()
    translate ([-bowden_trap_escapement_width / 2, 0, -epsilon])
    cube ([bowden_trap_escapement_width, bowden_trap_od,
            bowden_trap_height + epsilon * 2]);

    module screwholes ()
    for (i=[1, -1])
    translate ([i * bowden_trap_screw_spacing / 2, 0, -epsilon])
    polyhole (d=screw_size, h=bowden_trap_height + epsilon * 2);
}

bowden_trap ();
