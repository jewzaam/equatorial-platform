/*

Now that I know how to get the coordinates of a point on a circle given the angle and radius (see circle.scad) we need to find the midpoint for an arc.

We know:
- radius (hard coded to 100 in this example)
- coordinates of the two points A and B

And we can assume all is within one quadrent.  A is up and to the left of B.
*/

A_x=90.6308;
A_y=42.2618;

B_x=57.3576;
B_y=81.9152;

/* [Hidden] */

$fn=100;
$vpt=[0,0,0];
$vpr=[360,0,0];
$vpd=800;

r=100;

module point(x,y,c) {
    color(c)
    translate([x,y,0])
    sphere(d=10);
}

module rod(angle,c) {
    color(c)
    rotate([0,0,-angle])
    {
        rotate([-90,0,0])
        cylinder(r=2,h=r,center=false);

        // and, cause we can, label it
        translate([-len(str(angle))*10/3,r+5,0])
        text(str(angle,"°"));
    }
}

module reference_circle() {
    color("gold")
    cylinder(r=r,h=1,center=true);
}

function midpoint(r,x1,y1,x2,y2) = [r*sin(atan(x1/y1)+(atan(x2/y2)-atan(x1/y1))/2),r*cos(atan(x1/y1)+(atan(x2/y2)-atan(x1/y1))/2)];


// circle
reference_circle();

// the 0 degree line
rod(0,"white");

point(A_x,A_y,"Magenta");
point(B_x,B_y,"Lime");

// calculate the angles
A_T=atan(A_x/A_y);
B_T=atan(B_x/B_y);

// verify visually
rod(A_T,"Magenta");
rod(B_T,"Lime");

// we know the angles now, draw midpoint line
M_T=A_T+(B_T-A_T)/2;
rod(M_T,"Silver");

// calculate the midpoint coordinates
// https://math.stackexchange.com/questions/260096/find-the-coordinates-of-a-point-on-a-circle
M_x=r*sin(M_T);
M_y=r*cos(M_T);
point(M_x,M_y,"Silver");

// try the midpoint formula
Mxy=midpoint(r,A_x,A_y,B_x,B_y);
point(Mxy[0],Mxy[1],"Gold");


// it works if the silver line has a gold point (it should overlap the silver point)