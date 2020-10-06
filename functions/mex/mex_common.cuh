#ifndef MEX_COMMON_CUH__
#define MEX_COMMON_CUH__

#include <initializer_list>
#include <cstdint>

#include "mex.h"
#include "matrix.h"

// TODO: Use enum from morph.cuh
enum MorphOp : int {
    MOP_DILATE = 0,
    MOP_ERODE = 1,
    MOP_OPEN = 2,
    MOP_CLOSE = 3,
    MOP_TOPHAT = 4,
    MOP_BOTHAT = 5
};

#define abortWithMsg(...) do { \
    mexErrMsgIdAndTxt("mexgorpho:internal", __VA_ARGS__); \
} while(false)

#define ensureOrError(expr, ...) do { \
    if (!(expr)) { \
        abortWithMsg(__VA_ARGS__); \
    } \
} while (false)

#define typeDispatch(type, func, ...) do { \
    switch (type) { \
    case mxDOUBLE_CLASS: \
        func<double>(__VA_ARGS__); \
        break; \
    case mxSINGLE_CLASS: \
        func<float>(__VA_ARGS__); \
        break; \
    case mxINT8_CLASS: \
        func<int8_t>(__VA_ARGS__); \
        break; \
    case mxUINT8_CLASS: \
        func<uint8_t>(__VA_ARGS__); \
        break; \
    case mxINT16_CLASS: \
        func<int16_t>(__VA_ARGS__); \
        break; \
    case mxUINT16_CLASS: \
        func<uint16_t>(__VA_ARGS__); \
        break; \
    case mxINT32_CLASS: \
        func<int32_t>(__VA_ARGS__); \
        break; \
    case mxUINT32_CLASS: \
        func<uint32_t>(__VA_ARGS__); \
        break; \
    case mxINT64_CLASS: \
        func<int64_t>(__VA_ARGS__); \
        break; \
    case mxUINT64_CLASS: \
        func<uint64_t>(__VA_ARGS__); \
        break; \
    default: \
        abortWithMsg("invalid type code (was: %d)", static_cast<int>(type)); \
    } \
} while(false)

template <class Ty>
inline Ty derefAndCast(const void *ptr, mxClassID id)
{
	switch (id) {
	case mxLOGICAL_CLASS:
		return static_cast<Ty>(*reinterpret_cast<const mxLogical *>(ptr));
	case mxINT8_CLASS:
		return static_cast<Ty>(*reinterpret_cast<const mxInt8 *>(ptr));
	case mxUINT8_CLASS:
		return static_cast<Ty>(*reinterpret_cast<const mxUint8 *>(ptr));
	case mxINT16_CLASS:
		return static_cast<Ty>(*reinterpret_cast<const mxInt16 *>(ptr));
	case mxUINT16_CLASS:
		return static_cast<Ty>(*reinterpret_cast<const mxUint16 *>(ptr));
	case mxINT32_CLASS:
		return static_cast<Ty>(*reinterpret_cast<const mxInt32 *>(ptr));
	case mxUINT32_CLASS:
		return static_cast<Ty>(*reinterpret_cast<const mxUint32 *>(ptr));
	case mxSINGLE_CLASS:
		return static_cast<Ty>(*reinterpret_cast<const mxSingle *>(ptr));
	case mxDOUBLE_CLASS:
		return static_cast<Ty>(*reinterpret_cast<const mxDouble *>(ptr));
	case mxINT64_CLASS:
		return static_cast<Ty>(*reinterpret_cast<const mxInt64 *>(ptr));
	case mxUINT64_CLASS:
		return static_cast<Ty>(*reinterpret_cast<const mxUint64 *>(ptr));
	default:
		abortWithMsg("derefAndCast: Unknown class ID");
		return Ty(); // NOTE: This will never run as mexErrMsgIdAndTxt aborts execution
	}
}

inline bool isRealNumeric(const mxArray *a)
{
    return (mxIsNumeric(a) || mxIsLogical(a)) && !mxIsComplex(a);
}

inline bool isVector(const mxArray *a)
{
    return mxGetNumberOfDimensions(a) == 2 && (mxGetN(a) == 1 || mxGetM(a) == 1);
}

inline bool isMatrix(const mxArray *a)
{
    return mxGetNumberOfDimensions(a) == 2;
}

inline bool isVolume(const mxArray *a)
{
    return mxGetNumberOfDimensions(a) <= 3;
}

inline bool isRealVector(const mxArray *a)
{
	return isVector(a) && isRealNumeric(a);
}

inline bool isRealMatrix(const mxArray *a)
{
    return isMatrix(a) && isRealNumeric(a);
}

inline bool isRealVolume(const mxArray *a)
{
    return isVolume(a) && isRealNumeric(a);
}

inline void ensureRealVector(const mxArray *a, const char *errPrefix = "value")
{
    ensureOrError(isRealVector(a), "%d must a real numeric vector", errPrefix);
}

inline void ensureRealMatrix(const mxArray *a, const char *errPrefix = "value")
{
    ensureOrError(isRealMatrix(a), "%s must a real numeric matrix", errPrefix);
}

inline void ensureRealNumericVolume(const mxArray *a, const char *errPrefix = "value")
{
    ensureOrError(isRealVolume(a), "%s must be a real numeric volume", errPrefix);
}

template <class Ty>
void ensureValue(Ty value, std::initializer_list<Ty> validValues, const char *errPrefix = "value")
{
    for (const auto& v : validValues) {
        if (v == value) {
            return;
        }
    }
    abortWithMsg("Invalid value of %", errPrefix);
}

inline int3 volSize(const mxArray *a)
{
    int3 size;
    const mwSize *dims = mxGetDimensions(a);
    size.x = dims[0];
    size.y = dims[1];
    size.z = mxGetNumberOfDimensions(a) > 2 ? dims[2] : 1;
    return size;
}

inline int3 getValidatedInt3(const mxArray *a, const char *errPrefix = "value")
{
    int3 out;
    ensureRealVector(a);
    ensureOrError(mxGetNumberOfElements(a) == 3, "%s must have 3 elements", errPrefix);
    const uint8_t *data = static_cast<const uint8_t *>(mxGetData(a));
    const size_t elemSize = mxGetElementSize(a);
    const mxClassID cid = mxGetClassID(a);
    out.x = derefAndCast<int>(data + 0 * elemSize, cid);
    out.y = derefAndCast<int>(data + 1 * elemSize, cid);
    out.z = derefAndCast<int>(data + 2 * elemSize, cid);
    return out;
}

inline int getValidatedMorphOp(const mxArray *a)
{
    ensureOrError(mxIsScalar(a) && isRealNumeric(a), "op must be a real numeric scalar");
    int op = static_cast<int>(mxGetScalar(a));
    ensureValue<int>(op, { MOP_DILATE, MOP_ERODE, MOP_OPEN, MOP_CLOSE, MOP_TOPHAT, MOP_BOTHAT }, "op");
    return op;
}

inline mxArray *createVolumeLike(const mxArray *a)
{
    int3 size = volSize(a);
    size_t sizeArray[3] = { size.x, size.y, size.z };
    return mxCreateUninitNumericArray(mxGetNumberOfDimensions(a), sizeArray, mxGetClassID(a), mxREAL);
}

#endif // MEX_COMMON_CUH__