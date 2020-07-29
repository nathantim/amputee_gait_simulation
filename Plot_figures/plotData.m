function plotData(angularData,musculoData,GRFData,GaitPhaseData,stepTimes,info,b_saveFigure,b_oneGaitPhase)
%%
set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);


saveInfo = struct;
if  nargin < 7
    saveInfo.b_saveFigure = 1;
else
    saveInfo.b_saveFigure = b_saveFigure;
end
if  nargin < 8
    b_oneGaitPhase = true;
end
if saveInfo.b_saveFigure
    saveInfo.type = {'jpeg','eps','emf'};
end
saveInfo.info = info;
t = angularData.time;

GaitInfo = getPartOfGaitData(b_oneGaitPhase,GaitPhaseData,t,stepTimes);
GaitInfo.tp = (0:0.5:100)';
% if ~b_oneGaitPhase
%     getSteps(t,GaitPhaseData,stepTimes);
% end
%%
plotInfo.showSD = true;
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-'; '--';':'};
plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E'};
plotInfo.lineVec = plotInfo.lineVec(1:3,:);
plotInfo.colorProp = plotInfo.colorProp(1:3,:);
plotInfo.lineWidthProp = {3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];

plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor','LineStyle'};
faceAlpha = {0.2;0.2;0.2};
plotInfo.fillVal = {'#0072BD';	'#D95319';'#7E2F8E'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.edgeVec = {':';':';':'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.fillProp_entries = [plotInfo.fillVal,faceAlpha,plotInfo.fillVal,plotInfo.edgeVec];

%%
plotAngularData(angularData,GaitPhaseData,plotInfo,GaitInfo,saveInfo);
plotMusculoData(musculoData,plotInfo,GaitInfo,saveInfo);
plotGRF(GRFData,plotInfo,GaitInfo,saveInfo);

%
set(0, 'DefaultAxesTitleFontSizeMultiplier',1);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1);

