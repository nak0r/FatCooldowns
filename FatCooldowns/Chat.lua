assert(FatCooldowns, "FatCooldowns not found!")

local mod = FatCooldowns:NewModule("Chat", nil, "AceComm-3.0", "AceEvent-3.0", "AceConsole-3.0", "SheklesLibBars-1.0", "AceTimer-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("FatCooldowns")


local function FCDGroupPlayerFound(msg)
	local members = 0
	if UnitInRaid("player") then
		members = GetNumRaidMembers()
	else
		members = GetNumPartyMembers() + 1
	end
	local matchedPlayers = {}
	for i = 1, members do
		local ScanName
		if UnitInRaid("player") then
			ScanName = UnitName("raid" .. i)
		elseif not UnitInRaid("player") and i <= GetNumPartyMembers() then
			ScanName = UnitName("party" .. i)
		else
			ScanName = UnitName("player")
		end
		if ScanName and ScanName ~= "Unknown" then
			local lowerScanName = string.lower(ScanName)
			if string.find(string.lower(msg), lowerScanName, 1, true) and
			   string.find(string.lower(LowerMessage), lowerScanName, 1, true) then
				table.insert(matchedPlayers, ScanName)
			end
		end
	end
	local replacementIndex = 1
	msg = string.gsub(msg, "FCDGroupPlayer", function()
		local replacementName = matchedPlayers[replacementIndex]
		replacementIndex = replacementIndex + 1
		return replacementName or "FCDGroupPlayer"
	end)
	return msg 
end

local function SafeLower(str)
	if not str then return str end
	local result = ""
	local lastEnd = 1
	local pattern = "|H.-|h"
	while true do
		local startIdx, endIdx = str:find(pattern, lastEnd)
		if not startIdx then
			result = result .. str:sub(lastEnd):lower()
			break
		end
		result = result .. str:sub(lastEnd, startIdx - 1):lower()
		result = result .. str:sub(startIdx, endIdx)
		lastEnd = endIdx + 1
	end
	return result
end

local UIETime = {}
local Error_OnEvent = UIErrorsFrame:GetScript('OnEvent')
UIErrorsFrame:SetScript('OnEvent', function(self, event, msg, author,...)
	if event == "UI_INFO_MESSAGE" then return Error_OnEvent(self, event, msg, author, ...) end
	if not FatCooldowns:GetModule("Display").db.profile.UIEEnable or (FatCooldowns:GetModule("Display").db.profile.UIECombat and UnitAffectingCombat("player")) then return Error_OnEvent(self, event, msg, author, ...) end
	if not FatCooldowns:GetModule("Display").db.profile.UIETable[msg] and
		not msg:lower():find("^missing reagent.+") and
		not msg:lower():find("^requires.+") and 
		not msg:lower():find("^you must wait.+before speaking again") and
		not msg:lower():find("^you must reach level.+ to use that item") and
		not msg:lower():find("^that player can not be kicked for another")
		then
			FatCooldowns:GetModule("Display").db.profile.UIETable[msg] = msg 
	end
	if FatCooldowns:GetModule("Display").db.profile.UIEDisable[msg] or FatCooldowns:GetModule("Display").db.profile.UIEAll then
		return 
	elseif FatCooldowns:GetModule("Display").db.profile.UIETimer then
		if UIETime[msg] ~= nil and GetTime() - UIETime[msg] < 5 then
			return
		else
			UIETime[msg] = GetTime()
			return Error_OnEvent(self, event, msg, author, ...)
		end
	else
		return Error_OnEvent(self, event, msg, author, ...)
	end
end)

local OG_OnEvent = RaidWarningFrame:GetScript('OnEvent')
RaidWarningFrame:SetScript('OnEvent', function(self, event, msg, author,...)
	local RunFilter = false
	local RWTable = {
		[1] = "^Infest #[%d]+ coming up! [\\-] Cooldown: None [\\-] No One$",
		[2] = "^Defile on caster [A-Z][%a]+$",
		[3] = "^Shambling Horror [%d]+ Frenzy in [\\.%d]*s! Plague will kill it [%d]+s later[\\.]$",
		[4] = "^Shambling Horror [%d]+ Frenzy in [.%d]*s! Plague will not kill it!$",
		[5] = "^Shambling Horror used Enrage [\\-] Stun/Tranq/Cooldown now!$",
		[6] = "^{[sS][Kk][uU][lL][lL]}Shambling Horror Enrage . Tranquilize now!{[sS][Kk][uU][lL][lL]}$",
		[7] = "^{rt[1,2,3,4,5,6,7,8]}Shambling Horror Enrage . Tranquilize now!{rt[1,2,3,4,5,6,7,8]}$",
		[8] = "^{[sS][Kk][uU][lL][lL]}Shambling Horror Frenzy . Stun it or Pain Suppression{[sS][Kk][uU][lL][lL]}$",
		[9] = "^{rt[1,2,3,4,5,6,7,8]}Shambling Horror Frenzy . Stun it or Pain Suppression{rt[1,2,3,4,5,6,7,8]}$",
		[10] = "^Infest #[%d]+ coming up!$",
		[11] = "^Infest coming up! %- Cooldown: None %- No One$",
		[12] = "^Infest #[%d]+[%s]*[!]*$",
		[13] = "^Plague will kill Shambling Horror [%d]+ in [%d]+s%.$",
		[14] = "^{[sS][Kk][uU][lL][lL]}Shambling Horror Frenzy [\\-] Cooldowns on add tank![%s]*{[sS][Kk][uU][lL][lL]}[%s]*$",
		[15] = "^{[sS][Kk][uU][lL][lL]}Defile on tank [A-Z][%a]+{[sS][Kk][uU][lL][lL]}[%s]*$",
		[16] = "^{[sS][Kk][uU][lL][lL]}Defile on healer [A-Z][%a]+{[sS][Kk][uU][lL][lL]}[%s]*$",
		[17] = "^{[sS][Kk][uU][lL][lL]}Defile on caster [A-Z][%a]+{[sS][Kk][uU][lL][lL]}[%s]*$",
		[18] = "^{[sS][Kk][uU][lL][lL]}Defile on melee [A-Z][%a]+{[sS][Kk][uU][lL][lL]}[%s]*$",
		[19] = "^{[sS][Kk][uU][lL][lL]}Defile on [A-Z][%a]+{[sS][Kk][uU][lL][lL]}[%s]*$",
		[20] = "^No AoE stun!$",
		[21] = "^No AoE slow!$",
		[22] = "^Warning: Shambling Horro has 10 stacks of Necrotic Plague$",
		[23] = "^[A-Z][%a]+ pulled aggro on a Raging Spirit!$",
		[24] = "^[A-Z][%a]+ and [A-Z][%a]+ are like a bi%-ird, they'll only fly awa%-ay%.%.%.$",
		[25] = "^[A-Z][%a]+, [A-Z][%a]+ and [A-Z][%a]+ are like a bi%-ird, they'll only fly awa%-ay%.%.%.$",
		[26] = "^[A-Z][%a]+, [A-Z][%a]+, [A-Z][%a]+ and [A-Z][%a]+ are like a bi%-ird, they'll only fly awa%-ay%.%.%.$",
		[27] = "^[A-Z][%a]+ is like a bi%-ird, he'll only fly awa-ay%.%.%.$",
		[28] = "^[A-Z][%a]+ is like a bi%-ird, she'll only fly awa%-ay%.%.%.$",
		[29] = "^[A-Z][%a]+ picked up!$",
		[30] = "^Big Brother: ",
	}
	if author ~= UnitName("player") and msg ~= nil and msg ~= "" then
		if not RunFilter and FatCooldowns:GetModule("Display").db.profile.chatfilter[99878] then
			for x,c in pairs(RWTable) do
				if msg:lower():find(c) then RunFilter = true break end
			end
		end

		if not RunFilter and FatCooldowns:GetModule("Display").db.profile.chatfilter[99858] then
			if msg:find("^[A-Z][%a]+ receives loot:.+%.$") or msg:find("^[A-Z][%a]+ won:.+%.$") then RunFilter = true end
		end

		if next(FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList) then
			for l,p in pairs(FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList) do
				if FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].RWFrame ~= nil and FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].RWFrame then
					local Message = l
					local CurrentMessage = msg
					if Message:find("FCDAuthor") then Message = gsub(Message, "FCDAuthor", author) end
					if Message:find("FCDBoss1") then Message = gsub(Message, "FCDBoss1", UnitName("boss1")) end
					if Message:find("FCDAnyLink") then
						local pattern = "|c%x+|H(%w+):.-|h%[.-%]|h|r"
						CurrentMessage = gsub(CurrentMessage, pattern, "FCDAnyLink")	
					end
					if Message:find("FCDGroupPlayer") then Message = FCDGroupPlayerFound(Message) end
					if FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Match ~= nil and FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Match then else
						Message = SafeLower(Message)
						CurrentMessage = SafeLower(CurrentMessage)
					end
					if CurrentMessage:find(Message) then 
						if next(FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Filter) then
							for g,f in pairs(FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Filter) do
								if f and g == event then
									RunFilter = true
									break
								end
							end
						end
					end
				end
			end
		end

		if RunFilter then
			if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99878] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99878].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99878].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidWarningFrame] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidWarningFrame] ~= msg) then
				FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidWarningFrame] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99878].chan]:AddMessage("FCDRaidWarningFrame:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) 
			end
			return 
		else
			msg = FatCooldowns:GetModule("Display"):ProcessMessage(msg)
			return OG_OnEvent(self, event, msg, author, ...)
		end
	else
		msg = FatCooldowns:GetModule("Display"):ProcessMessage(msg)
		return OG_OnEvent(self, event, msg, author, ...)
	end
end)


function islead(name)
	if UnitInRaid("player") then
		for i=1, GetNumRaidMembers() do
 		local nametwo, rank, _, _, _, _, _, _, _, role, _, _ = GetRaidRosterInfo(i)
 		if name == nametwo and rank == 2 then return nametwo end
 		end
	end
end

