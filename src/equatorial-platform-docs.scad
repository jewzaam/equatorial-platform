include <bearing.scad>

image="1"; // [debug:debug,1:Earth,2:Earth with Cone,4:Basic Platform,5:Platform with South Pin,3:Cone,6:Cone with Basic Platform,7:Cone with Circle,8:Cone with Circle and Basic Platform,9:Cone Circle Basic Platform with Point,10:Updated Platform,11:North Rectangle,12:North Curve,13:North Fancy,18:North Support,30:Platform Bottom,31:Bottom Bearings]

/* [Hidden] */
$fn=200;


$vpt = [235, 756, 347];
$vpr = [62,0,111];
$vpd = 1750;

T=35.5;

print_x=250;
bs_h=50;
bs_d=10;
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

cone_h=eqp_y*1.1;
cone_r1=0;
cone_r2=cone_h*tan(T);

c_hyp=bn_y;
c_r=c_hyp*sin(T);
c_h=c_hyp*cos(T);

c_eqp_x=sqrt(pow(c_r,2)-pow(c_r-eqp_z/cos(T),2));
c_eqp_y=bn_y-eqp_z*tan(T);
c_eqp_z=eqp_z; 

e_r=250;


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

module axis() {
    r2=eqp_x*tan(T);

    color("blue")
    rotate([T-90,0,0])
    cylinder(r=5,h=eqp_x*2);
}

module earth() {
    rotate([0,0,180])
    union()
    {
        // scale by trial and error
        scale(6.32)
        color("LawnGreen")
        import("../stl/geody_earthmap.stl");
        
        color("CornflowerBlue")
        sphere(r=e_r);
    }
    rotate([90-T,0,0])
    axis();
}

// the shape used to cut the top off the cone, for reuse
module cone_cut() {
    color("yellow")
    translate([-eqp_x,0,eqp_z])
    cube([cone_h*2,cone_h*2,cone_h*2]);
}

module cone(solid=true,cut=false,t=1) {

    color("yellow",t)
    difference() 
    {

        rotate([T-90,0,0])
        difference()
        {
            cylinder(r1=cone_r1,r2=cone_r2,cone_h);

            if (solid) {
                // noop
            } else {
                translate([0,0,1])
                cylinder(r1=cone_r1,r2=cone_r2,cone_h);
            }
            
        }
        if (cut) {
            cone_cut();
        }
    }
}

module earth_cone() {
    earth();
    
    // find point cone intersects.. because we can
    
    // adjust the "e_r" which is actually the radius of the blue sphere
    e_cone_r = e_r * 1.02;
    e_cone_hyp = e_cone_r/cos(T);
    e_cone_x = e_cone_r*cos(T);
    e_cone_z = e_cone_r*sin(T);

    s=0.1;
    
    translate([e_cone_x,0,e_cone_z])
    rotate([90-T,0,0])
    {
        scale(s)
        cone(solid=false);

        axis();
    }
}


// circle along axis of cone
module circle(cut=false,rod=false,h=1,r=c_r,hyp=c_hyp,axis_offset=c_h) {
    if (rod) {
        color("red")
        translate([0,hyp,0])
        cylinder(r=5,h=eqp_z);
    }
    
    color("lime")
    difference()
    {
        rotate([T-90,0,0])
        translate([0,0,axis_offset-h])
        cylinder(r=r,h=h);
        
        if (cut) {
            cone_cut();
        }
    }
}

module platform_trangle() {
    R=atan(eqp_y/eqp_x/2);
    
    color("SaddleBrown")
    difference()
    {
        translate([-eqp_x/2,0,0])
        cube([eqp_x,eqp_y,eqp_h]);
        
        translate([0,0,-eqp_h/2])
        rotate([0,0,-R])
        cube([eqp_x*2,eqp_y*2,eqp_h*2]);

        translate([0,0,-eqp_h/2])
        rotate([0,0,90+R])
        cube([eqp_x*2,eqp_y*2,eqp_h*2]);
    }
}

module bridge_south() {
    color("Magenta")
    translate([0,bs_eqp_y-bs_d/2,-bs_h])
    cylinder(d=bs_d,h=bs_h);
}


