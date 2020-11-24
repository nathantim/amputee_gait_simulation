% -----------------
% Create Prosthetic
% -----------------

function [prosthSphereObjects, prosthLinkObjects] = createProstheticObjects(yShift,SphereRes,ConeRes,rKJ,rAJ,rCP,amputeeFactor, rCMG, yShiftGlobal)
if nargin < 9
    yShiftGlobal = 0;
end
b_showColors = false;
JointCol2     = [0.3 0.3 0.3];
ContPointCol2 = [0.2 0.2 0.2];
ConeCol3 = [0.5 0.5 0.5];

rLC  = 0.04*rKJ;
rJ  = 0.002;%
% Factor for scaling spheres
rAJP = amputeeFactor*rAJ;
rCPP = amputeeFactor*rCP;

rFootProsth     = [rCPP rCPP]*2/3; %[m]
% rShankProsth    = [rAJP-0. rAJP rAJP-0.02 rLC]; %[m]
rShankProsth    = [rAJP*0.25 rAJP*0.25 rAJP*0.25 rAJP*0.25 rAJP*0.4 rAJP*0.5]; %[m]


[prosthSphereObjects, prosthLinkObjects] = create3R60Objects(SphereRes, yShift, rLC, rJ, ConeRes,b_showColors);

%% Create spheres
[x,y,z] = sphere(SphereRes);
P_AJ   = surf(rAJP*x, rAJP*y + yShift + yShiftGlobal, rAJP*z, 'FaceColor', JointCol2);
P_Ball = surf(rCPP*x, rCPP*y + yShift + yShiftGlobal, rCPP*z, 'FaceColor', ContPointCol2);
P_Heel = surf(rCPP*x, rCPP*y + yShift + yShiftGlobal, rCPP*z, 'FaceColor', ContPointCol2);

if ~isempty(rCMG)
    CMG   = surf(rCMG*x, rCMG*y - yShift + yShiftGlobal, rCMG*z, 'FaceColor', [0.1 0.1 0.8],'FaceAlpha',0.8);
else
    CMG = [];
end
    
prosthSphereObjects = [prosthSphereObjects; CMG; P_AJ; P_Ball; P_Heel];

set(prosthSphereObjects, 'Visible', 'off', 'EdgeColor', 'none', ...
        'BackFaceLighting', 'unlit');
    
%% Create cones
[xs,ys,zs] = cylinder( rShankProsth, ConeRes);
[xf,yf,zf] = cylinder( rFootProsth, ConeRes);

P_BallObj  = surf( xf, yf - yShift + yShiftGlobal, zf, 'FaceColor', ConeCol3);
P_HeelObj  = surf( xf, yf - yShift + yShiftGlobal, zf, 'FaceColor', ConeCol3);
P_ShankObj = surf( xs, ys - yShift + yShiftGlobal, zs, 'FaceColor', ConeCol3);

if ~isempty(rCMG)
    CMGlink   = surf(xs, ys - yShift + yShiftGlobal, zs, 'FaceColor', ConeCol3);
else
    CMGlink = [];
end

prosthLinkObjects = [prosthLinkObjects; CMGlink; P_ShankObj; P_BallObj; P_HeelObj];
set(prosthLinkObjects, 'Visible', 'off', 'EdgeColor', 'none', ...
    'BackFaceLighting', 'unlit');
end