function SystemAddonFailed(self,_,msg,author) if msg:lower():find("interface action failed because of an addon") then return true end end
function WarmaneSystemSpam(self,_,msg,author) if msg:lower():find("^|cff99cc00.+|r$") then
 if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99950] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99950].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99950].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[WarmaneSystemSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[WarmaneSystemSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[WarmaneSystemSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99950].chan]:AddMessage("FCDWarmaneSystemSpam: "..msg, 1,0.49,0.04) end return true end end
function MPRSpam(self,_,msg,author) if (msg:lower():find("^<mpr>") or msg:lower():find("^<b%.m>") or msg:find("^[\\[]HASS] ") or msg:find("^GoofyBest> ") or
 (msg:find("^{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+") and msg:find("|cff71d5ff|Hspell:[%d]+|h[\\[].+]|h|r")) or
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ used |cffa335ee|Hitem:54589:0:0:0:0:0:0:0:0|h[Glowing Twilight Scale]|h|r") or
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ used |cffa335ee|Hitem:54573:0:0:0:0:0:0:0:0|h[Glowing Twilight Scale]|h|r") or
 (msg:find("^{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ died%. %(") and msg:find("%)$")) or

 (msg:find("^{[sS][tT][aA][rR]}[%s]*[A-Z][%a]+") and msg:find("|cff71d5ff|Hspell:[%d]+|h[\\[].+]|h|r")) or

 msg:find("^{rt[1,2,3,4,5,6,7,8]}[%s]*|cff71d5ff|Hspell:[%d]+|h[\\[].+]|h|r .+ on [A-Z][%a]+") or
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[%s]*|cff71d5ff|Hspell:[%d]+|h[\\[].+]|h|r hits: [A-Z][%a]+ %([%d]+[k]*%)") or
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[%s]*|cff71d5ff|Hspell:[%d]+|h[\\[].+]|h|r expires in [%d]+ seconds%.$") or
 msg:find("^{[sS][tT][aA][rR]}[%s]*|cff71d5ff|Hspell:[%d]+|h[\\[].+]|h|r .+ on [A-Z][%a]+$") or

 msg:lower():find("^%>[%s]*{[Ss][Tt][Aa][Rr]}[%s]*|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r CD: [%d]+ sec[%s]*{[Ss][Tt][Aa][Rr]}$") or
 msg:lower():find("^%>[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r CD: [%d]+ sec[%s]*{rt[1,2,3,4,5,6,7,8]}$") or
 msg:lower():find("^%>[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r: [%d]+ sec[%s]*{rt[1,2,3,4,5,6,7,8]}$") or
 msg:lower():find("^%>[%s]*{[tT][Rr][Ii][Aa][Nn][Gg][Ll][Ee]}[%s]*|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r: [%d]+ sec[%s]*{[tT][Rr][Ii][Aa][Nn][Gg][Ll][Ee]}$") 
) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99951] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99951].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99951].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[MPRSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[MPRSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[MPRSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99951].chan]:AddMessage("FCDMPRSpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FatalitySpam(self,_,msg,author) if (msg:lower():find("^fatality") or msg:find("^Décès:") ) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99952] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99952].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99952].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FatalitySpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FatalitySpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FatalitySpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99952].chan]:AddMessage("FCDFatalitySpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function CrybabySpam(self,_,msg,author) if msg:lower():find("^crybaby") and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99953] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99953].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99953].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[CrybabySpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[CrybabySpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[CrybabySpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99953].chan]:AddMessage("FCDCrybabySpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function WarmaneCustomDBMSpam(self,_,msg,author) if (msg:find("^[%s]*Instability_Reset$") or msg:find("^[%s]*Gained_Instability$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99954] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99954].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99954].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[WarmaneCustomDBMSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[WarmaneCustomDBMSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[WarmaneCustomDBMSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99954].chan]:AddMessage("FCDWarmaneCustomDBMSpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function IDKNAMESpam(self,_,msg,author) if ((msg:lower():find("^%*%*%*") and msg:lower():find("%*%*%*$")) or (msg:lower():find("^###") and msg:lower():find("###$"))) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99955] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99955].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99955].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[IDKNAMESpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[IDKNAMESpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[IDKNAMESpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99955].chan]:AddMessage("FCDIDKNAMESpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end 
function FactionGroupSpam(self,_,msg,author,lang) if UnitFactionGroup("player")=="Horde" and lang=="Common" then
	if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99956] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99956].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99956].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FactionGroupSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FactionGroupSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FactionGroupSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99956].chan]:AddMessage("FCDFactionGroupSpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end
 return true elseif UnitFactionGroup("player")=="Alliance" and lang=="Orcish" then
	if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99956] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99956].enable ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99956].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99956].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FactionGroupSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FactionGroupSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FactionGroupSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99956].chan]:AddMessage("FCDFactionGroupSpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end 
function EmblemSpam(self,_,msg,author) if msg:lower():find("receives loot") and msg:lower():find("emblem of") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99957] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99957].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99957].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[EmblemSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[EmblemSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[EmblemSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99957].chan]:AddMessage("FCDEmblemSpam:"..msg, 1,0.49,0.04) end return true end end 
function ParrySpam(self,_,msg,author) if 
	((msg:find("PARRY") and msg:find("parried") and msg:find("!$")) or
	(msg:find("has caused a PARRY by") and msg:find("!$")) or
	msg:find("^[%s]*PARRY: [%a]+$") or
	(UnitName("boss1") ~= nil and msg:find("^[A-Z][%a]+'s attack was parried by "..UnitName("boss1").."!$")) or
	msg:find("^[%s]*Congratz [A-Z][%a]+ you won %-[%d]+k dkp !$") or
	msg:find("^[A-Z][%a]+ caused a parry on [A-Z][%a]+") or
	msg:find("^PARRY: [A-Z][%a]+ has caused a PARRY! boss target is [A-Z][%a]+$") or
	msg:find("^PARRY: [A-Z][%a]+ has caused a PARRY! Boss Target: [A-Z][%a]+$") or
	msg:find("^PARRY: [A-Z][%a]+'s pet %([A-Z][%a]+%) has caused a PARRY! Boss Target: [A-Z][%a]+$") or
	msg:find("^PARRY: [A-Z][%a]+'s pet %(.+%) has caused a PARRY!$") or
	msg:find("^PARRY: [A-Z][%a]+ has caused a PARRY!$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99958] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99958].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99958].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ParrySpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ParrySpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ParrySpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99958].chan]:AddMessage("FCDParrySpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end  
function DetailsDeathSpam(self,_,msg,author) if 
msg:find("^Details! [A-Z][%a]+'s Death:") and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99949] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99949].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99949].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[DetailsDeathSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[DetailsDeathSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[DetailsDeathSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99949].chan]:AddMessage("FCDDetailsDeathSpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function SkadaDeathSpam(self,_,msg,author) if 
msg:find("^Skada: [A-Z].+ > [A-Z][%a]+ %(.+%) [%d]+") and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99946].enable ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99946].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99946].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[SkadaDeathSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[SkadaDeathSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[SkadaDeathSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99946].chan]:AddMessage("FCDSkadaDeathSpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function IsReadySpam(self,_,msg,author) if (
	msg:find("^[%s]*[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r is ready!$") or
	msg:find("^[%s]*[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r will be ready in [%d]+sec$") or
	msg:find("|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r is ready to be used by [A-Z][%a]+") or
	msg:find("|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r is ready to be used by ~") or
	msg:find("|cffa335ee|Hitem:54589:0:0:0:0:0:0:0:0|h[Glowing Twilight Scale]|h|r[%s]*is ready to be used by [A-Z][%a]+") or
	msg:find("^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r will be ready in (CD [%d]+[\\.]*[%d]*)$") or
	(msg:find("^[A-Z][%a]+ has |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r ready.$") and not msg:find(UnitName("player")))	) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99948] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99948].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99948].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[IsReadySpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[IsReadySpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[IsReadySpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99948].chan]:AddMessage("FCDIsReadySpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function IconsSpam(self,_,msg,author) if UnitInRaid("player") and UnitAffectingCombat("player") then local player = select(3, msg:find("[\\[](%a+)]")) if islead(player) == player then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99873] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99873].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99873].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[IconsSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[IconsSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[IconsSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99873].chan]:AddMessage("FCDIconsSpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return false else return true end end end
function RBSDeaths(self,_,msg,author) if (msg:find("^Ranged DPS [A-Z][%a]+ has died!$") or msg:find("^Melee DPS [A-Z][%a]+ has died!$") or msg:find("^Tank [A-Z][%a]+ has died!$") or msg:find("^Healer [A-Z][%a]+ has died!$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99946] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99946].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99946].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RBSDeaths] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RBSDeaths] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RBSDeaths] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99946].chan]:AddMessage("FCDRBSDeaths:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FCDMVileGas(self,_,msg,author) if (msg:find("Vile Gas on: [A-Z][%a]+, [A-Z][%a]+, [A-Z][%a]+$") or msg:find("Vile Gas on: [A-Z][%a]+, [A-Z][%a]+, [A-Z][%a]+ Extra: [A-Z][%a]+")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99929] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99929].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99929].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMVileGas] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMVileGas] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMVileGas] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99929].chan]:AddMessage("FCDFCDMVileGas:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FCDMWhoring(self,_,msg,author) if UnitName("boss1") ~= nil and (
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on "..UnitName("boss1").." or adds".."$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Prince Valanar with 1HP$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Prince Keleseth with 1HP$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Prince Taldaram with 1HP$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on "..UnitName("boss1").."$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Blood Beast$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Val'kyr Shadowguard$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Vile Spirit$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Drudge Ghoul$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Little Ooze$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Big Ooze$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Shambling Horror$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Drudge Ghoul$") or
msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Dark Nucleus$") or
--other whoring addon messages
msg:find("^[%s]*[\\*]Whoring[\\*] [A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on"..UnitName("boss1").."$") or
msg:find("^[%s]*[\\*]Whoring[\\*] [A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Big Ooze$") or
msg:find("^[%s]*[\\*]Whoring[\\*] [A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Little Ooze$") or
msg:find("^[%s]*[\\*]Whoring[\\*] [A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Drudge Ghoul$") or
msg:find("^[%s]*[\\*]Whoring[\\*] [A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Prince Keleseth$") or
msg:find("^[%s]*[\\*]Whoring[\\*] [A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Prince Valanar$") or
msg:find("^[%s]*[\\*]Whoring[\\*] [A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Prince Taldaram$") or
msg:find("^[%s]*[\\*]Whoring[\\*] [A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Vile Spirit$") or
msg:find("^[%s]*[\\*]Whoring[\\*] [A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Shambling Horror$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99925] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99925].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99925].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMWhoring] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMWhoring] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMWhoring] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99925].chan]:AddMessage("FCDFCDMWhoring:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FCDMWhoringSingle(self,_,msg,author) if msg:find("Warning: [A-Z][%a]+ has used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on Val'kyr Shadowguard with [%d]+[%%] HP$") and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99924] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99924].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99924].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMWhoringSingle] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMWhoringSingle] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMWhoringSingle] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99924].chan]:AddMessage("FCDFCDMWhoringSingle:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FCDMBPCKock(self,_,msg,author) if
	(msg:find("[A-Z][%a]+ has knocked the Tank [A-Z][%a]+ with Empowered Shock Vortex$") or
		msg:find("Warning: [A-Z][%a]+ Healer knocked by [A-Z][%a]+") or 
		msg:find("Warning: [A-Z][%a]+ Tank knocked by [A-Z][%a]+"))
	and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99922] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99922].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99922].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMBPCKock] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMBPCKock] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMBPCKock] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99922].chan]:AddMessage("FCDFCDMBPCKock:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FCDOozeDamage(self,_,msg,author) if (msg:find("Incorrect Ooze Damage: [A-Z][%a]+ used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)()]*]|h|r on Gas Cloud with incorrect debuff$") or
	msg:find("Incorrect Ooze Damage: [A-Z][%a]+ used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)()]*]|h|r on Volatile Ooze with incorrect debuff$")) and author ~= UnitName("player") then
	if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99927] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99927].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99927].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDOozeDamage] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDOozeDamage] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDOozeDamage] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99927].chan]:AddMessage("FCDFCDOozeDamage:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FCDMBQLBite(self,_,msg,author) if msg:find("[A-Z][%a]+ has bitten [A-Z][%a]+$") and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99928] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99928].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99928].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMBQLBite] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMBQLBite] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMBQLBite] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99928].chan]:AddMessage("FCDFCDMBQLBite:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FCDMBacklash(self,_,msg,author) if UnitName("boss1") ~= nil and UnitName("boss1") == "Sindragosa" and (
	msg:find("[A-Z][%a]+ just exploded with [%d]+ stacks on [%d]+ targets[!]*") or 
	msg:find("[A-Z][%a]+ exploded with [%d]+ stacks") or 
	msg:find("[A-Z][%a]+ with [%d]+ stacks hits [%d]+: [A-Z][%a]+") or 
	msg:find("[A-Z][%a]+ with [%d]+ stacks hits Unknown: [A-Z][%a]+") or 
	msg:find("[A-Z][%a]+ with [%d]+ stacks hits Unkown: [A-Z][%a]+") or 
	--new backlash v16
	msg:find("[A-Z][%a]+.* [%d]+ Hits: Unknown: [A-Z][%a]+") or 
	msg:find("[A-Z][%a]+.* [%d]+ Hits: [%d]+: [A-Z][%a]+") or 
	msg:find("[A-Z][%a]+.* [%d]+ and [A-Z][%a]+.* [%d]+ Hits: Unknown: [A-Z][%a]+") or 
	msg:find("[A-Z][%a]+.* [%d]+ and [A-Z][%a]+.* [%d]+ Hits: [%d]+: [A-Z][%a]+") or 
	msg:find("[A-Z][%a]+ Ice Block [%d]+ Hits: [%d]+: [A-Z][%a]+") or 
	msg:find("[A-Z][%a]+ Bubble [%d]+ Hits: [%d]+: [A-Z][%a]+") or
	msg:find("[A-Z][%a]+ Ice Block [%d]+ Hits: [%d]+ [A-Z][%a]+") or 
	msg:find("[A-Z][%a]+ Bubble [%d]+ Hits: [%d]+ [A-Z][%a]+") or
	--new backlash b=v16
	msg:find("[A-Z][%a]+ Ice Block with [%d]+ stacks hits: [%d]+: [A-Z][%a]+") or 
	msg:find("[A-Z][%a]+ Bubble with [%d]+ stacks hits: [%d]+: [A-Z][%a]+") or 
	(msg:find("Backlash hit [%d]+ players for ") and msg:find("damage %(") and msg:find("absorbed%): ") and msg:find("[A-Z][%a]+ ([%d]+)$"))) 
	and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99926] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99926].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99926].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMBacklash] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMBacklash] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMBacklash] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99926].chan]:AddMessage("FCDFCDMBacklash:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FCDBMHastedAttack(self,_,msg,author) if UnitName("boss1") ~= nil and UnitName("boss1") == "Halion" and msg:find("Boss has done a PARRY HASTED attack$") and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99887] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99887].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99887].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDBMHastedAttack] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDBMHastedAttack] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDBMHastedAttack] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99887].chan]:AddMessage("FCDBMHastedAttack:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FCDMRSDispel(self,_,msg,author) if (
 msg:find("[A-Z][%a]+ dispelled |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r from [A-Z][%a]+ after [%d]+[\\.][%d]+ Seconds") or
 msg:find("[A-Z][%a]+ dispelled |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r from [A-Z][%a]+ after Unknown Seconds") or
 msg:find("[A-Z][%a]+ has dispelled the mark with Bubble, Cloak or Ice Block after Unkown Seconds") or
 msg:find("[A-Z][%a]+ has dispelled the mark with Bubble, Cloak or Ice Block after Unknown Seconds") or
 msg:find("[A-Z][%a]+ has dispelled the mark with Bubble, Cloak or Ice Block after [%d]+ Seconds") or
 msg:find("[A-Z][%a]+ has dispelled |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r with |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r after .+ Seconds")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99923] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99923].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99923].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMRSDispel] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMRSDispel] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMRSDispel] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99923].chan]:AddMessage("FCDFCDMRSDispel:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FCDMSunders(self,_,msg,author) if msg:find("5 Sunder's [%d]+sec: [A-Z][%a]+") and msg:find("[A-Z][%a]+ [\\-] [%d]+$") and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99906] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99906].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99906].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMSunders] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMSunders] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDMSunders] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99906].chan]:AddMessage("FCDFCDMSunders:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FCDBMNecro(self,_,msg,author) if (msg:find("[A-Z][%a]+ has dispelled Necrotic from [A-Z][%a]+ after [%d]+%.[%d]+s, Necrotic jumps to [A-Z][%a]+$") or
	msg:find("[A-Z][%a]+ has dispelled Necrotic from [A-Z][%a]+ after [%d]+%.[%d]+s$") or
	msg:find("[A-Z][%a]+ was killed with Necrotic$") or
	msg:find("[A-Z][%a]+ was killed by Necrotic[%s]*$") or
	msg:find("[A-Z][%a]+ has dispelled Necrotic from [A-Z][%a]+, Necrotic jumps to [A-Z][%a]+$") or
	msg:find("[A-Z][%a]+ has dispelled Necrotic from [A-Z][%a]+$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99930] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99930].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99930].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDBMNecro] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDBMNecro] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDBMNecro] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99930].chan]:AddMessage("FCDBMNecro:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FCDParryCounter(self,_,msg,author) if (msg:find("ParryCounterP[%d]+: [A-Z][%a]+") or msg:find("ParryCounter: [A-Z][%a]+") or
	msg:find("ParryCounterP[%d]+(In): [A-Z][%a]+") or
	msg:find("ParryCounterP[%d]+(Out): [A-Z][%a]+")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99875] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99875].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99875].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDParryCounter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDParryCounter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FCDParryCounter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99875].chan]:AddMessage("FCDParryCounter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function SmarBuffFilter(self,_,msg,author) if (
	((msg:lower():find("missing buff: <") or msg:lower():find("warning: <")) and
		(((msg:lower():find("paladin blessing") or (msg:lower():find("righteous fury") or msg:lower():find("seal")))and (not (CustomUnitClass("Player") == L["Paladin"]))) or
		((msg:lower():find("mark of the wild") or msg:lower():find("gift of the wild") or msg:lower():find("thorns")) and (not (CustomUnitClass("Player") == L["Druid"]))) or
		((msg:lower():find("arcane intellect") or msg:lower():find("molten armor") or msg:lower():find("missing focus magic")) and	(not (CustomUnitClass("Player") == L["Mage"]))) or 
		((msg:lower():find("water shield") or msg:lower():find("missing earth shield")) and (not (CustomUnitClass("Player") == L["Shaman"]))) or 
		(msg:lower():find("bone shield") and (not (CustomUnitClass("Player") == L["Death Knight"]))) or 
		((msg:lower():find("aspect cheetah/pack on") or msg:lower():find("hunter aspect")) and (not (CustomUnitClass("Player") == L["Hunter"]))) or
		((msg:lower():find("soul link") or msg:lower():find("no soulstone detected") or msg:lower():find("fel armor")) and	(not (CustomUnitClass("Player") == L["Warlock"]))) or 
		(msg:lower():find("call pet") and (not (CustomUnitClass("Player") == L["Hunter"] or CustomUnitClass("Player") == L["Death Knight"] or CustomUnitClass("Player") == L["Warlock"]))) or 
		((msg:lower():find("power word: fortitude") or msg:lower():find("shadow protection") or msg:lower():find("divine spirit") or msg:lower():find("inner fire") or
		 msg:lower():find("vampiric embrace") or msg:lower():find("shadowform")) and (not (CustomUnitClass("Player") == L["Priest"]))) or
		((msg:lower():find("different zone") or msg:lower():find("weapon buff") or msg:lower():find("well fed") or msg:lower():find("flask")) and (not (msg:find(UnitName("player"))))) )) or

	(msg:find("^[A-Z][%a]+%, [A-Z][%a]+%, [A-Z][%a]+%,") and msg:find("[A-Z][%a]+%, [A-Z][%a]+%, [A-Z][%a]+%$") and not msg:find("[%d!?\\(]")) or

((msg:find("^RBS:: [A-Z][%a]+") or 
	((msg:find("^[%s]*<No Soulstone detected>") or msg:find("^[%s]*<Soul Link>") or msg:lower():find("^[%s]*<fel armor>")) and (not (CustomUnitClass("Player") == L["Warlock"]))) or
	(msg:find("^[%s]*<Mana less than 80%>:") and (not (msg:find(UnitName("player"))))) or
	(msg:find("^[%s]*<Missing Earth Shield>:") and (not (CustomUnitClass("Player") == L["Shaman"]))) or
	((msg:find("^[%s]*Slackers:") or msg:find("^[%s]*<Slacking Paladins")) and (not (msg:find(UnitName("player"))))) or
	((msg:find("^[%s]*<Paladin blessing>:") or msg:find("^[%s]*<Crusader Aura>:") or msg:find("^[%s]*<Righteous Fury>:")) and (not (CustomUnitClass("Player") == L["Paladin"]))) or
	msg:find("^[%s]*<Bone Shield>:") or msg:find("^[%s]*<Offline>:") or msg:find("^[%s]*<Guardian Elixir>:") or
	((msg:find("^[%s]*<Hunter Aspect>:") or msg:find("^[%s]*<Aspect Cheetah/Pack On>:")) and (not (CustomUnitClass("Player") == L["Hunter"]))) or
	((msg:find("^[%s]*<Arcane Intellect>:") or msg:find("^[%s]*<Molten Armor>:")) and (not (CustomUnitClass("Player") == L["Mage"]))) or
	(msg:find("^[%s]*<Water Shield[\\/]Lightning Shield>:") and (not (CustomUnitClass("Player") == L["Shaman"]))) or
	((msg:find("^[%s]*<Power Word: Fortitude>:") or msg:find("^[%s]*<Shadow Protection>:") or msg:find("^[%s]*<Inner Fire>:") or msg:find("^[%s]*<Vampiric Embrace>:") or msg:find("^[%s]*<Divine Spirit>:") or msg:find("^[%s]*<Shadowform>:")) and (not (CustomUnitClass("Player") == L["Priest"]))) or
	((msg:find("^[%s]*<Mark of the Wild>:") or msg:find("^[%s]*<Gift of the Wild>:")) and (not (CustomUnitClass("Player") == L["Druid"]))) or

	((msg:find("^[%s]*<Well Fed>:") or msg:find("^[%s]*<Call Pet>:") or msg:find("^[%s]*<Seal>:") or msg:find("^[%s]*<Mana less then 80[\\%]>:") or msg:find("^[%s]*<Weapon buff>:") or
	msg:find("^[%s]*<Flask or two Elixirs>:") or msg:find("^[%s]*<Low durability>:") or msg:find("^[%s]*<AFK>:") or msg:find("^[%s]*<Missing Focus Magic>:")
			) and (not (msg:find(UnitName("player"))))) or
	msg:find("^[%s]*<Thorns>:")))) and (not (author == UnitName("player"))) then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99945] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99945].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99945].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[SmarBuffFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[SmarBuffFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[SmarBuffFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99945].chan]:AddMessage("FCDSmarBuffFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function FlumpFilter(self,_,msg,author) if (	
 msg:find("^[A-Z][%a]+ used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-']*]|h|r!$") or 
 msg:find("^|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from [A-Z][%a]+[%s]*!$") or 
 msg:find("^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r consumed: [%d]+ heal!$") or 
 msg:find("^[A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on [A-Z][%a]+!$") or
 msg:find("^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from [A-Z][%a]+[%s]*!$") or 
 msg:find("^[A-Z][%a]+ used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on [A-Z][%a]+!$") or

 msg:find("^[A-Z][%a]+ is creating a |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r!$") or 
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+ is creating a |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r!$") or 
 msg:find("^[A-Z][%a]+ prepares a |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r!$") or 
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+ prepares a |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r!$") or 
 msg:find("^[A-Z][%a]+ used a |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r!$") or 
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+ used a |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r!$") or 

 msg:find("^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r resurrected [A-Z][%a]+!$") or 
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r resurrected {rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+!$") or 
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r resurrected [A-Z][%a]+!$") or 
 msg:find("^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r resurrected {rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+!$") or 

--with icons
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+ used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r!$") or 
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r consumed: [%d]+ heal!$") or 
 msg:find("^{rt[1,2,3,4,5,6,7,8]}|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from {rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+!$") or
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on {rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+!$") or
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from {rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+!$") or
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from {rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+[%s]*!$") or 
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+ used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on {rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+!$") or

 msg:find("^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r consumed: [%d]+ heal!$") or 
 msg:find("^|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from {rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+!$") or
 msg:find("^[A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on {rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+!$") or
 msg:find("^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from {rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+!$") or
 msg:find("^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from {rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+[%s]*!$") or 
 msg:find("^[A-Z][%a]+ used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on {rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+!$") or

 msg:find("^{rt[1,2,3,4,5,6,7,8]}|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from [A-Z][%a]+!$") or
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on [A-Z][%a]+!$") or
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from [A-Z][%a]+!$") or
 msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from [A-Z][%a]+[%s]*!$")or
  msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+ used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on [A-Z][%a]+!$") or

 --vdw
msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from {rt[1,2,3,4,5,6,7,8]}Valithria Dreamwalker!$") or 
msg:find("^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r faded from {rt[1,2,3,4,5,6,7,8]}Valithria Dreamwalker!$") or 
msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on Valithria Dreamwalker!$") or 
msg:find("^[A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on {rt[1,2,3,4,5,6,7,8]}Valithria Dreamwalker!$") or 
msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on Valithria Dreamwalker!$") or 
msg:find("^{rt[1,2,3,4,5,6,7,8]}[A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on {rt[1,2,3,4,5,6,7,8]}Valithria Dreamwalker!$") or 
msg:find("^[A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r on Valithria Dreamwalker!$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99944] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99944].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99944].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FlumpFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FlumpFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FlumpFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99944].chan]:AddMessage("FCDFlumpFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function PhoenixStyleFilter(self,_,msg,author) if (--marrow
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*%'Coldflame%' debuff got: [A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Best %'Bone Spike's%' kill in%:") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Bone Spike killed in [\\.%d]* sec. %([A-Z][%a]+%).") or
-- lady
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ died in/after MC! Got damage from:[%s]*[A-Z][%a]+ %([%d]+k%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Friendly fire %(to players under MC%):[%s]*[A-Z][%a]+ %([%d]+k%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*'Curse of Torpor' dispelled by:[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Got dmg from ghosts explosions:[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ died from [%d]+ Vengeful Shade%'s explosions%. were triggered by") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ died from [%d]+ Vengeful Shade%'s explosion%. was triggered by") or
--gunship
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Caught rockets:[%s]*[A-Z][%a]+ %([%d]+%)") or
--dbs
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Blood Beast's wave #[%d]+. killed in [%d]+ sec%. Damage and switch%-time:$") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Got attacks from adds %(total%):[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Boss healed from attacking tanks with debuff:[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Blood Nova. max simultaneously damage:[%s]*[%d]+ %- [A-Z][%a]+") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Blood Nova. max simultaneously damage:[%s]*[%d]+$") or
--fester
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Big AoE inc! Not enough debuffs:") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Friendly vomit attacks: [A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*'Vile Gas' that could be avoid received:[%s]*[%d]+$") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Got 'Malleable Goo' %(crash%):[%s]*[A-Z][%a]+ %([%d]+%)") or -- pp too
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ %- got Malleable Goo!$") or -- pp too
(msg:find("^[%s]*[%d]:[%s]*[A-Z][%a]+") and UnitName("boss1") ~= nil and UnitName("boss1") == "Festergut" and msg:find("%.$")) or
--rotface
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Ticks from Slime Spray %(boss breath%):[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Missiles of Ooze Explosion received::[%s]*[A-Z][%a]+ %([%d]+%)") or
--pp
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Stand in Slime Puddle %(sec.%):[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ passed 'Unbound Plague' to [A-Z][%a]+ %(stack:[%s]*[%d]+%)$") or 
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Add #[%d]+ %(orange%). killed in [%d]+ sec[\\.] Damage and switch%-time:$") or 
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Add #[%d]+ %(green%). killed in [%d]+ sec. Damage and switch%-time:$") or 
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Mutated Abomination %([%d]+k - $") or 
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Choking Gas Explosion:[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ died from |cff71d5ff|Hspell:[%d]+|h[\\[]Unbound Plague]|h|r in .+ sec%. He had debuff") or
--bpc
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Target switch #[%d]+ %(Prince [A-Z][%a]+%):[%s]*[A-Z][%a]+ %([%d]+[\\.]*[%d]*s%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Max stacks of Shadow Prison:[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Friendly attacks from Empowered Shock Vortex:[%s]*[A-Z][%a]+ %([%d]+[k]*%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Flame ball killed raider! It was discharged by %([%d][\\.]*[%d]* sec[\\.]%):") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ died from |cff71d5ff|Hspell:[%d]+|h[\\[]Shadow Prison]|h|r[%s]*.[%s]*stack:[%s]*[%d]+ >") or
--bql
--vdw
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Mana Void:[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Column of Frost:[%s]*[A-Z][%a]+ %([%d]+%)") or
--sindra
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Marks were on:[%s]*[A-Z][%a]+, [A-Z][%a]+, [A-Z][%a]+, [A-Z][%a]+, [A-Z][%a]+") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Boss AoE:[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Max stacks of Mystic Buffet: [A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Backlash%, [%d]+ phase[%s]*%>[%d]+%% %(dmg %- quantity of debuffs%):[%s]*[A-Z][%a]+ %(") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Backlash%, [%d]+ phase[%s]*%<[%d]+%% %(dmg %- quantity of debuffs%):[%s]*[A-Z][%a]+ %(") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Losers %(top of Unchained Magic debuffs%):[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Frost Bomb damage %(Air phase%):[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ died from |cff71d5ff|Hspell:[%d]+|h[\\[]Backlash]|h|r Reason: [A-Z][%a]+ %(x[%d]+%)") or
--lk
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Damage from Defile #[%d]+ %([A-Z][%a]+%) %- [%d]+") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Fail damage to Val'kyr #[%d]+ no dots and aoe %(damage %- count%):[%s]*[A-Z][%a%s]+ %([%d]+") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Three Val'kyr #[%d]+ %([A-Z][%a]+ [A-Z][%a]+ [A-Z][%a]+%) Damage and switch%-time:$") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Total sec in Defile:[%s]*[A-Z][%a]+ %([%d]+%)") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Spirits explodes in this fight:[%s]*[%d]+.$") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*Harvest Soul. effective heal %(total%):[%s]*[A-Z][%a]+ %([%d]+") or
msg:find("^[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ died with Harvest Soul in .+ sec. Was healed by:[%s]*[A-Z][%a]+") or
--damage done (for more than one boss)
(msg:find("^[A-Z][%a]+ %([%d]+k %- [%d]+%.[%d]*s%)[%s,]*%.%.%.$") and UnitAffectingCombat("player") and UnitName("boss1") ~= nil and UnitName("boss1") == "The Lich King")  or
(msg:find("^[A-Z][%a]+ %([%d]+k %- [%d]+%.[%d]*s%), [A-Z][%a]+ %([%d]+k - [%d]+%.[%d]*s%)") and msg:find("[A-Z][%a]+ %([%d]+k - [%d]+%.[%d]*s%)[%s,]*%.%.%.$") and UnitAffectingCombat("player") and UnitName("boss1") ~= nil and UnitName("boss1") == "The Lich King") or
(msg:find("^[A-Z][%a]+ %([%d]+%), [A-Z][%a]+ %([%d]+%), [A-Z][%a]+ %([%d]+%)") and msg:find("[A-Z][%a]+ %([%d]+%), [A-Z][%a]+ %([%d]+%)%.[%.]*$") and UnitAffectingCombat("player") and UnitName("boss1") ~= nil and UnitName("boss1") == "Prince [A-Z][%a]+") or
(msg:find("^[A-Z][%a]+ %([%d]+k %- [%d]+%), %.%.%.$") and UnitAffectingCombat("player") and UnitName("boss1") ~= nil and UnitName("boss1") == "The Lich King") or
(msg:find("^[A-Z][%a%s]* %([%d]+k %- [%d]+%), [A-Z][%a%s]* %([%d]+k %- [%d]+%), %.%.%.$") and UnitAffectingCombat("player") and UnitName("boss1") ~= nil and UnitName("boss1") == "The Lich King") or
--failed to move EnsidiaFails
msg:find("^[A-Z][%a]+ has failed at not moving %(Choking Gas%) %([%d]+%)$") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Malleable Goo%) %([%d]+%)$") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Mutated Slime%) %([%d]+%)$") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Sticky Ooze%) %([%d]+%)$") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Coldflame%) %([%d]+%)$") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Slime Spray%) %([%d]+%)$") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Bone Storm%) %([%d]+%)$") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Death and Decay%) %([%d]+%)$") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Bone Slice%) %([%d]+%)$") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Emerald Vigor%) %([%d]+%)$") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Column of Frost%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Call Blood Beast%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at moving %(Call Blood Beast%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Kinetic Bomb%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Ice Tomb%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Mystic Buffet%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Swarming Shadows%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at casting %(Kinetic Bomb%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at casting %(Uncontrollable Frenzy%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Defile%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Death and Decay%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not casting %(Instability%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Spirit Bomb%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Shadow Trap%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Remorseless Winter%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Blistering Cold%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Tail Smash%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at being at the wrong place %(Soul Shriek%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at being at the wrong place %(Shockwave%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at being at the wrong place %(Pact of the Darkfallen%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at being at the wrong place %(Frost Breath%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Frost Bomb%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not spreading %(Bloodbolt Splash%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not spreading %(Empowered Shock Vortex%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at switching %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at notattacking %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at being at the wrong place %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at being at the wrong place %(Cleave%) %([%d]+%)") or
msg:find("^[A-Z][%a]+ has failed at not moving %(Explosion%)") )and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99943] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99943].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99943].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[PhoenixStyleFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[PhoenixStyleFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[PhoenixStyleFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99943].chan]:AddMessage("FCDPhoenixStyleFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function ImpBallFilter(self,_,msg,author) if author == "Imp in a Ball" then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99921] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99921].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99921].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ImpBallFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ImpBallFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ImpBallFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99921].chan]:AddMessage("FCDImpBallFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function WhisperFilter(self,_,msg,author) if (
	(msg:find("^You have") and msg:find("Power Infusion") and msg:find("[\\!]$")) or
	msg:find("^	casting .+ on you, but you're not in line of sight[!]*") or
	msg:find("^<MPR> |cff71d5ff|Hspell:[%d]+|h[\\[]Frost Beacon]|h|r on you! Run away from others[!]+") or
	msg:find("^<DBM> Your version of Deadly Boss Mods is out%-of%-date$") or
	msg:find("^<MPR> You have to bite[!]+$") or
	msg:find("^<B%.M> You have to bite[!]+$") or
	msg:find("^<B%.M> |cff71d5ff|Hspell:[%d]+|h[\\[]Necrotic Plague]|h|r on you[!]* Run to a Shambling Horror[!]*$") or
	msg:find("^<B%.M> |cff71d5ff|Hspell:[%d]+|h[\\[]Swarming Shadows]|h|r on you[!]* Run along walls[!]*$") or
	msg:find("^Hand of Protection on you[!]+$") or
	msg:find("^<B%.M>[%s]*|cff71d5ff|Hspell:[%d]+|h[\\[]Enervating Brand]|h|r[%s]*on you! Run away!!$") or
	msg:find("^<B%.M>[%s]*|cff71d5ff|Hspell:[%d]+|h[\\[]Gaseous Bloat]|h|r[%s]*on you[!]* Kite it[!]*$") or
	msg:find("^<B%.M>[%s]*|cff71d5ff|Hspell:[%d]+|h[\\[]Frost Beacon]|h|r[%s]*on you! Run away from others[!]+$") or
	msg:find("^<B%.M>[%s]*|cff71d5ff|Hspell:[%d]+|h[\\[]Pain and Suffering]|h|r") or
	msg:find("^Thanks for |cff71d5ff|Hspell:[%d]+|h[\\[]Tricks of the Trade]|h|r!$") or
	msg:find("^Focus Magic Cast On You$") or
	msg:find("^Trick or Treat! Careful! You're at [%d]+% threat on .+%.$") or
	msg:find("^Focus Magic on you$") or
	msg:find("^Power Infusion[!]+$") or
	msg:find("^Thanks For Focus Magic Baby <3$") or
	msg:find("^Thanks For The Innervate$") or
	msg:find("^FM on U$") or
	msg:find("^Trick or Treat!$") or
	msg:find("^Tricks gave you [%d]+ extra damage.$") or
	msg:find("^Thanks For Focus Magic$") or
	msg:find("^|cff71d5ff|Hspell:[%d]+|h[\\[]Curse of Torpor]|h|r on me%. Dispel, please$") or
	msg:find("^|cff71d5ff|Hspell:[%d]+|h[\\[]Tricks of the Trade]|h|r on you%.$") or
	msg:find("^casting Redirección on you, but you're not in line of sight[!]*$") or
	msg:find("^casting .+ on you, but you're not in line of sight[!]*$") or
	msg:find("^Thank you for Focus Magic!$") or
	msg:find("^Thanks For Power Infusion$") or
	msg:find("^Power Infusion casted on you$") or
	msg:find("^Thanks For Power Innervate$") or
	msg:find("^Hand of Protection cast on You!$") or
	msg:find("^Tricks of the Trade on you.$") or
	msg:find("^Pain Suppression cast on You!$") or
	msg:find("^Pain Suppression on You ended!$") or
	msg:find("^<MageNuggets> Focus Magic on you$") or
	msg:find("^<MageNuggets> Thanks for Focus Magic$") or
	msg:find("^[%s]*RSC > You have no Flask and Food Buff!$") or
	msg:find("^[%s]*RSC > You have no Flask or Food Buff!$") or
	msg:find("^[%s]*RSC > You have no Flask!$") or	
	msg:find("^[%s]*RSC > You have no Flask or Elixir!$") or
	msg:find("^[%s]*RSC > You have no Food Buff!$") or
	msg:find("^Power Infusion on You!$") or
	msg:find("^casting .+ on you, but you're out of range!$") or
	msg:find("^{rt[1,2,3,4,5,6,7,8]}[%s]*DEFILE ON YOU![%s]*{rt[1,2,3,4,5,6,7,8]}$") or
	msg:find("^{[Ss][Kk][Uu][Ll][Ll]}[%s]*DEFILE ON YOU![%s]*{[Ss][Kk][Uu][Ll][Ll]}$") or
	msg:find("^<MPR> |cff71d5ff|Hspell:[%d]+|h[\\[]Pain and suffering]|h|r %(5 stacks%) on you[!]+") or
	msg:find("^casting [A-Z][%a%s]* on you, but you're not in line of sight!$")) then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99920] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99920].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99920].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[WhisperFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[WhisperFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[WhisperFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99920].chan]:AddMessage("FCDWhisperFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function FlasknFoodFilter(self,_,msg,author) if 
((msg:lower():find("rsc > no flask %(") or msg:lower():find("rsc > everyone has flask and food buff%.") or msg:lower():find("rsc > only one elixir %(") or msg:lower():find("food buff has only %(") or msg:lower():find("no food buff %(") or msg:lower():find("no flask or elixir:") or msg:lower():find("no food buff:")) and not msg:find(UnitName("player")) or
msg:find("^No Flask %([%d]+%): [A-Z][%a]+") or
msg:find("^One Elixir %([%d]+%): [A-Z][%a]+$") or
msg:find("^Not checked %([%d]+%):[%s]*[A-Z][%a]+") or
((msg:find("^No Food Buff %([%d]+%):[%s]*[A-Z][%a]+") or msg:find("^No Food Buff %([%d]+%):[%s]*no one has it!")) and not msg:find(UnitName("player"))) or
(msg:find("^Not Well Fed %([%d]+%): [A-Z][%a]+$") and not msg:find(UnitName("player")))
)and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99919] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99919].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99919].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FlasknFoodFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FlasknFoodFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[FlasknFoodFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99919].chan]:AddMessage("FCDFlasknFoodFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function RSAFilter(self,_,msg,author) if (
	--pala
msg:find("^Ardent Defender Activated!$") or
msg:find("^Ardent Defender Faded!$") or
msg:find("^Aura Mastery Activated!$") or
msg:find("^Aura Mastery Faded!$") or
msg:find("^Aura Mastery activated!$") or
msg:find("^Aura Mastery has ended!$") or
msg:find("^Hand [Oo]f Freedom on [A-Z][%a]+!$") or
msg:find("^Divine Sacrifice and Guardian activated!$") or
msg:find("^Divine Sacrifice has ended!$") or
msg:find("^Divine Sacrifice activated!$") or
msg:find("^Divine Guardian has ended!$") or
msg:find("^Divine Guardian Activated!$") or
msg:find("^Divine Guardian Faded!$") or
msg:find("^Divine Protection Activated!$") or
msg:find("^Divine Protection activated!$") or
msg:find("^Divine Protection ended!$") or
msg:find("^Divine Protection Faded!$") or
msg:find("^Divine intervention on [A-Z][%a]+!$") or
msg:find("^Forbearance Faded!$") or
msg:find("^Ardent Defender Activated!$") or
msg:find("^Beacon [Oo]f Light cast on [A-Z][%a]+!$") or
msg:find("^Beacon [Oo]f Light on [A-Z][%a]+ has ended!$") or
msg:find("^Hand [Oo]f Freedom cast on [A-Z][%a]+!$") or
msg:find("^Hand [Oo]f Freedom on [A-Z][%a]+!$") or
msg:find("^Hand [Oo]f Protection cast on [A-Z][%a]+!$") or
msg:find("^Hand [Oo]f Sacrifice cast on [A-Z][%a]+!$") or
msg:find("^Hand [Oo]f Sacrifice on [A-Z][%a]+!$") or
msg:find("^Hand [Oo]f Salvation cast on [A-Z][%a]+!$") or
msg:find("^Hand [Oo]f Salvation on [A-Z][%a]+!$") or
msg:find("^Lay [oO]n Hands on [A-Z][%a]+ for [%d]+!$") or
msg:find("^Divine Protection has ended!$") or
msg:find("^Ardent Defender is active again!$") or
msg:find("^Ardent Defender has just saved my life!$") or
	--warlock
msg:find("^Banished [A-Z][%a%s]+!$") or
msg:find("^Banish on [A-Z][%a%s]+ has ended!$") or
msg:find("^Fearing [A-Z][%a%s]+!$") or
msg:find("^Fear on [A-Z][%a%s]+ has ended!$")or
--priest
msg:find("^Hymn of Hope activated!$") or
msg:find("^Hymn of Hope has ended!$") or
msg:find("^Power Infusion on [A-Z][%a]+!$") or
msg:find("^Pain Suppression on [A-Z][%a]+!$") or
msg:find("^Pain Suppression on [A-Z][%a]+ has ended!$") or
msg:find("^[A-Z][%a]+ casted Guardian Spirit on [A-Z][%a]+$") or
msg:find("^Divine Hymn activated!$") or
msg:find("^Divine Hymn over!$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99918] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99918].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99918].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RSAFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RSAFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RSAFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99918].chan]:AddMessage("FCDRSAFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function JapChiKorFilter(self,_,msg,author) if msg:find("[\228-\237]") and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99914] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99914].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99914].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[JapChiKorFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[JapChiKorFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[JapChiKorFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99914].chan]:AddMessage("FCDJapChiKorFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function RussainFilter(self,_,msg,author) if msg:find("[\208]") and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99913] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99913].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99913].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RussainFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RussainFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RussainFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99913].chan]:AddMessage("FCDRussainFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function TauntFilter(self,_,msg,author) if(
	(msg:find("^<WhoTaunted>") and msg:find("taunted") and msg:find("%.$")) or
	(msg:find("^<WhoTaunted>") and msg:find("taunt") and msg:find("against ") and msg:find("!$")) or
	msg:find("^[A-Z][%a]+ taunted [A-Z].* using |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r%.$") or
	msg:find("^TAUNT: [A-Z][%a]+ taunted [A-Z].* with |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r%.$") or
	msg:find("^TAUNT: [A-Z][%a]+ AOE taunted with |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r%.$") or
	msg:find("^TAUNT: [A-Z][%a]+'s taunt |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r against .* FAILED: REFLECT!$") or
	msg:find("^TAUNT: [A-Z][%a]+'s taunt |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r against .* FAILED: ABSORB!$") or
	msg:find("^TAUNT: [A-Z][%a]+'s taunt |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r against .* FAILED: IMMUNE!$") or
	msg:find("^[A-Z][%a]+ taunted my boss target %(.+%) with [A-Z]") or
	msg:find("^[A-Z][%a]+ taunted [A-Z].* %.$") or
	msg:find("^[%s]*NON%-TANK [A-Z][%a]+ taunted my boss target") or
	msg:find("^[%s]*NON%-TANK [A-Z][%a]+ taunted my target") or
	msg:find("^[\\[]RESIST] [A-Z][%a]+ FAILED TO TAUNT his boss target") or
	msg:find("^[A-Z][%a]+ AOE taunted off of [A-Z][%a]+.$") or
	msg:find("^[A-Z][%a]+ taunted my target %(.+%) with Hand of Reckoning$") or
	msg:find("^[A-Z][%a]+ taunted my target %(.+%) with Righteous Defense$") or
	msg:find("^[A-Z][%a]+ taunted my target %(.+%) with Dark Command$") or
	msg:find("[A-Z].+is immune to my taunt!$") or
	msg:find("^[A-Z][%a]+ AOE taunted off of [A-Z][%a]+ using |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r%.$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99905] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99905].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99905].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TauntFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TauntFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TauntFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99905].chan]:AddMessage("FCDTauntFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function BigBrotherFilter(self,_,msg,author) if (
	msg:find("^[A-Z][%a]+ taunted [A-Z].* with |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r$") or
	msg:find("^[A-Z][%a]+ taunted[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z].* with |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r$") or

	msg:find("^[A-Z][%a]+ aoe%-taunted [A-Z].+ with |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r$") or
	msg:find("^[A-Z][%a]+ cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on [A-Z][%a]+$") ) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99910] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99910].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99910].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[BigBrotherFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[BigBrotherFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[BigBrotherFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99910].chan]:AddMessage("FCDBigBrotherFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function LKAnnounceFilter(self,_,msg,author) if (
	msg:find("^Infest #[%d]+ coming up! [\\-] Cooldown: None [\\-] No One$") or
	msg:find("^Defile on caster [A-Z][%a]+$") or
	msg:find("^Shambling Horror [%d]+ Frenzy in [\\.%d]*s! Plague will kill it [%d]+s later[\\.]$") or
	msg:find("^Shambling Horror [%d]+ Frenzy in [.%d]*s! Plague will not kill it!$") or
	msg:find("^Shambling Horror used Enrage [\\-] Stun/Tranq/Cooldown now!$") or
	msg:find("^{[sS][Kk][uU][lL][lL]}Shambling Horror Enrage . Tranquilize now!{[sS][Kk][uU][lL][lL]}$") or
	msg:find("^{rt[1,2,3,4,5,6,7,8]}Shambling Horror Enrage . Tranquilize now!{rt[1,2,3,4,5,6,7,8]}$") or
	msg:find("^{[sS][Kk][uU][lL][lL]}Shambling Horror Frenzy . Stun it or Pain Suppression{[sS][Kk][uU][lL][lL]}$") or
	msg:find("^{rt[1,2,3,4,5,6,7,8]}Shambling Horror Frenzy . Stun it or Pain Suppression{rt[1,2,3,4,5,6,7,8]}$") or
	msg:find("^Infest #[%d]+ coming up!$") or
	msg:find("^Infest coming up! %- Cooldown: None %- No One$") or
	msg:find("^Infest #[%d]+[%s]*[!]*$") or
	msg:find("^Plague will kill Shambling Horror [%d]+ in [%d]+s%.$") or
	msg:find("^{[sS][Kk][uU][lL][lL]}Shambling Horror Frenzy [\\-] Cooldowns on add tank![%s]*{[sS][Kk][uU][lL][lL]}[%s]*$") or
	msg:find("^{[sS][Kk][uU][lL][lL]}Defile on tank [A-Z][%a]+{[sS][Kk][uU][lL][lL]}[%s]*$") or
	msg:find("^{[sS][Kk][uU][lL][lL]}Defile on healer [A-Z][%a]+{[sS][Kk][uU][lL][lL]}[%s]*$") or
	msg:find("^{[sS][Kk][uU][lL][lL]}Defile on caster [A-Z][%a]+{[sS][Kk][uU][lL][lL]}[%s]*$") or
	msg:find("^{[sS][Kk][uU][lL][lL]}Defile on melee [A-Z][%a]+{[sS][Kk][uU][lL][lL]}[%s]*$") or
	msg:find("^{[sS][Kk][uU][lL][lL]}Defile on [A-Z][%a]+{[sS][Kk][uU][lL][lL]}[%s]*$") or
	msg:find("^No AoE stun!$") or
	msg:find("^No AoE slow!$") or
	msg:find("^Warning: Shambling Horro has 10 stacks of Necrotic Plague$") or
	msg:find("^[A-Z][%a]+ pulled aggro on a Raging Spirit!$") or
	msg:find("^[A-Z][%a]+ and [A-Z][%a]+ are like a bi%-ird, they'll only fly awa%-ay%.%.%.$") or
	msg:find("^[A-Z][%a]+, [A-Z][%a]+ and [A-Z][%a]+ are like a bi%-ird, they'll only fly awa%-ay%.%.%.$") or
	msg:find("^[A-Z][%a]+, [A-Z][%a]+, [A-Z][%a]+ and [A-Z][%a]+ are like a bi%-ird, they'll only fly awa%-ay%.%.%.$") or
	msg:find("^[A-Z][%a]+ is like a bi%-ird, he'll only fly awa-ay%.%.%.$") or
	msg:find("^[A-Z][%a]+ is like a bi%-ird, she'll only fly awa%-ay%.%.%.$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99908] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99908].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99908].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[LKAnnounceFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[LKAnnounceFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[LKAnnounceFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99908].chan]:AddMessage("FCDLKAnnounceFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function RessFilter(self,_,msg,author) if (
	msg:find("^Why do you build me up, build me up, [A-Z][%a]+ baby, just to let me down, let me down, run me around%.$") or
	msg:find("^[A-Z][%a]+, by accepting this resurrection you hereby accept that you must forfeit your immortal soul to me%. Please click 'Accept' to continue%.$") or
	msg:find("^Casting Redemption on [A-Z][%a]+[%s!]*$") or
	msg:find("^Resurrection on [A-Z][%a]+$") or
	msg:find("^Casting Ancestral Spirit on [A-Z][%a]+$") or
	msg:find("^Revive on [A-Z][%a]+[%s]*!$") or
	msg:find("^Revive casting on [A-Z][%a]+[%s!]*$") or
	msg:find("^Ressing [A-Z][%a]+$") or
	msg:find("^Rezzing [A-Z][%a]+[!]* :%)$") or
	msg:find("^Ressurecting [A-Z][%a]+$") or 
	msg:find("^Rezing like a God Church$") or 
	msg:find("^Casting Revive on [A-Z][%a]+[%s]*!$") or
	msg:find("^Combat ressing >>> [A-Z][%a]+ <<<$") or
	msg:find("^Combat Rez cast on [A-Z][%a]+$") or
	msg:find("^Casting Rebirth on [A-Z][%a]+$") or
	msg:find("^Caffeine pill for [A-Z][%a]+%. comin' right up!$") or
	msg:find("^Did it hurt, [A-Z][%a]+, when you fell from Heaven? Oh, wait. You're dead. I don't know where I was going with that. Nevermind.$") or
	msg:find("^You've come to the right doctor, [A-Z][%a]+%. I'm writing you a prescription for 10mg of [\"]stop taking damage[\"]%.$") or
	msg:find("^Ancient Spirits of Evil, transform this decayed form into a.......[A-Z][%a]+$") or
	msg:find("^Death, Death%. go away%.[A-Z][%a]+ come for [A-Z][%a]+ another day!$") or
	msg:find("^it turns out [A-Z][%a]+ is only %*moslty%* dead%.$") or
	msg:find("^[A-Z][%a]+ fails at life literally$") or
	msg:find("^Remember%. [A-Z][%a]+%. if you do not fear death%. there is nothing you cannot achieve%.%.%. unless you die%.$") or
	msg:find("^Get of the floor%. [A-Z][%a]+%. it does not love you that way$") or
	msg:find("^Get of the floor%. [A-Z][%a]+%. it's not time to AFK yet!$") or
	msg:find("^Hey [A-Z][%a]+ you know it took jesus three days to do this?$") or
	msg:find("^Does anyone know what the respawn timer on [A-Z][%a]+ is?$") or
	msg:find("^Hey [A-Z][%a]+%. think i should start using Amberseeds for this?$") or
	msg:find("^Rezzing [A-Z][%a]+ should aggro every bears%.$") or
	msg:find("^in Soviet Icecrown%. life chooses [A-Z][%a]+!$") or
	msg:find("^Casting Resurrection on [A-Z][%a]+[%s]*[!]*$") or
	msg:find("^Casting Ancestral Spirit on [A-Z][%a]+[%s]*[!]*$") or
	msg:find("^Casting Revive on [A-Z][%a]+[%s]*[!]*$") or
	msg:find("^Come to life, [A-Z][%a]+, you slacker[%s]*!$") or
	msg:find("^Come to life, [A-Z][%a]+, you b00n[%s]*!$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99909] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99909].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99909].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RessFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RessFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RessFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99909].chan]:AddMessage("FCDRessFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function DBMAnnounceFilter(self,_,msg,author) if (msg:find("^Frost Beacon icon {rt[1,2,3,4,5,6,7,8]} set on [A-Z][%a]+$") or
	msg:find("^Gas Spore icon {rt[1,2,3,4,5,6,7,8]} set on [A-Z][%a]+$") or
	msg:find("^PCold icon removed from [A-Z][%a]+$") or
	msg:find("^Warning: [A-Z][%a]+ has 5 stacks of Mystic Buffet$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99959] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99959].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99959].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[DBMAnnounceFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[DBMAnnounceFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[DBMAnnounceFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99959].chan]:AddMessage("FCDDBMAnnounceFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function CustomMacronWeakaura(self,_,msg,author) if (
	msg:find("^<Keeper>.+|cff71d5ff|Hspell:[%d]+|h[\\[].+]|h|r.*:.+[%d]+ sec.+$") or
	msg:find("^Casted |cff71d5ff|Hspell:[%d]+|h[\\[]Misdirection]|h|r on [A-Z][%a]+$") or
	msg:find("^Casted |cff71d5ff|Hspell:[%d]+|h[\\[]Hand of salvation]|h|r on [A-Z][%a]+$") or
	msg:find("^Activated: |cff71d5ff|Hspell:[%d]+|h[\\[]Aura Mastery]|h|r [%d]s[!]*$") or
	msg:find("^Activated: |cff71d5ff|Hspell:[%d]+|h[\\[]Hand of sacrifice]|h|r on [A-Z][%a]+ %-[%d]s[!]*$") or
	msg:find("^Faded: |cff71d5ff|Hspell:[%d]+|h[\\[]Aura Mastery]|h|r$") or
	msg:find("^[A-Z][%a]+ exploded spirit$") or
	msg:find("^[%s]*Hand Of Freedom used$") or
	msg:find("^Hysteria CD cleared on [A-Z][%a]+$") or
	msg:find("^Pain Suppression CD cleared on [A-Z][%a]+$") or
	msg:find("^Hand of Salvation CD cleared on [A-Z][%a]+$") or
	msg:find("^Aura Mastery CD cleared on [A-Z][%a]+$") or
	msg:find("^%=%=[%s]*[A-Z][%a]+ is dead[!]*[%s]*%=%=$") or
	msg:find("^5 stacks of |cff71d5ff|Hspell:[%d]+|h[\\[]Sunder Armor]|h|r applied on .+ in .+ sec[!]*$") or
	msg:find("^|cff71d5ff|Hspell:[%d]+|h[\\[]Sunder Armor]|h|r applied on .+ in .+ sec[!]*$") or
	msg:find("^|cff71d5ff|Hspell:[%d]+|h[\\[]Holy Wrath]|h|r Hit [%d]+ targets[!]*$") or
	msg:find("^|cff71d5ff|Hspell:[%d]+|h[\\[]Holy Wrath]|h|r Hit [%d]+ targets[!]* %(.+%)$") or
	msg:find("^Faded: |cff71d5ff|Hspell:[%d]+|h[\\[]Hand of Sacrifice]|h|r$") or
	msg:find("^Activated: |cff71d5ff|Hspell:[%d]+|h[\\[]Hammer of Justice]|h|r on [A-Z][%a]+[!]*$") or
	msg:find("^Activated: |cff71d5ff|Hspell:[%d]+|h[\\[]Hymn of Hope]|h|r[!]*$") or
	msg:find("^Misdirection on [A-Z][%a]+[%s]+[!]+$") or
	msg:find("^|cff71d5ff|Hspell:[%d]+|h[\\[]Dispel Magic]|h|r Removed: |cff71d5ff|Hspell:[%d]+|h[\\[].+]|h|r from me$") or
	msg:find("^Hand of Salvation on [A-Z][%a]+$") or
	msg:find("^Aura Mastery up[!]*$") or
	msg:find("^Come back to life, [A-Z][%a]+$") or

	msg:find("^Casted |cff71d5ff|Hspell:[%d]+|h[\\[]Rebirth]|h|r on [A-Z][%a]+$") or


	msg:find("^Divine Sacrifice up[!]*$") or
	msg:find("^Hand of Sacrifice on [A-Z][%a]+$") or
	msg:find("^Hand of Protection on [A-Z][%a]+$") or
	msg:find("^Hand of Freedom on [A-Z][%a]+$") or
	msg:find("^Lay on Hands on [A-Z][%a]+$") or
	msg:find("^Casted |cff71d5ff|Hspell:[%d]+|h[\\[]Innervate]|h|r on [A-Z][%a]+$") or
	msg:find("^Casted |cff71d5ff|Hspell:[%d]+|h[\\[]Hand of Sacrifice]|h|r on [A-Z][%a]+$") or
	msg:find("^Casted |cff71d5ff|Hspell:[%d]+|h[\\[]Hand of Protection]|h|r on [A-Z][%a]+$") or
	msg:find("^Casted |cff71d5ff|Hspell:[%d]+|h[\\[]Hand of Freedom]|h|r on [A-Z][%a]+$") or
	msg:find("^Casted |cff71d5ff|Hspell:[%d]+|h[\\[]Lay on Hands]|h|r on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Misdirection on[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Misdirection on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Tricks of the Trade on[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Tricks of the Trade on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Misdirection on[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ used Bloodlust$") or
	msg:find("^[A-Z][%a]+ used Commanding Shout$") or
	msg:find("^[A-Z][%a]+ used Aura Mastery$") or
	msg:find("^[A-Z][%a]+ cast Power Infusion on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Innervate on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Hand of Salvation on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Hand of Freedom on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Hand of Protection on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Hysteria on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Pain Suppression on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Pain Suppression on[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ cast Rebirth on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ used Mana Tide Totem$") or
	msg:find("^[A-Z][%a]+ used Divine Hymn$") or
	msg:find("^[A-Z][%a]+ used Army of the Dead$") or
	msg:find("^Misdirected used on [A-Z][%a]+ !!$") or
	msg:find("^%>%>%> Bubblewall is ACTIVE! %<%<%<$") or
	msg:find("^%>%>%> Bubblewall is down%. %<%<%<$") or
	msg:find("^%>%>%> |cff71d5ff|Hspell:[%d]+|h[\\[]Divine Sacrifice]|h|r is ACTIVE!! Please Watch my health! %<%<%<$") or
	msg:find("^%>%>%> Death AVERTED%. Ardent Defender is my hero and healed me for [%d]+%. %<%<%<$") or
	msg:find("^%>%>%> |cff71d5ff|Hspell:[%d]+|h[\\[]Divine Sacrifice]|h|r is down %<%<%<$") or
	msg:find("^[%s]*%=%=[%s]*Divine Sacrifice up for [%d]+[%s]*seconds%. Taking more damage[!]*[%s]*%=%=[%s]*$") or
	msg:find("^[%s]*%=%=[%s]*Divine Sacrice up for [%d]+[%s]*seconds%. Taking more damage[!]*[%s]*%=%=[%s]*$") or
	msg:find("^Divine Sacrifice expires in [%d]+ seconds%.$") or
	msg:find("^[%s]*%=%=[%s]*Divine Sacrifice expired[!]*[%s]*%=%=$") or
	msg:find("^NEED MANA!$") or
	msg:find("^Skin Protect On[%s]*[!]*$") or
	msg:find("^Casted MD$") or
	msg:find("^Innervate on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ use AM with |cff71d5ff|Hspell:[%d]+|h[\\[][%a]+]|h|r$") or
	msg:find("^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a]+]|h|r AM faded$") or
	msg:find("^[A-Z][%a]+ used |cffffffff|Hitem:40211:0:0:0:0:0:0:0:0|h[\\[]Potion of Speed]|h|r$") or
	msg:find("^[A-Z][%a]+ used |cffffffff|Hitem:40212:0:0:0:0:0:0:0:0|h[\\[]Potion of Wild Magic]|h|r$") or
	msg:find("^Health swap: Prince [A-Z][%a]+$") or
	msg:find("^Shock zone: [A-Z][%a]+$") or
	msg:find("^Casting Shock[!]+$") or
	msg:find("^Empowered Flames: [A-Z][%a]+$") or
	msg:find("^Shadows: [A-Z][%a]+$") or
	msg:find("^Delirious Slash: [A-Z][%a]+$") or
	msg:find("^Pact: [A-Z][%a]+, [A-Z][%a]+$") or
	msg:find("^Pact: [A-Z][%a]+, [A-Z][%a]+, [A-Z][%a]+$") or
	msg:find("^Lay Waste$") or
	msg:find("^Blazing Skeleton soon[!]+$") or
	msg:find("^Portals [%d]+ up in [%d]+ sec[!]+$") or
	msg:find("^Portals up[!]+$") or
	msg:find("^ToT UP on me!$") or
	msg:find("^Unchained magic on YOU[!]+$") or
	msg:find("^Explosion[!]+$") or
	msg:find("^Unstable x[%d]+[!]+$") or
	msg:find("^Air Phase[!]+$") or
	msg:find("^Frost Beacon: [A-Z][%a]+, [A-Z][%a]+$") or
	msg:find("^Frost Beacon: [A-Z][%a]+$") or
	msg:find("^Magic x[%d]+[!]+$") or
	msg:find("^Shambling Horror$") or
	msg:find("^Infest$") or
	msg:find("^Necrotic Plague: [A-Z][%a]+$") or
	msg:find("^Enrage$") or
	msg:find("^Remorseless Winter Casting$") or
	msg:find("^Enrage on Shambling Horror$") or
	msg:find("^Raging Spirit on YOU$") or
	msg:find("^Raging Spirit: [A-Z][%a]+$") or
	msg:find("^Quake Casting$") or
	msg:find("^Val'kyr$") or
	msg:find("^Val'kyrs Hugged: [A-Z][%a]+$") or
	msg:find("^Soul Reaper: [A-Z][%a]+$") or
	msg:find("^Defile: [A-Z][%a]+$") or
	msg:find("^Harvet Soul: [A-Z][%a]+$") or
	msg:find("^Vile Spirits$") or
	msg:find("^has cast |cff71d5ff|Hspell:[%d]+|h[\\[]Divine Sacrifice]|h|r$") or
	msg:find("^Casting Bress on [A-Z][%a]+[!]*$") or
	msg:find("^Casting Innervate on [A-Z][%a]+[!]*$") or
	msg:find("^Necrotic Plague on me[%s]*[!]*$") or
	msg:find("^Soulstoning [>]*[%s]*[A-Z][%a]+[%s]*[<]*[%s]*Now[!]*$") or
	msg:find("^Lay on Hands on [A-Z][%a]+ at [%d]+ health%.$") or
	msg:find("^Innervate [Oo]n Holy Pala[!]*%([A-Z][%a]+%)$") or
	msg:find("^Salvation [A-Z][%a]+[!]* ROAR AGGRO[%S]*[:]*[%D]*$") or
	msg:find("^Guardian Spirit up, quit dying you fools$") or
	msg:find("^Malleable goo spawning!$") or
	msg:find("^Choking gas spawning!$") or
	msg:find("^Spirits spawning!$") or
	msg:find("^PainSuppression on [A-Z][%a]+ %(Tank%-Pala%) Please[!]*$") or
	msg:find("^Valkyr Shadowguard grabbed [A-Z][%a]+$") or
	msg:find("^{rt[1,2,3,4,5,6,7,8]}[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+ grabbed[!]*[%s]*{rt[1,2,3,4,5,6,7,8]}$") or
	msg:find("^Using GTS$") or
	msg:find("^Lady on Hans on [A-Z][%a]+ at [%d]+ health%.$") or
	msg:find("^Innervate On Holy Pala![\\[][A-Z][%a]+]$") or
	msg:find("^>> Opening Summoning Portal << Clicky clicky!$") or
	msg:find("^%-%->[%s]*[A-Z][%a]+ is soulstoned![%s]*<%-%-$") or
	msg:find("^Misdirected [A-Z][%a]+$") or
	msg:find("^Why does [A-Z][%a]+ always go afk when soulstoned?[!]+$") or
	msg:find("^All hail to the magic fingers of [A-Z][%a]+[!]+$") or
	msg:find("^Fools! Dont just stand there looking at the portal - click on it so we can summon those scrubs!$") or
	msg:find("^[A-Z][%a]+ casted Hand of Salvation on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ casted Hand of Freedom on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ casted Innervate on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ casted Hand of Protection on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ casted Hand of Sacrifice on [A-Z][%a]+$") or
	msg:find("^[A-Z][%a]+ casted Hand of Freedom on [A-Z][%a]+$") or
	msg:find("^Pain Suppression is up on [A-Z][%a]+$") or
	msg:find("^Misdirection [A-Z][%a]+$") or
	msg:find("^Started to cast |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on [A-Z][%a]+$") or
	msg:find("^Using Divine Hymn$") or
	msg:find("^Using Hymn of Hope$") or
	msg:find("^[A-Z][%a]+ picked up!$") or
	msg:find("^Aura Mastery is down[%s!]*$") or
	msg:find("^Aura Mastery is up[%s!]*$") or
	msg:find("^|cff71d5ff|Hspell:[%d]+|h[\\[]Aura Mastery]|h|r is up[%s!]*$") or
	msg:find("^|cff71d5ff|Hspell:[%d]+|h[\\[]Aura Mastery]|h|r is down[%s!]*$") or
	msg:find("^Valkyr Shadowguard grabbed[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*[A-Z][%a]+$") or
	msg:find("^Valkyr Shadowguard[%s]*{rt[1,2,3,4,5,6,7,8]}[%s]*grabbed [A-Z][%a]+$") or
	msg:find("^Innervate cast on [A-Z][%a]+$") or
	msg:find("^Arcanum Taxi Cab! Please click on the portal so we can get this show on the road%.$") or
	msg:find("^If you click on the portal, we might get this party started a lot quicker!$") or
	msg:find("^Why does [A-Z][%a]+ always go afk when they are soulstoned%?!!!$") or
	msg:find("^[A-Z][%a]+ is casting |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r%. Click!$") or
	msg:find("^Casted |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on [A-Z][%a]+ %([%d\\.]*%% mana%)$") or
	msg:find("^Casted |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on [A-Z][%a]+ %([%d\\.]*%% hp%)$")	) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99907] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99907].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99907].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[CustomMacronWeakaura] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[CustomMacronWeakaura] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[CustomMacronWeakaura] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99907].chan]:AddMessage("FCDCustomMacronWeakaura:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function OptiTauntFilter(self,_,msg,author) if (
	msg:find("^%+%+%+ .+ activated %([%d]+s%)[%s]*%+%+%+$") or
	msg:find("^%-%-%- .+ ends %-%-%-$") or
	msg:find("^Kicked .+ by .* %([%d]+s%)$") or
	msg:find("^%>%>%>.+%([%d]+%s) %- DISPEL[%s]*%<%<%<$") or
	msg:find("^%>%>%>.+ %([%d]+s%) %- STUNNED%<%<%<$") or
	msg:find("^%>%>%>.+ %([%d]+s%) %- ABOLISH DISEASE[%s]*%<%<%<$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99905] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99905].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99905].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[OptiTauntFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[OptiTauntFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[OptiTauntFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99905].chan]:AddMessage("FCDOptiTauntFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function AchivmentFailsFilter(self,_,msg,author) if (msg:find("^{[Ss][Kk][Uu][Ll][LL]}[%s]*|cffffff00|Hachievement.+[%s]*failed!") or
		msg:find("^{rt[1,2,3,4,5,6,7,8]}[%s]*|cffffff00|Hachievement.+[%s]*failed!")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99904] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99904].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99904].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[AchivmentFailsFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[AchivmentFailsFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[AchivmentFailsFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99904].chan]:AddMessage("FCDAchivmentFailsFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function RankWatchFilter(self,_,msg,author) if msg:find("^[\\[]RankWatch[\\]] [A-Z][%a]+ used |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r Rank [%d]+, which is replaced at level [%d]+ by |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r Rank [%d]+%.$") and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99936] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99936].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99936].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RankWatchFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RankWatchFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RankWatchFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99936].chan]:AddMessage("FCDRankWatchFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function OmenFilter(self,_,msg,author) if msg:find("^Passed [%d]+%% of [A-Z][%a]+'s threat!$") and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99931] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99931].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99931].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[OmenFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[OmenFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[OmenFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99931].chan]:AddMessage("FCDOmenFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function InterruptFilter(self,_,msg,author) if msg:find("^Interrupted .+'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r[!]+$") and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99932] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99932].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99932].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[InterruptFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[InterruptFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[InterruptFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99932].chan]:AddMessage("FCDInterruptFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function RaidLootNeed(self,_,msg,author) if (msg:lower():find("[%a]+ has selected need for: ") or msg:lower():find("need roll %- [%d]+ for ")) and UnitInRaid("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99940] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99940].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99940].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidLootNeed] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidLootNeed] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidLootNeed] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99940].chan]:AddMessage("FCDRaidLootNeed:"..msg, 1,0.49,0.04) end return true end end 

function RaidLootGreed(self,_,msg,author) if (msg:lower():find("[%a]+ has selected greed for: ") or msg:lower():find("greed roll %- [%d]+ for ")) and UnitInRaid("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99939] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99939].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99939].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidLootGreed] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidLootGreed] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidLootGreed] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99939].chan]:AddMessage("FCDRaidLootGreed:"..msg, 1,0.49,0.04) end return true end end 

function RaidLootPass(self,_,msg,author) if msg:lower():find("[%a]+ passed on: ") and UnitInRaid("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99942] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99942].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99942].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidLootPass] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidLootPassRaidLootPass] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidLootPass] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99942].chan]:AddMessage("FCDRaidLootPass:"..msg, 1,0.49,0.04) end return true end end 

function RaidLootDE(self,_,msg,author) if (msg:lower():find("[%a]+ has selected disenchant for: ") or msg:lower():find("disenchant roll %- [%d]+ for ")) and UnitInRaid("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99941] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99941].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99941].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidLootDE] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidLootDE] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidLootDE] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99941].chan]:AddMessage("FCDRaidLootDE:"..msg, 1,0.49,0.04) end return true end end 

function RaidPoorLoot(self,_,msg,author) if msg:find("^[A-Z][%a]+ receives loot:[%s]*|cff9d9d9d|Hitem:[%d]+:0:0:0:0:0:0:0:[%d]+|h[\\[].+]|h|r") and UnitInRaid("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99898] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99898].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99898].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidPoorLoot] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidPoorLoot] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RaidPoorLoot] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99898].chan]:AddMessage("FCDRaidLootDE:"..msg, 1,0.49,0.04) end return true end end 

function GLootNeed(self,_,msg,author) if msg:lower():find("need roll %- [%d]+ for ") and not UnitInRaid("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99850] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99850].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99850].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootNeed] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootNeed] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootNeed] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99850].chan]:AddMessage("FCDGLootNeed:"..msg, 1,0.49,0.04) end return true end end 

function GLootGreed(self,_,msg,author) if msg:lower():find("greed roll %- [%d]+ for ") and not UnitInRaid("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99853] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99853].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99853].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootGreed] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootGreed] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootGreed] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99853].chan]:AddMessage("FCDGLootGreed:"..msg, 1,0.49,0.04) end return true end end 

function GLootPass(self,_,msg,author) if msg:lower():find("[%a]+ passed on: ") and not UnitInRaid("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99852] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99852].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99852].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootPass] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootPassGLootPass] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootPass] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99852].chan]:AddMessage("FCDGLootPass:"..msg, 1,0.49,0.04) end return true end end 

function GLootDE(self,_,msg,author) if msg:lower():find("disenchant roll %- [%d]+ for ") and not UnitInRaid("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99851] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99851].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99851].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootDE] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootDE] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootDE] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99851].chan]:AddMessage("FCDGLootDE:"..msg, 1,0.49,0.04) end return true end end 

function GLootPoor(self,_,msg,author) if msg:find("^[A-Z][%a]+ receives loot:[%s]*|cff9d9d9d|Hitem:[%d]+:0:0:0:0:0:0:0:[%d]+|h[\\[].+]|h|r") and not UnitInRaid("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99854] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99854].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99854].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootPoor] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootPoor] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GLootPoor] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99854].chan]:AddMessage("FCDGLootDE:"..msg, 1,0.49,0.04) end return true end end 

function AnnounceFilter(self,_,msg,author) if (
	msg:find("^|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on [A-Z].+!$") or
	msg:find("^Faded: |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r on [A-Z].+!$") or
	msg:find("^|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r!$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99899] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99899].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99899].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[AnnounceFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[AnnounceFilter] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[AnnounceFilter] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99899].chan]:AddMessage("AnnounceFilter:"..msg, 1,0.49,0.04) end return true end end 

function ReadyCheckMessages(self,_,msg,author) if (
	msg:find("^Ready Check: The following players are Away: [A-Z][%a]+") or
	msg:find("^Ready Check: Everyone is Ready$")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99859] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99859].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99859].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ReadyCheckMessages] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ReadyCheckMessages] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ReadyCheckMessages] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99859].chan]:AddMessage("FCDReadyCheckMessages:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end
function IconsSpamPP(self,_,msg,author) if UnitInRaid("player") and UnitAffectingCombat("player") and UnitName("boss1") == "Professor Putricide" then
 if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99873] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99873].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99873].chan > 0 and
 	(FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[IconsSpamPP] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[IconsSpamPP] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[IconsSpamPP] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99873].chan]:AddMessage("FCDIconsSpamPP:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end

function MRTReciveLootSpam(self,_,msg,author) if (
	msg:find("^|cff.+|Hitem:.+|h[\\[].+]|h|r$") or
	msg:find("^|cff.+|Hitem:.+|h[\\[].+]|h|r[%s]*BiS: [A-Z].+%(.+") or
	msg:find("^Not eligible: [A-Z][%a]+")) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99865] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99865].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99865].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[MRTReciveLootSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[MRTReciveLootSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[MRTReciveLootSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99865].chan]:AddMessage("MRTReciveLootSpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end 

function GBuyingSelling(self,_,msg,author) if (
	msg:lower():find("^w[%s]*t[%s]*b[^%a]+") or msg:lower():find("[%s]+w[%s]*t[%s]*b[^%a]+") or
	msg:lower():find("^w[%s]*t[%s]*s[^%a]+") or msg:lower():find("[%s]+w[%s]*t[%s]*s[^%a]+") or
	msg:lower():find("^buy[%s]+") or msg:lower():find("[%s]+buy[%s]+") or
	msg:lower():find("^buying[%s]+") or msg:lower():find("[%s]+buying[%s]+") or
	msg:lower():find("^sell[%s]") or msg:lower():find("[%s]+sell[%s]+") or
	msg:lower():find("^selling[%s]+") or msg:lower():find("[%s]+selling[%s]+") or
	msg:lower():find("^trade[%s]+") or msg:lower():find("[%s]+trade[%s]+") or
	msg:lower():find("^c[\\.]o[\\.]d[%s]+") or msg:lower():find("[%s]+c[\\.]o[\\.]d[%s]+") or
	msg:lower():find("^c[%s]*o[%s]*d[%s]+") or msg:lower():find("[%s]+c[%s]*o[%s]*d[%s]+") or
	msg:lower():find("^lfw[%s]+") or msg:lower():find("[%s]+lfw[%s]+") or
	msg:lower():find("^wtt[%s]+") or msg:lower():find("[%s]+wtt[%s]+") or
	msg:lower():find("^coins[%s]+") or msg:lower():find("[%s]+coins[%s]+") or
	msg:lower():find("^warmane[%s]+market[%s]+") or msg:lower():find("[%s]+warmane[%s]*market[%s]+") or
	msg:lower():find("^warmane[%s]*trade[%s]+") or msg:lower():find("^warmane[%s]*trade[%s]+") or
	msg:lower():find("^for sale") or msg:lower():find("[%s]+for sale[%.]*[%s]+") or

	(msg:lower():find("[%s]+someone[%s]+") and msg:lower():find("[%s]+provide[%s]+") and msg:lower():find("[%s]+supply[%s]+")) or
	(msg:lower():find("[%s]+ah[%s]+") and msg:lower():find("[%s]+cheap[%s]+") and msg:lower():find("[%d]+g")) or
	(msg:lower():find("[%s]+salam[%s]+") and msg:lower():find("[%s]+gold[%s]+")) or
	(msg:lower():find("[%s]+warmane[%s]+") and msg:lower():find("[%s]+character[%s]+") and msg:lower():find("[%s]+sale[%s]+")) or
	(msg:lower():find("[%s]+gold[%s]+") and msg:lower():find("[%s]+trading[%s]+")) or 

	msg:lower():find("^jc[%s]+") or msg:lower():find("[%s]+jc[%s]+") or
	msg:lower():find("^jwc[%s]+") or msg:lower():find("[%s]+jwc[%s]+") or
	msg:lower():find("^bs[%s]+") or msg:lower():find("[%s]+bs[%s]+") or
	msg:lower():find("^lw[%s]+") or msg:lower():find("[%s]+lw[%s]+") or


	((msg:lower():find("alchemy") or
	msg:lower():find("blacksmith") or
	msg:lower():find("enchant") or
	msg:lower():find("inscription") or
	msg:lower():find("scribe") or
	msg:lower():find("jewelcrafting") or
	msg:lower():find("jewelcrafter") or
	msg:lower():find("leatherwork") or
	msg:lower():find("tailor") or
	msg:lower():find("transmu") or
	msg:lower():find("alchemy") or
	msg:lower():find("jeweler"))
	and (msg:lower():find("lf") or msg:lower():find("wtb") or msg:lower():find("any") or msg:lower():find("wts") or msg:lower():find("free") or msg:lower():find("mats"))) 
	
	) and not (
		author == UnitName("player") or
		msg:lower():find("recruit") or
		msg:lower():find("active") or
		msg:lower():find("progress") or
		(msg:lower():find("[^%a]core[^%a]") and not msg:lower():find("wts")) or
		(msg:lower():find("raid") and not (msg:lower():find("mount") or msg:lower():find("raiding achiev") or msg:lower():find("discount") or msg:lower():find("discount") or msg:lower():find("tailor") or
			msg:lower():find("name") or msg:lower():find("warmane trade") or msg:lower():find("for more info") or msg:lower():find("cheap"))) or
		(msg:lower():find("icc") and not (msg:lower():find("patter") or msg:lower():find("boost") or msg:lower():find("selling") or msg:lower():find("trade") or msg:lower():find("trade"))) or
		(msg:lower():find("toc") and not (msg:lower():find("boost"))) or msg:lower():find("naxx") or msg:lower():find("ulduar") or 
		(msg:lower():find("rs") and not (msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]") or msg:lower():find("selling") or msg:lower():find("trade") or msg:lower():find("wts") or msg:lower():find("glory") or (msg:lower():find("warmane") and msg:lower():find("trade")))) )

 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99871] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99871].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99871].chan > 0 and 
 	(FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GBuyingSelling] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GBuyingSelling] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GBuyingSelling] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99871].chan]:AddMessage("FCDGBuyingSelling:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end 

function GArena(self,_,msg,author) if 
  	((msg:lower():find("arena") or
  	msg:lower():find("just the two of us:") or
  	msg:lower():find("[235][']*s") or
  	msg:lower():find("10[%s]*games") or msg:lower():find("ten games") or
  	msg:lower():find("2[%s]*v[%s]*2") or msg:lower():find("3[%s]*v[%s]*3") or msg:lower():find("5[%s]*v[%s]*5") or
  	msg:lower():find("[235]vs") or
  	msg:lower():find("2[%s]*x[%s]*2") or msg:lower():find("3[%s]*x[%s]*3") or msg:lower():find("5[%s]*x[%s]*5")) and

  	(msg:lower():find("lf[m]*[^%a]") or msg:lower():find("partner") or msg:lower():find("team") or msg:lower():find("games") or msg:lower():find("que") or msg:lower():find("join") or msg:lower():find("play 10") or 
  		msg:lower():find("anyone 10") or msg:lower():find("points") or
  	(msg:lower():find("looking for") and msg:lower():find("mate"))))

and not (author == UnitName("player") or msg:lower():find("rep") or msg:lower():find("guild") or msg:lower():find("farm") or msg:lower():find("recruit") or msg:lower():find("active") or
 msg:lower():find("core") or msg:lower():find("raid") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or msg:lower():find("quest") or msg:lower():find("help") or
 msg:lower():find("drak") or msg:lower():find("icc") or msg:lower():find("toc") or msg:lower():find("voa") or msg:lower():find("nax[x]*") or msg:lower():find("ulduar") or 
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))))

 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99870] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99870].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99870].chan > 0 and 
 	(FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GArena] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GArena] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GArena] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99870].chan]:AddMessage("FCDGArena:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end 

function GGuild(self,_,msg,author) if 
	 (	(msg:lower():find("guild") and
		  			not ((msg:lower():find("[%a]run") and msg:lower():find("run[%a]")) or
		  					  		 	msg:lower():find("semi") or
		  					  		 	msg:lower():find("run") or
		  								msg:lower():find("carrying") or
		  								msg:lower():find("lfm")) ) or

	
	((msg:lower():find("recruit") or msg:lower():find("recrut") or msg:lower():find("active") or msg:lower():find("endgame") or msg:lower():find("high-end") or msg:lower():find("premades") or msg:lower():find("tournaments") or msg:lower():find("socialable community") or
	msg:lower():find("core") or msg:lower():find("looking for") or msg:lower():find("progres") or msg:lower():find("shivtr") or msg:lower():find("search") or msg:lower():find("hardcore")) and

	((msg:lower():find("player") and (not(msg:lower():find("10 player") or msg:lower():find("25 player"))) ) or msg:lower():find("server time") or msg:lower():find("pm for info") or msg:lower():find("raiders") or
	(msg:lower():find("raid") and (msg:lower():find("time") or msg:lower():find("day") )) or msg:lower():find("dkp") or msg:lower():find("expirenced") or msg:lower():find("for more info") or msg:lower():find("apply") or
	 msg:lower():find("twink") or msg:lower():find("members") or msg:lower():find("raids") or msg:lower():find("endgame content") or msg:lower():find("join") or msg:lower():find("time zone") or
	 msg:lower():find("newly formed") or msg:lower():find("rebuild") or msg:lower():find("application") or msg:lower():find("rebuild") or msg:lower():find("rebuild") or msg:lower():find("fill ranks") or
	 (msg:lower():find("[\\<][%a]+[\\>]") and msg:lower():find("[^%a]rs[^%a]") and msg:lower():find("icc") ) or
	 (msg:lower():find("[^%a]st[^%a]") and (msg:lower():find("info") or msg:lower():find("apply"))) )) or

		  		(msg:lower():find("[^%a]rs[^%a]") and (msg:lower():find("icc") or msg:lower():find("lod")) and ((msg:lower():find("togc") or msg:lower():find("progres")) or msg:lower():find("recrut") or msg:lower():find("progres")) and msg:lower():find("[\\>]")
		  			and msg:lower():find("[\\<]")) or

		  		(msg:lower():find("[\\>]") and msg:lower():find("[\\<]") and
		  			(msg:lower():find("recruit") or msg:lower():find("roster") or msg:lower():find("guild") or msg:lower():find("dkp")) and
		  				(msg:lower():find("team") or msg:lower():find("participate") or
				 msg:lower():find("raid") or msg:lower():find("players") or msg:lower():find("attitude") or msg:lower():find("dedicated") or msg:lower():find("active players") or
				 msg:lower():find("community") or msg:lower():find("end.game") or msg:lower():find("apply") or msg:lower():find("content cleared") or msg:lower():find("exceptional") or
				 msg:lower():find("class") or msg:lower():find("apply") or msg:lower():find("shivtr") or msg:lower():find("application") or msg:lower():find("roster") or
		  		 msg:lower():find("fill") or msg:lower():find("international") or msg:lower():find("more info") or msg:lower():find("experience") or msg:lower():find("premade") or
		  		 msg:lower():find("premade") or msg:lower():find("seeking") or msg:lower():find("participate") or msg:lower():find("tournament") )) or

		  		(msg:lower():find("bane") and msg:lower():find("lod") and msg:lower():find("raid time") and msg:lower():find("whisper for more info") and msg:lower():find("week")
		  		and msg:lower():find("recru") and msg:lower():find("icc") and msg:lower():find("[^%a]st[^%a]"))

	  )

 and (not (author == UnitName("player") or msg:lower():find("[%s]pug[%s]") or msg:lower():find("twitch") or msg:lower():find("selling") or msg:lower():find("[%s]wts[%s]") or msg:lower():find("endgame discord") or 
 	(msg:lower():find("mee6") and msg:lower():find("rank"))))
 
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99869] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99869].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99869].chan > 0 and 
 	(FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GGuild] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GGuild] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GGuild] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99869].chan]:AddMessage("FCDGGuild:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end 

function GNoneEnglish(self,_,msg,author) if
  (msg:lower():find("recluta") or msg:lower():find("hispana") or msg:lower():find("menkam") or msg:lower():find("para[^%a]") or msg:lower():find("pozdrav") or msg:lower():find("ima neko") or 
  	msg:lower():find("aktywnych") or msg:lower():find("regrutuje") or msg:lower():find("trazimo") or msg:lower():find("hispana") or msg:lower():find("busca") or msg:lower():find("deutschsprachige") or
  	msg:lower():find("busca") or msg:lower():find("gild") or msg:lower():find("trazi") or msg:lower():find("rajdovanje") or msg:lower():find("hermandad") or msg:lower():find("hermandad") or msg:lower():find("hermandad") or
  	msg:lower():find("nabira") or msg:lower():find("nabira") or msg:lower():find("recetu") or msg:lower():find("drugo") or msg:lower():find("iztropash") or	msg:lower():find("polskiej") or msg:lower():find("spremne") or
  	msg:lower():find("igrace") or msg:lower():find("druzenje") or msg:lower():find("saberi") or msg:lower():find("deutsche") or msg:lower():find("gildii") or msg:lower():find("polskiej") or msg:lower():find("rekrutuje") or
  	msg:lower():find("rekrutuje") or msg:lower():find("recruteaza") or msg:lower():find("recruteaza") or msg:lower():find("otvoren") or msg:lower():find("bulgari") or msg:lower():find("popalneniq") or
  	msg:lower():find("requisitos") or msg:lower():find("abre") or msg:lower():find("potrebno") or msg:lower():find("anazitaei") or msg:lower():find("etsii") or msg:lower():find("ﾃ") or
  	msg:lower():find("QuÃ") or msg:lower():find("francais") or msg:lower():find("jouer") or msg:lower():find("nous") or msg:lower():find("vivre") or msg:lower():find("d'Ãªtre") or 
  	msg:lower():find("actifs") or msg:lower():find("grossir") or msg:lower():find("bienvenue") or msg:lower():find("heures") or msg:lower():find("psaxoun") or msg:lower():find("gnorizoun") or 
	msg:lower():find("kvalitna") or msg:lower():find("skusenostami")or msg:lower():find("bienvenido")or msg:lower():find("rendimiento")or msg:lower():find("aspiramos") or
	msg:lower():find("Igrachi") or msg:lower():find("vsqkakvi") or msg:lower():find("Vsqka vecher") or msg:lower():find("shte raidvat") or msg:lower():find("raidovete") or
	msg:lower():find("vsqka vecher") or msg:lower():find("poveche") or msg:lower():find("tursi") or msg:lower():find("poszukuje") or msg:lower():find("rajdowania") or
	msg:lower():find("graczy") or msg:lower():find("bulgarsko vreme") or msg:lower():find("pravilata") or msg:lower():find("izpolzvame") or
	msg:lower():find("grupata") or msg:lower():find("activni") or msg:lower():find("umeniq") or msg:lower():find("afin de") or msg:lower():find("un esprit") or
	msg:lower():find("formarea") or msg:lower():find("interesati") or  msg:lower():find("mambri romani") or msg:lower():find("zdravei") or  msg:lower():find("popitam") or
	msg:lower():find("postoqnno") or  msg:lower():find("choveka") or msg:lower():find("naujai iskepta") or  msg:lower():find("pagrindu") or msg:lower():find("naudojame") or
	msg:lower():find("recrutando") or msg:lower():find("perspectiva") or  msg:lower():find("crescimento") or msg:lower():find("kardan") or  msg:lower():find("mipazird") or
	msg:lower():find("marre des") or  msg:lower():find("requis mini") or msg:lower():find("recrute pour") or  msg:lower():find("irani zire") or msg:lower():find("irani foroshe") or
	msg:lower():find("tedad balaye") or msg:lower():find("aktive") or msg:lower():find("ligegyldigt") or msg:lower():find("aftales efter") or msg:lower():find("mikham") or
	msg:lower():find("zmoniu") or msg:lower():find("mipazire") or msg:lower():find("mozda") or msg:lower():find("igra") or msg:lower():find("nejaka") or
	msg:lower():find("bacheha ahvaz") or msg:lower():find("mitonan ro") or msg:lower():find("moamele") or msg:lower():find("mifrosham") or msg:lower():find("tedadi") or
	msg:lower():find("Irani taze") or msg:lower():find("niyaze") or msg:lower():find("bara raida") or msg:lower():find("seriozni") or msg:lower():find("igrachi") or 
	msg:lower():find("nabera") or msg:lower():find("hracov") or msg:lower():find("pripadne") or msg:lower():find("jugadores") or msg:lower():find("quieran") or 
	msg:lower():find("divertir") or msg:lower():find("diario") or msg:lower():find("comunidad") or msg:lower():find("tambien") or msg:lower():find("te dejan") or 
	msg:lower():find("pasarla bien") or msg:lower():find("altos de") or msg:lower():find("recherche") or msg:lower():find("wszystkich") or msg:lower():find("oferujemy") or
	msg:lower():find("alguien") or msg:lower():find("le anda el") or msg:lower():find("tirate") or msg:lower():find("thuong xuyen") or msg:lower():find("hermanda") or 
	msg:lower():find("mikharam") or msg:lower():find("daashtid") or msg:lower():find("har meghdar") or msg:lower():find("Bache haye") or 
	msg:lower():find("guildimiz") or msg:lower():find("oyundan") or msg:lower():find("keyif almak") or msg:lower():find("olusturmak") or msg:lower():find("cumartesi") or
	msg:lower():find("froosh dare") or msg:lower():find("tawh phot") or msg:lower():find("thin tel") or msg:lower():find("minlo be don") or msg:lower():find("iskljucivo") or
	msg:lower():find("harkasi coin") or msg:lower():find("putem banke") or msg:lower():find("butun turk") or msg:lower():find("gheyre hozori") or msg:lower():find("gnadenlos") or
	msg:lower():find("weniger member") or msg:lower():find("wieviel") or msg:lower():find("wie seht ihr") or msg:lower():find("sorat hozori") or msg:lower():find("hier wirklich") or 
	msg:lower():find("balkanski guild") or msg:lower():find("nove clanove") or msg:lower():find("sada radimo") or msg:lower():find("runove u planu") or msg:lower():find("informacije") or
	msg:lower():find("druzeljubivi") or msg:lower():find("opusteni") or msg:lower():find("irani harki") or msg:lower():find("bara forosh") or 
	msg:lower():find("gelimekte") or msg:lower():find("oyuncular") or  msg:lower():find("kharidaram") or msg:lower():find("meghdar") or  msg:lower():find("bala darid") or
	msg:lower():find("forshande") or msg:lower():find("irani") or msg:lower():find("mipazitad") or msg:lower():find("az zohr") or msg:lower():find("forshande") or msg:lower():find("foroshi") or
	msg:lower():find("daram kasi") or msg:lower():find("mikhad") or msg:find("CZ/SK") or msg:lower():find("recluto") or msg:lower():find("quiera") or msg:lower():find("estar") or
	msg:lower():find("un buen") or  msg:lower():find("romani") or  msg:lower():find("care vor sa") or  msg:lower():find("facem impreuna") or  msg:lower():find("am un grup ") or
	msg:lower():find("prieteni") or msg:lower():find("te adaug") or  msg:lower():find("daca vrei sa") or msg:lower():find("parte din echipa") or msg:lower():find("cand facem") or
	msg:lower():find("algo asi") or msg:lower():find("vrushta ") or  msg:lower():find("otnovo") or msg:lower():find("pauza") or msg:lower():find("populneniq") or
	msg:lower():find("mastome") or msg:lower():find("jau apie") or  msg:lower():find("praleisti") or msg:lower():find("padaryti") or msg:lower():find("galetume") or
	msg:lower():find("zaideju") or msg:lower():find("ieskom") or  msg:lower():find("sveiki") or msg:lower():find("el pala") or msg:lower():find("donde esta") or
	msg:lower():find("bishtar") or msg:lower():find("baraye") or  msg:lower():find("etela'at") or msg:lower():find("och en") or msg:lower():find("samma konto") or
	msg:lower():find("intresse att") or msg:lower():find("winrakom") or msg:lower():find("madouna") or msg:lower():find("mot swish") or msg:lower():find("hunt och") or
	msg:lower():find("vers le bas") or msg:lower():find("kasi pala") or msg:lower():find("vase forosh") or msg:lower():find("glisser") or msg:lower():find("la barre de ") or
	msg:lower():find("appuyez sur la") or msg:lower():find("Appuyez") or msg:lower():find("bulgarski") or msg:lower():find("lqtnata") or msg:lower():find("subira novi") or
	msg:lower():find("predstoqshtiqt") or msg:lower():find("sedmica") or msg:lower():find("fundada por ") or msg:lower():find("experimentados") or msg:lower():find("reclutarte") or 
	msg:lower():find("nuestro") or msg:lower():find("para mas info") or msg:lower():find("herb alch gia ") or msg:lower():find("gia prwth ") or
	msg:lower():find("donde se") or msg:lower():find("plata aca") or msg:lower():find("joueurs") or msg:lower():find("francophones") or msg:lower():find("faire du") or
	msg:lower():find("dans la bonne") or msg:lower():find("ambiance et") or msg:lower():find("froshi pol ") or msg:lower():find("lazemam") or msg:lower():find("kasi niaz") or
	msg:lower():find("dasht w ") or  msg:lower():find("bde merci") or  msg:lower():find("kasi niaz") or msg:lower():find("hoy estamos ") or  msg:lower():find("haciendo") or
	msg:lower():find("historia los") or msg:lower():find("los lations") or  msg:lower():find("guilds latinas") or msg:lower():find("modo de ") or msg:lower():find("las mejores") or
	msg:lower():find("entre las ") or msg:lower():find("mllka egw ") or msg:lower():find("pote kasana ") or msg:lower():find("alch na deis") or msg:lower():find("afta ta ") or
	msg:lower():find("ton ekana") or msg:lower():find("esti roman") or msg:lower():find("roman si ") or msg:lower():find(" si cauti ") or msg:lower():find("si iti voi da") or
	msg:lower():find("orice fel de") or msg:lower():find("de gs sau lvl") or  msg:lower():find("asteptam cu bratele") or msg:lower():find("bratele deschise") or
	msg:lower():find("cauta playeri") or msg:lower():find("doresti sa vii") or msg:lower():find("aceasta guilda") or msg:lower():find("asteptam pe toti") or
	msg:lower():find("bara aktivni") or msg:lower():find("clenovi") or msg:lower():find("posiroko") or msg:lower():find("makedoncite") or msg:lower():find("osloboduvanje na") or
	msg:lower():find("dedicados a raidar") or msg:lower():find("estamos em") or msg:lower():find("horario de") or msg:lower():find("priridade") or msg:lower():find("venha fazer") or
	msg:lower():find("parte desta") or msg:lower():find("campeo de allis") or msg:lower():find("buenas amigos") or msg:lower():find("y amigas si") or msg:lower():find("quieres consequir") or
	msg:lower():find("oro de manera") or msg:lower():find("segura y casi") or msg:lower():find("regalados") or msg:lower():find("escribirme") or msg:lower():find("preguntar") or
	msg:lower():find("es mayuscula y") or msg:lower():find("que tengas un") or msg:lower():find("harki khast") or msg:lower():find("wiss me ya ba") or msg:lower():find("verebilecek") or
	msg:lower():find("oldum da train") or msg:lower():find("vendo esta") or msg:lower():find("cuenta con") or msg:lower():find("las clases") or msg:lower():find("encima de los") or
	msg:lower():find("ako chetesh") or msg:lower():find("tva da si") or msg:lower():find("znaesh") or msg:lower():find("da q porqt") or msg:lower():find("mrasni ciganeta") or
	msg:lower():find("brat da ti") or msg:lower():find("napravqt") or msg:lower():find("sled vreme") or msg:lower():find("da ti go") or msg:lower():find("buta mejdu") or
	msg:lower():find("nou care") or msg:lower():find("dorests sa") or msg:lower():find("formeze un") or msg:lower():find("de jucatori") or msg:lower():find("cu bun simt") or
	msg:lower():find("SALAM be dostan") or msg:lower():find("be dostan") or msg:lower():find("dostan iran") or msg:lower():find("coin bra frosh") or msg:lower():find("darm kasi khast") or
	msg:lower():find("ako je moguce") or msg:lower():find("srpski ako je") or msg:lower():find("si conoceras ") or msg:lower():find("el hueso de") or msg:lower():find("tuetano vos") or
	msg:lower():find("vos putaso") or msg:lower():find("no lo conozco") or msg:lower():find("pero se que") or msg:lower():find("te va doler") or msg:lower():find("brasileira") or
	msg:lower():find("necesito") or msg:lower():find("estamos con") or msg:lower():find("nadie maaaas") or msg:lower():find("siempre el mejor") or msg:lower():find("tengo que ser") or
	msg:lower():find("Hlada aktivnych") or msg:lower():find("ludi na doplnenie") or msg:lower():find("partia ludi chodime") or msg:lower():find("slabsich ludi") or
	msg:lower():find("molis ftiaxtike") or msg:lower():find("theloyme olous gia") or msg:lower():find("pve kai gia ") or msg:lower():find("kai greeklish gia") or msg:lower():find("doostan coin ") or
	msg:lower():find("coin kharidarim") or msg:lower():find("age mayel boodin") or msg:lower():find("solo gente") or msg:lower():find("vyzna tady na") or msg:lower():find("tady na serveru") or
	msg:lower():find("el nombre") or msg:lower():find("je tu nekdo") or msg:lower():find("alimlarimiz devam") or msg:lower():find("devam ediyor") or msg:lower():find("runlarimiza") or
	msg:lower():find("raideri ot ") or msg:lower():find("almak için") or msg:lower():find("atabilirsiniz") or msg:lower():find("ve bilgi almak") or msg:lower():find("katilmak") or
	msg:lower():find("tursqt") or msg:lower():find("hora za") or msg:lower():find("zaduljitelen") or msg:lower():find("salam doostan") or msg:lower():find("age mayel hastin") or
	msg:lower():find("bekharin") or msg:lower():find("motmean") or msg:lower():find("dostan iran") or msg:lower():find("zaprasza w szeregi") or msg:lower():find("szeregi wszytkich") or
	msg:lower():find("tylko u nas ") or msg:lower():find("kowid hiv oraz") or msg:lower():find("na uslugi na") or msg:lower():find("darmowy kowid") or msg:lower():find("avaz mikone") or
	msg:lower():find("avaz mikonam kasi") or msg:lower():find("daram ba ") or msg:lower():find(" louk avaz ") or msg:lower():find("recrute tout ") or msg:lower():find("de joueur mais ") or
	msg:lower():find("essentiellement du gros") or msg:lower():find("finaliser son roster") or msg:lower():find("hai kadishtu ") or msg:lower():find("aramakdayiz") or msg:lower():find("icin yeni ") or
	msg:lower():find("arkadaslar ") or msg:lower():find("sarttir") or msg:lower():find("amaclida aramiza ") or msg:lower():find("katilabilirsiniz") or msg:lower():find("stana resnaha") or
	msg:lower():find("kakvo stana") or msg:lower():find("una femilia") or msg:lower():find("que tiene") or msg:lower():find("muchas ganas de") or msg:lower():find("ctngo unico") or
	msg:lower():find("es ser activo") or

msg:find("[\227-\237]") or

  	msg:lower():find("락") or msg:lower():find("Ã") or msg:lower():find("¤") or msg:lower():find("ﾃ") or msg:lower():find("ｩ") or msg:lower():find("mardi") or
  	msg:find("я") or msg:find("набег") or msg:find("й") or msg:find("ц") or msg:find("бак") or msg:find("п") or msg:find("П") or msg:find("наем") or msg:find("Б") or
  	msg:find("И") or msg:find("Л") or msg:find("и") or msg:find("ф") or msg:find("ж") or msg:find("л") or msg:find("щ") or msg:find("ч") or msg:find("д") or msg:find("Ä") or
  	msg:find("Ã") or msg:find("¥") or msg:find("¤") or msg:find("nqkoi") or msg:find("°") or msg:find("œ") or msg:find("ö") or msg:find("诶") or
  	msg:find("比") or msg:find("伊") or msg:find("哦") or msg:find("提") or msg:find("维") or msg:find("开") or msg:find("ē") or msg:find("à") or msg:find("ú") or
  	msg:find("ㄱ") or msg:find("ㄷ") or msg:find("ㅂ") or msg:find("ㅅ") or msg:find("ㅈ") or msg:find("ㅊ") or msg:find("ㅃ") or msg:find("ㅟ") or msg:find("ㅎ") or
  	msg:find("Č") or msg:find("č") or msg:find("É") or msg:find("é ") or msg:find("ě") or msg:find("š") or msg:find("ň") or  msg:find("İ") or msg:find("ş") or msg:find("동") or
  	msg:find("업") or msg:find("조") or msg:find("합") or msg:find("원") or msg:find("다") or msg:find("한") or msg:find("습") or msg:find("격") or msg:find("을") or msg:find("많") or
  	msg:find("은") or msg:find("더") or msg:find("모") or msg:find("집") or msg:find("ñ") or msg:find("Ñ") or msg:find("公") or msg:find("会") or msg:find("正") or msg:find("在") or
  	msg:find("寻") or msg:find("找") or msg:find("更") or msg:find("多") or msg:find("的") or msg:find("袭") or msg:find("會") or msg:find("尋") or msg:find("突") or
  	msg:find("и") or msg:find("Г") or msg:find("ь") or msg:find("щ") or msg:find("Щ") or msg:find("Б") or msg:find("Л") or msg:find("Д") or msg:find("б") or msg:find("э") or msg:find("ю") or 
  	msg:find("人") or msg:find("英") or msg:find("雄") or msg:find("霜") or msg:find("冻") or msg:find("大") or msg:find("厅") or msg:find("凍") or msg:find("廳") or msg:find("襲") or
  	msg:find("祖") or msg:find("曼") or msg:find("阿") or msg:lower():find("á") or msg:find("太") or msg:find("阳") or msg:find("井") or msg:lower():find("之") or msg:lower():find("ä"))
  	and not (author == UnitName("player"))
 
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99868] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99868].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99868].chan > 0 and 
 	(FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GNoneEnglish] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GNoneEnglish] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GNoneEnglish] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99868].chan]:AddMessage("FCDGNoneEnglish:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end 

function GSpam(self,_,msg,author) if
((msg:lower():find("anal") or msg:lower():find("flashbang") or msg:lower():find("blessed blade of the windseeker") or msg:lower():find("^[f]+$") or msg:lower():find("youtube") or
 	 msg:lower():find("twitch") or msg:lower():find("stream") or msg:lower():find("^lfg[%s]+") or msg:lower():find("[%s]+lfg[%s]+") or msg:lower():find("ninja") or msg:lower():find("scammer") or msg:lower():find("scamer") or
 	 (msg:lower():find("discord") and msg:lower():find("live") and msg:lower():find("run") and msg:lower():find("[\\.]gg")) or
  	 		(msg:lower():find("bugtracker") and (msg:lower():find("vote") or msg:lower():find("report")) ) or
 	 		((msg:lower():find("bg") or msg:lower():find("battleground") or msg:lower():find("battle ground")) and msg:lower():find("twink")) or
			(msg:lower():find("summon") and msg:lower():find("anzu")) or
			(msg:lower():find("portal") and (msg:lower():find("lf") or msg:lower():find("wtb") or msg:lower():find("free") or msg:lower():find("wts") or msg:lower():find("looking for") )) or
			(msg:lower():find("mage") and msg:lower():find("tp") and (msg:lower():find("dala") or msg:lower():find("darnassus") )) or

	 (msg:lower():find("dungeon") or msg:lower():find("rdf") or msg:lower():find("rhc")) and ((msg:lower():find("join") or msg:lower():find("tank") or msg:lower():find("que") or msg:lower():find("need"))
   and not (msg:lower():find("guild") or msg:lower():find("icc") or msg:lower():find("ranks") or msg:lower():find("fresh") ) ) or

	 (msg:lower():find("^[\\[]") and msg:lower():find("[\\]]$") and msg:lower():find("youtube.com")) or (msg:lower():find("^[@]+") and msg:lower():find("[@]+$"))	  )

and (not (author == UnitName("player")  or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("wts") or msg:lower():find("wtb") ))) 
 
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99867] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99867].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99867].chan > 0 and 
 	(FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99867].chan]:AddMessage("FCDGSpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end 

function GTmog(self,_,msg,author) if 
 (((msg:lower():find("transmogs") or msg:lower():find("tmog") or msg:lower():find("xmoug") or msg:lower():find("molten core") or msg:lower():find("karzahan") or 
  msg:lower():find("t-mog") or msg:lower():find("xmog") or msg:lower():find("tranmog") or msg:lower():find("black temple") or msg:lower():find("karazhan") or
  msg:lower():find("blackwing lair") or msg:lower():find("sunwell plat") or msg:lower():find("serpentshrine cavern") or msg:lower():find("tempest keep") or
  msg:lower():find("gruul's lair") or msg:lower():find("magtheridon's lair") or msg:lower():find("scc") or msg:lower():find("hyjal")) 

  	and  ( msg:lower():find("mount hyjal") or (not (msg:lower():find("mount")) or msg:lower():find("mount ress"))) )

  and (not (author == UnitName("player") or msg:lower():find("icc") or msg:lower():find("[^%a]rs[^%a]") or msg:lower():find("togc") or msg:lower():find("toc") or msg:lower():find("guild") or
   msg:lower():find("title") or msg:lower():find("nax[x]*") or msg:lower():find("[^%a]name[^%a]") or msg:lower():find("[^%a]duelist[^%a]") or msg:lower():find("[^%a]shadowmourne[^%a]") or
   msg:lower():find("[^%a]profs[^%a]") or
   (msg:lower():find("[^%a]bis[^%a]") and msg:lower():find("[^%a]pala[^%a]")) or
   (msg:lower():find("[\\?]$") and msg:lower():find("can") or msg:lower():find("any") and not (msg:lower():find("xmog") or msg:lower():find("reserved"))  ) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99866] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99866].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99866].chan > 0 and 
 	(FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GTmog] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GTmog] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GTmog] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99866].chan]:AddMessage("FCDGTmog:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end 

function EnsidiaFailsSpam(self,_,msg,author) if (
	msg:find("^[A-Z][%a]+ failed [%d]+x %([%d]+x %(.+%)") or
	msg:find("^[%-]+")
	) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99862] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99862].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99862].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[EnsidiaFailsSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[EnsidiaFailsSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[EnsidiaFailsSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99862].chan]:AddMessage("EnsidiaFailsSpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end 

function DoTimerSpam(self,_,msg,author) if (
	msg:find("^My cooldown on .+ will finish in [%d]+[%.]*[%d]*s%.$") or
	msg:find("^My cooldown on .+ will finish in [%d]+[%.]*[%d]*m%.$") or
	msg:find("^My .+ on .+ will expire in [%d]+[%.]*[%d]*m%.$") or
	msg:find("^My .+ on .+ will expire in [%d]+[%.]*[%d]*s%.$") 
	) and author ~= UnitName("player") then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99861] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99861].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99861].chan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[DoTimerSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[DoTimerSpam] ~= msg) then
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[DoTimerSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99861].chan]:AddMessage("DoTimerSpam:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end return true end end 

function GoldRaidMessage(self,_,msg,author)
	if UnitInRaid("player") and msg:find("^Your share of the loot is ") and (msg:find("Gold") or msg:find("Silver") or msg:find("Copper")) then
		if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99849] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99849].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99849].chan > 0 and
			(FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GoldRaidMessage] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GoldRaidMessage] ~= msg) then
				FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GoldRaidMessage] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99849].chan]:AddMessage("GoldRaid:"..msg, 1,0.49,0.04)
		end
		return true
	end
