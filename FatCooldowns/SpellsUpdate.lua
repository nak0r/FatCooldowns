assert(FatCooldowns, "FatCooldowns not found!")

local Rank1Allowed = {
	[(GetSpellInfo(116))] = true,
	[(GetSpellInfo(1949))] = true,
	[(GetSpellInfo(686))] = true,
	[(GetSpellInfo(1008))] = true,
	[(GetSpellInfo(604))] = true,
	[(GetSpellInfo(1120))] = true,}

local RankMaxMinusOneAllowed = {[(GetSpellInfo(2120))] = true,}

local AnyRankAllowed = {
	[(GetSpellInfo(1454))] = true,
	[(GetSpellInfo(18220))] = true,
	[(GetSpellInfo(755))] = true,
	[(GetSpellInfo(118))] = true,
	[(GetSpellInfo(587))] = true,
	[(GetSpellInfo(5504))] = true,
	[(GetSpellInfo(42955))] = true,}

local TargetLevel = {
	[(GetSpellInfo(139))] = true,
	[(GetSpellInfo(61295))] = true,
	[(GetSpellInfo(33763))] = true,
	[(GetSpellInfo(774))] = true,
	[(GetSpellInfo(48438))] = true,
	[(GetSpellInfo(8936))] = true,
	[(GetSpellInfo(976))] = true,
	[(GetSpellInfo(27683))] = true,
	[(GetSpellInfo(1243))] = true,
	[(GetSpellInfo(21562))] = true,
	[(GetSpellInfo(14752))] = true,
	[(GetSpellInfo(27681))] = true,
	[(GetSpellInfo(1126))] = true,
	[(GetSpellInfo(21849))] = true,
	[(GetSpellInfo(23028))] = true,
	[(GetSpellInfo(61316))] = true,
	[(GetSpellInfo(467))] = true,
	[(GetSpellInfo(19740))] = true,
	[(GetSpellInfo(19742))] = true,
	[(GetSpellInfo(25782))] = true,
	[(GetSpellInfo(25894))] = true,
	[(GetSpellInfo(1459))] = true,
	[(GetSpellInfo(1008))] = true,
	[(GetSpellInfo(604))] = true,
	[(GetSpellInfo(17))] = true,}

local function FCDSU_GetGlobalSpellId(slotId)
	local type, _, _,id = GetActionInfo(slotId)
	if not type == "spell" or not id then return false end
	return id
end

local function FCDSU_GetMaximalSpellRank(spellId)
	local name, rank1 = GetSpellInfo(spellId)
	if rank1 == "" or not rank1 then return false end
	local _, rank2 = GetSpellInfo(name)
	return rank2
end

local function FCDSU_IsSlotOutdated(slotId)
	local id = FCDSU_GetGlobalSpellId(slotId)
	if not id then return false end
	local name, rank1 = GetSpellInfo(id)
	if rank1 == "" or not rank1 then return false, id end
	if Rank1Allowed[name] and rank1 == "Rank 1" then return false, id end
	if AnyRankAllowed[name] then return false, id end
	if RankMaxMinusOneAllowed[name] and rank1 == "Rank 8" then return false, id end
	if FatCooldowns:GetModule("Display").db.profile.FCDSPBlackList[name] then return false, id end
	local rank2 = FCDSU_GetMaximalSpellRank(id)
	if not rank2 or rank1 == rank2 then return false, id end
	return true, id
end

local function FCDSU_UpdateSlot(i, slotId)
	local id = FCDSU_GetGlobalSpellId(slotId)
	if not id then return end
	local name = GetSpellInfo(id)
	PickupSpell(name)  
	PlaceAction(slotId) 
	ClearCursor()
end

