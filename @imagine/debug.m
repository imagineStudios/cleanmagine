function debug(o, sMessage, varargin)

if o.lDebug
   SStack = dbstack(1, '-completenames');
   
   iInd = find(SStack(1).file == '@');
   if ~isempty(iInd)
      sCaller = SStack(1).file(iInd + 1:end - 2);
      sCaller = strrep(sCaller, filesep(), '.');
   else
      sCaller = SStack(1).name;
   end
   
   iLine = SStack(1).line;
   
   fprintf(['%s(%d): ', sMessage], sCaller, iLine, varargin{:});
end