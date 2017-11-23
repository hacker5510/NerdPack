local _, NeP = ...

local c_type = {}

c_type["string"] = function(cond, eval)
  return NeP.DSL.Parse(cond, eval.spell, eval.curUnit)
end

c_type["function"] = function(cond)
  return cond()
end

c_type["nil"] = function()
  return true
end

c_type["boolean"] = function(cond)
  return cond
end

-- public func (main)
-- return a function ready for usage
-- TODO: compile the condition instead of doing it in runtime
function NeP.Compiler.Condition(cond, ...)
  return c_type[type(cond)](cond, ...)
end
