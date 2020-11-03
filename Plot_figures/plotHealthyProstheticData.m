function plotHealthyProstheticData(realHealthyData,healthyData,prostheticData,prostheticCMGData,info,b_saveTotalFig)
showSD = true;
plotWinterData = false;

%For debug purposes
b_plotLegState    = 0;
b_plotAngles      = 1;
b_plotTorques     = 1;
b_plotPowers      = 1;
b_plotGRF         = 1;
b_plotMuscle      = 1;

%%
legStateFig     = [];
angularDataFig  = [];
torqueDataFig   = [];
powerDataFig    = [];
GRFDataFig      = [];
musculoDataFig  = [];

saveInfo = struct;
saveInfo.b_saveFigure = 0;
b_oneGaitPhase = true;

if 1
    savePath = '../../Thesis Document/fig/';
    saveInfo.type = {'eps'};
    b_withDate = false;
else
    savePath = [];
    b_withDate = true;
    saveInfo.type = {'jpeg','eps','emf'};
end

if nargin < 5
    b_saveTotalFig = false;
end
saveInfo.info = info;

healthySaveInfo = saveInfo;
healthySaveInfo.info = [healthySaveInfo.info, 'healthy'];

prostheticSaveInfo = saveInfo;
prostheticSaveInfo.info = [prostheticSaveInfo.info, 'prosthetic'];


healthyGaitInfo         = getPartOfGaitData(healthyData.angularData.time,       healthyData.GaitPhaseData,          healthyData.stepTimes,          healthySaveInfo, b_oneGaitPhase);
prostheticGaitInfo      = getPartOfGaitData(prostheticData.angularData.time,    prostheticData.GaitPhaseData,       prostheticData.stepTimes,       prostheticSaveInfo, b_oneGaitPhase);
% prostheticCMGGaitInfo   = getPartOfGaitData(prostheticCMGData.angularData.time, prostheticCMGData.GaitPhaseData,    prostheticCMGData.stepTimes,    prostheticSaveInfo, b_oneGaitPhase);
realHealthyDataGaitInfo = getPartOfGaitData(realHealthyData.angularData.time,   [],                                 [],                             healthySaveInfo, false);

%% Normalize data:
healthyData.jointTorquesData.signals.values = healthyData.jointTorquesData.signals.values./getBodyMass();
prostheticData.jointTorquesData.signals.values = prostheticData.jointTorquesData.signals.values./getBodyMass();
% prostheticCMGData.jointTorquesData.signals.values = prostheticData.jointTorquesData.signals.values./getBodyMass();

healthyData.GRFData.signals.values = healthyData.GRFData.signals.values./getBodyMass();
prostheticData.GRFData.signals.values = prostheticData.GRFData.signals.values./getBodyMass();
% prostheticCMGData.GRFData.signals.values = prostheticData.GRFData.signals.values./getBodyMass();

realHealthyData.angularData.time = realHealthyData.angularData.time./100;
realHealthyData.jointTorquesData.time = realHealthyData.jointTorquesData.time./100;
realHealthyData.GRFData.time = realHealthyData.GRFData.time./100;

%%
plotInfo.showSD = showSD;%true;
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-';':'; '-';':'};
plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E';'#618D27'};
% plotInfo.lineVec = plotInfo.lineVec(:,:);
% plotInfo.colorProp = plotInfo.colorProp(1:3,:);
plotInfo.lineWidthProp = {3;3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];
plotInfo.plotWinterData = plotWinterData;
plotInfo.showTables = true;
plotInfo.showCorr = true;

plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor','LineStyle'};
faceAlpha = {0.4;0.4;0.4;0.4};
plotInfo.fillVal = plotInfo.colorProp;
plotInfo.edgeVec = {'none';'none';'none';'none'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.fillProp_entries = [plotInfo.fillVal,faceAlpha,plotInfo.fillVal,plotInfo.edgeVec];

set(0, 'DefaultAxesFontSize',16);
set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);