end 

function GoldPartyMessage(self,_,msg,author)
	if not UnitInRaid("player") and msg:find("^Your share of the loot is ") and (msg:find("Gold") or msg:find("Silver") or msg:find("Copper")) then
		if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99855] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99855].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99855].chan > 0 and
			(FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GoldPartyMessage] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GoldPartyMessage] ~= msg) then
				FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[GoldPartyMessage] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99855].chan]:AddMessage("GoldParty:"..msg, 1,0.49,0.04)
		end
		return true
	end
end 

function TrainerSpam(self,_,msg,author)
	if msg:find("You have learned a new spell:") or msg:find("You have learned a new ability:") then
		local RankID = select(3,strfind(msg, "Rank (%d+)"))
		if RankID ~= nil and RankID ~= "1" then 
			if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99860] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99860].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99860].chan > 0 and
				(FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TrainerSpam] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TrainerSpam] ~= msg) then
					FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TrainerSpam] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99860].chan]:AddMessage("TrainerSpam:"..msg, 1,0.49,0.04)
			end
			return true
		end
	end
end 

function AlreadyStartedRaids(self,_,msg,author) if
    ((((msg:lower():find("@") and (not(msg:lower():find("@[%s]*vh") or msg:lower():find("@[%s]*memo"))))  or
   (msg:lower():find("[^%a]at[^%a]") and (not(msg:lower():find("at vh") or msg:lower():find("at memo")))) or
   msg:lower():find("front of") or
   msg:lower():find("[^%a]on[^%a]") or
   (msg:lower():find("replace") and (msg:lower():find("dc") or msg:lower():find("offline")) ) ) and
    ((msg:lower():find("pp") and (not(msg:lower():find("[%a]pp") or msg:lower():find("pp[%a]") ))) or
    msg:lower():find("bql") or msg:lower():find("bpc") or msg:lower():find("rotface") or msg:lower():find("fester") or msg:lower():find("putri") or
    msg:lower():find("dream[%s]*walker") or msg:lower():find("valithria") or msg:lower():find("sindra") or msg:lower():find("twins") or msg:lower():find("dbs") or
    msg:lower():find("@blood") or msg:lower():find("saurf") or msg:lower():find("lady") or msg:lower():find("proffessor") or msg:lower():find("plague") or
    msg:lower():find("deathbring") or msg:lower():find("vdw") or msg:lower():find("gunsh") or msg:lower():find("sindy") or 
    (msg:lower():find("rot") and (not(msg:lower():find("[%a]rot") or msg:lower():find("rot[%a]") ))) or
    msg:lower():find("council") or msg:lower():find("sindi") or msg:lower():find("surfang") or msg:lower():find("prince") or msg:lower():find("queen") or msg:lower():find("synd")


  ) and (not (author == UnitName("player") or (msg:lower():find("farm") and not msg:lower():find("eof")) or msg:lower():find("fresh") or  msg:lower():find("recruit") or
   msg:lower():find("active") or msg:lower():find("core") or msg:lower():find("raiding") or msg:lower():find("progress") or
   msg:lower():find("wts") or msg:lower():find("wtb")))))

 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99670] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99670].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99670].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[AlreadyStartedRaids] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[AlreadyStartedRaids] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[AlreadyStartedRaids] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99670].chan]:AddMessage("FCDAlreadyStartedRaids:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function ICC10LowGS(self,_,msg,author) if
    ((
(msg:lower():find("icc[%s]*10") or msg:lower():find("10[%s]*icc")) and

   (msg:lower():find("[^\\.\\,]5k[^789]") or msg:lower():find("5[\\,\\.]1") or msg:lower():find("5[\\,\\.]2") or msg:lower():find("5[\\,\\.]3") or msg:lower():find("5[\\,\\.]4") or msg:lower():find("5[\\,\\.]0") or
    msg:lower():find("5[\\,\\.]5") or msg:lower():find("5[\\,\\.]6") or msg:lower():find("4[\\,\\.]9") or msg:lower():find("4[\\,\\.]8") or msg:lower():find("4[\\,\\.]7") or msg:lower():find("4[\\,\\.]6") or msg:lower():find("4[\\,\\.]5") or 
    msg:lower():find("[5][0123456][0][0]")  ) )

and (not (author == UnitName("player")  or msg:lower():find("[^%a]rep[^%a]") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or

 msg:lower():find("togc") or msg:lower():find("toc") or msg:lower():find("icc[%s]*25") or msg:lower():find("naxx") or msg:lower():find("ulduar") or msg:lower():find("glory") or
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99671] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99671].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99671].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICC10LowGS] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICC10LowGS] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICC10LowGS] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99671].chan]:AddMessage("FCDICC10LowGS:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function ICC10HighGS(self,_,msg,author) if
    ((
(msg:lower():find("icc[%s]*10") or msg:lower():find("10[%s]*icc")) and
   (msg:lower():find("5[\\,\\.][789]") or msg:lower():find("[^\\.\\,]6k") or msg:lower():find("6[\\,\\.][0123456]") or
    msg:lower():find("[5][789][0][0]") or msg:lower():find("[6][0123456][0][0]") ) )

and (not (author == UnitName("player") or msg:lower():find("[^%a]rep[^%a]") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or

 msg:lower():find("togc") or msg:lower():find("toc") or msg:lower():find("icc[%s]*25") or msg:lower():find("naxx") or msg:lower():find("ulduar") or msg:lower():find("glory") or
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99672] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99672].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99672].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICC10HighGS] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICC10HighGS] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICC10HighGS] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99672].chan]:AddMessage("FCDICC10HighGS:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function ICC25LowGS(self,_,msg,author) if
    ((
(msg:lower():find("icc[%s]*25") or msg:lower():find("25[%s]*icc")) and

   (msg:lower():find("4[\\,\\.]8") or msg:lower():find("4[\\,\\.]9") or msg:lower():find("[^\\.\\,]5k[^789]") or msg:lower():find("5[\\,\\.]1") or msg:lower():find("5[\\,\\.]2") or
   msg:lower():find("5[\\,\\.]3") or msg:lower():find("5[\\,\\.]4") or msg:lower():find("5[\\,\\.]5") or msg:lower():find("5[\\,\\.]6") or msg:lower():find("4[\\,\\.]7") or msg:lower():find("4[\\,\\.]6") or msg:lower():find("4[\\,\\.]5") or
    msg:lower():find("[5][0123456][0][0]")  ))
  
and (not (author == UnitName("player") or msg:lower():find("[^%a]rep[^%a]") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or

 msg:lower():find("togc") or msg:lower():find("toc") or msg:lower():find("icc[%s]*10") or msg:lower():find("naxx") or msg:lower():find("ulduar") or msg:lower():find("glory") or
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99673] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99673].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99673].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICC25LowGS] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICC25LowGS] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICC25LowGS] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99673].chan]:AddMessage("FCDICC25LowGS:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function ICC25HighGS(self,_,msg,author) if
    ((
(msg:lower():find("icc[%s]*25") or msg:lower():find("25[%s]*icc")) and
   (msg:lower():find("5[\\,\\.][789]") or msg:lower():find("[^\\.\\,]6k") or msg:lower():find("6[\\,\\.][0123456]") or
    msg:lower():find("[5][789][0][0]") or msg:lower():find("[6][0123456][0][0]") or msg:lower():find("5k[789]")) )

and (not (author == UnitName("player") or msg:lower():find("[^%a]rep[^%a]") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or msg:lower():find("apply") or
msg:lower():find("shivtr") or msg:lower():find("raid time")  or msg:lower():find("dkp")  or msg:lower():find("informa")  or msg:lower():find("[^%a]rs[^%a]")  or
 msg:lower():find("togc") or msg:lower():find("toc") or msg:lower():find("icc[%s]*10") or msg:lower():find("naxx") or msg:lower():find("ulduar") or msg:lower():find("glory") or
  msg:lower():find("for more info") or msg:lower():find("characters") or msg:lower():find("trade") or msg:lower():find("wtv") or msg:lower():find("mount") or 
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99674] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99674].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99674].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICC25HighGS] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICC25HighGS] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICC25HighGS] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99674].chan]:AddMessage("FCDICC25HighGS:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function ICCRep(self,_,msg,author) if
    (
   ((msg:lower():find("rep") and (not(msg:lower():find("[%a]rep") or msg:lower():find("rep[%a]"))) ) or msg:lower():find("repfarm") or msg:lower():find("reputation") or
   (msg:lower():find("farm") and msg:lower():find("icc") and (not(msg:lower():find("eof"))) )) 

and (not (author == UnitName("player") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core") or msg:lower():find("selling") or
 msg:lower():find("arena") or msg:lower():find("mount") or msg:lower():find("coins") or msg:lower():find("dungeon") or msg:lower():find("shadow[%s]*labs") or
  msg:lower():find("head ench") or msg:lower():find("shoulder ench") or msg:lower():find("guild") or msg:lower():find("discord") or msg:lower():find("bane") 
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or 
(msg:lower():find("[\\?]$") and (msg:lower():find("which") or msg:lower():find("any") or msg:lower():find("can")  )) or

msg:lower():find("toc") or msg:lower():find("naxx") or msg:lower():find("ulduar") or msg:lower():find("dkp") or 
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99675] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99675].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99675].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICCRep] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICCRep] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[ICCRep] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99675].chan]:AddMessage("FCDICCRep:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function Naxx(self,_,msg,author) if
    ((
  	msg:lower():find("naxx") or msg:lower():find("dedicated few") or msg:lower():find("undying") or msg:lower():find("[^%a]immortal[^%a]") or
  	 (msg:find("Patchwerk") or msg:find("Anub'Rekhan") or msg:find("Noth the Plaguebringer") or msg:find("Instructor Razuvious") and msg:find("!")))

  
 and (not (author == UnitName("player") or msg:lower():find("[^%a]rep[^%a]") or msg:lower():find("farm") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or msg:lower():find("iron horde")  or

msg:lower():find("icc") or msg:lower():find("toc") or msg:lower():find("ulduar") or msg:lower():find("sunwell") or msg:lower():find("plateau") or msg:lower():find("mount") or 
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99676] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99676].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99676].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[Naxx] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[Naxx] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[Naxx] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99676].chan]:AddMessage("FCDNaxx:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function Onixya(self,_,msg,author) if
    (((msg:lower():find("onixya") or msg:lower():find("ony") or msg:lower():find("onxaya") or msg:lower():find("onixia") or msg:lower():find("onxi") or msg:lower():find("onxy") or
   msg:find("Whelps!")) and (msg:find("10") or msg:find("25")))
  

and (not (author == UnitName("player") or msg:lower():find("rep") or msg:lower():find("farm") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or

msg:lower():find("icc") or msg:lower():find("toc") or msg:lower():find("naxx") or msg:lower():find("ulduar") or 
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99677] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99677].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99677].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[Onixya] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[Onixya] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[Onixya] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99677].chan]:AddMessage("FCDOnixya:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function OS(self,_,msg,author) if
    (
  	(
  		(msg:lower():find("sarth") or msg:lower():find("twilight zone") or msg:lower():find("less is more") or
  	(msg:lower():find("[^%a]*os[%s]*10") or msg:lower():find("[^%a]*os[%s]*25") or msg:lower():find("10[%s]*os") or msg:lower():find("10[%s]*os")) ) and

   (msg:find("10") or msg:find("25") or (msg:lower():find("weekly") and msg:lower():find("need")) or
    ((msg:lower():find("lf") or msg:lower():find("need")) and (msg:lower():find("dps") or  msg:lower():find("tank") or msg:lower():find("healer") or msg:lower():find("all"))) ))
  

  and (not (author == UnitName("player") or msg:lower():find("rep") or msg:lower():find("os set") or msg:lower():find("farm") or  msg:lower():find("recruit") or msg:lower():find("active") or
   msg:lower():find("core") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or msg:lower():find("3d") or msg:lower():find("drake") or

msg:lower():find("icc") or msg:lower():find("toc") or msg:lower():find("togc") or msg:lower():find("naxx") or msg:lower():find("ulduar") or msg:lower():find("mount") or  msg:lower():find("less is more") or
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99678] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99678].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99678].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[OS] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[OS] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[OS] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99678].chan]:AddMessage("FCOS:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function RS(self,_,msg,author) if
    (
((msg:lower():find("[^%a]rs[^%a]") or msg:lower():find("^rs[^%a]")) or msg:lower():find("ruby sanctum") or msg:lower():find("twilight destroyer") or msg:lower():find("halion")	or msg:lower():find("hallion")) and
 (msg:find("10") or msg:find("25")) and


 (not (author == UnitName("player") or (msg:lower():find("guild") and (not (msg:lower():find("run"))) ) or msg:lower():find("[^%a]rep[^%a]") or msg:lower():find("farm") or
   msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core") or msg:lower():find("[^%a]lod[^%a]") or msg:lower():find("raid time") or
    msg:lower():find("shivtr") or msg:lower():find("apply")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or

msg:lower():find("icc") or msg:lower():find("toc") or msg:lower():find("naxx") or msg:lower():find("ulduar") )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99679] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99679].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99679].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RS] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RS] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[RS] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99679].chan]:AddMessage("FCRS:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function TOC10N(self,_,msg,author) if
    ((msg:lower():find("toc[%s]*10") or (msg:lower():find("lord jaraxxus") and msg:find("10") and msg:lower():find("!") ))
and  (not (msg:lower():find("hc") or msg:lower():find("toc[%s]*25") or msg:lower():find("mount") or msg:lower():find("10[%s]*h") or msg:lower():find("togc") ))


and (not (author == UnitName("player") or msg:lower():find("[^%a]rep[^%a]") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or

msg:lower():find("icc") or msg:lower():find("naxx") or msg:lower():find("ulduar") or 
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99680] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99680].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99680].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TOC10N] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TOC10N] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TOC10N] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99680].chan]:AddMessage("FCDTOC10N:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function TOC10HC(self,_,msg,author) if
    ((msg:lower():find("togc[%shc]*10") or msg:lower():find("10[%s]*togc") or (msg:lower():find("toc[%shc]*10") and (msg:lower():find("hc") or msg:lower():find("heroic") or msg:lower():find("10h") )))


and (not (author == UnitName("player")  or msg:lower():find("[^%a]rep[^%a]") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or

msg:lower():find("icc") or msg:lower():find("naxx") or msg:lower():find("ulduar") or 
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99681] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99681].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99681].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TOC10HC] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TOC10HC] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TOC10HC] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99681].chan]:AddMessage("FCDTOC10HC:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function TOC25N(self,_,msg,author) if
    ((msg:lower():find("toc[%s]*25") or (msg:lower():find("lord jaraxxus") and msg:find("25") and msg:lower():find("!") ))
and  (not (msg:lower():find("hc") or msg:lower():find("25[%s]*h") or msg:lower():find("togc") ))


and (not (author == UnitName("player")  or msg:lower():find("[^%a]rep[^%a]") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("[^%a]core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or

msg:lower():find("icc") or msg:lower():find("naxx") or msg:lower():find("ulduar") or 
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99682] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99682].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99682].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TOC25N] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TOC25N] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TOC25N] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99682].chan]:AddMessage("FCDTOC25N:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function TOC25HC(self,_,msg,author) if
    (
  	(msg:lower():find("togc[%shc]*25") or msg:lower():find("25[%s]*togc") or
  	(msg:lower():find("toc[%shc]*25") and (msg:lower():find("hc") or msg:lower():find("heroic") or msg:lower():find("25h") )) )


and (not (author == UnitName("player") or msg:lower():find("[^%a]rep[^%a]") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("lod") or msg:lower():find("bane") or msg:lower():find("wtb") or 

msg:lower():find("icc") or msg:lower():find("naxx") or msg:lower():find("ulduar") or 
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99683] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99683].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99683].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TOC25HC] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TOC25HC] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[TOC25HC] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99683].chan]:AddMessage("FCDTOC25HC:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function Ulduar(self,_,msg,author) if
     ((msg:lower():find("ulduar") or  (msg:lower():find("uld") and (not(msg:lower():find("[%a]uld") or msg:lower():find("uld[u]*[%a]") )) ) or
  	((msg:find("Flame Leviathan") or msg:find("Ignis the Furnace Master") or msg:find("Razorscale") or msg:find("XT%-002 Deconstructor")) and msg:find("!")))


and (not (author == UnitName("player") or msg:lower():find("[^%a]rep[^%a]") or msg:lower():find("farm") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or

msg:lower():find("icc") or msg:lower():find("toc") or msg:lower():find("naxx") or 
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99684] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99684].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99684].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[Ulduar] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[Ulduar] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[Ulduar] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99684].chan]:AddMessage("FCDUlduar:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function VOA10(self,_,msg,author) if
    (
  	(msg:lower():find("[^%a]*v[o0]a[%s]*1[0o]") or msg:lower():find("1[0o][%s]*v[o0]a[^%a]") or msg:find("Earth, Wind & Fire \\(10 player\\)")) or
  	((msg:lower():find("fire[%s]*[\\+][%s]*frost") or msg:lower():find("frost[%s]*[\\+][%s]*fire")) and not msg:find("25"))


and (not (author == UnitName("player") or msg:lower():find("rep") or msg:lower():find("farm") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or

msg:lower():find("icc") or msg:lower():find("toc") or msg:lower():find("naxx") or msg:lower():find("ulduar") or 
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99685] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99685].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99685].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[VOA10] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[VOA10] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[VOA10] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99685].chan]:AddMessage("FCDVOA10:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end

function VOA25(self,_,msg,author) if
    (
  	((msg:lower():find("v[o0]a[^%a]") and msg:lower():find("25")) or (msg:find("Earth, Wind & Fire \\(25 player\\)"))) or
((msg:lower():find("fire[%s]*[\\+][%s]*frost") or msg:lower():find("frost[%s]*[\\+][%s]*fire")) and not msg:find("10"))


and (not (author == UnitName("player") or msg:lower():find("rep") or msg:lower():find("farm") or  msg:lower():find("recruit") or msg:lower():find("active") or msg:lower():find("core")
or msg:lower():find("raiding") or msg:lower():find("progress") or msg:lower():find("wts") or msg:lower():find("wtb") or

msg:lower():find("icc") or msg:lower():find("toc") or msg:lower():find("naxx") or msg:lower():find("ulduar") or 
  (msg:lower():find("rs") and (not(msg:lower():find("[%a]rs") or msg:lower():find("rs[%a]")))) )))
 then if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99686] ~= nil and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99686].enable and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99686].chan > 0 and 
     (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[VOA25] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[VOA25] ~= msg) then
    FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[VOA25] = msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99686].chan]:AddMessage("FCDVOA25:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
end return true end end




function mod:Chatfiltercheck()
	local ChatFilters = {"CHAT FILTER - Deaths", "CHAT FILTER - Other", "CHAT FILTER - Bubbles", "CHAT FILTER - Raid","CHAT FILTER - RaidLoot", "CHAT FILTER - GroupLoot", "CHAT FILTER - Global", "CHAT FILTER - Global Raids", "CHAT FILTER - Spells", "CHAT FILTER - FCD"}
	for _, class in ipairs(ChatFilters) do
		for spellInfo, spellTable in pairs(FatCooldowns.chatfilter[class]) do
			if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[spellTable.id] ~= nil and type(FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[spellTable.id]) ~= "table" then
				local SaveInfo = FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[spellTable.id]
				FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[spellTable.id] = {chan = SaveInfo, enable = true} 
			end 
		end
	end
	FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[98910] = nil 

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99950] then ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", WarmaneSystemSpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99950] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", WarmaneSystemSpam) end
	
	if FatCooldowns:GetModule("Display").db.profile.chatfilter[98910] then ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", SystemAddonFailed) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[98910] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", SystemAddonFailed) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99951] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", MPRSpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", MPRSpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99951] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", MPRSpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", MPRSpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99952] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FatalitySpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FatalitySpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99952] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FatalitySpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FatalitySpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99953] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", CrybabySpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", CrybabySpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99953] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", CrybabySpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", CrybabySpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99954] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", WarmaneCustomDBMSpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", WarmaneCustomDBMSpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99954] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", WarmaneCustomDBMSpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", WarmaneCustomDBMSpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99955] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", IDKNAMESpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", IDKNAMESpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99955] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", IDKNAMESpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", IDKNAMESpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99956] then ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", FactionGroupSpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", FactionGroupSpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99956] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", FactionGroupSpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", FactionGroupSpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99957] then ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", EmblemSpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99957] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", EmblemSpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99958] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", ParrySpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", ParrySpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99958] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", ParrySpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", ParrySpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99959] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", DBMAnnounceFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", DBMAnnounceFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99959] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", DBMAnnounceFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", DBMAnnounceFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99949] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", DetailsDeathSpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", DetailsDeathSpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99949] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", DetailsDeathSpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", DetailsDeathSpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99948] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", IsReadySpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", IsReadySpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99948] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", IsReadySpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", IsReadySpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99947] then ChatFrame_AddMessageEventFilter("CHAT_MSG_TARGETICONS", IconsSpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99947] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_TARGETICONS", IconsSpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99873] then ChatFrame_AddMessageEventFilter("CHAT_MSG_TARGETICONS", IconsSpamPP) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99873] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_TARGETICONS", IconsSpamPP) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99946] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", RBSDeaths) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", RBSDeaths) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", RBSDeaths) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99946] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", RBSDeaths) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", RBSDeaths) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_WARNING", RBSDeaths) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99946] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", SkadaDeathSpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", SkadaDeathSpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", SkadaDeathSpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99946] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", SkadaDeathSpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", SkadaDeathSpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_WARNING", SkadaDeathSpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99945] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", SmarBuffFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", SmarBuffFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99945] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", SmarBuffFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", SmarBuffFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99944] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FlumpFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FlumpFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99944] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FlumpFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FlumpFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99943] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", PhoenixStyleFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", PhoenixStyleFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99943] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", PhoenixStyleFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", PhoenixStyleFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99921] then ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", ImpBallFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_PARTY", ImpBallFilter)end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99921] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY", ImpBallFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_MONSTER_PARTY", ImpBallFilter)end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99920] then ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", WhisperFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99920] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", WhisperFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99918] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", RSAFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", RSAFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99918] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", RSAFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", RSAFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99917] then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", BubblesFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", BubblesFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", BubblesFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", BubblesFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", BubblesFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_SAY", BubblesFilter) end

	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99917] then
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_MONSTER_YELL", BubblesFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", BubblesFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY_LEADER", BubblesFilter)
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY", BubblesFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", BubblesFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_MONSTER_SAY", BubblesFilter)  end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99914] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", JapChiKorFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", JapChiKorFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99914] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", JapChiKorFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", JapChiKorFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99913] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", RussainFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", RussainFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99913] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", RussainFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", RussainFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99911] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", TauntFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", TauntFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99911] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", TauntFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", TauntFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99910] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", BigBrotherFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", BigBrotherFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99910] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", BigBrotherFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", BigBrotherFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99909] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", RessFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", RessFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99909] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", RessFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", RessFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99908] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", LKAnnounceFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", LKAnnounceFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", LKAnnounceFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99908] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", LKAnnounceFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", LKAnnounceFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_WARNING", LKAnnounceFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99907] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", CustomMacronWeakaura) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", CustomMacronWeakaura) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", CustomMacronWeakaura) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99907] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", CustomMacronWeakaura) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", CustomMacronWeakaura) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_WARNING", CustomMacronWeakaura) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99905] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", OptiTauntFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", OptiTauntFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99905] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", OptiTauntFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", OptiTauntFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99904] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", AchivmentFailsFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", AchivmentFailsFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99904] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", AchivmentFailsFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", AchivmentFailsFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99936] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", RankWatchFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", RankWatchFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99936] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", RankWatchFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", RankWatchFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99931] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", OmenFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", OmenFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99931] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", OmenFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", OmenFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99932] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", InterruptFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", InterruptFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99932] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", InterruptFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", InterruptFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99940] then ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", RaidLootNeed) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99940] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", RaidLootNeed) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99939] then ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", RaidLootGreed) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99939] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", RaidLootGreed) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99942] then ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", RaidLootPass) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99942] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", RaidLootPass) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99941] then ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", RaidLootDE) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99941] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", RaidLootDE) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99850] then ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", GLootNeed) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99850] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", GLootNeed) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99853] then ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", GLootGreed) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99853] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", GLootGreed) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99852] then ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", GLootPass) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99852] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", GLootPass) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99851] then ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", GLootDE) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99851] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", GLootDE) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99854] then ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", GLootPoor) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99854] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", GLootPoor) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99899] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", AnnounceFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", AnnounceFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99899] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", AnnounceFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", AnnounceFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99898] then ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", RaidPoorLoot) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99898] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", RaidPoorLoot) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99871] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", GBuyingSelling)  end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99871] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", GBuyingSelling) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99870] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", GArena)  end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99870] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", GArena) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99869] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", GGuild)  end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99869] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", GGuild) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99868] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", GNoneEnglish)  end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99868] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", GNoneEnglish) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99867] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", GSpam)  end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99867] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", GSpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99866] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", GTmog)  end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99866] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", GTmog) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99865] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", MRTReciveLootSpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", MRTReciveLootSpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99865] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", MRTReciveLootSpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", MRTReciveLootSpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99862] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", EnsidiaFailsSpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", EnsidiaFailsSpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99862] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", EnsidiaFailsSpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", EnsidiaFailsSpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99861] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", DoTimerSpam) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", DoTimerSpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99861] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", DoTimerSpam) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", DoTimerSpam) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99919] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FlasknFoodFilter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FlasknFoodFilter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99919] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FlasknFoodFilter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FlasknFoodFilter) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99859] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", ReadyCheckMessages) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", ReadyCheckMessages) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99859] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", ReadyCheckMessages) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", ReadyCheckMessages) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99849] then ChatFrame_AddMessageEventFilter("CHAT_MSG_MONEY", GoldRaidMessage) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99849] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_MONEY", GoldRaidMessage) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99860] then ChatFrame_AddMessageEventFilter("CHAT_MSG_MONEY", GoldPartyMessage) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99860] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_MONEY", GoldPartyMessage) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99860] then ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", TrainerSpam) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99860] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", TrainerSpam) end

	------- Raids
	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99670] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", AlreadyStartedRaids) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99670] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", AlreadyStartedRaids) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99671] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ICC10LowGS) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99671] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", ICC10LowGS) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99672] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ICC10HighGS) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99672] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", ICC10HighGS) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99673] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ICC25LowGS) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99673] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", ICC25LowGS) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99674] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ICC25HighGS) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99674] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", ICC25HighGS) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99675] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ICCRep) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99675] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", ICCRep) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99676] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", Naxx) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99676] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", Naxx) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99677] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", Onixya) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99677] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", Onixya) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99678] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", OS) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99678] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", OS) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99679] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", RS) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99679] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", RS) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99680] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", TOC10N) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99680] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", TOC10N) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99681] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", TOC10HC) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99681] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", TOC10HC) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99682] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", TOC25N) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99682] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", TOC25N) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99683] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", TOC25HC) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99683] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", TOC25HC) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99684] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", Ulduar) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99684] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", Ulduar) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99685] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", VOA10) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99685] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", VOA10) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99686] then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", VOA25) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99686] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", VOA25) end


