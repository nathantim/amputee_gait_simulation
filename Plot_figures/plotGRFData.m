function [plotHandles,axesHandles] = plotGRFData(GRFData,plotInfo,GaitInfo,saveInfo,GRFDataFigure,axesHandles,subplotStart,legToPlot,b_addTitle)
% PLOTGRFDATA                   Function that plots the ground reaction forces
% INPUTS:
%   - GRFData                   Structure with time of the ground reaction forces data from the simulation.
%   - plotInfo                  Structure containing linestyle, -width, -color etc.
%   - GaitInfo                  Structure containing information on where a stride begins and ends, whether to show average
%                               for stride, or just all the data.
%   - saveInfo                  Structure with info on how and if to save the figure
%   - GRFDataFigure             Optional, pre-created figure in which the  ground reaction forces data can be plotted.
%   - axesHandles               Optional, pre-created axes in which the  ground reaction forces data can be plotted.
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
    GRFDataFigure = [];
end
if nargin < 6
    axesHandles = [];
end
if nargin < 7 || isempty(subplotStart)
    subplotStart = [1 3 1];
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
% x: Anterior +, Posterior -
LGRFx = GRFData.signals.values(:,1);
RGRFx = GRFData.signals.values(:,4);
% y: Medio +, Lateral -,
LGRFy = GRFData.signals.values(:,2);
RGRFy = GRFData.signals.values(:,5);
% z: Up +, down -
LGRFz = GRFData.signals.values(:,3);
RGRFz = GRFData.signals.values(:,6);

[LGRFx_avg,LGRFx_sd] = interpData2perc(t,GaitInfo.tp,LGRFx,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LGRFy_avg,LGRFy_sd] = interpData2perc(t,GaitInfo.tp,LGRFy,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LGRFz_avg,LGRFz_sd] = interpData2perc(t,GaitInfo.tp,LGRFz,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);

[RGRFx_avg,RGRFx_sd] = interpData2perc(t,GaitInfo.tp,RGRFx,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RGRFy_avg,RGRFy_sd] = interpData2perc(t,GaitInfo.tp,RGRFy,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RGRFz_avg,RGRFz_sd] = interpData2perc(t,GaitInfo.tp,RGRFz,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

if ~plotInfo.showSD
    LGRFx_sd = [];
    LGRFy_sd = [];
    LGRFz_sd = [];
    RGRFx_sd = [];
    RGRFy_sd = [];
    RGRFz_sd = [];
end



%%
if isempty(GRFDataFigure) && isempty(axesHandles)
    GRFDataFig = figure();
    fullScreen = get(0,'screensize');
    set(GRFDataFig, 'Position',[fullScreen(1:2)+20 fullScreen(3:4)*0.9]);
else
    GRFDataFig = GRFDataFigure;
end

%% Plot data 
plotHandlesLeft     = [];
plotHandlesRight    = [];

if contains(legToPlot,'left') || contains(legToPlot,'both')
    [plotHandlesLeft,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,GaitInfo.tp,LGRFx_avg,LGRFx_sd,LGRFy_avg,LGRFy_sd,LGRFz_avg,LGRFz_sd,subplotStart,b_addTitle);
end
if contains(legToPlot,'right') || contains(legToPlot,'both')
    if ~isempty(axesHandles)
        b_addTitle = false;
    end
    [plotHandlesRight,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,GaitInfo.tp,RGRFx_avg,RGRFx_sd,RGRFy_avg,RGRFy_sd,RGRFz_avg,RGRFz_sd,subplotStart,b_addTitle);
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
    saveFigure(GRFDataFig,'GRFData',saveInfo.type,saveInfo.info)
end