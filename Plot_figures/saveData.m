function saveData(animData,Gains,angularData,musculoData,GRFData,GaitPhaseData,stepTimes,stepLengths,info)
if nargin <= 8 
    info = '';
end

save(char(strcat('../Plot_figures/Data/',char(datestr(now,'yyyy-mm-dd_HH-MM')),'_',info,'_plotData.mat') ),'animData','Gains','angularData', ...
        'musculoData','GRFData','GaitPhaseData','stepTimes','stepLengths');