------- FCD Message Filter

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99929] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FCDMVileGas) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMVileGas) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99929] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FCDMVileGas) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMVileGas) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99928] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FCDMBQLBite) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMBQLBite) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99928] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FCDMBQLBite) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMBQLBite) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99927] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FCDOozeDamage) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDOozeDamage) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99927] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FCDOozeDamage) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDOozeDamage) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99926] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FCDMBacklash) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMBacklash) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99926] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FCDMBacklash) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMBacklash) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99925] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FCDMWhoring) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMWhoring) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99925] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FCDMWhoring) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMWhoring) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99924] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FCDMWhoringSingle) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMWhoringSingle) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99924] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FCDMWhoringSingle) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMWhoringSingle) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99923] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FCDMRSDispel) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMRSDispel) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99923] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FCDMRSDispel) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMRSDispel) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99922] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FCDMBPCKock) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMBPCKock) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99922] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FCDMBPCKock) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMBPCKock) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99906] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FCDMSunders) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMSunders) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99906] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FCDMSunders) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDMSunders) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99930] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FCDBMNecro) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDBMNecro) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99930] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FCDBMNecro) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDBMNecro) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99887] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FCDBMHastedAttack) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDBMHastedAttack) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99887] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FCDBMHastedAttack) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDBMHastedAttack) end

	if FatCooldowns:GetModule("Display").db.profile.chatfilter[99875] then ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FCDParryCounter) ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDParryCounter) end
	if not FatCooldowns:GetModule("Display").db.profile.chatfilter[99875] then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", FCDParryCounter) ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", FCDParryCounter) end

