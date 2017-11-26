local _, gbl = ...
gbl.Actions = {}

local Actions = {}
local noop = function() end

function gbl.Actions.Add(name, func)
  Actions[name] = func
end

function gbl.Actions.Remove(name)
  Actions[name] = nil
end

function gbl.Actions.Eval(name)
  return Actions[name] or noop
end
