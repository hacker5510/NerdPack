local _, NeP = ...

local t_type = {}

local function Ground(target, eval)
	if target:find('.ground') then
		eval.exeFunc = NeP.Protected["CastGround"]
    return target:sub(0,-8)
	end
  return target
end

t_type["string"] = function(target, eval)
  target = target:lower()
  target = Ground(target, eval)
  return target
end

function NeP.Compiler.Target(target, ...)
  local hasChanges = t_type[type("target")]
  if hasChanges then
    return hasChanges(target, ...)
  end
  return target
end
