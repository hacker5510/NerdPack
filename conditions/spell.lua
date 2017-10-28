local _, NeP = ...
local _G = _G

NeP.Condition:Register('spell.cooldown', function(_, spell)
  local start, duration = _G.GetSpellCooldown(spell)
  if not start then return 0 end
  return start ~= 0 and (start + duration - _G.GetTime()) or 0
end)

NeP.Condition:Register('spell.recharge', function(_, spell)
  local time = _G.GetTime()
  local _, _, start, duration = _G.GetSpellCharges(spell)
  if (start + duration - time) > duration then
    return 0
  end
  return (start + duration - time)
end)

NeP.Condition:Register('spell.usable', function(_, spell)
  return _G.IsUsableSpell(spell) ~= nil
end)

NeP.Condition:Register('spell.exists', function(_, spell)
  return NeP.Core:GetSpellBookIndex(spell) ~= nil
end)

NeP.Condition:Register('spell.charges', function(_, spell)
  local charges, maxCharges, start, duration = _G.GetSpellCharges(spell)
  if duration and charges ~= maxCharges then
    charges = charges + ((_G.GetTime() - start) / duration)
  end
  return charges or 0
end)

NeP.Condition:Register('spell.count', function(_, spell)
  return select(1, _G.GetSpellCount(spell))
end)

NeP.Condition:Register('spell.range', function(target, spell)
  local spellIndex, spellBook = NeP.Core:GetSpellBookIndex(spell)
  if not spellIndex then return false end
  return spellIndex and _G.IsSpellInRange(spellIndex, spellBook, target)
end)

NeP.Condition:Register('spell.casttime', function(_, spell)
  local CastTime = select(4, _G.GetSpellInfo(spell)) / 1000
  if CastTime then return CastTime end
  return 0
end)

local _procs = {}
NeP.Listener:Add('NeP_Procs_add', 'SPELL_ACTIVATION_OVERLAY_GLOW_SHOW', function(spellID)
	_procs[spellID] = true
	_procs[_G.GetSpellInfo(spellID)] = true
end)

NeP.Listener:Add('NeP_Procs_rem', 'SPELL_ACTIVATION_OVERLAY_GLOW_HIDE', function(spellID)
	_procs[spellID] = nil
	_procs[_G.GetSpellInfo(spellID)] = nil
end)

NeP.Condition:Register("spell.proc", function(_, spell)
	return _procs[spell] or _procs[_G.GetSpellInfo(spell)] or false
end)

NeP.Condition:Register('power.regen', function(target)
  return select(2, _G.GetPowerRegen(target))
end)

NeP.Condition:Register('casttime', function(_, spell)
  return select(3, _G.GetSpellInfo(spell))
end)

NeP.Condition:Register('lastcast', function(Unit, Spell)
  -- Convert the spell into name
  Spell = _G.GetSpellInfo(Spell)
  -- if Unit is player, returns lasr parser execute.
  if _G.UnitIsUnit('player', Unit) then
    local LastCast = NeP.Parser.LastCast
    return LastCast == Spell, LastCast
  end
  local LastCast = NeP.CombatTracker:LastCast(Unit)
  return LastCast == Spell, LastCast
end)

NeP.Condition:Register("lastgcd", function(Unit, Spell)
  -- Convert the spell into name
  Spell = _G.GetSpellInfo(Spell)
  -- if Unit is player, returns lasr parser execute.
  if _G.UnitIsUnit('player', Unit) then
    local LastCast = NeP.Parser.LastGCD
    return NeP.Parser.LastGCD == Spell, LastCast
  end
  local LastCast = NeP.CombatTracker:LastCast(Unit)
  return LastCast == Spell, LastCast
end)

NeP.Condition:Register("enchant.mainhand", function()
  return (select(1, _G.GetWeaponEnchantInfo()) == 1)
end)

NeP.Condition:Register("enchant.offhand", function()
  return (select(4, _G.GetWeaponEnchantInfo()) == 1)
end)
