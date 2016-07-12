include <MCAD/units/metric.scad>

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
}

module table_thing ()
{
    difference () {
        union () {
            linear_extrude (height = 43.9)
            basic_shape ();

            translate (concat (screwhole_pos, [-3.74]))
            cylinder (d = 5.93, h = 50.85);
        }

        translate ([35.88, -500, (43.9 - 29.86) / 2])
        cube ([1000, 1000, 29.86]);

        translate (screwhole_pos)
        cylinder (d = 2.9, h = 1000, center = true);
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
        translate ([0, 0, -z])
        children ();

        rotate (180, X)
        translate (-bbox / 2)
        cube (concat (bbox, [1000]));
    }
}

if (split_for_print) {
    split_for_print (z = 50.85 / 2, move = [0, 100])
    table_thing ();
} else {
    table_thing ();
}
