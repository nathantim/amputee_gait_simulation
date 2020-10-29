function [plotHandles,axesHandles] = plotAngularData(angularData,plotInfo,GaitInfo,saveInfo,angularDataFigure,axesHandles,subplotStart,legToPlot,b_addTitle)
if nargin < 5
    angularDataFigure = [];
end
if nargin < 6
    axesHandles = [];
end
if nargin < 9
    b_addTitle = true;
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


t = GaitInfo.t;

%%

% Flexion +, Extension -
LhipAngles      = -180/pi*angularData.signals.values(:,3);
RhipAngles      = -180/pi*angularData.signals.values(:,5);

% Flexion +, Extension -
LkneeAngles     = 180/pi*angularData.signals.values(:,7);
RkneeAngles     = 180/pi*angularData.signals.values(:,9);

% Dorsiflexion +, Plantar flexion -
LankleAngles    = -180/pi*angularData.signals.values(:,11);
RankleAngles    = -180/pi*angularData.signals.values(:,13);

% Abduction +, Adduction -
LhipRollAngles    = 180/pi*angularData.signals.values(:,15);
RhipRollAngles    = 180/pi*angularData.signals.values(:,17);

% warning('Unreasoned factor -1');


[LhipAngles_avg,LhipAngles_sd] = interpData2perc(t,GaitInfo.tp,LhipAngles,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LhipRollAngles_avg,LhipRollAngles_sd] = interpData2perc(t,GaitInfo.tp,LhipRollAngles,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LkneeAngles_avg,LkneeAngles_sd] = interpData2perc(t,GaitInfo.tp,LkneeAngles,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LankleAngles_avg,LankleAngles_sd] = interpData2perc(t,GaitInfo.tp,LankleAngles,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[RhipAngles_avg,RhipAngles_sd] = interpData2perc(t,GaitInfo.tp,RhipAngles,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RhipRollAngles_avg,RhipRollAngles_sd] = interpData2perc(t,GaitInfo.tp,RhipRollAngles,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RkneeAngles_avg,RkneeAngles_sd] = interpData2perc(t,GaitInfo.tp,RkneeAngles,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RankleAngles_avg,RankleAngles_sd] = interpData2perc(t,GaitInfo.tp,RankleAngles,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

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
if plotInfo.showTables
    varNames = {'LHipAbduction (deg)','RHipAbduction (deg)','LHipFlexion (deg)','RHipFlexion (deg)',...
                'LKneeFlexion (deg)','RKneeFlexion (deg)','LAnkleDorsiflexion (deg)','RAnkleDorsiflexion (deg)'};
    rangeTable = createRangeTable(GaitInfo,varNames,LhipRollAngles_avg,RhipRollAngles_avg,LhipAngles_avg,RhipAngles_avg,LkneeAngles_avg,RkneeAngles_avg,LankleAngles_avg,RankleAngles_avg);
    if ~isempty(rangeTable)
%         fprintf('Joint angle range (deg):\n');
        disp(rangeTable);
    end
end
%%
if isempty(angularDataFigure) && isempty(axesHandles)
    angularDataFig = figure();
    fullScreen = get(0,'screensize');
    set(angularDataFig, 'Position',[fullScreen(1:2)+20 fullScreen(3:4)*0.9]);
else
   
    angularDataFig = angularDataFigure; 
end
% set(0, 'DefaultAxesFontSize',12);
if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData 
    [timeWinter,hipAngleWinter_avg,hipAngleWinter_sd, kneeAngleWinter_avg,kneeAngleWinter_sd, ankleAngleWinter_avg,ankleAngleWinter_sd, ...
                                    ~,~,~,~, ~,~,~,~,~,~] = getWinterData(GaitInfo.WinterDataSpeed,"deg");
end
%%

 %%
 
 %     subplot(5,1,2);
 %     HATAnglePlot = plot(t_left_perc,HATAngle);
 %     title('HAT angle')
 %     ylabel('rad');
 %%
 plotHandlesLeft = [];
 plotHandlesRight = [];
 
 if contains(legToPlot,'left') || contains(legToPlot,'both')
 [plotHandlesLeft,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,GaitInfo.tp,LhipAngles_avg,LhipAngles_sd,LhipRollAngles_avg,LhipRollAngles_sd,LkneeAngles_avg,LkneeAngles_sd,LankleAngles_avg,LankleAngles_sd,subplotStart,GaitInfo.b_oneGaitPhase,b_addTitle);
 end
 if contains(legToPlot,'right') || contains(legToPlot,'both')
     if ~isempty(axesHandles)
        b_addTitle = false;
    end
     [plotHandlesRight,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,GaitInfo.tp,RhipAngles_avg,RhipAngles_sd,RhipRollAngles_avg,RhipRollAngles_sd,RkneeAngles_avg,RkneeAngles_sd,RankleAngles_avg,RankleAngles_sd,subplotStart,GaitInfo.b_oneGaitPhase,b_addTitle);
 end
 if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData
     [plotHandlesWinter,axesHandles] = plotAngularDataInFigure(angularDataFig,axesHandles,timeWinter,hipAngleWinter_avg,hipAngleWinter_sd,[],[],kneeAngleWinter_avg,kneeAngleWinter_sd, ...
         ankleAngleWinter_avg,ankleAngleWinter_sd,subplotStart);
 end
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
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~legToPlot
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Model', 'Winter data');
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && contains(legToPlot,'both')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Left leg','Right leg', 'Winter data');
elseif setLegend && contains(saveInfo.info,'prosthetic') && contains(legToPlot,'both')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Intact leg','Prosthetic leg');
%     leg = legend('Intact leg','Prosthetic leg');
elseif setLegend && ~contains(legToPlot,'both')
    leg = [];
elseif setLegend && contains(legToPlot,'both')
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
        saveFigure(angularDataFig,'angularData',saveInfo.type{j},saveInfo.info)
    end
end
