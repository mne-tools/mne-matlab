function comp = fiff_rename_comp(one, rename_struct)

me='MNE:fiff_rename_comp';

if nargin ~= 2
    error(me,'Incorrect number of arguments');
end

comp.data.row_names = fiff_rename_list(comp.data.row_names, rename_map);
comp.data.col_names = fiff_rename_list(comp.data.col_names, rename_map);

return

end
