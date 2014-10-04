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

_ = require 'lodash'
Q = require 'q'

# take settings and return a sql pool # should likely use prototype
#
# opt:
#  type (optional): mysql/odbc/postgres
#  host: name or ip of the server
#  port: port the db server runs on
#  query(query,cb): used to query the db
#  escape(param): used to escape param for insertion in the query string
#  connect/open,close
#  
pool = (opt) ->
	this.opt = _.assign {}, opt # settings used to create the pool
	
	this.name = this.get_name # string version of the connection
	this.conn = [] # active connections
	
	this.close_fn = this.opt.close
	this.query_fn = this.opt.query


# hash the relevant opts into a consistent name
pool.prototype.get_name = () ->
	"#{this.opt.host}:#{this.opt.port}"

# basic query function
pool.prototype.query = (q,cb) ->
	# choose a conn and query with it
	cb null, []

pool.prototype.close = (cb) ->
	_.each this.conn, (cn) ->
		this.close_fn cn, cb

module.exports = pool