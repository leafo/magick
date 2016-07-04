local enum
enum = require("magick.enum").enum
local filters = enum({
  [0] = "UndefinedFilter",
  "PointFilter",
  "BoxFilter",
  "TriangleFilter",
  "HermiteFilter",
  "HanningFilter",
  "HammingFilter",
  "BlackmanFilter",
  "GaussianFilter",
  "QuadraticFilter",
  "CubicFilter",
  "CatromFilter",
  "MitchellFilter",
  "LanczosFilter",
  "BesselFilter",
  "SincFilter"
})
return {
  filters = filters
}
