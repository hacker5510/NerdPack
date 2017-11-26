local _, NeP = ...
local _G = _G

NeP.Condition:Register({'equipped', 'item'}, function(_, item)
  return IsEquippedItem(item)
end)

NeP.Condition:Register('item.cooldown', function(_, item)
	local start, duration = GetItemCooldown(item)
	if not start then return 0 end
  return start ~= 0 and (start + duration - GetTime()) or 0
end)

NeP.Condition:Register('item.usable', function(_, item)
	local isUsable, notEnoughMana = IsUsableItem(item)
  if not isUsable or notEnoughMana or NeP.Condition:Get('item.cooldown')(nil, item) ~= 0 then return false end
	return true
end)

NeP.Condition:Register('item.count', function(_, item)
  return GetItemCount(item, false, true)
end)

NeP.Condition:Register('twohand', function()
  return IsEquippedItemType("Two-Hand")
end)

NeP.Condition:Register('onehand', function()
  return IsEquippedItemType("One-Hand")
end)

NeP.Condition:Register("ilevel", function()
  return math.floor(select(1,GetAverageItemLevel()))
end)
