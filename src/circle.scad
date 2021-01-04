/*

Needed to find the mid-point of an arc on a circle.
This is a building block towards that:

Find the coordinates of a point on a circle given an angle.

*/

angle=145;

/* [Hidden] */

$fn=100;
$vpt=[54,0,0];
$vpr=[360,0,0];
$vpd=800;

r=100;

color("gold")
cylinder(r=r,h=1,center=true);

// column represetning 0 degress
color("pink")
rotate([-90,0,0])
cylinder(r=2,h=r,center=false);

translate([-10/2,r+5,0])
text(str("0°"));

// put a point 45 degrees off the y axis
P_T=angle;
P_x=r*sin(P_T);
P_y=r*cos(P_T);

color("lime")
translate([P_x,P_y,0])
sphere(r=5);

// verify with a rotated cylinder

color("blue")
rotate([0,0,-P_T])
{
    rotate([-90,0,0])
    cylinder(r=2,h=r,center=false);

    // and, cause we can, label it
    translate([-len(str(P_T))*10/3,r+5,0])
    text(str(P_T,"°"));
}


translate([0,0,100])
text(str(P_x));