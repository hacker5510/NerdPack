local _, NeP = ...
local IsInGroup = _G.IsInGroup
local IsInRaid = _G.IsInRaid
local GetNumGroupMembers = _G.GetNumGroupMember

NeP.Protected = {}
NeP.Protected.callbacks = {}

local rangeCheck = _G.LibStub("LibRangeCheck-2.0")
local noop = function() end

function NeP.Protected:AddCallBack(func)
	if not func() then
		table.insert(self.callbacks, func)
	end
end

NeP.Protected.Cast = function(spell, target)
  NeP.Faceroll:Set(spell, target)
end

NeP.Protected.CastGround = function(spell, target)
  NeP.Faceroll:Set(spell, target)
end

NeP.Protected.Macro = noop
NeP.Protected.UseItem = noop
NeP.Protected.UseInvItem = noop
NeP.Protected.TargetUnit = noop
NeP.Protected.SpellStopCasting = noop
NeP.Protected.ObjectExists = noop
NeP.Protected.ObjectCreator = noop
NeP.Protected.GameObjectIsAnimating = noop
NeP.Protected.IsGameObject = noop

NeP.Protected.Distance = function(_, b)
  local minRange, maxRange = rangeCheck:GetRange(b)
  return maxRange or minRange or 0
end

NeP.Protected.Infront = function(_,b)
  return NeP.Helpers:Infront(b) or false
end

NeP.Protected.UnitCombatRange = function(_,b)
  return rangeCheck:GetRange(b) or 0
end

NeP.Protected.LineOfSight = function(_,b)
  return NeP.Helpers:Infront(b) or false
end

local OM = {}
local ValidUnits = {'player', 'mouseover', 'target', 'focus', 'pet',}
local ValidUnitsN = {'boss', 'arena', 'arenapet'}


function NeP.Protected.GetObjectCount()
	return #OM
end

function NeP.Protected.GetObjectWithIndex(i)
	return OM[i]
end

function NeP.Protected.omVal(Obj)
	return _G.UnitExists(Obj)
	and _G.UnitInPhase(Obj)
	and NeP.Protected.Distance('player', Obj) < 100
	and NeP.Protected.LineOfSight('player', Obj)
end

--FIXME: TODO
--[[local function BuildOM()
  -- If in Group scan frames...
  if IsInGroup()
	or IsInRaid() then
    local prefix = (IsInRaid() and 'raid') or 'party'
    for i = 1, GetNumGroupMembers() do
      local unit = prefix..i
			local pet = prefix..'pet'..i
      NeP.OM:Add(unit)
			NeP.OM:Add(pet)
      NeP.OM:Add(unit..'target')
      NeP.OM:Add(pet..'target')
    end
  end
  -- Valid Units
  for i=1, #ValidUnits do
    local object = ValidUnits[i]
    NeP.OM:Add(object)
    NeP.OM:Add(object..'target')
  end
	-- Valid Units with numb (5)
	for i=1, #ValidUnitsN do
		for k=1, 5 do
			local object = ValidUnitsN[i]..k
			NeP.OM:Add(object)
			NeP.OM:Add(object..'target')
		end
	end
end]]
