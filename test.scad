use <testData.scad>

lt = levels_testData();

width = len(lt[0]);
height = len(lt);

function lerp(start, end, bias) = (end * bias + start * (1 - bias));

function GetPoint (x, y) = lt[y % height][x % width]/255;

function GetPointBilinear (x, y) = 
let
(
    xF = floor(x),
    yF = floor(y),
    xC = ceil(x),
    yC = ceil(y),
    
    xR = x - xF,
    yR = y - yF,
    
    bl = GetPoint(xF, yF),
    br = GetPoint(xC, yF),
    tl = GetPoint(xF, yC),
    tr = GetPoint(xC, yC)
)
lerp (lerp (bl,br, xR), lerp(tl,tr,xR), yR);

resolution = 1.0; // [.5:.1:4]
scale = 1.0; // [.5:.1:4]
xOffset = 0; // [-1:0.01:1]
yOffset = 0; // [-1:0.01:1]

xOffsetPix = xOffset * width;
yOffsetPix = yOffset * height;

for (x = [xOffsetPix:scale/resolution:(width-1)*scale+xOffsetPix], y = [yOffsetPix:scale/resolution:(height-1)*scale+yOffsetPix])
    translate ([x,height-y]) sphere (d = GetPointBilinear(x,y)/resolution);
    //translate ([x,height-y]) sphere (d = GetPoint(x,y));