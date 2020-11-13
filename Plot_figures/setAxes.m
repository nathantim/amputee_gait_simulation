function axesPos = setAxes(axes,numAxCol,xOffset, xShift, yOffset, yShift, width, hwratio)
% setAxes                           Function that resizes the axes 
% 
% INPUTS:
%   - axes                          Axes of a figure to resize (best is to input all axes of a figure).
%   - numAxCol                      Number of columns in a figure.
%   - xOffset                       Offset of x. Increasing this value makes all the axes go to the right.
%   - xShift                        Determines x-spacing between axes, increasing this increases space between axes
%   - yOffset                       Optional, Structure with the data from amputee gait with active CMG simulation.
%   - infoyShift                    Offset of y. Increasing this value makes all the axes go up 
%   - width                         Desired width of axes
%   - hwratio                       Height-width ratio of the figure, so that the axes can be made square
%
% OUTPUTS:
%   - axesPos                       Matrix with per row the position of the axes
%%
for jj = 1:length(axes)
    if jj <= (length(axes)-numAxCol)
        set(axes(jj),'XTickLabel',{});
    end
    set(axes(jj),'Units','normalized');
    prevPos = get(axes(jj),'Position');
        axesPos(jj,:) = [xOffset + (mod(jj-1,numAxCol))*xShift ...
            yOffset + prevPos(2)+(floor((jj-1)/numAxCol))*yShift ...
            width width/hwratio];

    set(axes(jj),'Position',axesPos(jj,:));
    
    
end