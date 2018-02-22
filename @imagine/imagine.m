classdef imagine < handle
   %IMAGINE IMAGe visualization and evaluation engINE
   %
   %   IMAGINE starts the IMAGINE user interface without initial data
   %
   %   IMAGINE(DATA) Starts the IMAGINE user interface with one (DATA is 3D)
   %   or multiple panels (DATA is 4D).
   %
   %   IMAGINE(DATA, PROPERTY1, VALUE1, ...)) Starts the IMAGINE user
   %   interface with data DATA plus supplying some additional information
   %   about the dataset in the usual property/value pair format. Possible
   %   combinations are:
   %
   %       PROPERTY        VALUE
   %       -------------------------------------------------------------------
   %       'Name'          String: A name for the dataset
   %       'Resolution'    [3x1] or [1x3] double: The voxel size of the first
   %                       three dimensions of DATA.
   %       'Units'         String: The physical unit of the pixels (e.g. 'mm')
   %       'Zoom'          Initial zoom level for DATA (scalar)
   %       'Window'        [1x2] double vector indicating the initial lower
   %                       and upper intensity values used for the scaling of
   %                       intensity.
   %
   %   IMAGINE(DATA1, DATA2, ...) Starts the IMAGINE user interface with
   %   multiple panels, where each input can be either a 3D- or 4D-array. Each
   %   dataset can be defined more detailedly with the properties above.
   %
   %
   % Examples:
   %
   % 1. >> load mri % Gives variable D
   %    >> imagine(squeeze(D)); % squeeze because D is in rgb format
   %
   % 2. >> load mri % Gives variable D
   %    >> imagine(squeeze(D), 'Name', 'Head T1', 'Resolution', [2.2 2.2 2.2*2.7], 'Orient', 'tra');
   % This syntax gives a more realistic aspect ration if you rotate the data.
   %
   % For more information about the IMAGINE functions refer to the user's
   % guide file in the documentation folder supplied with the code.
   %
   % Copyright 2016 Christian Wuerslin
   % Contact: c.wuerslin@gmail.com
   
   % =====================================================================
   properties (Constant)
      sVERSION          = 'Cleanmagine'        % Figure title
      iMAXVIEWS         = [6, 4]               % Maximum nuimber of views in X and Y
   end
   
   properties
      Colors
      ScreenSize_inch  = 15.4
   end
   
   properties (Access = private)
      hF                = matlab.ui.Figure.empty() % The main figure
      hViewGroups       = CViewGroup.empty()
      hViews            = CView.empty()
      hData             = CData.empty()
      sBasePath
      sWorkingPath      = pwd % The working directory
      iPosition         = []
      sTheme            = 'default'
      iNViews           = [2, 2]
      l3D               = true
      dColWidth         = [1 1 1 1 1 1]
      dRowHeight        = [1 1 1 1 1 1]
      iIconSize         = 64
      SAction
      lRuler            = true
      
      lDebug            = true
      
      csSaveVars        = {'sWorkingPath', 'sTheme', 'iPosition'} % List of members to save/restore to/from settinges file
      csDeleteHandles   = {'hF', 'hViewGroups', 'hViews', 'hData'}      % List of members which are explicitely deleted on exit
   end
   % =====================================================================
   
   events
      drawEvent
      positionEvent
   end
      
   % =====================================================================
   methods (Access = public)
      
      % -----------------------------------------------------------------
      function o = imagine(varargin)
         %IMAGINE Constructor         
         if o.lDebug, clc, end
         
         o.sBasePath = fileparts(mfilename('fullpath'));
         try
            % Create all the GUI elements
            o.init();
            o.parseInputs(varargin{:});
            o.layout(o.iNViews);
         catch me
            o.delete();
            rethrow(me);
         end
         
         o.hF.Visible = 'on';
         
      end
      % END IMAGINE Constructor
      % -----------------------------------------------------------------
      
      delete(o)
      close(o, ~, ~)
      debug(o, sMessage, varargin)      
      layout(o, iNViews)
      plus(o, varargin)

      function hF = getFigure(o), hF = o.hF; end
      function l3D = get3DMode(o), l3D = o.l3D; end
      function hViewGroup = getViewGroup(o, iInd), hViewGroup = o.hViewGroups(iInd); end
   end
   % =====================================================================
   
   
   
   % =====================================================================
   methods (Access = private)
      
      init(o)
      parseInputs(o, varargin)
      
      % -----------------------------------------------------------------
      % Figure callbacks
      resize(o, hObject, eventdata)
      keyPress(o, hObject, eventdata)
      mouseMove(o, hObject, eventdata)
      draw(o, hObject, eventdata)
   end
   % =====================================================================
   
   
   
end
