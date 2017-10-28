local _, NeP = ...
local _G = _G

local function UnitBuffL(target, spell, own)
  local name,_,_,count,_,_,expires,caster = _G.UnitBuff(target, spell, nil, own)
  return name, count, expires, caster
end

local function UnitDebuffL(target, spell, own)
  local name, _,_, count, _,_, expires, caster = _G.UnitDebuff(target, spell, nil, own)
  return name, count, expires, caster
end

local heroismBuffs = { 32182, 90355, 80353, 2825, 146555 }
NeP.Condition:Register("hashero", function()
  for i = 1, #heroismBuffs do
    local SpellName = NeP.Core:GetSpellName(heroismBuffs[i])
    if UnitBuffL('player', SpellName) then return true end
  end
end)

------------------------------------------ BUFFS -----------------------------------------
------------------------------------------------------------------------------------------
NeP.Condition:Register("buff", function(target, spell)
  return not not UnitBuffL(target, spell, 'PLAYER')
end)

NeP.Condition:Register("buff.any", function(target, spell)
  return not not UnitBuffL(target, spell)
end)

NeP.Condition:Register("buff.count", function(target, spell)
  local _, count = UnitBuffL(target, spell, 'PLAYER')
  return count or 0
end)

NeP.Condition:Register("buff.count.any", function(target, spell)
  local _, count = UnitBuffL(target, spell)
  return count or 0
end)

NeP.Condition:Register("buff.duration", function(target, spell)
  local buff,_,expires = UnitBuffL(target, spell, 'PLAYER')
  return buff and (expires - _G.GetTime()) or 0
end)

NeP.Condition:Register("buff.many", function(target, spell)
  local count = 0
  for i=1,40 do
    if UnitBuffL(target, i, 'PLAYER') == spell then count = count + 1 end
  end
  return count
end)

NeP.Condition:Register("buff.many.any", function(target, spell)
  local count = 0
  for i=1,40 do
    if UnitBuffL(target, i) == spell then count = count + 1 end
  end
  return count
end)

------------------------------------------ DEBUFFS ---------------------------------------
------------------------------------------------------------------------------------------

NeP.Condition:Register("debuff", function(target, spell)
  return not not UnitDebuffL(target, spell, 'PLAYER')
end)

NeP.Condition:Register("debuff.any", function(target, spell)
  return not not UnitDebuffL(target, spell)
end)

NeP.Condition:Register("debuff.count", function(target, spell)
  local _,count = UnitDebuffL(target, spell, 'PLAYER')
  return count or 0
end)

NeP.Condition:Register("debuff.count.any", function(target, spell)
  local _,count = UnitDebuffL(target, spell)
  return count or 0
end)

NeP.Condition:Register("debuff.duration", function(target, spell)
  local debuff,_,expires = UnitDebuffL(target, spell)
  return debuff and (expires - _G.GetTime()) or 0
end)

NeP.Condition:Register("debuff.many", function(target, spell)
  local count = 0
  for i=1,40 do
    if UnitDebuffL(target, i, 'PLAYER') == spell then count = count + 1 end
  end
  return count
end)

NeP.Condition:Register("debuff.many.any", function(target, spell)
  local count = 0
  for i=1,40 do
    if UnitDebuffL(target, i) == spell then count = count + 1 end
  end
  return count
end)

----------------------------------------------------------------------------------------------

-- Counts how many units have the buff
-- USAGE: count(BUFF).buffs > = #
NeP.Condition:Register("count.enemies.buffs", function(_,buff)
  local n1 = 0
  for i=1, NeP.Protected.GetObjectCount() do
    local Obj = NeP.Protected.GetObjectWithIndex(i)
    if NeP.Protected.omVal(Obj)
    and _G.UnitCanAttack('player', Obj)
    and NeP.Condition:Get('buff')(Obj, buff) then
      n1 = n1 + 1
    end
  end
  return n1
end)

-- Counts how many units have the buff
-- USAGE: count(BUFF).buffs > = #
NeP.Condition:Register("count.friendly.buffs", function(_,buff)
  local n1 = 0
  for i=1, NeP.Protected.GetObjectCount() do
    local Obj = NeP.Protected.GetObjectWithIndex(i)
    if NeP.Protected.omVal(Obj)
    and _G.UnitCanAttack('player', Obj)
    and NeP.Condition:Get('buff')(Obj, buff) then
          n1 = n1 + 1
      end
  end
  return n1
end)

-- Counts how many units have the debuff
-- USAGE: count(DEBUFF).debuffs > = #
NeP.Condition:Register("count.enemies.debuffs", function(_,debuff)
  local n1 = 0
  for i=1, NeP.Protected.GetObjectCount() do
    local Obj = NeP.Protected.GetObjectWithIndex(i)
    if NeP.Protected.omVal(Obj)
    and _G.UnitCanAttack('player', Obj)
    and NeP.Condition:Get('debuff')(Obj, debuff) then
          n1 = n1 + 1
      end
  end
  return n1
end)

-- Counts how many units have the debuff
-- USAGE: count(DEBUFF).debuffs > = #
NeP.Condition:Register("count.friendly.debuffs", function(_,debuff)
  local n1 = 0
  for i=1, NeP.Protected.GetObjectCount() do
    local Obj = NeP.Protected.GetObjectWithIndex(i)
    if NeP.Protected.omVal(Obj)
    and _G.UnitCanAttack('player', Obj)
    and NeP.Condition:Get('debuff')(Obj, debuff) then
          n1 = n1 + 1
      end
  end
  return n1
end)
