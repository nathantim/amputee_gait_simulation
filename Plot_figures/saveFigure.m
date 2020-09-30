function saveFigure(fig,name,type,info,b_withDate,path)
set(fig,'PaperOrientation','landscape')
set(fig,'PaperType','a2')
if nargin < 4
    info = '';
end
if nargin < 5
    b_withDate = true;
end
if contains(type,'eps')
    addontype = 'epsc';
else
    addontype = '';
end
if nargin < 6 || isempty(path)
   path =  '../Plot_figures/Figures/';
end

if b_withDate
    dateNow = char(datestr(now,'yyyy-mm-dd_HH-MM'));
    saveas(fig,char(strcat(path,name,dateNow,'_',name,'_',info,'.',type) ),addontype);
else
    saveas(fig,char(strcat(path,name,'_',info,'.',type) ),addontype);
end
