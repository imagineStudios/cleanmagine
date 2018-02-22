function draw(o)

% -------------------------------------------------------------------------
% Determine some drawing parameters
% dGamma         = get(o.SSliders(1).hScatter, 'XData');
% dMaskAlpha     = o.getSlider('Mask Alpha');
% dQuiverWidth   = o.getSlider('Quiver Width');
% l3D = o(1).hParent.get3DMode();
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% Loop over all views
for iI = 1:numel(o)
   hView = o(iI);
   hData = hView.ViewGroup.Data;
   
   if ~isempty(hData)
      for iJ = 1:length(hData)
         
         [dImg, dXData, dYData] = ...
            hData(iJ).getData(hView.ViewGroup.DrawCenter, hView.dA);
         
         set(hView.hI(iJ), ...
            'CData'     , dImg, ...
            'AlphaData' , 1, ...
            'XData'     , dXData, ...
            'YData'     , dYData);
         
         %       if ~strcmp(o(iI).hData(iJ).Type, 'vector')
         % It's image data
         
         
         %       else
         % Its a quiver plot
         %          set(SView.hQuiver, ...
         %             'XData'     , dXData, ...
         %             'YData'     , dYData, ...
         %             'Visible'   , 'on', ...
         %             'LineWidth' , dQuiverWidth);
         %
         %          set(SView.hQuiver.Edge, ...
         %             'ColorBinding'  , 'interpolated', ...
         %             'ColorData'     , uint8(dImg))
         %       end
      end
      %    set(o(iI).hT(1, 1, :, :), 'String', sprintf('%s', o(iI).hData.Name), 'Visible', 'on');
   end
   
end