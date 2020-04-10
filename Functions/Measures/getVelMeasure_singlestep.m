function step_measure = getVelMeasure_singlestep(est_velocity,diff_step_time,min_velocity,max_velocity)
% vel_violation = nan;


if est_velocity < min_velocity
    vel_violation = est_velocity - min_velocity;
elseif est_velocity > max_velocity
    vel_violation = est_velocity - max_velocity;
else
    vel_violation = 0;
end

norm_vel = 1-abs(vel_violation)/min_velocity;
if norm_vel < -1
    norm_vel = -1;
elseif norm_vel > 1
    norm_vel = 1;
end
    

step_measure = diff_step_time*norm_vel;