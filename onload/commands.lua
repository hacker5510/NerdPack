local n_name, gbl = ...

gbl.Commands:Register(n_name, nil, n_name)

gbl.Commands:Add(n_name, "mastertoggle", function(rest)
	gbl.Interface:toggleToggle("MasterToggle", rest == "on")
end)

gbl.Commands:Add(n_name, "aoe", function(rest)
	gbl.Interface:toggleToggle("AoE", rest == "on")
end)

gbl.Commands:Add(n_name, "cooldowns", function(rest)
	gbl.Interface:toggleToggle("Cooldowns", rest == "on")
end)

gbl.Commands:Add(n_name, "interrupts", function(rest)
	gbl.Interface:toggleToggle("Interrupts", rest == "on")
end)

gbl.Commands:Add(n_name, "version", function() gbl.Core.Print(gbl.Version) end)
gbl.Commands:Add(n_name, "show", function() gbl.Interface.MainFrame:Show() end)
gbl.Commands:Add(n_name, "hide", function() gbl.Interface.MainFrame:Hide() end)
gbl.Commands:Add(n_name, "al", function() gbl.ActionLog.Frame:Show() end)
