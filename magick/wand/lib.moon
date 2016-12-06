ffi = require "ffi"

local lib

ffi.cdef [[
  typedef void MagickWand;
  typedef void PixelWand;

  typedef int MagickBooleanType;
  typedef int ExceptionType;
  typedef int ssize_t;
  typedef int CompositeOperator;
  typedef int GravityType;
  typedef int OrientationType;
  typedef int InterlaceType;

  void MagickWandGenesis();
  MagickWand* NewMagickWand();
  MagickWand* DestroyMagickWand(MagickWand*);
  MagickBooleanType MagickReadImage(MagickWand*, const char*);
  MagickBooleanType MagickReadImageBlob(MagickWand*, const void*, const size_t);

  char* MagickGetException(const MagickWand*, ExceptionType*);

  int MagickGetImageWidth(MagickWand*);
  int MagickGetImageHeight(MagickWand*);

  MagickBooleanType MagickAddImage(MagickWand*, const MagickWand*);

  MagickBooleanType MagickAdaptiveResizeImage(MagickWand*, const size_t, const size_t);

  MagickBooleanType MagickWriteImage(MagickWand*, const char*);

  unsigned char* MagickGetImageBlob(MagickWand*, size_t*);

  void* MagickRelinquishMemory(void*);

  MagickBooleanType MagickCropImage(MagickWand*,
    const size_t, const size_t, const ssize_t, const ssize_t);

  MagickBooleanType MagickBlurImage(MagickWand*, const double, const double);

  MagickBooleanType MagickSetImageFormat(MagickWand* wand, const char* format);
  char* MagickGetImageFormat(MagickWand* wand);

  size_t MagickGetImageCompressionQuality(MagickWand * wand);
  MagickBooleanType MagickSetImageCompressionQuality(MagickWand *wand,
  const size_t quality);

  MagickBooleanType MagickSharpenImage(MagickWand *wand,
    const double radius,const double sigma);

  MagickBooleanType MagickScaleImage(MagickWand *wand,
    const size_t columns,const size_t rows);

  MagickBooleanType MagickRotateImage(MagickWand *wand,
  const PixelWand *background,const double degrees);

  MagickBooleanType MagickSetOption(MagickWand *,const char *,const char *);
  char* MagickGetOption(MagickWand *,const char *);

  MagickBooleanType MagickCompositeImage(MagickWand *wand,
    const MagickWand *source_wand,const CompositeOperator compose,
    const ssize_t x,const ssize_t y);

  GravityType MagickGetImageGravity(MagickWand *wand);
  MagickBooleanType MagickSetImageGravity(MagickWand *wand,
    const GravityType gravity);

  MagickBooleanType MagickStripImage(MagickWand *wand);

  MagickBooleanType MagickGetImagePixelColor(MagickWand *wand,
    const ssize_t x,const ssize_t y,PixelWand *color);

  MagickWand* MagickCoalesceImages(MagickWand*);

  PixelWand *NewPixelWand(void);
  PixelWand *DestroyPixelWand(PixelWand *);

  double PixelGetAlpha(const PixelWand *);
  double PixelGetRed(const PixelWand *);
  double PixelGetGreen(const PixelWand *);
  double PixelGetBlue(const PixelWand *);

  void PixelSetAlpha(PixelWand *wand, const double alpha);
  void PixelSetRed(PixelWand *wand, const double red);
  void PixelSetGreen(PixelWand *wand, const double green);
  void PixelSetBlue(PixelWand *wand, const double blue);

  MagickBooleanType MagickTransposeImage(MagickWand *wand);

  MagickBooleanType MagickTransverseImage(MagickWand *wand);

  MagickBooleanType MagickFlipImage(MagickWand *wand);

  MagickBooleanType MagickFlopImage(MagickWand *wand);

  char* MagickGetImageProperty(MagickWand *wand, const char *property);
  MagickBooleanType MagickSetImageProperty(MagickWand *wand,
    const char *property,const char *value);

  OrientationType MagickGetImageOrientation(MagickWand *wand);
  MagickBooleanType MagickSetImageOrientation(MagickWand *wand,
    const OrientationType orientation);

  InterlaceType MagickGetInterlaceScheme(MagickWand *wand);
  MagickBooleanType MagickSetInterlaceScheme(MagickWand *wand,
    const InterlaceType interlace_scheme);

  MagickBooleanType MagickAutoOrientImage(MagickWand *wand);
]]


get_flags = ->
  proc = io.popen "pkg-config --cflags --libs MagickWand", "r"
  flags = proc\read "*a"
  get_flags = -> flags
  proc\close!
  flags

get_filters = ->
  fname = "magick/resample.h"
  prefixes = {
    "/usr/include/ImageMagick"
    "/usr/local/include/ImageMagick"
    unpack [p for p in get_flags!\gmatch "-I([^%s]+)"]
  }

  for p in *prefixes
    full = "#{p}/#{fname}"
    if f = io.open full
      content = with f\read "*a" do f\close!
      filter_types = content\match "(typedef enum.-FilterTypes;)"
      if filter_types
        ffi.cdef filter_types
        return true

  false

get_filter = (name) ->
  lib[name .. "Filter"]

can_resize = if get_filters!
  ffi.cdef [[
    MagickBooleanType MagickResizeImage(MagickWand*,
      const size_t, const size_t,
      const FilterTypes, const double);
  ]]
  true

try_to_load = (...) ->
  local out
  for name in *{...}
    if "function" == type name
      name = name!
      continue unless name

    return out if pcall ->
      out = ffi.load name

  error "Failed to load ImageMagick (#{...})"

lib = try_to_load "MagickWand", ->
  lname = get_flags!\match "-l(MagickWand[^%s]*)"
  local suffix
  if ffi.os == "OSX"
     suffix = ".dylib"
  elseif ffi.os == "Windows"
     suffix = ".dll"
  else
     suffix = ".so"

  lname and "lib" .. lname .. suffix

{ :lib, :can_resize, :get_filter }
