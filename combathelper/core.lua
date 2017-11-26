local _, NeP = ...
NeP.CombatHelper = {}

local config = {
	key = 'CombatHelper',
	title = "Combat Helper",
	subtitle = 'Settings',
	width = 250,
	height = 200,
	config = {
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cfffd1c15Advanced|r Only:', size = 25, align = 'Center' },
			-- Nothing here yet
	}
}

local GUI = NeP.Interface:BuildGUI(config)
NeP.Interface:Add('Combat Helper', function() GUI.parent:Show() end)
GUI.parent:Hide()
