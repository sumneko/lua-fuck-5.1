local load = load
local loadfile = loadfile
local debug = debug
local xpcall = xpcall
local type = type
local debugGetupvalue = debug.getupvalue
local debugUpvaluejoin = debug.upvaluejoin
local error = error
local debugGetinfo = debug.getinfo
local getmetatable = getmetatable
local setmetatable = setmetatable

local lua51 = {}

---@param obj any
---@param expect string | "'nil'" | "'number'" | "'string'" | "'boolean'" | "'function'" | "'table'" | "'userdata'" | "'thread'"
local function checkType(obj, expect, level)
    local tp = type(obj)
    if tp ~= expect then
        error(("%s expected, got %s"):format(expect, tp), level and (level + 1) or 3)
    end
end

local function getFunc(f, level)
    if type(f) == 'function' then
        return f
    end
    if not level then
        level = 3
    end
    checkType(f, 'number', level)
    if f < 0 then
        error('level must be non-negative', level)
    end
    local info = debugGetinfo(f + level - 1, 'f')
    if not info then
        error('invalid level', level)
    end
    if not info.func then
        error(('no function environment for tail call at level %d'):format(f), level)
    end
    return info.func
end

local function findTable(name)
    local pg = {}
    local current = lua51
    for id in name:gmatch '[^%.]+' do
        id = id:match '^%s*(.-)%s*$'
        pg[#pg+1] = id
        local field = current[id]
        if field == nil then
            field = {}
            current[id] = field
        elseif type(field) ~= 'table' then
            return nil, table.concat(pg, '.')
        end
        current = field
    end
    return current
end

local function setfenv(f, tbl)
    f = getFunc(f)
    if debugGetupvalue(f, 1) ~= '_ENV' then
        return
    end
    local function dummy()
        return tbl
    end
    debugUpvaluejoin(f, 1, dummy, 1)
end

lua51.arg = arg
lua51.assert = assert
lua51.collectgarbage = collectgarbage
lua51.dofile = dofile
lua51.error = error
lua51._G = lua51

function lua51.getfenv(f)
    f = getFunc(f)
    local k, v = debugGetupvalue(f, 1)
    if k ~= '_ENV' then
        return _ENV
    end
    return v
end

lua51.getmetatable = getmetatable
lua51.ipairs = ipairs

function lua51.load(func, name)
    checkType(func, 'function')
    return load(func, name, 'bt')
end

function lua51.loadfile(name)
    return loadfile(name, 'bt')
end

function lua51.loadstring(str, name)
    checkType(str, 'string')
    return load(str, name, 'bt')
end

function lua51.module(name, ...)
    checkType(name, 'string')
    local loaded = lua51.package.loaded
    local mod = loaded[name]
    if type(mod) ~= 'table' then
        local err
        mod, err = findTable(name)
        if not mod then
            error('name conflict for module ' .. err)
        end
        loaded[name] = mod
    end
    if mod._NAME == nil then
        mod._M = mod
        mod._NAME = name
        mod._PACKAGE = name:match '(.-)[^%.]+$'
    end
    local f = getFunc(1)
    setfenv(f, mod)
    for _, func in ipairs {...} do
        func(mod)
    end
end

lua51.next = next
lua51.pairs = pairs
lua51.pcall = pcall
lua51.print = print
lua51.rawequal = rawequal
lua51.rawget = rawget
lua51.rawlen = rawlen
lua51.rawset = rawset
lua51.select = select
lua51.setfenv = setfenv

lua51.setmetatable = setmetatable
lua51.tonumber = tonumber
lua51.tostring = tostring
lua51.type = type
lua51._VERSION = 'Lua 5.1'

function lua51.xpcall(f, msgh)
    checkType(f, 'function')
    checkType(f, 'function')
    return xpcall(f, msgh)
end

lua51.require = require
lua51.unpack = table.unpack

lua51.package = {}

lua51.package.loaded = {}

function lua51.package.seeall(mod)
    local mt = getmetatable(mod)
    if not mt then
        mt = {}
        setmetatable(mod, mt)
    end
    mt.__index = lua51
end

return lua51
