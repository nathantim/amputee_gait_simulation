function [plotHandles,axesHandles] = plotPhasePortraitInFigure(phasePortraitFig,axesHandles,hipAngle_avg,hipAngle_sd, ...
    hipRollAngle_avg,hipRollAngle_sd,kneeAngle_avg,kneeAngle_sd,ankleAngle_avg,ankleAngle_sd,hipAngleVel_avg,hipAngleVel_sd, ...
    hipRollAngleVel_avg,hipRollAngleVel_sd,kneeAngleVel_avg,kneeAngleVel_sd,ankleAngleVel_avg,ankleAngleVel_sd,...
    subplotStart,b_oneGaitPhase,b_addTitle)

plotHandles = nan(4,2);
if isempty(axesHandles)
    for i = 1:size(plotHandles,1)
        axesHandles(i) = axes(phasePortraitFig);
    end
end
if  nargin < 20
    b_oneGaitPhase = true;
end
if nargin < 21
   b_addTitle = true; 
end

% subplotStart = dec2base(subplotStart,10) - '0';

%%
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(hipRollAngle_avg) && ~isempty(hipRollAngleVel_avg)
    plotHandles(axidx,1) = plot(axesHandles(axidx),[hipRollAngle_avg; hipRollAngle_avg(1)],[hipRollAngleVel_avg;hipRollAngleVel_avg(1)]);
end
hold(axesHandles(axidx),'on');

if b_addTitle
    title(axesHandles(axidx),'Hip abduction');
end
ylabel(axesHandles(axidx),'Angular velocity (deg/s)');

%%
subplotStart(3) = subplotStart(3) +1;
axidx = 2;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(hipAngle_avg) && ~isempty(hipAngleVel_avg)
    plotHandles(axidx,1) = plot(axesHandles(axidx),[hipAngle_avg;hipAngle_avg(1)],[hipAngleVel_avg;hipAngleVel_avg(1)]);
end
hold(axesHandles(axidx),'on');

if b_addTitle
    title(axesHandles(axidx),'Hip flexion');
end


%%
subplotStart(3) = subplotStart(3) +1;
axidx = 3;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(kneeAngle_avg) && ~isempty(kneeAngleVel_avg)
    plotHandles(axidx,1) = plot(axesHandles(axidx),[kneeAngle_avg;kneeAngle_avg(1)],[kneeAngleVel_avg;kneeAngleVel_avg(1)]);
end
hold(axesHandles(axidx),'on');

if b_addTitle
    title(axesHandles(axidx),'Knee flexion');
end


%%
subplotStart(3) = subplotStart(3) +1;
axidx = 4;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(ankleAngle_avg) && ~isempty(ankleAngleVel_avg)
    plotHandles(axidx,1) = plot(axesHandles(axidx),[ankleAngle_avg;ankleAngle_avg(1)],[ankleAngleVel_avg;ankleAngleVel_avg(1)]);
end
hold(axesHandles(axidx),'on');

if b_addTitle
    title(axesHandles(axidx),'Ankle dorsiflexion');
end


