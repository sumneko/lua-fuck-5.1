module('a.b.c', package.seeall)

assert(type(a) == 'table')
assert(type(a.b) == 'table')
assert(type(a.b.c) == 'table')
assert(type(package.loaded['a.b.c']) == 'table')
assert(_M == _ENV)
assert(_NAME == 'a.b.c')
assert(_PACKAGE == 'a.b.')
