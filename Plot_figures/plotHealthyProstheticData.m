function plotHealthyProstheticData(realHealthyData,healthyData,prostheticData,prostheticCMGNotActiveData,prostheticCMGActiveData,info,b_saveTotalFig)
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
realHealthyDataGaitInfo = getPartOfGaitData(realHealthyData.angularData.time,   [],                                 [],                             healthySaveInfo, false);

if ~isempty(prostheticCMGNotActiveData)
    prostheticCMGNotActiveGaitInfo   = getPartOfGaitData(prostheticCMGNotActiveData.angularData.time, prostheticCMGNotActiveData.GaitPhaseData,    prostheticCMGNotActiveData.stepTimes,    prostheticSaveInfo, b_oneGaitPhase);
end
if ~isempty(prostheticCMGActiveData)
    prostheticCMGActiveGaitInfo   = getPartOfGaitData(prostheticCMGActiveData.angularData.time, prostheticCMGActiveData.GaitPhaseData,    prostheticCMGActiveData.stepTimes,    prostheticSaveInfo, b_oneGaitPhase);
end
%% Normalize data:
healthyData.jointTorquesData.signals.values = healthyData.jointTorquesData.signals.values./getBodyMass();
healthyData.GRFData.signals.values = healthyData.GRFData.signals.values./getBodyMass();

prostheticData.jointTorquesData.signals.values = prostheticData.jointTorquesData.signals.values./getBodyMass();
prostheticData.GRFData.signals.values = prostheticData.GRFData.signals.values./getBodyMass();

realHealthyData.angularData.time = realHealthyData.angularData.time./100;
realHealthyData.jointTorquesData.time = realHealthyData.jointTorquesData.time./100;
realHealthyData.GRFData.time = realHealthyData.GRFData.time./100;

if ~isempty(prostheticCMGNotActiveData)
    prostheticCMGNotActiveData.GRFData.signals.values = prostheticCMGNotActiveData.GRFData.signals.values./getBodyMass();
    prostheticCMGNotActiveData.jointTorquesData.signals.values = prostheticCMGNotActiveData.jointTorquesData.signals.values./getBodyMass();
end
if ~isempty(prostheticCMGActiveData)
    prostheticCMGActiveData.GRFData.signals.values = prostheticCMGActiveData.GRFData.signals.values./getBodyMass();
    prostheticCMGActiveData.jointTorquesData.signals.values = prostheticCMGActiveData.jointTorquesData.signals.values./getBodyMass();
end
%%
plotInfo.showSD = showSD;%true;
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-';':'; '-';':';'-';':';'-';':'};
plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E';'#618D27';'#372D31';'#E74B47';'#504579';'#D27918'};
% plotInfo.lineVec = plotInfo.lineVec(:,:);
% plotInfo.colorProp = plotInfo.colorProp(1:3,:);
plotInfo.lineWidthProp = {3;3;3;3;3;3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];
plotInfo.plotWinterData = plotWinterData;
plotInfo.showTables = true;
plotInfo.showCorr = true;

plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor','LineStyle'};
faceAlpha = {0.4;0.4;0.4;0.4;0.4;0.4;0.4;0.4};
plotInfo.fillVal = plotInfo.colorProp;
% plotInfo.edgeVec = {':';':';':';':'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.edgeVec = {'none';'none';'none';'none';'none';'none';'none';'none'};% {[0.8 0.8 0.8],0.5,'none'};

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
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    fprintf('<strong>Amputee model with inactive CMG:</strong> \n');
    [plotCMGState, axesCMGState] = plotLegState(prostheticCMGNotActiveData.GaitPhaseData,plotInfo,prostheticCMGNotActiveGaitInfo,prostheticSaveInfo,legStateFig,[],subplotStart,'both',false);
    
    axesState = [axesHealthyState,axesProstheticState,axesCMGState];
    
    xlabel(axesState(end),'gait cycle ($\%$) ');
    
    axesPosState = setAxes(axesState,subplotStart(2),0.38,0.185, -0.02, 0.01, 0.23, hwratioState);
    
    setLegend([plotHealthyState(1)],axesPosState(1,:),{'H'},18);
    setLegend(plotProstheticState(end,[1,3]),axesPosState(2,:),{'I','P'},18);
    setLegend(plotCMGState(end,[1,3]),axesPosState(3,:),{'I','P'},18);
    
    ylabelPosState = 0.5*alignYlabel(axesState);%,axesCMGAngle(1)]);
    addInfoTextFigure('Healthy',24,'(a)',20,axesState(1),ylabelPosState);
    addInfoTextFigure('Amputee',24,'(b)',20,axesState(2),ylabelPosState);
    addInfoTextFigure('CMG',24,'(c)',20,axesState(3),ylabelPosState);
