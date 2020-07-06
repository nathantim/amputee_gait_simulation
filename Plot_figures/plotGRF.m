function plotGRF(GRFData,plotInfo,GaitInfo,saveInfo,GRFDataFigure)
if nargin < 5
    GRFDataFigure = [];
end
%%
t_left_perc = GaitInfo.time.left_perc;
t_right_perc = GaitInfo.time.right_perc;
GRFData.signals.values = GRFData.signals.values./getBodyMass();
% L_Ball  = GRFData.signals.values(GaitInfo.start.left:GaitInfo.end.left,1:2);
L_Total_x = GRFData.signals.values(GaitInfo.start.left:GaitInfo.end.left,1);
L_Total_z = GRFData.signals.values(GaitInfo.start.left:GaitInfo.end.left,3);
% L_Heel  = GRFData.signals.values(GaitInfo.start.left:GaitInfo.end.left,5:6);

% R_Ball  = GRFData.signals.values(GaitInfo.start.right:GaitInfo.end.right,7:8);
R_Total_x = GRFData.signals.values(GaitInfo.start.right:GaitInfo.end.right,4);
R_Total_z = GRFData.signals.values(GaitInfo.start.right:GaitInfo.end.right,6);
% R_Heel  = GRFData.signals.values(GaitInfo.start.right:GaitInfo.end.right,11:12);

warning('Direction stuff');
% L_Total_x = -1*L_Total_x;
% R_Total_x = -1*R_Total_x;
% warning('Unreasoned factor -1');

[tWinter,~, ~, ~,~,~,~, vGRF_winter_avg,vGRF_winter_sd, hGRF_winter_avg,hGRF_winter_sd] = getWinterData(GaitInfo.WinterDataSpeed);
if size(vGRF_winter_avg,2) > size(vGRF_winter_avg,2)
    vGRF_winter_avg = vGRF_winter_avg';
    hGRF_winter_avg = hGRF_winter_avg';
end
%%
if isempty(GRFDataFigure)
    GRFDataFig = figure();
    set(GRFDataFig, 'Position',[10,50,800,600]);
else
   GRFDataFig = GRFDataFigure; 
%    clf(GRFDataFig);
end

% sgtitle('Ground Reaction Forces')

if false
%     plotHandlesLeft = plotGRFDataInFigure(t_left_perc,L_Ball,L_Total,L_Heel);
%     plotHandlesRight = plotGRFDataInFigure(t_right_perc,R_Ball,R_Total,R_Heel);
%     set(GRFDataFig, 'Position',[10,50,1600,900]);
else
    [plotHandlesLeft,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,[],t_left_perc,L_Total_x,[],L_Total_z,[],GaitInfo.b_oneGaitPhase);
    [plotHandlesRight,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,t_right_perc,R_Total_x,[],R_Total_z,[],GaitInfo.b_oneGaitPhase);
    if GaitInfo.b_oneGaitPhase
        [plotHandlesWinter,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,tWinter,hGRF_winter_avg,hGRF_winter_sd,vGRF_winter_avg,vGRF_winter_sd);
    end

end

if GaitInfo.b_oneGaitPhase && contains(saveInfo.info,'prosthetic')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Intact leg','Prosthetic leg', 'Winter data');
%     leg = legend('Intact leg','Prosthetic leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')) );
elseif GaitInfo.b_oneGaitPhase
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Left leg','Right leg', 'Winter data');
%     leg = legend('Left leg','Right leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')));
elseif contains(saveInfo.info,'prosthetic')
    leg = legend([plotHandlesLeft(2),plotHandlesRight(2)],'Intact leg','Prosthetic leg');
%     leg = legend('Intact leg','Prosthetic leg');
else
    leg = legend([plotHandlesLeft(2),plotHandlesRight(2)],'Left leg','Right leg');
%     leg = legend('Left leg','Right leg');
end
set(leg,'FontSize',18);

for i= 1:size(plotHandlesLeft,1)
    set(plotHandlesLeft(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    set(plotHandlesRight(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    if GaitInfo.b_oneGaitPhase && ~isnan(plotHandlesWinter(i,1))
        set(plotHandlesWinter(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotHandlesWinter(i,2),plotInfo.fillProp,plotInfo.fillVal);
    end
end

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(GRFDataFig,'GRFData',saveInfo.type{j},saveInfo.info)
    end
end