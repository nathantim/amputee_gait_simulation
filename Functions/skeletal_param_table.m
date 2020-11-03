
% 
segment = {'hat','thigh','thigh','shank','shank','foot','foot'};
segmentapp = {'','','Amp','','Prosth','','Prosth'};
% properpre = {'r','r','r','phimax','phimin','phiref','rho'};
properapp = {'Mass', 'Length', 'Inertia'};%,'',''};
rowhead = {'mass ($\\unit{kg}$)','Length ($\\unit{m}$)','Moment of inertia ($\\unit{kg\\cdot m^2}$)'};%, 'Center of Mass'};

textarr = '';
for jj = 1:length(rowhead)
    textarr = [textarr, rowhead{jj}];
    for ii = 1:length(segment)
        textarr = [textarr ,' & ' , findvar([segment{ii}, segmentapp{ii},properapp{jj}])];
    end
    if jj == length(rowhead)
        textarr = [textarr, '\n'];
    else
        textarr = [textarr, ' \\tabularnewline \n'];
    end
end

%  fprintf(textarr)
filename = '../Thesis Document/tables/skeletal_param.tex';
file = fopen(filename,'w');
fprintf(file,textarr);
fclose(file);

function outvar = findvar(one)

varname = char(strcat(one));
try
    outvar = evalin('caller',varname);
    if contains(varname,'Inertia')
        outvarmatrix = "$\\begin{bmatrix}";
        for ii = 1:length(outvar)
            outvarmatrix = [outvarmatrix, (num2str(outvar(ii)))];
            if ii ~= length(outvar)
                outvarmatrix = [outvarmatrix, '\\\\'];
            end
            
        end
        outvarmatrix = [outvarmatrix, "\\end{bmatrix}$"];
        outvarmatrix = [outvarmatrix{:}];
        outvar = outvarmatrix;
    else
        outvar = num2str(outvar);
    end
    outvar = char(outvar);
catch
    outvar = '-';
end
end