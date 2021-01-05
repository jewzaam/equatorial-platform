include <bearing.scad>

/*
Objects:
- cone (cone)
- axis (axis)
- platform, top (eqpt)
- platform, bottom (eqpb)
- north curve (bn)
- north bearing
- north support (bns)
- south pin (bs)
- south pivot (pivot)

Coordinates all relative to [0,0,0].
Rotations all in an array [x,y,z].

Thickness of objects called "height".

Variable types:
- input: values that user provides, are copied to other variables
- single value: special case, rare use
- coordinate, xyz: [x,y,z] relative to [0,0,0]
- rotation, rot: [x,y,z]
- dimensions, dim: [x,y,z]
- cylinder, cyl: [h,d], note use of diameter

All objects created from modules can be moved using the given coordinates which are relative to [0,0,0].

Variable names are
<object short name>_<variable type short name>

Order of translation and rotation is subject to the individual part.

Modules take arguments, order doesn't matter.
- dim: the cube dimensions of the shape (cannot also have cyl)
- cyl: the cylinderacle dimensions of the shape (cannot also have dim)
- xyz: the translation for the final shape created by the module
- rot: the rotation for the final shape created by the module
- t: transparency for the object
- s: scale for the object

*/

image="1"; // [debug:debug,earth:Earth,earth_cone:Earth with Cone,cone:Cone,eqpt_triangle:Basic Platform,eqpt_bs:Platform with South Pin,cone_circle:Cone with Circle,eqpt_circle_platform:Cone with Circle and Basic Platform,eqpt_circle_platform_point:Cone Circle Basic Platform with Point,eqpt_updated:Updated Platform,eqpt_bn_rectangle:North Rectangle,eqpt_bn_curve:North Curve,eqpt_bn_fancy:North Fancy,eqpt_bn_support:North Support,eqpb:Platform Bottom]


// Latitude
input_latitude=35.5;
input_south_bearing_height=50;
input_south_bearing_diameter=10;
input_print_bed=[250,250,250];

// Estimated dimensions of platforms (top and bottom).
input_platform_xyz=[800,800,18];
// Distance between the top and bottom platforms.
input_platform_gap=160;

input_north_curve_thickness=20;

input_north_support_thickness=20;

input_north_washer_diameter=50;

input_north_bolt_diameter=10;

input_south_washer_diameter=50;

/* [Hidden] */
$fn=200;

$vpt = [235, 756, 347];
$vpr = [62,0,111];
$vpd = 1750;

ORIGIN=[0,0,0];

// Helper index values.
// Makes it easier to read and allows it to be changed.
i_h=0;
i_d=1;
i_x=0;
i_y=1;
i_z=2;

// Convert input variables into more structured variables

// very special var name, just don't want to type something long
T=input_latitude;

print_x=max(input_print_bed[i_x],input_print_bed[i_y],input_print_bed[i_z]);

earth_xyz=[0,500,150];
earth_rot=[0,0,180];
earth_r=250;

eqpt_dim=input_platform_xyz;

// build south bridge data before eqpt xyz
bs_cyl=[input_south_bearing_height,input_south_bearing_diameter];
bs_xyz=[0,(input_platform_gap-bs_cyl[i_h])/tan(T),input_platform_gap-bs_cyl[i_h]];
bs_rot=[0,0,0];

eqpt_xyz=[
    -eqpt_dim[i_x]/2,
    bs_xyz[i_y]-input_south_washer_diameter/2,
    input_platform_gap
];

eqpb_dim=input_platform_xyz;
eqpb_xyz=[eqpt_xyz[i_x],eqpt_xyz[i_y],-eqpb_dim[i_z]];

bn_dim=[print_x,input_north_curve_thickness,eqpt_xyz[i_z]];

// the north support is big enough for the washers that can fit, no more
bns_dim=[
    floor(print_x/input_north_washer_diameter)*input_north_washer_diameter,
    input_north_washer_diameter+bn_dim[i_y],
    input_north_support_thickness
];



// special case variables for cone
cone_cyl=[eqpt_dim[i_y]*1.1,eqpt_dim[i_y]*1.1*tan(T)*2];
cone_rot=[T-90,0,0];
cone_xyz=[0,0,0];

axis_xyz=cone_xyz;
axis_cyl=[eqpt_dim[i_y]*2,4];
axis_rot=cone_rot;

