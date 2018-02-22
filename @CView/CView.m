classdef CView < handle
   
   properties (SetAccess = immutable)
      Ind
      Parent
   end
   
   properties
      ViewGroup
      Position
      Orientation
   end
   
   properties (Access = private)
      hA          = matlab.graphics.axis.Axes.empty()
      hI          = matlab.graphics.primitive.Image.empty                % Image components
      %         hQ          = CQuiver.empty()                                      % The quiver component
      %         hL          = matlab.graphics.primitive.Line.empty                 % Line components
      %         hS1         = matlab.graphics.chart.primitive.Scatter.empty        % Scatter components
      %         hS2         = matlab.graphics.chart.primitive.Scatter.empty        % Scatter components
      %         hT          = matlab.graphics.primitive.Text.empty                 % Text components
      hP          = matlab.graphics.primitive.Patch.empty                % Patch component
      
      dColor
      
      dA  % Transformation matrix from axes to xyz
   end
   
   methods
      
      function o = CView(hImagine, iInd)
         o.Parent = hImagine;
         o.Ind = iInd;
         o.Orientation = 'native';
         
         SUData.iInd = iInd;
         SUData.sCursor = 'arrow';
         o.hA = axes(...
            'Parent'            , o.Parent.getFigure(), ...
            'Layer'             , 'top', ...
            'Units'             , 'pixels', ...
            'Color'             , o.Parent.Colors.bg_dark, ...
            'FontSize'          , 12, ...
            'XTickMode'         , 'manual', ...
            'YTickMode'         , 'manual', ...
            'XColor'            , [1 1 1].*0.25, ...
            'YColor'            , [1 1 1].*0.25, ...
            'XTickLabelMode'    , 'manual', ...
            'YTickLabelMode'    , 'manual', ...
            'XAxisLocation'     , 'top', ...
            'Box'               , 'on', ...
            'XGrid'             , 'off', ...
            'YGrid'             , 'off', ...
            'GridAlpha'         , 0.5, ...
            'XMinorGrid'        , 'off', ...
            'YMinorGrid'        , 'off', ...
            'MinorGridAlpha'    , 0.5, ...
            'YTickLabelRotation', 90, ...
            'UserData'           , SUData);
         hold on
         
         [dX, dY] = o.fHalfCircle(10);
         dLogoX = [dY, 1 - dY; dX, - dX + 1]' - 0.5;
         dLogoY = [- dX - 1, dX - 1; dY + 0.1, - dY + 1.1]' + 0.45;
         o.hP = patch(...
            'XData'     , dLogoX, ...
            'YData'     , dLogoY, ...
            'EdgeAlpha' , 0.25, ...
            'FaceAlpha' , 0.2);
         
      end
      
      function delete(o)
         if isvalid(o.hA)
            delete(o.hA);
            o.Parent.debug('Deleting Axes in View %d.\n', o.Ind);
         end
         delete@handle(o)
      end
      
      function set.ViewGroup(o, hGroup)
         o.ViewGroup = hGroup;
         o.dColor = hGroup.Color;
      end
      
      function set.dColor(o, dColor)
         o.dColor = dColor;
         set(o.hP, 'FaceColor', dColor, 'EdgeColor', dColor);
      end
      
      function set.Position(o, iPos)
         o.Position = iPos;
         o.hA.Position = iPos;
         %       if ~isempty(obj.hT)
         %          set(obj.hT(1, 1, 1, iJ), 'Position', [30, iHeight(iInd) - 10 - iRulerWidth]);
         %          set(obj.hT(1, 1, 2, iJ), 'Position', [29, iHeight(iInd) -  9 - iRulerWidth]);
         %       set(o.hT(1, 2, 1, iJ), 'Position', [iWidth(iPos) - 10 - iRuler, iHeight(iPos) - 10 - iRuler]);
         %       set(o.hT(1, 2, 2, iJ), 'Position', [iWidth(iPos) - 11 - iRuler, iHeight(iPos) -  9 - iRuler]);
         %       set(o.hT(2, 2, 1, iJ), 'Position', [iWidth(iPos) - 10, 10]);
         %       set(o.hT(2, 2, 2, iJ), 'Position', [iWidth(iPos) - 11, 11]);
         %       end
         % obj.grid();
         o.position();
      end
      
      function set.Orientation(o, sOrientation)
         switch(lower(sOrientation))
            
            case {'cor', 'c', 'coronal'}
               o.Orientation = 'cor';
               o.dA = [ 0,  1,  0;  0,  0,  1; 1,  0,  0];
               set(o.hA, 'XDir', 'normal', 'YDir', 'normal');
               
            case {'sag', 's', 'sagittal'}
               o.Orientation = 'sag';
               o.dA = [ 0,  0,  1;  0,  1,  0; 1,  0,  0];
               set(o.hA, 'XDir', 'normal', 'YDir', 'normal');
               
            case {'tra', 't', 'transversal'}
               o.Orientation = 'tra';
               o.dA = [ 0, -1,  0;  1,  0,  0; 0,  0,  1];
               set(o.hA, 'XDir', 'normal', 'YDir', 'reverse');
               
            case {'nat', 'n', 'native'}
               o.Orientation = 'nat';
               o.dA = [ 0,  1,  0; 1,  0,  0; 0,  0,  1];
               set(o.hA, 'XDir', 'normal', 'YDir', 'normal');
               
            otherwise
               error('Undefined data orientation "%s"!', sOrientation);
               
         end
      end
      
      function iPermutation = getPermutation(o)
         iPermutation = o.dA'*[1; 2; 3];
      end
      
      function d3DrawCenter = getDrawCenter(o, dDrawCenter_xyzt, iDim)
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
      end
      
      draw(o)
      position(o)
      grid(o)
      %
      updateImages(o)
      %         setData(o, cData)
      %         iDivider = isOverDevider(o, dCoord_px)
      %         backup(o)
      %         shift(o, dDelta)
      %         zoom(o, dFactor)
      %         showSlicePosition(o)
      %         showTimePoint(o)
      %         showSquare(o)
      %         dCoverage = getCoverage(o)
      
      %         function dCoord = getCurrentPoint(o, iDimInd)
      %             dCoord = get(o.hA(iDimInd), 'CurrentPoint');
      %             dCoord = dCoord(1, 1:2);
      %         end
      
      %         function NoBottomLeftText(o)
      %             for iI = 1:length(o)
      %                 if ~isempty(o(iI).hT)
      %                     set(o(iI).hT(2, 1, :), 'String', '');
      %                 end
      %             end
      %         end
      
      
   end
   
   methods (Static)
      
      function [dX, dY] = fHalfCircle(iN)
         dAlpha = linspace(0, pi/2, iN);
         dX = cos(dAlpha);
         dY = sin(dAlpha);
      end
      
   end
   
end
