% Function that shifts view window and  
% and the light sources if model is out
% of view
% ----------------------------------------
function ViewShiftParams = checkViewWin( u, t, ViewWin, TolFrac, ViewShiftParams, tShiftTot)

    % Check For Shift Initiation
    % --------------------------

    if ViewShiftParams(1)==0
        % get axis limits
        XLimits = get(gca, 'XLim');

        % get min and max xpos of object
        minX = u(1);
        maxX = u(1);

        % check right border
        if XLimits(2) < ( maxX + ViewWin*TolFrac )
            % initiate shift to the right
            StartPos  = XLimits(1);
            dShiftTot = (minX - ViewWin*TolFrac)  - StartPos; 
            ViewShiftParams = [1 t StartPos dShiftTot];

            set(gca, 'XLim', [minX - ViewWin*TolFrac  minX + ViewWin*(1-TolFrac)]);
        % check left border
        elseif XLimits(1) > ( minX - ViewWin*TolFrac )
            % initiate shift to the left
            StartPos  = XLimits(1);
            dShiftTot = StartPos - (minX + ViewWin*TolFrac - ViewWin); 
            ViewShiftParams = [-1 t StartPos dShiftTot];
            set(gca, 'XLim', [maxX - ViewWin*(1-TolFrac)  maxX + ViewWin*TolFrac]);
        end
    end


    % Shift View Window
    % -----------------

    if ViewShiftParams(1)~=0
        % get current shift time
        tShift   = t - ViewShiftParams(2);

        % check for end of shift phase
        if tShift > tShiftTot
            % reset view window shift parameters
            ViewShiftParams(1) = 0;
        else
            ShiftDir = ViewShiftParams(1);  % get shift direction
            dShiftTot = ViewShiftParams(4); % get shift distance
            StartPos  = ViewShiftParams(3); % get start position

            % get new distance to former axis limit
            if tShiftTot == 0
                xLimShift = dShiftTot;
            else
                if tShift <= tShiftTot/2 
                    xLimShift = 2*dShiftTot * (tShift/tShiftTot)^2;
                else
                    xLimShift = dShiftTot-2*dShiftTot*((tShiftTot-tShift)/tShiftTot)^2;
                end
            end

            % shift axis limits
            set(gca, 'XLim', StartPos + ShiftDir*xLimShift+[0 ViewWin]);
        end
    end
end
