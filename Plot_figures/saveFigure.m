function saveFigure(fig,name,type,info)
if nargin <= 3
    info = '';
end
dateNow = char(datestr(now,'yyyy-mm-dd_HH-MM'));
saveas(fig,char(strcat('../Plot_figures/Figures/',dateNow,'_',name,'_',info,'.',type) ));