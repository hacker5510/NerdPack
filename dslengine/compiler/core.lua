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

function NeP.Compiler.Compile(cr)
	local list = {}
  for i = 1, #cr do
    local cur = cr[i]
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
		print(">>> ")
		for i=1, #list do
			print(i, "------------")
			if list[i]() then
				return true
			end
		end
		print("<<< ")
	end
end
