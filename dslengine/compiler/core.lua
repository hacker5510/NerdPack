local _, NeP = ...

NeP.Compiler = {}
NeP.Compiler.Tokens = {}

local noop = function() end
local noopVal = function() return true end

local function ForEachUnit(eval)
	if not eval.isTable then
		print("SPELL:",eval.spell)
	end
	eval.targets = NeP.Unit:Filter(eval.targets)
	for i=1, #eval.targets do
		local curUnit = eval.targets[i]
		eval.curUnit = curUnit
		print("UNIT:", #eval.targets, curUnit)
		--print("CONDITION:", eval.conditions())
		if NeP.API:ValidUnit(curUnit)
		and eval.conditions() then
			if not eval.isTable then
				print("BREAK:", eval.spell)
			end
			eval.exeExtra()
			return eval.exeFunc(eval.spell, curUnit, eval.spellArgs)
		end
	end
end

local function CompileFunc(cur, cond)
	local eval = NeP.Compiler.Spell(cur[1])
	eval.targets = NeP.Compiler.Target(cur[3], eval)
	eval.conditions = NeP.Compiler.Condition(cur[2], eval)
	eval.exeVal = eval.exeVal or noopVal
	eval.exeFunc = eval.exeFunc or noop
	eval.exeExtra = eval.exeExtra or noop
	return function()
		return eval.exeVal(eval.spell)
		and ForEachUnit(eval)
		or cond()
	end
end

function NeP.Compiler.Compile(cr)
	local cond = noop
  for i = 1, #cr do
    cond = CompileFunc(cr[i], cond)
  end
  return cond
end
