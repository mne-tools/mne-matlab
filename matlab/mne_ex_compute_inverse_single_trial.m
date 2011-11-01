function mne_ex_compute_inverse_single_trial(stc_fname_prefix, epochs, inv_file, snr, tmin, tstep, dSPM)
%
% mne_ex_compute_inverse_single_trial(epoch_info,which,prev_fid)
%
% Reads epochs from a binary file produced by mne_epochs2mat and apply MNE on each
% Results are save in stc files.
%
% stc_fname_prefix - The string used to prefix all stc filenames.
% epochs           - binary file produced by mne_epochs2mat
% inv_file         - The file name of the inverse operator
% snr              - The SNR (lambda2 = 1/snr^2)
% tmin             - tmin of the epoch in seconds
% tstep            - the tstep (interval between epochs)
% dSPM             - boolean
%
% To use this script on MNE sample data:
% extract epochs using mne_epochs2mat. When using mne_epochs2mat, apply the
% inverse operator - it removes bad channels and applies the projections. 
% After epochs have been extracted, use this script to produce stc files for
% each trial specified in the epoch.
% 
% Example to extract data:
% 
% mne_epochs2mat --raw (sample_data_raw.fif --mat (output) --event (#)
% --tmin (x) --tmax (y)  --inv (inv file)
%
% Author: Ricky Sachdeva, July 20, 2011

load(epochs);
inv_temp = mne_read_inverse_operator(inv_file);
lambda2 = 1/(snr*snr);       % 1/snr^2
[inv] = mne_prepare_inverse_operator(inv_temp,inv_temp.nave,lambda2,dSPM,false);
FIFF = fiff_define_constants();
for trial = 1:MNE_epoch_info.nepoch;
    [data,fid] = mne_read_epoch(MNE_epoch_info,trial,-1);
    raw_data(:,:,trial) = data;

    % below is from mne_ex_compute_inverse
    trans = diag(sparse(inv.reginv))*inv.eigen_fields.data*inv.whitener*double(squeeze(raw_data(:,:,trial)));  % removed proj because applied during mne_epoch2mat
    if inv.eigen_leads_weighted
       %
       %     R^0.5 has been already factored in
       %
       fprintf(1,'(eigenleads already weighted)...');
       sol = inv.eigen_leads.data*trans;
    else
       %
       %     R^0.5 has to factored in
       %
       fprintf(1,'(eigenleads need to be weighted)...');
       sol = diag(sparse(sqrt(inv.source_cov.data)))*inv.eigen_leads.data*trans;
    end

    if inv.source_ori == FIFF.FIFFV_MNE_FREE_ORI
        fprintf(1,'combining the current components...');
        sol1 = zeros(size(sol,1)/3,size(sol,2));
        for k = 1:size(sol,2)
            sol1(:,k) = sqrt(mne_combine_xyz(sol(:,k)));
        end
    end
    if dSPM
        sol = inv.noisenorm * sol1;
    else
        sol = sol1;
    end
    file_name = ([stc_fname_prefix, '_trial_', int2str(trial)]);
    mne_write_inverse_sol_stc(file_name,inv,sol,tmin,tstep);
end
end