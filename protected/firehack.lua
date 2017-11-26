local _, NeP = ...
NeP.Protected.FireHack = {}
local FireHack = NeP.Protected.FireHack
FireHack.Name = "FireHack"
FireHack.Test = function() return _G.FireHacK end

FireHack.Load = function()
	ObjectCreator = GetObjectDescriptorAccessor("CGUnitData::createdBy", Type.GUID)
	GameObjectIsAnimating = GetObjectFieldAccessor(0x1C4, Type.Bool)
	-- FireHack b27 breaks InCombatLockdown, lets fix it
	InCombatLockdown = function() return UnitAffectingCombat("player") end
end

FireHack.Distance = function(a, b)
	-- Make Sure the Unit Exists
	if not ObjectIsVisible(a)
	or not ObjectIsVisible(b) then
		return 999
	end
	return GetDistanceBetweenObjects(a,b)
end

FireHack.Infront = function(a, b)
	-- Make Sure the Unit Exists
	if not ObjectIsVisible(a)
	or not ObjectIsVisible(b) then
		return false
	end
	return ObjectIsFacing(a,b)
end

FireHack.ObjectExists = function(Obj)
	return ObjectIsVisible(Obj)
end

FireHack.CastGround = function(spell, target)
	-- fallback to generic if we can cast it using macros
	if NeP.Protected.ValidGround[target] then
		return NeP.Protected.CastGround(spell, target)
	end
	if not ObjectIsVisible(target) then return end
	local rX, rY = math.random(), math.random()
	local oX, oY, oZ = ObjectPosition(target)
	if oX then oX = oX + rX; oY = oY + rY end
	NeP.Protected.Cast(spell)
	if oX then ClickPosition(oX, oY, oZ) end
	CancelPendingSpell()
end

FireHack.UnitCombatRange = function(a, b)
	-- Make Sure the Unit Exists
	if not ObjectIsVisible(a)
	or not ObjectIsVisible(b) then
		return 999
	end
	return FireHack.Distance(a, b) - (UnitCombatReach(a) + UnitCombatReach(b))
end

FireHack.ObjectCreator = function(a)
	return ObjectIsVisible(a) and ObjectCreator(a)
end

FireHack.GameObjectIsAnimating = function(a)
	return ObjectIsVisible(a) and GameObjectIsAnimating(a)
end

FireHack.LineOfSight = function(a, b)
	-- Make Sure the Unit Exists
	if not ObjectIsVisible(a)
	or not ObjectIsVisible(b) then
		return false
	end
	-- skip if its a boss
	if NeP.BossID:Eval(a)
	or NeP.BossID:Eval(b) then
		return true
	end
	-- contiunue
	local ax, ay, az = ObjectPosition(a)
	local bx, by, bz = ObjectPosition(b)
	return not TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, bit.bor(0x10, 0x100))
end

FireHack.GetObjectCount = function()
	return GetObjectCount()
end

FireHack.GetObjectWithIndex = function(i)
	return GetObjectWithIndex(i)
end

FireHack.IsGameObject = function(Obj)
	return ObjectIsType(Obj, ObjectTypes.GameObject)
end

NeP.Protected:AddUnlocker(FireHack)
