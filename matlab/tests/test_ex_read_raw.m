function test_ex_read_raw()
% Test IO with FIF raw files

data_path = getenv('MNE_SAMPLE_DATASET_PATH');
if isempty(data_path)
    error('MNE_SAMPLE_DATASET_PATH environment variable no set.')
end

fname = [data_path filesep 'MEG' filesep 'sample' filesep 'sample_audvis_raw.fif'];
from = 100;
to = 150;
in_samples = false;
[data, times] = mne_ex_read_raw(fname, from, to, in_samples);

assert(size(data, 2) == length(times))
assertTrue(all(times < 151))
assertTrue(all(times > 99))

