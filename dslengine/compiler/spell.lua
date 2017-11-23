local _, NeP = ...

local s_types = {}
local s_tokens = {}

-- this is the regual spell path
-- has to validate the spell, if its ready, etc...
local function regularSpell(eval)
  -- TODO
end

-- Macro
-- has no real sanity checks... its up to the dev
s_tokens["/"] = function(eval)
  eval.exe = NeP.Protected["Macro"]
end

-- Library
-- has no real sanity checks... its up to the dev
s_tokens["@"] = function(eval)
  eval.exe = function(...) return NeP.Library:Parse(...) end
end

-- usual string spell
-- compile it into a function
s_types["string"] = function(spell)
  local eval = {}
  eval.spell = spell
  -- find tokens
  local nextToken = eval.spell:sub(1,1)
  while(s_tokens[nextToken]) do
    s_tokens[nextToken](eval)
    eval.spell = eval.spell:sub(2)
    nextToken = eval.spell:sub(1,1)
  end
  -- if it has no function then its a regular Spell
  if not eval.exe then
    regularSpell(eval)
  end
  return eval.func, eval.exe
end

-- function type Spell
-- just return whatever it gives
s_types["function"] = function(spell)
  return nil, spell
end

-- nest (recursive)
-- compile into a function
s_types["table"] = function(spell)
  return nil, NeP.Compiler.Compile(spell)
end

-- nil
-- this is a cr author error... lets fix it!
s_types["nil"] = function()
  return function() return false end
end

-- public func (main)
-- return a function ready for usage
function NeP.Compiler.Spell(spell)
  return s_types[type(spell)]
end
