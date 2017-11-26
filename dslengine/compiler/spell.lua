local _, gbl = ...

local s_types = {}
local s_tokens = {}

local noop = function() end

-- this is the regual spell path
-- has to validate the spell, if its ready, etc...
local function regularSpell(eval)
  eval.spell = gbl.Spells:Convert(eval.spell)
  eval.icon = select(3,GetSpellInfo(eval.spell))
  eval.id = gbl.Core.GetSpellID(eval.spell)
  eval.exeVal = gbl.API.IsSpellReady
  eval.exe = gbl.API.CastSpell
  eval.token = "Spell"
end

local invItems = {
  ["head"]    = "HeadSlot",
  ["helm"]    = "HeadSlot",
  ["neck"]    = "NeckSlot",
  ["shoulder"]  = "ShoulderSlot",
  ["shirt"]    = "ShirtSlot",
  ["chest"]    = "ChestSlot",
  ["belt"]    = "WaistSlot",
  ["waist"]    = "WaistSlot",
  ["legs"]    = "LegsSlot",
  ["pants"]    = "LegsSlot",
  ["feet"]    = "FeetSlot",
  ["boots"]    = "FeetSlot",
  ["wrist"]    = "WristSlot",
  ["bracers"]    = "WristSlot",
  ["gloves"]    = "HandsSlot",
  ["hands"]    = "HandsSlot",
  ["finger1"]    = "Finger0Slot",
  ["finger2"]    = "Finger1Slot",
  ["trinket1"]  = "Trinket0Slot",
  ["trinket2"]  = "Trinket1Slot",
  ["back"]    = "BackSlot",
  ["cloak"]    = "BackSlot",
  ["mainhand"]  = "MainHandSlot",
  ["offhand"]    = "SecondaryHandSlot",
  ["weapon"]    = "MainHandSlot",
  ["weapon1"]    = "MainHandSlot",
  ["weapon2"]    = "SecondaryHandSlot",
  ["ranged"]    = "RangedSlot"
}

local function InvItems(item, eval)
  if not invItems[item] then
    return item
  end
  local invItem = GetInventorySlotInfo(invItems[item])
  item = GetInventoryItemID("player", invItem) or eval.spell
  eval.invitem = true
  eval.invslot = invItem
  return item
end

-- Item
-- Checks if its rady
s_tokens["#"] = function(eval)
  local item = eval.spell
  item = InvItems(item, eval)
  eval.id = tonumber(item) or gbl.Core.GetItemID(item)
  local itemName, itemLink, _,_,_,_,_,_,_, texture = GetItemInfo(eval.id)
  eval.spell = itemName or eval.spell
  eval.icon = texture
  eval.link = itemLink
  eval.exeVal = gbl.API.IsItemReady
  eval.exe = gbl.API.UseItem
  eval.token = "Item"
end

s_tokens["%"] = function(eval)
  eval.token = "Action"
  eval.exe = function() return true end
end

-- Macro
-- has no real sanity checks... its up to the dev
s_tokens["/"] = function(eval)
  eval.token = "Macro"
  eval.exe = gbl.API.Macro
end

-- Interrupt
-- same as spell but Interrupts the current
s_tokens["!"] = function(eval)
  eval.exeExtra = gbl.API.Interrupt
end

-- Library
-- has no real sanity checks... its up to the dev
s_tokens["@"] = function(eval)
  eval.token = "Library"
  eval.exe = gbl.Library.Parse
end

-- usual string spell
-- compile it into a function
s_types["string"] = function(spell)
  local eval = {}
  eval.spell = spell
  --Arguments
	eval.args = eval.spell:match("%((.+)%)")
  eval.spell = eval.spell:gsub("%((.+)%)","")
  -- find tokens
  local nextToken = eval.spell:sub(1,1)
  while(s_tokens[nextToken]) do
    s_tokens[nextToken](eval)
    eval.spell = eval.spell:sub(2)
    nextToken = eval.spell:sub(1,1)
  end
  -- if it has no function then its a regular Spell
  if not eval.exe then
    regularSpell(eval)
  end
  return {
    exeVal = eval.exeVal,
    exeFunc = eval.exe,
    spell = eval.spell,
    spellArgs = eval.args,
    token = eval.token,
    icon = eval.icon,
  }
end

-- function type Spell
-- just return whatever it gives
s_types["function"] = function(spell)
  return {
    spell = "FUNCZ",
    exeFunc = spell,
    token = "Function"
  }
end

-- nest (recursive)
-- compile into a function
s_types["table"] = function(...)
  return {
    spell = "TABLEZ",
    exeFunc = gbl.Compiler.Compile(...),
    token = "Table",
    isTable = true
  }
end

-- nil
-- this is a cr author error... lets fix it!
s_types["nil"] = function()
  return {
    spell = "NILZ",
    exeVal = function() return false end,
    exeFunc = noop,
    token = "Nil",
  }
end

-- public func (main)
-- return a function ready for usage
function gbl.Compiler.Spell(...)
  return s_types[type(...)](...)
end
