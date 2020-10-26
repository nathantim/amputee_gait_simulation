function plotGRF(GRFData,plotInfo,GaitInfo,saveInfo,GRFDataFigure,subplotStart,b_plotBothLegs)
if nargin < 5
    GRFDataFigure = [];
end
if nargin < 6 || isempty(subplotStart)
    subplotStart = 211;
    subplotStart = dec2base(subplotStart,10) - '0';
    setLegend = true;
else
    setLegend = false;
end
if nargin < 7
    b_plotBothLegs = true;
end
t = GRFData.time;
%%
t_left_perc = GaitInfo.time.left_perc;
t_right_perc = GaitInfo.time.right_perc;
GRFData.signals.values = GRFData.signals.values./getBodyMass();
% L_Ball  = GRFData.signals.values(GaitInfo.start.left:GaitInfo.end.left,1:2);
L_Total_x = GRFData.signals.values(:,1);
L_Total_z = GRFData.signals.values(:,3);
% L_Heel  = GRFData.signals.values(GaitInfo.start.left:GaitInfo.end.left,5:6);

% R_Ball  = GRFData.signals.values(GaitInfo.start.right:GaitInfo.end.right,7:8);
R_Total_x = GRFData.signals.values(:,4);
R_Total_z = GRFData.signals.values(:,6);
% R_Heel  = GRFData.signals.values(GaitInfo.start.right:GaitInfo.end.right,11:12);

warning('Direction stuff');
% L_Total_x = -1*L_Total_x;
% R_Total_x = -1*R_Total_x;
% warning('Unreasoned factor -1');

[L_Total_x_avg,L_Total_x_sd] = interpData2perc(t,GaitInfo.tp,L_Total_x,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);
[L_Total_z_avg,L_Total_z_sd] = interpData2perc(t,GaitInfo.tp,L_Total_z,GaitInfo.start.leftV,GaitInfo.end.leftV,GaitInfo.b_oneGaitPhase);

[R_Total_x_avg,R_Total_x_sd] = interpData2perc(t,GaitInfo.tp,R_Total_x,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);
[R_Total_z_avg,R_Total_z_sd] = interpData2perc(t,GaitInfo.tp,R_Total_z,GaitInfo.start.rightV,GaitInfo.end.rightV,GaitInfo.b_oneGaitPhase);

if ~plotInfo.showSD
    L_Total_x_sd = [];
    L_Total_z_sd = [];
    R_Total_x_sd = [];
    R_Total_z_sd = [];
end
if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData
    [tWinter,~, ~, ~,~,~,~, vGRF_winter_avg,vGRF_winter_sd, hGRF_winter_avg,hGRF_winter_sd, ~,~,~,~,~,~] = getWinterData(GaitInfo.WinterDataSpeed);
    if size(vGRF_winter_avg,2) > size(vGRF_winter_avg,2)
        vGRF_winter_avg = vGRF_winter_avg';
        hGRF_winter_avg = hGRF_winter_avg';
    end
end

%%
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


[plotHandlesLeft,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,[],GaitInfo.tp,L_Total_x_avg,L_Total_x_sd,L_Total_z_avg,L_Total_z_sd,GaitInfo.b_oneGaitPhase,subplotStart);
if b_plotBothLegs
    [plotHandlesRight,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,GaitInfo.tp,R_Total_x_avg,R_Total_x_sd,R_Total_z_avg,R_Total_z_sd,GaitInfo.b_oneGaitPhase,subplotStart);
end
if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData
    [plotHandlesWinter,axesHandles] = plotTotalGRFDataInFigure(GRFDataFig,axesHandles,tWinter,hGRF_winter_avg,hGRF_winter_sd,vGRF_winter_avg,vGRF_winter_sd,GaitInfo.b_oneGaitPhase,subplotStart);
end


if setLegend && GaitInfo.b_oneGaitPhase && contains(saveInfo.info,'prosthetic') && plotInfo.plotWinterData 
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Intact leg','Prosthetic leg', 'Winter data');
%     leg = legend('Intact leg','Prosthetic leg',char(strcat(string(GaitInfo.WinterDataSpeed), ' gait Winter')) );
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~b_plotBothLegs
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Model', 'Winter data');
elseif setLegend && GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData 
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1),plotHandlesWinter(2,1)],'Left leg','Right leg', 'Winter data');
elseif setLegend && contains(saveInfo.info,'prosthetic')
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Intact leg','Prosthetic leg');
%     leg = legend('Intact leg','Prosthetic leg');
elseif setLegend && ~b_plotBothLegs
    leg = [];
elseif setLegend 
    leg = legend([plotHandlesLeft(2,1),plotHandlesRight(2,1)],'Left leg','Right leg');
else
    leg = [];
end


if ~isempty(leg)
    set(leg,'FontSize',18);
end

for i= 1:size(plotHandlesLeft,1)
    set(plotHandlesLeft(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(1,:));
    if b_plotBothLegs
        set(plotHandlesRight(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(2,:));
    end
    if plotInfo.showSD && GaitInfo.b_oneGaitPhase
        set(plotHandlesLeft(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(1,:));
        if b_plotBothLegs
            set(plotHandlesRight(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(2,:));
        end
    end
    if GaitInfo.b_oneGaitPhase && plotInfo.plotWinterData && ~isnan(plotHandlesWinter(i,1)) 
        set(plotHandlesWinter(i,1),plotInfo.plotProp,plotInfo.plotProp_entries(3,:));
        set(plotHandlesWinter(i,2),plotInfo.fillProp,plotInfo.fillProp_entries(3,:));
    end
end

if saveInfo.b_saveFigure
    for j = 1:length(saveInfo.type)
        saveFigure(GRFDataFig,'GRFData',saveInfo.type{j},saveInfo.info)
    end
end