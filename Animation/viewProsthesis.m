function viewProsthesis(figAxes, u, ViewWin)

    % Check if an object is out of bounds
    % --------------------------
% CameraPosition:
    
    betweenThighShank = mean([u(22:24);u(59:61)],1); % Mean between right thigh and shank connect
    % shift to align with hip
    zoomfactor = 16;
    set(figAxes, 'XLim', [betweenThighShank(1) - ViewWin/zoomfactor,  betweenThighShank(1) + ViewWin/zoomfactor]);
    set(figAxes, 'YLim', [betweenThighShank(2) - ViewWin/zoomfactor,  betweenThighShank(2) + ViewWin/zoomfactor]);
    set(figAxes, 'ZLim', [betweenThighShank(3) - ViewWin/zoomfactor,  betweenThighShank(3) + ViewWin/zoomfactor]);