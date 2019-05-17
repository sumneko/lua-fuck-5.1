assert(_VERSION == 'Lua 5.1')

module('mod', function (mod)
    mod.XXXX = 1
end)
assert(XXXX == 'Lua 5.1')
assert(_VERSION == nil)
