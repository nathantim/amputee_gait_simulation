function plotGRF(GRFData,plotInfo,oneGaitinfo,saveInfo)
%%
t_left_perc = oneGaitinfo.time.left_perc;
t_right_perc = oneGaitinfo.time.right_perc;
GRFData.signals.values = GRFData.signals.values./getBodyMassN();
L_Ball  = GRFData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,1:2);
L_Total = GRFData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,3:4);
L_Heel  = GRFData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,5:6);

R_Ball  = GRFData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,7:8);
R_Total = GRFData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,9:10);
R_Heel  = GRFData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,11:12);

%%
GRFDataFig = figure();

% sgtitle('Ground Reaction Forces')

if false
    plotHandlesLeft = plotGRFDataInFigure(t_left_perc,L_Ball,L_Total,L_Heel);
    plotHandlesRight = plotGRFDataInFigure(t_right_perc,R_Ball,R_Total,R_Heel);
    set(GRFDataFig, 'Position',[10,50,1600,900]);
else
    plotHandlesLeft = plotTotalGRFDataInFigure(t_left_perc,L_Total);
    plotHandlesRight = plotTotalGRFDataInFigure(t_right_perc,R_Total);
    set(GRFDataFig, 'Position',[10,50,600,400]);
end
leg = legend('Left leg','Right leg');
set(leg,'FontSize',18);

for i= 1:length(plotHandlesLeft)
    set(plotHandlesLeft(i),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    set(plotHandlesRight(i),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
end

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(GRFDataFig,'GRFData',saveInfo.type{j},saveInfo.info)
    end
end