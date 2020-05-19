close all;
%%
models = {'friction_test','stance_flexion_test','swing_flexion_test'};
stoptime = {'0.32','2','3'};
% phases = ["swing";"stance"];


for i = 1%1:length(models)
    warning('off');
    simout = sim(models{i},'TimeOut',2*60,...
        'SaveOutput','on','StopTime',stoptime{i});
    warning('on');
    
    time = get(simout,'time');
    knee_angle = get(simout,'knee_angle');
    % ICR = get(simout,'ICR');
    % pos14_1 = get(simout,'pos14_1');
    % pos14_2 = get(simout,'pos14_2');
    l_stance_elem = get(simout,'l_stance_elem');
    l_swing_elem = get(simout,'l_swing_elem');
    stance_unit = get(simout,'stance_unit');
    swing_unit = get(simout,'swing_unit');
    theta = get(simout,'theta');
    
    figure();
    warning('off')
    sgtitle(models{i});     warning('on');
    subplot(2,1,1)
    plot(time,knee_angle);
    title('Knee angle');
    ylabel('deg');
    subplot(2,1,2);
    plot(time,l_stance_elem,time,l_swing_elem)
    legend('Stance phase element','Swing phase element')
    ylabel('Length in m'); xlabel('time in s');
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
    
    if contains(models{i},'friction')
       figure();
       plot(theta.Time,theta.Data,'o');
       title('Angle $\theta$'); 
       ylabel('deg');
       xlabel('time in s');
    end
end