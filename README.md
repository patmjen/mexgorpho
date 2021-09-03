# mexgorpho

MATLAB bindings for [gorpho](https://github.com/patmjen/gorpho).

This is a MATLAB library for fast 3D mathematical morphology using CUDA. Currently, the library provides:

 * Dilation and erosion for grayscale 3D images.
 * Support for flat or grayscale structuring elements.
 * A van Herk/Gil-Werman implementation for fast dilation/erosion with flat line segments in 3D.
 * Automatic block processing for 3D images which can't fit in GPU memory.

**Python bindings** are also available at [github.com/patmjen/pygorpho](https://github.com/patmjen/pygorpho).

 ## Installation

 1. Download source code (including submodule).
 2. Navigate to `functions/mex`.
 3. Run `compile_all.m` from MATLAB.

That should be it. To use, run `setup.m` to add function to the MATLAB path.
