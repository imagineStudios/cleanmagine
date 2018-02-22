function parseInputs(o, varargin)

% -------------------------------------------------------------------------
% Process the first input, which has to contain the image data

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Validate data type
validateattributes(varargin{1}, {'numeric', 'logical', 'struct'}, {});

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% If it is a struct, process it into image data and cell of parameters
if length(varargin) > 1
   cParams = varargin(2:end);
else
   cParams = {};
end

if isstruct(varargin{1})
   [dImg, cAdditionalParams] = iGlobals.fStruct2Params(varargin{1});
   cParams = [cParams, cAdditionalParams];
else
   dImg = varargin{1};
end


% -------------------------------------------------------------------------
% Get the histogram and dynamic range from the input data
if isinteger(dImg)
   if numel(dImg) > 1E6
      [o.Hist, o.HistCenter] = hist(double(dImg(1:100:end)), 256);
   else
      [o.Hist, o.HistCenter] = hist(double(dImg(:)), 256);
   end
else
   if isreal(dImg)
      if numel(dImg) > 1E6
         [o.Hist, o.HistCenter] = hist(dImg(1:100:end), 256);
      else
         [o.Hist, o.HistCenter] = hist(dImg(:), 256);
      end
   else
      if numel(dImg) > 1E6
         [o.Hist, o.HistCenter] = hist(abs(dImg(1:100:end)), 256);
      else
         [o.Hist, o.HistCenter] = hist(abs(dImg(:)), 256);
      end
   end
end
o.Window(1) = o.HistCenter(1);
o.Window(2) = o.HistCenter(end);
if diff(o.Window) == 0, o.Window(2) = o.Window(1) + 1; end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Parse optional parameter-value pairs
hP = inputParser;

% hValidFcn = @(x) validatestring(x, {'scalar', 'categorical', 'rgb', 'vector'});
hP.addParameter('Name', '', @ischar);
hP.addParameter('Resolution', []);
hP.addParameter('Origin', []);
hP.addParameter('Units', 'px', @ischar);
hP.addParameter('TemporalUnits', '', @ischar);

hP.addParameter('Type', '');

hP.addParameter('Orientation', 'native', @ischar);
hP.addParameter('Source', 'startup', @ischar);

hP.addParameter('Window', []);
hP.addParameter('Views', []);
hP.addParameter('Alpha', 1);

hP.parse(cParams{:});

sType = hP.Results.Type;
o.Name = hP.Results.Name;
o.TemporalUnits = hP.Results.TemporalUnits;
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% Figure out data type and do necessary permutation
lReal = isreal(dImg);
switch ndims(dImg)
   
   case 2
      if strcmpi(sType, 'rgb') || strcmpi(sType, 'vector')
         error('2D data connot be RGB or Vector data!');
      end
      if isempty(sType), sType = 'scalar'; end
      o.dImg = dImg;
      o.Type = sType;
      
   case 3
      if size(dImg, 3) == 3 && ~(strcmp(sType, 'scalar') || strcmp(sType, 'categorical')) && lReal % Assume RGB data
         if isempty(sType), sType = 'rgb'; end
         o.dImg = permute(dImg, [1 2 5 4 3]);
         o.Type = sType;
      else
         if strcmpi(sType, 'rgb') || strcmpi(sType, 'vector')
            error('Data is declared RGB or Vector, but 3rd dimension is not of size 3!');
         end
         if isempty(sType), sType = 'scalar'; end
         o.dImg = dImg;
         o.Type = sType;
      end
      
   case 4
      if size(dImg, 3) == 3 && ~(strcmp(sType, 'scalar') || strcmp(sType, 'categorical')) && lReal % Assume RGB Video
         if isempty(sType), sType = 'rgb'; end
         o.dImg = permute(dImg, [1 2 5 4 3]);
         o.Type = sType;
      else
         if strcmpi(sType, 'rgb') || strcmpi(sType, 'vector')
            error('Data is declared RGB or Vector, but 3rd dimension is not of size 3!');
         end
         if isempty(sType), sType = 'scalar'; end
         o.dImg = dImg;
         o.Type = sType;
      end
      
   case 5 % can only be 3D Vector data
      if strcmp(sType, 'scalar') || strcmp(sType, 'categorical')
         error('5D data can only be of type RGB or vector!');
      end
      if ~lReal
         error('5D data must be real!');
      end
      i3Ind = size(dImg) == 3;
      i3Ind = i3Ind(i3Ind > 2);
      switch length(i3Ind)
         case 0
            error('5D data supplied, but no dimension is of size 3!');
            
         case 1
            iPermutation = [1 2 3 4 d3Ind];
            iPermutation(d3Ind) = 5;
            o.dImg = permute(dImg, iPermutation);
            
         otherwise
            if any(i3Ind == 5)
               o.dImg = dImg;
            else % (3 or 4)
               o.dImg = permute(dImg, [1 2 3 5 4]);
            end
      end
      if isempty(sType), sType = 'vector'; end
      o.Mode = sType;
      
   otherwise
      error('Allowed number of input dimensions is 2-5');
      
end

% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% Handle the orientation data
o.Orientation = hP.Results.Orientation;
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Supplement the coordinate system data according to what's been supplied
if isempty(hP.Results.Resolution)
   if ~isempty(hP.Results.Origin)
      o.Origin = hP.Results.Origin(:);
   else
      o.fSetTrafos();
   end
   if isempty(hP.Results.Units)
      o.SpatialUnits = 'px';
   else
      o.SpatialUnits = hP.Results.Units;
   end
else
   o.Res = hP.Results.Resolution(:);
   % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   % Resolution given
   if isempty(hP.Results.Origin) % Assume user wants 0 as data origin
      o.Origin = [0 0 0 0]';
   else
      o.Origin = hP.Results.Origin(:);
   end
   if isempty(hP.Results.Units) % Assume mm resolution
      o.SpatialUnits = 'mm';
   else
      o.SpatialUnits = hP.Results.Units;
   end
end
% -------------------------------------------------------------------------