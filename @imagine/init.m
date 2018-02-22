function init(o)

fs = filesep();

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Init the action structure
o.SAction.lShift = false;
o.SAction.lControl = false;
o.SAction.lAlt = false;
o.SAction.sSelectionType = 'normal';
o.SAction.lMoved = false;
o.SAction.iOldToolInd = 0;

% -------------------------------------------------------------------------
% Get defaults and load settings from file

fReadSettings(o);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Make sure the figure fits on the screen
iScreenSize = get(0, 'ScreenSize');
iDefaultPosition = [200, 200, iScreenSize(3:4) - 400];
if ~isempty(o.iPosition)
   if (o.iPosition(1) + o.iPosition(3) > iScreenSize(3)) || (o.iPosition(2) + o.iPosition(4) > iScreenSize(4))
      o.iPosition(1:2) = iDefaultPosition;
   end
else
   o.iPosition(1:2) = iDefaultPosition;
end

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Default Colors
o.Colors.bg_dark = [0 0 0];
o.Colors.bg_normal = [0 0 0];
o.Colors.bg_light = [0 0 0];
o.Colors.accent1 = [255 255 255];

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Load theme colors
hDOM = xmlread([o.sBasePath, fs, '..', fs, 'themes', fs, o.sTheme, fs, 'colors.xml']);
hColors = hDOM.getElementsByTagName('color');
for iI = 0:hColors.getLength - 1
   sName = hColors.item(iI).getAttribute('Name');
   dR    = str2double( hColors.item(iI).getElementsByTagName('red').item(0).getTextContent );
   dG    = str2double( hColors.item(iI).getElementsByTagName('green').item(0).getTextContent );
   dB    = str2double( hColors.item(iI).getElementsByTagName('blue').item(0).getTextContent );
   o.Colors.(char(sName)) = [dR dG dB]./255;
end

% -------------------------------------------------------------------------
% Create the view gropus
for iI = 1:prod(o.iMAXVIEWS)
   o.hViewGroups(iI) = CViewGroup(o, iI);
end

% -------------------------------------------------------------------------
% Create the main figure
o.hF = figure(...
   'Visible'               , 'off', ...
   'BusyAction'            , 'cancel', ...
   'Interruptible'         , 'off', ...
   'Color'                 , o.Colors.bg_normal, ...
   'Colormap'              , gray(256), ...
   'MenuBar'               , 'none', ...
   'NumberTitle'           , 'off', ...
   'Name'                  , ['IMAGINE ', o.sVERSION], ...
   'CloseRequestFcn'       , @o.close, ...
   'ResizeFcn'             , @o.resize, ...
   'WindowKeyPressFcn'     , @o.keyPress, ...
...'WindowKeyReleaseFcn'   , @o.keyRelease, ...
   'WindowButtonMotionFcn' , @o.mouseMove, ...
   'WindowScrollWheelFcn'  , @o.changeImg);
   
if ~isempty(o.iPosition)
   try
      set(o.hF, 'Position', o.iPosition);
   catch
      o.iPosition = iDefaultPosition;
      set(o.hF, 'Position', o.iPosition);
   end
else
   set(o.hF, 'WindowStyle', 'docked');
end
% -------------------------------------------------------------------------


% ---------------------------------------------------------------------
% Timer objects to realize delayed actions (like hiding of tooltip)
% o.STimers.hGrid      = timer('Name', 'grid', 'StartDelay', 0.5, 'UserData', 'Imagine', 'TimerFcn', @o.restoreGrid);
% o.STimers.hIcons     = timer('Name', 'icons', 'StartDelay', 0.1, 'UserData', 'Imagine', 'TimerFcn', @o.resize);
% o.STimers.hDrawFancy = timer('Name', 'drawFancy', 'StartDelay', 0.1, 'UserData', 'Imagine', 'TimerFcn', @o.draw);
%     o.STimers.hDraw      = timer('ExecutionMode', 'fixedRate', 'Period', 1, 'UserData', 'Imagine', 'TimerFcn', @o.updateData, 'BusyMode', 'drop');
% ---------------------------------------------------------------------

