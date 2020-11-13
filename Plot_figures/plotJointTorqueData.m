function [plotHandles,axesHandles] = plotJointTorqueData(jointTorquesData,plotInfo,GaitInfo,saveInfo,torqueDataFigure,axesHandles,subplotStart,legToPlot,b_addTitle)
% PLOTJOINTTORQUEDATA           Function that plots the joint torques
% INPUTS:
%   - jointTorquesData          Structure with time of the joint torque data from the simulation.
%   - plotInfo                  Structure containing linestyle, -width, -color etc.
%   - GaitInfo                  Structure containing information on where a stride begins and ends, whether to show average
%                               for stride, or just all the data.
%   - saveInfo                  Structure with info on how and if to save the figure
%   - torqueDataFigure          Optional, pre-created figure in which the joint torque data can be plotted.
%   - axesHandles               Optional, pre-created axes in which the joint torque data can be plotted.
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
    torqueDataFigure = [];
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
LhipTorque      =  -jointTorquesData.signals.values(:,1);
RhipTorque      =  -jointTorquesData.signals.values(:,4);

% Flexion +, Extension -
LkneeTorque     =  jointTorquesData.signals.values(:,2);
RkneeTorque     =  jointTorquesData.signals.values(:,5);

% Dorsiflexion +, Plantar flexion -, implementation of model is other way around
LankleTorque    =  -jointTorquesData.signals.values(:,3);
RankleTorque    =  -jointTorquesData.signals.values(:,6);

% Abduction +, Adduction -
LhipRollTorque    =  jointTorquesData.signals.values(:,7);
RhipRollTorque    =  jointTorquesData.signals.values(:,8);

[LhipTorque_avg,        LhipTorque_sd]      = interpData2perc(t,GaitInfo.tp,LhipTorque,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LhipRollTorque_avg,    LhipRollTorque_sd]  = interpData2perc(t,GaitInfo.tp,LhipRollTorque,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LkneeTorque_avg,       LkneeTorque_sd]     = interpData2perc(t,GaitInfo.tp,LkneeTorque,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LankleTorque_avg,      LankleTorque_sd]    = interpData2perc(t,GaitInfo.tp,LankleTorque,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[RhipTorque_avg,        RhipTorque_sd]      = interpData2perc(t,GaitInfo.tp,RhipTorque,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RhipRollTorque_avg,    RhipRollTorque_sd]  = interpData2perc(t,GaitInfo.tp,RhipRollTorque,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RkneeTorque_avg,       RkneeTorque_sd]     = interpData2perc(t,GaitInfo.tp,RkneeTorque,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RankleTorque_avg,      RankleTorque_sd]    = interpData2perc(t,GaitInfo.tp,RankleTorque,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

if ~plotInfo.showSD
    LhipTorque_sd = [];
    LhipRollTorque_sd = [];
    LkneeTorque_sd = [];
    LankleTorque_sd = [];
    RhipTorque_sd = [];
    RhipRollTorque_sd = [];
    RkneeTorque_sd = [];
    RankleTorque_sd = [];
end


%%
if isempty(torqueDataFigure) && isempty(axesHandles)
    torqueDataFig = figure();
    fullScreen = get(0,'screensize');
    set(torqueDataFig, 'Position',[fullScreen(1:2)+20 fullScreen(3:4)*0.9]);
else
    torqueDataFig = torqueDataFigure;
end

%% Plot data 
plotHandlesLeft    = [];
plotHandlesRight   = [];

if contains(legToPlot,'left') || contains(legToPlot,'both')
    [plotHandlesLeft,axesHandles] = plotTorqueDataInFigure(torqueDataFig,axesHandles,GaitInfo.tp,LhipTorque_avg,LhipTorque_sd,LhipRollTorque_avg,...
                                                           LhipRollTorque_sd,LkneeTorque_avg,LkneeTorque_sd,LankleTorque_avg,LankleTorque_sd,...
                                                           subplotStart,b_addTitle);
end
if contains(legToPlot,'right') || contains(legToPlot,'both')
    if ~isempty(axesHandles)
        b_addTitle = false;
    end
    [plotHandlesRight,axesHandles] = plotTorqueDataInFigure(torqueDataFig,axesHandles,GaitInfo.tp,RhipTorque_avg,RhipTorque_sd,RhipRollTorque_avg,...
                                                            RhipRollTorque_sd,RkneeTorque_avg,RkneeTorque_sd,RankleTorque_avg,RankleTorque_sd,...
                                                            subplotStart,b_addTitle);
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
    saveFigure(torqueDataFig,'torqueData',saveInfo.type,saveInfo.info)
end
