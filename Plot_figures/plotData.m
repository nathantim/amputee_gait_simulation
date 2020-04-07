function plotData(angularData,musculoData,GRFData,StanceData,info,b_saveFigure,b_oneGaitPhase)
%%
set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);


saveInfo = struct;
if  nargin <= 5
    saveInfo.b_saveFigure = 1;
else
    saveInfo.b_saveFigure = b_saveFigure;
end
if  nargin <= 6
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
    StanceVal = StanceData.signals.values;
    StanceChange = diff(StanceVal,1);

    [changeSwing2StanceRow, changeSwing2StanceCol] = find(StanceChange == 1);
    
    leftGaitPhaseStart = changeSwing2StanceRow(changeSwing2StanceCol==1);
    rightGaitPhaseStart = changeSwing2StanceRow(changeSwing2StanceCol==2);
    
    selectStart = 5;
    leftGaitPhaseEnd = leftGaitPhaseStart(selectStart+1);
    leftGaitPhaseStart = leftGaitPhaseStart(selectStart)+1;
    
    rightGaitPhaseEnd = rightGaitPhaseStart(selectStart+1);
    rightGaitPhaseStart = rightGaitPhaseStart(selectStart)+1;
    
    t_left = (t_left(leftGaitPhaseStart:leftGaitPhaseEnd)-t_left(leftGaitPhaseStart))./(t_left(leftGaitPhaseEnd)-t_left(leftGaitPhaseStart))*100;
    t_right = (t_right(rightGaitPhaseStart:rightGaitPhaseEnd)-t_right(rightGaitPhaseStart))./(t_right(rightGaitPhaseEnd)-t_right(rightGaitPhaseStart))*100;
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

%%
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-'; '--';':'};
plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E'};
plotInfo.lineVec = plotInfo.lineVec(1:3,:);
plotInfo.colorProp = plotInfo.colorProp(1:3,:);
plotInfo.lineWidthProp = {3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];

%%
plotAngularData(angularData,plotInfo,oneGaitinfo,saveInfo);
plotMusculoData(musculoData,plotInfo,oneGaitinfo,saveInfo);
plotGRF(GRFData,plotInfo,oneGaitinfo,saveInfo);

%
set(0, 'DefaultAxesTitleFontSizeMultiplier',1);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1);










































































































