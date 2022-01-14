module('Share', package.seeall)

local obj = {}

function obj:new()
    assert(SharedDate == 1)
end

obj:new()
