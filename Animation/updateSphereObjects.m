% ---------------------
% Update Sphere Objects
% ---------------------

function updateSphereObjects( SphereObjects, u, x, intactFlag)
    % extract sphere objects
    L_HJ_Obj  = SphereObjects(1);
    L_BallObj = SphereObjects(2);
    L_HeelObj = SphereObjects(3);
    L_AJ_Obj  = SphereObjects(4);
    L_KJ_Obj  = SphereObjects(5);
    R_HJ_Obj  = SphereObjects(6);

    if(intactFlag)
        R_BallObj = SphereObjects( 7);
        R_HeelObj = SphereObjects( 8);
        R_AJ_Obj  = SphereObjects( 9);
        R_KJ_Obj  = SphereObjects(10);
    end
        

    % shift spheres to their new position
    set(L_HJ_Obj,  'XData',  get(L_HJ_Obj, 'XData') +  u( 3) - x( 3), ...
                   'ZData',  get(L_HJ_Obj, 'ZData') +  u( 4) - x( 4))
    set(L_KJ_Obj,  'XData',  get(L_KJ_Obj, 'XData') +  u( 5) - x( 5), ...
                   'ZData',  get(L_KJ_Obj, 'ZData') +  u( 6) - x( 6))
    set(L_AJ_Obj,  'XData',  get(L_AJ_Obj, 'XData') +  u( 7) - x( 7), ...
                   'ZData',  get(L_AJ_Obj, 'ZData') +  u( 8) - x( 8))
    set(L_BallObj, 'XData', get(L_BallObj, 'XData') +  u( 9) - x( 9), ...
                   'ZData', get(L_BallObj, 'ZData') +  u(10) - x(10))
    set(L_HeelObj, 'XData', get(L_HeelObj, 'XData') +  u(11) - x(11), ...
                   'ZData', get(L_HeelObj, 'ZData') +  u(12) - x(12))
    set(R_HJ_Obj,  'XData',  get(R_HJ_Obj, 'XData') +  u(13) - x(13), ...
                   'ZData',  get(R_HJ_Obj, 'ZData') +  u(14) - x(14))
    if(intactFlag)
        set(R_KJ_Obj,  'XData',  get(R_KJ_Obj, 'XData') +  u(15) - x(15), ...
                       'ZData',  get(R_KJ_Obj, 'ZData') +  u(16) - x(16))
        set(R_AJ_Obj,  'XData',  get(R_AJ_Obj, 'XData') +  u(17) - x(17), ...
                       'ZData',  get(R_AJ_Obj, 'ZData') +  u(18) - x(18))
        set(R_BallObj, 'XData', get(R_BallObj, 'XData') +  u(19) - x(19), ...
                       'ZData', get(R_BallObj, 'ZData') +  u(20) - x(20))
        set(R_HeelObj, 'XData', get(R_HeelObj, 'XData') +  u(21) - x(21), ...
                       'ZData', get(R_HeelObj, 'ZData') +  u(22) - x(22))
    end
end
