function plotCMGData(CMGData,saveInfoInput,CMGDataFigure,b_saveFigure)
if nargin <3
   CMGDataFigure = []; 
end
if nargin < 4
    b_saveFigure = false;
end
if ~isstruct(saveInfoInput)
   saveInfo.info = saveInfoInput;
   saveInfo.b_saveFigure = b_saveFigure;
   saveInfo.type = {'jpeg','eps','emf'};
else
    saveInfo = saveInfoInput;
end
CMGParams;
idx = (find(abs(CMGData.time-6) == min(abs(CMGData.time-6))):find(abs(CMGData.time-9) == min(abs(CMGData.time-9))));

if isempty(CMGDataFigure)
CMGDataFig = figure();
set(CMGDataFig, 'Position',[10,50,1000,900]);
else
  CMGDataFig = CMGDataFigure;
end

%% Angle
subplot(411); 
plot(CMGData.time(idx),CMGData.signals.values(idx,1)); 
hold on;
if abs(maxGMangle) < 100
    plot(CMGData.time([idx(1),idx(end)]),180/pi*maxGMangle*ones(1,2),'--');
end
legend('$\gamma$(t)','$\gamma_{{max}}$');
title('GM angle');
ylabel('$\gamma$(t) (deg)'); 

%% Angular velocity
subplot(412); 
plot(CMGData.time(idx),CMGData.signals.values(idx,2)); 
hold on;
plot(CMGData.time(idx),CMGData.signals.values(idx,3),':'); 
legend('$\dot{\gamma}(t)$','$\dot{\gamma}_{\mathrm{ref}}$');
title('GM angular velocity ');
yaxis([(min( [CMGData.signals.values(idx,2);CMGData.signals.values(idx,3)] )*1.1), (max( [CMGData.signals.values(idx,2);CMGData.signals.values(idx,3)] )*1.1) ]);
ylabel('$\dot{\gamma}(t)$ (rad/s)'); 

%% torque
subplot(413); 
% plot(CMGData.time(idx),CMGData.signals.values(idx,6)); % total
plot(CMGData.time(idx),CMGData.signals.values(idx,6),':');  % locking torque
% hold on;
% plot(CMGData.time(idx),CMGData.signals.values(idx,8));  % trip reaction torque
title('GM torque');
yaxis([max(-15,min(min(CMGData.signals.values(idx,6:8)*1.1))),min(15,max(max(1.1*CMGData.signals.values(idx,6:8))))]);
% yaxis(min((CMGData.signals.values(idx,8))-2),(max(CMGData.signals.values(idx,8))+2));
% legend('$\tau_{{\mathrm{r}0}}(t)$','$\tau_{\mathrm{llc}}(t)$','Location','north');

ylabel('$\tau(t)$ (Nm)'); 

%% Angular momentum
subplot(414); 
colorOrder = get(gca,'colororder');
plot(CMGData.time(idx),CMGData.signals.values(idx,9),'-.'); 
hold on;
plot(CMGData.time(idx),CMGData.signals.values(idx,10)); 

plot(CMGData.time(idx),CMGData.signals.values(idx,11),'--');%,'color',colorOrder(4,:)); 
plot(CMGData.time(idx),CMGData.signals.values(idx,12),' :');%,'color',colorOrder(3,:)); 
% plot(CMGData.time(idx),-CMGData.signals.values(idx,9),'--','color',colorOrder(4,:)); 

legend('$\Delta H_{\mathrm{ML}}(t)$','$\Delta H_{\mathrm{AP}}(t)$','$||\mathbf{H}(t)||$','$||\Delta\mathbf{H}(t)||$','location','northwest');
title('Exchanged angular momentum');
ylabel('$\Delta H(t)$ (Nms)'); 
xlabel('time (s)');

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(CMGDataFig,'CMGData',saveInfo.type{j},saveInfo.info,true)
    end
end