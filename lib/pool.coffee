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
	"#{opt.host}:#{opt.port}"

# basic query function
pool.prototype.query = (q,cb) ->
	# choose a conn and query with it
	cb null, []

pool.prototype.close = (cb) ->
	_.each this.conn, (cn) ->
		this.close_fn cn, cb

module.exports = pool