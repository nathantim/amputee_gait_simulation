function plotProgressOptimization(data)
global updateFigure

for i = 1:length(updateFigure.Children)
    %     fieldnameSelect = structnames(contains(structnames,updateFigure.Children(i).Tag));
%     set(updateFigure, 'currentaxes', updateFigure.Children(i));
    updateProgressPlot(updateFigure.Children(i),data.(updateFigure.Children(i).Tag))
end

