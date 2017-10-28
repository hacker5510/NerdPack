local _, NeP = ...

local function GetPredictedHealth(unit)
	return _G.UnitHealth(unit)+(_G.UnitGetTotalHealAbsorbs(unit) or 0)+(_G.UnitGetIncomingHeals(unit) or 0)
end

local function GetPredictedHealth_Percent(unit)
	return math.floor((NeP.Healing.GetPredictedHealth(unit)/_G.UnitHealthMax(unit))*100)
end

local function healthPercent(unit)
	return math.floor((_G.UnitHealth(unit)/_G.UnitHealthMax(unit))*100)
end

NeP.Condition:Register("health", function(target)
	return healthPercent(target)
end)

NeP.Condition:Register("health.actual", function(target)
	return _G.UnitHealth(target)
end)

NeP.Condition:Register("health.max", function(target)
	return _G.UnitHealthMax(target)
end)

NeP.Condition:Register("health.predicted", function(target)
	return GetPredictedHealth_Percent(target)
end)

NeP.Condition:Register("health.predicted.actual", function(target)
	return GetPredictedHealth(target)
end)
