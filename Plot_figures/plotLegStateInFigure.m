function [plotHandles,axesHandles] = plotLegStateInFigure(legStateDataFig,axesHandles,t,legState_avg,legState_sd,subplotStart,b_addTitle)
plotHandles = nan(1,2);
if isempty(axesHandles)
    for i = 1:size(plotHandles,1)
        axesHandles(i) = axes(legStateDataFig);
    end
end

if nargin < 7
    b_addTitle = true;
end
%%
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(legState_sd)
     plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[round(legState_avg-legState_sd);flipud(round(legState_avg+legState_sd))],[0.8 0.8 0.8]);
 end
%  subplotStart(3) = subplotStart(3)+1;
hold(axesHandles(axidx),'on');

% Substracting 0.3 is done to make sure that during rounding off everything below .8 is rounded off to the lower integer.  
 plotHandles(axidx,1) = stairs(axesHandles(axidx),t,round(legState_avg-0.3));

 if b_addTitle
     title(axesHandles(axidx),'Leg state');
 end
 yticks(axesHandles(axidx),0:1:4);
 yticklabels(axesHandles(axidx),{'EarlyStance','LateStance','Lift-off','Swing','Landing'})