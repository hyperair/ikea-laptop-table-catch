include <MCAD/units/metric.scad>
use <MCAD/shapes/polyhole.scad>
use <MCAD/fasteners/nuts_and_bolts.scad>

$fs = 0.4;
$fa = 1;

screwhole_pos = [62.5, -39];
split_for_print = true;

module basic_shape ()
{
    /* imported thing */
    resize ([68.56, 0], auto = true)
    translate ([-402, -765])
    rotate (15.5, Z)
    import ("trace.dxf");

    /* flange for fingers */
    translate ([0, -7.8])
    square ([3, 13]);

    /* live spring */
    translate ([37, -45])
    rotate (15, Z)
    square ([22.73, 1.79]);
}

module place_joining_screwholes ()
{
    positions = [
        [7, -5],
        [28, -5],
        [28, -17]
    ];

    for (pos = positions)
    translate (pos)
    children ();
}

module table_thing ()
{
    render ()
    difference () {
        union () {
            linear_extrude (height = 43.9)
            basic_shape ();

            translate (concat (screwhole_pos, [-3.74]))
            cylinder (d = 5.93, h = 50.85);
        }

        /* center cutout */
        translate ([35.88, -500, (43.9 - 29.86) / 2])
        cube ([1000, 1000, 29.86]);

        /* screwhole cylinder */
        translate (screwhole_pos)
        cylinder (d = 2.9, h = 1000, center = true);

        if (split_for_print)
        place_joining_screwholes () {
            mcad_polyhole (d = 3.3, h = 1000, center = true);

            translate ([0, 0, 40])
            mcad_polyhole (d = 5.5, h = 1000);

            translate ([0, 0, -epsilon])
            mcad_nut_hole (3);
        }
    }
}

module split_for_print (z, bbox = [200, 200], move = [200, 200])
{
    difference () {
        translate ([0, 0, -z])
        children ();

        mirror (Z)
        translate (-bbox / 2)
        cube (concat (bbox, [1000]));
    }

    translate (move)
    difference () {
        rotate (180, X)
        translate ([0, 0, -z])
        children ();

        mirror (Z)
        translate (-bbox / 2)
        cube (concat (bbox, [1000]));
    }
}

if (split_for_print) {
    split_for_print (z = 43.9 / 2, move = [0, 50])
    table_thing ();
} else {
    table_thing ();
}
