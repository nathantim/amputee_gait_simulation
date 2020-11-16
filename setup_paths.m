outputstruct = dir('mainfolder') ;
dots = '';
idx = 1;
while isempty(outputstruct) && idx < 5
    dots = ['../',dots];
    outputstruct = dir(strcat(dots,'mainfolder'));
    idx = idx + 1;
end

mainfolderpath = outputstruct.folder;

addpath(mainfolderpath);

addpath(genpath(strcat(mainfolderpath,[filesep 'Functions'])));
addpath(genpath(strcat(mainfolderpath,[filesep 'Parameter_files'])));
addpath(strcat(mainfolderpath,[filesep 'Animation']));
addpath(strcat(mainfolderpath,[filesep 'Plot_figures']));
