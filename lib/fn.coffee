# Sloppy: A utility for slopping data from one bucket to another.
# Copyright (C) 2014 - 2015  David Ulrich (http://github.com/dulrich)
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

fn.bool = (b) ->
	if fn.isstring b and b.toLowerCase() == "false" then false
	else Boolean b

fn.fixed = (f,n) ->
	fn.float(f).toFixed(fn.ifdef n n 2)

fn.float = (f) ->
	ff = parseFloat f 10
	if isFinite ff then ff else 0


# ternary shortcuts
fn.ifarray = (v,a,b) ->
	if fn.isarray v then a else b

fn.ifbool = (v,a,b) ->
	if fn.isbool v then a else b

fn.ifdef = (v,a,b) ->
	if fn.isdef v then a else b

# call f if it is a function
fn.iffn = (f,rest...) ->
	if fn.isfn f then f.apply rest else null

fn.iffloat = (v,a,b) ->
	if fn.isfloat v then a else b


# type checking functions
fn.isarray = (a) ->
	a instanceof Array

fn.isbool = (b) ->
	typeof b is 'boolean'

fn.isfn = (f) ->
	typeof f is 'function'

fn.isfloat = (n) ->
	n == +n and n != (n|0)

fn.isnum = (n) ->
	typeof n is 'number'

fn.isobj = (o) ->
	typeof o is 'object'

fn.isnum = (s) ->
	typeof s is 'string'


fn.log = (conf,data) ->
	console.log "#{data.event}: #{data}"

fn.orin = (e,a) ->
	(fn.array(a).indexOf e) != -1

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
