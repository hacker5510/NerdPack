local n_name, NeP = ...
NeP.Version = {
	major = 2,
	minor = 0000,
	branch = "DEV"
}
NeP.Media = 'Interface\\AddOns\\' .. n_name .. '\\Media\\'
NeP.Color = 'FFFFFF'
NeP.Paypal = 'https://www.paypal.me/JaimeMarques/25'
NeP.Patreon = 'https://www.patreon.com/mrthesoulz'
NeP.Discord = 'https://discord.gg/XtSZbjM'
NeP.Author = 'MrTheSoulz'

-- This exports stuff into global space
NeP.Globals = {}
_G.NeP = NeP.Globals

NeP.Cache = {}

function NeP.Wipe_Cache()
	for _, v in pairs(NeP.Cache) do
		_G.wipe(v)
	end
end
