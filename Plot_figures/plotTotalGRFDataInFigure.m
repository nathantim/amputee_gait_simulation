function plotHandles = plotTotalGRFDataInFigure(t,Total,b_oneGaitPhase)
if  nargin <= 2
    b_oneGaitPhase = true;
end
plotHandles = nan(2,1);

%%
subplot(2,1,1);
plotHandles(1) = plot(t,Total(:,1));
title('Total x')
ylabel('N/kg');

hold on;


subplot(2,1,2);
plotHandles(2) = plot(t,Total(:,2));
title('Total z')
ylabel('N/kg');
if b_oneGaitPhase
    xlabel('%_{stride}','interpreter','tex')
else
    xlabel('s')
end
hold on;


