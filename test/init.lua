local lua51 = require 'Lua51'

local function requireLoad(name)
    local msg = ''
    if type(package.searchers) ~= 'table' then
        error("'package.searchers' must be a table", 3)
    end
    for _, searcher in ipairs(package.searchers) do
        local f, extra = searcher(name)
        if type(f) == 'function' then
            return f, extra
        elseif type(f) == 'string' then
            msg = msg .. f
        end
    end
    error(("module '%s' not found:%s"):format(name, msg), 3)
end

local function requireWithEnv(name, env)
    local loaded = package.loaded
    if type(name) ~= 'string' then
        error(("bad argument #1 to 'require' (string expected, got %s)"):format(type(name)), 2)
    end
    local p = loaded[name]
    if p ~= nil then
        return p
    end
    local init, extra = requireLoad(name)
    if type(env) == 'table' then
        if debug.getupvalue(init, 1) == '_ENV' then
            debug.setupvalue(init, 1, env)
        end
    end
    local res = init(name, extra)
    if res ~= nil then
        loaded[name] = res
    end
    if loaded[name] == nil then
        loaded[name] = true
    end
    local path = debug.getinfo(init, 'S').source
    return loaded[name], extra
end

local lua51env = setmetatable({}, { __index = lua51 })

function lua51env.require(name)
    return requireWithEnv(name, lua51env)
end

print('Test start ...')

requireWithEnv('test.setfenv', lua51env)
requireWithEnv('test.module', lua51env)

print('Test finish.')
