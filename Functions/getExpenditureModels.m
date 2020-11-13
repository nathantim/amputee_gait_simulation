function muscleExpenditureModels = getExpenditureModels(model)

load_system(model);
muscle_energy_contents = find_system([model,'/Optimization/Muscle Energy LSOL'],'LookUnderMasks','on','FollowLinks','on','SearchDepth',1);
muscleExpenditureModels = cell(size(muscle_energy_contents));
for k = 1:length(muscle_energy_contents)
    tempString = strsplit(muscle_energy_contents{k},'/Muscle Energy ');
    if ~contains(tempString{end},'LSOL')
        muscleExpenditureModels{k} = tempString{end};
    end
end
muscleExpenditureModels = muscleExpenditureModels(cellfun(@ischar,muscleExpenditureModels(:,1)),:);