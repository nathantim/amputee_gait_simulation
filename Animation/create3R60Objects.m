function [prosthSphereObjects, prosthLinkObjects] = create3R60Objects(SphereRes, yShift, rLC, rJ, ConeRes,b_showColors)
%% Generate spherical objects prosthesis
if nargin < 7
    yShiftGlobal = 0;
end
% general sphere
[x,y,z] = sphere(SphereRes);
JointCol     = [0.8 0.8 1];

% make Ball, Heel, Ankle, Hip spheres and set their properties
%     thighConnect    = surf(rLC*x, rLC*y + yShift + yShiftGlobal, rLC*z, 'FaceColor', JointCol);
joint1          = surf(rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
joint2          = surf(rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
joint3          = surf(rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
joint4          = surf(rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
joint5          = surf(rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
joint6          = surf(rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
joint7          = surf(rJ*x,  rJ*y  + yShift + yShiftGlobal, rJ*z,  'FaceColor', JointCol);
shankConnect    = surf(rLC*x, rLC*y + yShift + yShiftGlobal, rLC*z, 'FaceColor', JointCol);



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


rH = [ones(1,5)*rJ*0.5 ones(1,3)*rJ*1.2  ones(1,5)*rJ*0.5];

scaleYfactor = 1;
scaleXfactor = 1;

[xLs,yLs,zLs] = cylinder( rJ*0.75, ConeRes); % smaller
[xL,yL,zL] = cylinder( rJ, ConeRes); 
[xH,yH,zH] = cylinder( rH, ConeRes); % hydraulic elements

xLs = scaleXfactor*xLs;
xL = scaleXfactor*xL;
yLs = scaleYfactor*yLs;
yL = scaleYfactor*yL;

prosthLinkObjects(1) = surf( xL, yL + yShift + yShiftGlobal, zL, 'FaceColor', col134); % link1
prosthLinkObjects(2) = surf( xL, yL + yShift + yShiftGlobal, zL, 'FaceColor', col134); % link3
prosthLinkObjects(3) = surf( xLs, yLs + yShift + yShiftGlobal, zLs, 'FaceColor', col134);  % link4
prosthLinkObjects(4) = surf( xL, yL + yShift + yShiftGlobal, zL, 'FaceColor', col134); % link between shank and j5
prosthLinkObjects(5) = surf( xH, yH + yShift + yShiftGlobal, zH, 'FaceColor', colStanceHydElem); % link5
prosthLinkObjects(6) = surf( xL, yL - yShift + yShiftGlobal, zL, 'FaceColor', col6); % link6
prosthLinkObjects(7) = surf( xH, yH - yShift + yShiftGlobal, zH, 'FaceColor', colSwingHydElem ); % link8
prosthLinkObjects(8) = surf( xLs/scaleXfactor*scaleYfactor, yLs/scaleYfactor*scaleXfactor + yShift + yShiftGlobal, zLs, 'FaceColor', col9); % link9
prosthLinkObjects(9) = surf( xL, yL + yShift + yShiftGlobal, zL, 'FaceColor', col11); % link11
prosthLinkObjects(10) = surf( xL, yL + yShift + yShiftGlobal, zL, 'FaceColor', col131416); % link13
prosthLinkObjects(11) = surf( xLs, yLs + yShift + yShiftGlobal, zLs, 'FaceColor', col131416); % link14
prosthLinkObjects(12) = surf( xL, yL + yShift + yShiftGlobal, zL, 'FaceColor', col131416); % link16


% set general properties
set(prosthLinkObjects, 'Visible', 'off', 'EdgeColor', 'none', ...
    'BackFaceLighting', 'unlit');
% if ~b_showColors
%     set(prosthLinkObjects(1),'FaceColor','texturemap')
%     CDataLink1 = get(prosthLinkObjects(1),'CData');
%     CDataLink1(:,:,1:3) =col134(1);
%     CDataLink1(:,ceil(size(CDataLink1,2)/2),1) =  colStanceHydElem(1);
%     CDataLink1(:,ceil(size(CDataLink1,2)/2),2) =  colStanceHydElem(2);
%     CDataLink1(:,ceil(size(CDataLink1,2)/2),3) =  colStanceHydElem(3);
%     set(prosthLinkObjects(1),'CData',CDataLink1)
%     
%     set(prosthLinkObjects(6),'FaceColor','testuremap')
%     CDataLink6 = get(prosthLinkObjects(6),'CData');
%     CDataLink6(:,:,1:3) =col134(1);
%     CDataLink6(:,ceil(size(CDataLink6,2)/2),1) =  colStanceHydElem(1);
%     CDataLink6(:,ceil(size(CDataLink6,2)/2),2) =  colStanceHydElem(2);
%     CDataLink6(:,ceil(size(CDataLink6,2)/2),3) =  colStanceHydElem(3);
%     set(prosthLinkObjects(6),'CData',CDataLink6)
% end

end