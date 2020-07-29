function [meanDataInterp,sdDataInterp] = interpData2perc(t,tp,data,stepStarts,stepEnds,b_oneGaitPhase)
if b_oneGaitPhase
    dataInterp = nan(length(tp),length(stepEnds));
    for i = 1:length(stepEnds)
        t_sec = t(stepStarts(i):stepEnds(i));
        t_perc = (t_sec-t_sec(1))./(t_sec(end)-t_sec(1))*100;
        dataInterp(:,i) = interp1(t_perc,data(stepStarts(i):stepEnds(i)),tp,'linear');
    end
    
    % figure(); plot(t_perc,data(stepStarts(i):stepEnds(i)) ); hold on; plot((0:0.5:100),dataInterp);
    
    meanDataInterp = mean(dataInterp,2);
    sdDataInterp = std(dataInterp,0,2);
else
    meanDataInterp = data;
    sdDataInterp = [];
end

% figure();
% fill([tp;flipud(tp)],[meanDataInterp-sdDataInterp;flipud(meanDataInterp+sdDataInterp)],[0.8 0.8 0.8]);
% hold on;
% plot(tp,meanDataInterp);


