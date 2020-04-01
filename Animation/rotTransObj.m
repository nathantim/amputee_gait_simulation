% ---------------------------
% Rotate and Translate Ojects
% ---------------------------

function rotTransObj( Object, LowXY, TopXY, LowXYold, TopXYold )
    
    % calculate change in rotation angle compared to previous angle
    dalpha =  atan2(   LowXY(1)-   TopXY(1),    TopXY(2)-   LowXY(2)) ...
           -atan2(LowXYold(1)-TopXYold(1), TopXYold(2)-LowXYold(2));

    % get actual x and z data and shift it back to zero
    xAct = get(Object, 'XData')-LowXYold(1);
    zAct = get(Object, 'ZData')-LowXYold(2);

    % rotate and shift x and z data to new angle and position
    xNew = cos(dalpha)*xAct - sin(dalpha)*zAct + LowXY(1);
    zNew = sin(dalpha)*xAct + cos(dalpha)*zAct + LowXY(2);

    % update cone object
    set(Object, 'XData', xNew, 'ZData', zNew);

end
