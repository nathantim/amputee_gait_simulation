function velMeasure = getVelMeasure2(HATPosVel,stepNumbers,min_velocity,max_velocity,initiation_steps)

idxfirst = round(max(find(stepNumbers(:,1)==initiation_steps,1,'first'),find(stepNumbers(:,2)==initiation_steps,1,'first'))/30);

if isempty(idxfirst)
    velMeasure = 9999999999;
    return    
else
    HATVel = sqrt( sum(mean(HATPosVel.signals.values(idxfirst:end,[4,5]),1).^2) );
end

if min_velocity == max_velocity
    velMeasure = abs(max_velocity - HATVel);
elseif HATVel < min_velocity
    velMeasure = abs(min_velocity - HATVel);
elseif HATVel > max_velocity
    velMeasure = abs(max_velocity - HATVel);
elseif HATVel == max_velocity || HATVel == min_velocity
    velMeasure = 0;
else   
    error('Something went wrong in getVelMeasure2');
   
end

