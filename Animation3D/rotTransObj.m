% ---------------------------
% Rotate and Translate Ojects
% ---------------------------

function rotTransObj( Object, LowXYZ, TopXYZ, LowXYZold, TopXYZold, yaw)
if nargin < 6
    yaw = 0;
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
RotYaw = [cos(yaw) sin(yaw) 0;...
    -sin(yaw) cos(yaw) 0;...
    0          0       1];
% xAct = RotYaw(1,1)*xAct + RotYaw(1,2)*yAct;
% xAct = RotYaw(2,1)*xAct + RotYaw(2,2)*xAct;

xNew = RotMat(1,1)*xAct + RotMat(1,2)*yAct + RotMat(1,3)*zAct + LowXYZ(1);
yNew = RotMat(2,1)*xAct + RotMat(2,2)*yAct + RotMat(2,3)*zAct + LowXYZ(2);
zNew = RotMat(3,1)*xAct + RotMat(3,2)*yAct + RotMat(3,3)*zAct + LowXYZ(3);


%     newVec =  R*[xAct;yAct;zAct] + LowXYZ;
% update cone object
if max(abs(RotMat*(TopXYZold-LowXYZold) + (LowXYZ) - (TopXYZ))) > 1E-2
    warning('Wrong rotation matrix, max error of: %d',max(abs(RotMat*(TopXYZold-LowXYZold) + (LowXYZ) - (TopXYZ))));
end
set(Object, 'XData', xNew, 'yData', yNew, 'ZData', zNew);

end
