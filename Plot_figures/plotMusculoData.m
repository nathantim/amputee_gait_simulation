function plotMusculoData(musculoData,plotInfo,GaitInfo,saveInfo,musculoDataFigure)
if nargin < 5
    musculoDataFigure = [];
end
%%
t_left_perc = GaitInfo.time.left_perc;
t_right_perc = GaitInfo.time.right_perc;

%%
L_HFL   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,1);
L_GLU   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,2);
L_HAM   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,3);
L_RF    = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,4);
L_VAS   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,5);
L_BFSH  = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,6);
L_GAS   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,7);
L_SOL   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,8);
L_TA    = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,9);


R_HFL   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,10);
R_GLU   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,11);
R_HAM   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,12);
R_RF    = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,13);
R_VAS   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,14);
R_BFSH  = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,15);
R_GAS   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,16);
R_SOL   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,17);
R_TA    = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,18);
R_HAMc  = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,19);

%%
if isempty(musculoDataFigure)
    musculoDataFig = figure();
    set(musculoDataFig, 'Position',[10,40,1200,930]);
else
    musculoDataFig = musculoDataFigure;
%     clf(musculoDataFig);
end

% sgtitle('Muscle stimulations')

[plotHandlesLeft,axesHandles] = plotMusculoDataInFigure(musculoDataFig,[],t_left_perc,L_HFL,L_GLU,L_HAM,L_RF,L_VAS,L_BFSH,L_GAS,L_SOL,L_TA,GaitInfo.b_oneGaitPhase);
[plotHandlesRight,axesHandles] = plotMusculoDataInFigure(musculoDataFig,axesHandles,t_right_perc,R_HFL,R_GLU,R_HAM,R_RF,R_VAS,R_BFSH,R_GAS,R_SOL,R_TA,GaitInfo.b_oneGaitPhase,R_HAMc);
if contains(saveInfo.info,'prosthetic')
    leg = legend([plotHandlesLeft(end),plotHandlesRight(end)],'Intact leg','Prosthetic leg');
else
    leg = legend([plotHandlesLeft(end),plotHandlesRight(end)],'Left leg','Right leg');
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