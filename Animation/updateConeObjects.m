% -------------------
% Update Cone Objects
% -------------------

function updateConeObjects( ConeObjects, u, x, t, intactFlag)

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
    if t==0
        % set HAT length
        HAT_Length = 2*sqrt( (u(1)-u(3))^2 + (u(2)-u(4))^2 );
        set(HAT_ConeObj, 'ZData', get(HAT_ConeObj, 'ZData') * HAT_Length);

        % set left thigh length
        L_ThighLength = sqrt( (u(3)-u(5))^2 + (u(4)-u(6))^2 );
        set(L_ThighObj, 'ZData', get(L_ThighObj, 'ZData') * L_ThighLength);

        % set left shank length
        L_ShankLength = sqrt( (u(5)-u(7))^2 + (u(6)-u(8))^2 );
        set(L_ShankObj, 'ZData', get(L_ShankObj, 'ZData') * L_ShankLength);

        % set left foot length
        L_FootLength = sqrt( (u(9)-u(11))^2 + (u(10)-u(12))^2 );
        set(L_FootObj, 'ZData', get(L_FootObj, 'ZData') * L_FootLength);
        
        % set right thigh length
        R_ThighLength = sqrt( (u(13)-u(15))^2 + (u(14)-u(16))^2 );
        set(R_ThighObj, 'ZData', get(R_ThighObj, 'ZData') * R_ThighLength);

        if(intactFlag)
            % set right shank length
            R_ShankLength = sqrt( (u(15)-u(17))^2 + (u(16)-u(18))^2 );
            set(R_ShankObj, 'ZData', get(R_ShankObj, 'ZData') * R_ShankLength);

            % set right foot length
            R_FootLength = sqrt( (u(19)-u(21))^2 + (u(20)-u(22))^2 );
            set(R_FootObj, 'ZData', get(R_FootObj, 'ZData') * R_FootLength);
        end
    end

    % rotate and shift cones to their new angles and positions
    rotTransObj( HAT_ConeObj, u(3:4),   u(1:2),   x(3:4),   x(1:2))
    rotTransObj(  L_ThighObj, u(5:6),   u(3:4),   x(5:6),   x(3:4))
    rotTransObj(  L_ShankObj, u(7:8),   u(5:6),   x(7:8),   x(5:6)) 
    rotTransObj(   L_FootObj, u(11:12), u(9:10),  x(11:12), x(9:10)) 
    rotTransObj(  R_ThighObj, u(15:16), u(13:14), x(15:16), x(13:14))

    if(intactFlag)
        rotTransObj(  R_ShankObj, u(17:18),   u(15:16),   x(17:18),   x(15:16)) 
        rotTransObj(   R_FootObj, u(21:22), u(19:20),  x(21:22), x(19:20)) 
    end
end
