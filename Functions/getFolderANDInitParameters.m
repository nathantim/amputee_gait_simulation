function [Gains, initAnglesFile, Folder] = getFolderANDInitParameters(model)
if contains(model,'3R60') && contains(model,'3D')
    Folder = 'Prosthetic3R60_3D';
elseif contains(model,'3R60') && contains(model,'2D')
    Folder = 'Prosthetic3R60';
elseif contains(model,'healthy') && contains(model,'3D')
    Folder = 'IntactModel3D';
elseif contains(model,'healthy') && contains(model,'2D')
    Folder = 'IntactModel';
else
    error('Unknown model type');
end
    