% ---------------------------
% Rotate and Translate Ojects
% ---------------------------

function rotTransObj( Object, LowXYZ, TopXYZ, LowXYZold, TopXYZold )
    
    % calculate change in rotation angle compared to previous angle
    % Rot y
    dbeta =  atan2(   LowXYZ(1)-   TopXYZ(1),    TopXYZ(3)-   LowXYZ(3)) ...
           -atan2(LowXYZold(1)-TopXYZold(1), TopXYZold(3)-LowXYZold(3));
    RotY = [cos(dbeta) 0 sin(dbeta); ...
            0 1 0; ...
            -sin(dbeta) 0 cos(dbeta)];
       
       % Rot z
    dalpha =  atan2(   LowXYZ(1)-   TopXYZ(1),    TopXYZ(2)-   LowXYZ(2)) ...
           -atan2(LowXYZold(1)-TopXYZold(1), TopXYZold(2)-LowXYZold(2));
    RotZ = [cos(dalpha) -sin(dalpha) 0; ...
            sin(dalpha) cos(dalpha) 0; ...
            0 0 1];
       
    % Rot x   
    dgamma =  atan2(   LowXYZ(2)-   TopXYZ(2),    TopXYZ(3)-   LowXYZ(3)) ...
           -atan2(LowXYZold(2)-TopXYZold(2), TopXYZold(3)-LowXYZold(3));
    RotX = [1 0 0; ...
            0 cos(dgamma) -sin(dgamma); ...
            0 sin(dgamma) cos(dgamma)];
        
    % get actual x and z data and shift it back to zero
    xAct = get(Object, 'XData')-LowXYZold(1);
    yAct = get(Object, 'YData');%-LowXYZold(2);
    zAct = get(Object, 'ZData')-LowXYZold(3);
    
    RotMat = RotX * RotY * RotZ;
    
%     newData = RotMat * [xAct;yAct;zAct] + LowXYZ;
    % rotate and shift x and z data to new angle and position
    xNew = cos(dbeta)*xAct - sin(dbeta)*zAct + LowXYZ(1);
    yNew = yAct;% + LowXYZ(2);
    zNew = sin(dbeta)*xAct + cos(dbeta)*zAct + LowXYZ(3);
    
%     xNew = RotMat(1,1)*xAct + RotMat(1,2)*yAct + RotMat(1,3)*zAct;
%     yNew = RotMat(2,1)*xAct + RotMat(2,2)*yAct + RotMat(2,3)*zAct;
%     zNew = RotMat(3,1)*xAct + RotMat(3,2)*yAct + RotMat(3,3)*zAct;
%     
    % update cone object
    set(Object, 'XData', xNew, 'yData', yNew, 'ZData', zNew);

end
