function alignCylinder(Object,nHeelBall,nShank,basePoint,endPoint,cylType)
basepoints(1,:) = Object.XData(1,:)';
basepoints(2,:) = Object.YData(1,:)';
basepoints(3,:) = Object.ZData(1,:)';
dirVec = (endPoint-basePoint)/norm((endPoint-basePoint));
if real(acos( dot(dirVec,nShank)/(norm(dirVec)*norm(nShank)) )) *180/pi > 45
    cylType = 'hor';
elseif real(acos( dot(dirVec,nShank)/(norm(dirVec)*norm(nShank)) )) *180/pi <= 45
    cylType = 'ver';
end
p2 = 1;
p1 = ceil(size(basepoints,2)/2);
nxCylinder = (basepoints(:,p1)-basepoints(:,p2))/norm(basepoints(:,p1)-basepoints(:,p2));


if contains(cylType,'ver')
    thetaRot = -(atan2(nHeelBall(2),nHeelBall(1))-atan2(nxCylinder(2),nxCylinder(1)));
        
elseif contains(cylType,'hor')
    locY = cross(nShank,nHeelBall)';
    dotProd = nan(size(basepoints,2),1);
    for idx = 1:size(basepoints,2)
        dotProd(idx) = round(dot(locY,basepoints(:,idx)),3);
    end
    p2 = find(dotProd == min(dotProd));
    p1 = find(dotProd == max(dotProd));
    nCylinder = (mean(basepoints(:,p1),2)-mean(basepoints(:,p2),2))/norm(mean(basepoints(:,p1),2)-mean(basepoints(:,p2),2));
    
    thetaRot = atan2(locY(3),locY(2))-atan2(nCylinder(3),nCylinder(2));
end

rotate(Object,dirVec,thetaRot*180/pi);

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
