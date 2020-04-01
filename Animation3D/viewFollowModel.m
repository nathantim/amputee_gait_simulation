% Function that shifts view window to follow the hip of the model
% ----------------------------------------
function viewFollowModel(u, ViewWin)

    % Check if an object is out of bounds
    % --------------------------

    % get hip x pos
    hipX = u(13);

    % shift to align with hip
    set(gca, 'XLim', [hipX - ViewWin/2,  hipX + ViewWin/2]);
