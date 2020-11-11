function [titleExtXMin] = alignTitle(axesHandles)
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
titlePosXMin = 99;
titleExtXMin = 99;
axPos = nan(length(axesHandles),4);
allAxesLabeled = true;

for ii = 1:length(axesHandles)
    % Find vertical positioning of ylabel
    set(axesHandles(ii),'Units','points');
    axPos(ii,:) = get(axesHandles(ii),'Position');
    set(axesHandles(ii),'Units','Normalized')
    
    
    % Find horizontal positioning of ylabel
    if (~isempty(get(get(axesHandles(ii),'Title'),'String')))
        set(get(axesHandles(ii),'Title'),'Units','Normalized');
        set(get(axesHandles(ii),'Title'),'HorizontalAlignment','center')
        set(get(axesHandles(ii),'Title'),'VerticalAlignment','bottom')
        titlePos = get(get(axesHandles(ii),'Title'),'Position');
        titleExt = get(get(axesHandles(ii),'Title'),'Extent');
        if titleExt(2) < titleExtXMin
            titlePosYMin = titlePos(2);
            titleExtYMin = titleExt(2);
        end
        allAxesLabeled = true;
    else
        allAxesLabeled = false;
    end
    
end

% Find middle position figure
rightIdx = find(axPos(:,1) == max(axPos(:,1)));
leftIdx = find(axPos(:,1) == min(axPos(:,1)));
titlePosXNorm = 1+((axPos(rightIdx,1) - (axPos(leftIdx,1)+axPos(leftIdx,3))))/(2*axPos(leftIdx,3));

%% Set positioning
for ii = 1:1%length(axesHandles)
    if allAxesLabeled
        titleXSet = 0.5;
    else
        titleXSet = titlePosXNorm;
    end
    titlePos = get(get(axesHandles(ii),'Title'),'Position');
    set(get(axesHandles(ii),'Title'),'Position',[titleXSet, titlePosYMin, titlePos(3)]);
end
