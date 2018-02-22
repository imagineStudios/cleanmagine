function [dImg, cAdditionalInputs] = fStruct2Params(SImg)

dImg = [];
cAdditionalInputs = {};

if ~isscalar(SImg)
    error('So far only scalar struct inputs supported - sorry!');
end

% -------------------------------------------------------------------------
% Define a mapping structure for fields
% SMapping = struct('Source', 'Target', 'Tolerance');

SMapping(1).Source = {'aspect', 'res', 'resolution'};
SMapping(1).Target = 'resolution';

SMapping(2).Source = {'org', 'origin'};
SMapping(2).Target = 'origin';

SMapping(3).Source = {'units'};
SMapping(3).Target = 'units';

SMapping(4).Source = {'orient', 'orientation'};
SMapping(4).Target = 'orientation';

SMapping(5).Source = {'name', 'sname'};
SMapping(5).Target = 'name';
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Parse all fields of the struct
csFields = fieldnames(SImg);
for iI = 1:length(csFields)
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    % Check for image data
    if any(strcmpi({'img', 'image', 'data', 'dImg'}, csFields{iI}))
        dImg = SImg.(csFields{iI});
        continue
    end
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    % Check for properties defined in the mappign structure
    for iJ = 1:length(SMapping)
        if any(strcmpi(csFields{iI}, SMapping(iJ).Source))
            xVal = SImg.(csFields{iI});
            cAdditionalInputs = [cAdditionalInputs, SMapping(iJ).Target, xVal];
            break
        end
    end
    
end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Throw error if no image data could be identified
if isempty(dImg)
    error('Could not identify any image data in struct input!');
end