
ffi = require "ffi"

ffi.cdef [[
  typedef void MagickWand;

  typedef int MagickBooleanType;
  typedef int ExceptionType;
  typedef int ssize_t;

  void MagickWandGenesis();
  MagickWand* NewMagickWand();
  MagickWand* DestroyMagickWand(MagickWand*);
  MagickBooleanType MagickReadImage(MagickWand*, const char*);
  MagickBooleanType MagickReadImageBlob(MagickWand*, const void*, const size_t);

  const char* MagickGetException(const MagickWand*, ExceptionType*);

  int MagickGetImageWidth(MagickWand*);
  int MagickGetImageHeight(MagickWand*);

  MagickBooleanType MagickAddImage(MagickWand*, const MagickWand*);

  MagickBooleanType MagickAdaptiveResizeImage(MagickWand*, const size_t, const size_t);

  MagickBooleanType MagickWriteImage(MagickWand*, const char*);

  unsigned char* MagickGetImageBlob(MagickWand*, size_t*);

  MagickBooleanType MagickCropImage(MagickWand*,
    const size_t, const size_t, const ssize_t, const ssize_t);

  MagickBooleanType MagickBlurImage(MagickWand*, const double, const double);

  MagickBooleanType MagickSetImageFormat(MagickWand* wand, const char* format);
  const char* MagickGetImageFormat(MagickWand* wand);
]]

get_flags = ->
  proc = io.popen "MagickWand-config --cflags --libs", "r"
  flags = proc\read "*a"
  get_flags = -> flags
  proc\close!
  flags

get_filters = ->
  fname = "magick/resample.h"
  prefixes = {
    "/usr/include/ImageMagick"
    "/usr/local/include/ImageMagick"
    -> get_flags!\match("-I([^%s]+)")
  }

  for p in *prefixes
    if "function" == type p
      p = p!
      continue unless p

    full = "#{p}/#{fname}"
    if f = io.open full
      content = with f\read "*a" do f\close!
      filter_types = content\match "(typedef enum.-FilterTypes;)"
      if filter_types
        ffi.cdef filter_types
        return true

  false

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
  lname and "lib" .. lname .. ".so"

can_resize = if get_filters!
  ffi.cdef [[
    MagickBooleanType MagickResizeImage(MagickWand*,
      const size_t, const size_t,
      const FilterTypes, const double);
  ]]
  true

lib.MagickWandGenesis!

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
  get_format: => ffi.string(lib.MagickGetImageFormat @wand)\lower!
  set_format: (format) =>
    handle_result @,
      lib.MagickSetImageFormat @wand, format

  _keep_aspect: (w,h) =>
    if not w and h
      @get_width! / @get_height! * h, h
    elseif w and not h
      w, @get_height! / @get_width! * w
    else
      w,h

  clone: =>
    wand = lib.NewMagickWand!
    lib.MagickAddImage wand, @wand
    Image wand, @path

  resize: (w,h, f="Lanczos2", sharp=1.0) =>
    error "Failed to load filter list, can't resize" unless can_resize
    w, h = @_keep_aspect w,h
    handle_result @,
      lib.MagickResizeImage @wand, w, h, filter(f), sharp

  adaptive_resize: (w,h) =>
    w, h = @_keep_aspect w,h
    handle_result @,
      lib.MagickAdaptiveResizeImage @wand, w, h

  crop: (w,h, x=0, y=0) =>
    handle_result @,
      lib.MagickCropImage @wand, w, h, x, y

  blur: (sigma, radius=0) =>
    handle_result @,
      lib.MagickBlurImage @wand, radius, sigma

  -- resize but crop image to maintain aspect ratio
  resize_and_crop: (w,h) =>
    src_w, src_h = @get_width!, @get_height!

    ar_src = src_w / src_h
    ar_dest = w / h

    if ar_dest > ar_src
      new_height = w / ar_src
      @resize w, new_height
      @crop w, h, 0, (new_height - h) / 2
    else
      new_width = h * ar_src
      @resize new_width, h
      @crop w, h, (new_width - w) / 2, 0

  get_blob: =>
    len = ffi.new "size_t[1]", 0
    blob = lib.MagickGetImageBlob @wand, len
    ffi.string blob, len[0]

  write: (fname) =>
    handle_result @, lib.MagickWriteImage @wand, fname

  destroy: =>
    lib.DestroyMagickWand @wand if @wand
    @wand = nil

  __tostring: =>
    "Image<#{@path}, #{@wand}>"

load_image = (path) ->
  wand = lib.NewMagickWand!
  if 0 == lib.MagickReadImage wand, path
    code, msg = get_exception wand
    lib.DestroyMagickWand wand
    return nil, msg, code
  
  Image wand, path

load_image_from_blob = (blob) ->
  wand = lib.NewMagickWand!
  if 0 == lib.MagickReadImageBlob wand, blob, #blob
    code, msg = get_exception wand
    lib.DestroyMagickWand wand
    return nil, msg, code

  Image wand, "<from_blob>"

tonumber = tonumber
parse_size_str = (str, src_w, src_h) ->
  w, h, rest = str\match "^(%d*%%?)x(%d*%%?)(.*)$"
  return nil, "failed to parse string (#{str})" if not w

  if p = w\match "(%d+)%%"
    w = tonumber(p) / 100 * src_w
  else
    w = tonumber w

  if p = h\match "(%d+)%%"
    h = tonumber(p) / 100 * src_h
  else
    h = tonumber h

  center_crop = rest\match"#" and true

  -- by default we use the dimensions as max sizes
  if w and h and not center_crop
    unless rest\match"!"
      if src_w/src_h > w/h
        h = nil
      else
        w = nil

  crop_x, crop_y = rest\match "%+(%d+)%+(%d+)"
  if crop_x
    crop_x = tonumber crop_x
    crop_y = tonumber crop_y

  {
    :w, :h
    :crop_x, :crop_y
    :center_crop
  }

thumb = (img, size_str, output) ->
  if type(img) == "string"
    img = assert load_image img

  src_w, src_h = img\get_width!, img\get_height!
  opts = parse_size_str size_str, src_w, src_h

  if opts.center_crop
    img\resize_and_crop opts.w, opts.h
  elseif opts.crop_x
    img\crop opts.w, opts.h, opts.crop_x, opts.crop_y
  else
    img\resize opts.w, opts.h

  ret = if output
    img\write output
  else
    img\get_blob!

  img\destroy!
  ret

if ... == "test"
  w,h = 500,300
  D = (t) -> print table.concat ["#{k}: #{v}" for k,v in pairs t], ", "

  D parse_size_str "10x10", w,h

  D parse_size_str "50%x50%", w,h
  D parse_size_str "50%x50%!", w,h

  D parse_size_str "x10", w,h
  D parse_size_str "10x%", w,h
  D parse_size_str "10x10%#", w,h

  D parse_size_str "200x300", w,h
  D parse_size_str "200x300!", w,h
  D parse_size_str "200x300+10+10", w,h


{ :load_image, :load_image_from_blob, :thumb, :Image }

