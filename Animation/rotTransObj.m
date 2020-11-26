% ---------------------------
% Rotate and Translate Ojects
% ---------------------------

function rotTransObj( Object, LowXYZ, TopXYZ, LowXYZold, TopXYZold, yaw, yawOld)
if nargin < 6
    yaw = 0;
end
if nargin < 7
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

magOld = norm(TopXYZold-LowXYZold);
magNew = norm(TopXYZ-LowXYZ);

oldUnit = (TopXYZold-LowXYZold)./magOld;
newUnit = (TopXYZ-LowXYZ)./magNew;

x = oldUnit;
y = newUnit;
RotMat = eye(3) + y*x' - x*y' + 1/(1+dot(x,y))*(y*x' - x*y')^2;

xNew = RotMat(1,1)*xAct + RotMat(1,2)*yAct + RotMat(1,3)*zAct + LowXYZ(1);
yNew = RotMat(2,1)*xAct + RotMat(2,2)*yAct + RotMat(2,3)*zAct + LowXYZ(2);
zNew = RotMat(3,1)*xAct + RotMat(3,2)*yAct + RotMat(3,3)*zAct + LowXYZ(3);

% update cone object
set(Object, 'XData', xNew, 'yData', yNew, 'ZData', zNew);

if ~isempty(yaw)
    %%
    direction = ((TopXYZ-LowXYZ)./norm((TopXYZ-LowXYZ)));
    rotate(Object,direction,yaw-yawOld);
    
    xData = get(Object, 'XData');
    lowxData = xData(1,:);
    yData = get(Object, 'YData');
    lowyData = yData(1,:);
    zData = get(Object, 'ZData');
    lowzData = zData(1,:);
    diffX = mean(lowxData,'all') - LowXYZ(1);
    diffY = mean(lowyData,'all') - LowXYZ(2);
    diffZ = mean(lowzData,'all') - LowXYZ(3);
    set(Object, 'XData',get(Object, 'XData')-diffX , 'yData', get(Object, 'YData') - diffY, 'ZData', get(Object, 'ZData') - diffZ);
    %%
    %
end
end
