function test_suite=test_fiff_readwrite
    try test_functions=localfunctions(); catch
    end
    initTestSuite;

function test_fiff_readwrite_raw_()
% Test a round trip of reading and writing raw data
%  this function calls the following relevant m-files:
%   - fiff_read_meas_info
%   - fiff_setup_read_raw
%   - fiff_read_raw_segment
%   - fiff_start_writing_raw
%   - fiff_write_int
%   - fiff_write_raw_buffer
%   - fiff_finish_writing_raw

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

function test_fiff_readwrite_raw_double_()
% Test a round trip of reading and writing raw data in double precision
%  this function calls the following relevant m-files:
%   - fiff_read_meas_info
%   - fiff_setup_read_raw
%   - fiff_read_raw_segment
%   - fiff_start_writing_raw
%   - fiff_write_int
%   - fiff_write_raw_buffer
%   - fiff_finish_writing_raw

FIFF = fiff_define_constants;

% read
pathstr = fileparts(mfilename('fullpath'));
fname   = fullfile(pathstr, 'data', 'test_raw.fif');
info    = fiff_read_meas_info(fname);
raw     = fiff_setup_read_raw(fname);
[data, times] = fiff_read_raw_segment(raw);

% write -> note that the original data was in 24 chunks of 600 samples, the
% data is saved out as a single chunk of 14400 samples
fnamenew = strrep(fname, 'test_', 'testoutd_');
[outfid, cals] = fiff_start_writing_raw(fnamenew, info, [], 'double');
fiff_write_int(outfid, FIFF.FIFF_FIRST_SAMPLE, raw.first_samp);
fiff_write_int(outfid, FIFF.FIFF_DATA_SKIP, 0);
fiff_write_raw_buffer(outfid, data, cals, FIFF.FIFFT_DOUBLE);
fiff_finish_writing_raw(outfid);

% read the new file
rawnew     = fiff_setup_read_raw(fnamenew);
[datanew, timesnew] = fiff_read_raw_segment(rawnew);

% compare, with some tolerance, because for unknown reasons the fiff code
% adjusts the cal/range factors upon writing, which anecdotally may yield
% differences (in the round trip) up to eps, but for the given test data
% only for the EEG channels, MEG is numerically equal
assertElementsAlmostEqual(data,  datanew, 'relative', eps);
assertElementsAlmostEqual(times,  timesnew, 'relative', eps);

% clean up
delete(fnamenew);

function test_fiff_readwrite_raw_complex_()
% Test a round trip of reading and writing raw data in complex single precision
%  this function calls the following relevant m-files:
%   - fiff_read_meas_info
%   - fiff_setup_read_raw
%   - fiff_read_raw_segment
%   - fiff_start_writing_raw
%   - fiff_write_int
%   - fiff_write_raw_buffer
%   - fiff_finish_writing_raw

FIFF = fiff_define_constants;

% read
pathstr = fileparts(mfilename('fullpath'));
fname   = fullfile(pathstr, 'data', 'test_raw.fif');
info    = fiff_read_meas_info(fname);
raw     = fiff_setup_read_raw(fname);
[data, times] = fiff_read_raw_segment(raw);
data = data + 1i.*data;

% write -> note that the original data was in 24 chunks of 600 samples, the
% data is saved out as a single chunk of 14400 samples
fnamenew = strrep(fname, 'test_', 'testoutc_');
[outfid, cals] = fiff_start_writing_raw(fnamenew, info, [], 'single_complex');
fiff_write_int(outfid, FIFF.FIFF_FIRST_SAMPLE, raw.first_samp);
fiff_write_int(outfid, FIFF.FIFF_DATA_SKIP, 0);
fiff_write_raw_buffer(outfid, data, cals, FIFF.FIFFT_COMPLEX_FLOAT);
fiff_finish_writing_raw(outfid);

% read the new file
rawnew     = fiff_setup_read_raw(fnamenew);
[datanew, timesnew] = fiff_read_raw_segment(rawnew);

% compare, with some tolerance, because for unknown reasons the fiff code
% adjusts the cal/range factors upon writing, which anecdotally may yield
% differences (in the round trip) up to eps, but for the given test data
% only for the EEG channels, MEG is numerically equal
assertElementsAlmostEqual(data,  datanew, 'relative', eps);
assertElementsAlmostEqual(times,  timesnew, 'relative', eps);

% clean up
delete(fnamenew);

function test_fiff_readwrite_raw_complex_double_()
% Test a round trip of reading and writing raw data in complex double precision
%  this function calls the following relevant m-files:
%   - fiff_read_meas_info
%   - fiff_setup_read_raw
%   - fiff_read_raw_segment
%   - fiff_start_writing_raw
%   - fiff_write_int
%   - fiff_write_raw_buffer
%   - fiff_finish_writing_raw

FIFF = fiff_define_constants;

% read
pathstr = fileparts(mfilename('fullpath'));
fname   = fullfile(pathstr, 'data', 'test_raw.fif');
info    = fiff_read_meas_info(fname);
raw     = fiff_setup_read_raw(fname);
[data, times] = fiff_read_raw_segment(raw);
data = data + 1i.*data;

% write -> note that the original data was in 24 chunks of 600 samples, the
% data is saved out as a single chunk of 14400 samples
fnamenew = strrep(fname, 'test_', 'testoutc_');
[outfid, cals] = fiff_start_writing_raw(fnamenew, info, [], 'double_complex');
fiff_write_int(outfid, FIFF.FIFF_FIRST_SAMPLE, raw.first_samp);
fiff_write_int(outfid, FIFF.FIFF_DATA_SKIP, 0);
fiff_write_raw_buffer(outfid, data, cals, FIFF.FIFFT_COMPLEX_DOUBLE);
fiff_finish_writing_raw(outfid);

% read the new file
rawnew     = fiff_setup_read_raw(fnamenew);
[datanew, timesnew] = fiff_read_raw_segment(rawnew);

% compare, with some tolerance, because for unknown reasons the fiff code
% adjusts the cal/range factors upon writing, which anecdotally may yield
% differences (in the round trip) up to eps, but for the given test data
% only for the EEG channels, MEG is numerically equal
assertElementsAlmostEqual(data,  datanew, 'relative', eps);
assertElementsAlmostEqual(times,  timesnew, 'relative', eps);

% clean up
delete(fnamenew);

function test_fiff_readwrite_evoked_()
% Test a round trip of reading and writing evoked data

% read
pathstr = fileparts(mfilename('fullpath'));
fname   = fullfile(pathstr, 'data', 'test-ave.fif');
evoked  = fiff_read_evoked(fname);

fnamenew = strrep(fname, 'test-', 'testout-');
fiff_write_evoked(fnamenew, evoked);
evokednew = fiff_read_evoked(fnamenew);

assertEqual(evoked.evoked, evokednew.evoked);

% clean up
delete(fnamenew);

function test_fiff_readwrite_evoked_all_()
% Test a round trip of reading and writing evoked data

% read
pathstr = fileparts(mfilename('fullpath'));
fname   = fullfile(pathstr, 'data', 'test-ave.fif');
evoked  = fiff_read_evoked_all(fname);

fnamenew = strrep(fname, 'test-', 'testout-');
fiff_write_evoked(fnamenew, evoked);
evokednew = fiff_read_evoked_all(fnamenew);

assertEqual(evoked.evoked, evokednew.evoked);

% clean up
delete(fnamenew);
