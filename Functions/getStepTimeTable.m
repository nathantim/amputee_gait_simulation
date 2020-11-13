function stepTimeTable = getStepTimeTable(stepTimes,saveInfo,initiation_steps)
stepTimeASIstruct = getFilterdMean_and_ASI(findpeaks(stepTimes.signals.values(:,1)),findpeaks(stepTimes.signals.values(:,2)),initiation_steps);

rowNames = {'Step Time'};

if ~isempty(stepTimeASIstruct)
    if contains(saveInfo.info,'prosthetic') || contains(saveInfo.info,'amputee')
        varNames = {'Left (s)','Right (s)', 'ASI_s (%)'};
        vars = {stepTimeASIstruct.leftTxt, stepTimeASIstruct.rightTxt, stepTimeASIstruct.ASItxt};
        stepTimeTable = (table(vars(:,1),vars(:,2),vars(:,3),'VariableNames',varNames,'RowNames',rowNames));
    else
        varNames = {'Total (s)', 'ASI_s (%)'};
        vars = {stepTimeASIstruct.totalTxt, stepTimeASIstruct.ASItxt};
        stepTimeTable = (table(vars(:,1),vars(:,2),'VariableNames',varNames,'RowNames',rowNames));
    end
end