local load_image
do
  local _table_0 = require("magick")
  load_image = _table_0.load_image
end
local img = load_image("hi.png")
img:resize(600, 600)
print(img)
local blob = img:get_blob()
return print(#blob)
