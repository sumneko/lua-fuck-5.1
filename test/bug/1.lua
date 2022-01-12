local lua51 = require 'lua51'

XXX = 1
lua51._G = _G
module = lua51.module
package.seeall = lua51.package.seeall

module('XXXX', package.seeall)

assert(XXX == 1)
