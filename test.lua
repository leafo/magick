local load_image
do
  local _table_0 = require("magick")
  load_image = _table_0.load_image
end
do
  local img = load_image("hi.png")
  img:resize_and_crop(500, 1000)
  return img:write("out.png")
end
