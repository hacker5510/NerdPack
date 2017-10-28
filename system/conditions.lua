local _, NeP = ...

NeP.Condition = {
	conditions = {},
	cust_funcs = {}
}

local conditions = NeP.Condition.conditions
local noop = function() end

function NeP.Condition.Get(_, Strg)
	Strg = Strg:lower()
	if conditions[Strg] then
		return conditions[Strg]
	end
	return noop
end

function NeP.Condition.Exists(_, Strg)
	return conditions[Strg:lower()] ~= nil
end

local function _add(name, condition, overwrite)
	name = name:lower()
	if not conditions[name] or overwrite then
		conditions[name] = condition
		--NeP.Debug:Add(name, condition, true)
	end
end

function NeP.Condition.Register(_, name, condition, overwrite)
	if type(name) == 'table' then
		for i=1, #name do
			_add(name[i], condition, overwrite)
		end
	elseif type(name) == 'string' then
		_add(name, condition, overwrite)
	else
		NeP.Core:Print("ERROR! tried to add an invalid condition")
	end
end
