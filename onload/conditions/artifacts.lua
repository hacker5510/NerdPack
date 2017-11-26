local _, gbl = ...
local LAD = LibStub("LibArtifactData-1.0")
--[[
					ARTIFACT CONDITIONS!
			Only submit ARTIFACT specific conditions here.
					KEEP ORGANIZED AND CLEAN!

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
]]
gbl.Artifact = {}

function gbl.Artifact.Update()
    LAD.ForceUpdate()
end

function gbl.Artifact.Traits(_, artifactID)
    artifactID = LAD.GetArtifactTraits(artifactID)
    return LAD.GetArtifactTraits(artifactID)
end

function gbl.Artifact:TraitInfo(spell)
  local artifactID = gbl.Condition.Get("artifact.active_id")()
  if not artifactID then self:Update() end
  local _, traits = self:Traits(artifactID)
  if not traits then return end
  for _,v in ipairs(traits) do
    if v.name == spell then
      return v.isGold,v.bonusRanks,v.maxRank,v.traitID,v.isStart,v.icon,v.isFinal,v.name,v.currentRank,v.spellID
    end
  end
end

gbl.Condition.Register("artifact.acquired_power", function(artifactID)
  return LAD.GetAcquiredArtifactPower(artifactID)
end)

gbl.Condition.Register("artifact.active_id", function()
  return LAD.GetActiveArtifactID()
end)

gbl.Condition.Register("artifact.knowledge", function()
  return select(1,LAD.GetArtifactKnowledge())
end)

gbl.Condition.Register("artifact.power", function(artifactID)
  return select(3,LAD.GetArtifactPower(artifactID))
end)

gbl.Condition.Register("artifact.relics", function(artifactID)
  return LAD.GetArtifactRelics(artifactID)
end)

gbl.Condition.Register("artifact.num_obtained", function()
  return LAD.GetNumObtainedArtifacts()
end)

gbl.Condition.Register("artifact.enabled", function(_, spell)
    return not not select(10,gbl.Artifact:TraitInfo(spell))
end)
