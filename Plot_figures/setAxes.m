function axesPos = setAxes(axes,xOffset, xShift, yOffset, yShift, width, hwratio)

for jj = 1:length(axes)
    if jj <= length(axes)/2
        set(axes(jj),'XTickLabel',{});
    end
    prevPos = get(axes(jj),'Position');
        axesPos(jj,:) = [xOffset + (mod(jj-1,length(axes)/2))*xShift ...
            yOffset + prevPos(2)+(jj<=length(axes)/2)*yShift ...
            width width/hwratio];

    set(axes(jj),'Position',axesPos(jj,:));
    
    
end