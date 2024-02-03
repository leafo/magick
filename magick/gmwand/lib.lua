local cffi = require("cffi")
cffi.cdef([[  void InitializeMagick( const char *path );
  typedef void MagickWand;
  typedef void PixelWand;
  typedef unsigned int MagickPassFail;
  typedef int CompositeOperator;
  typedef int ExceptionType;

  typedef enum {
    UndefinedFilter
  } FilterTypes;

  typedef enum {
    UndefinedOrientation
  } OrientationType;

  typedef enum {
    UndefinedColorspace,
  } ColorspaceType;

  MagickWand *NewMagickWand();
  MagickWand *CloneMagickWand(const MagickWand *wand);

  MagickPassFail MagickReadImage(MagickWand *,const char *);
  MagickPassFail MagickReadImageBlob(MagickWand *,const unsigned char *,const size_t length);
  MagickPassFail MagickWriteImage(MagickWand *,const char *);

  MagickWand *MagickGetImage(MagickWand*);

  unsigned char *MagickWriteImageBlob(MagickWand *,size_t *);

  MagickPassFail DestroyMagickWand(MagickWand *);
  MagickPassFail MagickRelinquishMemory(void *);

  char* MagickGetException(const MagickWand*, ExceptionType*);

  unsigned long MagickGetImageHeight(MagickWand *);
  unsigned long MagickGetImageWidth(MagickWand *);

  MagickPassFail MagickScaleImage(MagickWand *,const unsigned long,const unsigned long);
  MagickPassFail MagickResizeImage(MagickWand *,const unsigned long,const unsigned long, const FilterTypes,const double);
  MagickPassFail MagickCropImage(MagickWand *,const unsigned long,const unsigned long, const long,const long);

  MagickPassFail MagickCompositeImage(MagickWand *, const MagickWand *, const CompositeOperator, const long, const long);

  MagickPassFail MagickBlurImage(MagickWand*, const double, const double);
  MagickPassFail MagickModulateImage(MagickWand*, const double, const double, const double);

  MagickPassFail MagickSharpenImage(MagickWand *wand,
    const double radius,const double sigma);

  char *MagickGetImageFormat(MagickWand *);
  MagickPassFail MagickSetImageFormat(MagickWand *wand,const char *format);

  unsigned int MagickSetImagePage(MagickWand *wand, const unsigned long width,const unsigned long height,const long x, const long y);

  unsigned int MagickAutoOrientImage(MagickWand *wand,const OrientationType);

  MagickPassFail MagickSetImageDepth(MagickWand *,const unsigned long);
  unsigned long MagickGetImageDepth(MagickWand *);

  MagickPassFail MagickSetCompressionQuality(MagickWand *wand,const unsigned long quality);

  ColorspaceType MagickGetImageColorspace(MagickWand *);
  MagickPassFail MagickSetImageColorspace(MagickWand *, const ColorspaceType);
  MagickPassFail MagickLevelImage(MagickWand *,const double,const double,const double);
  MagickPassFail MagickHaldClutImage(MagickWand *wand,const MagickWand *clut_wand);

  PixelWand *NewPixelWand( void );
  MagickPassFail DestroyPixelWand( PixelWand *wand );

  double PixelGetRed( const PixelWand *wand );
  double PixelGetGreen( const PixelWand *wand );
  double PixelGetBlue( const PixelWand *wand );
  double PixelGetOpacity( const PixelWand *wand );

  void PixelSetRed(PixelWand *,const double);
  void PixelSetGreen(PixelWand *,const double);
  void PixelSetBlue(PixelWand *,const double);
  void PixelSetOpacity(PixelWand *,const double);

  char *PixelGetColorAsString( PixelWand *wand );

  MagickPassFail MagickGetImageBackgroundColor(MagickWand *,PixelWand *);
  MagickPassFail MagickSetImageBackgroundColor(MagickWand *,const PixelWand *);
  MagickPassFail MagickSetSize(MagickWand *,const unsigned long,const unsigned long);

]])
local gmwand = cffi.load("GraphicsMagickWand")
return {
  lib = gmwand
}
