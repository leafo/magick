
class BaseImage
  _keep_aspect: (w,h) =>
    if not w and h
      @get_width! / @get_height! * h, h
    elseif w and not h
      w, @get_height! / @get_width! * w
    else
      w,h

  -- resize but crop image to maintain aspect ratio
  resize_and_crop: (w,h) =>
    src_w, src_h = @get_width!, @get_height!

    ar_src = src_w / src_h
    ar_dest = w / h

    if ar_dest == ar_src
      @resize w, h
    elseif ar_dest > ar_src
      new_height = w / ar_src
      @resize w, new_height
      @crop w, h, 0, (new_height - h) / 2
    else
      new_width = h * ar_src
      @resize new_width, h
      @crop w, h, (new_width - w) / 2, 0

  scale_and_crop: (w,h) =>
    src_w, src_h = @get_width!, @get_height!

    ar_src = src_w / src_h
    ar_dest = w / h

    if ar_dest > ar_src
      new_height = w / ar_src
      @resize w, new_height
      @scale w, h
    else
      new_width = h * ar_src
      @resize new_width, h
      @scale w, h



