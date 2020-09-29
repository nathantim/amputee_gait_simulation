% Function that shifts view window and
% and the light sources if model is out
% of view
% ----------------------------------------
function [ViewShiftParamsX, ViewShiftParamsY] = checkViewWin( u, t, ViewWin, TolFrac, ViewShiftParamsX, ViewShiftParamsY, tShiftTot)
%% x
% Check For Shift Initiation
% --------------------------

if ViewShiftParamsX(1)==0
    % get axis limits
    XLimits = get(gca, 'XLim');
    
    % get min and max xpos of object
    minX = u(1);
    maxX = u(1);
    
    % check right border
    if XLimits(2) < ( maxX + ViewWin*TolFrac )
        % initiate shift to the right
        StartPosX  = XLimits(1);
        dShiftTotX = (minX - ViewWin*TolFrac)  - StartPosX;
        ViewShiftParamsX = [1 t StartPosX dShiftTotX];
        
        set(gca, 'XLim', [minX - ViewWin*TolFrac  minX + ViewWin*(1-TolFrac)]);
        % check left border
    elseif XLimits(1) > ( minX - ViewWin*TolFrac )
        % initiate shift to the left
        StartPosX  = XLimits(1);
        dShiftTotX = StartPosX - (minX + ViewWin*TolFrac - ViewWin);
        ViewShiftParamsX = [-1 t StartPosX dShiftTotX];
        set(gca, 'XLim', [maxX - ViewWin*(1-TolFrac)  maxX + ViewWin*TolFrac]);
    end
end


% Shift View Window
% -----------------

if ViewShiftParamsX(1)~=0
    % get current shift time
    tShift   = t - ViewShiftParamsX(2);
    
    % check for end of shift phase
    if tShift > tShiftTot
        % reset view window shift parameters
        ViewShiftParamsX(1) = 0;
    else
        ShiftDirX = ViewShiftParamsX(1);  % get shift direction
        dShiftTotX = ViewShiftParamsX(4); % get shift distance
        StartPosX  = ViewShiftParamsX(3); % get start position
        
        % get new distance to former axis limit
        if tShiftTot == 0
            xLimShift = dShiftTotX;
        else
            if tShift <= tShiftTot/2
                xLimShift = 2*dShiftTotX * (tShift/tShiftTot)^2;
            else
                xLimShift = dShiftTotX-2*dShiftTotX*((tShiftTot-tShift)/tShiftTot)^2;
            end
        end
        
        % shift axis limits
        set(gca, 'XLim', StartPosX + ShiftDirX*xLimShift+[0 ViewWin]);
    end
end

%% y
  % Check For Shift Initiation
    % --------------------------

    if ViewShiftParamsY(1)==0
        % get axis limits
        YLimits = get(gca, 'YLim');

        % get min and max xpos of object
        minY = u(2);
        maxY = u(2);

        % check right border
        if YLimits(2) < ( maxY + ViewWin*TolFrac )
            % initiate shift to the right
            StartPosY  = YLimits(1);
            dShiftTotY = (minY - ViewWin*TolFrac)  - StartPosY; 
            ViewShiftParamsY = [1 t StartPosY dShiftTotY];

            set(gca, 'YLim', [minY - ViewWin*TolFrac  minY + ViewWin*(1-TolFrac)]);
        % check left border
        elseif YLimits(1) > ( minY - ViewWin*TolFrac )
            % initiate shift to the left
            StartPosY  = YLimits(1);
            dShiftTotY = StartPosY - (minY + ViewWin*TolFrac - ViewWin); 
            ViewShiftParamsY = [-1 t StartPosY dShiftTotY];
            set(gca, 'YLim', [maxY - ViewWin*(1-TolFrac)  maxY + ViewWin*TolFrac]);
        end
    end


    % Shift View Window
    % -----------------

    if ViewShiftParamsY(1)~=0
        % get current shift time
        tShift   = t - ViewShiftParamsY(2);

        % check for end of shift phase
        if tShift > tShiftTot
            % reset view window shift parameters
            ViewShiftParamsY(1) = 0;
        else
            ShiftDirY = ViewShiftParamsY(1);  % get shift direction
            dShiftTotY = ViewShiftParamsY(4); % get shift distance
            StartPosY  = ViewShiftParamsY(3); % get start position

            % get new distance to former axis limit
            if tShiftTot == 0
                yLimShift = dShiftTotY;
            else
                if tShift <= tShiftTot/2 
                    yLimShift = 2*dShiftTotY * (tShift/tShiftTot)^2;
                else
                    yLimShift = dShiftTotY-2*dShiftTotY*((tShiftTot-tShift)/tShiftTot)^2;
                end
            end

            % shift axis limits
            set(gca, 'YLim', StartPosY + ShiftDirY*yLimShift+[0 ViewWin]);
        end
    end
end

