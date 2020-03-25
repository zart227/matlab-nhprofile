function z=finddate(c,str)
z=find(~cellfun('isempty',strfind(c,str)));