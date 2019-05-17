FENVRESULT = {}
YES = false

local function f()
    FENVRESULT[2] = YES
    local nf = require 'test.newfunction'
    return nf, function ()
        FENVRESULT[4] = YES
    end
end
setfenv(f, {
    require = require,
    YES = true,
    print = print,
    FENVRESULT = FENVRESULT,
})
FENVRESULT[1] = YES
local nf1, nf2 = f()
nf1()
nf2()
assert(FENVRESULT[1] == false)
assert(FENVRESULT[2] == true)
assert(FENVRESULT[3] == false)
assert(FENVRESULT[4] == true)
