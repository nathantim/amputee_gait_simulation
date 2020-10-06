function axesHandles = plotPhasePortrait(angularData,plotInfo,GaitInfo,saveInfo,phasePortraitFigure,axesHandles,subplotStart,b_plotBothLegs,b_addTitle)
if nargin < 5
    phasePortraitFigure = [];
end
if nargin < 6
    axesHandles = [];
end

if nargin < 7 || isempty(subplotStart)
    subplotStart = [1 4 1];
    setLegend = true;
else
    setLegend = false;
end
if nargin < 8
    b_plotBothLegs = true;
end
if nargin < 9
    b_addTitle = true;
end

t = angularData.time;

%%
LhipAngle          = -180/pi*angularData.signals.values(:,3);
LhipAngleVel       = -180/pi*angularData.signals.values(:,4);

RhipAngle          = -180/pi*angularData.signals.values(:,5);
RhipAngleVel       = -180/pi*angularData.signals.values(:,6);

LkneeAngle         = 180/pi*angularData.signals.values(:,7);
LkneeAngleVel      = 180/pi*angularData.signals.values(:,8);
RkneeAngle         = 180/pi*angularData.signals.values(:,9);
RkneeAngleVel      = 180/pi*angularData.signals.values(:,10);

LankleAngle        = -180/pi*angularData.signals.values(:,11);
LankleAngleVel     = -180/pi*angularData.signals.values(:,12);
RankleAngle        = -180/pi*angularData.signals.values(:,13);
RankleAngleVel     = -180/pi*angularData.signals.values(:,14);

LhipRollAngle      = 180/pi*angularData.signals.values(:,15);
LhipRollAngleVel   = 180/pi*angularData.signals.values(:,16);
RhipRollAngle      = 180/pi*angularData.signals.values(:,17);
RhipRollAngleVel   = 180/pi*angularData.signals.values(:,18);

%%
[LhipAngle_avg,LhipAngle_sd] = interpData2perc(t,GaitInfo.tp,LhipAngle,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LhipRollAngle_avg,LhipRollAngle_sd] = interpData2perc(t,GaitInfo.tp,LhipRollAngle,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LkneeAngle_avg,LkneeAngle_sd] = interpData2perc(t,GaitInfo.tp,LkneeAngle,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LankleAngle_avg,LankleAngle_sd] = interpData2perc(t,GaitInfo.tp,LankleAngle,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[RhipAngle_avg,RhipAngle_sd] = interpData2perc(t,GaitInfo.tp,RhipAngle,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RhipRollAngle_avg,RhipRollAngle_sd] = interpData2perc(t,GaitInfo.tp,RhipRollAngle,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RkneeAngle_avg,RkneeAngle_sd] = interpData2perc(t,GaitInfo.tp,RkneeAngle,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RankleAngle_avg,RankleAngle_sd] = interpData2perc(t,GaitInfo.tp,RankleAngle,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

[LhipAngleVel_avg,LhipAngleVel_sd] = interpData2perc(t,GaitInfo.tp,LhipAngleVel,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LhipRollAngleVel_avg,LhipRollAngleVel_sd] = interpData2perc(t,GaitInfo.tp,LhipRollAngleVel,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LkneeAngleVel_avg,LkneeAngleVel_sd] = interpData2perc(t,GaitInfo.tp,LkneeAngleVel,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LankleAngleVel_avg,LankleAngleVel_sd] = interpData2perc(t,GaitInfo.tp,LankleAngleVel,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[RhipAngleVel_avg,RhipAngleVel_sd] = interpData2perc(t,GaitInfo.tp,RhipAngleVel,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RhipRollAngleVel_avg,RhipRollAngleVel_sd] = interpData2perc(t,GaitInfo.tp,RhipRollAngleVel,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RkneeAngleVel_avg,RkneeAngleVel_sd] = interpData2perc(t,GaitInfo.tp,RkneeAngleVel,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RankleAngleVel_avg,RankleAngleVel_sd] = interpData2perc(t,GaitInfo.tp,RankleAngleVel,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

if ~plotInfo.showSD
    LhipAngle_sd           = [];
    LhipRollAngle_sd       = [];
    LkneeAngle_sd          = [];
    LankleAngle_sd         = [];
    RhipAngle_sd           = [];
    RhipRollAngle_sd       = [];
    RkneeAngle_sd          = [];
    RankleAngle_sd         = [];
    
    LhipAngleVel_sd        = [];
    LhipRollAngleVel_sd    = [];
    LkneeAngleVel_sd       = [];
    LankleAngleVel_sd      = [];
    RhipAngleVel_sd        = [];
    RhipRollAngleVel_sd    = [];
    RkneeAngleVel_sd       = [];
    RankleAngleVel_sd      = [];
    
end

%%
if isempty(phasePortraitFigure)
    phasePortraitFig = figure();
    set(phasePortraitFig, 'Position',[10,100,1700,800]);
else
   
    phasePortraitFig = phasePortraitFigure; 
end

[plotHandlesLeft,axesHandles] = plotPhasePortraitInFigure(phasePortraitFig,axesHandles,LhipAngle_avg,LhipAngle_sd, ...
    LhipRollAngle_avg,LhipRollAngle_sd,LkneeAngle_avg,LkneeAngle_sd,LankleAngle_avg,LankleAngle_sd,LhipAngleVel_avg,LhipAngleVel_sd, ...
    LhipRollAngleVel_avg,LhipRollAngleVel_sd,LkneeAngleVel_avg,LkneeAngleVel_sd,LankleAngleVel_avg,LankleAngleVel_sd,...
    subplotStart,GaitInfo.b_oneGaitPhase,b_addTitle);

if b_plotBothLegs
    [plotHandlesRight,axesHandles] = plotPhasePortraitInFigure(phasePortraitFig,axesHandles,RhipAngle_avg,RhipAngle_sd, ...
        RhipRollAngle_avg,RhipRollAngle_sd,RkneeAngle_avg,RkneeAngle_sd,RankleAngle_avg,RankleAngle_sd,RhipAngleVel_avg,RhipAngleVel_sd, ...
        RhipRollAngleVel_avg,RhipRollAngleVel_sd,RkneeAngleVel_avg,RkneeAngleVel_sd,RankleAngleVel_avg,RankleAngleVel_sd,...
        subplotStart,GaitInfo.b_oneGaitPhase,false);
end


if setLegend
    if GaitInfo.b_oneGaitPhase
        xlabel(axesHandles(end),'Angle (deg)');
    else
        xlabel(axesHandles(end),'s');
    end
end

%%
for i= 1:size(plotHandlesLeft,1)
    set(plotHandlesLeft(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    if b_plotBothLegs
        set(plotHandlesRight(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
end


if setLegend && contains(saveInfo.info,'prosthetic')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Intact leg','Prosthetic leg');
%     leg = legend('Intact leg','Prosthetic leg');
elseif setLegend && ~b_plotBothLegs
    leg = [];
elseif setLegend 
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Left leg','Right leg');
else
    leg = [];
end

% set(leg,'Location','north');
if ~isempty(leg)
    set(leg,'FontSize',14);
    set(leg,'Location','best');
end

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(angularDataFig,'phasePortrait',saveInfo.type{j},saveInfo.info)
    end
end