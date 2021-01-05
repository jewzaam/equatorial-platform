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

There are some lessons I have learned doing this project that I want to share.  As I figure out better ways to do the models I have started over or made major revisions.  Starting over is easier for me but that's up to the individual.  I'm on revision 6 as of writing these tips..

1. pick a point of reference for all shapes
1. do translations from this point of reference
1. do rotations from this point of reference
1. use a standard naming convention for your variables
1. use modules to create intermediate or final shapes
1. use consistent module arguments
1. do your model in steps you can reference later (you want to know what you did before you tweaked it, i.e. why I have a "fancy" north curve)
1. for each of the steps, use a parameter to select what to render
1. use a prefix for user supplied variables that you will never use for hidden variables

For this model:
* [0,0,0] is `ORIGIN`, the point of reference for all things
* I decided to put my build along the Y axis.. probably X is more common (better?) choice but that is where I am
* I build standard variables OUTSIDE of modules and pass them in as default arguments.

Using default agruments allows for manipulation by passing new arguments without having to write a new module or manipulate the output of a module.  It's **so** much cleaner!

I have put all of my standards into the model file used for this and since it might change I don't want to recreate it here.  See [the docs model initial comments](../src/equatorial-platform-docs.scad#L3-L43) (note this may not be exactly right as I am still tweaking the model).