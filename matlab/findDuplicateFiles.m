function findDuplicateFiles(directory)
% FINDDUPLICATEFILES Scans the specified directory for duplicate files.
% Usage: findDuplicateFiles('C:\Your\Directory\Path')

if nargin < 1
    error('Please specify a directory path.');
end

% Get list of all files recursively
files = dir(fullfile(directory, '**', '*.*'));
files = files(~[files.isdir]); % Remove directories

fprintf('Scanning %d files...\n', numel(files));

% Map to store file hashes
hashMap = containers.Map();

for i = 1:numel(files)
    filePath = fullfile(files(i).folder, files(i).name);
    fileHash = getFileHash(filePath);

    fprintf('$d - fileHash %s: %s \n', i,fileHash, files(i).name);

    if isKey(hashMap, fileHash)
        tempList = hashMap(fileHash);
        tempList{end+1} = filePath;
        hashMap(fileHash) = tempList;
    else
        hashMap(fileHash) = {filePath};
    end
end

% Display duplicates
fprintf('\nDuplicate files found:\n');
keys = hashMap.keys;
for i = 1:numel(keys)
    fileList = hashMap(keys{i});
    if numel(fileList) > 1
        fprintf('\nGroup %d:\n', i);
        for j = 1:numel(fileList)
            fprintf('  %s\n', fileList{j});
        end
    end
end
end

function hash = getFileHash(filePath)
% GETFILEHASH Computes SHA-256 hash of the file content
fid = fopen(filePath, 'rb');
if fid == -1
    error('Cannot open file: %s', filePath);
end
data = fread(fid, inf, '*uint8');
fclose(fid);

md = java.security.MessageDigest.getInstance('SHA-256');
md.update(data);
hashBytes = typecast(md.digest(), 'uint8');
hash = dec2hex(hashBytes)';
hash = lower(hash(:)');
end
