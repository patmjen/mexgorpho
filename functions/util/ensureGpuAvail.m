function ensureGpuAvail
% ensureGpuAvail Throw an error message if no GPU is found
%
% ensureGpuAvail()
%
% Patrick M. Jensen, 2020, Technical University of Denmark

if gpuDeviceCount == 0
    error('A GPU is required but none was found');
end