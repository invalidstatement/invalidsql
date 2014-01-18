--[[	invalidsql 0.1

	Copyright 2014-2015 David Harris
					aka Legion

	You may use this for any purpose as long as:
	-	You don't remove this copyright notice.
	-	You don't claim this to be your own.
	-	You properly credit the author (Legion) if you publish your work based on (and/or using) this.

	If you modify the code for any purpose, the above obligations still apply.

	The author may not be held responsible for any damage or losses directly or indirectly caused by
	the use of invalidsql.

	If you disagree with the above, don't use the code.
--]]

local fortwars, hook, pcall, pairs, tostring, require, MsgN, error = fortwars, hook, pcall, pairs, tostring, require, MsgN, error
local database

require("mysqloo")

invalidsql = {}

function invalidsql.Connect(host, user, pass, name, port)
	if mysqloo then
		MsgN("MySQL modules found!")
		MsgN("Connecting to DataBase "..name.." at "..host)

		local _database = mysqloo.connect(host, user, pass, name, port)

		_database.onConnectionFailed = function(msg)
			error("Failed to connect!")
		end
		
		_database.onConnected = function()
			MsgN("Connected to DataBase "..name.." at "..host)
			hook.Call("DatabaseConnected")
		end
		
		_database:connect()
		database = _database
	else
		error("MySQL modules are not installed properly!")
	end
end

function invalidsql.Query(query, callback)
	local _query = database:query(query)
	_query:start()
	_query:wait()

	if _query:error() == "" then
		return _query:getData(), true
	else
		return nil, false
	end
end

function invalidsql.SQLStr(str)
	return "\"" .. database:escape(tostring(str)) .. "\""
end