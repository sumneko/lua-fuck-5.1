assert(_VERSION == 'Lua 5.1')

module('mod', package.seeall)
assert(_VERSION == 'Lua 5.1')
assert(_G['mod'] ~= nil)
assert(package.loaded['mod'] ~= nil)
