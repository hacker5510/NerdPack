local _, NeP = ...

NeP.Compiler = {}
NeP.Compiler.Tokens = {}

local noop = function() end
local noopVal = function() return true end

local function CompileFunc(original, eval)
  if original() then return end
  eval.exeVal = eval.exeVal or noopVal
  if eval.exeVal() then
  end
end

function NeP.Compiler.Compile(cr)
  local finalFunc, originalFunc;
  for i = #cr, 1, -1 do
    local cur = cr[i]
    local eval = {}
    eval.exeVal, eval.exeFunc = NeP.Compiler.Spell(cur[1])
    eval.condition = NeP.Compiler.Condition(cur[2])
    eval.target = NeP.Compiler.target(cur[3])
    originalFunc = finalFunc or noop
    finalFunc = CompileFunc(originalFunc, eval)
  end
  cr.exe = finalFunc
end
