function leg = setLegend(plotHandles,axesPos,legendText,fontSize)
leg = legend(plotHandles,legendText,'FontSize', fontSize,'Location','northeastoutside');  %two
legPos = get(leg,'Position');
set(leg,'Position',[axesPos(1)+axesPos(3)+0.005 legPos(2:end)],'Box','off');

