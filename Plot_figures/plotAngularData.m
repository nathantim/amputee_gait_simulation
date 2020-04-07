function plotAngularData(angularData,plotInfo,oneGaitinfo,saveInfo)
%%
t_left = oneGaitinfo.time.left;
t_right = oneGaitinfo.time.right;

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

%%
angularDataFig = figure();

[timeWinter,hipAngleWinter, kneeAngleWinter, ankleAngleWinter, ~, ~] = getWinterData('normal');

%%
if true
    subplot(4,1,1);
    HATAnglePlot = plot(t_left,HATAngle);
    title('HAT angle')
    ylabel('rad');
    
    plotHandlesLeft = plotAngularDataInFigure(t_left,LhipAngles,LkneeAngles,LankleAngles);
    plotHandlesRight = plotAngularDataInFigure(t_right,RhipAngles,RkneeAngles,RankleAngles);
    plotHandlesWinter = plotAngularDataInFigure(timeWinter,(-hipAngleWinter),kneeAngleWinter,ankleAngleWinter);
end
%%
if false
    subplot(4,2,1);
    HATAnglePlot = plot(t_left,HATAngle);
    title('HAT angle')
    ylabel('rad');
    subplot(4,2,2);
    HATAngleVelPlot = plot(t_left,HATAngleVel);
    title('HAT angular velocity')
    ylabel('rad/s')
    
    set(HATAngleVelPlot,plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    
    plotHandlesLeft = plotAngular_a_VelDataInFigure(t_left,LhipAngles,LhipAnglesVel,...
        LkneeAngles,LkneeAnglesVel,LankleAngles,LankleAnglesVel);
    
    plotHandlesRight = plotAngular_a_VelDataInFigure(t_right,RhipAngles,RhipAnglesVel...
        ,RkneeAngles,RkneeAnglesVel,RankleAngles,RankleAnglesVel);

    plotHandlesWinter = plotAngular_a_VelDataInFigure(timeWinter,(-hipAngleWinter),'',kneeAngleWinter,'',ankleAngleWinter,'');
    
end

%%
set(HATAnglePlot,plotInfo.plotProp,plotInfo.plotProp_entries(1,:));

for i= 1:length(plotHandlesLeft)
    set(plotHandlesLeft(i),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    set(plotHandlesRight(i),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    if ~isnan(plotHandlesWinter(i))
        set(plotHandlesWinter(i),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
    end
end

set(angularDataFig, 'Position',[10,40,1000,930]);
leg = legend([plotHandlesLeft(2),plotHandlesRight(2),plotHandlesWinter(2)],'Left leg','Right leg', 'Winter data');
% set(leg,'Location','northwest');
set(leg,'FontSize',18);
set(leg,'Location','best');

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(angularDataFig,'angularData',saveInfo.type{j},saveInfo.info)
    end
end
