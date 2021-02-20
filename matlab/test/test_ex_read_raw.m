function test_suite=test_ex_read_raw
    try test_functions=localfunctions(); catch
    end
    initTestSuite;

function test_ex_read_raw_()
% Test IO with FIF raw files

pathstr = fileparts(mfilename('fullpath'));
fname = [pathstr filesep 'data' filesep 'test_raw.fif'];

from = 50;
to = 55;
in_samples = false;
[data, times] = mne_ex_read_raw(fname, from, to, in_samples);

assert(size(data, 2) == length(times))
assertTrue(all(times < 56))
assertTrue(all(times > 49))

raw = fiff_setup_read_raw(fname);
fiff_write_raw_segment_times('foo.fif', raw, 51, 53);

raw = fiff_setup_read_raw('foo.fif');
[data, times] = fiff_read_raw_segment(raw);
assert(size(data, 2) == length(times))
assertTrue(all(times < 53.01))
assertTrue(all(times > 50.99))

% import mne, numpy as np
% data = np.random.RandomState(0).randn(3, 2)
% info = mne.create_info(['MEG1', 'MEG2 with a very long name', 'STI 014'], 1000., ['grad', 'grad', 'stim'])
% mne.io.RawArray(data, info).save('matlab/test/data/test_long_raw.fif')
want_data = [[1.76405235, 0.40015721]; [0.97873798, 2.2408932]; [1.86755799, -0.97727788]];
want_times = [0., 0.001]
want_names = {'MEG1', 'MEG2 with a very long name', 'STI 014'}

fname = [pathstr filesep 'data' filesep 'test_long_raw.fif'];
[data, times] = mne_ex_read_raw(fname, 0, 1, in_samples);
assertTrue(all(data(:) - want_data(:) < 1e-6));
assertTrue(all(times == want_times));

raw = fiff_setup_read_raw(fname);
assertTrue(all(strcmp(raw.info.ch_names, want_names)));
fiff_write_raw_segment_times('foo.fif', raw, 0, 1);

raw = fiff_setup_read_raw('foo.fif');
[data, times] = fiff_read_raw_segment(raw);
assertTrue(all(data(:) - want_data(:) < 1e-6));
assertTrue(all(times == want_times));
assertTrue(all(strcmp(raw.info.ch_names, want_names)));