-------

	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", CustomChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", CustomChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", CustomChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", CustomChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", CustomChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", CustomChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", CustomChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", CustomChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", CustomChatFilter)

	if FatCooldowns:GetModule("Display").db.profile.CWEnable then ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ChatWhisperBlocker) ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", ChatWhisperBlocker2) end
	if not FatCooldowns:GetModule("Display").db.profile.CWEnable then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", ChatWhisperBlocker) ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", ChatWhisperBlocker2) end

	if FatCooldowns:GetModule("Display").db.profile.samechatmessages ~= 0 then ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", DupMessages)  end
	if FatCooldowns:GetModule("Display").db.profile.samechatmessages == 0 then ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", DupMessages) end
end

local DupMessagesTable = {}
function DupMessages(self,channel,msg,author)
	if author == UnitName("player") then return false end
	local DupTimer = GetTime()
	if DupMessagesTable[author] ~= nil and DupMessagesTable[author].msg == msg and DupTimer - DupMessagesTable[author].time > 1 and DupTimer - DupMessagesTable[author].time < FatCooldowns:GetModule("Display").db.profile.samechatmessages then
		return true
	else 
		DupMessagesTable[author] = DupMessagesTable[author] or {}
		DupMessagesTable[author].msg = msg
		DupMessagesTable[author].time = GetTime()
	end