%% Leg state
if b_plotLegState
    axesHealthyState = []; axesProstheticState = []; axesCMGState = [];
    legStateFig = figure();
    figurePositionState = [10,100,500,500];
    hwratioState = figurePositionState(end)/figurePositionState(end-1);
    set(legStateFig, 'Position',figurePositionState);
    subplotStart = [3 1 1];
    fprintf('\n<strong>Healthy model:</strong> \n');
    [plotHealthyState, axesHealthyState] = plotLegState(healthyData.GaitPhaseData,plotInfo,healthyGaitInfo,healthySaveInfo,legStateFig,[],subplotStart,'left',true);
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    fprintf('<strong>Amputee model:</strong> \n');
    [plotProstheticState, axesProstheticState] = plotLegState(prostheticData.GaitPhaseData,plotInfo,prostheticGaitInfo,prostheticSaveInfo,legStateFig,[],subplotStart,'both',false);

%     subplotStart(3) = subplotStart(3)+subplotStart(2);
%     fprintf('<strong>Amputee model with CMG:</strong> \n');
%     [plotCMGState, axesCMGState] = plotLegState(prostheticCMGData.GaitPhaseData,plotInfo,prostheticCMGGaitInfo,prostheticSaveInfo,legStateFig,[],subplotStart,'both',false);
    
    axesState = [axesHealthyState,axesProstheticState,axesCMGState];
    
    xlabel(axesState(end),'gait cycle ($\%$) ');

    axesPosState = setAxes(axesState,subplotStart(2),0.38,0.185, -0.02, 0.01, 0.23, hwratioState);
    
    setLegend([plotHealthyState(1)],axesPosState(1,:),{'H'},18);
    setLegend(plotProstheticState(end,[1,3]),axesPosState(2,:),{'I','P'},18);
%     setLegend(plotCMGState(end,[1,3]),axesPosState(3,:),{'I','P'},18);

    ylabelPosState = 0.5*alignYlabel(axesState);%,axesCMGAngle(1)]);
    addInfoTextFigure('Healthy',24,'(a)',20,axesState(1),ylabelPosState);
    addInfoTextFigure('Amputee',24,'(b)',20,axesState(2),ylabelPosState);
%     addInfoTextFigure('CMG',24,'(c)',20,axesState(3),ylabelPosState);
end

%% Angular data

