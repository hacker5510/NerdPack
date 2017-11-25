local _, NeP = ...

NeP.Compiler = {}
NeP.Compiler.Tokens = {}

local noop = function() end
local noopVal = function() return true end

local function ForEachUnit(eval)
	for i=1, #eval.targets do
		local curUnit = eval.targets[i]
		eval.curUnit = NeP.Unit:Filter(curUnit)
		if NeP.API:ValidUnit(curUnit)
		and eval.conditions() then
			eval.exeExtra()
			eval.exeFunc(eval.spell, curUnit, eval.spellArgs)
			return true
		end
	end
end

function NeP.Compiler.Compile(cr)
  local finalFunc, originalFunc;
  for i = #cr, 1, -1 do
    local cur = cr[i]
    local eval = NeP.Compiler.Spell(cur[1])
    eval.targets = NeP.Compiler.target(cur[3])
		eval.conditions = NeP.Compiler.Condition(cur[2], eval)
		eval.exeVal = eval.exeVal or noopVal
		eval.exeFunc = eval.exeFunc or noop
    originalFunc = finalFunc or noop
    finalFunc = function()
			return eval.exeVal(eval.spell)
			and ForEachUnit(eval)
			or originalFunc()
		end
  end
  cr.master.exe = finalFunc
end
