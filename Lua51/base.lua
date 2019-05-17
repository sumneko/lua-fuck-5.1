local u = require 'lua51.utility'

local base = {}

base.arg = arg
base.assert = assert
base.collectgarbage = collectgarbage
base.dofile = dofile
base.error = error
base._G = _G

function base.getfenv(f)
    u.checkType(f, 'function')
    local k, v = debug.getupvalue(f, 1)
    if k ~= '_ENV' then
        return _ENV
    end
    return v
end

base.getmetatable = getmetatable
base.ipairs = ipairs

function base.load(func, name)
    u.checkType(func, 'function')
    return load(func, name, 'bt')
end

function base.loadfile(name)
    return loadfile(name, 'bt')
end

function base.loadstring(str, name)
    u.checkType(str, 'string')
    return load(str, name, 'bt')
end

-- TODO mudule

base.next = next
base.pairs = pairs
base.pcall = pcall
base.print = print
base.rawequal = rawequal
base.rawget = rawget
base.rawlen = rawlen
base.rawset = rawset
base.select = select

function base.setfenv(f, tbl)
    if debug.getupvalue(f, 1) ~= '_ENV' then
        return
    end
    local function dummy()
        return tbl
    end
    debug.upvaluejoin(f, 1, dummy, 1)
end

base.setmetatable = setmetatable
base.tonumber = tonumber
base.tostring = tostring
base.type = type
base._VERSION = 'Lua 5.1'

function base.xpcall(f, msgh)
    u.checkType(f, 'function')
    u.checkType(f, 'function')
    return xpcall(f, msgh)
end

base.require = require
base.unpack = table.unpack

return base
