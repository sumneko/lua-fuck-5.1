local assert = assert

assert(_VERSION == 'Lua 5.1')

module('mod1')
assert(_VERSION == nil)
