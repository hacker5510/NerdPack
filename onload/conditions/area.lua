local _, NeP = ...
local _G = _G

-- USAGE: UNIT.area(DISTANCE).enemies >= #
NeP.Condition:Register("area.enemies", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and UnitCanAttack('player', Obj)
    and NeP.Condition:Get('combat')(Obj)
    and NeP.Condition:Get("rangefrom")(unit, Obj) < tonumber(distance) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).enemies.infront >= #
NeP.Condition:Register("area.enemies.infront", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and UnitCanAttack('player', Obj)
    and NeP.Condition:Get('combat')(Obj)
    and NeP.Condition:Get("rangefrom")(unit, Obj) < tonumber(distance)
    and NeP.Protected.Infront(unit, Obj) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).friendly >= #
NeP.Condition:Register("area.friendly", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and UnitIsFriend('player', Obj)
    and NeP.Condition:Get("rangefrom")(unit, Obj) < tonumber(distance) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).friendly.infront >= #
NeP.Condition:Register("area.friendly.infront", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and UnitIsFriend('player', Obj)
    and NeP.Condition:Get("rangefrom")(unit, Obj) < tonumber(distance)
    and NeP.Protected.Infront(unit, Obj) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).incdmg >= #
NeP.Condition:Register("area.incdmg", function(target, max_dist)
  if not UnitExists(target) then return 0 end
  local total = 0
  for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and UnitCanAttack('player', Obj)
    and NeP.Condition:Get("range")(target, Obj) < tonumber(max_dist) then
      total = total + NeP.Condition:Get("incdmg")(Obj)
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).dead >= #
NeP.Condition:Register("area.dead", function(target, max_dist)
  if not UnitExists(target) then return 0 end
  local total = 0
  for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and UnitCanAttack('player', Obj)
    and NeP.Condition:Get("range")(target, Obj) < tonumber(max_dist) then
      total = total + 1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE, HEALTH).heal >= #
NeP.Condition:Register("area.heal", function(unit, args)
	local total = 0
	if not UnitExists(unit) then return total end
	local distance, health = strsplit(",", args, 2)
  for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and UnitIsFriend('player', Obj)
		and UnitHealth(Obj) < (tonumber(health) or 100)
    and NeP.Protected.Distance(unit, Obj) < (tonumber(distance) or 20) then
			total = total + 1
		end
	end
	return total
end)

-- USAGE: UNIT.area(DISTANCE, HEALTH).heal.infront >= #
NeP.Condition:Register("area.heal.infront", function(unit, args)
	local total = 0
	if not UnitExists(unit) then return total end
	local distance, health = strsplit(",", args, 2)
  for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and UnitIsFriend('player', Obj)
		and UnitHealth(Obj) < (tonumber(health) or 100)
		and NeP.Protected.Infront(unit, Obj)
    and NeP.Protected.Distance(unit, Obj) < (tonumber(distance) or 20) then
			total = total + 1
		end
	end
	return total
end)

-- USAGE: UNIT.area(DISTANCE, PERCENTAGE).interrupt >= #
NeP.Condition:Register("area.interruptAt", function(unit, args)
	local total = 0
	if not UnitExists(unit) then return total end
	local distance, interrupt = strsplit(",", args, 2)
  for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and UnitCanAttack('player', Obj)
    and NeP.Condition:Get("interruptAt")(Obj, interrupt)
		and NeP.Protected.Distance(unit, Obj) < (tonumber(distance) or 20) then
			total = total + 1
		end
	end
	return total
end)

-- USAGE: UNIT.area(DISTANCE, PERCENTAGE).interrupt.infront >= #
NeP.Condition:Register("area.interruptAt.infront", function(unit, args)
	local total = 0
	if not UnitExists(unit) then return total end
	local distance, interrupt = strsplit(",", args, 2)
  for i=1, NeP.Protected.GetObjectCount() do
		local Obj = NeP.Protected.GetObjectWithIndex(i)
		if NeP.Protected.omVal(Obj)
		and UnitCanAttack('player', Obj)
    and NeP.Condition:Get("interruptAt")(Obj, interrupt)
    and NeP.Protected.Infront(unit, Obj)
		and NeP.Protected.Distance(unit, Obj) < (tonumber(distance) or 20) then
			total = total + 1
		end
	end
	return total
end)
