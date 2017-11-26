local _, gbl = ...

gbl.Buttons = {}

local nBars = {
	"ActionButton",
	"MultiBarBottomRightButton",
	"MultiBarBottomLeftButton",
	"MultiBarRightButton",
	"MultiBarLeftButton"
}

local function UpdateButtons()
	wipe(gbl.Buttons)
	for _, group in ipairs(nBars) do
		for i =1, 12 do
			local button = _G[group .. i]
			if button then
				local actionType, id = GetActionInfo(ActionButton_CalculateAction(button, "LeftButton"))
				if actionType == "spell" then
					local spell = GetSpellInfo(id)
					if spell then
						gbl.Buttons[spell] = button
					end
				end
			end
		end
	end
end

gbl.Listener:Add("gbl_Buttons","PLAYER_ENTERING_WORLD", function ()
	UpdateButtons()
end)

gbl.Listener:Add("gbl_Buttons","ACTIONBAR_SLOT_CHANGED", function ()
	UpdateButtons()
end)
