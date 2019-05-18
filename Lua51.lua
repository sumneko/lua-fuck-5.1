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
local debugGetlocal = debug.getlocal

local lua51 = {}

local FenvCache = setmetatable({}, { __mode = 'kv' })

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
    local tp = type(f)
    if tp ~= 'function' and tp ~= 'userdata' and tp ~= 'thead' then
        error [['setfenv' cannot change environment of given object]]
    end
    FenvCache[f] = tbl
    if debugGetupvalue(f, 1) ~= '_ENV' then
        return
    end
    local function dummy()
        return tbl
    end
    debugUpvaluejoin(f, 1, dummy, 1)
end

local function getfenv(f)
    if FenvCache[f] then
        return FenvCache[f]
    end
    local _, v = debugGetupvalue(f, 1)
    return v
end

local function copyTable(t)
    local nt = {}
    for k, v in pairs(t) do
        nt[k] = v
    end
    return nt
end

lua51.arg = arg
lua51.assert = assert
lua51.collectgarbage = collectgarbage
lua51.dofile = dofile
lua51.error = error
lua51._G = lua51

function lua51.getfenv(f)
    f = getFunc(f)
    return getfenv(f)
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

function lua51.setfenv(f, tbl)
    f = getFunc(f)
    setfenv(f, tbl)
end

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

lua51.coroutine = {}

lua51.coroutine.create = coroutine.create
lua51.coroutine.isyieldable = coroutine.isyieldable
lua51.coroutine.resume = coroutine.resume
lua51.coroutine.running = coroutine.running
lua51.coroutine.status = coroutine.status
lua51.coroutine.wrap = coroutine.wrap
lua51.coroutine.yield = coroutine.yield

lua51.debug = {}

lua51.debug.debug = debug.debug
lua51.debug.getfenv = getfenv
lua51.debug.gethook = debug.gethook
lua51.debug.getinfo = debug.getinfo

function lua51.debug.getlocal(...)
    local n = select('#', ...)
    if n == 2 then
        local level, loc = ...
        checkType(level, 'number')
        return debugGetlocal(level, loc)
    else
        local th, level, loc = ...
        return debugGetlocal(th, level, loc)
    end
end

lua51.debug.getmetatable = debug.getmetatable
lua51.debug.getregistry = debug.getregistry
lua51.debug.getupvalue = debug.getupvalue
lua51.debug.getuservalue = debug.getuservalue
lua51.debug.setfenv = setfenv
lua51.debug.sethook = debug.sethook
lua51.debug.setlocal = debug.setlocal
lua51.debug.setmetatable = debug.setmetatable
lua51.debug.setupvalue = debug.setupvalue
lua51.debug.setuservalue = debug.setuservalue
lua51.debug.traceback = debug.traceback

lua51.package = {}

lua51.package.config = package.config
lua51.package.cpath = package.cpath
lua51.package.loaded = copyTable(package.loaded)
lua51.package.loaders = copyTable(package.searchers)
lua51.package.loadlib = package.loadlib
lua51.package.path = package.path
lua51.package.preload = copyTable(package.preload)

function lua51.package.seeall(mod)
    local mt = getmetatable(mod)
    if not mt then
        mt = {}
        setmetatable(mod, mt)
    end
    mt.__index = lua51
end

return lua51
