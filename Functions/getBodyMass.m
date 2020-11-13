function bodyMass = getBodyMass(modeltype)
% GETBODYMASS    Function that gets the mass of the model
% INPUTS:
%   - modeltype                 Type of model: healthy, amputee, CMG
%
% OUTPUTS:
%   - bodyMass                  Mass of the model

%%
if nargin < 1 || isempty(modeltype)
    modeltype = 'healthy';
end
BodyMechParams;
if contains(modeltype,'CMG')
    CMGParams;
    bodyMass = totalMassAmputee + CMGmass;
elseif contains(modeltype,'amputee') || contains(modeltype,'prosthetic') 
    bodyMass = totalMassAmputee;
else
    bodyMass = totalMass;    
end