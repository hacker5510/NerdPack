local _, NeP = ...
NeP.CR = {}
NeP.CR.CurrentCR = nil

local CRs = {}
local noop = function() end

local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo

function NeP.CR.AddGUI(_, ev)
	local gui_st = ev.gui_st or {}
	local temp = {
		title = gui_st.title or ev.name,
		key = ev.name,
		width = gui_st.width or 200,
		height = gui_st.height or 300,
		config = ev.gui,
		color = gui_st.color,
		profiles = true
	}
	ev.gui = true
	NeP.Interface:BuildGUI(temp).parent:Hide()
end

local function add(ev)
	ev.name = ev.name
	ev.spec = ev.id
	ev.load = ev.load
	ev.unload = ev.unload
	ev[true] = ev.ic
	ev[false] = ev.ooc
	ev.wow_ver = ev.wow_ver
	ev.nep_ver = ev.nep_ver
	ev.blacklist = ev.blacklist
	ev.has_gui = ev.gui
	ev.blacklist.units = ev.blacklist.units or {}
	ev.blacklist.buff = ev.blacklist.buff or {}
	ev.blacklist.debuff = ev.blacklist.debuff or {}
	CRs[ev.id] = CRs[ev.id] or {}
	CRs[ev.id][ev.name] = ev
end

local function refs(ev, SpecID)
	ev.id = SpecID
	ev.ic = ev.ic or {}
	ev.ooc = ev.ooc or {}
	ev.wow_ver = ev.wow_ver or 0.00
	ev.nep_ver = ev.nep_ver or 0.00
	ev.load = ev.load or noop
	ev.unload = ev.unload or noop
	ev.blacklist = ev.blacklist or {}
	ev.blacklist.units = ev.blacklist.units or {}
	ev.blacklist.buff = ev.blacklist.buff or {}
	ev.blacklist.debuff = ev.blacklist.debuff or {}
end

function NeP.CR.Add(_, SpecID, ev)
	local classIndex = select(3, UnitClass('player'))
	-- This only allows crs we can use to be registered
	if not NeP.ClassTable:SpecIsFromClass(classIndex, SpecID )
	and classIndex ~= SpecID then
		return
	end
	--refs
	refs(ev, SpecID)
	-- Import SpellIDs from the cr
	if ev.ids then NeP.Spells:Add(ev.ids) end
	ev.ic.func = NeP.Compiler.Compile(ev.ic)
	ev.ooc.func = NeP.Compiler.Compile(ev.ooc)
	--Create user GUI
	if ev.gui then NeP.CR:AddGUI(ev) end
	-- Class Cr (gets added to all specs whitin that class)
	if classIndex == SpecID then
		SpecID = NeP.ClassTable:GetClassSpecs(classIndex)
		for i=1, #SpecID do
			ev.id = SpecID[i]
			add(ev)
		end
	-- normal add
	else
		add(ev)
	end
end

function NeP.CR:Set(Spec, Name)
	Spec = Spec or GetSpecializationInfo(GetSpecialization())
	Name = Name or NeP.Config:Read('SELECTED', Spec)
	--break if no sec or name
	if not Spec or not Name then return end
	--break if cr dosent exist
	if not (CRs[Spec] and CRs[Spec][Name]) then return end
	-- execute the previous unload
	if self.CurrentCR
	and self.CurrentCR.unload then
		self.CurrentCR.unload()
	end
	self.CurrentCR = CRs[Spec][Name]
	NeP.Config:Write('SELECTED', Spec, Name)
	NeP.Interface:ResetToggles()
	--Execute onload
	if self.CurrentCR then self.CurrentCR.load() end
end

function NeP.CR.GetList(_, Spec)
	return CRs[Spec] or {}
end

----------------------------EVENTS
NeP.Listener:Add("NeP_CR", "PLAYER_LOGIN", function()
	NeP.CR:Set()
end)
NeP.Listener:Add("NeP_CR", "PLAYER_SPECIALIZATION_CHANGED", function(unitID)
	if unitID ~= 'player' then return end
	NeP.CR:Set()
end)
