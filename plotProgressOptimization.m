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
        musclesStimulation = findobj('type','figure','Name','Muscle stimulation levels');
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
        if isempty(musclesStimulation) || ~isvalid(musclesStimulation)
            musclesStimulation = figure();
            %     musclesStimulation.HitTest = 'off';
            musclesStimulation.Name = 'Muscle stimulation levels';
        end
        if isempty(GRFData) || ~isvalid(GRFData)
            GRFData = figure();
            %     GRFData.HitTest = 'off';
            GRFData.Name = 'Ground reaction forces';
        end
        if isempty(CMGData) || ~isvalid(CMGData)
            CMGData = figure();
            CMGData.Name = 'CMG data';
        end
        %%
        if isempty(minCost) || data.cost.data < minCost
            minCost = data.cost.data;
            b_minCost = true;
        else
            b_minCost = false;
        end
        %%
        plotInfo.showSD = true;
        plotInfo.plotProp = {'LineStyle','Color','LineWidth'};
        plotInfo.lineVec = {'-'; '--';':'};
        plotInfo.colorProp = {	'#0072BD';	'#D95319';'#7E2F8E'};
        plotInfo.lineVec = plotInfo.lineVec(1:3,:);
        plotInfo.colorProp = plotInfo.colorProp(1:3,:);
        plotInfo.lineWidthProp = {3;3;3};
        plotInfo.plotProp_entries = [plotInfo.lineVec(:),plotInfo.colorProp(:), plotInfo.lineWidthProp(:)];
        
        plotInfo.fillProp = {'FaceColor','FaceAlpha','EdgeColor','LineStyle'};
        faceAlpha = {0.2;0.2;0.2};
        plotInfo.fillVal = {'#0072BD';	'#D95319';'#7E2F8E'};% {[0.8 0.8 0.8],0.5,'none'};
        plotInfo.edgeVec = {':';':';':'};% {[0.8 0.8 0.8],0.5,'none'};
        plotInfo.fillProp_entries = [plotInfo.fillVal,faceAlpha,plotInfo.fillVal,plotInfo.edgeVec];
        t = data.kinematics.angularData.time;
        GaitInfo = getPartOfGaitData(1,data.kinematics.GaitPhaseData,t,data.kinematics.stepTimes);
        GaitInfo.tp = (0:0.5:100)';
        GaitInfo.b_oneGaitPhase = true;
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
            sgtitle(gaitKinematics,['Gait kinematics for cost of ',num2str(round(data.cost.data,1)),', with $v_{mean}$ = ', num2str(round(data.vMean.data,1)),'m/s','. $\tau_{stop}$ = ', num2str(data.sumTstop.data)]);
            plotAngularData(data.kinematics.angularData,data.kinematics.GaitPhaseData,plotInfo,GaitInfo,saveInfo,gaitKinematics);
                           
            clf(musclesStimulation);
            sgtitle(musclesStimulation,['Muscle stimulation levels for cost of ',num2str(round(data.cost.data,1)),', with $v_{mean}$ = ', num2str(round(data.vMean.data,1)),'m/s','. $\tau_{stop}$ = ', num2str(data.sumTstop.data)]);
            plotMusculoData(data.kinematics.musculoData,plotInfo,GaitInfo,saveInfo,musclesStimulation);
                            
            clf(GRFData);
            sgtitle(GRFData,['Ground reaction forces for cost of ',num2str(round(data.cost.data,1)),', with $v_{mean}$ = ', num2str(round(data.vMean.data,1)),'m/s','. $\tau_{stop}$ = ', num2str(data.sumTstop.data)]);
            plotGRF(data.kinematics.GRFData,plotInfo,GaitInfo,saveInfo,GRFData);
            
            clf(CMGData);
            sgtitle(CMGData,['CMG data for cost of ',num2str(round(data.cost.data,1)),', with $v_{mean}$ = ', num2str(round(data.vMean.data,1)),'m/s','. $\tau_{stop}$ = ', num2str(data.sumTstop.data)]);
            plotCMGData(data.kinematics.CMGData,saveInfo,CMGData);
 
            warning('on');
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
