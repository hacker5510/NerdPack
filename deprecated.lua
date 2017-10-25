local _, NeP = ...

NeP.Globals.OM.GetRoster = function() return NeP.OM:Get("Roster") end

NeP.DSL:Register("glyph", function(_,spell)
  local spellId = tonumber(spell)
  local glyphName, glyphId
  for i = 1, 6 do
    glyphId = select(4, _G.GetGlyphSocketInfo(i))
    if glyphId then
      if spellId then
        if select(4, _G.GetGlyphSocketInfo(i)) == spellId then
          return true
        end
      else
        glyphName = NeP.Core:GetSpellName(glyphId)
        if glyphName:find(spell) then
          return true
        end
      end
    end
  end
  return false
end)

local LibDisp = _G.LibStub('LibDispellable-1.0')

local function FindDispell(eval, unit)
  if not _G.UnitExists(unit) then return end
  for _, spellID, _,_,_,_,_, duration, expires in LibDisp:IterateDispellableAuras(unit) do
    local spell = GetSpellInfo(spellID)
    if IsSpellReady(spell)
    and (expires - eval.master.time) < (duration - math.random(1, 3)) then
      eval.spell = spell
      eval[3].target = unit
      eval.exe = funcs["Cast"]
      return true
    end
  end
end
-- DispelSelf
NeP.Actions:Add('dispelself', function(eval)
  return FindDispell(eval, 'player')
end)

-- Dispell all
NeP.Actions:Add('dispelall', function(eval)
  for _, Obj in pairs(NeP.OM:Get('Roster')) do
    if FindDispell(eval, Obj.key) then return true; end
  end
end)
