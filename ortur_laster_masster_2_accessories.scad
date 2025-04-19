include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

layerHeight = 0.2;

makeType1 = false;
makeType2 = false;

footX = 35;
footY = 4.8;
footZ = 8;

footPadX = 15.55;
footPadY = 7;
footPadZ = 20; //7;

footEnclosureX = footX + 4.5;
footEnclosureY = footY + 4.5;
footEnclosureZ = footZ + 1;
footEnclosureCornerDia = 5;

pfex = footEnclosureX/2 - footEnclosureCornerDia/2;
pfey = footEnclosureY/2 - footEnclosureCornerDia/2;

baseCornerDia = footEnclosureCornerDia + 6;
baseX = footEnclosureX + 14;
baseY = footEnclosureY + 14;
baseZ = 12 * layerHeight;

baseShiftXY = 3;

pbx = baseX/2 - baseCornerDia/2;
pby = baseY/2 - baseCornerDia/2;

screwHoleDia = 3.2; // Measured #4-1/2 FH

psh1x = pbx;
psh1y = pby;

psh2x = -pbx;
psh2y = -pby;

module itemModule()
{
	difference()
	{
		footBase();
		footCutout();
		screwHoles();
	}
}

module footBase()
{
	hull()
	{
		doubleX() doubleY() translate([pfex, pfey, 0]) simpleChamferedCylinder(d=footEnclosureCornerDia, h=footZ, cz=3*layerHeight);
	}
	baseXform() hull()
	{
		doubleX() doubleY() translate([pbx, pby, 0]) simpleChamferedCylinder(d=baseCornerDia, h=baseZ, cz=1);
	}
}

module footCutout()
{
	tcu([-footX/2, -footY/2, -1], [footX, footY, 20]);
	tcu([-footPadX/2, -footPadY/2, -1], [footPadX, footPadY, footPadZ+1]);
}

module baseXform()
{
	translate([baseShiftXY, -baseShiftXY, 0]) children();
}

module screwHoles()
{
	screwHole(psh1x, psh1y);
	screwHole(psh2x, psh2y);
}

module screwHole(x, y)
{
	baseXform() translate([x,y,0]) 
	{
		tcy([0,0,-1], d=screwHoleDia, h=20);
		d2=9;
		translate([0,0,baseZ-screwHoleDia/2-1.7]) cylinder(d1=0, d2=d2, h=d2/2);
	}
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
	// baseXform() tcu([-200, -400+psh2y+d, -1], 400);
}

if(developmentRender)
{
	display() itemModule();

	display() translate([-50,0,0]) mirror([1,0,0]) itemModule();
}
else
{
	if(makeType1) itemModule();
	if(makeType2) mirror([1,0,0]) itemModule();
}
