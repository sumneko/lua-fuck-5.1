require 'test.module.1'
require 'test.module.2'
require 'test.module.3'
require 'test.module.4'

require 'test.module.share1'
collectgarbage()
collectgarbage()
require 'test.module.share2'
