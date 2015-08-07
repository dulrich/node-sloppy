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

fn = {}

fn.getServerName = (conf) ->
	"http://#{conf.server.host}:#{conf.server.port}"

fn.array = (a) ->
	if fn.isarray a then a
	else if a? then [a]
	else []

# call f if it is a function
fn.iffn = (f,rest...) ->
	if fn.isfn f then f.apply rest else null

fn.isarray = (a) ->
	return a instanceof Array

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