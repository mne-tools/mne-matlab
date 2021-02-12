function rename_struct = fiff_make_rename_struct(chs)

me='MNE:fiff_make_rename_struct';
if nargin ~= 1
    error(me,'Incorrect number of arguments');
end

rename_struct = struct();
need_rename = false;
counts = struct();
used = struct();
for k = 1:length(chs)
    if length(chs(k).ch_name) > 15
        need_rename = true;
    end
end
if ~need_rename
    return;
end

% count how many of each 15-char one we have
for k = 1:length(chs)
    short_name = chs(k).ch_name;
    short_name = short_name(1:min(length(short_name),15));
    if ~isfield(counts, short_name)
        counts = setfield(counts, short_name, 0);
        used = setfield(used, short_name, 0);
    end
    counts = setfield(counts, short_name, getfield(counts, short_name) + 1);
end
% now do the assignments, taking into account duplicates and adding -1, -2, etc
for k = 1:length(chs)
    short_name = chs(k).ch_name;
    if length(short_name) > 15
        short_name = short_name(1:15);
        n = getfield(counts, short_name);
        if n > 1
            fw = ceil(log10(n));
            n = getfield(used, short_name) + 1;
            used = setfield(used, short_name, n);
            short_name = sprintf(sprintf('%%s-%%0%dd', fw), short_name(1:15-fw-1), n);
        end
        rename_struct = setfield(rename_struct, chs(k).ch_name, short_name);
    end
end

return;
end
