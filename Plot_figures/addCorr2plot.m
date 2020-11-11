function addCorr2plot(b_plotCorr,plotHandlesModel,plotHandlesHuman,axesHandles,fontSize,corrPosition)
if size(corrPosition,1) ~= size(plotHandlesModel,1)
   corrPosition = repmat(corrPosition,size(plotHandlesModel,1),1);
end
if b_plotCorr 
    for ii = 1:size(plotHandlesModel,1)
        dataModel = get(plotHandlesModel(ii,1),'YData');
        dataModel = dataModel(1:2:end);
        dataHuman = get(plotHandlesHuman(ii,1),'YData');
        R = xcorr(dataHuman,dataModel,0,'normalized');
        addInfoTextFigure('',[],['R=', num2str(round(R,2))],fontSize,axesHandles(ii),0,corrPosition(ii,:),'left');
    end
end

end