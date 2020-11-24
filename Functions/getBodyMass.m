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

if contains(upper(modeltype),'CMG')
    CMGParams;
    Prosthesis3R60Params;
    bodyMass = totalMassAmputee + m3R60 + CMGmass;
elseif contains(lower(modeltype),'amputee') || contains(lower(modeltype),'prosthetic') 
    Prosthesis3R60Params;
    bodyMass = totalMassAmputee + m3R60;
else
    bodyMass = totalMass;    
end