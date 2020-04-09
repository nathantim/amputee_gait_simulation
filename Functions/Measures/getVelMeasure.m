function velMeasure = getVelMeasure(est_velocity,step_times,min_velocity,max_velocity,initiation_steps)

if min(size(est_velocity)) == 0 || min(size(step_times)) == 0
    velMeasure = 999999;
elseif min(size(est_velocity(est_velocity~=0))) == 0 || min(size(step_times(step_times~=0))) == 0
    velMeasure = 999999;
else
    est_velocity    = est_velocity(est_velocity~=0);
    step_times      = step_times(step_times~=0);
    
    est_velocity    = est_velocity(min( min(1,1+abs(length(est_velocity)-5)) ,initiation_steps):end);
    step_times      = step_times(min( min(1,1+abs(length(est_velocity)-5)) ,initiation_steps):end);
    
    step_measure    = 0;
    step_time       = 0;
    
    for i=1:length(est_velocity)
        if ( i>1 && length(step_times) >= i )
            diff_step_time = step_times(i)-step_times(i-1);
        else
            diff_step_time = step_times(1);
        end
        step_measure = step_measure + getVelMeasure_singlestep(est_velocity(i),diff_step_time,min_velocity,max_velocity);
        step_time = step_time + diff_step_time;
    end
    
    velMeasure = 1 - step_measure/step_time;
end

