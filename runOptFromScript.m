setup_paths;
folder2run = 'IntactModel3D';
%folder2run = 'Prosthetic3R60_3D';
disp(folder2run);
addpath(genpath(strcat(mainfolderpath,folder2run)));
cd(folder2run);
optimize;
%evaluateCost;
%
