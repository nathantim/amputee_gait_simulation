function plotData(angularData,musculoData,GRFData,GaitPhaseData,stepTimes,info,b_saveFigure,b_oneGaitPhase)
%%
set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);


saveInfo = struct;
if  nargin <= 6
    saveInfo.b_saveFigure = 1;
else
    saveInfo.b_saveFigure = b_saveFigure;
end
if  nargin <= 7
    b_oneGaitPhase = true;
end
if saveInfo.b_saveFigure
    saveInfo.type = {'jpeg','eps','emf'};
end
saveInfo.info = info;
t = angularData.time;
t_left = t;
t_right = t;

%%
if (b_oneGaitPhase)
    leftLegState    = GaitPhaseData.signals.values(:,1);
    rightLegState   = GaitPhaseData.signals.values(:,2);
    leftLegStateChange = diff(leftLegState);
    rightLegStateChange = diff(rightLegState);
    
    [L_changeSwing2StanceIdx] = find(leftLegStateChange == -4);
    [R_changeSwing2StanceIdx] = find(rightLegStateChange == -4);
    
    selectStart = max([ceil(1.5*(length(L_changeSwing2StanceIdx)/2)),min(1,length(L_changeSwing2StanceIdx)-1),min(1,length(R_changeSwing2StanceIdx)-1)])
    leftGaitPhaseEnd = L_changeSwing2StanceIdx(selectStart+1);
    leftGaitPhaseStart = L_changeSwing2StanceIdx(selectStart)+1;
    
    rightGaitPhaseEnd = R_changeSwing2StanceIdx(selectStart+1);
    rightGaitPhaseStart = R_changeSwing2StanceIdx(selectStart)+1;
    
    t_left = t_left(leftGaitPhaseStart:leftGaitPhaseEnd);
    t_right = t_right(rightGaitPhaseStart:rightGaitPhaseEnd);
    t_left_perc = (t_left-t_left(1))./(t_left(end)-t_left(1))*100;
    t_right_perc = (t_right-t_right(1))./(t_right(end)-t_right(1))*100;
else   
    leftGaitPhaseEnd = length(t);
    leftGaitPhaseStart = 1;
    t_left_perc = t_left;
    t_right_perc = t_right;
    rightGaitPhaseEnd = length(t);
    rightGaitPhaseStart = 1;
end

%%
GaitInfo.b_oneGaitPhase = logical(b_oneGaitPhase);
GaitInfo.start.left = leftGaitPhaseStart;
GaitInfo.start.right = rightGaitPhaseStart;
GaitInfo.end.left = leftGaitPhaseEnd;
GaitInfo.end.right = rightGaitPhaseEnd;
GaitInfo.time.left = t_left;
GaitInfo.time.right = t_right;
GaitInfo.time.left_perc = t_left_perc;
GaitInfo.time.right_perc = t_right_perc;

%%
tWinter = [1.45,1.2,0.96];
speedsWinter = {'slow','normal','fast'};
leftLegSteptimes = stepTimes(stepTimes(:,1)~=0,1);
rightLegSteptimes = stepTimes(stepTimes(:,2)~=0,2);
meanStepTime = mean([mean(leftLegSteptimes),mean(rightLegSteptimes)]);
% speed2select = find(abs(tWinter - meanStepTime) == min(abs(tWinter - meanStepTime)));
GaitInfo.WinterDataSpeed = speedsWinter{abs(tWinter - meanStepTime) == min(abs(tWinter - meanStepTime))};

%%
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-'; '--';':'};
plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E'};
plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor'};
plotInfo.fillVal = {[0.8 0.8 0.8],0.9,'none'};
plotInfo.lineVec = plotInfo.lineVec(1:3,:);
plotInfo.colorProp = plotInfo.colorProp(1:3,:);
plotInfo.lineWidthProp = {3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];

%%
plotAngularData(angularData,GaitPhaseData,plotInfo,GaitInfo,saveInfo);
% plotMusculoData(musculoData,plotInfo,GaitInfo,saveInfo);
plotGRF(GRFData,plotInfo,GaitInfo,saveInfo);

%
set(0, 'DefaultAxesTitleFontSizeMultiplier',1);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1);










































































































