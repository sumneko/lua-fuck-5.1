local assert = assert
assert(_VERSION == 'Lua 5.1')

module('mod3', function (mod)
    mod.XXXX = 1
end)
assert(XXXX == 1)
assert(_VERSION == nil)
