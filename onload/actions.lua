local n_name, NeP = ...
local _G = _G
local LibDisp = _G.LibStub('LibDispellable-1.0')

local GetItemSpell = _G.GetItemSpell
local IsUsableItem = _G.IsUsableItem
local IsEquippedItem = _G.IsEquippedItem
local GetInventoryItemCooldown = _G.GetInventoryItemCooldown
local GetItemCooldown = _G.GetItemCooldown
local GetItemCount = _G.GetItemCount
local GetSpellInfo = _G.GetSpellInfo
local GetInventorySlotInfo = _G.GetInventorySlotInfo
local GetInventoryItemID = _G.GetInventoryItemID
local GetItemInfo = _G.GetItemInfo
local random = _G.random
local GetSpellBookItemInfo = _G.GetSpellBookItemInfo
local GetSpellCooldown = _G.GetSpellCooldown
local IsUsableSpell = _G.IsUsableSpell
local F = NeP.Interface.Fetch
local K = n_name..'_Settings'
local LastUsed = NeP.CombatTracker.LastUsed

local funcs = {
  noop = function() end,
  Cast = function(eva)
    NeP.Parser.LastCast = eva.spell
    NeP.Parser.LastGCD = not eva.nogcd and eva.spell or NeP.Parser.LastGCD
    NeP.Parser.LastTarget = eva.target
    NeP.Protected["Cast"](eva.spell, eva.target)
    return true
  end,
  UseItem = function(eva) NeP.Protected["UseItem"](eva.spell, eva.target); return true end,
  Macro = function(eva) NeP.Protected["Macro"]("/"..eva.spell, eva.target); return true end,
  Lib = function(eva) return NeP.Library:Parse(eva.spell, eva.target, eva[1].args) end,
  C_Buff = function(eva) _G.CancelUnitBuff('player', _G.GetSpellInfo(eva[1].args)) end
}

local function userLike(spell)
  if F(K, "userLike", true) then
    print(1)
    local t = (F(K, "minOffCD", 1) + random(-.5,.5))/1000
    return LastUsed(spell, 'player') + t < GetTime()
  end
  return true
end

local function IsSpellReady(spell)
  if GetSpellBookItemInfo(spell) ~= 'FUTURESPELL'
  and (GetSpellCooldown(spell) or 0) <= NeP.DSL:Get('gcd')()
  and userLike(spell) then
    return IsUsableSpell(spell)
  end
end

-- Clip
NeP.Compiler:RegisterToken("!", function(_, ref)
    ref.interrupts = true
    ref.bypass = true
end)

-- No GCD
NeP.Compiler:RegisterToken("&", function(eval)
    eval.nogcd = true
end)

-- Regular actions
NeP.Compiler:RegisterToken("%", function(eval, ref)
  eval.exe = funcs["noop"]
  ref.token = ref.spell
end)

-- USAGE: {"%dispel", nil, UNIT}
-- this will dispel any spell if any from the unit
NeP.Actions:Add('dispel', function(eval)
  if not _G.UnitExists(eval[3].target) then return end
  for _, spellID, _,_,_,_,_, duration, expires in LibDisp:IterateDispellableAuras(eval[3].target) do
    local spell = GetSpellInfo(spellID)
    if IsSpellReady(spell)
    and (expires - eval.master.time) < (duration - math.random(1, 3)) then
      eval.spell = spell
      eval.exe = funcs["Cast"]
      return true
    end
  end
end)

-- Executes a users macro
NeP.Compiler:RegisterToken("/", function(eval, ref)
  ref.token = 'macro'
  eval.exe = funcs["Macro"]
end)

NeP.Actions:Add('macro', function()
  return true
end)

-- Executes a users macro
NeP.Actions:Add('function', function()
  return true
end)

-- Executes a users lib
NeP.Compiler:RegisterToken("@", function(eval, ref)
  ref.token = 'lib'
  eval.exe = funcs["Lib"]
end)

NeP.Actions:Add('lib', function()
  return true
end)

-- Cancel buff
NeP.Actions:Add('cancelbuff', function(eval)
  eval.exe = funcs["C_Buff"]
  return true
end)

-- Cancel Shapeshift Form
NeP.Actions:Add('cancelform', function(eval)
  eval.exe = _G.CancelShapeshiftForm
  return true
end)

