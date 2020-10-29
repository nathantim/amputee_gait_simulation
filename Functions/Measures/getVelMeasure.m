function [velMeasure, avgHATVel,ASIVel] = getVelMeasure(HATPosVel,stepNumbers,min_velocity,max_velocity,initiation_steps)
velMeasure = nan;
avgHATVel = nan;
ASIVel = 0;
idxfirstStepNum = (max(find(stepNumbers.signals.values(:,1)==initiation_steps,1,'first'),find(stepNumbers.signals.values(:,2)==initiation_steps,1,'first')));
if isempty(idxfirstStepNum)
    velMeasure = 9999999999;
    avgHATVel = nan;
    disp('Insufficient steps');
    return    
end
idxfirstHATPosVel = find(abs(HATPosVel.time-stepNumbers.time(idxfirstStepNum))==min(abs(HATPosVel.time-stepNumbers.time(idxfirstStepNum))));
if isempty(idxfirstHATPosVel)
    velMeasure = 9999999999;
    avgHATVel = nan;
    disp('Insufficient steps');
    return    
else
    avgHATVel = mean( sqrt( sum(HATPosVel.signals.values(idxfirstHATPosVel:end,[4,5]).^2,2)) );
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

