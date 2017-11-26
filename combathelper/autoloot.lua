local _, NeP = ...

local _G = _G
local icon = 'Interface\\Icons\\trade_archaeology_chestoftinyglassanimals'
local GetNumLootItems = GetNumLootItems
local LootSlotHasItem = LootSlotHasItem
local LootSlot = LootSlot
local CloseLoot = CloseLoot
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local NUM_BAG_SLOTS = NUM_BAG_SLOTS
local looting = false

function NeP.CombatHelper.Load_Loot()

	-- DOnt load if not advanced
	if not HackEnabled then return end

	NeP.Interface:AddToggle({
			key = 'AutoLoot',
			name = 'Auto Loot',
			text = 'Automatically loot units around you',
			icon = icon,
			nohide = true
	})

	local function BagSpace()
		local freeslots = 0
		for lbag = 0, NUM_BAG_SLOTS do
			local numFreeSlots = GetContainerNumFreeSlots(lbag)
			freeslots = freeslots + numFreeSlots
		end
		return freeslots
	end

	function NeP.CombatHelper.Loot()
		looting = true
	  for i=1, GetNumLootItems() do
			if LootSlotHasItem(i) then LootSlot(i) end
	  end
		C_Timer.After(1, function()
			CloseLoot()
			looting = false
		end)
	end

	function NeP.CombatHelper.DoLoot()
	    for _, Obj in pairs(NeP.OM:Get('Dead')) do
	        if Obj.distance < 5 and ObjectIsVisible(Obj.key) then
	            local hl,cl = CanLootUnit(ObjectGUID(Obj.key))
	            if hl and cl then
	                ObjectInteract(Obj.key)
	                NeP.ActionLog:Add("Auto Loot", "Looted", icon, Obj.name)
	                break
	            end
	        end
	    end
	end

	-- Ticker
	C_Timer.NewTicker(0.1, (function()
		if NeP.DSL:Get('toggle')(nil, 'mastertoggle')
		and NeP.DSL:Get('toggle')(nil, 'AutoLoot')
		and not UnitChannelInfo('player')
		and not UnitCastingInfo('player')
	  and not IsMounted("player")
		and not UnitAffectingCombat("player") then
			if BagSpace()>0  then
				if LootFrame:IsShown() then
					if not looting then
						NeP.CombatHelper:Loot()
					end
	      else
					NeP.CombatHelper:DoLoot()
				end
			end
		end
	end), nil)

	return true
end

NeP.Protected:AddCallBack(NeP.CombatHelper.Load_Loot)
