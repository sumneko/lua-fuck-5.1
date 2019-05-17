local lua51 = require 'Lua51'
for k, v in pairs(lua51) do
    _G[k] = v
end
print('Test start ...')

require 'test.setfenv'

print('Test finish.')
