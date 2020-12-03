function plotCombinedCMGData(amputeeCMGactive,amputeeTripPrevent,initiationSteps,b_saveTotalFig)
% PLOTCOMBINEDCMGDATA Function plots the averaged CMG data during a stride and the CMG data during trip prevention
% INPUTS:
%   - amputeeCMGactive       is the simout struct that contains the CMGData of the amputee model walking with active CMG
%   - amputeeTripPrevent     is the simout struct containing the data of trip prevention smulation
%   - b_saveTotalFig         is an optional argument that lets you save the figure
% OUTPUTS:
%   -

%%
if nargin < 3
    initiationSteps = 0;
end
if nargin < 4
    b_saveTotalFig = false;
end
saveInfo = struct;
saveInfo.b_saveFigure = 0;

if 1 && b_saveTotalFig
%     savePath = '../../Thesis Document/fig/';
    savePath = '../Thesis Document/fig/';
    saveInfo.type = {'pdf'};
    b_withDate = false;
else
    savePath = [];
    b_withDate = true;
    saveInfo.type = {'jpeg','eps','emf'};
end
saveInfo.info = 'amputeeCMG1.2ms';
b_oneGaitPhase = true;
plotInfo.showSD = true;
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-';':'; '--';':'};
plotInfo.colorProp = {	'#004D82';	'#EB7F4F';'#7E2F8E';'#74A82E'};

plotInfo.lineWidthProp = {3;3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];

plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor','LineStyle'};
faceAlpha = {0.4;0.4;0.4;0.4};
plotInfo.fillVal = plotInfo.colorProp;
plotInfo.edgeVec = {'none';'none';'none';'none'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.fillProp_entries = [plotInfo.fillVal,faceAlpha,plotInfo.fillVal,plotInfo.edgeVec];
plotInfo.showTables = b_oneGaitPhase;

GaitInfoWalk = getGaitInfo(amputeeCMGactive.angularData.time,amputeeCMGactive.GaitPhaseData,amputeeCMGactive.stepTimes,true,initiationSteps,[]);
GaitInfoTrip = getGaitInfo(amputeeTripPrevent.angularData.time,amputeeTripPrevent.GaitPhaseData,amputeeTripPrevent.stepTimes,false,initiationSteps,[7 8]);

amputeeTripPrevent.GRFData.signals.values = amputeeTripPrevent.GRFData.signals.values/getBodyMass('CMG');

[collisIdx, ~] = find(amputeeTripPrevent.ObstacleForce.signals.values ~=0,1,'first');
tCollision = amputeeTripPrevent.ObstacleForce.time(collisIdx);

%%
set(0, 'DefaultAxesFontSize',16);
set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);

%%
CMGcombinedFig = figure();
CMGcombinedFig.Name = 'CMG data during walking and trip prevention';
figurePositionCMG = [50 10 750 500];
hwratio = figurePositionCMG(end)/figurePositionCMG(end-1);
set(CMGcombinedFig, 'Position',figurePositionCMG);

subplotStart = [2,4,1];
axesWalk = plotCMGData(amputeeCMGactive.CMGData,plotInfo,GaitInfoWalk,saveInfo,CMGcombinedFig,[],subplotStart,true,true,false);
subplotStart(3) = subplotStart(3)+subplotStart(2);
axesTripPrevent = plotCMGData(amputeeTripPrevent.CMGData,plotInfo,GaitInfoTrip,saveInfo,CMGcombinedFig,[],subplotStart,false,true,true,tCollision);

axesCMG = [ axesWalk,axesTripPrevent];

% Resize axes
setAxes(axesCMG,subplotStart(2),0.13,0.23, 0.07, 0.12, 0.14, hwratio,true,false);

alignYlabel([axesWalk(1),axesTripPrevent(1)]);
alignYlabel([axesWalk(2),axesTripPrevent(2)]);
alignYlabel([axesWalk(3),axesTripPrevent(3)]);
alignYlabel([axesWalk(4),axesTripPrevent(4)]);
% % Align Title and axis
% for ii = 1:2:length(axesCMG)
%     alignTitle(axesCMG(ii:ii+1));
% end


