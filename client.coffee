_     = require 'lodash'
async = require 'async'
fn    = require './lib/fn'
pool  = require './lib/pool'
Q     = require 'q'
sock  = require 'socket.io-client'
	
conf  = require './conf/client-config.json'
conf  = _.assign conf, fn.tryRequire './conf/client-config.local.json', {}, false

process.on 'uncaughtException', fn.trapError

cdata = {
	jobs: []
}

cfn = {
	io: {} # socket event handlers
}


cfn.clean_jobs = () ->
	# purge any completed jobs which the server has confirmed

# keep track of things, pass on logging config
cfn.log = (e,data) ->
	fn.log conf.logging, _.extend {}, data, { event: e }

cfn.run_jobs = () ->
	# start ready jobs that are not started yet

cfn.set_jobs = (jobs) ->
	cdata.jobs = cdata.jobs.concat jobs
	cfn.clean_jobs

cfn.io.connect = (msg) ->
	cfn.log 'io-connect', msg
	io.emit 'identify', conf.client

# the server has confirmed receipt of the data, remove it
cfn.io.job_data = (msg) ->
	cfn.log 'io-job-data', msg
	## stub ##

cfn.io.job_list = (msg) ->
	cfn.log 'io-job-list', msg
	cfn.set_jobs msg
	cfn.run_jobs

io = sock fn.getServerName conf

io.on 'connect', cfn.io.connect
io.on 'job-data', cfn.io.job_data
io.on 'job-list', cfn.io.job_list