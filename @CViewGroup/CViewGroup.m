classdef CViewGroup < handle
   
   properties (SetAccess = immutable)
      Parent
      Ind                          % Index of the view (global)      
      Color
   end
   
   properties (SetAccess = private)
      Zoom        = 1     % Zoom level
      DrawCenter  = []    % Coordinates of the central point
      Data = CData.empty() % handles of data objects attached to the view gropu
   end
   
   methods
      
      function o = CViewGroup(hImagine, iInd)
         %CViewGroup constructor
         dColors = iGlobals.fColors();
         dColors = dColors([1 3 6 9 13 15 16 18 20 23], :);
         dColors = repmat(dColors, [4, 1]);
         
         o.Parent = hImagine;
         o.Ind = iInd;
         o.Color = dColors(mod(iInd - 1, length(dColors)) + 1, :);
      end
      
      function addData(o, hData)
         for iI = 1:length(o)
            hViewGroup = o(iI);
            hViewGroup.Data(end + 1) = hData;
            if isempty(hViewGroup.DrawCenter)
               if hViewGroup.Ind == 1
                  if ~isempty(hViewGroup.Data)
                     dCoverage = hViewGroup.Data(1).getCoverage();
                     hViewGroup.DrawCenter = [mean(dCoverage, 2); 1];
                  end
               else
                  hViewGroup.DrawCenter = hViewGroup.Parent.getViewGroup(1).DrawCenter;
               end
            end
         end
      end
      
      function iNImg = getImageDataCount(o)
         iNQuiver = 0; % sum(strcmp([o.hData.Type], 'vector'));
         iNImg = numel(o.Data) - iNQuiver;
      end
      
      function shift(o, dDelta)
         for iI = 1:numel(o)
            if isempty(o(iI).Data), continue, end
            o(iI).DrawCenter = o(iI).DrawCenter + dDelta;
         end
      end
      
   end
   
end
