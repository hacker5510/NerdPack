local n_name, gbl = ...
local logo = "|T"..gbl.Media.."logo.blp:10:10|t"
local L = gbl.Locale
local gbl_ver = tostring(gbl.Version.major.."."..gbl.Version.minor.."-"..gbl.Version.branch)

local EasyMenu = EasyMenu
local CreateFrame = CreateFrame
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecialization = GetSpecialization
local GetBuildInfo = GetBuildInfo

local function CR_Ver_WoW(cr_wow_ver, wow_ver)
	return wow_ver:find("^"..tostring(cr_wow_ver))
end

local function CR_Ver_gbl(cr_gbl_ver)
	return gbl_ver:find("^"..tostring(cr_gbl_ver))
end

gbl.Interface.MainFrame = gbl.Interface.BuildGUI({
	key = "gblMFrame",
	width = 100,
	height = 60,
	title = logo..n_name,
	subtitle = "v:"..gbl_ver
}).parent
gbl.Interface.MainFrame:SetEventListener("OnClose", function()
	gbl.Core.Print(L:TA("Any", "gbl_Show"))
end)

local menuFrame = CreateFrame("Frame", "gbl_DropDown", gbl.Interface.MainFrame.frame, "UIDropDownMenuTemplate")
menuFrame:SetPoint("BOTTOMLEFT", gbl.Interface.MainFrame.frame, "BOTTOMLEFT", 0, 0)
menuFrame:Hide()

local DropMenu = {
	{text = logo.."["..n_name.." |rv:"..gbl_ver.."]", isTitle = 1, notCheckable = 1},
	{text = L:TA("mainframe", "CRS"), hasArrow = true, menuList = {}},
	{text = L:TA("mainframe", "CRS_ST"), hasArrow = true, menuList = {}}
}

function gbl.Interface.ResetCRs()
	DropMenu[2].menuList = {}
	DropMenu[3].menuList = {}
	local spec = GetSpecializationInfo(GetSpecialization())
	for _,v in pairs(gbl.CR:GetList(spec)) do
		gbl.Interface:AddCR(v)
		if v.has_gui then gbl.Interface:AddCR_ST(v.name) end
	end
end

function gbl.Interface.UpdateCRs()
	local spec = GetSpecializationInfo(GetSpecialization())
	local last = gbl.Config:Read("SELECTED", spec)
	for _,v in pairs(DropMenu[2].menuList) do
		v.checked = last == v.name
	end
end

function gbl.Interface:AddCR_ST(Name)
	table.insert(DropMenu[3].menuList, {
		text = Name,
		notCheckable = 1,
		func = function()
			self:BuildGUI(Name)
		end
	})
end

function gbl.Interface.AddCR(_, ev)
	local text = ev.name.."|cff0F0F0F <->|r [WoW: "..ev.wow_ver.." gbl: "..ev.gbl_ver.."]"
	local wow_ver = GetBuildInfo()
	table.insert(DropMenu[2].menuList, {
		text = text,
		name = ev.name,
		func = function()
			gbl.CR:Set(ev.spec, ev.name)
				if not CR_Ver_WoW(ev.wow_ver, wow_ver)  then
					gbl.Core.Print(ev.name, "|rwas not built for WoW:", wow_ver, "\nThis might cause problems!")
				end
				if not CR_Ver_gbl(ev.gbl_ver, gbl_ver) then
					gbl.Core.Print(ev.name, "|rwas not built for", gbl_ver, "\nThis might cause problems!")
				end
				gbl.Core.Print(L:TA("mainframe", "ChangeCR"), ev.name)
				gbl.Interface.UpdateCRs()
		end
	})
end

function gbl.Interface.DropMenu()
	EasyMenu(DropMenu, menuFrame, menuFrame, 0, 0, "MENU")
end

function gbl.Interface.Add(_, name, func)
	table.insert(DropMenu, {
		text = tostring(name),
		func = func,
		notCheckable = 1
	})
end

----------------------------EVENTS
gbl.Listener:Add("gbl_CR_interface", "PLAYER_LOGIN", function()
	gbl.Interface.ResetCRs()
end)
gbl.Listener:Add("gbl_CR_interface", "PLAYER_SPECIALIZATION_CHANGED", function(unitID)
	if unitID ~= "player" then return end
	gbl.Interface:ResetCRs()
end)
