function [ylabelPosXMin] = alignYlabel(axesHandles)
% Input: 
%   axesHandles: All the most left axes of the figure
% Output:
%   ylabelPosXMin: x position of the y label used as reference for other
%   labels such as (a), (b), etc.
% Function aligns the positioning of the y labels. In case of one ylabel
% and multiple (vertical) axes, the label is aligned in the middel. In case
% of multiple ylabels the horizontal positioning is aligned and the the
% labels are center aligned in the vertical direction of their respective
% axes.



%% Find positioning of ylabel
ylabelPosXMin = 99;
axPos = nan(length(axesHandles),4);
allAxesLabeled = true;

for ii = 1:length(axesHandles)
    % Find vertical positioning of ylabel
    set(axesHandles(ii),'Units','points');
    axPos(ii,:) = get(axesHandles(ii),'Position');
    set(axesHandles(ii),'Units','Normalized')
    
    % Find horizontal positioning of ylabel
    set(get(axesHandles(ii),'YLabel'),'Units','Normalized');
    ylabelPos = get(get(axesHandles(ii),'YLabel'),'Position');
    if ylabelPos(1) < ylabelPosXMin
        ylabelPosXMin = ylabelPos(1);
    end
    allAxesLabeled = allAxesLabeled & (~isempty(get(get(axesHandles(ii),'YLabel'),'String')));
end

% Find middle position figure
topIdx = find(axPos(:,2) == max(axPos(:,2)));
bottomIdx = find(axPos(:,2) == min(axPos(:,2)));
ylabelPosYNorm = -(axPos(topIdx,2) - (axPos(bottomIdx,2)+axPos(bottomIdx,4)))/(2*axPos(topIdx,4));

%% Set positioning
for ii = 1:length(axesHandles)
    if allAxesLabeled
        ylabelYSet = 0.5;
    else
        ylabelYSet = ylabelPosYNorm;
    end
    ylabelPos = get(get(axesHandles(ii),'YLabel'),'Position');
    set(get(axesHandles(ii),'YLabel'),'Position',[ylabelPosXMin, ylabelYSet, ylabelPos(3)]);
end
