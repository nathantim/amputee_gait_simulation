function plotHealthyProstheticData(healthyData,prostheticData,info,b_saveTotalFig)
showSD = false;
plotInOneFigure = true;
plotWinterData = false;
%%
set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);


saveInfo = struct;
saveInfo.b_saveFigure = 0;
b_oneGaitPhase = true;

if b_saveTotalFig
    saveInfo.type = {'eps'};%{'jpeg','eps','emf'};
end
if nargin < 4
    b_saveTotalFig = false;
end
saveInfo.info = info;


healthyGaitInfo = getPartOfGaitData(b_oneGaitPhase,healthyData.GaitPhaseData,healthyData.angularData.time,healthyData.stepTimes);
healthyGaitInfo.tp = (0:0.5:100)';
prostheticGaitInfo = getPartOfGaitData(b_oneGaitPhase,prostheticData.GaitPhaseData,prostheticData.angularData.time,prostheticData.stepTimes);
prostheticGaitInfo.tp = (0:0.5:100)';


%%
plotInfo.showSD = showSD;%true;
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-'; ':';'-.'};
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

set(0, 'DefaultAxesFontSize',20);

%% Angular data
angularDataFig = figure();
set(angularDataFig, 'Position',[10,100,1850,800]);
subplotStart = [2 5 1];
plotAngularData(healthyData.angularData,healthyData.GaitPhaseData,plotInfo,healthyGaitInfo,saveInfo,angularDataFig,subplotStart,false);
subplotStart(3) = subplotStart(3)+subplotStart(2);
plotAngularData(prostheticData.angularData,prostheticData.GaitPhaseData,plotInfo,prostheticGaitInfo,saveInfo,angularDataFig,subplotStart,true);

htxt = text(-740,32,'Healthy model','FontSize',26,'Rotation',90);
set(htxt,'Position',[-740, 32, 0]);
ptxt = text(-740,-39,'Amputee model','FontSize',26,'Rotation',90);
set(ptxt,'Position',[-740, -39, 0]);
legend('Intact leg','Prosthetic leg','FontSize', 22,'Position',[0.515 0.02 0.075 0.07]);

%% Torque data
torqueDataFig = figure();
set(torqueDataFig, 'Position',[10,100,1700,800]);
subplotStart = [2 4 1];
plotJointTorqueData(healthyData.jointTorquesData,plotInfo,healthyGaitInfo,saveInfo,torqueDataFig,subplotStart,false);
subplotStart(3) = subplotStart(3)+subplotStart(2);
plotJointTorqueData(prostheticData.jointTorquesData,plotInfo,prostheticGaitInfo,saveInfo,torqueDataFig,subplotStart,true);

htxt = text(-515,3.6,'Healthy model','FontSize',26,'Rotation',90);
% set(htxt,'Position',[-515, 3.6, 0]);
ptxt = text(-515,-0.3,'Amputee model','FontSize',26,'Rotation',90);
% set(ptxt,'Position',[-515, -0.3, 0]);
legend('Intact leg','Prosthetic leg','FontSize', 22,'Position',[0.50 0.02 0.075 0.07]);

%% GRF data
GRFDataFig = figure();
set(GRFDataFig, 'Position',[10,100,1000,800]);
subplotStart = [2 2 1];
plotGRF(healthyData.GRFData,plotInfo,healthyGaitInfo,saveInfo,GRFDataFig,subplotStart,false);
subplotStart(3) = subplotStart(3)+subplotStart(2);
plotGRF(prostheticData.GRFData,plotInfo,prostheticGaitInfo,saveInfo,GRFDataFig,subplotStart,true);

htxt = text(-165,27,'Healthy model','FontSize',26,'Rotation',90);
% set(htxt,'Position',[-165, 27, 0]);
ptxt = text(-165,1,'Amputee model','FontSize',26,'Rotation',90);
% set(ptxt,'Position',[-165, -1, 0]);

legend('Intact leg','Prosthetic leg','FontSize', 22,'Position',[0.45 0.02 0.075 0.07]);

%% Musculo data
% plotInfo.lineWidthProp = {4;4;4};
set(0, 'DefaultAxesFontSize',18);
musculoDataFig = figure();
set(musculoDataFig, 'Position',[10,100,1900,600]);
subplotStart = [2 11 1];
plotMusculoData(healthyData.musculoData,plotInfo,healthyGaitInfo,saveInfo,musculoDataFig,subplotStart,false);
subplotStart(3) = subplotStart(3)+subplotStart(2);
plotMusculoData(prostheticData.musculoData,plotInfo,prostheticGaitInfo,saveInfo,musculoDataFig,subplotStart,true);

htxt = text(-1560,1.65,'Healthy model','FontSize',25,'Rotation',90);
set(htxt,'Position',[-1560, 1.65, 0]);
ptxt = text(-1560,-0.2,'Amputee model','FontSize',25,'Rotation',90);
set(ptxt,'Position',[-1560, -0.2, 0]);
legend('Intact leg','Prosthetic leg','FontSize', 20,'Position',[0.50 0.045 0.075 0.03]);

%% Save
path = '../../Thesis Document/fig/';
if b_saveTotalFig
    for jj = 1:length(saveInfo.type)
        saveFigure(angularDataFig,'angularData',saveInfo.type{jj},saveInfo.info,false,path)            
    end
    for jj = 1:length(saveInfo.type)
        saveFigure(torqueDataFig,'torqueData',saveInfo.type{jj},saveInfo.info,false,path)
    end
    for jj = 1:length(saveInfo.type)
        saveFigure(musculoDataFig,'musculoData',saveInfo.type{jj},saveInfo.info,false,path)
    end
    for jj = 1:length(saveInfo.type)
        saveFigure(GRFDataFig,'GRFData',saveInfo.type{jj},saveInfo.info,false,path)
    end
end

startup;
close(angularDataFig);
close(torqueDataFig);
close(GRFDataFig);
close(musculoDataFig);

