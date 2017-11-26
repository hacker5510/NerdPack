local _, gbl = ...
local _G = _G

-- Valid wow units
-- Full list can be found here:
-- http://wowwiki.wikia.com/wiki/UnitId

gbl.Unit:Add('player')
gbl.Unit:Add('pet')
gbl.Unit:Add('focus')
gbl.Unit:Add('mouseover')
for i=1, 40 do
	gbl.Unit:Add('raid'..i)
	gbl.Unit:Add('raidpet'..i)
end
for i=1, 5 do
	gbl.Unit:Add('arena'..i)
	gbl.Unit:Add('arenapet'..i)
end
for i=1, 4 do
	gbl.Unit:Add('boss'..i)
	gbl.Unit:Add('party'..i)
	gbl.Unit:Add('partypet'..i)
end

-- Lowest
gbl.Unit:Add('lowest', function(num, role)
	local tmp = {}
	for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitIsFriend('player', Obj)
		and (UnitInRaid(Obj) or UnitInParty(Obj))
		and (not role or role and UnitGroupRolesAssigned(Obj) == role:upper()) then
			tmp[#tmp+1] = {
				key = Obj,
				prio = UnitHealth(Obj)
			}
		end
	end
	table.sort( tmp, function(a,b) return a.prio < b.prio end )
	return tmp[num] and tmp[num].key
end)

-- Tank
gbl.Unit:Add('tank', function(num)
	local tmp = {}
	for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitIsFriend('player', Obj)
		and (UnitInRaid(Obj) or UnitInParty(Obj))
		and UnitGroupRolesAssigned(Obj) == "TANK" then
			tmp[#tmp+1] = {
				key = Obj,
				prio = UnitHealthMax(Obj)
			}
		end
	end
	table.sort( tmp, function(a,b) return a.prio > b.prio end )
	return tmp[num] and tmp[num].key
end)

-- Healer
gbl.Unit:Add('healer', function(num)
	local tmp = {}
	for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitIsFriend('player', Obj)
		and (UnitInRaid(Obj) or UnitInParty(Obj))
		and UnitGroupRolesAssigned(Obj) == "HEALER" then
			tmp[#tmp+1] = {
				key = Obj,
				prio = UnitHealthMax(Obj)
			}
		end
	end
	table.sort( tmp, function(a,b) return a.prio > b.prio end )
	return tmp[num] and tmp[num].key
end)

-- DAMAGER
gbl.Unit:Add('damager', function(num)
	local tmp = {}
	for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitIsFriend('player', Obj)
		and (UnitInRaid(Obj) or UnitInParty(Obj))
		and UnitGroupRolesAssigned(Obj) == "DAMAGER" then
			tmp[#tmp+1] = {
				key = Obj,
				prio = UnitHealthMax(Obj)
			}
		end
	end
	table.sort( tmp, function(a,b) return a.prio > b.prio end )
	return tmp[num] and tmp[num].key
end)

-- this is a table that contains all add units
-- Uses IDs from tables/addsids.lua
gbl.Unit:Add('add', function()
	local tmp = {}
	for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitCanAttack('player', Obj)
		and gbl.AddsID:Eval(Obj) then
			tmp[#tmp+1] = Obj
		end
	end
	return tmp
end)

-- this is a table that contains all boss units
-- Uses IDs from tables/bossids.lua and libbossids
gbl.Unit:Add('boss', function()
	local tmp = {}
	for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitCanAttack('player', Obj)
		and gbl.BossID:Eval(Obj) then
			tmp[#tmp+1] = Obj
		end
	end
	return tmp
end)

--This is a table with all enemie units
gbl.Unit:Add('enemies', function()
	local tmp = {}
	for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitCanAttack('player', Obj) then
			tmp[#tmp+1] = Obj
		end
	end
	return tmp
end)

--This is a table with all friendly units
gbl.Unit:Add('friendly', function()
	local tmp = {}
	for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitIsFriend('player', Obj) then
			tmp[#tmp+1] = Obj
		end
	end
	return tmp
end)
