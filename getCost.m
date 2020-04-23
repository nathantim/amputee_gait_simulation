function cost = getCost(model,Gains,time,metabolicEnergy,sumOfIdealTorques,sumOfStopTorques,HATPos,swingStateCounts,stepVelocities,stepTimes,stepLengths, b_isParallel)
if nargin < 12
    b_isParallel = 0;
end
OptimParams;

if HATPos > 101
    cost = nan;
    disp('HATPos > 101')
    return
elseif HATPos < 0
    cost = nan;
    disp('HATPos < 0')
    return
elseif any(metabolicEnergy < 0)
    cost = nan;
    disp('Metabolic Energy < 0')
    return
elseif ( min(size(stepVelocities)) == 0 || min(size(stepTimes)) == 0 || size(stepVelocities,2) ~= 2 || size(stepTimes,2) ~= 2 || ...
        min(size(stepVelocities(stepVelocities~=0))) == 0 ||  min(size(stepTimes(stepTimes~=0))) == 0)
    cost = nan;
    disp('No steps')
    return
end

%%
tic;
load_system(model);
muscle_energy_contents = find_system([model,'/Optimization/Muscle Energy LSOL'],'LookUnderMasks','on','FollowLinks','on','SearchDepth',1);
muscle_exp_models = cell(size(muscle_energy_contents));
for k = 1:length(muscle_energy_contents)
    tempString = strsplit(muscle_energy_contents{k},'/Muscle Energy ');
    if ~contains(tempString{end},'LSOL')
        muscle_exp_models{k} = tempString{end};
    end
end
muscle_exp_models = muscle_exp_models(cellfun(@ischar,muscle_exp_models(:,1)),:);
toc; 

%% Calculate cost of transport
amputeeMass = 80; % kg
effort_costs = struct;

for i = 1:length(muscle_exp_models)
   effort_costs(i).name = (muscle_exp_models{i});
   effort_costs(i).metabolicEnergy = metabolicEnergy(:,i);
   effort_costs(i).costOfTransport = (metabolicEnergy(:,i) + 0.1*sumOfIdealTorques + .01*sumOfStopTorques)/(HATPos*amputeeMass);
end

% Decide which to use for optimization
costOfTransportForOpt =  effort_costs(contains(muscle_exp_models,'Umberger (2010)')).costOfTransport; 

%% Calculate time cost
timeSetToRun = str2double(get_param(model,'StopTime'));
timeCost = round(timeSetToRun/time,3)-1;
if timeCost < 0
    timeCost = 0;
end

%% Calculate velocity cost
velCost = getVelMeasure(stepVelocities(:,1),stepTimes(:,1),min_velocity,max_velocity,initiation_steps) + ...
    getVelMeasure(stepVelocities(:,2),stepTimes(:,2),min_velocity,max_velocity,initiation_steps);

%     [distCost, dist_covered] = getDistMeasure(timeSetToRun,stepLengths,min_velocity,max_velocity,dist_slack);

%% Calculate step info
[meanStepLength, ASIStepLength] = getFilterdMean_and_ASI(stepLengths(:,1),stepLengths(:,2),initiation_steps);
[meanStepTime, ASIStepTime] = getFilterdMean_and_ASI(stepTimes(:,1),stepTimes(:,2),initiation_steps);
[meanVel, ASIVel] = getFilterdMean_and_ASI(stepVelocities(:,1),stepVelocities(:,2),initiation_steps);

%%
%     cost = 100000*timeCost  + 1000*(velCost + 0*distCost) + 0.1*costOfTransport;
cost = 100000*timeCost  + 1000*(velCost) + 100*costOfTransportForOpt;

if length(cost) ~= 1
    disp(cost);
    warning('Size cost is not 1');
end
fprintf('-- <strong> t_sim: %2.2f</strong>, Cost: %2.2f, E_m (Wang): %.0f, E_m(Umb10): %.0f, <strong>avg v_step: %2.2f</strong>, avg t_step: %1.2f, avg l_step: %1.2f, ASI l_step: %2.2f, ASI t_step: %2.2f, timeCost: %2.2f, velCost: %2.2f --\n',...
    time, cost, effort_costs(contains(muscle_exp_models,'Wang')).metabolicEnergy, effort_costs(contains(muscle_exp_models,'Umberger (2010)')).metabolicEnergy,...
    meanVel, meanStepTime, meanStepLength,round(ASIStepLength,2),round(ASIStepTime,2), timeCost, velCost);

%% Save when optimizing
if b_isParallel && timeCost == 0
%     try
GainsSave = Gains;
if size(GainsSave,1)>size(GainsSave,2)
   GainsSave = GainsSave'; 
end
        filename = char(strcat('compareEnergyCost',num2str(getCurrentWorker().ProcessId),'.mat'));
        if exist(filename,'file') == 2
            exist_vars = load(filename);
            metabolicEnergySave     = [exist_vars.metabolicEnergySave;metabolicEnergy];
            meanVel                 = [exist_vars.meanVel;meanVel];
            meanStepTime            = [exist_vars.meanStepTime;meanStepTime];
            meanStepLength          = [exist_vars.meanStepLength;meanStepLength];
            ASIStepLength           = [exist_vars.ASIStepLength;ASIStepLength];
            ASIStepTime             = [exist_vars.ASIStepTime;ASIStepTime];
            ASIVel                  = [exist_vars.ASIVel;ASIVel];
            costOfTransportSave     = [exist_vars.costOfTransportSave;costOfTransport];
            costT                   = [exist_vars.costT;cost];
            sumOfIdealTorques       = [exist_vars.sumOfIdealTorques;sumOfIdealTorques];
            sumOfStopTorques        = [exist_vars.sumOfStopTorques;sumOfStopTorques];
            HATPos                  = [exist_vars.HATPos;HATPos];
            GainsSave               = [exist_vars.GainsSave;GainsSave];
        else 
            costT = cost;
        end
        
        save(filename,'metabolicEnergySave','meanVel','meanStepTime', 'meanStepLength','costOfTransportSave', ...
            'costT','sumOfIdealTorques','sumOfStopTorques','HATPos','GainsSave','ASIStepLength','ASIStepTime','ASIVel')
end