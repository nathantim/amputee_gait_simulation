function muscle_exp_models = getExpenditureModels(model)

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