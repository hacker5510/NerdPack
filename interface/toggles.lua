local n_name, gbl = ...
local mainframe = gbl.Interface.MainFrame
local L = gbl.Locale
local GameTooltip = GameTooltip
local CreateFrame = CreateFrame
local unpack = unpack

gbl.ButtonsSize = 40
gbl.ButtonsPadding = 2

gbl.min_width = 40
gbl.min_height = 25

local title_size = 20

-- Load Saved sizes
gbl.Core:WhenInGame(function()
	gbl.ButtonsSize = gbl.Config:Read(n_name..'_Settings', 'bsize', 40)
	gbl.ButtonsPadding = gbl.Config:Read(n_name..'_Settings', 'bpad', 2)
	gbl.Interface:RefreshToggles()
end)

local Toggles = {}

local function SetTexture(parent, icon)
	local temp = parent:CreateTexture()
	if icon then
		temp:SetTexture(icon)
		temp:SetTexCoord(.08, .92, .08, .92)
	else
		local r,g,b = unpack(gbl.Core:ClassColor('player', 'rgb'))
		temp:SetColorTexture(r,g,b,.7)
	end
	temp:SetAllPoints(parent)
	return temp
end

local function OnClick(self, func, button)
	if button == 'LeftButton' then
		self.actv = not self.actv
		gbl.Config:Write('TOGGLE_STATES', self.key, self.actv)
	end
	if func then
		func(self, button)
	end
	self:SetChecked(self.actv)
end

local function OnEnter(self, name, text)
	local OnOff = self.actv and L:TA('Any', 'ON') or L:TA('Any', 'OFF')
	GameTooltip:SetOwner(self, "ANCHOR_TOP")
	GameTooltip:AddDoubleLine(name, OnOff)
	if text then
		GameTooltip:AddLine('|cffFFFFFF'..text)
	end
	GameTooltip:Show()
end

local function CreateToggle(eval)
	eval.key = eval.key:lower()
	Toggles[#Toggles+1] = CreateFrame("CheckButton", eval.key, mainframe.content)
	local temp = Toggles[#Toggles]
	temp:SetFrameStrata("high")
	temp:SetFrameLevel(1)
	temp.key = eval.key
	temp:SetFrameLevel(1)
	temp:SetNormalFontObject("GameFontNormal")
	temp.texture = SetTexture(temp, eval.icon)
	temp.actv = gbl.Config:Read('TOGGLE_STATES', eval.key, false)
	temp.nohide = eval.nohide
	temp.Checked_texture = SetTexture(temp)
	temp:SetCheckedTexture(temp.Checked_texture)
	temp:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	temp:SetScript("OnClick", function(self, button) OnClick(self, eval.func, button) end)
	temp:SetScript("OnEnter", function(self) OnEnter(self, eval.name, eval.text) end)
	temp:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local function GetToggle(key)
	for i=1, #Toggles do
		if Toggles[i].key == key then return Toggles[i] end
	end
end

function gbl.Interface.UpdateIcon(_, key, icon)
	local test = GetToggle(key)
	if not icon or not test then return end
	test.texture:SetTexture(icon)
end

function gbl.Interface.AddToggle(_, eval)
	gbl.Core:WhenInGame(function()
		local test = GetToggle(eval.key)
		if test then
			test:Show()
		else
			CreateToggle(eval)
		end
		gbl.Interface:RefreshToggles()
	end)
end

function gbl.Interface.RefreshToggles()
	local tcount, row_count, maxed = 0, 0, 0

	for i=1, #Toggles do
		if Toggles[i]:IsShown() then

			-- This is to handle rows
			local n1 = gbl.Config:Read(n_name..'_Settings', 'brow', 10)
			if tcount >= n1 then
				maxed = tcount
				tcount = 0
				row_count = row_count + 1
			end

			tcount = tcount + 1
			local pos = (gbl.ButtonsSize*tcount)+(tcount*gbl.ButtonsPadding)-(gbl.ButtonsSize+gbl.ButtonsPadding)
			Toggles[i]:SetSize(gbl.ButtonsSize, gbl.ButtonsSize)
			Toggles[i]:SetPoint("TOPLEFT", mainframe.content, pos, -(row_count*gbl.ButtonsSize))
			Toggles[i]:SetChecked(Toggles[i].actv)
		end
	end

	-- this is to handle max width
	if maxed > 0 then
		tcount = maxed
	end

	-- Set size to match ButtonsSize
	mainframe.settings.width = tcount*(gbl.ButtonsSize+gbl.ButtonsPadding)
	mainframe.settings.height = (gbl.ButtonsSize*(row_count+1))+title_size

	-- Dont go bellow the mimimum allowed
	if mainframe.settings.width<gbl.min_width then mainframe.settings.width=gbl.min_width end
	if mainframe.settings.height<gbl.min_height then mainframe.settings.height=gbl.min_height end

	-- Dont allow Resize
	mainframe.settings.minHeight = mainframe.settings.height
	mainframe.settings.minWidth = mainframe.settings.width
	mainframe.settings.maxHeight = mainframe.settings.height
	mainframe.settings.maxWidth = mainframe.settings.width

	-- apply
	mainframe:ApplySettings()
end

function gbl.Interface.ResetToggles()
	for i=1, #Toggles do
		if not Toggles[i].nohide then
			Toggles[i]:Hide()
		end
	end
	gbl.Interface:RefreshToggles()
end

function gbl.Interface.toggleToggle(_, key, state)
	local tmp = GetToggle(key:lower())
	if not tmp then return end
	tmp.actv = state or not tmp.actv
	tmp:SetChecked(tmp.actv)
	gbl.Config:Write('TOGGLE_STATES', tmp.key, tmp.actv)
end
