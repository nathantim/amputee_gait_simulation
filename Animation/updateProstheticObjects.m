% -------------------------
% Update Prosthetic Objects
% -------------------------

function updateProstheticObjects(prostheticObjects, u, x)
    
    %extract objects
    prosKneeObj  = prostheticObjects(1);
    prosShankObj = prostheticObjects(2);
    prosFootObj  = prostheticObjects(3);
    kneeVertices = get(prosKneeObj, 'Vertices');
    shankVertices = get(prosShankObj, 'Vertices');
    footVertices = get(prosFootObj, 'Vertices');
    
    %move objects back to origin
    numKneeVertices = size(kneeVertices,1);
    transKneeOld = repmat([x(15), 0, x(16)], numKneeVertices, 1);
    kneeVertices = kneeVertices - transKneeOld;

    numShankVertices = size(shankVertices,1);
    transShankOld = repmat([x(15), 0, x(16)], numShankVertices, 1);
    shankVertices = shankVertices - transShankOld;

    numFootVertices = size(footVertices,1);
    transFootOld = repmat([x(17), 0, x(18)], numFootVertices, 1);
    footVertices = footVertices - transFootOld;

    %rotate object vertices
    RotKnee = [ cos(u(19) - x(19)), 0, sin(u(19) - x(19)); 
                0,                  1, 0; 
               -sin(u(19) - x(19)), 0, cos(u(19) - x(19))];
    kneeVertices = (RotKnee*(kneeVertices'))';

    RotShank = [ cos(u(20) - x(20)), 0, sin(u(20) - x(20)); 
                 0,                  1, 0; 
                -sin(u(20) - x(20)), 0, cos(u(20) - x(20))];
    shankVertices = (RotShank*(shankVertices'))';

    RotFoot = [ cos(u(21) - x(21)), 0, sin(u(21) - x(21)); 
                0,                  1, 0; 
               -sin(u(21) - x(21)), 0, cos(u(21) - x(21))];
    footVertices = (RotFoot*(footVertices'))';

    %translate obj vertices
    transKneeNew = repmat([u(15), 0, u(16)], numKneeVertices, 1);
    kneeVertices = kneeVertices + transKneeNew;

    transShankNew = repmat([u(15), 0, u(16)], numShankVertices, 1);
    shankVertices = shankVertices + transShankNew;

    transFootNew = repmat([u(17), 0, u(18)], numFootVertices, 1);
    footVertices = footVertices + transFootNew;

    %update object vertices
    set(prosKneeObj, 'Vertices', kneeVertices);
    set(prosShankObj, 'Vertices', shankVertices);
    set(prosFootObj, 'Vertices', footVertices);
end