% ---------------------------------------------------------------------
% Create the bars that contain icons (menu, toolbar and sidebar,
% context menu)

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Toolbar
% o.SAxes.hTools = axes(...
%    'Parent'       , o.hF, ...
%    'Units'        , 'pixels', ...
%    'YDir'         , 'reverse', ...
%    'Hittest'      , 'off', ...
%    'Visible'      , 'off');
% hold on
%
% o.SImgs.hTools = image(...
%     'CData'             , permute(o.SColors.bg_normal, [1 3 2]), ...
%     'XData'             , [1, 128], ...
%     'YData'             , [1, 2000]);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Menubar
% o.SAxes.hMenu  = axes(...
%    'Units'             , 'pixels', ...
%    'YDir'              , 'reverse', ...
%    'Hittest'           , 'off', ...
%    'Visible'           , 'off');
% hold on

% o.SImgs.hMenu = image(...
%    'CData'             , 0, ...
%    'XData'             , [1, 2000]);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Context menu
% o.SAxes.hContext = axes(...
%    'Parent'            , o.hF, ...
%    'Units'             , 'pixels', ...
%    'Position'          , [1 1 1 1], ...
%    'YLim'              , [0.5 1.5], ...
%    'YDir'              , 'reverse', ...
%    'XTick'             , [], ...
%    'YTick'             , [], ...
%    'Visible'           , 'off', ...
%    'Hittest'           , 'off');
% hold on

% ---------------------------------------------------------------------


% ---------------------------------------------------------------------
% Load the icons of the menubar, menubar and sidebar and context menu
% for iI = 1:length(o.SMenu)
%
%    hParent = o.SAxes.hMenu;
%    if o.SMenu(iI).SubGroupInd
%       hParent = o.SAxes.hContext;
%    else
%       if o.SMenu(iI).GroupIndex == 255
%          hParent = o.SAxes.hTools;
%       end
%    end
%
%    o.SImgs.hIcons(iI)  = image(...
%       'Parent'        , hParent, ...
%       'CData'         , 1, ...
%       'AlphaData'     , 1);
% end
% ---------------------------------------------------------------------


% ---------------------------------------------------------------------
% The utility axis
% o.SAxes.hUtil = axes(...
%    'Parent'                , o.hF, ...
%    'Visible'               , 'off', ...
%    'Units'                 , 'pixels', ...
%    'Position'              , [1 1 1 1], ...
%    'YDir'                  , 'reverse', ...
%    'Hittest'               , 'off', ...
%    'Visible'               , 'off');
% o.SImgs.hUtil = image(...
%    'Parent'                , o.SAxes.hUtil, ...
%    'CData'                 , 0, ...
%    'Visible'               , 'off');
% -------------------------------------------------------------------------

% o.hTooltip = CTooltip(o.hF, o.SColors.bg_light);


function fReadSettings(o)
% -------------------------------------------------------------------------
% Read the preferences from the save file and determine figure size

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Read saved preferences from file
sSaveFile = [o.sBasePath, filesep(), '.settings.mat'];
if exist(sSaveFile, 'file')
   o.debug('Loading settings from file:\n');
   load(sSaveFile);
   
   for iI = 1:length(o.csSaveVars)
      sVar = o.csSaveVars{iI};
      if exist(sVar, 'var')
         o.debug(' - %s\n', sVar);
         eval(sprintf('o.%s = %s;', sVar, sVar));
      end
   end
else
   o.debug('No settings found -- using defaults.\n');
end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Read the menu and slider definitions
% S = load([o.sBasePath, fs, 'Menu.mat']);
% o.SMenu = S.SMenu;
% -------------------------------------------------------------------------

% o.SMenu = o.SMenu(~[o.SMenu.WIP]);
