function SphereObjects = createSphereObjects(SphereRes, yShift, rCP, rAJ, rKJ, rHJ, intactFlag, yShiftGlobal)

    if nargin == 7
        yShiftGlobal = 0;
    end

    JointCol     = [0.8 0.8 1];
    %ContPointCol = [0   0   1];

    JointCol2     = [0.9 0.9 1];
    ContPointCol2 = [0.7 0.7 1];

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

    %make additional right side spheres if intact
    if(intactFlag)
        R_Ball = surf(rCP*x, rCP*y - yShift + yShiftGlobal, rCP*z, 'FaceColor', ContPointCol2);
        R_Heel = surf(rCP*x, rCP*y - yShift + yShiftGlobal, rCP*z, 'FaceColor', ContPointCol2);
        R_AJ   = surf(rAJ*x, rAJ*y - yShift + yShiftGlobal, rAJ*z, 'FaceColor', JointCol2);
        R_KJ   = surf(rKJ*x, rKJ*y - yShift + yShiftGlobal, rKJ*z, 'FaceColor', JointCol2);

        material shiny
        % generate objects vector
        SphereObjects = [L_HJ; L_Ball; L_Heel; L_AJ; L_KJ; R_HJ; R_Ball; R_Heel; R_AJ; R_KJ];
    else
        material shiny
        % generate objects vector
        SphereObjects = [L_HJ; L_Ball; L_Heel; L_AJ; L_KJ; R_HJ];
    end

    % set general properties                 
    set(SphereObjects, 'Visible', 'off', 'EdgeColor', 'none', ...
        'BackFaceLighting', 'unlit');
end  