circle_hyp=eqpt_dim[i_y]+eqpt_xyz[i_y];
circle_cyl=[0.1/*bn_dim[i_y]*/,circle_hyp*sin(T)*2];
circle_xyz=[0,circle_hyp,0];
circle_rot=[T,0,0];

// calculate where circle meets parabola
c_r=circle_cyl[i_d]/2;
c_h=circle_hyp*cos(T);

circleParabolaPoint_xyz=[
    sqrt(pow(circle_cyl[i_d]/2,2)-pow(circle_cyl[i_d]/2-eqpt_xyz[i_z]/cos(T),2)),
    eqpt_dim[i_y]+eqpt_xyz[i_y]-eqpt_xyz[i_z]*tan(T),
    eqpt_xyz[i_z]
];
P=circleParabolaPoint_xyz;

// angle of rotation for north bridge (rectangle/curve) is from the edge of eqpt near parabola/circle to the "rod"
bn_rot=[0,0,-atan((eqpt_dim[i_y]+eqpt_xyz[i_y]-circleParabolaPoint_xyz[i_y])/(eqpt_dim[i_x]/2))];
bn_xyz=[eqpt_dim[i_x]/2,P[i_y],0];

bs_h=input_south_bearing_height;
bs_d=input_south_bearing_diameter;
bs_eqp_y=50;
eqp_x=800;
eqp_y=800;
eqp_h=18;
eqp_z=160;
bn_h=20;
bn_support_h=20;
bn_hole_d=10;
bn_washer_d=60;

bs_z=eqp_z-bs_h;
bs_y=bs_z/tan(T);
cone_bs_y=bs_y-bs_eqp_y+bs_d/2;
bn_y=eqp_y+bs_y-(bs_eqp_y-bs_d/2);
cone_bn_y=bn_y;



bearing_ir_od=21;
bearing_ir_id=14.9;
bearing_ir_h=11;

bearing_or_od=35;
bearing_or_id=30.8;
bearing_or_h=11;

bearing_s_h=10.4;

/**
 * Get the midpoint between two points on a circle of known radius.  The circle must be a (0,0).  
 */
function midpoint(r,x1,y1,x2,y2) = [r*sin(atan(x1/y1)+(atan(x2/y2)-atan(x1/y1))/2),r*cos(atan(x1/y1)+(atan(x2/y2)-atan(x1/y1))/2)];

module axis(cyl=axis_cyl,xyz=axis_xyz,rot=axis_rot,t=0.5) {
    color("blue",t)
    rotate(rot)
    translate(xyz)
    cylinder(r=cyl[i_d]/2,h=cyl[i_h]);
}

module earth(xyz=earth_xyz,rot=earth_rot) {
    translate(xyz)
    rotate(rot)
    {
        // scale by trial and error
        scale(6.32)
        color("LawnGreen")
        import("../stl/geody_earthmap.stl");
        
        color("CornflowerBlue")
        sphere(r=earth_r);

        // axis w/o rotation
        axis(rot=rot,t=1);
    }
}

// the shape used to cut the top off the cone, for reuse
module cone_cut(xyz=[-eqpt_dim[i_x],0,eqpt_xyz[i_z]],dim=[cone_cyl[i_h]*2,cone_cyl[i_h]*2,cone_cyl[i_h]*2],rot=ORIGIN) {
    color("yellow")
    translate(xyz)
    rotate(rot)
    cube(dim);
}

module cone(cyl=cone_cyl,xyz=cone_xyz,rot=cone_rot,solid=true,cut=false,t=0.5) {

    color("yellow",t)
    translate(xyz)
    difference() 
    {

        rotate(rot)
        difference()
        {
            cylinder(r1=0,r2=cyl[i_d]/2,cyl[i_h]);

            if (solid) {
                // noop
            } else {
                translate([0,0,1])
                cylinder(r1=0,r2=cyl[i_d]/2,cyl[i_h]);
            }
            
        }
        if (cut) {
            cone_cut();
        }
    }
}

module earth_cone(xyz=earth_xyz,rot=earth_rot) {
    earth(xyz=xyz,rot=rot);
    
    // find point cone intersects.. because we can
    
    // adjust the "earth_r" which is actually the radius of the blue sphere, so that it's outside of the "land" parts of earth
    earth_cone_r = earth_r * 1.02;
    
