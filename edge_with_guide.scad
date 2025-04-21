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

guideX = baseX;
guideY = 6;
guideZ = 8;
guideCZ = baseCZ;

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
                doubleY() baseRoundedCornersXform() simpleChamferedCylinder(d=baseCornerDia, h=baseZ, cz=baseCZ);
            }
            // Guide:
            // tcu([-guideX/2, -guideY, 0], [guideX, guideY, guideZ]);
            hull()
            {
                cx = guideX - 2*guideCZ;
                cy = guideY - 2*guideCZ;
                cz = guideZ - guideCZ;
                tcu([-guideX/2, -cy-guideCZ, 0], [guideX, cy, cz]);
                tcu([-cx/2, -guideY, 0], [cx, guideY, guideZ]);
            }
        }

        // Chamfer the ends:
        doubleX() translate([-baseX/2, 0, 0]) rotate([0,0,45]) tcu([-200, -2*sin(45), -10], 400);

        // Chamfer the top of the guide:
        translate([-baseX/2, 0, guideZ]) rotate([45,0,0]) tcu([-200, -2*sin(45), -10], 400);

        // Trim off X>0:
        tcu([-200,0,-10], 400);
    }
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
	display() edgeWithGuide();
}
else
{
	edgeWithGuide();
}
