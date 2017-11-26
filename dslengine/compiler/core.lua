local _, NeP = ...

NeP.Compiler = {}
NeP.Compiler.Tokens = {}

local noop = function() end
local noopVal = function() return true end

local function ForEachUnit(eval)
	local targets = NeP.Unit:Filter(eval.targets)
	for i=1, #targets do
		local curUnit = targets[i]
		eval.curUnit = curUnit
		if eval.isTable then
			return eval.conditions() and eval.exeFunc(eval.spell, curUnit, eval.spellArgs)
		elseif NeP.API:ValidUnit(curUnit)
		and eval.conditions() then
			NeP.ActionLog:Add(eval.token, eval.spell or "", eval.icon, curUnit)
			NeP.Interface:UpdateIcon('mastertoggle', eval.icon)
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
  for i = #cr, 1, -1 do
    cond = CompileFunc(cr[i], cond)
  end
  return cond
end
