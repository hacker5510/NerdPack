local _, gbl = ...

function gbl.CombatHelper.Load_Move()

	-- Dont even load if not using advaned
	if not HackEnabled then return end

	gbl.Interface:AddToggle({
			key = 'AutoMove',
			name = 'Auto Move',
			text = 'Automatically move to your target',
			icon = 'Interface\\Icons\\ability_monk_legsweep',
			nohide = true
	})

	local awsd = {65, 83, 68, 87}
	function gbl.CombatHelper.ManualMoving()
	  for i=1, #awsd do
	    if GetKeyState(awsd[i]) then
	      return true
	    end
	  end
	end

	function gbl.CombatHelper.Move()
		local specIndex = GetSpecializationInfo(GetSpecialization())
		local tRange = gbl.ClassTable:GetRange(specIndex)
		local Range = gbl.Condition:Get("range")("player", "target")
		local unitSpeed = GetUnitSpeed('player')
		-- Stop Moving
		if Range > tRange and unitSpeed ~= 0 then
			local pX, pY, pZ = ObjectPosition('player')
			MoveTo(pX, pY, pZ)
		-- Start Moving
		elseif Range < tRange then
			local oX, oY, oZ = ObjectPosition('target')
			MoveTo(oX, oY, oZ)
		end
	end

	local function Start()
		if UnitAffectingCombat('player')
		and UnitExists('target')
		and gbl.Condition:Get('toggle')(nil, 'mastertoggle')
		and gbl.Condition:Get('toggle')(nil, 'AutoMove')
		and not gbl.Condition:Get('casting')('player')
		and not gbl.CombatHelper:ManualMoving() then
			gbl.CombatHelper:Move()
		end
	end

	-- Ticker
	C_Timer.NewTicker(0.5, Start)
	gbl.Debug:Add("FACING", Start, true)

	return true
end

gbl.Protected:AddCallBack(gbl.CombatHelper.Load_Move)
