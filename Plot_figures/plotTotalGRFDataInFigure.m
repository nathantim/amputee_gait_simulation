function plotHandles = plotTotalGRFDataInFigure(t,GRFhor_avg,GRFhor_sd,GRFv_avg,GRFv_sd,b_oneGaitPhase)
if  nargin <= 5
    b_oneGaitPhase = true;
end
plotHandles = nan(2,2);

%%
subplot(2,1,1);
plotHandles(1,1) = plot(t,GRFhor_avg);
hold on;
if ~isempty(GRFhor_sd)
    plotHandles(1,2) = fill([t;flipud(t)],[GRFhor_avg-GRFhor_sd;flipud(GRFhor_avg+GRFhor_sd)],[0.8 0.8 0.8]);
end
h = get(gca,'Children');
set(gca,'Children',flipud(h))

title('Total x')
ylabel('N/kg');

%%
subplot(2,1,2);
plotHandles(2,1) = plot(t,GRFv_avg);
hold on;
if ~isempty(GRFv_sd)
    plotHandles(2,2) = fill([t;flipud(t)],[GRFv_avg-GRFv_sd;flipud(GRFv_avg+GRFv_sd)],[0.8 0.8 0.8]);
end
h = get(gca,'Children');
set(gca,'Children',flipud(h))
title('Total z')
ylabel('N/kg');
if b_oneGaitPhase
    xlabel('%_{stride}','interpreter','tex')
else
    xlabel('s')
end



