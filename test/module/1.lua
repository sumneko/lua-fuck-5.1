local assert = assert

assert(_VERSION == 'Lua 5.1')

module('mod')
assert(_VERSION == nil)
