assert(FatCooldowns, "FatCooldowns not found!")

local mod = FatCooldowns:NewModule("AltDungeon", nil, "AceComm-3.0", "AceEvent-3.0", "AceConsole-3.0", "SheklesLibBars-1.0", "AceTimer-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("FatCooldowns")

function FatCooldowns:UI_INFO_MESSAGE(event,msg) 
	if FatCooldowns:GetModule("Display").db.profile.AltTab and FatCooldowns:GetModule("Display").db.profile.BGAltTab and msg:find(L["Your group has joined the queue for Random Battleground"]) then self:SetSound() end
end

function FatCooldowns:UPDATE_BATTLEFIELD_STATUS()
	if FatCooldowns:GetModule("Display").db.profile.AltTab ~= nil and FatCooldowns:GetModule("Display").db.profile.AltTab and FatCooldowns:GetModule("Display").db.profile.BGAltTab ~= nil and FatCooldowns:GetModule("Display").db.profile.BGAltTab then
		for i = 1, MAX_BATTLEFIELD_QUEUES do
			local status, mapName, instanceID = GetBattlefieldStatus(i)
			if status == L["confirm"] then	self:AltTabPlaySound() break end
		end
	end
end

function FatCooldowns:CHAT_MSG_SYSTEM(event,msg)  
	if FatCooldowns:GetModule("Display").db.profile.AltTab and FatCooldowns:GetModule("Display").db.profile.RDFAltTab and msg:find(L["You are now queued in the Dungeon Finder"]) then
		self:ScheduleTimer(function() self:SetSound() end, 0.1)
	elseif FatCooldowns:GetModule("Display").db.profile.AltTab and FatCooldowns:GetModule("Display").db.profile.RDFAltTab and msg:find(L["You are no longer queued in the Dungeon Finder"]) then
		self:ScheduleTimer(function() self:ResetSound() end, 0.1)
	elseif FatCooldowns:GetModule("Display").db.profile.AltTab and FatCooldowns:GetModule("Display").db.profile.RDFAltTab and msg:find(L["Someone has declined the dungeon invite. You have been returned to the front of the dungeon queue"]) then
		self:SetSound()
	end
end

function FatCooldowns:SetSound(force)
	if not FatCooldowns:GetModule("Display").db.profile.AltTab or UnitAffectingCombat("player") or HasLFGRestrictions() then return end
	if force then
	local inParty, joined, queued, noPartialClear, achievements, lfgComment, slotCount = GetLFGInfoServer()
		if queued and slotCount ~= 0 then
			local hasData, leaderNeeds, tankNeeds, healerNeeds, dpsNeeds, totalTanks, totalHealers, totalDPS, instanceType, instanceSubType, instanceName, averageWait, tankWait, healerWait, damageWait, myWait, queuedTime = GetLFGQueueStats()
			if hasData == nil then
				self:ScheduleTimer(function() FatCooldowns:SetSound() FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Setting Sound, Dont Alt Tab untill its set")  end, 2)
			end
		end
	end
	local _, zone4 = IsInInstance()
	local name, type2 = GetInstanceInfo()
	if zone4 == "party" or type2 == "party" then return end
	SetCVar("Sound_EnableAllSound","0")
	SetCVar("Sound_EnableSoundWhenGameIsInBG", "1")
end

function FatCooldowns:ResetSound(force)
	if not FatCooldowns:GetModule("Display").db.profile.AltTab then return end
	if PlayingSound then self:ScheduleTimer(function() self:ResetSound() end, 5) return end
	local hasData = GetLFGQueueStats()
	if hasData and force ~= nil then return end
	local TempBG, TempSound, TempSFX = "1", "1", "1"
	if FatCooldowns:GetModule("Display").db.profile.BGSound then TempBG = "1" else TempBG = "0" end
	if FatCooldowns:GetModule("Display").db.profile.SoundEnabled then TempSound = "1" else TempSound = "0" end
	if FatCooldowns:GetModule("Display").db.profile.SFXSound then TempSFX = "1" else TempSFX = "0" end
	SetCVar("Sound_MasterVolume", (FatCooldowns:GetModule("Display").db.profile.MasterVolSetting / 100))
	SetCVar("Sound_EnableSoundWhenGameIsInBG", TempBG)
	SetCVar("Sound_EnableAllSound", TempSound)
	SetCVar("Sound_EnableSFX", TempSFX)
end

function FatCooldowns:AltTabPlaySound(Finished)
	if not FatCooldowns:GetModule("Display").db.profile.AltTab then return end
	SetCVar("Sound_EnableSFX","0")
	SetCVar("Sound_EnableAllSound","1")
	if FatCooldowns:GetModule("Display").db.profile.DoublePlay and Finished == nil then self:ScheduleTimer(function() self:AltTabPlaySound("true") end, 3) end
	if FatCooldowns:GetModule("Display").db.profile.ChangeMSound then SetCVar("Sound_MasterVolume", (FatCooldowns:GetModule("Display").db.profile.MaxSound / 100)) end
	PlaySoundFile(FatCooldowns.FCDSounds[FatCooldowns:GetModule("Display").db.profile.AltTabSound], "Master",false)
	PlayingSound = true
	self:ScheduleTimer(function() PlayingSound = false end, 2)
	if not FatCooldowns:GetModule("Display").db.profile.DoublePlay then self:ScheduleTimer(function() self:ResetSound() end, 4)
	elseif FatCooldowns:GetModule("Display").db.profile.DoublePlay and Finished ~= nil then self:ScheduleTimer(function() self:ResetSound() end, 4)
	end
end

local function HookDungeonReadyDialog()
    local dialog = _G["LFDDungeonReadyDialog"]
    if dialog then
        dialog:HookScript("OnShow", function()
            FatCooldowns:AltTabPlaySound()
        end)
        dialog:HookScript("OnHide", function()
            FatCooldowns:SetSound(true)
        end)
        return true
    end
    return false
end

local function WaitForDialog()
    if not HookDungeonReadyDialog() then
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:SetScript("OnEvent", function(self, event)
            if event == "PLAYER_ENTERING_WORLD" then
                if HookDungeonReadyDialog() then
                    self:SetScript("OnEvent", nil)
                end
            end
        end)
    end
end
WaitForDialog()
