local _, NeP = ...
local _G = _G

-- Valid wow units
-- Full list can be found here:
-- http://wowwiki.wikia.com/wiki/UnitId

NeP.Unit:Add('player')
NeP.Unit:Add('pet')
NeP.Unit:Add('focus')
NeP.Unit:Add('mouseover')
for i=1, 40 do
	NeP.Unit:Add('raid'..i)
	NeP.Unit:Add('raidpet'..i)
end
for i=1, 5 do
	NeP.Unit:Add('arena'..i)
	NeP.Unit:Add('arenapet'..i)
end
for i=1, 4 do
	NeP.Unit:Add('boss'..i)
	NeP.Unit:Add('party'..i)
	NeP.Unit:Add('partypet'..i)
end

-- Lowest
NeP.Unit:Add('lowest', function(num, role)
	local tmp = {}
	for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and _G.UnitIsFriend('player', Obj)
		and (_G.UnitInRaid(Obj) or _G.UnitInParty(Obj))
		and (not role or role and _G.UnitGroupRolesAssigned(Obj) == role:upper()) then
			tmp[#tmp+1] = {
				key = Obj,
				prio = _G.UnitHealth(Obj)
			}
		end
	end
	table.sort( tmp, function(a,b) return a.prio < b.prio end )
	return tmp[num] and tmp[num].key
end)

-- Tank
NeP.Unit:Add('tank', function(num)
	local tmp = {}
	for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and _G.UnitIsFriend('player', Obj)
		and (_G.UnitInRaid(Obj) or _G.UnitInParty(Obj))
		and _G.UnitGroupRolesAssigned(Obj) == "TANK" then
			tmp[#tmp+1] = {
				key = Obj,
				prio = _G.UnitHealthMax(Obj)
			}
		end
	end
	table.sort( tmp, function(a,b) return a.prio > b.prio end )
	return tmp[num] and tmp[num].key
end)

-- Healer
NeP.Unit:Add('healer', function(num)
	local tmp = {}
	for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and _G.UnitIsFriend('player', Obj)
		and (_G.UnitInRaid(Obj) or _G.UnitInParty(Obj))
		and _G.UnitGroupRolesAssigned(Obj) == "HEALER" then
			tmp[#tmp+1] = {
				key = Obj,
				prio = _G.UnitHealthMax(Obj)
			}
		end
	end
	table.sort( tmp, function(a,b) return a.prio > b.prio end )
	return tmp[num] and tmp[num].key
end)

-- DAMAGER
NeP.Unit:Add('damager', function(num)
	local tmp = {}
	for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and _G.UnitIsFriend('player', Obj)
		and (_G.UnitInRaid(Obj) or _G.UnitInParty(Obj))
		and _G.UnitGroupRolesAssigned(Obj) == "DAMAGER" then
			tmp[#tmp+1] = {
				key = Obj,
				prio = _G.UnitHealthMax(Obj)
			}
		end
	end
	table.sort( tmp, function(a,b) return a.prio > b.prio end )
	return tmp[num] and tmp[num].key
end)

-- this is a table that contains all add units
-- Uses IDs from tables/addsids.lua
NeP.Unit:Add('add', function()
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

-- this is a table that contains all boss units
-- Uses IDs from tables/bossids.lua and libbossids
NeP.Unit:Add('boss', function()
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

--This is a table with all enemie units
NeP.Unit:Add('enemies', function()
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

--This is a table with all friendly units
NeP.Unit:Add('friendly', function()
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
