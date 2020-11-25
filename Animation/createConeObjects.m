function ConeObjects = createConeObjects(figAxes, ConeRes, yShift, rFoot, rShank, rThigh, rHAT_Cone, rAmputeeThigh, intactFlag, yShiftGlobal)

if nargin < 11
    yShiftGlobal = 0;
end

ConeCol2 = [1 1 0.99];
ConeCol  = [0.8 0.8 0.7];
if intactFlag
    ConeCol3 = [1 1 0.99];
else
    ConeCol3 = [0.5 0.5 0.5];
end
% HAT cone
[x,y,z] = cylinder( rHAT_Cone, ConeRes);
HAT_ConeObj = surf(figAxes,  1.3*x, 2.2*y + yShiftGlobal, z, 'FaceColor', ConeCol);

% thigh cones
[xt,yt,zt] = cylinder( rThigh, ConeRes);
L_ThighObj = surf(figAxes,  xt, yt + yShift + yShiftGlobal, zt, 'FaceColor', ConeCol2);

% shank cones
[xs,ys,zs] = cylinder( rShank, ConeRes);
L_ShankObj = surf(figAxes,  xs, ys + yShift + yShiftGlobal, zs, 'FaceColor', ConeCol2);

% feet cone
[xf,yf,zf] = cylinder( rFoot, ConeRes);
L_BallObj = surf(figAxes,  xf, yf + yShift + yShiftGlobal, zf, 'FaceColor', ConeCol2);
L_HeelObj = surf(figAxes,  xf, yf + yShift + yShiftGlobal, zf, 'FaceColor', ConeCol2);

if (intactFlag)
    R_ThighObj = surf(figAxes,  xt, yt - yShift + yShiftGlobal, zt, 'FaceColor', ConeCol);
    R_ShankObj = surf(figAxes,  xs, ys - yShift + yShiftGlobal, zs, 'FaceColor', ConeCol3);
    R_BallObj  = surf(figAxes,  xf, yf - yShift + yShiftGlobal, zf, 'FaceColor', ConeCol3);
    R_HeelObj  = surf(figAxes,  xf, yf - yShift + yShiftGlobal, zf, 'FaceColor', ConeCol3);

else
    [xt,yt,zt] = cylinder( rAmputeeThigh, ConeRes);
    R_ThighObj = surf(figAxes,  xt, yt - yShift + yShiftGlobal, zt, 'FaceColor', ConeCol);
    R_ShankObj = [];
    R_BallObj = [];
    R_HeelObj = [];
end

ConeObjects = [HAT_ConeObj, L_ThighObj, L_ShankObj, L_BallObj, L_HeelObj, R_ThighObj, R_ShankObj, R_BallObj, R_HeelObj];


% set general properties
set(ConeObjects, 'Visible', 'off', 'EdgeColor', 'none', ...
    'BackFaceLighting', 'unlit');
end
