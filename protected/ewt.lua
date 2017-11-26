local _, gbl = ...
gbl.Protected.EWT = {}
local EWT = gbl.Protected.EWT
EWT.Name = "EWT"
EWT.Test = function() return _G.EWT end

EWT.Load = function()
end

EWT.Distance = function(a, b)
	if not ObjectExists(a)
	or not ObjectExists(b) then
		return 999
	end
	return GetDistanceBetweenObjects(a,b)
end

EWT.Infront = function(a, b)
	if not ObjectExists(a)
	or not ObjectExists(b) then
		return false
	end
	return ObjectIsFacing(a,b)
end

EWT.CastGround = function(spell, target)
	-- fallback to generic if we can cast it using macros
	if gbl.Protected.ValidGround[target] then
		return gbl.Protected.CastGround(spell, target)
	end
	if not ObjectExists(target) then return end
	local rX, rY = math.random(), math.random()
	local oX, oY, oZ = ObjectPosition(target)
	if oX then oX = oX + rX; oY = oY + rY end
	gbl.Protected.Cast(spell)
	if oX then CastAtPosition(oX, oY, oZ) end
	CancelPendingSpell()
end

EWT.ObjectExists = function(Obj)
	return ObjectExists(Obj)
end

EWT.UnitCombatRange = function(a, b)
	if not ObjectExists(a)
	or not ObjectExists(b) then
		return 999
	end
	return gbl.Protected.Distance(a, b) - (UnitCombatReach(a) + UnitCombatReach(b))
end

EWT.LineOfSight = function(a, b)
	if not ObjectExists(a)
	or not ObjectExists(b) then
		return false
	end
	-- skip if its a boss
	if gbl.BossID:Eval(a)
	or gbl.BossID:Eval(b) then
		return true
	end
	local ax, ay, az = ObjectPosition(a)
	local bx, by, bz = ObjectPosition(b)
	return not TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, bit.bor(0x10, 0x100))
end

gbl.Protected:AddUnlocker(EWT)
