function plotCombinedCMGData(amputeeCMGactive,amputeeTripPrevent,b_saveTotalFig)
% PLOTCOMBINEDCMGDATA Function plots the averaged CMG data during a stride and the CMG data during trip prevention
% INPUTS:
%   - amputeeCMGactive       is the simout struct that contains the CMGData of the amputee model walking with active CMG
%   - amputeeTripPrevent     is the simout struct containing the data of trip prevention smulation
%   - b_saveTotalFig         is an optional argument that lets you save the figure
% OUTPUTS:
%   -

%%
if nargin < 3
    b_saveTotalFig = false;
end
saveInfo = struct;
saveInfo.b_saveFigure = 0;

if 1 && b_saveTotalFig
    savePath = '../../Thesis Document/fig/';
    saveInfo.type = {'eps'};
    b_withDate = false;
else
    savePath = [];
    b_withDate = true;
    saveInfo.type = {'jpeg','eps','emf'};
end
saveInfo.info = 'prosthetic1.2ms';
b_oneGaitPhase = true;
plotInfo.showSD = true;
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-';':'; '-.';':'};
plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E';'#618D27'};

plotInfo.lineWidthProp = {3;3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];

plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor','LineStyle'};
faceAlpha = {0.4;0.4;0.4;0.4};
plotInfo.fillVal = plotInfo.colorProp;
plotInfo.edgeVec = {'none';'none';'none';'none'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.fillProp_entries = [plotInfo.fillVal,faceAlpha,plotInfo.fillVal,plotInfo.edgeVec];
plotInfo.showTables = b_oneGaitPhase;

GaitInfoWalk = getPartOfGaitData(amputeeCMGactive.angularData.time,amputeeCMGactive.GaitPhaseData,amputeeCMGactive.stepTimes,true,[]);
GaitInfoTrip = getPartOfGaitData(amputeeTripPrevent.angularData.time,amputeeTripPrevent.GaitPhaseData,amputeeTripPrevent.stepTimes,false,[7 8]);

%%
set(0, 'DefaultAxesFontSize',15);
set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);

%%
CMGcombinedFig = figure();
CMGcombinedFig.Name = 'CMG data during walking and trip prevention';
figurePositionCMG = [50 10 500 800];
hwratio = figurePositionCMG(end)/figurePositionCMG(end-1);
set(CMGcombinedFig, 'Position',figurePositionCMG);

subplotStart = [4,2,1];
axesWalk = plotCMGData(amputeeCMGactive.CMGData,plotInfo,GaitInfoWalk,saveInfo,CMGcombinedFig,[],subplotStart,true,true,false);
subplotStart(3) = 2;
axesTripPrevent = plotCMGData(amputeeTripPrevent.CMGData,plotInfo,GaitInfoTrip,saveInfo,CMGcombinedFig,[],subplotStart,false,false,true,true);

axesCMG = [ axesWalk(1),axesTripPrevent(1),...
    axesWalk(2),axesTripPrevent(2),...
    axesWalk(3),axesTripPrevent(3),...
    axesWalk(4),axesTripPrevent(4)];

% Resize axes
setAxes(axesCMG,subplotStart(2),0.12,0.325, -0.04, 0.0, 0.24, hwratio);

% Align Title and axis
for ii = 1:2:length(axesCMG)
    alignTitle(axesCMG(ii:ii+1));
end
alignYlabel(axesWalk);

% Add figure title text and subfigure letters
lettertxtT = text(0,0,'\underline{CMG Data}','FontSize',22,'clipping', 'off');
set(lettertxtT,'Parent',(axesCMG(1)))
set(lettertxtT,'HorizontalAlignment','center','VerticalAlignment','bottom');
set(lettertxtT,'Units','Normalized');
set(lettertxtT,'Position',[1.25 1.5 0]);

lettertxtA = text(0,0,'(a)','FontSize',20,'clipping', 'off');
set(lettertxtA,'Parent',(axesCMG(1)))
set(lettertxtA,'HorizontalAlignment','center','VerticalAlignment','bottom');
set(lettertxtA,'Units','Normalized');
set(lettertxtA,'Position',[0.5 1.25 0]);

lettertxtB = text(0.5,0,'(b)','FontSize',20,'clipping', 'off');
set(lettertxtB,'Parent',(axesCMG(2)))
set(lettertxtB,'HorizontalAlignment','center','VerticalAlignment','bottom');
set(lettertxtB,'Units','Normalized');
set(lettertxtB,'Position',[0.5 1.25 0]);

if b_saveTotalFig
    saveFigure(CMGcombinedFig,     'CMGData',saveInfo.type,saveInfo.info,b_withDate,savePath)
end
end
