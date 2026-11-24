assert(FatCooldowns, "FatCooldowns not found!")
if (select(2, UnitClass("player"))) ~= "SHAMAN" then return end

local mod = FatCooldowns:NewModule("Shaman", FatCooldowns.ModuleBase, "AceConsole-3.0", "AceEvent-3.0", "AceBucket-3.0")
mod.cooldowns = FatCooldowns.cooldowns["SHAMAN"]