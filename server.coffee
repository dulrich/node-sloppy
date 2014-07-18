_     = require 'lodash'
async = require 'async'
fn    = require './lib/fn'
sock  = require 'socket.io'

conf  = require './conf/server-config.json'
conf  = _.assign conf, fn.tryRequire './conf/server-config.local.json', {}, false


process.on 'uncaughtException', fn.trapError




io = new sock conf.server.port, {}