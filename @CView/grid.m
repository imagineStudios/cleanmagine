function grid(o)

dGridSpacing = 50;
% dGrid = obj(1).hParent.dGrid;
% lRuler = obj(1).hParent.lRuler;

% -------------------------------------------------------------------------
% If the grid serves as a temporary crosshair, reset and start the timer
% for undoing this
% if dGrid == -1
%     stop(obj(1).hParent.STimers.hGrid);
%     start(obj(1).hParent.STimers.hGrid);
% end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
for iView = 1:numel(o)
   hView = o(iView);
   
   % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   % Handle the grid visibility
   %    if isempty(o.hData) || (dGrid == 0 && ~lRuler)
   %       set(o.hA, ...
   %          'XGrid'         , 'off', ...
   %          'YGrid'         , 'off', ...
   %          'XMinorGrid'    , 'off', ...
   %          'YMinorGrid'    , 'off', ...
   %          'XTick'         , [], ...
   %          'YTick'         , [], ...
   %          'XTickLabel'    , {}, ...
   %          'YTickLabel'    , {});
   %       continue
   %    end
   
   set(hView.hA, 'XGrid', 'on', 'YGrid', 'on');
%    if dGrid > 0
      set(hView.hA, 'XMinorGrid', 'on', 'YMinorGrid', 'on');
%    else
%       set(o.hA, 'XMinorGrid', 'off', 'YMinorGrid', 'off');
%    end
   
   % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   % Determine the position of the grid ticks and labels
   %    if dGrid == -1
   %       % -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
   %       % This is the crosshair case
   %       iDim = o.hData(1).Dims(iDimInd, :);
   %       dCoord_mm = o.DrawCenter(iDim);
   %       set(o.hA(iDimInd), 'XTick', dCoord_mm(2), 'YTick', dCoord_mm(1), ...
   %          'XTickLabel', {}, 'YTickLabel', {});
   
   %    else
   % -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
   % The standard grid
   
   % -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
   % Set the ticks
   dXLim = get(hView.hA, 'XLim');
   dYLim = get(hView.hA, 'YLim');
   dXTick = floor(dXLim(1)/dGridSpacing)*dGridSpacing:dGridSpacing:ceil(dXLim(2)/dGridSpacing)*dGridSpacing;
   dYTick = floor(dYLim(1)/dGridSpacing)*dGridSpacing:dGridSpacing:ceil(dYLim(2)/dGridSpacing)*dGridSpacing;
   set(hView.hA, 'XTick', dXTick + 0.5, 'YTick', dYTick + 0.5);
   
   % -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
   % Set the tick labels
   %    if lRuler
   dViewSize = get(hView.hA, 'Position');
   dPixelsPerTick = dViewSize(3)./diff(dXLim).*dGridSpacing;
   iMod = ceil(30/dPixelsPerTick);
   sXLabels = cell(size(dXTick));
   for iI = 1:length(dXTick)
      if ~mod(round(dXTick(iI)/dGridSpacing), iMod)
         sXLabels{iI} = sprintf('%d', round(dXTick(iI)));
      else
         sXLabels{iI} = '';
      end
   end
   
   dYTick = get(hView.hA, 'YTick') - 0.5;
   sYLabels = cell(size(dYTick));
   for iI = 1:length(dYTick)
      if ~mod(round(dYTick(iI)/dGridSpacing), iMod)
         sYLabels{iI} = sprintf('%d', round(dYTick(iI)));
      else
         sYLabels{iI} = '';
      end
   end
   
   set(hView.hA, 'XTickLabel', sXLabels, 'YTickLabel', sYLabels);
   %    else
   %       set(o.hA(iDimInd), 'XTickLabel', {}, 'YTickLabel', {});
   %    end
   %    end
end
