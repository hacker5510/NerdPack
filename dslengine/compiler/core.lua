local _, NeP = ...

NeP.Compiler = {}
NeP.Compiler.Tokens = {}

local noop = function() end
local noopVal = function() return true end

local function ForEachUnit(eval)
	eval.targets = NeP.Unit:Filter(eval.targets)
	print(eval.spell, eval.targets, #eval.targets)
	for i=1, #eval.targets do
		local curUnit = eval.targets[i]
		eval.curUnit = curUnit
		if NeP.API:ValidUnit(curUnit)
		and eval.conditions() then
			eval.exeExtra()
			eval.exeFunc(eval.spell, curUnit, eval.spellArgs)
			return true
		end
	end
end

function NeP.Compiler.Compile(cr)
	local list = {}
  for i = #cr, 1, -1 do
    local cur = cr[i]
		print(i)
    local eval = NeP.Compiler.Spell(cur[1])
    eval.targets = NeP.Compiler.Target(cur[3], eval)
		eval.conditions = NeP.Compiler.Condition(cur[2], eval)
		eval.exeVal = eval.exeVal or noopVal
		eval.exeFunc = eval.exeFunc or noop
		eval.exeExtra = eval.exeExtra or noop
		list[#list+1] = function()
			return eval.exeVal(eval.spell)
			and ForEachUnit(eval)
		end
  end
  return function()
		for i=1, #list do
			print(i)
			if list[i]() then
				break
			end
		end
	end
end
