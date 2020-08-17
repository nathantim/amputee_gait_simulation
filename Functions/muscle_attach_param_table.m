
% 
muscle = {'HAB','HAD','HFL','GLU','HAM','RF','HAM','RF','VAS','BFSH','GAS','GAS','SOL','TA'};
muscleapp = {'', '', '','','h','h','k','k','','','k','a','',''};
properpre = {'r','r','r','phimax','phimin','phiref','rho'};
properapp = {'', 'max','min','','','',''};
rowhead = {'$r_{0}$ (cm)','$r_{\\text{max}}$ (cm)','$r_{\\text{min}}$ (cm)', '$\\varphi_{\\text{max}}$ (deg)',...
    '$\\varphi_{\\text{min}}$ (deg)','$\\varphi_{0}$ (deg)','$\\rho$'};

textarr = '';
for j = 1:length(rowhead)
    textarr = [textarr, rowhead{j}];
    for i = 1:length(muscle)
        textarr = [textarr ,' & ' , findvar([properpre{j}],[muscle{i}, muscleapp{i},properapp{j}])];
    end
    textarr = [textarr, ' \\tabularnewline \n'];
end

%  fprintf(textarr)
filename = '../Thesis Document/tables/muscle_attach_param.tex';
file = fopen(filename,'w');
fprintf(file,textarr);
% fprintf(file,'\\newcommand{\\%s}{\n\t',handle);
% fprintf(file,'\t%s\n}',latex_table);
fclose(file);

function outvar = findvar(one,two)

varname = char(strcat(one,two));
try
    outvar = evalin('caller',varname);
    if contains(varname,'phi')
       outvar = 180/pi*outvar;
    elseif contains(one,'r')
       outvar = 100*outvar;
    end
    outvar = num2str(outvar);
catch
    outvar = '-';
end
end