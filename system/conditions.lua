local _, gbl = ...

gbl.Condition = {
	conditions = {},
	cust_funcs = {}
}

local conditions = gbl.Condition.conditions
local noop = function() end

function gbl.Condition.Get(_, Strg)
	if conditions[Strg] then
		return conditions[Strg]
	end
	return noop
end

function gbl.Condition.Exists(_, Strg)
	return conditions[Strg] ~= nil
end

local function _add(name, condition, overwrite)
	name = name:lower()
	if not conditions[name] or overwrite then
		conditions[name] = condition
		--gbl.Debug:Add(name, condition, true)
	end
end

function gbl.Condition.Register(_, name, condition, overwrite)
	if type(name) == "table" then
		for i=1, #name do
			_add(name[i], condition, overwrite)
		end
	elseif type(name) == "string" then
		_add(name, condition, overwrite)
	else
		gbl.Core.Print("ERROR! tried to add an invalid condition")
	end
end
