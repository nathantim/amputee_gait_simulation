% -----------------
% Create Prosthetic
% -----------------

function prostheticObjects = createProstheticObjects(prosKneeFile, ...
    prosShankFile, prosFootFile, yShiftGlobal)


    if nargin == 0
        yShiftGlobal = 0;
        prosKneeFile  = '../Prosthesis/kneeStatorForAnim.STL';
        prosShankFile = '../Prosthesis/shankForAnim.STL';
        prosFootFile  = '../Prosthesis/footForAnim.STL';
    end

    [vProsKnee, fProsKnee] = stlread(prosKneeFile);
    vProsKnee(:,2)  = vProsKnee(:,2) - 0.1 + yShiftGlobal;
    [vProsShank, fProsShank] = stlread(prosShankFile);
    vProsShank(:,2)  = vProsShank(:,2) - 0.1 + yShiftGlobal;
    [vProsFoot, fProsFoot] = stlread(prosFootFile);
    vProsFoot(:,2)  = vProsFoot(:,2) - 0.1 + yShiftGlobal;

    prosColor = [0.5, 0.5, 0.5];
    prosKneePatch  = patch('Faces',fProsKnee,'Vertices',vProsKnee);
    prosShankPatch = patch('Faces',fProsShank,'Vertices',vProsShank);
    prosFootPatch  = patch('Faces',fProsFoot,'Vertices',vProsFoot); 
    prostheticObjects = [prosKneePatch, prosShankPatch, prosFootPatch];     

    set(prostheticObjects,'Visible','off','FaceColor',prosColor,'EdgeColor','none');
end
