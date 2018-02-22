function [dImg, dXData, dYData] = getData(o, dDrawCenter_xyzt, dA)

iDimPermutation = abs(dA'*o.dP(1:3,1:3)*[1; 2; 3]);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Translate to slice indices, determine timepoint
dDrawCenter_data = o.fWorld2Data(dDrawCenter_xyzt(1:3));
d3Lim_data = round(dDrawCenter_data(iDimPermutation(3)));
iT = max(1, min(dDrawCenter_xyzt(4), size(o.dImg, 4)));

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Get data and permute into first two dimensions (3rd for projection data, 4th for rgb/vector data)

if ~isempty(d3Lim_data)
   switch iDimPermutation(3)
      case 1, dImg = o.dImg(d3Lim_data, :, :, iT, :);
      case 2, dImg = o.dImg(:, d3Lim_data, :, iT, :);
      case 3, dImg = o.dImg(:, :, d3Lim_data, iT, :);
   end
   dImg = permute(dImg, [iDimPermutation' 5 4]);
else
   dImg = 0;
end

dLims = o.getCoverage();
dLims = sort(dLims, 2);

a = o.dP(1:3, 1:3)'*dLims;

lFlip = abs(dA)*o.dS(1:3,1:3)'*ones(3, 1);
if lFlip(1), flip(dImg, 1); end
if lFlip(2), flip(dImg, 2); end

dAspect = o.Res(iDimPermutation(1:2));
dOrigin = o.Origin(iDimPermutation(1:2));
dXData = [0 size(dImg, 2) - 1].*dAspect(2) + dOrigin(2);
dYData = [0 size(dImg, 1) - 1].*dAspect(1) + dOrigin(1);
% dXData = a(2, :);
% dYData = a(1, :);


% -------------------------------------------------------------------------

% if nargin < 5, lHD = false;   end
% lHD = obj.Parent.getHDMode();

% if nargin == 1 && nargout == 1
%     % Special case of only one input argument: Return thumbnail
%     dImg = obj.Img(:,:,obj.ThumbSlice,1,:);
%     dImg = permute(dImg, [1 2 5 4 3]);
%     return
% end

% -------------------------------------------------------------------------
% Get the corresponding image data




% -------------------------------------------------------------------------
% Apply the global draw mode
% sDrawMode = obj.Parent.getDrawMode;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% For complex data and not phase mode, get the magnitude
% if ~strcmp(sDrawMode, 'phase') && ~isreal(dImg)
%     dImg = abs(dImg);
% end

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Calculate phase image or projection
% switch sDrawMode
%     case 'phase'
%         if isreal(dImg)
%             dImg = pi*sign(dImg);
%         else
%             dImg = angle(dImg);
%         end
%
%     case 'max'
%         dImg = max(dImg, [], 3);
%
%     case 'min'
%         dImg = min(dImg, [], 3);
%
% end
% -------------------------------------------------------------------------

% dImg = double(dImg);

% lNum = ~any(isnan(dImg), 4);
% dImg(~lNum) = 0;



% if lHD && ~strcmp(o.Mode, 'vector') && ~strcmp(o.Mode, 'categorical') && ~isscalar(dImg)
%     % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
%     % Fancy mode: Interpolate the images to full resolution. Is
%     % executed when arbitrary input is supplied or the timer fires.
%
%     % -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
%     % Pad the image for better boundary extrapolation
%     dImg = [dImg(:,1), dImg, dImg(:, end)];
%     dImg = [dImg(1,:); dImg; dImg(end, :)];
%     dX = (-1:size(dImg, 2) - 2).*dAspect(2) + dOrigin(2);
%     dY = (-1:size(dImg, 1) - 2).*dAspect(1) + dOrigin(1);
%
%     dXLim = get(hAxes, 'XLim');
%     dYLim = get(hAxes, 'YLim');
%     dPosition = get(hAxes, 'Position');
%
%     dXI = (0.5:dPosition(3) - 0.5)./dPosition(3).*diff(dXLim) + dXLim(1);
%     dYI = (0.5:dPosition(4) - 0.5)./dPosition(4).*diff(dYLim) + dYLim(1);
%
%     dXI = dXI(dXI >= mean(dX(1:2)) & dXI <= mean(dX(end-1:end)));
%     dYI = dYI(dYI >= mean(dY(1:2)) & dYI <= mean(dY(end-1:end)));
%
%     [dXXI, dYYI] = meshgrid(dXI, dYI);
%     dImg = interp2(dX, dY, double(dImg), dXXI, dYYI, 'spline', 0);
%     dNum = interp2(dX(2:end-1), dY(2:end-1), double(lNum), dXXI, dYYI, 'spline', 0);
%
%     dXData = [dXI(1), dXI(end)];
%     dYData = [dYI(1), dYI(end)];
% else
% dNum = double(lNum);
% end


% -------------------------------------------------------------------------
% Apply the intensity scaling and current colormap
% if strcmp(sDrawMode, 'phase')
%    dMin = -pi;
%    dMax = pi;
% else
%    dMin = o.Window(1);
%    dMax = o.Window(2);
% end
% 
% switch o.Type
%    
%    case 'scalar'
%       dImgA = dImg - dMin;
%       dImgA = dImgA./(dMax - dMin);
%       dImgA(dImgA < 0) = 0;
%       dImgA(dImgA > 1) = 1;
%       
%       iImg = round(dImgA.*(size(o.Colormap.dMap, 1) - 1)) + 1;
%       dImg = reshape(o.Colormap.dMap(iImg, :), [size(iImg, 1) ,size(iImg, 2), 3]);
%       
%    case 'categorical'
%       dColormap = [0 0 0; lines(max(dImg(:)))];
%       iImg = round(dImg) + 1;
%       dImg = reshape(dColormap.dMap(iImg, :), [size(iImg, 1) ,size(iImg, 2), 3]);
%       
%    case 'rgb'
%       dImg = dImg - dMin;
%       dImg = dImg./(dMax - dMin);
%       dImg(dImg < 0) = 0;
%       dImg(dImg > 1) = 1;
%       dImg = squeeze(dImg);
%       
% end
% % -------------------------------------------------------------------------
% 
% if o.Alpha == 0 && strcmp(o.Mode, 'scalar')
%    dAlpha = dImgA;
% elseif ~isempty(d3Lim_px)
%    dAlpha = o.Alpha;
% else
%    dAlpha = 0;
% end
% dAlpha = dNum.*dAlpha;