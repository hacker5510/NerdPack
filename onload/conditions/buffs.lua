local _, gbl = ...


local function UnitBuffL(target, spell, own)
  local name,_,_,count,_,_,expires,caster = UnitBuff(target, spell, nil, own)
  return name, count, expires, caster
end

local function UnitDebuffL(target, spell, own)
  local name, _,_, count, _,_, expires, caster = UnitDebuff(target, spell, nil, own)
  return name, count, expires, caster
end

local heroismBuffs = { 32182, 90355, 80353, 2825, 146555 }
gbl.Condition.Register("hashero", function()
  for i = 1, #heroismBuffs do
    local SpellName = gbl.Core.GetSpellName(heroismBuffs[i])
    if UnitBuffL("player", SpellName) then return true end
  end
end)

------------------------------------------ BUFFS -----------------------------------------
------------------------------------------------------------------------------------------
gbl.Condition.Register("buff", function(target, spell)
  return not not UnitBuffL(target, spell, "PLAYER")
end)

gbl.Condition.Register("buff.any", function(target, spell)
  return not not UnitBuffL(target, spell)
end)

gbl.Condition.Register("buff.count", function(target, spell)
  local _, count = UnitBuffL(target, spell, "PLAYER")
  return count or 0
end)

gbl.Condition.Register("buff.count.any", function(target, spell)
  local _, count = UnitBuffL(target, spell)
  return count or 0
end)

gbl.Condition.Register("buff.duration", function(target, spell)
  local buff,_,expires = UnitBuffL(target, spell, "PLAYER")
  return buff and (expires - GetTime()) or 0
end)

gbl.Condition.Register("buff.many", function(target, spell)
  local count = 0
  for i=1,40 do
    if UnitBuffL(target, i, "PLAYER") == spell then count = count + 1 end
  end
  return count
end)

gbl.Condition.Register("buff.many.any", function(target, spell)
  local count = 0
  for i=1,40 do
    if UnitBuffL(target, i) == spell then count = count + 1 end
  end
  return count
end)

------------------------------------------ DEBUFFS ---------------------------------------
------------------------------------------------------------------------------------------

gbl.Condition.Register("debuff", function(target, spell)
  return not not UnitDebuffL(target, spell, "PLAYER")
end)

gbl.Condition.Register("debuff.any", function(target, spell)
  return not not UnitDebuffL(target, spell)
end)

gbl.Condition.Register("debuff.count", function(target, spell)
  local _,count = UnitDebuffL(target, spell, "PLAYER")
  return count or 0
end)

gbl.Condition.Register("debuff.count.any", function(target, spell)
  local _,count = UnitDebuffL(target, spell)
  return count or 0
end)

gbl.Condition.Register("debuff.duration", function(target, spell)
  local debuff,_,expires = UnitDebuffL(target, spell)
  return debuff and (expires - GetTime()) or 0
end)

gbl.Condition.Register("debuff.many", function(target, spell)
  local count = 0
  for i=1,40 do
    if UnitDebuffL(target, i, "PLAYER") == spell then count = count + 1 end
  end
  return count
end)

gbl.Condition.Register("debuff.many.any", function(target, spell)
  local count = 0
  for i=1,40 do
    if UnitDebuffL(target, i) == spell then count = count + 1 end
  end
  return count
end)

----------------------------------------------------------------------------------------------

-- Counts how many units have the buff
-- USAGE: count(BUFF).buffs > = #
gbl.Condition.Register("count.enemies.buffs", function(_,buff)
  local n1 = 0
  for i=1, gbl.Protected.GetObjectCount() do
    local Obj = gbl.Protected.GetObjectWithIndex(i)
    if gbl.Protected.omVal(Obj)
    and UnitCanAttack("player", Obj)
    and gbl.Condition.Get("buff")(Obj, buff) then
      n1 = n1 + 1
    end
  end
  return n1
end)

-- Counts how many units have the buff
-- USAGE: count(BUFF).buffs > = #
gbl.Condition.Register("count.friendly.buffs", function(_,buff)
  local n1 = 0
  for i=1, gbl.Protected.GetObjectCount() do
    local Obj = gbl.Protected.GetObjectWithIndex(i)
    if gbl.Protected.omVal(Obj)
    and UnitCanAttack("player", Obj)
    and gbl.Condition.Get("buff")(Obj, buff) then
          n1 = n1 + 1
      end
  end
  return n1
end)

-- Counts how many units have the debuff
-- USAGE: count(DEBUFF).debuffs > = #
gbl.Condition.Register("count.enemies.debuffs", function(_,debuff)
  local n1 = 0
  for i=1, gbl.Protected.GetObjectCount() do
    local Obj = gbl.Protected.GetObjectWithIndex(i)
    if gbl.Protected.omVal(Obj)
    and UnitCanAttack("player", Obj)
    and gbl.Condition.Get("debuff")(Obj, debuff) then
          n1 = n1 + 1
      end
  end
  return n1
end)

-- Counts how many units have the debuff
-- USAGE: count(DEBUFF).debuffs > = #
gbl.Condition.Register("count.friendly.debuffs", function(_,debuff)
  local n1 = 0
  for i=1, gbl.Protected.GetObjectCount() do
    local Obj = gbl.Protected.GetObjectWithIndex(i)
    if gbl.Protected.omVal(Obj)
    and UnitCanAttack("player", Obj)
    and gbl.Condition.Get("debuff")(Obj, debuff) then
          n1 = n1 + 1
      end
  end
  return n1
end)
