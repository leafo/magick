
class Enum
  to_str: (val) =>
    return val if type(val) == "string"
    @[val]

  to_int: (val) =>
    return val if type(val) == "number"
    @[val]

enum = (t) ->
  keys = [k for k in pairs t]
  for key in *keys
    t[t[key]] = key

  setmetatable t, Enum.__base
  t

{ :enum }