local function FCDSU_UpdateMacros()
	local AccountMacros, PersonalMacros = GetNumMacros()
	for i = 1, AccountMacros do
		local name, iconTexture, macro = GetMacroInfo(i)
		local CanUpdate = true
		if macro then
			for name2, name3 in pairs(FatCooldowns:GetModule("Display").db.profile.FCDSPBlackList) do
				if macro:find(name2) then CanUpdate = false end
			end
			if CanUpdate then 
				local updatedMacro = macro:gsub("%(Rank %d+%)", "")
				if updatedMacro ~= macro then
					FatCooldowns:GetModule("Display"):FCDPrefixPrint("Removing Rank from macro "..name)
					EditMacro(i, name, nil, updatedMacro)
				end
		  	end
		end
	end
   	for i = 37, PersonalMacros do
		local name, macro = GetMacroInfo(i)
		local CanUpdate = true
		if macro then
			for name2, name3 in pairs(FatCooldowns:GetModule("Display").db.profile.FCDSPBlackList) do
				if macro:find(name2) then CanUpdate = false end
			end
			if CanUpdate then 
				local updatedMacro = macro:gsub("%(Rank %d+%)", "")
				if updatedMacro ~= macro then
					FatCooldowns:GetModule("Display"):FCDPrefixPrint("Removing Rank from macro "..name)
					EditMacro(i, name, nil, updatedMacro, 1, 1)
				end
		  	end
		end
	end
end

local function FCDSU_CheckSlots()
	local slots = {}
	for i=1, 120 do
		local outdated, id = FCDSU_IsSlotOutdated(i)
		if outdated then
			local name, rank = GetSpellInfo(id)
			local SpellLink = GetSpellLink(id)
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..SpellLink.." ("..rank..")".." updated rank")
			tinsert(slots, i)
		end
	end
	if not UnitAffectingCombat("player") then table.foreach(slots, FCDSU_UpdateSlot) end
end

local messageTimers = {}
local function ShouldSendMessage(sourceName, spellName)
	local key = sourceName .. ":" .. spellName
	local now = GetTime()
	local lastTime = messageTimers[key]
	if not lastTime or (now - lastTime > 600) then
		messageTimers[key] = now
		return true
	end
	return false
end

local function IsDownranked(sourceName, spellId, spellName, sourceLevel, destName)
	local data = FatCooldowns.SpellData[spellId]
	if not data or not data.rank then return false end
	local maxRankId = spellId
	local maxRankData = data
	while maxRankData.next and FatCooldowns.SpellData[maxRankData.next] and FatCooldowns.SpellData[maxRankData.next].level <= sourceLevel do
		maxRankId = maxRankData.next
		maxRankData = FatCooldowns.SpellData[maxRankId]
	end
	if (data.rank == 1 and Rank1Allowed[spellName]) or (data.rank == maxRankData.rank - 1 and RankMaxMinusOneAllowed[spellName]) or (AnyRankAllowed[spellName]) then return false end
	if maxRankId ~= spellId then return true, data.rank, FatCooldowns.SpellData[maxRankId].rank, maxRankId end
	return false
end

local function IsTargetLevelAppropriate(spellId, destName)
	if TargetLevel[GetSpellInfo(spellId)] then
		local targetLevel = UnitLevel(destName)
		if targetLevel and targetLevel < 80 then return false end
	end
	return true
end

