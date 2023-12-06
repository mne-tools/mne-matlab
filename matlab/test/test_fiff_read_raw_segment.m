function test_suite=test_fiff_read_raw_segment
    try test_functions=localfunctions(); catch
    end
    initTestSuite;

function test_fiff_read_raw_segment_()
% Test fiff_read_raw_segment.m

if ispc
  % I don't know what happens with the unit testing actually, if the
  % function returns without actually testing anything
  return;
end

p = fileparts(mfilename('fullpath'));
fname = fullfile(p, 'data', 'test_raw.fif');
[raw] = fiff_setup_read_raw(fname);
[dat,times] = fiff_read_raw_segment(raw);

% grab the first 100 samples
indx = double(raw.first_samp) + [0 99];
[dat2,times2] = fiff_read_raw_segment(raw, indx(1), indx(2));
assert(isequal(dat(:,1:100),dat2));
assert(isequal(times(:,1:100),times2));

% grab the last 100 samples
indx = double(raw.last_samp) - [99 0];
[dat2,times2] = fiff_read_raw_segment(raw, indx(1), indx(2));
assert(isequal(dat(:,(end-99):end),dat2));
assert(isequal(times(:,(end-99):end),times2));

% grab somewhere in between, going over a block boundary
indx = double(raw.first_samp) + 500 + [0 99];
[dat2,times2] = fiff_read_raw_segment(raw, indx(1), indx(2));
assert(isequal(dat(:,501:600),dat2));
assert(isequal(times(:,501:600),times2));

% grab a subset of channels
[dat2,times2] = fiff_read_raw_segment(raw, raw.first_samp, raw.last_samp, 2:2:size(dat,1));
assert(isequal(dat(2:2:end,:), dat2));
