function dCoverage_world = getCoverage(o)

iSize_image = iGlobals.fSize(o.dImg, 1:3);
dCoverage_world = [o.fData2World([1; 1; 1]), ...
                   o.fData2World(iSize_image)];