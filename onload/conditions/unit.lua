local _, gbl = ...
local _G = _G

gbl.Condition:Register("ingroup", function(target)
  return UnitInParty(target) or UnitInRaid(target)
end)

gbl.Condition:Register("group.members", function()
  return (GetNumGroupMembers() or 0)
end)

-- USAGE: group.type==#
-- * 3 = RAID
-- * 2 = Party
-- * 1 = SOLO
gbl.Condition:Register("group.type", function()
  return IsInRaid() and 3 or IsInGroup() and 2 or 1
end)

local UnitClsf = {
  ["elite"] = 2,
  ["rareelite"] = 3,
  ["rare"] = 4,
  ["worldboss"] = 5
}

gbl.Condition:Register("boss", function (target)
  local classification = UnitClassification(target)
  if UnitClsf[classification] then
    return UnitClsf[classification] >= 3
  end
  return gbl.BossID:Eval(target)
end)

gbl.Condition:Register("elite", function (target)
  local classification = UnitClassification(target)
  if UnitClsf[classification] then
    return UnitClsf[classification] >= 2
  end
  return gbl.BossID:Eval(target)
end)

gbl.Condition:Register("id", function(target, id)
  local expectedID = tonumber(id)
  return expectedID and gbl.Core.UnitID(target) == expectedID
end)

gbl.Condition:Register("threat", function(target)
  if UnitThreatSituation("player", target) then
    return select(3, UnitDetailedThreatSituation("player", target))
  end
  return 0
end)

gbl.Condition:Register("aggro", function(target)
  return (UnitThreatSituation(target) and UnitThreatSituation(target) >= 2)
end)

gbl.Condition:Register("moving", function(target)
  local speed, _ = GetUnitSpeed(target)
  return speed ~= 0
end)

gbl.Condition:Register("classification", function (target, spell)
  if not spell then return false end
  local classification = UnitClassification(target)
  if string.find(spell, "[%s,]+") then
    for classificationExpected in string.gmatch(spell, "%a+") do
      if classification == string.lower(classificationExpected) then
        return true
      end
    end
    return false
  else
    return UnitClassification(target) == string.lower(spell)
  end
end)

gbl.Condition:Register("target", function(target, spell)
  return ( UnitGUID(target .. "target") == UnitGUID(spell) )
end)

gbl.Condition:Register("player", function(target)
  return UnitIsPlayer(target)
end)

gbl.Condition:Register("exists", function(target)
  return UnitExists(target)
end)

gbl.Condition:Register("dead", function (target)
  return UnitIsDeadOrGhost(target)
end)

gbl.Condition:Register("alive", function(target)
  return not UnitIsDeadOrGhost(target)
end)

gbl.Condition:Register("behind", function(target)
  return not gbl.Protected.Infront("player", target)
end)

gbl.Condition:Register("infront", function(target)
  return gbl.Protected.Infront("player", target)
end)

local movingCache = {}

gbl.Condition:Register("lastmoved", function(target)
  if UnitExists(target) then
    local guid = UnitGUID(target)
    if movingCache[guid] then
      local moving = (GetUnitSpeed(target) > 0)
      if not movingCache[guid].moving and moving then
        movingCache[guid].last = GetTime()
        movingCache[guid].moving = true
        return false
      elseif moving then
        return false
      elseif not moving then
        movingCache[guid].moving = false
        return GetTime() - movingCache[guid].last
      end
    else
      movingCache[guid] = { }
      movingCache[guid].last = GetTime()
      movingCache[guid].moving = (GetUnitSpeed(target) > 0)
      return false
    end
  end
  return false
end)

gbl.Condition:Register("movingfor", function(target)
  if UnitExists(target) then
    local guid = UnitGUID(target)
    if movingCache[guid] then
      local moving = (GetUnitSpeed(target) > 0)
      if not movingCache[guid].moving then
        movingCache[guid].last = GetTime()
        movingCache[guid].moving = (GetUnitSpeed(target) > 0)
        return 0
      elseif moving then
        return GetTime() - movingCache[guid].last
      elseif not moving then
        movingCache[guid].moving = false
        return 0
      end
    else
      movingCache[guid] = { }
      movingCache[guid].last = GetTime()
      movingCache[guid].moving = (GetUnitSpeed(target) > 0)
      return 0
    end
  end
  return 0
end)

