close all; 
% clearvars; 
clc;
%%
models = {'friction_test','stance_flexion_test','swing_flexion_test'};
stoptime = {'0.32','2','3'};
% phases = ["swing";"stance"];


for i = 1%:2%1:length(models)
    %%
    warning('off');
    simout = sim(models{i},'TimeOut',2*60,...
        'SaveOutput','on','StopTime',stoptime{i});
    warning('on');
    
    time = get(simout,'time');
    knee_angle_plot = 180/pi*get(simout,'knee_angle');
    ICR = get(simout,'ICR');
    pos14_1 = get(simout,'pos14_1');
    pos14_2 = get(simout,'pos14_2');
    pos25_1 = get(simout,'pos25_1');
    pos25_2 = get(simout,'pos25_2');
    hingeangles = get(simout,'hingeangles');
    stance_unit = get(simout,'stance_unit');
    swing_unit = get(simout,'swing_unit');
    theta = get(simout,'theta');
    l_stance_elem = get(simout,'l_stance_elem');
    l_swing_elem = get(simout,'l_swing_elem');
    if isempty(l_stance_elem)
        l_stance_elem = stance_unit(:,end);
        l_swing_elem = swing_unit(:,end);
    end
    %%
    figure();
    set(gcf,'Position',[30,80,700,600]);
%     warning('off')
%     sgtitle(models{i});     warning('on');
    subplot(2,1,1)
    plot(time,knee_angle_plot);
    title('Knee angle');
    ylabel('deg');
    yaxis([0 (max(knee_angle_plot)+3)]);
%     yaxis([-5 15]);
    subplot(2,1,2);
    plot(time,l_stance_elem,time,l_swing_elem)
    yaxis([0.08, 0.09]);
    legend('Stance phase element','Swing phase element','Location','north')
    ylabel('Length in m'); xlabel('time (s)');
    title('Length of hydraulic elements');
    
    figure();
    subplot(2,4,1);
    plot(time,stance_unit(:,1),time,swing_unit(:,1))
    title('Spring force')
    ylabel('N')
    subplot(2,4,2);
    plot(time,stance_unit(:,2),time,swing_unit(:,2))
    title('Damping force')
    ylabel('N')
    subplot(2,4,5);
    plot(time,stance_unit(:,3),time,swing_unit(:,3))
    title('$x$');
    ylabel('m')
    xlabel('time in s');
    subplot(2,4,6);
    plot(time,stance_unit(:,4),time,swing_unit(:,4))
    title('$\dot{x}$');
    ylabel('m/s')
    xlabel('time in s');
%     legend('Stance phase element','Swing phase element');
    
    subplot(2,4,[3 4 7 8]);
    plot(time,sum(stance_unit(:,1:2),2),time,sum(swing_unit(:,1:2),2))
    title('Total element force');
    ylabel('N')
    xlabel('time in s');
    legend('Stance phase element','Swing phase element');
    
    if contains(models{i},'stance')
        figure();
        [j9_ll, j9_ul, j10_ll, j10_ul, j12_ll, j12_ul, j13_ll, j13_ul, j15_ll, j15_ul] = getBounds3R60Hinges(models{i});
        plot(time,hingeangles)
        title('3R60 Hinge joint angles with their limits');
        hold on;
        colororder = get(gca,'colororder');
        plot([time(1) time(end)],[j9_ll,j9_ul;j9_ll j9_ul],'--','Color',colororder(1,:))
        plot([time(1) time(end)],[j10_ll,j10_ul;j10_ll j10_ul],'--','Color',colororder(2,:))
        plot([time(1) time(end)],[j12_ll,j12_ul;j12_ll j12_ul],'--','Color',colororder(3,:))
        plot([time(1) time(end)],[j13_ll,j13_ul;j13_ll j13_ul],'--','Color',colororder(4,:))
        plot([time(1) time(end)],[j15_ll,j15_ul;j15_ll j15_ul],'--','Color',colororder(5,:))
        legend('Joint 9', 'Joint 10', 'Joint 12', 'Joint 13', 'Joint 15');
    end
    
    if contains(models{i},'friction')
       figure();
       set(gcf,'Position',[30,80,630,300]);
       plot(theta.Time,theta.Data,'-o');
       hold on;
       plot(theta.Time,[187.5, 188.0, 185.0 180.5, 175.5],':*');
       plot(theta.Time,[ 187.5294, 187.9851, 185.3274, 181.1133, 176.2327 ],'-.>');
       title('Angle $\theta$'); 
       ylabel('deg');
       xlabel('time (s)');
       legend('Simulink model','Vandaele experiment','Vandaele model','Location','southwest');
    end
    %%
end