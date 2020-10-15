function moveAndRenameFile(oldFile,newFile)
baseOldFileParts = strsplit(oldFile,filesep);

baseNewFileParts = strsplit(newFile,filesep);
baseNewFile = baseNewFileParts{1};
for idx = 2:length(baseNewFileParts)-1
    baseNewFile = [baseNewFile filesep baseNewFileParts{idx}];
end

copyfile(oldFile, baseNewFile);
if ~strcmp(baseOldFileParts{end},baseNewFileParts{end})
    movefile([baseNewFile, filesep, baseOldFileParts{end}] , [baseNewFile, filesep, baseNewFileParts{end}])
end