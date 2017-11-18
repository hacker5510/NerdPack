local _, NeP = ...
local GetTime = _G.GetTime
local CR = NeP.CR

--[[

  THIS IS A TEST FILE, IGNORE IT..

]]

NeP.LuaEngine = {}

--FIXME: should get a list for all nep units
local tmp_units = {
  ["player"] = function() return "player" end,
  ["tank"] = function() return NeP.Units:filter("tank") end,
}

local function Build_Units()
  for unit_name, unit_func in pairs(tmp_units) do

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
