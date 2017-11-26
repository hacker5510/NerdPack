local _, gbl = ...


-- USAGE: UNIT.area(DISTANCE).enemies >= #
gbl.Condition.Register("area.enemies", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitCanAttack("player", Obj)
    and gbl.Condition.Get("combat")(Obj)
    and gbl.Condition.Get("rangefrom")(unit, Obj) < tonumber(distance) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).enemies.infront >= #
gbl.Condition.Register("area.enemies.infront", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitCanAttack("player", Obj)
    and gbl.Condition.Get("combat")(Obj)
    and gbl.Condition.Get("rangefrom")(unit, Obj) < tonumber(distance)
    and gbl.Protected.Infront(unit, Obj) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).friendly >= #
gbl.Condition.Register("area.friendly", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitIsFriend("player", Obj)
    and gbl.Condition.Get("rangefrom")(unit, Obj) < tonumber(distance) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).friendly.infront >= #
gbl.Condition.Register("area.friendly.infront", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitIsFriend("player", Obj)
    and gbl.Condition.Get("rangefrom")(unit, Obj) < tonumber(distance)
    and gbl.Protected.Infront(unit, Obj) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).incdmg >= #
gbl.Condition.Register("area.incdmg", function(target, max_dist)
  if not UnitExists(target) then return 0 end
  local total = 0
  for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitCanAttack("player", Obj)
    and gbl.Condition.Get("range")(target, Obj) < tonumber(max_dist) then
      total = total + gbl.Condition.Get("incdmg")(Obj)
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).dead >= #
gbl.Condition.Register("area.dead", function(target, max_dist)
  if not UnitExists(target) then return 0 end
  local total = 0
  for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitCanAttack("player", Obj)
    and gbl.Condition.Get("range")(target, Obj) < tonumber(max_dist) then
      total = total + 1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE, HEALTH).heal >= #
gbl.Condition.Register("area.heal", function(unit, args)
	local total = 0
	if not UnitExists(unit) then return total end
	local distance, health = strsplit(",", args, 2)
  for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitIsFriend("player", Obj)
		and UnitHealth(Obj) < (tonumber(health) or 100)
    and gbl.Protected.Distance(unit, Obj) < (tonumber(distance) or 20) then
			total = total + 1
		end
	end
	return total
end)

-- USAGE: UNIT.area(DISTANCE, HEALTH).heal.infront >= #
gbl.Condition.Register("area.heal.infront", function(unit, args)
	local total = 0
	if not UnitExists(unit) then return total end
	local distance, health = strsplit(",", args, 2)
  for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitIsFriend("player", Obj)
		and UnitHealth(Obj) < (tonumber(health) or 100)
		and gbl.Protected.Infront(unit, Obj)
    and gbl.Protected.Distance(unit, Obj) < (tonumber(distance) or 20) then
			total = total + 1
		end
	end
	return total
end)

-- USAGE: UNIT.area(DISTANCE, PERCENTAGE).interrupt >= #
gbl.Condition.Register("area.interruptAt", function(unit, args)
	local total = 0
	if not UnitExists(unit) then return total end
	local distance, interrupt = strsplit(",", args, 2)
  for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitCanAttack("player", Obj)
    and gbl.Condition.Get("interruptAt")(Obj, interrupt)
		and gbl.Protected.Distance(unit, Obj) < (tonumber(distance) or 20) then
			total = total + 1
		end
	end
	return total
end)

-- USAGE: UNIT.area(DISTANCE, PERCENTAGE).interrupt.infront >= #
gbl.Condition.Register("area.interruptAt.infront", function(unit, args)
	local total = 0
	if not UnitExists(unit) then return total end
	local distance, interrupt = strsplit(",", args, 2)
  for i=1, gbl.Protected.GetObjectCount() do
		local Obj = gbl.Protected.GetObjectWithIndex(i)
		if gbl.Protected.omVal(Obj)
		and UnitCanAttack("player", Obj)
    and gbl.Condition.Get("interruptAt")(Obj, interrupt)
    and gbl.Protected.Infront(unit, Obj)
		and gbl.Protected.Distance(unit, Obj) < (tonumber(distance) or 20) then
			total = total + 1
		end
	end
	return total
end)
