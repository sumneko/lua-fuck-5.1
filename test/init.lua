local lua51 = require 'lua51'

print('Test start ...')

lua51.require 'test.require'
lua51.require 'test.loadfile'
lua51.require 'test.loadstring'
lua51.require 'test.setfenv'
lua51.require 'test.module'

require 'test.bug.1'

print('Test finish.')
