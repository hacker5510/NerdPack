local _, NeP = ...

local s_types = {}
local s_tokens = {}

local noop = function() end

-- this is the regual spell path
-- has to validate the spell, if its ready, etc...
local function regularSpell(eval)
  eval.spell = NeP.Spells:Convert(eval.spell)
  eval.icon = select(3,_G.GetSpellInfo(eval.spell))
  eval.id = NeP.Core:GetSpellID(eval.spell)
  eval.exeVal = NeP.API.IsSpellReady
  eval.exe = NeP.API.CastSpell
end

local invItems = {
  ['head']    = 'HeadSlot',
  ['helm']    = 'HeadSlot',
  ['neck']    = 'NeckSlot',
  ['shoulder']  = 'ShoulderSlot',
  ['shirt']    = 'ShirtSlot',
  ['chest']    = 'ChestSlot',
  ['belt']    = 'WaistSlot',
  ['waist']    = 'WaistSlot',
  ['legs']    = 'LegsSlot',
  ['pants']    = 'LegsSlot',
  ['feet']    = 'FeetSlot',
  ['boots']    = 'FeetSlot',
  ['wrist']    = 'WristSlot',
  ['bracers']    = 'WristSlot',
  ['gloves']    = 'HandsSlot',
  ['hands']    = 'HandsSlot',
  ['finger1']    = 'Finger0Slot',
  ['finger2']    = 'Finger1Slot',
  ['trinket1']  = 'Trinket0Slot',
  ['trinket2']  = 'Trinket1Slot',
  ['back']    = 'BackSlot',
  ['cloak']    = 'BackSlot',
  ['mainhand']  = 'MainHandSlot',
  ['offhand']    = 'SecondaryHandSlot',
  ['weapon']    = 'MainHandSlot',
  ['weapon1']    = 'MainHandSlot',
  ['weapon2']    = 'SecondaryHandSlot',
  ['ranged']    = 'RangedSlot'
}

local function InvItems(item, eval)
  if not invItems[item] then
    return item
  end
  local invItem = _G.GetInventorySlotInfo(invItems[item])
  item = _G.GetInventoryItemID("player", invItem) or eval.spell
  eval.invitem = true
  eval.invslot = invItem
  return item
end

-- Item
-- Checks if its rady
s_tokens["#"] = function(eval)
  local item = eval.spell
  item = InvItems(item, eval)
  eval.id = tonumber(item) or NeP.Core:GetItemID(item)
  local itemName, itemLink, _,_,_,_,_,_,_, texture = _G.GetItemInfo(eval.id)
  eval.spell = itemName or eval.spell
  eval.icon = texture
  eval.link = itemLink
  eval.exeVal = NeP.API.IsItemReady
  eval.exe = NeP.API.UseItem
end

s_tokens["%"] = function(eval)
  eval.exe = function() return true end
end

-- Macro
-- has no real sanity checks... its up to the dev
s_tokens["/"] = function(eval)
  eval.exe = NeP.API.Macro
end

-- Interrupt
-- same as spell but Interrupts the current
s_tokens["!"] = function(eval)
  regularSpell(eval)
  eval.exeExtra = function() NeP.API:Interrupt(eval.spell) end
end

-- Library
-- has no real sanity checks... its up to the dev
s_tokens["@"] = function(eval)
  eval.exe = function(...) return NeP.Library:Parse(...) end
end

-- usual string spell
-- compile it into a function
s_types["string"] = function(spell)
  local eval = {}
  eval.spell = spell
  --Arguments
	eval.args = eval.spell:match('%((.+)%)')
  eval.spell = eval.spell:gsub('%((.+)%)','')
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
    spellArgs = eval.args
  }
end

-- function type Spell
-- just return whatever it gives
s_types["function"] = function(spell)
  return { exeFunc = spell }
end

-- nest (recursive)
-- compile into a function
s_types["table"] = function(...)
  return {
    spell = "TABLEZ",
    exeFunc = NeP.Compiler.Compile(...),
    isTable = true
  }
end

-- nil
-- this is a cr author error... lets fix it!
s_types["nil"] = function()
  return {
    exeVal = function() return false end,
    exeFunc = noop
  }
end

-- public func (main)
-- return a function ready for usage
function NeP.Compiler.Spell(...)
  return s_types[type(...)](...)
end
