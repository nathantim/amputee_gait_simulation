function plotAngularData(angularData,GaitPhaseData,plotInfo,GaitInfo,saveInfo)
%%
t_left_perc = GaitInfo.time.left_perc;
t_right_perc = GaitInfo.time.right_perc;

%%

HATAngle    = 180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,1);
HATAngleVel = 180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,2);

LhipAngles      = 180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,3);
LhipAnglesVel   = 180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,4);
RhipAngles      = 180/pi*angularData.signals.values(GaitInfo.start.right:GaitInfo.end.right,5);
RhipAnglesVel   = 180/pi*angularData.signals.values(GaitInfo.start.right:GaitInfo.end.right,6);

LkneeAngles     = 180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,7);
LkneeAnglesVel  = 180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,8);
RkneeAngles     = 180/pi*angularData.signals.values(GaitInfo.start.right:GaitInfo.end.right,9);
RkneeAnglesVel  = 180/pi*angularData.signals.values(GaitInfo.start.right:GaitInfo.end.right,10);

LankleAngles    = 180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,11);
LankleAnglesVel = 180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,12);
RankleAngles    = 180/pi*angularData.signals.values(GaitInfo.start.right:GaitInfo.end.right,13);
RankleAnglesVel = 180/pi*angularData.signals.values(GaitInfo.start.right:GaitInfo.end.right,14);

leftLegState    = GaitPhaseData.signals.values(GaitInfo.start.left:GaitInfo.end.left,1);
rightLegState   = GaitPhaseData.signals.values(GaitInfo.start.right:GaitInfo.end.right,2);

%%
angularDataFig = figure();

[timeWinter,hipAngleWinter, kneeAngleWinter, ankleAngleWinter, ~, ~] = getWinterData(GaitInfo.WinterDataSpeed);

%%
if true
     
    subplot(5,1,1);
    legStatePlot = plot(t_left_perc,leftLegState,t_right_perc,rightLegState);
    title('leg state')

    subplot(5,1,2);
    HATAnglePlot = plot(t_left_perc,HATAngle);
    title('HAT angle')
    ylabel('rad');
    
    plotHandlesLeft = plotAngularDataInFigure(t_left_perc,LhipAngles,LkneeAngles,LankleAngles,GaitInfo.b_oneGaitPhase);
    plotHandlesRight = plotAngularDataInFigure(t_right_perc,RhipAngles,RkneeAngles,RankleAngles,GaitInfo.b_oneGaitPhase);
    if GaitInfo.b_oneGaitPhase
        plotHandlesWinter = plotAngularDataInFigure(timeWinter,180/pi*(-hipAngleWinter),180/pi*kneeAngleWinter,180/pi*(-ankleAngleWinter));
        warning('Unreasoned factor -1');
    end
end
%%
if false
    subplot(4,2,1);
    HATAnglePlot = plot(t_left_perc,HATAngle);
    title('HAT angle')
    ylabel('rad');
    subplot(4,2,2);
    HATAngleVelPlot = plot(t_left_perc,HATAngleVel);
    title('HAT angular velocity')
    ylabel('rad/s')
    
    set(HATAngleVelPlot,plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    
    plotHandlesLeft = plotAngular_a_VelDataInFigure(t_left_perc,LhipAngles,LhipAnglesVel,...
        LkneeAngles,LkneeAnglesVel,LankleAngles,LankleAnglesVel,GaitInfo.b_oneGaitPhase);
    
    plotHandlesRight = plotAngular_a_VelDataInFigure(t_right_perc,RhipAngles,RhipAnglesVel...
        ,RkneeAngles,RkneeAnglesVel,RankleAngles,RankleAnglesVel,GaitInfo.b_oneGaitPhase);

    if oneGaitInfo.b_oneGaitPhase
        plotHandlesWinter = plotAngular_a_VelDataInFigure(timeWinter,180/pi*(-hipAngleWinter),'',180/pi*kneeAngleWinter,'',180/pi*(-ankleAngleWinter),'');
        warning('Unreasoned factor -1');
    end
end

%%
set(legStatePlot,plotInfo.plotProp,plotInfo.plotProp_entries(1:2,:));
set(HATAnglePlot,plotInfo.plotProp,plotInfo.plotProp_entries(1,:));

for i= 1:length(plotHandlesLeft)
    set(plotHandlesLeft(i),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    set(plotHandlesRight(i),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    if GaitInfo.b_oneGaitPhase && ~isnan(plotHandlesWinter(i))
        set(plotHandlesWinter(i),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
    end
end

set(angularDataFig, 'Position',[10,0,1000,1530]);
% set(angularDataFig, 'Position',[10,40,1000,930]);

if GaitInfo.b_oneGaitPhase && contains(saveInfo.info,'prosthetic')
%     leg = legend([plotHandlesLeft(2),plotHandlesRight(2),plotHandlesWinter(2)],'Intact leg','Prosthetic leg', 'Winter data');
    leg = legend('Intact leg','Prosthetic leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')) );
elseif GaitInfo.b_oneGaitPhase
%     leg = legend([plotHandlesLeft(2),plotHandlesRight(2),plotHandlesWinter(2)],'Left leg','Right leg', 'Winter data');
    leg = legend('Left leg','Right leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')));
elseif contains(saveInfo.info,'prosthetic')
%     leg = legend([plotHandlesLeft(2),plotHandlesRight(2)],'Intact leg','Prosthetic leg');
    leg = legend('Intact leg','Prosthetic leg');
else
%     leg = legend([plotHandlesLeft(2),plotHandlesRight(2)],'Left leg','Right leg');
    leg = legend('Left leg','Right leg');
end

set(leg,'Location','northwest');
set(leg,'FontSize',18);
% set(leg,'Location','best');

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(angularDataFig,'angularData',saveInfo.type{j},saveInfo.info)
    end
end
