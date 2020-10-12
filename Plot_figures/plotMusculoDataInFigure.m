function [plotHandles, axesHandles] = plotMusculoDataInFigure(musculoDataFigure,axesHandles,t,HFL_avg,HFL_sd,GLU_avg,GLU_sd,HAM_avg,HAM_sd,...
                                                                RF_avg,RF_sd,VAS_avg,VAS_sd,BFSH_avg,BFSH_sd,GAS_avg,GAS_sd,SOL_avg,SOL_sd,TA_avg,TA_sd,...
                                                                HAB_avg,HAB_sd,HAD_avg,HAD_sd,b_oneGaitPhase,subplotStart,b_addTitle)
plotHandles = nan(11,2);
if isempty(axesHandles)
    for i = 1:length(plotHandles)
        axesHandles(i) = axes(musculoDataFigure);
    end
end

if  nargin < 26
    b_oneGaitPhase = true;
end
if nargin < 27
    b_addTitle = true;
end

% subplotStart = dec2base(subplotStart,10) - '0';

%%
axidx = 1;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(HAB_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[HAB_avg-HAB_sd;flipud(HAB_avg+HAB_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,HAB_avg);
if b_addTitle
    title(axesHandles(axidx),'HAB');
end
if (max(HAB_avg)<1)
    ylim(axesHandles(axidx),[0,1])
end
ylabel(axesHandles(axidx),'Activation (-)');
% ylabel('rad/s')

subplotStart(3) = subplotStart(3) +1;
axidx = 2;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(HAD_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[HAD_avg-HAD_sd;flipud(HAD_avg+HAD_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,HAD_avg);
if b_addTitle
    title(axesHandles(axidx),'HAD');
end
if (max(HAD_avg)<1)
    ylim(axesHandles(axidx),[0,1])
end

subplotStart(3) = subplotStart(3) +1;
axidx = 3;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(HFL_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[HFL_avg-HFL_sd;flipud(HFL_avg+HFL_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,HFL_avg);
if b_addTitle
    title(axesHandles(axidx),'HFL');
end
% ylabel('rad');
if (max(HFL_avg)<1)
    ylim(axesHandles(axidx),[0,1])
end

subplotStart(3) = subplotStart(3) +1;
axidx = 4;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(GLU_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[GLU_avg-GLU_sd;flipud(GLU_avg+GLU_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,GLU_avg);
if b_addTitle
    title(axesHandles(axidx),'GLU');
end
if (max(GLU_avg)<1)
    ylim(axesHandles(axidx),[0,1])
end
% ylabel('rad/s')


%%
subplotStart(3) = subplotStart(3) +1;
axidx = 5;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(HAM_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[HAM_avg-HAM_sd;flipud(HAM_avg+HAM_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,HAM_avg);
if b_addTitle
    title(axesHandles(axidx),'HAM');
end
if (max(HAM_avg)<1 )
    ylim(axesHandles(axidx),[0,1])
end
% ylabel('rad');


subplotStart(3) = subplotStart(3) +1;
axidx = 6;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(RF_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[RF_avg-RF_sd;flipud(RF_avg+RF_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
plotHandles(axidx,1) = plot(axesHandles(axidx),t,RF_avg);
if b_addTitle
    title(axesHandles(axidx),'RF');
end
if (max(RF_avg)<1)
    ylim(axesHandles(axidx),[0,1])
end% ylabel('rad');

subplotStart(3) = subplotStart(3) +1;
axidx = 7;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(VAS_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[VAS_avg-VAS_sd;flipud(VAS_avg+VAS_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
if (length(t) == length(VAS_avg))
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,VAS_avg);
else
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,zeros(size(t)));
end
if b_addTitle
title(axesHandles(axidx),'VAS');
end
if (max(VAS_avg)<1)
    ylim(axesHandles(axidx),[0,1])
end
% ylabel('rad/s')




%%
subplotStart(3) = subplotStart(3) +1;
axidx = 8;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(BFSH_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[BFSH_avg-BFSH_sd;flipud(BFSH_avg+BFSH_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
if (length(t) == length(BFSH_avg))
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,BFSH_avg);
else
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,zeros(size(t)));
end
if b_addTitle
    title(axesHandles(axidx),'BFSH');
end
if (max(BFSH_avg)<1)
    ylim(axesHandles(axidx),[0,1])
end
% ylabel('rad/s')


subplotStart(3) = subplotStart(3) +1;
axidx = 9;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(GAS_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[GAS_avg-GAS_sd;flipud(GAS_avg+GAS_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
if (length(t) == length(GAS_avg))
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,GAS_avg);
else
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,zeros(size(t)));
end
if b_addTitle
    title(axesHandles(axidx),'GAS');
end
if (max(GAS_avg)<1)
    ylim(axesHandles(axidx),[0,1])
end
% ylabel('rad');

subplotStart(3) = subplotStart(3) +1;
axidx = 10;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(SOL_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[SOL_avg-SOL_sd;flipud(SOL_avg+SOL_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
if (length(t) == length(SOL_avg))
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,SOL_avg);
else
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,zeros(size(t)));
end
if b_addTitle
    title(axesHandles(axidx),'SOL');
end
if (max(SOL_avg)<1)
    ylim(axesHandles(axidx),[0,1])
end
% ylabel('rad/s')

subplotStart(3) = subplotStart(3) +1;
axidx = 11;
axesHandles(axidx) = subplot(subplotStart(1),subplotStart(2),subplotStart(3),axesHandles(axidx));
if ~isempty(TA_sd)
    plotHandles(axidx,2) = fill(axesHandles(axidx),[t;flipud(t)],[TA_avg-TA_sd;flipud(TA_avg+TA_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(axidx),'on');
if (length(t) == length(TA_avg))
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,TA_avg);
else
    plotHandles(axidx,1) = plot(axesHandles(axidx),t,zeros(size(t)));
end
if b_addTitle
    title(axesHandles(axidx),'TA');
end
if (max(TA_avg)<1)
    ylim(axesHandles(axidx),[0,1])
end
% ylabel('rad');

% ylabel('rad');

% if b_oneGaitPhase
%     xlabel(axesHandles(10),'%_{stride}','interpreter','tex')
%     xlabel(axesHandles(11),'%_{stride}','interpreter','tex')
% else
%     xlabel(axesHandles(10),'s')
%     xlabel(axesHandles(11),'s')
% end
