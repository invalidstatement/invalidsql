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

local hook, pairs, tostring, require, MsgC, color, error = hook, pairs, tostring, require, MsgC, color;
local database;

--[[
	Purpose: print data accordingly.
]]
local function PrintSuccess(_message)
	MsgC(Color(0, 255, 0), _message .. "\n");
end

--[[
	Purpose: connect to the database.
]]
function MySQL.Connect(_host, _user, _pass, _name, _port)
	if (mysqloo) then
		PrintSuccess("MySQLOO modules found.");
		
		local _database = mysqloo.connect(_host, _user, _pass, _name, _port);

		function _database.onConnectionFailed(_message)
			if (_message) then
				error(_message);
			end
		end
		
		function _database.onConnected()
			PrintSuccess("Connected to database " .. _name);
			hook.Call("DatabaseConnected");
		end

		_database:connect();
		database = _database;
	end
end

--[[
	Purpose: issue a query, and return the data.
]]
function MySQL.Query(_sql, callback)
	local _query = database:query(_sql);

	function _query:onSuccess(_data)
		callback(_data);
	end

	function _query:onError(_error)
		error("Query errored!");
	end

	_query:start();
end