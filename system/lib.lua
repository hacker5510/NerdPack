local _, gbl = ...
local strsplit = strsplit
gbl.Library = {}
gbl.Library.Libs = {}
local libs = gbl.Library.Libs

function gbl.Library.Add(name, lib)
	if not libs[name] then
		libs[name] = lib
	end
end

function gbl.Library.Fetch(strg)
	local a, b = strsplit(".", strg, 2)
	return libs[a][b]
end

function gbl.Library.Parse(strg, ...)
	local lib = gbl.Library.Fetch(strg)
	return lib(...)
end
