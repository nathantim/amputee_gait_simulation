function plotHealthyProstheticData(realHealthyData,healthyData,prostheticData,prostheticCMGData,info,b_saveTotalFig)
showSD = false;
plotInOneFigure = true;
plotWinterData = false;

%For debug purposes
b_plotLegState    = 0;
b_plotAngles      = 1;
b_plotTorques     = 1;
b_plotPowers      = 1;
b_plotGRF         = 1;
b_plotMuscle      = 0;

%%
legStateFig     = [];
angularDataFig  = [];
torqueDataFig   = [];
powerDataFig    = [];
GRFDataFig      = [];
musculoDataFig  = [];

set(0, 'DefaultAxesTitleFontSizeMultiplier',1.3);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.3);


saveInfo = struct;
saveInfo.b_saveFigure = 0;
b_oneGaitPhase = true;

if b_saveTotalFig
    saveInfo.type = {'eps'};%{'jpeg','eps','emf'};
end
if nargin < 5
    b_saveTotalFig = false;
end
saveInfo.info = info;


healthyGaitInfo = getPartOfGaitData(b_oneGaitPhase,healthyData.GaitPhaseData,healthyData.angularData.time,healthyData.stepTimes);
prostheticGaitInfo = getPartOfGaitData(b_oneGaitPhase,prostheticData.GaitPhaseData,prostheticData.angularData.time,prostheticData.stepTimes);
prostheticCMGGaitInfo = getPartOfGaitData(b_oneGaitPhase,prostheticCMGData.GaitPhaseData,prostheticCMGData.angularData.time,prostheticCMGData.stepTimes);
realHealthyDataGaitInfo = getPartOfGaitData(false,[],realHealthyData.angularData.time,[]);

%% Normalize data:
healthyData.jointTorquesData.signals.values = healthyData.jointTorquesData.signals.values./getBodyMass();
prostheticData.jointTorquesData.signals.values = prostheticData.jointTorquesData.signals.values./getBodyMass();
healthyData.GRFData.signals.values = healthyData.GRFData.signals.values./getBodyMass();
prostheticData.GRFData.signals.values = prostheticData.GRFData.signals.values./getBodyMass();

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
if b_plotLegState
    legStateFig = figure();
    set(legStateFig, 'Position',[10,100,950,750]);
    subplotStart = [3 1 1];
    fprintf('\n<strong>Healthy model:</strong> \n');
    plotLegState(healthyData.GaitPhaseData,plotInfo,healthyGaitInfo,saveInfo,legStateFig,subplotStart,false,true)
    pos=get(gca,'position');  % retrieve the current values
    pos(1)= 2* pos(1);        % try reducing width 10%
    % pos(4)= 0.8* pos(4);        % try reducing width 10%
    pos(3)= 0.8* pos(3);        % try reducing width 10%
    set(gca,'position',pos);
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    fprintf('<strong>Amputee model:</strong> \n');
    plotLegState(prostheticData.GaitPhaseData,plotInfo,prostheticGaitInfo,saveInfo,legStateFig,subplotStart,true,false)
    
    pos=get(gca,'position');  % retrieve the current values
    pos(1)= 2* pos(1);        % try reducing width 10%
    % pos(2)= 1.3* pos(2);        % try reducing width 10%
    % pos(4)= 0.8* pos(4);        % try reducing width 10%
    pos(3)= 0.8* pos(3);        % try reducing width 10%
    set(gca,'position',pos);
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    fprintf('<strong>Amputee model with CMG:</strong> \n');
    plotLegState(prostheticCMGData.GaitPhaseData,plotInfo,prostheticCMGGaitInfo,saveInfo,legStateFig,subplotStart,true,false)
    
    pos=get(gca,'position');  % retrieve the current values
    pos(1)= 2* pos(1);        % try reducing width 10%
    % pos(2)= 1.3* pos(2);        % try reducing width 10%
    % pos(4)= 0.8* pos(4);        % try reducing width 10%
    pos(3)= 0.8* pos(3);        % try reducing width 10%
    set(gca,'position',pos);
    
    htxt = text(gca,-28,6.3,'\underline{Healthy model}','interpreter','latex','FontSize',26,'Rotation',90);
    set(htxt,'Position',[-28, 6.3, 0]);
    ptxt = text(gca,-28,-0.3,'\underline{Amputee model}','interpreter','latex','FontSize',26,'Rotation',90);
    set(ptxt,'Position',[-28, -0.3, 0]);
    atxt = text(gca,-38,8,'(a)','FontSize',20);
    set(atxt,'Position',[-38, 8, 0]);
    btxt = text(gca,-38,2,'(b)','FontSize',20);
    set(btxt,'Position',[-38, 2, 0]);
    legend('Intact leg','Prosthetic leg','FontSize', 21,'Location','southeast'); %'Position',[0.515 0.03 0.075 0.07]
    
end

