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

