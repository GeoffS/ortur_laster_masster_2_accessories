include <../OpenSCAD_Lib/MakeInclude.scad>

footX = 30;
footY = 4.8;
footZ = 8;

footPadX = 15.55;
footPadY = 7;
footPadZ = 7;

footEnclosureX = footX + 4.5;
footEnclosureY = footY + 4.5;
footEnclosureZ = footZ + 1;
footEnclosureCornerDia = 4;

pbx = footEnclosureX/2 - footEnclosureCornerDia/2;
pby = footEnclosureY/2 - footEnclosureCornerDia/2;

module itemModule()
{
	difference()
	{
		footBase();
		footCutout();
	}
}

module footBase()
{
	hull()
	{
		doubleX() doubleY() translate([pbx, pby, 0]) cylinder(d=footEnclosureCornerDia, h=footZ);
	}
}

module footCutout()
{
	tcu([-footX/2, -footY/2, -1], [footX, footY, 20]);
	tcu([-footPadX/2, -footPadY/2, -1], [footPadX, footPadY, footPadZ+1]);
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
