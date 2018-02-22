function plus(o, varargin)
%PLUS Add a new series to the data structure
% PLUS(OBJ, DIMG, VARARGIN) Adds the data in structure SNEWDATA to the
% GUI's data structure. Depending on the dimensions of SNEWDATA.dIMG, it
% decides wether the data is to be interpretet as RGB of scalar data. It is
% treated as RGB, if size(SNEWDATA.dImg, 3) == 3. If not 3 but greater than
% 1, the third dimension is treated as the 3rd dimension.


% -------------------------------------------------------------------------
% Prepare template data structure for new entry
iDataInd = length(o.hData) + 1;
o.hData(iDataInd) = CData(iDataInd, varargin{:});
o.debug('Adding New Dataset "%s" at index %d.\n', o.hData(iDataInd).Name, iDataInd);
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Determine to which view group the new data has to be added. If no view group supplied
% explicitely, add a new view
hP = inputParser;
hP.KeepUnmatched = true;
hValidFcn = @(x) validateattributes(x, {'numeric'}, {'vector', 'positive'});
hP.addParameter('View', [], hValidFcn);
hP.parse(varargin{2:end});
if isempty(hP.Results.View)
   iGroup = 1;
   while ~isempty(o.hViewGroups(iGroup).Data) && iGroup < prod(o.iMAXVIEWS)
      iGroup = iGroup + 1;
   end
else
   iGroup = hP.Results.View;
end
o.hViewGroups(iGroup).addData(o.hData(iDataInd));
% -------------------------------------------------------------------------

o.hViews.updateImages();




% -------------------------------------------------------------------------
% Update global drawing parameters
% dAllRes = obj.hData.getRes();
% obj.dMinRes = min(dAllRes, [], 1);
% -------------------------------------------------------------------------