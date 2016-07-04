

import enum from require "magick.enum"

filters = enum {
  [0]: "UndefinedFilter"
  "PointFilter"
  "BoxFilter"
  "TriangleFilter"
  "HermiteFilter"
  "HanningFilter"
  "HammingFilter"
  "BlackmanFilter"
  "GaussianFilter"
  "QuadraticFilter"
  "CubicFilter"
  "CatromFilter"
  "MitchellFilter"
  "LanczosFilter"
  "BesselFilter"
  "SincFilter"
}

{ :filters }
