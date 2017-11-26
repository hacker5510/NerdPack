local _, NeP = ...

local function GetPredictedHealth(unit)
	return UnitHealth(unit)+(UnitGetTotalHealAbsorbs(unit) or 0)+(UnitGetIncomingHeals(unit) or 0)
end

local function GetPredictedHealth_Percent(unit)
	return math.floor((NeP.Healing.GetPredictedHealth(unit)/UnitHealthMax(unit))*100)
end

local function healthPercent(unit)
	return math.floor((UnitHealth(unit)/UnitHealthMax(unit))*100)
end

NeP.Condition:Register("health", function(target)
	return healthPercent(target)
end)

NeP.Condition:Register("health.actual", function(target)
	return UnitHealth(target)
end)

NeP.Condition:Register("health.max", function(target)
	return UnitHealthMax(target)
end)

NeP.Condition:Register("health.predicted", function(target)
	return GetPredictedHealth_Percent(target)
end)

NeP.Condition:Register("health.predicted.actual", function(target)
	return GetPredictedHealth(target)
end)
