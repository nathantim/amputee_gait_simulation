outputstruct = dir('mainfolder') ;
dots = '';
i = 1;
while isempty(outputstruct) && i < 5
    dots = ['../',dots];
    outputstruct = dir(strcat(dots,'mainfolder'));
    i = i + 1;
end
mainfolderpath = outputstruct.folder;
addpath(mainfolderpath);
addpath(strcat(mainfolderpath,'/Animation'));
addpath(genpath(strcat(mainfolderpath,'/Functions')));
addpath(strcat(mainfolderpath,'/Plot_figures'));
