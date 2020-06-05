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

GaitInfo = getPartOfGaitData(b_oneGaitPhase,GaitPhaseData,t);

%%
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-'; '--';':'};
plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E'};
plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor'};
plotInfo.fillVal = {[0.8 0.8 0.8],0.9,'none'};
plotInfo.lineVec = plotInfo.lineVec(1:3,:);
plotInfo.colorProp = plotInfo.colorProp(1:3,:);
plotInfo.lineWidthProp = {3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];

%%
plotAngularData(angularData,GaitPhaseData,plotInfo,GaitInfo,saveInfo);
plotMusculoData(musculoData,plotInfo,GaitInfo,saveInfo);
plotGRF(GRFData,plotInfo,GaitInfo,saveInfo);

%
set(0, 'DefaultAxesTitleFontSizeMultiplier',1);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1);

