local _, gbl = ...
local GetTime = GetTime

gbl.LuaEngine = {}
gbl.LuaEngine.Queue = {}

-- returns target if it exists or player
function gbl.LuaEngine.NoopUnit()
  return UnitExists("target") and "target" or "player"
end

function gbl.LuaEngine.BuildUnits()
  for unit_name, unit_func in pairs(gbl.Unit.Units) do
    -- build the Object
    gbl.LuaEngine[unit_name] = {
      unit = unit_func,
      unit_func = unit_func
    }
    -- give it all conditions
    for cond_name, cond_func in pairs(gbl.Condition.conditions) do
      gbl.LuaEngine[unit_name][cond_name] = function(arg)
        return cond_func(unit_func(), arg)
      end
    end
  end
end

function gbl.LuaEngine.QueueSpell(spell, unit)
  spell = gbl.Spells:Convert(spell)
  if not spell then return end
  gbl.LuaEngine.Queue[spell] = {
    time = GetTime(),
    unit = unit or gbl.NoopUnit()
  }
end
