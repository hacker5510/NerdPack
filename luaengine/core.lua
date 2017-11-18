local _, NeP = ...
local GetTime = _G.GetTime

NeP.LuaEngine = {}
NeP.LuaEngine.Queue = {}

-- returns target if it exists or player
function NeP.LuaEngine.NoopUnit()
  return _G.UnitExists('target') and 'target' or 'player'
end

function NeP.LuaEngine.BuildUnits()
  for unit_name, unit_func in pairs(NeP.Unit.Units) do
    -- build the Object
    NeP.LuaEngine[unit_name] = {
      unit = unit_func,
      unit_func = unit_func
    }
    -- give it all conditions
    for cond_name, cond_func in pairs(NeP.Condition.conditions) do
      NeP.LuaEngine[unit_name][cond_name] = function(arg)
        return cond_func(unit_func(), arg)
      end
    end
  end
end

function NeP.LuaEngine.QueueSpell(spell, unit)
  spell = NeP.Spells:Convert(spell)
  if not spell then return end
  NeP.LuaEngine.Queue[spell] = {
    time = GetTime(),
    unit = unit or NeP.NoopUnit()
  }
end
