function [plotHandles,axesHandles] = plotMusculoData(musculoData,plotInfo,GaitInfo,saveInfo,musculoDataFigure,axesHandles,subplotStart,legToPlot,b_addTitle)
% PLOTMUSCULODATA               Function that plots the muscle data (normally muscle activation level) 
% 
%                               Other options: Muscle force (N), Specific contractile element length (L/L_opt), 
%                               Specific contractile element velocity (v/L_opt), Series elastic element length (m),
%                               Specific muscle force (F/Fmax)

% INPUTS:
%   - musculoData               Structure with time of the joint angle and angular velocity data from the simulation.
%   - plotInfo                  Structure containing linestyle, -width, -color etc.
%   - GaitInfo                  Structure containing information on where a stride begins and ends, whether to show average
%                               for stride, or just all the data.
%   - saveInfo                  Structure with info on how and if to save the figure
%   - musculoDataFigure         Optional, pre-created figure in which the  muscle data can be plotted.
%   - axesHandles               Optional, pre-created axes in which the  muscle data can be plotted.
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
    musculoDataFigure = [];
end
if nargin < 6
    axesHandles = [];
end
if nargin < 7 || isempty(subplotStart)
    subplotStart = [6 2 1];
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
l_dyn = 6; % Number of elements per Muscle dynamics vector
% 1: Muscle force (N), 2: Specific contractile element length (L/L_opt), 3: Specific contractile element velocity (v/L_opt)
% 4: Series elastic element length (m) 5: Muscle activation level (-) 6: Specific muscle force (F/Fmax)
act_offset = 5;
Lstart = 0;
Rstart = 11;

