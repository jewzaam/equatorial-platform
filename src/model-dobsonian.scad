/*
#Units
Everything is in mm unless otherwise specified.

#Values
Enter real values!  It can be scaled down.

#Terms

Reference image for terms: https://stellafane.org/tm/dob/resources/images/mountanatomy.jpg

* Ground Board - stationary board that sits on the ground.
* Rocker Box ("rocker") - rotates on the Ground Board and is the box on which the Tube (via Altitude Bearing) sits.
* Platform - for this model, combination of the Ground Board and bottom of Rocker box
* Tube - the main body of the scope, houses the mirrors.
* Altitude Bearing ("bearing") - rests the Tube on the Rocker Box and provides Altitude adjustments.

*/

// Thickness of board that make up the rocker box.
dob_rocker_board_thickness=18;

// Height from floor to top of bottom of rocker box (the part that spins).
dob_platform_h=68;

// Radius of ground board / bottom of rocker box.
dob_platform_r=245;

// Height (length) of tube.
dob_tube_h=1180;

// Radius of tube.
dob_tube_r=117;

// Width of altitude bearing from one side of the tube to the other (height of cylinder).  Should be at least the same as dob_rocker_x!
dob_bearing_w=305;

// Radius of altitude bearing (radius of cylinder)
dob_bearing_r=70;

// Distance from fron of tube to center of altitude bearing.
dob_bearing_offset_from_tube_front=705;

// Height of the rocker box, excluding the rocker box base board, the part that rotates on the ground board.
dob_rocker_z=535;

// Width of the rocker box (side to side).  Must be less than or equal to dob_bearning_w!
dob_rocker_x=305;

// Depth of the rocker box (front to back).  Probably same ad dob_rocker_x.
dob_rocker_y=305;

// For the "display" picture, how much to rotate the tube.
display_rotation_deg=75;

// Scale for printing.  You can scale it yourself but this gives a "sane" starting point.
print_scale=0.1;

// If '1' will create the "display" model.  You want it to be "0" for a printable model unless you cut up and scale for printing.
output_display=1;

/* [Hidden] */
$fn = 1000;

module dob_base() {

    // base plate (simplified, not modeling spinning)
    color("blue")
    cylinder(h=dob_platform_h,r=dob_platform_r);

    // mount
    color("green")
    {
        
        difference() 
        {
            union() 
            {
                // side 1
                translate([-dob_rocker_x/2,-dob_rocker_y/2,0])
                cube([dob_rocker_board_thickness,dob_rocker_y,dob_rocker_z+dob_platform_h]);

                // side 2
                translate([dob_rocker_x/2-dob_rocker_board_thickness,-dob_rocker_y/2,0])
                cube([dob_rocker_board_thickness,dob_rocker_y,dob_rocker_z+dob_platform_h]);
            }

            // pivot
            translate([-dob_bearing_w,0,dob_tube_h-dob_bearing_offset_from_tube_front+dob_platform_h*2])
            rotate([0,90,0])
            cylinder(h=dob_bearing_w*2,r=dob_bearing_r*1.05);
        }
        
        // front
        translate([-dob_rocker_x/2,-dob_rocker_y/2,0])
        cube([dob_rocker_x,dob_rocker_board_thickness,dob_rocker_z/2+dob_platform_h]);
    }
}

module dob_scope() {
    {
        difference() 
        {
            union() 
            {
                // body
                color("black")
                cylinder(h=dob_tube_h,r=dob_tube_r);
                
                // pivot
                color("red")
                translate([-dob_bearing_w*1.1/2,0,dob_tube_h-dob_bearing_offset_from_tube_front])
                rotate([0,90,0])
                cylinder(h=dob_bearing_w*1.1,r=dob_bearing_r);
            }
            
            // hollow
            translate([0,0,dob_rocker_board_thickness])
            cylinder(h=dob_tube_h*2,r=dob_tube_r-dob_rocker_board_thickness);
        }
    }
}

module dob_print() {
    scale([print_scale,print_scale,print_scale])
    {
        // base as-is
        dob_base();
        
        // cut scope in half for post-print assembly (no support needed)
        
        // scope top
        translate([dob_platform_r,dob_platform_r*1.5,-dob_tube_h+dob_bearing_offset_from_tube_front])
        difference()
        {
            dob_scope();
            
            translate([-dob_platform_r,-dob_platform_r,-dob_bearing_offset_from_tube_front])
            cube([dob_platform_r*2,dob_platform_r*2,dob_tube_h]);
        }

        // scope bottom
        rotate([180,0,0])
        translate([-dob_platform_r,-dob_platform_r*1.5,-dob_tube_h+dob_bearing_offset_from_tube_front])
        difference()
        {
            dob_scope();
            
            translate([-dob_platform_r,-dob_platform_r,dob_tube_h-dob_bearing_offset_from_tube_front])
            cube([dob_platform_r*2,dob_platform_r*2,dob_tube_h]);
        }
    }
}

// approximation of the orion xt8 dob for reference
module dob_display() {
    dob_base();

    scope_offset_y=sin(display_rotation_deg)*(dob_tube_h-dob_bearing_offset_from_tube_front);
    scope_offset_z=cos(display_rotation_deg)*(dob_tube_h-dob_bearing_offset_from_tube_front);
    
    translate([0,scope_offset_y,dob_tube_h-dob_bearing_offset_from_tube_front+dob_platform_h*2-scope_offset_z])
    rotate([display_rotation_deg,0,0])
    dob_scope();
}

if (output_display > 0) {
    dob_display();
} else if (output_display == 0) {
    dob_print();
}
