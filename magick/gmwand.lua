local lib
lib = require("magick.gmwand.lib").lib
lib.InitializeMagick(nil)
local Image
Image = require("magick.gmwand.image").Image
local make_thumb
make_thumb = require("magick.thumb").make_thumb
local load_image
do
  local _base_0 = Image
  local _fn_0 = _base_0.load
  load_image = function(...)
    return _fn_0(_base_0, ...)
  end
end
return {
  VERSION = require("magick.version"),
  mode = "graphics_magick",
  Image = Image,
  load_image = load_image,
  thumb = make_thumb(load_image),
  load_image_from_blob = (function()
    local _base_0 = Image
    local _fn_0 = _base_0.load_from_blob
    return function(...)
      return _fn_0(_base_0, ...)
    end
  end)()
}
