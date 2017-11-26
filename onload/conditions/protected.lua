local _, gbl = ...

gbl.Condition.Register("advanced", function()
	return HackEnabled ~= nil
end)

gbl.Condition.Register("ishackenabled", function(_, hack)
	return HackEnabled and HackEnabled(hack)
end)