if ~contains(saveInfo.info,'2D')
    L_HAB   = musculoData.signals.values(:,act_offset+(Lstart+0)*l_dyn);
    L_HAD   = musculoData.signals.values(:,act_offset+(Lstart+1)*l_dyn);
    Lstart = 2;
    
    [L_HAB_avg,L_HAB_sd] = interpData2perc(t,GaitInfo.tp,L_HAB,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
    [L_HAD_avg,L_HAD_sd] = interpData2perc(t,GaitInfo.tp,L_HAD,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
    
    R_HAB   = musculoData.signals.values(:,act_offset+(Rstart+0)*l_dyn);
    R_HAD   = musculoData.signals.values(:,act_offset+(Rstart+1)*l_dyn);
    
    [R_HAB_avg,R_HAB_sd] = interpData2perc(t,GaitInfo.tp,R_HAB,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
    [R_HAD_avg,R_HAD_sd] = interpData2perc(t,GaitInfo.tp,R_HAD,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
    
    Rstart = 13;
else
    Rstart = 9;
    L_HAB_avg = zeros(size(GaitInfo.tp));
    L_HAD_avg = zeros(size(GaitInfo.tp));
    R_HAB_avg = zeros(size(GaitInfo.tp));
    R_HAD_avg = zeros(size(GaitInfo.tp));
end
if ~plotInfo.showSD || contains(saveInfo.info,'2D')
    L_HAB_sd = [];
    L_HAD_sd = [];
    R_HAB_sd = [];
    R_HAD_sd = [];
end

L_HFL   = musculoData.signals.values(:,act_offset+(Lstart+0)*l_dyn);
L_GLU   = musculoData.signals.values(:,act_offset+(Lstart+1)*l_dyn);
L_HAM   = musculoData.signals.values(:,act_offset+(Lstart+2)*l_dyn);
L_RF    = musculoData.signals.values(:,act_offset+(Lstart+3)*l_dyn);
L_VAS   = musculoData.signals.values(:,act_offset+(Lstart+4)*l_dyn);
L_BFSH  = musculoData.signals.values(:,act_offset+(Lstart+5)*l_dyn);
L_GAS   = musculoData.signals.values(:,act_offset+(Lstart+6)*l_dyn);
L_SOL   = musculoData.signals.values(:,act_offset+(Lstart+7)*l_dyn);
L_TA    = musculoData.signals.values(:,act_offset+(Lstart+8)*l_dyn);

[L_HFL_avg,L_HFL_sd]    = interpData2perc(t,GaitInfo.tp,L_HFL,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[L_GLU_avg,L_GLU_sd]    = interpData2perc(t,GaitInfo.tp,L_GLU,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[L_HAM_avg,L_HAM_sd]    = interpData2perc(t,GaitInfo.tp,L_HAM,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[L_RF_avg,L_RF_sd]      = interpData2perc(t,GaitInfo.tp,L_RF,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[L_VAS_avg,L_VAS_sd]    = interpData2perc(t,GaitInfo.tp,L_VAS,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[L_BFSH_avg,L_BFSH_sd]  = interpData2perc(t,GaitInfo.tp,L_BFSH,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[L_GAS_avg,L_GAS_sd]    = interpData2perc(t,GaitInfo.tp,L_GAS,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[L_SOL_avg,L_SOL_sd]    = interpData2perc(t,GaitInfo.tp,L_SOL,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[L_TA_avg,L_TA_sd]      = interpData2perc(t,GaitInfo.tp,L_TA,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);

R_HFL   = musculoData.signals.values(:,act_offset+(Rstart+0)*l_dyn);
R_GLU   = musculoData.signals.values(:,act_offset+(Rstart+1)*l_dyn);
R_HAM   = musculoData.signals.values(:,act_offset+(Rstart+2)*l_dyn);
R_RF    = musculoData.signals.values(:,act_offset+(Rstart+3)*l_dyn);

[R_HFL_avg,R_HFL_sd] = interpData2perc(t,GaitInfo.tp,R_HFL,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[R_GLU_avg,R_GLU_sd] = interpData2perc(t,GaitInfo.tp,R_GLU,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[R_HAM_avg,R_HAM_sd] = interpData2perc(t,GaitInfo.tp,R_HAM,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[R_RF_avg,R_RF_sd] = interpData2perc(t,GaitInfo.tp,R_RF,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);


try
    R_VAS   = musculoData.signals.values(:,act_offset+(Rstart+4)*l_dyn);
    R_BFSH  = musculoData.signals.values(:,act_offset+(Rstart+5)*l_dyn);
    R_GAS   = musculoData.signals.values(:,act_offset+(Rstart+6)*l_dyn);
    R_SOL   = musculoData.signals.values(:,act_offset+(Rstart+7)*l_dyn);
    R_TA    = musculoData.signals.values(:,act_offset+(Rstart+8)*l_dyn);
    
    [R_VAS_avg,R_VAS_sd] = interpData2perc(t,GaitInfo.tp,R_VAS,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
    [R_BFSH_avg,R_BFSH_sd] = interpData2perc(t,GaitInfo.tp,R_BFSH,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
    [R_GAS_avg,R_GAS_sd] = interpData2perc(t,GaitInfo.tp,R_GAS,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
    [R_SOL_avg,R_SOL_sd] = interpData2perc(t,GaitInfo.tp,R_SOL,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
    [R_TA_avg,R_TA_sd] = interpData2perc(t,GaitInfo.tp,R_TA,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
catch
    R_VAS_avg   = 0;
    R_BFSH_avg  = 0;
    R_GAS_avg   = 0;
    R_SOL_avg   = 0;
    R_TA_avg    = 0;
    R_VAS_sd = [];
    R_BFSH_sd = [];
    R_GAS_sd = [];
    R_SOL_sd = [];
    R_TA_sd = [];
end

if ~plotInfo.showSD
    L_HFL_sd = [];
    L_GLU_sd = [];
    L_HAM_sd = [];
    L_RF_sd = [];
    L_VAS_sd = [];
    L_BFSH_sd = [];
    L_GAS_sd = [];
    L_SOL_sd = [];
    L_TA_sd = [];
    R_HFL_sd = [];
    R_GLU_sd = [];
    R_HAM_sd = [];
    R_RF_sd = [];
    R_VAS_sd = [];
    R_BFSH_sd = [];
    R_GAS_sd = [];
    R_SOL_sd = [];
    R_TA_sd = [];
end

%%
if isempty(musculoDataFigure) && isempty(axesHandles)
    musculoDataFig = figure();
    fullScreen = get(0,'screensize');
    set(musculoDataFig, 'Position',[fullScreen(1:2)+20 fullScreen(3:4)*0.9]);
else
    musculoDataFig = musculoDataFigure;
    
end

%% Plot data 
plotHandlesLeft = [];
plotHandlesRight = [];

if contains(legToPlot,'left') || contains(legToPlot,'both')
    [plotHandlesLeft,axesHandles] = plotMusculoDataInFigure(musculoDataFig,axesHandles,GaitInfo.tp,L_HFL_avg,L_HFL_sd,L_GLU_avg,L_GLU_sd,...
                                                            L_HAM_avg,L_HAM_sd,L_RF_avg,L_RF_sd,L_VAS_avg,L_VAS_sd,L_BFSH_avg,L_BFSH_sd,...
                                                            L_GAS_avg,L_GAS_sd,L_SOL_avg,L_SOL_sd,L_TA_avg,L_TA_sd,L_HAB_avg,L_HAB_sd,...
                                                            L_HAD_avg,L_HAD_sd,subplotStart,b_addTitle);
end
if contains(legToPlot,'right') || contains(legToPlot,'both')
    [plotHandlesRight,axesHandles] = plotMusculoDataInFigure(musculoDataFig,axesHandles,GaitInfo.tp,R_HFL_avg,R_HFL_sd,R_GLU_avg,R_GLU_sd,...
                                                             R_HAM_avg,R_HAM_sd,R_RF_avg,R_RF_sd,R_VAS_avg,R_VAS_sd,R_BFSH_avg,R_BFSH_sd,...
                                                             R_GAS_avg,R_GAS_sd,R_SOL_avg,R_SOL_sd,R_TA_avg,R_TA_sd,R_HAB_avg,R_HAB_sd,...
                                                             R_HAD_avg,R_HAD_sd,subplotStart,b_addTitle);
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
    if ~isempty(plotHandles(ii,1))
    set(plotHandles(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    end
    if size(plotHandles,2) > 2 && ~isnan(plotHandles(ii,2))
        set(plotHandles(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    % Set fill properties
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        if ~isempty(plotHandles(ii,2))
            set(plotHandles(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(1,:));
        end
        if size(plotHandles,2)>2 && ~isnan(plotHandles(ii,4))
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
    saveFigure(musculoDataFig,'musculoData',saveInfo.type,saveInfo.info)
end