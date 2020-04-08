function plotData(angularData,musculoData,GRFData,GaitPhaseData,info,b_saveFigure,b_oneGaitPhase)
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
    b_oneGaitPhase = 1;
end
if saveInfo.b_saveFigure
    saveInfo.type = {'jpeg','eps'};
    saveInfo.info = info;
end

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
    
    selectStart = min(5,length(L_changeSwing2StanceIdx)-1);
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
    
    rightGaitPhaseEnd = length(t);
    rightGaitPhaseStart = 1;
end

%%

oneGaitinfo.start.left = leftGaitPhaseStart;
oneGaitinfo.start.right = rightGaitPhaseStart;
oneGaitinfo.end.left = leftGaitPhaseEnd;
oneGaitinfo.end.right = rightGaitPhaseEnd;
oneGaitinfo.time.left = t_left;
oneGaitinfo.time.right = t_right;
oneGaitinfo.time.left_perc = t_left_perc;
oneGaitinfo.time.right_perc = t_right_perc;

%%
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-'; '--';':'};
plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E'};
plotInfo.lineVec = plotInfo.lineVec(1:3,:);
plotInfo.colorProp = plotInfo.colorProp(1:3,:);
plotInfo.lineWidthProp = {3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];

%%
plotAngularData(angularData,GaitPhaseData,plotInfo,oneGaitinfo,saveInfo);
plotMusculoData(musculoData,plotInfo,oneGaitinfo,saveInfo);
plotGRF(GRFData,plotInfo,oneGaitinfo,saveInfo);

%
set(0, 'DefaultAxesTitleFontSizeMultiplier',1);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1);










































































































