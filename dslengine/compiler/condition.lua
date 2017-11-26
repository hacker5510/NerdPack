local _, gbl = ...

local c_type = {}

-- Remove whitespaces (_xspc_ needs to be unique so we dont
-- end up replacing something we shouldn"t)
local function CondSpaces(cond)
	return cond:gsub("%b()", function(s)
		return s:gsub(" ", "_xspc_")
	end):gsub("%s", ""):gsub("_xspc_", " ")
end

-- Convert Spells into locale ones
local function CondSpellLocale(str)
	return str:gsub("%((.-)%)", function(s)
		-- we cant convert numbers due to it messing up other things
		if tonumber(s) then return "("..s..")" end
		return "("..gbl.Spells:Convert(s)..")"
	end)
end

c_type["string"] = function(cond, eval)
  cond = cond:lower()
  cond = CondSpaces(cond)
  cond = CondSpellLocale(cond)
  return function()
		return gbl.DSL.Parse(cond, eval.spell, eval.curUnit)
	end
end

c_type["function"] = function(cond)
  return cond()
end

c_type["nil"] = function()
  return function() return true end
end

c_type["boolean"] = function(cond)
  return cond
end

-- public func (main)
-- return a function ready for usage
-- TODO: compile the condition instead of doing it in runtime
function gbl.Compiler.Condition(cond, ...)
  return c_type[type(cond)](cond, ...)
end
