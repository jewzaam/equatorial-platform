/*

Model of the bearing centered at (0,0,0), oriented along the x/y plane.


https://spinnermint.com/img/guides/bearing-exploded-view-265.jpg

Parts:
- inner race
- outer race
- shield

Quatlifiers:
- od: outer diameter
- id: inner diameter
- h: height

All units are in millimeters.

*/

/* [Debug] */

// If true will render the bearing.  Default to false for easy import to other models.
display=false;


/* [Hidden] */

module bearing_part(od,id,h) {
    translate([0,0,-h/2])
    difference()
    {
        cylinder(d=od,h=h);
        
        translate([0,0,-h/2])
        cylinder(d=id,h=h*2);
    }
}

module bearing(i_od,i_id,i_h,o_od,o_id,o_h,s_h) {
    union()
    {
        // outer race
        color("Silver")
        bearing_part(od=o_od,id=o_id,h=o_h);

        // inner race
        color("Silver")
        bearing_part(od=i_od,id=i_id,h=i_h);

        // shield
        color("SlateGray")
        bearing_part(od=o_id,id=i_od,h=s_h);
    }
}

// for debugging
if (display) {
    $fn=200;

    race_inner_od=21;
    race_inner_id=14.9;
    race_inner_h=11;

    race_outer_od=35;
    race_outer_id=30.8;
    race_outer_h=11;

    shield_h=10.4;

    bearing(
        i_od=race_inner_od,
        i_id=race_inner_id,
        i_h=race_inner_h,
        o_od=race_outer_od,
        o_id=race_outer_id,
        o_h=race_outer_h,
        s_h=shield_h
    );
}