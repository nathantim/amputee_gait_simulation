function saveFigure(fig,name,type,info,b_withDate,path)
set(fig,'PaperOrientation','landscape')
set(fig,'PaperType','a2')
if nargin < 4
    info = '';
end
if nargin < 5s
    b_withDate = true;
end

if nargin < 6 || isempty(path)
   path =  '../Plot_figures/Figures/';
end

if b_withDate
    dateNow = strcat(char(datestr(now,'yyyy-mm-dd_HH-MM')),'_');
    
else
    dateNow = [];
    
end
if contains(type,'eps')
%     addontype = 'epsc';
    saveas(fig,char(strcat(path,dateNow,name,'_',info,'.',type)), 'epsc');
else
    saveas(fig,char(strcat(path,dateNow,name,'_',info,'.',type)));
end

