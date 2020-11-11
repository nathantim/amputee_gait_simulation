function [meanDataInterp,sdDataInterp] = interpData2perc(t,tp,data,stepStarts,stepEnds,b_oneGaitPhase,interpMethod)
if nargin < 7 || isempty(interpMethod)
    interpMethod = 'linear';
end

if b_oneGaitPhase
    dataInterp = nan(length(tp),length(stepEnds));
    for ii = 1:length(stepEnds)
        t_sec = t(stepStarts(ii):stepEnds(ii));
        t_perc = (t_sec-t_sec(1))./(t_sec(end)-t_sec(1))*100;
        dataInterp(:,ii) = interp1(t_perc,data(stepStarts(ii):stepEnds(ii)),tp,interpMethod); % previous
    end
    
    % figure(); plot(t_perc,data(stepStarts(i):stepEnds(i)) ); hold on; plot((0:0.5:100),dataInterp);
    
    meanDataInterp = mean(dataInterp,2);
    sdDataInterp = std(dataInterp,0,2);

else
    meanDataInterp = data(stepStarts:stepEnds,:);
    sdDataInterp = zeros(size(meanDataInterp));
    
end

% figure();
% fill([tp;flipud(tp)],[meanDataInterp-sdDataInterp;flipud(meanDataInterp+sdDataInterp)],[0.8 0.8 0.8]);
% hold on;
% plot(tp,meanDataInterp);


