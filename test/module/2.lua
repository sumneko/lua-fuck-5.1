assert(_VERSION == 'Lua 5.1')

module('mod2', package.seeall)
assert(_VERSION == 'Lua 5.1')
assert(_G['mod2'] ~= nil)
assert(package.loaded['mod2'] ~= nil)
