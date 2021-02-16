function ch_rename = fiff_make_ch_rename(chs)

me='MNE:fiff_make_ch_rename';
if nargin ~= 1
    error(me,'Incorrect number of arguments');
end

ch_rename = {};
need_rename = false;
counts = containers.Map;
used = containers.Map;
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
    if ~isKey(counts, short_name)
        counts(short_name) = 0;
        used(short_name) = 0;
    end
    counts(short_name) = counts(short_name) + 1;
end
% now do the assignments, taking into account duplicates and adding -1, -2, etc
for k = 1:length(chs)
    short_name = chs(k).ch_name;
    if length(short_name) > 15
        short_name = short_name(1:15);
        n = counts(short_name);
        if n > 1
            fw = ceil(log10(n));
            n = used(short_name) + 1;
            used(short_name) = n;
            short_name = sprintf(sprintf('%%s-%%0%dd', fw), short_name(1:15-fw-1), n);
        end
        ch_rename = [ch_rename; {chs(k).ch_name, short_name}];
    end
end

return;
end
