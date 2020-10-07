function [plotHandles,axesHandles] = plotJointTorqueData(jointTorquesData,plotInfo,GaitInfo,saveInfo,torqueDataFigure,axesHandles,subplotStart,legToPlot,b_addTitle)
if nargin < 5
    torqueDataFigure = [];
end
if nargin < 6
    axesHandles = [];
end
if nargin < 7 || isempty(subplotStart)
%     subplotStart = 141;
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
LhipTorque      =  jointTorquesData.signals.values(:,1);
RhipTorque      =  jointTorquesData.signals.values(:,4);

LkneeTorque     =  jointTorquesData.signals.values(:,2);
RkneeTorque     =  jointTorquesData.signals.values(:,5);

LankleTorque    =  jointTorquesData.signals.values(:,3);
RankleTorque    =  jointTorquesData.signals.values(:,6);

LhipRollTorque    =  jointTorquesData.signals.values(:,7);
RhipRollTorque    =  jointTorquesData.signals.values(:,8);

[LhipTorque_avg,LhipTorque_sd] = interpData2perc(t,GaitInfo.tp,LhipTorque,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LhipRollTorque_avg,LhipRollTorque_sd] = interpData2perc(t,GaitInfo.tp,LhipRollTorque,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LkneeTorque_avg,LkneeTorque_sd] = interpData2perc(t,GaitInfo.tp,LkneeTorque,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LankleTorque_avg,LankleTorque_sd] = interpData2perc(t,GaitInfo.tp,LankleTorque,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[RhipTorque_avg,RhipTorque_sd] = interpData2perc(t,GaitInfo.tp,RhipTorque,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RhipRollTorque_avg,RhipRollTorque_sd] = interpData2perc(t,GaitInfo.tp,RhipRollTorque,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RkneeTorque_avg,RkneeTorque_sd] = interpData2perc(t,GaitInfo.tp,RkneeTorque,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RankleTorque_avg,RankleTorque_sd] = interpData2perc(t,GaitInfo.tp,RankleTorque,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

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
if isempty(torqueDataFigure)
    torqueDataFig = figure();
%     set(angularDataFig, 'Position',[10,0,1000,1530]);
else
    torqueDataFig = torqueDataFigure; 
end
if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData 
    [timeWinter, ~,~,~,~,~,~, ~,~,~,~, ...
      hipTorqueWinter_avg,hipTorqueWinter_sd,kneeTorqueWinter_avg,kneeTorqueWinter_sd,ankleTorqueWinter_avg,ankleTorqueWinter_sd] = getWinterData(GaitInfo.WinterDataSpeed);
end
%%
 plotHandlesLeft = [];
 plotHandlesRight = [];

if ~GaitInfo.b_oneGaitPhase
    GaitInfo.tp = jointTorquesData.time;
end
if contains(legToPlot,'left') || contains(legToPlot,'both')
[plotHandlesLeft,axesHandles] = plotTorqueDataInFigure(torqueDataFig,axesHandles,GaitInfo.tp,LhipTorque_avg,LhipTorque_sd,LhipRollTorque_avg,LhipRollTorque_sd,LkneeTorque_avg,LkneeTorque_sd,LankleTorque_avg,LankleTorque_sd,subplotStart,GaitInfo.b_oneGaitPhase,b_addTitle);
end
if contains(legToPlot,'right') || contains(legToPlot,'both')
    [plotHandlesRight,axesHandles] = plotTorqueDataInFigure(torqueDataFig,axesHandles,GaitInfo.tp,RhipTorque_avg,RhipTorque_sd,RhipRollTorque_avg,RhipRollTorque_sd,RkneeTorque_avg,RkneeTorque_sd,RankleTorque_avg,RankleTorque_sd,subplotStart,GaitInfo.b_oneGaitPhase,false);
end
if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData
    [plotHandlesWinter,axesHandles] = plotTorqueDataInFigure(torqueDataFig,axesHandles,timeWinter,hipTorqueWinter_avg,hipTorqueWinter_sd,[],[],kneeTorqueWinter_avg,kneeTorqueWinter_sd, ...
        ankleTorqueWinter_avg,ankleTorqueWinter_sd,subplotStart);
end
if setLegend
    if GaitInfo.b_oneGaitPhase
        xlabel(axesHandles(end),'gait cycle ($\%$)');
    else
        xlabel(axesHandles(end),'s');
    end
end


%%
if contains(legToPlot,'both')
    plotHandles = [plotHandlesLeft, plotHandlesRight];
elseif contains(legToPlot,'left')
    plotHandles = [plotHandlesLeft, plotHandlesRight];
elseif contains(legToPlot,'right')
    plotHandles = [plotHandlesLeft, plotHandlesRight];
    
else
    error('Unknown leg');
end


for i= 1:max(size(plotHandlesLeft,1),size(plotHandlesRight,1))
    
    set(plotHandles(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    
    if size(plotHandles,2)>2
        set(plotHandles(i,3),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        set(plotHandles(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(1,:));
        if size(plotHandles,2)>2
            set(plotHandles(i,4),plotInfo.fillProp,plotInfo.fillProp_entries(2,:));
        end
    end
    if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~isnan(plotHandlesWinter(i,1))
        set(plotHandlesWinter(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotHandlesWinter(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
    end
end


% set(angularDataFig, 'Position',[10,40,1000,930]);

if setLegend && GaitInfo.b_oneGaitPhase && contains(saveInfo.info,'prosthetic') && plotInfo.plotWinterData 
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Intact leg','Prosthetic leg', 'Winter data');
%     leg = legend('Intact leg','Prosthetic leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')) );
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~legToPlot
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Model', 'Winter data');
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData 
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Left leg','Right leg', 'Winter data');
elseif setLegend && contains(saveInfo.info,'prosthetic')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Intact leg','Prosthetic leg');
%     leg = legend('Intact leg','Prosthetic leg');
elseif setLegend && ~legToPlot
    leg = [];
elseif setLegend 
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
        saveFigure(torqueDataFig,'torqueData',saveInfo.type{j},saveInfo.info)
    end
end
