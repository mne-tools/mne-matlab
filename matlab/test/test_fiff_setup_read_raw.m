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

f = which('test_fiff_define_constants.m');
[p,f,e] = fileparts(f);

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
assert(isequaln(raw, raws.longraw));
