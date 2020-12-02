function saveFigure(fig,name,saveType,info,b_withDate,path)
if nargin < 4
    info = '';
end
if nargin < 5 || isempty(b_withDate)
    b_withDate = true;
end
if nargin < 6 || isempty(path)
    pathMain = getPathMainfolder();
    path =  [pathMain filesep 'Plot_figures' filesep 'Figures' filesep];
    if isempty(dir(path))
        mkdir(path);
    end
end
if ~isempty(info)
   info = strrep(info,'0.9m/s','0_9ms'); 
   info = strrep(info,'1.2m/s','1_2ms'); 
   info = strrep(info,'0.9ms','0_9ms'); 
   info = strrep(info,'1.2ms','1_2ms'); 
end
if ~isempty(fig)
    oldunits = get(fig,'Units');
    set(fig, 'PaperUnits', 'centimeters', 'Units', 'centimeters');
    figpos = get(fig, 'Position');
    set(fig, 'PaperSize', figpos(3:4), 'Units', oldunits);
    
    if b_withDate
        dateNow = strcat(char(datestr(now,'yyyy-mm-dd_HH-MM')),'_');
    else
        dateNow = [];   
    end
    for ii = 1:length(saveType)
        if contains(saveType{ii},'eps')
            saveas(fig,char(strcat(path,dateNow,name,'_',info,'.',saveType{ii})), 'epsc');
        else
            saveas(fig,char(strcat(path,dateNow,name,'_',info,'.',saveType{ii})));
        end
    end
    
    close(fig)
end
