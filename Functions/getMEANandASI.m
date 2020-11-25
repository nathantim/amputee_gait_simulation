function [ASIstruct, ASImean, ASIstd, leftMean, rightMean, leftStd, rightStd ] = getMEANandASI(leftSignal,rightSignal,initiation_steps)
% GETMEANANDASI                     Function that plots the data of healthy and prosthetic simulation together, with optional 
%                                   amputee with CMG simulation
% INPUTS:
%   - realHealthyData               Structure with the data from Fukuchi.
%   - healthyData                   Structure with the data from healthy gait simulation.
%   - amputeeData                   Structure with the data from amputee gait simulaion.
%   - amputeeCMGNotActiveData       Optional, structure with the data from amputee gait with inactive CMG simulation.
%   - amputeeCMGActiveData          Optional, Structure with the data from amputee gait with active CMG simulation.
%   - info                          Optional, info which can be added to the saved file name of the figure 
%   - b_saveTotalFig                Optional, select whether to save the figure or not, default is false
%
% OUTPUTS:
%   - 
%%
if nargin < 3 || isempty(initiation_steps)
    initiation_steps = 0;
end

leftValues = reshape(leftSignal,1,length(leftSignal));
rightValues = reshape(rightSignal,1,length(rightSignal));

step2cal    = min(length(leftValues),length(rightValues))-initiation_steps;

leftMean    = mean(leftValues((1+initiation_steps):end));
leftStd     =  std(leftValues((1+initiation_steps):end));

rightMean   = mean(rightValues((1+initiation_steps):end));
rightStd    = std(rightValues((1+initiation_steps):end));

totalMean   = mean([leftValues((1+initiation_steps):end), rightValues((1+initiation_steps):end)]);
totalStd    = std([leftValues((1+initiation_steps):end), rightValues((1+initiation_steps):end)]);


ASI         = getAsymmetry(leftValues(end-(step2cal-1):end), rightValues(end-(step2cal-1):end));
ASImean     = mean(ASI);
ASIstd      = std(ASI);

numSig      = 3;
leftTxt     = [num2str(round(leftMean,numSig, 'decimals')), ' (' num2str(round(leftStd,numSig, 'decimals')) ')'];
rightTxt    = [num2str(round(rightMean,numSig, 'decimals')), ' (' num2str(round(rightStd,numSig, 'decimals')) ')'];
totalTxt    = [num2str(round(totalMean,numSig, 'decimals')), ' (' num2str(round(totalStd,numSig, 'decimals')) ')'];
ASItxt      = [num2str(round(ASImean,numSig, 'decimals')), ' (' num2str(round(ASIstd,numSig, 'decimals')) ')'];

ASIstruct = struct('leftMean',leftMean,'leftStd',leftStd, ...
                   'rightMean',rightMean,'rightStd',rightStd,...
                   'totalMean',totalMean,'totalStd', totalStd,...
                   'ASImean',ASImean,'ASIstd',ASIstd, ...
                   'leftTxt',leftTxt,'rightTxt',rightTxt,...
                   'ASItxt',ASItxt, 'totalTxt',totalTxt);