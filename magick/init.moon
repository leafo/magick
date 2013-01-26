
ffi = require "ffi"

ffi.cdef [[
  typedef void MagickWand;

  typedef int MagickBooleanType;
  typedef int ExceptionType;

  typedef enum
  {
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
    JincFilter,
    SincFilter,
    SincFastFilter,
    KaiserFilter,
    WelshFilter,
    ParzenFilter,
    BohmanFilter,
    BartlettFilter,
    LagrangeFilter,
    LanczosFilter,
    LanczosSharpFilter,
    Lanczos2Filter,
    Lanczos2SharpFilter,
    RobidouxFilter,
    RobidouxSharpFilter,
    CosineFilter,
    SplineFilter,
    LanczosRadiusFilter,
    SentinelFilter
  } FilterTypes;

  MagickWand* NewMagickWand();
  MagickWand* DestroyMagickWand(MagickWand*);
  MagickBooleanType MagickReadImage(MagickWand*, const char*);
  const char* MagickGetException(const MagickWand*, ExceptionType*);

  int MagickGetImageWidth(MagickWand*);
  int MagickGetImageHeight(MagickWand*);


  MagickBooleanType MagickResizeImage(MagickWand*,
    const size_t, const size_t,
    const FilterTypes, const double);

  MagickBooleanType MagickAdaptiveResizeImage(MagickWand*, const size_t, const size_t);

  MagickBooleanType MagickWriteImage(MagickWand*, const char*);

  unsigned char* MagickGetImageBlob(MagickWand*, size_t*);
]]

lib = ffi.load "MagickWand"

filter = (name) -> lib[name .. "Filter"]

get_exception = (wand) ->
  etype = ffi.new "ExceptionType[1]", 0
  msg = ffi.string lib.MagickGetException wand, etype
  etype[0], msg

handle_result = (img_or_wand, status) ->
  wand = img_or_wand.wand or img_or_wand
  if status == 0
    code, msg = get_exception wand
    nil, msg, code
  else
    true

class Image
  new: (@wand, @path) =>
  get_width: => lib.MagickGetImageWidth @wand
  get_height: => lib.MagickGetImageHeight @wand

  resize: (w,h, f="Lanczos2", sharp=1.0) =>
    handle_result @,
      lib.MagickResizeImage @wand, w, h, filter(f), sharp

  adaptive_resize: (w,h) =>
    handle_result @,
      lib.MagickAdaptiveResizeImage @wand, w, h

  get_blob: =>
    len = ffi.new "size_t[1]", 0
    blob = lib.MagickGetImageBlob @wand, len
    ffi.string blob, len[0]

  write: (fname) =>
    handle_result @, lib.MagickWriteImage @wand, fname

  destroy: =>
    lib.DestroyMagickWand @wand
    @wand = nil

  __tostring: =>
    "Image<#{@path}, #{@wand}>"

load_image = (path) ->
  wand = lib.NewMagickWand!
  status = lib.MagickReadImage wand, path
  if status == 0
    code, msg = get_exception wand
    lib.DestroyMagickWand wand
    return nil, msg, code
  
  Image wand, path

{ :load_image, :Image }

