local _, gbl = ...
gbl.BossID = {}

--BossIDs Lib
gbl.BossID.table = LibStub("LibBossIDs-1.0").BossIDs
local T = gbl.BossID.table

function gbl.BossID:Add(...)
  if type(...) == "table" then
    for id in pairs(...) do
      id = tonumber(id)
      if id then
        T[id] = true
      end
    end
  else
    local id = tonumber(...)
    if id then
      T[id] = true
    end
  end
end

local function WoWBossID(unit)
  if not unit then return false end
  for i=1, 4 do
    if UnitIsUnit(unit, "boss"..i) then
      return true
    end
  end
end

local function UnitID(unit)
  if tonumber(unit) then
    return nil, tonumber(unit)
  else
    local unitid = select(6, strsplit("-", UnitGUID(unit)))
    return unit, tonumber(unitid)
  end
end

function gbl.BossID.Eval(_, unit)
  if not unit then return false end
  local unit2, unitid = UnitID(unit)
  return UnitExists(unit2) and WoWBossID(unit2) or T[unitid]
end

function gbl.BossID.Get()
  return T
end

gbl.BossID:Add({
  -- The Nighthold
  [102263] = true, -- Skorpyron
  [101002] = true, -- Krosus
  [104415] = true, -- Chronomatic Anomaly
  [104288] = true, -- Trilliax
  [103758] = true, -- Star Augur Etraeus
  [105503] = true, -- Gul"dan
  [110965] = true, -- Grand Magistrix Elisande
  [107699] = true, -- Spellblade Aluriel
  [104528] = true, -- High Botanist Tel"arn
  [103685] = true, -- Tichondrius
})
