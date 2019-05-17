module('a.b.c', package.seeall)

assert(type(a) == 'table')
assert(type(a.b) == 'table')
assert(type(a.b.c) == 'table')
assert(package.loaded['a.b.c'] == 'table')
