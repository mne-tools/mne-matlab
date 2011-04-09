function [dmap_sel] = mne_morph_data(from,src,to,data,grade)
% MNE_MORPH_DATA   Returns data morphed to a new subject.
%
%   SYNTAX
%       [EDGES] = MNE_MORPH_DATA(FROM, SRC, TO, DATA, GRADE)
%
%   from : name of origin subject
%   src : source space of subject "from" read with mne_read_source_spaces
%   to : name of destination subject
%   data : data to morph
%   grade : (optional) resolution of the icosahedral mesh (typically 5)
%
% Note : The functions requires to set MNE_ROOT and SUBJECTS_DIR variables.
%
% Example:
%  from = 'sample';
%  to = 'fsaverage';
%  src = mne_read_source_spaces([getenv('SUBJECTS_DIR'),'/', from, '/bem/sample-oct-6-src.fif']);
%  data{1} = randn(4098, 10);
%  data{2} = randn(4098, 10);
%  dmap_sel = mne_morph_data(from,src,to,data,5);
%
%  Note: Since vertices may have been omitted due to being too close
% to the skull in the forward model calculation, it is recommended
% that the source space information is read from the forward model
% or inverse operator file rather than from the original source space
%

%
%   Author : Alexandre Gramfort, MGH Martinos Center
%            Matti Hamalainen
%   License : BSD 3-clause
%

if nargin < 5
    grade = 5;
end

[map{1}, map{2}] = mne_read_morph_map(from,to);

for hemi = 1:2
    e = mne_mesh_edges(src(hemi).tris);
    e = e==2;
    n_vertices = length(e);
    e = e + speye(n_vertices, n_vertices);
    idx_use = find(src(hemi).inuse);
    n_iter = 100; % nb of smoothing iterations
    for k = 1:n_iter
        data1 = e(:,idx_use) * ones(length(idx_use),1);
        data{hemi}  = e(:,idx_use)*data{hemi};
        idx_use = find(data1);
        fprintf(1,'%d/%d ',k,length(idx_use));
        if ( k == n_iter ) || ( length(idx_use) >= n_vertices )
            data{hemi}(idx_use,:) = bsxfun(@rdivide, data{hemi}(idx_use,:), data1(idx_use));
            break;
        else
            data{hemi} = bsxfun(@rdivide, data{hemi}(idx_use,:), data1(idx_use));
        end
    end
    fprintf(1,'\n');
    dmap{hemi} = map{hemi}*data{hemi};
end

ico_file_name = [getenv('MNE_ROOT'),'/share/mne/icos.fif'];

s = mne_read_bem_surfaces(ico_file_name);

for k = 1:length(s)
    if (s(k).id == 9000 + grade)
        ico = s(k);
        break;
    end
end

sphere = [getenv('SUBJECTS_DIR'),'/',to,'/surf/lh.sphere.reg'];
lhs = mne_read_surface(sphere);
sphere = [getenv('SUBJECTS_DIR'),'/',to,'/surf/rh.sphere.reg'];
rhs = mne_read_surface(sphere);

nearest{1} = zeros(ico.np, 1);
nearest{2} = zeros(ico.np, 1);

lhs =  bsxfun(@rdivide, lhs, sqrt(sum(lhs.^2, 2)));
rhs =  bsxfun(@rdivide, rhs, sqrt(sum(rhs.^2, 2)));

for k = 1:size(ico.rr,1)
    dots = ico.rr(k,:)*lhs';
    [tmp, nearest{1}(k)] = max(dots);
    dots = ico.rr(k,:)*rhs';
    [tmp, nearest{2}(k)] = max(dots);
end

dmap_sel{1} = dmap{1}(nearest{1},:);
dmap_sel{2} = dmap{2}(nearest{2},:);

fprintf(1, '\n');
