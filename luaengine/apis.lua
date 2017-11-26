local _, gbl = ...
local GetTime = GetTime
local CR = gbl.CR

gbl.API = {}

local queue_var;
local spellCooldown;
local spell_queued = false
local toggle;

function gbl.API.CastSpell(spell, target)
	gbl.Protected.Cast(spell, target)
	spell_queued = true
	C_Timer.After((queue_var+.1), function()
		spell_queued = false
	end)
	return true
end

function gbl.API.UseItem(item, target)
	gbl.Protected.UseItem(item, target)
	return true
end

function gbl.API.Macro(macro, target)
	gbl.Protected.Macro("/"..macro, target)
	return true
end

--Return if we're mounted or not
function gbl.API.IsMounted()
	for i = 1, 40 do
		local mountID = select(11, UnitBuff('player', i))
		if mountID and gbl.ByPassMounts:Eval(mountID) then
			return true
		end
	end
	return (SecureCmdOptionParse("[overridebar][vehicleui][possessbar,@vehicle,exists][mounted]true")) ~= "true"
end

-- Returns name, time and if its a channel
function gbl.API.CastingTime()
	local channeling = false
	local name, _,_,_,_, endTime = UnitCastingInfo("player")
	if not name then
		name, _,_,_,_, endTime = UnitChannelInfo("player")
		channeling = true
	end
	local time = (name and (endTime/1000)-GetTime()) or 0
	return name, time, channeling
end

local function testUnitBlackList(_type, unit)
	local tbl = CR.CurrentCR.blacklist[_type]
	if not tbl then return end
	for i=1, #tbl do
		local _count = tbl[i].count
		if _count then
			if gbl.DSL:Get(_type..'.count.any')(unit, tbl[i].name) >= _count then return true end
		else
			if gbl.DSL:Get(_type..'.any')(unit, tbl[i]) then return true end
		end
	end
end

-- Returns if a Unit is blacklist by gbl orthe CR
function gbl.API.UnitBlacklist(unit)
	return gbl.Debuffs:Eval(unit)
	or CR.CurrentCR.blacklist.units[gbl.Core:UnitID(unit)]
	or testUnitBlackList("buff", unit)
	or testUnitBlackList("debuff", unit)
end

-- Interrupt a Cast/Channel and returns the result
-- Decides if you should interrput or not
-- FIXME: should take time into account.
function gbl.API:Interrupt(spell)
  local name = self:CastingTime()
	if name == spell then
		return false
	end
	gbl.Protected.SpellStopCasting()
	return true
end

-- Returns if the unit is valid for usage
function gbl.API:ValidUnit(unit)
	return UnitExists(unit)
	and UnitIsVisible(unit)
	and gbl.Protected.LineOfSight('player', unit)
	and not self.UnitBlacklist(unit)
end

-- Returns if the spell is ready and if it has mana
-- Ready, Mana
function gbl.API.IsSpellReady(spell)
	if not spell_queued
	and GetSpellBookItemInfo(spell) ~= 'FUTURESPELL'
  and spellCooldown(nil, spell) <= queue_var then
    return IsUsableSpell(spell)
  end
end

-- Returns if the item is ready
function gbl.API.IsItemReady()
	-- TODO
	return false
end

local function ParseStart()
	gbl.Faceroll:Hide()
	gbl:Wipe_Cache()
	gbl.DBM.BuildTimers()
	if toggle(nil, 'mastertoggle')
	and not UnitIsDeadOrGhost('player')
	and gbl.API.IsMounted()
	and not LootFrame:IsShown() then
		CR.CurrentCR[InCombatLockdown()].func()
	end
end

gbl.Core:WhenInGame(function()
	toggle = gbl.Condition:Get('toggle')
	queue_var = (tonumber(GetCVar("SpellQueueWindow")) / 1000)
	spellCooldown = gbl.Condition:Get('spell.cooldown')
	C_Timer.NewTicker(0.1, ParseStart)
	gbl.Debug:Add("CR_TICKER", ParseStart, true)
end, -99)
