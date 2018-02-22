function resize(o, hSource, ~)
%RESIZE Arranges all the contens of the GUI

% -------------------------------------------------------------------------
% Get size of the figure
dFigureSize   = get(o.hF, 'Position');
dFigureWidth  = dFigureSize(3);
dFigureHeight = dFigureSize(4);
o.iPosition = dFigureSize;

% -------------------------------------------------------------------------
% Arrange the views
iRulerWidth = 19.*double(o.lRuler) + 1;
iX = round(fNonLinSpace(1, dFigureWidth + 2, o.dColWidth(1:o.iNViews(1))));
iY = round(fNonLinSpace(dFigureHeight + 1, 1, o.dRowHeight(1:o.iNViews(2))));
[iH, iW] = meshgrid(diff(iY), diff(iX));
[iY, iX] = meshgrid(iY(2:end), iX(1:end - 1));
iPos = [iX(:) + iRulerWidth, iY(:), iW(:) - iRulerWidth - 1, - iH(:) - iRulerWidth - 1];
for iI = 1:length(o.hViews)
   o.hViews(iI).Position = iPos(iI, :);
end
o.hViews.grid();

% -------------------------------------------------------------------------
% If triggered by the timer, check if icons have to be resized
% if isa(hSource, 'timer')
%    
%    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%    % Determine the desired size according to figure dimensions
%    iNMenuIcons = nnz([o.SMenu.GroupIndex] < 255 & [o.SMenu.SubGroupInd] == 0) + 3;
%    iNTools = nnz([o.SMenu.GroupIndex] == 255) + 1.2;
%    iSize = min(48, round(dFigureWidth./iNMenuIcons));
%    iSize = min(iSize, round(dFigureHeight./iNTools));
%    
%    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%    % Resize if necessary
%    if iSize ~= o.iIconSize
%       o.iIconSize = max(24, iSize);
%       o.updateActivation; % Rescales the icons if necessary
%    end
%    stop(o.STimers.hIcons);
% elseif isa(hSource, 'matlab.ui.Figure')
%    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%    % Origin is figure (user is resizing) -> start timer to check for icon resizing
%    if strcmp(get(o.hF, 'Visible'), 'on');
%       stop(o.STimers.hIcons);
%       start(o.STimers.hIcons);
%    end
% end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Arrange the imagine elements

% dToolbarWidth = o.iIconSize;
% dMenubarHeight = o.iIconSize;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% MenuBar
% dMenuWidth = dFigureWidth + 1 - dToolbarWidth;
% set(o.SAxes.hMenu,  ...
%    'Position'      , [dToolbarWidth, dFigureHeight - o.iIconSize + 1 - 4, dMenuWidth, dMenubarHeight + 4], ...
%    'XLim'          , [0 dMenuWidth] + 0.5, ...
%    'YLim'          , [0 o.iIconSize + 4] + 0.5);

% dCData = repmat(permute(o.SColors.bg_normal, [1 3 2]), o.iIconSize + 4, 1);
% dCData(o.iIconSize + 1:end, :, :) = 0;
% dAlpha = ones(o.iIconSize + 4, 1);
% dAlpha(o.iIconSize + 1:o.iIconSize + 4) = [0.7; 0.5; 0.3; 0.0];
% set(o.SImgs.hMenu, ...
%    'CData'       , dCData, ...
%    'AlphaData'   , dAlpha);


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Toolbar
% set(o.SAxes.hTools, ...
%    'Position'      , [0, 1, dToolbarWidth, dFigureHeight - o.iIconSize], ...
%    'XLim'          , [0 dToolbarWidth] + 0.5, ...
%    'YLim'          , [0 dFigureHeight - o.iIconSize] + 0.5);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Dock button
% lInd = strcmp({o.SMenu.Name}, 'dock');
% set(o.SImgs.hIcons(lInd), 'XData', 1 + dFigureWidth - dToolbarWidth - o.iIconSize);
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% o.hViews.showSquare;
% -------------------------------------------------------------------------

function dPos = fNonLinSpace(dStart, dEnd, dRelDistance)

dInt = cumsum(dRelDistance./sum(dRelDistance));
dPos = [dStart, (dEnd - dStart).*dInt + dStart];