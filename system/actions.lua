local _, gbl = ...
gbl.Actions = {}

local _actions = {}
local noop = function() end

function gbl.Actions.Add(_, name, func)
  _actions[name] = func
end

function gbl.Actions.Remove(_, name)
  _actions[name] = nil
end

function gbl.Actions.Eval(_, name)
  return _actions[name] or noop
end
