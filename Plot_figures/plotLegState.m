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



[leftLegState_avg,leftLegState_sd] = interpData2perc(t,GaitInfo.tp,leftLegState,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase,'previous');
[rightLegState_avg,rightLegState_sd] = interpData2perc(t,GaitInfo.tp,rightLegState,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase,'previous');

if plotInfo.showTables && ~isempty(GaitInfo.gaitstate)
    rowNames = {'Stance','Double Stance (leg to other leg)','Swing'};
    if contains(saveInfo.info,'prosthetic')
        varNames = {'Left (%)','Right (%)', 'ASI_% (%)', 'Left (s)','Right (s)', 'ASI_s (%)'};%,'L mean propel impulse (N%/kg)','R mean propel impulse (N%/kg)'};
        vars = {GaitInfo.gaitstate.left.stanceMeanstdtxt_perc, GaitInfo.gaitstate.right.stanceMeanstdtxt_perc, GaitInfo.gaitstate.stanceASItxt_perc, ...
                GaitInfo.gaitstate.left.stanceMeanstdtxt, GaitInfo.gaitstate.right.stanceMeanstdtxt, GaitInfo.gaitstate.stanceASItxt; ...
                GaitInfo.gaitstate.left.doubleStanceMeanstdtxt_perc, GaitInfo.gaitstate.right.doubleStanceMeanstdtxt_perc, GaitInfo.gaitstate.doubleStanceASItxt_perc, ...
                GaitInfo.gaitstate.left.doubleStanceMeanstdtxt, GaitInfo.gaitstate.right.doubleStanceMeanstdtxt, GaitInfo.gaitstate.doubleStanceASItxt; ...
                GaitInfo.gaitstate.left.swingMeanstdtxt_perc, GaitInfo.gaitstate.right.swingMeanstdtxt_perc, GaitInfo.gaitstate.swingASItxt_perc, ...
                GaitInfo.gaitstate.left.swingMeanstdtxt, GaitInfo.gaitstate.right.swingMeanstdtxt, GaitInfo.gaitstate.swingASItxt};
        disp(table(vars(:,1),vars(:,2),vars(:,3),vars(:,4),vars(:,5),vars(:,6),'VariableNames',varNames,'RowNames',rowNames));
    else
        varNames = {'Total (%)', 'ASI_% (%)', 'Total (s)', 'ASI_s (%)'};%,'L mean propel impulse (N%/kg)','R mean propel impulse (N%/kg)'};
        vars = {GaitInfo.gaitstate.stanceMeanstdtxt_perc, GaitInfo.gaitstate.stanceASItxt_perc, ...
                GaitInfo.gaitstate.stanceMeanstdtxt, GaitInfo.gaitstate.stanceASItxt;...
                GaitInfo.gaitstate.doubleStanceMeanstdtxt_perc, GaitInfo.gaitstate.doubleStanceASItxt_perc, ...
                GaitInfo.gaitstate.doubleStanceMeanstdtxt, GaitInfo.gaitstate.doubleStanceASItxt;
                GaitInfo.gaitstate.swingMeanstdtxt_perc, GaitInfo.gaitstate.swingASItxt_perc, ...
                GaitInfo.gaitstate.swingMeanstdtxt, GaitInfo.gaitstate.swingASItxt};
        disp(table(vars(:,1),vars(:,2),vars(:,3),vars(:,4),'VariableNames',varNames,'RowNames',rowNames));
    end
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
    saveFigure(legStateFig,'legState',saveInfo.type,saveInfo.info)
end
