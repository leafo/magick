ffi = require "ffi"

ffi.cdef [[
  void InitializeMagick( const char *path );
  typedef void MagickWand;
  typedef unsigned int MagickPassFail;
  typedef int ExceptionType;

  typedef enum {
    UndefinedFilter
  } FilterTypes;

  MagickWand *NewMagickWand();
  MagickPassFail MagickReadImage(MagickWand *,const char *);
  MagickPassFail MagickReadImageBlob(MagickWand *,const unsigned char *,const size_t length);
  MagickPassFail MagickWriteImage(MagickWand *,const char *);

  MagickPassFail DestroyMagickWand(MagickWand *);
  MagickPassFail MagickRelinquishMemory(void *);

  char* MagickGetException(const MagickWand*, ExceptionType*);

  unsigned long MagickGetImageHeight(MagickWand *);
  unsigned long MagickGetImageWidth(MagickWand *);

  MagickPassFail MagickScaleImage(MagickWand *,const unsigned long,const unsigned long);
  MagickPassFail MagickResizeImage(MagickWand *,const unsigned long,const unsigned long, const FilterTypes,const double);
  MagickPassFail MagickCropImage(MagickWand *,const unsigned long,const unsigned long, const long,const long);

  char *MagickGetImageFormat(MagickWand *);
  MagickPassFail MagickSetImageFormat(MagickWand *wand,const char *format);
]]

gmwand = ffi.load "GraphicsMagickWand"

{ lib: gmwand }

