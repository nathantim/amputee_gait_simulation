function plotData(varargin)
% PLOTDATA                          Function that plots the data simulation
%
% INPUTS:
%   - varargin                      Variable inputs can be given, which will result in affecting the plot, or adding plots etc
%                                   Use: 
%                                   plotData(GaitPhaseData,stepTimes,'nameVarArgin1',<value/data varargin1> ,'nameVarArgin2',<value/data varargin2>)
%                                   Required varargin:
%                                   - 'GaitPhaseData': structure with the gait phase data from the simulation 
%                                   - 'stepTimes': structure with the step time data from simulation.
%                                   Optional varargin:
%                                   - 'angularData': structure with time with angular data from simulation  
%                                   - 'musculoData': structure with time with muscular data from simulation 
%                                   - 'GRFData': structure with time with GRF data from simulation 
%                                   - 'jointTorquesData': structure with time with joint torque data from simulation 
%                                   - 'CMGData': structure with time with CMG data from simulation 
%                                   - 'saveFigure': bool for saving figure, default: false
%                                   - 'showAverageStride': bool for showing data averaged per stride, default: true
%                                   - 'showSD': bool for showing std data per stride, default: true
%                                   - 'showFukuchi': bool for showing Fukuchi data, default: false
%                                   - 'info': char with information that can be added to figure saved file name
%                                   - 'timeInterval': time interval over which to show the data
% 
%   - amputeeCMGNotActiveData       Optional, structure with the data from amputee gait with inactive CMG simulation.
%   - amputeeCMGActiveData          Optional, Structure with the data from amputee gait with active CMG simulation.
%   - info                          Optional, info which can be added to the saved file name of the figure
%   - b_saveTotalFig                Optional, select whether to save the figure or not, default is false
%
% OUTPUTS:
%   -
%%
%%%%%%%%%%%%%%%%%%%%
% Parse Argmuments %
%%%%%%%%%%%%%%%%%%%%

persistent p
if isempty(p)
    p = inputParser;
    p.FunctionName = 'plotData';
    addRequired(p,'GaitPhaseData');
    addRequired(p,'stepTimes');
    
    validDataStructFcn = @(ii) isstruct(ii) && max(contains(fieldnames(ii),'time'));
    addParameter(p,'angularData',      [],validDataStructFcn);
    addParameter(p,'musculoData',      [],validDataStructFcn);
    addParameter(p,'GRFData',          [],validDataStructFcn);
    addParameter(p,'jointTorquesData', [],validDataStructFcn);
    addParameter(p,'CMGData',          [],validDataStructFcn);
    
    validBoolFcn = @(ii) islogical(ii) && isscalar(ii);
    addParameter(p,'saveFigure',       false,validBoolFcn);
    addParameter(p,'showAverageStride',true,validBoolFcn);
    addParameter(p,'showSD',           true,validBoolFcn);
    addParameter(p,'showFukuchi',      false,validBoolFcn);
    
    validCharFcn = @(ii) ischar(ii);
    addParameter(p,'info','',validCharFcn);
    
    validVector2Fcn = @(ii) max(size(ii))==2 && min(size(ii))==1;
    addParameter(p,'timeInterval',[],validVector2Fcn);
    
    validIntegerFcn = @(ii) isinteger(ii);
    addParameter(p,'initiationSteps',   5,                  validIntegerFcn);
end

parse(p,varargin{:});
GaitPhaseData           = p.Results.GaitPhaseData;
stepTimes               = p.Results.stepTimes;
angularData             = p.Results.angularData;
musculoData             = p.Results.musculoData;
GRFData                 = p.Results.GRFData;
jointTorquesData        = p.Results.jointTorquesData;
CMGData                 = p.Results.CMGData;
info                    = p.Results.info;
timeInterval            = p.Results.timeInterval;
saveInfo.b_saveFigure   = p.Results.saveFigure;
plotFukuchiData         = p.Results.showFukuchi;
showSD                  = p.Results.showSD;
b_oneGaitPhase          = p.Results.showAverageStride;
initiationSteps         = p.Results.initiationSteps;

%%
set(0, 'DefaultAxesFontSize',16);
set(0, 'DefaultAxesTitleFontSizeMultiplier',1.5);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1.5);
set(0, 'DefaultFigureHitTest','on');
set(0, 'DefaultAxesHitTest','on','DefaultAxesPickableParts','all');
set(0, 'DefaultLineHitTest','on','DefaultLinePickableParts','all');
set(0, 'DefaultPatchHitTest','on','DefaultPatchPickableParts','all');
set(0, 'DefaultStairHitTest','on','DefaultStairPickableParts','all');
set(0, 'DefaultLegendHitTest','on','DefaultLegendPickableParts','all');

if saveInfo.b_saveFigure
    saveInfo.type = {'jpeg','eps','emf'};
end
saveInfo.info = info;
t = GaitPhaseData.time;

