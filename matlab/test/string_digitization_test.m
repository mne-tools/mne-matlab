
%% FIFF file name
% fname = 'data/old_megin_data_raw_5s.fif'; % old file
fname = 'data/raw_data_tsss_mc.fif'; % new file

%% reading info with mne
[fid, tree, dir] = fiff_open(fname);
[info, meas] = fiff_read_meas_info(fid, tree);
disp(info.dig)
