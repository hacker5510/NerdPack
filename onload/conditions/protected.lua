local _, NeP = ...

NeP.Condition:Register("advanced", function()
	return HackEnabled ~= nil
end)

NeP.Condition:Register("ishackenabled", function(_, hack)
	return HackEnabled and HackEnabled(hack)
end)
