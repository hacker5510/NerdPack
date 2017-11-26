local _, NeP = ...
NeP.Protected.Faceroll = {}
local rangeCheck = LibStub("LibRangeCheck-2.0")
local noop = function() end
local Faceroll = NeP.Protected.Faceroll
Faceroll.Name = "Faceroll"
Faceroll.Test = function() return true end

Faceroll.Load = function()
end

Faceroll.Cast = function(spell, target)
  NeP.Faceroll:Set(spell, target)
end

Faceroll.CastGround = function(spell, target)
  NeP.Faceroll:Set(spell, target)
end

Faceroll.Macro = noop
Faceroll.UseItem = noop
Faceroll.UseInvItem = noop
Faceroll.TargetUnit = noop
Faceroll.SpellStopCasting = noop
Faceroll.ObjectExists = noop
Faceroll.ObjectCreator = noop
Faceroll.GameObjectIsAnimating = noop
Faceroll.IsGameObject = noop

Faceroll.Distance = function(_, b)
  local minRange, maxRange = rangeCheck:GetRange(b)
  return maxRange or minRange or 0
end

Faceroll.Infront = function(_,b)
  return NeP.Helpers:Infront(b) or false
end

Faceroll.UnitCombatRange = function(_,b)
  return rangeCheck:GetRange(b) or 0
end

Faceroll.LineOfSight = function(_,b)
  return NeP.Helpers:Infront(b) or false
end

local OM = {}

Faceroll.GetObjectCount = function()
	return #OM
end

Faceroll.GetObjectWithIndex = function(i)
	return OM[i]
end

NeP.Protected:AddUnlocker(Faceroll)
