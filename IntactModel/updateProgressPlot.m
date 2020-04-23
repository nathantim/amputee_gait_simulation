function updateProgressPlot(ax,data)
% ax = gca; 
if ~isempty(ax.Children)
    previousData = [ax.Children(:).Data];
    plotData = [previousData;data];    
else
    plotData = data;
end
tagToSave = ax.Tag;
if size(data,2)> 1
    for i = 1:size(data,2)
%         colors =  {	'#0072BD';	'#D95319';'#7E2F8E';'#77AC30'};
        if ~isempty(ax.Children) && length(ax.Children) == size(plotData,2)
            hold(ax,'off');
            set(ax.Children(i),'Data',plotData(:,i));
        end
        histogram(ax,plotData(:,i),'facealpha',.5,'edgecolor','black','edgealpha',.5);
        ax.Children(i).Tag = 'i';
        hold(ax,'on');
    end
else
    histogram(ax,plotData);
end
ax.Tag = tagToSave;
minPlotData = min(min(plotData));
title(ax,['$J_{min} = ',num2str(round(minPlotData,3)),'$']);
for j = 1:length(ax.Children)
    ax.Children(j).BinWidth = max( min(min(round(minPlotData)/5,1000)) ,20);
    ax.Children(j).BinLimits = [0, min(min(25*ax.Children(j).BinWidth,25000))];
end