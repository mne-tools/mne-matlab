function test_suite=test_read_string_digitization
    try test_functions=localfunctions(); catch
    end
    initTestSuite;

function test_read_string_digitization_()

p = fileparts(mfilename('fullpath'));
% % FIFF file name
fname = fullfile(p, 'data', 'string_digi_test_data_1s.fif'); % a MEGIN data file with string type digitization

% % reading info with mne-matlab
% cd ..
[fid, tree, dir] = fiff_open(fname);
[info, meas] = fiff_read_meas_info(fid, tree);
disp(info.dig)
assert(length(info.dig)==332, 'failed')
