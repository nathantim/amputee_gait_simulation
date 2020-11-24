function SphereObjects = createSphereObjects3D(SphereRes, yShift, rCP, rAJ, rKJ, rHJ,amputeeFactor, rCMG, intactFlag, CMGFlag, yShiftGlobal)

    if nargin < 11
        yShiftGlobal = 0;
    end

    JointCol     = [0.8 0.8 1];
    %ContPointCol = [0   0   1];
    JointCol2     = [0.9 0.9 1];
    ContPointCol = [0.7 0.7 1];
    % general sphere
    [x,y,z] = sphere(SphereRes);

    % make Ball, Heel, Ankle, Hip spheres and set their properties
    L_Ball = surf(rCP*x, rCP*y + yShift + yShiftGlobal, rCP*z, 'FaceColor', ContPointCol);
    L_Heel = surf(rCP*x, rCP*y + yShift + yShiftGlobal, rCP*z, 'FaceColor', ContPointCol);
    L_AJ   = surf(rAJ*x, rAJ*y + yShift + yShiftGlobal, rAJ*z, 'FaceColor', JointCol);
    L_KJ   = surf(rKJ*x, rKJ*y + yShift + yShiftGlobal, rKJ*z, 'FaceColor', JointCol);
    L_HJ   = surf(rHJ*x, rHJ*y + yShift + yShiftGlobal, rHJ*z, 'FaceColor', JointCol);
    R_HJ   = surf(rHJ*x, rHJ*y - yShift + yShiftGlobal, rHJ*z, 'FaceColor', JointCol);
    
    % change material properties of preceeding objects to shiny
    if (intactFlag)        
        R_KJ   = surf(rKJ*x, rKJ*y - yShift + yShiftGlobal, rKJ*z, 'FaceColor', JointCol);
        R_Ball = surf(rCP*x, rCP*y - yShift + yShiftGlobal, rCP*z, 'FaceColor', ContPointCol);
        R_Heel = surf(rCP*x, rCP*y - yShift + yShiftGlobal, rCP*z, 'FaceColor', ContPointCol);
        R_AJ   = surf(rAJ*x, rAJ*y - yShift + yShiftGlobal, rAJ*z, 'FaceColor', JointCol);
    else
        rKJP = amputeeFactor*rKJ;
        R_KJ   = surf(rKJP*x, rKJP*y - yShift + yShiftGlobal, rKJP*z, 'FaceColor', [0.3 0.3 0.3]);

        R_AJ = [];
        R_Ball = [];
        R_Heel = [];
    end

    
    material shiny
    % generate objects vector
    SphereObjects = [L_HJ; L_KJ; L_AJ; L_Ball; L_Heel; R_HJ; R_KJ; R_AJ; R_Ball; R_Heel];
    


    % set general properties                 
    set(SphereObjects, 'Visible', 'off', 'EdgeColor', 'none', ...
        'BackFaceLighting', 'unlit');
end  
