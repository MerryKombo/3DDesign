/*
Ultimate Cable Label
Version V5, October 2023
Written by MC Geisler (mcgenki at gmail dot com)

Have fun!

License: Attribution 4.0 International (CC BY 4.0)

You are free to:
    Share - copy and redistribute the material in any medium or format
    Adapt - remix, transform, and build upon the material
    for any purpose, even commercially.
*/

$fn = 40;

cable_dia = 6.6;
cable_flat = cable_dia;
text = "Prusa";

/*
cable_dia=6.5;
cable_flat=cable_dia;
text="Scope";

cable_dia=7;
cable_flat=cable_dia;
text="NUC";

cable_dia=6.3;
cable_flat=4;
text="Shredder";

cable_dia=5.5;
cable_flat=3.5;
text="IXO";

cable_dia=5.5;
cable_flat=3.5;
text="USB 5V";

cable_dia=3.6;
cable_flat=cable_dia;
text="Lamp";

cable_dia=6.1;
cable_flat=cable_dia;
text="PSU";
*/




//------------------------

wiggle = .1;
cable_dia_wiggle = cable_dia + 2 * wiggle;
cable_flat_wiggle = cable_flat + 2 * wiggle;

wall = 1;
sink_in = wall / 2;
groove = 1;
groove_cube = sqrt(2) * groove;

nose = 0.75;

font = "Arial Rounded MT Bold";
size = 6.5;
updownaroundtext = .75 * wall;
leftrightaroundtext = 1 * wall;

//Size from text
tm = textmetrics(text, size = size, font = font);
textsize = tm.size; //array
textpos = tm.position; //array
textwidth = textsize[1];
shift_back = textpos[0];
//echo(ascent=tm.ascent,descent=tm.descent,textsize,tm);

length = textsize[0] + 2 * leftrightaroundtext;
height = cable_flat + 2 * wall;
top_width = max(cable_dia_wiggle + 2 * wall, textwidth + 2 * updownaroundtext);
if (cable_dia_wiggle + 2 * wall < textwidth + 2 * updownaroundtext)
    echo("********** font size too big ", cable_dia_wiggle - textwidth, "\n");
top_height = cable_flat / 2 + wall;
width = top_width + 2 * wall;

groove_dist = wall / 2;

module elongated(dia1, dia2, length)
{
    //echo (dia1, dia2, length); 

    hull()
        {
            dist = max(0, dia1 / 2 - dia2 / 2);
            translate([0, dist, 0])
                cylinder(d = dia2, h = length);
            translate([0, -dist, 0])
                cylinder(d = dia2, h = length);
        }
}

module cable(delta)
{
    translate([0, 0, wall + cable_flat / 2])
        rotate([0, 90, 0])
            translate([0, 0, -wall])
                intersection()
                    {
                        //scale([(cable_flat_wiggle/cable_dia_wiggle),1,1])
                        //cylinder(d=cable_dia_wiggle-2*delta,h=length+2*wall);

                        if (cable_dia_wiggle != cable_flat_wiggle)
                        {
                            elongated(cable_dia_wiggle - 2 * delta, cable_flat_wiggle - 2 * delta, length + 2 * wall);
                        }
                        else
                        {
                            cylinder(d = cable_dia_wiggle - 2 * delta, h = length + 2 * wall);
                        }
                        //translate([-(cable_flat_wiggle-2*delta)/2,-(cable_dia_wiggle+2)/2,0])
                        //    cube([cable_flat_wiggle-2*delta,cable_dia_wiggle+2,length+2*wall]);
                    }
}

module sunktext()
{
    translate([-shift_back + leftrightaroundtext, 0, sink_in - 0.01])
        color("white")
            rotate([180, 0, 0])
                linear_extrude(height = sink_in)
                    text(text, size = size, font = font, valign = "center");
}

module groove(deltalen)
{
    rotate([45, 0, 0])
        translate([-deltalen / 2, 0, 0])
            cube([length + deltalen, groove_cube, groove_cube]);
}

deltalen = 2 * wall;

module top(delta)
{
    difference()
        {
            union()
                {
                    difference()
                        {
                            //main block
                            translate([-delta / 2, -top_width / 2, -delta / 2])
                                {
                                    cube([length + delta, top_width, top_height + delta]);
                                }

                            //grooves
                            translate([0, 0, groove_dist])
                                {
                                    deltalengroove = 2 * wall;

                                    translate([0, -top_width / 2, 0])
                                        groove(deltalengroove);
                                    translate([0, top_width / 2, 0])
                                        groove(deltalengroove);
                                }

                        }


                    nosecube = sqrt(2) * nose;
                    nosein = nose + 2 * wall;
                    nosesink = groove - nose;

                    translate([nosein, -top_width / 2 + nosesink, 0])
                        rotate([0, 0, 45])
                            cube([nosecube, nosecube, top_height]);

                    translate([nosein, top_width / 2 - nose * 2 - nosesink, 0])
                        rotate([0, 0, 45])
                            cube([nosecube, nosecube, top_height]);
                }

            //cutout cable
            cable(delta);

            //cutout text
            if (delta == 0)
            sunktext();
        }
}




module bottom()
{
    difference()
        {
            translate([0, -width / 2, 0])
                cube([length, width, height]);

            //cutout cable
            cable(0);

            translate([0, 0, height])
                rotate([180, 0, 0])
                    top(2 * wiggle);

            sunktext();
        }
}


translate([0, top_width * 2, 0])
    top(0);

bottom();

test = textmetrics("test", size = 8);
if (test.size.x > 0)
{
    echo("All good. Textmetrics option is activated.");
}
else
{
    echo("*****************************************************");
    echo("*****************************************************");
    echo("**");
    echo("**   ERROR: Textmetrics option is not activated!");
    echo("**");
    echo("**   To fix this:");
    echo("**    - Install latest OpenSCAD snapshot:");
    echo("**      https://openscad.org/downloads.html#snapshots");
    echo("**    - Activate textmetrics via");
    echo("**      Edit → Preferences → Features → textmetrics");
    echo("**");
    echo("*****************************************************");
    echo("*****************************************************");
}
