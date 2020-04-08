function plotAngularData(angularData,GaitPhaseData,plotInfo,oneGaitinfo,saveInfo)
%%
t_left_perc = oneGaitinfo.time.left_perc;
t_right_perc = oneGaitinfo.time.right_perc;

%%

HATAngle    = angularData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,1);
HATAngleVel = angularData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,2);

LhipAngles      = angularData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,3);
LhipAnglesVel   = angularData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,4);
RhipAngles      = angularData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,5);
RhipAnglesVel   = angularData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,6);

LkneeAngles     = angularData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,7);
LkneeAnglesVel  = angularData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,8);
RkneeAngles     = angularData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,9);
RkneeAnglesVel  = angularData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,10);

LankleAngles    = angularData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,11);
LankleAnglesVel = angularData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,12);
RankleAngles    = angularData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,13);
RankleAnglesVel = angularData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,14);

leftLegState    = GaitPhaseData.signals.values(oneGaitinfo.start.left:oneGaitinfo.end.left,1);
rightLegState   = GaitPhaseData.signals.values(oneGaitinfo.start.right:oneGaitinfo.end.right,2);

%%
angularDataFig = figure();

[timeWinter,hipAngleWinter, kneeAngleWinter, ankleAngleWinter, ~, ~] = getWinterData('normal');

%%
if true
     
    subplot(5,1,1);
    legStatePlot = plot(t_left_perc,leftLegState,t_right_perc,rightLegState);
    title('leg state')

    subplot(5,1,2);
    HATAnglePlot = plot(t_left_perc,HATAngle);
    title('HAT angle')
    ylabel('rad');
    
    plotHandlesLeft = plotAngularDataInFigure(t_left_perc,LhipAngles,LkneeAngles,LankleAngles);
    plotHandlesRight = plotAngularDataInFigure(t_right_perc,RhipAngles,RkneeAngles,RankleAngles);
    plotHandlesWinter = plotAngularDataInFigure(timeWinter,(-hipAngleWinter),kneeAngleWinter,ankleAngleWinter);
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
        LkneeAngles,LkneeAnglesVel,LankleAngles,LankleAnglesVel);
    
    plotHandlesRight = plotAngular_a_VelDataInFigure(t_right_perc,RhipAngles,RhipAnglesVel...
        ,RkneeAngles,RkneeAnglesVel,RankleAngles,RankleAnglesVel);

    plotHandlesWinter = plotAngular_a_VelDataInFigure(timeWinter,(-hipAngleWinter),'',kneeAngleWinter,'',ankleAngleWinter,'');
    
end

%%
set(legStatePlot,plotInfo.plotProp,plotInfo.plotProp_entries(1:2,:));
set(HATAnglePlot,plotInfo.plotProp,plotInfo.plotProp_entries(1,:));

for i= 1:length(plotHandlesLeft)
    set(plotHandlesLeft(i),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    set(plotHandlesRight(i),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    if ~isnan(plotHandlesWinter(i))
        set(plotHandlesWinter(i),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
    end
end

set(angularDataFig, 'Position',[10,40,1000,930]);

if contains(saveInfo.info,'prosthetic')
    leg = legend([plotHandlesLeft(2),plotHandlesRight(2),plotHandlesWinter(2)],'Intact leg','Prosthetic leg', 'Winter data');
else
    leg = legend([plotHandlesLeft(2),plotHandlesRight(2),plotHandlesWinter(2)],'Left leg','Right leg', 'Winter data');
end

% set(leg,'Location','northwest');
set(leg,'FontSize',18);
set(leg,'Location','best');

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(angularDataFig,'angularData',saveInfo.type{j},saveInfo.info)
    end
end