end

function ChatWhisperBlockerWhoLib(user, results, complete)
	local startCWPlayerName, CWPlayerName = select(3, user:find("(%a+)-(%a+)"))
	if startCWPlayerName == "n" then
		if user and complete then
			if FatCooldowns.BWList[CWPlayerName] then
				for TableIndex, PlayersTable in pairs(results) do
					if PlayersTable.Name == CWPlayerName then
						if (PlayersTable.Online) then
							FatCooldowns.BWList[PlayersTable.Name].name = PlayersTable.Name
							FatCooldowns.BWList[PlayersTable.Name].level = PlayersTable.Level
							FatCooldowns.BWList[PlayersTable.Name].guild = PlayersTable.Guild
							FatCooldowns.BWList[PlayersTable.Name].complete = true
						end
					end
				end
			end
		end
	elseif startCWPlayerName == "g" then
		for TableIndex, PlayersTable in pairs(results) do
			if user and complete then
				if PlayersTable.Guild == CWPlayerName then
					if PlayersTable.Online then
						FatCooldowns.BWList[PlayersTable.Name] = FatCooldowns.BWList[PlayersTable.Name] or {name = "", level = 0, guild = ""}
						FatCooldowns.BWList[PlayersTable.Name].name = PlayersTable.Name
						FatCooldowns.BWList[PlayersTable.Name].level = PlayersTable.Level
						FatCooldowns.BWList[PlayersTable.Name].guild = PlayersTable.Guild
						FatCooldowns.BWList[PlayersTable.Name].complete = true
					end
				end
			end
		end
	end
end
function ChatWhisperBlocker2(self,channel,msg,author)
	if msg ~= "FCD Auto Reply: Sorry your message was blocked by an addon" and FatCooldowns:GetModule("Display").db.profile.CWEPMed > 0 then FatCooldowns.MessagedPeople[author] = GetTime() end
	if channel == "CHAT_MSG_WHISPER_INFORM" and msg == "FCD Auto Reply: Sorry your message was blocked by an addon" then
		return true 
	end
end
function ChatWhisperBlocker(self,channel,...)
	local args = { ... }
	local localizedClass, englishClass, localizedRace, englishRace, sex, WhisperName, realm = GetPlayerInfoByGUID(args[12])
	local BlockMessage = true
	local BlockMessage2 = true
	if args[1] == "FCD Auto Reply: Sorry your message was blocked by an addon" then return false end
	if CWBlockCheckExtra(WhisperName) then BlockMessage = true else BlockMessage = false end
	if FatCooldowns:GetModule("Display").db.profile.CWEWho and BlockMessage == true then BlockMessage2 = false end
	if BlockMessage and WhisperName and BlockMessage2 and FatCooldowns.LogInTime ~= nil and GetTime() - FatCooldowns.LogInTime > 5 then 
		if FatCooldowns:GetModule("Display").db.profile.CWEReply then
			if (LastSent[WhisperName] == nil or (LastSent[WhisperName] ~= nil and GetTime() - LastSent[WhisperName] > 0.4)) and args[1] ~= nil then
				if FatCooldowns:GetModule("Display").db.profile.CWEReply then SendChatMessage("FCD Auto Reply: Sorry your message was blocked by an addon", "WHISPER", nil, WhisperName) end
				if FatCooldowns:GetModule("Display").db.profile.CWESound then PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\Blocked.mp3", "Master",false) end
				CWLogMessage(WhisperName, args[1])
				LastSent[WhisperName] = GetTime()
			else
				LastSent[WhisperName] = GetTime()
			end
		end
		return true
	else
		return false
	end
end