%% Angular data
if b_plotAngles
    angularDataFig = figure();
    figurePositionAngle = [10,100,1100,480];
    hwratioAngles = figurePositionAngle(end)/figurePositionAngle(end-1);
    set(angularDataFig, 'Position',figurePositionAngle); % two
    % set(angularDataFig, 'Position',[10,100,1700,800]); % three
    subplotStart = [2 4 1];
    [plotHealthyAngle, axesHealthyAngle] = plotAngularData(healthyData.angularData,healthyData.GaitPhaseData,plotInfo,healthyGaitInfo,saveInfo,angularDataFig,[],subplotStart,'left',false,true);
    [plotRealHealthyAngle, axesRealHealthyAngle] = plotAngularData(realHealthyData.angularData,[],plotInfo,realHealthyDataGaitInfo,saveInfo,angularDataFig,axesHealthyAngle,subplotStart,'right',false,true);
    for ii = 1:length(plotRealHealthyAngle)
        set(plotRealHealthyAngle(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticAngle, axesProstheticAngle] = plotAngularData(prostheticData.angularData,prostheticData.GaitPhaseData,plotInfo,prostheticGaitInfo,saveInfo,angularDataFig,[],subplotStart,'both',false,false);
    % subplotStart(3) = subplotStart(3)+subplotStart(2);
    % [plotCMGAngle, axesCMGAngle] = plotAngularData(prostheticCMGData.angularData,prostheticCMGData.GaitPhaseData,plotInfo,prostheticCMGGaitInfo,saveInfo,angularDataFig,[],subplotStart,'both',false,false);
    
    axesAngle = [axesHealthyAngle,axesProstheticAngle];%,axesCMGAngle];
    
    xlabel(axesAngle(end),'gait cycle ($\%$) ');
    
    % addInfoTextFigure('Amputee model CMG','c',axesCMGAngle(1),ylabelPosAngle);
    
    axesPosAngle = setAxes(axesAngle,0.11,0.19, 0.05, -0.09, 0.14, hwratioAngles);
    
    setLegend([plotHealthyAngle(end,1),plotRealHealthyAngle(end,1)],axesPosAngle(4,:),{'Model','Humans'},18);
    setLegend(plotProstheticAngle(end,[1,3]),axesPosAngle(end,:),{'Intact leg','Prosthetic leg'},18);
    
    ylabelPosAngle = 1.05*alignYlabels(axesAngle([1,5]));%,axesCMGAngle(1)]);
    addInfoTextFigure('Healthy',24,'a',20,axesAngle(1),ylabelPosAngle);
    addInfoTextFigure('Amputee',24,'b',20,axesAngle(5),ylabelPosAngle);
end

%% Torque data
if b_plotTorques
    torqueDataFig = figure();
    figurePositionTorque = [10,100,1100,540]; %[10,100,1700,800]
    hwratioTorque = figurePositionTorque(end)/figurePositionTorque(end-1);
    set(torqueDataFig, 'Position',figurePositionTorque);
    subplotStart = [2 4 1];
    
    
    [plotHealthyTorque,axesHealthyTorque] = plotJointTorqueData(healthyData.jointTorquesData,plotInfo,healthyGaitInfo,saveInfo,torqueDataFig,[],subplotStart,'left',true);
    [plotRealHealthyTorque,axesRealHealthyTorque] = plotJointTorqueData(realHealthyData.jointTorquesData,plotInfo,realHealthyDataGaitInfo,saveInfo,torqueDataFig,axesHealthyTorque,subplotStart,'right',true);
    for ii = 1:length(plotRealHealthyTorque)
        set(plotRealHealthyTorque(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticTorque,axesProstheticTorque] = plotJointTorqueData(prostheticData.jointTorquesData,plotInfo,prostheticGaitInfo,saveInfo,torqueDataFig,[],subplotStart,'both',false);
    
    axesTorque = [axesHealthyTorque,axesProstheticTorque];%,axesCMGAngle];
    xlabel(axesTorque(end),'gait cycle ($\%$) ');
    
    axesPosTorque = setAxes(axesTorque,0.10,0.19, 0.03, -0.04, 0.14, hwratioTorque);
    
    setLegend([plotHealthyTorque(end,1),plotRealHealthyTorque(end,1)],axesPosTorque(4,:),{'Model','Humans'},18);
    setLegend(plotProstheticTorque(end,[1,3]),axesPosTorque(end,:),{'Intact leg','Prosthetic leg'},18);
    % legend(plotProstheticAngle(end,[1,3]),'Intact leg','Prosthetic leg','FontSize', 21,'Position',[0.80 0.465 0.075 0.07]);  %two
    
    ylabelPosTorque = 1.8*alignYlabels(axesTorque([1,5]));%,axesCMGAngle(1)]);
    addInfoTextFigure('Healthy',24,'a',20,axesTorque(1),ylabelPosTorque);
    addInfoTextFigure('Amputee',24,'b',20,axesTorque(5),ylabelPosTorque);
end

