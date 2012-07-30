function test_source_spectral_analysis()
% Test PSD computation for sources

data_path = getenv('MNE_SAMPLE_DATASET_PATH');
if isempty(data_path)
    error('MNE_SAMPLE_DATASET_PATH environment variable no set.')
end

fname_data = [data_path filesep 'MEG' filesep 'sample' filesep 'sample_audvis_raw.fif'];

clear cfg
cfg.inv = [data_path filesep 'MEG' filesep 'sample' filesep 'sample_audvis-meg-oct-6-meg-inv.fif'];
cfg.first_samp = 0;
cfg.last_samp = 40000;
cfg.outfile = 'source_psd'

[res] = mne_source_spectral_analysis(fname_data,cfg);

