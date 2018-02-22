function position(o)
% iView.POSITION Responsisble for positioning the contents of the views correctly.

for iI = 1:length(o)
   hView = o(iI);
   
   for iAxesInd = 1:length(hView.hA)
      dAxesPos_px = get(hView.hA(iAxesInd), 'Position');
      
      if ~isempty(hView.ViewGroup.Data)
         % Panel not empty

         % Determine the limits of x- and y-axes
         dMinRes_units = 1;%min(hView.hParent.dMinRes(1:3));
         dDelta_units = dAxesPos_px([4, 3])./hView.ViewGroup.Zoom.*dMinRes_units;
         
         iDimPermutation = hView.dA'*[1; 2; 3];
         set(hView.hA(iAxesInd), ...
            'XLim'   , hView.ViewGroup.DrawCenter(abs(iDimPermutation(2))) + dDelta_units(2).*[-0.5 0.5], ...
            'YLim'   , hView.ViewGroup.DrawCenter(abs(iDimPermutation(1))) + dDelta_units(1).*[-0.5 0.5]);
         
      else
         % Panel is empty: Dislpay the logo undistorted
         dSize = dAxesPos_px([4 3]);
         dLim = 6./max(dSize).*dSize;
         set(hView.hA(iAxesInd), ...
            'XLim'   , dLim(2).*[-0.5 0.5], ...
            'YLim'   , dLim(1).*[-0.5 0.5], ...
            'XDir'   , 'normal', ...
            'YDir'   , 'normal');
      end
   end
end

