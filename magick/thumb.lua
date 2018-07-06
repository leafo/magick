local tonumber = tonumber
local parse_size_str
parse_size_str = function(str, src_w, src_h)
  local w, h, rest = str:match("^(%d*%%?)x(%d*%%?)(.*)$")
  if not (w) then
    return nil, "failed to parse string (" .. tostring(str) .. ")"
  end
  do
    local p = w:match("(%d+)%%")
    if p then
      if not (src_w) then
        return nil, "missing source width for percentage scale"
      end
      w = tonumber(p) / 100 * src_w
    else
      w = tonumber(w)
    end
  end
  do
    local p = h:match("(%d+)%%")
    if p then
      if not (src_h) then
        return nil, "missing source height for percentage scale"
      end
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
    if w and h and not center_crop and src_w and src_h then
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
local make_thumb
make_thumb = function(load_image)
  local thumb
  thumb = function(img, size_str, output)
    if type(img) == "string" then
      img = assert(load_image(img))
    end
    img:thumb(size_str)
    local ret
    if output then
      ret = img:write(output)
    else
      ret = img:get_blob()
    end
    return ret
  end
  return thumb
end
return {
  parse_size_str = parse_size_str,
  make_thumb = make_thumb
}
