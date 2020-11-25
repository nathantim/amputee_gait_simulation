function scaleObj(Object, LowXYZ, TopXYZ, LowXYZold, TopXYZold)

xAct = get(Object, 'XData')-LowXYZ(1);
yAct = get(Object, 'YData')-LowXYZ(2);
zAct = get(Object, 'ZData')-LowXYZ(3);
scaleV = norm(LowXYZ - TopXYZ) / norm([xAct(1,1),yAct(1,1),zAct(1,1)]-[xAct(end,1),yAct(end,1),zAct(end,1)]);

xNew = xAct + LowXYZ(1);
xNew(2:end,:) = scaleV*xAct(2:end,:) + LowXYZ(1);
yNew = yAct + LowXYZ(2);
yNew(2:end,:) = scaleV*yAct(2:end,:) + LowXYZ(2);
zNew = zAct + LowXYZ(3);
zNew(2:end,:) = scaleV*zAct(2:end,:) + LowXYZ(3);

set(Object,'XData', xNew);
set(Object,'YData', yNew);
set(Object,'ZData', zNew);