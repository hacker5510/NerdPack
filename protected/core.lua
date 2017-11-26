local n_name, NeP = ...

NeP.Protected = {}
NeP.Protected.Unlocked = false
NeP.Protected.Unlockers = {}
NeP.Protected.Callbacks = {}

NeP.Protected.ValidGround = {
	["player"] = true,
	["cursor"] = true
}

NeP.Listener:Add(n_name, "ADDON_ACTION_FORBIDDEN", function(...)
	local addon = ...
	if addon == n_name then
		StaticPopup1:Hide()
	end
end)

function NeP.Protected.omVal(Obj)
	return UnitInPhase(Obj)
	and NeP.Protected.Distance('player', Obj) < 100
	and NeP.Protected.LineOfSight('player', Obj)
end

local Count = 0

function NeP.Protected:AddUnlocker(Unlocker)
	table.insert(self.Unlockers, Unlocker)
	Unlocker.Prio = Count
	table.sort(self.Unlockers, function(a,b) return a.Prio < b.Prio end)
	Count = Count + 1
end

function NeP.Protected:AddCallBack(func)
	if not func() then
		table.insert(self.Callbacks, func)
	end
end

function NeP.Protected:LoadCallbacks()
	for i=1, #self.Callbacks do
		local cur = self.Callbacks[i]
		if cur and cur() then
			self.Callbacks[i] = nil
		end
	end
end

function NeP.Protected:SetUnlocker(Unlocker)
	NeP.Core:Print('|cffff0000Found:|r ' .. Unlocker.Name)
	for name, func in pairs(Unlocker) do
			self[name] = func
	end
	self.Load()
	self:LoadCallbacks()
end

function NeP.Protected:FindUnlocker()
	for i=1, #self.Unlockers do
		local Unlocker = self.Unlockers[i]
		if Unlocker.Test() then
			NeP.Unlocked = nil
			self:SetUnlocker(Unlocker)
		end
	 end
end

local function Find() NeP.Protected:FindUnlocker() end

-- Delay until everything is ready
NeP.Core:WhenInGame(function()
	NeP.Interface:Add("Find Unlocker", Find)
	C_Timer.After(1, Find)
end)
