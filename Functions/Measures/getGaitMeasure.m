function getGaitMeasure(stepLengths,stepTimes,stepVelocities)
OptimParams;
time = stepTimes.time;
stepTimes = stepTimes.signals.values;

% meanVel = min( mean(stepVelocities(stepVelocities(:,1)~=0,1),1), mean(stepVelocities(stepVelocities(:,2)~=0,2),1) );

distMeasure = getDistMeasure(time(end),stepLengths,min_velocity,max_velocity);

LvelMeasure = getVelMeasure(stepVelocities(:,1),stepTimes(:,1),min_velocity,max_velocity,initiation_steps);
RvelMeasure = getVelMeasure(stepVelocities(:,2),stepTimes(:,2),min_velocity,max_velocity,initiation_steps);
velMeasure = LvelMeasure + RvelMeasure;