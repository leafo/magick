local ffi = require("ffi")
ffi.cdef([[  typedef void MagickWand;
  typedef void PixelWand;

  typedef int MagickBooleanType;
  typedef int ExceptionType;
  typedef int ssize_t;
  typedef int CompositeOperator;
  typedef int GravityType;
  typedef int ColorspaceType;
  typedef int AlphaChannelOption;

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
  MagickBooleanType MagickSetImageColorspace(MagickWand* wand, const ColorspaceType colorspace);
  MagickBooleanType MagickTransformImageColorspace(MagickWand *wand, const ColorspaceType colorspace);
  MagickBooleanType MagickSepiaToneImage(MagickWand* wand, const double threshold);
  MagickBooleanType MagickSolarizeImage(MagickWand* wand, const double threshold);
  MagickBooleanType MagickSetImageAlpha(MagickWand*, const double);
  MagickBooleanType MagickSetImageAlphaChannel(MagickWand*, const AlphaChannelOption);
  MagickBooleanType MagickSetImageBackgroundColor(MagickWand *wand, const PixelWand *background);
  MagickBooleanType MagickNewImage(MagickWand *wand, const size_t columns,const size_t rows, const PixelWand *background);
  MagickBooleanType MagickBrightnessContrastImage(MagickWand *wand, const double brightness,const double contrast);



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

  void PixelSetColor(PixelWand *wand, const char *color);
  void PixelSetAlpha(PixelWand *wand, const double alpha);
  void PixelSetRed(PixelWand *wand, const double red);
  void PixelSetGreen(PixelWand *wand, const double green);
  void PixelSetBlue(PixelWand *wand, const double blue);
]])
local get_flags
get_flags = function()
  local proc = io.popen("pkg-config --cflags --libs MagickWand", "r")
  local flags = proc:read("*a")
  get_flags = function()
    return flags
  end
  proc:close()
  return flags
end
local get_filters
get_filters = function()
  local fname = "magick/resample.h"
  local prefixes = {
    "/usr/include/ImageMagick",
    "/usr/local/include/ImageMagick",
    unpack((function()
      local _accum_0 = { }
      local _len_0 = 1
      for p in get_flags():gmatch("-I([^%s]+)") do
        _accum_0[_len_0] = p
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end)())
  }
  for _index_0 = 1, #prefixes do
    local p = prefixes[_index_0]
    local full = tostring(p) .. "/" .. tostring(fname)
    do
      local f = io.open(full)
      if f then
        local content
        do
          local _with_0 = f:read("*a")
          f:close()
          content = _with_0
        end
        local filter_types = content:match("(typedef enum.-FilterTypes;)")
        if filter_types then
          ffi.cdef(filter_types)
          return true
        end
      end
    end
  end
  return false
end
local can_resize
if get_filters() then
  ffi.cdef([[    MagickBooleanType MagickResizeImage(MagickWand*,
      const size_t, const size_t,
      const FilterTypes, const double);
  ]])
  can_resize = true
end
local try_to_load
try_to_load = function(...)
  local out
  local _list_0 = {
    ...
  }
  for _index_0 = 1, #_list_0 do
    local _continue_0 = false
    repeat
      local name = _list_0[_index_0]
      if "function" == type(name) then
        name = name()
        if not (name) then
          _continue_0 = true
          break
        end
      end
      if pcall(function()
        out = ffi.load(name)
      end) then
        return out
      end
      _continue_0 = true
    until true
    if not _continue_0 then
      break
    end
  end
  return error("Failed to load ImageMagick (" .. tostring(...) .. ")")
end
local lib = try_to_load("MagickWand", function()
  local lname = get_flags():match("-l(MagickWand[^%s]*)")
  local suffix
  if ffi.os == "OSX" then
    suffix = ".dylib"
  elseif ffi.os == "Windows" then
    suffix = ".dll"
  else
    suffix = ".so"
  end
  return lname and "lib" .. lname .. suffix
end)
return {
  lib = lib,
  can_resize = can_resize
}
