local load_image, load_image_from_blob, thumb
do
  local _obj_0 = require("magick")
  load_image, load_image_from_blob, thumb = _obj_0.load_image, _obj_0.load_image_from_blob, _obj_0.thumb
end
local _exp_0 = ...
if "icon" == _exp_0 then
  local img = load_image("hi.png")
  img:resize(16, 16)
  return img:write("favicon.ico")
elseif "resize" == _exp_0 then
  local img = load_image("hi.png")
  img:resize(nil, 80)
  return img:write("out.png")
elseif "resize2" == _exp_0 then
  local img = load_image("hi.png")
  img:resize_and_crop(500, 1000)
  return img:write("out.png")
elseif "blur" == _exp_0 then
  local img = load_image("hi.png")
  img:blur(3, 10)
  return img:write("out.png")
elseif "clone" == _exp_0 then
  local img = load_image("hi.png")
  local img2 = img:clone()
  img2:resize(50, 50)
  print("first: " .. tostring(img:get_width()) .. ", " .. tostring(img:get_height()))
  return print("second: " .. tostring(img2:get_width()) .. ", " .. tostring(img2:get_height()))
elseif "blob" == _exp_0 then
  local img = load_image("hi.png")
  local blob = img:get_blob()
  local img2 = load_image_from_blob(blob)
  return print(img2, img2:get_width(), img2:get_height())
elseif "thumb" == _exp_0 then
  thumb("hi.png", "150x200", "out.png")
  thumb("hi.png", "150x200#", "out2.png")
  return thumb("hi.png", "30x30+20+20", "out3.png")
elseif "format" == _exp_0 then
  local img = load_image("hi.png")
  print(img:set_format("bmp"))
  return print(img:get_format())
elseif "set_quality" == _exp_0 then
  local img = load_image("hi.png")
  img:set_quality(90)
  return img:write("out.png")
elseif "get_quality" == _exp_0 then
  local img = load_image("hi.png")
  img:set_quality(90)
  return print("quality of hi.png is " .. tostring(img:get_quality()))
elseif "sharpen" == _exp_0 then
  local img = load_image("hi.png")
  img:sharpen(1)
  return img:write("out.png")
elseif "set_gravity" == _exp_0 then
  local img = load_image("hi.png")
  img:set_gravity("SouthEastGravity")
  return img:write("out.png")
elseif "get_gravity" == _exp_0 then
  local img = load_image("hi.png")
  img:set_gravity("SouthEastGravity")
  return print(img:get_gravity())
elseif "set_option" == _exp_0 then
  local img = load_image("hi.png")
  img:set_option("webp", "lossless", "0")
  return img:write("out.png")
elseif "get_option" == _exp_0 then
  local img = load_image("hi.png")
  img:set_option("webp", "lossless", "0")
  local o = img:get_option("webp", "lossless")
  return print("webp(lossless) option of hi.png is " .. tostring(o))
elseif "scale" == _exp_0 then
  local img = load_image("hi.png")
  img:scale(80)
  return img:write("out.png")
elseif "composite" == _exp_0 then
  local img = load_image("hi.png")
  local img1 = load_image("hi2.png")
  local rt = img:composite(img1.wand, 0, 0)
  print(rt)
  return img:write("out.png")
else
  return error("don't know what to do")
end
