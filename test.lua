local load_image
do
  local _table_0 = require("magick")
  load_image = _table_0.load_image
end
do
  local img = load_image("hi.png")
  img:resize(600, 600)
  img:write("resized.png")
end
do
  local img = load_image("hi.png")
  img:adaptive_resize(600, 600)
  return img:write("adaptive.png")
end
