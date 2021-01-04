# Model: Top Platform

## Basic Platform
For the purposes of this document the platform (brown) is represented as a triangle.  In practice it can be whatever shape you like so long as it’s heavy enough and your telescope fits on it.
![Basic Platform](images/basic-platform.png)

## Our Cone
The foundation of an equatorial platform is spilling a cone (yellow) to compensate for earth’s rotation.  So we take the latitude where the platform is going to be used and start with a cone on its side with the center axis (blue) raised at the latitude.
![Cone](images/cone.png)

## South Bearing
The entire model depends on this platform, south bearing pivot pin (purple), and the distance the bottom and top of the platforms are from each other at the north bridge (not built yet).
![South Pin](images/platform-with-south-pin.png)

## Platform / Cone Cross Section
With this critical information we can find the intersection of the bottom of the platform with the cone.  This is the plane with the platform positioned off the bottom of the cone with the south bearing pivot pin touching the axis.  We illustrate this by cutting the top of the cone off showing the parabola edge.
![Platform / Cone Cross Section](images/cone-with-basic-platform.png)

## Rotation
Things get interesting now!  We want to design the north bridge. At the north bridge we have movement along a curve.  This movement means a lot of moving forces and ideally we have the forces go straight down.  This will also simplify where this curve rests (and moves) on the bottom platform.  To find this curve that intersects the cone directly under the middle of the north edge of the platform and is perpendicular to the axis.  In this picture a slice of the circle (green) is shown with the platform removed for better viewing.
![Cone with Circle](images/cone-with-circle.png)

## Platform with Rotation
To verify, we can review the model with the platform (brown) added in, the circle (green) cut, and a rod (red) indicating the circle under the platform edge lines up.
![Cone with Circle and Basic Platform](images/cone-with-circle-and-basic-platform.png)

## Point on Parabola
That looks fancy and complicated.  But why do we care?  We want a vertical north bearing.  For that we are going to find where the circle in the picture above ends on the cone.  Meaning, the point (pink) on the parabola that intersects with the circle.  From that point we’ll create a curve towards where the cone (red) intersects with the circle.
![Cone with Circle and Basic Platform and Point](images/cone-with-circle-and-basic-platform-and-point.png)

## Adjusted Platform
Except… this isn’t what we really want.  We want the curve from where the green circle intersects the cone between platform edges.  And we have to consider we’re not making the full curve since we’ll never be able to use the middle portion.

Ok, this needs to be adjusted!  We need to line up the circle with the east and west edges of the platform.  I’m going to optimize a little bit.  I know I won’t have a triangular corner on my platform.  So I’m going to simply square the north edge corners. I’ll use the intersection of the circle on the parabola since it’s close enough to what I want and can be consistently calculated from the input we already have.
![Updated Platform](images/updated-platform.png)

## North Curve: Rough
Now we’ll build the north curve.  Finally!  Deep breath.. we move to “close enough” territory now.  Drop a rectangle (orange) along the edge from the circle/parabola/platform intersection (pink) towards the rod (red).  Limit the width to the print area assuming you can print the height.

Note the north rectangle (green) does not touch the full circle (green).  You would need to adjust the height of this part to get it to hit all bits of the curve.  Remember, we’re trying to have forces go straight down from the platform.  The simplest approximation of this is to base it on a flat orientation.
![North Rectangle](images/north-rectangle.png)

## North Curve: Pretty Good
There are some thing that could be optimized about this.  But keep in mind this is about rotating around the axis (blue).  And we have the cone (yellow) that provides a surface.  If we simply ensure that our north curve (orange) roles on something that represents the outside of the cone we’re good.  
![North Curve](images/north-curve.png)

## North Curve: Fancy
I couldn't leave it alone though.  When looking at placement for the bearing under the north curve (orange) I just didn't like that it moved across that curve.  So we get fancy.  I'll explain it but not going to show anything but the final product (purple).

1. draw the circle with a height that's acceptable for it to run on the bearing(s)
2. cut the top off at the bottom of the platform
3. cut the inside portion of the remainder off so that a width that is big enough to print remains
4. cut all but the outer edge of this curve off
5. place a copy of this curve offset in the z direction by the platform bottom's height
6. create a shape between the two curves (original and copy) with [hull](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#hull)
7. cut again, keeping only the portion below the platform's bottom
8. and cut one more time to curve the inner vertical to match the outer vertical
![North Fancy](images/north-fancy.png)


## North Curve: Supports
The edge of the circle now lines up with the fancy north curve.  But on the off chance it’s not good enough we can ensure the platform can take adjustments.  We’ll build the mounting support relative to the point on the parabola (pink) so adjustments will just screw in to replace the old part.  Use the washer diameter to limit the printed horizontal support structure.  It doesn’t add value if it’s not being held by something.
![North Support](images/north-support.png)