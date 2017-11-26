local _, NeP = ...

NeP.Condition:Register("glyph", function(_,spell)
  local spellId = tonumber(spell)
  local glyphName, glyphId
  for i = 1, 6 do
    glyphId = select(4, GetGlyphSocketInfo(i))
    if glyphId then
      if spellId then
        if select(4, GetGlyphSocketInfo(i)) == spellId then
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
