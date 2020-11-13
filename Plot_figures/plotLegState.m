function [plotHandles, axesHandles] = plotLegState(GaitPhaseData,plotInfo,GaitInfo,saveInfo,legStateFigure,axesHandles,subplotStart,legToPlot,b_addTitle)
% PLOTLEGSTATE                  Function that plots the state of the legs
% INPUTS:
%   - GaitPhaseData             Structure with time of the gait phase data from the simulation.
%   - plotInfo                  Structure containing linestyle, -width, -color etc.
%   - GaitInfo                  Structure containing information on where a stride begins and ends, whether to show average
%                               for stride, or just all the data.
%   - saveInfo                  Structure with info on how and if to save the figure
%   - legStateFigure          Optional, pre-created figure in which the leg state data can be plotted.
%   - axesHandles               Optional, pre-created axes in which the leg state data can be plotted.
%   - subplotStart              Optional, in case of multiple subfigures, this says in which subfigure to start.
%   - legToPlot                 Optional, select if you want to plot 'both' legs, or 'left', or 'right' leg.
%   - b_addTitle                Optional, boolean which selects if title of axis has to be put in the figure.
%
% OUTPUTS:
%   - plotHandles               Handles of all the plots, which can be used for later changes in line style etc, or for
%                               adding a legend.
%   - axesHandles               Handles of all the axes, which can be used for later changes in axes size, axes title
%                               locations etc.
%%
if nargin < 5
    legStateFigure = [];
end
if nargin < 6
    axesHandles = [];
end
if nargin < 7 || isempty(subplotStart)
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

if ~plotInfo.showSD
    leftLegState_sd = [];
    rightLegState_sd = [];
end

%%
if isempty(legStateFigure)
    legStateDataFig = figure();
    fullScreen = get(0,'screensize');
    set(legStateDataFig, 'Position',[fullScreen(1:2)+20 fullScreen(3:4)*0.9]);
else
    legStateDataFig = legStateFigure;
end

%% Plot the data
plotHandlesLeft = [];
plotHandlesRight = [];
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

%% Set the properties of the plotted lines
for ii= 1:max(size(plotHandlesLeft,1),size(plotHandlesRight,1))
    % Set line properties
    set(plotHandles(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    if size(plotHandles,2)>2
        set(plotHandles(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    % Set fill properties
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        set(plotHandles(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(1,:));
        if size(plotHandles,2)>2
            set(plotHandles(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(2,:));
        end
    end
end

%% Set legend
if setLegend && (contains(saveInfo.info,'prosthetic') || contains(saveInfo.info,'amputee')) && contains(legToPlot,'both')
    % Amputee gait
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Intact leg','Prosthetic leg');
elseif setLegend && contains(legToPlot,'both')
    % Healthy gait
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Left leg','Right leg');
elseif setLegend && ~contains(legToPlot,'both')
    leg = [];
else
    leg = [];
end
if ~isempty(leg)
    set(leg,'FontSize',14);
    set(leg,'Location','best');
end

%% Save figure if requested
if saveInfo.b_saveFigure
    saveFigure(legStateFig,'legState',saveInfo.type,saveInfo.info)
end
