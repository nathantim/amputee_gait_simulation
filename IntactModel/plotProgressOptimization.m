function plotProgressOptimization(data)
global updateFigure

if isempty(updateFigure) || ~isvalid(updateFigure)
    updateFigure = figure();
end

dataFieldnames = fieldnames(data);
numOfData = length(dataFieldnames);

for i = 1:numOfData
    %     fieldnameSelect = structnames(contains(structnames,updateFigure.Children(i).Tag));
%     set(updateFigure, 'currentaxes', updateFigure.Children(i));
if ~isempty(updateFigure.Children) && length(findall(updateFigure,'type','axes')) == numOfData
    axesChildren = findall(updateFigure,'type','axes');
    updateProgressPlot(axesChildren(i),data.(axesChildren(i).Tag))
else
    ax = subplot(ceil(numOfData/4),4,i);
    updateProgressPlot(ax,data.(dataFieldnames{i}),dataFieldnames{i})
end

end
pause(0.005);

