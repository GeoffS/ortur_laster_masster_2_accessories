include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

layerHeight = 0.2;

footX = 100;
footY = 6;
footZ = 6;

footEnclosureCornerDia = 4;

baseCornerDia = footEnclosureCornerDia + 6;
baseX = footX;
baseY = 20;
baseZ = 12 * layerHeight;
baseCZ = 1;

echo(str("baseZ = ", baseZ));

baseShiftX = 6.5;
baseShiftY = 6.5;

pbx = baseX/2 - baseCornerDia/2;
pby = -(baseY - baseCornerDia/2);

screwHoleDia = 3.2; // Measured #4-1/2 FH

screwExtensionZ = baseZ;

guideZ = 8;
guideCZ = baseCZ;

pgy = -baseCornerDia/2;

module edgeWithGuide()
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
        union()
        {
            // Base:
            hull()
            {
                baseRoundedCornersXform(pby) simpleChamferedCylinder(d=baseCornerDia, h=baseZ, cz=baseCZ);
                baseRoundedCornersXform(pgy) simpleChamferedCylinder(d=baseCornerDia, h=baseZ, cz=baseCZ);
            }
            // Guide:
            hull()
            {
                baseRoundedCornersXform(pgy) simpleChamferedCylinder(d=baseCornerDia, h=guideZ, cz=guideCZ);
            }
        }
    }
}

module baseRoundedCornersXform(y)
{
	doubleX() translate([pbx, y, 0]) children();
}

module screwHoles()
{
	baseRoundedCornersXform(pby)
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
	display() edgeWithGuide();
}
else
{
	edgeWithGuide();
}
