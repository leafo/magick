local VERSION = "1.1.0"
local Image, load_image, load_image_from_blob
do
  local _obj_0 = require("magick.wand")
  Image, load_image, load_image_from_blob = _obj_0.Image, _obj_0.load_image, _obj_0.load_image_from_blob
end
local tonumber = tonumber
local parse_size_str
parse_size_str = function(str, src_w, src_h)
  local w, h, rest = str:match("^(%d*%%?)x(%d*%%?)(.*)$")
  if not w then
    return nil, "failed to parse string (" .. tostring(str) .. ")"
  end
  do
    local p = w:match("(%d+)%%")
    if p then
      w = tonumber(p) / 100 * src_w
    else
      w = tonumber(w)
    end
  end
  do
    local p = h:match("(%d+)%%")
    if p then
      h = tonumber(p) / 100 * src_h
    else
      h = tonumber(h)
    end
  end
  local center_crop = rest:match("#") and true
  local crop_x, crop_y = rest:match("%+(%d+)%+(%d+)")
  if crop_x then
    crop_x = tonumber(crop_x)
    crop_y = tonumber(crop_y)
  else
    if w and h and not center_crop then
      if not (rest:match("!")) then
        if src_w / src_h > w / h then
          h = nil
        else
          w = nil
        end
      end
    end
  end
  return {
    w = w,
    h = h,
    crop_x = crop_x,
    crop_y = crop_y,
    center_crop = center_crop
  }
end
local thumb
thumb = function(img, size_str, output)
  if type(img) == "string" then
    img = assert(load_image(img))
  end
  local src_w, src_h = img:get_width(), img:get_height()
  local opts = parse_size_str(size_str, src_w, src_h)
  if opts.center_crop then
    img:resize_and_crop(opts.w, opts.h)
  elseif opts.crop_x then
    img:crop(opts.w, opts.h, opts.crop_x, opts.crop_y)
  else
    img:resize(opts.w, opts.h)
  end
  local ret
  if output then
    ret = img:write(output)
  else
    ret = img:get_blob()
  end
  return ret
end
return {
  load_image = load_image,
  load_image_from_blob = load_image_from_blob,
  thumb = thumb,
  Image = Image,
  parse_size_str = parse_size_str,
  VERSION = VERSION
}
