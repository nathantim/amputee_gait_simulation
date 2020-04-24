function updateProgressPlot(ax,dataStruct,tagName)
if nargin == 3
    tagToSave = tagName;
else
    tagToSave = ax.Tag;
end
data = dataStruct.data;
% tagToSaveC = cell(size(data));%cellfun(@num2str,cell(size(data)),'UniformOutput',false);
% ax = gca; 
if ~isempty(ax.Children)
    previousData = [ax.Children(:).Data];
    plotData = [previousData;fliplr(data)];
%     tagToSaveC = {ax.Children(:).Tag};
else
    plotData = data;
end

if size(data,2)> 1
    for i = 1:size(data,2)
        
%         colors =  {	'#0072BD';	'#D95319';'#7E2F8E';'#77AC30'};
        if ~isempty(ax.Children) && length(findall(ax.Children,'type','histogram')) == size(plotData,2)
            
            hold(ax,'off');
            faceColor = get(ax.Children(i), 'facecolor');
            set(ax.Children(i),'Data',plotData(:,i));
            set(ax.Children(i), 'facecolor',faceColor);
            set(ax.Children(i), 'facealpha',1.0);
        else
            histogram(ax,plotData(:,i),'facecolor',ax.ColorOrder(i,:),'facealpha',1.0,'edgecolor','black','edgealpha',.5);
%             ax.Children(i).Tag = char(num2str(i));
            hold(ax,'on');
            
        end
        
    end
    legend(ax,dataStruct.info,'Location','south');
else
    histogram(ax,plotData);
end
ax.Tag = tagToSave;
minPlotData = min(min(plotData));
maxPlotData = max(max(plotData));
if mod(size(plotData,1),2) == 0
    medianPlotData = median([plotData;999999*ones(1,size(plotData,2))],'all');
else
    medianPlotData = median(plotData,'all');
end

if max([dataStruct.minimize]) == 0
    title(ax,[ax.Tag, '$_{max} = ',num2str(round(maxPlotData,3)),'$']);
elseif max([dataStruct.minimize]) == 1
    title(ax,[ax.Tag, '$_{min} = ',num2str(round(minPlotData,3)),'$']);
else
    title(ax,[ax.Tag, ': $(',num2str(round(minPlotData,3)),', ',num2str(round(maxPlotData,3)), ')$']);
end

for j = 1:length(findall(ax.Children,'type','histogram'))
    histChildren = findall(ax.Children,'type','histogram');
    binWidth = max( min(min([round(minPlotData)/2,1000,round(maxPlotData/5,3)])) ,0.1);
    binLimits = [min([1.1*minPlotData,max([(minPlotData-5*binWidth),0])]), max( [min( [25*binWidth,round(maxPlotData + 2*binWidth,2,'significant'),25000]), 0.1, ceil(medianPlotData+2*binWidth)]) ];
%     binEdges = binLimits(1):binWidth:binLimits(end);
    set(histChildren(j),'BinWidth',binWidth);
    set(histChildren(j),'BinLimits',binLimits);
    set(histChildren(j),'NumBins',max([15,ceil(range(binLimits)/binWidth)]) );
%     set(histChildren(j),'BinEdges','auto');
%     ax.Children(j).BinWidth = max( min(min([round(minPlotData)/2,1000,round(maxPlotData/5,3)])) ,0.1);
%     ax.Children(j).BinLimits = 
%     if ~isempty([tagToSaveC{:}])
%         set(ax.Children(j), 'Tag',tagToSaveC{j});
%     end
end