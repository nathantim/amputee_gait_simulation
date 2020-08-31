function plotCMGData(CMGData,info,b_saveFigure)
if nargin <3
   b_saveFigure = 0; 
end
saveType = {'jpeg','eps','emf'};
CMGParams;
idx = (find(CMGData.time==6):find(CMGData.time==9));

CMGDataFig = figure(); 
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
ylabel('$\dot{\gamma}(t)$ (rad/s)'); 

subplot(413); 
plot(CMGData.time(idx),CMGData.signals.values(idx,6)); 
title('GM torque');
ylabel('$\tau(t)$ (Nm)'); 


subplot(414); 
colorOrder = get(gca,'colororder');
plot(CMGData.time(idx),CMGData.signals.values(idx,7),'-.'); 
hold on;
plot(CMGData.time(idx),CMGData.signals.values(idx,8)); 

plot(CMGData.time(idx),CMGData.signals.values(idx,9),'--');%,'color',colorOrder(4,:)); 
plot(CMGData.time(idx),CMGData.signals.values(idx,10),' :');%,'color',colorOrder(3,:)); 
% plot(CMGData.time(idx),-CMGData.signals.values(idx,9),'--','color',colorOrder(4,:)); 

legend('$\Delta H_{ML}(t)$','$\Delta H_{AP}(t)$','$||\mathbf{H}(t)||$','$||\Delta\mathbf{H}(t)||$','location','northwest');
title('Exchanged angular momentum');
ylabel('$\Delta H(t)$ (Nms)'); 
xlabel('time in seconds');

if b_saveFigure
    for j = 1:length(saveType)
        saveFigure(CMGDataFig,'CMGData',saveType{j},info)
    end
end