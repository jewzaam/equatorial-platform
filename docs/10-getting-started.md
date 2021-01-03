# Getting Started!

## Principles Defined
I’ve done many iterations on this and they’re all flawed.  The assume a dynamic platform.  This is a problem because it makes the build unable to adjust for error.  If your math is wrong you have to build a new platform.  I have decided a set of principles upon which the design is based is necessary.

1. The platform must have known dimensions.
2. The user defines the final configuration for both north and south bearings.
3. The design checks the telescope fits on the platform.
4. The design checks the center of gravity but not use it in the design.

This gives us a solid foundation to build from.  We can validate the design by doing a check that the platform and telescope should not tip over ever.  And we give the user ultimate responsibility for getting things right.

## Principles in Action
This actually is just the user inputs.  For this parameterized build, we can only work on what the user tells us.  So we need to collect some key information.  Listing those here in the context of the principles defined earlier:

1. The platform must have known dimensions.
    * platform top max width (east / west)
    * platform top length (north / south)
2. The user defines the final configuration for both north and south bearings.
    * south bearing pivot pin length
    * south bearing pivot pin diameter
    * center of south bearing pivot pin distance from south side of platform
    * north bearing width (if 3D printing, probably your max print bed width)
    * north bearing height at center (aka distance from bottom board to top board)
3. The design checks the telescope fits on the platform.
    * rocker box radius
4. The design checks the center of gravity but not use it in the design.
    * rocker box weight
    * tube weight
    * rocker box weight
    * rocker box distribution factor (i.e. how bottom heavy is it)
    * platform top weight
    * platform top thickness

From #1 we can provide a template for the platform top.  This template is used by the builder to at a minimum estimate the platform weight.

From #2 in conjunction with #1 we know the height of the south bearing and the curvature of the north bearing.  With data from #4 we can calculate if the scope will ever fall over, meaning tip past the point that gravity can keep things from moving in an unstable way.

And #3 will ensure what is being built actually fits the telescope.  Seems obvious but let’s make sure!

## Designing the Model
I use OpenSCAD.  All the images taken are from this tool.  The [model used is included](../src/equatorial-platform-docs.scad) and each picture can be reviewed by picking the “image” parameter.  The constant input values are also available for editing.






