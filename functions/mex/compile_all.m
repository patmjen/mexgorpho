gorphoPath = '../../gorpho/lib';

compileOptions = {
    ['-I' gorphoPath]
    ['-I' gorphoPath '/cudablockproc']
    'NVCC_FLAGS="--expt-relaxed-constexpr"'
};

mexFiles = dir('gorpho_mex_*.cu');
numMexFiles = length(mexFiles);

for i = 1:numMexFiles
    crntFile = fullfile(mexFiles(i).folder, mexFiles(i).name);
    fprintf('Compiling %s...\n', mexFiles(i).name);
    mexcuda(compileOptions{:}, crntFile);
end