function plotAngularData(angularData,GaitPhaseData,plotInfo,GaitInfo,saveInfo,angularDataFigure)
if nargin < 6
    angularDataFigure = [];
end
t = angularData.time;
%%
t_left_perc = GaitInfo.time.left_perc;
t_right_perc = GaitInfo.time.right_perc;

%%

% HATAngle    = 2*180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,1);
% HATAngleVel = 180/pi*angularData.signals.values(GaitInfo.start.left:GaitInfo.end.left,2);

LhipAngles      = -180/pi*angularData.signals.values(:,3);
LhipAnglesVel   = -180/pi*angularData.signals.values(:,4);

RhipAngles      = -180/pi*angularData.signals.values(:,5);
RhipAnglesVel   = -180/pi*angularData.signals.values(:,6);

LkneeAngles     = 180/pi*angularData.signals.values(:,7);
LkneeAnglesVel  = 180/pi*angularData.signals.values(:,8);
RkneeAngles     = 180/pi*angularData.signals.values(:,9);
RkneeAnglesVel  = 180/pi*angularData.signals.values(:,10);

LankleAngles    = -180/pi*angularData.signals.values(:,11);
LankleAnglesVel = -180/pi*angularData.signals.values(:,12);
RankleAngles    = -180/pi*angularData.signals.values(:,13);
RankleAnglesVel = -180/pi*angularData.signals.values(:,14);

warning('Unreasoned factor -1');

leftLegState    = GaitPhaseData.signals.values(:,1);
rightLegState   = GaitPhaseData.signals.values(:,2);



