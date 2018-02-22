classdef CData < handle
   
   properties
      Name
      SpatialUnits
      TemporalUnits
      Type
      Orientation
      Res             = ones(4, 1)
      Origin          = ones(4, 1)
      Window
      Colormap
      Hist
      HistCenter
   end
   
%    properties (SetAccess = private)
%       ViewGroups      = []
%    end
   
   properties (Access = private)
      dImg             = []
      sAlpha           = 1
      dThumbSlice      = 1
      dOldCenter
      dOldWidth
      SColormaps
      dP = [0 1 0 0; 1 0 0 0; 0 0 1 0; 0 0 0 1] % Permutation matrix
      dS       % Scaling Matrix
      dSInv
      dT       % Joint transformation matrix, i.e. dP*dS
      dTInv
   end
   
   methods
      
      function o = CData(iInd, varargin)
         %CDATA c'tor
         o.parseInputs(varargin{:});
         if isempty(o.Name)
            o.Name = sprintf('Data %d', iInd);
         end
      end
      
%       function addViewGroups(o, iGroups)
         %Add this dataset to the view groups with indices iGroups
%          o.ViewGroups = union(o.ViewGroups, iGroups(:)');
%       end
      
%       function removeViewGroups(o, iGroups)
         %Remove this dataset from the view groups with indices iGroups
%          o.ViewGroups = setdiff(o.ViewGroups, iGroups);
%       end
      
      function set.Res(o, dRes)
         o.Res = padarray(dRes(:), 4 - length(dRes), 1, 'post');
         o.fSetTrafos();
      end
      
      function set.Origin(o, dOrigin)
         o.Origin = padarray(dOrigin(:), 4 - length(dOrigin), 1, 'post');
         o.fSetTrafos();
      end
      
      function set.Orientation(o, sOrientation)
         o.Orientation = lower(sOrientation(1:3));
         o.fSetTrafos();
      end
      
      dCoverage_world = getCoverage(o)      
      [dImg, dXData, dYData] = getData(obj, dDrawCenter_xyzt, dA)
      %     [dUData, dVData, dXData, dYData, dCData] = getVectors(obj, dDrawCenter, iDimInd, hA)
      
      %     setColormap(obj, xMap)
      %     [sMap, iInd] = getColormap(obj)
      
      %     iSize_xyz = getSize(obj, iDim)
      %     dCoverage = getCoverage(obj, iDim)
      %     dCenter = getCenter(obj)
      
      %     d3Lim_px = getSliceLim(obj, dDrawCenter, iDim)
      
      %     function iPermutation = getPermutation(obj)
      %        iPermutation = obj.B*[1 2 3]';
      %     end
      
      %     backup(obj)
      %     window(obj, dFactor)
      
      %     function cRes = getRes(obj)
      %       cRes = cell2mat({obj.Res}');
      %     end
      
      %     setOrientation(obj, sOrientation)
      
   end
   
   methods (Access = private)
      parseInputs(obj, varargin)
      
      function dCoord_world = fData2World(o, dCoord_data)
         dCoord_data = [dCoord_data(:) - 1; 1]; % Compensate for matlab indexing and harmonize
         dCoord_world = o.dT*dCoord_data; % Scaling & Permutation
         dCoord_world = dCoord_world(1:3); % De-harmonize
      end
      
      function dCoord_data = fWorld2Data(o, dCoord_world)
         dCoord_world = [dCoord_world(:); 1]; % Harmonize
         dCoord_data = o.dTInv*dCoord_world;    % Permutation & Scaling
         dCoord_data = dCoord_data(1:3) + 1; % Compensate for matlab indexing and de-harmonize
      end
   end
   
end