function [plotHandles,axesHandles] = plotGRFData(GRFData,plotInfo,GaitInfo,saveInfo,GRFDataFigure,axesHandles,subplotStart,legToPlot,b_addTitle)
if nargin < 5
    GRFDataFigure = [];
end
if nargin < 6
    axesHandles = [];
end
if nargin < 7 || isempty(subplotStart)
    subplotStart = [1 3 1];
    setLegend = true;
else
    setLegend = false;
end
if nargin < 8
    legToPlot = 'both';
end
if nargin < 9
    b_addTitle = true;
end

t = GaitInfo.t;

%%

LGRFx = GRFData.signals.values(:,1);
LGRFy = GRFData.signals.values(:,2);
LGRFz = GRFData.signals.values(:,3);

RGRFx = GRFData.signals.values(:,4);
RGRFy = GRFData.signals.values(:,5);
RGRFz = GRFData.signals.values(:,6);

warning('Direction stuff');


[LGRFx_avg,LGRFx_sd] = interpData2perc(t,GaitInfo.tp,LGRFx,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LGRFy_avg,LGRFy_sd] = interpData2perc(t,GaitInfo.tp,LGRFy,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[LGRFz_avg,LGRFz_sd] = interpData2perc(t,GaitInfo.tp,LGRFz,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);

[RGRFx_avg,RGRFx_sd] = interpData2perc(t,GaitInfo.tp,RGRFx,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RGRFy_avg,RGRFy_sd] = interpData2perc(t,GaitInfo.tp,RGRFy,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[RGRFz_avg,RGRFz_sd] = interpData2perc(t,GaitInfo.tp,RGRFz,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

if ~plotInfo.showSD
    LGRFx_sd = [];
    LGRFy_sd = [];
    LGRFz_sd = [];
    RGRFx_sd = [];
    RGRFy_sd = [];
    RGRFz_sd = [];
end

if plotInfo.showTables
    varNames = {'LGRFx (N/kg)','RGRFx (N/kg)','LGRFy (N/kg)','RGRFy (N/kg)','LGRFz (N/kg)','RGRFz (N/kg)'};
    rangeTableGRF = createRangeTable(GaitInfo,varNames,LGRFx_avg,RGRFx_avg,LGRFy_avg,RGRFy_avg,LGRFz_avg,RGRFz_avg);
    if ~isempty(rangeTableGRF)
%         fprintf('GRF range (N/kg):\n');
        disp(rangeTableGRF);
    end
    
    LGRFx = GRFData.signals.values(:,1);
    
LGRFy = GRFData.signals.values(:,2);
LGRFz = GRFData.signals.values(:,3);

RGRFx = GRFData.signals.values(:,4);
RGRFy = GRFData.signals.values(:,5);
RGRFz = GRFData.signals.values(:,6);
    


[LGRimpxBrake,LGRimpxProp]  = getImpulse(GRFData.time,GaitInfo.start.leftV,GaitInfo.end.leftV,LGRFx);
% Medial force is positive, hence * -1
[LGRimpyBrake,LGRimpyProp]  = getImpulse(GRFData.time,GaitInfo.start.leftV,GaitInfo.end.leftV,-LGRFy);
[~,LGRimpzProp]             = getImpulse(GRFData.time,GaitInfo.start.leftV,GaitInfo.end.leftV,LGRFz);

[RGRimpxBrake,RGRimpxProp]  = getImpulse(GRFData.time,GaitInfo.start.rightV,GaitInfo.end.rightV,RGRFx);
% Medial force is positive, hence * -1
[RGRimpyBrake,RGRimpyProp]  = getImpulse(GRFData.time,GaitInfo.start.rightV,GaitInfo.end.rightV,-RGRFy);
[~,RGRimpzProp]             = getImpulse(GRFData.time,GaitInfo.start.rightV,GaitInfo.end.rightV,RGRFz);


[impxBrakestruct]   = getFilterdMean_and_ASI(LGRimpxBrake,RGRimpxBrake);
[impxPropstruct]    = getFilterdMean_and_ASI(LGRimpxProp,RGRimpxProp);
[impyBrakestruct]   = getFilterdMean_and_ASI(LGRimpyBrake,RGRimpyBrake);
[impyPropstruct]    = getFilterdMean_and_ASI(LGRimpyProp,RGRimpyProp);
[impzPropstruct]    = getFilterdMean_and_ASI(LGRimpzProp,RGRimpzProp);

    
    rowNames = {'x','y','z'};
    varNames = {'L braking impulse (N%/kg)','R braking impulse (N%/kg)', 'Braking ASI (%)', 'L prop impulse (N%/kg)','R prop impulse (N%/kg)', 'Prop ASI (%)'};%,'L mean propel impulse (N%/kg)','R mean propel impulse (N%/kg)'};
    vars = {impxBrakestruct.leftTxt, impxBrakestruct.rightTxt, impxBrakestruct.ASItxt, impxPropstruct.leftTxt, impxPropstruct.rightTxt, impxPropstruct.ASItxt; ... 
            impyBrakestruct.leftTxt, impyBrakestruct.rightTxt, impyBrakestruct.ASItxt, impyPropstruct.leftTxt, impyPropstruct.rightTxt, impyPropstruct.ASItxt; ... 
            '-', '-', '-', impzPropstruct.leftTxt, impzPropstruct.rightTxt, impzPropstruct.ASItxt};
    disp(table(vars(:,1),vars(:,2),vars(:,3),vars(:,4),vars(:,5),vars(:,6),'VariableNames',varNames,'RowNames',rowNames));
    
end

%%
if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData
    [tWinter,~, ~, ~,~,~,~, GRFz_winter_avg,GRFz_winter_sd, GRFx_winter_avg,GRFx_winter_sd, ~,~,~,~,~,~] = getWinterData(GaitInfo.WinterDataSpeed);
    if size(GRFz_winter_avg,2) > size(GRFz_winter_avg,2)
        GRFz_winter_avg = GRFz_winter_avg';
        GRFx_winter_avg = GRFx_winter_avg';
        
    end
    GRFy_winter_avg = zeros(size(GRFx_winter_avg));
    GRFy_winter_sd = [];
end

%%
plotHandlesLeft = [];
plotHandlesRight = [];

if isempty(GRFDataFigure) && isempty(axesHandles)
    GRFDataFig = figure();
    fullScreen = get(0,'screensize');
    set(GRFDataFig, 'Position',[fullScreen(1:2)+20 fullScreen(3:4)*0.9]);
else
    GRFDataFig = GRFDataFigure;
    %    clf(GRFDataFig);
end

% sgtitle('Ground Reaction Forces')

if ~GaitInfo.b_oneGaitPhase
    GaitInfo.tp = GRFData.time;
end


if contains(legToPlot,'left') || contains(legToPlot,'both')
    [plotHandlesLeft,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,GaitInfo.tp,LGRFx_avg,LGRFx_sd,LGRFy_avg,LGRFy_sd,LGRFz_avg,LGRFz_sd,subplotStart,b_addTitle);
end
if contains(legToPlot,'right') || contains(legToPlot,'both')
    if ~isempty(axesHandles)
        b_addTitle = false;
    end
    [plotHandlesRight,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,GaitInfo.tp,RGRFx_avg,RGRFx_sd,RGRFy_avg,RGRFy_sd,RGRFz_avg,RGRFz_sd,subplotStart,b_addTitle);
end
if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData
    [plotHandlesWinter,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,tWinter,GRFx_winter_avg,GRFx_winter_sd,GRFy_winter_avg,GRFy_winter_sd,GRFz_winter_avg,GRFz_winter_sd,subplotStart);
end
if setLegend
    if GaitInfo.b_oneGaitPhase
        xlabel(axesHandles(end),'gait cycle ($\%$)');
    else
        xlabel(axesHandles(end),'s');
    end
end

 plotHandles = [plotHandlesLeft, plotHandlesRight];
 
%%
for ii= 1:max(size(plotHandlesLeft,1),size(plotHandlesRight,1))
    
    set(plotHandles(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    
    if size(plotHandles,2)>2
        set(plotHandles(ii,3),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        set(plotHandles(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(1,:));
        if size(plotHandles,2)>2
            set(plotHandles(ii,4),plotInfo.fillProp,plotInfo.fillProp_entries(2,:));
        end
    end
    if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~isnan(plotHandlesWinter(ii,1))
        set(plotHandlesWinter(ii,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        if ~isnan(plotHandlesWinter(ii,2))
            set(plotHandlesWinter(ii,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
        end
    end
end

%%
if setLegend && GaitInfo.b_oneGaitPhase && contains(saveInfo.info,'prosthetic') && plotInfo.plotWinterData && contains(legToPlot,'both')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Intact leg','Prosthetic leg', 'Winter data');
    %     leg = legend('Intact leg','Prosthetic leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')) );
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~contains(legToPlot,'both')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Model', 'Winter data');
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && contains(legToPlot,'both')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Left leg','Right leg', 'Winter data');
elseif setLegend && contains(saveInfo.info,'prosthetic') && contains(legToPlot,'both')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Intact leg','Prosthetic leg');
    %     leg = legend('Intact leg','Prosthetic leg');
elseif setLegend && ~contains(legToPlot,'both')
    leg = [];
elseif setLegend && contains(legToPlot,'both')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Left leg','Right leg');
else
    leg = [];
end

if ~isempty(leg)
    set(leg,'FontSize',18);
end

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(GRFDataFig,'GRFData',saveInfo.type{j},saveInfo.info)
    end
end