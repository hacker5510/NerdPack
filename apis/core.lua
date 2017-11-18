local _, NeP = ...
local GetTime = _G.GetTime
local CR = NeP.CR

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

--Return if we're mounted or not
function NeP.API.IsMounted()
	for i = 1, 40 do
		local mountID = select(11, _G.UnitBuff('player', i))
		if mountID and NeP.ByPassMounts:Eval(mountID) then
			return true
		end
	end
	return (_G.SecureCmdOptionParse("[overridebar][vehicleui][possessbar,@vehicle,exists][mounted]true")) ~= "true"
end

-- Returns name, time and if its a channel
function NeP.API.CastingTime()
	local channeling = false
	local name, _,_,_,_, endTime = _G.UnitCastingInfo("player")
	if not name then
		name, _,_,_,_, endTime = _G.UnitChannelInfo("player")
		channeling = true
	end
	local time = (name and (endTime/1000)-GetTime()) or 0
	return name, time, channeling
end


-- blacklist
local function testUnitBlackList(_type, unit)
	local tbl = CR.currentCR.blacklist[_type]
	if not tbl then return end
	for i=1, #tbl do
		local _count = tbl[i].count
		if _count then
			if NeP.DSL:Get(_type..'.count.any')(unit, tbl[i].name) >= _count then return true end
		else
			if NeP.DSL:Get(_type..'.any')(unit, tbl[i]) then return true end
		end
	end
end

function NeP.API.UnitBlacklist(unit)
	return NeP.Debuffs:Eval(unit)
	or CR.currentCR.blacklist.units[NeP.Core:UnitID(unit)]
	or testUnitBlackList("buff", unit)
	or testUnitBlackList("debuff", unit)
end
