function setfenv(f, tbl)
    if debug.getupvalue(f, 1) ~= '_ENV' then
        return
    end
    local function dummy()
        return tbl
    end
    debug.upvaluejoin(f, 1, dummy, 1)
end

function getfenv(f)
    local k, v = debug.getupvalue(f, 1)
    if k ~= '_ENV' then
        return _ENV
    end
    return v
end
