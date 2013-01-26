local ffi = require("ffi")
ffi.cdef([[  typedef void MagickWand;

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
]])
local lib = ffi.load("MagickWand")
local filter
filter = function(name)
  return lib[name .. "Filter"]
end
local get_exception
get_exception = function(wand)
  local etype = ffi.new("ExceptionType[1]", 0)
  local msg = ffi.string(lib.MagickGetException(wand, etype))
  return etype[0], msg
end
local handle_result
handle_result = function(img_or_wand, status)
  local wand = img_or_wand.wand or img_or_wand
  if status == 0 then
    local code, msg = get_exception(wand)
    return nil, msg, code
  else
    return true
  end
end
local Image
do
  local _parent_0 = nil
  local _base_0 = {
    get_width = function(self)
      return lib.MagickGetImageWidth(self.wand)
    end,
    get_height = function(self)
      return lib.MagickGetImageHeight(self.wand)
    end,
    resize = function(self, w, h, f, sharp)
      if f == nil then
        f = "Lanczos2"
      end
      if sharp == nil then
        sharp = 1.0
      end
      return handle_result(self, lib.MagickResizeImage(self.wand, w, h, filter(f), sharp))
    end,
    adaptive_resize = function(self, w, h)
      return handle_result(self, lib.MagickAdaptiveResizeImage(self.wand, w, h))
    end,
    get_blob = function(self)
      local len = ffi.new("size_t[1]", 0)
      local blob = lib.MagickGetImageBlob(self.wand, len)
      return ffi.string(blob, len[0])
    end,
    write = function(self, fname)
      return handle_result(self, lib.MagickWriteImage(self.wand, fname))
    end,
    destroy = function(self)
      lib.DestroyMagickWand(self.wand)
      self.wand = nil
    end,
    __tostring = function(self)
      return "Image<" .. tostring(self.path) .. ", " .. tostring(self.wand) .. ">"
    end
  }
  _base_0.__index = _base_0
  if _parent_0 then
    setmetatable(_base_0, _parent_0.__base)
  end
  local _class_0 = setmetatable({
    __init = function(self, wand, path)
      self.wand, self.path = wand, path
    end,
    __base = _base_0,
    __name = "Image",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil and _parent_0 then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0 and _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Image = _class_0
end
local load_image
load_image = function(path)
  local wand = lib.NewMagickWand()
  local status = lib.MagickReadImage(wand, path)
  if status == 0 then
    local code, msg = get_exception(wand)
    lib.DestroyMagickWand(wand)
    return nil, msg, code
  end
  return Image(wand, path)
end
return {
  load_image = load_image,
  Image = Image
}
