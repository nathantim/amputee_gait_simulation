function plotHandles = plotGRFDataInFigure(t,Ball,Total,Heel)
plotHandles = nan(6,1);

%%
subplot(3,2,1);
plotHandles(1) = plot(t,Total(:,1));
title('Total x')
% ylabel('-');

hold on;


subplot(3,2,2);
plotHandles(2) = plot(t,Total(:,2));
title('Total z')
% ylabel('-');
hold on;

%%
subplot(3,2,3);
plotHandles(3) = plot(t,Ball(:,1));
title('Ball x')
% ylabel('-');
hold on;

subplot(3,2,4);
plotHandles(4) = plot(t,Ball(:,2));
title('Ball z')
% ylabel('-');
hold on;


%%
subplot(3,2,5);
plotHandles(5) = plot(t,Heel(:,1));
title('Heel x')
% ylabel('-');
xlabel('%_s_t_r_i_d_e')
hold on;


subplot(3,2,6);
plotHandles(6) = plot(t,Heel(:,2));
title('Heel z')
% ylabel('-');
xlabel('%_s_t_r_i_d_e')
hold on;

