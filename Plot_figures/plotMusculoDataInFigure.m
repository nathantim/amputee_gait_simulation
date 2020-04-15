function plotHandles = plotMusculoDataInFigure(t,SOL,TA,GAS,VAS,HAM,GLU,HFL,b_oneGaitPhase,HAMc)
if  nargin <= 9
    HAMc = [0];
end
if  nargin <= 8
    b_oneGaitPhase = true;
end

plotHandles = nan(7,1);
%%
subplot(4,2,1);
plotHandles(1) = plot(t,SOL);
title('SOL')
% ylabel('rad');
if (max(SOL)<1)
    yaxis([0,1])
end
hold on;


subplot(4,2,2);
plotHandles(2) = plot(t,TA);
title('TA')
if (max(TA)<1)
    yaxis([0,1])
end
% ylabel('rad/s')
hold on;

%%
subplot(4,2,3);
plotHandles(3) = plot(t,GAS);
title('GAS')
if (max(GAS)<1)
    yaxis([0,1])
end% ylabel('rad');
hold on;

subplot(4,2,4);
plotHandles(4) = plot(t,VAS);
title('VAS')
if (max(VAS)<1)
    yaxis([0,1])
end
% ylabel('rad/s')
hold on;


%%
subplot(4,2,5);
if (~isempty(HAMc) && sum(HAMc)~=0)
    plotHandles(5) = plot(t,HAMc);
else
    plotHandles(5) = plot(t,HAM);
end

title('HAM')
if (max(HAM)<1 && max(HAMc)<1 )
    yaxis([0,1])
end
% ylabel('rad');
hold on;


subplot(4,2,6);
plotHandles(6) = plot(t,GLU);
title('GLU')
if (max(GLU)<1)
    yaxis([0,1])
end
% ylabel('rad/s')
if b_oneGaitPhase
    xlabel('%_s_t_r_i_d_e')
else
    xlabel('s')
end
hold on;


subplot(4,2,7);
plotHandles(7) = plot(t,HFL);
title('HFL')
if (max(HFL)<1)
    yaxis([0,1])
end
% ylabel('rad');
if b_oneGaitPhase
    xlabel('%_s_t_r_i_d_e')
else
    xlabel('s')
end
hold on;