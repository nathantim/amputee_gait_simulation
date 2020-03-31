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
    if t==0
        % set HAT length
        HAT_Length = 2*sqrt( (u(1)-u(4))^2 + (u(2)-u(5))^2 + (u(3)-u(6))^2 );
        set(HAT_ConeObj, 'ZData', get(HAT_ConeObj, 'ZData') * HAT_Length);

        % set left thigh length
        L_ThighLength = sqrt( (u(4)-u(7))^2 + (u(5)-u(8))^2 + (u(6)-u(9))^2 );
        set(L_ThighObj, 'ZData', get(L_ThighObj, 'ZData') * L_ThighLength);

        % set left shank length
        L_ShankLength = sqrt( (u(7)-u(10))^2 + (u(8)-u(11))^2 + (u(9)-u(12))^2 );
        set(L_ShankObj, 'ZData', get(L_ShankObj, 'ZData') * L_ShankLength);

        % set left foot length
        L_FootLength = sqrt( (u(10)- (u(13)+u(16)/2 ) )^2 + (u(11)- (u(14)+u(17))/2 )^2 + (u(12)- (u(15)+u(18))/2)^2 );
        set(L_FootObj, 'ZData', get(L_FootObj, 'ZData') * L_FootLength);
        
        % set right thigh length
        R_ThighLength = sqrt( (u(25)-u(28))^2 + (u(26)-u(29))^2 + (u(27)-u(30))^2 );
        set(R_ThighObj, 'ZData', get(R_ThighObj, 'ZData') * R_ThighLength);

        if(intactFlag)
            % set right shank length
            R_ShankLength = sqrt( (u(28)-u(31))^2 + (u(29)-u(32))^2 + (u(30)-u(33))^2 );
            set(R_ShankObj, 'ZData', get(R_ShankObj, 'ZData') * R_ShankLength);

            % set right foot length
            R_FootLength = sqrt( (u(31)- (u(34)+u(37)/2 ) )^2 + (u(32)- (u(35)+u(38))/2 )^2 + (u(33)- (u(36)+u(39))/2)^2 );
            set(R_FootObj, 'ZData', get(R_FootObj, 'ZData') * R_FootLength);
        end
    end

    % rotate and shift cones to their new angles and positions
    rotTransObj( HAT_ConeObj, u(4:6),   u(1:3),   x(4:6),   x(1:3))
    rotTransObj(  L_ThighObj, u(7:9),   u(4:6),   x(7:9),   x(4:6))
    rotTransObj(  L_ShankObj, u(10:12),   u(7:9),   x(10:12),   x(7:9)) 
    rotTransObj(   L_FootObj, (u(13:15) + u(16:18))./2, u(10:12),  (x(13:15) + x(16:18))./2, x(10:12)) 
    rotTransObj(  R_ThighObj, u(28:30), u(25:27), x(28:30), x(25:27))

    if(intactFlag)
        rotTransObj(  R_ShankObj, u(31:33),   u(28:30),   x(31:33),   x(28:30)) 
        rotTransObj(   R_FootObj, (u(34:36) + u(37:39))./2, u(31:33),  (x(34:36) + x(37:39))./2, x(31:33)) 
    end
end
