function plotTripData(no_obstacleData,notrippreventData,trippreventData,info,b_saveFigure)
set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);


saveInfo = struct;
if  nargin < 5
    saveInfo.b_saveFigure = 0;
else
    saveInfo.b_saveFigure = b_saveFigure;
end

if saveInfo.b_saveFigure
    saveInfo.type = {'jpeg','eps','emf'};
end

saveInfo.info = info;


tripidx = find(sum(trippreventData.ObstacleForce.signals.values(:,1:end-1),2)~=0,1,'first');
timeInterval = [no_obstacleData.angularData.time(tripidx-10), no_obstacleData.angularData.time(tripidx)+3];

no_obstacleDataGaitInfo = getPartOfGaitData(false,no_obstacleData.GaitPhaseData,no_obstacleData.angularData.time,no_obstacleData.stepTimes,timeInterval);
trippreventDataGaitInfo = getPartOfGaitData(false,trippreventData.GaitPhaseData,trippreventData.angularData.time,trippreventData.stepTimes,timeInterval);
notrippreventDataGaitInfo = getPartOfGaitData(false,notrippreventData.GaitPhaseData,notrippreventData.angularData.time,notrippreventData.stepTimes,timeInterval);


%%
plotInfo.showSD = false;%true;
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-'; '--';':';'-.';':'; '-.'};
plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E';'#77AC30';'#4DBEEE';'#A2142F'};
plotInfo.lineVec = plotInfo.lineVec(1:6,:);
plotInfo.colorProp = plotInfo.colorProp(1:6,:);
plotInfo.lineWidthProp = {3;3;3;3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];
plotInfo.plotWinterData = false;

plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor','LineStyle'};
faceAlpha = {0.2;0.2;0.2};
plotInfo.fillVal = {'#0072BD';	'#D95319';'#7E2F8E'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.edgeVec = {':';':';':'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.fillProp_entries = [plotInfo.fillVal,faceAlpha,plotInfo.fillVal,plotInfo.edgeVec];

%%
tripFigure = figure();
set(tripFigure, 'Position',[10,100,1850,800]);
subplotStart = [2 4 1];
plotInfoTemp = plotInfo;

plotInfoTemp.plotProp_entries = plotInfo.plotProp_entries(1,:);
[plotHandlesLeft1,axesHandlesLeft] = plotAngularData(no_obstacleData.angularData,no_obstacleData.GaitPhaseData,plotInfoTemp,no_obstacleDataGaitInfo,saveInfo,tripFigure,[],subplotStart,'left',false,true);
plotInfoTemp.plotProp_entries = plotInfo.plotProp_entries(1:2,:);
subplotStart(3) = subplotStart(3) + subplotStart(2);
[plotHandlesRight1,axesHandlesRight] = plotAngularData(no_obstacleData.angularData,no_obstacleData.GaitPhaseData,plotInfoTemp,no_obstacleDataGaitInfo,saveInfo,tripFigure,[],subplotStart,'right',false,true);

subplotStart(3) = 1;
plotInfoTemp.plotProp_entries = plotInfo.plotProp_entries(3:4,:);
[plotHandlesLeft2,axesHandlesLeft] = plotAngularData(trippreventData.angularData,trippreventData.GaitPhaseData,plotInfoTemp,trippreventDataGaitInfo,saveInfo,tripFigure,axesHandlesLeft,subplotStart,'left',false,true);
subplotStart(3) = subplotStart(3) + subplotStart(2);
[plotHandlesRight2,axesHandlesRight] = plotAngularData(trippreventData.angularData,trippreventData.GaitPhaseData,plotInfoTemp,trippreventDataGaitInfo,saveInfo,tripFigure,axesHandlesRight,subplotStart,'right',false,true);

legend([plotHandlesLeft1(2,1),plotHandlesLeft2(2,1)],'Intact Leg - no obstacle','Intact Leg - trip prevent','Intact Leg - trip','Location','South');
legend([plotHandlesRight1(2,1),plotHandlesRight2(2,1)],'Prosthetic Leg - no obstacle','Prosthetic Leg - trip prevent','Prosthetic Leg - trip','Location','South');
% axesHandles = plotPhasePortrait(no_obstacleData.angularData,plotInfoTemp,no_obstacleDataGaitInfo,saveInfo,phasePortraitFigure,[],subplotStart,true,true);
% 
% plotInfoTemp.plotProp_entries = plotInfo.plotProp_entries(3:4,:);
% axesHandles = plotPhasePortrait(trippreventData.angularData,plotInfoTemp,trippreventDataGaitInfo,saveInfo,phasePortraitFigure,axesHandles,subplotStart,true,true);

% plotInfoTemp.plotProp_entries = plotInfo.plotProp_entries(5:6,:);
% axesHandles = plotPhasePortrait(notrippreventData.angularData,plotInfoTemp,notrippreventDataGaitInfo,saveInfo,phasePortraitFigure,axesHandles,subplotStart,true,true);

% legend('Intact Leg - no obstacle','Prosthetic Leg - no obstacle','Intact Leg - trip prevent','Prosthetic Leg - trip prevent','Intact Leg - trip','Prosthetic Leg - trip');