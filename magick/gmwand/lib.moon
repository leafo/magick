ffi = require "ffi"

ffi.cdef [[
  void InitializeMagick( const char *path );
  typedef void MagickWand;
  typedef unsigned int MagickPassFail;
  typedef int ExceptionType;

  typedef enum {
    UndefinedFilter,
    PointFilter,
    BoxFilter,
    TriangleFilter,
    HermiteFilter,
    HanningFilter,
    HammingFilter,
    BlackmanFilter,
    GaussianFilter,
    QuadraticFilter,
    CubicFilter,
    CatromFilter,
    MitchellFilter,
    LanczosFilter,
    BesselFilter,
    SincFilter
  } FilterTypes;

  MagickWand *NewMagickWand();
  MagickPassFail MagickReadImage(MagickWand *,const char *);
  MagickPassFail MagickReadImageBlob(MagickWand *,const unsigned char *,const size_t length);
  MagickPassFail MagickWriteImage(MagickWand *,const char *);

  MagickPassFail MagickResizeImage(MagickWand *,const unsigned long,const unsigned long, const FilterTypes, const double);
  MagickPassFail DestroyMagickWand(MagickWand *);
  MagickPassFail MagickRelinquishMemory(void *);

  char* MagickGetException(const MagickWand*, ExceptionType*);

  unsigned long MagickGetImageHeight(MagickWand *);
  unsigned long MagickGetImageWidth(MagickWand *);

  char *MagickGetImageFormat(MagickWand *);
  MagickPassFail MagickSetImageFormat(MagickWand *wand,const char *format);
]]

gmwand = ffi.load "GraphicsMagickWand"

{ lib: gmwand }

