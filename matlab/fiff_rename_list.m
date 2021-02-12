function lst = fiff_rename_list(lst, rename_struct)

me = 'MNE:fiff_rename_list';

if nargin ~= 2
    error(me,'Incorrect number of arguments');
end
if isempty(lst)
    return;
end
if ~iscell(lst)
    error(me,'input must be a cell array:%s',lst);
end

for k = 1:length(lst)
    name = lst(k);
    if isfield(rename_struct, name)
        name = rename_struct.name;
    end
    lst(k) = name;
end

return

end
