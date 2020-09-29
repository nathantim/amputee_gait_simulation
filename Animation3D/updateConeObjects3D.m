% -------------------
% Update Cone Objects
% -------------------

function updateConeObjects3D( ConeObjects, u, x, t, intactFlag)

    % extract cone objects
    HAT_ConeObj = ConeObjects(1);
    L_ThighObj  = ConeObjects(2);
    L_ShankObj  = ConeObjects(3);
    L_FootObj   = ConeObjects(4);
    R_ThighObj  = ConeObjects(5);
    if(intactFlag)
        R_ShankObj  = ConeObjects(6);
        R_FootObj   = ConeObjects(7);
    end

    % at the initial time step t=0, scale cone objects to their actual length
    HAT_Length = 2*sqrt( (u(1)-u(4))^2 + (u(2)-u(5))^2 + (u(3)-u(6))^2 );

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
        L_FootLength = sqrt( (u(10)-u(13))^2 + (u(11)-u(14))^2 + (u(12)-u(15))^2 );
        set(L_FootObj, 'ZData', get(L_FootObj, 'ZData') * L_FootLength);
        x(12) = L_FootLength;
        
        % set right thigh length
        R_ThighLength = sqrt( (u(19)-u(22))^2 + (u(20)-u(23))^2 + (u(21)-u(24))^2 );
        set(R_ThighObj, 'ZData', get(R_ThighObj, 'ZData') * R_ThighLength);
        x(21) = R_ThighLength;
        
        if(intactFlag)
            % set right shank length
            R_ShankLength = sqrt( (u(22)-u(25))^2 + (u(23)-u(26))^2 + (u(24)-u(27))^2 );
            set(R_ShankObj, 'ZData', get(R_ShankObj, 'ZData') * R_ShankLength);
            x(24) = R_ShankLength;
            
            % set right foot length
            R_FootLength = sqrt( (u(25)-u(28))^2 + (u(26)-u(29))^2 + (u(27)-u(30))^2 );
            set(R_FootObj, 'ZData', get(R_FootObj, 'ZData') * R_FootLength);
            x(27) = R_FootLength;
        end
        
        % rotate and shift cones to their new angles and positions
        lowHATu =(u(4:6)+u(19:21))./2;
        magHATu = sqrt(sum( (u(1:3)-lowHATu).^2));
        unitHATu = ((u(1:3)-lowHATu))./magHATu;
        topHATu = unitHATu*HAT_Length + lowHATu;
        rotTransObj( HAT_ConeObj, lowHATu,   topHATu,   zeros(1,3),   x(1:3))
        rotTransObj(  L_ThighObj, u(7:9),   u(4:6),   zeros(1,3),   x(4:6))
        rotTransObj(  L_ShankObj, u(10:12),   u(7:9),   zeros(1,3),   x(7:9))
        rotTransObj(   L_FootObj, u(13:15), u(10:12),  zeros(1,3), x(10:12))
        rotTransObj(  R_ThighObj, u(22:24), u(19:21), zeros(1,3), x(19:21))
        
        if(intactFlag)
            rotTransObj(  R_ShankObj, u(25:27),   u(22:24),   zeros(1,3),   x(22:24))
            rotTransObj(   R_FootObj, u(28:30), u(25:27),  zeros(1,3), x(25:27))
        end
        
    else
        % rotate and shift cones to their new angles and positions
        lowHATu =(u(4:6)+u(19:21))./2;
        magHATu = sqrt(sum( (u(1:3)-lowHATu).^2));
        unitHATu = ((u(1:3)-lowHATu))./magHATu;
        topHATu = unitHATu*HAT_Length + lowHATu;
        lowHATx =(x(4:6)+x(19:21))./2;
        magHATx = sqrt(sum( (x(1:3)-lowHATx).^2));
        unitHATx = ((x(1:3)-lowHATx))./magHATx;
        topHATx = unitHATx*HAT_Length + lowHATx;
        
        rotTransObj( HAT_ConeObj, lowHATu,   topHATu,   lowHATx,   topHATx)
        rotTransObj(  L_ThighObj, u(7:9),   u(4:6),   x(7:9),   x(4:6))
        rotTransObj(  L_ShankObj, u(10:12),   u(7:9),   x(10:12),   x(7:9))
        rotTransObj(   L_FootObj, u(13:15), u(10:12),  x(13:15), x(10:12))
        rotTransObj(  R_ThighObj, u(22:24), u(19:21), x(22:24), x(19:21))
        
        if(intactFlag)
            rotTransObj(  R_ShankObj, u(25:27),   u(22:24),   x(25:27),   x(22:24))
            rotTransObj(   R_FootObj, u(28:30), u(25:27),  x(28:30), x(25:27))
        end
    end

    
end
