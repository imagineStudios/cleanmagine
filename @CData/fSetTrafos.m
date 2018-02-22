function fSetTrafos(o)

switch (o.Orientation)
   case 'cor', dPerm = [0 1 0 0; 0 0 1 0; -1 0 0 0; 0 0 0 1];
   case 'sag', dPerm = [0 0 1 0; 0 1 0 0; -1 0 0 0; 0 0 0 1];
   case 'tra', dPerm = [0 1 0 0; 1 0 0 0;  0 0 1 0; 0 0 0 1];
   case 'nat', dPerm = [0 1 0 0; 1 0 0 0;  0 0 1 0; 0 0 0 1];
   otherwise
      error('Undefined data orientation "%s"!', o.Orientation);
end

% Calculate harmonized transformation matrices and it's inverse.

% Permutation matrix
o.dP = abs(dPerm);
dSign = dPerm'*ones(4, 1);

% Scaling matrix matrix (includes inversion)
o.dS = diag([o.Res(1:3); 1].*dSign);
o.dS(1:3, 4) = o.Origin(1:3);
o.dSInv = inv(o.dS);

% Combined trafo
o.dT = o.dP*o.dS;
o.dTInv = inv(o.dT);