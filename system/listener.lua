local _, gbl = ...
local onEvent = onEvent
local CreateFrame = CreateFrame
gbl.Listener = {}
local listeners = {}

local frame = CreateFrame('Frame', 'gbl_Events')
frame:SetScript('OnEvent', function(_, event, ...)
	if not listeners[event] then return end
	for k in pairs(listeners[event]) do
		listeners[event][k](...)
	end
end)

function gbl.Listener.Add(_, name, event, callback)
	if not listeners[event] then
		frame:RegisterEvent(event)
		listeners[event] = {}
	end
	listeners[event][name] = callback
end

function gbl.Listener.Remove(_, name, event)
	if listeners[event] then
		listeners[event][name] = nil
	end
end

function gbl.Listener.Trigger(_, event, ...)
	onEvent(nil, event, ...)
end