module platform_circle_eqp_intersect() {
    color("pink")
    translate([c_eqp_x,c_eqp_y,c_eqp_z])
    sphere(r=10);
}

module platform_updated() {
    o=c_eqp_x;
    a=c_hyp-cone_bs_y-(bn_y-c_eqp_y);
    R=atan(o/a);
    
    color("SaddleBrown")
    difference()
    {
        translate([-eqp_x/2,0,0])
        cube([eqp_x,eqp_y,eqp_h]);
        
        translate([0,0,-eqp_h/2])
        rotate([0,0,-R])
        cube([eqp_x*2,eqp_y*2,eqp_h*2]);

        translate([0,0,-eqp_h/2])
        rotate([0,0,90+R])
        cube([eqp_x*2,eqp_y*2,eqp_h*2]);
    }
}

module north_rectangle(support=false) {
    a=c_eqp_x;
    o=cone_bn_y-c_eqp_y;
    W=atan(o/a);
    
    color("Orange")
    translate([0,cone_bn_y,0])
    rotate([0,0,-W])
    translate([c_eqp_x-print_x,0,0])
    cube([print_x,bn_h,eqp_z]);
}

module north_curve() {
    color("Orange")
    intersection() 
    {
        color("Orange")
        cone(solid=true,cut=false);

        north_rectangle();
    }
}

module north_fancy_base() {
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

module north_fancy_hull() {
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

module north_fancy(support=false) {
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
    if (support) {
        difference()
        {
            // add the support
            north_support(c="purple");
            // cut the holes
            north_holes();
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
 


module image_earth() {
    translate([0,500,150])
    earth();
}

module image_earth_cone() {
    translate([0,500,150])
    earth_cone();
}

module image_platform() {
    platform_trangle();
}

module image_cone() {
    h=eqp_y;
    cone(solid=false);
    axis();
}

module image_platform_bs() {
    platform_trangle();
    bridge_south();
}

module image_platform_cone_intersection() {
    cone(solid=false,cut=true);
    axis();
    
    translate([0,cone_bs_y,bs_z+bs_h])
    {
        platform_trangle();
        bridge_south();
    }
}

module image_circle() {
    cone(solid=false,cut=true);
    axis();
    circle(cut=false,rod=false);
}

module image_circle_cut() {
    cone(solid=false,cut=true);
    axis();
    circle(cut=true,rod=true);

    translate([0,cone_bs_y,bs_z+bs_h])
    {
        platform_trangle();
        bridge_south();
    }
}

module image_platform_circle_eqp_intersect() {
    image_circle_cut();
    
    platform_circle_eqp_intersect();
}

module image_platform_updated() {
    
    cone(solid=false,cut=true);
    axis();
    circle(cut=true,rod=true);

    translate([0,cone_bs_y,bs_z+bs_h])
    {
        platform_updated();
        bridge_south();
    }
    
    platform_circle_eqp_intersect();
}


module image_north_rectangle() {
    cone(solid=false,cut=true);
    axis();
    circle(cut=true,rod=true);

    platform_circle_eqp_intersect();
    
    north_rectangle();
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

if (image == "1") {
    image_earth();
} else if (image == "2") {
    image_earth_cone();
} else if (image == "4") {
    image_platform();
} else if (image == "3") {
    image_cone();
} else if (image == "5") {
    image_platform_bs();
} else if (image == "6") {
    image_platform_cone_intersection();
} else if (image == "7") {
    image_circle();
} else if (image == "8") {
    image_circle_cut();
} else if (image == "9") {
    image_platform_circle_eqp_intersect();
} else if (image == "10") {
    image_platform_updated();
} else if (image == "11") {
    image_north_rectangle();
} else if (image == "12") {
    image_north_curve();
} else if (image == "13") {
    image_north_fancy();
} else if (image == "18") {
    image_north_support();
} else if (image == "30") {
    image_platform_bottom();
} else if (image == "31") {
    image_platform_bottom_bearing();
} else if (image == "debug") {
    // get midpoint between 
    
    circle();
    north_curve();
    platform_bottom();
}

module debug_y(y,t) {

    translate(t)
    rotate([-90,0,0])
    cylinder(d=10,h=y);
}

module debug_x(x,z) {
}