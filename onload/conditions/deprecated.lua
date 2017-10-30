local _, NeP = ...

NeP.Condition:Register("isself", function(target)
  return NeP.Condition:Get("is")(target, 'player')
end)

NeP.Condition:Register('furydiff', function(target)
  return NeP.Condition:Get("fury.diff")(target)
end)

NeP.Condition:Register('pull_timer', function()
  return NeP.Condition:Get('dbm')(nil, "Pull in")
end)
