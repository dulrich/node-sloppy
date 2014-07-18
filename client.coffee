_     = require 'lodash'
async = require 'async'
fn    = require './lib/fn'
sock  = require 'socket.io-client'

conf  = require './conf/client-config.json'
conf  = _.assign conf, fn.tryRequire './conf/client-config.local.json', {}, false


process.on 'uncaughtException', fn.trapError



io = new sock config