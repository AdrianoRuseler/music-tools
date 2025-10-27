
% Specify the full path and filename for your .db file
dbfile = 'C:\Users\ruseler\AppData\Local\Mixed In Key\Mixed In Key\11.0\MIKStore.db'; 

songs2 = readSongTable(dbfile);
% Display the first song's details from the songs2 table

mp3File=songs2.File(1);

disp(songs2(1, :));
info = audioinfo(mp3File);

% Build ffprobe command to extract metadata in JSON format
cmd = sprintf('ffprobe -v quiet -print_format json -show_format "%s"', mp3File);
[status, result] = system(cmd);

[info,jsonData] = extractMP3Metadata(mp3File);
disp(info);


% 1. Read the audio file
[audioIn, Fs] = audioread(mp3File); 

% 'audioIn' is the signal data (samples x channels)
% 'Fs' is the sample rate (e.g., 44100 Hz or 48000 Hz)

% 2. Calculate Integrated Loudness (LUFS)
% https://www.mathworks.com/help/releases/R2026a/audio/ref/integratedloudness.html?searchHighlight=integratedLoudness&s_tid=doc_srchtitle
loudness = integratedLoudness(audioIn, Fs);
songs2.OverallVolumeLUFS(1)

% Display the result
fprintf('Integrated Loudness: %.2f LUFS\n', loudness);


% 3. Calculate Integrated Loudness and Loudness Range (LRA)
[loudness, LRA] = integratedLoudness(audioIn, Fs);

% Display the results
fprintf('Integrated Loudness: %.2f LUFS\n', loudness);
fprintf('Loudness Range (LRA): %.2f LU\n', LRA);

% Create a loudnessMeter System object
% This object is designed for frame-by-frame (live/streaming) processing.
loudMtr = loudnessMeter('SampleRate', Fs);

% Initialize measurement variables
integrated_loudness = [];
loudness_range = [];
true_peak = [];

% In a streaming loop (or process the file in frames)
% For simplicity here, we process the whole file in one pass:
[momentary, shortTerm, integrated, range, peak] = loudMtr(audioIn);

% The 'integrated' and 'range' outputs will contain the overall results
fprintf('Short-Term Loudness (Last Frame): %.2f LUFS\n', shortTerm(end));
% fprintf('Integrated Loudness: %.2f LUFS\n', integrated);
fprintf('Maximum True Peak: %.2f dBTP\n', max(peak));

RMS = sqrt(mean(audioIn.^2));
RMS_per_channel = sqrt(mean(audioIn.^2, 1)); % The '1' specifies operating along the first dimension (rows)

linear_RMS = rms(audioIn, 'all');

20*log10(linear_RMS);

20*log10(RMS_per_channel);


songs2.OverallVolumeRMS1(1)
songs2.OverallVolumeRMS2(1)


% 1. Read the Audio File filename = 'handel.ogg'; 
% Replace with your file [audioIn, Fs] = audioread(filename); 
% 2. Calculate the Linear RMS Value 
% The 'all' flag ensures the RMS is computed over the entire array (all samples, all channels) 
linear_RMS = rms(audioIn, 'all'); 
% 3. Convert to dBFS 
RMS_in_dBFS = 20 * log10(linear_RMS); 
% 4. Display the result disp(['Linear RMS: ', num2str(linear_RMS)]); 
disp(['Overall Volume RMS: ', num2str(RMS_in_dBFS), ' dBFS']);

