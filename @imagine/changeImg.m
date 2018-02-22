function changeImg(o, ~, iCnt)

% -------------------------------------------------------------------------
% Determine origin of callback and which dimension to work on
if isstruct(iCnt) || isobject(iCnt)
   % Mouse wheel callback: operate depending on current view
   iCnt = iCnt.VerticalScrollCount;
   hView = o.SAction.hView;
else
   % Keyboard input (iCnt is numeric): work on the first view
   hView = o.hViews(1);
end

if isempty(hView), return, end
% if isempty(hView.hData), return, end

if o.SAction.lShift
   % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   % Change Timepoint
   iDim = 4;
   dStepSize = 1;
   iCnt = sign(iCnt);
else
   % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   % Change z coordinate
   iDimPermutation = hView.getPermutation();
   iDim = iDimPermutation(3);
   dStepSize = 1;%o.dMinRes(iDim);
   %     dStepSize = hView.hData(1).Res(iDim);
end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Apply scrolling to all views
dDelta = zeros(4, 1);
dDelta(iDim) = iCnt.*dStepSize;
o.hViewGroups.shift(dDelta);
% -------------------------------------------------------------------------


% -----------------------------------------------------------------
% Update the view contents
o.hViews.draw();
o.hViews.position();
o.hViews.grid();
% if o.isOn('3d')
%    %     if obj.dGrid ~= -1, obj.SAction.dGrid = obj.dGrid; end
%    o.dGrid = -1;
%    o.hViews.position;
%    %     obj.hViews.grid;
% end
% 
% if iDim == 4
%    o.hViews.showTimePoint;
% else
%    o.hViews.showSlicePosition;
% end
% -----------------------------------------------------------------