#include <stdexcept>

#include "mex.h"

#include "view.cuh"
#include "general_morph.cuh"

#include "mex_common.cuh"

template <class Ty>
void genMorphOp(mxArray *res, const mxArray *vol, const mxArray *strel, int op, int3 blockSize);

/** Grayscale morphological operation with grayscale structuring element
 *
 * Parameters
 * ----------
 * vol : numerical array
 *     Input volume.
 * strel : numerical array
 *     Structuring element. Must have same class as input volume.
 * op : numerical
 *     Operation to perform.
 * blockSize : numerical vector
 *     Block size for GPU processing.
 *
 * Returns
 * -------
 * result : numerical array
 *     Output volume with result of operation. Same size as input volume.
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // Validate inputs
    ensureOrError(nrhs == 4, "Must supply 4 inputs");
    ensureOrError(nlhs == 1, "Must have 1 output");

    const mxArray *mxVol = prhs[0];
    const mxArray *mxStrel = prhs[1];
    ensureRealNumericVolume(mxVol, "vol");
    ensureRealNumericVolume(mxStrel, "strel");
    ensureOrError(mxGetClassID(mxVol) == mxGetClassID(mxStrel), "vol and strel must have same class");
    int op = getValidatedMorphOp(prhs[2]);
    int3 blockSize = getValidatedInt3(prhs[3]);
    ensureOrError(blockSize.x > 0 && blockSize.y > 0 && blockSize.z > 0, "blockSize must be positive");

    // Allocate output
    mxArray *mxRes = createVolumeLike(mxVol);

    // Run function
    typeDispatch(mxGetClassID(prhs[0]), genMorphOp, mxRes, mxVol, mxStrel, op, blockSize);
    plhs[0] = mxRes;
}

template <class Ty>
void genMorphOp(mxArray *mxRes, const mxArray *mxVol, const mxArray *mxStrel, int op, int3 blockSize)
{
    gpho::HostView<Ty> res(static_cast<Ty *>(mxGetData(mxRes)), volSize(mxRes));
    gpho::HostView<const Ty> vol(static_cast<const Ty *>(mxGetData(mxVol)), volSize(mxVol));
    gpho::HostView<const Ty> strel(static_cast<const Ty *>(mxGetData(mxStrel)), volSize(mxStrel));

    switch (op) {
    case MOP_DILATE:
        gpho::genDilate(res, vol, strel, blockSize);
        break;
    case MOP_ERODE:
        gpho::genErode(res, vol, strel, blockSize);
        break;
    default:
        abortWithMsg("invalid morphology op");
    }
}