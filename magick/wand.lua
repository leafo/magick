local ffi = require("ffi")
local lib, can_resize
do
  local _obj_0 = require("magick.wand.lib")
  lib, can_resize = _obj_0.lib, _obj_0.can_resize
end
lib.MagickWandGenesis()
local Image
Image = require("magick.wand.image").Image
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
  mode = "image_magick",
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
