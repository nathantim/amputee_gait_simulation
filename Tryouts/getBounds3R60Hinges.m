function [j9_ll, j9_ul, j10_ll, j10_ul, j12_ll, j12_ul, j13_ll, j13_ul, j15_ll, j15_ul] = getBounds3R60Hinges(model)

if strcmp(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint9'),'LowerLimitSpecify'),'on')
    j9_ll = str2double(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint9'),'LowerLimitBound'));
else
    j9_ll = nan;
end
if strcmp(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint9'),'UpperLimitSpecify'),'on')
    j9_ul = str2double(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint9'),'UpperLimitBound'));
else
    j9_ul = nan;
end
if strcmp(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint10'),'LowerLimitSpecify'),'on')
    j10_ll = str2double(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint10'),'LowerLimitBound'));
else
    j10_ll = nan;
end
if strcmp(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint10'),'UpperLimitSpecify'),'on')
    j10_ul = str2double(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint10'),'UpperLimitBound'));
else
    j10_ul = nan;
end
if strcmp(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint12'),'LowerLimitSpecify'),'on')
    j12_ll = str2double(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint12'),'LowerLimitBound'));
else
    j12_ll = nan;
end
if strcmp(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint12'),'UpperLimitSpecify'),'on')
    j12_ul = str2double(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint12'),'UpperLimitBound'));
else
    j12_ul = nan;
end
if strcmp(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint13'),'LowerLimitSpecify'),'on')
    j13_ll = str2double(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint13'),'LowerLimitBound'));
else
    j13_ll = nan;
end
if strcmp(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint13'),'UpperLimitSpecify'),'on')
    j13_ul = str2double(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint13'),'UpperLimitBound'));
else
    j13_ul = nan;
end
if strcmp(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint15'),'LowerLimitSpecify'),'on')
    j15_ll = str2double(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint15'),'LowerLimitBound'));
else
    j15_ll = nan;
end
if strcmp(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint15'),'UpperLimitSpecify'),'on')
    j15_ul = str2double(get_param(strcat(model,'/stance test/Otto-bock 3R60/Revolute Joint15'),'UpperLimitBound'));
else
    j15_ul = nan;
end