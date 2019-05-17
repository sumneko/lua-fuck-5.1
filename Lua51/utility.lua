---@param obj any
---@param expect string | "'nil'" | "'number'" | "'string'" | "'boolean'" | "'function'" | "'table'" | "'userdata'" | "'thread'"
local function checkType(obj, expect)
    local tp = type(obj)
    if tp ~= expect then
        error(("%s expected, got %s"):format(expect, tp), 3)
    end
end

return {
    checkType = checkType
}
