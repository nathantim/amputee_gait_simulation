
% 
joint = {'Hip','HipAbd','Knee','Ankle'};
proper = {'phi','phi'};
properapp = {'UpLimit','LowLimit'};
rowhead = {'$\\theta_{\\text{max}}$ (deg)', '$\\theta_{\\text{min}}$ (deg)'};

textarr = '';
for jj = 1:length(rowhead)
    textarr = [textarr, rowhead{jj}];
    for ii = 1:length(joint)
        textarr = [textarr ,' & ' , findvar(proper{jj},[joint{ii},properapp{jj}])];
    end
    if jj == length(rowhead)
        textarr = [textarr, '\n'];
    else
        textarr = [textarr, ' \\tabularnewline \n'];
    end
end

% fprintf(textarr)
filename = '../Thesis Document/tables/joint_limits.tex';
file = fopen(filename,'w');
fprintf(file,textarr);
fclose(file);

function outvar = findvar(one,two)

varname = char(strcat(one,two));
try
    outvar = 180/pi*evalin('caller',varname); % in deg
    outvar = num2str(round(outvar,2));
catch
    outvar = '-';
end
end