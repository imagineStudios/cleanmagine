function delete(o)

try
   % -------------------------------------------------------------------------
   % Stop and delete the timers
   % if ~isempty(o.STimers)
   %    csTimers = fieldnames(o.STimers);
   %    for iI = 1:length(csTimers)
   %       stop(o.STimers.(csTimers{iI}));
   %       delete(o.STimers.(csTimers{iI}));
   %    end
   % end
   % ------------------------------------------------------------------------
   for iI = 1:length(o.csDeleteHandles)
      hHandle = o.(o.csDeleteHandles{iI});
      for iJ = 1:numel(hHandle)
         if isvalid(hHandle(iJ))
            delete(hHandle(iJ));
            o.debug('Deleting %s(%d)\n', o.csDeleteHandles{iI}, iJ);
         end
      end
   end
   o.debug('Deleting object.\n');
   delete@handle(o);
catch me
   if isvalid(o.hF)
      delete(o.hF);
   end
   o.debug('Deleting object.\n');
   delete@handle(o);
   rethrow(me);
end