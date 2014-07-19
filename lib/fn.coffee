fn = {}

fn.getServerName = (conf) ->
	"http://#{conf.server.host}:#{conf.server.port}";

# call f if it is a function
fn.iffn = (f,rest...) ->
	if fn.isfn f then f.apply rest else null

fn.isfn = (f) ->
	return typeof f is 'function'

fn.log = (conf,data) ->
	console.log "#{data.event}: #{data}"

fn.trapError = (err) ->
	console.log "Unhandled exception: #{err}"
	if err.stack then console.log err.stack

fn.tryRequire = (fp,errval,log) ->
	try
		require fp
	catch err
		if log then console.err "Could not require #{fp}"
		errval

module.exports = fn