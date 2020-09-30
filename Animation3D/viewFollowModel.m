% Function that shifts view window to follow the hip of the model
% ----------------------------------------
function viewFollowModel(u, ViewWin)

    % Check if an object is out of bounds
    % --------------------------

    % get HAT x,y pos
    HATx = u(1);
    HATy = u(2);

    % shift to align with hip
    set(gca, 'XLim', [HATx - ViewWin/2,  HATx + ViewWin/2]);
    set(gca, 'YLim', [HATy - ViewWin/2,  HATy + ViewWin/2]);
