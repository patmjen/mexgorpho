gorphoPath = '../../gorpho/lib';

compileOptions = {
    ['-I' gorphoPath],...
    ['-I' gorphoPath '/cudablockproc'],...
    'NVCC_FLAGS="--expt-relaxed-constexpr"',...
};

if ~ispc
    % If we are not on Windows we use the costum g++ config to compile with
    % C++14. If an older (or newer?) version of MATLAB is used this may
    % break.
    compileOptions = [compileOptions, '-f', 'nvcc_g++_c++14.xml'];
end

mexFiles = dir('gorpho_mex_*.cu');
numMexFiles = length(mexFiles);

%%
for i = 1:numMexFiles
    crntFile = fullfile(mexFiles(i).folder, mexFiles(i).name);
    fprintf('Compiling %s...\n', mexFiles(i).name);
    mexcuda(compileOptions{:}, crntFile);
end
fprintf('Done\n');