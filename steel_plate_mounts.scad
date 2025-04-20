include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

layerHeight = 0.2;

makeLLCorner = false;
makeULCorner = false;
makeEdgeWithGuide = false;
makeEdgeWithoutGuide = false;

footX = 100;
footY = 6;
footZ = 6;

footEnclosureCornerDia = 4;

// pfex = footX/2 - footEnclosureCornerDia/2;
// pfey = footY/2 - footEnclosureCornerDia/2;

baseCornerDia = footEnclosureCornerDia + 6;
baseX = footX;
baseY = 20;
baseZ = 7 * layerHeight; // Just less than 1/16"
baseCZ = 1;

echo(str("baseZ = ", baseZ));

baseShiftX = 6.5;
baseShiftY = 6.5;

pbx = baseX/2 - baseCornerDia/2;
pby = -(baseY - baseCornerDia/2);

screwHoleDia = 3.2; // Measured #4-1/2 FH

screwExtensionZ = baseZ + baseCZ;

module edgeWithoutGuide()
{
	difference()
	{
		basePlate();
		screwHoles();
	}
}

module basePlate()
{
	difference()
    {
        hull()
        {
            doubleY() baseRoundedCornersXform() simpleChamferedCylinder(d=baseCornerDia, h=baseZ, cz=baseCZ);
        }
        // Trim off X>0:
        tcu([-200,0,-10], 400);
    }
    // Extra thickness at screws:
    baseRoundedCornersXform() simpleChamferedCylinder(d=baseCornerDia, h=screwExtensionZ, cz=baseCZ);
}

module baseRoundedCornersXform()
{
	doubleX() translate([pbx, pby, 0]) children();
}

module screwHoles()
{
	baseRoundedCornersXform()
	{
		tcy([0,0,-1], d=screwHoleDia, h=20);
		d2=9;
		translate([0,0,screwExtensionZ-screwHoleDia/2-1.7]) cylinder(d1=0, d2=d2, h=d2/2);
	}
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
	// baseXform() tcu([-200, -400+psh2y+d, -1], 400);
}

if(developmentRender)
{
	display() edgeWithoutGuide();

	// display() translate([-70,0,0]) mirror([1,0,0]) edgeWithoutGuide();
}
else
{
	if(makeType1) edgeWithoutGuide();
	if(makeType2) mirror([1,0,0]) edgeWithoutGuide();
}
