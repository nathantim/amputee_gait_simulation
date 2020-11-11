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

addpath(genpath(strcat(mainfolderpath,'/Functions')));
addpath(genpath(strcat(mainfolderpath,'/Parameter_files')));
addpath(strcat(mainfolderpath,'/Animation'));
addpath(strcat(mainfolderpath,'/Plot_figures'));
