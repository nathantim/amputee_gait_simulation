function saveFigure(fig,name,saveType,info,b_withDate,path)
if ~isempty(fig)
    set(fig,'PaperOrientation','landscape')
    set(fig,'PaperType','a2')
    if nargin < 4
        info = '';
    end
    if nargin < 5
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
    for ii = 1:length(saveType)
        if contains(saveType{ii},'eps')
            %     addontype = 'epsc';
            saveas(fig,char(strcat(path,dateNow,name,'_',info,'.',saveType{ii})), 'epsc');
        else
            saveas(fig,char(strcat(path,dateNow,name,'_',info,'.',saveType{ii})));
        end
    end
    
    close(fig)
end