%% Power data
if b_plotPowers
    powerDataFig = figure();
    figurePositionPower = [10,100,1100,500]; %[10,100,1700,800]
    hwratioPower = figurePositionPower(end)/figurePositionPower(end-1);
    set(powerDataFig, 'Position',figurePositionPower);
    subplotStart = [2 4 1];
    [plotHealthyPower,axesHealthyPower] = plotJointPowerData(healthyData.angularData,healthyData.jointTorquesData,plotInfo,healthyGaitInfo,saveInfo,powerDataFig,[],subplotStart,'left',true);
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticPower,axesProstheticPower] = plotJointPowerData(prostheticData.angularData,prostheticData.jointTorquesData,plotInfo,prostheticGaitInfo,saveInfo,powerDataFig,[],subplotStart,'both',false);
    
    axesPower = [axesHealthyPower,axesProstheticPower];%,axesCMGAngle];
    xlabel(axesPower(end),'gait cycle ($\%$) ');
    
    axesPosPower = setAxes(axesPower,0.11,0.19, 0.03, -0.04, 0.14, hwratioPower);
    
    setLegend([plotHealthyPower(end,1)],axesPosPower(4,:),{'Model'},18);
    setLegend(plotProstheticPower(end,[1,3]),axesPosPower(end,:),{'Intact leg','Prosthetic leg'},18);
    
    ylabelPosPower = 0.9*alignYlabels(axesPower([1,5]));%,axesCMGAngle(1)]);
    addInfoTextFigure('Healthy',24,'a',20,axesPower(1),ylabelPosPower);
    addInfoTextFigure('Amputee',24,'b',20,axesPower(5),ylabelPosPower);
end

%% GRF data
if b_plotGRF
    GRFDataFig = figure();
    figurePositionGRF = [10,100,900,450]; %[10,100,1700,800]
    hwratioGRF = figurePositionGRF(end)/figurePositionGRF(end-1);
    set(GRFDataFig, 'Position',figurePositionGRF);
    subplotStart = [2 3 1];
    
    [plotHealthyGRF,axesHealthyGRF] = plotGRF(healthyData.GRFData,plotInfo,healthyGaitInfo,saveInfo,GRFDataFig,[],subplotStart,'left',true);
    [plotRealHealthyGRF,axesRealHealthyGRF] = plotGRF(realHealthyData.GRFData,plotInfo,realHealthyDataGaitInfo,saveInfo,GRFDataFig,axesHealthyGRF,subplotStart,'right',true);
    for ii = 1:length(plotRealHealthyGRF)
        set(plotRealHealthyGRF(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticGRF,axesProstheticGRF] = plotGRF(prostheticData.GRFData,plotInfo,prostheticGaitInfo,saveInfo,GRFDataFig,[],subplotStart,'both',false);
    
    
    axesGRF = [axesHealthyGRF,axesProstheticGRF];%,axesCMGAngle];
    xlabel(axesGRF(end),'gait cycle ($\%$) ');
    axesPosGRF = setAxes(axesGRF,0.14,0.23, 0.04, -0.08, 0.17, hwratioGRF);
    
    setLegend([plotHealthyGRF(end,1),plotRealHealthyGRF(end,1)],axesPosGRF(3,:),{'Model','Humans'},18);
    setLegend(plotProstheticGRF(end,[1,3]),axesPosGRF(6,:),{'Intact leg','Prosthetic leg'},18);
    % legend(plotProstheticAngle(end,[1,3]),'Intact leg','Prosthetic leg','FontSize', 21,'Position',[0.80 0.465 0.075 0.07]);  %two
    
    ylabelPosGRF = 1.4*alignYlabels(axesGRF([1,4]));%,axesCMGAngle(1)]);
    addInfoTextFigure('Healthy',24,'a',20,axesGRF(1),ylabelPosGRF);
    addInfoTextFigure('Amputee',24,'b',20,axesGRF(4),ylabelPosGRF);
end

%% Musculo data
if b_plotMuscle
    set(0, 'DefaultAxesFontSize',18);
    musculoDataFig = figure();
    set(musculoDataFig, 'Position',[10,100,1900,600]);
    subplotStart = [2 11 1];
    [plotHealthyMusc,axesHealthyMusc] = plotMusculoData(healthyData.musculoData,plotInfo,healthyGaitInfo,saveInfo,musculoDataFig,[],subplotStart,'left',true);
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticMusc,axesProstheticMusc] = plotMusculoData(prostheticData.musculoData,plotInfo,prostheticGaitInfo,saveInfo,musculoDataFig,[],subplotStart,'both',false);
    
    
    ylabelPosMusc = 1.5*alignYlabels([axesHealthyMusc(1),axesProstheticMusc(1)]);%,axesCMGAngle(1)]);
    axesMusc = [axesHealthyMusc,axesProstheticMusc];%,axesCMGAngle];

    
    xlabel(axesMusc(end),'gait cycle ($\%$) ');
    addInfoTextFigure('Healthy model',24,'a',20,axesHealthyMusc(1),ylabelPosMusc);
    addInfoTextFigure('Amputee model',24,'b',20,axesProstheticMusc(1),ylabelPosMusc);
    
    legend(plotProstheticMusc(end,[1,3]),'Intact leg','Prosthetic leg','FontSize', 20,'Position',[0.88 0.45 0.075 0.03]);
end

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


