#include <stdexcept>
#include <vector>

#include "mex.h"

#include "view.cuh"
#include "morph.cuh"
#include "strel.cuh"
#include "flat_linear_morph.cuh"

#include "mex_common.cuh"

template <class Ty>
void flatLinearMorphOp(mxArray *mxRes, const mxArray *mxVol, const std::vector<gpho::LineSeg>& lines,
    int op, int3 blockSize);

/** Grayscale morphological operation with flat linear structuring elements
 *
 * Parameters
 * ----------
 * vol : numeric array
 *     Input volume.
 * lineSteps : int32 matrix
 *     Step vectors for line segments. Must be N x 3.
 * lineLens : int32 vector
 *     Number of steps for line segments.
 * op : numeric
 *     Operation to perform.
 * blockSize : numeric vector
 *     Block size for GPU processing.
 *
 * Returns
 * -------
 * result : numeric array
 *     Output volume with result of operation. Same size and class as input volume.
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // Validate inputs
    ensureOrError(nrhs == 5, "Must supply 5 inputs");
    ensureOrError(nlhs == 1, "Must have 1 output");

    const mxArray *mxVol = prhs[0];
    const mxArray *mxLineSteps = prhs[1];
    const mxArray *mxLineLens = prhs[2];
    ensureRealNumericVolume(mxVol, "vol");
    ensureRealMatrix(mxLineSteps, "lineSteps");
    ensureOrError(mxGetN(mxLineSteps) == 3, "lineSteps must be N x 3");
    ensureOrError(mxGetClassID(mxLineSteps) == mxINT32_CLASS, "lineSteps must be int32");
    ensureRealVector(mxLineLens, "lineLens");
    ensureOrError(mxGetClassID(mxLineSteps) == mxINT32_CLASS, "lineLens must be int32");
    ensureOrError(mxGetM(mxLineSteps) == mxGetNumberOfElements(mxLineLens),
        "number of steps vectors and step lengths must be equal");
    int op = getValidatedMorphOp(prhs[3]);
    int3 blockSize = getValidatedInt3(prhs[4]);
    ensureOrError(blockSize.x > 0 && blockSize.y > 0 && blockSize.z > 0, "blockSize must be positive");

    // Allocate output
    mxArray *mxRes = createVolumeLike(mxVol);

    // Extract line segments
    size_t numLineSegs = mxGetM(mxLineSteps);
    std::vector<gpho::LineSeg> lines(numLineSegs);
    const int *lineStepsData = static_cast<const int *>(mxGetData(mxLineSteps));
    const int *lineLensData = static_cast<const int *>(mxGetData(mxLineLens));
    for (size_t i = 0; i < numLineSegs; ++i) {
        // MATLAB stores matrices in column major order
        auto& ls = lines[i];
        ls.step.x = lineStepsData[i + 0 * numLineSegs];
        ls.step.y = lineStepsData[i + 1 * numLineSegs];
        ls.step.z = lineStepsData[i + 2 * numLineSegs];
        ls.length = lineLensData[i];
    }

    // Run function
    typeDispatch(mxGetClassID(prhs[0]), flatLinearMorphOp, mxRes, mxVol, lines, op, blockSize);
    plhs[0] = mxRes;
}

template <class Ty>
void flatLinearMorphOp(mxArray *mxRes, const mxArray *mxVol, const std::vector<gpho::LineSeg>& lines,
    int op, int3 blockSize)
{
    gpho::HostView<Ty> res(static_cast<Ty *>(mxGetData(mxRes)), volSize(mxRes));
    gpho::HostView<const Ty> vol(static_cast<const Ty *>(mxGetData(mxVol)), volSize(mxVol));

    switch (op) {
    case MOP_DILATE:
        gpho::flatLinearDilateErode<gpho::MORPH_DILATE>(res, vol, lines, blockSize);
        break;
    case MOP_ERODE:
        gpho::flatLinearDilateErode<gpho::MORPH_ERODE>(res, vol, lines, blockSize);
        break;
    default:
        abortWithMsg("invalid morphology op");
    }
}