function [totalRange, stanceRange, swingRange] = getMinMaxStanceSwing(gaitstates,tp,data)
% t in %
endStanceIdx = find(tp == gaitstates.Stance);

stanceRange = [min(data(1:endStanceIdx)), max(data(1:endStanceIdx))];
swingRange  = [min(data(endStanceIdx+1:end)), max(data(endStanceIdx+1:end))];
totalRange = {  char(strcat('(',num2str(round(stanceRange(1),1)),','," ",num2str(round(stanceRange(2),2)),')'));...
                char(strcat('(',num2str(round(swingRange(1),1)),','," ",num2str(round(swingRange(2),2)),')'))};
% if size(stanceRange,2)>1
%     stanceRange = stanceRange';
% end
% if size(swingRange,2)>1
%     swingRange = swingRange';
% end
if size(totalRange,2)>1
    totalRange = totalRange';
end