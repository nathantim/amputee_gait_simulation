function [velMeasure, avgHATVel,ASIVel] = getVelMeasure2(HATPosVel,stepNumbers,min_velocity,max_velocity,initiation_steps)
velMeasure = nan;
avgHATVel = nan;
ASIVel = 0;
idxfirst = (max(find(stepNumbers(:,1)==initiation_steps,1,'first'),find(stepNumbers(:,2)==initiation_steps,1,'first')));

if isempty(idxfirst)
    velMeasure = 9999999999;
    avgHATVel = nan;
    return    
else
    avgHATVel = mean( sqrt( sum(HATPosVel.signals.values(idxfirst:end,[4,5]).^2,2)) );
end

if min_velocity == max_velocity
    velMeasure = abs(max_velocity - avgHATVel);
elseif avgHATVel < min_velocity
    velMeasure = abs(min_velocity - avgHATVel);
elseif avgHATVel > max_velocity
    velMeasure = abs(max_velocity - avgHATVel);
elseif avgHATVel == max_velocity || avgHATVel == min_velocity
    velMeasure = 0;
else   
    error('Something went wrong in getVelMeasure2');
   
end

