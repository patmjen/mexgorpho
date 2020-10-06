#include <stdexcept>

#include "mex.h"
#include "matrix.h"

#include "flat_linear_morph.cuh"
#include "strel.cuh"

#include "mex_common.cuh"

inline gpho::ApproxType toApproxType(int approxType)
{
    if (approxType == 0) {
        return gpho::APPROX_INSIDE;
    } else if (approxType == 1) {
        return gpho::APPROX_BEST;
    } else {
        return gpho::APPROX_OUTSIDE;
    }
}

/** Line segment approximation to flat ball structuring element
 *
 * Parameters
 * ----------
 * radius : numeric scalar
 *     Radius of ball.
 * approxType : numeric scalar
 *     Type of approximation: 0 = constrained inside, 1 = best, 2 = constrained outside.
 *
 * Returns
 * -------
 * lineSteps : int32 matrix
 *     N x 3 matrix with step vectors for line segments.
 * lineLens : int32 vector
 *     N x 1 vector with length sof line segments (in steps).
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // Validate inputs
    ensureOrError(nrhs == 2, "Must supply 2 inputs");
    ensureOrError(nlhs == 2, "Must have 2 outputs");

    int radius = getValidatedScalar<int>(prhs[0], "radius");
    ensureOrError(radius > 0, "radius mus the positive");
    int approxType = getValidatedScalar<int>(prhs[1], "approxType");
    ensureValue(approxType, { 0, 1, 2 }, "approxType");

    std::vector<gpho::LineSeg> lines = gpho::flatBallApprox(radius, toApproxType(approxType));

    // Allocate and fill outputs
    mxArray *mxLineSteps = mxCreateUninitNumericMatrix(lines.size(), 3, mxINT32_CLASS, mxREAL);
    mxArray *mxLineLens = mxCreateUninitNumericMatrix(lines.size(), 1, mxINT32_CLASS, mxREAL);
    int *lineStepsData = static_cast<int *>(mxGetData(mxLineSteps));
    int *lineLensData = static_cast<int *>(mxGetData(mxLineLens));

    for (size_t i = 0; i < lines.size(); ++i) {
        const auto& ls = lines[i];
        lineStepsData[i + 0 * lines.size()] = ls.step.x;
        lineStepsData[i + 1 * lines.size()] = ls.step.y;
        lineStepsData[i + 2 * lines.size()] = ls.step.z;
        lineLensData[i] = ls.length;
    }

    plhs[0] = mxLineSteps;
    plhs[1] = mxLineLens;
}