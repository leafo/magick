local load_image, load_image_from_blob, thumb
do
  local _table_0 = require("magick")
  load_image, load_image_from_blob, thumb = _table_0.load_image, _table_0.load_image_from_blob, _table_0.thumb
end
local _exp_0 = ...
if "resize" == _exp_0 then
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
  return thumb("hi.png", "150x200#", "out2.png")
elseif "format" == _exp_0 then
  local img = load_image("hi.png")
  print(img:set_format("bmp"))
  return print(img:get_format())
else
  return error("don't know what to do")
end
