function SphereObjects = createSphereObjects3D(SphereRes, yShift, rCP, rAJ, rKJ, rHJ,rCMG, intactFlag, CMGFlag, yShiftGlobal)

    if nargin < 10
        yShiftGlobal = 0;
    end

    JointCol     = [0.8 0.8 1];
    %ContPointCol = [0   0   1];
    JointCol2     = [0.9 0.9 1];
    ContPointCol2 = [0.7 0.7 1];
        
    if (intactFlag)
        JointCol3     = [0.9 0.9 1];
        ContPointCol3 = [0.7 0.7 1];
    else
        JointCol3     = [0.3 0.3 0.3];
        ContPointCol3 = [0.2 0.2 0.2];
    end
    % general sphere
    [x,y,z] = sphere(SphereRes);

    % make Ball, Heel, Ankle, Hip spheres and set their properties
    L_Ball = surf(rCP*x, rCP*y + yShift + yShiftGlobal, rCP*z, 'FaceColor', ContPointCol2);
    L_Heel = surf(rCP*x, rCP*y + yShift + yShiftGlobal, rCP*z, 'FaceColor', ContPointCol2);
    L_AJ   = surf(rAJ*x, rAJ*y + yShift + yShiftGlobal, rAJ*z, 'FaceColor', JointCol2);
    L_KJ   = surf(rKJ*x, rKJ*y + yShift + yShiftGlobal, rKJ*z, 'FaceColor', JointCol2);
    L_HJ   = surf(rHJ*x, rHJ*y + yShift + yShiftGlobal, rHJ*z, 'FaceColor', JointCol2);
    R_HJ   = surf(rHJ*x, rHJ*y - yShift + yShiftGlobal, rHJ*z, 'FaceColor', JointCol);

    % change material properties of preceeding objects to shiny
    if (~intactFlag)
        prosthFactor = 0.65;
        rKJ = prosthFactor*rKJ;
        rAJ = prosthFactor*rAJ;
        rCP = prosthFactor*rCP;
    end
    %make additional right side spheres if intact
    R_Ball = surf(rCP*x, rCP*y - yShift + yShiftGlobal, rCP*z, 'FaceColor', ContPointCol3);
    R_Heel = surf(rCP*x, rCP*y - yShift + yShiftGlobal, rCP*z, 'FaceColor', ContPointCol3);
    R_AJ   = surf(rAJ*x, rAJ*y - yShift + yShiftGlobal, rAJ*z, 'FaceColor', JointCol3);
    R_KJ   = surf(rKJ*x, rKJ*y - yShift + yShiftGlobal, rKJ*z, 'FaceColor', JointCol3);
    
    material shiny
    % generate objects vector
    SphereObjects = [L_HJ; L_KJ; L_AJ; L_Ball; L_Heel; R_HJ; R_KJ; R_AJ; R_Ball; R_Heel];
    
    if (~intactFlag)
        R_KJ2   = surf(rAJ*x, rAJ*y - yShift + yShiftGlobal, rAJ*z, 'FaceColor', JointCol3);
        material shiny
        SphereObjects = [SphereObjects; R_KJ2];
    end
    if CMGFlag
        
        CMG   = surf(rCMG*x, rCMG*y - yShift + yShiftGlobal, rCMG*z, 'FaceColor', [0.1 0.1 0.8],'FaceAlpha',0.2);
%         material shiny
        SphereObjects = [SphereObjects; CMG];
    end

    % set general properties                 
    set(SphereObjects, 'Visible', 'off', 'EdgeColor', 'none', ...
        'BackFaceLighting', 'unlit');
end  
