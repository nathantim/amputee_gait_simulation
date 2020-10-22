% ---------------------------
% Rotate and Translate Ojects
% ---------------------------

function rotTransObj( Object, LowXYZ, TopXYZ, LowXYZold, TopXYZold, Lhip, Rhip)
if nargin < 6
    Lhip = [];
end
if nargin < 7
    Rhip = [];
end
if size(LowXYZ,1) == 1
    LowXYZ = LowXYZ';
end
if size(TopXYZ,1) == 1
    TopXYZ = TopXYZ';
end
if size(LowXYZold,1) == 1
    LowXYZold = LowXYZold';
end
if size(TopXYZold,1) == 1
    TopXYZold = TopXYZold';
end



% get actual x and z data and shift it back to zero
xAct = get(Object, 'XData')-LowXYZold(1);
yAct = get(Object, 'YData')-LowXYZold(2);
zAct = get(Object, 'ZData')-LowXYZold(3);



magOld = norm(TopXYZold-LowXYZold);
magNew = norm(TopXYZ-LowXYZ);
if abs(magOld-magNew) > 1E-2
    warning('Dissimilar magnitudes, error of: %d',abs(magOld-magNew));
end
RotYaw = 1;%[cos(yaw-yawOld) -sin(yaw-yawOld) 0;...
%     sin(yaw-yawOld) cos(yaw-yawOld) 0;...
%     0          0       1];

oldUnit = RotYaw*((TopXYZold-LowXYZold)./magOld);
newUnit = RotYaw*((TopXYZ-LowXYZ)./magNew);

x = oldUnit;
y = newUnit;
RotMat = eye(3) + y*x' - x*y' + 1/(1+dot(x,y))*(y*x' - x*y')^2;


% RotYaw = 1;%[cos(yaw-yawOld), 0, -sin(yaw-yawOld);...
%     0, 1, 0;...
%     sin(yaw-yawOld) 0 cos(yaw-yawOld)];

% xAct = RotYaw(1,1)*xAct + RotYaw(1,2)*yAct;
% xAct = RotYaw(2,1)*xAct + RotYaw(2,2)*xAct;
totalRotMat = RotMat;
% abs(totalRotMat*(TopXYZold-LowXYZold) + (LowXYZ) - (TopXYZ))
xNew = totalRotMat(1,1)*xAct + totalRotMat(1,2)*yAct + totalRotMat(1,3)*zAct + LowXYZ(1);
yNew = totalRotMat(2,1)*xAct + totalRotMat(2,2)*yAct + totalRotMat(2,3)*zAct + LowXYZ(2);
zNew = totalRotMat(3,1)*xAct + totalRotMat(3,2)*yAct + totalRotMat(3,3)*zAct + LowXYZ(3);


%     newVec =  R*[xAct;yAct;zAct] + LowXYZ;
% update cone object
if max(abs(totalRotMat*(TopXYZold-LowXYZold) + (LowXYZ) - (TopXYZ))) > 1E-2
    warning('Wrong rotation matrix, max error of: %d',max(abs(RotMat*(TopXYZold-LowXYZold) + (LowXYZ) - (TopXYZ))));
end
set(Object, 'XData', xNew, 'yData', yNew, 'ZData', zNew);
% disp(yaw-yawOld)
if ~isempty(Lhip)
    %%
    xData = get(Object, 'XData');
    lowxData = xData(1,:);
    
    yData = get(Object, 'YData');
    lowyData = yData(1,:);
    idxLeft = find(lowyData == max(lowyData));
    idxRight = find(lowyData == min(lowyData));
    left = [lowxData(idxLeft),lowyData(idxLeft)];
    right = [lowxData(idxRight),lowyData(idxRight)];
    
    ang = (atan((Lhip(1)-Rhip(1))/(Lhip(2)-Rhip(2)))-atan((left(1)-right(1))/(left(2)-right(2))) )*180/pi;
    %     set(Object, 'XData',get(Object, 'XData')-diffX , 'yData', get(Object, 'YData') - diffY);
    direction = ((TopXYZ-LowXYZ)./norm((TopXYZ-LowXYZ)));
    rotate(Object,direction,-ang);
    
    xData = get(Object, 'XData');
    lowxData = xData(1,:);
    yData = get(Object, 'YData');
    lowyData = yData(1,:);
    diffX = mean(lowxData,'all') - LowXYZ(1);
    diffY = mean(lowyData,'all') - LowXYZ(2);
    set(Object, 'XData',get(Object, 'XData')-diffX , 'yData', get(Object, 'YData') - diffY);
    %%
    %
end
end