-- Automated tauting
-- USAGE %taunt(SPELL)
NeP.Actions:Add('taunt', function(eval)
  if not IsSpellReady(eval[1].args) then return end
  for _, Obj in pairs(NeP.OM:Get('Enemy')) do
    if _G.UnitExists(Obj.key)
    and Obj.distance <= 30
    and NeP.Taunts:ShouldTaunt(Obj.key) then
      eval.spell = eval[1].args
      eval[3].target = Obj.key
      eval.exe = funcs["Cast"]
      return true
    end
  end
end)

-- Ress all dead
NeP.Actions:Add('ressdead', function(eval)
  if not IsSpellReady(eval[1].args) then return end
  for _, Obj in pairs(NeP.OM:Get('Friendly')) do
    if Obj.distance < 40
    and _G.UnitExists(Obj.key)
    and _G.UnitIsPlayer(Obj.key)
    and _G.UnitIsDeadOrGhost(Obj.key)
    and _G.UnitPlayerOrPetInParty(Obj.key) then
      eval.spell = eval[1].args
      eval[3].target = Obj.key
      eval.exe = funcs["Cast"]
      return true
    end
  end
end)

-- Pause
NeP.Actions:Add('pause', function(eval)
  eval.exe = function() return true end
  return true
end)

--USAGE in CR:
--{"%target", CONDITION, TARGET}
NeP.Actions:Add('target', function(eval)
	eval.exe = function(eva)
		NeP.Protected.TargetUnit(eva.target)
		return true
	end
	return true
end)

-- Items
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

local temp_itemx = {}

local function compile_item(ref, item)
  local invitem = invItems[item]
  if invitem then
		local slotid = GetInventorySlotInfo(invitem)
		item = GetInventoryItemID("player", slotid) or ref.spell
		ref.invitem = true
		ref.invslot = slotid
	end
	ref.id = tonumber(item) or NeP.Core:GetItemID(item)
	local itemName, itemLink, _,_,_,_,_,_,_, texture = GetItemInfo(ref.id)
	ref.spell = itemName or ref.spell
	ref.icon = texture
	ref.link = itemLink
  ref.usable = GetItemSpell(ref.spell) and IsUsableItem(ref.spell)
  if not invitem then
    ref.usable = ref.usable and GetItemCount(item.spell) > 0
  else
    ref.usable = ref.usable and IsEquippedItem(ref.spell)
  end
end

NeP.Compiler:RegisterToken("#", function(eval, ref)
	local item = ref.spell
	ref.token = 'item'
	eval.bypass = true
	compile_item(ref, item)
  temp_itemx[#temp_itemx+1] = function() compile_item(ref, item) end
	eval.exe = funcs["UseItem"]
end)

NeP.Listener:Add("NeP_Compiler_Item", "BAG_UPDATE", function()
  for i=1, #temp_itemx do
    temp_itemx[i]()
  end
end)
NeP.Listener:Add("NeP_Compiler_Item", "UNIT_INVENTORY_CHANGED", function(unit)
  if not unit == 'player' then return end
  for i=1, #temp_itemx do
    temp_itemx[i]()
  end
end)

NeP.Actions:Add('item', function(eval)
  local item = eval[1]
  if not item.id then return end
  --Iventory invItems
  if item.invitem then
    return item.usable
    and select(2,GetInventoryItemCooldown('player', item.invslot)) == 0
  --regular
  else
    return item.usable
    and select(2,GetItemCooldown(item.id)) == 0
  end
end)

-- regular spell
NeP.Compiler:RegisterToken("spell_cast", function(eval, ref)
  ref.spell = NeP.Spells:Convert(ref.spell, eval.master.name)
  ref.icon = select(3,GetSpellInfo(ref.spell))
  ref.id = NeP.Core:GetSpellID(ref.spell)
  eval.exe = funcs["Cast"]
  ref.token = 'spell_cast'
end)

--cache
NeP.Cache.Spells = {}
local C = NeP.Cache.Spells

-- this forces the parser to stop until this spel is ready
local function POLLING_PARSER(eval, nomana)
  if not eval.master.pooling then return end
  eval.master.halt = eval.master.halt or nomana or false
  if eval.master.halt then eval.master.halt_spell = eval[1].spell end
end

NeP.Actions:Add('spell_cast', function(eval)
  -- cached
  if C[eval[1].spell] ~= nil then return C[eval[1].spell]; end
  -- normal stuff
  local ready, nomana = IsSpellReady(eval[1].spell)
  C[eval[1].spell] = ready or false
  POLLING_PARSER(eval, nomana)
  return ready or false
end)
