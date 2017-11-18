local _, NeP = ...

NeP.Compiler = {}
NeP.Compiler.Tokens = {}

-- DO NOT USE THIS UNLESS YOU KNOW WHAT YOUR DOING!
function NeP.Compiler.RegisterToken(_, token, func)
	NeP.Compiler.Tokens[token] = func
end
