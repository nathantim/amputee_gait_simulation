function plotHealthyProstheticData(healthyData,prostheticData,prostheticCMGData,info,b_saveTotalFig)
showSD = false;
plotInOneFigure = true;
plotWinterData = false;

%For debug purposes
b_plotLegState    = 0;
b_plotAngles      = 0;
b_plotTorques     = 0;
b_plotPowers      = 0;
b_plotGRF         = 1;
b_plotMuscle      = 0;

%%
legStateFig     = [];
angularDataFig  = [];
torqueDataFig   = [];
powerDataFig    = [];
GRFDataFig      = [];
musculoDataFig  = [];

set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);


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
    set(angularDataFig, 'Position',[10,100,1300,600]); % two
    % set(angularDataFig, 'Position',[10,100,1700,800]); % three
    subplotStart = [2 4 1];
    [plotHealthyAngle, axesHealthyAngle] = plotAngularData(healthyData.angularData,healthyData.GaitPhaseData,plotInfo,healthyGaitInfo,saveInfo,angularDataFig,[],subplotStart,'left',false,true);
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticAngle, axesProstheticAngle] = plotAngularData(prostheticData.angularData,prostheticData.GaitPhaseData,plotInfo,prostheticGaitInfo,saveInfo,angularDataFig,[],subplotStart,'both',false,false);
    % subplotStart(3) = subplotStart(3)+subplotStart(2);
    % [plotCMGAngle, axesCMGAngle] = plotAngularData(prostheticCMGData.angularData,prostheticCMGData.GaitPhaseData,plotInfo,prostheticCMGGaitInfo,saveInfo,angularDataFig,[],subplotStart,'both',false,false);
    
    ylabelPosAngle = alignYlabels([axesHealthyAngle(1),axesProstheticAngle(1)]);%,axesCMGAngle(1)]);
    axesAngle = [axesHealthyAngle,axesProstheticAngle];%,axesCMGAngle];
    
    xlabel(axesAngle(end),'gait cycle ($\%$) ');
    addInfoTextFigure('Healthy model','a',axesHealthyAngle(1),ylabelPosAngle);
    addInfoTextFigure('Amputee model','b',axesProstheticAngle(1),ylabelPosAngle);
    % addInfoTextFigure('Amputee model CMG','c',axesCMGAngle(1),ylabelPosAngle);
    
    % legend(plotProstheticAngle(end,[1,3]),'Intact leg','Prosthetic leg','FontSize', 21,'Location','northeastoutside');
    legend(plotProstheticAngle(end,[1,3]),'Intact leg','Prosthetic leg','FontSize', 21,'Position',[0.80 0.465 0.075 0.07]);  %two
    % legend(plotProstheticAngle(end,[1,3]),'Intact leg','Prosthetic leg','FontSize', 21,'Position',[0.89 0.425 0.075 0.07]);  % three
end

%% Torque data
if b_plotTorques
    torqueDataFig = figure();
    set(torqueDataFig, 'Position',[10,100,1700,800]);
    subplotStart = [2 4 1];
    [plotHealthyTorque,axesHealthyTorque] = plotJointTorqueData(healthyData.jointTorquesData,plotInfo,healthyGaitInfo,saveInfo,torqueDataFig,[],subplotStart,'left',true);
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticTorque,axesProstheticTorque] = plotJointTorqueData(prostheticData.jointTorquesData,plotInfo,prostheticGaitInfo,saveInfo,torqueDataFig,[],subplotStart,'both',false);
    
    ylabelPosTorque = alignYlabels([axesHealthyTorque(1),axesProstheticTorque(1)]);%,axesCMGAngle(1)]);
    axesTorque = [axesHealthyTorque,axesProstheticTorque];%,axesCMGAngle];
    xlabel(axesTorque(end),'gait cycle ($\%$) ');
    
    addInfoTextFigure('Healthy model','a',axesHealthyTorque(1),ylabelPosTorque);
    addInfoTextFigure('Amputee model','b',axesProstheticTorque(1),ylabelPosTorque);
    
    legend(plotProstheticTorque(end,[1,3]),'Intact leg','Prosthetic leg','FontSize', 21,'Position',[0.81 0.46 0.075 0.07]);
    % legend(plotProstheticAngle(end,[1,3]),'Intact leg','Prosthetic leg','FontSize', 21,'Position',[0.80 0.465 0.075 0.07]);  %two
end

%% Power data
if b_plotPowers
    powerDataFig = figure();
    set(powerDataFig, 'Position',[10,100,1700,800]);
    subplotStart = [2 4 1];
    [plotHealthyPower,axesHealthyPower] = plotJointPowerData(healthyData.angularData,healthyData.jointTorquesData,plotInfo,healthyGaitInfo,saveInfo,powerDataFig,[],subplotStart,'left',true);
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticPower,axesProstheticPower] = plotJointPowerData(prostheticData.angularData,prostheticData.jointTorquesData,plotInfo,prostheticGaitInfo,saveInfo,powerDataFig,[],subplotStart,'both',false);
    
    ylabelPosPower = 0.9*alignYlabels([axesHealthyPower(1),axesProstheticPower(1)]);%,axesCMGAngle(1)]);
    axesPower = [axesHealthyPower,axesProstheticPower];%,axesCMGAngle];
    xlabel(axesPower(end),'gait cycle ($\%$) ');
    
    xlabel(axesPower(end),'gait cycle ($\%$) ');
    addInfoTextFigure('Healthy model','a',axesHealthyPower(1),ylabelPosPower);
    addInfoTextFigure('Amputee model','b',axesProstheticPower(1),ylabelPosPower);
    
    legend(plotProstheticPower(end,[1,3]),'Intact leg','Prosthetic leg','FontSize', 21,'Position',[0.81 0.46 0.075 0.07]);
end

%% GRF data
if b_plotGRF
    GRFDataFig = figure();
    set(GRFDataFig, 'Position',[10,100,1400,800]);
    subplotStart = [2 3 1];
    [plotHealthyGRF,axesHealthyGRF] = plotGRF(healthyData.GRFData,plotInfo,healthyGaitInfo,saveInfo,GRFDataFig,[],subplotStart,'left',true);
    subplotStart(3) = subplotStart(3)+subplotStart(2);
    [plotProstheticGRF,axesProstheticGRF] = plotGRF(prostheticData.GRFData,plotInfo,prostheticGaitInfo,saveInfo,GRFDataFig,[],subplotStart,'both',false);
    
    
    ylabelPosGRF = 1.1*alignYlabels([axesHealthyGRF(1),axesProstheticGRF(1)]);%,axesCMGAngle(1)]);
    axesGRF = [axesHealthyGRF,axesProstheticGRF];%,axesCMGAngle];
    xlabel(axesGRF(end),'gait cycle ($\%$) ');
    
    xlabel(axesGRF(end),'gait cycle ($\%$) ');
    addInfoTextFigure('Healthy model','a',axesHealthyGRF(1),ylabelPosGRF);
    addInfoTextFigure('Amputee model','b',axesProstheticGRF(1),ylabelPosGRF);
    
    legend(plotProstheticGRF(end,[1,3]),'Intact leg','Prosthetic leg','FontSize', 21,'Position',[0.77 0.36 0.075 0.07]);
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
    
    xlabel(axesMusc(end),'gait cycle ($\%$) ');
    addInfoTextFigure('Healthy model','a',axesHealthyMusc(1),ylabelPosMusc);
    addInfoTextFigure('Amputee model','b',axesProstheticMusc(1),ylabelPosMusc);
    
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


