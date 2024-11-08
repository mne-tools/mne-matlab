function test_suite=test_fiff_setup_read_raw
    try test_functions=localfunctions(); catch
    end
    initTestSuite;

function test_fiff_setup_read_raw_()
% Test fiff_setup_read_raw.m

if ispc
  % I don't know what happens with the unit testing actually, if the
  % function returns without actually testing anything
  return;
end

p = fileparts(mfilename('fullpath'));

% load the reference trees
load(fullfile(p, 'data', 'test_setup_raw_ref.mat'));

fname = fullfile(p, 'data', 'test_raw.fif');
[raw] = fiff_setup_read_raw(fname);
if ~isfield(raws, 'raw')
  raws(1).raw = raw;
end
try, raw.info = rmfield(raw.info, 'filename'); end
try, raws.raw.info = rmfield(raws.raw.info, 'filename'); end
assert(isequaln(raw, raws.raw));

fname = fullfile(p, 'data', 'test_long_raw.fif');
[raw] = fiff_setup_read_raw(fname);
if ~isfield(raws, 'longraw')
  raws(1).longraw = raw;
end
try, raw.info = rmfield(raw.info, 'filename'); end
try, raws.longraw.info = rmfield(raws.longraw.info, 'filename'); end

if isfield(raw, 'fastread') && raw.fastread~=0
  raw = rmfield(raw, 'fastread');

  % the version stored on disk is based on the representation that allows
  % for fast reading, i.e. the former has an a struct-array 'ent' with
  % metadata for each of the data blocks, the latter has metadata that is
  % relevant for all data blocks at once, also the data type of the samples
  % may be different (int32 vs. double), this is not relevant for most
  % conventional use of thos quantities downstream in matlab
  raw.first_samp = double(raw.first_samp);
  raw.last_samp  = double(raw.last_samp);
  assert(isequaln(rmfield(raw, 'rawdir'), rmfield(raws.longraw, 'rawdir')));

elseif isfield(raw, 'fastread')
  raw = rmfield(raw, 'fastread');
  assert(isequaln(raw, raws.longraw));
end

