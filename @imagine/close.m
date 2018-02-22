function close(o, ~, ~)

% -------------------------------------------------------------------------
% Save settinge and close figure, delete object
try
   % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   % Save settings (only if executed as a callback)
   for iI = 1:length(o.csSaveVars)
      sVar = o.csSaveVars{iI};
      SSave.(sVar) = o.(sVar); %#ok<STRNU>: Saved to file
   end
   save([o.sBasePath, filesep(), '.settings.mat'], '-struct', 'SSave');
   
%    SSave.sPath         = o.sPath;
%    SSave.lRuler        = o.lRuler;
%    SSave.dGrid         = max(0, o.dGrid);
%    SSave.l3DMode       = o.isOn('3d');
%    SSave.lDocked       = strcmp(get(o.hF, 'WindowStyle'), 'docked');
%    SSave.iIconSize     = o.iIconSize;
%    SSave.sTheme        = o.sTheme;
   
   % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   % Delete and close
   delete(o);
catch me % if you can
   % Just to make sure that the figure is closed. Super annoying if there is an error here
   delete(o);
   rethrow(me);
end
% -------------------------------------------------------------------------