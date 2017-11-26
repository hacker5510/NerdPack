local _, gbl = ...

local PE = {}
PE.toggle = {}
PE.rotation = {}

local function Condition(cond, name)
	local str = "{"
	for k=1, #cond do
		local tmp = cond[k]
		local xtype = type(tmp)
		--string
		if xtype == "string" then
			if tmp:lower() == "or" then
				str = str .. "||" .. tmp
			elseif k ~= 1 then
				str = str .. "&" .. tmp
			else
				str = str .. tmp
			end
		-- Others
		else
			str = str .. "&" .. cond_types[xtype](tmp)
		end
	end
	return cond_types["string"](str.."}", name)
end

--wrapper for toggles
PE.toggle.create = function(key, icon, name, tooltip)
	gbl.Interface:AddToggle({
		key = key,
		name = name,
		text = tooltip,
		icon = icon,
	})
end

--wrapper for CR Add
PE.rotation.register_custom = function(id, name, incombat, outcombat, callback)
	gbl.CR.Add(id, {
		name = name,
		ic = incombat,
		ooc = outcombat,
		load = callback
	})
end

ProbablyEngine = PE
