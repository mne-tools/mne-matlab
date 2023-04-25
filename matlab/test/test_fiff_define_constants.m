function test_suite=test_fiff_define_constants
    try test_functions=localfunctions(); catch
    end
    initTestSuite;

function test_fiff_define_constants_()
% Test consistency of the fiff_define_constants.m w.r.t. the required
% constants in the code base

if ispc
  % I don't know what happens with the unit testing actually, if the
  % function returns without actually testing anything
  return;
end

f = which('fiff_define_constants.m');
[p,f,e] = fileparts(f);

cd(p);

% create temporary files that holds the fiff constants from all m-files
% together, and one that holds the fiff constants from the definition file
system('grep -o "\<FIFF\>\.FIFF[A-Z_]*" fiff_define_constants.m | sort -u > c1');
system('grep -oh "\<FIFF\>\.FIFF[A-Z_]*" *.m --exclude fiff_define_constants.m | sort -u > c2');

% make the diff
system('diff c1 c2 > delta');

% check which constants are accessed from the m-files, but which are not
% present inthe definitions file
[st, count] = system('grep ">" delta | wc -l');

% clean up
delete('c1');
delete('c2');
delete('delta');

assertEqual(deblank(count), '0');
