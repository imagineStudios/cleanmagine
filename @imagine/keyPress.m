function keyPress(o, hSource, eventdata)

persistent lLoopDir
persistent lastTime

if isempty(lLoopDir)
    lLoopDir = false;
end
if isempty(lastTime)
    lastTime = -1;
end


% Zoom levels for the Cntl+/- commands
dZOOMFACTORS = [0.1 0.175 0.25 0.33 0.5 0.66 1 1.5 2 3 4 6 8 12 16 24 32];
% dSECOND = 1/(24*60*60);

% -------------------------------------------------------------------------
% Reduce key repetition rate to amout set by slider
% dFPS = obj.getSlider('Keyboard FPS');
% dDelay = dSECOND/dFPS;
% dNow = now;
% if dNow - lastTime < dDelay
%     return
% end
% lastTime = dNow;
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Bail if only a modifier has been pressed. For some reason the mac command
% and fn keys are represented as '0'
if any(strcmp(eventdata.Key, {'shift', 'control', 'alt'})) || ...
        (strcmp(eventdata.Key, '0') && isempty(eventdata.Character))
    switch eventdata.Key
        case 'shift', o.SAction.lShift = true;
        case 'control', o.SAction.lControl = true;
        case 'alt', o.SAction.lAlt = true;
    end
    return
end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Get the modifier (shift, cntl, cmd, alt) keys
iModifier = 0;
if any(strcmp(eventdata.Modifier, 'shift'))         , iModifier = iModifier + 1; end;
if any(strcmp(eventdata.Modifier, 'control')) || ...
   any(strcmp(eventdata.Modifier, 'command'))       , iModifier = iModifier + 2; end;
if any(strcmp(eventdata.Modifier, 'alt'))           , iModifier = iModifier + 4; end;
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Look for buttons with corresponding accelerators/modifiers and trigger
% their callback
% iI = find(strcmp(eventdata.Key, {o.SMenu.Accelerator}) & iModifier == [o.SMenu.Modifier]);
% if ~isempty(iI)
%     o.iconDown(o.SMenu(iI).Name, eventdata);
%     return
% end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Functions not implemented by buttons
switch iModifier
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    % No modifier
    case 0
        switch eventdata.Key
            
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Image up
            case 'uparrow'
                changeImg(o, hSource, -1);
                
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -    
            % Image down
            case 'downarrow'
                changeImg(o, hSource, 1);
                
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -    
            % Series up
            case 'leftarrow'
                
                lShift = o.SAction.lShift;
                o.SAction.lShift = true;
                changeImg(o, hSource, -1);
                o.SAction.lShift = lShift;
                
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -    
            % Series down
            case 'rightarrow'
                lShift = o.SAction.lShift;
                o.SAction.lShift = true;
                changeImg(o, hSource, 1);
                o.SAction.lShift = lShift;
                
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Loop through series in a 1->end fashion
            case {'period', 'comma'}
                if isempty(o.hViews(1).hData), return, end
                
                iNTime = o.hViews(1).hData(1).getSize(4);
                if strcmp(eventdata.Key, 'period')
                    iT = mod(o.hViews(1).DrawCenter(4), iNTime) + 1;
                else
                    if o.hViews(1).DrawCenter(4) == 1, lLoopDir = true; end
                    if o.hViews(1).DrawCenter(4) == iNTime, lLoopDir = false; end
                    iT = o.hViews(1).DrawCenter(4) - 1 + 2.*uint8(lLoopDir);
                end
                
                for iI = 1:numel(o.hViews)
                    o.hViews(iI).DrawCenter(4) = iT;
                end
                o.draw;
                o.hViews.showTimePoint;
            
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Temporarily switch to cursor tool
            case 'space' 
                if o.SAction.iOldToolInd == 0
                    iInd = find([o.SMenu.GroupIndex] == 255 & [o.SMenu.Active]);
                    o.SAction.iOldToolInd = iInd;
                    for iI = find([o.SMenu.GroupIndex] == 255)
                        o.SMenu(iI).Active = strcmp(o.SMenu(iI).Name, 'cursor');
                    end
                    o.updateActivation;
                end
            
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Cycle colormaps
            case 'tab'
                csColormaps = o.getColormaps;
                iInd = find(strcmp(o.sColormap, csColormaps));
                iInd = mod(iInd, length(csColormaps)) + 1;
                o.setColormap(csColormaps{iInd});
                o.tooltip(o.sColormap);
        end
         
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    % Shift
    case 1 
        switch eventdata.Key
            
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Cycle Tools
            case 'space' 
                iTools   = find([o.SMenu.GroupIndex] == 255 & [o.SMenu.Enabled]);
                iToolInd = find(strcmp({o.SMenu.Name}, o.getTool));
                iToolIndInd = find(iTools == iToolInd);
                iTools = [iTools(end), iTools, iTools(1)];
                iToolIndInd = iToolIndInd + 2;
                iToolInd = iTools(iToolIndInd);
                o.iconClick(o.SImgs.hIcons(iToolInd), eventdata);
                o.tooltip(o.SMenu(iToolInd).Tooltip);
            
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Cycle colormaps (reverse)
            case 'tab'
                csColormaps = o.getColormaps;
                iInd = find(strcmp(o.sColormap, csColormaps));
                iInd = mod(iInd - 2, length(csColormaps)) + 1;
                o.setColormap(csColormaps{iInd});
                o.tooltip(o.sColormap);

        end
        
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    % Command / Control
    case 2
        switch eventdata.Character
            
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Toggle Grid
            case 'g'
                if o.dGrid ~= -1
                    if o.dGrid
                        o.dGrid = 0;
                    else
                        o.dGrid = 1;
                    end
                    o.resize(0);
                end
            
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Toggle Ruler
            case 'r' 
                o.lRuler = ~o.lRuler;
                o.resize(0);
            
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Zoom in
            case {'+', '-'}
                dMinus = double(eventdata.Character == '-');
                for iI = 1:length(o.hViews)
                    dDiff = dZOOMFACTORS - o.hViews(iI).Zoom;
                    [dVal, iPos] = min(abs(dDiff));
                    if dVal == 0.0 % Zoom was on a discrete level
                        iPos = iPos + 1 - 2.*dMinus;
                    else
                        iPos = find(dDiff > 0, 1, 'first') - dMinus;
                    end
                    iPos = min(length(dZOOMFACTORS), max(1, iPos));
                    o.hViews(iI).Zoom = dZOOMFACTORS(iPos);
                end
%                 obj.tooltip(sprintf('%d %%', uint16(obj.SData(obj.iStartSeries).dZoom.*100)));
                o.tooltip(sprintf('%d %%', dZOOMFACTORS(iPos)*100));
                o.hViews.position();
                o.draw();
                o.hViews.grid();
                
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Set mask opacity
            case {'1', '2', '3', '4', '5', '6', '7', '8', '9'}
                dMaskOpacity = double(eventdata.Character - '0')./10;
                set(o.SScatters.hSlider(5), 'XData', dMaskOpacity);
                o.draw;
                o.tooltip(sprintf('Mask Opacity: %d %%', uint8(dMaskOpacity*100)));
        end
                
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    % Command + Shift
    case 3
        switch eventdata.Key
            
            case 'd' % Debug entry point
               if o.lDebug
                  SStack = dbstack;
                  eval(sprintf('dbstop in %s at %d', SStack(1).name, SStack(1).line + 2));
                  pause(0.1);
               end
                
        end

end
% -----------------------------------------------------------------
set(o.hF, 'SelectionType', 'normal');
end