    earth_cone_xyz=[xyz[i_x]+earth_cone_r*cos(T),xyz[i_y],xyz[i_z]+earth_cone_r*sin(T)];
    earth_cone_rot=[0,0,0];

    // scale down some things for the cone and axis
    s=0.1;
    
    // scale cone by "s"
    cone(cyl=cone_cyl*s,xyz=earth_cone_xyz,rot=earth_cone_rot,solid=false,t=1);

    // scale only axis height by "s"
    axis(cyl=[axis_cyl[i_h]*s,axis_cyl[i_d]],xyz=earth_cone_xyz,rot=earth_cone_rot,t=1);
}

// circle along axis of cone
module north_circle(cyl=circle_cyl,xyz=circle_xyz,rot=circle_rot,cut=false,t=0.5) {
    color("lime",t)
    difference()
    {
        translate(xyz)
        rotate(rot)
        translate([0,0,cyl[i_d]/2])
        rotate([90,0,0])
        cylinder(d=cyl[i_d],h=cyl[i_h]);
        
        if (cut) {
            cone_cut();
        }
    }
}

module eqpt_triangle(xyz=eqpt_xyz,dim=eqpt_dim) {
    R=atan(dim[i_y]/dim[i_x]/2);
    
    color("SaddleBrown")
    translate(xyz)
    difference()
    {
        cube([dim[i_x],dim[i_y],dim[i_z]]);
        
        translate([dim[i_x]/2,0,-dim[i_z]/2])
        rotate([0,0,-R])
        cube([dim[i_x]*2,dim[i_y]*2,dim[i_z]*2]);

        translate([dim[i_x]/2,0,-dim[i_z]/2])
        rotate([0,0,90+R])
        cube([dim[i_x]*2,dim[i_y]*2,dim[i_z]*2]);
    }
}

module eqpt_updated(xyz=eqpt_xyz,dim=eqpt_dim,t=1) {
    // from the intersection of circle and parabola (point P)
    
    // find the angle towards the center of the cone (where top of "red rod" is in images)
    R=atan(dim[i_x]/2/(P[i_y]-eqpt_xyz[i_y]));
    
    color("SaddleBrown",t)
    translate(xyz)
    difference()
    {
        cube([dim[i_x],eqp_y,eqp_h]);
        color("pink")
        translate([dim[i_x]/2,0,-dim[i_z]/2])
        rotate([0,0,-R])
        cube([dim[i_x]*2,dim[i_y]*2,dim[i_z]*2]);

        translate([dim[i_x]/2,0,-dim[i_z]/2])
        rotate([0,0,90+R])
        cube([dim[i_x]*2,dim[i_y]*2,dim[i_z]*2]);
    }
}
module bearing_south(xyz=bs_xyz,cyl=bs_cyl,rot=bs_rot) {
    color("Magenta")
    translate(xyz)
    cylinder(d=cyl[i_d],h=cyl[i_h]);
}



module bn_fancy_base() {
    // find the intersection of the circle and extrude it in the z direction to have a shape that can connect to the support
    
    difference()
    {
        
        intersection()
        {
            // where the thickened circle and cone intersect
            cone(cut=true);
            circle(h=bn_h);
        }
        
        // minus all but width of printer
        translate([-c_eqp_x-print_x,bn_y/2,-eqp_z/2])
        cube([c_eqp_x*2,bn_y,eqp_z*2]);
    }
}

module bn_fancy_hull() {
    // this is slow.  super slow.  too bad eh?
    hull() 
    {
        // create the base
        north_fancy_base();
        
        // extrude up with hull to a copy above it
        translate([0,0,eqp_z])
        north_fancy_base();
    }
}

module bn_rectangle(xyz,rot,dim) {
    translate(xyz)
    rotate(rot)
    translate([-dim[i_x],0,0])
    cube(dim);
}


module bridge_north(xyz=bn_xyz,rot=bn_rot,dim=bn_dim,type="rectangle") {
    // this one is a little different.  we want to offset for rotation and translation relative to the outer north point
    if (type == "rectangle") {
        color("Orange")
        bn_rectangle(xyz=xyz,rot=rot,dim=dim);
    } else if (type == "curve") {
        color("Orange")
        intersection() 
        {
            color("Orange")
            cone(solid=true,cut=false);

            bn_rectangle(xyz=xyz,rot=rot,dim=dim);
        }
    } else if (type == "fancy") {
        color("purple")
        
        difference() 
        {
            union() {
                // base is the hulled fancy thing
                north_fancy_hull();

            }
            // cut off the inner curve by using the outer curve
            // scale in x and z a little bit
            // and translate it -x and -z just a touch
            translate([-c_eqp_x*0.01,-bn_h,0])        
            scale([1.01,1,1.01])
            north_fancy_hull();
            
            // cut the top off, same level as the cone cut
            cone_cut();
            
        }

    }
}

