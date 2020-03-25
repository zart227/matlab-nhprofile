function [CurrentFile, d] = openIonogramm (ReadDir, WorkDir, i)
d=cellstr(ls(ReadDir));
v=d(3:end);
[CurrentFile] = unzipIonogram (WorkDir,[ReadDir v{i}]);
d=cellstr(ls(WorkDir));