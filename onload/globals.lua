local _, gbl = ...
local g = gbl.Globals

--[[----------------
	This is where we assign whats Globaly usable
------------------]]

g.Actions = gbl.Actions
g.RegisterCommand = gbl.Commands.Register
g.Core = gbl.Core
g.Unit = gbl.Unit
g.Listener = gbl.Listener
g.Tooltip = gbl.Tooltip
g.Protected = gbl.Protected
g.Artifact = gbl.Artifact
g.DBM = gbl.DBM
g.ClassTable = gbl.ClassTable
g.Spells = gbl.Spells
g.API = gbl.API
g.LuaEngine = gbl.LuaEngine

g.Condition = {
	Get = gbl.Condition.Get,
	Exists = gbl.Condition.Exists,
	Register = gbl.Condition.Register,
}
g.CR = {
	Add = gbl.CR.Add,
	GetList = gbl.CR.GetList
}
g.Debug = {
	Add =  gbl.Debug.Add
}
g.DSL = {
	Register = gbl.DSL.Register,
	Parse = gbl.DSL.Parse
}
g.Library = {
	Add = gbl.Library.Add,
	Fetch = gbl.Library.Fetch,
	Parse = gbl.Library.Parse
}
g.Interface = {
	BuildGUI = gbl.Interface.BuildGUI,
	Fetch = gbl.Interface.Fetch,
	GetElement = gbl.Interface.GetElement,
	Add = gbl.Interface.Add,
	toggleToggle = gbl.Interface.toggleToggle,
	AddToggle = gbl.Interface.AddToggle,
	Alert = gbl.Interface.Alert,
	Splash = gbl.Interface.Splash
}
g.ActionLog = {
	Add = gbl.ActionLog.Add,
}
g.AddsID = {
  Add = gbl.AddsID.Add,
  Eval = gbl.AddsID.Eval,
  Get = gbl.AddsID.Get
}
g.Debuffs = {
  Add = gbl.Debuffs.Add,
  Eval = gbl.Debuffs.Eval,
  Get = gbl.Debuffs.Get
}
g.BossID = {
  Add = gbl.BossID.Add,
  Eval = gbl.BossID.Eval,
  Get = gbl.BossID.Get
}
g.ByPassMounts = {
  Add = gbl.ByPassMounts.Add,
  Eval = gbl.ByPassMounts.Eval,
  Get = gbl.ByPassMounts.Get
}
g.Taunts = {
  Add = gbl.Taunts.Add,
  ShouldTaunt = gbl.Taunts.ShouldTaunt,
  Get = gbl.Taunts.Get
}
