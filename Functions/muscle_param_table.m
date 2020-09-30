
% 
muscle = {'HAB','HAD','HFL','GLU','HAM','RF','VAS','BFSH','GAS','SOL','TA','HAB','HAD','HFL','GLU','HAM','RF'};
muscleapp = {'', '', '','','','','','','','','','amp','amp','amp','amp','amp','amp'};
proper = {'Fmax','vmax','lopt','lslack','FT_'};
% properapp = {'', 'max','min','','','',''};
rowhead = {'$F_{\\mathrm{max}} (\\unit{kN})$', '$v_{\\mathrm{max}} (\\unit{\\ell_{\\mathrm{opt}}/s})$', ...
    '$\\ell_{\\mathrm{opt}} (\\unit{cm})$', '$\\ell_{\\mathrm{slack}} (\\unit{cm})$', 'FT $(\\unit{\\%%})$'};

textarr = '';
for j = 1:length(rowhead)
    textarr = [textarr, rowhead{j}];
    for i = 1:length(muscle)
        textarr = [textarr ,' & ' , findvar(proper{j},[muscle{i},muscleapp{i}])];
    end
    textarr = [textarr, ' \\tabularnewline \n'];
end

% fprintf(textarr)
filename = '../Thesis Document/tables/muscle_param.tex';
file = fopen(filename,'w');
fprintf(file,textarr);
fclose(file);

function outvar = findvar(one,two)

varname = char(strcat(one,two));
try
    outvar = evalin('caller',varname);
    if contains(one,'Fmax')
       outvar = 1/1000*outvar;
    elseif contains(one,'l')
       outvar = 100*outvar;
    end
    outvar = num2str(round(outvar,2));
catch
    outvar = '-';
end
end