function CustomChatFilter(self,channel,msg,author,language)
	if msg == nil or msg == "" then return end
	if author == UnitName("player") then
		if FatCooldowns:GetModule("Display").db.profile.CWEPosted[channel] ~= nil and FatCooldowns:GetModule("Display").db.profile.CWEPosted[channel] == true then
			LastPostedMessage = GetTime()
		end
	end

	if next(FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList) then
		for l,p in pairs(FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList) do
			local Message = l
			local CurrentMessage = msg
			if Message:find("FCDAuthor") then Message = gsub(Message, "FCDAuthor", author) end 
			if Message:find("FCDBoss1") then Message = gsub(Message, "FCDBoss1", UnitName("boss1")) end 
			if Message:find("FCDAnyLink") then
				local pattern = "|c%x+|H(%w+):.-|h%[.-%]|h|r"
				CurrentMessage = gsub(CurrentMessage, pattern, "FCDAnyLink")
			end
			if Message:find("FCDGroupPlayer") then Message = FCDGroupPlayerFound(Message) end
			if FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Match ~= nil and FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Match then else
				Message = SafeLower(Message)
				CurrentMessage = SafeLower(CurrentMessage)
			end
			if CurrentMessage:find(Message) then 
				if next(FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Filter) then
					for g,f in pairs(FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Filter) do
						if f and g == channel then
							if (g == "CHAT_MSG_SAY" or g == "CHAT_MSG_YELL" or g == "CHAT_MSG_PARTY") and FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Bubbles ~= nil and
							FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Bubbles then
							else
								if FatCooldowns:GetModule("Display").db.profile.CustomChatFilterReporter > 0 and
									(FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[CustomChatFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[CustomChatFilter] ~= msg) then
										FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[CustomChatFilter] =
										msg _G["ChatFrame"..FatCooldowns:GetModule("Display").db.profile.CustomChatFilterReporter]:AddMessage("CustomChatFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04)
								end
								return true
							end
						end
					end
				end
			end
		end
	end
end

local LoadEU = true
local E, _, V, P, G

function BubblesFilter(self,channel,msg,author,language)
	local BubbleBossOne = "FCDFakeBoss1"
	if UnitName("boss1") ~= nil then BubbleBossOne = UnitName("boss1") end
	local UnboundTable = {
		[1] = "^unbound plague on me!$",
		[2] = "^entfesselte seuche on me!$",
		[3] = "^peste desatada on me!$",
		[4] = "^entfesselte seuche auf mir!$",
	}
	local SpanishTable = {
		[1] = "¡",
		[2] = "¿",
		[3] = "Ü",
		[4] = "á",
		[5] = "í",
		[6] = "ó",
		[7] = "ú",
		[8] = "ñ",
		[9] = "Á",
		[10] = "É",
		[11] = "ü",
		[12] = "Í",
		[13] = "Ñ",
		[14] = "Ó",
		[15] = "Ú",
		[16] = "é",
	}
	local InnervateTableLower = {
		[1] = "^innervate please[%s]*[!]*$",
		[2] = "^thanks for the innervate[%s!]*$",
		[3] = "^Innervate on [%a]+[%s!]*$",
		[4] = "^innervate me please[%s!]*$",
		[5] = "^innervate me[%s!]*$",
		[6] = "^innervate FCDAuthor[%s!]*$",
		[7] = "^innervate FCDAuthor's' booty[%s!]*$",
	}
	local InnervateTable = {
		[1] = "^Casting |cff71d5ff|Hspell:[%d]+|h[\\[]Innervate]|h|r on [A-Z][%a]+[%s!]*$",
		[2] = "^INNERVATE on [A-Z][%a]+ %([A-Z]+% plz$",
		[3] = "^[\"]INNERVATE ME PLEASE[\"]$",
		[4] = "^INNER on [A-Z][%a]+ %(HPALA% plz[%s!]*$",
		[5] = "^INNERVATE USED$",
		[6] = "^[A-Z][%a]+ Nayura et Manar!$",
		[7] = "^[A-Z][%a]+ Innervated[!]*$",
		[8] = "^[A-Z][%a]+, Casted Innervate on you[!]*$",
		[9] = "^[A-Z][%a]+%. Casted Innervate on you[!]*$",
		[10] = "^innervate on [A-Z][%a]+ please$",
		[11] = "^INNERVATE HPALA [A-Z][%a]+[%s!]*$",
		[12] = "^cast Innervate on [A-Z][%a]+[%s!]*$",
		[13] = "^[A-Z][%a]+, Casted Innervate on you[%s!]*$",
		[14] = "^Innvervate me now[%s!]*$",
		[15] = "INNERVATE [A-Z][%a]+ PLEASE[%s!]*$",
	}
	local SheklesFilterTable = {
		["Any"] = {
			[1] = "^[A-Z][%a]+ used AM with |cff71d5ff|Hspell:[%d]+|h[\\[]Frost Resistance Aura]|h|r$",
			[2] = "^[A-Z][%a]+ used AM with |cff71d5ff|Hspell:[%d]+|h[\\[]Shadow Resistance Aura]|h|r$",
			[3] = "^[A-Z][%a]+ used AM with |cff71d5ff|Hspell:[%d]+|h[\\[]Fire Resistance Aura]|h|r$",
			[4] = "^[A-Z][%a]+ used AM with |cff71d5ff|Hspell:[%d]+|h[\\[]Crusader Aura]|h|r$",
			[5] = "^[A-Z][%a]+ used Aura Mastery with |cff71d5ff|Hspell:[%d]+|h[\\[]Frost Resistance Aura]|h|r$",
			[6] = "^[A-Z][%a]+ used Aura Mastery with |cff71d5ff|Hspell:[%d]+|h[\\[]Shadow Resistance Aura]|h|r$",
			[7] = "^[A-Z][%a]+ used Aura Mastery with |cff71d5ff|Hspell:[%d]+|h[\\[]Fire Resistance Aura]|h|r$",
			[8] = "^[A-Z][%a]+ used Aura Mastery with |cff71d5ff|Hspell:[%d]+|h[\\[]Crusader Aura]|h|r$",
			[9] = "^AM down!$",
			[10] = "^{star}[%s]*Innervate shaman[%s]*{star}[%s]*{star}[%s]*Innervate shaman[%s]*{star}$",
			[11] = "^MAGE SPAWNED!!$",
			[12] = "^Dsac [Uu][Pp][!]*$",
			[13] = "^[aA]ura [Mm]astery [uU][Pp][%s]*[!]*$",
			[14] = "^Silenced !$",
			[15] = "^{[Ss][Kk][Uu][Ll][LL]}[%s]*|cffffff00|Hachievement.+[%s]*failed!",
			[16] = "^{rt[1,2,3,4,5,6,7,8]}[%s]*|cffffff00|Hachievement.+[%s]*failed!",
			[17] = "^[A-Z][%a]+ caused a parry on FCDAuthor$",
			[18] = "^[<]+PARRY[>]+[%s]*[A-Z][%a]+ parried [A-Z][%a]+[!]+$",
			[19] = "^[A-Z][%a]+ receives loot: |cff[%d%a]+|Hitem:[%d]+:0:0:0:0:0:0:0:[%d]+|h[\\[].+]|h|r%.$",
			[20] = "^using Evocation !$",
			[21] = "^Focus Magic on [A-Z][%a]+%.$",
			[22] = "^I'll give you a soul if you come to me, Felguard! Please hear my command!$",
			[23] = "^Banished [A-Z][%a%s]+!$",
			[24] = "^Banish on [A-Z][%a%s]+ has ended!$",
			[25] = "^Soulstone on [A-Z][%a]+$",
			[26] = "^Last Standing$",
			[27] = "^Aura Mastery is up[!]* Thanks [A-Z][%a]+$",
			[28] = "^FOR THE ALLIANCE[!]*$",
			[29] = "^thanks for pain suppresion!!$",
			[30] = "^thanks for the pain suppresion!$",
			[31] = "^Awesome! Divine Hymn up$",
			[32] = "^Hymn of Hope is UP!! Thanks [A-Z][%a]+$",
			[33] = "^Divine Hymn is UP!! Thanks [A-Z][%a]+$",
			[34] = "^%=%> I Interrupted That: .+%.$",
			[35] = "^|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r interrupted!$",
			[36] = "^Interrupted [A-Z][%a%s]*'s |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r!$",
			[37] = "^Interrupted [%a%s]+ with |cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-:)(]*]|h|r$",
			[38] = "^Time to bring the pain[!]*$",
			[39] = "^Tanks for the Pain Suppresion!$",
			[40] = "^Thanks for the Pain Suppression!$",
			[41] = "^Thanks for the Pain Suppresion[!]+$",
			[42] = "^Fearing [A-Z][%a%s]+!$",
			[43] = "^CC%/Stuns%/Hex%/Fear anyone[?]+$",
			[44] = "^thanks for dguardian !$",
			[45] = "^thanks for the dguardian !$",
			[46] = "^thanks for the bloodlust!$",
			[47] = "^thanks for the power infusion!$",
			[48] = "^thanks for the hand of salvation[%s]*!$",
			[49] = "^salvation[!]*$",
			[50] = "^thanks for the hand of sacrifice[%s]*!$",
			[51] = "^thanks for dsac!$",
			[52] = "^thanks mate !$",
			[53] = "^thanks for bloodlust$",
			[54] = "^thanks for the bloodlust$",
			[55] = "^thanks!$",
			[56] = "^Perfect Divine Sacrifice!!! Thanks [A-Z][%a]+$",
			[57] = "^Thanks for the Hand of Protection!$",
			[58] = "^Thanks for the PI!$",
			[59] = "^Thanks for the Sacrifice!$",
			[60] = "^Thanks for the Salvation!$",
			[61] = "^Thanks for the bite !$",
			[62] = "^Thanks for the Sacrifice!$",
			[63] = "^Perfect Divine Sacrifice[!]* Thanks, [A-Z][%a]+$",
			[64] = "^Waow[!] Thanks for the Hysteria$",
			[65] = "^Thanks for the HOP[!]*$",
			[66] = "^Thanks !$",
			[67] = "^Thanks for Innervate+$",
			[68] = "^[A-Z][%a]+ used Hand of Protection on [%>]+ [A-Z][%a]+ [%<]+$",
			[69] = "^[A-Z][%a]+ used Hand of Sacrifice on [%>]+ [A-Z][%a]+ [%<]+$",
			[70] = "^[A-Z][%a]+ used Hand of Salvation on [%>]+ [A-Z][%a]+ [%<]+$",
			[71] = "^[A-Z][%a]+ is casting Divine Sacrifice!$",
			[72] = "^[A-Z][%a]+ used Divine Salvation$",
			[73] = "^[A-Z][%a]+ used Divine Sacrifice$",
			[74] = "^[A-Z][%a]+ used Divine Protection$",
			[75] = "^get ready for the [Ss]uper [Ss]ayan. [aA]+[Hh]+$",
			[76] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Stealth]|h|r up on [A-Z]",
			[77] = "^salvación por favor$",
			[78] = "^salvation FCDAuthor!$",
			[79] = "^[%s]*{triangle}[%s]*THORNS %- REMOVED[%s]*{triangle}[%s]*$",
			[80] = "^[%s]*{triangle}[%s]*FOCUS MAGIC %- REMOVED[%s]*{triangle}[%s]*$",
			[81] = "^[%s]*{triangle}[%s]*INTELLECT %- REMOVED[%s]*{triangle}[%s]*$",
			[82] = "^[%s]*{triangle}[%s]*BEACON %- REMOVED[%s]*{triangle}[%s]*$",
			[83] = "^5 stacks of |cff71d5ff|Hspell:[%d]+|h[\\[]Sunder Armor]|h|r applied on .+ in .+ sec[!]*$",
			[84] = "^5 Sunders took .+seconds$",
			[85] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Sunder Armor]|h|r dropped from .+[!]*$",
			[86] = "^[A-Z][%a]+ just intervened to [A-Z][%a]+$",
			[87] = "^GTS is down[%s!]*$",
			[88] = "^GTS Used[!]* Thanks, [A-Z][%a]+$",
			[89] = "^GTS is up[%s!]*$",
			[90] = "^[A-Z][%a]+'s GTS is up!!$",
			[91] = "^GTS used$",
			[92] = "^GTS UP$",
			[93] = "^[A-Z][%a]+ GTS UP$",
			[94] = "^GTS$",
			[95] = "^Using GTS$",
			[96] = "^I USE Glowing Twilight Scale$",
			[97] = "^Glowing Twilight Scale USED$",
			[98] = "^Glowing Twilight Scale Used$",
			[99] = "^Used[%s]*|cffa335ee|Hitem:54589:0:0:0:0:0:0:0:80|h[\\[]Glowing Twilight Scale]|h|r$",
			[100] = "^Used[%s]*|cffa335ee|Hitem:54589:0:0:0:0:0:0:0:0|h[\\[][Glowing Twilight Scale]|h|r$",
			[101] = "^Used[%s]*|cffa335ee|Hitem:54573:0:0:0:0:0:0:0:80|h[\\[]Glowing Twilight Scale]|h|r$",
			[102] = "^Used[%s]*|cffa335ee|Hitem:54573:0:0:0:0:0:0:0:0|h[\\[]Glowing Twilight Scale]|h|r$",
			[103] = "^Used[%s]*|cffa335ee|Hitem:.+|h[\\[]Glowing Twilight Scale]|h|r$",
			[104] = "^[A-Z][%a]+ PULLED [A-Z][%a%s]*!!!$",
			[105] = "^[A-Z][%a]+ PULLED Der [%a%s]+!!!$",
			[106] = "^9 STACKS SOMEBODY TUANT!!!$",
			[107] = "^9 STACKS SOMEBODY TAUNT!!!$",
			[108] = "^3 STACKS , TAUNT !!$",
			[109] = "^3 STACKS . TUANT !!$",
			[110] = "^9 STACKS TAUNT[%s]*[!]+$",
			[111] = "^Taunt now!$",
			[112] = "^TAUNT IMMUNE: [.]+!$",
			[113] = "^Casting Resurrection on [A-Z][%a]+$",
			[114] = "^Started to cast |cff71d5ff|Hspell:[%d]+|h[\\[]Redemption]|h|r on [A-Z][%a]+$",
			[115] = "^Casted |cff71d5ff|Hspell:[%d]+|h[\\[]Revive]|h|r on [A-Z][%a]+$",
			[116] = "^Casting Ancestral Spirit on [A-Z][%a]+$",
			[117] = "^Resurrecting [A-Z][%a]+%.$",
			[118] = "^If you cherish the idea of a mass suicide, [A-Z][%a]+ can now self-resurrect, so all should be fine. Go ahead.$",
			[119] = "^I need you to get this into your head, you have done this before, this is not progress, okey. It$",
			[120] = "^in soviet icecrown, life chooses [%a]+!$",
			[121] = "^[A-Z][%a]+ get back to life Ma B!tch$",
			[122] = "^Come to life, [A-Z][%a]+, you b00n!$",
			[123] = "^Started to cast [Resurrection] on [A-Z][%a]+$",
			[124] = "^Creating a |cff71d5ff|Hspell:[%d]+|h[\\[]Ritual of Summoning]|h|r%. Please, assist%.$",
			[125] = "^Started to cast |cff71d5ff|Hspell:[%d]+|h[\\[]Soulstone Resurrection]|h|r on [A-Z][%a]+$",
			[126] = "^Started to cast |cff71d5ff|Hspell:[%d]+|h[\\[]Resurrection]|h|r on [A-Z][%a]+$",
			[127] = "^Obey now, Haaghun!$",
			[128] = "^I'll give you a soul if you come to me, Felguard! Please hear my command!$",
			[129] = "^ressing %[%[ [A-Z][%a]+ %]%]$",
			[130] = "^Wakey wakey, hands off snakey [A-Z][%a]+!$",
			[131] = "^Back on your feet%. [A-Z][%a]+[!]+ just don't come crying to me if you die again%.$",
			[132] = "^Clearly%. [A-Z][%a]+ hasn't learned how to get out of the fire yet%.$",
			[133] = "^And the [A-Z][%a]+ dies in the F[I]+[G]+HT[!]+$",
			[134] = "^Rezzing [A-Z][%a]+ should aggro every bears%.$",
			[135] = "^This Rebirth brought to [A-Z][%a]+ by Renaissance Magic%. Inc%. Bringing the dead to life faster, better, stronger%.$",
			[136] = "^Let nature come hence and heal thy wounds, and resurrect Somedeadguy, who is an utter noob!$",
			[137] = "^Hey name, think i should start using Amberseeds for this?$",
			[138] = "^[A-Z][%a]+ Combat ressedd$",
			[139] = "^Does anyone know what the respawn timer on [A-Z][%a]+ is?$",
			[140] = "^Obey now, Haaghun!$",
			[141] = "^Sending holy energies in all of [A-Z][%a]+'s secret places. Click Accept to consent$",
			[142] = "^Hey [A-Z][%a]+, I've calculated your chance of survival, but I don't think you'll like it.$",
			[143] = "^Get off the floor, [A-Z][%a]+, it does not love you that way$",
			[144] = "^Let's give [AZ][%a]+ a round of applause for that beautiful demonstration of what not to do.$",
			[145] = "^[A-Z][%a]+ get back to life u slacker !$",
			[146] = "^We have gathered here today%.%.%.%. to mourne the passing of%.%.%.%.%.%. what am i doing here again?$",
			[147] = "^Creating a |cff71d5ff|Hspell:[%d]+|h[\\[][[.]+]*]|h|r%. Please assist%.$", 
		},
		["Shaman"] = {
			[1] = "^%-%-|cff71d5ff|Hspell:[%d]+|h[\\[]Mana Tide Totem]|h|r used!%-%-$",
			[2] = "^MANATIDE UP[%,]*$",
			[3] = "^Hymn of Hope is up[!]* Use Mana Cooldowns[!]*$",
			[4] = "^Mana Tide Totem[!]*$",
			[5] = "^Mana Tide Totem up[!]*$",
			[6] = "^Mana tide UP %= do your Hymn of hope$",
			[7] = "^Mana Tide is up, Hymn of Hope pls$",
			[8] = "^%-%-[\\[]Mana Tide Totem] used!%-%-$",
			[9] = "^{square}{triangle}{square}{triangle} M A N A T I D E[%s]*{triangle}{square}{triangle}{square}$",
			[10] = "^Bloodlust UP!$", 
		},
		["Druid"] = {
			[1] = "^Casting Bress on [A-Z][%a]+$",
			[2] = "^Resurrecting [A-Z][%a]+.$",
			[3] = "^ressing [\\[][\\[] [A-Z][%a]+ ]]$",
			[4] = "^OKC [A-Z][%a]+ casts Battle Res$",
			[5] = "^Resurrecting [A-Z][%a]+%.$",
			[6] = "^Casting Bress on [A-Z][%a]+!$",
			[7] = "^[A-Z][%a]+ get back to life Ma B!tch$",
			[8] = "^Casting on [A-Z][%a]+$",
			[9] = "^cast Rebirth on [A-Z][%a]+$",
			[10] = "^Started to cast |cff71d5ff|Hspell:[%d]+|h[\\[]Rebirth]|h|r on [A-Z][%a]+$",
			[11] = "^rebirth on [A-Z][%a]+[%s!]*$",
			[12] = "^Started to cast on |cff71d5ff|Hspell:[%d]+|h[\\[]Rebirth]|h|r [A-Z][%a]+$",
			[13] = "^Come to life, [A-Z][%a]+, you b00n!$",
			[14] = "^Casting Rebirth on [A-Z][%a]+$",
			[15] = "^[A-Z][%a]+ Combat ressed$",
			[16] = "^BARKSKIN USED$",
			[17] = "^BARKSIN USED$",
			[18] = "^Skin Protect On[%s]*[!]*$",
			[19] = "^ENRAGED DEFENSE is DOWN!$",
			[20] = "^LAST STAND[%s]*%(FERLOL%) is DOWN!$",
			[21] = "^ENRAGED DEFENSE is UP!$",
			[22] = "^LAST STAND[%s]*%(FERLOL%) is UP!$",
			[23] = "^DRUID WALL is UP!$",
			[24] = "^DRUID WALL is DOWN!$",
		},
		["Hunter"] = {
			[1] = "^Misdirected [A-Z][%a]+$", 
			[2] = "^Md [A-Z][%a]+$",
			[3] = "^MD up$",
			[4] = "^.MD on. [A-Z][%a]+$",
			[5] = "^Misdirection is up$",
			[6] = "^Misdirection [A-Z][%a]+$",
			[7] = "^Misdirected used on [A-Z][%a]+[%s]*[!]*$",
			[8] = "^MD on [A-Z][%a]+$",
			[9] = "^[%s]*Taunting Blistering Zombie$",
			[10] = "^Taunting Blood Beast$",
			[11] = "^MD on sexy %<[A-Z][%a]+%>$",
			[12] = "^Misdirection on [A-Z][%a]+[%s]+[!]+$",
			[13] = "^[%s]*[.]MD on[.] [A-Z][%a]+$",
			[14] = "^[%s]*[\"]MD on[\"] [A-Z][%a]+$",
			[15] = "^[%s]*Tuanting Blistering Zombie$",
			[16] = "^Tuanting Blood Beast$",
			[17] = "^~~Misdirecting on Kawzz~~$",
		},
		["Death Knight"] = {
			[1] = "^BLOOD ARMOR [iI][SS] DOWN[!]+$",
			[2] = "^VAMPIRIC BLOOD [iI][SS] DOWN[!]+$",
			[3] = "^BLOOD ARMOR [iI][SS] UP[!]+$",
			[4] = "^VAMPIRIC BLOOD [iI][SS] UP[!]+$",
			[5] = "^DK WALL [iI][SS] UP[!]+$",
			[6] = "^DK WALL [iI][SS] DOWN[!]+$",
		},	--["Mage"] = {},
		["Paladin"] = {
			[1] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Holy Wrath]|h|r activate$",
			[2] = "^Hand of Freedom on >>>> [A-Z][%a]+ <<<<$",
			[3] = "^Thanks for the Freedom!$",
			[4] = "^Hand Of Freedom cast on [A-Z][%a]+!$",
			[5] = "^Thanks for the Freedom!$",
			[6] = "^Thanks for the Hands of Freedom!$",
			[7] = "^Hand of Freedom is down[%s!]*$",
			[8] = "^Hand of Freedom is up[%s!]*$",
			[9] = "^Hand of Freedom on [A-Z][%a]+[!]*$",
			[10] = "^[A-Z][%a]+ used Hand of Freedom on [%>]+ [A-Z][%a]+ [%<]+$",
			[11] = "^Freedom [uU]sed$",
			[12] = "^Hand of freedom up !$",
			[13] = "^Beacon Fades !$",
			[14] = "^Beacon Of Light cast on [A-Z][%a]+!$",
			[15] = "^Beacon Of Light on [A-Z][%a]+ has ended!$",
			[16] = "^Perfect Divine Sacrifice!$",
			[17] = "^|cff.+|Hspell:[%d]+|h[\\[]Divine Guardian]|h|r up and running%.$",
			[18] = "^>>> Divine Protection is ACTIVE! <<<$",
			[19] = "^Divine Plea activated$",
			[20] = "^Divine Guardian Activated!$",
			[21] = "^Divine Guardian Faded!$",
			[22] = "^Divine Protection Activated!$",
			[23] = "^Divine Protection Faded!$",
			[24] = "^[%s]*FCDAuthor[%s]*used Divine Sacrifice[%s]*$",
			[25] = "^FCDAuthor used Divine Sacrifice$",
			[26] = "^Divine Protection %^%-%^ Activated %^%-%^$",
			[27] = "^Divine Sacrifice has been cast!$",
			[28] = "^Casting |cff71d5ff|Hspell:[%d]+|h[\\[]Divine Sacrifice]|h|r$",
			[29] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Divine Protection]|h|r %^%.%^[%s]*Activated[%s]*%^%.%^$",
			[30] = "^%>%>%> |cff71d5ff|Hspell:[%d]+|h[\\[]Divine Sacrifice]|h|r is ACTIVE!! Please Watch my health! %<%<%<$",
			[31] = "^Divine Sacrifice Up!!!$",
			[32] = "^DIVINE SACRIFICE UP[!]*$",
			[33] = "^I believe I have used DSAC ~-~$",
			[34] = "^ I believe I have used DSAC ~.~$",
			[35] = "^I believe I have used DSAC %~%-%~$",
			[36] = "^Forbearance Faded!$",
			[37] = "^>>> Death AVERTED. Ardent Defender is my hero and healed me for [%d]+. <<<$",
			[38] = "^Ardent Defender Activated!$",
			[39] = "^Ardent Defender Faded!$",
			[40] = "^Hand of Protection is up[%s!]*$",
			[41] = "^Hand of Sacrifice is up[%s!]*$",
			[42] = "^Hand of Sac up$",
			[43] = "^Hand of Salvation on [A-Z][%a]+$",
			[44] = "^Hand Of sacrifice On !$",
			[45] = "^Hand of Salvation on >>>> [A-Z][%a]+ <<<<$",
			[46] = "^Hand of Sacrifice on >>>> [A-Z][%a]+ <<<<$",
			[47] = "^Hand Of Protection cast on [A-Z][%a]+!$",
			[48] = "^Hand Of Sacrifice cast on [A-Z][%a]+!$",
			[49] = "^Hand Of Salvation cast on [A-Z][%a]+!$",
			[50] = "^Lay On Hands on [A-Z][%a]+ for [%d]+!$",
			[51] = "^HAND OF SACRIFICE on [A-Z][%a]+!$",
			[52] = "^LAY ON HANDS on [A-Z][%a]+!$",
			[53] = "^TAUNT MISSED [.]*! %(Hand of Reckoning%)$",
			[54] = "^Hand of Protection on [>]+[%s]*[A-Z][%a]+[%s]*[<]+$",
			[55] = "^Clutch Lay on Hand$",
			[56] = "^Hand of Protection on [>]+[%s]*[A-Z][%a]+[%s]*[<]+$",
			[57] = "^Hand of Sacrifice on [A-Z][%a]+[!]*$",
			[58] = "^SVL up[!]+$",
			[59] = "^[%s]*SLV up[%s]*!$",
			[60] = "^Salv on [A-Z][%a]+$",
			[61] = "^Salvation [A-Z][%a]+[!]* ROAR AGGRO[%S]*[:]*[%D]*$",
			[62] = "^SALVATION [A-Z]+$",
			[63] = "^Casting HOSAC!$",
			[64] = "^i used HoF next you$",
			[65] = "^AM on[!]*$",
			[66] = "^AM used %- Aura 100[\\%] stronger for [%d]+ sec%.$",
			[67] = "^AM used %- Aura 100%% stronger for [%d]+ sec%.$",
			[68] = "^Casting Aura Mastery!$",
			[69] = "^Aura Mastery Activated[%s]*[!]*$",
			[70] = "^Aura Mastery Faded!$",
			[71] = "^Aura Mastery is up!!! Thanks Girl$",
			[72] = "^Casting |cff71d5ff|Hspell:[%d]+|h[\\[]Aura Mastery]|h|r$",
			[73] = "^Aura Mastery is up!!! Thanks [A-Z][%a]+$",
			[74] = "^%-[>]+[%-]*|cff71d5ff|Hspell:[%d]+|h[\\[]Aura Mastery]|h|r is Up[%-]*[<]+[%-]+$",
			[75] = "^CASTING AURA MASTERY$",
			[76] = "^Aura mastery UP[!]+$",
			[77] = "^uSED Aura mastery$",
			[78] = "^FOR THE HORDE[!]+$",
			[79] = "^Aura mastery UP !$",
			[80] = "^[%s]*Arua mastery UP[%s]*!$",
			[81] = "^AM used %- Aura 100%% stringer for 6 sec%.$",
			[82] = "^Frso Resistance Aura Used$",
			[83] = "^Frost Aura Mastery[!]*$",
			[84] = "^Shadow Aura Mastery[!]*$",
			[85] = "^Fire Aura Mastery[!]*$",
			[86] = "^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[]Frost Resistance Aura]|h|r AM faded$",
			[87] = "^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[]Fire Resistance Aura]|h|r AM faded$",
			[88] = "^[A-Z][%a]+'s |cff71d5ff|Hspell:[%d]+|h[\\[]Shadow Resistance Aura]|h|r AM faded$",
			[89] = "^[\\-]+AURA MASTERY[\\-]+$",
			[90] = "^Red Bull Gives Me Wings!$",
			[91] = "^Hammer of Justice$",
			[92] = "^%>%>%> Bubblewall is ACTIVE! %<%<%<$",
			[93] = "^>>> Divine Protection is down. <<<$",
			[94] = "^Ardent Defender just proc. Heal up!",
			[95] = "^RAIDWALL is UP!$",
			[96] = "^BUBBLE WALL is UP!$",
			[97] = "^ARDENT DEFENDER HEALED ME! KEEP ME UP FOR 2 MINUTES!$",
			[98] = "^RAIDWALL is DOWN!$",
			[99] = "^BUBBLE WALL is DOWN!$",
			[100] = "^Hand of Protection is down[%s!]*$",
			[101] = "^Hand of Sacrifice is down[%s!]*$",
			[102] = "^%>%>%> |cff71d5ff|Hspell:[%d]+|h[\\[]Divine Sacrifice]|h|r is down %<%<%<$",
			[103] = "^HOLY FUCKING WRATH FUCKING USED[!]*$",
			[104] = "^Free {rt5}[%s]*%> ME %<[%s]*{rt5}[%s]*TAKE IT IN [%d]+s!$",
			[105] = "^%>%>%> Bubblewall is down%. %<%<%<$",
		},
		["Priest"] = {
			[1] = "^Hymn of Hope is out.$",
			[2] = "^Hymn of Hope is casted!$",
			[3] = "^using Divine Hymn$",
			[4] = "^using Hymn of Hope$",
			[5] = "^Casting [Divine Hymn]$",
			[6] = "^Casting |cff71d5ff|Hspell:[%d]+|h[\\[]Divine Hymn]|h|r$",
			[7] = "^Casting |cff71d5ff|Hspell:[%d]+|h[\\[]Hymn of Hope]|h|r$",
			[8] = "^Using Hymn of Hope$",
			[9] = "^Using Divine Hymn$",
			[10] = "^Casting Hymn of Hope$",
			[11] = "^Divine Hymn USED[!]* Thanks [A-Z][%a]+$",
			[12] = "^Hymn of Hope USED[!]* Thanks [A-Z][%a]+$",
			[13] = "^Casting Hymn of Hope now[!]*$",
			[14] = "^innervae !! Hymn !!!$",
			[15] = "^Awesome! Hymn of Hope up$",
			[16] = "^Divine Hymn up!$",
			[17] = "^Hymn of Hope up!$",
			[18] = "^[\\[] Divine Hymn ] up$",
			[19] = "^%[ Hymn Of Hope %][%s]*up$",
			[20] = "^Divine Hymn is up!$",
			[21] = "^Divine Hymn is up!$",
			[22] = "^Guardian Spirit up, quit dying you fools$",
			[23] = "^Pain[%s]*Suppression on [A-Z][%a]+[%s]*%(Tank%-Pala%) Please[!]*$",
			[24] = "^Fear Ward up$",
			[25] = "^[\\[] Fear Ward ] up$",
			[26] = "^Fear Ward on [A-Z][%a]+$",
			[27] = "^Fear on [A-Z][%a%s]+ has ended!$",
		}, -- ["Rogue"] = {},	["Warlock"] = {},	
		["Warrior"] = {
			[1] = "^casting Shattering Throw on "..BubbleBossOne.."$"
		},
	}
	local SheklesFilterTableLower = {
		--["Any"] = {},
		["Shaman"] = {
			[1] = "^{rt[1,2,3,4,5,6,7,8]}[%s]*TIDE[%s]*{rt[1,2,3,4,5,6,7,8]}$",
			[2] = "^{[Ss][Tt][Aa][Rr]}[%s]*TIDE[%s]*{[Ss][Tt][Aa][Rr]}}$",
			[3] = "^mana tide is up please use hymn of hope[%s]*[<]*[%d]*[%s]*[!]*$",
			[4] = "^mana tide down[%s!]*$",
			[5] = "^mana tide totem by me [>]*come here for mana[<]*",
			[6] = "^mana totem here$",
			[7] = "^mana tide is active$",
			[8] = "^mana tide down$",
			[9] = "^mana tide down, hymn of hope now[%s!]*$",
			[10] = "^manatide up%.$",
			[11] = "^manatide down now[%s!]* use hymn of hope[%s!]*$",
			[12] = "^mana tide down. hymn now.$",
			[13] = "^mana tide incoming pop hymn[%s!]*$",
			[14] = "^mana tide up$",
			[15] = "^mana tide up . . .$",
			[16] = "^[a-z][%a]+ get ur mana back boy[%s!]*$",
			[17] = "^hymn of hope is up [%s!]* use mana totem$",
			[18] = "^mana tide totem down$",
			[19] = "^mana tide incoming pop hymn[%s!]*[%s!]*$",
			[20] = "^mana tide totem up[%s!]* hymm of hope[%s!]* mana tide totem up[%s!]* hymm of hope[%s!]*$",
			[21] = "^kemba gives [a-z][%a]+ some mana$",
			[22] = "^mana for big choddy$",
			[23] = "^mana tide$",
			[24] = "^mana tide totem up$",
			[25] = "^mana tide totem$",
			[26] = "^mana tide used[%s!]*$",
			[27] = "^mana tide used, use hymn hope$",
			[28] = "^pop mana hymn pls mana tide is up$",
			[29] = "^mana tide used, use hym hope$",
			[30] = "^mana tide is up[%s!]*$",
			[31] = "^mana tide totem is up[%s!]*$",
			[32] = "^mana tide, priest do hymn pls$",
			[33] = "^mana tide totem: please hymn of hope now[!]*$",
			[34] = "^mana tide totem used[!]* mana hymn please.$",
			[35] = "^mana tide down, disc mana hymn pls$",
			[36] = "^mana tide up[!]* hymn of hope [+]*[%s]*innervate now[!]*$",
			[37] = "^mana tide totem down[!]*$",
			[38] = "^mana tide is up, hymn of hope pls$",
			[39] = "^blyattide$",
			[40] = "^Mana tide UP = do your Hymn of hope$",
		},--["Druid"] = {}, ["Hunter"] = {},	["Death Knight"] = {},	["Mage"] = {},
		["Paladin"] = {
			[1] = "^aura mastery used[%s]*[!]*$",
			[2] = "^aura mastery is up[%s]*[!]*$",
			[3] = "^divine sacrifice for all!$",
			[4] = "^holy wrath on val'kyr shadowguard$",
			[5] = "^holy wrath used[%s!]*$",
			[6] = "^holy wrath used[%s]*%.$",
			[7] = "^[%a]+ used holy wrath[%s!]*$",
			[8] = "^holy wrath pero hindi kulong[%s!]*$",
			[9] = "^FCDAuthor used holy wrath[%s!]*$",
			[10] = "^dsac these nuts[%s]*[!]*$",
			[11] = "^dsac dis nuts[%s]*[!]*$",
		}, --["Priest"] = {},	["Rogue"] = {},	["Warlock"] = {},	["Warrior"] = {},
	}
	local SheklesFilterTableBoss = {
		["The Lich King"] = {
			[1] = "^[A-Z][%a]+ is like a bi%-ird, he'll only fly awa%-ay%.%.%.$",
			[2] = "^[A-Z][%a]+ is like a bi%-ird, she'll only fly awa%-ay%.%.%.$",
			[3] = "^[A-Z][%a]+ and [A-Z][%a]+ are like a bi%-ird. they'll only fly awa%-ay%.%.%.$",
			[4] = "^[A-Z][%a]+, [A-Z][%a]+ and [A-Z][%a]+ are like a bi%-ird, they'll only fly awa%-ay%.%.%.$",
			[5] = "^[A-Z][%a]+, [A-Z][%a]+, [A-Z][%a]+ and [A-Z][%a]+ are like a bi%-ird, they'll only fly awa%-ay%.%.%.$",
			[6] = "^Shambling Horror used Enrage [\\-] Stun/Tranq/Cooldown now!$",
			[7] = "^Shambling Horror [%d]+ Frenzy in [\\.%d]*s! Plague will kill it [%d]+s later[\\.]$",
			[8] = "^Shambling Horror [%d]+ Frenzy in [.%d]*s! Plague will not kill it!$",
			[9] = "^Normal Enrage! Tranq now!$",
			[10] = "^Hard Enrage!$",
			[11] = "^Hard Enrag!$",
			[12] = "^oh shit! dispel me in a bit.$",
			[13] = "^Infest #[%d]+ coming up!$",
			[14] = "^Raging Spirit on me[%s]*[!]*$",
			[15] = "^Quake! Run inside!!$",
			[16] = "^Quake! Get in the middle!$",
			[17] = "^Reaper on me[%s]*!$",
			[18] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Soul Reaper]|h|r on me!$",
			[19] = "^[A-Z][%a]+ picked up!$",
			[20] = "^Rsham is Grabbed!$",
			[21] = "^Rshaman is Grabbed!$",
			[22] = "^Hpala is Grabbed!$",
			[23] = "^Disc is Grabbed!$",
			[24] = "^Rdruid is Grabbed!$",
		},
		["Halion"] = {
			[1] = "^Meteor Strike in [%d]+ sec. Run to the other side!$",
			[2] = "^[>]*Meteor[!]* Watch out[!]*[<]*$",
			[3] = "^[%s]*Meteor[%s]*$",
			[4] = "^[%s]*[Fiery Combustion] on me![%s]*$",
			[5] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Twilight Cutter]|h|r in [%d]+ seconds! Adjust your position!$",
			[6] = "^Twilight Cutter in [%d]+ sec%. Watch orbs[!]*$",
			[7] = "^Twilight Cutter in [%d]+ seconds! Adjust your position!$",
			[8] = "^[%s]*Cutters![%s]*$",
			[9] = "^[>]*Cutters[!]* Adjust your position[!]*[<]*$",
			[10] = "^60%% %- MORE DPS[!]+$",
			[11] = "^40%% %- STOP ON BOSS[!]+$",
			[12] = "^40%% %- STOP ON BOSS[!]+$",
			[13] = "^Flame beacon on me[%s]*!$",
			[14] = "^[%s]*Flame beacon on me[%s]*![%s]*$",
			[15] = "^Beacon tneket$",
			[16] = "^[%s]*Fire bomb on ME![%s]*$",
			[17] = "^Cookie Cutter in [%d]+ seconds[!]*$",
		},
		["Lord Marrowgar"] = {
			[1] = "^Spike here! HELP!!!!$",
			[2] = "^I am spiked !! ez afk$",
			[3] = "^spyke !!!$",
		},
		["Lady Deathwhisper"] = {
			[1] = "^I got controlled, CC me NOW[!]* Dont Kill Me Dog[!]*$",
			[2] = "^curse of tongues is up!$",
			[3] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Cure of Torpos]|h|r on me[!]*$",
			[4] = "^curse of torpor, dispel me !!$",
			[5] = "^Curse of Torpor . Dispel me !!$",
			[6] = "^%-%-REMEMEBER TO EQUIP WEAPONS / REFRESH SELF BUFF %& DRUID BUFF after MC [!]*$",
			[7] = "^[iI] got controlled. CC me NOW[!]*$",
			[8] = "on me. Dispel, please$",
			[9] = "^OMG! Dispel me in a bit$",
			[10] = "^Cyclone me ! DON'T AOE !$",
			[11] = "^Spirit on me$",
			[12] = "^PLEASE DONT KILL ME! CC ANYONE?$",
			[13] = "^Spirit on me!$",
			[14] = "^summoning vengeful spirits %-%- spread[!]*$",
			[15] = "^KILL ME BEACHES[!]+$",
			[16] = "^Curse of Torpor[%s]*,[%s]*Dispel Me !!$",
		},
		["Deathbringer Saurfang"] = {
			[1]	= "^TAUNT$",
			[2]	= "^|cff71d5ff|Hspell:[%d]+|h[\\[]Mark of the Fallen Champion]|h|r on me!$",
			[3] = "^mark on me!$",
		},
		["Festergut"] = {
			[1] = "^Espora de gas on me!$",
			[2] = "^Gas Spore on TABK!$",
			[3] = "^Gas Spore on TANK!$",
			[4] = "^9 STACKS[%s]*%. TAUNT[%s]*[!]+$",
			[5] = "^Gas Spore on me!$",
			[6] = "^Vile Gas on me!$",
			[7] = "^Gas Spore on [A-Z][%a]+!$",
			[8] = "^Gas inmundo on me!$",
			[9] = "^VILED!!! FFS SPREAD!!!$",
			[10] = "^spor on me!$",
			[11] = "^stack on me !!$",
			[12] = "^[%s]*defensives!$",
			[13] = "^Activate your defensives!$",
			[14] = "^Spor on me$",
			[15] = "^cyka bleat[%s]*[!]*$",
			[16] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Pungent Blight]|h|r! Be careful!$",
			[17] = "^Deffenslves!$",
			[18] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Gas Spore]|h|r on me!$",
			[19] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Gas Spore]|h|r on me! Stack up if you don't have any yet!$",
			[20] = "^|cff71d5ff|Hspell:[%d]+|h[\\[][%a%s-]*]|h|r! Activate your defensives!$",
			[21] = "^Spore on me!$",
		},
		["Rotface"] = {
			[1] = "^Infected! Little ooze on me in a bit$",
			[2] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Unstable Ooze Explosion]|h|r! Be careful!$",
			[3] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Mutated Infection]|h|r on me[!]*$",
			[4] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Mutated Infection]|h|r on me[!]* WTB merge[!]*$",
			[5] = "^Mutated Infection on me!$",
			[6] = "^Explosion!$",
		},
		["Professor Putricide"] = {
			[1] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Choking Gas Bomb]|h|r! Be careful and don't step in it!$",
			[2] = "^malleable goo on me!$",
			[3] = "^WTF[!]+ Why on me[?]+$",
			[4] = "^Red [dD]ebuff$",
			[5] = "^Malleables$",
			[6] = "^Stack on me[%s]*[!]*$",
			[7] = "^cyka bleat[%s]*[!]*$",
			[8] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Gaseous Bloat]|h|r on me[!]*$",
			[9] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Ooze Variable]|h|r on me[!]*$",
			[10] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Malleable Goo]|h|r on me[!]* Here we go again[%s]*%.%.%.$",
			[11] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Malleable Goo]|h|r! Watch out!$",
			[12] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Malleable Goo]|h|r! Be careful!$",
			[13] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Choking Gas Bomb]|h|r! Be careful!$",
			[14] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Volatile Ooze Adhesive]|h|r on me! WTB merge!$",
			[15] = "^Choking$",
			[16] = "^[Ii|] need to run away from red ooze !!$",
			[17] = "^Green [dD]ebuff$",
			[18] = "^Goo ball incoming!$",
		},
		["Prince Keleseth"] = {
			[1] = "^vortex!$",
			[2] = "^shock vortex on me!$",
			[3] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Empowered Shock Vortex]|h|r[!]* Spread out[!]*$",
			[4] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Empowered Shock Vortex]|h|r! Be careful!$",
			[5] = "^conjure empowered flame on me!$",
			[6] = "^Flames on [A-Z][%a]+! Help me and soak[%s!]*$",
		},
		["Prince Valanar"] = {
			[1] = "^vortex!$",
			[2] = "^shock vortex on me!$",
			[3] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Empowered Shock Vortex]|h|r[!]* Spread out[!]*$",
			[4] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Empowered Shock Vortex]|h|r! Be careful!$",
			[5] = "^conjure empowered flame on me!$",
			[6] = "^Flames on [A-Z][%a]+! Help me and soak[%s!]*$",
		},
		["Prince Taldaram"] = {
			[1] = "^vortex!$",
			[2] = "^shock vortex on me!$",
			[3] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Empowered Shock Vortex]|h|r[!]* Spread out[!]*$",
			[4] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Empowered Shock Vortex]|h|r! Be careful!$",
			[5] = "^conjure empowered flame on me!$",
			[6] = "^Flames on [A-Z][%a]+! Help me and soak[%s!]*$",
		},
		["Blood-Queen Lana'thel"] = {
			[1] = "^link up!$",
			[2] = "on me! Stack up if you don't have any yet!$",
			[3] = "^shadows on me !$",
			[4] = "^link fast!$",
			[5] = "^Yikes! Catch me if you can! xD$",
			[6] = "^BITE!!$",
			[7] = "^I'm hungry!$",
			[8] = "^Link$",
			[9] = "^Come to daddy fast ^^$",
			[10] = "^Swarming Shadows on me!$",
			[11] = "^Swarming Shadow[s]* on FCDAuthor!$",
			[12] = "^Hug me sisters!$",
			[13] = "^Links %-%-%> Stack$",
			[14] = "^Stack on me$",
			[15] = "^Pact on [A-Z][%a]+[!]+$",
			[16] = "^GET OVER HERE !!!$",
			[17] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Swaming Shadows]|h|r on me[!]* Out of the way[!]*$",
			[18] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Pact of the Darkfallen]|h|r on me[!]*$",
			[19] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Pact of the Darkfallen]|h|r on me[!]* Come together[!]*$",
			[20] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Swarming Shadows]|h|r on me[!]*$",
			[21] = "^Shadows On Me!!!$",
		},
		["Valithria Dreamwalker"] = {
			[1] = "^I lost my portal stacks[%s]*[!]+$",
		},
		["Sindragosa"] = {
			[1] = "^6 Instability Stacks!$",
			[2] = "^Instability [%d]+ stacks$",
			[3] = "^Unchained Magic on me!$",
			[4] = "^Unchained on me!$",
			[5] = "^Unchained on me! IM AFK!$",
			[6] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Unchained Magic]|h|r on me$",
			[7] = "^[%d]+cChilled Stacks!$",
			[8] = "^[%d]+ Chilled Stacks!$",
			[9] = "^YellBeacon$",
			[10] = "^Frost Beacon on FCDAuthor$",
			[11] = "^stacks cleared!$",
			[12] = "^fvck stacks!$",
			[13] = "^Oof [Ii][a]*m frozen !$",
			[14] = "^WTF!!! Why on me????$",
			[15] = "^|cff71d5ff|Hspell:[%d]+|h[\\[]Frost Beacon]|h|r on me!$",
			[16] = "^Tomb on me!$",
		},
	}
	local FilterNow = false
	local CustomPrintMessageChan = 0
	if not FilterNow and FatCooldowns:GetModule("Display").db.profile.chatfilter[99916] and (channel == "CHAT_MSG_MONSTER_YELL" or channel == "CHAT_MSG_MONSTER_SAY") then 
		FilterNow = true
		CustomPrintMessageChan = FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99916].chan
	end -- npc 
	if author ~= nil and author ~= UnitName("player") then
		if not FilterNow and FatCooldowns:GetModule("Display").db.profile.chatfilter[98938] and language:find("Demonic") then
			FilterNow = true
			CustomPrintMessageChan = FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[98938].chan
		end -- Demonic language
		if not FilterNow and FatCooldowns:GetModule("Display").db.profile.chatfilter[99915] and msg:find("[\228-\237]") then 
			FilterNow = true
			CustomPrintMessageChan = FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99915].chan
		end -- Japanese, Chinese and Korean Bubbles
		if not FilterNow and FatCooldowns:GetModule("Display").db.profile.chatfilter[99913] and msg:find("[\208]") then
			FilterNow = true
			CustomPrintMessageChan = FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99913].chan
		end -- Russian Bubbles
		if not FilterNow and FatCooldowns:GetModule("Display").db.profile.chatfilter[99937] then  -- Spanish Bubbles
			for x,c in pairs(SpanishTable) do
				if msg:lower():find(c) then
					FilterNow = true
					CustomPrintMessageChan = FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99937].chan
					break
				end
			end
		end
		if not FilterNow and FatCooldowns:GetModule("Display").db.profile.chatfilter[99938] then -- unbound
			for x,c in pairs(UnboundTable) do
				if msg:lower():find(c) then 
					FilterNow = true
					CustomPrintMessageChan = FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99938].chan
					break
				end
			end
		end

		if not FilterNow and FatCooldowns:GetModule("Display").db.profile.chatfilter[99933] and UnitClass("player") ~= L["Druid"] then -- innervate
			for x,c in pairs(InnervateTable) do
				if msg:find(c) then
					FilterNow = true
					CustomPrintMessageChan = FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99933].chan
					break
				end
			end
			if not FilterNow then
				for x,c in pairs(InnervateTableLower) do
					if c:find("FCDAuthor") then c = gsub(c, "FCDAuthor", author) end
 					if msg:lower():find(c) then
 						FilterNow = true
 						CustomPrintMessageChan = FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99933].chan
 						break
 					end
				end
			end
		end
		if not FilterNow and FatCooldowns:GetModule("Display").db.profile.chatfilter[99934] then -- shkles list
			for x,c in pairs(SheklesFilterTable) do
				if not FilterNow and (x == "Any" or L[x] == UnitClass(author)) then
					for u,p in pairs(c) do
						if p:find("FCDAuthor") then p = gsub(p, "FCDAuthor", author) end
						if msg:find(p) then 
							FilterNow = true
							CustomPrintMessageChan = FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99934].chan
							break
						end
					end
				end
			end
			if not FilterNow then
				for x,c in pairs(SheklesFilterTableLower) do
					if not FilterNow and (x == "Any" or L[x] == UnitClass(author)) then
						for u,p in pairs(c) do
							if p:find("FCDAuthor") then p = gsub(p, "FCDAuthor", author) end
		 					if msg:lower():find(p) then
		 						FilterNow = true
		 						CustomPrintMessageChan = FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99934].chan
		 						break
		 					end
		 				end
		 			end
				end
			end
			if not FilterNow then
				for x,c in pairs(SheklesFilterTableBoss) do
					if x == UnitName("boss1") then
						for u,p in pairs(c) do
							if p:find("FCDAuthor") then p = gsub(p, "FCDAuthor", author) end
	 						if msg:find(p) then 
	 							FilterNow = true
								CustomPrintMessageChan = FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99934].chan
	 							break 
	 						end
	 					end
	 				end
				end
			end
		end

		if next(FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList) then
			for l,p in pairs(FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList) do
				if FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Bubbles ~= nil and FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Bubbles then
					local Message = l
					if Message:find("FCDAuthor") then Message = gsub(Message, "FCDAuthor", author) end 
					if Message:find("FCDBoss1") then Message = gsub(Message, "FCDBoss1", UnitName("boss1")) end 
					if Message:find("FCDAnyLink") then
						local pattern = "|c%x+|H(%w+):.-|h%[.-%]|h|r"
						CurrentMessage = gsub(CurrentMessage, pattern, "FCDAnyLink")	
					end
					if Message:find("FCDGroupPlayer") then Message = FCDGroupPlayerFound(Message) end
					local CurrentMessage = msg
					if FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Match ~= nil and FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Match then else
						Message = SafeLower(Message)
						CurrentMessage = SafeLower(CurrentMessage)
					end
					if CurrentMessage:find(Message) then 
						if next(FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Filter) then
							for g,f in pairs(FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[l].Filter) do
								if f and g == channel then
									CustomPrintMessageChan = FatCooldowns:GetModule("Display").db.profile.CustomChatFilterReporter
									FilterNow = true
									break
								end
							end
						end
					end
				end
			end
		end

	end

	if FilterNow then
		if FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99917] and CustomPrintMessageChan > 0 and (FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[BubblesFilter] == nil or FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[BubblesFilter] ~= msg) then
		FatCooldowns:GetModule("Display").db.profile.ChatFilterReporterMessage[BubblesFilter] = msg _G["ChatFrame"..CustomPrintMessageChan]:AddMessage("FCDBubblesFilter:".."|Hplayer:"..author.."|h["..author.."]|h"..": "..msg, 1,0.49,0.04) end
	
		if IsAddOnLoaded("ElvUI") then
			if LoadEU then E, _, V, P, G = unpack(ElvUI) LoadEU = false end
			E.private.general.chatBubbles = "disabled"
		end
		SetCVar("chatBubbles", 0) SetCVar("chatBubblesParty", 0)
		if FatCooldowns:GetModule("Display").db.profile.chatfilter[99897] then
			return false 
		else
			return true
		end
	else
		if IsAddOnLoaded("ElvUI") then
			if LoadEU then E, _, V, P, G = unpack(ElvUI) LoadEU = false end
			E.private.general.chatBubbles = FatCooldowns:GetModule("Display").db.profile.ElvUiCB
		end
		SetCVar("chatBubbles", 1) SetCVar("chatBubblesParty", 1)
		return false
	end
