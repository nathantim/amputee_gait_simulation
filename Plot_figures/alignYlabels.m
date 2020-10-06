function [ylabelPosxMin] = alignYlabels(axesHandles)

ylabelPosxMin = 99;
for ii = 1:length(axesHandles)
    set(get(axesHandles(ii),'YLabel'),'Units','Normalized');
    ylabelPos = get(get(axesHandles(ii),'YLabel'),'Position');
    if ylabelPos(1) < ylabelPosxMin
        ylabelPosxMin = ylabelPos(1);
    end
end
for ii = 1:length(axesHandles)
    ylabelPos = get(get(axesHandles(ii),'YLabel'),'Position');
    set(get(axesHandles(ii),'YLabel'),'Position',[ylabelPosxMin, ylabelPos(2:3)]);
end