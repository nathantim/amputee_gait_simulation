% clc;
%%
% tempstring = strsplit(opts.UserData,' ');
% dataFile = tempstring{end};
% InitialGuessFile = load(dataFile); 
% 
% Gains = InitialGuessFile.Gains.*exp(bestever.x);

%%
% load('Results/Rough/SongGainsamp.mat');
% load('Results/Flat/SongGains_02amp.mat');

% load('Results/Rough/SongGains_wC_IC.mat');
% load('Results/Rough/Umb10_1.5cm_1.2ms_Umb10_kneelim1_mstoptorque3.mat');
load('Results/Rough/Umb10_1.5cm_1.2ms_kneelim1_mstoptorque2.mat');
load('Results/Flat/SongGains_02_wC_IC.mat');

assignGains;

[groundX, groundZ, groundTheta] = generateGround('flat');
% [groundX, groundZ, groundTheta] = generateGround('const', .05,1);
%[groundX, groundZ, groundTheta] = generateGround('ramp');

dt_visual = 1/50;
setInit;
% LlegLengthClr = 0.95*LlegLengthClr;
% RGainLRFHFLsw = 5*RGainLRFHFLsw;
% RGainVRFHFLsw = 5*RGainVRFHFLsw;
% RlegLengthClr = 0.9*RlegLengthClr;
% RGainLGLUsw = 3*RGainLGLUsw;
%%
model = 'NeuromuscularModel_3R60_2D';
load_system(model);

% set_param(model,'SimulationMode','accelerator');
% set_param(model,'StopTime','30');

Vals = [LPreStimHFLst,1];
for i = 1:2
    in(i) = Simulink.SimulationInput(model);
    in(i) = in(i).setVariable('LPreStimHFLst',Vals(i));
end
%%
[inner_opt_settings,~] = setInnerOptSettings();

%%
%open('NeuromuscularModel');


% warning('off');
tic;
% out = sim(model)
out = parsim(in, 'ShowProgress', 'on');
toc;
% warning('on');

try
disp('1 Error message:')
disp(out(1).ErrorMessage)

disp('2 Error message:')
disp(out(2).ErrorMessage)
catch
end

fprintf('1 time: %d seconds\n',out(1).time(end));
fprintf('2 time: %d seconds\n',out(2).time(end));
%%
% [cost, dataStruct] = getCost(model,Gains,time,metabolicEnergy,sumOfStopTorques,HATPos,stepVelocities,stepTimes,stepLengths,inner_opt_settings,0);
% printOptInfo(dataStruct,true);
%%
% kinematics.angularData = angularData;
% kinematics.GaitPhaseData = GaitPhaseData;
% kinematics.time = time;
% kinematics.stepTimes = stepTimes;
% kinematics.musculoData = musculoData;
% kinematics.GRFData = GRFData;
% dataStruct.kinematics = kinematics;
% save('dataStruct.mat','dataStruct')
% 
% %%
% set(0, 'DefaultFigureHitTest','on');
% set(0, 'DefaultAxesHitTest','on','DefaultAxesPickableParts','all');
% set(0, 'DefaultLineHitTest','on','DefaultLinePickableParts','all');
% set(0, 'DefaultPatchHitTest','on','DefaultPatchPickableParts','all');
% set(0, 'DefaultStairHitTest','on','DefaultStairPickableParts','all');
% set(0, 'DefaultLegendHitTest','on','DefaultLegendPickableParts','all');