function [meanDataInterp,sdDataInterp] = interpData2perc(t,tp,data,stepStarts,stepEnds,b_oneGaitPhase,interpMethod)
% INTERPDATA2PERC               Function that averages and interpolates the data such that there all the data can be 
%                               compared at the same percentage points. 
% INPUTS:
%   - t                         Time vector of the simulation.
%   - tp                        Required percentage vector at which the data should have an interpolation point.
%   - data                      Data that needs to be averaged and interpolated.
%   - stepStarts                Vector with index numbers at which a stride starts.
%   - stepEnds                  Vector with index numbers at which a stride ends.
%   - b_oneGaitPhase            Optional, if false, then the data will not be interpolated and averaged and just fed through 
%   - interpMethod              Optional, select which interpolation method to use, default is 'linear'.
%
% OUTPUTS:
%   - meanDataInterp            Handles of all the plots, which can be used for later changes in line style etc, or for
%                               adding a legend.
%   - sdDataInterp              Handles of all the axes, which can be used for later changes in axes size, axes title
%                               locations etc.
%%
if nargin < 7 || isempty(interpMethod)
    interpMethod = 'linear';
end

%%
if b_oneGaitPhase
    dataInterp = nan(length(tp),length(stepEnds));
    % Interpolate the data per stride
    for ii = 1:length(stepEnds)
        t_sec = t(stepStarts(ii):stepEnds(ii));
        t_perc = (t_sec-t_sec(1))./(t_sec(end)-t_sec(1))*100;
        dataInterp(:,ii) = interp1(t_perc,data(stepStarts(ii):stepEnds(ii)),tp,interpMethod); % previous
    end
       
    % Average the data
    meanDataInterp  = mean(dataInterp,2);
    sdDataInterp    = std(dataInterp,0,2);

else
    meanDataInterp  = data(stepStarts:stepEnds,:);
    sdDataInterp    = zeros(size(meanDataInterp));
    
end



