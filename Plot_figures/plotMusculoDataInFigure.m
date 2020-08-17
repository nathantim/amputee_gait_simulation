function [plotHandles, axesHandles] = plotMusculoDataInFigure(musculoDataFigure,axesHandles,t,HFL_avg,HFL_sd,GLU_avg,GLU_sd,HAM_avg,HAM_sd,...
                                                                RF_avg,RF_sd,VAS_avg,VAS_sd,BFSH_avg,BFSH_sd,GAS_avg,GAS_sd,SOL_avg,SOL_sd,TA_avg,TA_sd,...
                                                                HAB_avg,HAB_sd,HAD_avg,HAD_sd,b_oneGaitPhase)
plotHandles = nan(11,2);
if isempty(axesHandles)
    for i = 1:length(plotHandles)
        axesHandles(i) = axes(musculoDataFigure);
    end
end

if  nargin < 26
    b_oneGaitPhase = true;
end


%%
axesHandles(1) = subplot(6,2,1,axesHandles(1));
if ~isempty(HFL_sd)
    plotHandles(1,2) = fill(axesHandles(1),[t;flipud(t)],[HFL_avg-HFL_sd;flipud(HFL_avg+HFL_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(1),'on');
plotHandles(1,1) = plot(axesHandles(1),t,HFL_avg);
title(axesHandles(1),'HFL')
% ylabel('rad');
if (max(HFL_avg)<1)
    ylim(axesHandles(1),[0,1])
end


axesHandles(2) = subplot(6,2,2,axesHandles(2));
if ~isempty(GLU_sd)
    plotHandles(2,2) = fill(axesHandles(2),[t;flipud(t)],[GLU_avg-GLU_sd;flipud(GLU_avg+GLU_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(2),'on');
plotHandles(2,1) = plot(axesHandles(2),t,GLU_avg);
title(axesHandles(2),'GLU')
if (max(GLU_avg)<1)
    ylim(axesHandles(2),[0,1])
end
% ylabel('rad/s')


%%
axesHandles(3) = subplot(6,2,3,axesHandles(3));
if ~isempty(HAM_sd)
    plotHandles(3,2) = fill(axesHandles(3),[t;flipud(t)],[HAM_avg-HAM_sd;flipud(HAM_avg+HAM_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(3),'on');
plotHandles(3,1) = plot(axesHandles(3),t,HAM_avg);

title(axesHandles(3),'HAM')
if (max(HAM_avg)<1 )
    ylim(axesHandles(3),[0,1])
end
% ylabel('rad');



axesHandles(4) = subplot(6,2,4,axesHandles(4));
if ~isempty(RF_sd)
    plotHandles(4,2) = fill(axesHandles(4),[t;flipud(t)],[RF_avg-RF_sd;flipud(RF_avg+RF_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(4),'on');
plotHandles(4,1) = plot(axesHandles(4),t,RF_avg);
title(axesHandles(4),'RF')
if (max(RF_avg)<1)
    ylim(axesHandles(4),[0,1])
end% ylabel('rad');


axesHandles(5) = subplot(6,2,5,axesHandles(5));
if ~isempty(VAS_sd)
    plotHandles(5,2) = fill(axesHandles(5),[t;flipud(t)],[VAS_avg-VAS_sd;flipud(VAS_avg+VAS_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(5),'on');
if (length(t) == length(VAS_avg))
    plotHandles(5,1) = plot(axesHandles(5),t,VAS_avg);
else
    plotHandles(5,1) = plot(axesHandles(5),t,zeros(size(t)));
end
title(axesHandles(5),'VAS')
if (max(VAS_avg)<1)
    ylim(axesHandles(5),[0,1])
end
% ylabel('rad/s')




%%

axesHandles(6) = subplot(6,2,6,axesHandles(6));
if ~isempty(BFSH_sd)
    plotHandles(6,2) = fill(axesHandles(6),[t;flipud(t)],[BFSH_avg-BFSH_sd;flipud(BFSH_avg+BFSH_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(6),'on');
if (length(t) == length(BFSH_avg))
    plotHandles(6,1) = plot(axesHandles(6),t,BFSH_avg);
else
    plotHandles(6,1) = plot(axesHandles(6),t,zeros(size(t)));
end

title(axesHandles(6),'BFSH')
if (max(BFSH_avg)<1)
    ylim(axesHandles(6),[0,1])
end
% ylabel('rad/s')



axesHandles(7) = subplot(6,2,7,axesHandles(7));
if ~isempty(GAS_sd)
    plotHandles(7,2) = fill(axesHandles(7),[t;flipud(t)],[GAS_avg-GAS_sd;flipud(GAS_avg+GAS_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(7),'on');
if (length(t) == length(GAS_avg))
    plotHandles(7,1) = plot(axesHandles(7),t,GAS_avg);
else
    plotHandles(7,1) = plot(axesHandles(7),t,zeros(size(t)));
end
title(axesHandles(7),'GAS')
if (max(GAS_avg)<1)
    ylim(axesHandles(7),[0,1])
end
% ylabel('rad');


axesHandles(8) = subplot(6,2,8,axesHandles(8));
if ~isempty(SOL_sd)
    plotHandles(8,2) = fill(axesHandles(8),[t;flipud(t)],[SOL_avg-SOL_sd;flipud(SOL_avg+SOL_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(8),'on');
if (length(t) == length(SOL_avg))
    plotHandles(8,1) = plot(axesHandles(8),t,SOL_avg);
else
    plotHandles(8,1) = plot(axesHandles(8),t,zeros(size(t)));
end
title(axesHandles(8),'SOL')
if (max(SOL_avg)<1)
    ylim(axesHandles(8),[0,1])
end
% ylabel('rad/s')


axesHandles(9) = subplot(6,2,9,axesHandles(9));
if ~isempty(TA_sd)
    plotHandles(9,2) = fill(axesHandles(9),[t;flipud(t)],[TA_avg-TA_sd;flipud(TA_avg+TA_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(9),'on');
if (length(t) == length(TA_avg))
    plotHandles(9,1) = plot(axesHandles(9),t,TA_avg);
else
    plotHandles(9,1) = plot(axesHandles(9),t,zeros(size(t)));
end

title(axesHandles(9),'TA')
if (max(TA_avg)<1)
    ylim(axesHandles(9),[0,1])
end
% ylabel('rad');


axesHandles(10) = subplot(6,2,10,axesHandles(10));
if ~isempty(HAB_sd)
    plotHandles(10,2) = fill(axesHandles(10),[t;flipud(t)],[HAB_avg-HAB_sd;flipud(HAB_avg+HAB_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(10),'on');
plotHandles(10,1) = plot(axesHandles(10),t,HAB_avg);
title(axesHandles(10),'HAB')
if (max(HAB_avg)<1)
    ylim(axesHandles(10),[0,1])
end
% ylabel('rad/s')
if b_oneGaitPhase
    xlabel(axesHandles(10),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(10),'s')
end



axesHandles(11) = subplot(6,2,11,axesHandles(11));
if ~isempty(HAD_sd)
    plotHandles(11,2) = fill(axesHandles(11),[t;flipud(t)],[HAD_avg-HAD_sd;flipud(HAD_avg+HAD_sd)],[0.8 0.8 0.8]);
end
hold(axesHandles(11),'on');
plotHandles(11,1) = plot(axesHandles(11),t,HAD_avg);
title(axesHandles(11),'HAD')
if (max(HAD_avg)<1)
    ylim(axesHandles(11),[0,1])
end
% ylabel('rad');
if b_oneGaitPhase
    xlabel(axesHandles(11),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(11),'s')
end
