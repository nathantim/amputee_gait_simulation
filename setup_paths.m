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
try
    addpath(strcat(mainfolderpath,'/Animation3D'));
    addpath(strcat(mainfolderpath,'/Plot_figures'));
catch
end
