function b_isProperDistCovered = bisProperDistCovered(Tsim,stepLengths,min_velocity,max_velocity,dist_slack)
min_dist = min_velocity*Tsim;
max_dist = max_velocity*Tsim;


dist_covered = max(sum(stepLengths,1));

if (dist_covered < (1-dist_slack)*min_dist || dist_covered > (1+dist_slack)*max_dist || dist_covered < 8)
    b_isProperDistCovered = false;
else
    b_isProperDistCovered = true;
end