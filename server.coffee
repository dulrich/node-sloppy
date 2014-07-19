_     = require 'lodash'
async = require 'async'
fn    = require './lib/fn'
sock  = require 'socket.io'

conf  = require './conf/server-config.json'
conf  = _.assign conf, fn.tryRequire './conf/server-config.local.json', {}, false

process.on 'uncaughtException', fn.trapError


sfn = {
	io: {} # socket event handlers
}

sfn.get_jobs = (msg) ->
	[]

sfn.set_data = (msg) ->
	# use conf to save job results

# keep track of things, pass on logging config
sfn.log = (e,data) ->
	fn.log conf.logging, _.extend {}, data, { event: e }

sfn.io.connect = (socket) ->
	sfn.log "io-connected"
	
	socket.on 'identify', (msg) ->
		sfn.io.identify socket, msg
	socket.on 'job-data', (msg) ->
		sfn.io.job_data socket, msg
	socket.on 'job-list', (msg) ->
		sfn.io.job_list socket, msg

sfn.io.identify = (socket,msg) ->
	sfn.log 'io-identify', msg
	
	socket.emit 'job-list', sfn.get_jobs msg

sfn.io.job_data = (socket,msg) ->
	sfn.log 'io-job-data', msg
	
	sfn.set_data msg
	
sfn.io.job_list = (socket,msg) ->
	sfn.log 'io-job-list', msg


io = new sock conf.server.port, {}

io.on 'connection', sfn.io.connect

