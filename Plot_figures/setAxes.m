function axesPos = setAxes(axes,numAxCol,xOffset, xShift, yOffset, yShift, width, hwratio)

for jj = 1:length(axes)
    if jj <= (length(axes)-numAxCol)
        set(axes(jj),'XTickLabel',{});
    end
    prevPos = get(axes(jj),'Position');
        axesPos(jj,:) = [xOffset + (mod(jj-1,numAxCol))*xShift ...
            yOffset + prevPos(2)+(floor((jj-1)/numAxCol))*yShift ...
            width width/hwratio];

    set(axes(jj),'Position',axesPos(jj,:));
    
    
end