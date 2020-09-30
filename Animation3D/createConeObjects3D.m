function ConeObjects = createConeObjects(ConeRes, yShift, rFoot, rShank, rThigh, rHAT_Cone, intactFlag, yShiftGlobal)
    
    if nargin == 7
        yShiftGlobal = 0;
    end

    ConeCol2 = [1 1 0.99];
    ConeCol  = [0.8 0.8 0.7];
    if intactFlag
        ConeCol3 = [1 1 0.99];
    else
        ConeCol3 = [0.5 0.5 0.5];
    end
    % feet cone
    [xf,yf,zf] = cylinder( rFoot, ConeRes);
    L_BallObj = surf( xf, yf + yShift + yShiftGlobal, zf, 'FaceColor', ConeCol2);
    
    [xf,yf,zf] = cylinder( rFoot, ConeRes);
    L_HeelObj = surf( xf, yf + yShift + yShiftGlobal, zf, 'FaceColor', ConeCol2);
    
    % shank cones
    [xs,ys,zs] = cylinder( rShank, ConeRes);
    L_ShankObj = surf( xs, ys + yShift + yShiftGlobal, zs, 'FaceColor', ConeCol2);

    % thigh cones
    [xt,yt,zt] = cylinder( rThigh, ConeRes);
    R_ThighObj = surf( xt, yt - yShift + yShiftGlobal, zt, 'FaceColor', ConeCol);
    L_ThighObj = surf( xt, yt + yShift + yShiftGlobal, zt, 'FaceColor', ConeCol2);

    % HAT cone
    [x,y,z] = cylinder( rHAT_Cone, ConeRes);
    HAT_ConeObj = surf( 1.3*x, 2.2*y + yShiftGlobal, z, 'FaceColor', ConeCol);

    
    R_BallObj  = surf( xf, yf - yShift + yShiftGlobal, zf, 'FaceColor', ConeCol3);
    R_HeelObj  = surf( xf, yf - yShift + yShiftGlobal, zf, 'FaceColor', ConeCol3);
    R_ShankObj = surf( xs, ys - yShift + yShiftGlobal, zs, 'FaceColor', ConeCol3);
    ConeObjects = [HAT_ConeObj, L_ThighObj, L_ShankObj, L_BallObj, L_HeelObj, R_ThighObj, R_ShankObj, R_BallObj, R_HeelObj];
   
    if false %(intactFlag)
   %make additional cones if not intact
        R_KneeProsthObj = surf( xf, yf - yShift + yShiftGlobal, zf, 'FaceColor', ConeCol3);
        ConeObjects = [ConeObjects, R_KneeProsthObj];
    end

    % set general properties                 
    set(ConeObjects, 'Visible', 'off', 'EdgeColor', 'none', ...
        'BackFaceLighting', 'unlit');
end
