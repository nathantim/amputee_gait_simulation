% ---------------------------
% Rotate and Translate Ojects
% ---------------------------

function rotTransObj( Object, LowXYZ, TopXYZ, LowXYZold, TopXYZold, yaw, yawOld)
if nargin < 6
    yaw = 0;
    yawOld = 0;
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



magOld = sqrt(sum((TopXYZold-LowXYZold).^2));
magNew = sqrt(sum((TopXYZ-LowXYZ).^2));
if abs(magOld-magNew) > 1E-2
    warning('Dissimilar magnitudes, error of: %d',abs(magOld-magNew));
end
oldUnit = ((TopXYZold-LowXYZold)./magOld);
newUnit = ((TopXYZ-LowXYZ)./magNew);

x = oldUnit;
y = newUnit;
RotMat = eye(3) + y*x' - x*y' + 1/(1+dot(x,y))*(y*x' - x*y')^2;
RotYaw = [cos(yaw-yawOld) sin(yaw-yawOld) 0;...
    -sin(yaw-yawOld) cos(yaw-yawOld) 0;...
    0          0       1];

% xAct = RotYaw(1,1)*xAct + RotYaw(1,2)*yAct;
% xAct = RotYaw(2,1)*xAct + RotYaw(2,2)*xAct;
totalRotMat = RotYaw*RotMat;
xNew = totalRotMat(1,1)*xAct + totalRotMat(1,2)*yAct + totalRotMat(1,3)*zAct + LowXYZ(1);
yNew = totalRotMat(2,1)*xAct + totalRotMat(2,2)*yAct + totalRotMat(2,3)*zAct + LowXYZ(2);
zNew = totalRotMat(3,1)*xAct + totalRotMat(3,2)*yAct + totalRotMat(3,3)*zAct + LowXYZ(3);


%     newVec =  R*[xAct;yAct;zAct] + LowXYZ;
% update cone object
if max(abs(RotMat*(TopXYZold-LowXYZold) + (LowXYZ) - (TopXYZ))) > 1E-2
    warning('Wrong rotation matrix, max error of: %d',max(abs(RotMat*(TopXYZold-LowXYZold) + (LowXYZ) - (TopXYZ))));
end
set(Object, 'XData', xNew, 'yData', yNew, 'ZData', zNew);

end
