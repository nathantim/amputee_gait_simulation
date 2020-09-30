function plotLegState(GaitPhaseData,plotInfo,GaitInfo,saveInfo,legStateFigure,subplotStart,b_plotBothLegs)
if nargin < 5
    legStateFigure = [];
end

if nargin < 6 || isempty(subplotStart)
%     subplotStart = 151;
subplotStart = [1 1 1];

setLegend = true;

else
    setLegend = false;
end
if nargin < 7
    b_plotBothLegs = true;
end

t = GaitPhaseData.time;
%%


leftLegState    = GaitPhaseData.signals.values(:,1);
rightLegState   = GaitPhaseData.signals.values(:,2);



[leftLegState_avg,leftLegState_sd] = interpData2perc(t,GaitInfo.tp,leftLegState,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[rightLegState_avg,rightLegState_sd] = interpData2perc(t,GaitInfo.tp,rightLegState,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

if ~plotInfo.showSD
    leftLegState_sd = [];
    rightLegState_sd = [];    
end

%%
if isempty(legStateFigure)
    legStateFig = figure();
    set(legStateFig, 'Position',[10,0,1000,1530]);
else
   
    legStateFig = legStateFigure; 
end
% set(0, 'DefaultAxesFontSize',12);

%%

 %%
 
 legStatePlot = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axes(legStateFig));
 if ~GaitInfo.b_oneGaitPhase
     GaitInfo.tp = GaitPhaseData.time;
 end
 subplotStart(3) = subplotStart(3)+1;
 if ~isempty(leftLegState_sd)
     LegHandles(1,2) = fill(legStatePlot,[GaitInfo.tp;flipud(GaitInfo.tp)],[round(leftLegState_avg-leftLegState_sd);flipud(round(leftLegState_avg+leftLegState_sd))],[0.8 0.8 0.8]);
 end
 set(legStatePlot,'NextPlot','add');
 if ~isempty(rightLegState_sd) && b_plotBothLegs
     LegHandles(2,2) = fill(legStatePlot,[GaitInfo.tp;flipud(GaitInfo.tp)],[round(rightLegState_avg-rightLegState_sd);flipud(round(rightLegState_avg+rightLegState_sd))],[0.8 0.8 0.8]);
 end
 
 LegHandles(1,1) = stairs(legStatePlot,GaitInfo.tp,round(leftLegState_avg));
 %     stairs(legStatePlot,t_left_perc,round(leftLegState_avg));
 if b_plotBothLegs
     LegHandles(2,1) = stairs(legStatePlot,GaitInfo.tp,round(rightLegState_avg));
     xlabel(legStatePlot,'%_{stride}','interpreter','tex');
 end
 %     stairs(legStatePlot,t_right_perc,rightLegState);
 title(legStatePlot,'Leg state')
 yticks(legStatePlot,0:1:4);
 yticklabels(legStatePlot,{'EarlyStance','LateStance','Lift-off','Swing','Landing'})
% if b_oneGaitPhase
    
% else
%     xlabel(axesHandles(4),'s')
% end
 %     subplot(5,1,2);
 %     HATAnglePlot = plot(t_left_perc,HATAngle);
 %     title('HAT angle')
 %     ylabel('rad');
 %%
 
%%
% set(flipud(legStatePlot.Children),plotInfo.plotProp,plotInfo.plotProp_entries(1:2,:));
for j = 1:size(LegHandles,1)
    set(LegHandles(j,1),plotInfo.plotProp,plotInfo.plotProp_entries(j,:));
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        set(LegHandles(j,2),plotInfo.fillProp,plotInfo.fillProp_entries(j,:));
    end
end



if setLegend && contains(saveInfo.info,'prosthetic')
    leg = legend([LegHandles(1,1),LegHandles(2,1)],'Intact leg','Prosthetic leg');
%     leg = legend('Intact leg','Prosthetic leg');
elseif setLegend && ~b_plotBothLegs
    leg = [];
elseif setLegend 
    leg = legend([LegHandles(1,1),LegHandles(2,1)],'Left leg','Right leg');
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
        saveFigure(legStateFig,'legState',saveInfo.type{j},saveInfo.info)
    end
end
