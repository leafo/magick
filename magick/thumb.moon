
tonumber = tonumber
parse_size_str = (str, src_w, src_h) ->
  w, h, rest = str\match "^(%d*%%?)x(%d*%%?)(.*)$"
  return nil, "failed to parse string (#{str})" unless w

  w = if p = w\match "(%d+)%%"
    unless src_w
      return nil, "missing source width for percentage scale"

    tonumber(p) / 100 * src_w
  else
    tonumber w

  h = if p = h\match "(%d+)%%"
    unless src_h
      return nil, "missing source height for percentage scale"

    tonumber(p) / 100 * src_h
  else
    tonumber h

  center_crop = rest\match"#" and true

  crop_x, crop_y = rest\match "%+(%d+)%+(%d+)"
  if crop_x
    crop_x = tonumber crop_x
    crop_y = tonumber crop_y
  else
    -- by default we use the dimensions as max sizes
    if w and h and not center_crop and src_w and src_h
      unless rest\match"!"
        if src_w/src_h > w/h
          h = nil
        else
          w = nil

  {
    :w, :h
    :crop_x, :crop_y
    :center_crop
  }

make_thumb = (load_image) ->
  thumb = (img, size_str, output) ->
    if type(img) == "string"
      img = assert load_image img

    img\thumb size_str

    ret = if output
      img\write output
    else
      img\get_blob!

    ret

  thumb

{:parse_size_str, :make_thumb}
