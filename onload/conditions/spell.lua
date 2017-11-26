local _, gbl = ...
local _G = _G

gbl.Condition:Register("spell.cooldown", function(_, spell)
  local start, duration = GetSpellCooldown(spell)
  if not start then return 0 end
  return start ~= 0 and (start + duration - GetTime()) or 0
end)

gbl.Condition:Register("spell.recharge", function(_, spell)
  local time = GetTime()
  local _, _, start, duration = GetSpellCharges(spell)
  if (start + duration - time) > duration then
    return 0
  end
  return (start + duration - time)
end)

gbl.Condition:Register("spell.usable", function(_, spell)
  return IsUsableSpell(spell) ~= nil
end)

gbl.Condition:Register("spell.exists", function(_, spell)
  return gbl.Core:GetSpellBookIndex(spell) ~= nil
end)

gbl.Condition:Register("spell.charges", function(_, spell)
  local charges, maxCharges, start, duration = GetSpellCharges(spell)
  if duration and charges ~= maxCharges then
    charges = charges + ((GetTime() - start) / duration)
  end
  return charges or 0
end)

gbl.Condition:Register("spell.count", function(_, spell)
  return select(1, GetSpellCount(spell))
end)

gbl.Condition:Register("spell.range", function(target, spell)
  local spellIndex, spellBook = gbl.Core:GetSpellBookIndex(spell)
  if not spellIndex then return false end
  return spellIndex and IsSpellInRange(spellIndex, spellBook, target)
end)

gbl.Condition:Register("spell.casttime", function(_, spell)
  local CastTime = select(4, GetSpellInfo(spell)) / 1000
  if CastTime then return CastTime end
  return 0
end)

local _procs = {}
gbl.Listener:Add("gbl_Procs_add", "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", function(spellID)
	_procs[spellID] = true
	_procs[GetSpellInfo(spellID)] = true
end)

gbl.Listener:Add("gbl_Procs_rem", "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", function(spellID)
	_procs[spellID] = nil
	_procs[GetSpellInfo(spellID)] = nil
end)

gbl.Condition:Register("spell.proc", function(_, spell)
	return _procs[spell] or _procs[GetSpellInfo(spell)] or false
end)

gbl.Condition:Register("power.regen", function(target)
  return select(2, GetPowerRegen(target))
end)

gbl.Condition:Register("casttime", function(_, spell)
  return select(3, GetSpellInfo(spell))
end)

gbl.Condition:Register("lastcast", function(Unit, Spell)
  -- Convert the spell into name
  Spell = GetSpellInfo(Spell)
  -- if Unit is player, returns lasr parser execute.
  if UnitIsUnit("player", Unit) then
    local LastCast = gbl.Parser.LastCast
    return LastCast == Spell, LastCast
  end
  local LastCast = gbl.CombatTracker:LastCast(Unit)
  return LastCast == Spell, LastCast
end)

gbl.Condition:Register("lastgcd", function(Unit, Spell)
  -- Convert the spell into name
  Spell = GetSpellInfo(Spell)
  -- if Unit is player, returns lasr parser execute.
  if UnitIsUnit("player", Unit) then
    local LastCast = gbl.Parser.LastGCD
    return gbl.Parser.LastGCD == Spell, LastCast
  end
  local LastCast = gbl.CombatTracker:LastCast(Unit)
  return LastCast == Spell, LastCast
end)

gbl.Condition:Register("enchant.mainhand", function()
  return (select(1, GetWeaponEnchantInfo()) == 1)
end)

gbl.Condition:Register("enchant.offhand", function()
  return (select(4, GetWeaponEnchantInfo()) == 1)
end)
