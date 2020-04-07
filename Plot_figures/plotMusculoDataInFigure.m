function plotHandles = plotMusculoDataInFigure(t,SOL,TA,GAS,VAS,HAM,GLU,HFL,HAMc)
if  nargin <= 8
    HAMc = [];
end

plotHandles = nan(7,1);
%%
subplot(4,2,1);
plotHandles(1) = plot(t,SOL);
title('SOL')
% ylabel('rad');
yaxis([0,1])
hold on;


subplot(4,2,2);
plotHandles(2) = plot(t,TA);
title('TA')
yaxis([0,1])
% ylabel('rad/s')
hold on;

%%
subplot(4,2,3);
plotHandles(3) = plot(t,GAS);
title('GAS')
yaxis([0,1])
% ylabel('rad');
hold on;

subplot(4,2,4);
plotHandles(4) = plot(t,VAS);
title('VAS')
yaxis([0,1])
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
yaxis([0,1])
% ylabel('rad');
hold on;


subplot(4,2,6);
plotHandles(6) = plot(t,GLU);
title('GLU')
yaxis([0,1])
% ylabel('rad/s')
xlabel('%_s_t_r_i_d_e')
hold on;


subplot(4,2,7);
plotHandles(7) = plot(t,HFL);
title('HFL')
yaxis([0,1])
% ylabel('rad');
xlabel('%_s_t_r_i_d_e')
hold on;