% -------------------
% Update Cone Objects
% -------------------

function updateConeObjects( ConeObjects, u, x, t, intactFlag)

% extract cone objects
HAT_ConeObj = ConeObjects(1);
L_ThighObj  = ConeObjects(2);
L_ShankObj  = ConeObjects(3);
L_BallObj   = ConeObjects(4);
L_HeelObj   = ConeObjects(5);
R_ThighObj  = ConeObjects(6);
if(intactFlag)
    R_ShankObj  = ConeObjects(7);
    R_BallObj   = ConeObjects(8);
    R_HeelObj   = ConeObjects(9);
end


% at the initial time step t=0, scale cone objects to their actual length
HAT_Length = sqrt( (u(1)-u(4))^2 + (u(2)-u(5))^2 + (u(3)-u(6))^2 );

if t==0
    % set HAT length
    set(HAT_ConeObj, 'ZData', get(HAT_ConeObj, 'ZData') * HAT_Length);
    x(3) = HAT_Length;
    
    % set left thigh length
    L_ThighLength = sqrt( (u(4)-u(7))^2 + (u(5)-u(8))^2 + (u(6)-u(9))^2 );
    set(L_ThighObj, 'ZData', get(L_ThighObj, 'ZData') * L_ThighLength);
    x(6) = L_ThighLength;
    
    % set left shank length
    L_ShankLength = sqrt( (u(7)-u(10))^2 + (u(8)-u(11))^2 + (u(9)-u(12))^2 );
    set(L_ShankObj, 'ZData', get(L_ShankObj, 'ZData') * L_ShankLength);
    x(9) = L_ShankLength;
    
    % set left foot length
    L_BallLength = sqrt( (u(10)-u(13))^2 + (u(11)-u(14))^2 + (u(12)-u(15))^2 );
    set(L_BallObj, 'ZData', get(L_BallObj, 'ZData') * L_BallLength);
    x(12) = L_BallLength;
    
    % set left foot length
    L_HeelLength = sqrt( (u(10)-u(16))^2 + (u(11)-u(17))^2 + (u(12)-u(18))^2 );
    set(L_HeelObj, 'ZData', get(L_HeelObj, 'ZData') * L_HeelLength);
    
    
    % set right thigh length
    R_ThighLength = sqrt( (u(19)-u(22))^2 + (u(20)-u(23))^2 + (u(21)-u(24))^2 );
    set(R_ThighObj, 'ZData', get(R_ThighObj, 'ZData') * R_ThighLength);
    x(21) = R_ThighLength;
    
    
    
    if (intactFlag)
        % set right shank length
        R_ShankLength = sqrt( (u(22)-u(25))^2 + (u(23)-u(26))^2 + (u(24)-u(27))^2 );
        set(R_ShankObj, 'ZData', get(R_ShankObj, 'ZData') * R_ShankLength);
        x(24) = R_ShankLength;
        % set right foot length
        R_BallLength = sqrt( (u(25)-u(28))^2 + (u(26)-u(29))^2 + (u(27)-u(30))^2 );
        set(R_BallObj, 'ZData', get(R_BallObj, 'ZData') * R_BallLength);
        x(27) = R_BallLength;
        
        R_HeelLength = sqrt( (u(25)-u(31))^2 + (u(26)-u(32))^2 + (u(27)-u(33))^2 );
        set(R_HeelObj, 'ZData', get(R_HeelObj, 'ZData') * R_HeelLength);
        
    end
       
   
    % rotate and shift cones to their new angles and positions
    lowHATu =(u(4:6)+u(19:21))./2;
    rotTransObj( HAT_ConeObj, lowHATu,   u(1:3),   zeros(1,3),   x(1:3))
    rotTransObj(  L_ThighObj, u(7:9),   u(4:6),   zeros(1,3),   x(4:6))
    rotTransObj(  L_ShankObj, u(10:12),   u(7:9),   zeros(1,3),   x(7:9))
    rotTransObj(   L_BallObj, u(13:15), u(10:12),  zeros(1,3), x(10:12))
    x(12) = L_HeelLength;
    rotTransObj(   L_HeelObj, u(16:18), u(10:12),  zeros(1,3), x(10:12))    
    rotTransObj(  R_ThighObj, u(22:24), u(19:21), zeros(1,3), x(19:21))
    
    if (intactFlag)
        rotTransObj(  R_ShankObj, u(25:27),   u(22:24),   zeros(1,3),   x(22:24))
        rotTransObj(   R_BallObj, u(28:30), u(25:27),  zeros(1,3), x(25:27))
        x(27) = R_HeelLength;
        rotTransObj(   R_HeelObj, u(31:33), u(25:27),  zeros(1,3), x(25:27))
    end
    
    
else
    % rotate and shift cones to their new angles and positions

    yaw = 180/pi*u(34);
    yawOld = 180/pi*x(34);

    lowHATx =(x(4:6)+x(19:21))./2;    
    lowHATu =(u(4:6)+u(19:21))./2;   
    
    rotTransObj( HAT_ConeObj, lowHATu,   u(1:3),   lowHATx,   x(1:3), yaw, yawOld)
    rotTransObj(  L_ThighObj, u(7:9),   u(4:6),   x(7:9),   x(4:6))
    rotTransObj(  L_ShankObj, u(10:12),   u(7:9),   x(10:12),   x(7:9))
    rotTransObj(   L_BallObj, u(13:15), u(10:12),  x(13:15), x(10:12))
    rotTransObj(   L_HeelObj, u(16:18), u(10:12),  x(16:18), x(10:12))
    rotTransObj(  R_ThighObj, u(22:24), u(19:21), x(22:24), x(19:21))
    
    if (intactFlag)
        rotTransObj(  R_ShankObj, u(25:27),   u(22:24),   x(25:27),   x(22:24))
        rotTransObj(   R_BallObj, u(28:30), u(25:27),  x(28:30), x(25:27))
        rotTransObj(   R_HeelObj, u(31:33), u(25:27),  x(31:33), x(25:27))  
    end
    
    
end


end
