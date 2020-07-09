function plotMusculoData(musculoData,plotInfo,GaitInfo,saveInfo,musculoDataFigure)
if nargin < 5
    musculoDataFigure = [];
end
%%
t_left_perc = GaitInfo.time.left_perc;
t_right_perc = GaitInfo.time.right_perc;

%%
l_dyn = 6;
act_offset = 5;
Lstart = 0;
Rstart = 11;

if contains(saveInfo.info,'3D')
L_HAB   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,act_offset+(Lstart+0)*l_dyn); 
L_HAD   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,act_offset+(Lstart+1)*l_dyn);
Lstart = 2;

R_HAB   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,act_offset+(Rstart+0)*l_dyn);
R_HAD   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,act_offset+(Rstart+1)*l_dyn);
Rstart = 13;

else
Rstart = 9;    
L_HAB = zeros(size(musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,1)));
L_HAD = zeros(size(musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,1)));
R_HAB = zeros(size(musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,1)));
R_HAD = zeros(size(musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,1)));
end

L_HFL   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,act_offset+(Lstart+0)*l_dyn);
L_GLU   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,act_offset+(Lstart+1)*l_dyn);
L_HAM   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,act_offset+(Lstart+2)*l_dyn);
L_RF    = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,act_offset+(Lstart+3)*l_dyn);
L_VAS   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,act_offset+(Lstart+4)*l_dyn);
L_BFSH  = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,act_offset+(Lstart+5)*l_dyn);
L_GAS   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,act_offset+(Lstart+6)*l_dyn);
L_SOL   = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,act_offset+(Lstart+7)*l_dyn);
L_TA    = musculoData.signals.values(GaitInfo.start.left:GaitInfo.end.left,act_offset+(Lstart+8)*l_dyn);


R_HFL   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,act_offset+(Rstart+0)*l_dyn);
R_GLU   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,act_offset+(Rstart+1)*l_dyn);
R_HAM   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,act_offset+(Rstart+2)*l_dyn);
R_RF    = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,act_offset+(Rstart+3)*l_dyn);



try
    R_VAS   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,act_offset+(Rstart+4)*l_dyn);
    R_BFSH  = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,act_offset+(Rstart+5)*l_dyn);
    R_GAS   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,act_offset+(Rstart+6)*l_dyn);
    R_SOL   = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,act_offset+(Rstart+7)*l_dyn);
    R_TA    = musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,act_offset+(Rstart+8)*l_dyn);
    R_HAMc  = 0;%musculoData.signals.values(GaitInfo.start.right:GaitInfo.end.right,act_offset+(Rstart+0)*l_dyn);
catch
    R_HAMc = 0;
    R_VAS   = 0;
    R_BFSH  = 0;
    R_GAS   = 0;
    R_SOL   = 0;
    R_TA    = 0;
end

%%
if isempty(musculoDataFigure)
    musculoDataFig = figure();
    set(musculoDataFig, 'Position',[10,40,1200,930]);
else
    musculoDataFig = musculoDataFigure;
%     clf(musculoDataFig);
end

% sgtitle('Muscle stimulations')

[plotHandlesLeft,axesHandles] = plotMusculoDataInFigure(musculoDataFig,[],t_left_perc,L_HFL,L_GLU,L_HAM,L_RF,L_VAS,L_BFSH,L_GAS,L_SOL,L_TA,L_HAB,L_HAD,GaitInfo.b_oneGaitPhase);
[plotHandlesRight,axesHandles] = plotMusculoDataInFigure(musculoDataFig,axesHandles,t_right_perc,R_HFL,R_GLU,R_HAM,R_RF,R_VAS,R_BFSH,R_GAS,R_SOL,R_TA,R_HAB,R_HAD,GaitInfo.b_oneGaitPhase,R_HAMc);
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