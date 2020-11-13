function plotData(angularData,musculoData,GRFData,jointTorquesData,GaitPhaseData,stepTimes,CMGData,info,timeInterval,b_saveFigure,plotFukuchiData,showSD,b_oneGaitPhase)
%%
set(0, 'DefaultAxesFontSize',16);
set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);
set(0, 'DefaultFigureHitTest','on');
set(0, 'DefaultAxesHitTest','on','DefaultAxesPickableParts','all');
set(0, 'DefaultLineHitTest','on','DefaultLinePickableParts','all');
set(0, 'DefaultPatchHitTest','on','DefaultPatchPickableParts','all');
set(0, 'DefaultStairHitTest','on','DefaultStairPickableParts','all');
set(0, 'DefaultLegendHitTest','on','DefaultLegendPickableParts','all');


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
    plotFukuchiData = false;
end
saveInfo.info = info;
t = angularData.time;

GaitInfo = getPartOfGaitData(t,GaitPhaseData,stepTimes,b_oneGaitPhase,timeInterval);

axesState = [];
axesAngle = [];
axesTorque = [];
axesPower = [];
axesMusc = [];
axesGRF = [];

%%
plotInfo.showSD = showSD;%true;
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-'; '--';':'};
plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E'};
plotInfo.lineVec = plotInfo.lineVec(1:3,:);
plotInfo.colorProp = plotInfo.colorProp(1:3,:);
plotInfo.lineWidthProp = {3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];
plotInfo.plotWinterData = false;
plotInfo.plotFukuchiData = plotFukuchiData;

plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor','LineStyle'};
faceAlpha = {0.2;0.2;0.2};
plotInfo.fillVal = {'#0072BD';	'#D95319';'#7E2F8E'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.edgeVec = {':';':';':'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.fillProp_entries = [plotInfo.fillVal,faceAlpha,plotInfo.fillVal,plotInfo.edgeVec];
plotInfo.showTables = true;

%%
if ~isempty(GRFData)
    GRFData.signals.values = GRFData.signals.values./getBodyMass(saveInfo.info);
end
if ~isempty(jointTorquesData)
    jointTorquesData.signals.values = jointTorquesData.signals.values./getBodyMass(saveInfo.info);
end

%%'
plotLegState(GaitPhaseData,plotInfo,GaitInfo,saveInfo);
[~,axesAngle] = plotAngularData(angularData,plotInfo,GaitInfo,saveInfo,[]);
[~,axesTorque] = plotJointTorqueData(jointTorquesData,plotInfo,GaitInfo,saveInfo,[]);
plotJointPowerData(angularData,jointTorquesData,plotInfo,GaitInfo,saveInfo,[]);
plotMusculoData(musculoData,plotInfo,GaitInfo,saveInfo);
[~,axesGRF] = plotGRFData(GRFData,plotInfo,GaitInfo,saveInfo,[]);

if ~isempty(CMGData)
    plotCMGData(CMGData,plotInfo,GaitInfo,saveInfo,[]);
end
try
    if plotInfo.plotFukuchiData && b_oneGaitPhase
        disp('Fukuchi Data');
        FukuchiData = load('../Plot_figures/Data/FukuchiData.mat','gaitData');
        fieldNames = fieldnames(FukuchiData.gaitData);
        
        if contains(saveInfo.info,'0.5ms')
            FukuchiData2Plot = FukuchiData.gaitData.(fieldNames{contains(fieldNames,'0_5')});
        elseif contains(saveInfo.info,'0.9ms')
            FukuchiData2Plot = FukuchiData.gaitData.(fieldNames{contains(fieldNames,'0_9')});
        elseif contains(saveInfo.info,'1.2ms')
            FukuchiData2Plot = FukuchiData.gaitData.(fieldNames{contains(fieldNames,'1_2')});
        else
            warning('Unknown velocity')
        end
        plotInfoTemp = plotInfo;
        plotInfoTemp.showTables = false;
        plotInfoTemp.plotProp_entries = plotInfoTemp.plotProp_entries(end,:);
        GaitInfoFukuchi = getPartOfGaitData(FukuchiData2Plot.angularData.time,[],[],saveInfo,false);
        if ~isempty(axesAngle)
            [plotAngleFukuchi,~] = plotAngularData(FukuchiData2Plot.angularData,plotInfoTemp,GaitInfoFukuchi,saveInfo,[],axesAngle,[1 4 1],'right');
            set(plotAngleFukuchi(2,1),'DisplayName','Fukuchi');
        end
        if ~isempty(axesTorque)
            [plotTorqueFukuchi,~] = plotJointTorqueData(FukuchiData2Plot.jointTorquesData,plotInfoTemp,GaitInfoFukuchi,saveInfo,[],axesTorque,[1 4 1],'right');
            set(plotTorqueFukuchi(2,1),'DisplayName','Fukuchi');
        end
        if ~isempty(axesGRF)
            [plotGRFFukuchi,~] = plotGRFData(FukuchiData2Plot.GRFData,plotInfoTemp,GaitInfoFukuchi,saveInfo,[],axesGRF,[1 3 1],'right');
            set(plotGRFFukuchi(2,1),'DisplayName','Fukuchi');
        end
        
    end
catch ME
    warning(ME.message);
    
end


%
set(0, 'DefaultAxesFontSize',15);
set(0, 'DefaultAxesTitleFontSizeMultiplier',1);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1);

