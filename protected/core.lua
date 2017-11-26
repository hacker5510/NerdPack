local n_name, gbl = ...
local L = function(val) return gbl.Locale:TA("Protected", val) end

gbl.Protected = {}
gbl.Protected.Unlocked = false
gbl.Protected.Unlockers = {}
gbl.Protected.Callbacks = {}

gbl.Protected.ValidGround = {
	["player"] = true,
	["cursor"] = true
}

gbl.Listener:Add(n_name, "ADDON_ACTION_FORBIDDEN", function(...)
	local addon = ...
	if addon == n_name then
		StaticPopup1:Hide()
	end
end)

function gbl.Protected.omVal(Obj)
	return UnitInPhase(Obj)
	and gbl.Protected.Distance("player", Obj) < 100
	and gbl.Protected.LineOfSight("player", Obj)
end

local Count = 0

function gbl.Protected:AddUnlocker(Unlocker)
	table.insert(self.Unlockers, Unlocker)
	Unlocker.Prio = Count
	table.sort(self.Unlockers, function(a,b) return a.Prio < b.Prio end)
	Count = Count + 1
end

function gbl.Protected:AddCallBack(func)
	if not func() then
		table.insert(self.Callbacks, func)
	end
end

function gbl.Protected:LoadCallbacks()
	for i=1, #self.Callbacks do
		local cur = self.Callbacks[i]
		if cur and cur() then
			self.Callbacks[i] = nil
		end
	end
end

function gbl.Protected:SetUnlocker(Unlocker)
	gbl.Core.Print("|cffff0000"..L("found")..":|r " .. Unlocker.Name)
	for name, func in pairs(Unlocker) do
			self[name] = func
	end
	self.Load()
	self:LoadCallbacks()
end

function gbl.Protected:FindUnlocker()
	for i=1, #self.Unlockers do
		local Unlocker = self.Unlockers[i]
		if Unlocker.Test() then
			gbl.Unlocked = nil
			self:SetUnlocker(Unlocker)
		end
	 end
end

local function Find() gbl.Protected:FindUnlocker() end

-- Delay until everything is ready
gbl.Core.WhenInGame(function()
	gbl.Interface:Add(L("find"), Find)
	C_Timer.After(1, Find)
end)