if b_plotAngles
    axesHealthyAngle = []; axesProstheticAngle = []; axesCMGAngle = [];
    angularDataFig = figure();
    figurePositionAngle = [10,100,730,400];
    hwratioAngles = figurePositionAngle(end)/figurePositionAngle(end-1);
    set(angularDataFig, 'Position',figurePositionAngle); % two
    % set(angularDataFig, 'Position',[10,100,1700,800]); % three
    subplotStart = [2 4 1];
    [plotHealthyAngle, axesHealthyAngle] = plotAngularData(healthyData.angularData,plotInfo,healthyGaitInfo,healthySaveInfo,angularDataFig,[],subplotStart,'left',true);
    [plotRealHealthyAngle, axesHealthyAngle] = plotAngularData(realHealthyData.angularData,plotInfo,realHealthyDataGaitInfo,healthySaveInfo,angularDataFig,axesHealthyAngle,subplotStart,'right',true);
    for ii = 1:length(plotRealHealthyAngle)
        set(plotRealHealthyAngle(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticAngle, axesProstheticAngle] = plotAngularData(prostheticData.angularData,plotInfo,prostheticGaitInfo,prostheticSaveInfo,angularDataFig,[],subplotStart,'both',false);
    % subplotStart(3) = subplotStart(3)+subplotStart(2);
    % [plotCMGAngle, axesCMGAngle] = plotAngularData(prostheticCMGData.angularData,prostheticCMGData.GaitPhaseData,plotInfo,prostheticCMGGaitInfo,prostheticSaveInfo,angularDataFig,[],subplotStart,'both',false,false);
    
    for ii = 1:size(plotProstheticAngle,1)
        set(plotProstheticAngle(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotProstheticAngle(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
        set(plotProstheticAngle(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(4,:));
        set(plotProstheticAngle(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(4,:));
        
    end
    
    axesAngle = [axesHealthyAngle,axesProstheticAngle,axesCMGAngle];
    
    xlabel(axesAngle(end),'gait cycle ($\%$) ');
    
    % addInfoTextFigure('Amputee model CMG','(c)',axesCMGAngle(1),ylabelPosAngle);
    
    axesPosAngle = setAxes(axesAngle,subplotStart(2),0.135,0.20, -0.08, 0.12, 0.16, hwratioAngles);
    
    setLegend([plotHealthyAngle(end,1),plotRealHealthyAngle(end,1)],axesPosAngle(4,:),{'H','F'},18);
    setLegend(plotProstheticAngle(end,[1,3]),axesPosAngle(end,:),{'I','P'},18);
    
    ylabelPosAngle = alignYlabel(axesAngle([1,5]));%,axesCMGAngle(1)]);
%     ylabelPosAngle = ylabelPosAngle + 0.25;
    addInfoTextFigure('Healthy',24,'(a)',20,axesAngle(1),ylabelPosAngle);
    addInfoTextFigure('Amputee',24,'(b)',20,axesAngle(5),ylabelPosAngle);
    
    
    addCorr2plot(plotInfo.showCorr,plotHealthyAngle(:,1),plotRealHealthyAngle(:,1),axesHealthyAngle,...
                14,[0.05,0.75,0; 0.05,0.75,0; 0.05,0.75,0; 0.01,0.05,0;]);

end

%% Torque data
if b_plotTorques
    axesHealthyTorque = []; axesProstheticTorque = []; axesCMGTorque = [];
    torqueDataFig = figure();
    figurePositionTorque = [10,100,640,400]; %[10,100,1700,800]
    hwratioTorque = figurePositionTorque(end)/figurePositionTorque(end-1);
    set(torqueDataFig, 'Position',figurePositionTorque);
    subplotStart = [2 4 1];
    
    
    [plotHealthyTorque,axesHealthyTorque] = plotJointTorqueData(healthyData.jointTorquesData,plotInfo,healthyGaitInfo,healthySaveInfo,torqueDataFig,[],subplotStart,'left',true);
    [plotRealHealthyTorque,axesHealthyTorque] = plotJointTorqueData(realHealthyData.jointTorquesData,plotInfo,realHealthyDataGaitInfo,healthySaveInfo,torqueDataFig,axesHealthyTorque,subplotStart,'right',true);
    for ii = 1:length(plotRealHealthyTorque)
        set(plotRealHealthyTorque(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticTorque,axesProstheticTorque] = plotJointTorqueData(prostheticData.jointTorquesData,plotInfo,prostheticGaitInfo,prostheticSaveInfo,torqueDataFig,[],subplotStart,'both',false);   
    for ii = 1:size(plotProstheticTorque,1)
        set(plotProstheticTorque(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotProstheticTorque(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
        set(plotProstheticTorque(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(4,:));
        set(plotProstheticTorque(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(4,:));
    end
    
    axesTorque = [axesHealthyTorque,axesProstheticTorque,axesCMGTorque];
    xlabel(axesTorque(end),'gait cycle ($\%$) ');
    
    axesPosTorque = setAxes(axesTorque,subplotStart(2),0.13,0.200, -0.08, 0.12, 0.16, hwratioTorque);
    
    setLegend([plotHealthyTorque(end,1),plotRealHealthyTorque(end,1)],axesPosTorque(4,:),{'H','F'},18);
    setLegend(plotProstheticTorque(end,[1,3]),axesPosTorque(end,:),{'I','P'},18);
    
    ylabelPosTorque = alignYlabel(axesTorque([1,5]));%,axesCMGAngle(1)]);
    
    addInfoTextFigure('Healthy',24,'(a)',20,axesTorque(1),ylabelPosTorque);
    addInfoTextFigure('Amputee',24,'(b)',20,axesTorque(5),ylabelPosTorque);
    
    addCorr2plot(plotInfo.showCorr,plotHealthyTorque(:,1),plotRealHealthyTorque(:,1),axesHealthyTorque,...
                14,[0.35,0.75,0; 0.35,0.75,0; 0.30,0,0; 0.39,0.75,0]);

end

%% Power data
if b_plotPowers
    axesHealthyPower = []; axesProstheticPower = []; axesCMGPower = [];
    powerDataFig = figure();
    figurePositionPower = [10,100,720,380]; %[10,100,1700,800]
    hwratioPower = figurePositionPower(end)/figurePositionPower(end-1);
    set(powerDataFig, 'Position',figurePositionPower);
    subplotStart = [2 4 1];
    [plotHealthyPower,axesHealthyPower] = plotJointPowerData(healthyData.angularData,healthyData.jointTorquesData,plotInfo,healthyGaitInfo,healthySaveInfo,powerDataFig,[],subplotStart,'left',true);
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticPower,axesProstheticPower] = plotJointPowerData(prostheticData.angularData,prostheticData.jointTorquesData,plotInfo,prostheticGaitInfo,prostheticSaveInfo,powerDataFig,[],subplotStart,'both',false);
    for ii = 1:size(plotProstheticPower,1)
        set(plotProstheticPower(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotProstheticPower(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
        set(plotProstheticPower(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(4,:));
        set(plotProstheticPower(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(4,:));
    end
    
    axesPower = [axesHealthyPower,axesProstheticPower,axesCMGPower];
    xlabel(axesPower(end),'gait cycle ($\%$) ');
    
    axesPosPower = setAxes(axesPower,subplotStart(2),0.145,0.2, -0.08, 0.12, 0.155, hwratioPower);
    
    setLegend([plotHealthyPower(end,1)],axesPosPower(4,:),{'H'},18);
    setLegend(plotProstheticPower(end,[1,3]),axesPosPower(end,:),{'I','P'},18);
    
    ylabelPosPower = alignYlabel(axesPower([1,5]));%,axesCMGAngle(1)]);
    addInfoTextFigure('Healthy',24,'(a)',20,axesPower(1),ylabelPosPower);
    addInfoTextFigure('Amputee',24,'(b)',20,axesPower(5),ylabelPosPower);
end

%% GRF data
if b_plotGRF
    axesHealthyGRF = []; axesProstheticGRF = []; axesCMGGRF = [];
    GRFDataFig = figure();
    figurePositionGRF = [10,100,500,400]; %[10,100,1700,800]
    hwratioGRF = figurePositionGRF(end)/figurePositionGRF(end-1);
    set(GRFDataFig, 'Position',figurePositionGRF);
    subplotStart = [2 3 1];
    
    [plotHealthyGRF,axesHealthyGRF] = plotGRFData(healthyData.GRFData,plotInfo,healthyGaitInfo,healthySaveInfo,GRFDataFig,[],subplotStart,'left',true);
    [plotRealHealthyGRF,axesHealthyGRF] = plotGRFData(realHealthyData.GRFData,plotInfo,realHealthyDataGaitInfo,healthySaveInfo,GRFDataFig,axesHealthyGRF,subplotStart,'right',true);
    for ii = 1:length(plotRealHealthyGRF)
        set(plotRealHealthyGRF(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticGRF,axesProstheticGRF] = plotGRFData(prostheticData.GRFData,plotInfo,prostheticGaitInfo,prostheticSaveInfo,GRFDataFig,[],subplotStart,'both',false);
    for ii = 1:size(plotProstheticGRF,1)
        set(plotProstheticGRF(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotProstheticGRF(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
        set(plotProstheticGRF(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(4,:));
        set(plotProstheticGRF(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(4,:));
    end
    
    axesGRF = [axesHealthyGRF,axesProstheticGRF,axesCMGGRF];
    xlabel(axesGRF(end),'gait cycle ($\%$) ');
    axesPosGRF = setAxes(axesGRF,subplotStart(2),0.170,0.250, -0.05, 0.12, 0.19, hwratioGRF);
    
    setLegend([plotHealthyGRF(end,1),plotRealHealthyGRF(end,1)],axesPosGRF(3,:),{'H','F'},18);
    setLegend(plotProstheticGRF(end,[1,3]),axesPosGRF(6,:),{'I','P'},18);
    % legend(plotProstheticAngle(end,[1,3]),'I','P','FontSize', 21,'Position',[0.80 0.465 0.075 0.07]);  %two
    
    ylabelPosGRF = alignYlabel(axesGRF([1,4]));%,axesCMGAngle(1)]);
    addInfoTextFigure('Healthy',24,'(a)',20,axesGRF(1),ylabelPosGRF);
    addInfoTextFigure('Amputee',24,'(b)',20,axesGRF(4),ylabelPosGRF);
    
    addCorr2plot(plotInfo.showCorr,plotHealthyGRF(:,1),plotRealHealthyGRF(:,1),axesHealthyGRF, ...
                14,[0.30,0.75,0; 0.30,0.75,0; 0.30,0.75,0]);

end

%% Musculo data
if b_plotMuscle
    axesHealthyMusc = []; axesProstheticMusc = []; axesCMGMusc = [];
    set(0, 'DefaultAxesFontSize',18);
    figurePositionMusc = [10,100,1750,400]; %[10,100,1700,800]
    hwratioMusc = figurePositionMusc(end)/figurePositionMusc(end-1);
    musculoDataFig = figure();
    set(musculoDataFig, 'Position',figurePositionMusc);
    subplotStart = [2 11 1];
    [plotHealthyMusc,axesHealthyMusc] = plotMusculoData(healthyData.musculoData,plotInfo,healthyGaitInfo,healthySaveInfo,musculoDataFig,[],subplotStart,'left',true);
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticMusc,axesProstheticMusc] = plotMusculoData(prostheticData.musculoData,plotInfo,prostheticGaitInfo,prostheticSaveInfo,musculoDataFig,[],subplotStart,'both',false);
    for ii = 1:size(plotProstheticMusc,1)
        set(plotProstheticMusc(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotProstheticMusc(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
        set(plotProstheticMusc(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(4,:));
        if ~isnan(plotProstheticMusc(ii,4))
            set(plotProstheticMusc(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(4,:));
        end
    end
    
    axesMusc = [axesHealthyMusc,axesProstheticMusc];%,axesCMGAngle];
        
    xlabel(axesMusc(end),'gait cycle ($\%$) ');
    
    axesPosMusc = setAxes(axesMusc,subplotStart(2),0.058,0.08, -0.05, 0.10, 0.065, hwratioMusc);
    
    setLegend([plotHealthyMusc(end,1)],axesPosMusc(length(axesHealthyMusc),:),{'H'},18);
    setLegend(plotProstheticMusc(end,[1,3]),axesPosMusc(end,:),{'I','P'},18);
    
    ylabelPosMusc = alignYlabel([axesHealthyMusc(1),axesProstheticMusc(1)]);%,axesCMGMusc(1)]);
    addInfoTextFigure('Healthy model',24,'(a)',20,axesHealthyMusc(1),ylabelPosMusc);
    addInfoTextFigure('Amputee model',24,'(b)',20,axesProstheticMusc(1),ylabelPosMusc);
    
end

%% Save

if b_saveTotalFig
        saveFigure(legStateFig,     'legState',saveInfo.type,saveInfo.info,b_withDate,savePath)
        saveFigure(angularDataFig,  'angularData',saveInfo.type,saveInfo.info,b_withDate,savePath)
        saveFigure(torqueDataFig,   'torqueData',saveInfo.type,saveInfo.info,b_withDate,savePath)
        saveFigure(powerDataFig,    'powerData',saveInfo.type,saveInfo.info,b_withDate,savePath)
        saveFigure(musculoDataFig,  'musculoData',saveInfo.type,saveInfo.info,b_withDate,savePath)
        saveFigure(GRFDataFig,      'GRFData',saveInfo.type,saveInfo.info,b_withDate,savePath)
end

startup;


