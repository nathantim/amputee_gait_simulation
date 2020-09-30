function plotJointPowerData(angularData,jointTorquesData,plotInfo,GaitInfo,saveInfo,powerDataFigure,subplotStart,b_plotBothLegs)
if nargin < 6
    powerDataFigure = [];
end
if nargin < 7 || isempty(subplotStart)
%     subplotStart = 141;
    subplotStart = 411;
    subplotStart = dec2base(subplotStart,10) - '0';
    setLegend = true;
else
    setLegend = false;
end
if nargin < 8
    b_plotBothLegs = true;
end
t = angularData.time;

%%
jointTorquesData.signals.values = jointTorquesData.signals.values./getBodyMass();

%%
LhipTorque      =  jointTorquesData.signals.values(:,1);
RhipTorque      =  jointTorquesData.signals.values(:,4);

LkneeTorque     =  jointTorquesData.signals.values(:,2);
RkneeTorque     =  jointTorquesData.signals.values(:,5);

LankleTorque    =  jointTorquesData.signals.values(:,3);
RankleTorque    =  jointTorquesData.signals.values(:,6);

LhipRollTorque    =  jointTorquesData.signals.values(:,7);
RhipRollTorque    =  jointTorquesData.signals.values(:,8);

LhipAnglesVel   = angularData.signals.values(:,4);
RhipAnglesVel   = angularData.signals.values(:,6);

LkneeAnglesVel  = angularData.signals.values(:,8);
RkneeAnglesVel  = angularData.signals.values(:,10);

LankleAnglesVel = angularData.signals.values(:,12);
RankleAnglesVel = angularData.signals.values(:,14);

LhipRollAnglesVel    = angularData.signals.values(:,16);
RhipRollAnglesVel    = angularData.signals.values(:,18);

%%
LhipPower      =  LhipTorque.*LhipAnglesVel;
RhipPower      =  RhipTorque.*RhipAnglesVel;

LkneePower     =  LkneeTorque.*LkneeAnglesVel;
RkneePower     =  RkneeTorque.*RkneeAnglesVel;

LanklePower    =  LankleTorque.*LankleAnglesVel;
RanklePower    =  RankleTorque.*RankleAnglesVel;

LhipRollPower    =  LhipRollTorque.*LhipRollAnglesVel;
RhipRollPower    =  RhipRollTorque.*RhipRollAnglesVel;

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

%%
if isempty(powerDataFigure)
    PowerDataFig = figure();
%     set(angularDataFig, 'Position',[10,0,1000,1530]);
else
    PowerDataFig = powerDataFigure; 
end
% if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData 
%     [timeWinter, ~,~,~,~,~,~, ~,~,~,~, ...
%       hipPowerWinter_avg,hipPowerWinter_sd,kneePowerWinter_avg,kneePowerWinter_sd,anklePowerWinter_avg,anklePowerWinter_sd] = getWinterData(GaitInfo.WinterDataSpeed);
% end
%%
if ~GaitInfo.b_oneGaitPhase
    GaitInfo.tp = jointPowersData.time;
end
[plotHandlesLeft,axesHandles] = plotPowerDataInFigure(PowerDataFig,[],GaitInfo.tp,LhipPower_avg,LhipPower_sd,LhipRollPower_avg,LhipRollPower_sd,LkneePower_avg,LkneePower_sd,LanklePower_avg,LanklePower_sd,subplotStart,GaitInfo.b_oneGaitPhase);
if b_plotBothLegs
    [plotHandlesRight,axesHandles] = plotPowerDataInFigure(PowerDataFig,axesHandles,GaitInfo.tp,RhipPower_avg,RhipPower_sd,RhipRollPower_avg,RhipRollPower_sd,RkneePower_avg,RkneePower_sd,RanklePower_avg,RanklePower_sd,subplotStart,GaitInfo.b_oneGaitPhase);
end
% if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData
%     [plotHandlesWinter,axesHandles] = plotPowerDataInFigure(PowerDataFig,axesHandles,timeWinter,hipPowerWinter_avg,hipPowerWinter_sd,[],[],kneePowerWinter_avg,kneePowerWinter_sd, ...
%         anklePowerWinter_avg,anklePowerWinter_sd,subplotStart);
% end



%%
% set(flipud(legStatePlot.Children),plotInfo.plotProp,plotInfo.plotProp_entries(1:2,:));


for i= 1:size(plotHandlesLeft,1)
    set(plotHandlesLeft(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    if b_plotBothLegs
        set(plotHandlesRight(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        set(plotHandlesLeft(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(1,:));
        if b_plotBothLegs
            set(plotHandlesRight(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(2,:));
        end
    end
%     if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~isnan(plotHandlesWinter(i,1))
%         set(plotHandlesWinter(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
%         set(plotHandlesWinter(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
%     end
end


% set(angularDataFig, 'Position',[10,40,1000,930]);

if setLegend && GaitInfo.b_oneGaitPhase && contains(saveInfo.info,'prosthetic') && plotInfo.plotWinterData 
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Intact leg','Prosthetic leg', 'Winter data');
%     leg = legend('Intact leg','Prosthetic leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')) );
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~b_plotBothLegs
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Model', 'Winter data');
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData 
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Left leg','Right leg', 'Winter data');
elseif setLegend && contains(saveInfo.info,'prosthetic')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Intact leg','Prosthetic leg');
%     leg = legend('Intact leg','Prosthetic leg');
elseif setLegend && ~b_plotBothLegs
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
        saveFigure(PowerDataFig,'powerData',saveInfo.type{j},saveInfo.info)
    end
end