[leftLegState_avg,leftLegState_sd] = interpData2perc(t,GaitInfo.tp,leftLegState,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[rightLegState_avg,rightLegState_sd] = interpData2perc(t,GaitInfo.tp,rightLegState,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

[LhipAngles_avg,LhipAngles_sd] = interpData2perc(t,GaitInfo.tp,LhipAngles,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LkneeAngles_avg,LkneeAngles_sd] = interpData2perc(t,GaitInfo.tp,LkneeAngles,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LankleAngles_avg,LankleAngles_sd] = interpData2perc(t,GaitInfo.tp,LankleAngles,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[RhipAngles_avg,RhipAngles_sd] = interpData2perc(t,GaitInfo.tp,RhipAngles,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RkneeAngles_avg,RkneeAngles_sd] = interpData2perc(t,GaitInfo.tp,RkneeAngles,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RankleAngles_avg,RankleAngles_sd] = interpData2perc(t,GaitInfo.tp,RankleAngles,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

[LhipAnglesVel_avg,LhipAnglesVel_sd] = interpData2perc(t,GaitInfo.tp,LhipAnglesVel,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LkneeAnglesVel_avg,LkneeAnglesVel_sd] = interpData2perc(t,GaitInfo.tp,LkneeAnglesVel,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LankleAnglesVel_avg,LankleAnglesVel_sd] = interpData2perc(t,GaitInfo.tp,LankleAnglesVel,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[RhipAnglesVel_avg,RhipAnglesVel_sd] = interpData2perc(t,GaitInfo.tp,RhipAnglesVel,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RkneeAnglesVel_avg,RkneeAnglesVel_sd] = interpData2perc(t,GaitInfo.tp,RkneeAnglesVel,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RankleAnglesVel_avg,RankleAnglesVel_sd] = interpData2perc(t,GaitInfo.tp,RankleAnglesVel,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

if ~plotInfo.showSD
    leftLegState_sd = [];
    rightLegState_sd = [];
    LhipAngles_sd = [];
    LkneeAngles_sd = [];
    LankleAngles_sd = [];
    RhipAngles_sd = [];
    RkneeAngles_sd = [];
    RankleAngles_sd = [];
    LhipAnglesVel_sd = [];
    LkneeAnglesVel_sd = [];
    LankleAnglesVel_sd = [];
    RhipAnglesVel_sd = [];
    RkneeAnglesVel_sd = [];
    RankleAnglesVel_sd = [];
end

%%
if isempty(angularDataFigure)
    angularDataFig = figure();
    set(angularDataFig, 'Position',[10,0,1000,1530]);
else
   
    angularDataFig = angularDataFigure; 
end

[timeWinter,hipAngleWinter_avg,hipAngleWinter_sd, kneeAngleWinter_avg,kneeAngleWinter_sd, ankleAngleWinter_avg,ankleAngleWinter_sd, ~, ~] = getWinterData(GaitInfo.WinterDataSpeed,"deg");

%%
if true
 %%
    legStatePlot = subplot(4,1,1,axes(angularDataFig));
    if ~GaitInfo.b_oneGaitPhase
        GaitInfo.tp = GaitPhaseData.time;
    end
        
    if ~isempty(leftLegState_sd)
        LegHandles(1,2) = fill(legStatePlot,[GaitInfo.tp;flipud(GaitInfo.tp)],[round(leftLegState_avg-leftLegState_sd);flipud(round(leftLegState_avg+leftLegState_sd))],[0.8 0.8 0.8]);
    end
    set(legStatePlot,'NextPlot','add');
    if ~isempty(rightLegState_sd)
        LegHandles(2,2) = fill(legStatePlot,[GaitInfo.tp;flipud(GaitInfo.tp)],[round(rightLegState_avg-rightLegState_sd);flipud(round(rightLegState_avg+rightLegState_sd))],[0.8 0.8 0.8]);
    end
    
    LegHandles(1,1) = stairs(legStatePlot,GaitInfo.tp,round(leftLegState_avg));
%     stairs(legStatePlot,t_left_perc,round(leftLegState_avg));
    LegHandles(2,1) = stairs(legStatePlot,GaitInfo.tp,round(rightLegState_avg));
%     stairs(legStatePlot,t_right_perc,rightLegState);
    title(legStatePlot,'Leg state')
    yticks(legStatePlot,0:1:4);
    yticklabels(legStatePlot,{'EarlyStance','LateStance','Lift-off','Swing','Landing'})

%     subplot(5,1,2);
%     HATAnglePlot = plot(t_left_perc,HATAngle);
%     title('HAT angle')
%     ylabel('rad');
%%
    subplotStart = 412;
    
    if ~GaitInfo.b_oneGaitPhase
        GaitInfo.tp = angularData.time;
    end
    [plotHandlesLeft,axesHandles] = plotAngularDataInFigure(angularDataFig,[],GaitInfo.tp,LhipAngles_avg,LhipAngles_sd,LkneeAngles_avg,LkneeAngles_sd,LankleAngles_avg,LankleAngles_sd,subplotStart,GaitInfo.b_oneGaitPhase);
    [plotHandlesRight,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,GaitInfo.tp,RhipAngles_avg,RhipAngles_sd,RkneeAngles_avg,RkneeAngles_sd,RankleAngles_avg,RankleAngles_sd,subplotStart,GaitInfo.b_oneGaitPhase);
    if GaitInfo.b_oneGaitPhase
        [plotHandlesWinter,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,timeWinter,hipAngleWinter_avg,hipAngleWinter_sd,kneeAngleWinter_avg,kneeAngleWinter_sd, ...
            ankleAngleWinter_avg,ankleAngleWinter_sd,subplotStart);
    end

end

%%
% set(flipud(legStatePlot.Children),plotInfo.plotProp,plotInfo.plotProp_entries(1:2,:));
for j = 1:size(LegHandles,1)
    set(LegHandles(j,1),plotInfo.plotProp,plotInfo.plotProp_entries(j,:));
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        set(LegHandles(j,2),plotInfo.fillProp,plotInfo.fillProp_entries(j,:));
    end
end

if exist('HATAnglePlot','var') == 1
    set(HATAnglePlot,plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
end

for i= 1:size(plotHandlesLeft,1)
    set(plotHandlesLeft(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    set(plotHandlesRight(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        set(plotHandlesLeft(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(1,:));
        set(plotHandlesRight(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(2,:));
    end
    if GaitInfo.b_oneGaitPhase && ~isnan(plotHandlesWinter(i,1))
        set(plotHandlesWinter(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotHandlesWinter(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
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
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Intact leg','Prosthetic leg');
%     leg = legend('Intact leg','Prosthetic leg');
else
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Left leg','Right leg');
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
