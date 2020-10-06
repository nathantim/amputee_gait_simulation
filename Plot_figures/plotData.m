function plotData(angularData,musculoData,GRFData,jointTorquesData,GaitPhaseData,stepTimes,CMGData,info,timeInterval,b_saveFigure,plotWinterData,showSD,b_oneGaitPhase)
%%
set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);


saveInfo = struct;
if  nargin < 9
    timeInterval = [];
end
if  nargin < 10
    saveInfo.b_saveFigure = 1;
else
    saveInfo.b_saveFigure = b_saveFigure;
end
if  nargin < 13
    b_oneGaitPhase = true;
end
if saveInfo.b_saveFigure
    saveInfo.type = {'jpeg','eps','emf'};
end
if nargin < 12
   showSD = false; 
end
if nargin < 11
    plotWinterData = false;
end
saveInfo.info = info;
t = angularData.time;

GaitInfo = getPartOfGaitData(b_oneGaitPhase,GaitPhaseData,t,stepTimes,timeInterval);

% if ~b_oneGaitPhase
%     getSteps(t,GaitPhaseData,stepTimes);
% end
%%
plotInfo.showSD = showSD;%true;
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-'; '--';':'};
plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E'};
plotInfo.lineVec = plotInfo.lineVec(1:3,:);
plotInfo.colorProp = plotInfo.colorProp(1:3,:);
plotInfo.lineWidthProp = {3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];
plotInfo.plotWinterData = plotWinterData;

plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor','LineStyle'};
faceAlpha = {0.2;0.2;0.2};
plotInfo.fillVal = {'#0072BD';	'#D95319';'#7E2F8E'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.edgeVec = {':';':';':'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.fillProp_entries = [plotInfo.fillVal,faceAlpha,plotInfo.fillVal,plotInfo.edgeVec];

%%
% plotAngularData(angularData,GaitPhaseData,plotInfo,GaitInfo,saveInfo,[]);
% plotJointTorqueData(jointTorquesData,plotInfo,GaitInfo,saveInfo,[]);
% plotJointPowerData(angularData,jointTorquesData,plotInfo,GaitInfo,saveInfo,[]);
% plotMusculoData(musculoData,plotInfo,GaitInfo,saveInfo,[],[]);
% plotGRF(GRFData,plotInfo,GaitInfo,saveInfo,[]);
% set(0, 'DefaultAxesFontSize',18);
plotCMGData(CMGData,plotInfo,GaitInfo,saveInfo,[])



%
set(0, 'DefaultAxesFontSize',15);
set(0, 'DefaultAxesTitleFontSizeMultiplier',1);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1);

