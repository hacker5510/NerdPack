local _, gbl = ...
gbl.DBM = {}

--dont load if DBM is not installed
function gbl.DBM.BuildTimers()end
if not DBM then return end

gbl.Cache.DBM_Timers = {}
local fake_timer = 999

function gbl.DBM.BuildTimers()
  for bar in pairs(DBM.Bars.bars) do
      local id = GetSpellInfo(bar.id:match("%d+")) or bar.id:lower()
      gbl.Cache.DBM_Timers[id] = bar.timer and bar.timer
  end
end

gbl.Condition:Register("dbm", function(_, event)
  return gbl.Cache.DBM_Timers[event:lower()] or fake_timer
end)
