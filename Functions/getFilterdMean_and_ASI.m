function [meanSignal,ASI] = getFilterdMean_and_ASI(leftSignal,rightSignal,initiation_steps)

noZeroLeftSignal = leftSignal(leftSignal~=0);
meanLeftSignal = mean(noZeroLeftSignal(initiation_steps:end));

noZeroRightSignal = rightSignal(rightSignal~=0);
meanRightSignal = mean(noZeroRightSignal(initiation_steps:end));

meanSignal = mean([meanLeftSignal,meanRightSignal]);
ASI = getAsymmetry(meanLeftSignal, meanRightSignal);