module north_curve_bearing_touch() {
}

module north_holes() {
    // well, not the holes. but the pegs to cut them
        a=c_eqp_x;
    o=cone_bn_y-c_eqp_y;
    W=atan(o/a);

    x=floor(print_x/bn_washer_d)*bn_washer_d;
    bn_hole_count=floor(x/bn_washer_d);
    
    translate([0,cone_bn_y,0])
    rotate([0,0,-W])
    translate([c_eqp_x-print_x,-bn_h,0])
    translate([0,-bn_h/2,eqp_z-bn_support_h*2])
    for (i=[1:bn_hole_count]) {
        translate([bn_washer_d/2+(i-1)*bn_washer_d,0,0])
        cylinder(d=bn_hole_d,h=50);
        
        translate([bn_washer_d/2+(i-1)*bn_washer_d,0,-eqp_z+bn_support_h])
        cylinder(d=bn_washer_d,h=eqp_z);
    }
}

module north_support(c="white") {
    // add the support bits
    
    // based on washers, platform is only as wide as needed
    washer_count=floor(print_x/bn_washer_d);
    x=washer_count*bn_washer_d;
    
    // figure out angle to rotate.  should be the 
    // it gets moved relative to platform
    a=c_eqp_x;
    o=cone_bn_y-c_eqp_y;
    W=atan(o/a);

    color(c)
    translate([0,cone_bn_y,0])
    rotate([0,0,-W])
    translate([c_eqp_x-print_x,-bn_h,0])
    difference()
    {
        // the main support platform, create from 2 cylinders representing washers (minimizes waste)
        translate([0,-bn_h/2,eqp_z-bn_support_h])
        hull()
        {
            translate([bn_washer_d*(washer_count-1)+bn_washer_d/2,0,0])
            cylinder(d=bn_washer_d,h=bn_support_h);
            
            translate([bn_washer_d/2,0,0])
            cylinder(d=bn_washer_d,h=bn_support_h);
        }
        
        // holes
        north_holes();
    }
}
 


module image_platform_cone_intersection() {
    cone(solid=false,cut=true);
    axis();
    eqpt_triangle();
    bearing_south();
}

module image_circle() {
    cone(solid=false,cut=true);
    axis();
    circle(cut=false);
    
}

module image_circle_cut() {
    cone(solid=false,cut=true);
    axis();
    circle(cut=true);
    circle_eqpt_rod();

    translate([0,cone_bs_y,bs_z+bs_h])
    {
        eqpt_triangle();
        bearing_south();
    }
}

module image_platform_circle_eqp_intersect() {
    image_circle_cut();
    
    platform_circle_eqp_intersect();
}



module image_north_curve() {
    axis();
    
    cone(solid=false,cut=true);

    north_curve();
    
    mirror([1,0,0])
    north_curve();
    
    
    platform_circle_eqp_intersect();
}

module image_north_fancy() {
    axis();
    
    cone(solid=false,cut=true);

    circle(cut=true);

    north_fancy();
    
    mirror([1,0,0])
    north_fancy();
    
    platform_circle_eqp_intersect();
}

module image_north_support() {
    axis();
    
    cone(solid=false,cut=true);

    north_fancy(support=true);

    mirror([1,0,0])
    {
        north_fancy(support=true);
    }
    
    platform_circle_eqp_intersect();
}

module platform_bottom(bearing=false) {
    translate([0,cone_bs_y,-eqp_h])
    platform_updated();
    
    if (bearing) {
        // starts centered on x/y plane
        // re-orient and move relative to north curve
        
        rotate([90,0,0])
        model_bearing();
    }
}

module model_bearing() {
    bearing(
        i_od=bearing_ir_od,
        i_id=bearing_ir_id,
        i_h=bearing_ir_h,
        o_od=bearing_or_od,
        o_id=bearing_or_od,
        o_h=bearing_or_h,
        s_h=bearing_s_h
    );
}

