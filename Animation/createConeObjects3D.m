function ConeObjects = createConeObjects(ConeRes, yShift, rFoot, rShank, rThigh, rHAT_Cone, rShankProsth, rFootProsth, intactFlag, CMGFlag, yShiftGlobal)
    
    if nargin < 11
        yShiftGlobal = 0;
    end

    ConeCol2 = [1 1 0.99];
    ConeCol  = [0.8 0.8 0.7];
    if intactFlag
        ConeCol3 = [1 1 0.99];
    else
        ConeCol3 = [0.5 0.5 0.5];
    end
    % HAT cone
    [x,y,z] = cylinder( rHAT_Cone, ConeRes);
    HAT_ConeObj = surf( 1.3*x, 2.2*y + yShiftGlobal, z, 'FaceColor', ConeCol);
    
    % thigh cones
    [xt,yt,zt] = cylinder( rThigh, ConeRes);
    R_ThighObj = surf( xt, yt - yShift + yShiftGlobal, zt, 'FaceColor', ConeCol);
    L_ThighObj = surf( xt, yt + yShift + yShiftGlobal, zt, 'FaceColor', ConeCol2);

    % shank cones
    [xs,ys,zs] = cylinder( rShank, ConeRes);
    L_ShankObj = surf( xs, ys + yShift + yShiftGlobal, zs, 'FaceColor', ConeCol2);

    % feet cone
    [xf,yf,zf] = cylinder( rFoot, ConeRes);
    L_BallObj = surf( xf, yf + yShift + yShiftGlobal, zf, 'FaceColor', ConeCol2);
    L_HeelObj = surf( xf, yf + yShift + yShiftGlobal, zf, 'FaceColor', ConeCol2);
    
    
    
    
    if (~intactFlag)
        [xs,ys,zs] = cylinder( rShankProsth, ConeRes);
        [xf,yf,zf] = cylinder( rFootProsth, ConeRes);
    end
    R_BallObj  = surf( xf, yf - yShift + yShiftGlobal, zf, 'FaceColor', ConeCol3);
    R_HeelObj  = surf( xf, yf - yShift + yShiftGlobal, zf, 'FaceColor', ConeCol3);
    R_ShankObj = surf( xs, ys - yShift + yShiftGlobal, zs, 'FaceColor', ConeCol3);
    ConeObjects = [HAT_ConeObj, L_ThighObj, L_ShankObj, L_BallObj, L_HeelObj, R_ThighObj, R_ShankObj, R_BallObj, R_HeelObj];
   
    if (~intactFlag)
   %make additional cones if not intact
        R_KneeProsthObj = surf( xf, yf - yShift + yShiftGlobal, zf, 'FaceColor', [1,0.6,0.6]);
        ConeObjects = [ConeObjects, R_KneeProsthObj];
    end
    if CMGFlag
        CMGlinkObj = surf( xf, yf - yShift + yShiftGlobal, zf, 'FaceColor', ConeCol3);
        ConeObjects = [ConeObjects, CMGlinkObj];
    end

    % set general properties                 
    set(ConeObjects, 'Visible', 'off', 'EdgeColor', 'none', ...
        'BackFaceLighting', 'unlit');
end
