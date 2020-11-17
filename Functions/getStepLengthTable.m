function stepLengthTable = getStepLengthTable(stepLengths,saveInfo,initiationSteps)
stepLengthASIstruct = getMEANandASI(findpeaks(stepLengths.signals.values(:,1)),findpeaks(stepLengths.signals.values(:,2)),initiationSteps);

rowNames = {'Step Length'};

if ~isempty(stepLengthASIstruct)
    if contains(saveInfo.info,'prosthetic') || contains(saveInfo.info,'amputee')
        varNames = {'Left (m)','Right (m)', 'ASI_s (%)'};
        vars = {stepLengthASIstruct.leftTxt, stepLengthASIstruct.rightTxt, stepLengthASIstruct.ASItxt};
        stepLengthTable = (table(vars(:,1),vars(:,2),vars(:,3),'VariableNames',varNames,'RowNames',rowNames));
    else
        varNames = {'Total (m)', 'ASI_s (%)'};
        vars = {stepLengthASIstruct.totalTxt, stepLengthASIstruct.ASItxt};
        stepLengthTable = (table(vars(:,1),vars(:,2),'VariableNames',varNames,'RowNames',rowNames));
    end
end