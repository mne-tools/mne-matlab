function test_suite=test_fiff_readwrite
    try test_functions=localfunctions(); catch
    end
    initTestSuite;

function test_fiff_readwrite_raw_()
% Test a round trip of reading and writing raw data 

FIFF = fiff_define_constants;

% read
pathstr = fileparts(mfilename('fullpath'));
fname   = fullfile(pathstr, 'data', 'test_raw.fif');
info    = fiff_read_meas_info(fname);
raw     = fiff_setup_read_raw(fname);
[data, times] = fiff_read_raw_segment(raw);

% write -> note that the original data was in 24 chunks of 600 samples, the
% data is saved out as a single chunk of 14400 samples
fnamenew = strrep(fname, 'test_', 'testout_');
[outfid, cals] = fiff_start_writing_raw(fnamenew, info);
fiff_write_int(outfid, FIFF.FIFF_FIRST_SAMPLE, raw.first_samp);
fiff_write_int(outfid, FIFF.FIFF_DATA_SKIP, 0);
fiff_write_raw_buffer(outfid, data, cals);
fiff_finish_writing_raw(outfid);

% read the new file
rawnew     = fiff_setup_read_raw(fnamenew);
[datanew, timesnew] = fiff_read_raw_segment(rawnew);

% compare
assertEqual(data,  datanew);
assertEqual(times, timesnew);

% clean up
delete(fnamenew);

