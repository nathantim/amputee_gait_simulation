function plotProgressOptimization(data)
global minCost;

%%
set(0, 'DefaultFigureHitTest','off');
set(0, 'DefaultAxesHitTest','off','DefaultAxesPickableParts','none');
set(0, 'DefaultLineHitTest','off','DefaultLinePickableParts','none');
set(0, 'DefaultPatchHitTest','off','DefaultPatchPickableParts','none');
set(0, 'DefaultStairHitTest','off','DefaultStairPickableParts','none');
set(0, 'DefaultLegendHitTest','off','DefaultLegendPickableParts','none');

%%
try
    dataFieldnames = fieldnames(data);
    %     numOfData = length(dataFieldnames)-1;
    %%
    if ~isempty(dataFieldnames) && length(dataFieldnames)>4 && data.timeCost.data == 0
        % updateFigure = findobj('type','figure','Name','Optimization Parameters');
        gaitKinematics = findobj('type','figure','Name','Gait Kinematics');
        musclesActivation = findobj('type','figure','Name','Muscle activation levels');
        GRFData = findobj('type','figure','Name','Ground reaction forces');
        CMGData = findobj('type','figure','Name','CMG data');
        
        % if isempty(updateFigure) || ~isvalid(updateFigure)
        %     updateFigure = figure();
        % %     updateFigure.HitTest = 'off';
        %     updateFigure.Name = 'Optimization Parameters';
        % end
        if isempty(gaitKinematics) || ~isvalid(gaitKinematics)
            gaitKinematics = figure();
            %     gaitKinematics.HitTest = 'off';
            gaitKinematics.Name = 'Gait Kinematics';
            minCost = inf;
        end
        if isempty(musclesActivation) || ~isvalid(musclesActivation)
            musclesActivation = figure();
            %     musclesStimulation.HitTest = 'off';
            musclesActivation.Name = 'Muscle activation levels';
        end
        if isempty(GRFData) || ~isvalid(GRFData)
            GRFData = figure();
            %     GRFData.HitTest = 'off';
            GRFData.Name = 'Ground reaction forces';
        end
        if (isempty(CMGData) || ~isvalid(CMGData) ) && size(data.kinematics.CMGData.signals.values,1)>1
            CMGData = figure();
            CMGData.Name = 'CMG data';
        else
            CMGData = [];
        end
        %%
        if isempty(minCost) || data.optimCost < minCost
            minCost = data.optimCost;
            b_minCost = true;
        else
            b_minCost = false;
        end
        %%
        b_oneGaitPhase = true;
        plotInfo.showSD = true;
        plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
        plotInfo.lineVec = {'-'; '--';':'};
        plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E'};
        plotInfo.lineVec = plotInfo.lineVec(1:3,:);
        plotInfo.colorProp = plotInfo.colorProp(1:3,:);
        plotInfo.lineWidthProp = {3;3;3};
        plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];
        plotInfo.plotWinterData = true;
        
        plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor','LineStyle'};
        faceAlpha = {0.2;0.2;0.2};
        plotInfo.fillVal = {'#0072BD';	'#D95319';'#7E2F8E'};% {[0.8 0.8 0.8],0.5,'none'};
        plotInfo.edgeVec = {':';':';':'};% {[0.8 0.8 0.8],0.5,'none'};
        plotInfo.fillProp_entries = [plotInfo.fillVal,faceAlpha,plotInfo.fillVal,plotInfo.edgeVec];
        t = data.kinematics.angularData.time;
        GaitInfo = getPartOfGaitData(b_oneGaitPhase,data.kinematics.GaitPhaseData,t,data.kinematics.stepTimes);
        
        saveInfo.b_saveFigure = 0;
        saveInfo.info = data.modelType;
        
        %%
        %         for i = 1:numOfData
        %             %     fieldnameSelect = structnames(contains(structnames,updateFigure.Children(i).Tag));
        %             %     set(updateFigure, 'currentaxes', updateFigure.Children(i));
        %             if ~isempty(updateFigure.Children) && length(findall(updateFigure,'type','axes')) == numOfData
        %                 axesChildren = findall(updateFigure,'type','axes');
        %                 updateProgressPlot(axesChildren(i),data.(axesChildren(i).Tag),[],b_minCost)
        %             else
        %                 ax = subplot(ceil(numOfData/4),4,i,axes(updateFigure)); % Select correct axis
        %                 updateProgressPlot(ax,data.(dataFieldnames{i}),dataFieldnames{i},b_minCost) % update axis with new data
        %             end
        %
        %         end
        %         drawnow;
        if b_minCost
            
            warning('off');
            
            clf(gaitKinematics);
            sgtitle(gaitKinematics,['Gait kinematics for cost of ',num2str(round(data.optimCost,1)),', with $v_{mean}$ = ', num2str(round(data.vMean.data,1)),'m/s','. $\tau_{stop}$ = ', num2str(data.sumTstop.data)]);
            [~,axesAngle] = plotAngularData(data.kinematics.angularData,plotInfo,GaitInfo,saveInfo,gaitKinematics);
            
            clf(musclesActivation);
            sgtitle(musclesActivation,['Muscle activation levels for cost of ',num2str(round(data.optimCost,1)),', with $v_{mean}$ = ', num2str(round(data.vMean.data,1)),'m/s','. $\tau_{stop}$ = ', num2str(data.sumTstop.data)]);
            [plotMusc,axesMusc] = plotMusculoData(data.kinematics.musculoData,plotInfo,GaitInfo,saveInfo,musclesActivation);
            
            clf(GRFData);
            sgtitle(GRFData,['Ground reaction forces for cost of ',num2str(round(data.optimCost,1)),', with $v_{mean}$ = ', num2str(round(data.vMean.data,1)),'m/s','. $\tau_{stop}$ = ', num2str(data.sumTstop.data)]);
            [~,axesGRF] = plotGRFData(data.kinematics.GRFData,plotInfo,GaitInfo,saveInfo,GRFData);
            warning('on');
            
            if ~isempty(CMGData)
                clf(CMGData);
                sgtitle(CMGData,['CMG data for cost of ',num2str(round(data.optimCost,1)),', with $v_{mean}$ = ', num2str(round(data.vMean.data,1)),'m/s','. $\tau_{stop}$ = ', num2str(data.sumTstop.data)]);
                plotCMGData(data.kinematics.CMGData,saveInfo,CMGData,false);
            end
            
            if plotInfo.plotFukuchiData && b_oneGaitPhase
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
                plotInfoTemp.plotProp_entries = plotInfoTemp.plotProp_entries(end,:);
                GaitInfoFukuchi = getPartOfGaitData(false,[],FukuchiData2Plot.angularData.time,[]);
                [plotAngleFukuchi,~] = plotAngularData(FukuchiData2Plot.angularData,plotInfoTemp,GaitInfoFukuchi,saveInfo,[],axesAngle,[],'right');
                set(plotAngleFukuchi(2,1),'DisplayName','Fukuchi');
%                 [plotTorqueFukuchi,~] = plotJointTorqueData(FukuchiData2Plot.jointTorquesData,plotInfoTemp,GaitInfoFukuchi,saveInfo,[],axesTorque,[],'right');
                [plotGRFFukuchi,~] = plotGRFData(FukuchiData2Plot.GRFData,plotInfoTemp,GaitInfoFukuchi,saveInfo,[],axesGRF,[],'right');
                set(plotAngleFukuchi(2,1),'DisplayName','Fukuchi');
%                 set(plotTorqueFukuchi(2,1),'DisplayName','Fukuchi');
                set(plotGRFFukuchi(2,1),'DisplayName','Fukuchi');
            end
        end
        %         drawnow;
    else
        %         disp('empty data struct');
    end
    
    drawnow;
catch ME
    warning(strcat(char(ME.message)," In ", ME.stack(1).name, " line ", num2str(ME.stack(1).line)));
    %     pause(0.05);
end
