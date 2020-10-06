function [plotHandles,axesHandles] = plotGRF(GRFData,plotInfo,GaitInfo,saveInfo,GRFDataFigure,axesHandles,subplotStart,legToPlot,b_addTitle)
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
GRFData.signals.values = GRFData.signals.values./getBodyMass();
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
if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData
    [tWinter,~, ~, ~,~,~,~, vGRF_winter_avg,vGRF_winter_sd, hGRF_winter_avg,hGRF_winter_sd, ~,~,~,~,~,~] = getWinterData(GaitInfo.WinterDataSpeed);
    if size(vGRF_winter_avg,2) > size(vGRF_winter_avg,2)
        vGRF_winter_avg = vGRF_winter_avg';
        hGRF_winter_avg = hGRF_winter_avg';
    end
end

%%
 plotHandlesLeft = [];
 plotHandlesRight = [];

if isempty(GRFDataFigure)
    GRFDataFig = figure();
    set(GRFDataFig, 'Position',[10,50,800,600]);
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
    [plotHandlesRight,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,GaitInfo.tp,RGRFx_avg,RGRFx_sd,RGRFy_avg,RGRFy_sd,RGRFz_avg,RGRFz_sd,subplotStart,false);
end
if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData
    [plotHandlesWinter,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,tWinter,hGRF_winter_avg,hGRF_winter_sd,vGRF_winter_avg,vGRF_winter_sd,subplotStart);
end
if setLegend
    if GaitInfo.b_oneGaitPhase
        xlabel(axesHandles(end),'gait cycle ($\%$)');
    else
        xlabel(axesHandles(end),'s');
    end
end

%%
if contains(legToPlot,'both')
    plotHandles = [plotHandlesLeft, plotHandlesRight];
elseif contains(legToPlot,'left')
    plotHandles = [plotHandlesLeft, plotHandlesRight];
elseif contains(legToPlot,'right')
    plotHandles = [plotHandlesLeft, plotHandlesRight];
    
else
    error('Unknown leg');
end

    
for i= 1:max(size(plotHandlesLeft,1),size(plotHandlesRight,1))
    
    set(plotHandles(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    
    if size(plotHandles,2)>2
        set(plotHandles(i,3),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        set(plotHandles(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(1,:));
        if size(plotHandles,2)>2
            set(plotHandles(i,4),plotInfo.fillProp,plotInfo.fillProp_entries(2,:));
        end
    end
    if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~isnan(plotHandlesWinter(i,1))
        set(plotHandlesWinter(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotHandlesWinter(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
    end
end

%%
if setLegend && GaitInfo.b_oneGaitPhase && contains(saveInfo.info,'prosthetic') && plotInfo.plotWinterData 
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Intact leg','Prosthetic leg', 'Winter data');
%     leg = legend('Intact leg','Prosthetic leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')) );
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~legToPlot
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Model', 'Winter data');
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData 
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Left leg','Right leg', 'Winter data');
elseif setLegend && contains(saveInfo.info,'prosthetic')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Intact leg','Prosthetic leg');
%     leg = legend('Intact leg','Prosthetic leg');
elseif setLegend && ~legToPlot
    leg = [];
elseif setLegend 
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