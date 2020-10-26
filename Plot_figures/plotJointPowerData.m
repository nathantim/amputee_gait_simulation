function [plotHandles,axesHandles] = plotJointPowerData(angularData,jointTorquesData,plotInfo,GaitInfo,saveInfo,powerDataFigure,axesHandles,subplotStart,legToPlot,b_addTitle)
if nargin < 6
    powerDataFigure = [];
end
if nargin < 7
    axesHandles = [];
end
plotInfo.plotWinterData = false;
if nargin < 8 || isempty(subplotStart)
%     subplotStart = 141;
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

LhipPowerVel   = angularData.signals.values(:,4);
RhipPowerVel   = angularData.signals.values(:,6);

LkneePowerVel  = angularData.signals.values(:,8);
RkneePowerVel  = angularData.signals.values(:,10);

LanklePowerVel = angularData.signals.values(:,12);
RanklePowerVel = angularData.signals.values(:,14);

LhipRollPowerVel    = angularData.signals.values(:,16);
RhipRollPowerVel    = angularData.signals.values(:,18);

%%
LhipPower      =  LhipTorque.*LhipPowerVel;
RhipPower      =  RhipTorque.*RhipPowerVel;

LkneePower     =  LkneeTorque.*LkneePowerVel;
RkneePower     =  RkneeTorque.*RkneePowerVel;

LanklePower    =  LankleTorque.*LanklePowerVel;
RanklePower    =  RankleTorque.*RanklePowerVel;

LhipRollPower    =  LhipRollTorque.*LhipRollPowerVel;
RhipRollPower    =  RhipRollTorque.*RhipRollPowerVel;

[LhipPower_avg,LhipPower_sd] = interpData2perc(t,GaitInfo.tp,LhipPower,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LhipRollPower_avg,LhipRollPower_sd] = interpData2perc(t,GaitInfo.tp,LhipRollPower,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LkneePower_avg,LkneePower_sd] = interpData2perc(t,GaitInfo.tp,LkneePower,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LanklePower_avg,LanklePower_sd] = interpData2perc(t,GaitInfo.tp,LanklePower,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[RhipPower_avg,RhipPower_sd] = interpData2perc(t,GaitInfo.tp,RhipPower,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RhipRollPower_avg,RhipRollPower_sd] = interpData2perc(t,GaitInfo.tp,RhipRollPower,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RkneePower_avg,RkneePower_sd] = interpData2perc(t,GaitInfo.tp,RkneePower,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RanklePower_avg,RanklePower_sd] = interpData2perc(t,GaitInfo.tp,RanklePower,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

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
if plotInfo.showTables
     varNames = {'LHipAbduction (W/kg)','RHipAbduction (W/kg)','LHipFlexion (W/kg)','RHipFlexion (W/kg)',...
                'LKneeFlexion (W/kg)','RKneeFlexion (W/kg)','LAnkleDorsiflexion (W/kg)','RAnkleDorsiflexion (W/kg)'};
    rangeTable = createRangeTable(GaitInfo,varNames,LhipRollPower_avg,RhipRollPower_avg,LhipPower_avg,RhipPower_avg,LkneePower_avg,RkneePower_avg,LanklePower_avg,RanklePower_avg);
    if ~isempty(rangeTable)
%         fprintf('Joint power range (W/kg):\n');
        disp(rangeTable);
    end
    
    LkneePowerStance    =  LkneePower.* GaitInfo.gaitstate.left.StanceV;
    RkneePowerStance    =  RkneePower.* GaitInfo.gaitstate.right.StanceV;
    LanklePowerStance   =  LanklePower.* GaitInfo.gaitstate.left.StanceV;
    RanklePowerStance   =  RanklePower.* GaitInfo.gaitstate.right.StanceV;
    
    rowNames = {'knee max Power';'ankle max Power'};
    
    for ii = 1:length(GaitInfo.start.leftV)
        startIdx = GaitInfo.start.leftV(ii);
        endIdx = GaitInfo.end.leftV(ii);
        maxLkneePowerStance(ii)   = max(LkneePowerStance(startIdx:endIdx));
        maxLanklePowerStance(ii)   = max(LanklePowerStance(startIdx:endIdx));
    end
    maxLkneePowerStance = reshape(maxLkneePowerStance,1,length(maxLkneePowerStance));
    maxLanklePowerStance = reshape(maxLanklePowerStance,1,length(maxLanklePowerStance));
    
    for ii = 1:length(GaitInfo.start.rightV)
        startIdx = GaitInfo.start.rightV(ii);
        endIdx = GaitInfo.end.rightV(ii);
        maxRkneePowerStance(ii)   = max(RkneePowerStance(startIdx:endIdx));
        maxRanklePowerStance(ii)   = max(RanklePowerStance(startIdx:endIdx));
    end
    maxRkneePowerStance = reshape(maxRkneePowerStance,1,length(maxRkneePowerStance));
    maxRanklePowerStance = reshape(maxRanklePowerStance,1,length(maxRanklePowerStance));
        
    powerKneeASI = getFilterdMean_and_ASI(maxLkneePowerStance,maxRkneePowerStance);
    powerAnkleASI = getFilterdMean_and_ASI(maxLanklePowerStance,maxRanklePowerStance);
    
    if contains(saveInfo.info,'prosthetic')
        varNames = {'Intact (W/kg)','Prosthetic (W/kg)', 'ASI (%)'};%,'L mean propel impulse (N%/kg)','R mean propel impulse (N%/kg)'};
        vars = {powerKneeASI.leftTxt, powerKneeASI.rightTxt, powerKneeASI.ASItxt; ...
                powerAnkleASI.leftTxt, powerAnkleASI.rightTxt, powerAnkleASI.ASItxt};
        anklePowerTab = (table(vars(:,1),vars(:,2),vars(:,3),'VariableNames',varNames,'RowNames',rowNames));
        
    else
        varNames = {'Total (W/kg)', 'ASI (%)'};%,'L mean propel impulse (N%/kg)','R mean propel impulse (N%/kg)'};
        vars = {powerKneeASI.totalTxt, powerKneeASI.ASItxt; ...
                powerAnkleASI.totalTxt, powerAnkleASI.ASItxt};
        anklePowerTab = (table(vars(:,1),vars(:,2),'VariableNames',varNames,'RowNames',rowNames));
        
    end
    disp(anklePowerTab);

