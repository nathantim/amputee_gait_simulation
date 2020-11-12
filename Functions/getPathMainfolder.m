function pathMain = getPathMainfolder()

outputstruct = dir('mainfolder') ;
dots = '';
idx = 1;
while isempty(outputstruct) && idx < 5
    dots = ['../',dots];
    outputstruct = dir(strcat(dots,'mainfolder'));
    idx = idx + 1;
end

pathMain = outputstruct.folder;