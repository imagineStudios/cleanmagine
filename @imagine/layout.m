function layout(o, iNViews)
% Sets the GUI layout. Triggered whenever layout or 3d mode changes.

o.iNViews = iNViews;

% -------------------------------------------------------------------------
% Create new or delete obsolete views
iNExistingViews = length(o.hViews);
iNTargetViews = prod(iNViews);

if iNTargetViews < iNExistingViews
   % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   % Delete obsolete views
   delete(o.hViews(iNTargetViews + 1:iNExistingViews));
   lKeep = ~isvalid(o.hViews);
   o.hViews = o.hViews(lKeep);
   o.debug('Deleted %d view(s)!\n', nnz(~lKeep));
   
elseif iNTargetViews > iNExistingViews
   % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   % Create the new views
   for iI = iNExistingViews + 1:iNTargetViews
      o.hViews(iI) = CView(o, iI);
      o.debug('Creating new view %d!\n', iI);
   end
end

% -------------------------------------------------------------------------
% Assign views to the view groups
iViewsPerGroup = 1 + 2.*double(o.l3D);
csOrientations = {'cor', 'sag', 'tra'};
for iView = 1:iNTargetViews
   iGroup = floor((iView - 1)./iViewsPerGroup) + 1;
   if o.l3D
      sOrientation = csOrientations{mod(iView - 1, iViewsPerGroup) + 1};
   else
      hFirstData = o.hViewGroups(iGroup).Data(1);
      if ~isempty(hFirstData)
         sOrientation = hFirstData.Orientation;
      else
         sOrientation = 'nat';
      end
   end
   o.debug('Assigning view %d to group %d, %s orientation.\n', iView, iGroup, sOrientation);
   o.hViews(iView).ViewGroup = o.hViewGroups(iGroup);
   o.hViews(iView).Orientation = sOrientation;
end

% -------------------------------------------------------------------------
% Make sure all views have adequate number of image components, position and draw
o.hViews.updateImages();
if strcmp(get(o.hF, 'Visible'), 'on')
   o.resize(o.hF); % Assign correct positioning to all views
   o.draw();
end