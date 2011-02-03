function fiff_write_raw_segment(fname, raw, from, to, sel)
%   FIFF_WRITE_RAW_SEGMENT   Write chunck of raw data to disk
%       [] = FIFF_WRITE_RAW_SEGMENT(FNAME, RAW, FROM, TO, SEL)
%
%   The functions reads data from a file specified by raw
%   which is obtained with fiff_setup_read_raw
%
% fname  - the name of the file where to write
% raw    - structure returned by fiff_setup_read_raw
% from   - first sample to include. If omitted, defaults to the
%          first sample in data
% to     - last sample to include. If omitted, defaults to the last
%          sample in data
% sel    - optional channel selection vector

% from   - starting time of the segment in seconds
% to     - end time of the segment in seconds

%
%   Author : Alexandre Gramfort, MGH Martinos Center
%   License : BSD 3 - clause
%

global FIFF;
if isempty(FIFF)
    FIFF = fiff_define_constants();
end
%
me = 'MNE:fiff_write_raw_segment';
%
if nargin < 2
    error(me, 'Incorrect number of arguments');
end
if nargin < 3 | isempty(from)
    from = raw.first_samp;
end
if nargin < 4 | isempty(to)
    to = raw.last_samp;
end
if nargin < 5
    sel = 1:raw.info.nchan;
end
%
[outfid, cals] = fiff_start_writing_raw(fname, raw.info, sel);
%
%   Set up the reading parameters
%
quantum_sec = 30; % read by chunks of 30 seconds
quantum     = ceil(quantum_sec * raw.info.sfreq);
%
first_buffer = true;
for first = from:quantum:to
    last = first + quantum - 1;
    if last > to
        last = to;
    end
    try
        [ data, times ] = fiff_read_raw_segment(raw, first, last, sel);
    catch
        fclose(raw.fid);
        fclose(outfid);
        error(me, '%s', mne_omit_first_line(lasterr));
    end
    %
    %   You can add your own miracle here
    %
    fprintf(1, 'Writing...');
    if first_buffer
        if first > 0
            fiff_write_int(outfid, FIFF.FIFF_FIRST_SAMPLE, first);
        end
        first_buffer = false;
    end
    fiff_write_raw_buffer(outfid, data, cals);
    fprintf(1, '[done]\n');
end

fiff_finish_writing_raw(outfid);
