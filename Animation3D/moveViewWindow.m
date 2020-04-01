% Function that shifts view window and  
% and the light sources if model is out
% of view
% ----------------------------------------
function moveViewWindow( uInt, uRef, uImp, ViewWin, TolFrac, curFrame, frameFocus1, frameFocus2)

    % Check if an object is out of bounds
    % --------------------------

    % get axis limits
    XLimits = get(gca, 'XLim');

    if curFrame < frameFocus1
        % get min and max xpos of object
        minX = min([uRef(1:2:17), uImp(1:2:17), uInt(1:2:end)]);
        maxX = max([uRef(1:2:17), uImp(1:2:17), uInt(1:2:end)]);

        % shift if object past right border
        if XLimits(2) < ( maxX + ViewWin*TolFrac )
            % initiate shift to the right
            set(gca, 'XLim', [maxX - ViewWin*TolFrac,  maxX + ViewWin*(1-TolFrac)]);
        end

        % zoom out if object pastleft border
        XLimits = get(gca, 'XLim');
        if XLimits(1) > ( minX - ViewWin*TolFrac )
            % initiate zoom to the left
            set(gca, 'XLim', [minX-ViewWin*TolFrac,  XLimits(2)]);
        end
    elseif curFrame > frameFocus2
        % get min and max xpos of object
        minX = min([uInt(1:2:end)]);
        maxX = max([uInt(1:2:end)]);

        % shift if object past right border
        if XLimits(2) < ( maxX + ViewWin*TolFrac )
            % initiate shift to the right
            set(gca, 'XLim', [maxX - ViewWin*TolFrac,  maxX + ViewWin*(1-TolFrac)]);
        end

        % zoom out if object pastleft border
        XLimits = get(gca, 'XLim');
        if XLimits(1) > ( minX - ViewWin*TolFrac )
            % initiate zoom to the left
            set(gca, 'XLim', [minX-ViewWin*TolFrac,  XLimits(2)]);
        end
    else
        % get min and max xpos of object
        minX = min([uRef(1:2:17), uInt(1:2:end)]);
        maxX = max([uRef(1:2:17), uInt(1:2:end)]);

        % shift if object past right border
        if XLimits(2) < ( maxX + ViewWin*TolFrac )
            % initiate shift to the right
            set(gca, 'XLim', [maxX - ViewWin*TolFrac,  maxX + ViewWin*(1-TolFrac)]);
        end

        % zoom out if object pastleft border
        XLimits = get(gca, 'XLim');
        if XLimits(1) > ( minX - ViewWin*TolFrac )
            % initiate zoom to the left
            set(gca, 'XLim', [minX-ViewWin*TolFrac,  XLimits(2)]);
        end
    end
