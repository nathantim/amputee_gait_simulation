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

%% Leg state
legStateFig = figure();
set(legStateFig, 'Position',[10,100,950,750]);
subplotStart = [2 1 1];
plotLegState(healthyData.GaitPhaseData,plotInfo,healthyGaitInfo,saveInfo,legStateFig,subplotStart,false)
pos=get(gca,'position');  % retrieve the current values
pos(1)= 2* pos(1);        % try reducing width 10%
pos(4)= 0.8* pos(4);        % try reducing width 10%
pos(3)= 0.8* pos(3);        % try reducing width 10%
set(gca,'position',pos);

subplotStart(3) = subplotStart(3)+subplotStart(2);
plotLegState(prostheticData.GaitPhaseData,plotInfo,prostheticGaitInfo,saveInfo,legStateFig,subplotStart,true)

pos=get(gca,'position');  % retrieve the current values
pos(1)= 2* pos(1);        % try reducing width 10%
pos(2)= 1.3* pos(2);        % try reducing width 10%
pos(4)= 0.8* pos(4);        % try reducing width 10%
pos(3)= 0.8* pos(3);        % try reducing width 10%
set(gca,'position',pos);

htxt = text(gca,-28,6,'Healthy model','FontSize',26,'Rotation',90);
set(htxt,'Position',[-28, 6, 0]);
ptxt = text(gca,-28,-0.3,'Amputee model','FontSize',26,'Rotation',90);
set(ptxt,'Position',[-28, -0.3, 0]);
atxt = text(gca,-38,8,'(a)','FontSize',20);
set(atxt,'Position',[-38, 8, 0]);
btxt = text(gca,-38,2,'(b)','FontSize',20);
set(btxt,'Position',[-38, 2, 0]);
legend('Intact leg','Prosthetic leg','FontSize', 21,'Location','southeast'); %'Position',[0.515 0.03 0.075 0.07]

%% Angular data
angularDataFig = figure();
set(angularDataFig, 'Position',[10,100,1700,800]);
subplotStart = [2 4 1];
plotAngularData(healthyData.angularData,healthyData.GaitPhaseData,plotInfo,healthyGaitInfo,saveInfo,angularDataFig,subplotStart,false,false);
subplotStart(3) = subplotStart(3)+subplotStart(2);
plotAngularData(prostheticData.angularData,prostheticData.GaitPhaseData,plotInfo,prostheticGaitInfo,saveInfo,angularDataFig,subplotStart,true,false);

htxt = text(gca,-500,32,'Healthy model','FontSize',26,'Rotation',90);
set(htxt,'Position',[-500, 32, 0]);
ptxt = text(gca,-500,-40,'Amputee model','FontSize',26,'Rotation',90);
set(ptxt,'Position',[-500, -40, 0]);
atxt = text(gca,-535,55,'(a)','FontSize',20);
set(atxt,'Position',[-535, 55, 0]);
btxt = text(gca,-535,-15,'(b)','FontSize',20);
set(btxt,'Position',[-535, -15, 0]);
legend('Intact leg','Prosthetic leg','FontSize', 22,'Position',[0.50 0.02 0.075 0.07]);

%% Torque data
torqueDataFig = figure();
set(torqueDataFig, 'Position',[10,100,1700,800]);
subplotStart = [2 4 1];
plotJointTorqueData(healthyData.jointTorquesData,plotInfo,healthyGaitInfo,saveInfo,torqueDataFig,subplotStart,false);
subplotStart(3) = subplotStart(3)+subplotStart(2);
plotJointTorqueData(prostheticData.jointTorquesData,plotInfo,prostheticGaitInfo,saveInfo,torqueDataFig,subplotStart,true);

htxt = text(gca,-515,2.9,'Healthy model','FontSize',26,'Rotation',90);
set(htxt,'Position',[-515, 2.9, 0]);
ptxt = text(gca,-515,-0.1,'Amputee model','FontSize',26,'Rotation',90);
set(ptxt,'Position',[-515, -0.1, 0]);
atxt = text(gca,-550,3.8,'(a)','FontSize',20);
set(atxt,'Position',[-550, 3.8, 0]);
btxt = text(gca,-550,1,'(b)','FontSize',20);
set(btxt,'Position',[-550, 1.0, 0]);
legend('Intact leg','Prosthetic leg','FontSize', 22,'Position',[0.50 0.02 0.075 0.07]);

