function [ASIstruct, ASImean, ASIstd, leftMean, rightMean, leftStd, rightStd ] = getFilterdMean_and_ASI(leftSignal,rightSignal,initiation_steps)
if nargin < 3 || isempty(initiation_steps)
    initiation_steps = 0;
end

leftValues = leftSignal;
rightValues = rightSignal;

leftMean = mean(leftValues((1+initiation_steps):end));
leftStd =  std(leftValues((1+initiation_steps):end));



rightMean = mean(rightValues((1+initiation_steps):end));
rightStd = std(rightValues((1+initiation_steps):end));

step2cal = min(length(leftValues),length(rightValues))-initiation_steps;
ASI = getAsymmetry(leftValues(end-(step2cal-1):end), rightValues(end-(step2cal-1):end));
ASImean = mean(ASI);
ASIstd = std(ASI);

leftTxt  = [num2str(round(leftMean,2)), ' (' num2str(round(leftStd,2)) ')'];
rightTxt = [num2str(round(rightMean,2)), ' (' num2str(round(rightStd,2)) ')'];
ASItxt          = [num2str(round(ASImean,2)), ' (' num2str(round(ASIstd,2)) ')'];

ASIstruct = struct('leftMean',leftMean,'leftStd',leftStd, ...
                   'rightMean',rightMean,'rightStd',rightStd,...
                   'ASImean',ASImean,'ASIstd',ASIstd, ...
                   'leftTxt',leftTxt,'rightTxt',rightTxt,...
                   'ASItxt',ASItxt);