local n_name, gbl = ...

gbl.Core = {}

local last_print = ""
function gbl.Core.Print(...)
	if last_print ~= ... then
		last_print = ...
		print("[|cff"..gbl.Color..n_name.."|r]", ...)
	end
end

local d_color = {
	hex = "FFFFFF",
	rgb = {1,1,1}
}

function gbl.Core.ClassColor(unit, type)
	type = type and type:lower() or "hex"
	if UnitExists(unit) then
		local classid  = select(3, UnitClass(unit))
		if classid then
			return gbl.ClassTable:GetClassColor(classid, type)
		end
	end
	return d_color[type]
end

function gbl.Core.Round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function gbl.Core.GetSpellID(spell)
	local _type = type(spell)
	if not spell then
		return
	elseif _type == "string" and spell:find("^%d") then
		return tonumber(spell)
	end
	local index, stype = gbl.Core.GetSpellBookIndex(spell)
	local spellID = select(7, GetSpellInfo(index, stype))
	return spellID
end

function gbl.Core.GetSpellName(spell)
	if not spell or type(spell) == "string" then return spell end
	local spellID = tonumber(spell)
	if spellID then
		return GetSpellInfo(spellID)
	end
	return spell
end

function gbl.Core.GetItemID(item)
	if not item or type(item) == "number" then return item end
	local itemID = string.match(select(2, GetItemInfo(item)) or "", "Hitem:(%d+):")
	return tonumber(itemID) or item
end

function gbl.Core.UnitID(unit)
	return tonumber(unit and select(6, strsplit("-", UnitGUID(unit))) or 0)
end

function gbl.Core.GetSpellBookIndex(spell)
	local spellName = gbl.Core.GetSpellName(spell)
	if not spellName then return end
	spellName = spellName:lower()

	for t = 1, 2 do
		local _, _, offset, numSpells = GetSpellTabInfo(t)
		for i = 1, (offset + numSpells) do
			if GetSpellBookItemName(i, BOOKTYPE_SPELL):lower() == spellName then
				return i, BOOKTYPE_SPELL
			end
		end
	end

	local numFlyouts = GetNumFlyouts()
	for f = 1, numFlyouts do
		local flyoutID = GetFlyoutID(f)
		local _, _, numSlots, isKnown = GetFlyoutInfo(flyoutID)
		if isKnown and numSlots > 0 then
			for g = 1, numSlots do
				local spellID, _, isKnownSpell = GetFlyoutSlotInfo(flyoutID, g)
				local name = gbl.Core.GetSpellName(spellID)
				if name and isKnownSpell and name:lower() == spellName then
					return spellID, nil
				end
			end
		end
	end

	local numPetSpells = HasPetSpells()
	if numPetSpells then
		for i = 1, numPetSpells do
			if GetSpellBookItemName(i, BOOKTYPE_PET):lower() == spellName then
				return i, BOOKTYPE_PET
			end
		end
	end
end

local Run_Cache = {}
function gbl.Core.WhenInGame(func, prio)
	if Run_Cache then
		table.insert(Run_Cache, {func = func, prio = prio or -(#Run_Cache)})
	else
		func()
	end
end

function gbl.Core.HexToRGB(hex)
	return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

function gbl.Core.string_split(string, delimiter)
	local result, from = {}, 1
	local delim_from, delim_to = string.find(string, delimiter, from)
	while delim_from do
		table.insert( result, string.sub(string, from , delim_from-1))
		from = delim_to + 1
		delim_from, delim_to = string.find(string, delimiter, from)
	end
	table.insert(result, string.sub(string, from))
	return result
end

gbl.Listener.Add("gbl_Core_load", "PLAYER_LOGIN", function()
	C_Timer.After(5, function()
		table.sort(Run_Cache, function(a,b) return a.prio > b.prio end)
		gbl.Color = gbl.Core.ClassColor("player", "hex")
		for i=1, #Run_Cache do
			Run_Cache[i].func()
		end
		Run_Cache = nil
	end)
end)