%% Power data
powerDataFig = figure();
set(powerDataFig, 'Position',[10,100,1700,800]);
subplotStart = [2 4 1];
plotJointPowerData(healthyData.angularData,healthyData.jointTorquesData,plotInfo,healthyGaitInfo,saveInfo,powerDataFig,subplotStart,false);
subplotStart(3) = subplotStart(3)+subplotStart(2);
plotJointPowerData(prostheticData.angularData,prostheticData.jointTorquesData,plotInfo,prostheticGaitInfo,saveInfo,powerDataFig,subplotStart,true);

htxt = text(gca,-515,6.1,'Healthy model','FontSize',26,'Rotation',90);
set(htxt,'Position',[-490, 6.1, 0]);
ptxt = text(gca,-515,-3,'Amputee model','FontSize',26,'Rotation',90);
set(ptxt,'Position',[-490, -2.3, 0]);
atxt = text(gca,-525,8.8,'(a)','FontSize',20);
set(atxt,'Position',[-525, 8.8, 0]);
btxt = text(gca,-525,0.3,'(b)','FontSize',20);
set(btxt,'Position',[-525, 0.3, 0]);
legend('Intact leg','Prosthetic leg','FontSize', 22,'Position',[0.50 0.02 0.075 0.07]);

%% GRF data
GRFDataFig = figure();
set(GRFDataFig, 'Position',[10,100,1500,800]);
subplotStart = [2 2 1];
plotGRF(healthyData.GRFData,plotInfo,healthyGaitInfo,saveInfo,GRFDataFig,subplotStart,false);
subplotStart(3) = subplotStart(3)+subplotStart(2);
plotGRF(prostheticData.GRFData,plotInfo,prostheticGaitInfo,saveInfo,GRFDataFig,subplotStart,true);

htxt = text(gca,-155,27,'Healthy model','FontSize',26,'Rotation',90);
set(htxt,'Position',[-155, 27, 0]);
ptxt = text(gca,-155,1,'Amputee model','FontSize',26,'Rotation',90);
set(ptxt,'Position',[-155, -1, 0]);
atxt = text(gca,-170,36,'(a)','FontSize',20);
set(atxt,'Position',[-170, 36, 0]);
btxt = text(gca,-170,2,'(b)','FontSize',20);
set(btxt,'Position',[-170, 8, 0]);

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

htxt = text(gca,-1560,1.65,'Healthy model','FontSize',25,'Rotation',90);
set(htxt,'Position',[-1560, 1.65, 0]);
ptxt = text(gca,-1560,-0.2,'Amputee model','FontSize',25,'Rotation',90);
set(ptxt,'Position',[-1560, -0.2, 0]);
atxt = text(gca,-1650,2.4,'(a)','FontSize',20);
set(atxt,'Position',[-1650, 2.4, 0]);
btxt = text(gca,-1650,0.6,'(b)','FontSize',20);
set(btxt,'Position',[-1650, 0.6, 0]);

legend('Intact leg','Prosthetic leg','FontSize', 20,'Position',[0.50 0.045 0.075 0.03]);

%% Save
path = '../../Thesis Document/fig/'; 
if b_saveTotalFig 
    for jj = 1:length(saveInfo.type)
        saveFigure(legStateFig,'legState',saveInfo.type{jj},saveInfo.info,false,path)            
    end
    for jj = 1:length(saveInfo.type)
        saveFigure(angularDataFig,'angularData',saveInfo.type{jj},saveInfo.info,false,path)            
    end
    for jj = 1:length(saveInfo.type)
        saveFigure(torqueDataFig,'torqueData',saveInfo.type{jj},saveInfo.info,false,path)
    end
    for jj = 1:length(saveInfo.type)
        saveFigure(powerDataFig,'powerData',saveInfo.type{jj},saveInfo.info,false,path)
    end
    for jj = 1:length(saveInfo.type)
        saveFigure(musculoDataFig,'musculoData',saveInfo.type{jj},saveInfo.info,false,path)
    end
    for jj = 1:length(saveInfo.type)
        saveFigure(GRFDataFig,'GRFData',saveInfo.type{jj},saveInfo.info,false,path)
    end
end

startup;
close(legStateFig);
close(angularDataFig);
close(torqueDataFig);
close(powerDataFig);
close(GRFDataFig);
close(musculoDataFig);

