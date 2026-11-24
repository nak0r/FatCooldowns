assert(FatCooldowns, "FatCooldowns not found!")
if (select(2, UnitClass("player"))) ~= "ROGUE" then return end

local mod = FatCooldowns:NewModule("Rogue", FatCooldowns.ModuleBase, "AceConsole-3.0", "AceEvent-3.0")
mod.cooldowns = FatCooldowns.cooldowns["ROGUE"]