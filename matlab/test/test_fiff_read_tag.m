function test_suite=test_fiff_read_tag
    try test_functions=localfunctions(); catch
    end
    initTestSuite;

function test_fiff_read_tag_()
% Test fiff_open.m

if ispc
  % I don't know what happens with the unit testing actually, if the
  % function returns without actually testing anything
  return;
end

p = fileparts(mfilename('fullpath'));

% load the reference trees
load(fullfile(p, 'data', 'test_fiftrees_ref.mat'));

fname = fullfile(p, 'data', 'test_raw.fif');
[fid, tree, dir] = fiff_open(fname);
fclose(fid);
assert(isequal(tree, trees.raw));

fname = fullfile(p, 'data', 'test_long_raw.fif');
[fid, tree, dir] = fiff_open(fname);
fclose(fid);
assert(isequal(tree, trees.longraw));

fname = fullfile(p, 'data', 'test_raw-eve.fif');
[fid, tree, dir] = fiff_open(fname);
fclose(fid);
assert(isequal(tree, trees.raweve));

fname = fullfile(p, 'data', 'test-eve.fif');
[fid, tree, dir] = fiff_open(fname);
fclose(fid);
assert(isequal(tree, trees.eve));

fname = fullfile(p, 'data', 'test-ave.fif');
[fid, tree, dir] = fiff_open(fname);
fclose(fid);
assert(isequal(tree, trees.ave));

fname = fullfile(p, 'data', 'test-cov.fif');
[fid, tree, dir] = fiff_open(fname);
fclose(fid);
assert(isequal(tree, trees.cov));