end

%%
if isempty(powerDataFigure) && isempty(axesHandles)
    PowerDataFig = figure();
    fullScreen = get(0,'screensize');
    set(PowerDataFig, 'Position',[fullScreen(1:2)+20 fullScreen(3:4)*0.9]);
else
    PowerDataFig = powerDataFigure;
end
% if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData 
%     [timeWinter, ~,~,~,~,~,~, ~,~,~,~, ...
%       hipPowerWinter_avg,hipPowerWinter_sd,kneePowerWinter_avg,kneePowerWinter_sd,anklePowerWinter_avg,anklePowerWinter_sd] = getWinterData(GaitInfo.WinterDataSpeed);
% end
%%
 plotHandlesLeft = [];
 plotHandlesRight = [];


if contains(legToPlot,'left') || contains(legToPlot,'both')
    [plotHandlesLeft,axesHandles] = plotPowerDataInFigure(PowerDataFig,axesHandles,GaitInfo.tp,LhipPower_avg,LhipPower_sd,LhipRollPower_avg,LhipRollPower_sd,LkneePower_avg,LkneePower_sd,LanklePower_avg,LanklePower_sd,subplotStart,GaitInfo.b_oneGaitPhase,b_addTitle);
end
if  contains(legToPlot,'right') || contains(legToPlot,'both')
    if ~isempty(axesHandles)
        b_addTitle = false;
    end
    [plotHandlesRight,axesHandles] = plotPowerDataInFigure(PowerDataFig,axesHandles,GaitInfo.tp,RhipPower_avg,RhipPower_sd,RhipRollPower_avg,RhipRollPower_sd,RkneePower_avg,RkneePower_sd,RanklePower_avg,RanklePower_sd,subplotStart,GaitInfo.b_oneGaitPhase,b_addTitle);
end
% if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData
%     [plotHandlesWinter,axesHandles] = plotPowerDataInFigure(PowerDataFig,axesHandles,timeWinter,hipPowerWinter_avg,hipPowerWinter_sd,[],[],kneePowerWinter_avg,kneePowerWinter_sd, ...
%         anklePowerWinter_avg,anklePowerWinter_sd,subplotStart);
% end
if setLegend
    if GaitInfo.b_oneGaitPhase
        xlabel(axesHandles(end),'gait cycle ($\%$)');
    else
        xlabel(axesHandles(end),'s');
    end
end

 plotHandles = [plotHandlesLeft, plotHandlesRight];
 
%%
for ii= 1:max(size(plotHandlesLeft,1),size(plotHandlesRight,1))
    
    set(plotHandles(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    
    if size(plotHandles,2)>2
        set(plotHandles(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        set(plotHandles(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(1,:));
        if size(plotHandles,2)>2
            set(plotHandles(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(2,:));
        end
    end
    if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~isnan(plotHandlesWinter(ii,1))
        set(plotHandlesWinter(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotHandlesWinter(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
    end
end


% set(angularDataFig, 'Position',[10,40,1000,930]);

if setLegend && GaitInfo.b_oneGaitPhase && contains(saveInfo.info,'prosthetic') && plotInfo.plotWinterData && contains(legToPlot,'both')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Intact leg','Prosthetic leg', 'Winter data');
%     leg = legend('Intact leg','Prosthetic leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')) );
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~contains(legToPlot,'both')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Model', 'Winter data');
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData  &&contains(legToPlot,'both')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Left leg','Right leg', 'Winter data');
elseif setLegend && contains(saveInfo.info,'prosthetic') && contains(legToPlot,'both')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Intact leg','Prosthetic leg');
%     leg = legend('Intact leg','Prosthetic leg');
elseif setLegend && ~contains(legToPlot,'both')
    leg = [];
elseif setLegend  && contains(legToPlot,'both')
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
        saveFigure(PowerDataFig,'powerData',saveInfo.type{j},saveInfo.info)
    end
end
