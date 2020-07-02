function [plotHandles, axesHandles] = plotMusculoDataInFigure(musculoDataFigure,axesHandles,t,HFL,GLU,HAM,RF,VAS,BFSH,GAS,SOL,TA,HAB,HAD,b_oneGaitPhase,HAMc)
plotHandles = nan(11,1);
if isempty(axesHandles)
    for i = 1:length(plotHandles)
        axesHandles(i) = axes(musculoDataFigure);
    end
end
if  nargin < 16
    HAMc = [0];
end
if  nargin < 15
    b_oneGaitPhase = true;
end


%%
axesHandles(1) = subplot(6,2,1,axesHandles(1));
plotHandles(1) = plot(axesHandles(1),t,HFL);
title(axesHandles(1),'HFL')
% ylabel('rad');
if (max(HFL)<1)
    ylim(axesHandles(1),[0,1])
end
hold(axesHandles(1),'on');


axesHandles(2) = subplot(6,2,2,axesHandles(2));
plotHandles(2) = plot(axesHandles(2),t,GLU);
title(axesHandles(2),'GLU')
if (max(GLU)<1)
    ylim(axesHandles(2),[0,1])
end
% ylabel('rad/s')
hold(axesHandles(2),'on');

%%
axesHandles(3) = subplot(6,2,3,axesHandles(3));
if (~isempty(HAMc) && sum(HAMc)~=0)
    plotHandles(3) = plot(axesHandles(3),t,HAMc);
else
    plotHandles(3) = plot(axesHandles(3),t,HAM);
end

title(axesHandles(3),'HAM')
if (max(HAM)<1 && max(HAMc)<1 )
    ylim(axesHandles(3),[0,1])
end
% ylabel('rad');
hold(axesHandles(3),'on');


axesHandles(4) = subplot(6,2,4,axesHandles(4));
plotHandles(4) = plot(axesHandles(4),t,RF);
title(axesHandles(4),'RF')
if (max(RF)<1)
    ylim(axesHandles(4),[0,1])
end% ylabel('rad');
hold(axesHandles(4),'on');

axesHandles(5) = subplot(6,2,5,axesHandles(5));
plotHandles(5) = plot(axesHandles(5),t,VAS);
title(axesHandles(5),'VAS')
if (max(VAS)<1)
    ylim(axesHandles(5),[0,1])
end
% ylabel('rad/s')
hold(axesHandles(5),'on');

%%

axesHandles(6) = subplot(6,2,6,axesHandles(6));
plotHandles(6) = plot(axesHandles(6),t,BFSH);
title(axesHandles(6),'BFSH')
if (max(BFSH)<1)
    ylim(axesHandles(6),[0,1])
end
% ylabel('rad/s')
hold(axesHandles(6),'on');


axesHandles(7) = subplot(6,2,7,axesHandles(7));
plotHandles(7) = plot(axesHandles(7),t,GAS);
title(axesHandles(7),'GAS')
if (max(GAS)<1)
    ylim(axesHandles(7),[0,1])
end
% ylabel('rad');
hold(axesHandles(7),'on');

axesHandles(8) = subplot(6,2,8,axesHandles(8));
plotHandles(8) = plot(axesHandles(8),t,SOL);
title(axesHandles(8),'SOL')
if (max(SOL)<1)
    ylim(axesHandles(8),[0,1])
end
% ylabel('rad/s')

hold(axesHandles(8),'on');


axesHandles(9) = subplot(6,2,9,axesHandles(9));
plotHandles(9) = plot(axesHandles(9),t,TA);
title(axesHandles(9),'TA')
if (max(TA)<1)
    ylim(axesHandles(9),[0,1])
end
% ylabel('rad');
hold(axesHandles(9),'on');

axesHandles(10) = subplot(6,2,10,axesHandles(10));
plotHandles(10) = plot(axesHandles(10),t,HAB);
title(axesHandles(10),'HAB')
if (max(HAB)<1)
    ylim(axesHandles(10),[0,1])
end
% ylabel('rad/s')
if b_oneGaitPhase
    xlabel(axesHandles(10),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(10),'s')
end
hold(axesHandles(10),'on');


axesHandles(11) = subplot(6,2,11,axesHandles(11));
plotHandles(11) = plot(axesHandles(11),t,HAD);
title(axesHandles(11),'HAD')
if (max(HAD)<1)
    ylim(axesHandles(11),[0,1])
end
% ylabel('rad');
if b_oneGaitPhase
    xlabel(axesHandles(11),'%_{stride}','interpreter','tex')
else
    xlabel(axesHandles(11),'s')
end
hold(axesHandles(11),'on');