end

local function FCDGroupPlayerFound(msg)
	local members = 0
	if UnitInRaid("player") then
		members = GetNumRaidMembers()
	else
		members = GetNumPartyMembers() + 1
	end
	local matchedPlayers = {}
	for i = 1, members do
		local ScanName
		if UnitInRaid("player") then
			ScanName = UnitName("raid" .. i)
		elseif not UnitInRaid("player") and i <= GetNumPartyMembers() then
			ScanName = UnitName("party" .. i)
		else
			ScanName = UnitName("player")
		end
		if ScanName and ScanName ~= "Unknown" then
			local lowerScanName = string.lower(ScanName)
			if string.find(string.lower(msg), lowerScanName, 1, true) and
			   string.find(string.lower(LowerMessage), lowerScanName, 1, true) then
				table.insert(matchedPlayers, ScanName)
			end
		end
	end
	local replacementIndex = 1
	msg = string.gsub(msg, "FCDGroupPlayer", function()
		local replacementName = matchedPlayers[replacementIndex]
		replacementIndex = replacementIndex + 1
		return replacementName or "FCDGroupPlayer"
	end)
	return msg 
end

function FCDMessageEdit(msg)
	local WorkingWithMSG = msg
	if UnitName("boss1") ~= nil and WorkingWithMSG:find("FCDBoss1") then WorkingWithMSG = gsub(WorkingWithMSG, UnitName("boss1"), "FCDBoss1") end
	local pattern = "|c%x+|H(%w+):.-|h%[.-%]|h|r"
	if WorkingWithMSG:find(pattern) then
		WorkingWithMSG = gsub(WorkingWithMSG, pattern, "FCDAnyLink")	
	end
	local members = 0
	if UnitInRaid("player") then
		members = GetNumRaidMembers()
	else
		members = GetNumPartyMembers() + 1
	end
	local matchedPlayers = {}
	for i = 1, members do
		local ScanName
		if UnitInRaid("player") then
			ScanName = UnitName("raid" .. i)
		elseif not UnitInRaid("player") and i <= GetNumPartyMembers() then
			ScanName = UnitName("party" .. i)
		else
			ScanName = UnitName("player")
		end
		if ScanName and ScanName ~= "Unknown" then
			if WorkingWithMSG:find(ScanName) then
	 			WorkingWithMSG = gsub(WorkingWithMSG, ScanName, "FCDGroupPlayer")	
	 		end
	 	end
	 end
	 return WorkingWithMSG
end

local PopupUnits = {"FRIEND"}
local lastClickedMessage = {}
local chatEvents = {"CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_WHISPER", "CHAT_MSG_PARTY", "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_CHANNEL"}

local function RegisterChatEvents()
	for _, event in ipairs(chatEvents) do
		local f = CreateFrame("Frame")
		f:RegisterEvent(event)
		f:SetScript("OnEvent", function(self, evt, message, author)
			lastClickedMessage[author] = {
				message = message,
				time = GetTime(),
				chan = evt
			}
		end)
	end
end

local cleanupInterval = 60
local elapsed = 0
local function CleanupOldMessages(maxAge)
	local now = GetTime()
	for author, data in pairs(lastClickedMessage) do
		if (now - data.time) > maxAge then
			lastClickedMessage[author] = nil
		end
	end
end

local cleanupFrame = CreateFrame("Frame")
cleanupFrame:SetScript("OnUpdate", function(self, delta)
	elapsed = elapsed + delta
	if elapsed >= cleanupInterval then
		elapsed = 0
		CleanupOldMessages(300)
	end
end)

local MagicChars = true
local function ShowEditMessagePopup(playerName, originalMessage, chan)
	local popupName = "FCD_EditMessagePopup"
	if not _G[popupName] then
		local window = CreateFrame("Frame", popupName, UIParent)
		_G[popupName] = window
		UIPanelWindows[popupName] = { area = "center", pushable = 0, whileDead = 1 }
		HideUIPanel(FCD_EditMessagePopup)
		
		window:SetFrameStrata("FULLSCREEN_DIALOG")
		window:SetWidth(600)
		window:SetHeight(300 / 1.618)
		window:SetPoint("CENTER")
		window:SetMovable(true)
		window:EnableMouse(true)
		window:RegisterForDrag("LeftButton")
		window:SetScript("OnDragStart", window.StartMoving)
		window:SetScript("OnDragStop", window.StopMovingOrSizing)

		local titlebg = window:CreateTexture(nil, "BORDER")
		titlebg:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Title-Background")
		titlebg:SetPoint("TOPLEFT", 9, -6)
		titlebg:SetPoint("BOTTOMRIGHT", window, "TOPRIGHT", -28, -24)

		local dialogbg = window:CreateTexture(nil, "BACKGROUND")
		dialogbg:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-CharacterTab-L1")
		dialogbg:SetPoint("TOPLEFT", 8, -12)
		dialogbg:SetPoint("BOTTOMRIGHT", -6, 8)
		dialogbg:SetTexCoord(0.255, 1, 0.29, 1)

		local topleft = window:CreateTexture(nil, "BORDER")
		topleft:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		topleft:SetWidth(64)
		topleft:SetHeight(64)
		topleft:SetPoint("TOPLEFT")
		topleft:SetTexCoord(0.501953125, 0.625, 0, 1)

		local topright = window:CreateTexture(nil, "BORDER")
		topright:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		topright:SetWidth(64)
		topright:SetHeight(64)
		topright:SetPoint("TOPRIGHT")
		topright:SetTexCoord(0.625, 0.75, 0, 1)

		local top = window:CreateTexture(nil, "BORDER")
		top:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		top:SetHeight(64)
		top:SetPoint("TOPLEFT", topleft, "TOPRIGHT")
		top:SetPoint("TOPRIGHT", topright, "TOPLEFT")
		top:SetTexCoord(0.25, 0.369140625, 0, 1)

		local bottomleft = window:CreateTexture(nil, "BORDER")
		bottomleft:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		bottomleft:SetWidth(64)
		bottomleft:SetHeight(64)
		bottomleft:SetPoint("BOTTOMLEFT")
		bottomleft:SetTexCoord(0.751953125, 0.875, 0, 1)

		local bottomright = window:CreateTexture(nil, "BORDER")
		bottomright:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		bottomright:SetWidth(64)
		bottomright:SetHeight(64)
		bottomright:SetPoint("BOTTOMRIGHT")
		bottomright:SetTexCoord(0.875, 1, 0, 1)

		local bottom = window:CreateTexture(nil, "BORDER")
		bottom:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		bottom:SetHeight(64)
		bottom:SetPoint("BOTTOMLEFT", bottomleft, "BOTTOMRIGHT")
		bottom:SetPoint("BOTTOMRIGHT", bottomright, "BOTTOMLEFT")
		bottom:SetTexCoord(0.376953125, 0.498046875, 0, 1)

		local left = window:CreateTexture(nil, "BORDER")
		left:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		left:SetWidth(64)
		left:SetPoint("TOPLEFT", topleft, "BOTTOMLEFT")
		left:SetPoint("BOTTOMLEFT", bottomleft, "TOPLEFT")
		left:SetTexCoord(0.001953125, 0.125, 0, 1)

		local right = window:CreateTexture(nil, "BORDER")
		right:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		right:SetWidth(64)
		right:SetPoint("TOPRIGHT", topright, "BOTTOMRIGHT")
		right:SetPoint("BOTTOMRIGHT", bottomright, "TOPRIGHT")
		right:SetTexCoord(0.1171875, 0.2421875, 0, 1)

		local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", 2, 1)
		close:SetScript("OnClick", CloseFCDEditBox)

		sessionLabel = window:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		sessionLabel:SetJustifyH("CENTER")
		sessionLabel:SetPoint("TOP", titlebg, "TOP", 0, -3) -- center relative to titlebg
		sessionLabel:SetWidth(titlebg:GetWidth())
		sessionLabel:SetTextColor(1, 1, 1, 1)
		sessionLabel:SetText("|cffffff00FCD Custom Message Filter|r")

		textArea = CreateFrame("EditBox", popupName.."ScrollText", scroll)
		textArea:SetAutoFocus(false)
		textArea:SetMultiLine(true)
		textArea:SetFontObject(GameFontHighlight)
		textArea:SetMaxLetters(99999)
		textArea:EnableMouse(true)
		textArea:SetScript("OnEscapePressed", textArea.ClearFocus)
		textArea:SetWidth(450)
		textArea:SetText(originalMessage or "")

		nextButton = CreateFrame("Button", "BugSackNextButton", window, "UIPanelButtonTemplate2")
		nextButton:SetPoint("BOTTOMRIGHT", window, -11, 16)
		nextButton:SetWidth(130)
		nextButton:SetText("Confirm")
		nextButton:SetScript("OnClick", function()
			local editedMessage = textArea:GetText()
			local magic_chars = {
			  ["^"] = true,
			  ["$"] = true,
			  ["("] = true,
			  [")"] = true,
			  ["%"] = true,
			  ["."] = true,
			  ["["] = true,
			  ["]"] = true,
			  ["*"] = true,
			  ["+"] = true,
			  ["-"] = true,
			  ["?"] = true,
			}
			local function escapePattern(str)
			  local pattern = str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
			  return pattern
			end
			if MagicChars then editedMessage = escapePattern(editedMessage) end
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Custom Chat Filter Added: "..editedMessage)
			if chan == "CHAT_MSG_RAID" or chan == "CHAT_MSG_RAID_LEADER" then
				if FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[editedMessage] == nil then
			   		FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[editedMessage] = {Filter = {["CHAT_MSG_RAID_LEADER"] = true, ["CHAT_MSG_RAID"] = true}}
			   	else
			   		FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[editedMessage].Filter["CHAT_MSG_RAID_LEADER"] = true
			   		FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[editedMessage].Filter["CHAT_MSG_RAID"] = true
			   	end
			elseif chan == "CHAT_MSG_PARTY" or chan == "CHAT_MSG_PARTY_LEADER" then
				if FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[editedMessage] == nil then
					FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[editedMessage] = {Filter = {["CHAT_MSG_PARTY"] = true, ["CHAT_MSG_PARTY_LEADER"] = true}}
				else
			   		FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[editedMessage].Filter["CHAT_MSG_PARTY_LEADER"] = true
			   		FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[editedMessage].Filter["CHAT_MSG_PARTY"] = true
				end
			else
				if FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[editedMessage] == nil then
					FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[editedMessage] = {Filter = {[chan] = true}}
				else
					FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[editedMessage].Filter[chan] = true
				end
			end
	   		if FatCooldowns:GetModule("Display").db.profile.ChatFilterMenuBubbles then FatCooldowns:GetModule("Display").db.profile.CustomChatFilterList[editedMessage].Bubbles = true end
			window:Hide()
		end)

		toggle = CreateFrame("CheckButton", "FCD_ToggleButton", window, "UICheckButtonTemplate")
		toggle:SetPoint("BOTTOMLEFT", window, 11, 16) -- Adjust as needed
		toggle:SetWidth(24)
		toggle:SetHeight(24)

		if toggle.text then
		    toggle.text:SetText("Magic Characters")
		else
		    toggle.label = toggle:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		    toggle.label:SetPoint("LEFT", toggle, "RIGHT", 2, 0)
		    toggle.label:SetText("Magic Characters")
		end
		toggle:SetChecked(MagicChars)
		toggle:SetScript("OnClick", function(self)
		    if self:GetChecked() then
		    	MagicChars = true
		    else
		    	MagicChars = false
		    end
		end)

		local scroll = CreateFrame("ScrollFrame", popupName.."Scroll", window, "UIPanelScrollFrameTemplate")
		scroll:SetPoint("TOPLEFT", window, 16, -36)
		scroll:SetPoint("BOTTOMRIGHT", nextButton, "TOPRIGHT", -24, 8)
		scroll:SetScrollChild(textArea)

		_G["FCD_EditMessagePopup"] = window
		tinsert(UISpecialFrames, "FCD_EditMessagePopup")
		window:Show()
	else
		local window = _G[popupName]
		window:Show()
		textArea:SetText(originalMessage or "")
	end
end

function CloseFCDEditBox() HideUIPanel(FCD_EditMessagePopup) end

function FCDCFAddMenu() 
	if FatCooldowns:GetModule("Display").db.profile.ChatFilterMenu then
		UnitPopupButtons["FCD_BLOCK"] = {
			text = "FCD Block Message",
			dist = 0,
			func = function()
		        mod:FCDBlockLastMessage()
		    end,
		}
		tinsert(UnitPopupMenus["FRIEND"],	#UnitPopupMenus["FRIEND"] - 1,	"FCD_BLOCK")
	end
end

function mod:FCDBlockLastMessage(name) 
	local msgData = lastClickedMessage[name]
	if msgData then
		local FCDEditedMessage = FCDMessageEdit(msgData.message)
		ShowEditMessagePopup(name, FCDEditedMessage, msgData.chan)
		sessionLabel:SetText("|cffffff00FCD Custom Message Filter|r")
	else
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: No message info available.")
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	RegisterChatEvents()
	if FatCooldowns:GetModule("Display").db.profile.ChatFilterMenu then
		FCDCFAddMenu()
		hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData, ...)
	        for i=1, UIDROPDOWNMENU_MAXBUTTONS do
	            local button = _G["DropDownList"..UIDROPDOWNMENU_MENU_LEVEL.."Button"..i]
	            if button.value == "FCD_BLOCK" then
	                button.func = function()
	             	   mod:FCDBlockLastMessage(name)
	            	end
	            end
	        end
	    end)
	end
end)