function [plotHandles, axesHandles] = plotMusculoDataInFigure(musculoDataFigure,axesHandles,t,SOL,TA,GAS,VAS,HAM,GLU,HFL,b_oneGaitPhase,HAMc)
plotHandles = nan(7,1);
if isempty(axesHandles)
    for i = 1:length(plotHandles)
        axesHandles(i) = axes(musculoDataFigure);
    end
end
if  nargin <= 11
    HAMc = [0];
end
if  nargin <= 10
    b_oneGaitPhase = true;
end


%%
axesHandles(1) = subplot(4,2,1,axesHandles(1));
plotHandles(1) = plot(axesHandles(1),t,SOL);
title(axesHandles(1),'SOL')
% ylabel('rad');
if (max(SOL)<1)
    ylim(axesHandles(1),[0,1])
end
hold(axesHandles(1),'on');


axesHandles(2) = subplot(4,2,2,axesHandles(2));
plotHandles(2) = plot(axesHandles(2),t,TA);
title(axesHandles(2),'TA')
if (max(TA)<1)
    ylim(axesHandles(2),[0,1])
end
% ylabel('rad/s')
hold(axesHandles(2),'on');

%%
axesHandles(3) = subplot(4,2,3,axesHandles(3));
plotHandles(3) = plot(axesHandles(3),t,GAS);
title(axesHandles(3),'GAS')
if (max(GAS)<1)
    ylim(axesHandles(3),[0,1])
end% ylabel('rad');
hold(axesHandles(3),'on');

axesHandles(4) = subplot(4,2,4,axesHandles(4));
plotHandles(4) = plot(axesHandles(4),t,VAS);
title(axesHandles(4),'VAS')
if (max(VAS)<1)
    ylim(axesHandles(4),[0,1])
end
% ylabel('rad/s')
hold(axesHandles(4),'on');


%%
axesHandles(5) = subplot(4,2,5,axesHandles(5));
if (~isempty(HAMc) && sum(HAMc)~=0)
    plotHandles(5) = plot(axesHandles(5),t,HAMc);
else
    plotHandles(5) = plot(axesHandles(5),t,HAM);
end

title(axesHandles(5),'HAM')
if (max(HAM)<1 && max(HAMc)<1 )
    ylim(axesHandles(5),[0,1])
end
% ylabel('rad');
hold(axesHandles(5),'on');


axesHandles(6) = subplot(4,2,6,axesHandles(6));
plotHandles(6) = plot(axesHandles(6),t,GLU);
title(axesHandles(6),'GLU')
if (max(GLU)<1)
    ylim(axesHandles(6),[0,1])
end
% ylabel('rad/s')
if b_oneGaitPhase
    xlabel(axesHandles(6),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(6),'s')
end
hold(axesHandles(6),'on');


axesHandles(7) = subplot(4,2,7,axesHandles(7));
plotHandles(7) = plot(axesHandles(7),t,HFL);
title(axesHandles(7),'HFL')
if (max(HFL)<1)
    ylim(axesHandles(7),[0,1])
end
% ylabel('rad');
if b_oneGaitPhase
    xlabel(axesHandles(7),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(7),'s')
end
hold(axesHandles(7),'on');