gbl.Condition:Register("friend", function(target)
  return not UnitCanAttack("player", target)
end)

gbl.Condition:Register("enemy", function(target)
  return UnitCanAttack("player", target)
end)

gbl.Condition:Register({"distance", "range"}, function(unit)
  return gbl.Protected.UnitCombatRange("player", unit)
end)

gbl.Condition:Register({"distancefrom", "rangefrom"}, function(unit, unit2)
  return gbl.Protected.UnitCombatRange(unit2, unit)
end)

gbl.Condition:Register("level", function(target)
  return UnitLevel(target)
end)

gbl.Condition:Register("combat", function(target)
  return UnitAffectingCombat(target)
end)

-- Checks if the player has autoattack toggled currently
-- Use {"/startattack", "!isattacking"}, at the top of a CR to force autoattacks
gbl.Condition:Register("isattacking", function()
  return IsCurrentSpell(6603)
end)

gbl.Condition:Register("role", function(target, role)
  return role:upper() == UnitGroupRolesAssigned(target)
end)

gbl.Condition:Register("name", function (target, expectedName)
  return UnitName(target):lower():find(expectedName:lower()) ~= nil
end)

gbl.Condition:Register("creatureType", function (target, expectedType)
  return UnitCreatureType(target) == expectedType
end)

gbl.Condition:Register("class", function (target, expectedClass)
  local class, _, classID = UnitClass(target)
  if tonumber(expectedClass) then
    return tonumber(expectedClass) == classID
  else
    return expectedClass == class
  end
end)

gbl.Condition:Register("inmelee", function(target)
  local range = gbl.Protected.UnitCombatRange("player", target)
  return range <= 1.6, range
end)

gbl.Condition:Register("inranged", function(target)
  local range = gbl.Protected.UnitCombatRange("player", target)
  return range <= 40, range
end)

gbl.Condition:Register("incdmg", function(target, args)
  if args and UnitExists(target) then
    local pDMG = gbl.CombatTracker:getDMG(target)
    return pDMG * tonumber(args)
  end
  return 0
end)

gbl.Condition:Register("incdmg.phys", function(target, args)
  if args and UnitExists(target) then
    local pDMG = select(3, gbl.CombatTracker:getDMG(target))
    return pDMG * tonumber(args)
  end
  return 0
end)

gbl.Condition:Register("incdmg.magic", function(target, args)
  if args and UnitExists(target) then
    local mDMG = select(4, gbl.CombatTracker:getDMG(target))
    return mDMG * tonumber(args)
  end
  return 0
end)

gbl.Condition:Register("swimming", function ()
  return IsSwimming()
end)

--return if a unit is a unit
gbl.Condition:Register("is", function(a,b)
  return UnitIsUnit(a,b)
end)

gbl.Condition:Register("falling", function()
  return IsFalling()
end)

gbl.Condition:Register({"deathin", "ttd", "timetodie"}, function(target)
  return gbl.CombatTracker:TimeToDie(target)
end)

gbl.Condition:Register("charmed", function(target)
  return UnitIsCharmed(target)
end)

local communName = gbl.Locale:TA("Dummies", "Name")
local matchs = gbl.Locale:TA("Dummies", "Pattern")

gbl.Condition:Register("isdummy", function(unit)
  if not UnitExists(unit) then return end
  if UnitName(unit):lower():find(communName) then return true end
  return gbl.Tooltip:Unit(unit, matchs)
end)

gbl.Condition:Register("indoors", function()
    return IsIndoors()
end)

gbl.Condition:Register("haste", function(unit)
  return UnitSpellHaste(unit)
end)

gbl.Condition:Register("mounted", function()
  return IsMounted()
end)

gbl.Condition:Register("combat.time", function(target)
  return gbl.CombatTracker:CombatTime(target)
end)

gbl.Condition:Register("los", function(a, b)
  return gbl.Protected.LineOfSight(a, b)
end)
