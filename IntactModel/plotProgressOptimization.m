function plotProgressOptimization(data)
%%
updateFigure = findobj('type','figure','Name','Optimization Parameters');
gaitKinematics = findobj('type','figure','Name','Gait Kinematics');

if isempty(updateFigure) || ~isvalid(updateFigure)
    updateFigure = figure();
    updateFigure.Name = 'Optimization Parameters';
end
if isempty(gaitKinematics) || ~isvalid(gaitKinematics)
    gaitKinematics = figure();
    gaitKinematics.Name = 'Gait Kinematics';
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
        for i = 1:numOfData
            set(0,'CurrentFigure',updateFigure)
            %     fieldnameSelect = structnames(contains(structnames,updateFigure.Children(i).Tag));
            %     set(updateFigure, 'currentaxes', updateFigure.Children(i));
            if ~isempty(updateFigure.Children) && length(findall(updateFigure,'type','axes')) == numOfData
                axesChildren = findall(updateFigure,'type','axes');
                updateProgressPlot(axesChildren(i),data.(axesChildren(i).Tag))
            else
                ax = subplot(ceil(numOfData/4),4,i); % Select correct axis
                updateProgressPlot(ax,data.(dataFieldnames{i}),dataFieldnames{i}) % update axis with new data
            end
            
        end
        drawnow;
        if (min(get(get(findall(updateFigure,'type','axes','Tag','cost'),'Children'),'Data')) == data.cost.data)
            set(0,'CurrentFigure',gaitKinematics);
            clf(gaitKinematics);
            sgtitle(['Gait kinematics for cost of ',num2str(data.cost.data)]);
            warning('off');
            plotAngularData(data.kinematics.angularData,data.kinematics.GaitPhaseData,plotInfo,GaitInfo,saveInfo,gaitKinematics);
            warning('on');
        end
        drawnow;
    else
%         disp('empty data struct');
    end
catch ME
    warning(strcat(char(ME.message)," In ", ME.stack(1).name, " line ", num2str(ME.stack(1).line)));
    %     pause(0.05);
end
drawnow;