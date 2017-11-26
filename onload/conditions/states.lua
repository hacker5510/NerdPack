local _, gbl = ...
local LibDispellable = LibStub("LibDispellable-1.0")
local tlp = gbl.Tooltip

gbl.Condition.Register("state.purge", function(target, spell)
  spell = gbl.Core.GetSpellID(spell)
  return LibDispellable:CanDispelWith(target, spell)
end)

gbl.Condition.Register("state", function(target, arg)
  local match = gbl.Locale:TA("States", tostring(arg))
  return match and tlp:Scan_Debuff(target, match)
end)

gbl.Condition.Register("immune", function(target, arg)
  local match = gbl.Locale:TA("Immune", tostring(arg))
  return match and tlp:Scan_Buff(target, match)
end)