module image_platform_bottom() {
    platform_bottom();
    
    cone(cut=true,solid=false,t=0.3);
    
    axis();
}

module image_platform_bottom_bearing() {
    north_curve();
    platform_bottom(bearing=true);
}

if (image == "earth") {
    earth();
} else if (image == "earth_cone") {
    earth_cone();
} else if (image == "cone") {
    cone(solid=false);
    axis();
} else if (image == "eqpt_triangle") {
    eqpt_triangle();
    cone(solid=false,cut=true);
    axis();
} else if (image == "eqpt_bs") {
    eqpt_triangle();
    bearing_south();
    cone(solid=false,cut=true);
    axis();
} else if (image == "cone_circle") {
    cone(solid=false,cut=true);
    north_circle();
    axis();    
} else if (image == "eqpt_circle_platform") {
    eqpt_triangle();
    bearing_south();
    cone(solid=false,cut=true);
    axis();
    north_circle(cyl=[1,circle_cyl[i_d]],cut=true);
    
    // show the "rod"
    debug_z(xyz=[0,eqpt_xyz[i_y]+eqpt_dim[i_y],0],value=eqpt_xyz[i_z]);
} else if (image == "eqpt_circle_platform_point") {
    eqpt_triangle();
    bearing_south();
    cone(solid=false,cut=true);
    axis();
    north_circle(cut=true);
    
    // show the "rod"
    debug_z(xyz=[0,eqpt_xyz[i_y]+eqpt_dim[i_y],0],value=eqpt_xyz[i_z]);
    
    // show where circle meets parabola
    debug_point(circleParabolaPoint_xyz,c="hotpink");
    
} else if (image == "eqpt_updated") {
    eqpt_updated();
    bearing_south();
    cone(solid=false,cut=true);
    axis();
    north_circle(cut=true);

    // show the "rod"
    debug_z(xyz=[0,eqpt_xyz[i_y]+eqpt_dim[i_y],0],value=eqpt_xyz[i_z]);
    
    // show where circle meets parabola
    debug_point(circleParabolaPoint_xyz,c="hotpink");
} else if (image == "eqpt_bn_rectangle") {
    cone(solid=false,cut=true);
    axis();
    north_circle(cut=true);

    bridge_north(type="rectangle");
    
    // show the "rod"
    debug_z(xyz=[0,eqpt_xyz[i_y]+eqpt_dim[i_y],0],value=eqpt_xyz[i_z]);
    
    eqpt_updated(t=0.4);
    bearing_south();

    // show where platform circle/parabola line
    debug_point(xyz=[bn_xyz[i_x],bn_xyz[i_y],eqpt_xyz[i_z]],d=20);
} else if (image == "eqpt_bn_curve") {
    north_circle(cut=true);
    cone(solid=false,cut=true,t=0.5);
    // translate up just a bit for visual color maniuplation
    s=0.1;
    translate([0,s,s])
    bridge_north(type="curve");
    axis();
} else if (image == "eqpt_bn_fancy") {
    image_north_fancy();
} else if (image == "eqpt_bn_support") {
    image_north_support();
} else if (image == "eqpb") {
    image_platform_bottom();
} else if (image == "31") {
    image_platform_bottom_bearing();
} else if (image == "debug") {
    bearing_south();
    eqpt_triangle();
    axis();
    cone(solid=false,cut=true);
    circle(cut=true);
    
}


module debug_x(xyz=ORIGIN,value,c="red",t=0.5) {
    color(c,t)
    translate(xyz)
    rotate([0,90,0])
    cylinder(d=10,h=value);
}

module debug_y(xyz=ORIGIN,value,c="red",t=0.5) {
    color(c,t)
    translate(xyz)
    rotate([-90,0,0])
    cylinder(d=10,h=value);
}

module debug_z(xyz=ORIGIN,value,c="red",t=0.5) {
    color(c,t)
    translate(xyz)
    rotate([0,0,90])
    cylinder(d=10,h=value);
}

module debug_point(xyz=ORIGIN,d=25,c="red",t=0.5) {
    color(c,t)
    translate(xyz)
    sphere(d=d);
}

module debug(xyz=[eqpt_dim[i_x]/2,eqpt_xyz[i_y],0],rot=[0,0,90],value,s=5,c="red",t=0.5) {
    translate(xyz)
    rotate([0,0,90])
    scale(s)
    text(str(value));
}