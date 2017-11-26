local _, gbl = ...
local _G = _G

local KEYBINDS = {
  -- Shift
  ['shift']    = function() return IsShiftKeyDown() end,
  ['lshift']   = function() return IsLeftShiftKeyDown() end,
  ['rshift']   = function() return IsRightShiftKeyDown() end,
  -- Control
  ['control']  = function() return IsControlKeyDown() end,
  ['lcontrol'] = function() return IsLeftControlKeyDown() end,
  ['rcontrol'] = function() return IsRightControlKeyDown() end,
  -- Alt
  ['alt']      = function() return IsAltKeyDown() end,
  ['lalt']     = function() return IsLeftAltKeyDown() end,
  ['ralt']     = function() return IsRightAltKeyDown() end,
}

gbl.Condition:Register("keybind", function(_, Arg)
  Arg = Arg:lower()
  return KEYBINDS[Arg] and KEYBINDS[Arg]() and not GetCurrentKeyBoardFocus()
end)

gbl.Condition:Register("mouse", function(_, Arg)
  Arg = tonumber(Arg:lower())
  return IsMouseButtonDown(Arg) and not GetCurrentKeyBoardFocus()
end)
