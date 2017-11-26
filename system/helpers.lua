local _, gbl = ...
local _G = _G
gbl.Helpers = {}
--local UIErrorsFrame = UIErrorsFrame
local C_Timer = C_Timer

local _Failed = {}

--this disables the error messages
--UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")

local function addToData(GUID)
	if not _Failed[GUID] then
		_Failed[GUID] = {}
	end
end

local function blackListSpell(GUID, spell)
	_Failed[GUID][spell] =  true
	C_Timer.After(0.5, (function()
		_Failed[GUID][spell] =  nil
	end), nil)
end

local function blackListInfront(GUID)
	_Failed[GUID].infront = true
	C_Timer.After(0.5, (function()
		_Failed[GUID].infront = nil
	end), nil)
end

function gbl.Helpers.Infront(_, target, GUID)
	GUID = GUID or UnitGUID(target)
	if _Failed[GUID] then
		 return not _Failed[GUID].infront
	end
	return true
end

function gbl.Helpers.Spell(_, spell, target, GUID)
	GUID = GUID or UnitGUID(target)
	if _Failed[GUID] then
		 return not _Failed[GUID][spell]
	end
	return true
end

function gbl.Helpers:Check(spell, target)
	-- Both MUST be strings
	if type(spell) ~= "string"
	or type(target) ~= "string" then
		return true
	end
	local GUID = UnitGUID(target)
	if _Failed[GUID] then
		return self:Spell(spell, target, GUID) and self:Infront(target, GUID)
	end
	return true
end

gbl.Listener:Add("gbl_Helpers", "UI_ERROR_MESSAGE", function(_, msg)
	local unit, spell = gbl.Helpers.LastTarget, gbl.Helpers.LastCast
	if not unit or not spell then return end
	local GUID = UnitGUID(unit)
	if not GUID then return end
	addToData(GUID)
	gbl.ActionLog:Add(">>> BLACKLIST - "..(msg or ""), spell, nil, unit)
	-- not infront
	if msg == ERR_BADATTACKFACING then
		blackListInfront(GUID)
	end
	blackListSpell(GUID, spell)
end)
