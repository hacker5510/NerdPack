local n_name, gbl = ...

gbl.Config = {}
local Data = {}
local version = "0.2"

gbl.Listener:Add("gbl_Config", "ADDON_LOADED", function(addon)
	if addon:lower() == n_name:lower() then
		gblDATA = gblDATA or Data
		Data = gblDATA
		if Data["config_ver"] ~= version then wipe(Data) end
		Data["config_ver"] = version
	end
end)

function gbl.Config.Read(_, a, b, default, profile)
	profile = profile or "default"
	if Data[a] then
		if not Data[a][profile] then
			Data[a][profile] = {}
		end
		if Data[a][profile][b] == nil then
			Data[a][profile][b] = default
		end
	else
		Data[a] = {}
		Data[a][profile] = {}
		Data[a][profile][b] = default
	end
	return Data[a][profile][b]
end

function gbl.Config.Write(_, a, b, value, profile)
	profile = profile or "default"
	if not Data[a] then Data[a] = {} end
	if not Data[a][profile] then Data[a][profile] = {} end
	Data[a][profile][b] = value
end

function gbl.Config.Reset(_, a, b, profile)
	if profile then
		Data[a][profile] = nil
	elseif b then
		if Data[a][profile] then
			Data[a][profile][b] = nil
		end
	elseif a then
		Data[a] = nil
	end
end

function gbl.Config.Rest_all()
	wipe(Data)
end
