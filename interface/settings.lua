local n_name, NeP = ...
local L = function(val) return NeP.Locale:TA('Settings', val) end
local K = n_name..'_Settings'
local NeP_ver = tostring(NeP.Version.major.."."..NeP.Version.minor.."-"..NeP.Version.branch)

function NeP.Interface:Update()
  NeP.ButtonsSize = NeP.Interface:Fetch(K, 'bsize', 40)
  NeP.ButtonsPadding = NeP.Interface:Fetch(K, 'bpad', 2)
  --NeP.OM.max_distance = NeP.Interface:Fetch(K, 'OM_Dis', 100)
  self:RefreshToggles()
end

local config = {
key = K,
title = n_name,
  subtitle = L('option'),
  width = 250,
  height = 270,
  config = {
		{ type = 'header', text = n_name, size = 24, align = 'Center'},
    { type = 'text', text = NeP_ver, size = 18, align = 'Center'},

    { type = 'spacer' },{ type = 'ruler' },{ type = 'spacer' },
    { type = 'header', text = L('UI_Settings') },
    { type = 'spinner', text = L('bsize'), key = 'bsize', min = NeP.min_width, default = 40},
		{ type = 'spinner', text = L('bpad'), key = 'bpad', default = 2},
    { type = 'spinner', text = L('brow'), key = 'brow', step = 1, min = 1, max = 20, default = 10},

    { type = 'spacer' },
    { type = 'header', text = L('OM_Settings') },
    { type = 'spinner', text = L('OM_Dis'), key = 'OM_Dis', step = 10, min = 40, max = 300, default = 100, desc = L("OM_Dis_desc")},

    { type = 'spacer' },
    { type = 'header', text = L('misc') },
		{ type = 'checkbox', text = 'Change talents while not resting', key = 'talents_exp', default = false },
    { type = 'checkbox', text = 'Auto accept LFG', key = 'LFG_acp', default = false },

    { type = 'spacer' },
    { type = 'header', text = L('userLike') },
		{ type = 'checkbox', text = 'Enable/Disable', key = 'userLike', default = false },
    { type = 'spinner', text = 'Minimum time off CD', key = 'minOffCD', step = .5, min = 0, max = 3, default = 1 },

    { type = 'spacer' },
		{ type = 'button', text = L('apply_bt'), callback = function() NeP.Interface:Update() end },

	}
}

NeP.STs = NeP.Interface:BuildGUI(config)
NeP.Interface:Add(n_name..' '..L('option'), function() NeP.STs.parent:Show() end)
NeP.STs.parent:Hide()

NeP.Core:WhenInGame(function()
  NeP.Interface:Update()
end)
