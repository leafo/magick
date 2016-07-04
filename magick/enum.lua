local Enum
do
  local _class_0
  local _base_0 = {
    to_str = function(self, val)
      if type(val) == "string" then
        return val
      end
      return self[val]
    end,
    to_int = function(self, val)
      if type(val) == "number" then
        return val
      end
      return self[val]
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Enum"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Enum = _class_0
end
local enum
enum = function(t)
  local keys
  do
    local _accum_0 = { }
    local _len_0 = 1
    for k in pairs(t) do
      _accum_0[_len_0] = k
      _len_0 = _len_0 + 1
    end
    keys = _accum_0
  end
  for _index_0 = 1, #keys do
    local key = keys[_index_0]
    t[t[key]] = key
  end
  setmetatable(t, Enum.__base)
  return t
end
return {
  enum = enum
}
