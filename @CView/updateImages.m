function updateImages(o)

for iI = 1:length(o)
   hView = o(iI);
   
   if isempty(hView.ViewGroup)
      iNTargetImgs = 0;
   else
      iNTargetImgs = hView.ViewGroup.getImageDataCount();
   end
   iNExistingImgs = numel(hView.hI);
   
   if iNTargetImgs < iNExistingImgs
      % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      % Delete obsolete image components
      delete(hView.hI(iNTargetImgs + 1:iNExistingViews));
      lKeep = ~isvalid(o.hViews);
      hView.hI = hView.hI(lKeep);
      hView.Parent.debug('Deleted %d image component(s) in view %d!\n', nnz(~lKeep), iI);
      
   elseif iNTargetImgs > iNExistingImgs
      % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      % Create the new image components
      for iJ = iNExistingImgs + 1:iNTargetImgs
         hView.hI(iJ) = image( ...
            'Parent'    , hView.hA(iJ), ...
            'CData'     , zeros(1, 1, 3), ...
            'HitTest'   , 'off');
         hView.Parent.debug('Creating new image component no. %d in view %d!\n', iJ, iI);
      end
   end
   
   if iNTargetImgs > 0
      hView.hP.Visible = 'off';
      hView.hA.Color = 'k';
   else
      hView.hP.Visible = 'on';
      hView.hA.Color = hView.Parent.Colors.bg_dark;
   end
   
   hView.draw();
   
end