function test_ex_read_epochs()
% Test IO with FIF raw files

data_path = getenv('MNE_SAMPLE_DATASET_PATH');
if isempty(data_path)
    error('MNE_SAMPLE_DATASET_PATH environment variable no set.')
end

fname = [data_path filesep 'MEG' filesep 'sample' filesep 'sample_audvis_raw.fif'];
eventname = [data_path filesep 'MEG' filesep 'sample' filesep 'sample_audvis_raw-eve.fif'];

event = 1
tmin = -0.2
tmax = 0.5

[data, times, ch_names] = mne_ex_read_epochs(fname, event, eventname, tmin, tmax);

assert(376 == length(ch_names))
assert(72 == length(data))
assert(376 == size(data(1).epoch, 1))
% assert(length(times) == size(data(1).epoch, 2)) # XXX should not fail

