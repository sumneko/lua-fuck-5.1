local f = loadfile 'test/loadfile/cont.lua'
local version = f()
assert(_VERSION == 'Lua 5.1')
