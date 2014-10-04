# Sloppy: A utility for slopping data from one bucket to another.
# Copyright (C) 2014  David Ulrich (http://github.com/dulrich)
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

_     = require 'lodash'
async = require 'async'
B     = require 'bluebird'
fn    = require './lib/fn'
pool  = require './lib/pool'
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