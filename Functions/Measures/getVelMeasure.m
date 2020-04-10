function velMeasure = getVelMeasure(stepVelocity,stepTimes,min_velocity,max_velocity,initiation_steps)

if ( min(size(stepVelocity)) == 0 || min(size(stepTimes)) == 0 || max(isnan(stepVelocity)) || max(isnan(stepTimes)))
    velMeasure = 99999999;
elseif min(size(stepVelocity(stepVelocity~=0))) == 0 || min(size(stepTimes(stepTimes~=0))) == 0
    velMeasure = 99999999;
elseif min((stepVelocity(stepVelocity~=0))) < 0
    velMeasure = 99999999*exp(-min((stepVelocity(stepVelocity~=0))));
else
    stepVelocity    = stepVelocity(stepVelocity~=0);
    stepTimes      = stepTimes(stepTimes~=0);
    
    stepVelocity    = stepVelocity(min( min(1,1+abs(length(stepVelocity)-5)) ,initiation_steps):end);
    stepTimes      = stepTimes(min( min(1,1+abs(length(stepVelocity)-5)) ,initiation_steps):end);
    
    if length(stepVelocity)~= length(stepTimes)
        disp(stepVelocity); disp(stepTimes);
       error('No equal vector lengths, stepVelocity length: %d, stepTimes length: %d',length(stepVelocity),length(stepTimes)) 
    end
    
    step_measure    = nan(length(stepVelocity),1);

    for i=1:length(stepVelocity)
        step_measure(i) = getVelMeasure_singlestep(stepVelocity(i),stepTimes(i),min_velocity,max_velocity);
    end
    
    velMeasure = round(1 - sum(step_measure)/sum(stepTimes),3);
    if velMeasure < 0
        disp([step_measure,stepTimes]);
        error('Something went wrong: velMeasure < 0, avg vel: %2.2f, avg step time: %2.2f, step_measure: %3.3f, stepTimes: %3.3f',mean(stepVelocity), ...
            mean(stepTimes),sum(step_measure),sum(stepTimes));
        
    end
   
end

