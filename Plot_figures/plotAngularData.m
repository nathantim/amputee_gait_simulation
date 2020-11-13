function [plotHandles,axesHandles] = plotAngularData(angularData,plotInfo,GaitInfo,saveInfo,angularDataFigure,axesHandles,subplotStart,legToPlot,b_addTitle)
% PLOTANGULARDATA               Function that plots the joint angles
% INPUTS:
%   - angularData               Structure with time of the joint angle and angular velocity data from the simulation.
%   - plotInfo                  Structure containing linestyle, -width, -color etc.
%   - GaitInfo                  Structure containing information on where a stride begins and ends, whether to show average
%                               for stride, or just all the data.
%   - saveInfo                  Structure with info on how and if to save the figure
%   - angularDataFigure         Optional, pre-created figure in which the  joint angle data can be plotted.
%   - axesHandles               Optional, pre-created axes in which the  joint angle data can be plotted.
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
    angularDataFigure = [];
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
    legToPlot = 'both';
end
if nargin < 9
    b_addTitle = true;
end
t = GaitInfo.t;

%%
% Flexion +, Extension -, implementation of model is other way around
LhipAngles      = -180/pi*angularData.signals.values(:,3);
RhipAngles      = -180/pi*angularData.signals.values(:,5);

% Flexion +, Extension -
LkneeAngles     = 180/pi*angularData.signals.values(:,7);
RkneeAngles     = 180/pi*angularData.signals.values(:,9);

% Dorsiflexion +, Plantar flexion -, implementation of model is other way around
LankleAngles    = -180/pi*angularData.signals.values(:,11);
RankleAngles    = -180/pi*angularData.signals.values(:,13);

% Abduction +, Adduction -
LhipRollAngles    = 180/pi*angularData.signals.values(:,15);
RhipRollAngles    = 180/pi*angularData.signals.values(:,17);

[LhipAngles_avg,        LhipAngles_sd]      = interpData2perc(t,GaitInfo.tp,LhipAngles,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LhipRollAngles_avg,    LhipRollAngles_sd]  = interpData2perc(t,GaitInfo.tp,LhipRollAngles,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LkneeAngles_avg,       LkneeAngles_sd]     = interpData2perc(t,GaitInfo.tp,LkneeAngles,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LankleAngles_avg,      LankleAngles_sd]    = interpData2perc(t,GaitInfo.tp,LankleAngles,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[RhipAngles_avg,        RhipAngles_sd]      = interpData2perc(t,GaitInfo.tp,RhipAngles,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RhipRollAngles_avg,    RhipRollAngles_sd]  = interpData2perc(t,GaitInfo.tp,RhipRollAngles,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RkneeAngles_avg,       RkneeAngles_sd]     = interpData2perc(t,GaitInfo.tp,RkneeAngles,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RankleAngles_avg,      RankleAngles_sd]    = interpData2perc(t,GaitInfo.tp,RankleAngles,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

if ~plotInfo.showSD
    LhipAngles_sd = [];
    LhipRollAngles_sd = [];
    LkneeAngles_sd = [];
    LankleAngles_sd = [];
    RhipAngles_sd = [];
    RhipRollAngles_sd = [];
    RkneeAngles_sd = [];
    RankleAngles_sd = [];
    
end

%%
if isempty(angularDataFigure) && isempty(axesHandles)
    angularDataFig = figure();
    fullScreen = get(0,'screensize');
    set(angularDataFig, 'Position',[fullScreen(1:2)+20 fullScreen(3:4)*0.9]);
else
    angularDataFig = angularDataFigure;
end

%% Plot data 
plotHandlesLeft     = [];
plotHandlesRight    = [];

if contains(legToPlot,'left') || contains(legToPlot,'both')
    [plotHandlesLeft,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,GaitInfo.tp,LhipAngles_avg,LhipAngles_sd,...
                                                            LhipRollAngles_avg,LhipRollAngles_sd,LkneeAngles_avg,LkneeAngles_sd,...
                                                            LankleAngles_avg,LankleAngles_sd,subplotStart,b_addTitle);
end
if contains(legToPlot,'right') || contains(legToPlot,'both')
    if ~isempty(axesHandles)
        b_addTitle = false;
    end
    [plotHandlesRight,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,GaitInfo.tp,RhipAngles_avg,RhipAngles_sd,...
                                                             RhipRollAngles_avg,RhipRollAngles_sd,RkneeAngles_avg,RkneeAngles_sd,...
                                                             RankleAngles_avg,RankleAngles_sd,subplotStart,b_addTitle);
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
    if size(plotHandles,2) > 2
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
    saveFigure(angularDataFig,'angularData',saveInfo.type,saveInfo.info)
end
