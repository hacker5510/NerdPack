local _, gbl = ...

gbl.Commands = {}
gbl.Commands.cache = {}

function gbl.Commands:Add(a, b, func)
	self.cache[a][b] = func
end

local default_func = function(a, msg)
	local b, rest = msg:match("^(%S*)%s*(.-)$");
	if gbl.Commands.cache[a][b] then
		gbl.Commands.cache[a][b](rest)
	end
end

function gbl.Commands:Register(name, func, ...)
	SlashCmdList[name] = func or function(msg) default_func(name, msg) end
	local command
	for i = 1, select('#', ...) do
		command = select(i, ...)
		if command:sub(1, 1) ~= '/' then
			command = '/' .. command
		end
		_G['SLASH_'..name..i] = command
		self.cache[name] = {}
	end
end
