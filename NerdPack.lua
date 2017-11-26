local n_name, gbl = ...
gbl.Version = {
	major = 2,
	minor = 0000,
	branch = "DEV"
}
gbl.Media = "Interface\\AddOns\\" .. n_name .. "\\Media\\"
gbl.Color = "FFFFFF"
gbl.Paypal = "https://www.paypal.me/JaimeMarques/25"
gbl.Patreon = "https://www.patreon.com/mrthesoulz"
gbl.Discord = "https://discord.gg/XtSZbjM"
gbl.Author = "MrTheSoulz"

-- This exports stuff into global space
gbl.Globals = {}
_G[n_name] = gbl.Globals

gbl.Cache = {}

function gbl.Wipe_Cache()
	for _, v in pairs(gbl.Cache) do
		wipe(v)
	end
end
