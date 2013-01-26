local load_image, load_image_from_blob
do
  local _table_0 = require("magick")
  load_image, load_image_from_blob = _table_0.load_image, _table_0.load_image_from_blob
end
local _exp_0 = ...
if "resize" == _exp_0 then
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
else
  return error("don't know what to do")
end