% Add figure title text and subfigure letters
% lettertxtT = text(0,0,'\underline{CMG Data}','FontSize',22,'clipping', 'off');
% set(lettertxtT,'Parent',(axesCMG(1)))
% set(lettertxtT,'HorizontalAlignment','center','VerticalAlignment','bottom');
% set(lettertxtT,'Units','Normalized');
% set(lettertxtT,'Position',[1.25 1.5 0]);

lettertxtA = text(0,0,'(a)','FontSize',20,'clipping', 'off');
set(lettertxtA,'Parent',(axesWalk(1)))
set(lettertxtA,'HorizontalAlignment','center','VerticalAlignment','bottom');
set(lettertxtA,'Units','Normalized');
set(lettertxtA,'Position',[-0.7 0.3 0]);

lettertxtB = text(0.5,0,'(b)','FontSize',20,'clipping', 'off');
set(lettertxtB,'Parent',(axesTripPrevent(1)))
set(lettertxtB,'HorizontalAlignment','center','VerticalAlignment','bottom');
set(lettertxtB,'Units','Normalized');
set(lettertxtB,'Position',[-0.7 0.3 0]);

for jj = 1:length(axesTripPrevent)
leg = get(axesTripPrevent(jj)).Legend;
    set(leg,'Units','Normalized');
    legPos(jj,:) = get(leg,'Position');
end
for jj = 1:length(axesTripPrevent)
    leg = get(axesTripPrevent(jj)).Legend;
    set(leg,'Position',[legPos(jj,1),min(legPos(:,2)),legPos(jj,3:4)]);
end
%% Plot GRF data during trip prevention
plotInfo.showSD = false;
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-';'--'};
plotInfo.colorProp = {	'#004D82';	'#EB7F4F'};

plotInfo.lineWidthProp = {3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];

plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor','LineStyle'};
faceAlpha = {0.0;0.0};
plotInfo.fillVal = plotInfo.colorProp;
plotInfo.edgeVec = {'none';'none'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.fillProp_entries = [plotInfo.edgeVec,faceAlpha,plotInfo.edgeVec,plotInfo.edgeVec];
plotInfo.showTables = false;

GRFDataFig = figure();
GRFDataFig.Name = ['Ground reaction forces data during trip'];

subplotStart = [1 3 1];
figurePositionGRF = [10,100,900,340];

hwratioGRF = figurePositionGRF(end)/figurePositionGRF(end-1);
set(GRFDataFig, 'Position',figurePositionGRF);


[plotTripPreventGRF,axesTripPreventGRF] = plotGRFData(amputeeTripPrevent.GRFData,plotInfo,GaitInfoTrip,saveInfo,GRFDataFig,[],subplotStart,'both',true);


xlabel(axesTripPreventGRF(end),'time (s) ');
axesPosGRF = setAxes(axesTripPreventGRF,subplotStart(2),0.09,0.29, 0.09, 0.12, 0.22, hwratioGRF);

if ~isempty(collisIdx)
    t_CMGPreventActive = [amputeeTripPrevent.CMGData.time( find(amputeeTripPrevent.CMGData.signals.values(:,14)~=0,1,'first')),...
                          amputeeTripPrevent.CMGData.time( find(amputeeTripPrevent.CMGData.signals.values(:,14)~=0,1,'last'))];
    for jj = 1:length(axesTripPreventGRF)
        axidx = jj;
        plotTripPreventGRF(jj,5) = plot(axesTripPreventGRF(axidx), [tCollision, tCollision], get(axesTripPreventGRF(axidx)).YLim,'--o','Color','#454545');
        plotTripPreventGRF(jj,6) = plot(axesTripPreventGRF(axidx), t_CMGPreventActive, ones(1,2)*get(axesTripPreventGRF(axidx)).YLim(2)-0.001,'-*','color','#9F9F9F','MarkerSize',12);
        h = get(axesTripPreventGRF(axidx),'children');
        set(axesTripPreventGRF(axidx),'children',[h(3:end); h(1:2)] );
    end
end

setLegend(plotTripPreventGRF(end,[1,3,5:6]),axesPosGRF(3,:),{'I','P','Col.','Act.'},18);



%% Save data if requested
if b_saveTotalFig
    saveFigure(CMGcombinedFig, 'CMGData',saveInfo.type,saveInfo.info,b_withDate,savePath)
    saveFigure(GRFDataFig, 'GRFDataTrip',saveInfo.type,saveInfo.info,b_withDate,savePath)
end
end
