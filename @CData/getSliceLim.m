function d3Lim_px = getSliceLim(o, dDrawCenter_xyzt, iDim)

% dDrawCenter_mnot = abs(o.dPos*dDrawCenter_xyzt(1:3));
dDrawCenter_data = o.fWorld2Data(dDrawCenter_xyzt(1:3));

% if any(strcmp(o.Parent.getDrawMode, {'min', 'max'}));
%     dMipDepth = 10;
%     d3Lim_mm = dDrawCenter_data(iDim) + 0.5.*[-dMipDepth dMipDepth];
% else
    d3Lim_mm = [dDrawCenter_data(iDim), dDrawCenter_data(iDim)];
% end

d3Lim_px = round((d3Lim_mm - o.Origin(iDim))./o.Res(iDim) + 1);
d3Lim_px = d3Lim_px(1):d3Lim_px(2);
d3Lim_px = d3Lim_px(d3Lim_px > 0 & d3Lim_px <= iGlobals.fSize(o.dImg, iDim));