function plotAngularData(angularData,GaitPhaseData,plotInfo,GaitInfo,saveInfo,angularDataFigure)
if nargin < 6
    angularDataFigure = [];
end
%%
t_left_perc = GaitInfo.time.left_perc;
t_right_perc = GaitInfo.time.right_perc;

%%

HATAngle    = 2*180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,1);
HATAngleVel = 180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,2);

LhipAngles      = -180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,3);
LhipAnglesVel   = -180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,4);
RhipAngles      = -180/pi*angularData.signals.values(GaitInfo.start.right:GaitInfo.end.right,5);
RhipAnglesVel   = -180/pi*angularData.signals.values(GaitInfo.start.right:GaitInfo.end.right,6);

LkneeAngles     = 180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,7);
LkneeAnglesVel  = 180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,8);
RkneeAngles     = 180/pi*angularData.signals.values(GaitInfo.start.right:GaitInfo.end.right,9);
RkneeAnglesVel  = 180/pi*angularData.signals.values(GaitInfo.start.right:GaitInfo.end.right,10);

LankleAngles    = -180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,11);
LankleAnglesVel = -180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,12);
RankleAngles    = -180/pi*angularData.signals.values(GaitInfo.start.right:GaitInfo.end.right,13);
RankleAnglesVel = -180/pi*angularData.signals.values(GaitInfo.start.right:GaitInfo.end.right,14);
warning('Unreasoned factor -1');

leftLegState    = GaitPhaseData.signals.values(GaitInfo.start.left:GaitInfo.end.left,1);
rightLegState   = GaitPhaseData.signals.values(GaitInfo.start.right:GaitInfo.end.right,2);

%%
if isempty(angularDataFigure)
    angularDataFig = figure();
    set(angularDataFig, 'Position',[10,0,1000,1530]);
else
   
    angularDataFig = angularDataFigure; 
    clf(angularDataFig);
end

[timeWinter,hipAngleWinter_avg,hipAngleWinter_sd, kneeAngleWinter_avg,kneeAngleWinter_sd, ankleAngleWinter_avg,ankleAngleWinter_sd, ~, ~] = getWinterData(GaitInfo.WinterDataSpeed,"deg");

%%
if true
     
    legStatePlot = subplot(4,1,1,axes(angularDataFig));
    stairs(legStatePlot,t_left_perc,leftLegState);
    set(legStatePlot,'NextPlot','add');
    stairs(legStatePlot,t_right_perc,rightLegState);
    title(legStatePlot,'Leg state')
    yticks(legStatePlot,0:1:4);
    yticklabels(legStatePlot,{'EarlyStance','LateStance','Lift-off','Swing','Landing'})

%     subplot(5,1,2);
%     HATAnglePlot = plot(t_left_perc,HATAngle);
%     title('HAT angle')
%     ylabel('rad');
    
    subplotStart = 412;
    [plotHandlesLeft,axesHandles] = plotAngularDataInFigure(angularDataFig,[],t_left_perc,LhipAngles,[],LkneeAngles,[],LankleAngles,[],subplotStart,GaitInfo.b_oneGaitPhase);
    [plotHandlesRight,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,t_right_perc,RhipAngles,[],RkneeAngles,[],RankleAngles,[],subplotStart,GaitInfo.b_oneGaitPhase);
    if GaitInfo.b_oneGaitPhase
        [plotHandlesWinter,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,timeWinter,hipAngleWinter_avg,hipAngleWinter_sd,kneeAngleWinter_avg,kneeAngleWinter_sd, ...
                                                    ankleAngleWinter_avg,ankleAngleWinter_sd,subplotStart);
    end
end

%%
set(flipud(legStatePlot.Children),plotInfo.plotProp,plotInfo.plotProp_entries(1:2,:));

if exist('HATAnglePlot','var') == 1
    set(HATAnglePlot,plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
end

for i= 1:size(plotHandlesLeft,1)
    set(plotHandlesLeft(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    set(plotHandlesRight(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    if GaitInfo.b_oneGaitPhase && ~isnan(plotHandlesWinter(i,1))
        set(plotHandlesWinter(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotHandlesWinter(i,2),plotInfo.fillProp,plotInfo.fillVal);
    end
end


% set(angularDataFig, 'Position',[10,40,1000,930]);

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

% set(leg,'Location','north');
set(leg,'FontSize',14);
set(leg,'Location','best');

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(angularDataFig,'angularData',saveInfo.type{j},saveInfo.info)
    end
end
