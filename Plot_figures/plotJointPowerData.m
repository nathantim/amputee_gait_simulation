function [plotHandles,axesHandles] = plotJointPowerData(angularData,jointTorquesData,plotInfo,GaitInfo,saveInfo,powerDataFigure,axesHandles,subplotStart,legToPlot,b_addTitle)
% PLOTJOINTPOWERDATA            Function that plots the joint powers
% INPUTS:
%   - angularData               Structure with time of the joint angle and angular velocity data from the simulation.
%   - jointTorquesData          Structure with time of the joint torque data from the simulation.
%   - plotInfo                  Structure containing linestyle, -width, -color etc.
%   - GaitInfo                  Structure containing information on where a stride begins and ends, whether to show average
%                               for stride, or just all the data.
%   - saveInfo                  Structure with info on how and if to save the figure
%   - powerDataFigure           Optional, pre-created figure in which the  joint angle data can be plotted.
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
if nargin < 6
    powerDataFigure = [];
end
if nargin < 7
    axesHandles = [];
end
plotInfo.plotWinterData = false;
if nargin < 8 || isempty(subplotStart)
    subplotStart = [1 4 1];
    setLegend = true;
else
    setLegend = false;
end
if nargin < 9
    legToPlot = 'both';
end
if nargin < 10
    b_addTitle = true;
end
t = GaitInfo.t;

%%
LhipTorque      =  jointTorquesData.signals.values(:,1);
RhipTorque      =  jointTorquesData.signals.values(:,4);

LkneeTorque     =  jointTorquesData.signals.values(:,2);
RkneeTorque     =  jointTorquesData.signals.values(:,5);

LankleTorque    =  jointTorquesData.signals.values(:,3);
RankleTorque    =  jointTorquesData.signals.values(:,6);

LhipRollTorque    =  jointTorquesData.signals.values(:,7);
RhipRollTorque    =  jointTorquesData.signals.values(:,8);

LhipVel   = angularData.signals.values(:,4);
RhipVel   = angularData.signals.values(:,6);

LkneeVel  = angularData.signals.values(:,8);
RkneeVel  = angularData.signals.values(:,10);

LankleVel = angularData.signals.values(:,12);
RankleVel = angularData.signals.values(:,14);

LhipRollVel    = angularData.signals.values(:,16);
RhipRollVel    = angularData.signals.values(:,18);

%%
LhipPower      =  LhipTorque.*LhipVel;
RhipPower      =  RhipTorque.*RhipVel;

LkneePower     =  LkneeTorque.*LkneeVel;
RkneePower     =  RkneeTorque.*RkneeVel;

LanklePower    =  LankleTorque.*LankleVel;
RanklePower    =  RankleTorque.*RankleVel;

LhipRollPower    =  LhipRollTorque.*LhipRollVel;
RhipRollPower    =  RhipRollTorque.*RhipRollVel;

[LhipPower_avg,     LhipPower_sd]       = interpData2perc(t,GaitInfo.tp,LhipPower,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LhipRollPower_avg, LhipRollPower_sd]   = interpData2perc(t,GaitInfo.tp,LhipRollPower,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LkneePower_avg,    LkneePower_sd]      = interpData2perc(t,GaitInfo.tp,LkneePower,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LanklePower_avg,   LanklePower_sd]     = interpData2perc(t,GaitInfo.tp,LanklePower,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[RhipPower_avg,     RhipPower_sd]       = interpData2perc(t,GaitInfo.tp,RhipPower,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RhipRollPower_avg, RhipRollPower_sd]   = interpData2perc(t,GaitInfo.tp,RhipRollPower,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RkneePower_avg,    RkneePower_sd]      = interpData2perc(t,GaitInfo.tp,RkneePower,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RanklePower_avg,   RanklePower_sd]     = interpData2perc(t,GaitInfo.tp,RanklePower,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

if ~plotInfo.showSD
    LhipPower_sd = [];
    LhipRollPower_sd = [];
    LkneePower_sd = [];
    LanklePower_sd = [];
    RhipPower_sd = [];
    RhipRollPower_sd = [];
    RkneePower_sd = [];
    RanklePower_sd = [];
end



%% Plot data
if isempty(powerDataFigure) && isempty(axesHandles)
    PowerDataFig = figure();
    fullScreen = get(0,'screensize');
    set(PowerDataFig, 'Position',[fullScreen(1:2)+20 fullScreen(3:4)*0.9]);
else
    PowerDataFig = powerDataFigure;
end

%%
plotHandlesLeft     = [];
plotHandlesRight 	= [];

if contains(legToPlot,'left') || contains(legToPlot,'both')
    [plotHandlesLeft,axesHandles] = plotPowerDataInFigure(PowerDataFig,axesHandles,GaitInfo.tp,LhipPower_avg,LhipPower_sd,LhipRollPower_avg,LhipRollPower_sd,...
                                                          LkneePower_avg,LkneePower_sd,LanklePower_avg,LanklePower_sd,subplotStart,b_addTitle);
end
if  contains(legToPlot,'right') || contains(legToPlot,'both')
    if ~isempty(axesHandles)
        b_addTitle = false;
    end
    [plotHandlesRight,axesHandles] = plotPowerDataInFigure(PowerDataFig,axesHandles,GaitInfo.tp,RhipPower_avg,RhipPower_sd,RhipRollPower_avg,RhipRollPower_sd,...
                                                           RkneePower_avg,RkneePower_sd,RanklePower_avg,RanklePower_sd,subplotStart,b_addTitle);
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
    saveFigure(PowerDataFig,'powerData',saveInfo.type,saveInfo.info)
end
