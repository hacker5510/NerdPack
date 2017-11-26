local _, gbl = ...
gbl.ByPassMounts = {}
gbl.ByPassMounts.table = {}
local T = gbl.ByPassMounts.table

function gbl.ByPassMounts:Eval(ID)
	for i=1, #T do
		if tonumber(ID) == T[i] then
			return true
		end
	end
end

function gbl.ByPassMounts:Add(ID)
	if type(ID) == 'table' then
		for i=1, #ID do
			self:Add(ID[i])
		end
	else
		table.insert(T, ID)
	end
end

function gbl.ByPassMounts:Get()
	return T
end

gbl.ByPassMounts:Add({
	165803, --telaari-talbuk
	164222, --frostwolf-war-wolf
	221883, --divine-steed
	221887, --divine-steed
	221673, --storms-reach-worg
	221595, --storms-reach-cliffwalker
	221672, --storms-reach-greatstag
	221671, --storms-reach-warbear
	221886 -- Divine Steed
})
