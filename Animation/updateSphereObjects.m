% ---------------------
% Update Sphere Objects
% ---------------------

function updateSphereObjects3D( SphereObjects, u, x, yShift, intactFlag)
    % extract sphere objects
    L_HJ_Obj  = SphereObjects( 1);
    L_KJ_Obj  = SphereObjects( 2);
    L_AJ_Obj  = SphereObjects( 3);
    L_BallObj = SphereObjects( 4);
    L_HeelObj = SphereObjects( 5);
    R_HJ_Obj  = SphereObjects( 6);
    R_KJ_Obj  = SphereObjects( 7);
    
    
    if (intactFlag)
        R_AJ_Obj  = SphereObjects( 8);
        R_BallObj = SphereObjects( 9);
        R_HeelObj = SphereObjects(10);
    end
        
    
    % shift spheres to their new position
    set(L_HJ_Obj,  'XData',  get(L_HJ_Obj, 'XData')  +  u( 4) - x( 4), ...
        'YData',  get(L_HJ_Obj, 'YData')  +  u( 5) - x( 5), ...
        'ZData',  get(L_HJ_Obj, 'ZData')  +  u( 6) - x( 6))
    set(L_KJ_Obj,  'XData',  get(L_KJ_Obj, 'XData')  +  u( 7) - x( 7), ...
        'YData',  get(L_KJ_Obj, 'YData')  +  u( 8) - x( 8), ...
        'ZData',  get(L_KJ_Obj, 'ZData')  +  u( 9) - x( 9))
    set(L_AJ_Obj,  'XData',  get(L_AJ_Obj, 'XData')  +  u(10) - x(10), ...
        'YData',  get(L_AJ_Obj, 'YData')  +  u(11) - x(11), ...
        'ZData',  get(L_AJ_Obj, 'ZData')  +  u(12) - x(12))
    set(L_BallObj, 'XData',  get(L_BallObj, 'XData') +  u(13) - x(13), ...
        'YData',  get(L_BallObj, 'YData') +  u(14) - x(14), ...
        'ZData',  get(L_BallObj, 'ZData') +  u(15) - x(15))
    set(L_HeelObj, 'XData',  get(L_HeelObj, 'XData') +  u(16) - x(16), ...
        'YData',  get(L_HeelObj, 'YData') +  u(17) - x(17), ...
        'ZData',  get(L_HeelObj, 'ZData') +  u(18) - x(18))
    set(R_HJ_Obj,  'XData',  get(R_HJ_Obj, 'XData')  +  u(19) - x(19), ...
        'YData',  get(R_HJ_Obj, 'YData')  +  u(20) - x(20), ...
        'ZData',  get(R_HJ_Obj, 'ZData')  +  u(21) - x(21))
    set(R_KJ_Obj,  'XData',  get(R_KJ_Obj, 'XData')  +  u(22) - x(22), ...
        'YData',  get(R_KJ_Obj, 'YData')  +  u(23) - x(23), ...
        'ZData',  get(R_KJ_Obj, 'ZData')  +  u(24) - x(24))
    
    if(intactFlag)
        set(R_AJ_Obj,  'XData',  get(R_AJ_Obj, 'XData')  +  u(25) - x(25), ...
            'YData',  get(R_AJ_Obj, 'YData')  +  u(26) - x(26), ...
            'ZData',  get(R_AJ_Obj, 'ZData')  +  u(27) - x(27))
        set(R_BallObj, 'XData',  get(R_BallObj, 'XData') +  u(28) - x(28), ...
            'YData',  get(R_BallObj, 'YData') +  u(29) - x(29), ...
            'ZData',  get(R_BallObj, 'ZData') +  u(30) - x(30))
        set(R_HeelObj, 'XData',  get(R_HeelObj, 'XData') +  u(31) - x(31), ...
            'YData',  get(R_HeelObj, 'YData') +  u(32) - x(32), ...
            'ZData',  get(R_HeelObj, 'ZData') +  u(33) - x(33))
    end

end
