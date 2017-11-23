local _, NeP = ...
local GetTime = _G.GetTime
local CR = NeP.CR

NeP.API = {}

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

-- Returns if a Unit is blacklist by NeP orthe CR
function NeP.API.UnitBlacklist(unit)
	return NeP.Debuffs:Eval(unit)
	or CR.currentCR.blacklist.units[NeP.Core:UnitID(unit)]
	or testUnitBlackList("buff", unit)
	or testUnitBlackList("debuff", unit)
end

-- Interrupt a Cast/Channel and returns the result
-- Decides if you should interrput or not
-- FIXME: should take time into account.
function NeP.API:Interrupt(spell)
  local name = self:CastingTime()
	if name == spell then
		return false
	end
	NeP.Protected.SpellStopCasting()
	return true
end

-- Returns if the unit is valid for usage
function NeP.API:ValidUnit(unit)
	return _G.UnitExists(unit)
	and _G.UnitIsVisible(unit)
	and NeP.Protected.LineOfSight('player', unit)
	and not self:Unit_Blacklist(unit)
end

-- Returns if the spell is ready and if it has mana
-- Ready, Mana
function NeP.API.IsSpellReady(spell)
	if _G.GetSpellBookItemInfo(spell) ~= 'FUTURESPELL'
  and (_G.GetSpellCooldown(spell) or 0) <= NeP.DSL:Get('gcd')() then
    return _G.IsUsableSpell(spell)
  end
end
