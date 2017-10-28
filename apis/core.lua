local _, NeP = ...

--[[

  THIS IS A TEST FILE, IGNORE IT..

]]

NeP.API = {}
NeP.API.Unit = {}

--FIXME: should get a list for all nep units
local tmp_units = {
  ["player"] = function() return "player" end,
  ["tank"] = function() return NeP.Units:filter("tank") end,
}

local function Build_Units()
  for unit_name, unit_func in pairs(tmp_units) do

    -- build the Object
    NeP.API.Unit[unit_name] = {
      unit = unit_func(),
      unit_func = unit_func
    }

    -- give it all conditions
    for cond_name, cond_func in pairs(NeP.Condition.conditions) do
      NeP.API.Unit[unit_name][cond_name] = function(arg)
        return cond_func(NeP.API.Unit[unit_name].unit, arg)
      end
    end

  end
end

local function Refresh_Units()
  for Obj in pairs(NeP.API.Unit) do
    Obj.unit = Obj.unit_func();
  end
end
