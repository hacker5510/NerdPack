local _, gbl = ...

gbl.Condition:Register("isself", function(target)
  return gbl.Condition:Get("is")(target, 'player')
end)

gbl.Condition:Register('furydiff', function(target)
  return gbl.Condition:Get("fury.diff")(target)
end)

gbl.Condition:Register('pull_timer', function()
  return gbl.Condition:Get('dbm')(nil, "Pull in")
end)
