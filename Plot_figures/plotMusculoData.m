function plotMusculoData(musculoData,plotInfo,GaitInfo,saveInfo,musculoDataFigure,subplotStart,b_plotBothLegs)
if nargin < 5
    musculoDataFigure = [];
end
if nargin < 6 || isempty(subplotStart)
    subplotStart = 621;
    subplotStart = dec2base(subplotStart,10) - '0';
end
if nargin < 7
    b_plotBothLegs = true;
end
%%
if ~GaitInfo.b_oneGaitPhase
        GaitInfo.tp = musculoData.time;
end
t = musculoData.time;
%%
l_dyn = 6;
act_offset = 5;
Lstart = 0;
Rstart = 11;

if contains(saveInfo.info,'3D')
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
if ~plotInfo.showSD || ~contains(saveInfo.info,'3D')
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
if isempty(musculoDataFigure)
    musculoDataFig = figure();
    set(musculoDataFig, 'Position',[10,40,1200,930]);
else
    musculoDataFig = musculoDataFigure;
%     clf(musculoDataFig);
end

% sgtitle('Muscle stimulations')


    
[plotHandlesLeft,axesHandles] = plotMusculoDataInFigure(musculoDataFig,[],GaitInfo.tp,L_HFL_avg,L_HFL_sd,L_GLU_avg,L_GLU_sd,L_HAM_avg,L_HAM_sd,L_RF_avg,L_RF_sd,L_VAS_avg,L_VAS_sd,...
        L_BFSH_avg,L_BFSH_sd,L_GAS_avg,L_GAS_sd,L_SOL_avg,L_SOL_sd,L_TA_avg,L_TA_sd,L_HAB_avg,L_HAB_sd,L_HAD_avg,L_HAD_sd,GaitInfo.b_oneGaitPhase,subplotStart);
if b_plotBothLegs
    [plotHandlesRight,axesHandles] = plotMusculoDataInFigure(musculoDataFig,axesHandles,GaitInfo.tp,R_HFL_avg,R_HFL_sd,R_GLU_avg,R_GLU_sd,R_HAM_avg,R_HAM_sd,R_RF_avg,R_RF_sd,R_VAS_avg,R_VAS_sd,...
        R_BFSH_avg,R_BFSH_sd,R_GAS_avg,R_GAS_sd,R_SOL_avg,R_SOL_sd,R_TA_avg,R_TA_sd,R_HAB_avg,R_HAB_sd,R_HAD_avg,R_HAD_sd,GaitInfo.b_oneGaitPhase,subplotStart);
end
    if contains(saveInfo.info,'prosthetic') || b_plotBothLegs
        leg = legend([plotHandlesLeft(end,1),plotHandlesRight(end,1)],'Intact leg','Prosthetic leg');
    elseif b_plotBothLegs
        leg = legend([plotHandlesLeft(end,1),plotHandlesRight(end,1)],'Left leg','Right leg');
    else
        leg = [];
    end
% set(leg,'FontSize',18);
if ~isempty(leg)
    set(leg,'FontSize',12);
end

for i= 1:length(plotHandlesLeft)
    if ~isnan(plotHandlesLeft(i,1))
        set(plotHandlesLeft(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    end
    if b_plotBothLegs && ~isnan(plotHandlesRight(i,1)) 
        set(plotHandlesRight(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        if ~isnan(plotHandlesLeft(i,2))
            set(plotHandlesLeft(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(1,:));
        end
        if b_plotBothLegs && ~isnan(plotHandlesRight(i,2))
            set(plotHandlesRight(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(2,:));
        end
    end
end
if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(musculoDataFig,'musculoData',saveInfo.type{j},saveInfo.info)
    end
end