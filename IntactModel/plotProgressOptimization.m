function plotProgressOptimization(data)
%%
set(0, 'DefaultFigureHitTest','off');
set(0, 'DefaultAxesHitTest','off','DefaultAxesPickableParts','none');
set(0, 'DefaultLineHitTest','off','DefaultLinePickableParts','none');
set(0, 'DefaultPatchHitTest','off','DefaultPatchPickableParts','none');
set(0, 'DefaultStairHitTest','off','DefaultStairPickableParts','none');
set(0, 'DefaultLegendHitTest','off','DefaultLegendPickableParts','none');

%%
updateFigure = findobj('type','figure','Name','Optimization Parameters');
gaitKinematics = findobj('type','figure','Name','Gait Kinematics');
musclesStimulation = findobj('type','figure','Name','Muscle stimulation levels');
GRFData = findobj('type','figure','Name','Ground reaction forces');

if isempty(updateFigure) || ~isvalid(updateFigure)
    updateFigure = figure();
%     updateFigure.HitTest = 'off';
    updateFigure.Name = 'Optimization Parameters';
end
if isempty(gaitKinematics) || ~isvalid(gaitKinematics)
    gaitKinematics = figure();
%     gaitKinematics.HitTest = 'off';
    gaitKinematics.Name = 'Gait Kinematics';
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

try
    dataFieldnames = fieldnames(data);
    numOfData = length(dataFieldnames)-1;
    if ~isempty(dataFieldnames) && length(dataFieldnames)>4
        
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
        
        t = data.kinematics.angularData.time;
        GaitInfo = getPartOfGaitData(1,data.kinematics.GaitPhaseData,t,data.kinematics.stepTimes);
        
        saveInfo.b_saveFigure = 0;
        saveInfo.info = 'healthy';
        
        %%
        if isempty(updateFigure.Children) || (~isempty((get(get(findall(updateFigure,'type','axes','Tag','cost'),'Children'),'Data'))) ...
               && min(get(get(findall(updateFigure,'type','axes','Tag','cost'),'Children'),'Data')) >= data.cost.data  )
            minimumCost = true;
        else 
            minimumCost = false;
        end
            
        for i = 1:numOfData
            %     fieldnameSelect = structnames(contains(structnames,updateFigure.Children(i).Tag));
            %     set(updateFigure, 'currentaxes', updateFigure.Children(i));
            if ~isempty(updateFigure.Children) && length(findall(updateFigure,'type','axes')) == numOfData
                axesChildren = findall(updateFigure,'type','axes');
                updateProgressPlot(axesChildren(i),data.(axesChildren(i).Tag),[],minimumCost)
            else
                ax = subplot(ceil(numOfData/4),4,i,axes(updateFigure)); % Select correct axis
                updateProgressPlot(ax,data.(dataFieldnames{i}),dataFieldnames{i},minimumCost) % update axis with new data
            end
            
        end
        %         drawnow;
        if minimumCost

            warning('off');
            sgtitle(gaitKinematics,['Gait kinematics for cost of ',num2str(data.cost.data)]);
            plotAngularData(data.kinematics.angularData,data.kinematics.GaitPhaseData,plotInfo,GaitInfo,saveInfo,gaitKinematics);
            
            sgtitle(musclesStimulation,['Muscle stimulations for cost of ',num2str(data.cost.data)]);
            plotMusculoData(data.kinematics.musculoData,plotInfo,GaitInfo,saveInfo,musclesStimulation);
            
            sgtitle(GRFData,['Ground reaction forces for cost of ',num2str(data.cost.data)]);
            plotGRF(data.kinematics.GRFData,plotInfo,GaitInfo,saveInfo,GRFData);
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
