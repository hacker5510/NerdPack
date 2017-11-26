local _, gbl = ...
gbl.Protected.Generic = {}
local Generic = gbl.Protected.Generic
Generic.Name = "Generic"

Generic.Test = function()
	pcall(RunMacroText, '/run UnlockedTest = true')
	local bool = UnlockedTest
	UnlockedTest = nil
	return bool
end

Generic.Load = function()
end

Generic.Cast = function(spell, target)
	CastSpellByName(spell, target)
end

Generic.CastGround = function(spell, target)
	if not gbl.Protected.ValidGround[target] then
		target = "cursor"
	end
	Generic.Macro("/cast [@"..target.."]"..spell)
end

Generic.Macro = function(text)
	RunMacroText(text)
end

Generic.UseItem = function(name, target)
	UseItemByName(name, target)
end

Generic.UseInvItem = function(name)
	UseInventoryItem(name)
end

Generic.TargetUnit = function(target)
	TargetUnit(target)
end

Generic.SpellStopCasting = function()
	SpellStopCasting()
end

gbl.Protected:AddUnlocker(Generic)