GaitInfo = getGaitInfo(t,GaitPhaseData,stepTimes,b_oneGaitPhase,initiationSteps,timeInterval);

axesState = [];
axesAngle = [];
axesTorque = [];
axesPower = [];
axesMusc = [];
axesGRF = [];

%%
plotInfo.showSD = showSD;%true;
plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
plotInfo.lineVec = {'-'; '--';':'};
plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E'};
plotInfo.lineVec = plotInfo.lineVec(1:3,:);
plotInfo.colorProp = plotInfo.colorProp(1:3,:);
plotInfo.lineWidthProp = {3;3;3};
plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];
plotInfo.plotWinterData = false;
plotInfo.plotFukuchiData = plotFukuchiData;

plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor','LineStyle'};
faceAlpha = {0.2;0.2;0.2};
plotInfo.fillVal = {'#0072BD';	'#D95319';'#7E2F8E'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.edgeVec = {':';':';':'};% {[0.8 0.8 0.8],0.5,'none'};
plotInfo.fillProp_entries = [plotInfo.fillVal,faceAlpha,plotInfo.fillVal,plotInfo.edgeVec];
plotInfo.showTables = true;

%%
if ~isempty(GRFData)
    GRFData.signals.values = GRFData.signals.values./getBodyMass(saveInfo.info);
end
if ~isempty(jointTorquesData)
    jointTorquesData.signals.values = jointTorquesData.signals.values./getBodyMass(saveInfo.info);
end

%%
% plotLegState(GaitPhaseData,plotInfo,GaitInfo,saveInfo);

if ~isempty(angularData)
    [~,axesAngle] = plotAngularData(angularData,plotInfo,GaitInfo,saveInfo,[]);
end
if ~isempty(jointTorquesData)
    [~,axesTorque] = plotJointTorqueData(jointTorquesData,plotInfo,GaitInfo,saveInfo,[]);
end
if ~isempty(angularData) && ~isempty(jointTorquesData)
    plotJointPowerData(angularData,jointTorquesData,plotInfo,GaitInfo,saveInfo,[]);
end
if ~isempty(musculoData)
    plotMusculoData(musculoData,plotInfo,GaitInfo,saveInfo);
end
if ~isempty(GRFData)
    [~,axesGRF] = plotGRFData(GRFData,plotInfo,GaitInfo,saveInfo,[]);
end
if ~isempty(CMGData)
    plotCMGData(CMGData,plotInfo,GaitInfo,saveInfo,[]);
end

try
    if plotInfo.plotFukuchiData && b_oneGaitPhase
        disp('Fukuchi Data');
        FukuchiData = load('../Plot_figures/Data/FukuchiData.mat','gaitData');
        fieldNames = fieldnames(FukuchiData.gaitData);
        
        if contains(saveInfo.info,'0.5ms')
            FukuchiData2Plot = FukuchiData.gaitData.(fieldNames{contains(fieldNames,'0_5')});
        elseif contains(saveInfo.info,'0.9ms')
            FukuchiData2Plot = FukuchiData.gaitData.(fieldNames{contains(fieldNames,'0_9')});
        elseif contains(saveInfo.info,'1.2ms')
            FukuchiData2Plot = FukuchiData.gaitData.(fieldNames{contains(fieldNames,'1_2')});
        else
            warning('Unknown velocity')
        end
        plotInfoTemp = plotInfo;
        plotInfoTemp.showTables = false;
        plotInfoTemp.plotProp_entries = plotInfoTemp.plotProp_entries(end,:);
        GaitInfoFukuchi = getGaitInfo(FukuchiData2Plot.angularData.time,[],[],saveInfo,false);
        if ~isempty(axesAngle)
            [plotAngleFukuchi,~] = plotAngularData(FukuchiData2Plot.angularData,plotInfoTemp,GaitInfoFukuchi,saveInfo,[],axesAngle,[1 4 1],'right');
            set(plotAngleFukuchi(2,1),'DisplayName','Fukuchi');
        end
        if ~isempty(axesTorque)
            [plotTorqueFukuchi,~] = plotJointTorqueData(FukuchiData2Plot.jointTorquesData,plotInfoTemp,GaitInfoFukuchi,saveInfo,[],axesTorque,[1 4 1],'right');
            set(plotTorqueFukuchi(2,1),'DisplayName','Fukuchi');
        end
        if ~isempty(axesGRF)
            [plotGRFFukuchi,~] = plotGRFData(FukuchiData2Plot.GRFData,plotInfoTemp,GaitInfoFukuchi,saveInfo,[],axesGRF,[1 3 1],'right');
            set(plotGRFFukuchi(2,1),'DisplayName','Fukuchi');
        end
        
    end
catch ME
    warning(ME.message);
    
end


%
set(0, 'DefaultAxesFontSize',15);
set(0, 'DefaultAxesTitleFontSizeMultiplier',1);
set(0, 'DefaultAxesLabelFontSizeMultiplier',1);

