function [plotHandles, axesHandles] = plotLegState(GaitPhaseData,plotInfo,GaitInfo,saveInfo,legStateFigure,axesHandles,subplotStart,legToPlot,b_addTitle)
if nargin < 5
    legStateFigure = [];
end
if nargin < 6
    axesHandles = [];
end
if nargin < 7 || isempty(subplotStart)
    %     subplotStart = 151;
    subplotStart = [1 1 1];
    
    setLegend = true;
    
else
    setLegend = false;
end
if nargin < 8
    legToPlot = 'both';
end
if nargin < 9
    b_addTitle = true;
end

t = GaitPhaseData.time;
%%


leftLegState    = GaitPhaseData.signals.values(:,1);
rightLegState   = GaitPhaseData.signals.values(:,2);



[leftLegState_avg,leftLegState_sd] = interpData2perc(t,GaitInfo.tp,leftLegState,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[rightLegState_avg,rightLegState_sd] = interpData2perc(t,GaitInfo.tp,rightLegState,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

% stance_perc = (find(round(leftLegState_avg)==2,1,'last')-1)*diff(GaitInfo.tp(1:2));
% swing_perc = 100 - stance_perc;
% early_stance_perc = (find(round(leftLegState_avg)==0,1,'last')-1)*diff(GaitInfo.tp(1:2));
% late_stance_perc = (find(round(leftLegState_avg)==1,1,'last')-1)*diff(GaitInfo.tp(1:2))-early_stance_perc;
% lift_off_perc = (find(round(leftLegState_avg)==2,1,'last')-1)*diff(GaitInfo.tp(1:2))-early_stance_perc-late_stance_perc;
% swing_state_perc = (find(round(leftLegState_avg)==3,1,'last')-1)*diff(GaitInfo.tp(1:2))-early_stance_perc-late_stance_perc-lift_off_perc;
% landing_perc = (find(round(leftLegState_avg)==4,1,'last')-1)*diff(GaitInfo.tp(1:2))-early_stance_perc-late_stance_perc-lift_off_perc-swing_state_perc;
fprintf('Left leg: \nstance: %1.1f%%, swing: %1.1f%%\nearly-stance: %1.1f%%, late-stance: %1.1f%%, lift-off: %1.1f%%, swing-state: %1.1f%%, landing: %1.1f%% \n',...
    GaitInfo.gaitstate.left.Stance,GaitInfo.gaitstate.left.Swing,GaitInfo.gaitstate.left.earlyStanceState,GaitInfo.gaitstate.left.lateStanceState,...
    GaitInfo.gaitstate.left.liftoffState,GaitInfo.gaitstate.left.swingState,GaitInfo.gaitstate.left.landingState);

if legToPlot
    %     stance_perc = (find(round(rightLegState_avg)==2,1,'last')-1)*diff(GaitInfo.tp(1:2));
    %     swing_perc = 100 - stance_perc;
    %     early_stance_perc = (find(round(rightLegState_avg)==0,1,'last')-1)*diff(GaitInfo.tp(1:2));
    %     late_stance_perc = (find(round(rightLegState_avg)==1,1,'last')-1)*diff(GaitInfo.tp(1:2))-early_stance_perc;
    %     lift_off_perc = (find(round(rightLegState_avg)==2,1,'last')-1)*diff(GaitInfo.tp(1:2))-early_stance_perc-late_stance_perc;
    %     swing_state_perc = (find(round(rightLegState_avg)==3,1,'last')-1)*diff(GaitInfo.tp(1:2))-early_stance_perc-late_stance_perc-lift_off_perc;
    %     landing_perc = (find(round(rightLegState_avg)==4,1,'last')-1)*diff(GaitInfo.tp(1:2))-early_stance_perc-late_stance_perc-lift_off_perc-swing_state_perc;
    fprintf('Right leg: \nstance: %1.1f%%, swing: %1.1f%%\nearly-stance: %1.1f%%, late-stance: %1.1f%%, lift-off: %1.1f%%, swing-state: %1.1f%%, landing: %1.1f%% \n',...
        GaitInfo.gaitstate.right.Stance,GaitInfo.gaitstate.right.Swing,GaitInfo.gaitstate.right.earlyStanceState,GaitInfo.gaitstate.right.lateStanceState,...
        GaitInfo.gaitstate.right.liftoffState,GaitInfo.gaitstate.right.swingState,GaitInfo.gaitstate.right.landingState);
    
end
if ~plotInfo.showSD
    leftLegState_sd = [];
    rightLegState_sd = [];
end

%%
plotHandlesLeft = [];
plotHandlesRight = [];


if isempty(legStateFigure)
    legStateDataFig = figure();
    fullScreen = get(0,'screensize');
    set(legStateDataFig, 'Position',[fullScreen(1:2)+20 fullScreen(3:4)*0.9]);
else
    legStateDataFig = legStateFigure;
end
% set(0, 'DefaultAxesFontSize',12);
if ~GaitInfo.b_oneGaitPhase
    GaitInfo.tp = GaitPhaseData.time;
end

%     stairs(legStatePlot,t_right_perc,rightLegState);
if contains(legToPlot,'left') || contains(legToPlot,'both')
    [plotHandlesLeft,axesHandles] = plotLegStateInFigure(legStateDataFig,axesHandles,GaitInfo.tp,leftLegState_avg,leftLegState_sd,subplotStart,b_addTitle);
end
if contains(legToPlot,'right') || contains(legToPlot,'both')
    [plotHandlesRight,axesHandles] = plotLegStateInFigure(legStateDataFig,axesHandles,GaitInfo.tp,rightLegState_avg,rightLegState_sd,subplotStart,b_addTitle);
end

if setLegend
    if GaitInfo.b_oneGaitPhase
        xlabel(axesHandles(end),'gait cycle ($\%$)');
    else
        xlabel(axesHandles(end),'s');
    end
end

plotHandles = [plotHandlesLeft, plotHandlesRight];

%%
for ii = 1:size(plotHandles,1)
    set(plotHandles(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(ii,:));
    if size(plotHandles,2)>2
        set(plotHandles(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        set(plotHandles(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(ii,:));
        if size(plotHandles,2)>2
            set(plotHandles(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(2,:));
        end
    end
end



if setLegend && contains(saveInfo.info,'prosthetic') && contains(legToPlot,'both')
    leg = legend(plotHandles([1,3]),'Intact leg','Prosthetic leg');
    %     leg = legend('Intact leg','Prosthetic leg');
elseif setLegend && ~contains(legToPlot,'both')
    leg = [];
elseif setLegend && contains(legToPlot,'both')
    leg = legend(plotHandles([1,3]),'Left leg','Right leg');
else
    leg = [];
end

% set(leg,'Location','north');
if ~isempty(leg)
    set(leg,'FontSize',14);
    set(leg,'Location','best');
end

if saveInfo.b_saveFigure
    for ii = 1:length(saveInfo.type)
        saveFigure(legStateFig,'legState',saveInfo.type{ii},saveInfo.info)
    end
end