end

%% Angular data

if b_plotAngles
    axesHealthyAngle = []; axesProstheticAngle = [];
    axesCMGNotActiveAngle = []; axesCMGActiveAngle = [];
    angularDataFig = figure();
    
    if ~isempty(prostheticCMGNotActiveData) && ~isempty(prostheticCMGActiveData)
        subplotStart = [4 4 1];
        figurePositionAngle = [10,100,750,650];
    elseif ~isempty(prostheticCMGNotActiveData)
        subplotStart = [3 4 1];
    else
        subplotStart = [2 4 1];
        figurePositionAngle = [10,100,730,400];
    end
    
    hwratioAngles = figurePositionAngle(end)/figurePositionAngle(end-1);
    set(angularDataFig, 'Position',figurePositionAngle); % two
    % set(angularDataFig, 'Position',[10,100,1700,800]); % three
    
    
    [plotHealthyAngle, axesHealthyAngle] = plotAngularData(healthyData.angularData,plotInfo,healthyGaitInfo,healthySaveInfo,angularDataFig,[],subplotStart,'left',true);
    [plotRealHealthyAngle, axesHealthyAngle] = plotAngularData(realHealthyData.angularData,plotInfo,realHealthyDataGaitInfo,healthySaveInfo,angularDataFig,axesHealthyAngle,subplotStart,'right',true);
    for ii = 1:length(plotRealHealthyAngle)
        set(plotRealHealthyAngle(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticAngle, axesProstheticAngle] = plotAngularData(prostheticData.angularData,plotInfo,prostheticGaitInfo,prostheticSaveInfo,angularDataFig,[],subplotStart,'both',false);
    
    if ~isempty(prostheticCMGNotActiveData)
        subplotStart(3) = subplotStart(3)+subplotStart(2);
        [plotCMGNotActiveAngle, axesCMGNotActiveAngle] = plotAngularData(prostheticCMGNotActiveData.angularData,plotInfo,prostheticCMGNotActiveGaitInfo,prostheticSaveInfo,angularDataFig,[],subplotStart,'both',false);
    end
    if ~isempty(prostheticCMGActiveData)
        subplotStart(3) = subplotStart(3)+subplotStart(2);
        [plotCMGActiveAngle, axesCMGActiveAngle] = plotAngularData(prostheticCMGActiveData.angularData,plotInfo,prostheticCMGActiveGaitInfo,prostheticSaveInfo,angularDataFig,[],subplotStart,'both',false);
    end
    
    for ii = 1:size(plotProstheticAngle,1)
        set(plotProstheticAngle(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotProstheticAngle(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(4,:));
        
        if isgraphics(plotProstheticAngle(ii,2))
            set(plotProstheticAngle(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
        end
        if isgraphics(plotProstheticAngle(ii,4))
            set(plotProstheticAngle(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(4,:));
        end
        
        if ~isempty(prostheticCMGNotActiveData)
            set(plotCMGNotActiveAngle(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(5,:));
            set(plotCMGNotActiveAngle(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(6,:));
            if isgraphics(plotCMGNotActiveAngle(ii,2))
                set(plotCMGNotActiveAngle(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(5,:));
            end
            if isgraphics(plotCMGNotActiveAngle(ii,4))
                set(plotCMGNotActiveAngle(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(6,:));
            end
        end
        if ~isempty(prostheticCMGActiveData)
            set(plotCMGActiveAngle(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(7,:));
            set(plotCMGActiveAngle(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(8,:));
            if isgraphics(plotCMGActiveAngle(ii,2))
                set(plotCMGActiveAngle(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(7,:));
            end
            if isgraphics(plotCMGActiveAngle(ii,4))
                set(plotCMGActiveAngle(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(8,:));
            end
        end
    end
    
    axesAngle = [axesHealthyAngle,axesProstheticAngle,axesCMGNotActiveAngle,axesCMGActiveAngle];
    
    xlabel(axesAngle(end),'gait cycle ($\%$) ');
    
    % addInfoTextFigure('Amputee model CMG','(c)',axesCMGAngle(1),ylabelPosAngle);
    if subplotStart(1) == 2
        axesPosAngle = setAxes(axesAngle,subplotStart(2),0.135,0.20, -0.08, 0.12, 0.16, hwratioAngles);
    elseif subplotStart(1) == 4
        axesPosAngle = setAxes(axesAngle,subplotStart(2),0.125,0.20, -0.07, 0.015, 0.15, hwratioAngles);
    end
    
    setLegend([plotHealthyAngle(end,1),plotRealHealthyAngle(end,1)],axesPosAngle(end,:),{'H','F'},18);
    setLegend(plotProstheticAngle(end,[1,3]),axesPosAngle(end,:),{'I','P'},18);
    
    ylabelPosAngle = alignYlabel(axesAngle([1,(length(axesAngle)-length(axesHealthyAngle)+1)]));%,axesCMGAngle(1)]);
    %     ylabelPosAngle = ylabelPosAngle + 0.25;
    addInfoTextFigure('Healthy',24,'(a)',20,axesAngle(1),ylabelPosAngle);
    addInfoTextFigure('Amputee',24,'(b)',20,axesAngle(5),ylabelPosAngle);
    if ~isempty(prostheticCMGNotActiveData)
        setLegend(plotCMGNotActiveAngle(end,[1,3]),axesPosAngle(end,:),{'$\mathrm{I}_{\mathrm{CI}}$','$\mathrm{P}_{\mathrm{CI}}$'},18);
        addInfoTextFigure('CMG not Active',24,'(c)',20,axesAngle(9),ylabelPosAngle);
    end
    if ~isempty(prostheticCMGActiveData)
        addInfoTextFigure('CMG Active',24,'(d)',20,axesAngle(13),ylabelPosAngle);
        setLegend(plotCMGActiveAngle(end,[1,3]),axesPosAngle(end,:),{'$\mathrm{I}_{\mathrm{CA}}$','$\mathrm{P}_{\mathrm{CA}}$'},18);
    end
    
    addCorr2plot(plotInfo.showCorr,plotHealthyAngle(:,1),plotRealHealthyAngle(:,1),axesHealthyAngle,...
        14,[0.01,0.75,0; 0.01,0.75,0; 0.01,0.75,0; 0.01,0.05,0;]);
    
end

%% Torque data
if b_plotTorques
    axesHealthyTorque = []; axesProstheticTorque = [];
    axesCMGNotActiveTorque = []; axesCMGActiveTorque = [];
    torqueDataFig = figure();
    
    if ~isempty(prostheticCMGNotActiveData) && ~isempty(prostheticCMGActiveData)
        subplotStart = [4 4 1];
        figurePositionTorque = [10,100,750,650];
    elseif ~isempty(prostheticCMGNotActiveData)
        subplotStart = [3 4 1];
    else
        subplotStart = [2 4 1];
        figurePositionTorque = [10,100,640,400]; %[10,100,1700,800]
    end
    hwratioTorque = figurePositionTorque(end)/figurePositionTorque(end-1);
    set(torqueDataFig, 'Position',figurePositionTorque);
    
    
    [plotHealthyTorque,axesHealthyTorque] = plotJointTorqueData(healthyData.jointTorquesData,plotInfo,healthyGaitInfo,healthySaveInfo,torqueDataFig,[],subplotStart,'left',true);
    [plotRealHealthyTorque,axesHealthyTorque] = plotJointTorqueData(realHealthyData.jointTorquesData,plotInfo,realHealthyDataGaitInfo,healthySaveInfo,torqueDataFig,axesHealthyTorque,subplotStart,'right',true);
    for ii = 1:length(plotRealHealthyTorque)
        set(plotRealHealthyTorque(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticTorque,axesProstheticTorque] = plotJointTorqueData(prostheticData.jointTorquesData,plotInfo,prostheticGaitInfo,prostheticSaveInfo,torqueDataFig,[],subplotStart,'both',false);
    
    if ~isempty(prostheticCMGNotActiveData)
        subplotStart(3) = subplotStart(3)+subplotStart(2);
        [plotCMGNotActiveTorque, axesCMGNotActiveTorque] = plotJointTorqueData(prostheticCMGNotActiveData.jointTorquesData,plotInfo,prostheticCMGNotActiveGaitInfo,prostheticSaveInfo,torqueDataFig,[],subplotStart,'both',false);
    end
    if ~isempty(prostheticCMGActiveData)
        subplotStart(3) = subplotStart(3)+subplotStart(2);
        [plotCMGActiveTorque, axesCMGActiveTorque] = plotJointTorqueData(prostheticCMGActiveData.jointTorquesData,plotInfo,prostheticCMGActiveGaitInfo,prostheticSaveInfo,torqueDataFig,[],subplotStart,'both',false);
    end
    
    for ii = 1:size(plotProstheticTorque,1)
        set(plotProstheticTorque(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotProstheticTorque(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(4,:));
        
        if isgraphics(plotProstheticTorque(ii,2))
            set(plotProstheticTorque(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
        end
        if isgraphics(plotProstheticTorque(ii,4))
            set(plotProstheticTorque(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(4,:));
        end
        
        if ~isempty(prostheticCMGNotActiveData)
            set(plotCMGNotActiveTorque(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(5,:));
            set(plotCMGNotActiveTorque(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(6,:));
            if isgraphics(plotCMGNotActiveTorque(ii,2))
                set(plotCMGNotActiveTorque(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(5,:));
            end
            if isgraphics(plotCMGNotActiveTorque(ii,4))
                set(plotCMGNotActiveTorque(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(6,:));
            end
        end
        if ~isempty(prostheticCMGActiveData)
            set(plotCMGActiveTorque(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(7,:));
            set(plotCMGActiveTorque(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(8,:));
            if isgraphics(plotCMGActiveTorque(ii,2))
                set(plotCMGActiveTorque(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(7,:));
            end
            if isgraphics(plotCMGActiveTorque(ii,4))
                set(plotCMGActiveTorque(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(8,:));
            end
        end
    end
    
    axesTorque = [axesHealthyTorque,axesProstheticTorque, axesCMGNotActiveTorque, axesCMGActiveTorque];
    xlabel(axesTorque(end),'gait cycle ($\%$) ');
    
    
    if subplotStart(1) == 2
        axesPosTorque = setAxes(axesTorque,subplotStart(2),0.13,0.200, -0.08, 0.12, 0.16, hwratioTorque);
    elseif subplotStart(1) == 4
        axesPosTorque = setAxes(axesTorque,subplotStart(2),0.125,0.20, -0.07, 0.015, 0.15, hwratioTorque);
    end
    
    setLegend([plotHealthyTorque(end,1),plotRealHealthyTorque(end,1)],axesPosTorque(4,:),{'H','F'},18);
    setLegend(plotProstheticTorque(end,[1,3]),axesPosTorque(end,:),{'I','P'},18);
    
    ylabelPosTorque = alignYlabel(axesTorque([1,(length(axesTorque)-length(axesHealthyTorque)+1)]));%,axesCMGAngle(1)]);
    
    addInfoTextFigure('Healthy',24,'(a)',20,axesTorque(1),ylabelPosTorque);
    addInfoTextFigure('Amputee',24,'(b)',20,axesTorque(5),ylabelPosTorque);
    
    if ~isempty(prostheticCMGNotActiveData)
        setLegend(plotCMGNotActiveTorque(end,[1,3]),axesPosTorque(end,:),{'$\mathrm{I}_{\mathrm{CI}}$','$\mathrm{P}_{\mathrm{CI}}$'},18);
        addInfoTextFigure('CMG not Active',24,'(c)',20,axesTorque(9),ylabelPosTorque);
    end
    if ~isempty(prostheticCMGActiveData)
        addInfoTextFigure('CMG Active',24,'(d)',20,axesTorque(13),ylabelPosTorque);
        setLegend(plotCMGActiveTorque(end,[1,3]),axesPosTorque(end,:),{'$\mathrm{I}_{\mathrm{CA}}$','$\mathrm{P}_{\mathrm{CA}}$'},18);
    end
    
    addCorr2plot(plotInfo.showCorr,plotHealthyTorque(:,1),plotRealHealthyTorque(:,1),axesHealthyTorque,...
        14,[0.35,0.75,0; 0.35,0.75,0; 0.3,0.001,0; 0.40,0.75,0]);
    %             addCorr2plot(plotInfo.showCorr,plotHealthyTorque(:,1),plotRealHealthyTorque(:,1),axesHealthyTorque,...
    %                 14,[0.45,0.80,0; 0.40,0.80,0; 0.40,0.05,0; 0.40,0.80,0]);
    
end

%% Power data
if b_plotPowers
    axesHealthyPower = []; axesProstheticPower = [];
    axesCMGNotActivePower = []; axesCMGActivePower = [];
    powerDataFig = figure();
    
    if ~isempty(prostheticCMGNotActiveData) && ~isempty(prostheticCMGActiveData)
        subplotStart = [4 4 1];
        figurePositionPower = [10,100,750,650];
    elseif ~isempty(prostheticCMGNotActiveData)
        subplotStart = [3 4 1];
    else
        subplotStart = [2 4 1];
        figurePositionPower = [10,100,720,380]; %[10,100,1700,800]
    end
    
    hwratioPower = figurePositionPower(end)/figurePositionPower(end-1);
    set(powerDataFig, 'Position',figurePositionPower);
    
    [plotHealthyPower,axesHealthyPower] = plotJointPowerData(healthyData.angularData,healthyData.jointTorquesData,plotInfo,healthyGaitInfo,healthySaveInfo,powerDataFig,[],subplotStart,'left',true);
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticPower,axesProstheticPower] = plotJointPowerData(prostheticData.angularData,prostheticData.jointTorquesData,plotInfo,prostheticGaitInfo,prostheticSaveInfo,powerDataFig,[],subplotStart,'both',false);
    
    if ~isempty(prostheticCMGNotActiveData)
        subplotStart(3) = subplotStart(3)+subplotStart(2);
        [plotCMGNotActivePower, axesCMGNotActivePower] = plotJointPowerData(prostheticCMGNotActiveData.angularData,prostheticCMGNotActiveData.jointTorquesData,plotInfo,prostheticCMGNotActiveGaitInfo,prostheticSaveInfo,powerDataFig,[],subplotStart,'both',false);
        
    end
    if ~isempty(prostheticCMGActiveData)
        subplotStart(3) = subplotStart(3)+subplotStart(2);
        [plotCMGActivePower, axesCMGActivePower] = plotJointPowerData(prostheticCMGActiveData.angularData,prostheticCMGActiveData.jointTorquesData,plotInfo,prostheticCMGActiveGaitInfo,prostheticSaveInfo,powerDataFig,[],subplotStart,'both',false);
    end
    
    for ii = 1:size(plotProstheticPower,1)
        set(plotProstheticPower(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotProstheticPower(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(4,:));
        
        if isgraphics(plotProstheticPower(ii,2))
            set(plotProstheticPower(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
        end
        if isgraphics(plotProstheticPower(ii,4))
            set(plotProstheticPower(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(4,:));
        end
        
        if ~isempty(prostheticCMGNotActiveData)
            set(plotCMGNotActivePower(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(5,:));
            set(plotCMGNotActivePower(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(6,:));
            if isgraphics(plotCMGNotActivePower(ii,2))
                set(plotCMGNotActivePower(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(5,:));
            end
            if isgraphics(plotCMGNotActivePower(ii,4))
                set(plotCMGNotActivePower(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(6,:));
            end
        end
        if ~isempty(prostheticCMGActiveData)
            set(plotCMGActivePower(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(7,:));
            set(plotCMGActivePower(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(8,:));
            if isgraphics(plotCMGActivePower(ii,2))
                set(plotCMGActivePower(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(7,:));
            end
            if isgraphics(plotCMGActivePower(ii,4))
                set(plotCMGActivePower(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(8,:));
            end
        end
    end
    
    axesPower = [axesHealthyPower,axesProstheticPower,axesCMGNotActivePower, axesCMGActivePower];
    xlabel(axesPower(end),'gait cycle ($\%$) ');
    
    
    if subplotStart(1) == 2
        axesPosPower = setAxes(axesPower,subplotStart(2),0.145,0.2, -0.08, 0.12, 0.155, hwratioPower);
    elseif subplotStart(1) == 4
        axesPosPower = setAxes(axesPower,subplotStart(2),0.125,0.20, -0.07, 0.015, 0.15, hwratioPower);
    end
    
    setLegend([plotHealthyPower(end,1)],axesPosPower(4,:),{'H'},18);
    setLegend(plotProstheticPower(end,[1,3]),axesPosPower(end,:),{'I','P'},18);
    
    ylabelPosPower = alignYlabel(axesPower([1,(length(axesPower)-length(axesHealthyPower)+1)]));%,axesCMGAngle(1)]);
    addInfoTextFigure('Healthy',24,'(a)',20,axesPower(1),ylabelPosPower);
    addInfoTextFigure('Amputee',24,'(b)',20,axesPower(5),ylabelPosPower);
    
    if ~isempty(prostheticCMGNotActiveData)
        setLegend(plotCMGNotActivePower(end,[1,3]),axesPosPower(end,:),{'$\mathrm{I}_{\mathrm{CI}}$','$\mathrm{P}_{\mathrm{CI}}$'},18);
        addInfoTextFigure('CMG not Active',24,'(c)',20,axesPower(9),ylabelPosPower);
    end
    if ~isempty(prostheticCMGActiveData)
        addInfoTextFigure('CMG Active',24,'(d)',20,axesPower(13),ylabelPosPower);
        setLegend(plotCMGActivePower(end,[1,3]),axesPosPower(end,:),{'$\mathrm{I}_{\mathrm{CA}}$','$\mathrm{P}_{\mathrm{CA}}$'},18);
    end
end

%% GRF data
if b_plotGRF
    axesHealthyGRF = []; axesProstheticGRF = [];
    axesCMGNotActiveGRF = []; axesCMGActiveGRF = [];
    GRFDataFig = figure();
    
    if ~isempty(prostheticCMGNotActiveData) && ~isempty(prostheticCMGActiveData)
        subplotStart = [4 3 1];
        figurePositionGRF = [10,100,580,580];
    elseif ~isempty(prostheticCMGNotActiveData)
        subplotStart = [3 3 1];
    else
        subplotStart = [2 3 1];
        figurePositionGRF = [10,100,500,400]; %[10,100,1700,800]
    end
    hwratioGRF = figurePositionGRF(end)/figurePositionGRF(end-1);
    set(GRFDataFig, 'Position',figurePositionGRF);
    
    
    [plotHealthyGRF,axesHealthyGRF] = plotGRFData(healthyData.GRFData,plotInfo,healthyGaitInfo,healthySaveInfo,GRFDataFig,[],subplotStart,'left',true);
    [plotRealHealthyGRF,axesHealthyGRF] = plotGRFData(realHealthyData.GRFData,plotInfo,realHealthyDataGaitInfo,healthySaveInfo,GRFDataFig,axesHealthyGRF,subplotStart,'right',true);
    for ii = 1:length(plotRealHealthyGRF)
        set(plotRealHealthyGRF(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticGRF,axesProstheticGRF] = plotGRFData(prostheticData.GRFData,plotInfo,prostheticGaitInfo,prostheticSaveInfo,GRFDataFig,[],subplotStart,'both',false);
    
    if ~isempty(prostheticCMGNotActiveData)
        subplotStart(3) = subplotStart(3)+subplotStart(2);
        [plotCMGNotActiveGRF, axesCMGNotActiveGRF] = plotGRFData(prostheticCMGNotActiveData.GRFData,plotInfo,prostheticCMGNotActiveGaitInfo,prostheticSaveInfo,GRFDataFig,[],subplotStart,'both',false);
    end
    if ~isempty(prostheticCMGActiveData)
        subplotStart(3) = subplotStart(3)+subplotStart(2);
        [plotCMGActiveGRF, axesCMGActiveGRF] = plotGRFData(prostheticCMGActiveData.GRFData,plotInfo,prostheticCMGActiveGaitInfo,prostheticSaveInfo,GRFDataFig,[],subplotStart,'both',false);
    end
    
    for ii = 1:size(plotProstheticGRF,1)
        set(plotProstheticGRF(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotProstheticGRF(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(4,:));
        
        if isgraphics(plotProstheticGRF(ii,2))
            set(plotProstheticGRF(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
        end
        if isgraphics(plotProstheticGRF(ii,4))
            set(plotProstheticGRF(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(4,:));
        end
        
        if ~isempty(prostheticCMGNotActiveData)
            set(plotCMGNotActiveGRF(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(5,:));
            set(plotCMGNotActiveGRF(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(6,:));
            if isgraphics(plotCMGNotActiveGRF(ii,2))
                set(plotCMGNotActiveGRF(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(5,:));
            end
            if isgraphics(plotCMGNotActiveGRF(ii,4))
                set(plotCMGNotActiveGRF(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(6,:));
            end
        end
        if ~isempty(prostheticCMGActiveData)
            set(plotCMGActiveGRF(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(7,:));
            set(plotCMGActiveGRF(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(8,:));
            if isgraphics(plotCMGActiveGRF(ii,2))
                set(plotCMGActiveGRF(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(7,:));
            end
            if isgraphics(plotCMGActiveGRF(ii,4))
                set(plotCMGActiveGRF(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(8,:));
            end
        end
    end
    
    axesGRF = [axesHealthyGRF,axesProstheticGRF,axesCMGNotActiveGRF, axesCMGActiveGRF];
    xlabel(axesGRF(end),'gait cycle ($\%$) ');
    
    
    if subplotStart(1) == 2
        axesPosGRF = setAxes(axesGRF,subplotStart(2),0.170,0.250, -0.05, 0.12, 0.19, hwratioGRF);
    elseif subplotStart(1) == 4
        axesPosGRF = setAxes(axesGRF,subplotStart(2),0.16,0.250, -0.07, 0.02, 0.18, hwratioGRF);
    end
    
    setLegend([plotHealthyGRF(end,1),plotRealHealthyGRF(end,1)],axesPosGRF(3,:),{'H','F'},18);
    setLegend(plotProstheticGRF(end,[1,3]),axesPosGRF(6,:),{'I','P'},18);
    % legend(plotProstheticAngle(end,[1,3]),'I','P','FontSize', 21,'Position',[0.80 0.465 0.075 0.07]);  %two
    
    ylabelPosGRF = alignYlabel(axesGRF([1,(length(axesGRF)-length(axesHealthyGRF)+1)]));%,axesCMGAngle(1)]);
    addInfoTextFigure('Healthy',24,'(a)',20,axesGRF(1),ylabelPosGRF);
    addInfoTextFigure('Amputee',24,'(b)',20,axesGRF(4),ylabelPosGRF);
    
    if ~isempty(prostheticCMGNotActiveData)
        setLegend(plotCMGNotActiveGRF(end,[1,3]),axesPosGRF(end,:),{'$\mathrm{I}_{\mathrm{CI}}$','$\mathrm{P}_{\mathrm{CI}}$'},18);
        addInfoTextFigure('CMG not Active',24,'(c)',20,axesGRF(7),ylabelPosGRF);
    end
    if ~isempty(prostheticCMGActiveData)
        addInfoTextFigure('CMG Active',24,'(d)',20,axesGRF(10),ylabelPosGRF);
        setLegend(plotCMGActiveGRF(end,[1,3]),axesPosGRF(end,:),{'$\mathrm{I}_{\mathrm{CA}}$','$\mathrm{P}_{\mathrm{CA}}$'},18);
    end
    
    addCorr2plot(plotInfo.showCorr,plotHealthyGRF(:,1),plotRealHealthyGRF(:,1),axesHealthyGRF, ...
        14,[0.35,0.001,0; 0.35,0.75,0; 0.35,0.75,0]);
%     addCorr2plot(plotInfo.showCorr,plotHealthyGRF(:,1),plotRealHealthyGRF(:,1),axesHealthyGRF, ...
%         14,[0.35,0.05,0; 0.35,0.75,0; 0.35,0.75,0]);
    
end

%% Musculo data
if b_plotMuscle
    axesHealthyMusc = []; axesProstheticMusc = [];
    axesCMGNotActiveMusc = []; axesCMGActiveMusc = [];
    set(0, 'DefaultAxesFontSize',18);
    
    if ~isempty(prostheticCMGNotActiveData) && ~isempty(prostheticCMGActiveData)
        subplotStart = [4 11 1];
        figurePositionMusc = [10,100,1750,600];
    elseif ~isempty(prostheticCMGNotActiveData)
        subplotStart = [3 11 1];
    else
        subplotStart = [2 11 1];
        figurePositionMusc = [10,100,1750,400]; %[10,100,1700,800]
    end
    hwratioMusc = figurePositionMusc(end)/figurePositionMusc(end-1);
    musculoDataFig = figure();
    set(musculoDataFig, 'Position',figurePositionMusc);
    
    [plotHealthyMusc,axesHealthyMusc] = plotMusculoData(healthyData.musculoData,plotInfo,healthyGaitInfo,healthySaveInfo,musculoDataFig,[],subplotStart,'left',true);
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticMusc,axesProstheticMusc] = plotMusculoData(prostheticData.musculoData,plotInfo,prostheticGaitInfo,prostheticSaveInfo,musculoDataFig,[],subplotStart,'both',false);
    
    if ~isempty(prostheticCMGNotActiveData)
        subplotStart(3) = subplotStart(3)+subplotStart(2);
        [plotCMGNotActiveMusc, axesCMGNotActiveMusc] = plotMusculoData(prostheticCMGNotActiveData.musculoData,plotInfo,prostheticCMGNotActiveGaitInfo,prostheticSaveInfo,musculoDataFig,[],subplotStart,'both',false);
    end
    if ~isempty(prostheticCMGActiveData)
        subplotStart(3) = subplotStart(3)+subplotStart(2);
        [plotCMGActiveMusc, axesCMGActiveMusc] = plotMusculoData(prostheticCMGActiveData.musculoData,plotInfo,prostheticCMGActiveGaitInfo,prostheticSaveInfo,musculoDataFig,[],subplotStart,'both',false);
    end
    
    for ii = 1:size(plotProstheticMusc,1)
        set(plotProstheticMusc(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotProstheticMusc(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(4,:));
        
        if isgraphics(plotProstheticMusc(ii,2))
            set(plotProstheticMusc(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
        end
        if isgraphics(plotProstheticMusc(ii,4))
            set(plotProstheticMusc(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(4,:));
        end
        
        if ~isempty(prostheticCMGNotActiveData)
            set(plotCMGNotActiveMusc(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(5,:));
            set(plotCMGNotActiveMusc(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(6,:));
            if isgraphics(plotCMGNotActiveMusc(ii,2))
                set(plotCMGNotActiveMusc(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(5,:));
            end
            if isgraphics(plotCMGNotActiveMusc(ii,4))
                set(plotCMGNotActiveMusc(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(6,:));
            end
        end
        if ~isempty(prostheticCMGActiveData)
            set(plotCMGActiveMusc(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(7,:));
            set(plotCMGActiveMusc(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(8,:));
            if isgraphics(plotCMGActiveMusc(ii,2))
                set(plotCMGActiveMusc(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(7,:));
            end
            if isgraphics(plotCMGActiveMusc(ii,4))
                set(plotCMGActiveMusc(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(8,:));
            end
        end
    end
    
    axesMusc = [axesHealthyMusc,axesProstheticMusc, axesCMGNotActiveMusc, axesCMGActiveMusc];
    
    xlabel(axesMusc(end),'gait cycle ($\%$) ');
    
    if subplotStart(1) == 2
        axesPosMusc = setAxes(axesMusc,subplotStart(2),0.058,0.08, -0.05, 0.10, 0.065, hwratioMusc);
    elseif subplotStart(1) == 4
        axesPosMusc = setAxes(axesMusc,subplotStart(2),0.058,0.08, -0.03, 0.01, 0.06, hwratioMusc);
    end
    
    
    setLegend([plotHealthyMusc(end,1)],axesPosMusc(length(axesHealthyMusc),:),{'H'},18);
    setLegend(plotProstheticMusc(end,[1,3]),axesPosMusc(end,:),{'I','P'},18);
    
    ylabelPosMusc = alignYlabel(axesMusc([1,(length(axesMusc)-length(axesHealthyMusc)+1)]));
    addInfoTextFigure('Healthy model',24,'(a)',20,axesHealthyMusc(1),ylabelPosMusc);
    addInfoTextFigure('Amputee model',24,'(b)',20,axesProstheticMusc(1),ylabelPosMusc);
    
    if ~isempty(prostheticCMGNotActiveData)
        setLegend(plotCMGNotActiveMusc(end,[1,3]),axesPosMusc(end,:),{'$\mathrm{I}_{\mathrm{CI}}$','$\mathrm{P}_{\mathrm{CI}}$'},18);
        addInfoTextFigure('CMG not Active',24,'(c)',20,axesMusc(23),ylabelPosMusc);
    end
    if ~isempty(prostheticCMGActiveData)
        addInfoTextFigure('CMG Active',24,'(d)',20,axesMusc(34),ylabelPosMusc);
        setLegend(plotCMGActiveMusc(end,[1,3]),axesPosMusc(end,:),{'$\mathrm{I}_{\mathrm{CA}}$','$\mathrm{P}_{\mathrm{CA}}$'},18);
    end
    
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


