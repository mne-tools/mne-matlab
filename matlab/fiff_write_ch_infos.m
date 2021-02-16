function cals=fiff_write_ch_infos(fid,chs,reset_range,ch_rename)

me='MNE:fiff_write_ch_infos';

if nargin == 3
    ch_rename = {};
elseif nargin ~= 4
    error(me,'Incorrect number of arguments');
end

global FIFF;
if isempty(FIFF)
    FIFF = fiff_define_constants();
end

write_rename = false;
for k = 1:length(chs)
    %
    %   Scan numbers may have been messed up
    %
    ch = chs(k);
    ch.scanno = k;
    if reset_range
        ch.range = 1.0;
    end
    cals(k) = ch.cal;

    if length(ch_rename)
        idx = find(strcmp(ch_rename{:, 1}, ch.ch_name));
        if length(idx)
            write_rename = true;
            ch.ch_name = ch_rename{idx(1), 2};
        end
    end
    fiff_write_ch_info(fid,ch);
end

% add extra struct
if write_rename
    for k=1:length(chs)
        fiff_start_block(fid,FIFF.FIFFB_CH_INFO);
        fiff_write_string(fid,FIFF.FIFF_CH_DACQ_NAME,chs(k).ch_name);
        % XXX add more here
        fiff_end_block(fid, FIFF.FIFFB_CH_INFO)
    end
end

return;

end
