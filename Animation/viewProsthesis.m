function viewProsthesis(u, ViewWin)

    % Check if an object is out of bounds
    % --------------------------
% CameraPosition:
    
    betweenThighShank = mean([u(22:24);u(59:61)],1); % Mean between right thigh and shank connect
    % shift to align with hip
    zoomfactor = 8;
    set(gca, 'XLim', [betweenThighShank(1) - ViewWin/zoomfactor,  betweenThighShank(1) + ViewWin/zoomfactor]);
    set(gca, 'YLim', [betweenThighShank(2) - ViewWin/zoomfactor,  betweenThighShank(2) + ViewWin/zoomfactor]);
    set(gca, 'ZLim', [betweenThighShank(3) - ViewWin/zoomfactor,  betweenThighShank(3) + ViewWin/zoomfactor]);