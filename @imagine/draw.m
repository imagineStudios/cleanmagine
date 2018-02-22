function draw(o, ~, ~)

% -------------------------------------------------------------------------
% Timer logic for hd mode
% if nargin > 1
%    Stop timer to make sure it doesn't fire again
%    stop(o.STimers.hDrawFancy);
%    lHD = o.isOn('hd');
% else
%    if o.isOn('hd')
%       Reset and start timer
%       stop(o.STimers.hDrawFancy);
%       start(o.STimers.hDrawFancy);
%    end
%    lHD = false;
% end
lHD = false;
l3D = false;
o.hViews.draw(l3D, lHD);
% -------------------------------------------------------------------------
