% Function that shifts view window to follow the hip of the model
% ----------------------------------------
function viewFollowModel(u, ViewWin)

    % Check if an object is out of bounds
    % --------------------------

    % get HAT x,y pos
    HATx = u(1);
    HATy = u(2);
    
    betweenHips = mean([u(4:5);u(19:20)],1);
    % shift to align with hip
    set(gca, 'XLim', [betweenHips(1) - ViewWin/2,  betweenHips(1) + ViewWin/2]);
    set(gca, 'YLim', [betweenHips(2) - ViewWin/2,  betweenHips(2) + ViewWin/2]);
