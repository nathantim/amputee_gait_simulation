function alignCylinder(Object,nHeelBall,basePoint,endPoint)
basepoints(1,:) = Object.XData(1,:);
basepoints(2,:) = Object.YData(1,:);

nCylinder = (basepoints(1:2,ceil(size(basepoints,2)/2))-basepoints(1:2,1))/norm(basepoints(1:2,1)-basepoints(1:2,ceil(size(basepoints,2)/2)));
thetaAng = acos(dot(nCylinder,nHeelBall)/(norm(nCylinder)*norm(nHeelBall)))*180/pi;
dirVec = (endPoint-basePoint)/norm((endPoint-basePoint));
rotate(Object,dirVec,thetaAng);

xData = get(Object, 'XData');
lowxData = xData(1,:);
yData = get(Object, 'YData');
lowyData = yData(1,:);
zData = get(Object, 'ZData');
lowzData = zData(1,:);
diffX = mean(lowxData,'all') - basePoint(1);
diffY = mean(lowyData,'all') - basePoint(2);
diffZ = mean(lowzData,'all') - basePoint(3);
set(Object, 'XData',get(Object, 'XData')-diffX , 'yData', get(Object, 'YData') - diffY, 'ZData', get(Object, 'ZData') - diffZ);
   