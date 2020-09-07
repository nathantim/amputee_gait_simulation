function plotCMGData(CMGData,saveInfo,CMGDataFigure)
if nargin <3
   CMGDataFigure = []; 
end
CMGParams;
idx = (find(CMGData.time==6):find(CMGData.time==9));

if isempty(CMGDataFigure)
CMGDataFig = figure();
set(CMGDataFig, 'Position',[10,50,1000,900]);
else
  CMGDataFig = CMGDataFigure;
end
subplot(411); 
plot(CMGData.time(idx),CMGData.signals.values(idx,1)); 
hold on;
plot(CMGData.time([idx(1),idx(end)]),180/pi*maxGMangle*ones(1,2),'--');
legend('$\gamma$(t)','$\gamma_{{max}}$');
title('GM angle');
ylabel('$\gamma$(t) (deg)'); 

subplot(412); 
plot(CMGData.time(idx),CMGData.signals.values(idx,2)); 
hold on;
plot(CMGData.time(idx),CMGData.signals.values(idx,3),':'); 
legend('$\dot{\gamma}(t)$','$\dot{\gamma}_{{ref}}$');
title('GM angular velocity ');
yaxis(min((CMGData.signals.values(idx,3))-2),(max(CMGData.signals.values(idx,3))+2));
ylabel('$\dot{\gamma}(t)$ (rad/s)'); 

subplot(413); 
% plot(CMGData.time(idx),CMGData.signals.values(idx,6)); % total
plot(CMGData.time(idx),CMGData.signals.values(idx,7),':');  % locking torque
hold on;
plot(CMGData.time(idx),CMGData.signals.values(idx,8));  % trip reaction torque
title('GM lock and trip prevention torque');
yaxis(-10,10);
% yaxis(min((CMGData.signals.values(idx,8))-2),(max(CMGData.signals.values(idx,8))+2));
legend('$\tau_{{L}}(t)$','$\tau_{{T}}(t)$');

ylabel('$\tau(t)$ (Nm)'); 


subplot(414); 
colorOrder = get(gca,'colororder');
plot(CMGData.time(idx),CMGData.signals.values(idx,9),'-.'); 
hold on;
plot(CMGData.time(idx),CMGData.signals.values(idx,10)); 

plot(CMGData.time(idx),CMGData.signals.values(idx,11),'--');%,'color',colorOrder(4,:)); 
plot(CMGData.time(idx),CMGData.signals.values(idx,12),' :');%,'color',colorOrder(3,:)); 
% plot(CMGData.time(idx),-CMGData.signals.values(idx,9),'--','color',colorOrder(4,:)); 

legend('$\Delta H_{ML}(t)$','$\Delta H_{AP}(t)$','$||\mathbf{H}(t)||$','$||\Delta\mathbf{H}(t)||$','location','northwest');
title('Exchanged angular momentum');
ylabel('$\Delta H(t)$ (Nms)'); 
xlabel('time in seconds');

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(CMGDataFig,'CMGData',saveInfo.type{j},saveInfo.info)
    end
end