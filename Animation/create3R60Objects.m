function [prosthSphereObjects, prosthLinkObjects] = create3R60Objects(figAxes, SphereRes, yShift, rLC, rJ, ConeRes,b_showColors)
%% Generate spherical objects prosthesis
if nargin < 8
    yShiftGlobal = 0;
end
% general sphere
[x,y,z] = sphere(SphereRes);
JointCol     = [0.8 0.8 1];

% make Ball, Heel, Ankle, Hip spheres and set their properties
%     thighConnect    = surf(rLC*x, rLC*y + yShift + yShiftGlobal, rLC*z, 'FaceColor', JointCol);
joint1          = surf(figAxes, rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
joint2          = surf(figAxes, rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
joint3          = surf(figAxes, rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
joint4          = surf(figAxes, rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
joint5          = surf(figAxes, rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
joint6          = surf(figAxes, rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
joint7          = surf(figAxes, rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
shankConnect    = surf(figAxes, rLC*x, rLC*y + yShift + yShiftGlobal, rLC*z, 'FaceColor', JointCol);



% change material properties of preceeding objects to shiny
material shiny
% generate objects vector
prosthSphereObjects = [joint1; joint2; joint3; joint4; joint5; joint6; joint7; shankConnect];

% set general properties
set(prosthSphereObjects, 'Visible', 'off', 'EdgeColor', 'none', ...
    'BackFaceLighting', 'unlit');

%% Generate cone link objects prosthesis
prosthLinkObjects = nan(12,1);
if b_showColors
    col134 = [84 130 53]./255;
    col131416 = [68 114 196]./255;
    col6 = [197 90 17]./255;
    col9 = [112 48 160]./255;
    col11 = [191 144 0]./255;
    colStanceHydElem = [0.57 1.0 0.31];
    colSwingHydElem = [0 0 0];
else
    col134 = [128 128 128]./255;
    col131416 = [128 128 128]./255;
    col6 = [128 128 128]./255;
    col9 = [128 128 128]./255;
    col11 = [128 128 128]./255;
    colStanceHydElem = [0 0 153]./255;
    colSwingHydElem = [0 0 153]./255;
end


rH = [ones(1,3)*rJ*0.5 ones(1,7)*rJ*1.2  ones(1,3)*rJ*0.5];
%% Rescale, bend, and deform some links
b_bendLinks = true;
resObject = 24;
yShift = zeros(resObject,12);
xShift = zeros(resObject,12);
    
scaleYfactor = 8;
scaleXfactor = 1;

[xLs,yLs,zLs] = cylinder(  ones(1,resObject)*rJ*0.5, ConeRes); % smaller
[xL,yL,zL] = cylinder(  ones(1,resObject)*rJ, ConeRes); 
[xH,yH,zH] = cylinder( rH, ConeRes); % hydraulic elements

% make flat ellips shaped cones
xLs = scaleXfactor*xLs;
xL = scaleXfactor*xL;
yLs = scaleYfactor*yLs;
yL = scaleYfactor*yL;

% Bend links
if b_bendLinks
    ySize = find(yL(1,:) == max(yL(1,:)),1,'first');
    
    xLbend = xL + 12E-3*repmat( [(1-((linspace(1,0,(ySize)))).^2), zeros(1,1+ConeRes-2*ySize) ,(1-((linspace(0,1,(ySize)))).^2)],[resObject,1]);
    xLbendReverse = xL - 2E-3*repmat( [zeros(1,ySize), (4-((linspace(0.1,2,(ConeRes-2*ySize)/2))).^2),0 ,(4-((linspace(2,0.1,(ConeRes-2*ySize)/2))).^2) zeros(1,ySize)],[resObject,1]);
    
    
    xShift(:,1) = -12E-3*(1-((linspace(0,1,(resObject))')-0.5).^2); % link1
    % yShift(:,1) = -8E-3*(1-((linspace(0,1,(resObject))')-0.5).^2).^2; % link1
    xShift(:,4) =  8E-3*[ (1-((linspace(1,0,(resObject*7/8))')).^2); (1-((linspace(0,1,(resObject*1/8))')).^2)]; % link 17
    xShift(:,6) = -8E-3*(1-((linspace(0,1,(resObject))')-0.5).^2); % link 6
    xShift(:,9) =  8E-3*(1-((linspace(0,1,(resObject))')-0.5).^2); % link 11
else
    xLbend = xL;
    xLbendReverse = xL;
end

%%
prosthLinkObjects(1)  = surf(figAxes,  xLbend  + xShift(:,1),  yL  + yShift(:,1)  + yShiftGlobal, zL,  'FaceColor', col134); % link1
prosthLinkObjects(2)  = surf(figAxes,  xLs + xShift(:,2),  yLs + yShift(:,2)  + yShiftGlobal, zLs, 'FaceColor', col134); % link3
prosthLinkObjects(3)  = surf(figAxes,  xLs + xShift(:,3),  yLs + yShift(:,3)  + yShiftGlobal, zLs, 'FaceColor', col134);  % link4
prosthLinkObjects(4)  = surf(figAxes,  xLbendReverse  + xShift(:,4),  yL  + yShift(:,4)  + yShiftGlobal, zL,  'FaceColor', col134); % link between shank and j5
prosthLinkObjects(5)  = surf(figAxes,  xH,                 yH                 + yShiftGlobal, zH,  'FaceColor', colStanceHydElem); % link5
prosthLinkObjects(6)  = surf(figAxes,  xLbend  + xShift(:,6),  yL  + yShift(:,6)  + yShiftGlobal, zL,  'FaceColor', col6); % link6
prosthLinkObjects(7)  = surf(figAxes,  xH,                 yH                 + yShiftGlobal, zH,  'FaceColor', colSwingHydElem ); % link8
prosthLinkObjects(8)  = surf(figAxes,  xLs/scaleXfactor + xShift(:,8), yLs/scaleYfactor + yShift(:,8) + yShiftGlobal, zLs, 'FaceColor', col9); % link9
prosthLinkObjects(9)  = surf(figAxes,  xLbendReverse  + xShift(:,9),  yL  + yShift(:,9)  + yShiftGlobal, zL,  'FaceColor', col11); % link11
prosthLinkObjects(10) = surf(figAxes,  xL  + xShift(:,10), yL  + yShift(:,10) + yShiftGlobal, zL,  'FaceColor', col131416); % link13
prosthLinkObjects(11) = surf(figAxes,  xLs + xShift(:,11), yLs + yShift(:,11) + yShiftGlobal, zLs, 'FaceColor', col131416); % link14
prosthLinkObjects(12) = surf(figAxes,  xL  + xShift(:,12), yL  + yShift(:,12) + yShiftGlobal, zL,  'FaceColor', col131416); % link16


% set general properties
set(prosthLinkObjects, 'Visible', 'off', 'EdgeColor', 'none', ...
    'BackFaceLighting', 'unlit');
if ~b_showColors
    set(prosthLinkObjects(1),'FaceColor','texturemap')
    CDataLink1 = get(prosthLinkObjects(1),'CData');
    CDataLink1(:,:,1:3) =col134(1);
    CDataLink1(:,ConeRes/2+1,1) =  colStanceHydElem(1);
    CDataLink1(:,ConeRes/2+1,2) =  colStanceHydElem(2);
    CDataLink1(:,ConeRes/2+1,3) =  colStanceHydElem(3);
    set(prosthLinkObjects(1),'CData',CDataLink1)
    
    set(prosthLinkObjects(6),'FaceColor','texturemap')
    CDataLink6 = get(prosthLinkObjects(6),'CData');
    CDataLink6(:,:,1:3) =col134(1);
    CDataLink6(:,ConeRes/2+1,1) =  colStanceHydElem(1);
    CDataLink6(:,ConeRes/2+1,2) =  colStanceHydElem(2);
    CDataLink6(:,ConeRes/2+1,3) =  colStanceHydElem(3);
    set(prosthLinkObjects(6),'CData',CDataLink6)
end

end