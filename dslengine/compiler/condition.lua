local _, NeP = ...

-- public func (main)
-- return a function ready for usage
-- TODO: compile the condition instead of doing it in runtime
NeP.Compiler.Condition = function(cond, eval)
  return NeP.DSL.Parse(cond, eval.spell, eval.curUnit)
end
