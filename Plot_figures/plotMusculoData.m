function plotMusculoData(musculoData,plotInfo,oneGaitinfo,saveInfo)
%%
t_left_perc = oneGaitinfo.time.left_perc;
t_right_perc = oneGaitinfo.time.right_perc;

%%
L_SOL   = musculoData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,1);
L_TA    = musculoData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,2);
L_GAS   = musculoData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,3);
L_VAS   = musculoData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,4);
L_HAM   = musculoData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,5);
L_GLU   = musculoData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,6);
L_HFL   = musculoData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,7);

R_SOL   = musculoData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,8);
R_TA    = musculoData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,9);
R_GAS   = musculoData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,10);
R_VAS   = musculoData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,11);
R_HAM   = musculoData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,12);
R_GLU   = musculoData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,13);
R_HFL   = musculoData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,14);
R_HAMc  = musculoData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,15);

%%
musculoDataFig = figure();
set(musculoDataFig, 'Position',[10,40,1200,930]);
% sgtitle('Muscle stimulations')

plotHandlesLeft = plotMusculoDataInFigure(t_left_perc,L_SOL,L_TA,L_GAS,L_VAS,L_HAM,L_GLU,L_HFL);
plotHandlesRight = plotMusculoDataInFigure(t_right_perc,R_SOL,R_TA,R_GAS,R_VAS,R_HAM,R_GLU,R_HFL,R_HAMc);
if contains(saveInfo.info,'prosthetic')
    leg = legend('Intact leg','Prosthetic leg');
else
    leg = legend('Left leg','Right leg');
end
set(leg,'FontSize',18);

for i= 1:length(plotHandlesLeft)
    set(plotHandlesLeft(i),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    set(plotHandlesRight(i),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
end

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(musculoDataFig,'musculoData',saveInfo.type{j},saveInfo.info)
    end
end