function [distMeasure, dist_covered] = getDistMeasure(Tsim_set,stepLengths,min_velocity,max_velocity,dist_slack)
min_dist = min_velocity*Tsim_set;
max_dist = max_velocity*Tsim_set;


dist_covered = max(sum(stepLengths,1));



% distMeasure = 0 + (dist_covered > 0)*1/dist_covered + (dist_covered > (1+dist_slack)*max_dist)*exp(dist_covered-max_dist) + ...
%     (dist_covered <= 0)*exp(abs(dist_covered-min_dist));

% if (dist_covered > (1+dist_slack)*max_dist)
%     distMeasure = 1/dist_covered + exp(dist_covered-max_dist);
if (dist_covered <= 0)
    distMeasure = exp(abs(dist_covered-min_dist));
elseif (dist_covered > 0)
    distMeasure = abs(dist_covered-max_dist)^(1.1);
    if isinf(distMeasure)
        distMeasure = 0;
    end
end

% distMeasure = abs( (dist_covered-min_dist)*(dist_covered < (1-dist_slack)*min_dist) + (dist_covered-max_dist)*(dist_covered > (1+dist_slack)*max_dist) );

