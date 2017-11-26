local _, gbl = ...

function gbl.CombatHelper.Load_Face()

	-- Dont even load if not using advaned
	if not HackEnabled then return end

	gbl.Interface:AddToggle({
			key = 'AutoFace',
			name = 'Auto Face',
			text = 'Automatically Face your target',
			icon = 'Interface\\Icons\\misc_arrowlup',
			nohide = true
	})

	function gbl.CombatHelper.Face()
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

	local function Start()
		if UnitAffectingCombat('player')
		and UnitExists('target')
		and gbl.Condition:Get('toggle')(nil, 'mastertoggle')
		and gbl.Condition:Get('toggle')(nil, 'AutoFace')
		and not UnitChannelInfo('player')
		and not UnitCastingInfo('player')
		and not gbl.Condition:Get('Infront')('target')
		and not gbl.Condition:Get('moving')('player')
		and not gbl.CombatHelper:ManualMoving() then
			gbl.CombatHelper:Face()
		end
	end

	-- Ticker
	C_Timer.NewTicker(0.1, Start)
	gbl.Debug:Add("FACING", Start, true)

	return true
end

gbl.Protected:AddCallBack(gbl.CombatHelper.Load_Face)
