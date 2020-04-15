function plotGRF(GRFData,plotInfo,GaitInfo,saveInfo)
%%
t_left_perc = GaitInfo.time.left_perc;
t_right_perc = GaitInfo.time.right_perc;
GRFData.signals.values = GRFData.signals.values./getBodyMass();
L_Ball  = GRFData.signals.values(GaitInfo.start.left:GaitInfo.end.left,1:2);
L_Total = GRFData.signals.values(GaitInfo.start.left:GaitInfo.end.left,3:4);
L_Heel  = GRFData.signals.values(GaitInfo.start.left:GaitInfo.end.left,5:6);

R_Ball  = GRFData.signals.values(GaitInfo.start.right:GaitInfo.end.right,7:8);
R_Total = GRFData.signals.values(GaitInfo.start.right:GaitInfo.end.right,9:10);
R_Heel  = GRFData.signals.values(GaitInfo.start.right:GaitInfo.end.right,11:12);

L_Total(:,1) = -1*L_Total(:,1);
R_Total(:,1) = -1*R_Total(:,1);
warning('Unreasoned factor -1');

[tWinter,~, ~, ~, vGRF_winter, hGRF_winter] = getWinterData(GaitInfo.WinterDataSpeed);
if size(vGRF_winter,2) > size(vGRF_winter,2)
    vGRF_winter = vGRF_winter';
    hGRF_winter = hGRF_winter';
end
%%
GRFDataFig = figure();

% sgtitle('Ground Reaction Forces')

if false
    plotHandlesLeft = plotGRFDataInFigure(t_left_perc,L_Ball,L_Total,L_Heel);
    plotHandlesRight = plotGRFDataInFigure(t_right_perc,R_Ball,R_Total,R_Heel);
    set(GRFDataFig, 'Position',[10,50,1600,900]);
else
    plotHandlesLeft = plotTotalGRFDataInFigure(t_left_perc,L_Total,GaitInfo.b_oneGaitPhase);
    plotHandlesRight = plotTotalGRFDataInFigure(t_right_perc,R_Total,GaitInfo.b_oneGaitPhase);
    if GaitInfo.b_oneGaitPhase
        plotHandlesWinter = plotTotalGRFDataInFigure(tWinter,[hGRF_winter,vGRF_winter]);
    end
    set(GRFDataFig, 'Position',[10,50,800,600]);
end

if GaitInfo.b_oneGaitPhase && contains(saveInfo.info,'prosthetic')
    leg = legend('Intact leg','Prosthetic leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')) );
elseif GaitInfo.b_oneGaitPhase
    leg = legend('Left leg','Right leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')) );
elseif contains(saveInfo.info,'prosthetic')
    leg = legend('Intact leg','Prosthetic leg');
else
    leg = legend('Left leg','Right leg');
end
set(leg,'FontSize',18);

for i= 1:length(plotHandlesLeft)
    set(plotHandlesLeft(i),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    set(plotHandlesRight(i),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    if GaitInfo.b_oneGaitPhase
        set(plotHandlesWinter(i),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
    end
end

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(GRFDataFig,'GRFData',saveInfo.type{j},saveInfo.info)
    end
end