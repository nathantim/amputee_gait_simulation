function saveData(angularData,musculoData,GRFData,GaitPhaseData,info)
if nargin <= 4 
    info = '';
end

save(char(strcat('../Plot_figures/Data/',char(datestr(now,'yyyy-mm-dd_HH-MM')),'_',info,'_plotData.mat') ),'angularData','musculoData','GRFData','GaitPhaseData');