local _, NeP = ...

function NeP.CombatHelper.Load_Face()

	-- Dont even load if not using advaned
	if not HackEnabled then return end

	NeP.Interface:AddToggle({
			key = 'AutoFace',
			name = 'Auto Face',
			text = 'Automatically Face your target',
			icon = 'Interface\\Icons\\misc_arrowlup',
			nohide = true
	})

	function NeP.CombatHelper.Face()
		local ax, ay = ObjectPosition('player')
		local bx, by = ObjectPosition('target')
		if not ax or not bx or UnitIsDeadOrGhost('target') then return end
		local angle = rad(atan2(by - ay, bx - ax))
		if angle < 0 then
			UnitSetFacing('player', rad(atan2(by - ay, bx - ax) + 360))
		else
			UnitSetFacing('player', angle)
		end
	end

	-- Ticker
	C_Timer.NewTicker(0.1, (function()
		if UnitAffectingCombat('player')
		and UnitExists('target')
		and NeP.DSL:Get('toggle')(nil, 'mastertoggle')
		and NeP.DSL:Get('toggle')(nil, 'AutoFace')
		and not UnitChannelInfo('player')
		and not UnitCastingInfo('player')
		and not NeP.DSL:Get('Infront')('target')
		and not NeP.DSL:Get('moving')('player')
		and not NeP.CombatHelper:ManualMoving() then
			NeP.CombatHelper:Face()
		end
	end), nil)

	return true
end

NeP.Protected:AddCallBack(NeP.CombatHelper.Load_Face)
