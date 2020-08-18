%function runOptFromScript(modelname)
setup_paths;
% modelname = 'Prosthetic3R60_2D';
addpath(genpath(strcat(mainfolderpath,modelname)));
cd(modelname);
disp(modelname);
optimize;
%evaluateCost;

%end
