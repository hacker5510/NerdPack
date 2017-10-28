local _, NeP = ...
local _G = _G

-- Lowest
NeP.Units:Add('lowest', function(role)
	local tmp = {}
	for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and _G.UnitIsFriend('player', Obj)
		and _G.UnitGroupRolesAssigned(Obj.key) == "TANK"
		and (not role or role and Obj.role == role:upper()) then
			tmp[#tmp+1] = {
				key = Obj,
				prio = _G.UnitHealthMax(Obj)
			}
		end
	end
	table.sort( tmp, function(a,b) return a.health < b.health end )
	return tmp
end)

-- Tank
NeP.Units:Add('tank', function()
	local tmp = {}
	for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and _G.UnitIsFriend('player', Obj)
		and _G.UnitGroupRolesAssigned(Obj.key) == "TANK" then
			tmp[#tmp+1] = {
				key = Obj,
				prio = _G.UnitHealthMax(Obj)
			}
		end
	end
	table.sort( tmp, function(a,b) return a.prio > b.prio end )
	return tmp
end)

-- Healer
NeP.Units:Add('healer', function()
	local tmp = {}
	for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and _G.UnitIsFriend('player', Obj)
		and _G.UnitGroupRolesAssigned(Obj.key) == "HEALER" then
			tmp[#tmp+1] = {
				key = Obj,
				prio = _G.UnitHealthMax(Obj)
			}
		end
	end
	table.sort( tmp, function(a,b) return a.prio > b.prio end )
	return tmp
end)

-- DAMAGER
NeP.Units:Add('damager', function()
	local tmp = {}
	for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and _G.UnitIsFriend('player', Obj)
		and _G.UnitGroupRolesAssigned(Obj.key) == "DAMAGER" then
			tmp[#tmp+1] = {
				key = Obj,
				prio = _G.UnitHealthMax(Obj)
			}
		end
	end
	table.sort( tmp, function(a,b) return a.prio > b.prio end )
	return tmp
end)

-- enemy ADD
NeP.Units:Add('add', function()
	local tmp = {}
	for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and _G.UnitCanAttack('player', Obj)
		and NeP.AddsID:Eval(Obj) then
			tmp[#tmp+1] = Obj
		end
	end
	return tmp
end)

-- enemy Boss
NeP.Units:Add('boss', function()
	local tmp = {}
	for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and _G.UnitCanAttack('player', Obj)
		and NeP.BossID:Eval(Obj) then
			tmp[#tmp+1] = Obj
		end
	end
	return tmp
end)

NeP.Units:Add('enemies', function()
	local tmp = {}
	for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and _G.UnitCanAttack('player', Obj) then
			tmp[#tmp+1] = Obj
		end
	end
	return tmp
end)

NeP.Units:Add('friendly', function()
	local tmp = {}
	for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and _G.UnitIsFriend('player', Obj) then
			tmp[#tmp+1] = Obj
		end
	end
	return tmp
end)
