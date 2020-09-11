function plotData(angularData,musculoData,GRFData,jointTorquesData,GaitPhaseData,stepTimes,info,b_saveFigure,plotWinterData,showSD,plotInOneFigure,b_oneGaitPhase)
%%
set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);


saveInfo = struct;
if  nargin < 8
    saveInfo.b_saveFigure = 1;
else
    saveInfo.b_saveFigure = b_saveFigure;
end
if  nargin < 12
    b_oneGaitPhase = true;
end
if saveInfo.b_saveFigure
    saveInfo.type = {'jpeg','eps','emf'};
end
if nargin < 11
    plotInOneFigure = false;
end
if nargin < 10
   showSD = false; 
end
if nargin < 9
    plotWinterData = false;
end
saveInfo.info = info;
t = angularData.time;

GaitInfo = getPartOfGaitData(b_oneGaitPhase,GaitPhaseData,t,stepTimes);
GaitInfo.tp = (0:0.5:100)';

% if ~b_oneGaitPhase
%     getSteps(t,GaitPhaseData,stepTimes);
% end
%%
plotInfo.showSD = showSD;%true;
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-'; '--';':'};
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

%%

if plotInOneFigure
    totalFig = figure();
    subplotStart = dec2base(351,10) - '0';
else
    totalFig = [];
    subplotStart = [];
end
set(0, 'DefaultAxesFontSize',12);


plotAngularData(angularData,GaitPhaseData,plotInfo,GaitInfo,saveInfo,totalFig,subplotStart);

if plotInOneFigure
    subplotStart(3) = subplotStart(3)+6;
end
plotJointTorqueData(jointTorquesData,plotInfo,GaitInfo,saveInfo,totalFig,subplotStart);

% set(0, 'DefaultAxesFontSize',10);
plotMusculoData(musculoData,plotInfo,GaitInfo,saveInfo,[],[]);

if plotInOneFigure
    subplotStart(3) = subplotStart(3)+5;
end
plotGRF(GRFData,plotInfo,GaitInfo,saveInfo,totalFig,subplotStart);


if ~isempty(totalFig)
    set(0, 'currentfigure',totalFig);
end

if plotInOneFigure && GaitInfo.b_oneGaitPhase && contains(saveInfo.info,'prosthetic') && plotInfo.plotWinterData
    leg = legend('Intact leg','Prosthetic leg', 'Winter data');
    %     leg = legend('Intact leg','Prosthetic leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')) );
elseif plotInOneFigure && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData
    leg = legend('Left leg','Right leg', 'Winter data');
    %     leg = legend('Left leg','Right leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')));
elseif plotInOneFigure && contains(saveInfo.info,'prosthetic')
    leg = legend('Intact leg','Prosthetic leg');
    %     leg = legend('Intact leg','Prosthetic leg');
elseif plotInOneFigure
    leg = legend('Left leg','Right leg');
    %     leg = legend('Left leg','Right leg');
else
    leg = [];
end
if ~isempty(leg)
    set(leg, 'FontSize', 14);
    set(leg,'Position',[0.13 0.5 0.1 0.07]);
end
%
set(0, 'DefaultAxesFontSize',15);
set(0, 'DefaultAxesTitleFontSizeMultiplier',1);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1);

