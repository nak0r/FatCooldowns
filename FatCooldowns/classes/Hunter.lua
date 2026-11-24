assert(FatCooldowns, "FatCooldowns not found!")
if (select(2, UnitClass("player"))) ~= "HUNTER" then return end

local mod = FatCooldowns:NewModule("Hunter", FatCooldowns.ModuleBase, "AceConsole-3.0", "AceEvent-3.0")
mod.cooldowns = FatCooldowns.cooldowns["HUNTER"]