local function FCDSU_OnCombatLogEvent(self, event, ...)
	local timestamp, combatEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName = ...
	if not sourceName or sourceName == UnitName("player") and FatCooldowns:GetModule("Display").db.profile.FCDSPPlayer then return end
	if (_G.bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_MASK) == COMBATLOG_OBJECT_TYPE_PLAYER) and combatEvent:match("^SPELL") and combatEvent ~= "SPELL_AURA_REMOVED" and combatEvent ~= "SPELL_AURA_FAILED" and spellName and FatCooldowns.SpellData[spellId] then 
		local sourceLevel = UnitLevel(sourceName)
		if FatCooldowns:GetModule("Display").db.profile.FCDSP80 and sourceLevel and sourceLevel < 80 then return end
		if sourceLevel and sourceLevel < 80 then sourceLevel = sourceLevel - 1 end
		local IsDown, DRank, MRank, MRankID =  IsDownranked(sourceName, spellId, spellName, sourceLevel or 80, destName)
		if IsDown then
			if destName ~= nil and not IsTargetLevelAppropriate(spellId, destName) then return end
			if ShouldSendMessage(sourceName, spellName) then
				if destName and destName ~= sourceName then
					if FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 1 then 
						FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: "..FCDColorName(sourceName).." cast downranked spell "..GetSpellLink(spellId).." (Rank "..DRank..") on "..FCDColorName(destName).." current avalible "..GetSpellLink(MRankID).." (Rank "..MRank..")")
					else
						local Channel = nil
	        			if GetNumRaidMembers() > 0 then
	           				if FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 3 or FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 4 then Channel = RAID
	           				elseif FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 2 then Channel = PARTY end
	           				if select(2, IsInInstance()) == "pvp" then Channel = BATTLEGROUND end 
	        			elseif GetNumPartyMembers() > 0 then
	        				if FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 2 or FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 4 then Channel = PARTY end
	       				end
	       				if FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 5 then 
           					FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD Warning: "..sourceName.." cast downranked spell "..GetSpellLink(spellId).." (Rank "..DRank..") on "..destName.." current avalible "..GetSpellLink(MRankID).." (Rank "..MRank..")", WHISPER, nil, sourceName)
           					return
           				end
						if Channel ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD Warning: "..sourceName.." cast downranked spell "..GetSpellLink(spellId).." (Rank "..DRank..") on "..destName.." current avalible "..GetSpellLink(MRankID).." (Rank "..MRank..")", Channel)
						elseif Channel == nil then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: "..FCDColorName(sourceName).." cast downranked spell "..GetSpellLink(spellId).." (Rank "..DRank..") on "..FCDColorName(destName).." current avalible "..GetSpellLink(MRankID).." (Rank "..MRank..")") end
					end
				else
					if FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 1 then
						FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: "..FCDColorName(sourceName).." cast downranked spell "..GetSpellLink(spellId).." (Rank "..DRank..") current avalible "..GetSpellLink(MRankID).." (Rank "..MRank..")")
					else
						local Channel = nil
	        			if GetNumRaidMembers() > 0 then
	           				if FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 3 or FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 4 then Channel = RAID
	           				elseif FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 2 then Channel = PARTY end
	        			elseif GetNumPartyMembers() > 0 then
	        				if FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 2 or FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 4 then Channel = PARTY end
	       				end 
           				if FatCooldowns:GetModule("Display").db.profile.FCDSPChannel == 5 then
           					FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD Warning: "..sourceName.." cast downranked spell "..GetSpellLink(spellId).." (Rank "..DRank..") current avalible "..GetSpellLink(MRankID).." (Rank "..MRank..")", WHISPER, nil, sourceName)
           					return
           				end
						if Channel ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD Warning: "..sourceName.." cast downranked spell "..GetSpellLink(spellId).." (Rank "..DRank..") current avalible "..GetSpellLink(MRankID).." (Rank "..MRank..")", Channel) 
						elseif Channel == nil then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: "..FCDColorName(sourceName).." cast downranked spell "..GetSpellLink(spellId).." (Rank "..DRank..") current avalible "..GetSpellLink(MRankID).." (Rank "..MRank..")") end
					end
				end
			end
		end
	end
end
	
local function FCDSU_OnEvent(self, event, ...) 
	if event == "PLAYER_TALENT_UPDATE" then
		if FCDSUFrame.talents == GetActiveTalentGroup(nil) then return end
		FCDSUFrame:Show()
		FCDSUFrame.time = GetTime()
		FCDSUFrame.talents = GetActiveTalentGroup(nil)
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if FatCooldowns:GetModule("Display").db.profile.FCDSPMessages and (not FatCooldowns:GetModule("Display").db.profile.FCDSPExpac or FatCooldowns:GetModule("Display").db.profile.FCDSPExpac and FatCooldowns.ExPac == 2) then
			FCDSU_OnCombatLogEvent(self, event, ...)
		end
	end
end

local function FCDSU_OnUpdate()
	if not FCDSUFrame.time or FCDSUFrame.time == 0 then FCDSUFrame:Hide()
	else
		if not UnitAffectingCombat("player") then
			if GetTime() - FCDSUFrame.time > 1 then 
				if FatCooldowns:GetModule("Display").db.profile.FCDSPEnable then FCDSU_CheckSlots() end
				if FatCooldowns:GetModule("Display").db.profile.FCDSPMacros then FCDSU_UpdateMacros() end
				FCDSUFrame.time = 0
				FCDSUFrame:Hide()
			end			
		end
	end
end

FCDSUFrame = CreateFrame("frame", "FCDSUFrame", UIParent)
FCDSUFrame.talents = GetActiveTalentGroup(nil)
FCDSUFrame:SetScript("OnEvent", FCDSU_OnEvent)
FCDSUFrame:SetScript("OnUpdate", FCDSU_OnUpdate)
FCDSUFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
FCDSUFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")