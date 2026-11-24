assert(FatCooldowns, "FatCooldowns not found!")

local MINOR_VERSION = tonumber(("$Revision: 49 $"):match("%d+"))
if MINOR_VERSION > FatCooldowns.MINOR_VERSION then FatCooldowns.MINOR_VERSION = MINOR_VERSION end

local Media = LibStub("LibSharedMedia-3.0")
local fonts = Media:List("font")
local LGT = LibStub("LibGroupTalents-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("FatCooldowns")
local LD = LibStub:GetLibrary("LibDeflate")

local pairs, ipairs = _G.pairs, _G.ipairs
local tonumber, tostring = _G.tonumber, _G.tostring

local Display = FatCooldowns:GetModule("Display")

Media.RegisterCallback(Display, "LibSharedMedia_Registered", "UpdateDisplay")
Media.RegisterCallback(Display, "LibSharedMedia_SetGlobal", "UpdateDisplay")

local folder, core = ...
core.tooltip = core.tooltip or CreateFrame("GameTooltip", folder.."Tooltip", UIParent, "GameTooltipTemplate")
local tooltip = core.tooltip
tooltip:Show()
tooltip:SetOwner(UIParent, "ANCHOR_NONE")
 
local TempFrameXNames = nil
local TempFrameZNames = nil
local TempFrameNamesSpells = false
local TempHighLightList = nil
local TempChatFilterList = nil
local FakeClass, TempClass = UnitClass("player")
local TempClassAll = false
local TempPlayerList = {}
local TempSpellSearch = nil
local ABListFilled = {}
local CurrrentSelectedListAutoBuy = nil
local RLSelect, RSLTable, ValTable = 1, {}, {}
local AGSpec, AGSpec2 = "None", true
local IESettings, IESettings2 = nil, nil
local FailedToLoadItems = 0
local FailedToLoadItemsReset = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0}
local SelectedChannel = nil
local FCDSPBlackListSelected = nil 

FatCooldowns.PlayersRole = {}

local EQType = {
	["Cloth"] = true,
	["Leather"] = true,
	["Mail"] = true,
	["Plate"] = true,

	-- Weapons
	["Axe"] = true,
	["Mace"] = true,
	["Dagger"] = true,
	["Fist Weapon"] = true,
	["Sword"] = true,

	["Shield"] = true,

	["Libram"] = true,
	["Idol"] = true,
	["Totem"] = true,
	["Sigil"] = true,
	["Relic"] = true,

	["Bow"] = true,
	["Gun"] = true,
	["Crossbow"] = true,
	["Wand"] = true,
	["Thrown"] = true,

	["Polearm"] = true,
	["Staff"] = true,
}

local EQLeftType = {
	["Back"] = true,
	["Neck"] = true,
	["Finger"] = true,
	["Trinket"] = true,

	["Held In Off-hand"] = true,
	["One-Hand"] = true,
	["Main Hand"] = true,
	["Two-Hand"] = true,
	["Ranged"] = true,
}

local FunctionalItems = {
	["DEATHKNIGHT"] = {
		["Spell power"] = true,
		["mana per 5 sec"] = true,
		["intellect"] = true,
		["spirit"] = true,
	},
	["HUNTER"] = {
		["Spell power"] = true,
		["defense"] = true,
		["parry"] = true,
		["dodge"] = true,
		["spirit"] = true,
		["expertise"] = true,
	},
	["MAGE"] = {
		["defense"] = true,
		["parry"] = true,
		["dodge"] = true,
		["strength"] = true,
		["agility"] = true,
		["expertise"] = true,
		["attack power"] = true,
		["armor penetration"] = true,
	},
	["PRIEST"] = {
		["defense"] = true,
		["parry"] = true,
		["dodge"] = true,
		["strength"] = true,
		["agility"] = true,
		["expertise"] = true,
		["attack power"] = true,
		["armor penetration"] = true,
	},
	["ROGUE"] = {
		["Spell power"] = true,
		["defense"] = true,
		["parry"] = true,
		["dodge"] = true,
		["mana per 5 sec"] = true,
		["intellect"] = true,
		["spirit"] = true,
	},
	["SHAMAN"] = {
		["defense"] = true,
		["parry"] = true,
		["dodge"] = true,
	},
	["WARLOCK"] = {
		["defense"] = true,
		["parry"] = true,
		["dodge"] = true,
		["strength"] = true,
		["agility"] = true,
		["expertise"] = true,
		["attack power"] = true,
		["armor penetration"] = true,
	},
	["WARRIOR"] = {
		["Spell power"] = true,
		["mana per 5 sec"] = true,
		["intellect"] = true,
		["spirit"] = true,
	},
}
local TextColor = {
		["Spell power"] = "Green",
		["mana per 5 sec"] = "Green",
		["intellect"] = "White",
		["spirit"] = "White",
		["defense"] = "Green",
		["parry"] = "Green",
		["dodge"] = "Green",
		["expertise"] = "Green",
		["strength"] = "White",
		["agility"] = "White",
		["attack power"] = "Green",
		["armor penetration"] = "Green",
}

local function IsTextRed(text)
 	if text and text:GetText() then 
 		local r,g,b = text:GetTextColor()
 		return math.floor(r*256) == 255 and math.floor(g*256) == 32 and math.floor(b*256) == 32
 	end
end
local function IsTextGray(text)
 	if text and text:GetText() then 
 		local r,g,b = text:GetTextColor()
 		return math.floor(r*256) == 128 and math.floor(g*256) == 128 and math.floor(b*256) == 128
 	end
end
local function IsTextWhite(text)
 	if text and text:GetText() then 
 		local r,g,b = text:GetTextColor()
 		return math.floor(r*256) == 255 and math.floor(g*256) == 255 and math.floor(b*256) == 255
 	end
end
local function IsTextGreen(text)
 	if text and text:GetText() then 
 		local r,g,b = text:GetTextColor()
 		return math.floor(r*256) == 0 and math.floor(g*256) == 255 and math.floor(b*256) == 0
 	end
end

function RemoveColorCodes(text)
    local cleanedText = text:gsub('|c%x%x%x%x%x%x(.-)|r', '%1')
    cleanedText = cleanedText:gsub('|c%x%x%x%x%x%x', '')
    return cleanedText
end

local text = "ff+12 spell power and +10 hit rating"

local function getNumberBeforeKeyword(text, keyword)
	if keyword == nil or keyword == "" then return end
    local pattern = "([+-]?%d+%.?%d*)%s*" .. keyword
    local numberStr = string.match(text, pattern)
    if numberStr then
        return tonumber(numberStr)
    else
        return 0
    end
end

local SoulboundToolTip
function isSoulbound(bag, slot, ItemLink, ItemIsUseable, IsItemEQ, CheckIsFunctional, SendTime, StunOrSilence, SpellYardsChecker, checkitems, HasStat, ISGemSearch, CountThem)
	local IsUseable, IsFunctional = true, true
	if not SoulboundToolTip then
		SoulboundToolTip = CreateFrame("GameTooltip", "FCDSoulboundToolTip", UIParent, "GameTooltipTemplate")
		SoulboundToolTip:SetOwner(UIParent, "ANCHOR_NONE")	
	end	
	SoulboundToolTip:ClearLines()
	if not ItemLink then
		SoulboundToolTip:SetBagItem(bag, slot)
	else
		SoulboundToolTip:SetHyperlink(ItemLink)
	end

	if HasStat then
		local StartCount = 0
		local ReturnAmount = 0
		for ItemTipID = 1, SoulboundToolTip:NumLines() do
			local text = _G["FCDSoulboundToolTipTextLeft"..ItemTipID]
			local WorkingWithText = text:GetText()
			WorkingWithText = string.lower(WorkingWithText)
			local ForceSearch = false
			if ISGemSearch then ForceSearch = true elseif not IsTextGray(text) then ForceSearch = true end
			WorkingWithText = RemoveColorCodes(WorkingWithText)
			if WorkingWithText:find(HasStat) and ForceSearch and not WorkingWithText:find("cat, bear, dire bear, and moonkin forms") then
				local value = tonumber(string.match(WorkingWithText, "[+-]?%d+%.?%d*")) or 0
				if CountThem then
					local value2 = getNumberBeforeKeyword(WorkingWithText, HasStat)
					StartCount = StartCount + 1
					if value2 ~= 0 then
						ReturnAmount = ReturnAmount + value2
					else
						ReturnAmount = ReturnAmount + value
					end
				else
					return true
				end 
			end
		end
		if CountThem then return StartCount, ReturnAmount end
		return false
	end 

	if SendTime then
		for ItemTipID = 1, SoulboundToolTip:NumLines() do
			local text = _G["FCDSoulboundToolTipTextLeft"..ItemTipID]
			local WorkingWithText = text:GetText()
			if WorkingWithText:find("%d sec%.") then
				local StartingText, MiddleText, EndingText = select(3, WorkingWithText:find("(.+) (%d+) (sec%..*)"))
				return MiddleText, false
			end
		end
		return 10, true
	end

	if SpellYardsChecker then
		for ItemTipID = 1, SoulboundToolTip:NumLines() do
			local text = _G["FCDSoulboundToolTipTextLeft"..ItemTipID]
			local WorkingWithText = text:GetText()
			if WorkingWithText:find("100 yd range") or (WorkingWithText:match("Melee Range") and SpellYardsChecker:find("Poison")) then
				return true
			end
		end
		return false
	end

	if StunOrSilence then
		for ItemTipID = 1, SoulboundToolTip:NumLines() do
			local text = _G["FCDSoulboundToolTipTextLeft"..ItemTipID]
			local WorkingWithText = text:GetText()
			WorkingWithText = string.lower(WorkingWithText)
			local SearchTable = {
				[1] = "silenc.+%d sec", 
				[2] = "fear.+%d+ sec", 
				[3] = "stun.+%d+ sec", 
				[4] = "charm.+%d+ sec", 
				[5] = "incapac.+%d+ sec", 
				[6] = "sleep.+%d+ sec", 
				[7] = "disorient.+%d+ sec", 
				[8] = "polymo.+%d+ sec",
				[9] = "banish.+%d+ sec", 
				[10] = "horr.+%d+ sec", 
				[11] = "cannot attack", 
				[12] = "preven.+cast.+%d+ sec",
				[13] = "^asleep%.", 
				[14] = "unable to attack for %d+ sec%.", 
				[15] = "^hexed%.",
				[16] = "unable to attack or cast spells for %d+ sec%.", 
				[17] = "preventing the enemy from attacking or casting spells for %d+ sec%.", 
				[18] = "cyclone for up to %d+ sec", 
				[19] = "invulnerable for %d+ sec", 
				[20] = "flee for %d+ sec",
				[21] = "preventing the enemy from casting that spell again for %d+ sec%.",
				[22] = "preventing it from casting spells",
				[23] = "rendering them unable to attack or cast spells for %d+ sec%.",
				[24] = "wander around for up to %d+ sec%.",
				[25] = "seduces.+ for %d+ sec%.",
				[26] = "freeze.+ for %d+ sec%.",
				[27] = "wander confused for up to %d+ sec%.",
				[28] = "cannot cast spells", 
			}
			for SearchTableIndex, SearchTableVal in pairs(SearchTable) do
				if WorkingWithText:find(L[SearchTableVal]) then return true end
			end
		end
		return false
	end

	if CheckIsFunctional then
		if FunctionalItems[CheckIsFunctional] then
			local TBCClassicCheck = false
			for ItemTipID = 1, SoulboundToolTip:NumLines() do
				local text = _G["FCDSoulboundToolTipTextLeft"..ItemTipID]
				if IsFunctional then 
					for Fpower, FActive in pairs(FunctionalItems[CheckIsFunctional]) do
						local FixedText = nil
						local EditedText = text:GetText()
						EditedText = EditedText:lower()
						local FTPower = tostring(L[Fpower])
						if FActive and EditedText ~= nil and EditedText:find(FTPower) then FixedText = FTPower end

						if EditedText ~= nil and FixedText == nil and FixedText ~= FTPower then
							for stattype, stattypecolor in pairs(TextColor) do
								local realstatname = L[stattype]
								if EditedText:find(realstatname) and FunctionalItems[CheckIsFunctional].realstatname == nil then TBCClassicCheck = true end
							end
						end
		
						if FixedText ~= nil and TextColor[FixedText] ~= nil and TextColor[FixedText] == L["Green"] then
							if IsTextGreen(text) then IsFunctional = false end
						elseif FixedText ~= nil and TextColor[FixedText] ~= nil and TextColor[FixedText] == L["White"] then
							if IsTextWhite(text) then IsFunctional = false end
						end
					end
				end
			end
			if IsFunctional then
				return true
			else
				if TBCClassicCheck then 
					return true
				else
					return false
				end 
			end
		end
		return true
	end

	if ItemIsUseable then
		for ItemTipID = 1, SoulboundToolTip:NumLines() do
			local text = _G["FCDSoulboundToolTipTextRight"..ItemTipID]
			for inde, EQType1 in pairs(EQType) do
				if L[inde] == text:GetText() and IsTextRed(text) then IsUseable = false end
			end
		end
		for ItemTipID = 1, SoulboundToolTip:NumLines() do
			local text = _G["FCDSoulboundToolTipTextLeft"..ItemTipID]
			for inde, EQLeftType1 in pairs(EQLeftType) do
				if L[inde] == text:GetText() and IsTextRed(text) then IsUseable = false end
			end
		end
		if IsUseable then
			return true
		else
			return false
		end
	end

	if IsItemEQ then
		for ItemTipID = 1, SoulboundToolTip:NumLines() do
			local text = _G["FCDSoulboundToolTipTextRight"..ItemTipID]
			for inde, EQType1 in pairs(EQType) do
				if L[inde] == text:GetText() then return true end
			end
		end
		for ItemTipID = 1, SoulboundToolTip:NumLines() do
			local text = _G["FCDSoulboundToolTipTextLeft"..ItemTipID]
			for inde, EQLeftType1 in pairs(EQLeftType) do
				if L[inde] == text:GetText() then return true end
			end
		end
		return false
	end

	for ItemTipID = 1, SoulboundToolTip:NumLines() do
		local text = _G["FCDSoulboundToolTipTextLeft"..ItemTipID]
		if (text and text:GetText() and (text:GetText() == ITEM_SOULBOUND) or (ItemLink ~= nil and text:GetText() == L["Binds when picked up"])) then
			return true
		end
	end
	return false
end

local function GetLSMIndex(t, value)
	for k, v in pairs(Media:List(t)) do
		if v == value then
			return k
		end
	end
	return nil
end

local function set(t, value)
	Display.db.profile[t[#t]] = value
	Display:UpdateDisplay()
end
local function get(t)
	return Display.db.profile[t[#t]]
end

function SetEISettings()
	local SettingsTODO = nil
	local AllProfileSettings = {}

	if IESettings == 1 then SettingsTODO = {[1] = 1, [2] = {[1] = Display.db.profile, [2] = Display.db.profile.frameCount}}
	elseif IESettings == 2 then SettingsTODO = {[1] = 2, [2] = {[1] = Display.db.profile.frames}}
	elseif IESettings == 3 then SettingsTODO = {[1] = 3, [2] = {[1] = Display.db.profile.soundspells, [2] = Display.db.profile.soundspellsoptions}}
	elseif IESettings == 4 then SettingsTODO = {[1] = 4, [2] = {[1] = Display.db.profile.orderSpells, [2] = Display.db.profile.orderSpellPriorities}}
	elseif IESettings == 5 then SettingsTODO = {[1] = 5, [2] = {[1] = Display.db.profile.SellList2}}
	elseif IESettings == 6 then SettingsTODO = {[1] = 6, [2] = {[1] = Display.db.profile.ADList2}}
	elseif IESettings == 7 then SettingsTODO = {[1] = 7, [2] = {[1] = Display.db.profile.AutoMailerPlayers, [2] = Display.db.profile.LootMailerList, [3] = Display.db.profile.Realms}}
	elseif IESettings == 8 then SettingsTODO = {[1] = 8, [2] = {[1] = Display.db.profile.ARCount, [2] = Display.db.profile.LootBlackList2, [3] = Display.db.profile.ARTable, [4] = Display.db.profile.ARNameT}}
	elseif IESettings == 9 then SettingsTODO = {[1] = 9, [2] = {[1] = Display.db.profile.ABList}}
	end

	if SettingsTODO == nil then
		return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: No Settings Selected")
	else
		SettingsTODO = DefaultsChecker(SettingsTODO)
	    local serializedData = FatCooldowns:Serialize(SettingsTODO)
	    local compressed = LD:CompressDeflate(serializedData)
		IESettings2 = LD:EncodeForPrint(compressed)
	end
end

function FCDColorName3(Name, RealName)
	local classes = {["Death Knight"] = "DEATHKNIGHT", ["Druid"] = "DRUID", ["Hunter"] = "HUNTER", ["Mage"] = "MAGE", ["Paladin"] = "PALADIN", ["Priest"] = "PRIEST", ["Rogue"] = "ROGUE", ["Shaman"] = "SHAMAN", ["Warlock"] = "WARLOCK", ["Warrior"] = "WARRIOR"}
	if classes[Name] then Name = classes[Name] end
	if Name == nil then return nil end
	local CCName = RAID_CLASS_COLORS[Name]
	if CCName == nil then return Name end
	if RealName then
		RealName = format("|cff%02x%02x%02x%s|r", CCName.r*255, CCName.g*255, CCName.b*255, RealName)
		return RealName
	else 
		Name = format("|cff%02x%02x%02x%s|r", CCName.r*255, CCName.g*255, CCName.b*255, Name)
   		return Name
   	end
end

local FlashAleartFrame = CreateFrame("Frame", "FCDFlashScreen", WorldFrame)
FlashAleartFrame:SetClampedToScreen(true)
FlashAleartFrame:SetFrameStrata("BACKGROUND")
FlashAleartFrame:SetAllPoints(UIParent)
FlashAleartFrame:Show()
FlashAleartFrame.states = {["UNIT_HEALTH"] = 0, ["UNIT_MANA"] = 0, ["UNIT_PET"] = 0}
FlashAleartFrame:RegisterEvent("PLAYER_LOGIN")

FlashAleartFrame.SetSettings = function()
	if not FlashAleartFrame.health then
		FlashAleartFrame.health = FlashAleartFrame:CreateTexture("FCDLowHPWarning", "BACKGROUND")
		FlashAleartFrame.health:SetAllPoints(FlashAleartFrame)
		FlashAleartFrame.health:SetAlpha(0)
		FlashAleartFrame.health:SetBlendMode("ADD")
		FlashAleartFrame.health:SetVertexColor(Display.db.profile.LHPNC["r"], Display.db.profile.LHPNC["g"], Display.db.profile.LHPNC["b"])
		FlashAleartFrame.health:SetTexture(Media:Fetch("background", Display.db.profile.LHPNTE))

		FlashAleartFrame.health["ENABLED"] = Display.db.profile.LHPN
		FlashAleartFrame.health["COMBAT"] = Display.db.profile.LHPC
		FlashAleartFrame.health["SOUND"] = Display.db.profile.LHPS
		FlashAleartFrame.health["LEVEL"] = Display.db.profile.LHPPL
		FlashAleartFrame.health["LEVELTYPE"] = Display.db.profile.LHPPLT
		FlashAleartFrame.health["CLASSENABLED"] = Display.db.profile.LHPPCLAE
		FlashAleartFrame.health["CLASS"] = Display.db.profile.LHPPCLA
		FlashAleartFrame.health["NAMES"] = Display.db.profile.LHNFilter
	else 
		FlashAleartFrame.health["ENABLED"] = Display.db.profile.LHPN
		FlashAleartFrame.health["COMBAT"] = Display.db.profile.LHPC
		FlashAleartFrame.health["SOUND"] = Display.db.profile.LHPS
		FlashAleartFrame.health["LEVEL"] = Display.db.profile.LHPPL
		FlashAleartFrame.health["LEVELTYPE"] = Display.db.profile.LHPPLT
		FlashAleartFrame.health["CLASSENABLED"] = Display.db.profile.LHPPCLAE
		FlashAleartFrame.health["CLASS"] = Display.db.profile.LHPPCLA
		FlashAleartFrame.health["NAMES"] = Display.db.profile.LHNFilter
		FlashAleartFrame.health:SetVertexColor(Display.db.profile.LHPNC["r"], Display.db.profile.LHPNC["g"], Display.db.profile.LHPNC["b"])
		FlashAleartFrame.health:SetTexture(Media:Fetch("background", Display.db.profile.LHPNTE))
	end
	if not FlashAleartFrame.mana then
		FlashAleartFrame.mana = FlashAleartFrame:CreateTexture("FCDLowManaWarning", "BACKGROUND")
		FlashAleartFrame.mana:SetAllPoints(FlashAleartFrame)
		FlashAleartFrame.mana:SetAlpha(0)
		FlashAleartFrame.mana:SetBlendMode("ADD")
		FlashAleartFrame.mana:SetVertexColor(Display.db.profile.LMNC["r"], Display.db.profile.LMNC["g"], Display.db.profile.LMNC["b"])
		FlashAleartFrame.mana:SetTexture(Display.db.profile.LMPNTE)

		FlashAleartFrame.mana["ENABLED"] = Display.db.profile.LMM
		FlashAleartFrame.mana["COMBAT"] = Display.db.profile.LMPC
		FlashAleartFrame.mana["SOUND"] = Display.db.profile.LMPS
		FlashAleartFrame.mana["LEVEL"] = Display.db.profile.LMPPL
		FlashAleartFrame.mana["LEVELTYPE"] = Display.db.profile.LMPPLT
		FlashAleartFrame.mana["CLASSENABLED"] = Display.db.profile.LMPPCLAE
		FlashAleartFrame.mana["CLASS"] = Display.db.profile.LMPPCLA
		FlashAleartFrame.mana["NAMES"] = Display.db.profile.LMNFilter
	else
		FlashAleartFrame.mana["ENABLED"] = Display.db.profile.LMM
		FlashAleartFrame.mana["COMBAT"] = Display.db.profile.LMPC
		FlashAleartFrame.mana["SOUND"] = Display.db.profile.LMPS
		FlashAleartFrame.mana["LEVEL"] = Display.db.profile.LMPPL
		FlashAleartFrame.mana["LEVELTYPE"] = Display.db.profile.LMPPLT
		FlashAleartFrame.mana["CLASSENABLED"] = Display.db.profile.LMPPCLAE
		FlashAleartFrame.mana["CLASS"] = Display.db.profile.LMPPCLA
		FlashAleartFrame.mana["NAMES"] = Display.db.profile.LMNFilter
		FlashAleartFrame.mana:SetVertexColor(Display.db.profile.LMNC["r"], Display.db.profile.LMNC["g"], Display.db.profile.LMNC["b"])
		FlashAleartFrame.mana:SetTexture(Media:Fetch("background", Display.db.profile.LMPNTE))
	end
	if not FlashAleartFrame.pet then
		FlashAleartFrame.pet = FlashAleartFrame:CreateTexture("FCDLowPetWarning", "BACKGROUND")
		FlashAleartFrame.pet:SetAllPoints(FlashAleartFrame)
		FlashAleartFrame.pet:SetAlpha(0)
		FlashAleartFrame.pet:SetBlendMode("ADD")
		FlashAleartFrame.pet:SetVertexColor(Display.db.profile.LPNC["r"], Display.db.profile.LPNC["g"], Display.db.profile.LPNC["b"])
		FlashAleartFrame.pet:SetTexture(Display.db.profile.LPPNTE)

		FlashAleartFrame.pet["ENABLED"] = Display.db.profile.LPM
		FlashAleartFrame.pet["COMBAT"] = Display.db.profile.LPPC
		FlashAleartFrame.pet["SOUND"] = Display.db.profile.LPPS
		FlashAleartFrame.pet["LEVEL"] = Display.db.profile.LPPPL
		FlashAleartFrame.pet["LEVELTYPE"] = Display.db.profile.LPPPLT
		FlashAleartFrame.pet["CLASSENABLED"] = Display.db.profile.LPPPCLAE
		FlashAleartFrame.pet["CLASS"] = Display.db.profile.LPPPCLA
		FlashAleartFrame.pet["NAMES"] = Display.db.profile.LPNFilter
	else
		FlashAleartFrame.pet["ENABLED"] = Display.db.profile.LPM
		FlashAleartFrame.pet["COMBAT"] = Display.db.profile.LPPC
		FlashAleartFrame.pet["SOUND"] = Display.db.profile.LPPS
		FlashAleartFrame.pet["LEVEL"] = Display.db.profile.LPPPL
		FlashAleartFrame.pet["LEVELTYPE"] = Display.db.profile.LPPPLT
		FlashAleartFrame.pet["CLASSENABLED"] = Display.db.profile.LPPPCLAE
		FlashAleartFrame.pet["CLASS"] = Display.db.profile.LPPPCLA
		FlashAleartFrame.pet["NAMES"] = Display.db.profile.LPNFilter
		FlashAleartFrame.pet:SetVertexColor(Display.db.profile.LPNC["r"], Display.db.profile.LPNC["g"], Display.db.profile.LPNC["b"])
		FlashAleartFrame.pet:SetTexture(Media:Fetch("background", Display.db.profile.LPPNTE))
	end
	FlashAleartFrame:RegisterEvent("UNIT_PET")
	FlashAleartFrame:RegisterEvent("UNIT_DISPLAYPOWER")
	FlashAleartFrame:RegisterEvent("UNIT_HEALTH")
	if UnitPowerType("player") == 0 then
		FlashAleartFrame:RegisterEvent("UNIT_MANA")
		FlashAleartFrame.mana["ENABLED"] = Display.db.profile.LMM
	else
		FlashAleartFrame:UnregisterEvent("UNIT_MANA")
		FlashAleartFrame.mana["ENABLED"] = false
		FlashAleartFrame.FlashCheck(FlashAleartFrame, 50, 25, 20, FlashAleartFrame.mana, "UNIT_MANA", true)
		FlashAleartFrame.SoundCheck(FlashAleartFrame, 50, 25, FlashAleartFrame.mana, true, "UNIT_MANA")
	end
end

FlashAleartFrame.FlashCheck = function(self, value, regular, critical, texture, state, disable, force) 
	local REGULAR_FLASH, CRITICAL_FLASH = 1, 2
	local Class, _ = UnitClass("player")
	Class = string.upper(Class)
	if (value > regular or disable or (not UnitAffectingCombat("player") and texture["COMBAT"]) or UnitIsDead("player") or UnitIsDeadOrGhost("player") or not texture["ENABLED"] or
		(texture["CLASSENABLED"] and texture["CLASS"] ~= nil and texture["CLASS"][Class]) or
		(texture["NAMES"][UnitName("player")] ~= nil and texture["NAMES"][UnitName("player")] == UnitName("player")) or
		(UnitLevel("player") < texture["LEVEL"] and texture["LEVELTYPE"] == 1) or (UnitLevel("player") > texture["LEVEL"] and texture["LEVELTYPE"] == 2)) and not force then
		if UIFrameIsFlashing(texture) or UIFrameIsFading(FlashAleartFrame) then
			FlashAleartFrame:FlashStop(texture, state)
		end
	elseif value > critical or (force ~= nil and force == 1) then 
		if not (FlashAleartFrame.states[state] == REGULAR_FLASH) then 
			if UIFrameIsFlashing(texture) then
				if state ~= nil and state == "UNIT_HEALTH" then
					texture:SetTexture(Media:Fetch("background", Display.db.profile.LHPNTE))
				elseif state ~= nil and state == "UNIT_MANA" then
					texture:SetTexture(Media:Fetch("background", Display.db.profile.LMPNTE))
				elseif state ~= nil and state == "UNIT_PET" then
					texture:SetTexture(Media:Fetch("background", Display.db.profile.LPPNTE))
				end
				texture.fadeInTime = 0.4
				texture.fadeOutTime = 0.6
				texture.flashInHoldTime = 1
			else 
				if state ~= nil and state == "UNIT_HEALTH" then
					texture:SetTexture(Media:Fetch("background", Display.db.profile.LHPNTE))
				elseif state ~= nil and state == "UNIT_MANA" then
					texture:SetTexture(Media:Fetch("background", Display.db.profile.LMPNTE))
				elseif state ~= nil and state == "UNIT_PET" then
					texture:SetTexture(Media:Fetch("background", Display.db.profile.LPPNTE))
				end
				UIFrameFlash(texture, 0.4, 0.6, -1, false, 1, 0)
			end
			FlashAleartFrame.states[state] = REGULAR_FLASH
		end
	else
		if not (FlashAleartFrame.states[state] == CRITICAL_FLASH) then
			if UIFrameIsFlashing(texture) then
				if state ~= nil and state == "UNIT_HEALTH" then
					texture:SetTexture(Media:Fetch("background", Display.db.profile.LHPNTEC))
				elseif state ~= nil and state == "UNIT_MANA" then
					texture:SetTexture(Media:Fetch("background", Display.db.profile.LMPNTEC))
				elseif state ~= nil and state == "UNIT_PET" then
					texture:SetTexture(Media:Fetch("background", Display.db.profile.LPPNTEC))
				end
				texture.fadeInTime = 0.2
				texture.fadeOutTime = 0.8
				texture.flashInHoldTime = 0
			else
				if state ~= nil and state == "UNIT_HEALTH" then
					texture:SetTexture(Media:Fetch("background", Display.db.profile.LHPNTEC))
				elseif state ~= nil and state == "UNIT_MANA" then
					texture:SetTexture(Media:Fetch("background", Display.db.profile.LMPNTEC))
				elseif state ~= nil and state == "UNIT_PET" then
					texture:SetTexture(Media:Fetch("background", Display.db.profile.LPPNTEC))
				end
				UIFrameFlash(texture, 0.2, 0.8, -1, false, 0, 0)
			end
			FlashAleartFrame.states[state] = CRITICAL_FLASH
		end
	end
end

local SoundTimer = {["UNIT_HEALTH"] = 0, ["UNIT_MANA"] = 0, ["UNIT_PET"] = 0}
local FCDSoundCheck = {["UNIT_HEALTH"] = false, ["UNIT_MANA"] = false, ["UNIT_PET"] = false}
function FCDPlaySoundHealth()
	if FCDSoundCheck["UNIT_HEALTH"] and GetTime() - SoundTimer["UNIT_HEALTH"] > 3.9 then 
		PlaySoundFile(FatCooldowns.FCDSounds[Display.db.profile.LHPS], "Master",false)
		SoundTimer["UNIT_HEALTH"] = GetTime()
		if Display.db.profile.LHPSR then FatCooldowns:ScheduleTimer(function() FCDPlaySoundHealth() end, 4) end
	end
end
function FCDPlaySoundMana()
	if FCDSoundCheck["UNIT_MANA"] and GetTime() - SoundTimer["UNIT_MANA"] > 3.9 then 
		PlaySoundFile(FatCooldowns.FCDSounds[Display.db.profile.LMPS], "Master",false)
		SoundTimer["UNIT_MANA"] = GetTime()
		if Display.db.profile.LMPSR then FatCooldowns:ScheduleTimer(function() FCDPlaySoundMana() end, 4) end
	end
end
function FCDPlaySoundPet() 
	if not UnitExists("pet") or UnitIsDead("pet") then return end
	if FCDSoundCheck["UNIT_PET"] and GetTime() - SoundTimer["UNIT_PET"] > 3.9 then  
		PlaySoundFile(FatCooldowns.FCDSounds[Display.db.profile.LPPS], "Master",false) 
		SoundTimer["UNIT_PET"] = GetTime()
		if Display.db.profile.LPPSR then FatCooldowns:ScheduleTimer(function() FCDPlaySoundPet() end, 4) end
	end
end

FlashAleartFrame.FlashStop = function(self, texture, state)
	UIFrameFlashRemoveFrame(texture)
	UIFrameFadeRemoveFrame(texture)
	UIFrameFadeOut(texture, 0.5, texture:GetAlpha(), 0)
	FlashAleartFrame.states[state] = 0
end

FlashAleartFrame.SoundCheck = function(self, value, regular, texture, disable, event)
	local Class, _ = UnitClass("player")
	Class = string.upper(Class)
	if disable or value > regular or (not UnitAffectingCombat("player") and texture["COMBAT"]) or UnitIsDeadOrGhost("player") or not texture["ENABLED"] or
		(texture["CLASSENABLED"] and texture["CLASS"] ~= nil and texture["CLASS"][Class]) or
		(texture["NAMES"][UnitName("player")] ~= nil and texture["NAMES"][UnitName("player")] == UnitName("player")) or
		(UnitLevel("player") < texture["LEVEL"] and texture["LEVELTYPE"] == 1) or (UnitLevel("player") > texture["LEVEL"] and texture["LEVELTYPE"] == 2) then
		if FCDSoundCheck[event] ~= nil and FCDSoundCheck[event] then
			FCDSoundCheck[event] = false
		end
	else
		if not FCDSoundCheck[event] then
			if event == "UNIT_HEALTH" then 
				FCDSoundCheck[event] = true
				FCDPlaySoundHealth()
			elseif event == "UNIT_PET" then 
				FCDSoundCheck[event] = true
				FCDPlaySoundPet()
			elseif event == "UNIT_MANA" then 
				FCDSoundCheck[event] = true
				FCDPlaySoundMana()
			end
		end
	end
end

FlashAleartFrame:SetScript("OnEvent", function()
	if event == "UNIT_HEALTH" or event == "UNIT_MANA" or event == "UNIT_PET" then 
		if arg1 == "player" or arg1 == "pet" then
			local t1, t2, value, texture, disable
			if event == "UNIT_HEALTH" then
				if arg1 == "player" then
					t1, t2 = Display.db.profile.LHPH, Display.db.profile.LHPCR
					value = UnitHealth("player") / UnitHealthMax("player")
					texture = FlashAleartFrame.health
					disable = not Display.db.profile.LHPN
					FlashAleartFrame:SoundCheck(value * 100, t1, texture, disable, event)
				elseif arg1 == "pet" then
					t1, t2 = Display.db.profile.LPPH, Display.db.profile.LPPCR
					value = UnitHealth("pet") / UnitHealthMax("pet")
					texture = FlashAleartFrame.pet
					disable = not Display.db.profile.LPM
					event = "UNIT_PET"
					if UnitExists("pet") and not UnitIsDead("pet") then
						FlashAleartFrame:SoundCheck(value * 100, t1, texture, disable, event)
					end
				end
			elseif event == "UNIT_MANA" then
				value = UnitMana("player") / UnitManaMax("player")
				texture = FlashAleartFrame.mana
				t1, t2 = Display.db.profile.LMPH, Display.db.profile.LMPCR
				disable = not Display.db.profile.LMM
				FlashAleartFrame:SoundCheck(value * 100, t1, texture, disable, event)
			elseif event == "UNIT_PET" then
				if not UnitExists("pet") or UnitIsDead("pet") then
					FlashAleartFrame:FlashStop(FlashAleartFrame.pet, event)
				return
				end
			end
			if not value then return end
			FlashAleartFrame:FlashCheck(value * 100, t1, t2, texture, event, disable)
		end
	elseif event == "UNIT_DISPLAYPOWER" then
		FlashAleartFrame:SetSettings()
	elseif (event == "PLAYER_LOGIN") then
		FlashAleartFrame:SetSettings()
		if FlashAleartFrame.health then
			FlashAleartFrame:FlashStop(FlashAleartFrame.health, "UNIT_HEALTH")
		end	
		if FlashAleartFrame.pet then
			FlashAleartFrame:FlashStop(FlashAleartFrame.pet, "UNIT_PET")
		end
		if FlashAleartFrame.mana then
			FlashAleartFrame:FlashStop(FlashAleartFrame.mana, "UNIT_MANA")
		end
	end
end)

local options = {}

local function RefreshFrameListOptionsAndVariables()
	local optArgs = options.args.frames.args
	local classes = {"DEATHKNIGHT", "DRUID", "HUNTER", "MAGE", "PALADIN", "PRIEST", "ROGUE", "SHAMAN", "WARLOCK", "WARRIOR", "ITEMS", "RACIALS", "CONSUMABLES", "Tank Only Cooldowns", "OTHER BARS", "ITEM PROC"}
	local reporters = {"OTHER", "ITEMS", "PORTALS", "MULTIPLE BOSSES","BPC AND BQL", "THE LICH KING", "OTHER BOSSES", "PARRY REPORTER", "SOUND AND SAY"}
	local ChatFilters = {"CHAT FILTER - Deaths", "CHAT FILTER - Other", "CHAT FILTER - Bubbles", "CHAT FILTER - Raid","CHAT FILTER - RaidLoot", "CHAT FILTER - GroupLoot", "CHAT FILTER - Global", "CHAT FILTER - Global Raids", "CHAT FILTER - Spells", "CHAT FILTER - FCD"}
	local Display = Display
	
	for i = 1, 10, 1 do
		if i <= Display.db.profile.frameCount then
			if not Display.db.profile.frames[i] then
				local newFrame = {}
				newFrame.name = "Frame"..i
				newFrame.growUp = Display.db.profile.frames[i-1].growUp
				newFrame.hideSelf = Display.db.profile.frames[i-1].hideSelf
				newFrame.readyMsg = Display.db.profile.frames[i-1].readyMsg
				newFrame.scale = Display.db.profile.frames[i-1].scale
				newFrame.alpha = Display.db.profile.frames[i-1].alpha
				newFrame.opacity = Display.db.profile.frames[i-1].opacity
				newFrame.width = Display.db.profile.frames[i-1].width
				newFrame.fontsize = Display.db.profile.frames[i-1].fontsize
				newFrame.height = Display.db.profile.frames[i-1].height
				newFrame.maxTextLength = Display.db.profile.frames[i-1].maxTextLength
				newFrame.permanent = Display.db.profile.frames[i-1].permanent
				newFrame.anchor = Display.db.profile.frames[i-1].anchor
				newFrame.hideFrame = Display.db.profile.frames[i-1].hideFrame
				newFrame.hidetarget = Display.db.profile.frames[i-1].hidetarget
				newFrame.RaidMsg = Display.db.profile.frames[i-1].RaidMsg
				newFrame.UsedMsg = Display.db.profile.frames[i-1].UsedMsg
				newFrame.HideLabel = Display.db.profile.frames[i-1].HideLabel
				newFrame.onlySelf = Display.db.profile.frames[i-1].onlySelf
				newFrame.SpellNameLabel = Display.db.profile.frames[i-1].SpellNameLabel
				newFrame.EnemyFCDCaster = Display.db.profile.frames[i-1].EnemyFCDCaster
				newFrame.FriendlyCaster = Display.db.profile.frames[i-1].FriendlyCaster
				newFrame.HideArena = Display.db.profile.frames[i-1].HideArena
				newFrame.ShowArena = Display.db.profile.frames[i-1].ShowArena
				newFrame.HideInWG = Display.db.profile.frames[i-1].HideInWG				
				newFrame.HideInCombat = Display.db.profile.frames[i-1].HideInCombat				
				newFrame.HideBG = Display.db.profile.frames[i-1].HideBG
				newFrame.HideInRaid = Display.db.profile.frames[i-1].HideInRaid
				newFrame.HideOutRaid = Display.db.profile.frames[i-1].HideOutRaid
				newFrame.spells = {}

				Display.db.profile.frames[i] = newFrame
			end
			
			if not optArgs["frame"..i] then
				optArgs["frame"..i] = {
					type = "group",
					name = Display.db.profile.frames[i].name .. " Options",
					desc = "Configure frame options and spells displayed",
					cmdHidden = true,
					order = i,
					args = {
						MOHD = {
							type = "header",
							name =  "Main Options",
							width = "full",
							order = 0.1,
						},
						name = {
							type = "input",
							name = "Frame Name",
							desc = "Choose name of this frame",
							get = function(v) return Display.db.profile.frames[i].name end,
							set = function(info, v) 
								Display.db.profile.frames[i].name = v optArgs["frame"..i].name = v .. " Options"
								Display:UpdateDisplay()
							end,
							width = "double",
							order = 1
						},
						maxTextLength = {
							type = "range",
							name = "Max Characters",
							desc = "This will limit the amount of letters used in peoples.",
							min = 3, max = 12, step = 1, bigStep = 1,
							get = function(v) if Display.db.profile.frames[i].maxTextLength >= 12 then return 12 else
								return Display.db.profile.frames[i].maxTextLength end end,
							set = function(info, v) if v < 12 then Display.db.profile.frames[i].maxTextLength = v else Display.db.profile.frames[i].maxTextLength = 99 end Display:UpdateDisplay() end,
							order = 2,
							width = "double",
						},
						permanent = {
							type = "toggle",
							name = "Permanent Bars (Show When Ready)",
							desc = "Displays the spells even when ready.",
							width = "double",
							get = function(v) return Display.db.profile.frames[i].permanent end,
							set = function(info, v) 
								if v then
									Display.db.profile.frames[i].permanent = v  
									if FatCooldowns.raidRoster then Display:RaidUpdate(FatCooldowns.raidRoster,{},i) end
								else
									if FatCooldowns.raidRoster then Display:RaidUpdate({},FatCooldowns.raidRoster,i) end
									Display.db.profile.frames[i].permanent = v  
								end
								
								Display:UpdateDisplay()
							end,
							order = 2.2,
						},
						anchor = {
							type = "toggle",
							name = "Show Anchor",
							desc = "Shows Anchor with frame name.",
							order = 2.201,
							get = function(v) return Display.db.profile.frames[i].anchor end,
							set = function(info, v) Display.db.profile.frames[i].anchor = v Display:UpdateDisplay() end,
						},
						growUp = {
							type = "toggle",
							name =  "Grow Up",
							desc =  "Grow bars upwards",
							get = function(v) return Display.db.profile.frames[i].growUp end,
							set = function(info, v) Display.db.profile.frames[i].growUp = v Display:UpdateDisplay() end,
							order = 2.202,
						},
						OpHed = {
							type = "header",
							name =  "Hide/Show Frame",
							width = "full",
							order = 2.21,
						},
						hide = {
							type = "toggle",
							name = "Hide: Always",							
							desc = "Hides this frame.",
							order = 2.22,
							get = function(v) return Display.db.profile.frames[i].hideFrame end,
							set = function(info, v) Display.db.profile.frames[i].hideFrame = v Display:UpdateDisplay() end,
						},
						HideBG = {
							type = 'toggle',
							name =  "Hide: In BG",
							desc =  "This will hide/disable the addon in battlegrounds",							
							get = function(v) return Display.db.profile.frames[i].HideBG end,
							set = function(info, v) Display.db.profile.frames[i].HideBG = v Display:UpdateDisplay() end,
							order = 2.23,
						},
						HideArena = {
							type = 'toggle',
							name =  "Hide: In Arena",
							desc =  "This will hide/disable the addon in arena",
							disabled = function() if Display.db.profile.frames[i].ShowArena then Display.db.profile.frames[i].HideArena = false return true else return false end end,
							get = function(v) return Display.db.profile.frames[i].HideArena end,
							set = function(info, v) Display.db.profile.frames[i].HideArena = v Display:UpdateDisplay() end,
							order = 2.24,
						},
						ShowArena = {
							type = 'toggle',
							name =  "Show: Only In Arena",
							desc =  "This will hide/disable the addon outside arena",
							disabled = function() if Display.db.profile.frames[i].HideArena then Display.db.profile.frames[i].ShowArena = false return true else return false end end,
							get = function(v) return Display.db.profile.frames[i].ShowArena end,
							set = function(info, v) Display.db.profile.frames[i].ShowArena = v Display:UpdateDisplay() end,
							order = 2.25,
						},
						HideInRaid = {
							type = 'toggle',
							name =  "Hide: In Raid",
							desc =  "This will hide/disable the addon in a raid group",
							disabled = function() if Display.db.profile.frames[i].HideOutRaid then Display.db.profile.frames[i].HideInRaid = false return true else return false end end,
							get = function(v) return Display.db.profile.frames[i].HideInRaid end,
							set = function(info, v) Display.db.profile.frames[i].HideInRaid = v Display:UpdateDisplay() end,
							order = 2.251,
						},
						HideOutRaid = {
							type = 'toggle',
							name =  "Hide: Not In Raid",
							desc =  "This will hide/disable the addon not in a raid group",
							disabled = function() if Display.db.profile.frames[i].HideInRaid then Display.db.profile.frames[i].HideOutRaid = false return true else return false end end,
							get = function(v) return Display.db.profile.frames[i].HideOutRaid end,
							set = function(info, v) Display.db.profile.frames[i].HideOutRaid = v Display:UpdateDisplay() end,
							order = 2.252,
						},
						HideInWG = {
							type = 'toggle',
							name =  "Hide: In Wintergrasp",
							desc =  "This will hide/disable the addon in Wintergrasp",
							get = function(v) return Display.db.profile.frames[i].HideInWG end,
							set = function(info, v) Display.db.profile.frames[i].HideInWG = v Display:UpdateDisplay() end,
							order = 2.253,
						},						
						HideInCombat = {
							type = 'toggle',
							name =  "Hide: In Combat",
							desc =  "This will hide/disable the addon in Combat",
							get = function(v) return Display.db.profile.frames[i].HideInCombat end,
							set = function(info, v) Display.db.profile.frames[i].HideInCombat = v Display:UpdateDisplay() end,
							order = 2.253,
						},
						OpHedL = {
							type = "header",
							name =  "Label/Background Options",
							width = "full",
							order = 2.257,
						},
						hidetarget = {
							type = "toggle",
							name = "Hide: Target",
							desc = "Hides the Target.",
							order = 2.2581,
							get = function(v) return Display.db.profile.frames[i].hidetarget end,
							set = function(info, v) Display.db.profile.frames[i].hidetarget = v Display:UpdateDisplay() end,
						},
						HideLabel = {
							type = "toggle",
							name =  "Hide: Label",
							desc =  "Hides Labels from bars",
							disabled = function() if Display.db.profile.frames[i].SpellNameLabel then Display.db.profile.frames[i].HideLabel = false return true else return false end end,
							get = function(v) return Display.db.profile.frames[i].HideLabel end,
							set = function(info, v) Display.db.profile.frames[i].HideLabel = v Display:UpdateDisplay() end,
							order = 2.2582,
						},
						SpellNameLabel = {
							type = "toggle",
							name =  "Label: Spell Name",
							desc =  "Gives the bars the label of the spells",
							disabled = function() if Display.db.profile.frames[i].HideLabel then Display.db.profile.frames[i].SpellNameLabel = false return true else return false end end,
							get = function(v) return Display.db.profile.frames[i].SpellNameLabel end,
							set = function(info, v) Display.db.profile.frames[i].SpellNameLabel = v Display:UpdateDisplay() end,
							order = 2.258,
						},
						BarBackground = {
							type = "toggle",
							name = "Hide: Background",
							desc = "Hides the background of each bar.\nNote: will also hide the anchor",
							order = 2.2584,
							get = function(v) return Display.db.profile.frames[i].BarBackground end,
							set = function(info, v) Display.db.profile.frames[i].BarBackground = v Display:UpdateDisplay() end,
						},
						OpHedB = {
							type = "header",
							name =  "Hide Bar Options",
							width = "full",
							order = 2.259,
						},
						hideSelf = {
							type = "toggle",
							name =  "Hide: Self",
							desc =  "Hide your own cooldowns.",
							order = 3,
							get = function(v) return Display.db.profile.frames[i].hideSelf end,
							set = function(info, v) Display.db.profile.frames[i].hideSelf = v Display:UpdateDisplay() end,
						},
						onlySelf = {
							type = "toggle",
							name =  "Show: Only Self",
							desc =  "Only show your own cooldowns.",
							order = 3.1,
							get = function(v) return Display.db.profile.frames[i].onlySelf end,
							set = function(info, v) Display.db.profile.frames[i].onlySelf = v Display:UpdateDisplay() end,
						},
						EnemyFCDCaster = {
							type = "toggle",
							name =  "Show: Only Enemy",
							desc =  "Only show Enemy cooldowns.",
							order = 3.2,		
							disabled = function() if Display.db.profile.frames[i].FriendlyCaster then Display.db.profile.frames[i].EnemyFCDCaster = false return true else return false end end,
							get = function(v) return Display.db.profile.frames[i].EnemyFCDCaster end,
							set = function(info, v) Display.db.profile.frames[i].EnemyFCDCaster = v Display:UpdateDisplay() end,
						},
						FriendlyCaster = {
							type = "toggle",
							name =  "Show: Only Friendly",
							desc =  "Only show Friendly cooldowns.",
							order = 3.3,
							disabled = function() if Display.db.profile.frames[i].EnemyFCDCaster then Display.db.profile.frames[i].FriendlyCaster = false return true else return false end end,
							get = function(v) return Display.db.profile.frames[i].FriendlyCaster end,
							set = function(info, v) Display.db.profile.frames[i].FriendlyCaster = v Display:UpdateDisplay() end,
						},
						OpHedA = {
							type = "header",
							name =  "Display Options",
							width = "full",
							order = 4,
						},
						scale = {
							type = "range",
							name =  "Scale",
							desc =  "Control the scale of the frame",
							min = 1, max = 250, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.frames[i].scale end,
							set = function(info, v) Display.db.profile.frames[i].scale = v Display:UpdateDisplay() end,
							order = 11,
						},
						alpha = {
							type = "range",
							name =  "Alpha",
							desc =  "Control the transparency of the frame",
							min = 0, max = 100, step = 5, bigStep = 10,
							get = function(v) return Display.db.profile.frames[i].alpha end,
							set = function(info, v) Display.db.profile.frames[i].alpha = v Display:UpdateDisplay() end,
							order = 12,
						},
						opacity = {
							type = "range",
							name =  "Range Alpha",
							desc =  "Control the transparency of bars when the caster at or over a range of 80 yards",
							min = 0, max = 100, step = 5, bigStep = 10,
							get = function(v) return Display.db.profile.frames[i].opacity end,
							set = function(info, v) Display.db.profile.frames[i].opacity = v Display:UpdateDisplay() end,
							order = 12.1,
						},
						fontsize = {
							type = "range",
							name =  "Font Size",
							desc =  "The size of the font the bar will use",
							min = 5, max = 30, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.frames[i].fontsize end,
							set = function(info, v) Display.db.profile.frames[i].fontsize = v Display:UpdateDisplay() end,
							order = 12.2,
						},
						height = {
							type = "range",
							name =  "Height",
							min = 1, max = 25, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.frames[i].height end,
							set = function(info, v) Display.db.profile.frames[i].height = v Display:UpdateDisplay() end,
							order = 13,
							width = "double",
						},
						width = {
							type = "range",
							name =  "Width",
							min = 50, max = 500, step = 5, bigStep = 10,
							get = function(v) return Display.db.profile.frames[i].width end,
							set = function(info, v) Display.db.profile.frames[i].width = v Display:UpdateDisplay() end,
							order = 14,
							width = "double",
						},
						posX = {
							type = 'range',
							name =  "X Position",
							desc =  "Allows you to move the frame. if this is disabled your bars are locked, you can unlock them in the General options tab",
							disabled = function() if not Display.db.profile.locked then return false elseif Display.db.profile.locked then return true end end,
							softMin = 0,
							softMax = math.ceil(GetScreenWidth()),
		   					step = 1,
							bigStep = 5,
							get = function(info) return tonumber(Display.db.profile.frames[i].posX) end,
							set = function(info, v)
								Display.db.profile.frames[i].posX = tonumber(v)
								Display:SetAnchors(true)
							end,
							order = 15,
							width = "double",
						},
						posY = {
							type = 'range',
							name =  "Y Position",
							desc =  "Allows you to move the frame. if this is disabled your bars are locked, you can unlock them in the General options tab",
							disabled = function() if not Display.db.profile.locked then return false elseif Display.db.profile.locked then return true end end,
							softMin = 0,
							softMax = math.ceil(GetScreenHeight()),
		   					step = 1,
							bigStep = 5,
							get = function(info) return tonumber(Display.db.profile.frames[i].posY) end,
							set = function(info, v)
								Display.db.profile.frames[i].posY = tonumber(v)
								Display:SetAnchors(true)
							end,
							order = 16,
							width = "double",
						},
						SPOHD = {
							type = "header",
							name =  "Spells",
							width = "full",
							order = 16.7,
						},
						descr3 = {
							type = "description",
							name =  "\nNote: When a spell does not have a real cooldown e.g. Piercing Howl a 5 sec cooldown is used, Spells with * at the start of the name will have extra info in the tooltip\n",
							width = "full",
							fontSize  = "medium",
							order = 16.8,
						},
					},
				}

				local tab = optArgs["frame"..i].args
				local orderIndex = 17 -- Sorting
				local tempsortingcount = 0
				-- class bars
				for _, class in ipairs(classes) do
					if (class == "DEATHKNIGHT" and FatCooldowns.ExPac == 2) or class == "DRUID" or class == "MAGE" or class == "PALADIN" or class == "PRIEST" or class == "ROGUE" or class == "SHAMAN" or class == "WARLOCK" or class == "HUNTER" or class == "WARRIOR" then
						tab[class] = {
							type = "header",
							name =  "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\"..class..":24|t "..FCDColorName3(L[class]).." |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\"..class..":24|t",
							cmdHidden = true,
							order = orderIndex,
						}
						tab["EnableAllSpells"..class] = {
							order= orderIndex + 0.01,
							type = "execute",
							name = "Enable All Spells",
							width = "double",
							desc = "Enables all spells for ".. class,
							func = function() 
								for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
									Display.db.profile.frames[i].spells[spellTable.id] = true
									Display:SpellToggle(i,spellTable.id, true)
								end
							end
						}
						tab["DisableAllSpells"..class] = {
							order= orderIndex + 0.02,
							type = "execute",
							name = "Disable All Spells",
							width = "double",
							desc = "Enables all spells for ".. class,
							func = function() 
								for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
									Display.db.profile.frames[i].spells[spellTable.id] = nil
									Display:SpellToggle(i,spellTable.id, false)
								end
							end
						}
						orderIndex = orderIndex + 1
						for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
							local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(spellTable.id)

							local item = spellTable.itemid
							local id = spellTable.descid or spellTable.realid or spellTable.id
							local spellDesc = "??"
							if id then
								if item == nil then
									tooltip:ClearLines()
									tooltip:SetHyperlink("spell:"..id)
								else
									tooltip:ClearLines()
									tooltip:SetHyperlink("item:"..item)
								end
								local lines = tooltip:NumLines()
								if lines > 0 then
									spellDesc = _G[folder.."TooltipTextLeft"..lines] and _G[folder.."TooltipTextLeft"..lines]:GetText() or "??"
									if spellTable.desc ~= nil then 
										spellDesc = spellDesc.."\n\n"..spellTable.desc
									end
								end
							end


							if spellTable.icon ~= nil then icon = spellTable.icon end
							tab[tostring(spellTable.id)] = {
								type = "toggle",
								name = (spellTable.sortname ~= nil and "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..spellTable.sortname) or (type(spellInfo) == "number" and (tostring(GetSpellInfo(spellInfo)) .. " [#" .. spellInfo .. "]") or "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..spellInfo),
								desc = spellDesc,
								order = orderIndex + spellTable.sort,
								get = function(info) return Display.db.profile.frames[i].spells[spellTable.id] end,
								set = function(info, val)
									if val == true then
										Display.db.profile.frames[i].spells[spellTable.id] = true
									else
										Display.db.profile.frames[i].spells[spellTable.id] = nil
									end
									Display:SpellToggle(i,spellTable.id, val)
								end,
								hidden = function()
									if spellTable.ExpacHide ~= nil then
										if spellTable.ExpacHide[FatCooldowns.ExPac] then 
											return spellTable.ExpacHide[FatCooldowns.ExPac]
										else
											return false
										end
									end
								end,
								cmdHidden = true,
							}
							tempsortingcount = tempsortingcount + 1
						end 
						orderIndex = orderIndex + tempsortingcount + 1 tempsortingcount = 0
					end
				end
				-- extra bars not class
				for _, class in ipairs(classes) do
					if class == "ITEMS" or class == "RACIALS" or class == "CONSUMABLES" or class == "Tank Only Cooldowns" or class == "OTHER BARS" or class == "ITEM PROC" then
						tab[class] = {
							type = "header",
							name =  class,
							cmdHidden = true,
							order = orderIndex,
						}
						tab["EnableAllSpells"..class] = {
							order= orderIndex + 0.01,
							type = "execute",
							name = "Enable All Spells",
							width = "double",
							desc = "Enables all spells for ".. class,
							func = function() 
								for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
									Display.db.profile.frames[i].spells[spellTable.id] = true
									Display:SpellToggle(i,spellTable.id, true)
								end
							end
						}
						tab["DisableAllSpells"..class] = {
							order= orderIndex + 0.02,
							type = "execute",
							name = "Disable All Spells",
							width = "double",
							desc = "Enables all spells for ".. class,
							func = function() 
								for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
									Display.db.profile.frames[i].spells[spellTable.id] = nil
									Display:SpellToggle(i,spellTable.id, false)
								end
							end
						}
						orderIndex = orderIndex + 1
						for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
							local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(spellTable.id)

							local proc = spellTable.proc
							local item = spellTable.itemid
							local id = spellTable.descid or spellTable.realid or spellTable.id
							local spellDesc = "??"
							if id and proc == nil then
								if item == nil then
									tooltip:ClearLines()
									tooltip:SetHyperlink("spell:"..id)
								else
									tooltip:ClearLines()
									tooltip:SetHyperlink("item:"..item)
								end
								local lines = tooltip:NumLines()
								if lines > 0 then
									if spellTable.itemidline then
										spellDesc = _G[folder.."TooltipTextLeft"..spellTable.itemidline] and _G[folder.."TooltipTextLeft"..spellTable.itemidline]:GetText() or "??"
									else
										spellDesc = _G[folder.."TooltipTextLeft"..lines] and _G[folder.."TooltipTextLeft"..lines]:GetText() or "??" 
									end
									if spellTable.desc ~= nil then 
										spellDesc = spellDesc.."\n\n"..spellTable.desc
									end
								end
							elseif proc ~= nil then spellDesc = spellTable.desc
							end
							
							if spellTable.icon ~= nil then icon = spellTable.icon end
							tab[tostring(spellTable.id)] = {
								type = "toggle",
								name = (spellTable.sortname ~= nil and "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..spellTable.sortname) or (type(spellInfo) == "number" and (tostring(GetSpellInfo(spellInfo)) .. " [#" .. spellInfo .. "]") or "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..spellInfo),
								desc =  spellDesc,
								order = orderIndex,
								get = function(info) return Display.db.profile.frames[i].spells[spellTable.id] end,
								set = function(info, val)
									if val == true then
										Display.db.profile.frames[i].spells[spellTable.id] = true
									else
										Display.db.profile.frames[i].spells[spellTable.id] = nil
									end
									Display:SpellToggle(i,spellTable.id, val)
								end,	
								hidden = function()
									if spellTable.ExpacHide ~= nil then
										if spellTable.ExpacHide[FatCooldowns.ExPac] then 
											return spellTable.ExpacHide[FatCooldowns.ExPac]
										else
											return false
										end
									end
								end,
								cmdHidden = true,
							}
							orderIndex = orderIndex + 1
						end
					end
				end
			end
			optArgs["frame"..i].name = Display.db.profile.frames[i].name .. " Options"		
		else
			optArgs["frame"..i] = nil -- hide config
		end	
	end

	local otherorderIndex = 17
	--reporter - other
	for _, class in ipairs(reporters) do
		if class == "OTHER" then
			options.args.other.args.OT1.args[class] = {
				name = "REPORTER",
				type = "header",
				cmdHidden = true,
				order = 17,
			}
			for spellInfo, spellTable in pairs(FatCooldowns.reporter["OTHER"]) do
				if spellInfo:find("^Header[%d]+$") then
					options.args.other.args.OT1.args[tostring(spellTable.id)] = {
						name = spellTable.desc,
						type = "header",
						cmdHidden = true,
						order = otherorderIndex + spellTable.sort,
					}
				end
				if spellTable.id ~= 99803 and spellTable.id ~= 99804  and spellTable.id ~= 99803 and not spellInfo:find("^Header[%d]+$") then
					options.args.other.args.OT1.args[tostring(spellTable.id)] = {
						type = "toggle",
						name = spellTable.icon and spellTable.icon..spellInfo or spellInfo,
						desc =  spellTable.desc,
						order = otherorderIndex + spellTable.sort,
						width = "double",
						get = function(info) return Display.db.profile.reporter[spellTable.id] end,
						set = function(info, val)
							Display.db.profile.reporter[spellTable.id] = val
							if spellTable.id == 98875 then FatCooldowns:ChatBubblesIcons() end
						end,	
						hidden = function()
							if spellTable.ExpacHide ~= nil then
								if spellTable.ExpacHide[FatCooldowns.ExPac] then 
									return spellTable.ExpacHide[FatCooldowns.ExPac]
								else
									return false
								end
							end
						end,
						disabled = function() 
							if spellTable.id ~= 98879 then
								return false
							else
								if Display.db.profile.reporter[99879] ~= nil and Display.db.profile.reporter[99879] == false then
									return true
								else
									return false
								end
							end
						end,
						cmdHidden = true,
					}
				elseif spellTable.id ~= 99803 and spellTable.id == 99804 and not spellInfo:find("^Header[%d]+$") then
					options.args.other.args.OT1.args[tostring(spellTable.id)] = {
						type = "range",
						name = spellTable.icon and spellTable.icon..spellInfo or spellInfo,
						desc = spellTable.desc,
						min = 0, max = spellTable.max, step = 1, bigStep = 1,
						get = function(v) return Display.db.profile.SoulStoneCount end,
						set = function(info, v) Display.db.profile.SoulStoneCount = v end,
						order = otherorderIndex + 999,
						width = "double",				
						hidden = function()
							if spellTable.ExpacHide ~= nil then
								if spellTable.ExpacHide[FatCooldowns.ExPac] then 
									return spellTable.ExpacHide[FatCooldowns.ExPac]
								else
									return false
								end
							end
						end,
					} 
				elseif spellTable.id == 99803 then
					options.args.other.args.OT1.args[tostring(spellTable.id)] = {
						type = "select",
						name = spellTable.icon and spellTable.icon..spellInfo or spellInfo,
						desc = spellTable.desc,
						values = {"None", "Full Name -- Retribution", "Short Name -- Ret", "Icon -- ".." |TInterface\\Icons\\spell_holy_auraoflight:24:24:0:0:64:64:6:58:6:58|t "},
						get = function(info) return Display.db.profile.AMType end,
						set = function(info, v)	Display.db.profile.AMType = v end,
						order = otherorderIndex + 999.1,
						width = "double",
						hidden = function()
							if spellTable.ExpacHide ~= nil then
								if spellTable.ExpacHide[FatCooldowns.ExPac] then 
									return spellTable.ExpacHide[FatCooldowns.ExPac]
								else
									return false
								end
							end
						end,
					} 
				end
			end 
		end 
	end

	local orderIndexCR1 = 10
	--reporter
	for _, class in ipairs(reporters) do
		local ExpacCheck = true
		if (class == "BPC AND BQL" and FatCooldowns.ExPac ~= 2) or (class == "OTHER BOSSES" and FatCooldowns.ExPac ~= 2) or (class == "THE LICH KING" and FatCooldowns.ExPac ~= 2) or (class == "PARRY REPORTER" and FatCooldowns.ExPac ~= 2) then
			ExpacCheck = false 
		end
		if class ~= "OTHER" then
			if ExpacCheck then
				options.args.ChatReporter.args.CRMain.args[class] = {
					type = "header",
					name =  class,
					cmdHidden = true,
					order = orderIndexCR1,
				}
				orderIndexCR1 = orderIndexCR1 + 1
			end
			for spellInfo, spellTable in pairs(FatCooldowns.reporter[class]) do
				if class == "PORTALS" then
					options.args.ChatReporter.args.CRMain.args[tostring(spellTable.id)] = {
						type = "select",
						name = spellTable.icon and spellTable.icon..spellInfo or spellInfo,
						desc =  spellTable.desc,
						values = {[1] = "None", [2] = "Both: Warning", [3] = "Both: Anncounce", [4] = "Start: Warning", [5] = "Start: Anncounce", [6] = "End: Warning", [7] = "End: Anncounce"},
						order = orderIndexCR1,
						hidden = function()
							local ShouldHide = false
							if spellTable.ExpacHide ~= nil and spellTable.ExpacHide[FatCooldowns.ExPac] then ShouldHide = spellTable.ExpacHide[FatCooldowns.ExPac] end
							if spellTable.side ~= nil then
								if spellTable.side == "A" and UnitFactionGroup("player") ~= "Alliance" then ShouldHide = true
								elseif spellTable.side == "H" and UnitFactionGroup("player") == "Alliance" then ShouldHide = true
								end
							end
							return ShouldHide
						end,
						get = function(info) return Display.db.profile.reporter[spellTable.id] end,
						set = function(info, val) Display.db.profile.reporter[spellTable.id] = val end,
						cmdHidden = true,
					}
					orderIndexCR1 = orderIndexCR1 + 1
				else
					if spellTable.id == 99987 then
						options.args.ChatReporter.args.CRMain.args[tostring(spellTable.id)] = {
							type = "range",
							name = spellTable.icon and spellTable.icon..spellInfo or spellInfo,
							desc = spellTable.desc,
							min = 0, max = 15, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.FishCount end,
							set = function(info, v) Display.db.profile.FishCount = v end,
							order = orderIndexCR1,
							width = "double",
							hidden = function()
							if spellTable.ExpacHide ~= nil then
								if spellTable.ExpacHide[FatCooldowns.ExPac] then 
									return spellTable.ExpacHide[FatCooldowns.ExPac]
								else
									return false
								end
							end
						end,
						} 
					else
						options.args.ChatReporter.args.CRMain.args[tostring(spellTable.id)] = {
							type = "toggle",
							name = spellTable.icon and spellTable.icon..spellInfo or spellInfo,
							desc =  spellTable.desc,
							order = orderIndexCR1,
							get = function(info) return Display.db.profile.reporter[spellTable.id] end,
							set = function(info, val) Display.db.profile.reporter[spellTable.id] = val end,
							cmdHidden = true,
							width = "double",
							hidden = function()
								if spellTable.ExpacHide ~= nil then
									if spellTable.ExpacHide[FatCooldowns.ExPac] then 
										return spellTable.ExpacHide[FatCooldowns.ExPac]
									else
										return false
									end
								end
							end,
						}
					end
					orderIndexCR1 = orderIndexCR1 + 1
				end
			end 
		end 
	end
	--chat filter
	local HeaderOrderBubbles = 0
	local HeaderOrder = 0
	local RaidsOrder = nil
	for _, class in ipairs(ChatFilters) do
		if class == "CHAT FILTER - Bubbles" then HeaderOrderBubbles = orderIndexCR1 end
		if class == "CHAT FILTER - Global" then HeaderOrder = orderIndexCR1 end
		if class == "CHAT FILTER - Global Raids" then RaidsOrder = orderIndexCR1 else RaidsOrder = nil end
		options.args.ChatFilter.args.ChatFilterTab.args[class] = {
			type = "header",
			name =  class,
			cmdHidden = true,
			order = orderIndexCR1,
		}
		orderIndexCR1 = orderIndexCR1 + 1
		for spellInfo, spellTable in pairs(FatCooldowns.chatfilter[class]) do
			if spellTable.id == 99917 then
				options.args.ChatFilter.args.ChatFilterTab.args[tostring(spellTable.id)] = {
					type = "toggle",
					name = spellInfo,
					desc =  spellTable.desc,
					order = HeaderOrderBubbles + 0.001,
					width = "double",
					disabled = function()
						if spellInfo == "Bubbles Only" and Display.db.profile.chatfilter[99917] then return false
						elseif spellInfo == "Bubbles Only" and not Display.db.profile.chatfilter[99917] then Display.db.profile.chatfilter[99897] = false return true end
					end,
					get = function(info) return Display.db.profile.chatfilter[spellTable.id] end,
					set = function(info, val)
						Display.db.profile.chatfilter[spellTable.id] = val
						FatCooldowns:GetModule("Chat"):Chatfiltercheck()
					end,
					cmdHidden = true,
				}
			elseif spellTable.id == 99897 then
				options.args.ChatFilter.args.ChatFilterTab.args[tostring(spellTable.id)] = {
					type = "toggle",
					name = spellInfo,
					desc =  spellTable.desc,
					order = HeaderOrderBubbles + 0.002,
					width = "full",
					disabled = function()
						if spellInfo == "Bubbles Only" and Display.db.profile.chatfilter[99917] then return false
						elseif spellInfo == "Bubbles Only" and not Display.db.profile.chatfilter[99917] then Display.db.profile.chatfilter[99897] = false return true end
					end,
					get = function(info) return Display.db.profile.chatfilter[spellTable.id] end,
					set = function(info, val)
						Display.db.profile.chatfilter[spellTable.id] = val
						FatCooldowns:GetModule("Chat"):Chatfiltercheck()
					end,
					cmdHidden = true,
				}
			elseif spellTable.id == 99765 then
				options.args.ChatFilter.args.ChatFilterTab.args[tostring(spellTable.id)] = {
					type = "select",
					name =  "ElvUi ChatBubbles Style",
					desc = "If you use ElvUi you will need to select your chat bubble style",
					values = {
						["backdrop"] = "Skin Backdrop",
						["nobackdrop"] = "Remove Backdrop",
						["backdrop_noborder"] = "Skin Backdrop (No Borders)",
						["disabled"] = "DISABLE",
					},
					get = function(info) return Display.db.profile.ElvUiCB end,
					set = function(info, v)	Display.db.profile.ElvUiCB = v end,
					order = HeaderOrderBubbles + 0.0011,
					width = "double",
				}
			elseif spellTable.id == 99766 then
				options.args.ChatFilter.args.ChatFilterTab.args[tostring(spellTable.id)] = {
					type = "range",
					name =  "Duplicate Messages",
					desc = "Blocks duplicate messages on global chat from the same person for the set amount of seconds.\n\nNote: 0 = disabled",
					min = 0, max = 6000, step = 1, bigStep = 1,
					get = function(info) return Display.db.profile.samechatmessages end,
					set = function(info, v)	Display.db.profile.samechatmessages = v FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
					order = HeaderOrder + 3.1,
					width = "double",
				}

			else
				options.args.ChatFilter.args.ChatFilterTab.args[tostring(spellTable.id)] = {
					type = "toggle",
					name = type(spellInfo) == "number" and (tostring(GetSpellInfo(spellInfo)) .. " [#" .. spellInfo .. "]") or spellInfo,
					disabled = function()
						if spellInfo == "Monster/NPC Bubbles" and Display.db.profile.chatfilter[99917] then return false
						elseif spellInfo == "Monster/NPC Bubbles" and not Display.db.profile.chatfilter[99917] then Display.db.profile.chatfilter[99916] = false return true end
										
						if spellInfo == "Japanese, Chinese and Korean Bubbles" and Display.db.profile.chatfilter[99917] then return false
						elseif spellInfo == "Japanese, Chinese and Korean Bubbles" and not Display.db.profile.chatfilter[99917] then Display.db.profile.chatfilter[99915] = false return true end

						if spellInfo == "Russian Bubbles" and Display.db.profile.chatfilter[99917] then return false
						elseif spellInfo == "Russian Bubbles" and not Display.db.profile.chatfilter[99917] then Display.db.profile.chatfilter[99913] = false return true end

						if spellInfo == "Bubbles Shekles Spam List" and Display.db.profile.chatfilter[99917] then return false
						elseif spellInfo == "Bubbles Shekles Spam List" and not Display.db.profile.chatfilter[99917] then Display.db.profile.chatfilter[99934] = false return true end

						if spellInfo == "Innervate Bubbles" and Display.db.profile.chatfilter[99917] then return false
						elseif spellInfo == "Innervate Bubbles" and not Display.db.profile.chatfilter[99917] then Display.db.profile.chatfilter[99933] = false return true end

						if spellInfo == "Spanish Bubbles" and Display.db.profile.chatfilter[99917] then return false
						elseif spellInfo == "Spanish Bubbles" and not Display.db.profile.chatfilter[99917] then Display.db.profile.chatfilter[99937] = false return true end

						if spellInfo == "Unbound Plague" and Display.db.profile.chatfilter[99917] then return false
						elseif spellInfo == "Unbound Plague" and not Display.db.profile.chatfilter[99917] then Display.db.profile.chatfilter[99938] = false return true end

					end,
					desc =  spellTable.desc,
					order = (RaidsOrder and RaidsOrder + spellTable.sort or orderIndexCR1),
					get = function(info) return Display.db.profile.chatfilter[spellTable.id] end,
					set = function(info, val)
						Display.db.profile.chatfilter[spellTable.id] = val
						FatCooldowns:GetModule("Chat"):Chatfiltercheck()
					end,
					cmdHidden = true,
				}
			end
			orderIndexCR1 = orderIndexCR1 + 1
		end 
	end 
	-- chat filter reporter
	local orderIndexCR = 17 -- Sorting
	for _, class in ipairs(ChatFilters) do
		if class == "CHAT FILTER - Global Raids" then RaidsOrder = orderIndexCR else RaidsOrder = nil end
		options.args.ChatFilter.args.ChatFilterReporter2.args[class] = {
			type = "header",
			name =  class,
			cmdHidden = true,
			hidden = function()
			local BlockedClass = true
				for spellInfo, spellTable in pairs(FatCooldowns.chatfilter[class]) do
					if spellTable.id ~= 99917 and spellTable.id ~= 99897 then
						if Display.db.profile.chatfilter[spellTable.id] then BlockedClass = false end
					end
				end
				return BlockedClass
			end,
			order = orderIndexCR,
			}
			orderIndexCR = orderIndexCR + 1
		for spellInfo, spellTable in pairs(FatCooldowns.chatfilter[class]) do
			if spellTable.id ~= 99917 and spellTable.id ~= 99897 then
				options.args.ChatFilter.args.ChatFilterReporter2.args[tostring(spellTable.id)] = {
				type = "range",
				name = spellInfo,
				desc = spellTable.desc,
				min = 0, max = 10, step = 1, bigStep = 1,
				get = function(v) return Display.db.profile.ChatFilterReporter2[spellTable.id].chan end,
				set = function(info, v)
					Display.db.profile.ChatFilterReporter2[spellTable.id].chan = v
					if v > 0 then Display.db.profile.ChatFilterReporter2[spellTable.id].enable = true else Display.db.profile.ChatFilterReporter2[spellTable.id].enable = false end
				end,
				hidden = function()
					if Display.db.profile.chatfilter[spellTable.id] then
						Display.db.profile.ChatFilterReporter2[spellTable.id] = Display.db.profile.ChatFilterReporter2[spellTable.id] or {chan = 0, enable = true}
						Display.db.profile.ChatFilterReporter2[spellTable.id].enable = true
						return false
					else
						Display.db.profile.ChatFilterReporter2[spellTable.id] = Display.db.profile.ChatFilterReporter2[spellTable.id] or {chan = 0, enable = false}
						Display.db.profile.ChatFilterReporter2[spellTable.id].enable = false
						return true 
					end
				end,
				order = (RaidsOrder and RaidsOrder + spellTable.sort or orderIndexCR),
				cmdHidden = true,
				}
				
			end
			orderIndexCR = orderIndexCR + 1
		end 
	end
	--soundspells
	local orderIndex2 = 17 -- Sorting
	local tempsortingcount2 = 0		
	for _, class in ipairs(classes) do
		if (class == "DEATHKNIGHT" and FatCooldowns.ExPac == 2) or class == "DRUID" or class == "MAGE" or class == "PALADIN" or class == "PRIEST" or class == "ROGUE" or class == "SHAMAN" or class == "WARLOCK" or class == "HUNTER" or class == "WARRIOR" or class == "OTHER BARS" then
			options.args.soundspells.args[class] = {
				type = "header",
				name =  function()
					if class ~= "OTHER BARS" then
						return "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\"..class..":24|t "..FCDColorName3(class).." |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\"..class..":24|t"
					else
						return class
					end
				end,
				cmdHidden = true,
				order = orderIndex2,
			}
			orderIndex2 = orderIndex2 + 1
			for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
				local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(spellTable.id)
				if spellTable.icon ~= nil then icon = spellTable.icon end
				if spellTable.id ~= 69766 then
					options.args.soundspells.args[tostring(spellTable.id)] = {
						type = "toggle",
						name = (spellTable.sortname ~= nil and "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..spellTable.sortname) or (type(spellInfo) == "number" and (tostring(GetSpellInfo(spellInfo)) .. " [#" .. spellInfo .. "]") or "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..spellInfo),
						desc =  spellTable.desc or string.format("Plays sound for "..(spellTable.sortname or "%s"),spellInfo),
						order = orderIndex2 + spellTable.sort,
						get = function(info) return Display.db.profile.soundspells[spellTable.id] end,
						set = function(info, val)
							if val == true then
								Display.db.profile.soundspells[spellTable.id] = val
								Display.db.profile.soundspellsoptions[spellTable.id] = {id = spellTable.id, EnemyCaster = false, NotTargetMe = false, TargetMe = false, FriendlyCaster = false, NotSelf = false, CDUsed = false, CDReady = false,
									Self = false, PlayerClassEnable = false, Spec1 = false, Spec2 = false, EnableCustomSound = false, CustomSound = "None", OptionsClass = class, CDUsedSound = false, CDReadySound = false,
									PlayerClass = {}
								}
							else
								Display.db.profile.soundspells[spellTable.id] = nil
								Display.db.profile.soundspellsoptions[spellTable.id] = nil
							end
							FatCooldowns.RefreshFrameListOptionsAndVariables()
						end,
						hidden = function()
							if spellTable.ExpacHide ~= nil then
								if spellTable.ExpacHide[FatCooldowns.ExPac] then 
									return spellTable.ExpacHide[FatCooldowns.ExPac]
								else
									return false
								end
							end
						end,
						cmdHidden = true,
					}
					tempsortingcount2 = tempsortingcount2 + 1
				end
			end
			orderIndex2 = orderIndex2 + tempsortingcount2 + 1 tempsortingcount2 = 0
		end 
	end
	local orderIndextab2 = 2
	local ClassTable2 = {}
	for spellID, SRTable in pairs(Display.db.profile.soundspellsoptions) do
		for _, class in ipairs(classes) do
			for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
				if spellID == spellInfo or spellID == spellTable.id then
					ClassTable2[class] = class
					SRTable.OptionsClass = class 
				end
			end
		end
	end
	options.args.soundspells.args.soundspellsoptions = {
		type = "group",
		name = "Spell Sounds Options",
		desc = "Set options for each spell",
		childGroups = "tab",
		cmdHidden = true,
		order = 2,
		args = {
			descr = {
				type = "description",
				name =  "Select which Spells Sounds you would like to enable."..
				"\n\nNote: Not every spell option has been tested please report if you find a broken one, if a sound no longer works after an update try disabling the sound and re-enable it"..
				"\nNote: For now you will need to track the spell in bars/frames for Spell Ready ",
				width = "full",
				fontSize  = "medium",
				order = 1,
			}
		}
	}
	for Num, class in ipairs(classes) do
		if ClassTable2[class] ~= nil then
		options.args.soundspells.args.soundspellsoptions.args[class] =  {
			type = "group",
			name =  FCDColorName3(class),
			desc = "Configure Spells Sounds Options for "..class,
			cmdHidden = true,
			order = orderIndextab2,
			args = {
			}
		}
		orderIndextab2 = orderIndextab2 + Num
		end
	end
	local orderIndex = 2 
	for spellID, SRTable in pairs(Display.db.profile.soundspellsoptions) do
		if SRTable.CDUsedSound == nil then SRTable.CDUsedSound = false end
		if SRTable.CDReadySound == nil then SRTable.CDReadySound = false end
		local tempname = nil
		local ssname, ssrank, ssicon, sscastTime, ssminRange, ssmaxRange, ssspellID = GetSpellInfo(spellID)

		for _, class in ipairs(classes) do
			for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
				if spellTable.id == spellID then tempname = spellTable.sortname end
				if spellTable.id == spellID and spellTable.icon ~= nil then ssicon = spellTable.icon end
			end
		end

		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID)] =  {
			type = "header",
			name =  (tempname ~= nil and "|T"..ssicon..":24:24:0:0:64:64:6:58:6:58|t "..tempname) or ("|T"..ssicon..":24:24:0:0:64:64:6:58:6:58|t "..string.format("%s",tostring(GetSpellInfo(spellID)))),
			order = orderIndex,
			width = "full",
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."CDUsed"] =  {
			type = "toggle",
			name =  "Spell Used",
			desc =  "this will make the sound active only when the spell is used.",
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].CDUsed end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].CDUsed = v end,
			order = orderIndex + 0.1,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."CDUsedSound"] =  {
			type = "toggle",
			name =  "Spell Used Sound",
			desc =  "this will play a Used sound after the cd sound.",
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].CDUsedSound end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].CDUsedSound = v end,
			order = orderIndex + 0.12,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."CDReady"] =  {
			type = "toggle",
			name =  "Spell Ready",
			desc =  "this will make the sound active only when the spell has become ready.",
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].CDReady end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].CDReady = v end,
			order = orderIndex + 0.2,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."CDReadySound"] =  {
			type = "toggle",
			name =  "Spell Ready Sound",
			desc =  "this will play a ready sound after the cd sound.",
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].CDReadySound end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].CDReadySound = v end,
			order = orderIndex + 0.21,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."EnemyCaster"] =  {
			type = "toggle",
			name =  "Enemy Caster",
			desc =  "this will make the sound active only when the spell is cast by an enemy player.",
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].EnemyCaster end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].EnemyCaster = v end,
			order = orderIndex + 0.3,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."FriendlyCaster"] =  {
			type = "toggle",
			name =  "Friendly Caster",
			desc =  "this will make the sound active only when the spell is cast by an friendly player.",
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].FriendlyCaster end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].FriendlyCaster = v end,
			order = orderIndex + 0.4,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."TargetMe"] =  {
			type = "toggle",
			name =  "Targeting Me",
			desc =  "this will make the sound active only when the spell targeting you.",
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].TargetMe end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].TargetMe = v end,
			order = orderIndex + 0.5,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."NotTargetMe"] =  {
			type = "toggle",
			name =  "Not Targeting Me",
			desc =  "this will make the sound active only when the spell is not targeting you.",
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].NotTargetMe end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].NotTargetMe = v end,
			order = orderIndex + 0.6,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."NotSelf"] =  {
			type = "toggle",
			name =  "Not Cast By Me",
			desc =  "this will make the sound active only when the spell is not cast by you.",
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].NotSelf end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].NotSelf = v end,
			order = orderIndex + 0.7,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."Self"] =  {
			type = "toggle",
			name =  "Cast By Me",
			desc =  "this will make the sound active only when the spell is cast by you.",
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].Self end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].Self = v end,
			order = orderIndex + 0.8,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."Spec1"] =  {
			type = "toggle",
			name =  "Primary Spec",
			desc =  "this will make the sound active only when you have your Primary Spec active.",
			disabled = function() if Display.db.profile.soundspellsoptions[spellID].Spec2 then Display.db.profile.soundspellsoptions[spellID].Spec1 = false return true else return false end end,
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].Spec1 end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].Spec1 = v end,
			order = orderIndex + 0.811,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."Spec2"] =  {
			type = "toggle",
			name =  "Secondary Spec",
			desc =  "this will make the sound active only when you have your Secondary Spec active.",
			disabled = function() if Display.db.profile.soundspellsoptions[spellID].Spec1 then Display.db.profile.soundspellsoptions[spellID].Spec2 = false return true else return false end end,
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].Spec2 end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].Spec2 = v end,
			order = orderIndex + 0.812,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."EnableCustomSound"] =  {
			type = "toggle",
			name =  "Enable Custom Sound",
			desc =  "this will enable the Custom set sound to play instead of the spell name.",
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].EnableCustomSound end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].EnableCustomSound = v end,
			order = orderIndex + 0.813,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."CustomSound"] =  {
			type = "select",
			name =  "Custom Sound",
			desc =  "this will enable the Custom set sound to play instead of the spell name.",
			hidden = function() if Display.db.profile.soundspellsoptions[spellID].EnableCustomSound then return false elseif not Display.db.profile.soundspellsoptions[spellID].EnableCustomSound then return true end end,
			values = function()
			local SoundName = {}
				for CustomSoundName, CustomSoundPath in pairs(FatCooldowns.FCDSounds) do
					SoundName[CustomSoundName] = CustomSoundName
				end
				return SoundName
			end,
			get = function(info, v, v2) return Display.db.profile.soundspellsoptions[spellID].CustomSound
			end,
			set = function(info, v, v2) Display.db.profile.soundspellsoptions[spellID].CustomSound = v 	
				PlaySoundFile(FatCooldowns.FCDSounds[v], "Master",false)
			end,
			order = orderIndex + 0.814,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."PlayerClassEnable"] =  {
			type = "toggle",
			name =  "Player Class Enable",
			desc =  "this will enable the player class option.",
			get = function(v) return Display.db.profile.soundspellsoptions[spellID].PlayerClassEnable end,
			set = function(info, v) Display.db.profile.soundspellsoptions[spellID].PlayerClassEnable = v end,
			order = orderIndex + 0.815,
		}
		options.args.soundspells.args.soundspellsoptions.args[SRTable.OptionsClass].args[tostring(spellID).."PlayerClass"] =  {
			type = "multiselect",
			name =  "Player Class",
			hidden = function() if Display.db.profile.soundspellsoptions[spellID].PlayerClassEnable then return false elseif not Display.db.profile.soundspellsoptions[spellID].PlayerClassEnable then return true end end,
			disabled = function() if Display.db.profile.soundspellsoptions[spellID].PlayerClassEnable then return false elseif not Display.db.profile.soundspellsoptions[spellID].PlayerClassEnable then
				for val, key in pairs(Display.db.profile.soundspellsoptions[spellID].PlayerClass) do
					Display.db.profile.soundspellsoptions[spellID].PlayerClass[val] = nil
				end
				return true end end,
			desc =  "this will make the sound active only when the player class matchers one of the selected.",
			values = function(info, v) if FatCooldowns.ExPac == 2 then
				return {
					["DEATH KNIGHT"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t |cffC41F3BDEATHKNIGHT|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t", 
					["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
					["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
					["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
					["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
					["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
					["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
					["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
					["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
					["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
				else return {
					["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
					["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
					["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
					["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
					["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
					["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
					["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
					["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
					["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
				end
			end,
			get = function(info, v) return Display.db.profile.soundspellsoptions[spellID].PlayerClass[v] end,
			set = function(info, v, v2)
				if v2 == true then
					Display.db.profile.soundspellsoptions[spellID].PlayerClass[v] = v2
				else
					Display.db.profile.soundspellsoptions[spellID].PlayerClass[v] = nil
				end
			end,
			order = orderIndex + 0.82,
		}

		orderIndex = orderIndex + 1
	end
	--SpellsReporter
	local orderIndex3 = 17 -- Sorting
	local tempsortingcount3 = 0
	for _, class in ipairs(classes) do
		if (class == "DEATHKNIGHT" and FatCooldowns.ExPac == 2) or class == "DRUID" or class == "MAGE" or class == "PALADIN" or class == "PRIEST" or class == "ROGUE" or class == "SHAMAN" or class == "WARLOCK" or class == "HUNTER" or class == "WARRIOR" or
			class == "ITEMS" or class == "RACIALS" or class == "CONSUMABLES" then
			options.args.SpellsReporter.args[class] = {
				type = "header",
				name =  function()
					if class ~= "OTHER BARS" and class ~= "RACIALS" and class ~= "CONSUMABLES"  then
						return "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\"..class..":24|t "..FCDColorName3(class).." |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\"..class..":24|t"
					else
						return class
					end
				end,
				cmdHidden = true,
				order = orderIndex3,
			}
			orderIndex3 = orderIndex3 + 1
			for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
				local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(spellTable.id)
				if spellTable.icon ~= nil then icon = spellTable.icon end
				if spellTable.id ~= 69766 then
					options.args.SpellsReporter.args[tostring(spellTable.id)] = {
						type = "toggle",
						name = (spellTable.sortname ~= nil and "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..spellTable.sortname) or (type(spellInfo) == "number" and (tostring(GetSpellInfo(spellInfo)) .. " [#" .. spellInfo .. "]") or "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..spellInfo),
						desc =  spellTable.desc or string.format("Sends Chat message for "..(spellTable.sortname or "%s"),spellInfo),
						order = orderIndex3 + (spellTable.sort and spellTable.sort or 0),
						get = function(info) return Display.db.profile.SpellsReporter[spellTable.id] end,
						set = function(info, val)
							if val then
								Display.db.profile.SpellsReporter[spellTable.id] = val
								Display.db.profile.spellreporteroptions[spellTable.id] = {id = spellTable.id, CDUsed = false, CDReady = false,
									Self = 1, Spec = 1, Channel = 1, Raid = 1, BG = 1, Arena = 1, EnemyCaster = 1, TargetMe = 1,
									PlayerClassEnable = false, OptionsClass = class,
									PlayerClass = {}
								}
							else
								Display.db.profile.SpellsReporter[spellTable.id] = nil
								Display.db.profile.spellreporteroptions[spellTable.id] = nil
							end
							FatCooldowns.RefreshFrameListOptionsAndVariables()
						end,
						hidden = function()
							if spellTable.ExpacHide ~= nil then
								if spellTable.ExpacHide[FatCooldowns.ExPac] then 
									return spellTable.ExpacHide[FatCooldowns.ExPac]
								else
									return false
								end
							end
						end,
						cmdHidden = true,
					}
					tempsortingcount3 = tempsortingcount3 + 1
				end
			end
			orderIndex3 = orderIndex3 + tempsortingcount3 + 1 tempsortingcount3 = 0
		end 
	end
	local orderIndex = 2
	local orderIndextab = 2
	local ClassTable = {}
	for spellID, SRTable in pairs(Display.db.profile.spellreporteroptions) do
		for _, class in ipairs(classes) do
			for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
				if spellID == spellInfo or spellID == spellTable.id then
					ClassTable[class] = class
					SRTable.OptionsClass = class 
				end
			end
		end
	end
	options.args.SpellsReporter.args.spellreporteroptions = {
		type = "group",
		name = "Spell Reporter Options",
		desc = "Set options for each spell",
		childGroups = "tab",
		cmdHidden = true,
		order = 2,
		args = {
			descr = {
				type = "description",
				name =  "Select which Spells Reporter you would like to report, you will need to be raid leader/assist to report in raid chat."..
				"\n\nNote: Not every spell option has been tested please report if you find a broken one, if a sound no longer works after an update try disabling the sound and re-enable it"..
				"\nNote: For now you will need to track the spell in bars/frames for Spell Ready",
				width = "full",
				fontSize  = "medium",
				order = 1,
			}
		}
	}
	for Num, class in ipairs(classes) do
		if ClassTable[class] ~= nil then
			options.args.SpellsReporter.args.spellreporteroptions.args[class] =  {
				type = "group",
				name =  FCDColorName3(class),
				desc = "Configure Spells Reports Options for "..class,
				cmdHidden = true,
				order = orderIndextab,
				args = {
				}
			}
			orderIndextab = orderIndextab + Num
		end
	end
	for spellID, SRTable in pairs(Display.db.profile.spellreporteroptions) do 
		local tempname = nil
		local ssname, ssrank, ssicon, sscastTime, ssminRange, ssmaxRange, ssspellID = GetSpellInfo(spellID)

		for _, class in ipairs(classes) do
			for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
				if spellTable.id == spellID then tempname = spellTable.sortname end
				if spellTable.id == spellID and spellTable.icon ~= nil then ssicon = spellTable.icon end
			end
		end

		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID)] =  {
			type = "header",
			name =  (tempname ~= nil and "|T"..ssicon..":24:24:0:0:64:64:6:58:6:58|t "..tempname) or ("|T"..ssicon..":24:24:0:0:64:64:6:58:6:58|t "..string.format("%s",tostring(GetSpellInfo(spellID)))),
			order = orderIndex,
			width = "full",
		}
		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID).."CDUsed"] =  {
			type = "toggle",
			name =  "Spell Used",
			desc =  "this will make the report active only when the spell is used.",
			get = function(v) return Display.db.profile.spellreporteroptions[spellID].CDUsed end,
			set = function(info, v) Display.db.profile.spellreporteroptions[spellID].CDUsed = v end,
			order = orderIndex + 0.1,
		}
		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID).."CDReady"] =  {
			type = "toggle",
			name =  "Spell Ready",
			desc =  "this will make the report active only when the spell has become ready.",
			get = function(v) return Display.db.profile.spellreporteroptions[spellID].CDReady end,
			set = function(info, v) Display.db.profile.spellreporteroptions[spellID].CDReady = v end,
			order = orderIndex + 0.2,
		}
		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID).."EnemyCaster"] =  {
			type = "select",
			name =  "Enemy or Friendly Caster",
			desc =  "this will limit the report to be sent if the selected option is correct",
			values = {"Any", "Enemy", "Friendly"},
			get = function(info, v, v2) return Display.db.profile.spellreporteroptions[spellID].EnemyCaster end,
			set = function(info, v, v2) Display.db.profile.spellreporteroptions[spellID].EnemyCaster = v end,
			order = orderIndex + 0.3,
		}
		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID).."TargetMe"] =  {
			type = "select",
			name =  "Targeting Me",
			desc =  "this will limit the report to be sent if the selected option is correct",
			values = {"Any", "Targeting Me", "Not Targeting Me"},
			get = function(info, v, v2) return Display.db.profile.spellreporteroptions[spellID].TargetMe end,
			set = function(info, v, v2) Display.db.profile.spellreporteroptions[spellID].TargetMe = v end,
			order = orderIndex + 0.4,
		}
		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID).."Self"] =  {
			type = "select",
			name =  "Cast by Self",
			desc =  "this will limit the report to be sent if the selected option is correct",
			values = {"Any", "Self", "Not Self"},
			get = function(info, v, v2) return Display.db.profile.spellreporteroptions[spellID].Self end,
			set = function(info, v, v2) Display.db.profile.spellreporteroptions[spellID].Self = v end,
			order = orderIndex + 0.5,
		}
		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID).."Spec"] =  {
			type = "select",
			name =  "Spec",
			desc =  "this will limit the report to be sent if the selected option is correct",
			values = {"Any", "Primary Spec", "Secondary Spec"},
			get = function(info, v, v2) return Display.db.profile.spellreporteroptions[spellID].Spec end,
			set = function(info, v, v2) Display.db.profile.spellreporteroptions[spellID].Spec = v end,
			order = orderIndex + 0.811,
		}
		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID).."Raid"] =  {
			type = "select",
			name =  "Raid",
			desc =  "this will limit the report to be sent if the selected option is correct",
			values = {"Any", "In Raid", "Not In Raid"},
			get = function(info, v, v2) return Display.db.profile.spellreporteroptions[spellID].Raid end,
			set = function(info, v, v2) Display.db.profile.spellreporteroptions[spellID].Raid = v end,
			order = orderIndex + 0.813,
		}
		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID).."BG"] =  {
			type = "select",
			name =  "BG",
			desc =  "this will limit the report to be sent if the selected option is correct",
			values = {"Any", "In BG", "Not In BG"},
			get = function(info, v, v2) return Display.db.profile.spellreporteroptions[spellID].BG end,
			set = function(info, v, v2) Display.db.profile.spellreporteroptions[spellID].BG = v end,
			order = orderIndex + 0.814,
		}
		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID).."Arena"] =  {
			type = "select",
			name =  "Arena",
			desc =  "this will limit the report to be sent if the selected option is correct",
			values = {"Any", "In Arena", "Not In Arena"},
			get = function(info, v, v2) return Display.db.profile.spellreporteroptions[spellID].Arena end,
			set = function(info, v, v2) Display.db.profile.spellreporteroptions[spellID].Arena = v end,
			order = orderIndex + 0.815,
		}
		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID).."Channel"] =  {
			type = "select",
			name =  "Channel",
			desc =  "set the channel were the report will be sent.\n\nNote: Raid means it will only post in raid, Both means it will post in raid when in raid or party when in party",
			values = {"Self", "Party", "Raid", "Both"},
			get = function(info, v, v2) return Display.db.profile.spellreporteroptions[spellID].Channel end,
			set = function(info, v, v2) Display.db.profile.spellreporteroptions[spellID].Channel = v end,
			order = orderIndex + 0.816,
		}
		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID).."PlayerClassEnable"] =  {
			type = "toggle",
			name =  "Player Class Enable",
			desc =  "this will enable the player class option.",
			get = function(v) return Display.db.profile.spellreporteroptions[spellID].PlayerClassEnable end,
			set = function(info, v) Display.db.profile.spellreporteroptions[spellID].PlayerClassEnable = v end,
			order = orderIndex + 0.817,
		}
		options.args.SpellsReporter.args.spellreporteroptions.args[SRTable.OptionsClass].args[tostring(spellID).."PlayerClass"] =  {
			type = "multiselect",
			name =  "Player Class",
			hidden = function() if Display.db.profile.spellreporteroptions[spellID].PlayerClassEnable then return false elseif not Display.db.profile.spellreporteroptions[spellID].PlayerClassEnable then return true end end,
			disabled = function() if Display.db.profile.spellreporteroptions[spellID].PlayerClassEnable then return false elseif not Display.db.profile.spellreporteroptions[spellID].PlayerClassEnable then
				for val, key in pairs(Display.db.profile.spellreporteroptions[spellID].PlayerClass) do
					Display.db.profile.spellreporteroptions[spellID].PlayerClass[val] = nil
				end
				return true end end,
			desc =  "this will make the report active only when the player class matchers one of the selected.",
			values = function(info, v) if FatCooldowns.ExPac == 2 then
				return {
					["DEATH KNIGHT"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t |cffC41F3BDEATHKNIGHT|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t", 
					["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
					["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
					["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
					["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
					["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
					["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
					["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
					["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
					["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
				else return {
					["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
					["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
					["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
					["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
					["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
					["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
					["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
					["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
					["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
				end
			end,
			get = function(info, v) return Display.db.profile.spellreporteroptions[spellID].PlayerClass[v] end,
			set = function(info, v, v2)
				if v2 == true then
					Display.db.profile.spellreporteroptions[spellID].PlayerClass[v] = v2
				else
					Display.db.profile.spellreporteroptions[spellID].PlayerClass[v] = nil
				end
			end,
			order = orderIndex + 0.82,
		}




		orderIndex = orderIndex + 1
	end
	-- spells order
	if not options.args.spellOrder.args["WARRIOR"] then
		local tab = options.args.spellOrder.args
		local orderIndex = 2 
		local tempsortingcount = 0
		
		for _, class in ipairs(classes) do
			if (class == "DEATHKNIGHT" and FatCooldowns.ExPac == 2) or class == "DRUID" or class == "MAGE" or class == "PALADIN" or class == "PRIEST" or class == "ROGUE" or
			class == "SHAMAN" or class == "WARLOCK" or class == "HUNTER" or class == "WARRIOR" then
				tab[class] = {
					type = "header",
					name =  "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\"..class..":24|t "..FCDColorName3(class).." |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\"..class..":24|t",
					cmdHidden = true,
					order = orderIndex,
				}
				tab["EnableAllSpells"..class] = {
					order= orderIndex + 0.01,
					type = "execute",
					name = "Enable All Spells",
					width = "double",
					desc = "Enables all spells for ".. class,
					func = function() 
						for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
							Display.db.profile.orderSpells[spellTable.id] = true
						end
						FatCooldowns.RefreshFrameListOptionsAndVariables()
					end
				}
				tab["DisableAllSpells"..class] = {
					order= orderIndex + 0.02,
					type = "execute",
					name = "Disable All Spells",
					width = "double",
					desc = "Enables all spells for ".. class,
					func = function() 
						for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
							Display.db.profile.orderSpells[spellTable.id] = nil
							Display.db.profile.orderSpellPriorities[spellTable.id] = nil
							FatCooldowns.spellInfoTable[spellTable.id].order = 500
						end
						FatCooldowns.RefreshFrameListOptionsAndVariables()
					end
				}
				orderIndex = orderIndex + 1
				for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
					local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(spellTable.id)
					if spellTable.icon ~= nil then icon = spellTable.icon end
					if spellTable.id <= 89999  or spellTable.id == 99038 then
						tab[tostring(spellTable.id)] = {
							type = "toggle",
							name = (spellTable.sortname ~= nil and "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..spellTable.sortname) or (type(spellInfo) == "number" and (tostring(GetSpellInfo(spellInfo)) .. " [#" .. spellInfo .. "]") or "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..spellInfo),
							desc =  string.format("Select %s",spellInfo),
							order = orderIndex + spellTable.sort,
							get = function(info) return Display.db.profile.orderSpells[spellTable.id] end,
							set = function(info, val)
								if val then
									Display.db.profile.orderSpells[spellTable.id] = val
								else
									Display.db.profile.orderSpells[spellTable.id] = nil
									Display.db.profile.orderSpellPriorities[spellTable.id] = nil
									FatCooldowns.spellInfoTable[spellTable.id].order = 500
								end
								FatCooldowns.RefreshFrameListOptionsAndVariables()
							end,
							cmdHidden = true,
							hidden = function()
								if spellTable.ExpacHide ~= nil then
									if spellTable.ExpacHide[FatCooldowns.ExPac] then 
										return spellTable.ExpacHide[FatCooldowns.ExPac]
									else
										return false
									end
								end
							end,
						}
					end
					tempsortingcount = tempsortingcount + 1
				end 
				orderIndex = orderIndex + tempsortingcount + 1 tempsortingcount = 0
			end	
		end
		for _, class in ipairs(classes) do
			if class == "ITEMS" or class == "RACIALS" or class == "CONSUMABLES" or class == "OTHER BARS" then
				tab[class] = {
					type = "header",
					name =  class,
					cmdHidden = true,
					order = orderIndex,
				}
				tab["EnableAllSpells"..class] = {
					order= orderIndex + 0.01,
					type = "execute",
					name = "Enable All Spells",
					width = "double",
					desc = "Enables all spells for ".. class,
					func = function() 
						for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
							Display.db.profile.orderSpells[spellTable.id] = true
						end
						FatCooldowns.RefreshFrameListOptionsAndVariables()
					end
				}
				tab["DisableAllSpells"..class] = {
					order= orderIndex + 0.02,
					type = "execute",
					name = "Disable All Spells",
					width = "double",
					desc = "Enables all spells for ".. class,
					func = function() 
						for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
							Display.db.profile.orderSpells[spellTable.id] = nil
							Display.db.profile.orderSpellPriorities[spellTable.id] = nil
							FatCooldowns.spellInfoTable[spellTable.id].order = 500
						end
						FatCooldowns.RefreshFrameListOptionsAndVariables()
					end
				}
				orderIndex = orderIndex + 1
				for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
					local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(spellTable.id)
					if spellTable.icon ~= nil then icon = spellTable.icon end
					if spellTable.id <= 89999  or spellTable.id == 99038 then
						tab[tostring(spellTable.id)] = {
							type = "toggle",
							name = (spellTable.sortname ~= nil and "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..spellTable.sortname) or (type(spellInfo) == "number" and (tostring(GetSpellInfo(spellInfo)) .. " [#" .. spellInfo .. "]") or "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..spellInfo),
							desc =  string.format("Select %s",(spellTable.sortname or spellInfo)),
							order = orderIndex,
							get = function(info) return Display.db.profile.orderSpells[spellTable.id] end,
							set = function(info, val)
								if val then
									Display.db.profile.orderSpells[spellTable.id] = val
								else
									Display.db.profile.orderSpells[spellTable.id] = nil
									Display.db.profile.orderSpellPriorities[spellTable.id] = nil
									FatCooldowns.spellInfoTable[spellTable.id].order = 500
								end
								FatCooldowns.RefreshFrameListOptionsAndVariables()
							end,
							cmdHidden = true,
						}
						orderIndex = orderIndex + 1
					end
				end
			end
		end
	end	
	options.args.spellOrder.args.spells.args = {
		descr = {
			type = "description",
			name =  "All unselected spells have priority 500 - select higher or lower to move your spell higher or lower in priority list. Higher priority is closer to anchor.",
			width = "full",
			fontSize  = "medium",
			order = 1,
		},
	}
	local orderIndex = 2 
	for spellID, on in pairs(Display.db.profile.orderSpells) do 
		local tempname = nil
		local soname, sorank, soicon, socastTime, sominRange, somaxRange, sospellID = GetSpellInfo(spellID)
		for _, class in ipairs(classes) do
			for spellInfo, spellTable in pairs(FatCooldowns.cooldowns[class]) do
				if spellTable.id == spellID then tempname = spellTable.sortname end
				if spellTable.id == spellID and spellTable.icon ~= nil then soicon = spellTable.icon end
			end
		end
		options.args.spellOrder.args.spells.args[tostring(spellID)] =  {
			type = "range",
			name =  (tempname ~= nil and "|T"..soicon..":24:24:0:0:64:64:6:58:6:58|t "..tempname) or ("|T"..soicon..":24:24:0:0:64:64:6:58:6:58|t "..string.format("%s",tostring(GetSpellInfo(spellID)))),
			desc =  "Set spell's display order priority",
			min = 1, max = 1000, step = 1, bigStep = 10,
			get = function(info) 
				if Display.db.profile.orderSpellPriorities[spellID] then FatCooldowns.spellInfoTable[spellID].order = Display.db.profile.orderSpellPriorities[spellID] end
				return Display.db.profile.orderSpellPriorities[spellID] or 500 
			end,
			set = function(info, val)
				Display.db.profile.orderSpellPriorities[spellID] = val
			end,
			order = 2,
			width = "full",		
			hidden = function()
				if FatCooldowns.cooldowns[soname] ~= nil and FatCooldowns.cooldowns[soname].ExpacHide ~= nil then
					if FatCooldowns.cooldowns[soname].ExpacHide[FatCooldowns.ExPac] then 
						return FatCooldowns.cooldowns[soname].ExpacHide[FatCooldowns.ExPac]
					else
						return false
					end
				end
			end,
		}
		orderIndex = orderIndex + 1
	end
	-- AutoMailer
	table.wipe(TempPlayerList)
	for ro,pl in pairs(Display.db.profile.AutoMailerPlayers) do
		local EnterVal = true
		for checker in pairs(TempPlayerList) do
			if checker == ro then EnterVal = false end
		end
		if EnterVal then table.insert(TempPlayerList, ro) end
	end
	table.sort(TempPlayerList ,function(a, b) return a:lower() < b:lower() end)
	for index, player in pairs(TempPlayerList) do
		local count = 1		
		local RealmCount = 0.01
		local ReamlId = GetRealmName()

		if ReamlId ~= nil and Display.db.profile.Realms[player] == nil then Display.db.profile.Realms[player] = {} end
		if ReamlId ~= nil and Display.db.profile.Realms[player][ReamlId] == nil then Display.db.profile.Realms[player][ReamlId] = false end
		if ReamlId ~= nil and Display.db.profile.AMExtra[player] == nil then Display.db.profile.AMExtra[player] = {[2] = false, [3] = false, [4] = false} end
		if ReamlId ~= nil and Display.db.profile.AMItemType[player] == nil then Display.db.profile.AMItemType[player] = {[1] = true, [2] = true} end

		if not options.args.AutoMailer.args[player] then
			options.args.AutoMailer.args[player] = {
				type = "group",
				name = player,
				desc = "Configure Auto Mail Options for " .. player,
				cmdHidden = true,
				order = count,
				args = {
					AMExtra = {
						type = "multiselect",
						name =  "Auto Mail Un-Soulbound Equipment.",
						desc =  "Select the quality of loot to auto mail.",
						values = {[2] = "|cff1eff00Uncommon|r", [3] = "|cff0070ddRare|r", [4] = "|cffa335eeEpic|r"},
						get = function(info, v)	return Display.db.profile.AMExtra[player][v] end,
						set = function(info, v, v2) Display.db.profile.AMExtra[player][v] = v2 end,
						order = 1,
					},
					AMItemType = {
						type = "multiselect",
						name =  "Auto Mail Item Type Limiter",
						desc =  "Select to allow auto mail of the selected item type.",
						values = {[1] = "Weapon", [2] = "Armor"},
						get = function(info, v)	return Display.db.profile.AMItemType[player][v] end,
						set = function(info, v, v2) Display.db.profile.AMItemType[player][v] = v2 end,
						order = 1.1,
					},
					AMMinIlvl = {
						type = "range",
						name =  "Un-Soulbound Equipment Max Ilvl",
						min = 0, max = 277, step = 1, bigStep = 1,
						desc = "Only mail items if they are below the limit",
						get = function(info) if Display.db.profile.AMMinIlvl[player] == nil then Display.db.profile.AMMinIlvl[player] = 277 end return Display.db.profile.AMMinIlvl[player] end,
						set = function(info, v)	Display.db.profile.AMMinIlvl[player] = v end,
						order = 1.2,
						width = "full"
					},
					AddLootMailerList = {
						type = "input",
						name =  "Add Items To Auto Mail (Drag and Drop or Shift-Click Link Items)",
						get = function(info) return nil end,
						set = function(info, v) 
							if v == nil then return end
							if not v:find("item:[%d]+") then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter a Item Link") end
							local ItemName, ItemLink = GetItemInfo(v)
							local ItemID = select(3,strfind(v, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
							if ItemName ~= nil and ItemLink ~= nil and ItemID ~= nil and not isSoulbound(nil,nil,v) then
								Display.db.profile.LootMailerList[player][ItemID] = ItemID
								if not Display.db.profile.SilentAdd then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Mailer: Added "..v) end
							else 
								FatCooldowns:GetModule("Display"):FCDPrefixPrint("Warning: Failed to add Item "..v..", Please Shift Click the item to link or Drag and drop the Item. Note: you can only add none Soulbound items.")
							end
						end,
						order = 1.5,
						width = "full",
					},
					MailerBagItems = {
						 name = "|TInterface\\Icons\\inv_misc_bag_08:24:24:0:0:64:64:6:58:6:58|t BagItems: Click To Add Item",
						 order = 2,
						 type = "group",
						 inline = true,
						 args = {
							theList = {
							   type = "select",
							   dialogControl = "MSItemSelectList",
							   name = "Anyname",
							   desc = "#ItemTooltip#",
							   width = "full",
							   values = function () return MailerBags(player) end,
							   get = function () return CurrrentSelectedBagList end,			
							   set = function (info, key) RemoveItemMailBagList(player,key) CurrrentSelectedBagList = key end,			
							},
						},
					},
					LootMailerList = {
						 name = "|TInterface\\AddOns\\FatCooldowns\\icons\\Mail:24:24|t MailerItems: Click To Remove Item",
						 order = 3,
						 type = "group",
						 inline = true,
						 args = {
							theList = {
							   type = "select",
							   dialogControl = "MSItemSelectList",
							   name = "Anyname",
							   desc = "#ItemTooltip#",
							   width = "full",
							   values = function () return FillMailList(player) end,
							   get = function () return CurrrentSelectedMailList end,			
							   set = function (info, key) RemoveItemMailList(player,key) CurrrentSelectedMailList = key end,			
							},
						},
					},
				},
			} 
			if Display.db.profile.Realms[player] ~= nil then 
				for RM, Enable in pairs(Display.db.profile.Realms[player]) do
					options.args.AutoMailer.args[player].args[RM] = {					
							type = 'toggle',
							name =  RM,
							desc =  "This will enable the Mailer for this realm",
							get = function(v) return Display.db.profile.Realms[player][RM] end,
							set = function(info, v) Display.db.profile.Realms[player][RM] = v end,
							order = RealmCount,
						}
					RealmCount = RealmCount + 0.01
				end
			end
			count = count + 1
		end
	end
	-- AutoRoller
	for i = 1, 10, 1 do
		if  i <= Display.db.profile.ARCount then
			if not options.args.AutoRoller.args[tostring(i)] then
				if Display.db.profile.ARTable == nil then Display.db.profile.ARTable = {} end

				if Display.db.profile.ARTable[tostring(i)] == nil then
					Display.db.profile.ARTable[tostring(i)] = {
						AREnable = false,
						RType = {
							Need = false,
							DE = false,
							Greed = false,
							Pass = false
						},
						ARUEQ = 1,
						EQ = 1,
						UnableToRType = {
							Need = false,
							DE = false
						},
						ARQuality = {
							[2] = false,
							[3] = false,
							[4] = false
						},
						GroupType = 1,
						IA = 0,
						IAT = 1,
						BagSpace = 0,
						PLevel = 0,
						PlevelType = 1,
						EIL = false,
						ItemList = {},
						ARLeader = 1,
						AREFunctional = 1,
						ARSellPrice = 1,
						VendorPrice = false,
						AucMinPrice = false,
						AucMarketPrice = false,
						AucSeen = 0,
						ARDelay = 0,
						ARILvL = 0,
						ARILvLType = 1,
						ARBind = 1,
						ARBOssItem = 1,
					}
				end
				if Display.db.profile.ARTable[tostring(i)].ARILvL == nil then Display.db.profile.ARTable[tostring(i)].ARILvL = 0 end
				if Display.db.profile.ARTable[tostring(i)].ARILvLType == nil then Display.db.profile.ARTable[tostring(i)].ARILvLType = 1 end
				if Display.db.profile.ARTable[tostring(i)].ARBind == nil then Display.db.profile.ARTable[tostring(i)].ARBind = 1 end 
				if Display.db.profile.ARTable[tostring(i)].ARBOssItem == nil then Display.db.profile.ARTable[tostring(i)].ARBOssItem = 1 end 
				if Display.db.profile.ARTable[tostring(i)].AucSeen == nil then Display.db.profile.ARTable[tostring(i)].AucSeen = 0 end

				options.args.AutoRoller.args[tostring(i)] = {
					type = "group",
					name = function(info,v)
						if next(Display.db.profile.ARNameT) and Display.db.profile.ARNameT[i] ~= nil and Display.db.profile.ARNameT[i] ~= "" and Display.db.profile.ARNameT[i] ~= " " then 
							return "AR "..tostring(i)..": "..Display.db.profile.ARNameT[i] 
						else
							return "AutoRoller "..tostring(i)
						end
					end, 
					desc = "Configure Auto Roller "..tostring(i).." Options",
					cmdHidden = true,
					order = i,
					args = {
						AREnable = {
							type = 'toggle',
							name =  "Enable",
							desc =  "Enable/Disable Auto Roller "..i,
							get = function(v) return Display.db.profile.ARTable[tostring(i)].AREnable end,
							set = function(info, v) Display.db.profile.ARTable[tostring(i)].AREnable = v end,
							order = 1,
						},
						ARName = {
							type = 'input',
							name =  "Name",
							desc =  "Change the name for Auto Roller "..i,
							get = function(v) return Display.db.profile.ARNameT[i] end,
							set = function(info, v) Display.db.profile.ARNameT[i] = v end,
							order = 1.1,
							width = "double",
						},
						MoveUp = {
							type = "execute",
							name = "+",
							desc = "Increase the priority of the current auto roll",
							func = function()
								local CurrentARSettings = Display.db.profile.ARTable[tostring(i)]
								local MoveingARSettings = Display.db.profile.ARTable[tostring(i - 1)]
								local CurrentName = Display.db.profile.ARNameT[i]
								local MoveingName = Display.db.profile.ARNameT[i - 1]

								Display.db.profile.ARTable[tostring(i)] = MoveingARSettings
								Display.db.profile.ARTable[tostring(i - 1)] = CurrentARSettings

								Display.db.profile.ARNameT[i] = MoveingName
								Display.db.profile.ARNameT[i - 1] = CurrentName

								RefreshFrameListOptionsAndVariables() 
								LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
							end,
							disabled = function() if i == 1 then return true else return false end end,
							order = 1.3,
							width = "half",
						},
						MoveDown = {
							type = "execute",
							name = "-",
							desc = "Decrease the priority of the current auto roll",
							func = function() 
								local CurrentARSettings = Display.db.profile.ARTable[tostring(i)]
								local MoveingARSettings = Display.db.profile.ARTable[tostring(i + 1)]
								local CurrentName = Display.db.profile.ARNameT[i]
								local MoveingName = Display.db.profile.ARNameT[i + 1]

								Display.db.profile.ARTable[tostring(i)] = MoveingARSettings
								Display.db.profile.ARTable[tostring(i + 1)] = CurrentARSettings

								Display.db.profile.ARNameT[i] = MoveingName
								Display.db.profile.ARNameT[i + 1] = CurrentName

								RefreshFrameListOptionsAndVariables() 
								LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
							end,
							disabled = function() if i == 10 or i == Display.db.profile.ARCount then return true else return false end end,
							order = 1.3,
							width = "half",
						},
						RType = {
							type = "multiselect",
							name =  "Auto Roll Type",
							desc = "Select which Auto Roll's to perform.\n\nOrder: Need > DE > Greed > Pass.",
							values = {[1] = "Need", [2] = "DE", [3] = "Greed", [4] = "Pass"},
							get = function(info, v) local TempV3 = {[1] = "Need", [2] = "DE", [3] = "Greed", [4] = "Pass"} return Display.db.profile.ARTable[tostring(i)].RType[TempV3[v]] end,
							set = function(info, v, v2) local TempV3 = {[1] = "Need", [2] = "DE", [3] = "Greed", [4] = "Pass"} Display.db.profile.ARTable[tostring(i)].RType[TempV3[v]] = v2 end,
							order = 2,
						},
						ARODE = {
							type = 'header',
							name =  "Disenchant Options",
							order = 2.11,
							width = "full",
							hidden = function()
								local Val = true
								if select(4, GetAddOnInfo("Auctionator")) == 1 then Val = false end
								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then Val = false end
								if not Display.db.profile.ARTable[tostring(i)].RType["DE"] then Val = true end
								return Val
							end,
						},
						VendorPrice = {
							type = 'toggle',
							name =  "Disenchant Value > Auctioneer Vendor Price",
							desc =  "Enable/Disable if the Disenchant Value is higher than Vendor Price",
							get = function(v) return Display.db.profile.ARTable[tostring(i)].VendorPrice end,
							set = function(info, v) Display.db.profile.ARTable[tostring(i)].VendorPrice = v end,
							order = 2.12,
							width = "double",
							hidden = function()
								local Val = true
								if select(4, GetAddOnInfo("Auctionator")) == 1 then Val = false end
								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then Val = false end
								if not Display.db.profile.ARTable[tostring(i)].RType["DE"] then Val = true end
								return Val
							end,
						},
						AucMinPrice = {
							type = 'toggle',
							name =  "Disenchant Value > Auctioneer Min Price",
							desc =  "Enable/Disable if the Disenchant Value is higher than Auctioneer Min Price\n\nNote: if no min price it will check the market price",
							get = function(v) return Display.db.profile.ARTable[tostring(i)].AucMinPrice end,
							set = function(info, v) Display.db.profile.ARTable[tostring(i)].AucMinPrice = v end,
							order = 2.13,
							width = "double",
							hidden = function()
								local Val = true
								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then Val = false end
								if not Display.db.profile.ARTable[tostring(i)].RType["DE"] then Val = true end
								return Val
							end,
						},
						AucMarketPrice = {
							type = 'toggle',
							name =  "Disenchant Value > Auctioneer Market Price",
							desc =  "Enable/Disable if the Disenchant Value > Auctioneer Market Price",
							get = function(v) return Display.db.profile.ARTable[tostring(i)].AucMarketPrice end,
							set = function(info, v) Display.db.profile.ARTable[tostring(i)].AucMarketPrice = v end,
							order = 2.14,
							width = "double",
							hidden = function()
								local Val = true
								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then Val = false end
								if not Display.db.profile.ARTable[tostring(i)].RType["DE"] then Val = true end
								return Val
							end,
						},
						AucSeen = {
							type = "range",
							name =  "Seen Count",
							min = 0, max = 100, step = 1, bigStep = 1,
							desc = "Items below the seen count will not be price checked with Disenchant Value > Auctioneer Min/Market Price..",
							get = function(info) return Display.db.profile.ARTable[tostring(i)].AucSeen end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].AucSeen = v end,
							order = 2.15,
							width = "double",
							hidden = function()
								local Val = true
								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then Val = false end
								if not Display.db.profile.ARTable[tostring(i)].RType["DE"] then Val = true end
								return Val
							end,
						},
						ARO = {
							type = 'header',
							name =  "Optional Options",
							order = 2.5,
							width = "full",
						},
						ARQuality = {
							type = "multiselect",
							name =  "Loot Quality",
							desc = "Auto Roll on selected quality itmes",
							values = {[2] = "|cff1eff00Uncommon|r", [3] = "|cff0070ddRare|r", [4] = "|cffa335eeEpic|r"},
							get = function(info, v) return Display.db.profile.ARTable[tostring(i)].ARQuality[v] end,
							set = function(info, v, v2)	Display.db.profile.ARTable[tostring(i)].ARQuality[v] = v2 end,
							order = 3,
						},
						ARGroup = {
							type = "select",
							name =  "Group Type",
							desc = "Auto Roll when in selected group type",
							values = { "Both", "Party", "Raid"},
							get = function(info) return Display.db.profile.ARTable[tostring(i)].GroupType end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].GroupType = v	end,
							order = 4,
						},
						ARLeader = {
							type = "select",
							name =  "Leader",
							desc = "checks if you are the leader of the group",
							values = {"Both", "Yes", "No"},
							get = function(info, v) return Display.db.profile.ARTable[tostring(i)].ARLeader end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].ARLeader = v end,
							order = 4.1,
						},
						AREquipment = {
							type = "select",
							name =  "Item: Equipment",
							desc = "Checks if the item is an Equipment.",
							values = {"Both", "Yes", "No"},
							get = function(info, v) return Display.db.profile.ARTable[tostring(i)].EQ end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].EQ = v end,
							order = 4.5,
						},
						ARUEQ = {
							type = "select",
							name =  "Equipment: Useable",
							desc = "checks if the Equipment is Useable.\n\nE.G. Plate on rogues",
							values = {"Both", "Yes", "No"},
							get = function(info, v) return Display.db.profile.ARTable[tostring(i)].ARUEQ end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].ARUEQ = v end,
							order = 4.6,
						},
						AREFunctional = {
							type = "select",
							name =  "Equipment: Functional",
							desc = "checks if the item is functional for use\n\nSpellpower on warrior",
							values = {"Both", "Yes", "No"},
							get = function(info, v) return Display.db.profile.ARTable[tostring(i)].AREFunctional end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].AREFunctional = v end,
							order = 4.7,
						},
						ARSellPrice = {
							type = "select",
							name =  "Item Sell Price",
							desc = "checks if the item has a sell price",
							values = {"Both", "Yes", "No"},
							get = function(info, v) return Display.db.profile.ARTable[tostring(i)].ARSellPrice end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].ARSellPrice = v end,
							order = 4.7,
						},
						BagSpace = {
							type = "range",
							name =  "|TInterface\\Icons\\inv_misc_bag_08:24:24:0:0:64:64:6:58:6:58|t Free Bag Space",
							min = 0, max = 80, step = 1, bigStep = 1,
							desc = "Auto Roll when your free Bag Space is above the set amount, 0 = disabled.",
							get = function(info) return Display.db.profile.ARTable[tostring(i)].BagSpace end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].BagSpace = v end,
							order = 5,
						},
						ARDelay = {
							type = "range",
							name =  "Delay Roll",
							min = 0, max = 30, step = 1, bigStep = 1,
							desc = "Auto Roll after the set number of seconds, 0 = disabled.",
							get = function(info) return Display.db.profile.ARTable[tostring(i)].ARDelay end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].ARDelay = v end,
							order = 5.3,
						}, 
						ARILvL = {
							type = "range",
							name =  "Item Ilvl",
							min = 0, max = 277, step = 1, bigStep = 1,
							desc = "Auto Roll if the item ilvl is above/below the set value, 0 = disabled.",
							get = function(info) return Display.db.profile.ARTable[tostring(i)].ARILvL end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].ARILvL = v end,
							order = 5.4,
						},
						ARILvLType = {
							type = "select",
							name =  "Item Ilvl Type",
							desc = "sets the above or below for Item Ilvl limit",
							values = { "Below", "Above"},
							get = function(info) return Display.db.profile.ARTable[tostring(i)].ARILvLType end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].ARILvLType = v end,
							order = 5.45,
						}, 
						ARBindType = {
							type = "select",
							name =  "Bind",
							desc = "sets if AR should roll if the item is BOP or not",
							values = { "Both", "Yes - BOP Only", "No - BOE Only"},
							get = function(info) return Display.db.profile.ARTable[tostring(i)].ARBind end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].ARBind = v end,
							order = 5.48,
						},
						ARBOssItem = {
							type = "select",
							name =  "Boss Items",
							desc = "sets if AR should roll if the item is a boss item or no",
							values = { "Both", "Yes - Boss items Only", "No - not Boss items Only"},
							get = function(info) return Display.db.profile.ARTable[tostring(i)].ARBOssItem end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].ARBOssItem = v end,
							order = 5.49,
						},
						UnableToRType = {
							type = "multiselect",
							name =  "Unable To Roll Type",
							desc = "Only roll on the item if the selected option is unable to be rolled on.\n\nE.G. Need is ticked and your unable to roll need on the item",
							values = {[1] = "Need", [2] = "DE"},
							get = function(info, v) local TempV3 = {[1] = "Need", [2] = "DE"}  return Display.db.profile.ARTable[tostring(i)].UnableToRType[TempV3[v]] end,
							set = function(info, v, v2) local TempV3 = {[1] = "Need", [2] = "DE"} 	Display.db.profile.ARTable[tostring(i)].UnableToRType[TempV3[v]] = v2 end,
							order = 5.5,
						},
						PLevel = {
							type = "range",
							name =  "Player's Level",
							min = 0, max = 80, step = 1, bigStep = 1,
							desc = "Auto Roll when your level is above/below the set amount, 0 = disabled.",
							get = function(info) return Display.db.profile.ARTable[tostring(i)].PLevel end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].PLevel = v end,
							order = 6,
						},
						PlevelType = {
							type = "select",
							name =  "Player Level Type",
							desc = "Sets above or below for players level setting.",
							values = { "Below", "Above"},
							get = function(info) return Display.db.profile.ARTable[tostring(i)].PlevelType end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].PlevelType = v end,
							order = 7,
						},
						ILvlAvg = {
							type = "range",
							name =  "Avg Ilvl Limit",
							min = 0, max = 277, step = 1, bigStep = 1,
							desc = function() return "Only Auto Roll when your Avg ILvl is above/below the set amount, 0 = disabled.\n\nCurrent ILvl: "..FatCooldowns:AvgIlvl() end,
							get = function(info) return Display.db.profile.ARTable[tostring(i)].IA end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].IA = v end,
							order = 8,
						},
						ILvlAvgType = {
							type = "select",
							name =  "Avg Ilvl Type",
							desc = "sets the above or below for Avg Ilvl limit",
							values = { "Below", "Above"},
							get = function(info) return Display.db.profile.ARTable[tostring(i)].IAT end,
							set = function(info, v)	Display.db.profile.ARTable[tostring(i)].IAT = v end,
							order = 9,
						},
						AREIL = {
							type = 'toggle',
							name =  "Enable Auto Roller Item List",
							desc =  "Enable/Disable the item list",
							get = function(v) return Display.db.profile.ARTable[tostring(i)].EIL end,
							set = function(info, v) Display.db.profile.ARTable[tostring(i)].EIL = v end,
							order = 9.5,
							width = "full",
						},
						AddLootRollList = {
							type = "input",
							name =  "Auto Roller Item List (Drag and Drop or Shift-Click Link Items)",
							desc = "Auto Roll only if item is listed below",
							get = function(info) return nil end,
							set = function(info, v) 
								if v == nil then return end
								if not v:find("item:[%d]+") then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter a Item Link") end
								local ItemID = select(3,strfind(v, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
								if ItemID ~= nil then
									Display.db.profile.ARTable[tostring(i)].ItemList[ItemID] = ItemID
								else 
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("Warning: Failed to add Item "..v..", Please Shift Click the item to link or Drag and drop the Item.")
								end
							end,
							order = 10,
							width = "full",
						},
						ARItemList = {
							 name = "Auto Roller Item List: Click To Remove Item",
							 order = 11,
							 type = "group",
							 inline = true,
							 args = {
								theList = {
								   type = "select",
								   dialogControl = "MSItemSelectList",
								   name = "Anyname",
								   desc = "#ItemTooltip#",
								   width = "full",
								   values = function () return FillARList(i) end,
								   get = function () return CurrrentSelectedARItem end,			
								   set = function (info, key) RemoveItemARList(key,i) CurrrentSelectedARItem = key end,			
								},
							 },
		  				},
					}
				}
			end
		else 
			options.args.AutoRoller.args[tostring(i)] = nil
		end
	end
	-- ignore and friends
	local IGCount = 5
	local Realm = GetRealmName()
	local Faction = UnitFactionGroup("player")
	if Display.db.profile.IshareList ~= nil then
		if Display.db.profile.IshareList[Realm] ~= nil then
			if Display.db.profile.IshareList[Realm][Faction] ~= nil then
				local TempIgnoreTable = {}

				for Player, PlayerTable in pairs(Display.db.profile.IshareList[Realm][Faction]) do
					TempIgnoreTable[#TempIgnoreTable + 1] = PlayerTable.name
					IGCount = IGCount + 1
				end
				for Player, PlayerTable in pairs(Display.db.profile.RIshareList[Realm][Faction]) do
					TempIgnoreTable[#TempIgnoreTable + 1] = Player
					IGCount = IGCount + 1
				end
				table.sort( TempIgnoreTable, function(a, b) return a:lower() < b:lower() end)

				for i = 1, IGCount, 1 do
					if TempIgnoreTable[i] ~= nil and Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]] and not Display.db.profile.RIshareList[Realm][Faction][TempIgnoreTable[i]] then
						local Faction = UnitFactionGroup("player")
						if not options.args.other.args.OT3.args.IshareList.args[tostring(TempIgnoreTable[i])] and Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].faction == Faction  then
							local weekday, month, day, year = CalendarGetDate()
							local FileDate = ((Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].month * 31) + Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].date + (Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].year * 365))
							local CurrentDate = ((month * 31) + day + (year * 365))
							options.args.other.args.OT3.args.IshareList.args[tostring(TempIgnoreTable[i])] = {
								type = 'group',
								name =  TempIgnoreTable[i],
								desc =  "Ignore Options for "..TempIgnoreTable[i],
								order = i + 10,
								args = {
									ILDate = {
										type = "description",
										name =  "Date Added: "..Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].date.."/"..Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].month.."/"..Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].year.."\nTotal Days: "..tostring(CurrentDate - FileDate).."\n",
										width = "full",
										fontSize  = "medium",
										order = 1,
									},
									ILNotes = {
										type = "input",
										name =  "Note's",
										get = function(info) if Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].note == nil then FatCooldowns.RefreshFrameListOptionsAndVariables() return "" else return Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].note end end,
										set = function(info, v) Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].note = v end,
										order = 2,
										multiline  = 6,
										width = "full",
									},
									ILWarn = {
										type = 'toggle',
										name =  "Notify When in Group",
										desc =  "Notify you when your in a group with the person",
										get = function(v) return Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].warn end,
										set = function(info, v) Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].warn = v end,
										order = 2,
										width = "full",
									},
									ILTimerRemove = {
										type = "select",
										name =  "Removal Timer",
										desc = "Set a Timer to remove the person from your ignore list.\n\nNote: The timer is based from the date the person was added.",
										values = {"Never", "1 Day", "1 Week", "1 Month", "1 Year"},
										get = function(info) return Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].remove end,
										set = function(info, v) Display.db.profile.IshareList[Realm][Faction][TempIgnoreTable[i]].remove = v end,
										order = 3,
									},
									ILRemove = {
										type = "execute",
										name =  "Remove",
										desc =  "Remove the person from the ignore list.",
										order = 4,
										func = function() Display.db.profile.RIshareList[Realm][Faction][TempIgnoreTable[i]] = TempIgnoreTable[i] FatCooldowns.RefreshFrameListOptionsAndVariables() DelIgnore(TempIgnoreTable[i]) end,
									},
								},
							}
						end
					else
						options.args.other.args.OT3.args.IshareList.args[tostring(TempIgnoreTable[i])] = nil
					end
				end
			end
		end
	end
	local FGCount = 5
	local Realm = GetRealmName()
	local Faction = UnitFactionGroup("player")
	if Display.db.profile.FshareList ~= nil then
		if Display.db.profile.FshareList[Realm] ~= nil then
			if Display.db.profile.FshareList[Realm][Faction] ~= nil then
				local TempFriendTable = {}

				for Player, PlayerTable in pairs(Display.db.profile.FshareList[Realm][Faction]) do
					TempFriendTable[#TempFriendTable + 1] = PlayerTable.name
					FGCount = FGCount + 1
				end
				for Player, PlayerTable in pairs(Display.db.profile.RFshareList[Realm][Faction]) do
					TempFriendTable[#TempFriendTable + 1] = Player
					FGCount = FGCount + 1
				end
				table.sort( TempFriendTable, function(a, b) return a:lower() < b:lower() end)

				for i = 1, FGCount, 1 do
					if TempFriendTable[i] ~= nil and Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]] and not Display.db.profile.RFshareList[Realm][Faction][TempFriendTable[i]] then 
						local Faction = UnitFactionGroup("player")
						if not options.args.other.args.OT3.args.FshareList.args[tostring(TempFriendTable[i])] and Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].faction == Faction  then
							local weekday, month, day, year = CalendarGetDate()
							local FileDate = ((Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].month * 31) + Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].date + (Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].year * 365))
							local CurrentDate = ((month * 31) + day + (year * 365))
							options.args.other.args.OT3.args.FshareList.args[tostring(TempFriendTable[i])] = {
								type = 'group',
								name =  TempFriendTable[i],
								desc =  "Friend Options for "..TempFriendTable[i],
								order = i + 10,
								args = {
									FLDate = {
										type = "description",
										name =  "Date Added: "..Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].date.."/"..Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].month.."/"..Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].year.."\nTotal Days: "..tostring(CurrentDate - FileDate).."\n",
										width = "full",
										fontSize  = "medium",
										order = 1,
									},
									FLNotes = {
										type = "input",
										name =  "Note's",
										get = function(info) return Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].note end,
										set = function(info, v) Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].note = v end,
										order = 2,
										multiline  = 6,
										width = "full",
									},
									FLWarn = {
										type = 'toggle',
										name =  "Notify When in Group",
										desc =  "Notify you when your in a group with the person",
										get = function(v) return Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].warn end,
										set = function(info, v) Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].warn = v end,
										order = 2,
										width = "full",
									},
									FLTimerRemove = {
										type = "select",
										name =  "Removal Timer",
										desc = "Set a Timer to remove the person from your friends list.\n\nNote: The timer is based from the date the person was added.",
										values = {"Never", "1 Day", "1 Week", "1 Month", "1 Year"},
										get = function(info) return Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].remove end,
										set = function(info, v) Display.db.profile.FshareList[Realm][Faction][TempFriendTable[i]].remove = v end,
										order = 3,
									},
									FLRemove = {
										type = "execute",
										name =  "Remove",
										desc =  "Remove the person from the friends list.",
										order = 4,
										func = function() Display.db.profile.RFshareList[Realm][Faction][TempFriendTable[i]] = TempFriendTable[i] FatCooldowns.RefreshFrameListOptionsAndVariables() RemoveFriend(TempFriendTable[i])  end,
									},
								},
							}
						end
					else 
						options.args.other.args.OT3.args.FshareList.args[tostring(TempFriendTable[i])] = nil
					end
				end
			end
		end
	end 
	if Display.db.profile.FShare or Display.db.profile.IShare then Display:UpdateConfig() end
	--keepicons
	for i = 1, 20, 1 do
		if  i <= Display.db.profile.KeepIcon1TargetNames then
			if not options.args.RaidLeader.args.OT1.args[tostring(i)] then
				options.args.RaidLeader.args.OT1.args[tostring(i)] = {					
					type = "input",
					name =  "Targets Name",
					desc =  "Place the icon on the target if the targets name matchs the set name.",
					get = function(v) return Display.db.profile.KeepIcon1TargetNamesSet[i] end,
					set = function(info, v) Display.db.profile.KeepIcon1TargetNamesSet[i] = v end,
					hidden = function() if not Display.db.profile.KeepIcon1Toggle or Display.db.profile.KeepIcon1 == nil or Display.db.profile.KeepIcon1 ~= "Target" then return true else return false end end,
					order = 1.930500 + i,
					width = "full",
				}
			end
		else 
			options.args.RaidLeader.args.OT1.args[tostring(i)] = nil
		end
	end
	for i = 1, 20, 1 do
		if  i <= Display.db.profile.KeepIcon2TargetNames then
			if not options.args.RaidLeader.args.OT1.args[tostring(i)] then
				options.args.RaidLeader.args.OT1.args[tostring(i)] = {					
					type = "input",
					name =  "Targets Name",
					desc =  "Place the icon on the target if the targets name matchs the set name.",
					get = function(v) return Display.db.profile.KeepIcon2TargetNamesSet[i] end,
					set = function(info, v) Display.db.profile.KeepIcon2TargetNamesSet[i] = v end,
					hidden = function() if not Display.db.profile.KeepIcon2Toggle or Display.db.profile.KeepIcon2 == nil or Display.db.profile.KeepIcon2 ~= "Target" then return true else return false end end,
					order = 1.960500 + i,
					width = "full",
				}
			end
		else
			options.args.RaidLeader.args.OT1.args[tostring(i)] = nil
		end
	end
	-- keep roles Messanger
	if Display.db.profile.PlayerRole and FatCooldowns.PlayersRole ~= nil and next(FatCooldowns.PlayersRole) then
		local PlayerRoleIndex = 1
		local classes = {["Death Knight"] = "DEATHKNIGHT", ["Druid"] = "DRUID", ["Hunter"] = "HUNTER", ["Mage"] = "MAGE", ["Paladin"] = "PALADIN", ["Priest"] = "PRIEST", ["Rogue"] = "ROGUE", ["Shaman"] = "SHAMAN", ["Warlock"] = "WARLOCK", ["Warrior"] = "WARRIOR"}
		local OrderClass = {["Death Knight"] = 1000, ["Druid"] = 2000, ["Hunter"] = 3000, ["Mage"] = 4000, ["Paladin"] = 5000, ["Priest"] = 6000, ["Rogue"] = 7000, ["Shaman"] = 8000, ["Warlock"] = 9000, ["Warrior"] = 10000}
		local TempRoleTable = {}
		for PlayerName, PlayerTable in pairs(FatCooldowns.PlayersRole) do
			TempRoleTable[#TempRoleTable + 1] = PlayerName
			PlayerRoleIndex = PlayerRoleIndex + 1
		end
		table.sort(TempRoleTable, function(a, b) return a:lower() < b:lower() end)
		
		for i = 1, PlayerRoleIndex, 1 do
			if TempRoleTable[i] ~= nil then
				if not options.args.Messanger.args.OT2.args[TempRoleTable[i].."Role"] then
					options.args.Messanger.args.OT2.args[TempRoleTable[i].."Role"] = {
						type = "select",
						name =  FCDColorName3(classes[L[FatCooldowns.PlayersRole[TempRoleTable[i]].Class]], TempRoleTable[i]),
						desc = "Select the players Role.",
						values = {"Any", "Tank", "Healer", "DPS", "Tank/Healer", "Tank/DPS", "Healer/DPS"},
						get = function(info) return FatCooldowns.PlayersRole[TempRoleTable[i]].Role end,
						set = function(info, v) FatCooldowns.PlayersRole[TempRoleTable[i]].Role = v end,
						order = 1 + i + OrderClass[L[FatCooldowns.PlayersRole[TempRoleTable[i]].Class]],
					}
				end
			end
		end
	end
	-- raid log
	if Display.db.profile.RMEnableRL and Display.db.profile.RMRaidLog ~= nil and next(Display.db.profile.RMRaidLog) then

		local RMLCount = 0
		local RMLTable = Display.db.profile.RMRaidLog
		local RMLTable2 = {}
		table.sort(RMLTable, function(a,b) return a["OG"] > b["OG"] end)
		if Display.db.profile.RMRaidCount > 50 then Display.db.profile.RMRaidCount = 50 end
		for RaidLogIndex, RaidLogTable in pairs(RMLTable) do		
			if RMLCount <= Display.db.profile.RMRaidCount then
				table.insert(RMLTable2, RaidLogTable)
				RMLCount = RMLCount + 1
			end
		end
		Display.db.profile.RMRaidLog = RMLTable2

		if RLSelect then 
			local TableCount = 1
			for RaidLogIndex, RaidLogTable in pairs(Display.db.profile.RMRaidLog) do
				local RealName = "Leader - "..(RaidLogTable.Leader.class and RaidLogTable.Leader.name and FCDColorName3(RaidLogTable.Leader.class, RaidLogTable.Leader.name) or "Unknown")
					.." - Date: "..RaidLogTable.FTime.day.."/"..RaidLogTable.FTime.month.."/"..RaidLogTable.FTime.year.." Time: "..RaidLogTable.FTime.hour..":"..RaidLogTable.FTime.min
					.." You: "..(RaidLogTable.You.class and RaidLogTable.You.name and FCDColorName3(RaidLogTable.You.class, RaidLogTable.You.name) or "Unknown")
				RSLTable[TableCount] = {name = RealName, OG =  RaidLogTable.OG, oldname = RaidLogTable.Leader.name}
				TableCount = TableCount + 1
			end
			table.sort(RSLTable, function(a,b) return a["OG"] > b["OG"] end)
			for Index, Val in pairs(RSLTable) do
				ValTable[Index] = Val.name
			end

			local RealName = ValTable[RLSelect]
			local TempIndex = nil
			for Index, Val in pairs(RSLTable) do
				if Val.name == RealName then TempIndex = Index end
			end
			local PlayersAdded = false
			local PlayersAddedA = false

			options.args.RaidLeader.args.OT6.args.RaidLogTab.args.RaidPlayers = {
				type = "group",
				name = "Players",
				desc = "Configure Players Options",
				order = 102,
				args = {},
			}

			for RaidLogIndex, RaidLogTable in pairs(Display.db.profile.RMRaidLog) do
				if RSLTable[TempIndex].OG == RaidLogTable.OG then
					local OrderCount = {}
					local OrderCount2 = {}
					for PlayerIndex, PlayerTable in pairs(RaidLogTable.Members) do
						table.insert(OrderCount, PlayerTable.name)
					end
					table.sort(OrderCount, function(a, b) return a:lower() < b:lower() end)
					for PlayerIndex, PlayerName in pairs(OrderCount) do
						OrderCount2[PlayerName] = PlayerIndex
					end
					for PlayerIndex, PlayerTable in pairs(RaidLogTable.Members) do
						if not options.args.RaidLeader.args.OT6.args.RaidLogTab.args.RaidPlayers.args[PlayerTable.name] then
							local OrderI = OrderCount2[PlayerTable.name]
							if PlayerTable.rank ~= nil and PlayerTable.rank == 2 then PlayersAdded = true OrderI = 0.001 elseif PlayerTable.rank ~= nil and PlayerTable.rank == 1 then PlayersAddedA = true OrderI = 0.01 end
							options.args.RaidLeader.args.OT6.args.RaidLogTab.args.RaidPlayers.args[PlayerTable.name] = {
								type = "execute",
								name =  FCDColorName3(PlayerTable.class, PlayerTable.name),
								desc = "Click to Invite Player",
								hidden = function() if RaidLogTable.Members[RaidLogTable.Leader.name] ~= nil then return false else return true end end,
								func = function()
									if UnitInRaid("player") and (IsRaidLeader() or IsRaidOfficer()) then
										InviteUnit(OrderCount[i])
									elseif not UnitInRaid("player") then
										InviteUnit(OrderCount[i])
									end
								end,
								order = OrderI,
							}
						end
					end
					if PlayersAdded then
						options.args.RaidLeader.args.OT6.args.RaidLogTab.args.RaidPlayers.args["Leader"] = {
							type = "header",
							name =  "Raid Leader",
							order = 0.0001,
							width = "full", 
						}
						options.args.RaidLeader.args.OT6.args.RaidLogTab.args.RaidPlayers.args["Members"] = {
							type = "header",
							name =  "Members",
							order = 0.1,
							width = "full", 
						}
					end		
					if PlayersAddedA then
						options.args.RaidLeader.args.OT6.args.RaidLogTab.args.RaidPlayers.args["Assist"] = {
							type = "header",
							name =  "Assist",
							order = 0.009,
							width = "full", 
						}
					end	
				end
			end
		end
	end
	-- Dispeller
	options.args.RaidLeader.args.OT7.args = {
		descr = {
			type = "description",
			name =  "Dispeller allows you to report in chat when someone dispels a debuff and how long the debuff was on that person.",
			width = "full",
			fontSize  = "medium",
			order = 1,
		},
		DispellerEnable = {
			type = "toggle",
			name =  "Enable",
			desc =  "Enables Dispeller.",
			get = function(info) return Display.db.profile.DispellerEnable end,
			set = function(info, v)	Display.db.profile.DispellerEnable = v end,
			order = 2,
		},
		DispellerMDEnable = {
			type = "toggle",
			name =  "Mass Dispel Report",
			desc =  "Enables Mass Dispel.",
			get = function(info) return Display.db.profile.DispellerMDEnable end,
			set = function(info, v)	Display.db.profile.DispellerMDEnable = v end,
			order = 2.1,
		},
		DispellerAdd = {
			type = "input",
			name =  "Add Spell: (Drag and Drop, Shift-Click Link or enter Spell ID)",
			get = function(info) return nil end,
			set = function(info, v) 
				if v == nil then return end
				if v:find("%d+") and not v:find("%a+") then v = "spell:"..v end
				if not v:find("spell:[%d]+") then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter a Spell Link or spell id") return end
				local spellID = nil
				if v:find("^spell:[%d]+") then spellID = select(3,strfind(v, "^spell:(%d+)"))
				elseif v:find(".+|Hspell:[%d]+.+") then spellID = select(3,strfind(v, ".+|Hspell:(%d+)")) end 
				local name = GetSpellInfo(spellID)
				if name ~= nil and spellID ~= nil then
					Display.db.profile.DispellerList[spellID] = Display.db.profile.DispellerList[spellID] or {}
					Display.db.profile.DispellerList[spellID]["enable"] =  Display.db.profile.DispellerList[spellID]["enable"] or true
					Display.db.profile.DispellerList[spellID]["instance"] = Display.db.profile.DispellerList[spellID]["instance"] or 1
					Display.db.profile.DispellerList[spellID]["boss"] = Display.db.profile.DispellerList[spellID]["boss"] or 1
					Display.db.profile.DispellerList[spellID]["chat"] = Display.db.profile.DispellerList[spellID]["chat"] or 5
					Display.db.profile.DispellerList[spellID]["death"] = Display.db.profile.DispellerList[spellID]["death"] or false
					Display.db.profile.DispellerList[spellID]["timeout"] = Display.db.profile.DispellerList[spellID]["timeout"] or false

					Display.db.profile.DispellerList[spellID]["applied"] = Display.db.profile.DispellerList[spellID]["applied"] or false
					Display.db.profile.DispellerList[spellID]["self"] = Display.db.profile.DispellerList[spellID]["self"] or true
					Display.db.profile.DispellerList[spellID]["chat2"] = Display.db.profile.DispellerList[spellID]["chat2"] or 5
					Display.db.profile.DispellerList[spellID]["instance2"] = Display.db.profile.DispellerList[spellID]["instance2"] or 1
					Display.db.profile.DispellerList[spellID]["boss2"] = Display.db.profile.DispellerList[spellID]["boss2"] or 1

					FatCooldowns.RefreshFrameListOptionsAndVariables()
					Display:UpdateConfig()
				else 
					FatCooldowns:GetModule("Display"):FCDPrefixPrint("Warning: Failed to add spell "..v..", Please Shift Click the spell to link, Drag and drop the spell or enter the spell id.")
				end
			end,
			order = 3,
			width = "double",
		}
	}
	local DSpellsIndex = {}
	local DTableNum = 1 
	for DSpellID, DSpellTable in pairs(Display.db.profile.DispellerList) do
		if Display.db.profile.DispellerList[DSpellID]["applied"] == nil then Display.db.profile.DispellerList[DSpellID]["applied"] = false end
		if Display.db.profile.DispellerList[DSpellID]["self"] == nil then Display.db.profile.DispellerList[DSpellID]["self"] = false end
		if Display.db.profile.DispellerList[DSpellID]["chat2"] == nil then Display.db.profile.DispellerList[DSpellID]["chat2"] = 5 end
		if Display.db.profile.DispellerList[DSpellID]["instance2"] == nil then Display.db.profile.DispellerList[DSpellID]["instance2"] = 1 end
		if Display.db.profile.DispellerList[DSpellID]["boss2"] == nil then Display.db.profile.DispellerList[DSpellID]["boss2"] = 1 end
	end
	for DSpellID, DSpellTable in pairs(Display.db.profile.DispellerList) do
		local Dname = GetSpellInfo(DSpellID)
		DSpellsIndex[DTableNum] = {name = Dname, DSpellID = DSpellID,  DSpellTable = DSpellTable}
		DTableNum = DTableNum + 1
	end		
	table.sort(DSpellsIndex, function(a,b) return a["name"] < b["name"] end)
	for DSpellIndex, DSpellTable2 in pairs(DSpellsIndex) do
		options.args.RaidLeader.args.OT7.args[DSpellTable2["DSpellID"]] = {
			type = "group",
			name = function()
				if Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["enable"] and Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["applied"] then
					local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(DSpellTable2["DSpellID"])
					return
					"|T"..icon..":24:24:0:0:64:64:6:58:6:58|t |cffFF7C0A"..DSpellTable2["name"].."|r"
				elseif Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["applied"] and not Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["enable"] then
					local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(DSpellTable2["DSpellID"])
					return
					"|T"..icon..":24:24:0:0:64:64:6:58:6:58|t |cffFFF468"..DSpellTable2["name"].."|r"
				elseif Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["enable"] then
					local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(DSpellTable2["DSpellID"])
					return
					"|T"..icon..":24:24:0:0:64:64:6:58:6:58|t |cff1eff00"..DSpellTable2["name"].."|r"
				else
					local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(DSpellTable2["DSpellID"])
					return
					"|T"..icon..":24:24:0:0:64:64:6:58:6:58|t |cffC41E3A"..DSpellTable2["name"].."|r"
				end
			end,
			desc = "Configure "..DSpellTable2["name"].." Options",
			order = DSpellIndex,
			args = {
				droptarget = {
					type = "input",
					name = function()
						local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(DSpellTable2["DSpellID"])
						return name
					end,
					disabled = function() return true end,
					dialogControl = "MSDropTarget",
					desc = "#ItemToolTip#",
					get = function() return "spell:"..DSpellTable2["DSpellID"] end,
					order = 0.5,
					width = "double",
				},
				Remove = {
					type = "execute",
					name =  "Remove",
					desc = "Removes the current spell from the report list",
					func = function() Display.db.profile.DispellerList[DSpellTable2["DSpellID"]] = nil FatCooldowns.RefreshFrameListOptionsAndVariables() Display:UpdateConfig() end,
					order = 1,
				},
				Removal = {
					type = "header",
					name =  "Removal",
					width = "full",
					order = 2.1,
				},
				Enable = {
					type = "toggle",
					name =  "Enable",
					desc =  "Enables "..DSpellTable2["name"].." reporter.",
					get = function(info) return Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["enable"] end,
					set = function(info, v)	Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["enable"] = v end,
					order = 2.5,
					width = "full",
				},
				Instance = {
					type = "select",
					name =  "Instance Limiter",
					values = FatCooldowns.Instances,
					desc = "Limits the reporter to only report when you inside the selected instance",
					get = function(v) return Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["instance"] end,
					set = function(info, v) Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["instance"] = v end,
					order = 3,
				},
				Boss = {
					type = "select",
					name =  "Boss Limiter",
					values = FatCooldowns.Boss,
					desc = "Limits the reporter to only report when you are fighting the selected boss.\n\nNote: The selected boss will need to be showen in boss frame 1",
					get = function(v) return Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["boss"] end,
					set = function(info, v) Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["boss"] = v end,
					order = 3,
				},
				Chat = {
					type = "select",
					name =  "Chat",
					values = {[1] = "Self", [2] = "Say", [3] = "Yell", [4] = "Party", [5] = "Raid"},
					desc = "Limits the reporter to only report when you inside the selected instance",
					get = function(v) return Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["chat"] end,
					set = function(info, v) Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["chat"] = v end,
					order = 4,
				},
				Death = {
					type = "toggle",
					name =  "Death",
					desc =  "Reports when the person dies with debuff "..DSpellTable2["name"].." reporter.",
					get = function(info) return Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["death"] end,
					set = function(info, v)	Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["death"] = v end,
					order = 5,
				},
				Timeout = {
					type = "toggle",
					name =  "Timeout/No Dispel",
					desc =  "Reports when there is no dispel/debuff runs out "..DSpellTable2["name"].." reporter.",
					get = function(info) return Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["timeout"] end,
					set = function(info, v)	Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["timeout"] = v end,
					order = 6,
				},
				Applied = {
					type = "header",
					name =  "Applied",
					width = "full",
					order = 6.1,
				},
				EnableR = {
					type = "toggle",
					name =  "Enable",
					desc =  "Enables "..DSpellTable2["name"].." reporter, when applied asking for the player to be dispelled.",
					get = function(info) return Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["applied"] end,
					set = function(info, v)	Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["applied"] = v end,
					order = 6.5,
					width = "full",
				},
				Self = {
					type = "toggle",
					name =  "Self Only",
					desc =  "reports only when the debuff is applied to you.",
					get = function(info) return Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["self"] end,
					set = function(info, v)	Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["self"] = v end,
					order = 7,
				},
				InstanceR = {
					type = "select",
					name =  "Instance Limiter",
					values = FatCooldowns.Instances,
					desc = "Limits the reporter to only report when you inside the selected instance",
					get = function(v) return Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["instance2"] end,
					set = function(info, v) Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["instance2"] = v end,
					order = 7.2,
				},
				BossR = {
					type = "select",
					name =  "Boss Limiter",
					values = FatCooldowns.Boss,
					desc = "Limits the reporter to only report when you are fighting the selected boss.\n\nNote: The selected boss will need to be showen in boss frame 1",
					get = function(v) return Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["boss2"] end,
					set = function(info, v) Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["boss2"] = v end,
					order = 7.5,
				},
				ChatR = {
					type = "select",
					name =  "Chat",
					values = {[1] = "Self", [2] = "Say", [3] = "Yell", [4] = "Party", [5] = "Raid"},
					desc = "Limits the reporter to only report when you inside the selected instance",
					get = function(v) return Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["chat2"] end,
					set = function(info, v) Display.db.profile.DispellerList[DSpellTable2["DSpellID"]]["chat2"] = v end,
					order = 8,
				},
			}
		}
	end
	-- AutoGear
	options.args.AutoGear.args = {
		descr111 = {
			type = "description",
			name =  "AutoGearer will allow the addon to auto equip items based on the settings below, currently only works with items you loot/recive from npcs, mobs or quests.\n",
			width = "full",
			fontSize  = "medium",
			order = 0.1,
		},	
		AGEnable = {
			type = "toggle",
			name =  "Enable",
			desc =  "Enables Auto Gearer.",
			get = function(info) return Display.db.profile.AGEnable end,
			set = function(info, v)	Display.db.profile.AGEnable = v end,
			order = 1,
			width = "double",
		},
		AGMaxLvl = {
			type = "toggle",
			name =  "Disable at max level",
			desc =  "disable when your at max level.",
			get = function(info) return Display.db.profile.AGMaxLvl end,
			set = function(info, v)	Display.db.profile.AGMaxLvl = v end,
			order = 2,
			width = "double",
		},
		AGPrint = {
			type = "toggle",
			name =  "Print",
			desc =  "prints in chat when AG changes gear.",
			get = function(info) return Display.db.profile.AGPrint end,
			set = function(info, v)	Display.db.profile.AGPrint = v end,
			order = 3,
			width = "double",
		},
		AGToolTip = {
			type = "select",
			name =  "Score In Tooltip",
			desc =  "adds item score to tooltips.",
			values = { "None", "Current", "All"},
			get = function(info) return Display.db.profile.AGToolTip2 end,
			set = function(info, v)	Display.db.profile.AGToolTip2 = v end,
			order = 4,
			width = "double",
		},
		AGBind = {
			type = "toggle",
			name =  "Enable BOE",
			desc =  "allows AG to bind/use BOE items.",
			get = function(info) return Display.db.profile.AGBind end,
			set = function(info, v)	Display.db.profile.AGBind = v end,
			order = 5,
			width = "double",
		},
		AGBags = {
			type = "toggle",
			name =  "Change Bags",
			desc =  "allows AG to change bags.",
			get = function(info) return Display.db.profile.AGBags end,
			set = function(info, v)	Display.db.profile.AGBags = v end,
			order = 6,
			width = "double",
		},
		AGQuality = {
			type = "multiselect",
			name =  "Item Quality",
			desc =  "Select the quality of loot to enable for AutoGearer.",
			values = {[0] = "|cff9d9d9dPoor|r", [1] = "|cffffffffCommon|r", [2] = "|cff1eff00Uncommon|r", [3] = "|cff0070ddRare|r", [4] = "|cffa335eeEpic|r"},
			get = function(info, v)	return Display.db.profile.AGQuality[v] end,
			set = function(info, v, v2) Display.db.profile.AGQuality[v] = v2 end,
			order = 6.2,
		},
		AGHD1 = {
			type = "header",
			name =  "Spec Priority Options",
			width = "full",
			order = 7,
		},
		AGDungeon = {
			type = "toggle",
			name =  "Dungeon Role > Talents",
			desc =  "when you recive a new item it will equip item basied on your dungeon role and not your talents.\n\nNote: e.g. when your dps talents and your healing it will equip new healing items and not dps ones.",
			get = function(info) return Display.db.profile.AGDungeon end,
			set = function(info, v)	Display.db.profile.AGDungeon = v end,
			order = 8,
			width = "double",
		},
		AGSpecOverWrite = {
			type = "select",
			name =  "Overwrite Spec 1",
			desc =  "Select the spec you would like AG to always use for this character. UnSet disable's this option.\n\nNote: this will overwrite dungeon role > talents",
			values = function(info, v)
				local tabletoreturn = {}
				for index, val in pairs(FatCooldowns.DefaultItemWeights[TempClass]) do
					tabletoreturn[index] = index
				end
				tabletoreturn["UnSet"] = "UnSet"
				return tabletoreturn
			end,
			get = function(info, v) if Display.db.profile.AGSpecOverWrite[UnitName("player")] ~= nil and Display.db.profile.AGSpecOverWrite[UnitName("player")][1] ~= nil then return Display.db.profile.AGSpecOverWrite[UnitName("player")][1] else return "UnSet" end end,
			set = function(info, v, v2)
				Display.db.profile.AGSpecOverWrite[UnitName("player")] = Display.db.profile.AGSpecOverWrite[UnitName("player")] or {}
				Display.db.profile.AGSpecOverWrite[UnitName("player")][1] = Display.db.profile.AGSpecOverWrite[UnitName("player")][1] or "Unset"
				Display.db.profile.AGSpecOverWrite[UnitName("player")][1] = v
				FatCooldowns.RefreshFrameListOptionsAndVariables()
				Display:UpdateConfig()
			end,
			order = 9,
		},
		AGSpecOverWrite2 = {
			type = "select",
			name =  "Overwrite Spec 2",
			desc =  "Select the spec you would like AG to always use for this character. UnSet disable's this option.\n\nNote: this will overwrite dungeon role > talents",
			values = function(info, v)
				local tabletoreturn = {}
				for index, val in pairs(FatCooldowns.DefaultItemWeights[TempClass]) do
					tabletoreturn[index] = index
				end
				tabletoreturn["UnSet"] = "UnSet"
				return tabletoreturn
			end,
			get = function(info, v) if Display.db.profile.AGSpecOverWrite[UnitName("player")] ~= nil and Display.db.profile.AGSpecOverWrite[UnitName("player")][2] ~= nil then return Display.db.profile.AGSpecOverWrite[UnitName("player")][2] else return "UnSet" end end,
			set = function(info, v, v2)
				Display.db.profile.AGSpecOverWrite[UnitName("player")] = Display.db.profile.AGSpecOverWrite[UnitName("player")] or {}
				Display.db.profile.AGSpecOverWrite[UnitName("player")][2] = Display.db.profile.AGSpecOverWrite[UnitName("player")][2] or "Unset"
				Display.db.profile.AGSpecOverWrite[UnitName("player")][2] = v
				FatCooldowns.RefreshFrameListOptionsAndVariables()
				Display:UpdateConfig()
			end,
			order = 9,
		},
		AGHD2 = {
			type = "header",
			name =  "Item Weights - Main Stats",
			width = "full",
			order = 10,
		},
		AGHide = {
			type = "toggle",
			name =  "Hide Low Stats",
			desc =  "hides the low stats from Item Weights.",
			get = function(info) return Display.db.profile.AGHide end,
			set = function(info, v)	Display.db.profile.AGHide = v FatCooldowns.RefreshFrameListOptionsAndVariables() Display:UpdateConfig() end,
			order = 11,
			width = "double",
		},
		AGClass = {
			type = "select",
			name =  "Player Class",
			desc =  "Select the class you would like to edit the item weights.",
			values = function(info, v) if FatCooldowns.ExPac == 2 then
				return {
					["DEATHKNIGHT"] = "|cffC41F3BDEATHKNIGHT|r", 
					["DRUID"] = "|cffFF7D0ADRUID|r", 
					["HUNTER"] = "|cffABD473HUNTER|r",
					["MAGE"] = "|cff69CCF0MAGE|r",
					["PALADIN"] = "|cffF58CBAPALADIN|r",
					["PRIEST"] = "|cffFFFFFFPRIEST|r",
					["ROGUE"] = "|cffFFF569ROGUE|r",
					["SHAMAN"] = "|cff0070DESHAMAN|r",
					["WARLOCK"] = "|cff9482C9WARLOCK|r",
					["WARRIOR"] = "|cffC79C6EWARRIOR|r",}
				else return {
					["DRUID"] = "|cffFF7D0ADRUID|r", 
					["HUNTER"] = "|cffABD473HUNTER|r",
					["MAGE"] = "|cff69CCF0MAGE|r",
					["PALADIN"] = "|cffF58CBAPALADIN|r",
					["PRIEST"] = "|cffFFFFFFPRIEST|r",
					["ROGUE"] = "|cffFFF569ROGUE|r",
					["SHAMAN"] = "|cff0070DESHAMAN|r",
					["WARLOCK"] = "|cff9482C9WARLOCK|r",
					["WARRIOR"] = "|cffC79C6EWARRIOR|r",}
				end
			end,
			get = function(info, v) return TempClass end,
			set = function(info, v, v2) AGSpec = "None" TempClass = v FatCooldowns.RefreshFrameListOptionsAndVariables() Display:UpdateConfig() end,
			order = 12,
		},
		AGSpec = {
			type = "select",
			name =  "Player Spec",
			desc =  "Select the spec you would like to edit the item weights.",
			values = function(info, v)
				local tabletoreturn = {}
				for index, val in pairs(FatCooldowns.DefaultItemWeights[TempClass]) do
					tabletoreturn[index] = index
				end
				return tabletoreturn
			end,
			get = function(info, v)
				if AGSpec2 then
					local playerslevel = UnitLevel("player")
					local SpecCheck, Tree1, Tree2, Tree3 = LGT:GetUnitTalentSpec("player")
					SpecCheck = L[SpecCheck]
					local FClass = UnitClass("player")
					if SpecCheck and playerslevel > 9 then
						if FClass == L["Druid"] and Tree2 > Tree1 and Tree2 > Tree3 then
							if FatCooldowns.ExPac == 0 and ((not LGT:UnitHasTalent("player", "Blood Frenzy") and LGT:UnitHasTalent("player", tostring(GetSpellInfo(37116)))) or (not LGT:UnitHasTalent("player", L["Improved Shred"]) and LGT:UnitHasTalent("player", tostring(GetSpellInfo(19609)))) or UnitBuff("player", tostring(GetSpellInfo(9634))) or UnitBuff("player", tostring(GetSpellInfo(5487)))) then
								AGSpec = "Guardian"
							elseif FatCooldowns.ExPac == 1 and ((LGT:UnitHasTalent("player", tostring(GetSpellInfo(16862))) and LGT:UnitHasTalent("player", tostring(GetSpellInfo(16949))) and LGT:UnitHasTalent("player", tostring(GetSpellInfo(37117)))) or UnitBuff("player", tostring(GetSpellInfo(9634))) or UnitBuff("player", tostring(GetSpellInfo(5487)))) then
								AGSpec = "Guardian"
							else
								AGSpec = SpecCheck
							end
						elseif IsEquippedItemType("Shields") then
							if FClass == L["Paladin"] and Tree3 > Tree1 then
								AGSpec = "Protection"
							elseif FClass == L["Warrior"] then
								AGSpec = "Protection"
							else
								AGSpec = SpecCheck
							end
						else
							AGSpec = SpecCheck
						end
					else
						AGSpec = "None"
					end 
					AGSpec2 = false
				end
				return AGSpec
			end,
			set = function(info, v, v2)
				if AGSpec2 then
					local playerslevel = UnitLevel("player")
					local SpecCheck, Tree1, Tree2, Tree3 = LGT:GetUnitTalentSpec("player")
					SpecCheck = L[SpecCheck]
					local FClass = UnitClass("player")
					if SpecCheck and playerslevel > 9 then
						if FClass == L["Druid"] and Tree2 > Tree1 and Tree2 > Tree3 then
							if FatCooldowns.ExPac == 0 and ((not LGT:UnitHasTalent("player", "Blood Frenzy") and LGT:UnitHasTalent("player", tostring(GetSpellInfo(37116)))) or (not LGT:UnitHasTalent("player", L["Improved Shred"]) and LGT:UnitHasTalent("player", tostring(GetSpellInfo(19609)))) or UnitBuff("player", tostring(GetSpellInfo(9634))) or UnitBuff("player", tostring(GetSpellInfo(5487)))) then
								AGSpec = "Guardian"
							elseif FatCooldowns.ExPac == 1 and ((LGT:UnitHasTalent("player", tostring(GetSpellInfo(16862))) and LGT:UnitHasTalent("player", tostring(GetSpellInfo(16949))) and LGT:UnitHasTalent("player", tostring(GetSpellInfo(37117)))) or UnitBuff("player", tostring(GetSpellInfo(9634))) or UnitBuff("player", tostring(GetSpellInfo(5487)))) then
								AGSpec = "Guardian"
							else
								AGSpec = SpecCheck
							end
						elseif IsEquippedItemType("Shields") then
							if FClass == L["Paladin"] and Tree3 > Tree1 then
								AGSpec = "Protection"
							elseif FClass == L["Warrior"] then
								AGSpec = "Protection"
							else
								AGSpec = SpecCheck
							end
						else
							AGSpec = SpecCheck
						end
					else
						AGSpec = "None"
					end
					AGSpec2 = false
				end
				AGSpec = v 
				FatCooldowns.RefreshFrameListOptionsAndVariables()
				Display:UpdateConfig()
			end,
			order = 13,
		},		
		AGHD3 = {
			type = "header",
			name =  "Item Weights - Gems",
			width = "full",
			hidden = function()
			local HideorNot = true
				if TempClass ~= nil and AGSpec ~= nil and  FatCooldowns.DefaultItemWeights[TempClass] ~= nil and FatCooldowns.DefaultItemWeights[TempClass][AGSpec] ~= nil then
					for ItemWeightsIndex1, ItemWeightsValue2 in pairs(FatCooldowns.DefaultItemWeights[TempClass][AGSpec]) do
						for ItemWeightsIndex, ItemWeightsValue in pairs(FatCooldowns.DefaultItemWeights[TempClass][AGSpec]) do
							if ItemWeightsValue2 == ItemWeightsIndex and ItemWeightsIndex == "BlueSockets" or ItemWeightsIndex == "MetaSockets" or ItemWeightsIndex == "YellowSockets" or ItemWeightsIndex == "RedSockets" then
								if Display.db.profile.AGHide == true then 
									if Display.db.profile.AGW[FatCooldowns.ExPac] and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass] and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec] and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec][ItemWeightsIndex] then
				 						if Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec][ItemWeightsIndex] ~= 0 and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec][ItemWeightsIndex] ~= 0.0001 then HideorNot = false end
				 					elseif ItemWeightsValue ~= 0 and ItemWeightsValue ~= 0.0001 then HideorNot = false
				 					end
				 				else
				 					HideorNot = false
				 				end
				 			end
				 		end
				 	end
			 	end
			 	return HideorNot
			end,
			order = 200,
		},		
		AGHD4 = {
			type = "header",
			name =  "Item Weights - Procs",
			hidden = function()
			local HideorNot = true
				if TempClass ~= nil and AGSpec ~= nil and  FatCooldowns.DefaultItemWeights[TempClass] ~= nil and FatCooldowns.DefaultItemWeights[TempClass][AGSpec] ~= nil then
					for ItemWeightsIndex1, ItemWeightsValue2 in pairs(FatCooldowns.DefaultItemWeights[TempClass][AGSpec]) do
						for ItemWeightsIndex, ItemWeightsValue in pairs(FatCooldowns.DefaultItemWeights[TempClass][AGSpec]) do
							if ItemWeightsValue2 == ItemWeightsIndex and ItemWeightsIndex == "DamageProc" or ItemWeightsIndex == "RangedProc" or ItemWeightsIndex == "MeleeProc" or ItemWeightsIndex == "SpellProc" or ItemWeightsIndex == "DamageSpellProc" or ItemWeightsIndex == "HealingProc" then
								if Display.db.profile.AGHide == true then 
									if Display.db.profile.AGW[FatCooldowns.ExPac] and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass] and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec] and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec][ItemWeightsIndex] then
				 						if Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec][ItemWeightsIndex] ~= 0 and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec][ItemWeightsIndex] ~= 0.0001 then HideorNot = false end
				 					elseif ItemWeightsValue ~= 0 and ItemWeightsValue ~= 0.0001 then HideorNot = false
				 					end
				 				else
				 					HideorNot = false
				 				end
				 			end
				 		end
				 	end
			 	end
			 	return HideorNot
			end,
			width = "full",
			order = 300,
		},
	}
	local ItemWeightsValueOrder = {}
	local ExtraOrder = 0
	if TempClass ~= nil and AGSpec ~= nil and  FatCooldowns.DefaultItemWeights[TempClass] ~= nil and FatCooldowns.DefaultItemWeights[TempClass][AGSpec] ~= nil then
		for x,i in pairs(FatCooldowns.DefaultItemWeights[TempClass][AGSpec]) do
			table.insert(ItemWeightsValueOrder, x)
		end
		table.sort(ItemWeightsValueOrder, function(a,b) return a < b end)
		for ItemWeightsIndex1, ItemWeightsValue2 in pairs(ItemWeightsValueOrder) do
			for ItemWeightsIndex, ItemWeightsValue in pairs(FatCooldowns.DefaultItemWeights[TempClass][AGSpec]) do
				if ItemWeightsValue2 == ItemWeightsIndex and ItemWeightsIndex ~= "weapons" then
					if ItemWeightsIndex == "BlueSockets" or ItemWeightsIndex == "MetaSockets" or ItemWeightsIndex == "YellowSockets" or ItemWeightsIndex == "RedSockets" then ExtraOrder = 100
					elseif ItemWeightsIndex == "DamageProc" or ItemWeightsIndex == "RangedProc" or ItemWeightsIndex == "MeleeProc" or ItemWeightsIndex == "SpellProc" or ItemWeightsIndex == "DamageSpellProc" or ItemWeightsIndex == "HealingProc"  then ExtraOrder = 200
					else ExtraOrder = 0 end
					options.args.AutoGear.args[ItemWeightsIndex] = {
						type = "range",
						name =  ItemWeightsIndex,
						desc =  "sets the weights value",
						min = 0, max = 5, step = 0.01, bigStep = 0.01,
						get = function(v)
							if Display.db.profile.AGW[FatCooldowns.ExPac] and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass] and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec] and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec][ItemWeightsIndex] then
								return Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec][ItemWeightsIndex]
							else
								return ItemWeightsValue
							end
						end,
						set = function(info, v)
							if v == 0 then v = 0.0001 end 
							Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec][ItemWeightsIndex] = v
						end,
						hidden = function() 
							if Display.db.profile.AGHide == true then 
								if Display.db.profile.AGW[FatCooldowns.ExPac] and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass] and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec] and Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec][ItemWeightsIndex] then
								 	if Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec][ItemWeightsIndex] == 0 or Display.db.profile.AGW[FatCooldowns.ExPac][TempClass][AGSpec][ItemWeightsIndex] == 0.0001 then
								 		return true
								 	else
								 		return false 
									end 
								elseif ItemWeightsValue == 0 or ItemWeightsValue == 0.0001 then return true
								else
									return false
								end
							else
								return false
							end
						end,
						order = 100 + ItemWeightsIndex1 + ExtraOrder,
					}
				end
			end
		end
	end
	-- spammer
	for i = 1, 20 do
		if Display.db.profile.SpammerAmount >= i then
			if Display.db.profile.SpammerTable[i] then
				options.args.ChatReporter.args.CRSpammer.args[tostring(i).."header"] = {
					type = "header",
					name = "Spammer "..i,
					order = i + 0.01,
					width = "full",
				}
				options.args.ChatReporter.args.CRSpammer.args[tostring(i).."enable"] = {
					type = 'toggle',
					name = "Enable",
					get = function(v) return Display.db.profile.SpammerTable[i].enable end,
					set = function(info, v) Display.db.profile.SpammerTable[i].enable = v end,
					order = i + 0.02,
				}
				options.args.ChatReporter.args.CRSpammer.args[tostring(i).."keep"] = {
					type = 'toggle',
					name = "Enable on log in",
					desc =  "if enabled this will turn on spammer for this message when you log in, if not enabled it will disable the spammer for this message when you log in",
					get = function(v) return Display.db.profile.SpammerTable[i].keep end,
					set = function(info, v) Display.db.profile.SpammerTable[i].keep = v end,
					order = i + 0.03,
				}
				options.args.ChatReporter.args.CRSpammer.args[tostring(i).."range"] = {
					type = "range",
					name =  "Priority",
					min = 1, max = 100, step = 1, bigStep = 1,
					desc = "set the priority of the message, the higher the number the more often the message will be sent",
					get = function(info) return Display.db.profile.SpammerTable[i].prio end,
					set = function(info, v)	Display.db.profile.SpammerTable[i].prio = v end,
					order = i + 0.04,
				}
				options.args.ChatReporter.args.CRSpammer.args[tostring(i).."channel"] = {
					type = "select",
					name =  "channel",
					desc = "Select a channel to spam the message",
					values = function(info)
						local ChatChannels = {
							["SAY"] = "Say",
							["YELL"] = "Yell", 
							["PARTY"] = "Party",
							["RAID"] = "Raid", 
							["GUILD"] = "Guild",
							["OFFICER"] = "Officer",
							["RAID_WARNING"] = "Raid Warning",
						} 

						for i = 1, 10 do
							local TempChannelID, TempChannelName = GetChannelName(i)
							if TempChannelName ~= nil then
								ChatChannels[TempChannelName] = TempChannelName
							end
						end
						return ChatChannels
					end,
					get = function(info) return Display.db.profile.SpammerTable[i].channel end,
					set = function(info, v)	Display.db.profile.SpammerTable[i].channel = v end,
					order = i + 0.05,
				}
				options.args.ChatReporter.args.CRSpammer.args[tostring(i).."input"] = {
					type = "input",
					name = "Message",
					order = i + 0.06,
					width = "full",
					get = function(info) return Display.db.profile.SpammerTable[i].msg end,
					set = function(info, v) Display.db.profile.SpammerTable[i].msg = v end,
					width = "full",
				}
			end
		else
			options.args.ChatReporter.args.CRSpammer.args[tostring(i).."enable"] = nil
			options.args.ChatReporter.args.CRSpammer.args[tostring(i).."header"] = nil
			options.args.ChatReporter.args.CRSpammer.args[tostring(i).."keep"] = nil
			options.args.ChatReporter.args.CRSpammer.args[tostring(i).."range"] = nil
			options.args.ChatReporter.args.CRSpammer.args[tostring(i).."channel"] = nil
			options.args.ChatReporter.args.CRSpammer.args[tostring(i).."input"] = nil
		end		
	end









	Display:UpdateDisplay()
end






























local TrashList = {}
local CurrrentSelectedTrash = nil

local ADList = {}
local CurrrentSelectedAD = nil

local BlackList = {}
local CurrrentSelectedBlackList = nil

local TempSearch = nil
local TempSearchList = {}
local CurrentSearchList = {}
local CurrrentSelectedSearchList = nil

local TempMailer = nil
local CurrentMailList = {}
local CurrrentSelectedMailList = nil

local TempMailerBag = nil
local CurrentMailBagList = {}
local CurrrentSelectedBagList = nil

local MasterLooterList = {}
local CurrrentSelectedMasterLooterItem = nil

local BuffList = {}
local CurrrentSelectedBuff = nil

local DisenchantList = {}
local CurrrentSelectedDisenchantItem = nil




















options = {
	name = "FCD |cffFF7C0AShekles|r Version V"..tostring(FatCooldowns.FCDVer),
	type = "group",
	args = {
		BlizOptions ={
			type = "group",
			name = "Open Standalone Dialog",
			hidden = function() if LibStub("AceConfigDialog-3.0").OpenFrames["FatCooldowns"] then return true else return false end end,
			args={
				config = {
					order= 0.1,
					type = "execute",
					name = "/FCD",
					desc = "Opens the setup options in a movable standalone dialog",
					func = function() FatCooldowns:OpenConfigDialog() FatCooldowns:ScheduleTimer(function() FatCooldowns:OpenConfigDialog() end, 0.1) end
				},
			},
		},
		test = {
			type = "execute",
			name =  "Test Bars",
			desc =  "Tests all the tracked spells",
			order = 1.1,
			func = Display.Test,
		},
		reset = {
			type = "execute",
			name =  "Reset Bars",
			desc =  "Reset the cooldown on all tracked spells",
			order = 1.2,
			func = Display.Reset,
		},
		resetspells = {
			type = "execute",
			name =  "Reset Tracking Spells",
			desc =  "Rests all tracked spells, you will no longer be tracking any spells.",
			order = 1.3,
			func = function() Display:resetspells() end,
			confirm = true
		},
		display = {
			type = "group",
			name =  "General Options",
			desc =  "General Options",
			order = 1.9,
			cmdHidden = true,
			args = {
				MOHD = {
					type = "header",
					name =  "Main Options",
					width = "full",
					order = 0.1,
				},
				HideAllFrames = {
					type = 'toggle',
					name =  "Hide All Frames",
					desc =  "Hide all of the frames, this will disable most of the addon",
					get = function(v) return Display.db.profile.HideAllFrames end,
					set = function(info, v) Display.db.profile.HideAllFrames = v Display:UpdateDisplay() Display:SetAnchors(true) end,
					order = 1,
				},
				locked = {
					type = "toggle",
					name = "Lock Bars",
					desc = "Locks the bars in place and prevents them from being moved.",
					get = get,
					set = set,
					order = 2,
				},
				minimapicon = {
					type = 'toggle',
					name =  "Minimap Button",
					desc =  "Show/Hide the minimap button.",
					get = function() return not Display.db.profile.minimap.hide end,
					set = function(info, v) Display.db.profile.minimap.hide = not v Display:FCDMiniMap() end,
					order = 3,
				},
				clamped = {
					type = 'toggle',
					name =  "Clamp to screen",
					desc =  "Prevent the anchor/bars from moving off screen.",
					get = get,
					set = set,
					order = 4,
				},
				MaxLvL = {
					type = 'toggle',
					name =  "Max Level",
					desc =  "Only auto load permanent bars for max level players.\n\nNote: This will not block permanent bars from being shown when the player uses the spell.",
					get = get,
					set = set,
					order = 5,
				},
				ArenaMode = {
					type = 'toggle',
					name =  "Arena Mode",
					desc =  "Attempt to track CDs from people who are not in your party.",
					get = get,
					set = set,
					order = 6,
				},
				loadmore = {
					type = 'toggle',
					name =  "More Bar Textures",
					desc =  "Load more textures for the bars.",
					get = function(v) return Display.db.profile.loadmore end,
					set = function(info, v)
						Display.db.profile.loadmore = v
						Display:loadbars()
					end,
					order = 7,
				},
				KeepWhenSolo = {
					type = 'toggle',
					name =  "Solo Mode",
					desc =  "Keeps bars when leaving a group.",
					get = get,
					set = set,
					order = 8,
				},
				SOHD = {
					type = "header",
					name =  "Sorting Options",
					width = "full",
					order = 9,
				},
				SortOrderTime = {
					type = 'toggle',
					name =  "Sort Order: Time",
					disabled = function() if Display.db.profile.SortOrderBarLength then Display.db.profile.SortOrderTime = false return true else return false end end,
					desc =  "Sort Bars ignoring all other sorting and just order by time.\n\nNote: disabled for perma bars.",
					get = get,
					set = set,
					order = 10,
				},
				SortOrderBarLength = {
					type = 'toggle',
					name =  "Sort Order: Bar Length",
					disabled = function() if Display.db.profile.SortOrderTime then Display.db.profile.SortOrderBarLength = false return true else return false end end,
					desc =  "Sort Bars ignoring all other sorting and just order by bar length.\n\nNote: disabled for perma bars.",
					get = get,
					set = set,
					order = 11
				},
				SortOrderDirection = {
					type = 'toggle',
					name =  "Sort Order: Direction",
					desc =  "Change the sort direction of the bars for the options Sort Order: Bar Length and Sort Order: Time.",
					get = get,
					set = set,
					order = 12,
				},
				PermaMoveingBars = {
					type = 'toggle',
					name =  "Moving Perma Bars",
					desc =  "Allow/Prevent permanent from moving when the CD is triggered/finished.",
					get = get,
					set = set,
					order = 13,
				},
				ExHD = {
					type = "header",
					name =  "Extra Options",
					width = "full",
					order = 14,
				},
				removereadytext = {
					type = 'toggle',
					name =  "Remove: Ready",
					desc =  "Remove the R - from permanent bars",
					get = get,
					set = set,
					order = 15.2,
				},	
				removeglow = {
					type = 'toggle',
					name =  "Remove: Spark",
					desc =  "Remove the glow/spark at the end of the bar.",
					get = get,
					set = function(info, v)
						Display.db.profile.removeglow = v
						Display:UpdateDisplay("yes")
					end,
					order = 15.2,
				},
				SpellIconAnimation = {
					type = "toggle",	
					name =  "Spell Icon Animation",
					desc =  "Adds animation to the spell icon.\n\nNote: If you are using OmniCC you can add |cffFFF468CooldownTimer|r to the filter list to remove the numbers/countdown.",
					get = get,
					set = set,
					order = 15.3,
				},
				SpellIconAnimationReverse = {
					type = "toggle",	
					name =  "Animation Reverse",
					desc =  "Reverse the animation to the spell icon.",
					disabled = function() if Display.db.profile.SpellIconAnimation then return false else Display.db.profile.SpellIconAnimationReverse = false return true end end,
					get = get,
					set = set,
					order = 15.4,
				},
				iconzoom = {
					type = 'toggle',
					name =  "Icon Zoom",
					desc =  "Remove the border around the icon.",
					get = get,
					set = function(info, v)
						Display.db.profile.iconzoom = v
						Display:UpdateDisplay("yes")
					end,
					order = 15.5,
				},
				availability = {
					type = 'toggle',
					name =  "Spell Availability",
					desc =  "Adds Zone, Dead, Offline to permanent bars.",
					get = get,
					set = set,
					order = 16.4,
				},
				AbbrevName = {
					type = 'toggle',
					name =  "Abbrevate Names",
					desc =  "Abbrevate Names e.g. T. L. King.",
					get = get,
					set = set,
					order = 16.5,
				},
				BOHD = {
					type = "header",
					name =  "Bar Options",
					width = "full",
					order = 17,
				},
				orientation = {
					type = "select",
					name =  "Orientation",
					values = {  "Right to Left",  "Left to Right" },
					get = function(info) return (Display.db.profile.orientation == 3) and 2 or 1 end,
					set = function(info, v)
						Display.db.profile.orientation = (v == 2) and 3 or 1
						Display:UpdateDisplay()
					end,
					order = 18,
				},
				texture = {
					type = "select",
					name =  "Texture",
					dialogControl = 'LSM30_Statusbar',
					desc =  "Sets the Bars Texture.",
					values = AceGUIWidgetLSMlists.statusbar,
					get = function(info) return Display.db.profile.texture end,
					set = function(info, v)
						Display.db.profile.texture = v
						Display:UpdateDisplay()
					end,
					order = 19,
				},
				FillBars = {
					type = 'toggle',
					name =  "Fill Bars",
					desc =  "Change the direction the bar fills and will fill permanent bars background",
					get = function(v) return Display.db.profile.FillBars end,
					set = function(info, v)
						Display.db.profile.FillBars = v
						Display:UpdateDisplay("yes")
					end,
					order = 22,
				},
				Removal = {
					type = 'toggle',
					name =  "Removal Bars",
					desc =  "Remove some bars when the aura/buff is removed.\n\nExample: Beacon of Light.",
					get = get,
					set = set,
					order = 23,
				},
				BaHD = {
					type = "header",
					name =  "Background Options",
					width = "full",
					order = 23.1,
				},
				removebackground = {
					type = 'toggle',
					name =  "Background Textures: Remove",
					disabled = function() if Display.db.profile.FillBackGround then Display.db.profile.removebackground = false return true else return false end end,
					desc =  "This will remove the background for permanent bars when they are ready\n\nNote: this will not remove the background from permanent bars already added",
					get = function(v) return Display.db.profile.removebackground end,
					set = function(info, v)
						Display.db.profile.removebackground = v
						Display:UpdateDisplay("yes")
					end,
					order = 23.2,
					width = "double",
				},
				FillBackGround = {
					type = 'toggle',
					name =  "Background Textures: Fill",
					disabled = function() if Display.db.profile.removebackground then Display.db.profile.FillBackGround = false return true else return false end end,
					desc =  "This will fill the background for permanent bars when they are ready\n\nNote: this will not fill the background for permanent bars already added",
					get = function(v) return Display.db.profile.FillBackGround end,
					set = function(info, v)
						Display.db.profile.FillBackGround = v
						Display:UpdateDisplay("yes")
					end,
					order = 23.3,
					width = "double",
				},
				BoHD = {
					type = "header",
					name =  "Border Options",
					width = "full",
					order = 24.1,
				},
				Border = {
					type = 'toggle',
					name =  "Enable Bar Borders",
					desc =  "this will toggle the border around bars",
					get = get,
					set = function(info, v)
						Display.db.profile.Border = v
						Display:UpdateDisplay("yes")
					end,
					order = 24.3,
					width = "double",
				},
				BorderThickness = {
					type = 'range',
					name =  "Border Thickness",
					desc =  "this will change the Thickness of the border\n\nNote: its best to reload after changing this setting",
					disabled = function() if Display.db.profile.Border then return false else Display.db.profile.BorderThickness = 0 return true end end,
					min = 0, max = 3, step = 0.1, bigStep = 0.1,
					get = get,
					set = function(info, v)
						Display.db.profile.BorderThickness = v
						Display:UpdateDisplay("yes")
					end,
					order = 24.5,
					width = "double",
				},
				AcoHD = {
					type = "header",
					name =  "Anchor Options",
					width = "full",
					order = 24.51,
				},
				Background = {
					type = "group",
					name = "",
					guiInline = true,
					order = 24.52,
					get = function(info) return Display.db.profile.Background[ info[#info] ] end,
					set = function(info, value)
						Display.db.profile.Background[ info[#info] ] = value
						Display:UpdateBackdrop()
					end,
					args = {
						Texture = {
							type = "select",
							dialogControl = 'LSM30_Background',
							order = 1,
							name = "Background Texture",
							desc = "Texture to use for the Anchor's background",
							values = AceGUIWidgetLSMlists.background,
						},
						BorderTexture = {
							type = "select",
							dialogControl = 'LSM30_Border',
							order = 2,
							name = "Border Texture",
							desc = "Texture to use for the Anchor's border",
							values = AceGUIWidgetLSMlists.border,
						},
						Color = {
							type = "color",
							order = 3,
							name = "Background Color",
							desc = "Anchor's background color",
							hasAlpha = true,
							get = function(info)
								local t = Display.db.profile.Background.Color
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = Display.db.profile.Background.Color
								t.r, t.g, t.b, t.a = r, g, b, a
								Display:UpdateBackdrop()
							end,
						},
						BorderColor = {
							type = "color",
							order = 4,
							name = "Border Color",
							desc = "Anchor's border color",
							hasAlpha = true,
							get = function(info)
								local t = Display.db.profile.Background.BorderColor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = Display.db.profile.Background.BorderColor
								t.r, t.g, t.b, t.a = r, g, b, a
								Display:UpdateBackdrop()
							end,
						},
						Tile = {
							type = "toggle",
							order = 5,
							name = "Tile Background",
							desc = "Tile the background texture",
						},
						TileSize = {
							type = "range",
							order = 6,
							name = "Background Tile Size",
							desc = "The size used to tile the background texture",
							min = 16, max = 256, step = 1,
							disabled = function() return not Display.db.profile.Background.Tile end,
						},
						EdgeSize = {
							type = "range",
							order = 7,
							name = "Border Thickness",
							desc = "The thickness of the border",
							min = 1, max = 16, step = 1,
						},
						BarInset = {
							type = "range",
							order = 8,
							name = "Bar Inset",
							desc = "Sets how far inside the Anchor the bars will display from the 4 borders of the Anchor",
							min = 1, max = 16, step = 1,
						},
					},
				},
				LBOHD = {
					type = "header",
					name =  "Label Options",
					width = "full",
					order = 27,
				},
				fontFace = {
					type = "select",
					name =  "Label Font",
					desc =  "The font that the bar labels will use",
					dialogControl = 'LSM30_Font',
					values = AceGUIWidgetLSMlists.font,
					get = function(info) return Display.db.profile.fontFace end,
					set = function(info, v)
						Display.db.profile.fontFace = v
						Display:UpdateDisplay()
					end,
					order = 28,
				},	
				outline = {
					type = "select",
		   			name = "Outline",
					values =  {"None", "MONOCHROME", "OUTLINE", "THICKOUTLINE"},
					get = function(info)  
					if Display.db.profile.outline == "None" then return 1 end
					if Display.db.profile.outline == "MONOCHROME" then return 2 end
					if Display.db.profile.outline == "OUTLINE" then return 3 end
					if Display.db.profile.outline == "THICKOUTLINE" then return 4 end end,
					set = function(t, value)
					if value == 1 then Display.db.profile.outline = "None" end
					if value == 2 then Display.db.profile.outline = "MONOCHROME" end
					if value == 3 then Display.db.profile.outline = "OUTLINE" end
					if value == 4 then Display.db.profile.outline = "THICKOUTLINE" end
						Display:UpdateDisplay()
					end,
					order = 29,
	   			},
				SymbolsStart = {
					type = "select",
					name =  "Start Symbol",
					values =  {"None", "(",")", ">", "<","- ","+ ","@  ","* ","[","]","|","\\","/","->","<-"},
					desc =  "The Starting Symbol for the targeted person",
					get = function(info)  
					if Display.db.profile.SymbolsStart == "" then return 1 end
					if Display.db.profile.SymbolsStart == "(" then return 2 end
					if Display.db.profile.SymbolsStart == ")" then return 3 end
					if Display.db.profile.SymbolsStart == ">" then return 4 end
					if Display.db.profile.SymbolsStart == "<" then return 5 end
					if Display.db.profile.SymbolsStart == "- " then return 6 end
					if Display.db.profile.SymbolsStart == "+ " then return 7 end
					if Display.db.profile.SymbolsStart == "@ " then return 8 end
					if Display.db.profile.SymbolsStart == "* " then return 9 end
					if Display.db.profile.SymbolsStart == "[" then return 10 end
					if Display.db.profile.SymbolsStart == "]" then return 11 end
					if Display.db.profile.SymbolsStart == "| " then return 12 end
					if Display.db.profile.SymbolsStart == "\\" then return 13 end
					if Display.db.profile.SymbolsStart == "/" then return 14 end
					if Display.db.profile.SymbolsStart == "->" then return 15 end
					if Display.db.profile.SymbolsStart == "<-" then return 16 end
					end,
					set = function(t, value)
					if value == 1 then Display.db.profile.SymbolsStart = "" end
					if value == 2 then Display.db.profile.SymbolsStart = "(" end
					if value == 3 then Display.db.profile.SymbolsStart = ")" end
					if value == 4 then Display.db.profile.SymbolsStart = ">" end
					if value == 5 then Display.db.profile.SymbolsStart = "<" end
					if value == 6 then Display.db.profile.SymbolsStart = "- " end
					if value == 7 then Display.db.profile.SymbolsStart = "+ " end
					if value == 8 then Display.db.profile.SymbolsStart = "@ " end
					if value == 9 then Display.db.profile.SymbolsStart = "* " end
					if value == 10 then Display.db.profile.SymbolsStart = "[" end
					if value == 11 then Display.db.profile.SymbolsStart = "]" end
					if value == 12 then Display.db.profile.SymbolsStart = "| " end
					if value == 13 then Display.db.profile.SymbolsStart = "\\" end
					if value == 14 then Display.db.profile.SymbolsStart = "/" end
					if value == 15 then Display.db.profile.SymbolsStart = "->" end
					if value == 16 then Display.db.profile.SymbolsStart = "<-" end
						Display:UpdateDisplay()
					end,
					order = 29.1,
				},
				SymbolsEnd = {
					type = "select",
					name =  "End Symbol",
					values =  {"None", "(",")", ">", "<"," -"," +"," @"," *","[","]","|","\\","/","->","<-"},
					desc =  "The Ending Symbol for the targeted person",
					get = function(info)  
					if Display.db.profile.SymbolsEnd == "" then return 1 end
					if Display.db.profile.SymbolsEnd == "(" then return 2 end
					if Display.db.profile.SymbolsEnd == ")" then return 3 end
					if Display.db.profile.SymbolsEnd == ">" then return 4 end
					if Display.db.profile.SymbolsEnd == "<" then return 5 end
					if Display.db.profile.SymbolsEnd == " -" then return 6 end
					if Display.db.profile.SymbolsEnd == " +" then return 7 end
					if Display.db.profile.SymbolsEnd == " @" then return 8 end
					if Display.db.profile.SymbolsEnd == " *" then return 9 end
					if Display.db.profile.SymbolsEnd == "[" then return 10 end
					if Display.db.profile.SymbolsEnd == "]" then return 11 end
					if Display.db.profile.SymbolsEnd == " |" then return 12 end
					if Display.db.profile.SymbolsEnd == "\\" then return 13 end
					if Display.db.profile.SymbolsEnd == "/" then return 14 end
					if Display.db.profile.SymbolsEnd == "->" then return 15 end
					if Display.db.profile.SymbolsEnd == "<-" then return 16 end
					end,
					set = function(t, value)
					if value == 1 then Display.db.profile.SymbolsEnd = "" end
					if value == 2 then Display.db.profile.SymbolsEnd = "(" end
					if value == 3 then Display.db.profile.SymbolsEnd = ")" end
					if value == 4 then Display.db.profile.SymbolsEnd = ">" end
					if value == 5 then Display.db.profile.SymbolsEnd = "<" end
					if value == 6 then Display.db.profile.SymbolsEnd = " -" end
					if value == 7 then Display.db.profile.SymbolsEnd = " +" end
					if value == 8 then Display.db.profile.SymbolsEnd = " @" end
					if value == 9 then Display.db.profile.SymbolsEnd = " *" end
					if value == 10 then Display.db.profile.SymbolsEnd = "[" end
					if value == 11 then Display.db.profile.SymbolsEnd = "]" end
					if value == 12 then Display.db.profile.SymbolsEnd = " |" end
					if value == 13 then Display.db.profile.SymbolsEnd = "\\" end
					if value == 14 then Display.db.profile.SymbolsEnd = "/" end
					if value == 15 then Display.db.profile.SymbolsEnd = "->" end
					if value == 16 then Display.db.profile.SymbolsEnd = "<-" end
						Display:UpdateDisplay()
					end,
					order = 29.2,
				},
				TLOHD = {
					type = "header",
					name =  "Target Location Options",
					width = "full",
					order = 40,
				},
				ReTarget = {
					type = 'toggle',
					name =  "Change Target Location",
					desc =  "changes the targets name location",
					get = function(info) if Display.db.profile.ReTarget == "" then return true else return false end end,
					set = function(info, v) if v == true then Display.db.profile.ReTarget = "" else Display.db.profile.ReTarget = nil end Display:UpdateDisplay() end,
					order = 41,
					width = "double",
				},					
				TargetOrientation = {
					type = "select",
					name =  "Target Orientation",
					disabled = function() if Display.db.profile.ReTarget then return false else return true end end,
					values = {  "TOP",  "BOTTOM" },
					get = function(info) return Display.db.profile.TargetOrientation end,
					set = function(info, v)
						Display.db.profile.TargetOrientation = v
						Display:UpdateDisplay()
					end,
					order = 42,
					width = "double",
				},
				CCOHD = {
					type = "header",
					name =  "Color Options",
					width = "full",
					order = 42.9,
				},
				ColorCaster = {
					type = 'toggle',
					name =  "Class Color Casters Names",
					disabled = function() if Display.db.profile.CustomNameColor then return true else return false end end,
					desc =  "changes the names to the class colors",
					get = get,
					set = set,
					order = 43,
					width = "double",
				},	
				ColorTarget = {
					type = 'toggle',
					name =  "Class Color Target Names",		
					disabled = function() if Display.db.profile.CustomNameColor then return true else return false end end,
					desc =  "changes the names to the class colors",
					get = get,
					set = set,
					order = 44,
					width = "double",
				},
				BorderColor = {
					type = "toggle",	
					name =  "Custom Border Color",
					desc =  "this will change the color of the border around the bars",
					get = get,
					set = function(info, v)
						Display.db.profile.BorderColor = v
						Display:UpdateDisplay("yes")
					end,	
					order = 44.1,
					width = "double",
				},
				BGBorderColor = {
					type = "color",	
					name =  "Custom Border Color",
					disabled = function() if Display.db.profile.BorderColor then return false else return true end end,
					desc =  "this will change the color of the border",
					hasAlpha = true,
					get = function(info) return Display.db.profile.BGBorderColor["r"], Display.db.profile.BGBorderColor["g"], Display.db.profile.BGBorderColor["b"], Display.db.profile.BGBorderColor["a"] end,
					set = function(info, r, g, b, a)
						Display.db.profile.BGBorderColor["r"] = r
						Display.db.profile.BGBorderColor["g"] = g
						Display.db.profile.BGBorderColor["b"] = b
						Display.db.profile.BGBorderColor["a"] = a
						Display:UpdateDisplay("yes")
					end,
					order = 44.2,
					width = "double",
				},
				CustomNameColor = {
					type = "toggle",	
					name =  "Custom Name Color",
					desc =  "this will change the color of the bars from class to the set color",
					disabled = function() if Display.db.profile.ColorCaster or Display.db.profile.ColorTarget then return true else return false end end,
					get = get,
					set = set,
					order = 45,
					width = "double",
				},
				CustomNameColorPicked = {
					type = "color",	
					name =  "Custom Name Color",
					disabled = function() if Display.db.profile.CustomNameColor then return false else return true end end,
					desc =  "this will change the color of the bars from class to the set color",
					hasAlpha = true,
					get = function(info) return Display.db.profile.CustomNameColorPicked["r"], Display.db.profile.CustomNameColorPicked["g"], Display.db.profile.CustomNameColorPicked["b"], Display.db.profile.CustomNameColorPicked["a"] end,
					set = function(info, r, g, b, a)
						Display.db.profile.CustomNameColorPicked["r"] = r
						Display.db.profile.CustomNameColorPicked["g"] = g
						Display.db.profile.CustomNameColorPicked["b"] = b
						Display.db.profile.CustomNameColorPicked["a"] = a
					end,
					order = 46,
					width = "double",
				},
				EnableBGColor = {
					type = "toggle",	
					name =  "Custom Background Color",
					desc =  "this will change the color of the bars background",
					get = get,
					set = set,
					order = 46.1,
					width = "double",
				},
				BGColor = {
					type = "color",	
					name =  "Custom Background Color",
					disabled = function() if Display.db.profile.EnableBGColor then return false else return true end end,
					desc =  "this will change the color of the background to the set color",
					hasAlpha = true,
					get = function(info) return Display.db.profile.BGColor["r"], Display.db.profile.BGColor["g"], Display.db.profile.BGColor["b"], Display.db.profile.BGColor["a"] end,
					set = function(info, r, g, b, a)
						Display.db.profile.BGColor["r"] = r
						Display.db.profile.BGColor["g"] = g
						Display.db.profile.BGColor["b"] = b
						Display.db.profile.BGColor["a"] = a
						Display:UpdateDisplay("yes")
					end,
					order = 46.2,
					width = "double",
				},
				CustomBarColor = {
					type = "toggle",	
					name =  "Custom Bar Color",
					desc =  "this will change the color of the bars from class to the set color",
					get = get,
					set = set,
					order = 46.3,
					width = "double",
				},
				CustomBarColorPicked = {
					type = "color",	
					name =  "Custom Bar Color",
					disabled = function() if Display.db.profile.CustomBarColor then return false else return true end end,
					desc =  "this will change the color of the bars from class to the set color",
					hasAlpha = true,
					get = function(info) return Display.db.profile.CustomBarColorPicked["r"], Display.db.profile.CustomBarColorPicked["g"], Display.db.profile.CustomBarColorPicked["b"], Display.db.profile.CustomBarColorPicked["a"] end,
					set = function(info, r, g, b, a)
						Display.db.profile.CustomBarColorPicked["r"] = r
						Display.db.profile.CustomBarColorPicked["g"] = g
						Display.db.profile.CustomBarColorPicked["b"] = b
						Display.db.profile.CustomBarColorPicked["a"] = a
					end,
					order = 46.4,
					width = "double",
				},
				DAOHD = {
					type = "header",
					name =  "Disable Options",
					width = "full",
					order = 47,
				},
				unclickDes2 = {
					type = "description",
					name =  "If you are having problems with this addon you can try enabling the options below, If you are not having problems its best to have these options unticked.\n",
					width = "full",
					fontSize  = "medium",
					order = 48,
				},
				DisableSync = {
					type = 'toggle',
					name =  "Disable Sync",
					desc =  "Disable's the Sync to try and fix errors",
					get = function(info) return Display.db.profile.DisableSync end,
					set = function(info, v)
						Display.db.profile.DisableSync = v
					end,
					order = 49,
					width = "double",
				},
				DisableScan = {
					type = 'toggle',
					name =  "Disable Scan",
					desc =  "Disable's the built in scan for talents",
					get = function(info) return Display.db.profile.DisableScan end,
					set = function(info, v)
						Display.db.profile.DisableScan = v
					end,
					order = 50,
					width = "double",
				},
				Backupcdused = {
					type = 'toggle',
					name =  "Disable Backup Trigger",
					width = "double",
					desc =  "Disable's the built 2nd trigger for tracking spells.\n\nWarning: The 2nd trigger event does not have a target so the bar currently uses on the old target. better code maybe added in later updates",
					get = function(info) return Display.db.profile.Backupcdused end,
					set = function(info, v)
						Display.db.profile.Backupcdused = v
					end,
					order = 51,
					width = "double",
				},
				DisableClassStoreInfo = {
					type = 'toggle',
					name =  "Disable Class Storage Info",
					desc =  "Disable's the saving of players class info, good for pvp if you dont pvp disable this",
					get = function(info) return not Display.db.profile.StoreClaSSInfo end,
					set = function(info, v)
						Display.db.profile.StoreClaSSInfo = not v
					end,
					width = "double",
					order = 52,
				},
				DisableDeepClassScan = {
					type = 'toggle',
					name =  "Disable Deep Class Scan",
					desc =  "Disable's deeper scaning of class info, good for pvp if you dont pvp disable this",
					get = function(info) return not Display.db.profile.DeepClassScan end,
					set = function(info, v)
						Display.db.profile.DeepClassScan = not v
					end,
					width = "double",
					order = 53,
				},
			},
		},
		frames = {
			type = "group",
			name = "Frames",
			desc = "Configure Cooldown Frames",
			cmdHidden = true,
			order = 2,
			args = {
				frameCount = {
					type = "range",
					name = "Frame Count",
					desc =  "Allows you to create more frames. if this is disabled you need to unlock your frames in the General options tab",
					disabled = function() if not Display.db.profile.locked then return false elseif Display.db.profile.locked then return true end end,
					min = 1, max = 10, step = 1, bigStep = 1,
					get = get,
					set = function(t, value)
						Display.db.profile[t[#t]] = value
						FatCooldowns.RefreshFrameListOptionsAndVariables()
						Display:SetAnchors(true)
						Display:MissingSettings()
					end,
					order = 10,
					width = "double",
				},
				descr5 = {
					type = "description",
					name =  "If frames are disabled you will need to untick 'Lock Bars' in the General tab, on the left, to enable editing.\n",
					width = "full",
					fontSize  = "medium",
					order = 0.1,
				},	
				descrLMJ5 = {
					type = "description",
					name =  "\n\n",
					width = "full",
					fontSize  = "medium",
					order = 10.01,
				},	
				FH1 = {
					type = "header",
					name =  "Copy Settings From Frame 1 To Frame 2",
					width = "full",
					order = 10.1,
				},
				FrameX = {
					type = "select",
					name =  "Frame 1",
					values = function()
					local FrameXNames = {}
						for i = 1, 10, 1 do
							if i <= Display.db.profile.frameCount then
								if Display.db.profile.frames[i] then
									if Display.db.profile.frames[i].name ~= nil then
										FrameXNames[i] = Display.db.profile.frames[i].name
									end
								end
							end
						end
						return FrameXNames
					end,
					get = function(info) return TempFrameXNames end,
					set = function(info, v)	TempFrameXNames = v end,
					order = 11,
				},
				FrameZ = {
					type = "select",
					name =  "Frame 2",
					values = function()
					local FrameZNames = {}
						for i = 1, 10, 1 do
							if i <= Display.db.profile.frameCount then
								if Display.db.profile.frames[i] then
									if Display.db.profile.frames[i].name ~= nil then
										FrameZNames[i] = Display.db.profile.frames[i].name
									end
								end
							end
						end
						return FrameZNames
					end,
					get = function(info) return TempFrameZNames end,
					set = function(info, v)	TempFrameZNames = v end,
					order = 12,
				},
				IncSpells = {
					type = 'toggle',
					name =  "Inc Spells",
					desc =  "Include Spells to be copied",
					get = function(info) return TempFrameNamesSpells end,
					set = function(info, v)	TempFrameNamesSpells = v end,
					order = 12.5,
				},
				CopyButton = {
					type = "execute",
					name =  "Copy Settings",
					desc =  "Copys Settings from one from to an other frame",
					order = 13,
					func = function()
						if TempFrameXNames ~= nil and TempFrameZNames ~= nil and TempFrameXNames ~= TempFrameZNames then
							Display.db.profile.frames[TempFrameZNames].growUp = Display.db.profile.frames[TempFrameXNames].growUp
							Display.db.profile.frames[TempFrameZNames].hideSelf = Display.db.profile.frames[TempFrameXNames].hideSelf
							Display.db.profile.frames[TempFrameZNames].readyMsg = Display.db.profile.frames[TempFrameXNames].readyMsg
							Display.db.profile.frames[TempFrameZNames].scale = Display.db.profile.frames[TempFrameXNames].scale
							Display.db.profile.frames[TempFrameZNames].alpha = Display.db.profile.frames[TempFrameXNames].alpha
							Display.db.profile.frames[TempFrameZNames].width = Display.db.profile.frames[TempFrameXNames].width
							Display.db.profile.frames[TempFrameZNames].fontsize = Display.db.profile.frames[TempFrameXNames].fontsize
							Display.db.profile.frames[TempFrameZNames].height = Display.db.profile.frames[TempFrameXNames].height
							Display.db.profile.frames[TempFrameZNames].maxTextLength = Display.db.profile.frames[TempFrameXNames].maxTextLength
							Display.db.profile.frames[TempFrameZNames].permanent = Display.db.profile.frames[TempFrameXNames].permanent
							Display.db.profile.frames[TempFrameZNames].anchor = Display.db.profile.frames[TempFrameXNames].anchor
							Display.db.profile.frames[TempFrameZNames].hideFrame = Display.db.profile.frames[TempFrameXNames].hideFrame
							Display.db.profile.frames[TempFrameZNames].hidetarget = Display.db.profile.frames[TempFrameXNames].hidetarget
							Display.db.profile.frames[TempFrameZNames].RaidMsg = Display.db.profile.frames[TempFrameXNames].RaidMsg
							Display.db.profile.frames[TempFrameZNames].UsedMsg = Display.db.profile.frames[TempFrameXNames].UsedMsg
							Display.db.profile.frames[TempFrameZNames].HideLabel = Display.db.profile.frames[TempFrameXNames].HideLabel
							Display.db.profile.frames[TempFrameZNames].EnemyFCDCaster = Display.db.profile.frames[TempFrameXNames].EnemyFCDCaster
							Display.db.profile.frames[TempFrameZNames].FriendlyCaster = Display.db.profile.frames[TempFrameXNames].FriendlyCaster
							Display.db.profile.frames[TempFrameZNames].SpellNameLabel = Display.db.profile.frames[TempFrameXNames].SpellNameLabel
							Display.db.profile.frames[TempFrameZNames].onlySelf = Display.db.profile.frames[TempFrameXNames].onlySelf
							if TempFrameNamesSpells then Display.db.profile.frames[TempFrameZNames].spells = Display.db.profile.frames[TempFrameXNames].spells end

							TempFrameXNames = nil
							TempFrameZNames = nil
							FatCooldowns.RefreshFrameListOptionsAndVariables()
						end
					end,
					confirm = true
				},
			},
		},
		spellOrder = {
			type = "group",
			name = "Spell Order",
			desc = "Configure the order in which spells are displayed",
			cmdHidden = true,
			order = 3,
			args = {
				descr = {
					type = "description",
					name =  "Select which spells should have modified priority over the default (class > spellid > caster > cooldown) sorting attributes.",
					width = "full",
					fontSize  = "medium",
					order = 1,
				},
				spells = {
					type = "group",
					name = "Spell priorities",
					desc = "Set priorities of selected spells",
					cmdHidden = true,
					order = 2,
					args = {
						descr = {
							type = "description",
							name =  "All unselected spells have priority 500 - select higher or lower to move your spell higher or lower in priority list.",
							width = "full",
							fontSize  = "medium",
							order = 1,
						},
					},
				},
			},
		},
		soundspells = {
			type = "group",
			name = "Spells Sounds",
			desc = "Configure Spells Sounds Options",
			cmdHidden = true,
			order = 4,
			args = {
				descr = {
					type = "description",
					name =  "Select which Spells Sounds you would like to enable.",
					width = "full",
					fontSize  = "medium",
					order = 1,
				},
				soundspellsoptions = {
					type = "group",
					name = "Spell Sound Options",
					desc = "Set options for each spell sound",
					cmdHidden = true,
					order = 2,
					args = {
						descr = {
							type = "description",
							name =  "Select which options you would like to enable for each sound",
							width = "full",
							fontSize  = "medium",
							order = 1,
						},
					}
				},				
			},
		},
		SpellsReporter = {
			type = "group",
			name = "Spells Reporter",
			desc = "Configure Spells Reporter Options",
			cmdHidden = true,
			order = 4.5,
			args = {
				descr = {
					type = "description",
					name =  "Select which Spells Reporter you would like to report, you will need to be raid leader/assist to report in raid chat.",
					width = "full",
					fontSize  = "medium",
					order = 1,
				},			
			},
		},
		ButtonClicks = {
			type = "group",
			name = "Button Clicks",
			desc = "Configure Button Clicks Options",
			cmdHidden = true,
			order = 5,
			args = {
				resetbutton = {
					type = "execute",
					name =  "Rest Clicks to Defualt",
					desc =  "Rests all button clicks to there default option",
					order = 0.7,
					func = function()
						Display.db.profile.LClick = 1
						Display.db.profile.RClick = 1
						Display.db.profile.MClick = 1
						Display.db.profile.SLClick = 2
						Display.db.profile.SRClick = 3
						Display.db.profile.SMClick = 4
						Display.db.profile.ALClick = 6
						Display.db.profile.ARClick = 7
						Display.db.profile.AMClick = 5
					end,
					width = "double",
					confirm = true
				},
				unclickable = {
					type = 'toggle',
					name =  "Make bars unclickable",
					desc =  "Disables right clicks on cooldown bars.",
					width = "double",
					get = function(info) return Display.db.profile.unclickable end,
					set = function(info, v)
						Display.db.profile.unclickable = v
						Display:ClickableChange()
					end,
					order = 0.8,
				},
				BH1 = {
					type = "header",
					name =  "",
					width = "full",
					order = 0.9,
				},
				LClick = {
					type = "select",
					name =  "Left-Click",
					values = { "None", "Report Cooldown to Raid", "Whisper Cooldown to Caster", "List Ready Cooldowns to Raid", "List Not Ready Cooldowns to Raid", "Report Last Target", "Remove Bar"},
					get = function(info) return Display.db.profile.LClick end,
					set = function(info, v)	Display.db.profile.LClick = v end,
					order = 1,
					width = "double",
				},
				RClick = {
					type = "select",
					name =  "Right-Click",
					values = { "None", "Report Cooldown to Raid", "Whisper Cooldown to Caster", "List Ready Cooldowns to Raid", "List Not Ready Cooldowns to Raid", "Report Last Target", "Remove Bar"},
					get = function(info) return Display.db.profile.RClick end,
					set = function(info, v)	Display.db.profile.RClick = v end,
					order = 2,
					width = "double",
				},
				MClick = {
					type = "select",
					name =  "Middle-Click",
					values = { "None", "Report Cooldown to Raid", "Whisper Cooldown to Caster", "List Ready Cooldowns to Raid", "List Not Ready Cooldowns to Raid", "Report Last Target", "Remove Bar"},
					get = function(info) return Display.db.profile.MClick end,
					set = function(info, v)	Display.db.profile.MClick = v end,
					order = 3,
					width = "double",
				},
				BH2 = {
					type = "header",
					name =  "",
					width = "full",
					order = 3.9,
				},
				SLClick = {
					type = "select",
					name =  "Shift-Left-Click",
					values = { "None", "Report Cooldown to Raid", "Whisper Cooldown to Caster", "List Ready Cooldowns to Raid", "List Not Ready Cooldowns to Raid", "Report Last Target", "Remove Bar"},
					get = function(info) return Display.db.profile.SLClick end,
					set = function(info, v)	Display.db.profile.SLClick = v end,
					order = 4,
					width = "double",
				},
				SRClick = {
					type = "select",
					name =  "Shift-Right-Click",
					values = { "None", "Report Cooldown to Raid", "Whisper Cooldown to Caster", "List Ready Cooldowns to Raid", "List Not Ready Cooldowns to Raid", "Report Last Target", "Remove Bar"},
					get = function(info) return Display.db.profile.SRClick end,
					set = function(info, v)	Display.db.profile.SRClick = v end,
					order = 5,
					width = "double",
				},
				SMClick = {
					type = "select",
					name =  "Shift-Middle-Click",
					values = { "None", "Report Cooldown to Raid", "Whisper Cooldown to Caster", "List Ready Cooldowns to Raid", "List Not Ready Cooldowns to Raid", "Report Last Target", "Remove Bar"},
					get = function(info) return Display.db.profile.SMClick end,
					set = function(info, v)	Display.db.profile.SMClick = v end,
					order = 6,
					width = "double",
				},
				BH3 = {
					type = "header",
					name =  "",
					width = "full",
					order = 6.9,
				},
				ALClick = {
					type = "select",
					name =  "Alt-Left-Click",
					values = { "None", "Report Cooldown to Raid", "Whisper Cooldown to Caster", "List Ready Cooldowns to Raid", "List Not Ready Cooldowns to Raid", "Report Last Target", "Remove Bar"},
					get = function(info) return Display.db.profile.ALClick end,
					set = function(info, v)	Display.db.profile.ALClick = v end,
					order = 7,
					width = "double",
				},
				ARClick = {
					type = "select",
					name =  "Alt-Right-Click",
					values = { "None", "Report Cooldown to Raid", "Whisper Cooldown to Caster", "List Ready Cooldowns to Raid", "List Not Ready Cooldowns to Raid", "Report Last Target", "Remove Bar"},
					get = function(info) return Display.db.profile.ARClick end,
					set = function(info, v)	Display.db.profile.ARClick = v end,
					order = 8,
					width = "double",
				},
				AMClick = {
					type = "select",
					name =  "Alt-Middle-Click",
					values = { "None", "Report Cooldown to Raid", "Whisper Cooldown to Caster", "List Ready Cooldowns to Raid", "List Not Ready Cooldowns to Raid", "Report Last Target", "Remove Bar"},
					get = function(info) return Display.db.profile.AMClick end,
					set = function(info, v)	Display.db.profile.AMClick = v end,
					order = 9,
					width = "double",
				},
			},
		},
		DisabledGroup1 = {
			type = "group",
			name = "-------------------",
			desc = "Spliter",
			cmdHidden = true,
			disabled = function() return true end,
			order = 5.1,
			args = {	
			},
		},	
		RaidLeader = {
			type = "group",
			name = "Leader",
			childGroups = "tab",
			desc = "Configure Raid Leader Options",
			cmdHidden = true,
			order = 5.2,
			args = {
				OT1 = {
					type = "group",
					name = "Icon Control",
					desc = "Configure Icon Control Options",
					order = 1,
					args = {
						descr = {
							type = "description",
							name =  "The Auto Icon Valk/Frostmourne Features will not remove icons from people and will not replace an icons already on a person.\nNote: DBM will place Circle, Diamond and Triangle on the valks its best not to use these icons for the valk stacking point.\n",
							width = "full",
							fontSize  = "medium",
							order = 1.11,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
						},
						AutoIconValk = {
							type = "toggle",
							name =  "Auto Icon Valk Stacking",
							desc =  "Auto adds icon to a player for stacking on valks on HC\n\nNote: if icon is already on someone it will not remove and if you want the icon to always be on yourself you can set the Player Name to player",
							get = function(info) return Display.db.profile.AutoIconValk end,
							set = function(info, v)	Display.db.profile.AutoIconValk = v	end,
							order = 1.2,
							width = "double",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
						},
						AutoIconValkName = {
							type = "select",
							name =  "Player Name",
							values = function(info)	return RaidPlayersNames() end,
							disabled = function() if Display.db.profile.AutoIconValk then return false elseif not Display.db.profile.AutoIconValk then return true end end,
							desc = "Enter the name of the player you would like to place the icon on, if you always want to stack on yourself then you can enter player instead of your name",
							get = function(v) return Display.db.profile.AutoIconValkName end,
							set = function(info, v) Display.db.profile.AutoIconValkName = v end,
							order = 1.3,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
						},
						AutoIconValkIcon = {
							type = "select",
							name =  "Icon",
							disabled = function() if Display.db.profile.AutoIconValk then return false elseif not Display.db.profile.AutoIconValk then return true end end,
							values = { 
								[1] = "|cFF9d9d9dDefualt|r",
								[2] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t |CFFFFF468Star|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t",
								[3] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t |CFFFF7C0ACircle|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t",
								[4] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t |CFFA330C9Diamond|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t",
								[5] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t |CFFAAD372Triangle|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t",
								[6] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t |CFFE5E5E5Moon|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t",
								[7] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t |CFF0070DDSquare|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t",
								[8] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t |CFFC41E3ACross|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t",
								[9] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t Skull |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t"},
							get = function(info) return Display.db.profile.AutoIconValkIcon end,
							set = function(info, v)	Display.db.profile.AutoIconValkIcon = v end,
							order = 1.4,
							--width = "half",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
						},
						fontDel4 = {
							type = "header",
							name =  "",
							width = "full",
							order = 1.5,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
						},
						AutoIconFrostmourne = {
							type = "toggle",
							name =  "Auto Icon Frostmourne Stacking",
							desc =  "Auto adds icon to a player for stacking on Frostmourne on HC\n\nNote: if icon is already on someone it will not remove and if you want the icon to always be on yourself you can set the 'Player Name' to player",
							get = function(info) return Display.db.profile.AutoIconFrostmourne end,
							set = function(info, v) Display.db.profile.AutoIconFrostmourne = v end,
							order = 1.6,
							width = "double",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
						},
						AutoIconFrostmourneName = {
							type = "select",
							name =  "Player Name",
							values = function(info)	return RaidPlayersNames() end,disabled = function() if Display.db.profile.AutoIconValk then return false elseif not Display.db.profile.AutoIconValk then return true end end,
							desc = "Enter the name of the player you would like to place the icon on, if you always want to stack on yourself then you can enter player instead of your name",
							disabled = function() if Display.db.profile.AutoIconFrostmourne then return false elseif not Display.db.profile.AutoIconFrostmourne then return true end end,
							get = function(v) return Display.db.profile.AutoIconFrostmourneName end,
							set = function(info, v) Display.db.profile.AutoIconFrostmourneName = v end,
							order = 1.7,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
						},
						AutoIconFrostmourneIcon = {
							type = "select",
							name =  "Icon",
							disabled = function() if Display.db.profile.AutoIconFrostmourne then return false elseif not Display.db.profile.AutoIconFrostmourne then return true end end,
							values = { 
								[1] = "|cFF9d9d9dNone|r",
								[2] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t |CFFFFF468Star|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t",
								[3] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t |CFFFF7C0ACircle|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t",
								[4] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t |CFFA330C9Diamond|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t",
								[5] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t |CFFAAD372Triangle|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t",
								[6] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t |CFFE5E5E5Moon|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t",
								[7] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t |CFF0070DDSquare|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t",
								[8] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t |CFFC41E3ACross|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t",
								[9] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t Skull |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t"},
							get = function(info) return Display.db.profile.AutoIconFrostmourneIcon end,
							set = function(info, v)	Display.db.profile.AutoIconFrostmourneIcon = v end,
							order = 1.9,
							--width = "half",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
						},
						fontDel5 = {
							type = "header",
							name =  "",
							width = "full",
							order = 1.901,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
						},
						KeepIcon1Toggle = {
							type = "toggle",
							name =  "Icon Control 1",
							desc =  "Keeps the selected icon on the named player\n\nNote: if icon 1 and 2 are the same this will disable this function",
							get = function(info) return Display.db.profile.KeepIcon1Toggle end,
							set = function(info, v) Display.db.profile.KeepIcon1Toggle = v end,
							order = 1.91,
							width = "double",
						},
						KeepIcon1 = {
							type = "select",
							name =  "Placement",
							values = function(info)	return RaidPlayersNames(true) end,
							get = function(info) return Display.db.profile.KeepIcon1 end,
							set = function(info, v)	Display.db.profile.KeepIcon1 = v end,
							disabled = function() if Display.db.profile.KeepIcon1Toggle then return false elseif not Display.db.profile.KeepIcon1Toggle then return true end end,
							order = 1.92,
						},
						KeepIcon1Icon = {
							type = "select",
							name =  "Icon",
							values = { 
								[1] = "|cFF9d9d9dNone|r",
								[2] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t |CFFFFF468Star|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t",
								[3] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t |CFFFF7C0ACircle|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t",
								[4] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t |CFFA330C9Diamond|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t",
								[5] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t |CFFAAD372Triangle|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t",
								[6] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t |CFFE5E5E5Moon|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t",
								[7] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t |CFF0070DDSquare|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t",
								[8] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t |CFFC41E3ACross|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t",
								[9] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t Skull |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t"},
							get = function(info) return Display.db.profile.KeepIcon1Icon end,
							set = function(info, v)	Display.db.profile.KeepIcon1Icon = v end,
							disabled = function() if Display.db.profile.KeepIcon1Toggle then return false elseif not Display.db.profile.KeepIcon1Toggle then return true end end,
							order = 1.93,
							--width = "half",
						},
						KeepIcon1InRaid = {
							type = "toggle",
							name =  "Player: In Raid",
							desc =  "Places icons only when player is in a raid",
							get = function(info) return Display.db.profile.KeepIcon1InRaid end,
							set = function(info, v) if v == true then Display.db.profile.KeepIcon1NotInRaid = false end Display.db.profile.KeepIcon1InRaid = v end,
							hidden = function() if not Display.db.profile.KeepIcon1Toggle or Display.db.profile.KeepIcon1 == nil then return true else return false end end,
							order = 1.93001,
						},
						KeepIcon1NotInRaid = {
							type = "toggle",
							name =  "Player: Not In Raid",
							desc =  "Places icons only when player is not in a raid",
							get = function(info) return Display.db.profile.KeepIcon1NotInRaid end,
							set = function(info, v) if v == true then Display.db.profile.KeepIcon1InRaid = false end Display.db.profile.KeepIcon1NotInRaid = v end,
							hidden = function() if not Display.db.profile.KeepIcon1Toggle or Display.db.profile.KeepIcon1 == nil then return true else return false end end,
							order = 1.93002,
						},
						KeepIcon1Boss = {
							type = "toggle",
							name =  "Boss Fight",
							desc =  "Places icons only when player is in a boss fight",
							get = function(info) return Display.db.profile.KeepIcon1Boss end,
							set = function(info, v) if v == true then Display.db.profile.KeepIcon1NoBoss = false end Display.db.profile.KeepIcon1Boss = v end,
							hidden = function() if not Display.db.profile.KeepIcon1Toggle or Display.db.profile.KeepIcon1 == nil then return true else return false end end,
							order = 1.93003,
						},
						KeepIcon1NoBoss = {
							type = "toggle",
							name =  "Not Boss Fight",
							desc =  "Places icons only when player is not in a boss fight",
							get = function(info) return Display.db.profile.KeepIcon1NoBoss end,
							set = function(info, v) if v == true then Display.db.profile.KeepIcon1Boss = false end Display.db.profile.KeepIcon1NoBoss = v end,
							hidden = function() if not Display.db.profile.KeepIcon1Toggle or Display.db.profile.KeepIcon1 == nil then return true else return false end end,
							order = 1.93004,
						},
						KeepIcon1Tank = {
							type = "toggle",
							name =  "Player: Tank",
							desc =  "Places icons only when player is a tank",
							get = function(info) return Display.db.profile.KeepIcon1Tank end,
							set = function(info, v) Display.db.profile.KeepIcon1Tank = v end,
							hidden = function() if not Display.db.profile.KeepIcon1Toggle or Display.db.profile.KeepIcon1 == nil or Display.db.profile.KeepIcon1 ~= "Target" then return true else return false end end,
							order = 1.9301,
						},
						KeepIcon1Healer = {
							type = "toggle",
							name =  "Player: Healer",
							desc =  "Places icons only when player is a healer",
							get = function(info) return Display.db.profile.KeepIcon1Healer end,
							set = function(info, v) Display.db.profile.KeepIcon1Healer = v end,
							hidden = function() if not Display.db.profile.KeepIcon1Toggle or Display.db.profile.KeepIcon1 == nil or Display.db.profile.KeepIcon1 ~= "Target" then return true else return false end end,
							order = 1.9302,
						},	
						KeepIcon1DPS = {
							type = "toggle",
							name =  "Player: DPS",
							desc =  "Places icons only when player is a dps",
							get = function(info) return Display.db.profile.KeepIcon1DPS end,
							set = function(info, v) Display.db.profile.KeepIcon1DPS = v end,
							hidden = function() if not Display.db.profile.KeepIcon1Toggle or Display.db.profile.KeepIcon1 == nil or Display.db.profile.KeepIcon1 ~= "Target" then return true else return false end end,
							order = 1.9303,
						},
						KeepIcon1Hostile = {
							type = "toggle",
							name =  "Hostile Targets Only",
							desc =  "Places icons on Hostile targets only",
							get = function(info) return Display.db.profile.KeepIcon1Hostile end,
							set = function(info, v) Display.db.profile.KeepIcon1Hostile = v end,
							hidden = function() if not Display.db.profile.KeepIcon1Toggle or Display.db.profile.KeepIcon1 == nil or Display.db.profile.KeepIcon1 ~= "Target" then return true else return false end end,
							order = 1.9304,
						},
						KeepIcon1TargetNames = {
							type = "range",
							name =  "Enable Target Names",
							min = 0, max = 20, step = 1, bigStep = 1,
							desc =  "Places icons on targets that mach the names below",
							get = function(info) return Display.db.profile.KeepIcon1TargetNames end,
							set = function(info, v) Display.db.profile.KeepIcon1TargetNames = v FatCooldowns.RefreshFrameListOptionsAndVariables() end,
							hidden = function() if not Display.db.profile.KeepIcon1Toggle or Display.db.profile.KeepIcon1 == nil or Display.db.profile.KeepIcon1 ~= "Target" then return true else return false end end,
							order = 1.9305,
							width = "full",
						},
						fontDel6 = {
							type = "header",
							name =  "",
							width = "full",
							order = 1.931,
						},
						KeepIcon2Toggle = {
							type = "toggle",
							name =  "Icon Control 2",
							desc =  "Keeps the selected icon on the named player\n\nNote: if icon 1 and 2 are the same this will disable this function",
							get = function(info) return Display.db.profile.KeepIcon2Toggle end,
							set = function(info, v) Display.db.profile.KeepIcon2Toggle = v end,
							order = 1.94,
							width = "double",
						},
						KeepIcon2 = {
							type = "select",
							name =  "Placement",
							values = function(info)	return RaidPlayersNames(true) end,
							get = function(info) return Display.db.profile.KeepIcon2 end,
							set = function(info, v)	Display.db.profile.KeepIcon2 = v end,
							disabled = function() if Display.db.profile.KeepIcon2Toggle then return false elseif not Display.db.profile.KeepIcon2Toggle then return true end end,
							order = 1.95,
						},
						KeepIcon2Icon = {
							type = "select",
							name =  "Icon",
							values = { 
								[1] = "|cFF9d9d9dNone|r",
								[2] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t |CFFFFF468Star|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t",
								[3] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t |CFFFF7C0ACircle|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t",
								[4] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t |CFFA330C9Diamond|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t",
								[5] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t |CFFAAD372Triangle|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t",
								[6] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t |CFFE5E5E5Moon|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t",
								[7] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t |CFF0070DDSquare|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t",
								[8] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t |CFFC41E3ACross|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t",
								[9] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t Skull |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t"},
							get = function(info) return Display.db.profile.KeepIcon2Icon end,
							set = function(info, v)	Display.db.profile.KeepIcon2Icon = v end,
							disabled = function() if Display.db.profile.KeepIcon2Toggle then return false elseif not Display.db.profile.KeepIcon2Toggle then return true end end,
							order = 1.96,
							--width = "half",
						},	
						KeepIcon2InRaid = {
							type = "toggle",
							name =  "Player: In Raid",
							desc =  "Places icons only when player is in a raid",
							get = function(info) return Display.db.profile.KeepIcon2InRaid end,
							set = function(info, v) if v == true then Display.db.profile.KeepIcon2NotInRaid = false end Display.db.profile.KeepIcon2InRaid = v end,
							hidden = function() if not Display.db.profile.KeepIcon2Toggle or Display.db.profile.KeepIcon2 == nil then return true else return false end end,
							order = 1.96001,
						},
						KeepIcon2NotInRaid = {
							type = "toggle",
							name =  "Player: Not In Raid",
							desc =  "Places icons only when player is not in a raid",
							get = function(info) return Display.db.profile.KeepIcon2NotInRaid end,
							set = function(info, v) if v == true then Display.db.profile.KeepIcon2InRaid = false end Display.db.profile.KeepIcon2NotInRaid = v end,
							hidden = function() if not Display.db.profile.KeepIcon2Toggle or Display.db.profile.KeepIcon2 == nil then return true else return false end end,
							order = 1.96002,
						},
						KeepIcon2Boss = {
							type = "toggle",
							name =  "Boss Fight",
							desc =  "Places icons only when player is in a boss fight",
							get = function(info) return Display.db.profile.KeepIcon2Boss end,
							set = function(info, v) if v == true then Display.db.profile.KeepIcon2NoBoss = false end Display.db.profile.KeepIcon2Boss = v end,
							hidden = function() if not Display.db.profile.KeepIcon2Toggle or Display.db.profile.KeepIcon2 == nil then return true else return false end end,
							order = 1.96003,
						},
						KeepIcon2NoBoss = {
							type = "toggle",
							name =  "Not Boss Fight",
							desc =  "Places icons only when player is not in a boss fight",
							get = function(info) return Display.db.profile.KeepIcon2NoBoss end,
							set = function(info, v) if v == true then Display.db.profile.KeepIcon2Boss = false end Display.db.profile.KeepIcon2NoBoss = v end,
							hidden = function() if not Display.db.profile.KeepIcon2Toggle or Display.db.profile.KeepIcon2 == nil then return true else return false end end,
							order = 1.96004,
						},
						KeepIcon2Tank = {
							type = "toggle",
							name =  "Player: Tank",
							desc =  "Places icons only when player is a tank",
							get = function(info) return Display.db.profile.KeepIcon2Tank end,
							set = function(info, v) Display.db.profile.KeepIcon2Tank = v end,
							hidden = function() if not Display.db.profile.KeepIcon2Toggle or Display.db.profile.KeepIcon2 == nil or Display.db.profile.KeepIcon2 ~= "Target" then return true else return false end end,
							order = 1.9601,
						},
						KeepIcon2Healer = {
							type = "toggle",
							name =  "Player: Healer",
							desc =  "Places icons only when player is a healer",
							get = function(info) return Display.db.profile.KeepIcon2Healer end,
							set = function(info, v) Display.db.profile.KeepIcon2Healer = v end,
							hidden = function() if not Display.db.profile.KeepIcon2Toggle or Display.db.profile.KeepIcon2 == nil or Display.db.profile.KeepIcon2 ~= "Target" then return true else return false end end,
							order = 1.9602,
						},	
						KeepIcon2DPS = {
							type = "toggle",
							name =  "Player: DPS",
							desc =  "Places icons only when player is a dps",
							get = function(info) return Display.db.profile.KeepIcon2DPS end,
							set = function(info, v) Display.db.profile.KeepIcon2DPS = v end,
							hidden = function() if not Display.db.profile.KeepIcon2Toggle or Display.db.profile.KeepIcon2 == nil or Display.db.profile.KeepIcon2 ~= "Target" then return true else return false end end,
							order = 1.9603,
						},
						KeepIcon2Hostile = {
							type = "toggle",
							name =  "Hostile Targets Only",
							desc =  "Places icons on Hostile targets only",
							get = function(info) return Display.db.profile.KeepIcon2Hostile end,
							set = function(info, v) Display.db.profile.KeepIcon2Hostile = v end,
							hidden = function() if not Display.db.profile.KeepIcon2Toggle or Display.db.profile.KeepIcon2 == nil or Display.db.profile.KeepIcon2 ~= "Target" then return true else return false end end,
							order = 1.9604,
						},
						KeepIcon2TargetNames = {
							type = "range",
							name =  "Enable Target Names",
							min = 0, max = 20, step = 1, bigStep = 1,
							desc =  "Places icons on targets that mach the names below",
							get = function(info) return Display.db.profile.KeepIcon2TargetNames end,
							set = function(info, v) Display.db.profile.KeepIcon2TargetNames = v FatCooldowns.RefreshFrameListOptionsAndVariables() end,
							hidden = function() if not Display.db.profile.KeepIcon2Toggle or Display.db.profile.KeepIcon2 == nil or Display.db.profile.KeepIcon2 ~= "Target" then return true else return false end end,
							order = 1.9605,
							width = "full",
						},
					},
				},
				OT2 = {
					type = "group",
					name = "Loot Changer",
					desc = "Configure Loot Changer Options",
					order = 2,
					args = {
						descr = {
							type = "description",
							name =  "Auto Change the loot settings when your the raid leader. You will need to be the raid leader. Changing to ML will only work when your inside a boss fight and the boss shows up in the boss frame.\n",
							width = "full",
							fontSize  = "medium",
							order = 1.11,
						},
						GLOnBoss = {
							type = "toggle",
							name =  "Auto Group Loot",
							desc =  "Auto Changes the Loot to Group Loot after a boss fight.",
							get = function(info) return Display.db.profile.GLOnBoss end,
							set = function(info, v) Display.db.profile.GLOnBoss = v end,
							order = 2,
							width = "double",
						},
						MLOnBoss = {
							type = "toggle",
							name =  "Auto Master Loot",
							desc =  "Auto Changes the Loot to Master Loot when in a boss fight.",
							get = function(info) return Display.db.profile.MLOnBoss end,
							set = function(info, v) Display.db.profile.MLOnBoss = v end,
							order = 3,
							width = "double",
						},
						GLOnBossTH = {
							type = "select",
							name =  "Group Loot Threshold",
							values = { [2] = "|cff1eff00Uncommon|r", [3] = "|cff0070ddRare|r", [4] = "|cffa335eeEpic|r"},
							get = function(info) return Display.db.profile.GLOnBossTH end,
							set = function(info, v)	Display.db.profile.GLOnBossTH = v end,
							order = 5,
						},
						MLOnBossTH = {
							type = "select",
							name =  "Master Loot Threshold",
							values = { [2] = "|cff1eff00Uncommon|r", [3] = "|cff0070ddRare|r", [4] = "|cffa335eeEpic|r"},
							get = function(info) return Display.db.profile.MLOnBossTH end,
							set = function(info, v)	Display.db.profile.MLOnBossTH = v end,
							order = 6,
						},
						MLOnBossName = {
							type = "select",
							name =  "Master Looter Player Name",
							values = function(info)	return RaidPlayersNames() end,
							get = function(info) return Display.db.profile.MLOnBossName end,
							set = function(info, v)	Display.db.profile.MLOnBossName = v end,
							disabled = function() if Display.db.profile.MLOnBoss then return false elseif not Display.db.profile.MLOnBoss then return true end end,
							order = 6.01,
							width = "double",
						},	
						descr = {
							type = "header",
							name =  "Instance Limiter",
							width = "full",
							order = 6.1,
						},
						LCLICC = {
							type = "toggle",
							name =  "ICC",
							desc =  "Auto Changes loot only when inside ICC",
							get = function(info) return Display.db.profile.LCLICC end,
							set = function(info, v) Display.db.profile.LCLICC = v end,
							order = 6.2,
						},	
						LCLRS = {
							type = "toggle",
							name =  "RS",
							desc =  "Auto Changes loot only when inside RS",
							get = function(info) return Display.db.profile.LCLRS end,
							set = function(info, v) Display.db.profile.LCLRS = v end,
							order = 6.3,
						},	
						LCLNaxx = {
							type = "toggle",
							name =  "Naxx",
							desc =  "Auto Changes loot only when inside NAXX",
							get = function(info) return Display.db.profile.LCLNaxx end,
							set = function(info, v) Display.db.profile.LCLNaxx = v end,
							order = 6.4,
						},	
						LCLULD = {
							type = "toggle",
							name =  "Ulduar",
							desc =  "Auto Changes loot only when inside Ulduar",
							get = function(info) return Display.db.profile.LCLULD end,
							set = function(info, v) Display.db.profile.LCLULD = v end,
							order = 6.5,
						},	
						MLGLDelay = {
							type = "range",
							name =  "Loot Change Delay",
							desc = "set the delay timer for changing back to group loot\n\nNote: the delay is so you can loot the boss, Defualt is 40 seconds.",
							min = 1, max = 120, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.MLGLDelay end,
							set = function(info, v)	Display.db.profile.MLGLDelay = v end,
							order = 9,
							width = "full",
						},
					},
				},	
				OT3 = {
					type = "group",
					name = "ML Window",
					desc = "Configure ML Window Options",
					order = 3,
					args = {	
						descr = {
							type = "description",
							name =  "Change the default ML Window to one of the options below.\n",
							width = "full",
							fontSize  = "medium",
							order = 1.11,
						},					
						CustomMasterLooterWindow = {
							type = "toggle",
							name =  "Custom Master Looter Window V1",
							desc =  "Changes the master looter window to color in players names and add Raid tab",
							disabled = function() if Display.db.profile.CustomMasterLooterWindowV2 then Display.db.profile.CustomMasterLooterWindow = false return true else return false end end,
							get = get,
							set = function(info, v)
								Display.db.profile.CustomMasterLooterWindow = v
								Display:CMasterLooterWindow()
							end,
							order = 1.992,
							width = "double",
						},	
						CustomMasterLooterWindowV2 = {
							type = "toggle",
							name =  "Custom Master Looter Window V2",
							desc =  "Changes the master looter window removing groups and coloring in players names",
							disabled = function() if Display.db.profile.CustomMasterLooterWindow then Display.db.profile.CustomMasterLooterWindowV2 = false return true else return false end end,
							get = get,
							set = function(info, v)
								Display.db.profile.CustomMasterLooterWindowV2 = v
								Display:CMasterLooterWindow()
							end,
							order = 1.99201,
							width = "double",
						},	
						CMLDT = {
							type = "description",
							name = "\n",
							width = "full",
							fontSize  = "medium",
							order = 1.99202,
						},
						CMLD = {
							type = "description",
							name = "",
							image = "Interface\\AddOns\\FatCooldowns\\icons\\CMLWindow",
							imageWidth = 360,
							imageHeight = 180,
							width = "full",
							fontSize  = "medium",
							order = 1.99203,
						},
					},
				},
				OT4 = {
					type = "group",
					name = "ML Looter",
					desc = "Configure ML Looter Options",
					order = 4,
					args = {	
						descr = {
							type = "description",
							name =  "Auto loot the items when your the ML.\n",
							width = "full",
							fontSize  = "medium",
							order = 1.11,
						},	
						MLAutoLoot = {
							type = "toggle",
							name =  "Enable Master Looter Auto Loot",
							desc =  "Auto loot items when you are the master looter. \n\nNote: Holding Shift will stop auto loot",
							get = function(info) return Display.db.profile.MLAutoLoot end,
							set = function(info, v) Display.db.profile.MLAutoLoot = v end,
							order = 2,
							width = "double",
						},
						descr = {
							type = "header",
							name =  "Instance Limiter",
							width = "full",
							order = 2.1,
						},
						MLLICC = {
							type = "toggle",
							name =  "ICC",
							desc =  "Limits the Auto Master Looter for when you are in ICC",
							get = function(info) return Display.db.profile.MLLICC end,
							set = function(info, v) Display.db.profile.MLLICC = v end,
							order = 2.2,
						},	
						MLLRS = {
							type = "toggle",
							name =  "RS",
							desc =  "Limits the Auto Master Looter for when you are in RS",
							get = function(info) return Display.db.profile.MLLRS end,
							set = function(info, v) Display.db.profile.MLLRS = v end,
							order = 2.3,
						},	
						MLLNaxx = {
							type = "toggle",
							name =  "Naxx",
							desc =  "Limits the Auto Master Looter for when you are in NAXX",
							get = function(info) return Display.db.profile.MLLNaxx end,
							set = function(info, v) Display.db.profile.MLLNaxx = v end,
							order = 2.4,
						},	
						MLLULD = {
							type = "toggle",
							name =  "Ulduar",
							desc =  "Limits the Auto Master Looter for when you are in Ulduar",
							get = function(info) return Display.db.profile.MLLULD end,
							set = function(info, v) Display.db.profile.MLLULD = v end,
							order = 2.5,
						},	
						MLQuality = {
							type = "multiselect",
							name =  "Loot Quality",
							desc =  "Select the quality of loot to auto loot.",
							values = { [1] = "|cff9d9d9dPoor|r", [2] = "|cffffffffCommon|r", [3] = "|cff1eff00Uncommon|r", [4] = "|cff0070ddRare|r", [5] = "|cffa335eeEpic|r", [6] = "|cffff8000Legendary|r"},
							get = function(info, v)	return Display.db.profile.MLQuality[v] end,
							set = function(info, v, v2) Display.db.profile.MLQuality[v] = v2 end,
							order = 3,
						},
						AddLootMLList = {
							type = "input",
							name =  "Add Item To Master Looter Blacklist",
							get = function(info) return nil end,
							set = function(info, v) 
								if v == nil then return end
								if not v:find("item:[%d]+") then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter a Item Link") end
								local ItemID = select(3,strfind(v, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
								if ItemID ~= nil then
									Display.db.profile.MasterLootBlackList2[ItemID] = ItemID
								else 
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("Warning: Failed to add Item "..v..", Please Shift Click the item to link or Drag and drop the Item.")
								end
							end,
							order = 4,
							width = "full",
						},
						TrashList = {
							 name = "Master Looter BlackList: Click To Remove Item",
							 order = 5,
							 type = "group",
							 inline = true,
							 args = {
								theList = {
								   type = "select",
								   dialogControl = "MSItemSelectList",
								   name = "Anyname",
								   desc = "#ItemTooltip#",
								   width = "full",
								   values = function () return FillMasterLooterList() end,
								   get = function () return CurrrentSelectedMasterLooterItem end,			
								   set = function (info, key) RemoveItemMasterLooterList(key) CurrrentSelectedMasterLooterItem = key end,			
								},
							 },
		  				},
		  			},
		  		},
		  		OT5 = {
					type = "group",
					name = "Invite & Assist",
					desc = "Configure Invite & Assist Options",
					order = 5,
					args = {	
						descr = {
							type = "description",
							name =  "This will add extra frames/buttons in the raid window tab that will allow raid leaders to disband the raid group or invite people from there guild.\n\nAuto Assist people in the raid bases on there guild rank and limit the inv button to specific guild ranks.\n",
							width = "full",
							fontSize  = "medium",
							order = 1,
						},
						EnableGDButton = {
							type = "toggle",
							name = "Guild Invites Button",
							desc = "This will enable extra button in the raid window to invite people from your guild to the raid",
							get = function(info) return Display.db.profile.EnableGDButton end,
							set = function(info, v)	Display.db.profile.EnableGDButton = v	end,
							order = 2,
							width = "double",
						},
						EnableGDisButton = {
							type = "toggle",
							name = "Disband Raid Button",
							desc = "This will enable extra button in the raid window to disbanding the raid",
							get = function(info) return Display.db.profile.EnableGDisButton end,
							set = function(info, v)	Display.db.profile.EnableGDisButton = v	end,
							order = 2.5,
							width = "double",
						},
						GuildInvMessage2 = {
							type = "input",
							name = "Timer message 10 sec",
							desc = "Set the message that will be send to guild chat.",
							get = function(info) return Display.db.profile.GuildInvMessage2 end,
							set = function(info, v)	Display.db.profile.GuildInvMessage2 = v	end,
							order = 3.2,
							width = "full",
						},
						GuildInvMessage3 = {
							type = "input",
							name = "Timer messages 5 sec",
							desc = "Set the message that will be send to guild chat.",
							get = function(info) return Display.db.profile.GuildInvMessage3 end,
							set = function(info, v)	Display.db.profile.GuildInvMessage3 = v	end,
							order = 3.5,
							width = "full",
						},
						GuildInvMessage = {
							type = "input",
							name = "Invite message",
							desc = "Set the message that will be send to guild chat.",
							get = function(info) return Display.db.profile.GuildInvMessage end,
							set = function(info, v)	Display.db.profile.GuildInvMessage = v	end,
							order = 3.8,
							width = "full",
						},
						AutoAssist = {
							type = "select",
							name =  "Auto Raid Assist",
							desc =  "Auto Raid Assist people with the guild rank and above",
							values = function(info)
							local GuildRanks = {}
								for i = 1, GuildControlGetNumRanks() do
									local rankName = GuildControlGetRankName(i)
									if GuildRanks[i] == nil then GuildRanks[i] = rankName end
								end
								GuildRanks[0.1] = "None"
								return GuildRanks
							end,
							get = function(info)
							 	for i = 1, GuildControlGetNumRanks() do
									local rankName = GuildControlGetRankName(i)
							 		if rankName == Display.db.profile.AutoAssist[GetGuildInfo("player")] then return i end
							 	end
							 return Display.db.profile.AutoAssist[GetGuildInfo("player")] end,
							set = function(info, v) if v == "None" then Display.db.profile.AutoAssist[GetGuildInfo("player")] = nil else Display.db.profile.AutoAssist[GetGuildInfo("player")] = GuildControlGetRankName(v) end end,
							order = 4,
							width = "double",
						},
						GuildInviteButton = {
							type = "select",
							name =  "Guild Inv Rank",
							desc =  "Guild Inv Button will only inv selected rank and above\n\nNote: Enable Guild and Disband button in Extra Frames tab, on the left.",
							values = function(info)
							local GuildRanks = {}
								for i = 1, GuildControlGetNumRanks() do
									local rankName = GuildControlGetRankName(i)
									if GuildRanks[i] == nil then GuildRanks[i] = rankName end
								end
								GuildRanks[0.1] = "None"
								return GuildRanks
							end,
							get = function(info)
							 	for i = 1, GuildControlGetNumRanks() do
									local rankName = GuildControlGetRankName(i)
							 		if rankName == Display.db.profile.GuildInviteButton[GetGuildInfo("player")] then return i end
							 	end
							 return Display.db.profile.GuildInviteButton[GetGuildInfo("player")] end,
							set = function(info, v) if v == "None" then Display.db.profile.GuildInviteButton[GetGuildInfo("player")] = nil else Display.db.profile.GuildInviteButton[GetGuildInfo("player")] = GuildControlGetRankName(v) end end,
							order = 5,
							width = "double",
						},	
						GIBDB = {
							type = "description",
							name = "",
							image = "Interface\\AddOns\\FatCooldowns\\icons\\RaidButtons",
							imageWidth = 330,
							imageHeight = 60,
							width = "full",
							fontSize  = "medium",
							order = 7,
						},
						IAHD1 = {
							type = "header",
							name =  "Auto Invite Key Words",
							width = "full",
							order = 8,
						},
						descrIAK = {
							type = "description",
							name =  "Auto Invite people based on key words, case sensitive.\n\n",
							width = "full",
							fontSize  = "medium",
							order = 8.5,
						},
						IAKW = {
							type = "input",
							name = "Auto Invite Words",
							desc = "add a word to the list of words that will auto invite people",
							get = function(v) return nil end,
							set = function(info, v) if v ~= nil then Display.db.profile.IAKW[v] = v end end,
							width = "double",
							order = 9,
						},
						IAKWList = {
							type = "select",
							name =  "Remove",
							desc = "Select a word to be removed from your auto invite list",
							values = function(info, v)
								local tabletoreturn = {}
								for index, val in pairs(Display.db.profile.IAKW) do
									tabletoreturn[index] = index
								end
								return tabletoreturn
							end,
							get = function(info) return Display.db.profile.IAKW end,
							set = function(info, v)	Display.db.profile.IAKW[v] = nil end,
							order = 10,
							width = "double",
						},
						GuildWordsInvite = {
							type = "range",
							name =  "Guild Chat",
							desc =  "Auto invite people who say the key words in guild chat, only for the set amount of seconds after you click the guild invite button.",
							min = 1, max = 60, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.GuildWordsInvite end,
							set = function(info, v) Display.db.profile.GuildWordsInvite = v end,
							order = 11,
							width = "full",
						},
					},
				},
		  		OT6 = {
					type = "group",
					name = "Remake Raids",
					desc = "Configure Remake Raids Options",
					order = 5,
					childGroups = "tab",
					args = {
						CurrentRaid = {
							type = "group",
							name = "Current Raid",
							desc = "Configure Current Raid Options",
							order = 1,
							childGroups = "tree",
							args = {
								descr = {
									type = "description",
									name =  "This will allow you to remake a raid group, you will need to have leader or assist to remake current raid.\n",
									width = "full",
									fontSize  = "medium",
									order = 1,
								},
								RMRWMessae = {
									type = "input",
									name =  "Raid Warning Message",
									get = function(info) return Display.db.profile.RMRWMessae end,
									set = function(info, v) Display.db.profile.RMRWMessae = v end,
									order = 2,
									width = "double",
								},					
								RMCRSendMessage = {
									type = "execute",
									name = "Send Message",
									desc = "This will send a raid warning message.",
									func = function()
										if UnitInRaid("player") and (IsRaidLeader() or IsRaidOfficer()) then
											local Message = Display.db.profile.RMRWMessae
											FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Message, "RAID_WARNING")
										elseif UnitInRaid("player") and  not (IsRaidLeader() or IsRaidOfficer()) then
											FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: You need to be raid leader or have raid assist")
										else
											FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: You are currently not in a raid")
										end
									end,
									order = 3,
								},					
								RMCurrent = {
									type = "execute",
									name = "Remake Current Raid",
									desc = "This will kick everyone and reinvite them.",
									func = function()
										if UnitInRaid("player") and (IsRaidLeader() or IsRaidOfficer()) then
											local RaidPlaerys = {}
											for x = 1, GetNumRaidMembers() do
												local PlayerName = UnitName("raid"..x)
												if PlayerName ~= UnitName("player") then
													RaidPlaerys[PlayerName] = PlayerName
												end
											end
											for i=1, GetNumRaidMembers() do
												if UnitInRaid("player") and UnitName("raid"..i) ~= UnitName("player") then
													UninviteUnit(UnitName("raid"..i))										
												end
											end
											FatCooldowns:ScheduleTimer(function() if UnitInRaid("player") then LeaveParty() end end, 1)												
											FatCooldowns:ScheduleTimer(function() FatCooldowns:ReMakeCurrentRaid(RaidPlaerys) end, 2)
										elseif UnitInRaid("player") and  not (IsRaidLeader() or IsRaidOfficer()) then
											FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: You need to be raid leader or have raid assist")
										else
											FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: You are currently not in a raid")
										end
									end,
									order = 4,
								},		
							},
						},
						RaidLogTab = {
							type = "group",
							name = "Raid Logs",
							desc = "Configure Raid Logs Options",
							order = 1,
							childGroups = "tab",
							args = {	
								RMEnableRL = {
									type = "toggle",
									name =  "Enable",
									desc =  "Tracks what raids you have been in, what loot drops, who was in the raid and gives you the ability to remake the raid",
									get = function(info) return Display.db.profile.RMEnableRL end,
									set = function(info, v)	Display.db.profile.RMEnableRL = v	end,
									order = 1,
									width = "half",
								},		
								RLDSL = {
									type = "execute",
									name = "Delete",
									desc = "Delete the selected raid log",
									func = function()
										if RLSelect then
											local RealName = ValTable[RLSelect]
											local TempIndex = nil
											local TempOldName = nil
											for Index, Val in pairs(RSLTable) do
												if Val.name == RealName then TempIndex = Val.OG TempOldName = Val.oldname end
											end
											for RaidLogIndex, RaidLogTable in pairs(Display.db.profile.RMRaidLog) do
												if TempIndex == RaidLogTable.OG and TempOldName == RaidLogTable.Leader.name then Display.db.profile.RMRaidLog[RaidLogIndex] = nil end
											end
											RLSelect = 1
											RefreshFrameListOptionsAndVariables() 
											LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
										end
									end,
									order = 2,
									width = "half",
								},
								RLDA = {
									type = "execute",
									name = "Clear",
									desc = "Deletes every Raid Log",
									func = function()
										table.wipe(Display.db.profile.RMRaidLog)
										RefreshFrameListOptionsAndVariables() 
										LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
									end,
									order = 3,
									width = "half",
								},	
								RMRaidCount = {
									type = "range",
									name = "Max Count",
									desc = "This will limit the number of raids logs to the selected amount",
									min = 1, max = 50, step = 1, bigStep = 1,
									get = function(v) return Display.db.profile.RMRaidCount end,
									set = function(info, v) Display.db.profile.RMRaidCount = v end,
									order = 3.2,
								},	
								RLInvite = {
									type = "execute",
									name = "Invite Members",
									desc = "Invite everyone from the selected raid log",
									func = function()
										if RLSelect then 
											local RealName = ValTable[RLSelect]
											local TempIndex = nil
											for Index, Val in pairs(RSLTable) do
												if Val.name == RealName then TempIndex = Index end
											end
											for RaidLogIndex, RaidLogTable in pairs(Display.db.profile.RMRaidLog) do
												if RSLTable[TempIndex].OG == RaidLogTable.OG then
													local OrderCount = {}
													for PlayerIndex, PlayerTable in pairs(RaidLogTable.Members) do
														table.insert(OrderCount, PlayerTable.name)
													end
													table.sort(OrderCount, function(a, b) return a:lower() < b:lower() end)
													for i = 1, #OrderCount, 1 do
														if OrderCount[i] ~= nil then
															InviteUnit(OrderCount[i])
														end
													end
												end
											end
										end
									end,
									order = 4,
								},
								RMRaidLog = {
									type = "select",
									name =  "Select Raid",
									desc =  "Select a raid to see the log",
									values = function()
										local TableCount = 1
										for RaidLogIndex, RaidLogTable in pairs(Display.db.profile.RMRaidLog) do
											local RealName = "Leader - "..(RaidLogTable.Leader.class and RaidLogTable.Leader.name and FCDColorName3(RaidLogTable.Leader.class, RaidLogTable.Leader.name) or "Unknown")
												.." - Date: "..RaidLogTable.FTime.day.."/"..RaidLogTable.FTime.month.."/"..RaidLogTable.FTime.year.." Time: "..RaidLogTable.FTime.hour..":"..RaidLogTable.FTime.min
												.." You: "..(RaidLogTable.You.class and RaidLogTable.You.name and FCDColorName3(RaidLogTable.You.class, RaidLogTable.You.name) or "Unknown")
											RSLTable[TableCount] = {name = RealName, OG =  RaidLogTable.OG, oldname = RaidLogTable.Leader.name}
											TableCount = TableCount + 1
										end
										table.sort(RSLTable, function(a,b) return a["OG"] > b["OG"] end)
										for Index, Val in pairs(RSLTable) do
											ValTable[Index] = Val.name
										end
										return ValTable
									end,
									get = function(info) return RLSelect end,
									set = function(info, v) 
										RLSelect = v
										RefreshFrameListOptionsAndVariables() 
										LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
										FatCooldowns.RefreshFrameListOptionsAndVariables()
									end,
									order = 5,
									width = "full",
								},
								RaidPlayers = {
									type = "group",
									name = "Players",
									desc = "Configure Players Options",
									order = 102,
									args = {
									},
								},
								RaidLoot = {
									type = "group",
									name = "Loot",
									desc = "Configure Players Options",
									order = 103,
									args = {
									},
								},
							},
						},
					},
				},
		  		OT7 = {
					type = "group",
					name = "Dispeller",
					desc = "Configure Dispeller Options",
					order = 7,
					childGroups = "tree",
					args = {
					},
				},
		  		OT8 = {
					type = "group",
					name = "Inspect",
					desc = "Configure Inspect Options",
					order = 8,
					childGroups = "tree",
					args = {
						descr1 = {
							type = "description",
							name =  "Shows an extra window frame when inspecting someone giving a summary of the player. the frame is limited to reload every 1 second, you can mouseover the players items to reload the window. shift click will report in chat, alt click will pm\n"..
							"Note: for talents the the inpected player will need to be in your group and for Glyphs the inpected player will need to be in your group and have LibGroupTalents",
							width = "full",
							fontSize  = "small",
							order = 0.1,
						},
						InspectEnable = {
							type = "toggle",
							name =  "Enable",
							desc =  "Shows an extra frame when inspecting people",
							get = function(info) return Display.db.profile.InspectEnable end,
							set = function(info, v)	Display.db.profile.InspectEnable = v	end,
							order = 1,
							width = "double",
						},
						LVL80 = {
							type = "toggle",
							name =  "Level 80",
							desc =  "only shows the frame for level 80 players",
							get = function(info) return Display.db.profile.LVL80 end,
							set = function(info, v)	Display.db.profile.LVL80 = v end,
							order = 2,
							width = "double",
						},
						IFSizeWidth = {
							type = "range",
							name =  "Width",
							min = 1, max = 600, step = 1, bigStep = 1,
							desc =  "Changes the size of the window",
							get = function(info) return Display.db.profile.IFSizeWidth end,
							set = function(info, v)	Display.db.profile.IFSizeWidth = v Display:InspectFrame(1, Display.db.profile.IFSizeWidth, Display.db.profile.IFSizeHight) end,
							order = 3,
							width = "double",
						},
						IFSizeHight = {
							type = "range",
							name =  "Hight",
							min = 1, max = 600, step = 1, bigStep = 1,
							desc =  "Changes the size of the window",
							get = function(info) return Display.db.profile.IFSizeHight end,
							set = function(info, v)	Display.db.profile.IFSizeHight = v Display:InspectFrame(1, Display.db.profile.IFSizeWidth, Display.db.profile.IFSizeHight) end,
							order = 4,
							width = "double",
						},
						IFXOffSet = {
							type = "range",
							name =  "X OffSet",
							min = 1, max = 600, step = 1, bigStep = 1,
							desc =  "Changes the location of the window",
							get = function(info) return Display.db.profile.IFXOffSet end,
							set = function(info, v)	Display.db.profile.IFXOffSet = v Display:InspectFrame(2, Display.db.profile.IFXOffSet, Display.db.profile.IFYOffSet) end,
							order = 5,
							width = "double",
						},
						IFYOffSet = {
							type = "range",
							name =  "Y OffSet",
							min = -300, max = 300, step = 1, bigStep = 1,
							desc =  "Changes the location of the window",
							get = function(info) return Display.db.profile.IFYOffSet end,
							set = function(info, v)	Display.db.profile.IFYOffSet = v Display:InspectFrame(2, Display.db.profile.IFXOffSet, Display.db.profile.IFYOffSet) end,
							order = 6,
							width = "double",
						},
						IFHD1 = {
							type = "header",
							name =  "Include",
							width = "full",
							order = 10,
						},
						LowLVLItems = {
							type = "range",
							name =  "Low LVL Items",
							min = 1, max = 277, step = 1, bigStep = 1,
							desc =  "Scans for items with an ilvl below the set amount",
							get = function(info) return Display.db.profile.LowLVLItems end,
							set = function(info, v)	Display.db.profile.LowLVLItems = v	end,
							order = 11,
							width = "double",
						},
						PVPItems = {
							type = "toggle",
							name =  "PVP Items",
							desc =  "Scans for PVP items",
							get = function(info) return Display.db.profile.IFPVPItems end,
							set = function(info, v)	Display.db.profile.IFPVPItems = v end,
							order = 12,
							width = "double",
						},
						ArmorType = {
							type = "toggle",
							name =  "UnFit Armor",
							desc =  "Scans for UnFit Armor, Cloth on Warriors",
							get = function(info) return Display.db.profile.ArmorType end,
							set = function(info, v)	Display.db.profile.ArmorType = v end,
							order = 13,
							width = "double",
						},
						UnFitStats = {
							type = "toggle",
							name =  "UnFit Stats",
							desc =  "Scans for items with UnFit stats, spell power on warrior",
							get = function(info) return Display.db.profile.UnFitStats end,
							set = function(info, v)	Display.db.profile.UnFitStats = v	end,
							order = 14,
							width = "double",
						},
						UnGem = {
							type = "toggle",
							name =  "UnGemmed Items",
							desc =  "Scans for items that dont have any gems",
							get = function(info) return Display.db.profile.UnGem end,
							set = function(info, v)	Display.db.profile.UnGem = v end,
							order = 15,
							width = "double",
						},
						UnEnchant = {
							type = "toggle",
							name =  "UnEnchanted Items",
							desc =  "Scans for items without enchants",
							get = function(info) return Display.db.profile.UnEnchant end,
							set = function(info, v)	Display.db.profile.UnEnchant = v	end,
							order = 16,
							width = "double",
						},
						Glyphs = {
							type = "toggle",
							name =  "Glyphs",
							desc =  "Scans for Glyphs",
							get = function(info) return Display.db.profile.IFGlyphs end,
							set = function(info, v)	Display.db.profile.IFGlyphs = v end,
							order = 17,
							width = "double",
						},
						IFFishing = {
							type = "toggle",
							name =  "Fishing Pole",
							desc =  "Scans for Fishing poles",
							get = function(info) return Display.db.profile.IFFishing end,
							set = function(info, v)	Display.db.profile.IFFishing = v end,
							order = 18,
							width = "double",
						},
						LowGem = {
							type = "toggle",
							name =  "Low Level Gems Items",
							desc =  "Scans for items that have low lvl gems",
							get = function(info) return Display.db.profile.LowGem end,
							set = function(info, v)	Display.db.profile.LowGem = v end,
							order = 19,
							width = "double",
						},
						LowEnchant = {
							type = "toggle",
							name =  "Low Level Enchants Items",
							desc =  "Scans for items with low level enchants",
							get = function(info) return Display.db.profile.LowEnchant end,
							set = function(info, v)	Display.db.profile.LowEnchant = v	end,
							order = 16,
							width = "double",
						},
						IFTalents = {
							type = "toggle",
							name =  "Talents",
							desc =  "Scans if the person has or is missing specific talents",
							get = function(info) return Display.db.profile.IFTalents end,
							set = function(info, v)	Display.db.profile.IFTalents = v end,
							order = 20,
							width = "double",
						},
						IFDef = {
							type = "toggle",
							name =  "Defense",
							desc =  "checks if capped for defense",
							get = function(info) return Display.db.profile.IFDef end,
							set = function(info, v)	Display.db.profile.IFDef = v end,
							order = 21,
							width = "double",
						},
						IFHit = {
							type = "toggle",
							name =  "Hit",
							desc =  "checks for hit cap",
							get = function(info) return Display.db.profile.IFHit end,
							set = function(info, v)	Display.db.profile.IFHit = v end,
							order = 22,
							width = "double",
						},
						IFCooking = {
							type = "toggle",
							name =  "Cooking",
							desc =  "Checks for 450 cooking",
							get = function(info) return Display.db.profile.IFCooking end,
							set = function(info, v)	Display.db.profile.IFCooking = v end,
							order = 23,
							width = "double",
						},
						IFRaidInfo = {
							type = "toggle",
							name =  "Raid Info",
							desc =  "checks how many times the person has killed bosses/raids",
							get = function(info) return Display.db.profile.IFRaidInfo end,
							set = function(info, v)	Display.db.profile.IFRaidInfo = v end,
							order = 24,
							width = "double",
						},
						PermaSum = {
							type = "multiselect",
							name =  "Permanent Summary Options",
							desc =  "this will make the the selected options always show.",
							values = function(info, v)
								return {
									[1] = "UnFit Talents", 
									[2] = "UnSpent Talents", 
									[3] = "Low Gems", 
									[4] = "PVP Items", 
									[5] = "UnGemmed",
									[6] = "UnEnchanted", 
									[7] = "UnFit Stats", 
									[8] = "UnFit Armor Type", 
									[9] = "Low Lvl Items",
								}
								end,
							get = function(info, v) return Display.db.profile.PermaSum[v] end,
							set = function(info, v, v2) Display.db.profile.PermaSum[v] = v2 end,
							order = 201,
						},
					},
				},
			},
		},
		other = {
			type = "group",
			name = "Personal",
			desc = "Configure Personal Options",
			childGroups = "tab",
			cmdHidden = true,
			order = 5.3,
			args = {	
				OT1 = {
					type = "group",
					name = "Main Options",
					desc = "Configure Main Options",
					order = 1,
					args = {
						LTH01 = {
							type = "header",
							name =  "Tooltip",
							width = "full",
							order = 1101,
						},
						GameTooltipHide = {
							type = "toggle",
							name =  "Combat Hide Tooltip",
							desc =  "Hides the Tooltip in the bottom right corner when in combat",
							get = function(info) return Display.db.profile.GameTooltipHide end,
							set = function(info, v)	Display.db.profile.GameTooltipHide = v	end,
							order = 1101.5,
							width = "double",
						},
						GameTooltipHideShift = {
							type = "toggle",
							name =  "Combat Tooltip Show on Shift",
							desc =  "Shows the Tooltip when you hold down shift",
							disabled = function() if Display.db.profile.GameTooltipHide then return false else Display.db.profile.GameTooltipHideShift = false return true end end,
							get = function(info) return Display.db.profile.GameTooltipHideShift end,
							set = function(info, v)	Display.db.profile.GameTooltipHideShift = v	end,
							order = 1101.6,
							width = "double",
						},
						LTH01 = {
							type = "header",
							name =  "Bank Move",
							width = "full",
							order = 2101,
						},
						MoveItemType = {
							type = "toggle",
							name =  "ItemType",
							desc =  "this will allow you to move all items from your bags to your bank that have the same ItemType when holding alt and right click an item",
							get = function(info) return Display.db.profile.MoveItemType end,
							set = function(info, v)	Display.db.profile.MoveItemType = v	end,
							order = 2102,
						},
						MoveItemSubType = {
							type = "toggle",
							name =  "ItemSubType",
							desc =  "this will allow you to move all items from your bags to your bank that have the same ItemSubType when holding alt and right click an item",
							get = function(info) return Display.db.profile.MoveItemSubType end,
							set = function(info, v)	Display.db.profile.MoveItemSubType = v	end,
							order = 2103,
						},
						MoveID = {
							type = "toggle",
							name =  "Item ID",
							desc =  "this will allow you to move all items from your bags to your bank that have the same ID when holding alt and right click an item",
							get = function(info) return Display.db.profile.MoveID end,
							set = function(info, v)	Display.db.profile.MoveID = v	end,
							order = 2104,
						},
					},
				},
				OT2 = {
					type = "group",
					name = "Auto Confirm",
					desc = "Configure Auto Confirm Options",
					order = 2,
					args = {
						SPUP = {
							type = "toggle",
							name =  "Enable",
							desc =  "Auto Confirms the popup window",
							get = function(info) return Display.db.profile.SPUP end,
							set = function(info, v)	Display.db.profile.SPUP = v end,
							order = 1,
							width = "double",
						},
						SPUPConfirm = {
							type = "toggle",
							name =  "Auto Confirms",
							desc =  "Auto Confirms the popup window i.e. enter DELETE in editbox",
							get = function(info) return Display.db.profile.SPUPConfirm end,
							set = function(info, v)	Display.db.profile.SPUPConfirm = v end,
							order = 2,
							disabled = function() if Display.db.profile.SPUP then return false else return true end end,
						},
						SPUPValPrint = {
							type = "toggle",
							name =  "Print Confirms",
							desc =  "Prints a message when the addon confirms popup window",
							get = function(info) return Display.db.profile.SPUPValPrint end,
							set = function(info, v)	Display.db.profile.SPUPValPrint = v end,
							order = 2.5,
							disabled = function() if Display.db.profile.SPUP then return false else return true end end,
						},
						BlockInviter = {
							type = "range",
							name =  "Auto Invite Blocker",
							desc =  "this will auto decline any invites from players below the selected lvl",
							min = 1, max = 80, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.BlockInvite end,
							set = function(info, v) Display.db.profile.BlockInvite = v Display:UpdateDisplay() end,
							order = 2.9,
							width = "double",
						},
						SPUPVal = {
							type = "multiselect",
							name =  "Type of Popup",
							desc =  "Select which type of popup to auto confirm",
							values = function() 
								local tempval = {}
								for v,b in pairs(Display.db.profile.SPUPVal) do
									tempval[v] = v
								end
								return tempval
							end,
							get = function(info, v)	return Display.db.profile.SPUPVal[v] end,
							set = function(info, v, v2) Display.db.profile.SPUPVal[v] = v2 end,
							hidden = function() return not Display.db.profile.SPUP end,
							order = 3,
							width = "double",
						},
					},
				},
				OT3 = {
					type = "group",
					name = "Friends & Ignore",
					desc = "Configure Friends & Ignore Confirm Options",
					order = 3,
					childGroups = "tab",
					args = {
						FshareList = {
							type = "group",
							name = "Friends List",
							desc = "Configure Friends List Options",
							order = 1,
							childGroups = "tree",
							args = {
								FShare = {
									type = "toggle",
									name =  "Enable",
									desc =  "Enables adding friends list across alts.",
									get = function(info) return Display.db.profile.FShare end,
									set = function(info, v)	Display.db.profile.FShare = v FatCooldowns:IGNORELIST_UPDATE() end,
									order = 1,
									width = "half",
								},
								FDefualtTimer = {
									type = "select",
									name =  "Defualt Remove Timer",
									desc =  "Sets Defualt Remove Timer for people to be removed",
									values = {"Never", "1 Day", "1 Week", "1 Month", "1 Year"},
									get = function(info) return Display.db.profile.FDefualtTimer end,
									set = function(info, v) Display.db.profile.FDefualtTimer = v end,
									order = 1.5,
								},		
								FSRemove = {
									type = "execute",
									name =  "Reset Remove List",
									desc =  "Resets the list of players to be removed. if you remove people from the friends list and want to re-add them you will need to click this.\n\nNote: This does not reset you friends list.",
									func = function() 
										local Realm = GetRealmName()
										local Faction = UnitFactionGroup("player")
										Display.db.profile.RFshareList[Realm][Faction] = {}
									end,
									order = 2,
								},
							},
						},
						IshareList = {
							type = "group",
							name = "Ignore List",
							desc = "Configure Friends List Options",
							order = 2,
							childGroups = "tree",
							args = {
								IShare = {
									type = "toggle",
									name =  "Enable",
									desc =  "Enables adding ignore list across alts.",
									get = function(info) return Display.db.profile.IShare end,
									set = function(info, v)	Display.db.profile.IShare = v FatCooldowns:IGNORELIST_UPDATE() end,
									order = 1,
									width = "half",
								},
								IDefualtTimer = {
									type = "select",
									name =  "Defualt Remove Timer",
									desc =  "Sets Defualt Remove Timer for people to be removed",
									values = {"Never", "1 Day", "1 Week", "1 Month", "1 Year"},
									get = function(info) return Display.db.profile.IDefualtTimer end,
									set = function(info, v) Display.db.profile.IDefualtTimer = v end,
									order = 1.5,
								},	
								ISRemove = {
									type = "execute",
									name =  "Reset Remove List",
									desc =  "Resets the list of players to be removed. if you remove people from the ignore list and want to re-add them you will need to click this.\n\nNote: This does not reset you ignore list.",
									func = function() 
										local Realm = GetRealmName()
										local Faction = UnitFactionGroup("player")
										Display.db.profile.RIshareList[Realm][Faction] = {} 
									end,
									order = 2,
								},
								IgnoreConfirm = {
									type = "toggle",
									name =  "Confirm Ignore",
									desc =  "Adds a Confirm popup window when ignoring a player, you will be able to add the notes into this popup window.",
									get = function(info) return Display.db.profile.IgnoreConfirm end,
									set = function(info, v)	Display.db.profile.IgnoreConfirm = v FatCooldowns:IGNORELIST_UPDATE() end,
									order = 3,
								},
							},
						},
					},
				},
				OT4 = {
					type = "group",
					name = "Flash Screen",
					desc = "Configure Flash Screen Options",
					order = 4,
					childGroups = "tab",
					args = {
						descr2 = {
							type = "description",
							name =  "Flash Screen allows you to set options to flash the screen on specific events.",
							width = "full",
							fontSize  = "medium",
							order = 1,
						},
						RSDFCT = {
							type = "header",
							name =  "Ruby Sanctum",
							width = "full",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 1.11,
						},
						RSDFC = {
							type = "toggle",
							name =  "Fiery Combustion",
							desc =  "Flashs the screen when the debuff is on you.",
							get = function(info) return Display.db.profile.RSDFCOn end,
							set = function(info, v)	Display.db.profile.RSDFCOn = v	end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 1.12,
							width = "double",
						},
						RSDFCColor = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.RSDFCOn then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = true,
							get = function(info) return Display.db.profile.RSDFCColor["r"], Display.db.profile.RSDFCColor["g"], Display.db.profile.RSDFCColor["b"], Display.db.profile.RSDFCColor["a"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.RSDFCColor["r"] = r
								Display.db.profile.RSDFCColor["g"] = g
								Display.db.profile.RSDFCColor["b"] = b
								Display.db.profile.RSDFCColor["a"] = a
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 1.13,
						},
						RSDFCTest = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.RSDFCOn ~= nil then return false else return true end end,
							func = function() AlertFrameFlashScreen(Display.db.profile.RSDFCColor["r"], Display.db.profile.RSDFCColor["g"], Display.db.profile.RSDFCColor["b"], Display.db.profile.RSDFCColor["a"]) end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 1.14,
							width = "half",
						},	
						RSDFCReset = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.RSDFCOn ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.RSDFCColor["r"] = 0
								Display.db.profile.RSDFCColor["g"] = 1
								Display.db.profile.RSDFCColor["b"] = 0
								Display.db.profile.RSDFCColor["a"] = 0.3
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 1.15,
							width = "half",
						},	
						RSDSCT = {
							type = "header",
							name =  "",
							width = "full",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 1.151,
						},
						RSDSC = {
							type = "toggle",
							name =  "Soul Consumption",
							desc =  "Flashs the screen when the debuff is on you.",
							get = function(info) return Display.db.profile.RSDSCOn end,
							set = function(info, v)	Display.db.profile.RSDSCOn = v	end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 1.16,
							width = "double",
						},
						RSDSCColor = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.RSDSCOn then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = true,
							get = function(info) return Display.db.profile.RSDSCColor["r"], Display.db.profile.RSDSCColor["g"], Display.db.profile.RSDSCColor["b"], Display.db.profile.RSDSCColor["a"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.RSDSCColor["r"] = r
								Display.db.profile.RSDSCColor["g"] = g
								Display.db.profile.RSDSCColor["b"] = b
								Display.db.profile.RSDSCColor["a"] = a
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 1.17,
						},
						RSDSCTest = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.RSDSCOn ~= nil then return false else return true end end,
							func = function() AlertFrameFlashScreen(Display.db.profile.RSDSCColor["r"], Display.db.profile.RSDSCColor["g"], Display.db.profile.RSDSCColor["b"], Display.db.profile.RSDSCColor["a"]) end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 1.18,
							width = "half",
						},	
						RSDSCReset = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.RSDSCOn ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.RSDSCColor["r"] = 0
								Display.db.profile.RSDSCColor["g"] = 1
								Display.db.profile.RSDSCColor["b"] = 0
								Display.db.profile.RSDSCColor["a"] = 0.3
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 1.19,
							width = "half",
						},							
						LKDT1 = {
							type = "header",
							name =  "The Lich King",
							width = "full",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 1.5,
						},
						LKDefileOnYou = {
							type = "toggle",
							name =  "LK: Defile On You",
							desc =  "Flashs the screen when Defile is cast on You.",
							get = function(info) return Display.db.profile.LKDefileOnYou end,
							set = function(info, v)	Display.db.profile.LKDefileOnYou = v	end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 2,
							width = "double",
						},
						LKDefileOnYouColor = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.LKDefileOnYou then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = true,
							get = function(info) return Display.db.profile.LKDefileOnYouColor["r"], Display.db.profile.LKDefileOnYouColor["g"], Display.db.profile.LKDefileOnYouColor["b"], Display.db.profile.LKDefileOnYouColor["a"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.LKDefileOnYouColor["r"] = r
								Display.db.profile.LKDefileOnYouColor["g"] = g
								Display.db.profile.LKDefileOnYouColor["b"] = b
								Display.db.profile.LKDefileOnYouColor["a"] = a
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 3,
						},
						LKDefileOnYouTest = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.LKDefileOnYou ~= nil then return false else return true end end,
							func = function() AlertFrameFlashScreen(Display.db.profile.LKDefileOnYouColor["r"], Display.db.profile.LKDefileOnYouColor["g"], Display.db.profile.LKDefileOnYouColor["b"], Display.db.profile.LKDefileOnYouColor["a"]) end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 4,
							width = "half",
						},	
						LKDefileOnYouReset = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.LKDefileOnYou ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.LKDefileOnYouColor["r"] = 1
								Display.db.profile.LKDefileOnYouColor["g"] = 0
								Display.db.profile.LKDefileOnYouColor["b"] = 0
								Display.db.profile.LKDefileOnYouColor["a"] = 0.3
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 4.5,
							width = "half",
						},	
						LKD1 = {
							type = "header",
							name =  "",
							width = "full",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 5,
						},
						LKDefileNotOnYou = {
							type = "toggle",
							name =  "LK: Defile Not On You",
							desc =  "Flashs the screen when Defile is Not cast on You.",
							get = function(info) return Display.db.profile.LKDefileNotOnYou end,
							set = function(info, v)	Display.db.profile.LKDefileNotOnYou = v	end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 6,
							width = "double",
						},
						LKDefileNotOnYouColor = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.LKDefileNotOnYou then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = true,
							get = function(info) return Display.db.profile.LKDefileNotOnYouColor["r"], Display.db.profile.LKDefileNotOnYouColor["g"], Display.db.profile.LKDefileNotOnYouColor["b"], Display.db.profile.LKDefileNotOnYouColor["a"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.LKDefileNotOnYouColor["r"] = r
								Display.db.profile.LKDefileNotOnYouColor["g"] = g
								Display.db.profile.LKDefileNotOnYouColor["b"] = b
								Display.db.profile.LKDefileNotOnYouColor["a"] = a
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 7,
						},
						LKDefileNotOnYouTest = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.LKDefileNotOnYou ~= nil then return false else return true end end,
							func = function() AlertFrameFlashScreen(Display.db.profile.LKDefileNotOnYouColor["r"], Display.db.profile.LKDefileNotOnYouColor["g"], Display.db.profile.LKDefileNotOnYouColor["b"], Display.db.profile.LKDefileNotOnYouColor["a"]) end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 8,
							width = "half",
						},	
						LKDefileNotOnYouReset = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.LKDefileNotOnYou ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.LKDefileNotOnYouColor["r"] = 0
								Display.db.profile.LKDefileNotOnYouColor["g"] = 1
								Display.db.profile.LKDefileNotOnYouColor["b"] = 0
								Display.db.profile.LKDefileNotOnYouColor["a"] = 0.3
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9,
							width = "half",
						},
						SindraOnT = {
							type = "header",
							name =  "Sindragosa",
							width = "full",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.11,
						},
						SindraOn = {
							type = "toggle",
							name =  "Sindra: Bomb On You",
							desc =  "Flashs the screen when the bomb is on you.",
							get = function(info) return Display.db.profile.SindraOn end,
							set = function(info, v)	Display.db.profile.SindraOn = v	end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.12,
							width = "double",
						},
						SindraOnColor = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.SindraOn then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = true,
							get = function(info) return Display.db.profile.SindraOnColor["r"], Display.db.profile.SindraOnColor["g"], Display.db.profile.SindraOnColor["b"], Display.db.profile.SindraOnColor["a"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.SindraOnColor["r"] = r
								Display.db.profile.SindraOnColor["g"] = g
								Display.db.profile.SindraOnColor["b"] = b
								Display.db.profile.SindraOnColor["a"] = a
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.13,
						},
						SindraOnTest = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.SindraOn ~= nil then return false else return true end end,
							func = function() AlertFrameFlashScreen(Display.db.profile.SindraOnColor["r"], Display.db.profile.SindraOnColor["g"], Display.db.profile.SindraOnColor["b"], Display.db.profile.SindraOnColor["a"]) end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.14,
							width = "half",
						},	
						SindraOnReset = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.SindraOn ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.SindraOnColor["r"] = 0
								Display.db.profile.SindraOnColor["g"] = 1
								Display.db.profile.SindraOnColor["b"] = 0
								Display.db.profile.SindraOnColor["a"] = 0.3
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.15,
							width = "half",
						},	
						SindraNotT = {
							type = "header",
							name =  "",
							width = "full",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.16,
						},
						SindraNot = {
							type = "toggle",
							name =  "Sindra: Bomb Not On You",
							desc =  "Flashs the screen when the bomb is not on you.",
							get = function(info) return Display.db.profile.SindraNot end,
							set = function(info, v)	Display.db.profile.SindraNot = v	end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.17,
							width = "double",
						},
						SindraNotColor = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.SindraNot then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = true,
							get = function(info) return Display.db.profile.SindraNotColor["r"], Display.db.profile.SindraNotColor["g"], Display.db.profile.SindraNotColor["b"], Display.db.profile.SindraNotColor["a"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.SindraNotColor["r"] = r
								Display.db.profile.SindraNotColor["g"] = g
								Display.db.profile.SindraNotColor["b"] = b
								Display.db.profile.SindraNotColor["a"] = a
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.18,
						},
						SindraNotTest = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.SindraNot ~= nil then return false else return true end end,
							func = function() AlertFrameFlashScreen(Display.db.profile.SindraNotColor["r"], Display.db.profile.SindraNotColor["g"], Display.db.profile.SindraNotColor["b"], Display.db.profile.SindraNotColor["a"]) end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.19,
							width = "half",
						},	
						SindraNotReset = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.SindraNot ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.SindraNotColor["r"] = 0
								Display.db.profile.SindraNotColor["g"] = 1
								Display.db.profile.SindraNotColor["b"] = 0
								Display.db.profile.SindraNotColor["a"] = 0.3
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.2,
							width = "half",
						},	
						PPGreenOoza = {
							type = "header",
							name =  "Professor Putricide",
							width = "full",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.51,
						},
						PPGreen = {
							type = "toggle",
							name =  "PP: Green Ooze",
							desc =  "Flashs the screen when you get the green debuff.",
							get = function(info) return Display.db.profile.PPGreen end,
							set = function(info, v)	Display.db.profile.PPGreen = v	end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.52,
							width = "double",
						},
						PPGreenColor = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.PPGreen then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = true,
							get = function(info) return Display.db.profile.PPGreenColor["r"], Display.db.profile.PPGreenColor["g"], Display.db.profile.PPGreenColor["b"], Display.db.profile.PPGreenColor["a"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.PPGreenColor["r"] = r
								Display.db.profile.PPGreenColor["g"] = g
								Display.db.profile.PPGreenColor["b"] = b
								Display.db.profile.PPGreenColor["a"] = a
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.53,
						},
						PPGreenTest = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.PPGreen ~= nil then return false else return true end end,
							func = function() AlertFrameFlashScreen(Display.db.profile.PPGreenColor["r"], Display.db.profile.PPGreenColor["g"], Display.db.profile.PPGreenColor["b"], Display.db.profile.PPGreenColor["a"]) end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.54,
							width = "half",
						},	
						PPGreenReset = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.PPGreen ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.PPGreenColor["r"] = 0
								Display.db.profile.PPGreenColor["g"] = 1
								Display.db.profile.PPGreenColor["b"] = 0
								Display.db.profile.PPGreenColor["a"] = 0.3
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.55,
							width = "half",
						},
						PPOrangeOoza = {
							type = "header",
							name =  "",
							width = "full",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.56,
						},
						PPOrange = {
							type = "toggle",
							name =  "PP: Orange Ooze",
							desc =  "Flashs the screen when you get the orange debuff.",
							get = function(info) return Display.db.profile.PPOrange end,
							set = function(info, v)	Display.db.profile.PPOrange = v	end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.57,
							width = "double",
						},
						PPOrangeColor = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.PPOrange then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = true,
							get = function(info) return Display.db.profile.PPOrangeColor["r"], Display.db.profile.PPOrangeColor["g"], Display.db.profile.PPOrangeColor["b"], Display.db.profile.PPOrangeColor["a"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.PPOrangeColor["r"] = r
								Display.db.profile.PPOrangeColor["g"] = g
								Display.db.profile.PPOrangeColor["b"] = b
								Display.db.profile.PPOrangeColor["a"] = a
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.58,
						},
						PPOrangeTest = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.PPOrange ~= nil then return false else return true end end,
							func = function() AlertFrameFlashScreen(Display.db.profile.PPOrangeColor["r"], Display.db.profile.PPOrangeColor["g"], Display.db.profile.PPOrangeColor["b"], Display.db.profile.PPOrangeColor["a"]) end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.59,
							width = "half",
						},	
						PPOrangeReset = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.PPOrange ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.PPOrangeColor["r"] = 0
								Display.db.profile.PPOrangeColor["g"] = 1
								Display.db.profile.PPOrangeColor["b"] = 0
								Display.db.profile.PPOrangeColor["a"] = 0.3
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.6,
							width = "half",
						},	
						BQLT = {
							type = "header",
							name =  "Blood-Queen Lanathel",
							width = "full",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.71,
						},
						BQL = {
							type = "toggle",
							name =  "BQL Shadows/Flames on You",
							desc =  "Flashs the screen you need to run for flames/shadows.",
							get = function(info) return Display.db.profile.BQL end,
							set = function(info, v)	Display.db.profile.BQL = v	end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.72,
							width = "double",
						},
						BQLColor = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.BQL then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = true,
							get = function(info) return Display.db.profile.BQLColor["r"], Display.db.profile.BQLColor["g"], Display.db.profile.BQLColor["b"], Display.db.profile.BQLColor["a"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.BQLColor["r"] = r
								Display.db.profile.BQLColor["g"] = g
								Display.db.profile.BQLColor["b"] = b
								Display.db.profile.BQLColor["a"] = a
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.73,
						},
						BQLTest = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.BQL ~= nil then return false else return true end end,
							func = function() AlertFrameFlashScreen(Display.db.profile.BQLColor["r"], Display.db.profile.BQLColor["g"], Display.db.profile.BQLColor["b"], Display.db.profile.BQLColor["a"]) end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.74,
							width = "half",
						},	
						BQLReset = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.BQL ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.BQLColor["r"] = 0
								Display.db.profile.BQLColor["g"] = 1
								Display.db.profile.BQLColor["b"] = 0
								Display.db.profile.BQLColor["a"] = 0.3
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.75,
							width = "half",
						},		
						LDYDT1 = {
							type = "header",
							name =  "Lady DeathWhisper",
							width = "full",
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.76,
						},
						LDYSpirits = {
							type = "toggle",
							name =  "LDW: Summon Spirits",
							desc =  "Flashs the screen when LDW casts summon spirits.",
							get = function(info) return Display.db.profile.LDYSpirits end,
							set = function(info, v)	Display.db.profile.LDYSpirits = v	end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.78,
							width = "double",
						},
						LDYSpiritsColor = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.LKDefileOnYou then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = true,
							get = function(info) return Display.db.profile.LDYSpiritsColor["r"], Display.db.profile.LDYSpiritsColor["g"], Display.db.profile.LDYSpiritsColor["b"], Display.db.profile.LDYSpiritsColor["a"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.LDYSpiritsColor["r"] = r
								Display.db.profile.LDYSpiritsColor["g"] = g
								Display.db.profile.LDYSpiritsColor["b"] = b
								Display.db.profile.LDYSpiritsColor["a"] = a
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.79,
						},
						LDYSpiritsTest = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.LDYSpirits ~= nil then return false else return true end end,
							func = function() AlertFrameFlashScreen(Display.db.profile.LDYSpiritsColor["r"], Display.db.profile.LDYSpiritsColor["g"], Display.db.profile.LDYSpiritsColor["b"], Display.db.profile.LDYSpiritsColor["a"]) end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.8,
							width = "half",
						},	
						LDYSpiritsReset = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.LDYSpirits ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.LDYSpiritsColor["r"] = 0.5
								Display.db.profile.LDYSpiritsColor["g"] = 0
								Display.db.profile.LDYSpiritsColor["b"] = 1
								Display.db.profile.LDYSpiritsColor["a"] = 0.3
							end,
							hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
							order = 9.9,
							width = "half",
						},	
						LHP1 = {
							type = "header",
							name =  "Low HP",
							width = "full",
							order = 10,
						},
						LHPN = {
							type = "toggle",
							name =  "Low HP",
							desc =  "Flashs the screen when you are have low hp.",
							get = function(info) return Display.db.profile.LHPN end,
							set = function(info, v)	Display.db.profile.LHPN = v	FlashAleartFrame.SetSettings() end,
							order = 11,
						},	
						LHPC = {
							type = "toggle",
							name =  "Combat Only",
							desc =  "Flashs the screen when are in combat only.",
							get = function(info) return Display.db.profile.LHPC end,
							set = function(info, v)	Display.db.profile.LHPC = v	FlashAleartFrame.SetSettings() end,
							order = 11.2,
						},		
						LHPNC = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.LHPN then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = false,
							get = function(info) return Display.db.profile.LHPNC["r"], Display.db.profile.LHPNC["g"], Display.db.profile.LHPNC["b"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.LHPNC["r"] = r
								Display.db.profile.LHPNC["g"] = g
								Display.db.profile.LHPNC["b"] = b
								FlashAleartFrame.SetSettings()
							end,
							order = 12,
						},
						LHPNCT = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.LHPNC ~= nil then return false else return true end end,
							func = function() 
								FlashAleartFrame.FlashCheck(FlashAleartFrame, 50, 25, 20, FlashAleartFrame.health, "UNIT_HEALTH", false, 1)
								FatCooldowns:ScheduleTimer(function() FlashAleartFrame.FlashStop(FlashAleartFrame, FlashAleartFrame.health, "UNIT_HEALTH") end, 6)
							end,
							order = 13,
							width = "half",
						},	
						LHPNR = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.LHPN ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.LHPNC["r"] = 1
								Display.db.profile.LHPNC["g"] = 0
								Display.db.profile.LHPNC["b"] = 0
								FlashAleartFrame.SetSettings()
							end,
							order = 14,
							width = "half",
						},	
						LHPH = {
							type = "range",
							name =  "Health Percent",
							desc = "Flash screen when your below the set %",
							min = 1, max = 99, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.LHPH end,
							set = function(info, v)	Display.db.profile.LHPH = v FlashAleartFrame.SetSettings() end,
							order = 14.01,
						},
						LHPNTE = {
							type = "select",
							name =  "Texture",
							dialogControl = 'LSM30_Background',
							desc =  "Sets the Texture.",
							values = AceGUIWidgetLSMlists.background,
							get = function(info) return Display.db.profile.LHPNTE end,
							set = function(info, v)	Display.db.profile.LHPNTE = v FlashAleartFrame.SetSettings() end,
							order = 14.1,
						},
						LHPS =  {
							type = "select",
							name =  "Sound",
							desc =  "Plays the sound when below the set hp.",
							values = function()
							local SoundName = {}
								for CustomSoundName, CustomSoundPath in pairs(FatCooldowns.FCDSounds) do
									SoundName[CustomSoundName] = CustomSoundName
								end
								return SoundName
							end,
							get = function(info, v, v2) return Display.db.profile.LHPS end,
							set = function(info, v, v2) Display.db.profile.LHPS = v PlaySoundFile(FatCooldowns.FCDSounds[v], "Master",false) FlashAleartFrame.SetSettings() end,
							order = 14.4,
						},
						LHPSR = {
							type = "toggle",
							name =  "Repeat Sound",
							desc =  "keep playing the sound until your no longer below the set %.",
							get = function(info) return Display.db.profile.LHPSR end,
							set = function(info, v)	Display.db.profile.LHPSR = v	FlashAleartFrame.SetSettings() end,
							order = 14.41,
						},	
						LHPCR = {
							type = "range",
							name =  "Critical Health Percent",
							desc = "Flash screen when your below the set %",
							min = 1, max = 99, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.LHPCR end,
							set = function(info, v)	Display.db.profile.LHPCR = v FlashAleartFrame.SetSettings() end,
							order = 14.42,
						},
						LHPNTEC = {
							type = "select",
							name =  "Critical Texture",
							dialogControl = 'LSM30_Background',
							desc =  "Sets the Texture.",
							values = AceGUIWidgetLSMlists.background,
							get = function(info) return Display.db.profile.LHPNTEC end,
							set = function(info, v)	Display.db.profile.LHPNTEC = v FlashAleartFrame.SetSettings() end,
							order = 14.43,
						},
						LHPPL = {
							type = "range",
							name =  "Player Level",
							desc = "Flash screen only if players level is above/below the set amount.",
							min = 0, max = 80, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.LHPPL end,
							set = function(info, v)	Display.db.profile.LHPPL = v FlashAleartFrame.SetSettings() end,
							order = 14.44,
						},
						LHPPLT = {
							type = "select",
							name =  "Player Level Type",
							desc =  "Sets if the players level should be above or below the set amount.",
							values = {"Above", "Below"},
							get = function(info) return Display.db.profile.LHPPLT end,
							set = function(info, v)	Display.db.profile.LHPPLT = v FlashAleartFrame.SetSettings() end,
							order = 14.45,
						},
						LHPPCLAE = {
							type = "toggle",
							name =  "Class Filter",
							desc =  "Enable the Class Filter.",
							get = function(info) return Display.db.profile.LHPPCLAE end,
							set = function(info, v)	Display.db.profile.LHPPCLAE = v	FlashAleartFrame.SetSettings() end,
							order = 14.46,
							width = "full",
						},	
						LHPPCLA = {
							type = "multiselect",
							name =  "Player Class",
							desc =  "Select the classes you would like to filter out.",
							values = function(info, v) if FatCooldowns.ExPac == 2 then
								return {
									["DEATH KNIGHT"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t |cffC41F3BDEATHKNIGHT|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t", 
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								else return {
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								end
							end,
							get = function(info, v) return Display.db.profile.LHPPCLA[v] end,
							set = function(info, v, v2) Display.db.profile.LHPPCLA[v] = v2 end,
							hidden = function(info, v) return not Display.db.profile.LHPPCLAE end,
							order = 14.5,
						},
						LHNFilter = {
							type = "input",
							name =  "Player Filter",
							desc =  "Enter a player name to disable on that player.",
							get = function(info) return nil end,
							set = function(info, v)	
								local NewV = v:gsub("^%l", string.upper)
								Display.db.profile.LHNFilter[NewV] = NewV
								FlashAleartFrame.SetSettings() end,
							order = 14.61,
							width = "double",
						},	
						LHNFilterList = {
							type = "select",
							name =  "Remove Player",
							desc =  "remove a player from the filter list.",
							values = function(info) return Display.db.profile.LHNFilter end,
							get = function(info) return nil end,
							set = function(info, v)	Display.db.profile.LHNFilter[v] = nil FlashAleartFrame.SetSettings() end,
							width = "double",
							order = 14.62,
						},
						LM1 = {
							type = "header",
							name =  "Low Mana",
							width = "full",
							order = 15,
						},
						LMM = {
							type = "toggle",
							name =  "Low Mana",
							desc =  "Flashs the screen when you are have low mana.",
							get = function(info) return Display.db.profile.LMM end,
							set = function(info, v)	Display.db.profile.LMM = v FlashAleartFrame.SetSettings() end,
							order = 16,
						},
						LMPC = {
							type = "toggle",
							name =  "Combat Only",
							desc =  "Flashs the screen when are in combat only.",
							get = function(info) return Display.db.profile.LMPC end,
							set = function(info, v)	Display.db.profile.LMPC = v	FlashAleartFrame.SetSettings() end,
							order = 16.2,
						},		
						LMNC = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.LMM then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = false,
							get = function(info) return Display.db.profile.LMNC["r"], Display.db.profile.LMNC["g"], Display.db.profile.LMNC["b"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.LMNC["r"] = r
								Display.db.profile.LMNC["g"] = g
								Display.db.profile.LMNC["b"] = b
								FlashAleartFrame.SetSettings()
							end,
							order = 17,
						},
						LMNCT = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.LMNC ~= nil then return false else return true end end,
							func = function()  
								FlashAleartFrame.FlashCheck(FlashAleartFrame, 50, 25, 20, FlashAleartFrame.mana, "UNIT_MANA", false, 1)
								FatCooldowns:ScheduleTimer(function() FlashAleartFrame.FlashStop(FlashAleartFrame, FlashAleartFrame.mana, "UNIT_MANA") end, 6)
							end,
							order = 18,
							width = "half",
						},	
						LMMR = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.LMM ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.LMNC["r"] = 0
								Display.db.profile.LMNC["g"] = 0
								Display.db.profile.LMNC["b"] = 1
								FlashAleartFrame.SetSettings()
							end,
							order = 19,
							width = "half",
						},	
						LMPH = {
							type = "range",
							name =  "Mana Percent",
							desc = "Flash screen when your below the set %",
							min = 1, max = 99, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.LMPH end,
							set = function(info, v)	Display.db.profile.LMPH = v FlashAleartFrame.SetSettings() end,
							order = 19.01,
						},
						LMPNTE = {
							type = "select",
							name =  "Texture",
							dialogControl = 'LSM30_Background',
							desc =  "Sets the Texture.",
							values = AceGUIWidgetLSMlists.background,
							get = function(info) return Display.db.profile.LMPNTE end,
							set = function(info, v)	Display.db.profile.LMPNTE = v FlashAleartFrame.SetSettings() end,
							order = 19.1,
						},
						LMPS =  {
							type = "select",
							name =  "Sound",
							desc =  "Plays the sound when below the set mana.",
							values = function()
							local SoundName = {}
								for CustomSoundName, CustomSoundPath in pairs(FatCooldowns.FCDSounds) do
									SoundName[CustomSoundName] = CustomSoundName
								end
								return SoundName
							end,
							get = function(info, v, v2) return Display.db.profile.LMPS end,
							set = function(info, v, v2) Display.db.profile.LMPS = v PlaySoundFile(FatCooldowns.FCDSounds[v], "Master",false) FlashAleartFrame.SetSettings() end,
							order = 19.4,
						},
						LMPSR = {
							type = "toggle",
							name =  "Repeat Sound",
							desc =  "keeps playing the sound.",
							get = function(info) return Display.db.profile.LMPSR end,
							set = function(info, v)	Display.db.profile.LMPSR = v FlashAleartFrame.SetSettings() end,
							order = 19.41,
						},
						LMPCR = {
							type = "range",
							name =  "Critical Mana Percent",
							desc = "Flash screen when your below the set %",
							min = 1, max = 99, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.LMPCR end,
							set = function(info, v)	Display.db.profile.LMPCR = v FlashAleartFrame.SetSettings() end,
							order = 19.42,
						},
						LMPNTEC = {
							type = "select",
							name =  "Critical Texture",
							dialogControl = 'LSM30_Background',
							desc =  "Sets the Texture.",
							values = AceGUIWidgetLSMlists.background,
							get = function(info) return Display.db.profile.LMPNTEC end,
							set = function(info, v)	Display.db.profile.LMPNTEC = v FlashAleartFrame.SetSettings() end,
							order = 19.43,
						},
						LMPPL = {
							type = "range",
							name =  "Player Level",
							desc = "Flash screen only if players level is above/below the set amount.",
							min = 0, max = 80, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.LMPPL end,
							set = function(info, v)	Display.db.profile.LMPPL = v FlashAleartFrame.SetSettings() end,
							order = 19.44,
						},
						LMPPLT = {
							type = "select",
							name =  "Player Level Type",
							desc =  "Sets if the players level should be above or below the set amount.",
							values = {"Above", "Below"},
							get = function(info) return Display.db.profile.LMPPLT end,
							set = function(info, v)	Display.db.profile.LMPPLT = v FlashAleartFrame.SetSettings() end,
							order = 19.45,
						},
						LMPPCLAE = {
							type = "toggle",
							name =  "Class Filter",
							desc =  "Enable the Class Filter.",
							get = function(info) return Display.db.profile.LMPPCLAE end,
							set = function(info, v)	Display.db.profile.LMPPCLAE = v	FlashAleartFrame.SetSettings() end,
							order = 19.61,
							width = "full",
						},	
						LMPPCLA = {
							type = "multiselect",
							name =  "Player Class",
							desc =  "Select the classes you would like to filter out.",
							values = function(info, v) if FatCooldowns.ExPac == 2 then
								return {
									["DEATH KNIGHT"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t |cffC41F3BDEATHKNIGHT|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t", 
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								else return {
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								end
							end,
							get = function(info, v) return Display.db.profile.LMPPCLA[v] end,
							set = function(info, v, v2) Display.db.profile.LMPPCLA[v] = v2 end,
							hidden = function(info, v) return not Display.db.profile.LMPPCLAE end,
							order = 19.65,
						},
						LMNFilter = {
							type = "input",
							name =  "Player Filter",
							desc =  "Enter a player name to disable on that player.",
							get = function(info) return nil end,
							set = function(info, v)	
								local NewV = v:gsub("^%l", string.upper)
								Display.db.profile.LMNFilter[NewV] = NewV
								FlashAleartFrame.SetSettings() end,
							order = 19.67,
							width = "double",
						},	
						LMNFilterList = {
							type = "select",
							name =  "Remove Player",
							desc =  "remove a player from the filter list.",
							values = function(info) return Display.db.profile.LMNFilter end,
							get = function(info) return nil end,
							set = function(info, v)	Display.db.profile.LMNFilter[v] = nil FlashAleartFrame.SetSettings() end,
							width = "double",
							order = 19.68,
						},
						LP1 = {
							type = "header",
							name =  "Low Pet Health",
							width = "full",
							order = 20,
						},
						LPM = {
							type = "toggle",
							name =  "Pet Health",
							desc =  "Flashs the screen when your pet is below the set % health.",
							get = function(info) return Display.db.profile.LPM end,
							set = function(info, v)	Display.db.profile.LPM = v FlashAleartFrame.SetSettings() end,
							order = 21,
						},
						LPPC = {
							type = "toggle",
							name =  "Combat Only",
							desc =  "Flashs the screen when are in combat only.",
							get = function(info) return Display.db.profile.LPPC end,
							set = function(info, v)	Display.db.profile.LPPC = v	FlashAleartFrame.SetSettings() end,
							order = 22,
						},		
						LPNC = {
							type = "color",	
							name =  "Color",
							disabled = function() if Display.db.profile.LPM then return false else return true end end,
							desc =  "Set the Color of the Flash Screen Effect",
							hasAlpha = false,
							get = function(info) return Display.db.profile.LPNC["r"], Display.db.profile.LPNC["g"], Display.db.profile.LPNC["b"] end,
							set = function(info, r, g, b, a)
								Display.db.profile.LPNC["r"] = r
								Display.db.profile.LPNC["g"] = g
								Display.db.profile.LPNC["b"] = b
								FlashAleartFrame.SetSettings()
							end,
							order = 23,
						},
						LPNCT = {
							type = "execute",
							name =  "Test",
							disabled = function() if Display.db.profile.LPNC ~= nil then return false else return true end end,
							func = function() 
								FlashAleartFrame.FlashCheck(FlashAleartFrame, 50, 25, 20, FlashAleartFrame.pet, "UNIT_PET", false, 1)
								FatCooldowns:ScheduleTimer(function() FlashAleartFrame.FlashStop(FlashAleartFrame, FlashAleartFrame.pet, "UNIT_PET") end, 6)
							end,
							order = 24,
							width = "half",
						},	
						LPMR = {
							type = "execute",
							name =  "Reset",
							disabled = function() if Display.db.profile.LPM ~= nil then return false else return true end end,
							func = function() 
								Display.db.profile.LPNC["r"] = 0
								Display.db.profile.LPNC["g"] = 0
								Display.db.profile.LPNC["b"] = 1
								FlashAleartFrame.SetSettings()
							end,
							order = 25,
							width = "half",
						},	
						LPPH = {
							type = "range",
							name =  "Pet Percent",
							desc = "Flash screen when your pet is below the set % health",
							min = 1, max = 99, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.LPPH end,
							set = function(info, v)	Display.db.profile.LPPH = v FlashAleartFrame.SetSettings() end,
							order = 26,
						},
						LPPNTE = {
							type = "select",
							name =  "Texture",
							dialogControl = 'LSM30_Background',
							desc =  "Sets the Texture.",
							values = AceGUIWidgetLSMlists.background,
							get = function(info) return Display.db.profile.LPPNTE end,
							set = function(info, v)	Display.db.profile.LPPNTE = v FlashAleartFrame.SetSettings() end,
							order = 27,
						},
						LPPS =  {
							type = "select",
							name =  "Sound",
							desc =  "Plays the sound when your pet is below the set % health.",
							values = function()
							local SoundName = {}
								for CustomSoundName, CustomSoundPath in pairs(FatCooldowns.FCDSounds) do
									SoundName[CustomSoundName] = CustomSoundName
								end
								return SoundName
							end,
							get = function(info, v, v2) return Display.db.profile.LPPS end,
							set = function(info, v, v2) Display.db.profile.LPPS = v PlaySoundFile(FatCooldowns.FCDSounds[v], "Master",false) FlashAleartFrame.SetSettings() end,
							order = 28,
						},
						LPPSR = {
							type = "toggle",
							name =  "Repeat Sound",
							desc =  "keeps playing the sound.",
							get = function(info) return Display.db.profile.LPPSR end,
							set = function(info, v)	Display.db.profile.LPPSR = v FlashAleartFrame.SetSettings() end,
							order = 29,
						},
						LPPCR = {
							type = "range",
							name =  "Critical Pet Percent",
							desc = "Flash screen when your pet is below the set %",
							min = 1, max = 99, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.LPPCR end,
							set = function(info, v)	Display.db.profile.LPPCR = v FlashAleartFrame.SetSettings() end,
							order = 30,
						},
						LPPNTEC = {
							type = "select",
							name =  "Critical Texture",
							dialogControl = 'LSM30_Background',
							desc =  "Sets the Texture.",
							values = AceGUIWidgetLSMlists.background,
							get = function(info) return Display.db.profile.LPPNTEC end,
							set = function(info, v)	Display.db.profile.LPPNTEC = v FlashAleartFrame.SetSettings() end,
							order = 31,
						},
						LPPPL = {
							type = "range",
							name =  "Player Level",
							desc = "Flash screen only if players level is above/below the set amount.",
							min = 0, max = 80, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.LPPPL end,
							set = function(info, v)	Display.db.profile.LPPPL = v FlashAleartFrame.SetSettings() end,
							order = 32,
						},
						LPPPLT = {
							type = "select",
							name =  "Player Level Type",
							desc =  "Sets if the players level should be above or below the set amount.",
							values = {"Above", "Below"},
							get = function(info) return Display.db.profile.LPPPLT end,
							set = function(info, v)	Display.db.profile.LPPPLT = v FlashAleartFrame.SetSettings() end,
							order = 33,
						},
						LPPPCLAE = {
							type = "toggle",
							name =  "Class Filter",
							desc =  "Enable the Class Filter.",
							get = function(info) return Display.db.profile.LPPPCLAE end,
							set = function(info, v)	Display.db.profile.LPPPCLAE = v	FlashAleartFrame.SetSettings() end,
							order = 34,
							width = "full",
						},	
						LPPPCLA = {
							type = "multiselect",
							name =  "Player Class",
							desc =  "Select the classes you would like to filter out.",
							values = function(info, v) if FatCooldowns.ExPac == 2 then
								return {
									["DEATH KNIGHT"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t |cffC41F3BDEATHKNIGHT|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t", 
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								else return {
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								end
							end,
							get = function(info, v) return Display.db.profile.LPPPCLA[v] end,
							set = function(info, v, v2) Display.db.profile.LPPPCLA[v] = v2 end,
							hidden = function(info, v) return not Display.db.profile.LPPPCLAE end,
							order = 35,
						},
						LPNFilter = {
							type = "input",
							name =  "Player Filter",
							desc =  "Enter a player name to disable on that player.",
							get = function(info) return nil end,
							set = function(info, v)	
								local NewV = v:gsub("^%l", string.upper)
								Display.db.profile.LPNFilter[NewV] = NewV
								FlashAleartFrame.SetSettings() end,
							order = 36,
							width = "double",
						},	
						LPNFilterList = {
							type = "select",
							name =  "Remove Player",
							desc =  "remove a player from the filter list.",
							values = function(info) return Display.db.profile.LMNFilter end,
							get = function(info) return nil end,
							set = function(info, v)	Display.db.profile.LPNFilter[v] = nil FlashAleartFrame.SetSettings() end,
							width = "double",
							order = 37,
						},
					},
				},
				OT5 = {
					type = "group",
					name = "UIError Filter",
					desc = "Configure UIError Filter Options",
					order = 5,
					args = {
						UIE = {
							type = "description",
							name =  "This allows you to filter out the red error messages. the list will grow as you encounter more messages. if your using other error filter addons it may interfear with this addon.\n",
							width = "full",
							fontSize  = "medium",
							order = 1,
						},
						UIEEnable = {
							type = "toggle",
							name =  "Enable",
							desc =  "Enable the Filter",
							get = function(info) return Display.db.profile.UIEEnable end,
							set = function(info, v)	Display.db.profile.UIEEnable = v end,
							order = 2,
						},
						UIECombat = {
							type = "toggle",
							name =  "Combat Only",
							desc =  "Filters only when your in combat",
							get = function(info) return Display.db.profile.UIECombat end,
							set = function(info, v)	Display.db.profile.UIECombat = v end,
							order = 3,
							disabled = function() return not Display.db.profile.UIEEnable end,
						},
						UIEAll = {
							type = "toggle",
							name =  "Filter All",
							desc =  "Filters All Messages",
							get = function(info) return Display.db.profile.UIEAll end,
							set = function(info, v)	Display.db.profile.UIEAll = v end,
							order = 4,
							disabled = function() return not Display.db.profile.UIEEnable end,
						},
						UIETimer = {
							type = "toggle",
							name =  "Timer",
							desc =  "Dont show the same message within 5 seconds.",
							get = function(info) return Display.db.profile.UIETimer end,
							set = function(info, v)	Display.db.profile.UIETimer = v end,
							order = 4.1,
							disabled = function() return not Display.db.profile.UIEEnable end,
						},
						ErrorList = {
							type = "multiselect",
							name =  "Filter List",
							desc =  "Enable messages to be filtered out",
							values = function() 
								local tempval = {}
								for v,b in pairs(Display.db.profile.UIETable) do
									tempval[v] = v
								end
								return tempval
							end,
							get = function(info, v)	return Display.db.profile.UIEDisable[v] end,
							set = function(info, v, v2) Display.db.profile.UIEDisable[v] = v2 end,
							order = 5,
							width = "full",
							hidden = function() return not Display.db.profile.UIEEnable end,
						},
					},
				},
				OT6 = {
					type = "group",
					name = "Badges Bar",
					desc = "Configure Badges Bar Options",
					order = 6,
					hidden = function() if FatCooldowns.ExPac == 2 then return false else return true end end,
					args = {
						ARDBB = {
							type = "description",
							name =  "Badges Bar will add extra buttons to vendor frames allowing you to trade faster.\n",
							width = "full",
							fontSize  = "medium",
							order = 1207.61,
		  				},
						BBE1 = {
							type = "description",
							name = "",
							image = "Interface\\AddOns\\FatCooldowns\\icons\\ExtraB\\Frost",
							imageWidth = 72,
							imageHeight = 24,
							width = "double",
							fontSize  = "medium",
							order = 1207.62,
						},
						BBE2 = {
							type = "description",
							name = "",
							image = "Interface\\AddOns\\FatCooldowns\\icons\\ExtraB\\Triumph",
							imageWidth = 72,
							imageHeight = 24,
							width = "double",
							fontSize  = "medium",
							order = 1207.63,
						},
						BBE3 = {
							type = "description",
							name = "",
							image = "Interface\\AddOns\\FatCooldowns\\icons\\ExtraB\\Conquest",
							imageWidth = 72,
							imageHeight = 24,
							width = "double",
							fontSize  = "medium",
							order = 1207.64,
						},
						BBE4 = {
							type = "description",
							name = "",
							image = "Interface\\AddOns\\FatCooldowns\\icons\\ExtraB\\Valor",
							imageWidth = 72,
							imageHeight = 24,
							width = "double",
							fontSize  = "medium",
							order = 1207.65,
						},
						BBE5 = {
							type = "description",
							name = "",
							image = "Interface\\AddOns\\FatCooldowns\\icons\\ExtraB\\Mark",
							imageWidth = 72,
							imageHeight = 24,
							width = "double",
							fontSize  = "medium",
							order = 1207.66,
						},
						BBE6 = {
							type = "description",
							name = "",
							image = "Interface\\AddOns\\FatCooldowns\\icons\\ExtraB\\Primo",
							imageWidth = 72,
							imageHeight = 24,
							width = "double",
							fontSize  = "medium",
							order = 1207.67,
						},
						BBEED = {
							type = "description",
							name = "\n",
							width = "full",
							fontSize  = "medium",
							order = 1207.68,
						},
						BadagesBar = {
							type = "toggle",
							name =  "Enable Badges Bar",
							desc =  "Enables the Badges bar.",
							get = function(info) return Display.db.profile.BadagesBar end,
							set = function(info, v)	Display.db.profile.BadagesBar = v	end,
							order = 1207.9,
							width = "double",
						},
						BadagesBarConfirm = {
							type = "toggle",
							name =  "Badages Bar Confirm",
							desc =  "Adds a confirm to buying with the badages bar.",
							get = function(info) return Display.db.profile.BadagesBarConfirm end,
							set = function(info, v)	Display.db.profile.BadagesBarConfirm = v	end,
							order = 1208,
							width = "double",
						},
						BadagesBarCount = {
							type = "range",
							name = "Amount to Trade",
							desc = "Set the Amount of badages you would like to trade at once, does not Include Primo's they are always set to 1",
							min = 1, max = 200, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.BadagesBarCount end,
							set = function(info, v) Display.db.profile.BadagesBarCount = v end,
							order = 1209,
							width = "full",
						},
					},
				},
				OT7 = {
					type = "group",
					name = "FCDMount",
					desc = "Configure FCDMount Options",
					order = 7,
					childGroups = "tab",
					args = {
						ARD22 = {
							type = "description",
							name =  "FCDMount allows you to mount on a random mount that is best fit for your current position i.e. flying, ground, fast and slow. Note: If the icon is not updating edit the macro icon to the question mark (?) manually.\n",
							width = "full",
							fontSize  = "medium",
							order = 0.1,
		  				},
		  				CreateMacro = {
							type = "execute",
							name =  "Create Macro",
							func = function() 
								local HasMacro = false
								local NumGlobal = GetNumMacros()
								for i = 1, NumGlobal, 1 do
									local MacroName, MacroIcon, MacroBody  = GetMacroInfo(i)
									if string.find(string.lower(MacroBody), string.lower("/fcd fcdmount")) then
										HasMacro = true
									end
								end
								if HasMacro then 
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: You already have the macro")
								elseif NumGlobal == 36 then
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: You have the max number of macros")
								else
									CreateMacro("FCDMount", 1, "/fcd fcdmount", nil, nil)
									FCDMountMacro()
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Macro Created")
								end
							end,
							order = 1,
						},
						ARD222 = {
							type = "description",
							name =  "",
							width = "full",
							fontSize  = "medium",
							order = 1.1,
		  				},
		  				OneClickMount = {
							type = "toggle",
							name = "One Click Mount",
							desc = "This will remove the need to click the macro again to mount when your already mounted",
							get = function(info) return Display.db.profile.OneClickMount end,
							set = function(info, v)	Display.db.profile.OneClickMount = v	end,
							order = 2,
							width = "double",
						},
						SafeDismount = {
							type = "toggle",
							name = "Safe Dismount",
							desc = "This will make it so you will need to click the macro 2 times in under 1 sec in order to dismount.",
							get = function(info) return Display.db.profile.SafeDismount end,
							set = function(info, v)	Display.db.profile.SafeDismount = v	end,
							order = 3,
							width = "double",
						},
						UseDruidForm = {
							type = "toggle",
							name = "Use Druid Form",
							desc = "This will make it so druids use there flying forms instead of normal mounts.",
							get = function(info) return Display.db.profile.UseDruidForm end,
							set = function(info, v)	Display.db.profile.UseDruidForm = v FCDMountMacro()	end,
							order = 4,
							width = "double",
						},
						IncludeFFMount = {
							type = "toggle",
							name = "Include 280%",
							desc = "This will include 280% mounts even when you have 310% mount.",
							get = function(info) return Display.db.profile.IncludeFFMount end,
							set = function(info, v)	Display.db.profile.IncludeFFMount = v	end,
							order = 4.1,
							width = "double",
						},
						DruidFormOneClick = {
							type = "toggle",
							name = "Druid One Click",
							desc = "This will remove the need to click the macro again to mount when your already mounted, like powershifting.\nNote: Flying only",
							get = function(info) return Display.db.profile.DruidFormOneClick end,
							set = function(info, v)	Display.db.profile.DruidFormOneClick = v FCDMountMacro() end,
							order = 4.5,
							width = "double",
						},
						DruidFormOneClickInDoor = {
							type = "toggle",
							name = "Druid One Click InDoors",
							desc = "This is like Druid One Click but will limit it to InDoors, this means you can use the FCDMount Macro to remove shapeshift form",
							get = function(info) return Display.db.profile.DruidFormOneClickInDoor end,
							set = function(info, v)	Display.db.profile.DruidFormOneClickInDoor = v FCDMountMacro() end,
							order = 4.6,
							width = "double",
						},
						OculusMounts = {
							type = "toggle",
							name = "Oculus Mounts",
							desc = "This will change the macro for Oculus mounts",
							get = function(info) return Display.db.profile.OculusMounts end,
							set = function(info, v)	Display.db.profile.OculusMounts = v	end,
							order = 5,
							width = "double",
						},
						DBWRemove = {
							type = "toggle",
							name = "Remove DBW Proc's",
							desc = "This will remove DBW Procs allowing you to mount",
							get = function(info) return Display.db.profile.DBWRemove end,
							set = function(info, v)	Display.db.profile.DBWRemove = v end,
							order = 5.2,
							width = "double",
						},
						ARD2222 = {
							type = "description",
							name =  "",
							width = "full",
							fontSize  = "medium",
							order = 5.5,
		  				},
						GMountList = {
							type = "select",
							name =  "Blacklist: Ground Mount",
							desc =  "Add a mount to the blacklist.",
							values = function(info)
							local Mounts = {}
								for MountIndex, MountTable in pairs(FatCooldowns.GroundMountInfo) do
									local name, rank, icon = GetSpellInfo(MountIndex)
									if name ~= nil then Mounts[name] = "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..name end
								end
								return Mounts
							end,
							get = function(info) return nil end,
							set = function(info, v) Display.db.profile.MountBlackList[v] = v end,
							order = 6,
							width = "double",
						},	
						FGMountList = {
							type = "select",
							name =  "Blacklist: Fast Ground Mount",
							desc =  "Add a mount to the blacklist.",
							values = function(info)
							local Mounts = {}
								for MountIndex, MountTable in pairs(FatCooldowns.FastGroundMountInfo) do
									local name, rank, icon = GetSpellInfo(MountIndex)
									if name ~= nil then Mounts[name] = "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..name end
								end
								return Mounts
							end,
							get = function(info) return nil end,
							set = function(info, v) Display.db.profile.MountBlackList[v] = v end,
							order = 7,
							width = "double",
						},			
						FLGMountList = {
							type = "select",
							name =  "Blacklist: Flying Mount",
							desc =  "Add a mount to the blacklist.",
							values = function(info)
							local Mounts = {}
								for MountIndex, MountTable in pairs(FatCooldowns.FlyingMountInfo) do
									local name, rank, icon = GetSpellInfo(MountIndex)
									if name ~= nil then Mounts[name] = "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..name end
								end
								return Mounts
							end,
							get = function(info) return nil end,
							set = function(info, v) Display.db.profile.MountBlackList[v] = v end,
							order = 8,
							width = "double",
						},		
						FFLGMountList = {
							type = "select",
							name =  "Blacklist: Fast Flying Mount",
							desc =  "Add a mount to the blacklist.",
							values = function(info)
							local Mounts = {}
								for MountIndex, MountTable in pairs(FatCooldowns.FastFlyingMountInfo) do
									local name, rank, icon = GetSpellInfo(MountIndex)
									if name ~= nil then Mounts[name] = "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..name end
								end
								return Mounts
							end,
							get = function(info) return nil end,
							set = function(info, v) Display.db.profile.MountBlackList[v] = v end,
							order = 9,
							width = "double",
						},	
						EMountList = {
							type = "select",
							name =  "Blacklist: Epic Flying Mount",
							desc =  "Add a mount to the blacklist.",
							values = function(info)
							local Mounts = {}
								for MountIndex, MountTable in pairs(FatCooldowns.EpicFlyingMountInfo) do
									local name, rank, icon = GetSpellInfo(MountIndex)
									if name ~= nil then Mounts[name] = "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..name end
								end
								return Mounts
							end,
							get = function(info) return nil end,
							set = function(info, v) Display.db.profile.MountBlackList[v] = v end,
							order = 10,
							width = "double",
						},
						RMountList = {
							type = "select",
							name =  "Remove From Blacklist",
							desc =  "remove a mount from the blacklist.",
							values = function(info)	
							local Mounts = {}
								for BMountOne, BMountTwo in pairs(Display.db.profile.MountBlackList) do
									for MountIndex, MountTable in pairs(FatCooldowns.EpicFlyingMountInfo) do
										local name, rank, icon = GetSpellInfo(MountIndex)
										if name == BMountOne then Mounts[name] = "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..name end
									end

									for MountIndex, MountTable in pairs(FatCooldowns.FastFlyingMountInfo) do
										local name, rank, icon = GetSpellInfo(MountIndex)
										if name == BMountOne then Mounts[name] = "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..name end
									end

									for MountIndex, MountTable in pairs(FatCooldowns.FlyingMountInfo) do
										local name, rank, icon = GetSpellInfo(MountIndex)
										if name == BMountOne then Mounts[name] = "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..name end
									end

									for MountIndex, MountTable in pairs(FatCooldowns.FastGroundMountInfo) do
										local name, rank, icon = GetSpellInfo(MountIndex)
										if name == BMountOne then Mounts[name] = "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..name end
									end

									for MountIndex, MountTable in pairs(FatCooldowns.GroundMountInfo) do
										local name, rank, icon = GetSpellInfo(MountIndex)
										if name == BMountOne then Mounts[name] = "|T"..icon..":24:24:0:0:64:64:6:58:6:58|t "..name end
									end
								end
								return Mounts
							end,
							get = function(info) return nil end,
							set = function(info, v) Display.db.profile.MountBlackList[v] = nil end,
							order = 11,
							width = "full",
						},	
					},
				},
				OT9 = {
					type = "group",
					name = "Controlled",
					desc = "Configure Controlled Options",
					order = 9,
					childGroups = "tab",
					args = {
						CCD2 = {
							type = "description",
							name =  "Controlled will allow you to play sounds and/or print messages in chat when you or another player is controlled e.g. PlayerName: Silence - 5 Sec\n",
							width = "full",
							fontSize  = "medium",
							order = 0.1,
		  				},
						CInt = {
							type = "toggle",
							name =  "Enable Interupted",
							desc =  "Enables Interupted Options.",
							get = function(info) return Display.db.profile.CInt end,
							set = function(info, v)	Display.db.profile.CInt = v end,
							order = 1,
							width = "full",
						},
						CIntPC =  {
							type = "select",
							name =  "Party Chat",
							desc =  "Sends the message to the selected chat when in a party group.",
							values = {[1] = "Disable", [2] = "Say", [3] = "Yell", [4] = "Party"},
							get = function(info, v, v2) return Display.db.profile.CIntPC end,
							set = function(info, v, v2) Display.db.profile.CIntPC = v end,
							order = 2,
						},
						CIntRC =  {
							type = "select",
							name =  "Raid Chat",
							desc =  "Sends the message to the selected chat when in a raid group.",
							values = {[1] = "Disable", [2] = "Say", [3] = "Yell", [4] = "Raid"},
							get = function(info, v, v2) return Display.db.profile.CIntRC end,
							set = function(info, v, v2) Display.db.profile.CIntRC = v end,
							order = 3,
						},
						CIntS =  {
							type = "select",
							name =  "Sound",
							desc =  "Plays the sound when Interupted.",
							values = function()
							local SoundName = {}
								for CustomSoundName, CustomSoundPath in pairs(FatCooldowns.FCDSounds) do
									SoundName[CustomSoundName] = CustomSoundName
								end
								return SoundName
							end,
							get = function(info, v, v2) return Display.db.profile.CIntS end,
							set = function(info, v, v2) Display.db.profile.CIntS = v PlaySoundFile(FatCooldowns.FCDSounds[v], "Master",false) end,
							order = 4,
							width = "double",
						},
						CIntHealer = {
							type = "toggle",
							name =  "Healer Only",
							desc =  "Triggers only when the Interupted player is a healer.",
							get = function(info, v) return Display.db.profile.CIntHealer end,
							set = function(info, v, v2) Display.db.profile.CIntHealer = v end,
							order = 5,
						},
						CIntPlayer = {
							type = "toggle",
							name =  "Player Only",
							desc =  "Triggers only when you are the Interupted player.",
							get = function(info, v) return Display.db.profile.CIntPlayer end,
							set = function(info, v, v2) Display.db.profile.CIntPlayer = v end,
							order = 6,
						},
						CIntArena = {
							type = "toggle",
							name =  "Arena Only",
							desc =  "Triggers only when you are in arena.",
							get = function(info, v) return Display.db.profile.CIntArena end,
							set = function(info, v, v2) Display.db.profile.CIntArena = v end,
							order = 7,
						},
						CIntRoleMessage = {
							type = "toggle",
							name =  "Inc Role Message",
							desc =  "Adds the players role into the message e.g. Healer PlayerName: Interupted - 5 Sec",
							get = function(info, v) return Display.db.profile.CIntRoleMessage end,
							set = function(info, v, v2) Display.db.profile.CIntRoleMessage = v end,
							order = 8,
						},
						CIntMinDur = {
							type = "range",
							name = "Min Duration",
							desc = "Only Trigger if above the min duration",
							min = 1, max = 10, step = 0.1, bigStep = 0.1,
							get = function(v) return Display.db.profile.CIntMinDur end,
							set = function(info, v) Display.db.profile.CIntMinDur = v end,
							order = 8.5,
							width = "full",
						},
						CHeader = {
							type = "header",
							name =  "",
							width = "full",
							order = 9,
						},
						CCC = {
							type = "toggle",
							name =  "Enable CC",
							desc =  "Enables CC Options.",
							get = function(info) return Display.db.profile.CCC end,
							set = function(info, v)	Display.db.profile.CCC = v end,
							order = 10,
							width = "full",
						},	
						CCCPC =  {
							type = "select",
							name =  "Party Chat",
							desc =  "Sends the message to the selected chat when in a party group.",
							values = {[1] = "Disable", [2] = "Say", [3] = "Yell", [4] = "Party"},
							get = function(info, v, v2) return Display.db.profile.CCCPC end,
							set = function(info, v, v2) Display.db.profile.CCCPC = v end,
							order = 12,
						},
						CCCRC =  {
							type = "select",
							name =  "Raid Chat",
							desc =  "Sends the message to the selected chat when in a raid group.",
							values = {[1] = "Disable", [2] = "Say", [3] = "Yell", [4] = "Raid"},
							get = function(info, v, v2) return Display.db.profile.CCCRC end,
							set = function(info, v, v2) Display.db.profile.CCCRC = v end,
							order = 13,
						},
						CCCS =  {
							type = "select",
							name =  "Sound",
							desc =  "Plays the sound when Interupted.",
							values = function()
							local SoundName = {}
								for CustomSoundName, CustomSoundPath in pairs(FatCooldowns.FCDSounds) do
									SoundName[CustomSoundName] = CustomSoundName
								end
								return SoundName
							end,
							get = function(info, v, v2) return Display.db.profile.CCCS end,
							set = function(info, v, v2) Display.db.profile.CCCS = v PlaySoundFile(FatCooldowns.FCDSounds[v], "Master",false) end,
							order = 14,
							width = "double",
						},
						CCCHealer = {
							type = "toggle",
							name =  "Healer Only",
							desc =  "Triggers only when the Interupted player is a healer.",
							get = function(info, v) return Display.db.profile.CCCHealer end,
							set = function(info, v, v2) Display.db.profile.CCCHealer = v end,
							order = 15,
						},
						CCCPlayer = {
							type = "toggle",
							name =  "Player Only",
							desc =  "Triggers only when you are the Interupted player.",
							get = function(info, v) return Display.db.profile.CCCPlayer end,
							set = function(info, v, v2) Display.db.profile.CCCPlayer = v end,
							order = 16,
						},						
						CCCArena = {
							type = "toggle",
							name =  "Arena Only",
							desc =  "Triggers only when you are in arena.",
							get = function(info, v) return Display.db.profile.CCCArena end,
							set = function(info, v, v2) Display.db.profile.CCCArena = v end,
							order = 17,
						},
						CCCRoleMessage = {
							type = "toggle",
							name =  "Inc Role Message",
							desc =  "Adds the players role into the message e.g. Healer PlayerName: Silence - 5 Sec",
							get = function(info, v) return Display.db.profile.CCCRoleMessage end,
							set = function(info, v, v2) Display.db.profile.CCCRoleMessage = v end,
							order = 18,
						},
						CCCMinDur = {
							type = "range",
							name = "Min Duration",
							desc = "Only Trigger if above the min duration",
							min = 1, max = 10, step = 0.1, bigStep = 0.1,
							get = function(v) return Display.db.profile.CCCMinDur end,
							set = function(info, v) Display.db.profile.CCCMinDur = v end,
							order = 19,
							width = "full",
						},
					},
				},
				OT10 = {
					type = "group",
					name = "Buff Removal",
					desc = "Configure Controlled Options",
					order = 10,
					childGroups = "tab",
					args = {
						CCD2 = {
							type = "description",
							name =  "Buff Removal will allow you to auto remove buffs\n",
							width = "full",
							fontSize  = "medium",
							order = 0.1,
		  				},
						ABRemovalAdd = {
							type = "input",
							name =  "Add Buff To Removal List (Drag and Drop, Shift-Click Link Items or Enter Spell ID)",
							get = function(info) return nil end,
							set = function(info, v) 
								if v == nil or v == "" then return end
								if v:find("%d+") then v = "spell:"..v end
								if not v:find("spell:[%d]+") then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter a Item Link") end
								local ItemID = select(3,strfind(v, "spell:(%d+)"))
								if ItemID ~= nil then
									Display.db.profile.ABRemovalList[ItemID] = ItemID
								else 
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("Warning: Failed to add Buff "..v..", Please Shift Click the item to link, Drag and drop the Item or Enter Spell ID.")
								end
							end,
							order = 1,
							width = "full",
						},
						ABRemovalList = {
							 name = "Sell List: Click To Remove Spell",
							 order = 2,
							 type = "group",
							 inline = true,
							 args = {
								theList = {
								   type = "select",
								   dialogControl = "MSItemSelectList",
								   name = "Anyname",
								   desc = "#ItemTooltip#",
								   width = "full",
								   values = function () return FillBuffList() end,
								   get = function () return CurrrentSelectedBuff end,			
								   set = function (info, key) RemoveBuffList(key) CurrrentSelectedBuff = key end,			
								},
							 },
		  				},
					},
				},
				OT12 = {
					type = "group",
					name = "Disenchant",
					desc = "Disenchant Options",
					order = 12,
					args = {
						DEDesc1 = {
							type = "description",
							name =  "Disenchant will disenchant items based on the options below, will not disenchant items in Equipment Manager, Outfitter and ItemRack.\n\n",
							width = "full",
							fontSize  = "medium",
							order = 0.5,
						},
		  				CreateMacro = {
							type = "execute",
							name =  "Create Macro",
							func = function() 
								local HasMacro = false
								local NumGlobal = GetNumMacros()
								for i = 1, NumGlobal, 1 do
									local MacroName, MacroIcon, MacroBody  = GetMacroInfo(i)
									if string.find(string.lower(MacroBody), string.lower("/fcd de")) then
										HasMacro = true
									end
								end
								if HasMacro then 
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: You already have the macro")
								elseif NumGlobal == 36 then
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: You have the max number of macros")
								else
									CreateMacro("FCD DE", 1, "#showtooltip Disenchant\n/fcd de", nil, nil)
									FCDMountMacro()
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Macro Created")
								end
							end,
							order = 1,
						},
						DEDesc2 = {
							type = "description",
							name =  "",
							width = "full",
							fontSize  = "medium",
							order = 1.1,
		  				},
						DEQuality = {
							type = "multiselect",
							name =  "Loot Quality",
							desc = "Disenchant the selected loot quality",
							values = {[2] = "|cff1eff00Uncommon|r", [3] = "|cff0070ddRare|r", [4] = "|cffa335eeEpic|r"},
							get = function(info, v) return Display.db.profile.DEQuality[v] end,
							set = function(info, v, v2)	Display.db.profile.DEQuality[v] = v2 end,
							order = 3,
						},
						DEItemTypeLimiter = {
							type = "multiselect",
							name =  "Loot Type Limiter",
							desc = "Select to allow disenchant of item type",
							values = {[1] = "Weapons", [2] = "Armor"},
							get = function(info, v) return Display.db.profile.DEItemTypeLimiter[v] end,
							set = function(info, v, v2)	Display.db.profile.DEItemTypeLimiter[v] = v2 end,
							order = 3.2,
						},
						MinIlvlRange = {
							type = "range",
							name = "Min Ilevel",
							desc = "Limits the disenchant to items above this range.",
							min = 1, max = 277, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.MinIlvlRange end,
							set = function(info, v) Display.db.profile.MinIlvlRange = v end,
							order = 3.5,
							width = "double",
						},
						MaxIlvlRange = {
							type = "range",
							name = "Max Ilevel",
							desc = "Limits the disenchant to items below this range.",
							min = 1, max = 277, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.MaxIlvlRange end,
							set = function(info, v) Display.db.profile.MaxIlvlRange = v end,
							order = 3.5,
							width = "double",
						},
						AucMinPrice = {
							type = "range",
							name = function () return "Auctioneer Min Price "..GetCoinTextureString(Display.db.profile.FCDAucMinPrice) end,
							desc = "Limits the disenchant to items below this range.",
							min = 1, max = 5000000, step = 1, bigStep = 1,
							hidden = function()
								local Val = true
								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then Val = false end
								return Val
							end,
							get = function(v) return Display.db.profile.FCDAucMinPrice end,
							set = function(info, v) Display.db.profile.FCDAucMinPrice = v end,
							order = 4,
							width = "double",
						},
						AucMarketPrice = {
							type = "range",
							name = function () return "Auctioneer Market Price "..GetCoinTextureString(Display.db.profile.FCDAucMarketPrice) end,
							desc = "Limits the disenchant to items below this range.",
							min = 1, max = 5000000, step = 1, bigStep = 1,
							hidden = function()
								local Val = true
								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then Val = false end
								return Val
							end,
							get = function(v) return Display.db.profile.FCDAucMarketPrice end,
							set = function(info, v) Display.db.profile.FCDAucMarketPrice = v end,
							order = 5,
							width = "double",
						},
						DisenchantVMinPrice = {
							type = "toggle",
							name = "Disenchant Value > Auctioneer Min Price",
							desc = "Limits Disenchant for items that have a disenchant value higher than Auctioneer Min Price \n\nNote: if no min price it will check the market price",
							get = function(info) return Display.db.profile.DisenchantVMinPrice end,
							set = function(info, v)	Display.db.profile.DisenchantVMinPrice = v  end,
							hidden = function()
								local Val = true
								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then Val = false end
								return Val
							end,
							order = 6,
							width = "double",
						},
						DisenchantVMarketPrice = {
							type = "toggle",
							name = "Disenchant Value > Auctioneer Market Price",
							desc = "Limits Disenchant for items that have a disenchant value higher than Auctioneer Market Price",
							hidden = function()
								local Val = true
								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then Val = false end
								return Val
							end,
							get = function(info) return Display.db.profile.DisenchantVMarketPrice end,
							set = function(info, v)	Display.db.profile.DisenchantVMarketPrice = v  end,
							order = 7,
							width = "double",
						},
						DisenchantVVendorPrice = {
							type = "toggle",
							name = "Disenchant Value > Vendor Price",
							desc = "Limits Disenchant for items that have a disenchant value higher than Vendor Price.\n\nNote: Needs Auctioneer or Auctionator",
							hidden = function()
								local Val = true
								if select(4, GetAddOnInfo("Auctionator")) == 1 then Val = false end
								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then Val = false end
								return Val
							end,
							get = function(info) return Display.db.profile.DisenchantVVendorPrice end,
							set = function(info, v)	Display.db.profile.DisenchantVVendorPrice = v  end,
							order = 7.5,
							width = "double",
						},
						AucSeenCount = {
							type = "range",
							name = "Seen Count",
							desc = "Items below the seen count will not be price checked with Disenchant Value > Auctioneer Min/Market Price.",
							min = 0, max = 100, step = 1, bigStep = 1,
							hidden = function()
								local Val = true
								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then Val = false end
								return Val
							end,
							get = function(v) return Display.db.profile.AucSeenCount end,
							set = function(info, v) Display.db.profile.AucSeenCount = v end,
							order = 8,
							width = "double",
						},
						DisenchantPrint = {
							type = "toggle",
							name = "Print Disenchant Message",
							desc = "Prints a message in chat when you disenchant",
							get = function(info) return Display.db.profile.DisenchantPrint end,
							set = function(info, v)	Display.db.profile.DisenchantPrint = v  end,
							order = 9,
							width = "double",
						},
						AddLootDisenchantList = {
							type = "input",
							name =  "Add Item To Disenchant Blacklist",
							get = function(info) return nil end,
							set = function(info, v) 
								if v == nil then return end
								if not v:find("item:[%d]+") then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter a Item Link") end
								local ItemID = select(3,strfind(v, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
								if ItemID ~= nil then
									Display.db.profile.DisenchantBlackList[ItemID] = ItemID
								else 
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("Warning: Failed to add Item "..v..", Please Shift Click the item to link or Drag and drop the Item.")
								end
							end,
							order = 58,
							width = "full",
						},
						DisenchantTrashList = {
							 name = "Disenchant BlackList: Click To Remove Item",
							 order = 59,
							 type = "group",
							 inline = true,
							 args = {
								theList = {
								   type = "select",
								   dialogControl = "MSItemSelectList",
								   name = "Anyname",
								   desc = "#ItemTooltip#",
								   width = "full",
								   values = function () return FillDisenchantList() end,
								   get = function () return CurrrentSelectedDisenchantItem end,			
								   set = function (info, key) RemoveItemDisenchantList(key) CurrrentSelectedDisenchantItem = key end,			
								},
							 },
		  				},
					},
				},
				OT13 = {
					type = "group",
					name = "Screenshot",
					desc = "Screenshot Options",
					order = 13,
					args = {
						ScreenShotDesc1 = {
							type = "description",
							name =  "Screenshot will allow you to automatically take screenshots.\n\n",
							width = "full",
							fontSize  = "medium",
							order = 0.5,
		  				},
						SSHeader1 = {
							type = "header",
							name =  "",
							width = "full",
							order = 1,
						},
						SSDeath = {
							type = "toggle",
							name =  "Death",
							desc =  "Automatically take screenshots when you die",
							get = function(info) return Display.db.profile.SSDeath end,
							set = function(info, v)	Display.db.profile.SSDeath = v end,
							order = 2,
						},
						SSDeathHide = {
							type = "toggle",
							name =  "Hide UI",
							desc =  "Hide UI when taking a screenshot",
							get = function(info) return Display.db.profile.SSDeathHide end,
							set = function(info, v)	Display.db.profile.SSDeathHide = v end,
							order = 3,
						},
		  				SSDeathDelay = {
							type = "range",
							name =  "Delay",
							desc =  "Adds a small delay to taking screenshots",
							min = 0, max = 10, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.SSDeathDelay end,
							set = function(info, v)	Display.db.profile.SSDeathDelay = v end,
							order = 4,
						},
						SSDeathInBG = {
							type = "toggle",
							name =  "Include PVP",
							desc =  "Includes Arena and BGs",
							get = function(info) return Display.db.profile.SSDeathInBG end,
							set = function(info, v)	Display.db.profile.SSDeathInBG = v end,
							order = 4.5,
						},
						SSHeader2 = {
							type = "header",
							name =  "",
							width = "full",
							order = 5,
						},
						SSAchiv = {
							type = "toggle",
							name =  "Achievements",
							desc =  "Automatically take screenshots on achievements",
							get = function(info) return Display.db.profile.SSAchiv end,
							set = function(info, v)	Display.db.profile.SSAchiv = v end,
							order = 6,
						},
						SSAchivHide = {
							type = "toggle",
							name =  "Hide UI",
							desc =  "Hide UI when taking a screenshot",
							get = function(info) return Display.db.profile.SSAchivHide end,
							set = function(info, v)	Display.db.profile.SSAchivHide = v end,
							order = 7,
						},
		  				SSAchivDelay = {
							type = "range",
							name =  "Delay",
							desc =  "Adds a small delay to taking screenshots",
							min = 0, max = 10, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.SSAchivDelay end,
							set = function(info, v)	Display.db.profile.SSAchivDelay = v end,
							order = 8,
						},
						SSHeader3 = {
							type = "header",
							name =  "",
							width = "full",
							order = 9,
						},
						SSLvl = {
							type = "toggle",
							name =  "Level",
							desc =  "Automatically take screenshots when you level up",
							get = function(info) return Display.db.profile.SSLvl end,
							set = function(info, v)	Display.db.profile.SSLvl = v end,
							order = 10,
						},
						SSLvlHide = {
							type = "toggle",
							name =  "Hide UI",
							desc =  "Hide UI when taking a screenshot",
							get = function(info) return Display.db.profile.SSLvlHide end,
							set = function(info, v)	Display.db.profile.SSLvlHide = v end,
							order = 11,
						},
		  				SSLvlDelay = {
							type = "range",
							name =  "Delay",
							desc =  "Adds a small delay to taking screenshots",
							min = 0, max = 10, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.SSLvlDelay end,
							set = function(info, v)	Display.db.profile.SSLvlDelay = v end,
							order = 12,
						},
						SSHeader4 = {
							type = "header",
							name =  "",
							width = "full",
							order = 13,
						},
						SSBoss = {
							type = "toggle",
							name =  "Boss",
							desc =  "Automatically take screenshots when you kill a boss\n\nLimited for now",
							get = function(info) return Display.db.profile.SSBoss end,
							set = function(info, v)	Display.db.profile.SSBoss = v end,
							order = 14,
						},
						SSBossHide = {
							type = "toggle",
							name =  "Hide UI",
							desc =  "Hide UI when taking a screenshot",
							get = function(info) return Display.db.profile.SSBossHide end,
							set = function(info, v)	Display.db.profile.SSBossHide = v end,
							order = 15,
						},
		  				SSBossDelay = {
							type = "range",
							name =  "Delay",
							desc =  "Adds a small delay to taking screenshots",
							min = 0, max = 10, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.SSBossDelay end,
							set = function(info, v)	Display.db.profile.SSBossDelay = v end,
							order = 16,
						},
						SSHeader5 = {
							type = "header",
							name =  "",
							width = "full",
							order = 18,
						},
						SSBG = {
							type = "toggle",
							name =  "Battleground",
							desc =  "Automatically take screenshots when battleground ends",
							get = function(info) return Display.db.profile.SSBG end,
							set = function(info, v)	Display.db.profile.SSBG = v end,
							order = 19,
						},
						SSBGHide = {
							type = "toggle",
							name =  "Hide UI",
							desc =  "Hide UI when taking a screenshot",
							get = function(info) return Display.db.profile.SSBGHide end,
							set = function(info, v)	Display.db.profile.SSBGHide = v end,
							order = 20,
						},
		  				SSBGDelay = {
							type = "range",
							name =  "Delay",
							desc =  "Adds a small delay to taking screenshots",
							min = 0, max = 10, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.SSBGDelay end,
							set = function(info, v)	Display.db.profile.SSBGDelay = v end,
							order = 21,
						},
						SSHeader6 = {
							type = "header",
							name =  "",
							width = "full",
							order = 22,
						},
						SSArena = {
							type = "toggle",
							name =  "Arena",
							desc =  "Automatically take screenshots when arena ends",
							get = function(info) return Display.db.profile.SSArena end,
							set = function(info, v)	Display.db.profile.SSArena = v end,
							order = 23,
						},
						SSArenaHide = {
							type = "toggle",
							name =  "Hide UI",
							desc =  "Hide UI when taking a screenshot",
							get = function(info) return Display.db.profile.SSArenaHide end,
							set = function(info, v)	Display.db.profile.SSArenaHide = v end,
							order = 24,
						},
		  				SSArenaDelay = {
							type = "range",
							name =  "Delay",
							desc =  "Adds a small delay to taking screenshots",
							min = 0, max = 10, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.SSArenaDelay end,
							set = function(info, v)	Display.db.profile.SSArenaDelay = v end,
							order = 25,
						},
						SSHeader7 = {
							type = "header",
							name =  "",
							width = "full",
							order = 26,
						},
						SSTrade = {
							type = "toggle",
							name =  "Trade",
							desc =  "Automatically take screenshots on trades",
							get = function(info) return Display.db.profile.SSTrade end,
							set = function(info, v)	Display.db.profile.SSTrade = v end,
							order = 27,
						},
						SSTradeHide = {
							type = "toggle",
							name =  "Hide UI",
							desc =  "Hide UI when taking a screenshot",
							get = function(info) return Display.db.profile.SSTradeHide end,
							set = function(info, v)	Display.db.profile.SSTradeHide = v end,
							order = 28,
						},
		  				SSTradeDelay = {
							type = "range",
							name =  "Delay",
							desc =  "Adds a small delay to taking screenshots",
							min = 0, max = 10, step = 1, bigStep = 1,
							get = function(info) return Display.db.profile.SSTradeDelay end,
							set = function(info, v)	Display.db.profile.SSTradeDelay = v end,
							order = 29,
						},
					},
				},
				OT14 = {
					type = "group",
					name = "Trader",
					desc = "Trader Options",
					order = 13,
					args = {
						ScreenShotDesc1 = {
							type = "description",
							name =  "Trader will allow you to auto select items to trade, you will still need to click the trade button to finish trading.\n\n",
							width = "full",
							fontSize  = "medium",
							order = 0.5,
		  				},
		  				Enable = {
							type = "toggle",
							name =  "Enable",
							desc =  "enable the auto trading",
							get = function(v) return Display.db.profile.Trade end,
							set = function(info, v) Display.db.profile.Trade = v end,
							order = 1,
							width = "double",
						},
		  				EnableBTN = {
							type = "toggle",
							name =  "Trade Window Buttons",
							desc =  "enable the trading frame buttons",
							get = function(v) return Display.db.profile.TradeButtons end,
							set = function(info, v) Display.db.profile.TradeButtons = v end,
							order = 1,
							width = "double",
						},
						TradeMageDrinks = {
							type = "header",
							name =  "Mage Drinks",
							width = "full",
							order = 1.9,
						},
						TradeDrinksS = {
							type = "range",
							name =  "Solo: Amount",
							desc =  "Set the number of drinks to trade",
							min = 1, max = 20, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.TradeDrinksSolo end,
							set = function(info, v) Display.db.profile.TradeDrinksSolo = v end,
							order = 2,
						},
						TradeDrinksP = {
							type = "range",
							name =  "Party: Amount",
							desc =  "Set the number of drinks to trade",
							min = 1, max = 20, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.TradeDrinksP end,
							set = function(info, v) Display.db.profile.TradeDrinksP = v end,
							order = 2.1,
						},
						TradeDrinksR = {
							type = "range",
							name =  "Raid: Amount",
							desc =  "Set the number of drinks to trade",
							min = 1, max = 20, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.TradeDrinksR end,
							set = function(info, v) Display.db.profile.TradeDrinksR = v end,
							order = 2.2,
						},
						TradeDrinkClasses = {
							type = "multiselect",
							name =  "Classes",
							desc =  "enable the auto trading of drinks for the selected classes",
							get = function(info, v) return Display.db.profile.TradeDrinkClasses[v] end,
							set = function(info, v, v2) Display.db.profile.TradeDrinkClasses[v] = v2 end,
							values = function(info, v) if FatCooldowns.ExPac == 2 then
								return {
									["DEATH KNIGHT"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t |cffC41F3BDEATHKNIGHT|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t", 
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								else return {
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								end
							end,
							order = 2.5,
						},
						TradeMageFood = {
							type = "header",
							name =  "Mage Food",
							width = "full",
							order = 2.9,
						},
						TradeFoodS = {
							type = "range",
							name =  "Solo: Amount",
							desc =  "Set the number of drinks to trade",
							min = 1, max = 20, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.TradeFoodSolo end,
							set = function(info, v) Display.db.profile.TradeFoodSolo = v end,
							order = 3.1,
						},
						TradeFoodP = {
							type = "range",
							name =  "Party: Amount",
							desc =  "Set the number of drinks to trade",
							min = 1, max = 20, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.TradeFoodP end,
							set = function(info, v) Display.db.profile.TradeFoodP = v end,
							order = 3.2,
						},
						TradeFoodR = {
							type = "range",
							name =  "Raid: Amount",
							desc =  "Set the number of drinks to trade",
							min = 1, max = 20, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.TradeFoodR end,
							set = function(info, v) Display.db.profile.TradeFoodR = v end,
							order = 3.3,
						},
						TradeFoodClasses = {
							type = "multiselect",
							name =  "Classes",
							desc =  "enable the auto trading of drinks for the selected classes",
							get = function(info, v) return Display.db.profile.TradeFoodClasses[v] end,
							set = function(info, v, v2) Display.db.profile.TradeFoodClasses[v] = v2 end,
							values = function(info, v) if FatCooldowns.ExPac == 2 then
								return {
									["DEATH KNIGHT"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t |cffC41F3BDEATHKNIGHT|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t", 
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								else return {
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								end
							end,
							order = 3.5,
						},
						TradeWarlock = {
							type = "header",
							name =  "Walock Healthstone",
							width = "full",
							order = 9,
						},
		  				TradeStone = {
							type = "multiselect",
							name =  "Classes",
							desc =  "enable the auto trading of healthstones for the selected classes",
							get = function(info, v) return Display.db.profile.TradeStone[v] end,
							set = function(info, v, v2) Display.db.profile.TradeStone[v] = v2 end,
							values = function(info, v) if FatCooldowns.ExPac == 2 then
								return {
									["DEATH KNIGHT"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t |cffC41F3BDEATHKNIGHT|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t", 
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								else return {
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								end
							end,
							order = 10,
						},
						TradRogue = {
							type = "header",
							name =  "Rogue",
							width = "full",
							order = 15,
						},
						Lockboxes = {
							type = "toggle",
							name =  "Lockboxes",
							desc =  "enable the auto trading, none trading opening slot.",
							get = function(v) return Display.db.profile.Lockboxes end,
							set = function(info, v) Display.db.profile.Lockboxes = v end,
							order = 16,
							width = "full",
						},
					},
				},
			},
		},	
		DisabledGroup3 = {
			type = "group",
			name = "-------------------",
			desc = "Spliter",
			cmdHidden = true,
			disabled = function() return true end,
			order = 5.4,
			args = {	
			},
		},	
		TrashManager = {
			type = "group",
			name = "Trash Manager",
			childGroups = "tab",
			desc = "Configure Trash Manager Options",
			cmdHidden = true,
			order = 5.5,
			args = {	
				GroupList1 = {
					order = 1,
					type = "group",
					name = "General Options",
					childGroups = "tab",
					args = {
						BMD = {
							type = "description",
							name =  "Trash Manager will auto delete items when your bags are getting full, starting with the lowest value items and it will sell items when at a vendor.\n\n",
							width = "full",
							fontSize  = "medium",
							order = 0.5,
						},
						EnablePopup = {
							type = "toggle",
							name =  "Destroy Items",
							desc =  "Destroy items on the sell list that are below the set price when low on bag space",
							get = function(info) return Display.db.profile.EnablePopup end,
							set = function(info, v)	Display.db.profile.EnablePopup = v Display:FCDDelPopup() end,
							order = 1,
						},
						AutoSell = {
							type = "toggle",
							name =  "Auto Sell Items",
							desc =  "Auto sell items on the sell list",
							get = function(info) return Display.db.profile.AutoSell end,
							set = function(info, v)	Display.db.profile.AutoSell = v	end,
							order = 2,
						},
						SellSilence = {
							type = "toggle",
							name =  "Silent",
							desc =  "Prevents the printing in chat of items being sold/Destroy.",
							get = function(info) return Display.db.profile.SellSilence end,
							set = function(info, v)	Display.db.profile.SellSilence = v	end,
							order = 3,
						},
						SellProtection = {
							type = "toggle",
							name =  "Sell Protection",
							desc =  "Limit the number of items being sold each time you talk to a vendor to 12 to protect again mistakes.",
							get = function(info) return Display.db.profile.SellProtection end,
							set = function(info, v)	Display.db.profile.SellProtection = v end,
							order = 3.5,
						},
						PriceRange = {
							type = "range",
							name = function () return "Max Price "..GetCoinTextureString(Display.db.profile.PriceRange) end,
							desc = "Auto delete items below this price when low on bag space",
							min = 1, max = 200000, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.PriceRange end,
							set = function(info, v) Display.db.profile.PriceRange = v end,
							order = 4,
							width = "double",
						},
						KeepSpaceFree = {
							type = "range",
							name = "|TInterface\\Icons\\inv_misc_bag_08:24:24:0:0:64:64:6:58:6:58|t Free Bag Space",
							desc = "Auto delete items when below this bag space",
							min = 1, max = 80, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.KeepSpaceFree end,
							set = function(info, v) Display.db.profile.KeepSpaceFree = v end,
							order = 5,
							width = "double",
						},
						SellSBItems = {
							type = "multiselect",
							name =  "Auto Sell Un-Equpiable Soulbound Equipment",
							desc =  "Auto Sells Un-Equpiable Soulbound Equipment.\n\nExample: Plate on Rogues",
							values = { [1] = "|cff1eff00Uncommon|r", [2] = "|cff0070ddRare|r", [3] = "|cffa335eeEpic|r"},
							get = function(info, v)	local TBVal = { [1] = 2, [2] = 3, [3] = 4} return Display.db.profile.SellSBItems[TBVal[v]]	end,
							set = function(info, v, v2) local TBVal = { [1] = 2, [2] = 3, [3] = 4} Display.db.profile.SellSBItems[TBVal[v]] = v2 end,
							order = 5.2,
							hidden = function() return not Display.db.profile.AutoSell end,
						},
						ExraAutoSell = {
							type = "multiselect",
							name =  "Extra Auto Sell and Destroy",
							desc =  "Low Level: Food & Drink, Scrolls\nWhite Equipment",
							confirm = function(info, v, v2) if v2 == true and v == 3 then return "|cfffff600Warning|r: This may result in some White items being delete/sold that you may have wanted." else return false end end,
							values = { [1] = "Food And Drink", [2] = "Scrolls", [3] = "White Equipment", [4] = "Recipes"},
							get = function(info, v)	local TBVal = { [1] = 1, [2] = 2, [3] = 3, [4] = 4} return Display.db.profile.ExraAutoSell[TBVal[v]] end,
							set = function(info, v, v2) local TBVal = { [1] = 1, [2] = 2, [3] = 3, [4] = 4} Display.db.profile.ExraAutoSell[TBVal[v]] = v2 end,
							order = 5.6,
						},
						TMFunctional = {
							type = "toggle",
							name =  "Soulbound Equipment: Functional",
							desc = "checks if the soulbound item is functional for use then it will sell the item\n\nSpellpower on warrior",
							get = function(info, v) return Display.db.profile.TMFunctional end,
							set = function(info, v)	Display.db.profile.TMFunctional = v end,
							order = 5.65,
							width = "double",
						},
						TMDisenchantVendorVal = {
							type = "toggle",
							name =  "Soulbound Equipment: Vendor Price > Disenchant",
							desc = "Sells soulbound items that have a vendor price over disenchant \n\nNote: Will enable Sell Protection",
							get = function(info, v) return Display.db.profile.TMDisenchantVendorVal end,
							set = function(info, v)	Display.db.profile.TMDisenchantVendorVal = v if v == true then Display.db.profile.SellProtection = v end end,
							hidden = function()
								local Val = true
								if select(4, GetAddOnInfo("Auctionator")) == 1 then Val = false end
								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then Val = false end
								return Val
							end,
							order = 5.7,
							width = "double",
						},
						FoodLvl = {
							type = "range",
							name = "Food Range",
							desc = "Change the level difference for deleting/selling food.\n\nPlayer Level - Food Ilevel > Food Range = Delete.\nLower number = sell higher level food",
							min = -30, max = 30, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.FoodLvl end,
							set = function(info, v) Display.db.profile.FoodLvl = v end,
							hidden = function() if Display.db.profile.ExraAutoSell[1] then return false elseif not Display.db.profile.ExraAutoSell[1] then return true end end,
							order = 5.9,
							width = "full",
						},
					},
				},
				GroupList2 = {
					order = 2,
					type = "group",
					name = "Sell List",
					childGroups = "tab",
					args = {
						AddLootSellList2 = {
							type = "input",
							name =  "Add Item To Sell/Destroy List (Drag and Drop or Shift-Click Link Items)",
							get = function(info) return nil end,
							set = function(info, v) 
								if v == nil then return end
								if not v:find("item:[%d]+") then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter a Item Link") end
								local ItemID = select(3,strfind(v, "|H(.+):.+|h%["))
								if ItemID ~= nil then
									Display.db.profile.SellList2[ItemID] = ItemID
								else 
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("Warning: Failed to add Item "..v..", Please Shift Click the item to link or Drag and drop the Item.")
								end
							end,
							order = 8,
							width = "full",
						},
						TrashList = {
							 name = "Sell List: Click To Remove Item",
							 order = 10,
							 type = "group",
							 inline = true,
							 args = {
								theList = {
								   type = "select",
								   dialogControl = "MSItemSelectList",
								   name = "Anyname",
								   desc = "#ItemTooltip#",
								   width = "full",
								   values = function () return FillTrashList() end,
								   get = function () return CurrrentSelectedTrash end,			
								   set = function (info, key) RemoveItemTrashList(key) CurrrentSelectedTrash = key end,			
								},
							 },
		  				},
					},
				},
				GroupList3 = {
					order = 3,
					type = "group",
					name = "Auto Delete List",
					childGroups = "tab",
					args = {
						AddLootDeleteList = {
							type = "input",
							name =  "Add Item To Auto Destroy List (Drag and Drop or Shift-Click Link Items)",
							get = function(info) return nil end,
							set = function(info, v) 
								if v == nil then return end
								if not v:find("item:[%d]+") then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter a Item Link") end
								local ItemID = select(3,strfind(v, "|H(.+):.+|h%["))
								if ItemID ~= nil then
									Display.db.profile.ADList2[ItemID] = ItemID
								else 
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("Warning: Failed to add Item "..v..", Please Shift Click the item to link or Drag and drop the Item.")
								end
							end,
							order = 8,
							width = "full",
						},
						ADList = {
							 name = "Auto Destroy List: Click To Remove Item",
							 order = 10,
							 type = "group",
							 inline = true,
							 args = {
								theList = {
								   type = "select",
								   dialogControl = "MSItemSelectList",
								   name = "Anyname",
								   desc = "#ItemTooltip#",
								   width = "full",
								   values = function () return FillADList() end,
								   get = function () return CurrrentSelectedAD end,			
								   set = function (info, key) RemoveItemTrashAD(key) CurrrentSelectedAD = key end,			
								},
							},
		  				},
					},
				},
			},
		},
		AutoMailer = {
			type = "group",
			name = "Auto Mail",
			desc = "Configure Auto Mail Options",
			cmdHidden = true,
			order = 5.7,
			args = {
				AuMD = {
					type = "description",
					name =  "Auto Mailer will allow you to auto send items to a player/alt everytime you go to the mailbox.\n\nNote: Holding Shift will disable this when opening the mail box\n\n",
					width = "full",
					fontSize  = "medium",
					order = 1,
  				},
				SilentMailer = {
					type = "toggle",
					name = "Slient Mail Items",
					desc =  "Stops printed messages when sending items via mail",
					get = function(info) return Display.db.profile.SilentMailer end,
					set = function(info, v)	Display.db.profile.SilentMailer = v	end,
					order = 1.5,
					--width = "double",
				},
				SilentAdd = {
					type = "toggle",
					name =  "Silent Add Items",
					desc = "Stops printed messages when adding items to the mailer list",
					get = function(info) return Display.db.profile.SilentAdd end,
					set = function(info, v)	Display.db.profile.SilentAdd = v	end,
					order = 2,
					--width = "double",
				},
				SilentRemove = {
					type = "toggle",
					name = "Slient Remove Items",
					desc =  "Stops printed messages when removing items from the mailer list",
					get = function(info) return Display.db.profile.SilentRemove end,
					set = function(info, v)	Display.db.profile.SilentRemove = v	end,
					order = 3,
					--width = "double",
				},
				AutoMailerPlayerAdd = {
					type = "input",
					name =  "Add Player",
					get = function(info) return nil end,
					set = function(info, v) 
						if v == nil or v == "" then return end
						if not v:find"[a-z,A-Z]+" then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AutoMailer: Please enter only letters") return end
						v = v:gsub("^%l", string.upper)
						if Display.db.profile.AutoMailerPlayers[v] ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AutoMailer: "..v.." already is listed") return end
						Display.db.profile.AutoMailerPlayers[v] = v
						Display.db.profile.LootMailerList[v] = {}
						RefreshFrameListOptionsAndVariables()
						LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
					end,
					order = 6,
					width = "double",
				},
				AutoMailerPlayersSelect = {
					type = "select",
					name =  "Players",
					desc = "Select a player to remove",
					values = function() 
						local tempval = {}
						for v,b in pairs(Display.db.profile.AutoMailerPlayers) do
							tempval[v] = v
						end
						return tempval
					end,
					get = function(info) return TempMailer end,
					set = function(info, v)	TempMailer = v end,
					order = 7,
				},
				AutoMailerPlayersRemove = {
					type = "execute",
					name =  "Remove",
					func = function() if TempMailer == nil then return else 
						Display.db.profile.AutoMailerPlayers[TempMailer] = nil
						options.args.AutoMailer.args[TempMailer] = nil
						RefreshFrameListOptionsAndVariables() 
						LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
						end
					end,
					order = 8,
				},
			},
		},
		AutoRoller = {
			type = "group",
			name = "Auto Roll",
			desc = "Configure Auto Roll Options",
			childGroups = "tab",
			cmdHidden = true,
			order = 5.72,
			args = {
				AutoRoller = {
					type = "group",
					name = "Main Options",
					order = 0.1,
					args = {
						ARD = {
							type = "description",
							name =  "Auto Roll will auto roll on items, when the loot system is set to group loot. it will check the settings in each tab working on a priority system checking in order 1-10\n",
							width = "full",
							fontSize  = "medium",
							order = 1,
		  				},
						ARCount = {
							type = "range",
							name = "Count",
							desc = "Set the Amount checks to run before auto rolling on items",
							min = 0, max = 10, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.ARCount end,
							set = function(info, v) Display.db.profile.ARCount = v FatCooldowns.RefreshFrameListOptionsAndVariables() end,
							order = 2,
							width = "double",
						},
						SilentARRemove = {
							type = "toggle",
							name = "Slient Roll On Items",
							desc =  "Stops printed messages when rolling on items",
							get = function(info) return Display.db.profile.SilentARRemove end,
							set = function(info, v)	Display.db.profile.SilentARRemove = v	end,
							order = 2.5,
							width = "double",
						},
						AddLootBlackList2 = {
							type = "input",
							name =  "Add Item To Blacklist (Drag and Drop or Shift-Click Link Items)",
							get = function(info) return nil end,
							set = function(info, v) 
								if v == nil then return end
								if not v:find("item:[%d]+") then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter a Item Link") end
								local ItemName, ItemLink = GetItemInfo(v)
								local ItemID = select(3,strfind(v, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
								if ItemName ~= nil and ItemLink ~= nil and ItemID ~= nil then
									Display.db.profile.LootBlackList2[ItemID] = ItemID
								else 
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("Warning: Failed to add Item "..v..", Please Shift Click the item to link or Drag and drop the Item.")
								end
							end,
							order = 3,
							width = "full",
						},
						LootBlackList2 = {
							 name = "Blacklist: Click To Remove Item",
							 order = 4,
							 type = "group",
							 inline = true,
							 args = {
								theList = {
								   type = "select",
								   dialogControl = "MSItemSelectList",
								   name = "Anyname",
								   desc = "#ItemTooltip#",
								   width = "full",
								   values = function () return FillBlackList() end,
								   get = function () return CurrrentSelectedBlackList end,			
								   set = function (info, key) RemoveItemBlackList(key) CurrrentSelectedBlackList = key end,			
								},
							},
		  				},
					},
				},
			},
		},
		AutoBuy = {
			type = "group",
			name = "AutoBuy",
			desc = "Configure AutoBuy Options",
			order = 5.73,
			childGroups = "tab",
			args = {
				ABEnable = {
					type = "toggle",
					name =  "Enable",
					desc =  "Enables Auto buying vendor items.",
					get = function(info) return Display.db.profile.ABEnable end,
					set = function(info, v)	Display.db.profile.ABEnable = v end,
					order = 0.1,
					width = "double",
				},
				ABAdd = {
					type = "input",
					name =  "Add: (Drag and Drop or Shift-Click Link Items)",
					get = function(info) return nil end,
					set = function(info, v) 
						if v == nil then return end
						if not v:find("item:[%d]+") then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter a Item Link") end
						local ItemName, ItemLink = GetItemInfo(v)
						local ItemID = select(3,strfind(v, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
						if ItemName ~= nil and ItemLink ~= nil and ItemID ~= nil then
							Display.db.profile.ABList[ItemID] = Display.db.profile.ABList[ItemID] or {}
							Display.db.profile.ABList[ItemID]["count"] =  Display.db.profile.ABList[ItemID]["count"] or 0
							Display.db.profile.ABList[ItemID]["shared"] = Display.db.profile.ABList[ItemID]["shared"] or false
							Display.db.profile.ABList[ItemID]["servers"] = Display.db.profile.ABList[ItemID]["servers"] or {}
						else 
							FatCooldowns:GetModule("Display"):FCDPrefixPrint("Warning: Failed to add Item "..v..", Please Shift Click the item to link or Drag and drop the Item. Note: you can only add none Soulbound items.")
						end
					end,
					order = 0.15,
					width = "double",
				},	
				ABH = {
					type = "header",
					name =  "Item Options",
					width = "full",
					order = 0.2,
				},
				droptarget = {
					type = "input",
					name = function()
						local itemName = CurrrentSelectedListAutoBuy and GetItemInfo(CurrrentSelectedListAutoBuy) or "Select an Item below"
						return itemName
					end,
					disabled = function() return true end,
					dialogControl = "MSDropTarget",
					desc = "#ItemToolTip#",
					get = function() return CurrrentSelectedListAutoBuy end,
					set = function(info, value) CurrrentSelectedListAutoBuy = value end,
					order = 1,
					width = "double",
				},
				ABEShared = {
					type = "toggle",
					name =  "Account Limiter",
					desc =  "Attempt to find out how many items you have on the account instead of your current bags.\n\nNote: Datashare addon is required",
					disabled = function() if CurrrentSelectedListAutoBuy == nil then return true else return false end end,
					get = function(info)
						if CurrrentSelectedListAutoBuy ~= nil then
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)")  
								return Display.db.profile.ABList[id]["shared"]
							else
								return false
							end
						end,
					set = function(info, v)
						if CurrrentSelectedListAutoBuy ~= nil then
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)")  
							Display.db.profile.ABList[id]["shared"] = v
						end
					end,
					order = 1.02,
				},
				ABClassFilter = {
					type = "toggle",
					name =  "Class",
					desc =  "enables the option to filter by class",
					disabled = function() if CurrrentSelectedListAutoBuy == nil then return true else return false end end,
					get = function(info)
						if CurrrentSelectedListAutoBuy ~= nil then
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)")  
								return Display.db.profile.ABList[id]["class"]
							else
								return false
							end
						end,
					set = function(info, v)
						if CurrrentSelectedListAutoBuy ~= nil then
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)")  
							Display.db.profile.ABList[id]["class"] = v
						end
					end,
					order = 1.022,
					width = "half",
				},
				ABListRemove = {
					type = "execute",
					name =  "Remove",
					disabled = function() if CurrrentSelectedListAutoBuy == nil then return true else return false end end,
					func = function() if CurrrentSelectedListAutoBuy == nil then return else 
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)") 
							CurrrentSelectedListAutoBuy = nil
							Display.db.profile.ABList[id] = nil
							RefreshFrameListOptionsAndVariables() 
							LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
						end
					end,
					order = 1.03,
					width = "half",
				},
				ABClasses = {
					type = "multiselect",
					name =  "Classes",
					desc =  "enable the autobuy for each server.",
					hidden = function()
						if CurrrentSelectedListAutoBuy == nil then
							return true
						else
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)")  
							if Display.db.profile.ABList[id]["class"] ~= nil then
								if Display.db.profile.ABList[id]["class"] then return false else return true end
							else
								return true
							end 
						end	
					end,
					values = function(info, v) if FatCooldowns.ExPac == 2 then
						return {
							["DEATH KNIGHT"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t |cffC41F3BDEATHKNIGHT|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t", 
							["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
							["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
							["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
							["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
							["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
							["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
							["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
							["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
							["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
						else return {
							["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
							["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
							["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
							["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
							["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
							["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
							["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
							["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
							["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
						end
					end,
					get = function(info, v, v2)
						if CurrrentSelectedListAutoBuy ~= nil then
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)") 
							Display.db.profile.ABList[id]["classes"] = Display.db.profile.ABList[id]["classes"] or {}
							return Display.db.profile.ABList[id]["classes"][v]
						else
							return false
						end
					end,
					set = function(info, v, v2)
						if CurrrentSelectedListAutoBuy ~= nil then
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)")
							Display.db.profile.ABList[id]["classes"] = Display.db.profile.ABList[id]["classes"] or {}
							Display.db.profile.ABList[id]["classes"][v] = v2 
						end
					end,
					order = 1.032,
				},
				ABListServer = {
					type = "multiselect",
					name =  "Servers",
					desc =  "enable the autobuy for each server.",
					values = function(info)
						if CurrrentSelectedListAutoBuy == nil then return {[GetRealmName()] = GetRealmName()}
						else
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)")
							Display.db.profile.ABList[id]["servers"] = Display.db.profile.ABList[id]["servers"] or {}
							if Display.db.profile.ABList[id]["servers"] ~= nil then
								local ReamlId = GetRealmName()
								if Display.db.profile.ABList[id]["servers"][ReamlId] == nil then Display.db.profile.ABList[id]["servers"][ReamlId] = false end
								local TempTable = {}
								for x,y in pairs(Display.db.profile.ABList[id]["servers"]) do
									TempTable[x] = x
								end
								return TempTable
							end
						end
					end,
					get = function(info, v, v2)
						if CurrrentSelectedListAutoBuy ~= nil then
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)") 
							Display.db.profile.ABList[id]["servers"] = Display.db.profile.ABList[id]["servers"] or {}
							return Display.db.profile.ABList[id]["servers"][v]
						else
							return false
						end
					end,
					set = function(info, v, v2)
						if CurrrentSelectedListAutoBuy ~= nil then
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)")
							Display.db.profile.ABList[id]["servers"] = Display.db.profile.ABList[id]["servers"] or {}
							Display.db.profile.ABList[id]["servers"][v] = v2 
						end
					end,
					order = 1.04,
				},
				ABRange = {
					type = "range",
					name = "Auto Buy Limiter",
					desc = "Set the limt on how many to buy",
					disabled = function() if CurrrentSelectedListAutoBuy == nil then return true else return false end end,
					min = 0, max = 500, step = 1, bigStep = 1,
					get = function(info)
						if CurrrentSelectedListAutoBuy ~= nil then
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)")  
								return Display.db.profile.ABList[id]["count"]
							else
								return 0
							end
						end,
					set = function(info, v)
						if CurrrentSelectedListAutoBuy ~= nil then
							local _, _, type, id = string.find(CurrrentSelectedListAutoBuy, "(%a+):(%-?%d+)")  
							Display.db.profile.ABList[id]["count"] = v
						end
					end,
					order = 1.1,
					width = "full",
				},
				ABList = {
					name = "|cffFFF468Auto Buy List: Shift-Click to Remove, Alt-Click To Lower Count, Control-Click To Increase Count.|r",
					order = 10,
					type = "group",
					args = {
						theList = {
							type = "select",
							dialogControl = "MSItemSelectListV2",
							name = "Anyname",
							desc = "#ItemTooltip#",
							width = "full",
							values = function () return FillAutoBuyList() end,
							get = function () return CurrrentSelectedAutoBuy end,			
							set = function (info, key)
								if IsShiftKeyDown() then
									RemoveItemAutoBuyList(key)
									CurrrentSelectedListAutoBuy = nil
									CurrrentSelectedAutoBuy = key
								elseif IsAltKeyDown() then
									local ItemID = select(3,strfind(ABListFilled[key], "^item:(%d+)"))
									Display.db.profile.ABList[ItemID]["count"] = Display.db.profile.ABList[ItemID]["count"] - 1
								elseif IsControlKeyDown() then
									local ItemID = select(3,strfind(ABListFilled[key], "^item:(%d+)"))
									Display.db.profile.ABList[ItemID]["count"] = Display.db.profile.ABList[ItemID]["count"] + 1
								else
									if ABListFilled and ABListFilled[key] then
										CurrrentSelectedListAutoBuy = ABListFilled[key]
									end
								end
							end, 
							order = 2,		  
						},
					},
				},
			},
		},
		AutoGear = {
			type = "group",
			name = "AutoGear",
			desc = "Configure AutoGear Options",
			order = 5.732,
			childGroups = "tab",
			args = {
			},
		},
		DisabledGroup421 = {
			type = "group",
			name = "-------------------",
			desc = "Spliter",
			cmdHidden = true,
			disabled = function() return true end,
			order = 5.74,
			args = {	
			},
		},
		EventReminder = {
			type = "group",
			name = "Event Reminder",
			desc = "Configure Event Reminder Options",
			cmdHidden = true,
			order = 5.75,
			args = {
				ERD = {
					type = "description",
					name =  "Event Reminder will notify you via Raid Warning, Chat Window and Sound if an event is going to happen.\n",
					width = "full",
					fontSize  = "medium",
					order = 1,
  				},
				ERInRaid = {
					type = "toggle",
					name =  "Disable in Raid Group",
					desc = "Does not trigger the event if your in a raid group",
					get = function(info) return Display.db.profile.ERInRaid end,
					set = function(info, v)	Display.db.profile.ERInRaid = v end,
					order = 1.2,
					width = "double",
				},
				ERTriggerDay = {
					type = "toggle",
					name =  "Log-in Reminder Trigger Once Per Day",
					desc = "Triggers the reminders once per day on log-in, does not effect Progressive Timer or Recheck Timer.",
					get = function(info) return Display.db.profile.ERTriggerDay end,
					set = function(info, v)	Display.db.profile.ERTriggerDay = v end,
					order = 1.3,
					width = "double",
				},
				ERSound = {
					type = "toggle",
					name =  "Play Sound",
					desc = "Plays a Raid Warning sound when the event reminder is triggered.",
					get = function(info) return Display.db.profile.ERSound end,
					set = function(info, v)	Display.db.profile.ERSound = v end,
					order = 1.4,
				},
				PERT = {
					type = "toggle",
					name =  "Progressive Timer",
					desc = "Triggers a Recheck timer 1/5/15/30 Minutes and 1/2/4/6 Hours before todays event starts.\n\nNote: This is different from (Todays Events Recheck Timer).",
					get = function(info) return Display.db.profile.PERT end,
					set = function(info, v)	Display.db.profile.PERT = v end,
					order = 1.5,
				},
  				ERTimer = {
					type = "select",
					name =  "Todays Events Recheck Timer",
					desc = "Rechecks todays events.\n\nNote: This is different from (Progressive Timer).",
					values = { "None", "1 Minute", "5 Minute", "15 Minute", "30 Minute", "1 Hour", "2 Hour", "4 Hour", "6 Hour"},
					get = function(info) return Display.db.profile.ERTimer end,
					set = function(info, v) Display.db.profile.ERTimer = v Display:EventReminderSetTimer() end,
					order = 1.6,
  				},
				ERD2 = {
					type = "description",
					name =  "\n",
					width = "full",
					fontSize  = "medium",
					order = 1.8,
  				},
				EREventsSD = {
					type = "header",
					name =  "Single Day Events",
					width = "full",
					order = 1.9,
				},
				FishingDerby = {
					type = "toggle",
					name =  "|TInterface\\Icons\\inv_fishingpole_03:24:24:0:0:64:64:6:58:6:58|t Kalu'ak Fishing Derby",
					desc = "Enable the Reminder for this event",
					get = function(info) return Display.db.profile.FishingDerby end,
					set = function(info, v)	Display.db.profile.FishingDerby = v end,
					order = 2,
					width = "double",
				},
				STVExt = {
					type = "toggle",
					name =  "|TInterface\\Icons\\trade_fishing:24:24:0:0:64:64:6:58:6:58|t Stranglethorn Fishing Extravaganza",
					desc = "Enable the Reminder for this event",
					get = function(info) return Display.db.profile.STVExt end,
					set = function(info, v)	Display.db.profile.STVExt = v end,
					order = 3,
					width = "double",
				},
				FSpectacular = {
					type = "toggle",
					name =  "|TInterface\\Icons\\inv_misc_missilesmall_red:24:24:0:0:64:64:6:58:6:58|t Fireworks Spectacular",
					desc =  "Enable the Reminders for this event",
					get = function(info) return Display.db.profile.FSpectacular	end,
					set = function(info, v) Display.db.profile.FSpectacular = v end,
					order = 3.2,
					width = "double",
				},
				PDay = {
					type = "toggle",
					name =  "|TInterface\\Icons\\inv_helmet_66:24:24:0:0:64:64:6:58:6:58|t Pirates' Day",
					desc =  "Enable the Reminders for this event",
					get = function(info) return Display.db.profile.PDay end,
					set = function(info, v) Display.db.profile.PDay = v end,
					order = 3.3,
					width = "double",
				},
				EREventsMD = {
					type = "header",
					name =  "Multuple Days Events",
					width = "full",
					order = 3.9,
				},
				DarkMF = {
					type = "multiselect",
					name =  "|TInterface\\Icons\\inv_misc_ticket_tarot_vengeance:24:24:0:0:64:64:6:58:6:58|t Darkmoon Faire",
					desc =  "Enable the Reminders for this event",
					values = { [1] = "Start", [2] = "Active", [3] = "Ends"},
					get = function(info, v)	local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} return Display.db.profile.DarkMF[TBVal[v]]	end,
					set = function(info, v, v2) local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} Display.db.profile.DarkMF[TBVal[v]] = v2 end,
					order = 4,
				},
				MFFestival = {
					type = "multiselect",
					name =  "|TInterface\\Icons\\inv_summerfest_fireflower:24:24:0:0:64:64:6:58:6:58|t Midsummer Fire Festival",
					desc =  "Enable the Reminders for this event",
					values = { [1] = "Start", [2] = "Active", [3] = "Ends"},
					get = function(info, v)	local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} return Display.db.profile.MFFestival[TBVal[v]]	end,
					set = function(info, v, v2) local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} Display.db.profile.MFFestival[TBVal[v]] = v2 end,
					order = 5,
				},
				CWeek = {
					type = "multiselect",
					name =  "|TInterface\\Icons\\inv_misc_food_35:24:24:0:0:64:64:6:58:6:58|t Children's Week",
					desc =  "Enable the Reminders for this event",
					values = { [1] = "Start", [2] = "Active", [3] = "Ends"},
					get = function(info, v)	local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} return Display.db.profile.CWeek[TBVal[v]]	end,
					set = function(info, v, v2) local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} Display.db.profile.CWeek[TBVal[v]] = v2 end,
					order = 6,
				},
				Ngarden = {
					type = "multiselect",
					name =  "|TInterface\\Icons\\inv_egg_06:24:24:0:0:64:64:6:58:6:58|t Noblegarden",
					desc =  "Enable the Reminders for this event",
					values = { [1] = "Start", [2] = "Active", [3] = "Ends"},
					get = function(info, v)	local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} return Display.db.profile.Ngarden[TBVal[v]]	end,
					set = function(info, v, v2) local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} Display.db.profile.Ngarden[TBVal[v]] = v2 end,
					order = 7,
				},
				LAir = {
					type = "multiselect",
					name =  "|TInterface\\Icons\\inv_valentinesboxofchocolates02:24:24:0:0:64:64:6:58:6:58|t Love is in the Air",
					desc =  "Enable the Reminders for this event",
					values = { [1] = "Start", [2] = "Active", [3] = "Ends"},
					get = function(info, v)	local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} return Display.db.profile.LAir[TBVal[v]]	end,
					set = function(info, v, v2) local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} Display.db.profile.LAir[TBVal[v]] = v2 end,
					order = 8,
				},
				LFestival = {
					type = "multiselect",
					name =  "|TInterface\\Icons\\inv_misc_elvencoins:24:24:0:0:64:64:6:58:6:58|t Lunar Festival",
					desc =  "Enable the Reminders for this event",
					values = { [1] = "Start", [2] = "Active", [3] = "Ends"},
					get = function(info, v)	local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} return Display.db.profile.LFestival[TBVal[v]]	end,
					set = function(info, v, v2) local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} Display.db.profile.LFestival[TBVal[v]] = v2 end,
					order = 9,
				},
				WVeil = {
					type = "multiselect",
					name =  "|TInterface\\Icons\\inv_misc_plant_03:24:24:0:0:64:64:6:58:6:58|t Feast of Winter Veil",
					desc =  "Enable the Reminders for this event",
					values = { [1] = "Start", [2] = "Active", [3] = "Ends"},
					get = function(info, v)	local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} return Display.db.profile.WVeil[TBVal[v]]	end,
					set = function(info, v, v2) local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} Display.db.profile.WVeil[TBVal[v]] = v2 end,
					order = 10,
				},
				PBounty = {
					type = "multiselect",
					name =  "|TInterface\\Icons\\inv_holiday_thanksgiving_empty_cornucopia:24:24:0:0:64:64:6:58:6:58|t Pilgrim's Bounty",
					desc =  "Enable the Reminders for this event",
					values = { [1] = "Start", [2] = "Active", [3] = "Ends"},
					get = function(info, v)	local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} return Display.db.profile.PBounty[TBVal[v]]	end,
					set = function(info, v, v2) local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} Display.db.profile.PBounty[TBVal[v]] = v2 end,
					order = 11,
				},
				DDead = {
					type = "multiselect",
					name =  "|TInterface\\Icons\\inv_misc_bone_humanskull_02:24:24:0:0:64:64:6:58:6:58|t Day of the Dead",
					desc =  "Enable the Reminders for this event",
					values = { [1] = "Start", [2] = "Ends"},
					get = function(info, v)	local TBVal = { [1] = "START", [2] = "END"} return Display.db.profile.DDead[TBVal[v]]	end,
					set = function(info, v, v2) local TBVal = { [1] = "START", [2] = "END"} Display.db.profile.DDead[TBVal[v]] = v2 end,
					order = 12,
				},
				HEnd = {
					type = "multiselect",
					name =  "|TInterface\\Icons\\inv_misc_bag_28_halloween:24:24:0:0:64:64:6:58:6:58|t Hallow's End",
					desc =  "Enable the Reminders for this event",
					values = { [1] = "Start", [2] = "Active", [3] = "Ends"},
					get = function(info, v)	local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} return Display.db.profile.HEnd[TBVal[v]]	end,
					set = function(info, v, v2) local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} Display.db.profile.HEnd[TBVal[v]] = v2 end,
					order = 13,
				},
				HFestival = {
					type = "multiselect",
					name =  "|TInterface\\Icons\\inv_summerfest_groundflower:24:24:0:0:64:64:6:58:6:58|t Harvest Festival",
					desc =  "Enable the Reminders for this event",
					values = { [1] = "Start", [2] = "Active", [3] = "Ends"},
					get = function(info, v)	local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} return Display.db.profile.HFestival[TBVal[v]]	end,
					set = function(info, v, v2) local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} Display.db.profile.HFestival[TBVal[v]] = v2 end,
					order = 14,
				},
				Brewfest = {
					type = "multiselect",
					name =  "|TInterface\\Icons\\inv_drink_13:24:24:0:0:64:64:6:58:6:58|t Brewfest",
					desc =  "Enable the Reminders for this event",
					values = { [1] = "Start", [2] = "Active", [3] = "Ends"},
					get = function(info, v)	local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} return Display.db.profile.Brewfest[TBVal[v]]	end,
					set = function(info, v, v2) local TBVal = { [1] = "START", [2] = "ONGOING", [3] = "END"} Display.db.profile.Brewfest[TBVal[v]] = v2 end,
					order = 15,
				},
			},
		},
		Messanger = {			
			type = "group",
			name = "Messanger",
			desc = "Configure Messanger Options",
			cmdHidden = true,
			childGroups = "tab",
			order = 5.79,
			args = {
				OT1 = {
					type = "group",
					name = "Main Options",
					desc = "Configure Main Options",
					order = 1,
					args = {
						Messanger1 = {
							type = "header",
							name =  "Mass Whisper",
							width = "full",
							order = 1,
						},
						WBMD = {
							type = "description",
							name =  "Mass Whisper will message people using the \\who list, a limit of 25 whispers is inplace to prevent mute.\n",
							width = "full",
							fontSize  = "medium",
							order = 1.5,
						},
		  				MMinLvl = {
							type = "range",
							name = "Min Lvl",
							min = 0, max = FatCooldowns.ExPac == 2 and 80 or FatCooldowns.ExPac == 0 and 60 or FatCooldowns.ExPac == 1 and 70, step = 1, bigStep = 1,
							desc = "Sets the min level of the search",
							get = function(info) return Display.db.profile.MMinLvl end,
							set = function(info, v)	Display.db.profile.MMinLvl = v  end,
							order = 3,
							width = "full",
						},
		  				MMaxLvl = {
							type = "range",
							name = "Max Lvl",
							min = 0, max = FatCooldowns.ExPac == 2 and 80 or FatCooldowns.ExPac == 0 and 60 or FatCooldowns.ExPac == 1 and 70, step = 1, bigStep = 1,
							desc = "Sets the min level of the search",
							get = function(info) return Display.db.profile.MMaxLvl end,
							set = function(info, v)	Display.db.profile.MMaxLvl = v end,
							order = 4,
							width = "full",
						},
						WhisperPeopleTimer = {
							type = "range",
							name = "Re-Whisper Timer Limit (Minutes)",
							min = 1, max = 30, step = 1, bigStep = 1,
							desc = "Sets the minimum amount of time before whispering the same person",
							get = function(info) return Display.db.profile.WhisperPeopleTimer end,
							set = function(info, v)	Display.db.profile.WhisperPeopleTimer = v  end,
							order = 4.5,
							width = "full",
						},
						WhisperMessageClasses = {
							type = "multiselect",
							name =  "Player Class",
							desc =  "Select the classes you would like the message to be sent to.",
							values = function(info, v) if FatCooldowns.ExPac == 2 then
								return {
									["DEATH KNIGHT"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t |cffC41F3BDEATHKNIGHT|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DEATHKNIGHT:24|t", 
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								else return {
									["DRUID"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t |cffFF7D0ADRUID|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\DRUID:24|t ", 
									["HUNTER"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t |cffABD473HUNTER|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\HUNTER:24|t", 
									["MAGE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t |cff69CCF0MAGE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\MAGE:24|t", 
									["PALADIN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t |cffF58CBAPALADIN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PALADIN:24|t",
									["PRIEST"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t |cffFFFFFFPRIEST|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\PRIEST:24|t", 
									["ROGUE"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t |cffFFF569ROGUE|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\ROGUE:24|t", 
									["SHAMAN"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t |cff0070DESHAMAN|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\SHAMAN:24|t", 
									["WARLOCK"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t |cff9482C9WARLOCK|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARLOCK:24|t", 
									["WARRIOR"] = "|TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t |cffC79C6EWARRIOR|r |TInterface\\AddOns\\FatCooldowns\\icons\\ClassIcons\\WARRIOR:24|t"}
								end
							end,
							get = function(info, v) return Display.db.profile.WhisperMessageClasses[v] end,
							set = function(info, v, v2) Display.db.profile.WhisperMessageClasses[v] = v2 end,
							order = 5,
						},
						InDungeon = {
							type = "toggle",
							name =  "Not inside Dungeon",
							desc =  "Does not Whisper people who are inside of a dungeon\n\nNote: Includes Death Knight starting zone",
							get = function(info) return Display.db.profile.InDungeon end,
							set = function(info, v)	Display.db.profile.InDungeon = v end,
							order = 5.5,
							width = "double",
		  				},
						InBG = {
							type = "toggle",
							name =  "Not inside Battleground",
							desc =  "Does not Whisper people who are inside of a Battleground.",
							get = function(info) return Display.db.profile.InBG end,
							set = function(info, v)	Display.db.profile.InBG = v end,
							order = 5.9,
							width = "double",
		  				},
						WhisperMessage = {
							type = "input",
							name =  "Message",
							get = function(info) return Display.db.profile.WhisperMessage end,
							set = function(info, v) 
								if v == nil then Display.db.profile.WhisperMessage = nil return end
								Display.db.profile.WhisperMessage = v
							end,
							order = 6,
							width = "double",
						},
						WhisperMessageExe = {
							type = "execute",
							name = "Whisper",
							func = function() WhisperMessageDo() end,
							order = 7,
						},	
						PlayerRole = {
							type = "toggle",
							name =  "Players Roles",
							desc =  "Enables the filtering of players bases on there role e.g. Tank Healer DPS, this information comes from seeing the players in dungeons but also can be manually added.",
							get = function(info) return Display.db.profile.PlayerRole end,
							set = function(info, v)	Display.db.profile.PlayerRole = v end,
							order = 8,
		  				},
						PlayerRoleTank = {
							type = "toggle",
							name =  "Include Tank",
							desc =  "Include Tanks in the whispering.",
							hidden = function() if Display.db.profile.PlayerRole then return false else return true end end,
							get = function(info) return Display.db.profile.PlayerRoleTank end,
							set = function(info, v)	Display.db.profile.PlayerRoleTank = v end,
							order = 9,
		  				},
						PlayerRoleHealer = {
							type = "toggle",
							name =  "Include Healer",
							desc =  "Include Healer in the whispering.",
							hidden = function() if Display.db.profile.PlayerRole then return false else return true end end,
							get = function(info) return Display.db.profile.PlayerRoleHealer end,
							set = function(info, v)	Display.db.profile.PlayerRoleHealer = v end,
							order = 10,
		  				},
						PlayerRoleDPS = {
							type = "toggle",
							name =  "Include DPS",
							desc =  "Include DPS in the whispering.",
							hidden = function() if Display.db.profile.PlayerRole then return false else return true end end,
							get = function(info) return Display.db.profile.PlayerRoleDPS end,
							set = function(info, v)	Display.db.profile.PlayerRoleDPS = v end,
							order = 11,
		  				},
		  			},
		  		},
		  		OT2 = {
					type = "group",
					name = "Player Roles",
					desc = "Configure Player Roles",
					order = 1,
					args = {
		  			},
		  		},
			},
		},
		AltTab = {
			type = "group",
			name = "Alt-Tab",
			desc = "Configure Alt-Tab Options",
			cmdHidden = true,
			order = 5.8,
			args = {
				BMD = {
					type = "description",
					name =  "Alt-Tab will play sounds when events are triggered.\n\n"..
					"When a tracked event is started this addon will 'disable sound' and 'enable background sound'. When the tracked event is finished the settings will be changed to the prefered settings (below).\n\n"..
					"Note: Things are done this way due to limitations with enabling/disabling settings, when you log-in the prefered settings will also be set.\n\n",
					width = "full",
					fontSize  = "medium",
					order = 0.5,
				},
				EnableAltTab = {
					type = "toggle",
					name =  "Enable Alt-Tab",
					desc =  "Plays Sound when events are triggered",
					get = function(info) return Display.db.profile.AltTab end,
					set = function(info, v)	Display.db.profile.AltTab = v end,
					order = 1,
					width = "full",
  				},
  				AltTabSound ={
					type = "select",
					name =  "Custom Sound",
					desc =  "this will enable the Custom set sound to play",
					values = function()
					local SoundName = {}
						for CustomSoundName, CustomSoundPath in pairs(FatCooldowns.FCDSounds) do
							SoundName[CustomSoundName] = CustomSoundName
						end
						return SoundName
					end,
					get = function(info, v, v2) return Display.db.profile.AltTabSound end,
					set = function(info, v, v2) Display.db.profile.AltTabSound = v PlaySoundFile(FatCooldowns.FCDSounds[v], "Master",false) end,
					order = 2,
				},
				ChangeMSound = {
					type = "toggle",
					name =  "Change Master Sound",
					desc =  "changes the Master Sound Volume for triggered events",
					get = function(info) return Display.db.profile.ChangeMSound end,
					set = function(info, v)	Display.db.profile.ChangeMSound = v end,
					order = 3,
  				},
				MaxSound = {
					type = "range",
					name = "Master Sound Volume",
					min = 0, max = 100, step = 10, bigStep = 10,
					disabled = function() if Display.db.profile.ChangeMSound then return false else return true end end,
					desc = "Changes the Master Volume.\n\nNote: will change back to normal when sound has finished playing",
					get = function(info) return Display.db.profile.MaxSound end,
					set = function(info, v)	Display.db.profile.MaxSound = v end,
					order = 4,
				},
				DoublePlay = {
					type = "toggle",
					name =  "Double Play",
					desc =  "Plays Sound more than once",
					get = function(info) return Display.db.profile.DoublePlay end,
					set = function(info, v)	Display.db.profile.DoublePlay = v end,
					order = 5,
  				},	
  				PERH = {
					type = "header",
					name =  "Prefered Settings",
					width = "full",
					order = 6,
				},
				MasterVolSetting = {
					type = "range",
					name = "Master Sound Volume",
					min = 0, max = 100, step = 10, bigStep = 10,
					desc = "Sets the Master Volume",
					get = function(info) return Display.db.profile.MasterVolSetting end,
					set = function(info, v)	Display.db.profile.MasterVolSetting = v end,
					order = 7,
				},
				SoundEnabled = {
					type = "toggle",
					name =  "Enable Sound",
					desc =  "Enables Sound",
					get = function(info) return Display.db.profile.SoundEnabled end,
					set = function(info, v)	Display.db.profile.SoundEnabled = v end,
					order = 8,
  				},
				BGSound = {
					type = "toggle",
					name =  "Sound in Background",
					desc =  "Enables Tracking for BG",
					get = function(info) return Display.db.profile.BGSound end,
					set = function(info, v)	Display.db.profile.BGSound = v end,
					order = 9,
  				},
				SFXSound = {
					type = "toggle",
					name =  "Sound Effects",
					desc =  "Enables Sound Effects",
					get = function(info) return Display.db.profile.SFXSound end,
					set = function(info, v)	Display.db.profile.SFXSound = v end,
					order = 10,
  				},
				ALTTABH = {
					type = "header",
					name =  "Events",
					width = "full",
					order = 11,
				},
				RDFAltTab = {
					type = "toggle",
					name =  "RDF/LFG",
					desc =  "Enables Tracking for RDF/LFG",
					get = function(info) return Display.db.profile.RDFAltTab end,
					set = function(info, v)	Display.db.profile.RDFAltTab = v end,
					order = 12,
  				},
				BGAltTab = {
					type = "toggle",
					name =  "BG",
					desc =  "Enables Tracking for BG",
					get = function(info) return Display.db.profile.BGAltTab end,
					set = function(info, v)	Display.db.profile.BGAltTab = v end,
					order = 13,
  				},
				BMD2 = {
					type = "description",
					name =  "\n\n",
					width = "full",
					fontSize  = "medium",
					order = 14,
				},
				ALTTABFR = {
					type = "header",
					name =  "Force Change Sound Settings",
					width = "full",
					order = 14.5,
				},
				ForceSet = {
					type = "execute",
					name =  "Force Set Sound",
					desc =  "Sets the sound settings",
					func = function() FatCooldowns:SetSound() end,
					order = 15,
					width = "double",
				},	
				ForceReset = {
					type = "execute",
					name =  "Force Reset Sound",
					desc =  "Reset the Sound to the prefered settings",
					func = function() FatCooldowns:ResetSound() end,
					order = 16,
					width = "double",
				},	
			},
		},
		ItemSearch = {
			type = "group",
			name = "Search",
			desc = "Configure Search Options",
			cmdHidden = true,
			order = 5.9,
			args = {
				BMD = {
					type = "description",
					name =  "Search for items and spells that are already cached, if you can not find an item in the list it maybe because you have not yet seen the item in-game.\n\n",
					width = "full",
					fontSize  = "medium",
					order = 0.5,
				},
				ItemSearchToggle = {
					type = "toggle",
					name =  "Search Items",
					desc =  "Toggle Search for Items",
					disabled = function() if Display.db.profile.SpellsSearchToggle then return false else return true end end,
					get = function(info) return Display.db.profile.ItemSearchToggle end,
					set = function(info, v)	
						if v == true then
							TempSearch = nil 
							table.wipe(CurrentSearchList)
							table.wipe(TempSearchList)
							Display.db.profile.SpellsSearchToggle = false
							Display.db.profile.ItemSearchToggle = v
						else
							TempSearch = nil 
							table.wipe(CurrentSearchList)
							table.wipe(TempSearchList)
							Display.db.profile.SpellsSearchToggle = true
							Display.db.profile.ItemSearchToggle = v
						end
					end,
					order = 0.6,
					width = "double",
  				},
				SpellsSearchToggle = {
					type = "toggle",
					name =  "Search Spells",
					desc =  "Toggle Search for Spells",
					disabled = function() if Display.db.profile.ItemSearchToggle then return false else return true end end,
					get = function(info) return Display.db.profile.SpellsSearchToggle end,
					set = function(info, v)	
						if v == true then
							TempSearch = nil 
							table.wipe(CurrentSearchList)
							table.wipe(TempSearchList)
							Display.db.profile.ItemSearchToggle = false
							Display.db.profile.SpellsSearchToggle = v
						else
							TempSearch = nil
							table.wipe(CurrentSearchList)
							table.wipe(TempSearchList) 
							Display.db.profile.ItemSearchToggle = true
							Display.db.profile.SpellsSearchToggle = v
						end
					end,
					order = 0.7,
					width = "double",
  				},
				ItemSearchBar = {
					type = "input",
					name =  "Search",
					get = function(info) return TempSearch end,
					set = function(info, v) 
						if v == nil then TempSearch = nil return end
						if type(v) ~= "string" then TempSearch = nil FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter the name of a item") return end
						if type(v) == "string" then TempSearch = strlower(v) end
					end,
					order = 1,
					width = "full",
				},
				ItemSearchList = {
					 name = "Search List: Click To Print Item In Chat",
					 order = 2,
					 type = "group",
					 inline = true,
					 args = {
						theList = {
						   type = "select",
						   dialogControl = "MSItemSelectList",
						   name = "Anyname",
						   desc = "#ItemTooltip#",
						   width = "full",
						   values = function () return FillSearchList() end,
						   get = function () return CurrrentSelectedSearchList end,			
						   set = function (info, key) PrintItemFromSearchList(key) CurrrentSelectedSearchList = key end,			
						},
					 },
				 },
			},
		},
		SpellsLvl = {
			type = "group",
			name = "Spells",
			desc = "List of Spells",
			cmdHidden = true,
			order = 5.93,
			args = {
				SpellsClasses = {
					type = "select",
					name =  "Class",
					desc = "Select a class to see the spells",
					values = function(info)
						if FatCooldowns.ExPac == 2 then return {
							["DEATHKNIGHT"] = "|cffC41F3BDEATHKNIGHT|r", 
							["DRUID"] = "|cffFF7D0ADRUID|r", 
							["HUNTER"] = "|cffABD473HUNTER|r", 
							["MAGE"] = "|cff69CCF0MAGE|r", 
							["PALADIN"] = "|cffF58CBAPALADIN|r",
							["PRIEST"] = "|cffFFFFFFPRIEST|r", 
							["ROGUE"] = "|cffFFF569ROGUE|r", 
							["SHAMAN"] = "|cff0070DESHAMAN|r", 
							["WARLOCK"] = "|cff9482C9WARLOCK|r", 
							["WARRIOR"] = "|cffC79C6EWARRIOR|r"}
						else return {
							["DRUID"] = "|cffFF7D0ADRUID|r", 
							["HUNTER"] = "|cffABD473HUNTER|r", 
							["MAGE"] = "|cff69CCF0MAGE|r", 
							["PALADIN"] = "|cffF58CBAPALADIN|r",
							["PRIEST"] = "|cffFFFFFFPRIEST|r", 
							["ROGUE"] = "|cffFFF569ROGUE|r", 
							["SHAMAN"] = "|cff0070DESHAMAN|r", 
							["WARLOCK"] = "|cff9482C9WARLOCK|r", 
							["WARRIOR"] = "|cffC79C6EWARRIOR|r"}
						end 
					end,
					get = function(info) return TempClass end,
					set = function(info, v)	TempSpellSearch = nil TempClass = v end,
					order = 1,
				},
				SpellsALL = {
					type = "toggle",
					name = "All Spells",
					desc = "Show all spells even already known spells",
					get = function(info) return TempClassAll end,
					set = function(info, v)	TempSpellSearch = nil TempClassAll = v end,
					hidden = function() local FakeClass2, TempClass2 = UnitClass("player") if TempClass == TempClass2 then return false else return true end end,
					order = 2,
				},	
				TalentsHide = {
					type = "toggle",
					name = "Unlearnt Talents",
					desc = "Shows Spells from unlearnt talents",
					get = function(info) return Display.db.profile.UnlearntTalents end,
					set = function(info, v)	TempSpellSearch = nil Display.db.profile.UnlearntTalents = v end,
					hidden = function() local FakeClass2, TempClass2 = UnitClass("player") if TempClass == TempClass2 then return false else return true end end,
					order = 3,
				},
				SpellsLvlLearn = {
					type = "toggle",
					name =  "Print",	
					desc = "when you level this will print in chat a list of spells that you are able to learn",
					get = function(info) return Display.db.profile.SpellLvlLearn end,
					set = function(info, v) Display.db.profile.SpellLvlLearn = v end,
					hidden = function() local FakeClass2, TempClass2 = UnitClass("player") if TempClass == TempClass2 then return false else return true end end,
					order = 3.02,
					width = "half",
				},
				SpellsLvlcost = {
					type = "toggle",
					name =  "Cost",	
					desc = "shows the cost of the spells",
					get = function(info) return Display.db.profile.SpellsLvlcost end,
					set = function(info, v) Display.db.profile.SpellsLvlcost = v end,
					order = 3.03,
					width = "half",
				},
				TempSpellsSearch = {
					type = "input",
					name =  "Search",
					get = function(info) return nil end,
					set = function(info, v) TempSpellSearch = v	end,
					order = 3.1,
					width = "full",
				},
			},
		},
		DisabledGroup4 = {
			type = "group",
			name = "-------------------",
			desc = "Spliter",
			cmdHidden = true,
			disabled = function() return true end,
			order = 6.9,
			args = {	
			},
		},
		ChatReporter = {
			type = "group",
			name = "Chat Reporter",
			desc = "Configure Chat Reporter Options",
			cmdHidden = true,
			childGroups = "tab",
			order = 7,
			args = {
				CRMain = {
					type = "group",
					name = "Chat Reporter Options",
					desc = "Set which reporter options you would like to enable.",
					cmdHidden = true,
					order = 1,
					args = {
						descr = {
							type = "description",
							name =  "Select which reporter options you would like enable.\n\n"..
							"There is 2 anti-spam features built-in:\n"..
							"1st checks if you have raid lead/assist, if you dont have lead/assist the messages will print to yourself.\n"..
							"2nd checks if your raid leader/assist has FCD, if he/she does have FCD it will then block your reporting.\n\n"..
							"'Disable AntiSpam For |cffFFF468Chat Reporter|r Tab' (in the |cffFFF468Personal|r tab on the left) will disable the 2nd check and will allow you to report in raid chat even if your raid leader/assist has FCD. you will still need leader/assist.",
							width = "full",
							fontSize  = "medium",
							order = 1,
						},
						FCDPrefix = {
							type = "select",
							name = "Chat Prefix",
							desc =  "Change the Prefix for a lot of chat messages",
							values = { 
								[1] = "|cFF9d9d9dDefualt|r",
								[2] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t |CFFFFF468Star|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t",
								[3] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t |CFFFF7C0ACircle|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t",
								[4] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t |CFFA330C9Diamond|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t",
								[5] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t |CFFAAD372Triangle|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t",
								[6] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t |CFFE5E5E5Moon|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t",
								[7] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t |CFF0070DDSquare|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t",
								[8] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t |CFFC41E3ACross|r |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t",
								[9] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t Skull |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t"},
							order = 2,
							get = function(info) return Display.db.profile.FCDPrefix end,
							set = function(info, val) Display.db.profile.FCDPrefix = val end,
							cmdHidden = true,
						},
						CustomPrintChatChannels = {
							type = "toggle",
							name =  "Custom Print Tabs",
							desc =  "Enable the custom print tabs so you can print messages in different/more tabs",
							get = function(v) return Display.db.profile.CustomPrintChatChannels end,
							set = function(info, v) Display.db.profile.CustomPrintChatChannels = v end,
							order = 3,
						},
						CustomPrintChatChannelsTable = {
							type = "multiselect",
							name =  "Chat Tabs.",
							desc =  "Select enable/disable print messages in selected tabs.",
							hidden = function() if Display.db.profile.CustomPrintChatChannels then return false else return true end end,
							values = {
								[1] = "Tab: 1",
								[2] = "Tab: 2",
								[3] = "Tab: 3",
								[4] = "Tab: 4",
								[5] = "Tab: 5",
								[6] = "Tab: 6",
								[7] = "Tab: 7",
								[8] = "Tab: 8",
								[9] = "Tab: 9",
								[10] = "Tab: 10",
							},
							get = function(info, v)	return Display.db.profile.CustomPrintChatChannelsTable[v] end,
							set = function(info, v, v2) Display.db.profile.CustomPrintChatChannelsTable[v] = v2 end,
							order = 4,
						},
					},
				},
				CRSpammer = {
					type = "group",
					name = "Chat Spammer Options",
					desc = "Set which reporter options you would like to enable.",
					cmdHidden = true,
					order = 2,
					args = {
						descr = {
							type = "description",
							name =  "Spammer allows you to spam different messages in different chats, if you have more than one then it will be random which one gets sent but the ones with higher prio will get sent more often.\n\n",
							width = "full",
							fontSize  = "medium",
							order = 0.1,
						},
						SpammerTime = {
							type = "range",
							name =  "Spammer Timer",
							desc =  "how often the messages are sent",
							min = 60, max = 500, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.SpammerTime end,
							set = function(info, v) Display.db.profile.SpammerTime = v end,
							order = 0.2,
							width = "double",
						},
						SpammerAmount = {
							type = "range",
							name =  "Amount",
							desc =  "set how many different messages you would like to spam",
							min = 0, max = 20, step = 1, bigStep = 1,
							get = function(v) return Display.db.profile.SpammerAmount end,
							set = function(info, v) 
								Display.db.profile.SpammerAmount = v
								for i = 1, Display.db.profile.SpammerAmount do
									if not Display.db.profile.SpammerTable[i] then Display.db.profile.SpammerTable[i] = {enable = false, msg = "", prio = 1, keep = false, channel = "SAY"} end
								end
								RefreshFrameListOptionsAndVariables() 
								LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
							end,
							order = 0.3,
						},
						SpammerSend = {
							type = "execute",
							name =  "Send",
							desc =  "Send a message and reset the timer. you dont need to click, but may want to click after you change the message",
							order = 0.4,
							func = function() Display:FCDSpammerMessage() end,
						},
					},
				},
				GloablSettings = {
					type = "group",
					name = "Chat Channel Options",
					desc = "Auto join the selected chat channels.",
					cmdHidden = true,
					order = 3,
					args = {
						descr = {
							type = "description",
							name =  "This will allow you to auto join selected chat channels and disable them from specific chat tabs.\n\n",
							width = "full",
							fontSize  = "medium",
							order = 0.1,
						},
						AddChatChannel = {
							type = "input",
							name =  "Add Channel Name",
							get = function(info) return nil end,
							set = function(info, v) SelectedChannel = v Display.db.profile.ChannelNames[v] = {} end,
							order = 1,
							width = "double",
						},
						SelectChat = {
							type = "select",
							name = "Select Channel",
							values = function ()
								local TempCN = {}
								for x,c in pairs(Display.db.profile.ChannelNames) do
									TempCN[x] = x
								end
								return TempCN
							end,
							order = 2,
							get = function(info) return SelectedChannel end,
							set = function(info, v) 
								if v == nil or v == "" then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter a real name") return end
									SelectedChannel = v
							end,
						},
						SelectedChatRemove = {
							order = 3,
							type = "execute",
							name = "Remove",
							func = function() 
								if SelectedChannel ~= nil and Display.db.profile.ChannelNames then
									if Display.db.profile.ChannelNames[SelectedChannel] then
										Display.db.profile.ChannelNames[SelectedChannel] = nil
										SelectedChannel = nil
									end
								end
							end,
						},	
						SelectChatOptions1 = {
							type = "select",
							name = function()
								local TabName = GetChatWindowInfo(1)
								return "Tab ".."1".." - "..TabName
							end,
							values = {[1] = "Nothing", [2] = "Rmove", [3] = "Add"},
							order = 4,
							hidden = function() if SelectedChannel == nil or SelectedChannel == "" then return true else return false end end,
							get = function(info)
								if SelectedChannel == nil or SelectedChannel == "" then return 1 end
								if Display.db.profile.ChannelNames[SelectedChannel][1] == true then return 3
								elseif Display.db.profile.ChannelNames[SelectedChannel][1] == false then return 2
								else return 1
								end
							end,
							set = function(info, v) 
								if SelectedChannel == nil or SelectedChannel == "" then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCDL: Please Select a Channel") end
								if v == 1 then Display.db.profile.ChannelNames[SelectedChannel][1] = nil
								elseif v == 2 then Display.db.profile.ChannelNames[SelectedChannel][1] = false
								elseif v == 3 then Display.db.profile.ChannelNames[SelectedChannel][1] = true
								end
							 end,
						},
						SelectChatOptions2 = {
							type = "select",
							name = function()
								local TabName = GetChatWindowInfo(2)
								return "Tab ".."2".." - "..TabName
							end,
							values = {[1] = "Nothing", [2] = "Rmove", [3] = "Add"},
							order = 5,
							hidden = function() if SelectedChannel == nil or SelectedChannel == "" then return true else return false end end,
							get = function(info)
								if SelectedChannel == nil or SelectedChannel == "" then return 1 end
								if Display.db.profile.ChannelNames[SelectedChannel][2] == true then return 3
								elseif Display.db.profile.ChannelNames[SelectedChannel][2] == false then return 2
								else return 1
								end
							end,
							set = function(info, v) 
								if SelectedChannel == nil or SelectedChannel == "" then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCDL: Please Select a Channel") end
								if v == 1 then Display.db.profile.ChannelNames[SelectedChannel][2] = nil
								elseif v == 2 then Display.db.profile.ChannelNames[SelectedChannel][2] = false
								elseif v == 3 then Display.db.profile.ChannelNames[SelectedChannel][2] = true
								end
							 end,
						},
						SelectChatOptions3 = {
							type = "select",
							name = function()
								local TabName = GetChatWindowInfo(3)
								return "Tab ".."3".." - "..TabName
							end,
							values = {[1] = "Nothing", [2] = "Rmove", [3] = "Add"},
							order = 6,
							hidden = function() if SelectedChannel == nil or SelectedChannel == "" then return true else return false end end,
							get = function(info)
								if SelectedChannel == nil or SelectedChannel == "" then return 1 end
								if Display.db.profile.ChannelNames[SelectedChannel][3] == true then return 3
								elseif Display.db.profile.ChannelNames[SelectedChannel][3] == false then return 2
								else return 1
								end
							end,
							set = function(info, v) 
								if SelectedChannel == nil or SelectedChannel == "" then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCDL: Please Select a Channel") end
								if v == 1 then Display.db.profile.ChannelNames[SelectedChannel][3] = nil
								elseif v == 2 then Display.db.profile.ChannelNames[SelectedChannel][3] = false
								elseif v == 3 then Display.db.profile.ChannelNames[SelectedChannel][3] = true
								end
							 end,
						},
						SelectChatOptions4 = {
							type = "select",
							name = function()
								local TabName = GetChatWindowInfo(4)
								return "Tab ".."4".." - "..TabName
							end,
							values = {[1] = "Nothing", [2] = "Rmove", [3] = "Add"},
							order = 7,
							hidden = function() if SelectedChannel == nil or SelectedChannel == "" then return true else return false end end,
							get = function(info)
								if SelectedChannel == nil or SelectedChannel == "" then return 1 end
								if Display.db.profile.ChannelNames[SelectedChannel][4] == true then return 3
								elseif Display.db.profile.ChannelNames[SelectedChannel][4] == false then return 2
								else return 1
								end
							end,
							set = function(info, v) 
								if SelectedChannel == nil or SelectedChannel == "" then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCDL: Please Select a Channel") end
								if v == 1 then Display.db.profile.ChannelNames[SelectedChannel][4] = nil
								elseif v == 2 then Display.db.profile.ChannelNames[SelectedChannel][4] = false
								elseif v == 3 then Display.db.profile.ChannelNames[SelectedChannel][4] = true
								end
							 end,
						},
						SelectChatOptions5 = {
							type = "select",
							name = function()
								local TabName = GetChatWindowInfo(5)
								return "Tab ".."5".." - "..TabName
							end,
							values = {[1] = "Nothing", [2] = "Rmove", [3] = "Add"},
							order = 8,
							hidden = function() if SelectedChannel == nil or SelectedChannel == "" then return true else return false end end,
							get = function(info)
								if SelectedChannel == nil or SelectedChannel == "" then return 1 end
								if Display.db.profile.ChannelNames[SelectedChannel][5] == true then return 3
								elseif Display.db.profile.ChannelNames[SelectedChannel][5] == false then return 2
								else return 1
								end
							end,
							set = function(info, v) 
								if SelectedChannel == nil or SelectedChannel == "" then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCDL: Please Select a Channel") end
								if v == 1 then Display.db.profile.ChannelNames[SelectedChannel][5] = nil
								elseif v == 2 then Display.db.profile.ChannelNames[SelectedChannel][5] = false
								elseif v == 3 then Display.db.profile.ChannelNames[SelectedChannel][5] = true
								end
							 end,
						},
						SelectChatOptions6 = {
							type = "select",
							name = function()
								local TabName = GetChatWindowInfo(6)
								return "Tab ".."6".." - "..TabName
							end,
							values = {[1] = "Nothing", [2] = "Rmove", [3] = "Add"},
							order = 9,
							hidden = function() if SelectedChannel == nil or SelectedChannel == "" then return true else return false end end,
							get = function(info)
								if SelectedChannel == nil or SelectedChannel == "" then return 1 end
								if Display.db.profile.ChannelNames[SelectedChannel][6] == true then return 3
								elseif Display.db.profile.ChannelNames[SelectedChannel][6] == false then return 2
								else return 1
								end
							end,
							set = function(info, v) 
								if SelectedChannel == nil or SelectedChannel == "" then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCDL: Please Select a Channel") end
								if v == 1 then Display.db.profile.ChannelNames[SelectedChannel][6] = nil
								elseif v == 2 then Display.db.profile.ChannelNames[SelectedChannel][6] = false
								elseif v == 3 then Display.db.profile.ChannelNames[SelectedChannel][6] = true
								end
							 end,
						},
						SelectChatOptions7 = {
							type = "select",
							name = function()
								local TabName = GetChatWindowInfo(7)
								return "Tab ".."7".." - "..TabName
							end,
							values = {[1] = "Nothing", [2] = "Rmove", [3] = "Add"},
							order = 10,
							hidden = function() if SelectedChannel == nil or SelectedChannel == "" then return true else return false end end,
							get = function(info)
								if SelectedChannel == nil or SelectedChannel == "" then return 1 end
								if Display.db.profile.ChannelNames[SelectedChannel][7] == true then return 3
								elseif Display.db.profile.ChannelNames[SelectedChannel][7] == false then return 2
								else return 1
								end
							end,
							set = function(info, v) 
								if SelectedChannel == nil or SelectedChannel == "" then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCDL: Please Select a Channel") end
								if v == 1 then Display.db.profile.ChannelNames[SelectedChannel][7] = nil
								elseif v == 2 then Display.db.profile.ChannelNames[SelectedChannel][7] = false
								elseif v == 3 then Display.db.profile.ChannelNames[SelectedChannel][7] = true
								end
							 end,
						},
						SelectChatOptions8 = {
							type = "select",
							name = function()
								local TabName = GetChatWindowInfo(8)
								return "Tab ".."8".." - "..TabName
							end,
							values = {[1] = "Nothing", [2] = "Rmove", [3] = "Add"},
							order = 11,
							hidden = function() if SelectedChannel == nil or SelectedChannel == "" then return true else return false end end,
							get = function(info)
								if SelectedChannel == nil or SelectedChannel == "" then return 1 end
								if Display.db.profile.ChannelNames[SelectedChannel][8] == true then return 3
								elseif Display.db.profile.ChannelNames[SelectedChannel][8] == false then return 2
								else return 1
								end
							end,
							set = function(info, v) 
								if SelectedChannel == nil or SelectedChannel == "" then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCDL: Please Select a Channel") end
								if v == 1 then Display.db.profile.ChannelNames[SelectedChannel][8] = nil
								elseif v == 2 then Display.db.profile.ChannelNames[SelectedChannel][8] = false
								elseif v == 3 then Display.db.profile.ChannelNames[SelectedChannel][8] = true
								end
							 end,
						},
						SelectChatOptions9 = {
							type = "select",
							name = function()
								local TabName = GetChatWindowInfo(9)
								return "Tab ".."9".." - "..TabName
							end,
							values = {[1] = "Nothing", [2] = "Rmove", [3] = "Add"},
							order = 12,
							hidden = function() if SelectedChannel == nil or SelectedChannel == "" then return true else return false end end,
							get = function(info)
								if SelectedChannel == nil or SelectedChannel == "" then return 1 end
								if Display.db.profile.ChannelNames[SelectedChannel][9] == true then return 3
								elseif Display.db.profile.ChannelNames[SelectedChannel][9] == false then return 2
								else return 1
								end
							end,
							set = function(info, v) 
								if SelectedChannel == nil or SelectedChannel == "" then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCDL: Please Select a Channel") end
								if v == 1 then Display.db.profile.ChannelNames[SelectedChannel][9] = nil
								elseif v == 2 then Display.db.profile.ChannelNames[SelectedChannel][9] = false
								elseif v == 3 then Display.db.profile.ChannelNames[SelectedChannel][9] = true
								end
							 end,
						},
						SelectChatOptions10 = {
							type = "select",
							name = function()
								local TabName = GetChatWindowInfo(10)
								return "Tab ".."10".." - "..TabName
							end,
							values = {[1] = "Nothing", [2] = "Rmove", [3] = "Add"},
							order = 13,
							hidden = function() if SelectedChannel == nil or SelectedChannel == "" then return true else return false end end,
							get = function(info)
								if SelectedChannel == nil or SelectedChannel == "" then return 1 end
								if Display.db.profile.ChannelNames[SelectedChannel][10] == true then return 3
								elseif Display.db.profile.ChannelNames[SelectedChannel][10] == false then return 2
								else return 1
								end
							end,
							set = function(info, v) 
								if SelectedChannel == nil or SelectedChannel == "" then return FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCDL: Please Select a Channel") end
								if v == 1 then Display.db.profile.ChannelNames[SelectedChannel][10] = nil
								elseif v == 2 then Display.db.profile.ChannelNames[SelectedChannel][10] = false
								elseif v == 3 then Display.db.profile.ChannelNames[SelectedChannel][10] = true
								end
							 end,
						},
					},
				},
				SpellsUpdater = {
					type = "group",
					name = "Chat SpellUpdate Options",
					desc = "Set which reporter options you would like to enable.",
					cmdHidden = true,
					order = 4,
					args = {
						descr = {
							type = "description",
							name =  "SpellsUpdate will allow you to auto update your own spells and send messages to other people telling them to update there spells.\n\n",
							width = "full",
							fontSize  = "medium",
							order = 0.1,
						},
						EnableAutoUpdate = {
							type = "toggle",
							name =  "Enable Auto Update",
							desc =  "Auto update the spell ranks on your bars",
							get = function(v) return Display.db.profile.FCDSPEnable end,
							set = function(info, v) Display.db.profile.FCDSPEnable = v end,
							order = 0.2,
							width = "double",
						},
						SUMacros = {
							type = "toggle",
							name =  "Macros: Remove Rank",
							desc =  "removes Rank from macros so they will always use the max rank",
							get = function(v) return Display.db.profile.FCDSPMacros end,
							set = function(info, v) Display.db.profile.FCDSPMacros = v end,
							order = 0.3,
							width = "double",
						},
						FCDSPBlackListAdd = {
							type = "input",
							name = "Blacklist: Add",
							desc = "add a spell to the blacklist, spells in the blacklist will not be auto updated",
							get = function(v) return nil end,
							set = function(info, v) 
								if v == nil or v == "" then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Please enter a real name") return end
								Display.db.profile.FCDSPBlackList[v] = v
								FCDSPBlackListSelected = v
							end,
							width = "double",
							order = 1
						},
						FCDSPBlackList = {
							type = "select",
							name =  "Auto Update Blacklist",
							desc = "any spell in this list will not get auto updated, good for spells like shadowbolt",
							values = function()
								local TempASPN = {}
								for name, name2 in pairs(Display.db.profile.FCDSPBlackList) do
									TempASPN[name] = name
								end
								return TempASPN
							end,
							get = function(info) return FCDSPBlackListSelected end,
							set = function(info, v)	FCDSPBlackListSelected = v end,
							order = 2,
						},
						FCDSPBlackListRemove = {
							order= 3,
							type = "execute",
							name = "Remove",
							desc = "remove the selected spell from the blacklist",
							func = function() if FCDSPBlackListSelected ~= nil and FCDSPBlackListSelected ~= "" then Display.db.profile.FCDSPBlackList[FCDSPBlackListSelected] = nil else return end end,
						},
						MOHD = {
							type = "header",
							name =  "Messages",
							width = "full",
							order = 4,
						},
						EnableMessages = {
							type = "toggle",
							name =  "Enable Messages",
							desc =  "Sends a message in the selected chat when someone uses a down ranked spell",
							get = function(v) return Display.db.profile.FCDSPMessages end,
							set = function(info, v) Display.db.profile.FCDSPMessages = v end,
							order = 5,
						},
						FCDSP80 = {
							type = "toggle",
							name =  "80 Only",
							desc =  "limits the messages to players who are level 80",
							get = function(v) return Display.db.profile.FCDSP80 end,
							set = function(info, v) Display.db.profile.FCDSP80 = v end,
							order = 6,
						},
						FCDSPPlayer = {
							type = "toggle",
							name =  "Ignore Self",
							desc =  "limits the messages to other players",
							get = function(v) return Display.db.profile.FCDSPPlayer end,
							set = function(info, v) Display.db.profile.FCDSPPlayer = v end,
							order = 7,
						}, 
						FCDSPExpac = {
							type = "toggle",
							name =  "WOTLK Limit",
							desc =  "limits the messages to wotlk version",
							get = function(v) return Display.db.profile.FCDSPExpac end,
							set = function(info, v) Display.db.profile.FCDSPExpac = v end,
							order = 7.5,
						}, 
						FCDSPChannel = {
							type = "select",
							name =  "Channel",
							desc = "were to send the message, both does not mean 2 messages it means raid if in raid or party if not in raid",
							values = { "Self", "Party", "Raid", "Both", "Whisper"},
							get = function(info) return Display.db.profile.FCDSPChannel end,
							set = function(info, v)	Display.db.profile.FCDSPChannel = v	end,
							order = 8,
						},
					},
				},
			},
		},
		ChatFilter = {
			type = "group",
			name = "Chat Filter",
			desc = "Configure Chat Filter Options",
			childGroups = "tab",
			cmdHidden = true,
			order = 8,
			args = {
				ChatFilterTab = {
					type = "group",
					name = "Chat Filter Options",
					desc = "Set which filters you would like to enable.",
					cmdHidden = true,
					order = 1,
					args = {
						descr = {
							type = "description",
							name =  "Select which chat filters you would like to enable.\n",
							width = "full",
							fontSize  = "medium",
							order = 1,
						},
					},
				},
				ChatFilterNew = {
					type = "group",
					name = "Custom Chat Filter",
					desc = "Configure Chat Filter Options",
					cmdHidden = true,
					order = 1.5,
					args = {
						CCFD = {
							type = "description",
							name =  "This option allows you to add custom words or phrases to the filter list when a message contains that word or phrase the message will be filtered from the chat.\n\n"..
								"You can use:"..
								"\nFCDAnyLink - for any spell or item link"..
								"\nFCDBoss1 - for the boss1 names e.g. The Lich King or Lord Marrowgar"..
								"\nFCDAuthor - for the players name who said the message"..
								"\nFCDGroupPlayer - for the name anynone in your group"..
								"\n"..
								"\nExample: the code below would block chat like Shekles use [Sunder Armor] on Lord Marrowgar\nFCDAuthor use FCDAnyLink on FCDBoss1\n",
							width = "full",
							order = 1100.11,
						},
						ChatFilterMenu = {
							type = "toggle",
							name = "Chat Filter Menu",
							desc = "adds a context menu when the right clicking a person name in the chat window to block that message, it will be the last message sent by that person, a popup will show what will be filtered.",
							get = function(info) return Display.db.profile.ChatFilterMenu end,
							set = function(info, v)	Display.db.profile.ChatFilterMenu = v end,
							order = 1100.111,
							width = "double"
						},	
						ChatFilterMenuBubbles = {
							type = "toggle",
							name = "Chat Filter Menu Bubbles",
							desc = "adds bubbles to filters added via the chat filter menu.",
							get = function(info) return Display.db.profile.ChatFilterMenuBubbles end,
							set = function(info, v)	Display.db.profile.ChatFilterMenuBubbles = v end,
							order = 1100.112,
							width = "double"
						},	
						ChatFilterMagicCharacters = {
							type = "toggle",
							name = "Magic Characters",
							desc = "edits the message you have added to compensate for magic characters, e.g. - ( ^ $",
							get = function(info) return Display.db.profile.CFMagicChars end,
							set = function(info, v)	Display.db.profile.CFMagicChars = v end,
							order = 1100.113,
							width = "double"
						},	
						CustomChatFilter = {
							type = "input",
							name =  "Add Word or Phrase to Custom Chat Filter (Case Sensitive)",
							get = function(info) return nil end,
							set = function(info, v) 
								if v == nil or v == "" then
									return
								else
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
									if Display.db.profile.CFMagicChars then v = escapePattern(v) end
									TempChatFilterList = v
									Display.db.profile.CustomChatFilterList[v] = {Filter = {}}
									FatCooldowns:GetModule("Chat"):Chatfiltercheck() end end,
							order = 1100.2,
							width = "full",
						},
						CustomChatFilterSelect = {
							type = "select",
							name =  "Select",
							desc = function(info) return TempChatFilterList or "Select a word to change the settings" end,
							values = function(info)
								local tempval = {}
								for v,b in pairs(Display.db.profile.CustomChatFilterList) do
									tempval[v] = v
								end
								return tempval
							end,
							get = function(info) return TempChatFilterList end,
							set = function(info, v)	TempChatFilterList = v FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
							order = 1100.3,
							width = "full",
						},
						CCFRH1 = {
							type = "header",
							name =  "",
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							width = "full",
							order = 1100.35,
						},
						CustomChatFilterRemove = {
							type = "execute",
							name =  "Remove",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							func = function() if TempChatFilterList ~= nil then Display.db.profile.CustomChatFilterList[TempChatFilterList] = nil TempChatFilterList = nil FatCooldowns:GetModule("Chat"):Chatfiltercheck() else FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Remove Word Failed") end end,
							order = 1100.38,
						},	
						CustomChatFilterMatch= {
							type = "toggle",
							name = "Case Sensitive",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							desc = "this will allow you to only match chat messages with or without case sensitivity.",
							get = function(info) return Display.db.profile.CustomChatFilterList[TempChatFilterList].Match end,
							set = function(info, v)	Display.db.profile.CustomChatFilterList[TempChatFilterList].Match = v FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
							order = 1100.381,
						},	
						CustomChatFilterBubbles = {
							type = "toggle",
							name = "Chat Bubbles",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							desc = "This will enable the filtering of the chat bubbles.",
							get = function(info) return Display.db.profile.CustomChatFilterList[TempChatFilterList].Bubbles end,
							set = function(info, v)	Display.db.profile.CustomChatFilterList[TempChatFilterList].Bubbles = v FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
							order = 1100.39,
						},	
						CustomChatFilterRWFrame = {
							type = "toggle",
							name = "RW Frame",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							desc = "This will enable the filtering of messages in the raid warning frame.",
							get = function(info) return Display.db.profile.CustomChatFilterList[TempChatFilterList].RWFrame end,
							set = function(info, v)	Display.db.profile.CustomChatFilterList[TempChatFilterList].RWFrame = v FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
							order = 1100.40,
						},
						CCFRH2 = {
							type = "header",
							name =  "Channels",
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							width = "full",
							order = 1100.6,
						},
						CustomChatFilterSAY = {
							type = "toggle",
							name = "SAY",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for SAY chat type",
							get = function(info) return Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_SAY"] end,
							set = function(info, v)	Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_SAY"] = v FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
							order = 1100.7,
						},
						CustomChatFilterYELL = {
							type = "toggle",
							name = "YELL",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for YELL chat type",
							get = function(info) return Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_YELL"] end,
							set = function(info, v)	Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_YELL"] = v	FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
							order = 1100.8,
						},
						CustomChatFilterPARY = {
							type = "toggle",
							name = "PARTY",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for PARTY chat type",
							get = function(info) return Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_PARTY"] end,
							set = function(info, v)	
								Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_PARTY"] = v 
								Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_PARTY_LEADER"] = v
								FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
							order = 1100.9,
						},
						CustomChatFilterGUILD = {
							type = "toggle",
							name = "GUILD",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for GUILD chat type",
							get = function(info) return Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_GUILD"] end,
							set = function(info, v)	Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_GUILD"] = v FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
							order = 1100.91,
						},
						CustomChatFilterRAID = {
							type = "toggle",
							name = "RAID",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for RAID chat type",
							get = function(info) return Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_RAID"] end,
							set = function(info, v)	
								Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_RAID"] = v
								Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_RAID_LEADER"] = v
								FatCooldowns:GetModule("Chat"):Chatfiltercheck()
							end,
							order = 1101,
						},
						CustomChatFilterRAIDW = {
							type = "toggle",
							name = "RAID WARNING",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for RAID WARNING chat type",
							get = function(info) return Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_RAID_WARNING"] end,
							set = function(info, v) Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_RAID_WARNING"] = v FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
							order = 1102,
						},
						CustomChatFilterWHISPER = {
							type = "toggle",
							name = "WHISPER",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for WHISPER chat type",
							get = function(info) return Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_WHISPER"] end,
							set = function(info, v)	Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_WHISPER"] = v FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
							order = 1103,
						},
						CustomChatFilterGLOBAL = {
							type = "toggle",
							name = "GLOBAL",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for GLOBAL chat type",
							get = function(info) return Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_CHANNEL"] end,
							set = function(info, v)	Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_CHANNEL"] = v FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
							order = 1104,
						},
						CustomChatFilterEMOTE = {
							type = "toggle",
							name = "EMOTE",
							disabled = function() if TempChatFilterList ~= nil then return false else return true end end,
							hidden = function() if TempChatFilterList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for EMOTE chat type",
							get = function(info) return Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_EMOTE"] end,
							set = function(info, v)	Display.db.profile.CustomChatFilterList[TempChatFilterList].Filter["CHAT_MSG_EMOTE"] = v FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
							order = 1105,
						},
					},
				},
				ChatFilterReporter2 = {
					type = "group",
					name = "Chat Filter Reporter Options",
					desc = "Set options for each filtered option, the options will allow you to print the filtered messages in a selected chat window",
					cmdHidden = true,
					order = 2,
					args = {
						descr = {
							type = "description",
							name =  "Select which options you would like to enable for each filter option",
							width = "full",
							fontSize  = "medium",
							order = 1,
						},
						CCFRH = {
							type = "header",
							name =  "Custom Chat Filter Reporter",
							disabled = function() if next(Display.db.profile.CustomChatFilterList) then return false else return true end end,
							hidden = function() if next(Display.db.profile.CustomChatFilterList) then return false else return true end end,
							width = "full",
							order = 1100.1,
						},
						CustomChatFilterReporter = {
							type = "range",
							name = "Custom Chat Reporter",
							min = 0, max = 10, step = 1, bigStep = 1,
							disabled = function() if next(Display.db.profile.CustomChatFilterList) then return false else return true end end,
							hidden = function() if next(Display.db.profile.CustomChatFilterList) then return false else return true end end,
							desc = "Reports messages blocked by the custom chat reporter",
							get = function(info) return Display.db.profile.CustomChatFilterReporter end,
							set = function(info, v)	Display.db.profile.CustomChatFilterReporter = v end,
							order = 1100.2,
						},
					},
				},
			},
		},
		ChatHighlighter = {
			type = "group",
			name = "Chat Highlighter",
			desc = "Configure Chat Highlighter Options",
			cmdHidden = true,
			childGroups = "tab",
			order = 8.5,
			args = {
				PlayerSystemNames = {
					type = "group",
					name = "Name Highlighter",
					desc = "Set which filters you would like to enable.",
					cmdHidden = true,
					order = 1,
					args = {								
						descr = {
							type = "description",
							name =  "This will change the color of player names or change the names to links.\n\n"..
							"Examples:\n\n"..
							"   |cffFF7C0AShekles|r |cff00FF00won: |r|cffa335ee[Deathbringer's Will]|r|cff00FF00.|r\n"..
							"   |cff00FF00[|r|cffFF7C0AShekles|r|cff00FF00]|r |cff00FF00won: |r|cffa335ee[Deathbringer's Will]|r|cff00FF00.|r\n"..
							"   |cffFF7C0AShekles|r |cffFFF468rolls 100 (1-100)|r\n\n",
							width = "full",
							fontSize  = "medium",
							order = 1,
						},
						ColorNamesLoot = {
							type = "toggle",
							name = "Loot: Color Players Names",
							desc = "This will add the class color to players names for loot chat",
							get = function(info) return Display.db.profile.ColorNamesLoot end,
							set = function(info, v)	if v == true then Display.db.profile.ColorNamesLoot2 = false end Display.db.profile.ColorNamesLoot = v end,
							order = 1.2,
							width = "double",
						},
						ColorNamesSystem = {
							type = "toggle",
							name = "System: Color Players Names",
							desc = "This will add the class color to players names for the system messages",
							get = function(info) return Display.db.profile.ColorNamesSystem end,
							set = function(info, v)	if v == true then Display.db.profile.ColorNamesSystem2 = false end Display.db.profile.ColorNamesSystem = v	end,
							order = 1.3,
							width = "double",
						},
						ColorNamesLoot2 = {
							type = "toggle",
							name = "Loot: Link Players Names",
							desc = "This will add the link to players names for loot chat",
							get = function(info) return Display.db.profile.ColorNamesLoot2 end,
							set = function(info, v)	if v == true then Display.db.profile.ColorNamesLoot = false end Display.db.profile.ColorNamesLoot2 = v end,
							order = 1.4,
							width = "double",
						},
						ColorNamesSystem2 = {
							type = "toggle",
							name = "System: Link Players Names",
							desc = "This will add the link to players names for the system messages",
							get = function(info) return Display.db.profile.ColorNamesSystem2 end,
							set = function(info, v)	if v == true then Display.db.profile.ColorNamesSystem = false end Display.db.profile.ColorNamesSystem2 = v end,
							order = 1.5,
							width = "double",
						},
					},
				},
				HighlighterText = {
					type = "group",
					name = "Text Highlighter",
					desc = "Set which filters you would like to enable.",
					cmdHidden = true,
					order = 2,
					args = {
						descr = {
							type = "description",
							name =  "This will change the color of words in the chat window, Select a word from the dropdown box for more options.\n\n"..
							"Note: Add / to any symbols to highlight the symbols e.g. if you want to highlight [ type /[\n"..
							"Symbols List: ( ) . % + – * ? [ ^ $\n\n"..
							"Examples:\n\n"..
							"   |cffFF7C0AShekles|r |cff00FF00won: |r|cffa335ee[Deathbringer's Will]|r|cff00FF00.|r\n"..
							"   |cff00FF00[|r|cffFF7C0AShekles|r|cff00FF00]|r |cff00FF00won: |r|cffa335ee[Deathbringer's Will]|r|cff00FF00.|r\n"..
							"   |cffFF7C0AShekles|r |cffFFF468rolls 100 (1-100)|r\n"..
							"   |cffFFBFBF[Global]: Join our|r |cff00FFFFDiscord|r |cffFFBFBFat |r|cffffffff[Discord.gg/Fake]|r\n\n",
							width = "full",
							fontSize  = "medium",
							order = 1,
						},
						ChatHighlighter = {
							type = "input",
							name =  "Add Word to Highlighter",
							get = function(info) return nil end,
							set = function(info, v) 
								if v == nil or v == "" or #v < 4 then
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Highlighter: The Word or Phrase must be at least 4 letters long")
									return
								else
									TempHighLightList = v Display.db.profile.HighLightList[v] = {r = 1, g = 1, b = 1, sound = "None", Filter = {}}
								end
							end,
							order = 1100.2,
							width = "double",
						},
						ChatHighlighterSelect = {
							type = "select",
							name =  "Select",
							desc = "Select a word to change the settings",
							values = function(info)
								local tempval = {}
								for v,b in pairs(Display.db.profile.HighLightList) do
									tempval[v] = v
								end
								return tempval
							end,
							get = function(info) return TempHighLightList end,
							set = function(info, v)	TempHighLightList = v end,
							order = 1100.3,
							width = "double",
						},
						ChatHighlighterSelectSound ={
							type = "select",
							name =  "Custom Sound",
							desc =  "this will enable the Custom set sound to play",
							disabled = function() if TempHighLightList ~= nil then return false else return true end end,
							hidden = function() if TempHighLightList ~= nil then return false else return true end end,
							values = function()
							local SoundName = {}
								for CustomSoundName, CustomSoundPath in pairs(FatCooldowns.FCDSounds) do
									SoundName[CustomSoundName] = CustomSoundName
								end
								return SoundName
							end,
							get = function(info, v, v2) if TempHighLightList ~= nil then return Display.db.profile.HighLightList[TempHighLightList].sound end end,
							set = function(info, v, v2) Display.db.profile.HighLightList[TempHighLightList].sound = v PlaySoundFile(FatCooldowns.FCDSounds[v], "Master",false) end,
							order = 1100.4,
							width = "double",
						},
						ChatHighlighterSelectColor = {
							type = "color",	
							name =  "Word Color",
							desc =  "this will change the selected word color",
							disabled = function() if TempHighLightList ~= nil then return false else return true end end,
							hidden = function() if TempHighLightList ~= nil then return false else return true end end,
							hasAlpha = false,
							get = function(info) if TempHighLightList ~= nil then
								return
								Display.db.profile.HighLightList[TempHighLightList]["r"], 
								Display.db.profile.HighLightList[TempHighLightList]["g"],
								Display.db.profile.HighLightList[TempHighLightList]["b"],
								Display.db.profile.HighLightList[TempHighLightList]["a"] end end,
							set = function(info, r, g, b, a)
								Display.db.profile.HighLightList[TempHighLightList]["r"] = r
								Display.db.profile.HighLightList[TempHighLightList]["g"] = g
								Display.db.profile.HighLightList[TempHighLightList]["b"] = b
								Display.db.profile.HighLightList[TempHighLightList]["a"] = a
							end,
							order = 1100.5,
						},
						ChatHighlighterRemove = {
							type = "execute",
							name =  "Remove",
							disabled = function() if TempHighLightList ~= nil then return false else return true end end,
							hidden = function() if TempHighLightList ~= nil then return false else return true end end,
							func = function() if TempHighLightList ~= nil then Display.db.profile.HighLightList[TempHighLightList] = nil TempHighLightList = nil else FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Remove Word Failed") end end,
							order = 1100.6,
						},	
						FilterHighLighterSAY = {
							type = "toggle",
							name = "SAY",
							disabled = function() if TempHighLightList ~= nil then return false else return true end end,
							hidden = function() if TempHighLightList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for SAY chat type",
							get = function(info) return Display.db.profile.HighLightList[TempHighLightList].Filter["SAY"] end,
							set = function(info, v)	Display.db.profile.HighLightList[TempHighLightList].Filter["SAY"] = v	end,
							order = 1100.7,
						},
						FilterHighLighterYELL = {
							type = "toggle",
							name = "YELL",
							disabled = function() if TempHighLightList ~= nil then return false else return true end end,
							hidden = function() if TempHighLightList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for YELL chat type",
							get = function(info) return Display.db.profile.HighLightList[TempHighLightList].Filter["YELL"] end,
							set = function(info, v)	Display.db.profile.HighLightList[TempHighLightList].Filter["YELL"] = v	end,
							order = 1100.8,
						},
						FilterHighLighterPARY = {
							type = "toggle",
							name = "PARTY",
							disabled = function() if TempHighLightList ~= nil then return false else return true end end,
							hidden = function() if TempHighLightList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for PARTY chat type",
							get = function(info) return Display.db.profile.HighLightList[TempHighLightList].Filter["PARTY"] end,
							set = function(info, v)	Display.db.profile.HighLightList[TempHighLightList].Filter["PARTY"] = v	end,
							order = 1100.9,
						},
						FilterHighLighterRAID = {
							type = "toggle",
							name = "RAID",
							disabled = function() if TempHighLightList ~= nil then return false else return true end end,
							hidden = function() if TempHighLightList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for PARTY chat type",
							get = function(info) return Display.db.profile.HighLightList[TempHighLightList].Filter["RAID"] end,
							set = function(info, v)	
								Display.db.profile.HighLightList[TempHighLightList].Filter["RAID"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["RAID_LEADER"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["RAID_WARNING"] = v
							end,
							order = 1101,
						},
						FilterHighLighterGUILD = {
							type = "toggle",
							name = "GUILD",
							disabled = function() if TempHighLightList ~= nil then return false else return true end end,
							hidden = function() if TempHighLightList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for PARTY chat type",
							get = function(info) return Display.db.profile.HighLightList[TempHighLightList].Filter["GUILD"] end,
							set = function(info, v)
								Display.db.profile.HighLightList[TempHighLightList].Filter["GUILD"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["OFFICER"] = v
							end,
							order = 1102,
						},
						FilterHighLighterWHISPER = {
							type = "toggle",
							name = "WHISPER",
							disabled = function() if TempHighLightList ~= nil then return false else return true end end,
							hidden = function() if TempHighLightList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for PARTY chat type",
							get = function(info) return Display.db.profile.HighLightList[TempHighLightList].Filter["WHISPER"] end,
							set = function(info, v)
								Display.db.profile.HighLightList[TempHighLightList].Filter["WHISPER"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["WHISPER_INFORM"] = v
							end,
							order = 1103,
						},
						FilterHighLighterGLOBAL = {
							type = "toggle",
							name = "GLOBAL",
							disabled = function() if TempHighLightList ~= nil then return false else return true end end,
							hidden = function() if TempHighLightList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for PARTY chat type",
							get = function(info) return Display.db.profile.HighLightList[TempHighLightList].Filter["CHANNEL1"] end,
							set = function(info, v)	
								Display.db.profile.HighLightList[TempHighLightList].Filter["CHANNEL1"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["CHANNEL2"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["CHANNEL3"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["CHANNEL4"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["CHANNEL5"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["CHANNEL6"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["CHANNEL7"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["CHANNEL8"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["CHANNEL9"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["CHANNEL10"] = v
							end,
							order = 1104,
						},
						FilterHighLighterBG = {
							type = "toggle",
							name = "BATTLEGROUNDS",
							disabled = function() if TempHighLightList ~= nil then return false else return true end end,
							hidden = function() if TempHighLightList ~= nil then return false else return true end end,
							desc = "This will enable the Highlighter for PARTY chat type",
							get = function(info) return Display.db.profile.HighLightList[TempHighLightList].Filter["BATTLEGROUND"] end,
							set = function(info, v)
								Display.db.profile.HighLightList[TempHighLightList].Filter["BATTLEGROUND"] = v
								Display.db.profile.HighLightList[TempHighLightList].Filter["BATTLEGROUND_LEADER"] = v
							end,
							order = 1105,
						},
					},
				},
				ItemSpellsIcons = {
					type = "group",
					name = "Icons Highlighter",
					desc = "Set which filters you would like to enable.",
					cmdHidden = true,
					order = 3,
					args = {
						descr2 = {
							type = "description",
							name =  "\nThis will add icons next to spells, items, achievements and profession in chat.\n\n Examples:\n\n"..	
							"|cffFFBFBF[Global]: LFM |TInterface\\Icons\\achievement_boss_lichking:20:20:0:0:64:64:6:58:6:58|t |cffFFF468[Bane of the Fallen King]|r |cffFFBFBFNeed All|r\n"..
							"|cffFFBFBF[Global]: WTB |TInterface\\Icons\\inv_jewelcrafting_gem_32:20:20:0:0:64:64:6:58:6:58|t |cffa335ee[Cardinal Ruby]|r |cffFFBFBFX20|r\n\n",
							width = "full",
							fontSize  = "medium",
							order = 1200,
						},
						SpellIcons = {
							type = "range",
							name =  "Spell Icon Size",
							min = 0, max = 32, step = 4, bigStep = 4,
							desc = "0 = disabled, adds/set the size of spell icons when a spell is linked in chat",
							get = function(info) return Display.db.profile.SpellIcons end,
							set = function(info, v)	Display.db.profile.SpellIcons = v Display:UpdateTextureLinkFormat() end,
							order = 1201,
							width = "double",
						},
						ItemIcons = {
							type = "range",
							name =  "Item Icon Size",
							min = 0, max = 32, step = 4, bigStep = 4,
							desc = "0 = disabled, adds/set the size of Item icons when a item is linked in chat",
							get = function(info) return Display.db.profile.ItemIcons end,
							set = function(info, v)	Display.db.profile.ItemIcons = v Display:UpdateTextureLinkFormat() end,
							order = 1202,
							width = "double",
						},
						AchivIcons = {
							type = "range",
							name =  "Achiv Icon Size",
							min = 0, max = 32, step = 4, bigStep = 4,
							desc = "0 = disabled, adds/set the size of Achiv icons when a achievement is linked in chat",
							get = function(info) return Display.db.profile.AchivIcons end,
							set = function(info, v)	Display.db.profile.AchivIcons = v Display:UpdateTextureLinkFormat() end,
							order = 1203,
							width = "double",
						},
						ProfIcons = {
							type = "range",
							name =  "Profession Icon Size",
							min = 0, max = 32, step = 4, bigStep = 4,
							desc = "0 = disabled, adds/set the size of Profession icons when a profession is linked in chat",
							get = function(info) return Display.db.profile.ProfIcons end,
							set = function(info, v)	Display.db.profile.ProfIcons = v Display:UpdateTextureLinkFormat() end,
							order = 1204,
							width = "double",
						},
						NeedIcons = {
							type = "range",
							name =  "Need Icon Size",
							min = 0, max = 32, step = 4, bigStep = 4,
							desc = "0 = disabled, adds/set the size of Need icons when a item is linked in chat",
							get = function(info) return Display.db.profile.NeedIcons end,
							set = function(info, v)	Display.db.profile.NeedIcons = v Display:UpdateTextureLinkFormat() end,
							order = 1205,
						},
						GreedIcons = {
							type = "range",
							name =  "Greed Icon Size",
							min = 0, max = 32, step = 4, bigStep = 4,
							desc = "0 = disabled, adds/set the size of Greed icons when a item is linked in chat",
							get = function(info) return Display.db.profile.GreedIcons end,
							set = function(info, v)	Display.db.profile.GreedIcons = v Display:UpdateTextureLinkFormat() end,
							order = 1206,
						},
						PassIcons = {
							type = "range",
							name =  "Pass Icon Size",
							min = 0, max = 32, step = 4, bigStep = 4,
							desc = "0 = disabled, adds/set the size of Pass icons when a item is linked in chat",
							get = function(info) return Display.db.profile.PassIcons end,
							set = function(info, v)	Display.db.profile.PassIcons = v Display:UpdateTextureLinkFormat() end,
							order = 1207,
						},
						NeedIconsTable = {
							type = 'input',
							name =  "Add Need Item",
							desc =  "Adds an item to the list of items that will show the need icon",
							get = function(v) return nil end,
							set = function(info, v)
								local ITEM_LINK_PATTERN = "|c%x%x%x%x%x%x%x%x|Hitem:(%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:?-?%d*|h"
							    local matchStart, matchEnd, match = v:find(ITEM_LINK_PATTERN)
								if v == "" or v == nil then
								elseif match then 
									Display.db.profile.NeedIconsTable[tonumber(match)] = tonumber(match)
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..v.." Added")
								elseif v:match("^%d+$") then
									Display.db.profile.NeedIconsTable[tonumber(v)] = tonumber(v)
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..v.." Added")
								end
							end,
							order = 1208,
							width = "double",
						},
						NeedIconsTableRemove = {
							type = "select",
							name =  "Removal Need",
							desc = "select a item to remove it from the need icon list.",
							values = function(info)
							local Items = {}
								for ItemIndex, ItemValue in pairs(Display.db.profile.NeedIconsTable) do
									local name, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(ItemIndex)
									if name ~= nil then
										Items[name] = "|T"..itemTexture..":24:24:0:0:64:64:6:58:6:58|t "..name
									else
										Items[tostring(ItemIndex)] = "|T".."Interface\\Icons\\inv_misc_questionmark"..":24:24:0:0:64:64:6:58:6:58|t "..tostring(ItemIndex)
									end
								end
								return Items
							end,
							get = function(info) return nil end,
							set = function(info, v,v2)
								for ItemIndex, ItemValue in pairs(Display.db.profile.NeedIconsTable) do
									local name, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(ItemIndex)
									if v == name then 
										Display.db.profile.NeedIconsTable[ItemIndex] = nil
										FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..v.." Removed")
									end
								end
							end,
							order = 1209,
							width = "double",
						},
						GreedIconsTable = {
							type = 'input',
							name =  "Add Greed Item",
							desc =  "Adds an item to the list of items that will show the Greed icon",
							get = function(v) return nil end,
							set = function(info, v)
								local ITEM_LINK_PATTERN = "|c%x%x%x%x%x%x%x%x|Hitem:(%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:?-?%d*|h"
							    local matchStart, matchEnd, match = v:find(ITEM_LINK_PATTERN)
								if v == "" or v == nil then
								elseif match then 
									Display.db.profile.GreedIconsTable[tonumber(match)] = tonumber(match)
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..v.." Added")
								elseif v:match("^%d+$") then
									Display.db.profile.GreedIconsTable[tonumber(v)] = tonumber(v)
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..v.." Added")
								end
							end,
							order = 1210,
							width = "double",
						},
						GreedIconsTableRemove = {
							type = "select",
							name =  "Removal Greed",
							desc = "select a item to remove it from the Greed icon list.",
							values = function(info)
							local Items = {}
								for ItemIndex, ItemValue in pairs(Display.db.profile.GreedIconsTable) do
									local name, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(ItemIndex)
									if name ~= nil then
										Items[name] = "|T"..itemTexture..":24:24:0:0:64:64:6:58:6:58|t "..name
									else
										Items[tostring(ItemIndex)] = "|T".."Interface\\Icons\\inv_misc_questionmark"..":24:24:0:0:64:64:6:58:6:58|t "..tostring(ItemIndex)
									end
								end
								return Items
							end,
							get = function(info) return nil end,
							set = function(info, v,v2)
								for ItemIndex, ItemValue in pairs(Display.db.profile.GreedIconsTable) do
									local name, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(ItemIndex)
									if v == name then 
										Display.db.profile.GreedIconsTable[ItemIndex] = nil
										FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..v.." Removed")
									end
								end
							end,
							order = 1211,
							width = "double",
						},
						PassIconsTable = {
							type = 'input',
							name =  "Add Pass Item",
							desc =  "Adds an item to the list of items that will show the Pass icon",
							get = function(v) return nil end,
							set = function(info, v)
								local ITEM_LINK_PATTERN = "|c%x%x%x%x%x%x%x%x|Hitem:(%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:?-?%d*|h"
							    local matchStart, matchEnd, match = v:find(ITEM_LINK_PATTERN)
								if v == "" or v == nil then
								elseif match then 
									Display.db.profile.PassIconsTable[tonumber(match)] = tonumber(match)
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..v.." Added")
								elseif v:match("^%d+$") then
									Display.db.profile.PassIconsTable[tonumber(v)] = tonumber(v)
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..v.." Added")
								end
							end,
							order = 1212,
							width = "double",
						},
						PassIconsTableRemove = {
							type = "select",
							name =  "Removal Pass",
							desc = "select a item to remove it from the Pass icon list.",
							values = function(info)
							local Items = {}
								for ItemIndex, ItemValue in pairs(Display.db.profile.PassIconsTable) do
									local name, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(ItemIndex)
									if name ~= nil then
										Items[name] = "|T"..itemTexture..":24:24:0:0:64:64:6:58:6:58|t "..name
									else
										Items[tostring(ItemIndex)] = "|T".."Interface\\Icons\\inv_misc_questionmark"..":24:24:0:0:64:64:6:58:6:58|t "..tostring(ItemIndex)
									end
								end
								return Items
							end,
							get = function(info) return nil end,
							set = function(info, v,v2)
								for ItemIndex, ItemValue in pairs(Display.db.profile.PassIconsTable) do
									local name, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(ItemIndex)
									if v == name then 
										Display.db.profile.PassIconsTable[ItemIndex] = nil
										FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..v.." Removed")
									end
								end
							end,
							order = 1213,
							width = "double",
						},
					},
				},
			},
		},	
		ChatWhispers = {
			type = "group",
			name = "Chat Whispers",
			desc = "Configure Chat Whispers Options",
			cmdHidden = true,
			order = 8.6,
			args = {
				descr = {
					type = "description",
					name =  "Chat Whispers will allow you to block whispers from people and send a auto reply, the people blocked will depend on the settings below.\n\n",
					width = "full",
					fontSize  = "medium",
					order = 1,
				},
				CWEnable = {
					type = "toggle",
					name =  "Enable",	
					desc = "Enables the blocking of whispers",
					get = function(info) return Display.db.profile.CWEnable end,
					set = function(info, v) Display.db.profile.CWEnable = v FatCooldowns:GetModule("Chat"):Chatfiltercheck() end,
					order = 2,
					width = "double",
				},
				CWESound = {
					type = "toggle",
					name =  "Play Sound",	
					desc = "Plays a Sound when the addon blocks a whisper",
					get = function(info) return Display.db.profile.CWESound end,
					set = function(info, v) Display.db.profile.CWESound = v end,
					order = 3,
				},
				CWEReply = {
					type = "toggle",
					name =  "Auto Reply Message",	
					desc = "Enables the auto reply to blocked whispers",
					get = function(info) return Display.db.profile.CWEReply end,
					set = function(info, v) Display.db.profile.CWEReply = v end,
					order = 4,
				},
				CWHDer = {
					type = "header",
					name =  "Allowed Whispers",
					width = "full",
					order = 10,
				},
				CWECurrentGuild = {
					type = "toggle",
					name =  "Current Guild",	
					desc = "allow whispers from people in your current guild",
					get = function(info) return Display.db.profile.CWECurrentGuild end,
					set = function(info, v) Display.db.profile.CWECurrentGuild = v end,
					order = 11,
				},
				CWEAltGuilds = {
					type = "toggle",
					name =  "Alt Guilds",	
					desc = "allow whispers from your alt guilds",
					get = function(info) return Display.db.profile.CWEAltGuilds end,
					set = function(info, v) Display.db.profile.CWEAltGuilds = v end,
					order = 13,
				},
				CWEFirends = {
					type = "toggle",
					name =  "Friends",	
					desc = "allow whispers from your friends",
					get = function(info) return Display.db.profile.CWEFirends end,
					set = function(info, v) Display.db.profile.CWEFirends = v end,
					order = 13.4,
				},
				CWEGroup = {
					type = "toggle",
					name =  "Group",	
					desc = "allow whispers from people in your raid/party",
					get = function(info) return Display.db.profile.CWEGroup end,
					set = function(info, v) Display.db.profile.CWEGroup = v end,
					order = 13.5,
				},
				CWEWho = {
					type = "toggle",
					name =  "Who",	
					desc = "allow the addon to use your who list to find out if the person is allowed to message you",
					get = function(info) return Display.db.profile.CWEWho end,
					set = function(info, v) Display.db.profile.CWEWho = v end,
					order = 14,
				},
				CWEZone = {
					type = "toggle",
					name =  "Zone",	
					desc = "allows messages from people who are in the same zone as you.",
					get = function(info) return Display.db.profile.CWEZone end,
					set = function(info, v) Display.db.profile.CWEZone = v end,
					order = 14,
				},
				CWEPMed = {
					type = "range",
					name =  "Reply Time",
					desc =  "allows people you message to message you back for the set amount of time, the set time is in minutes",
					min = 0, max = 60, step = 1, bigStep = 1,
					get = function(v) return Display.db.profile.CWEPMed end,
					set = function(info, v) Display.db.profile.CWEPMed = v end,
					order = 14.5,
				},
				CWEPostedTimer = {
					type = "range",
					name =  "After Message Time",
					desc =  "set the time for allowed messages after you post a message",
					min = 0, max = 60, step = 1, bigStep = 1,
					get = function(v) return Display.db.profile.CWEPostedTimer end,
					set = function(info, v) Display.db.profile.CWEPostedTimer = v end,
					order = 14.55,
				},
				CWEPosted = {
					type = "multiselect",
					name =  "After Message",
					desc =  "this will allow messages from people after you have posted in the selected Channels for the set time.",
					values = function(info, v) return {
						["CHAT_MSG_CHANNEL"] = "Channels",
						["CHAT_MSG_YELL"] = "Yell",
						["CHAT_MSG_SAY"] = "Say",
					} end,
					get = function(info, v) return Display.db.profile.CWEPosted[v] end,
					set = function(info, v, v2) Display.db.profile.CWEPosted[v] = v2 end,
					order = 14.6,
				},
				descr = {
					type = "description",
					name =  "",
					width = "full",
					fontSize  = "medium",
					order = 14.9,
				},
				CWAddGuild = {
					type = "input",
					name = "Add Guild",
					desc = "Add a guild to your allowed list",
					get = function(v) return nil end,
					set = function(info, v) if v ~= nil then Display.db.profile.CWEAltGuildsSaved[v] = v end end,
					width = "double",
					order = 15,
				},
				CWRemoveGuild = {
					type = "select",
					name =  "Remove Guild",
					desc = "Select a Guild to be removed from your allowed list",
					values = function(info, v)
						local tabletoreturn = {}
						for index, val in pairs(Display.db.profile.CWEAltGuildsSaved) do
							tabletoreturn[index] = index
						end
						return tabletoreturn
					end,
					get = function(info) return Display.db.profile.CWEAltGuildsSaved end,
					set = function(info, v)	Display.db.profile.CWEAltGuildsSaved[v] = nil end,
					order = 16,
					width = "double",
				},
				CWAddPlayer = {
					type = "input",
					name = "Add Player",
					desc = "Add a player to your allowed list",
					get = function(v) return nil end,
					set = function(info, v) if v ~= nil then Display.db.profile.CWEPlayerSaved[v] = v end end,
					width = "double",
					order = 17,
				},
				CWRemovePlayer = {
					type = "select",
					name =  "Remove Player",
					desc = "Select a player to be removed from your allowed list",
					values = function(info, v)
						local tabletoreturn = {}
						for index, val in pairs(Display.db.profile.CWEPlayerSaved) do
							tabletoreturn[index] = index
						end
						return tabletoreturn
					end,
					get = function(info) return Display.db.profile.CWEPlayerSaved end,
					set = function(info, v)	Display.db.profile.CWEPlayerSaved[v] = nil end,
					order = 18,
					width = "double",
				},
				CWLog = {
					type = "input",
					name = "Log",
					desc = "a log of blocked whispers",
					get = function(v)
						local tablemessages
						tablemessages = ""
						table.sort(Display.db.profile.CWLog, function(a,b) return a[1] > b[1] end)
						for c,v in pairs(Display.db.profile.CWLog) do
							tablemessages = tablemessages..v[2].."\n"
						end
						return tablemessages
					end,
					set = function(info, v) end,
					width = "full",
					order = 20,
					multiline = 15,
				},
			},
		},	
		ChatHistory = {
			type = "group",
			name = "Chat History",
			desc = "Chat History Options",
			order = 8.7,
			args = {
				MLimD = {
					type = "description",
					name =  "Chat History will save you last messages and print them when you log-in or reload ui. Note: The messages are shared across your characters.\n\n",
					width = "full",
					fontSize  = "medium",
					order = 0.5,
				},
				EnableChatHistory = {
					type = "toggle",
					name =  "Enable",
					desc =  "Enable Chat History",
					get = function(info) return Display.db.profile.EnableChatHistory end,
					set = function(info, v)	Display.db.profile.EnableChatHistory = v Display:FCDDelPopup() end,
					order = 1,
				},
				MessageLimit = {
					type = "range",
					name = "Message Limit",
					desc = "Limits the number of messages",
					min = 1, max = 2000, step = 1, bigStep = 1,
					get = function(v) return Display.db.profile.MessageLimit end,
					set = function(info, v) Display.db.profile.MessageLimit = v end,
					order = 2,
					width = "full",
				},
				MLimD2 = {
					type = "description",
					name =  "\n",
					width = "full",
					fontSize  = "medium",
					order = 5,
				},
				ChatHistorySAY = {
					type = "toggle",
					name = "SAY",
					desc = "This will enable the Chat History for SAY chat type",
					get = function(info) return Display.db.profile.ChatHistoryList["CHAT_MSG_SAY"] end,
					set = function(info, v)	Display.db.profile.ChatHistoryList["CHAT_MSG_SAY"] = v  end,
					order = 1100.7,
				},
				ChatHistoryYELL = {
					type = "toggle",
					name = "YELL",
					desc = "This will enable the Chat History for YELL chat type",
					get = function(info) return Display.db.profile.ChatHistoryList["CHAT_MSG_YELL"] end,
					set = function(info, v)	Display.db.profile.ChatHistoryList["CHAT_MSG_YELL"] = v	 end,
					order = 1100.8,
				},
				ChatHistoryPARY = {
					type = "toggle",
					name = "PARTY",
					desc = "This will enable the Chat History for PARTY chat type",
					get = function(info) return Display.db.profile.ChatHistoryList["CHAT_MSG_PARTY"] end,
					set = function(info, v)
						Display.db.profile.ChatHistoryList["CHAT_MSG_PARTY"] = v
						Display.db.profile.ChatHistoryList["CHAT_MSG_PARTY_LEADER"] = v
					end,
					order = 1100.9,
				},
				ChatHistoryRAID = {
					type = "toggle",
					name = "RAID",
					desc = "This will enable the Chat History for RAID chat type",
					get = function(info) return Display.db.profile.ChatHistoryList["CHAT_MSG_RAID"] end,
					set = function(info, v)	
						Display.db.profile.ChatHistoryList["CHAT_MSG_RAID"] = v
						Display.db.profile.ChatHistoryList["CHAT_MSG_RAID_LEADER"] = v
						Display.db.profile.ChatHistoryList["CHAT_MSG_RAID_WARNING"] = v			
					end,
					order = 1101,
				},
				ChatHistoryWHISPER = {
					type = "toggle",
					name = "WHISPER",
					desc = "This will enable the Chat History for WHISPER chat type",
					get = function(info) return Display.db.profile.ChatHistoryList["CHAT_MSG_WHISPER"] end,
					set = function(info, v)	
						Display.db.profile.ChatHistoryList["CHAT_MSG_WHISPER"] = v
						Display.db.profile.ChatHistoryList["CHAT_MSG_WHISPER_INFORM"] = v
					end,
					order = 1103,
				},
				ChatHistoryGUILD = {
					type = "toggle",
					name = "GUILD",
					desc = "This will enable the Chat History for GUILD chat type",
					get = function(info) return Display.db.profile.ChatHistoryList["CHAT_MSG_GUILD"] end,
					set = function(info, v)
						Display.db.profile.ChatHistoryList["CHAT_MSG_GUILD"] = v
						Display.db.profile.ChatHistoryList["CHAT_MSG_OFFICER"] = v
					end,
					order = 1103.91,
				},
				ChatHistoryGLOBAL = {
					type = "toggle",
					name = "GLOBAL",
					desc = "This will enable the Chat History for GLOBAL chat type",
					get = function(info) return Display.db.profile.ChatHistoryList["CHAT_MSG_CHANNEL"] end,
					set = function(info, v)	Display.db.profile.ChatHistoryList["CHAT_MSG_CHANNEL"] = v  end,
					order = 1104,
				},
				ChatHistoryBG = {
					type = "toggle",
					name = "BATTLEGROUND",
					desc = "This will enable the Chat History for GLOBAL chat type",
					get = function(info) return Display.db.profile.ChatHistoryList["CHAT_MSG_BATTLEGROUND"] end,
					set = function(info, v)
						Display.db.profile.ChatHistoryList["CHAT_MSG_BATTLEGROUND"] = v
						Display.db.profile.ChatHistoryList["CHAT_MSG_BATTLEGROUND_LEADER"] = v
					end,
					order = 1105,
				},
			},
		},
		DisabledGroup2 = {
			type = "group",
			name = "-------------------",
			desc = "Spliter",
			cmdHidden = true,
			disabled = function() return true end,
			order = 8.9,
			args = {	
			},
		},	
		SettingsImport = {
			type = "group",
			name = "I/E Settings",
			desc = "Import/Export Settings",
			cmdHidden = true,
			order = 8.91,
			args = {
				descr1 = {
					type = "description",
					name =  "Here you can import or export settings. You should |cffFFF569backup your wtf settings|r before importing any settings. \n\nThis will only export/import from/to the current loaded profile. if you want to copy settings from profile A to profile B you will need to load profile A export the settings then load profile B and inport the settings.\n",
					width = "full",
					order = 1,
				},
				FLTimerRemove = {
					type = "select",
					name =  "Select Settings",
					desc = "Select which settings you would like to export/import from the current profile.",
					values = {"All", "Frames", "Spell Sounds", "Spells Order", "TM Sell List", "TM Auto Delete List", "Auto Mailer", "Auto Roll", "Auto Buy",},
					get = function(info) return IESettings end,
					set = function(info, v) IESettings2 = nil IESettings = v SetEISettings() end,
					order = 2,
					width = "full",
				},
				ExportSettings = {
					type = "input",
					name =  "Export",
					get = function(info) return IESettings2 end,
					set = function(info, v) SetEISettings() end,
					order = 3,
					multiline  = 12,
					width = "full",
				},
				ImportSettings = {
					type = "input",
					name =  "Import",
					get = function(info) return nil end,
					set = function(info, v) 
						if v == nil or v == "" then 
							FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: No Import Settings")
						else
							local decoded = LD:DecodeForPrint(v)
							if decoded then
								local decompressed = LD:DecompressDeflate(decoded)
								if decompressed then
									success, deserialized = FatCooldowns:Deserialize(decompressed)
									if success then
										if type(deserialized) == "table" then 
											if deserialized[1] == 1 then 
												for x,c in pairs(deserialized[2][1]) do
													Display.db.profile[x] = c
												end
												ReloadUI()
											elseif deserialized[1] == 2 then 
												Display.db.profile.frames = deserialized[2][1]
												ReloadUI()
											elseif deserialized[1] == 3 then 
												Display.db.profile.soundspells = deserialized[2][1]
												Display.db.profile.soundspellsoptions = deserialized[2][2]
												ReloadUI()
											elseif deserialized[1] == 4 then 
												Display.db.profile.orderSpells = deserialized[2][1]
												Display.db.profile.orderSpellPriorities = deserialized[2][2]
												ReloadUI()
											elseif deserialized[1] == 5 then 
												Display.db.profile.SellList2 = deserialized[2][1]
												ReloadUI()
											elseif deserialized[1] == 6 then 
												Display.db.profile.ADList2 = deserialized[2][1]
												ReloadUI()
											elseif deserialized[1] == 7 then 
												Display.db.profile.AutoMailerPlayers = deserialized[2][1]
												Display.db.profile.LootMailerList = deserialized[2][2]
												Display.db.profile.Realms = deserialized[2][3]
												ReloadUI()
											elseif deserialized[1] == 8 then 
												Display.db.profile.ARCount = deserialized[2][1]
												Display.db.profile.LootBlackList2 = deserialized[2][2]
												Display.db.profile.ARTable = deserialized[2][3]
												Display.db.profile.ARNameT = deserialized[2][4]
												ReloadUI()
											elseif deserialized[1] == 9 then 
												Display.db.profile.ABList = deserialized[2][1]
												ReloadUI()
											end
										end
									else
										FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: Failed Deserialized")
									end
								else
									FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: Failed Decompressed")
								end
							else
								FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: Failed Decoded")
							end
						end
					end,
					order = 4,
					multiline  = 12,
					width = "full",
					desc =  "After reload settings will be Imported.",
					confirm = true
				},
			},
		},	
		About = {
			type = "group",
			name = "About",
			desc = "Extra Info",
			cmdHidden = true,
			order = 9,
			args = {
				descr1 = {
					type = "description",
					name =  "Welcome to FCD (FatCooldowns) |cffFF7C0AShekles|r Version, below is some extra information about this addon.\n\n",
					width = "full",
					fontSize  = "large",
					order = 1,
				},
				descr2 = {
					type = "description",
					name =  "|cffFFB74D1Q. Some of my permanent bars are missing up, what can i do?|r\n" ..
						"You can force a rescan to fix any missing bars, /fcd raidupdate will force a rescan.\n",
					width = "full",
					fontSize  = "medium",
					order = 2,
				},
				descr3 = {
					type = "description",
					name =  "|cffFFB74D2Q. Some of my bars are messed up/look funny, what can i do?|r\n" ..
						"Sometimes bars can get messed up/look funny after changing settings a simple relog or reload ui should fix this.\n",
					width = "full",
					fontSize  = "medium",
					order = 3,
				},
				descr4 = {
					type = "description",
					name =  "|cffFFB74D3Q. What are the commands for this addon?|r\n" ..
						"You can do /fcd help for a full list of commands.\n",
					width = "full",
					fontSize  = "medium",
					order = 4,
				},	
				descr5 = {
					type = "description",
					name =  "|cffFFB74D4Q. My FPS dropped a lot because of this addon, what can i do?|r\n" ..
						"You can try any of the following: disable the deep scan, remove the border, remove the background, disable spell availability, disable color names, track less spells, turn off backlash reporter.\n",
					width = "full",
					fontSize  = "medium",
					order = 4,
				},
				descr6 = {
					type = "description",
					name =  "|cffFFB74D5Q. What does the R/F/+ mean at the end of ToT/MD bars?|r\n" ..
						"The + means the hunter did double MD, R means the MD/ToT was removed and F means the MD/ToT was removed/finished before the aggro part of the spell was proc'ed.\n",
					width = "full",
					fontSize  = "medium",
					order = 5,
				},	
				descr65 = {
					type = "description",
					name =  "|cffFFB74D6Q. How can i remove the timer from the spell animation?|r\n" ..
						"If you are using OmniCC you can add CooldownTimer to the filter list.\n",
					width = "full",
					fontSize  = "medium",
					order = 5.5,
				},	
				descr7 = {
					type = "description",
					name =  "|cffFFB74D7Q. I dont understand what some things do, where can i find more information about some of the settings in this addon?|r\n" .. 
						"You can mouseover the setting and read the tooltip, if this is still not enough information please report which ones you are having a problem with so i can change the description.\n",
					width = "full",
					fontSize  = "medium",
					order = 6,
				},	
				descr8 = {
					type = "description",
					name =  "|cffFFB74D8Q. I have found a bug where do i report it?|r\n" ..
						"Most bugs happen when changing the setting they can be fixed with a reload ui but if the bug persistence you can report it to me on discord link below, I do not use any site for this addon.",
					width = "full",
					fontSize  = "medium",
					order = 7,
				},
				DiscordLink = {
					type = "input",
					name =  "Discord Link",
					get = function(info) return "https://discord.gg/deVHwh2Jny" end,
					set = function(info, v) v = "https://discord.gg/deVHwh2Jny" end,
					order = 7.5,
					width = "full",
				},
				descr9 = {
					type = "description",
					name =  "\n|cffFFB74D9Q. Did you (|r|cffFF7C0AShekles|r|cffFFB74D) make this addon?|r\n" ..
						"No this addon has been edited by many different people and it was orginaly RaidCooldowns.\n",
					width = "full",
					fontSize  = "medium",
					order = 8,
				},	
				descr10 = {
					type = "description",
					name =  "|cffFFB74D10Q. How do i know when you update this addon and were can i download the updated version?|r\n" .. 
						"I post updates in a few guild discords and send it to a list of people.\n",
					width = "full",
					fontSize  = "medium",
					order = 9,
				},	
				descr11 = {
					type = "description",
					name =  "|cffFFB74D11Q. Who are you and where are you from?|r\n" ..
						"I am from Mars, dont tell the USA government.\n",
					width = "full",
					fontSize  = "medium",
					order = 10,
				},	
			},
		},	
		config = {
			type = "execute",
			name =  "Configure",
			desc =  "Open the configuration dialog",
			func = function() FatCooldowns:OpenConfigDialog() FatCooldowns:ScheduleTimer(function() FatCooldowns:OpenConfigDialog() end, 0.1) end,
			guiHidden = true
		}
	}
}


local AllClasses2 = {["DEATHKNIGHT"] = FatCooldowns.DeathknightSpells, ["DRUID"] = FatCooldowns.DruidSpells, ["HUNTER"] = FatCooldowns.HunterSpells, ["MAGE"] = FatCooldowns.MageSpells, ["PALADIN"] = FatCooldowns.PaladinSpells, ["PRIEST"] = FatCooldowns.PriestSpells, ["ROGUE"] = FatCooldowns.RogueSpells,
		["SHAMAN"] = FatCooldowns.ShamanSpells, ["WARLOCK"] = FatCooldowns.WarlockSpells, ["WARRIOR"] = FatCooldowns.WarriorSpells}

local SpellsLvlPrint = {}
for i = 1, 80 do
	options.args.SpellsLvl.args[tostring(i)] = {
		name = "Level: "..i,
		order = 10 + i,
		type = "group",
		inline = true,
		hidden = function() if next(SpellsLvlFill(i)) then return false else return true end end,
		args = {
			theList = {
				type = "select",
				dialogControl = "MSItemSelectListV3",
				name = "Anyname",
				desc = "#ItemTooltip#",
				width = "full",
				values = function() return SpellsLvlFill(i) end,
				get = function() return end,			
				set = function(info, key)
					local ItemChecker = SpellsLvlPrint[i] and SpellsLvlPrint[i][key]
					if ItemChecker then
						if ItemChecker:find("spell") then
							local RealID = select(3,strfind(ItemChecker, "spell:(%d+)"))
							local ItemLink = GetSpellLink(RealID)
							if ItemLink then 
								FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Spell: "..ItemLink)
							end
						else
							local RealID = select(3,strfind(ItemChecker, "item:(%d+)"))
							local ItemName, itemlink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(RealID)
							if ItemLink then 
								FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Spell: "..itemlink)
							end
						end
					end
 				end,		
			},
		 },
	 }
end

function FillMasterLooterList()
	if not next(Display.db.profile.MasterLootBlackList2) then
		MasterLooterList = {}
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return MasterLooterList
	end
	local SortList = {}
	local ItemIDCheck = nil
	table.wipe(MasterLooterList)

	local TempChecker = false

	for ItemName, ItemID in pairs(Display.db.profile.MasterLootBlackList2) do
		if ItemName:find("[a-z]") or ItemName:find("[A-Z]") then 
			local RLItemName, RLItemLink =  GetItemInfo(ItemName)
			if RLItemName ~= nil and RLItemLink ~= nil then
				local RLItemID = select(3,strfind(RLItemLink, "^item:(%d+)"))
				Display.db.profile.MasterLootBlackList2[RLItemID] = RLItemID
			end
			Display.db.profile.MasterLootBlackList2[ItemName] = nil
		end
	end

	for ItemName, ItemID in pairs(Display.db.profile.MasterLootBlackList2) do
		local TempName = GetItemInfo(ItemID)
		if TempName == nil then
			tooltip:ClearLines()
			tooltip:SetHyperlink("item:"..ItemID)
			TempChecker = true
		else
			local TempName = GetItemInfo(ItemID)
			if TempName == nil then 
				tooltip:ClearLines() 
				tooltip:SetHyperlink("item:"..ItemID) 
			end
			if type(ItemID) == "boolean" then Display.db.profile.MasterLootBlackList2[ItemName] = nil
			elseif ItemID:find("[%a]+") then Display.db.profile.MasterLootBlackList2[ItemName] = nil
			elseif type(ItemID) == "number" then Display.db.profile.MasterLootBlackList2[ItemName] = nil
			elseif type(ItemID) ~= "string" then Display.db.profile.MasterLootBlackList2[ItemName] = nil
			else
				table.insert(SortList, ItemName)
			end
		end
	end
	if TempChecker then
		local TempFailList = {}
		FailedToLoadItems = FailedToLoadItems + 1
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Failed to load items, refreshing the tab. Count: "..FailedToLoadItems)
		if FailedToLoadItems <= 9 then
			FatCooldowns:ScheduleTimer(function() Display:ShowConfig() end, 1)
		else
			FailedToLoadItems = 0
			FailedToLoadItemsReset[1] = FailedToLoadItemsReset[1] + 1
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Reseting Item List Count "..FailedToLoadItemsReset[1].." Warning Items/Settings Will Reset After 5")
			if FailedToLoadItemsReset[1] > 5 then table.wipe(Display.db.profile.MasterLootBlackList2) end
			Display:UpdateConfig("yes")
		end
		return TempFailList
	else
		SortList = FCDTableSort(SortList)
		for i, ItemName in pairs(SortList) do
			ItemIDCheck = "item:"..tostring(Display.db.profile.MasterLootBlackList2[ItemName])
			MasterLooterList[i] = ItemIDCheck
		end
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return MasterLooterList
	end
end

function RemoveItemMasterLooterList(key) 
	local ItemChecker = MasterLooterList and MasterLooterList[key]
	if ItemChecker then 
		local ItemID = select(3,strfind(ItemChecker, "^item:(%d+)"))
		if ItemID and Display.db.profile.MasterLootBlackList2 and Display.db.profile.MasterLootBlackList2[ItemID] then 
			Display.db.profile.MasterLootBlackList2[ItemID] = nil
			FillMasterLooterList()
		end
	end
end

function QSortT(a,b) if a["quality"] == b["quality"] then return a["name"] < b["name"] else return a["quality"] > b["quality"] end end

function FCDTableSort(Table,SpellList,HasBoth)
	local SortedTable = {}
	local QualityTable = {}

	if HasBoth == true then
		for TableIndex, TableVar in pairs(Table) do
			if TableVar:find("item") then
				local ItemID = select(3,strfind(TableVar, "item:(%d+)"))
				local itemName, itemLink, itemRarity = GetItemInfo(ItemID)
				table.insert(QualityTable, {id = TableVar, name = itemName, quality = itemRarity, itemorspell = "item:"})
			else
				local ItemID = select(3,strfind(TableVar, "spell:(%d+)"))
				local itemName = GetSpellInfo(ItemID)
				table.insert(QualityTable, {id = TableVar, name = itemName, quality = 1, itemorspell = "spell:"})
			end
		end
	else
		for TableIndex, TableVar in pairs(Table) do
			if SpellList ~= nil then
	 			local itemName = GetSpellInfo(TableVar)
				table.insert(QualityTable, {id = TableVar, name = itemName, quality = 0})
			else
				local itemName, itemLink, itemRarity = GetItemInfo(TableVar)
				table.insert(QualityTable, {id = TableVar, name = itemName, quality = itemRarity})
			end
		end
	end

	table.sort(QualityTable, QSortT)

	if HasBoth then 
		for x,y in pairs(QualityTable) do
			table.insert(SortedTable, y.itemorspell..y.id)
		end
	else
		for x,y in pairs(QualityTable) do
			table.insert(SortedTable, y.id)
		end
	end

	return SortedTable
end

function MailerBags(player)
	local SortList = {}
	local ItemIDCheck = nil
	if type(CurrentMailBagList) ~= "table" then
		CurrentMailBagList = {}
	end
	if type(CurrentMailBagList[player]) ~= "table" then
		CurrentMailBagList[player] = {}
	end
	if next(CurrentMailBagList[player]) then
		table.wipe(CurrentMailBagList[player])
	end
	local TempChecker = false
	local TempIDTable = {}
	if type(TempIDTable[player]) ~= "table" then
		TempIDTable[player] = {}
	end

	for x = 0, 4 do 
		for y = 1, GetContainerNumSlots(x) do
			local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue = GetContainerItemInfo(x,y)
			if itemLink ~= nil then
				local ItemID = select(3,strfind(itemLink, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
				if itemLink ~= nil and ItemID ~= nil and (Display.db.profile.LootMailerList[player][ItemID] == nil or Display.db.profile.LootMailerList[player][ItemID] ~= ItemID) and not isSoulbound(x, y) then
					local AddItem = true
					for index, val in pairs(SortList) do
						if val == ItemID or index == ItemID then AddItem = false end
					end
					if AddItem then	table.insert(SortList, ItemID) end
					TempIDTable[player][ItemID] = ItemID
				end
			end
		end
	end
	SortList = FCDTableSort(SortList)
	for i, ItemID in pairs(SortList) do
		ItemIDCheck = "item:"..tostring(TempIDTable[player][ItemID])
		CurrentMailBagList[player][i] = ItemIDCheck
	end
	LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
	return CurrentMailBagList[player]
end

function RemoveItemMailBagList(player,key) 
	local ItemChecker = CurrentMailBagList[player] and CurrentMailBagList[player][key]
	if ItemChecker then 
		local ItemName, ItemLink = GetItemInfo(ItemChecker)
		local ItemID = select(3,strfind(ItemChecker, "item:(%d+)"))
		if ItemID then 
			Display.db.profile.LootMailerList[player][ItemID] = tostring(ItemID)
			if not Display.db.profile.SilentAdd and ItemLink ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Mailer: Added "..ItemLink) end
			MailerBags(player)
		end
	end
end

function FillMailList(player)
	if not next(Display.db.profile.LootMailerList[player]) then
		CurrentMailList[player] = {}
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return CurrentMailList[player] 
	end
	local SortList = {}
	local ItemIDCheck = nil
	if type(CurrentMailList) ~= "table" then
		CurrentMailList = {}
	end
	if type(CurrentMailList[player]) ~= "table" then
		CurrentMailList[player] = {}
	end
	if next(CurrentMailList[player]) then
		table.wipe(CurrentMailList[player])
	end
	local TempChecker = false

	for ItemName, ItemID in pairs(Display.db.profile.LootMailerList[player]) do
		if ItemName:find("[a-z]") or ItemName:find("[A-Z]") then 
			Display.db.profile.LootMailerList[player][ItemID] = ItemID
			Display.db.profile.LootMailerList[player][ItemName] = nil
		end
	end

	for ItemName, ItemID in pairs(Display.db.profile.LootMailerList[player]) do
		local TempName = GetItemInfo(ItemID)
		if TempName == nil then
			tooltip:ClearLines()
			tooltip:SetHyperlink("item:"..ItemID)
			TempChecker = true
		else
			if type(ItemID) == "boolean" then Display.db.profile.LootMailerList[player][ItemName] = nil
			elseif ItemID:find("[%a]+") then Display.db.profile.LootMailerList[player][ItemName] = nil
			elseif type(ItemID) == "number" then Display.db.profile.LootMailerList[player][ItemName] = nil
			elseif type(ItemID) ~= "string" then Display.db.profile.LootMailerList[player][ItemName] = nil
			else
				table.insert(SortList, ItemName)
			end
		end
	end
	if TempChecker then
		local TempFailList = {}
		FailedToLoadItems = FailedToLoadItems + 1
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Failed to load items, refreshing the tab. Count: "..FailedToLoadItems)
		if FailedToLoadItems <= 9 then
			FatCooldowns:ScheduleTimer(function() Display:ShowConfig() end, 1)
		else
			FailedToLoadItems = 0
			FailedToLoadItemsReset[2] = FailedToLoadItemsReset[2] + 1
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Reseting Item List Count "..FailedToLoadItemsReset[2].." Warning Items/Settings Will Reset After 5")
			if FailedToLoadItemsReset[2] > 5 then table.wipe(Display.db.profile.LootMailerList[player]) end
			Display:UpdateConfig("yes")
		end
		return TempFailList
	else
		SortList = FCDTableSort(SortList)
		for i, ItemName in pairs(SortList) do
			ItemIDCheck = "item:"..tostring(Display.db.profile.LootMailerList[player][ItemName])
			CurrentMailList[player][i] = ItemIDCheck
		end
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return CurrentMailList[player]
	end
end

function RemoveItemMailList(player,key) 
	local ItemChecker = CurrentMailList[player] and CurrentMailList[player][key]
	if ItemChecker then 
		local ItemName, ItemLink = GetItemInfo(ItemChecker)
		local ItemID = select(3,strfind(ItemChecker, "item:(%d+)"))
		if ItemID and Display.db.profile.LootMailerList[player] and Display.db.profile.LootMailerList[player][ItemID] then 
			if not Display.db.profile.SilentRemove and ItemLink ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Mailer: Removed "..ItemLink) end
			Display.db.profile.LootMailerList[player][ItemID] = nil
			FillMailList(player)
		end
	end
end


function FillDisenchantList()
	if not next(Display.db.profile.DisenchantBlackList) then
		DisenchantList = {}
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return DisenchantList
	end
	local SortList = {}
	local ItemIDCheck = nil
	table.wipe(DisenchantList)

	local TempChecker = false

	for ItemName, ItemID in pairs(Display.db.profile.DisenchantBlackList) do
		if ItemName:find("[a-z]") or ItemName:find("[A-Z]") then 
			local RLItemName, RLItemLink =  GetItemInfo(ItemName)
			if RLItemName ~= nil and RLItemLink ~= nil then
				local RLItemID = select(3,strfind(RLItemLink, "^item:(%d+)"))
				Display.db.profile.DisenchantBlackList[RLItemID] = RLItemID
			end
			Display.db.profile.DisenchantBlackList[ItemName] = nil
		end
	end

	for ItemName, ItemID in pairs(Display.db.profile.DisenchantBlackList) do
		local TempName = GetItemInfo(ItemID)
		if TempName == nil then
			tooltip:ClearLines()
			tooltip:SetHyperlink("item:"..ItemID)
			TempChecker = true
		else
			local TempName = GetItemInfo(ItemID)
			if TempName == nil then 
				tooltip:ClearLines() 
				tooltip:SetHyperlink("item:"..ItemID) 
			end
			if type(ItemID) == "boolean" then Display.db.profile.DisenchantBlackList[ItemName] = nil
			elseif ItemID:find("[%a]+") then Display.db.profile.DisenchantBlackList[ItemName] = nil
			elseif type(ItemID) == "number" then Display.db.profile.DisenchantBlackList[ItemName] = nil
			elseif type(ItemID) ~= "string" then Display.db.profile.DisenchantBlackList[ItemName] = nil
			else
				table.insert(SortList, ItemName)
			end
		end
	end
	if TempChecker then
		local TempFailList = {}
		FailedToLoadItems = FailedToLoadItems + 1
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Failed to load items, refreshing the tab. Count: "..FailedToLoadItems)
		if FailedToLoadItems <= 9 then
			FatCooldowns:ScheduleTimer(function() Display:ShowConfig() end, 1)
		else
			FailedToLoadItems = 0
			FailedToLoadItemsReset[3] = FailedToLoadItemsReset[3] + 1
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Reseting Item List Count "..FailedToLoadItemsReset[3].." Warning Items/Settings Will Reset After 5")
			if FailedToLoadItemsReset[3] > 5 then table.wipe(Display.db.profile.DisenchantBlackList) end
			Display:UpdateConfig("yes")
		end
		return TempFailList
	else
		SortList = FCDTableSort(SortList)
		for i, ItemName in pairs(SortList) do
			ItemIDCheck = "item:"..tostring(Display.db.profile.DisenchantBlackList[ItemName])
			DisenchantList[i] = ItemIDCheck
		end
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return DisenchantList
	end
end

function RemoveItemDisenchantList(key) 
	local ItemChecker = DisenchantList and DisenchantList[key]
	if ItemChecker then 
		local ItemID = select(3,strfind(ItemChecker, "^item:(%d+)"))
		if ItemID and Display.db.profile.DisenchantBlackList and Display.db.profile.DisenchantBlackList[ItemID] then 
			Display.db.profile.DisenchantBlackList[ItemID] = nil
			FillDisenchantList()
		end
	end
end

local AlertFrame = CreateFrame("FRAME", UIParent)
AlertFrame:SetFrameStrata("TOOLTIP")
AlertFrame:SetAllPoints(UIParent)
AlertFrame.texture = UIParent:CreateTexture()
AlertFrame.texture:SetAllPoints(AlertFrame)
AlertFrame.elapsed = 0
AlertFrame:SetScript("OnUpdate", function(self, elaps)
	self.elapsed = self.elapsed + elaps
	if(self.elapsed > 0.5) then
		self.texture:SetAlpha(2 - (2 * self.elapsed))
	end
	if(self.elapsed > 1) then
		self.elapsed = 0
		self:Hide()
	end
end)

function AlertFrameFlashScreen(r, g, b, a)
	AlertFrame.texture:SetAlpha(1)
	AlertFrame.texture:SetTexture(r, g, b, a)
	AlertFrame.texture:Show()
	AlertFrame:Show()
end



local WhisperTimer = nil
function WhisperMessageDo()
	if Display.db.profile.WhisperMessage == nil then return end
	if WhisperTimer ~= nil and GetTime() - WhisperTimer < 30 then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Messanger: Can only send whispers every 30+ seconds.") return end
	WhisperTimer = GetTime()
	local SearchTerm = nil
	local ClassCount = 0
	for x,u in pairs(Display.db.profile.WhisperMessageClasses) do
		if u == true then
			ClassCount = ClassCount + 1
			if SearchTerm == nil then
				SearchTerm = ' c-"'..x..'"'
			else
				SearchTerm = SearchTerm..' c-"'..x..'"'
			end
		end
	end
	if ClassCount == 10 then SearchTerm = nil ClassCount = 0 end
	if Display.db.profile.MMinLvl ~= 0 then
		if SearchTerm == nil then SearchTerm = "" end
		if Display.db.profile.MMaxLvl ~= 0 then
			SearchTerm = SearchTerm.." "..Display.db.profile.MMinLvl..'-'..Display.db.profile.MMaxLvl
		else
			SearchTerm = SearchTerm.." "..Display.db.profile.MMinLvl
		end
	end
	if SearchTerm then
		SetWhoToUI(1)
		HideUIPanel(FriendsFrame)
		SendWho(SearchTerm)
		FatCooldowns:ScheduleTimer(function() WhisperMessageDo2() end, 0.3)
	end
end

local WhisperPeople = {}
function WhisperMessageDo2(try)
	local MaxWhisper = 0
	if try == true then return end
	local Timer = 0
	if GetNumWhoResults() == nil or GetNumWhoResults() == 0 then FatCooldowns:ScheduleTimer(function() WhisperMessageDo2(true) end, 0.4) end
	local IgnoreTable = {}
	for i=1, GetNumIgnores() do
		if i > 0 then
			local IgnoreName = GetIgnoreName(i)
			IgnoreTable[IgnoreName] = IgnoreName
		end
	end
	for i = 1, GetNumWhoResults() do
		local WhoName, WhoGuildName, WhoLevel, WhoRace, WhoClass, WhoArea = GetWhoInfo(i)
		local HealerClass = {["Druid"] = true, ["Paladin"] = true, ["Shaman"] = true, ["Priest"] = true, }
		local TankClass = {["Druid"] = true, ["Paladin"] = true, ["Warrior"] = true, ["Death Knight"] = true, }
		if UnitName("player") ~= WhoName then
			if FatCooldowns.PlayersRole[WhoName] == nil then
				if WhoClass == L["Mage"] or WhoClass == L["Rogue"] or WhoClass == L["Warlock"] or WhoClass == L["Hunter"] then
					FatCooldowns.PlayersRole[WhoName] = {Level = WhoLevel, Class = WhoClass, Role = 4}
				else
					FatCooldowns.PlayersRole[WhoName] = {Level = WhoLevel, Class = WhoClass, Role = 1}
				end
			elseif FatCooldowns.PlayersRole[WhoName] ~= nil then
				FatCooldowns.PlayersRole[WhoName].Level = Level 
			end
		end
		if WhoName ~= nil and WhoArea ~= nil and WhoName ~= UnitName("player") and IgnoreTable[WhoName] == nil and not UnitInParty(WhoName) and MaxWhisper < 25 and (WhisperPeople[WhoName] == nil or GetTime() - WhisperPeople[WhoName] >= (Display.db.profile.WhisperPeopleTimer * 60)) then
					if Display.db.profile.InDungeon and FatCooldowns.Classic[WhoArea] == nil and FatCooldowns.TBC[WhoArea] == nil and FatCooldowns.Wotlk[WhoArea] == nil and Display.db.profile.WhisperMessage ~= nil and WhoArea ~= "Plaguelands: The Scarlet Enclave" then
						if Display.db.profile.InBG and FatCooldowns.BGZoneData[WhoArea] == nil then
							if Display.db.profile.PlayerRole then
								local SendMessage = false
								if Display.db.profile.PlayerRoleTank and TankClass[FatCooldowns.PlayersRole[WhoName].Class] and (FatCooldowns.PlayersRole[WhoName].Role == 1 or FatCooldowns.PlayersRole[WhoName].Role == 2 or FatCooldowns.PlayersRole[WhoName].Role == 5 or FatCooldowns.PlayersRole[WhoName].Role == 6) then SendMessage = true end
								if Display.db.profile.PlayerRoleHealer and HealerClass[FatCooldowns.PlayersRole[WhoName].Class] and (FatCooldowns.PlayersRole[WhoName].Role == 1 or FatCooldowns.PlayersRole[WhoName].Role == 3 or FatCooldowns.PlayersRole[WhoName].Role == 5 or FatCooldowns.PlayersRole[WhoName].Role == 7) then SendMessage = true end
								if Display.db.profile.PlayerRoleDPS and (FatCooldowns.PlayersRole[WhoName].Role == 1 or FatCooldowns.PlayersRole[WhoName].Role == 4 or FatCooldowns.PlayersRole[WhoName].Role == 6 or FatCooldowns.PlayersRole[WhoName].Role == 7) then SendMessage = true end
								if SendMessage then 
									FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Display.db.profile.WhisperMessage, "WHISPER", nil, WhoName) end, Timer)
									Timer = Timer + 1
									MaxWhisper = MaxWhisper + 1
								end
							else
								FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Display.db.profile.WhisperMessage, "WHISPER", nil, WhoName) end, Timer)
								Timer = Timer + 1
								MaxWhisper = MaxWhisper + 1
							end
						elseif not Display.db.profile.InBG then
							if Display.db.profile.PlayerRole then
								local SendMessage = false
								if Display.db.profile.PlayerRoleTank and (FatCooldowns.PlayersRole[WhoName].Role == 1 or FatCooldowns.PlayersRole[WhoName].Role == 2 or FatCooldowns.PlayersRole[WhoName].Role == 5 or FatCooldowns.PlayersRole[WhoName].Role == 6) then SendMessage = true end
								if Display.db.profile.PlayerRoleHealer and (FatCooldowns.PlayersRole[WhoName].Role == 1 or FatCooldowns.PlayersRole[WhoName].Role == 3 or FatCooldowns.PlayersRole[WhoName].Role == 5 or FatCooldowns.PlayersRole[WhoName].Role == 7) then SendMessage = true end
								if Display.db.profile.PlayerRoleDPS and (FatCooldowns.PlayersRole[WhoName].Role == 1 or FatCooldowns.PlayersRole[WhoName].Role == 4 or FatCooldowns.PlayersRole[WhoName].Role == 6 or FatCooldowns.PlayersRole[WhoName].Role == 7) then SendMessage = true end
								if SendMessage then 
									FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Display.db.profile.WhisperMessage, "WHISPER", nil, WhoName) end, Timer)
									Timer = Timer + 1
									MaxWhisper = MaxWhisper + 1
								end
							else
								FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Display.db.profile.WhisperMessage, "WHISPER", nil, WhoName) end, Timer)
								Timer = Timer + 1
								MaxWhisper = MaxWhisper + 1
							end
						end
					elseif not Display.db.profile.InDungeon and Display.db.profile.WhisperMessage ~= nil then
						if Display.db.profile.InBG and FatCooldowns.BGZoneData[WhoArea] == nil then
							if Display.db.profile.PlayerRole then
								local SendMessage = false
								if Display.db.profile.PlayerRoleTank and (FatCooldowns.PlayersRole[WhoName].Role == 1 or FatCooldowns.PlayersRole[WhoName].Role == 2 or FatCooldowns.PlayersRole[WhoName].Role == 5 or FatCooldowns.PlayersRole[WhoName].Role == 6) then SendMessage = true end
								if Display.db.profile.PlayerRoleHealer and (FatCooldowns.PlayersRole[WhoName].Role == 1 or FatCooldowns.PlayersRole[WhoName].Role == 3 or FatCooldowns.PlayersRole[WhoName].Role == 5 or FatCooldowns.PlayersRole[WhoName].Role == 7) then SendMessage = true end
								if Display.db.profile.PlayerRoleDPS and (FatCooldowns.PlayersRole[WhoName].Role == 1 or FatCooldowns.PlayersRole[WhoName].Role == 4 or FatCooldowns.PlayersRole[WhoName].Role == 6 or FatCooldowns.PlayersRole[WhoName].Role == 7) then SendMessage = true end
								if SendMessage then 
									FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Display.db.profile.WhisperMessage, "WHISPER", nil, WhoName) end, Timer)
									Timer = Timer + 1
									MaxWhisper = MaxWhisper + 1
								end
							else					
								FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Display.db.profile.WhisperMessage, "WHISPER", nil, WhoName) end, Timer)
								Timer = Timer + 1
								MaxWhisper = MaxWhisper + 1
							end
						elseif not Display.db.profile.InBG then
							if Display.db.profile.PlayerRole then
								local SendMessage = false
								if Display.db.profile.PlayerRoleTank and (FatCooldowns.PlayersRole[WhoName].Role == 1 or FatCooldowns.PlayersRole[WhoName].Role == 2 or FatCooldowns.PlayersRole[WhoName].Role == 5 or FatCooldowns.PlayersRole[WhoName].Role == 6) then SendMessage = true end
								if Display.db.profile.PlayerRoleHealer and (FatCooldowns.PlayersRole[WhoName].Role == 1 or FatCooldowns.PlayersRole[WhoName].Role == 3 or FatCooldowns.PlayersRole[WhoName].Role == 5 or FatCooldowns.PlayersRole[WhoName].Role == 7) then SendMessage = true end
								if Display.db.profile.PlayerRoleDPS and (FatCooldowns.PlayersRole[WhoName].Role == 1 or FatCooldowns.PlayersRole[WhoName].Role == 4 or FatCooldowns.PlayersRole[WhoName].Role == 6 or FatCooldowns.PlayersRole[WhoName].Role == 7) then SendMessage = true end
								if SendMessage then 
									FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Display.db.profile.WhisperMessage, "WHISPER", nil, WhoName) end, Timer)
									Timer = Timer + 1
									MaxWhisper = MaxWhisper + 1
								end
							else
								FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Display.db.profile.WhisperMessage, "WHISPER", nil, WhoName) end, Timer)
								Timer = Timer + 1
								MaxWhisper = MaxWhisper + 1
							end
						end
					end
					if MaxWhisper == 25 then
						FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Messanger: 25 Whispers Limit reached") end, Timer)
						WhisperPeople[WhoName] = GetTime()
						break
					end
					WhisperPeople[WhoName] = GetTime()
				end
		HideUIPanel(FriendsFrame)
	end
	MaxWhisper = 0
	RefreshFrameListOptionsAndVariables()
	LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
end

function FillSearchList()
	if (TempSearch == "" or TempSearch == nil or type(TempSearch) ~= "string") and not ForceSearch then
		CurrentSearchList = {}
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return CurrentSearchList
	end
	local SortList = {}
	local ItemIDCheck = nil
	if type(CurrentSearchList) ~= "table" then CurrentSearchList = {} end
	if next(CurrentSearchList) then
		table.wipe(CurrentSearchList)
	end
	local SpellOrItem = "item:"
	if Display.db.profile.ItemSearchToggle then SpellOrItem = "item:" else SpellOrItem = "spell:" end

	if not next(TempSearchList) then
		table.wipe(TempSearchList)
		if Display.db.profile.ItemSearchToggle then 
			for i = 1, 60000, 1 do
	 			local ItemName = GetItemInfo("item:"..i)
	 			if ItemName ~= nil then
					if TempSearchList[ItemName] == nil then
						TempSearchList[ItemName] =  i
					elseif type(TempSearchList[ItemName]) == "table" then
						table.insert(TempSearchList[ItemName], i)
					else
						local TempID = TempSearchList[ItemName]
						TempSearchList[ItemName] = {}
						table.insert(TempSearchList[ItemName], TempID)
						table.insert(TempSearchList[ItemName], i)
					end
				end
			end
		else
			for i = 1, 90000, 1 do
	 			local ItemName = GetSpellInfo(i)
	 			if ItemName ~= nil then
					if TempSearchList[ItemName] == nil then
						TempSearchList[ItemName] =  i
					elseif type(TempSearchList[ItemName]) == "table" then
						table.insert(TempSearchList[ItemName], i)
					else
						local TempID = TempSearchList[ItemName]
						TempSearchList[ItemName] = {}
						table.insert(TempSearchList[ItemName], TempID)
						table.insert(TempSearchList[ItemName], i)
					end
				end
			end
		end
	end
	for ItemName, ItemID in pairs(TempSearchList) do
		if ItemName:lower():find(TempSearch) then
			if type(ItemID) == "table" then
				for id1, id2 in pairs(ItemID) do
					table.insert(SortList, id2)
				end
			else
				table.insert(SortList, ItemID)
			end
		end
	end
	local SreachType = nil
	if not Display.db.profile.ItemSearchToggle then SreachType = 1 end
	SortList = FCDTableSort(SortList, SreachType)
	for i, ItemName in pairs(SortList) do
		CurrentSearchList[i] = SpellOrItem..tostring(ItemName)
	end
	LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
	return CurrentSearchList
end

function PrintItemFromSearchList(key) 
	local ItemChecker = CurrentSearchList and CurrentSearchList[key]
	if ItemChecker and Display.db.profile.ItemSearchToggle then 
		local ItemName, ItemLink = GetItemInfo(ItemChecker)
		if ItemName then 
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..ItemLink)
		end
	elseif ItemChecker and not Display.db.profile.ItemSearchToggle then
		local _, _, type, id = string.find(ItemChecker, "(%a+):(%-?%d+)")  
		local SpellName = GetSpellLink(id)
		if SpellName then 
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..SpellName)
		end
	end
end

function FillBlackList()
	if not next(Display.db.profile.LootBlackList2) then
		BlackList = {}
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return BlackList
	end
	local SortList = {}
	local ItemIDCheck = nil
	table.wipe(BlackList)

	local TempChecker = false

	for ItemName, ItemID in pairs(Display.db.profile.LootBlackList2) do
		if ItemName:find("[a-z]") or ItemName:find("[A-Z]") then 
			Display.db.profile.LootBlackList2[ItemID] = ItemID
			Display.db.profile.LootBlackList2[ItemName] = nil
		end
	end

	for ItemName, ItemID in pairs(Display.db.profile.LootBlackList2) do
		local TempName = GetItemInfo(ItemID)
		if TempName == nil then
			tooltip:ClearLines()
			tooltip:SetHyperlink("item:"..ItemID)
			TempChecker = true
		else
			if type(ItemID) == "boolean" then Display.db.profile.LootBlackList2[ItemName] = nil
			elseif ItemID:find("[%a]+") then Display.db.profile.LootBlackList2[ItemName] = nil
			elseif type(ItemID) == "number" then Display.db.profile.LootBlackList2[ItemName] = nil
			elseif type(ItemID) ~= "string" then Display.db.profile.LootBlackList2[ItemName] = nil
			else
				table.insert(SortList, ItemName)
			end
		end
	end
	if TempChecker then
		local TempFailList = {}
		FailedToLoadItems = FailedToLoadItems + 1
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Failed to load items, refreshing the tab. Count: "..FailedToLoadItems)
		if FailedToLoadItems <= 9 then
			FatCooldowns:ScheduleTimer(function() Display:ShowConfig() end, 1)
		else
			FailedToLoadItems = 0
			FailedToLoadItemsReset[4] = FailedToLoadItemsReset[4] + 1
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Reseting Item List Count "..FailedToLoadItemsReset[4].." Warning Items/Settings Will Reset After 5")
			if FailedToLoadItemsReset[4] > 5 then table.wipe(Display.db.profile.LootBlackList2) end
			Display:UpdateConfig("yes")
		end
		return TempFailList
	else
		SortList = FCDTableSort(SortList)
		for i, ItemName in pairs(SortList) do
			ItemIDCheck = "item:"..tostring(Display.db.profile.LootBlackList2[ItemName])
			BlackList[i] = ItemIDCheck
		end
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return BlackList
	end
end

function RemoveItemBlackList(key) 
	local ItemChecker = BlackList and BlackList[key]
	if ItemChecker then 
		local ItemID = select(3,strfind(ItemChecker, "^item:(%d+)"))
		if ItemID and Display.db.profile.LootBlackList2 and Display.db.profile.LootBlackList2[ItemID] then 
			Display.db.profile.LootBlackList2[ItemID] = nil
			FillBlackList()
		end
	end
end

function FillTrashList()
	if not next(Display.db.profile.SellList2) then
		TrashList = {}
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return TrashList
	end
	local SortList = {}
	local ItemIDCheck = nil
	table.wipe(TrashList)

	local TempChecker = false

	for ItemName, ItemID in pairs(Display.db.profile.SellList2) do
		if type(ItemName) ~= "string" then 
			Display.db.profile.SellList2[ItemID] = ItemID
			Display.db.profile.SellList2[ItemName] = nil
		end
	end

	for ItemName, ItemID in pairs(Display.db.profile.SellList2) do
		local TempName = GetItemInfo(ItemID)
		if TempName == nil then
			tooltip:ClearLines()
			tooltip:SetHyperlink(ItemName)
			TempChecker = true
		else
			local TempName = GetItemInfo(ItemID)
			if TempName == nil then 
				tooltip:ClearLines() 
				tooltip:SetHyperlink(ItemName) 
			end
			if type(ItemID) == "boolean" then Display.db.profile.SellList2[ItemName] = nil
			elseif type(ItemID) == "number" then Display.db.profile.SellList2[ItemName] = nil
			elseif type(ItemID) ~= "string" then Display.db.profile.SellList2[ItemName] = nil
			else
				table.insert(SortList, ItemName)
			end
		end
	end
	if TempChecker then
		local TempFailList = {}
		FailedToLoadItems = FailedToLoadItems + 1
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Failed to load items, refreshing the tab. Count: "..FailedToLoadItems)
		if FailedToLoadItems <= 9 then
			FatCooldowns:ScheduleTimer(function() Display:ShowConfig() end, 1)
		else
			FailedToLoadItems = 0
			FailedToLoadItemsReset[5] = FailedToLoadItemsReset[5] + 1
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Reseting Item List Count "..FailedToLoadItemsReset[5].." Warning Items/Settings Will Reset After 5")
			if FailedToLoadItemsReset[5] > 5 then table.wipe(Display.db.profile.SellList2) end
			Display:UpdateConfig("yes")
		end
		return TempFailList
	else
		SortList = FCDTableSort(SortList)
		for i, ItemName in pairs(SortList) do
			ItemIDCheck = ItemName
			TrashList[i] = ItemIDCheck
		end
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return TrashList
	end
end

function RemoveItemTrashList(key) 
	local ItemChecker = TrashList and TrashList[key]
	if ItemChecker then
		if Display.db.profile.SellList2 and Display.db.profile.SellList2[ItemChecker] then 
			Display.db.profile.SellList2[ItemChecker] = nil
			FillTrashList()
		end
	end
end

function FillADList()
	if not next(Display.db.profile.ADList2) then
		ADList = {}
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return ADList
	end
	local SortList = {}
	local ItemIDCheck = nil
	table.wipe(ADList)
	local TempChecker = false
	for ItemName, ItemID in pairs(Display.db.profile.ADList2) do
		if type(ItemName) ~= "string" then 
			Display.db.profile.ADList2[ItemID] = ItemID
			Display.db.profile.ADList2[ItemName] = nil
		end
	end

	for ItemName, ItemID in pairs(Display.db.profile.ADList2) do
		local TempName = GetItemInfo(ItemID)
		if TempName == nil then
			tooltip:ClearLines()
			tooltip:SetHyperlink(ItemName)
			TempChecker = true
		else
			local TempName = GetItemInfo(ItemID)
			if TempName == nil then 
				tooltip:ClearLines() 
				tooltip:SetHyperlink(ItemName) 
			end
			if type(ItemID) == "boolean" then Display.db.profile.ADList2[ItemName] = nil
			elseif type(ItemID) == "number" then Display.db.profile.ADList2[ItemName] = nil
			elseif type(ItemID) ~= "string" then Display.db.profile.ADList2[ItemName] = nil
			else
				table.insert(SortList, ItemName)
			end
		end
	end
	if TempChecker then
		local TempFailList = {}
		FailedToLoadItems = FailedToLoadItems + 1
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Failed to load items, refreshing the tab. Count: "..FailedToLoadItems)
		if FailedToLoadItems <= 9 then
			FatCooldowns:ScheduleTimer(function() Display:ShowConfig() end, 1)
		else
			FailedToLoadItems = 0
			FailedToLoadItemsReset[6] = FailedToLoadItemsReset[6] + 1
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Reseting Item List Count "..FailedToLoadItemsReset[6].." Warning Items/Settings Will Reset After 5")
			if FailedToLoadItemsReset[6] > 5 then table.wipe(Display.db.profile.ADList2) end
			Display:UpdateConfig("yes")
		end
		return TempFailList
	else
		SortList = FCDTableSort(SortList)
		for i, ItemName in pairs(SortList) do
			ItemIDCheck = Display.db.profile.ADList2[ItemName]
			ADList[i] = ItemIDCheck
		end
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return ADList
	end
end

function RemoveItemTrashAD(key) 
	local ItemChecker = ADList and ADList[key]
	if ItemChecker then 
		if Display.db.profile.ADList2 and Display.db.profile.ADList2[ItemChecker] then 
			Display.db.profile.ADList2[ItemChecker] = nil
			FillADList()
		end
	end
end

local ARList = {}
local CurrrentSelectedARItem = nil
function FillARList(ARNum)
	if ARNum == nil then return end
	if not next(Display.db.profile.ARTable[tostring(ARNum)].ItemList) then
		ARList = {}
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return ARList
	end
	local SortList = {}
	local ItemIDCheck = nil
	table.wipe(ARList)

	local TempChecker = false

	for ItemName, ItemID in pairs(Display.db.profile.ARTable[tostring(ARNum)].ItemList) do
		if type(ItemName) ~= "string" or ItemName:find("[a-z]") or ItemName:find("[A-Z]") then 
			Display.db.profile.ARTable[tostring(ARNum)].ItemList[ItemID] = ItemID
			Display.db.profile.ARTable[tostring(ARNum)].ItemList[ItemName] = nil
		end
	end

	for ItemName, ItemID in pairs(Display.db.profile.ARTable[tostring(ARNum)].ItemList) do
		local TempName = GetItemInfo(ItemID)
		if TempName == nil then
			tooltip:ClearLines()
			tooltip:SetHyperlink("item:"..ItemID)
			TempChecker = true
		else
			local TempName = GetItemInfo(ItemID)
			if TempName == nil then 
				tooltip:ClearLines() 
				tooltip:SetHyperlink("item:"..ItemID) 
			end
			if type(ItemID) == "boolean" then Display.db.profile.ARTable[tostring(ARNum)].ItemList[ItemName] = nil
			elseif ItemID:find("[%a]+") then Display.db.profile.ARTable[tostring(ARNum)].ItemList[ItemName] = nil
			elseif type(ItemID) == "number" then Display.db.profile.ARTable[tostring(ARNum)].ItemList[ItemName] = nil
			elseif type(ItemID) ~= "string" then Display.db.profile.ARTable[tostring(ARNum)].ItemList[ItemName] = nil
			else
				table.insert(SortList, ItemName)
			end
		end
	end
	if TempChecker then
		local TempFailList = {}
		FailedToLoadItems = FailedToLoadItems + 1
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Failed to load items, refreshing the tab. Count: "..FailedToLoadItems)
		if FailedToLoadItems <= 9 then
			FatCooldowns:ScheduleTimer(function() Display:ShowConfig() end, 1)
		else
			FailedToLoadItems = 0
			FailedToLoadItemsReset[7] = FailedToLoadItemsReset[7] + 1
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Reseting Item List Count "..FailedToLoadItemsReset[7].." Warning Items/Settings Will Reset After 5")
			if FailedToLoadItemsReset[7] > 5 then table.wipe(Display.db.profile.ARTable[tostring(ARNum)].ItemList) end
			Display:UpdateConfig("yes")
		end
		return TempFailList
	else
		SortList = FCDTableSort(SortList)
		for i, ItemName in pairs(SortList) do
			ItemIDCheck = "item:"..tostring(Display.db.profile.ARTable[tostring(ARNum)].ItemList[ItemName])
			ARList[i] = ItemIDCheck
		end
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return ARList
	end
end

function RemoveItemARList(key,ARNum) 
	local ItemChecker = ARList and ARList[key]
	if ItemChecker then 
		local ItemID = select(3,strfind(ItemChecker, "^item:(%d+)"))
		if ItemID and Display.db.profile.ARTable[tostring(ARNum)].ItemList and Display.db.profile.ARTable[tostring(ARNum)].ItemList[ItemID] then 
			Display.db.profile.ARTable[tostring(ARNum)].ItemList[ItemID] = nil
			FillARList()
		end
	end
end

function FillAutoBuyList()
	if not next(Display.db.profile.ABList) then
		ABListFilled = {}
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return ABListFilled
	end
	local SortList = {}
	local ItemIDCheck = nil
	table.wipe(ABListFilled)

	local TempChecker = false

	for ItemID, IDTable in pairs(Display.db.profile.ABList) do
		local TempName = GetItemInfo(ItemID)
		if TempName == nil then
			tooltip:ClearLines()
			tooltip:SetHyperlink("item:"..ItemID)
			TempChecker = true
		else
			if TempName == nil then 
				tooltip:ClearLines() 
				tooltip:SetHyperlink("item:"..ItemID) 
			end
			table.insert(SortList, ItemID)
		end
	end
	if TempChecker then
		local TempFailList = {}
		FailedToLoadItems = FailedToLoadItems + 1
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Failed to load items, refreshing the tab. Count: "..FailedToLoadItems)
		if FailedToLoadItems <= 9 then
			FatCooldowns:ScheduleTimer(function() Display:ShowConfig() end, 1)
		else
			FailedToLoadItems = 0
			FailedToLoadItemsReset[8] = FailedToLoadItemsReset[8] + 1
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Reseting Item List Count "..FailedToLoadItemsReset[8].." Warning Items/Settings Will Reset After 5")
			if FailedToLoadItemsReset[8] > 5 then table.wipe(Display.db.profile.ABList) end
			Display:UpdateConfig("yes")
		end
		return TempFailList
	else
		SortList = FCDTableSort(SortList)
		for i, ItemName in pairs(SortList) do
			ItemIDCheck = "item:"..tostring(ItemName)
			ABListFilled[i] = ItemIDCheck
		end
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return ABListFilled
	end
end

function RemoveItemAutoBuyList(key) 
	local ItemChecker = ABListFilled and ABListFilled[key]
	if ItemChecker then 
		local ItemID = select(3,strfind(ItemChecker, "^item:(%d+)"))
		if ItemID and Display.db.profile.ABList and Display.db.profile.ABList[ItemID] then 
			Display.db.profile.ABList[ItemID] = nil
			FillAutoBuyList()
		end
	end
end

function FillBuffList()
	if not next(Display.db.profile.ABRemovalList) then
		BuffList = {}
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return BuffList
	end
	local SortList = {}
	local ItemIDCheck = nil
	table.wipe(BuffList)

	local TempChecker = false

	for ItemName, ItemID in pairs(Display.db.profile.ABRemovalList) do
		if type(ItemName) ~= "string" or ItemName:find("[a-z]") or ItemName:find("[A-Z]") then 
			Display.db.profile.ABRemovalList[ItemID] = ItemID
			Display.db.profile.ABRemovalList[ItemName] = nil
		end
	end

	for ItemName, ItemID in pairs(Display.db.profile.ABRemovalList) do
		local TempName = GetSpellInfo(ItemID)
		if TempName == nil then
			tooltip:ClearLines()
			tooltip:SetHyperlink("spell:"..ItemID)
			TempChecker = true
		else
			local TempName = GetSpellInfo(ItemID)
			if TempName == nil then 
				tooltip:ClearLines() 
				tooltip:SetHyperlink("spell:"..ItemID) 
			end
			if type(ItemID) == "boolean" then Display.db.profile.ABRemovalList[ItemName] = nil
			elseif ItemID:find("[%a]+") then Display.db.profile.ABRemovalList[ItemName] = nil
			elseif type(ItemID) == "number" then Display.db.profile.ABRemovalList[ItemName] = nil
			elseif type(ItemID) ~= "string" then Display.db.profile.ABRemovalList[ItemName] = nil
			else
				table.insert(SortList, ItemName)
			end
		end
	end
	if TempChecker then
		local TempFailList = {}
		FailedToLoadItems = FailedToLoadItems + 1
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Failed to load spells, refreshing the tab. Count: "..FailedToLoadItems)
		if FailedToLoadItems <= 9 then
			FatCooldowns:ScheduleTimer(function() Display:ShowConfig() end, 1)
		else
			FailedToLoadItems = 0
			FailedToLoadItemsReset[9] = FailedToLoadItemsReset[9] + 1
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Reseting Item List Count "..FailedToLoadItemsReset[9].." Warning Items/Settings Will Reset After 5")
			if FailedToLoadItemsReset[9] > 5 then table.wipe(Display.db.profile.ABRemovalList) end
			Display:UpdateConfig("yes")
		end
		return TempFailList
	else
		SortList = FCDTableSort(SortList, 1)
		for i, ItemName in pairs(SortList) do
			ItemIDCheck = "spell:"..tostring(Display.db.profile.ABRemovalList[ItemName])
			BuffList[i] = ItemIDCheck
		end
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		return BuffList
	end
end

function RemoveBuffList(key) 
	local ItemChecker = BuffList and BuffList[key]
	if ItemChecker then 
		local ItemID = select(3,strfind(ItemChecker, "^spell:(%d+)"))
		if ItemID and Display.db.profile.ABRemovalList and Display.db.profile.ABRemovalList[ItemID] then 
			Display.db.profile.ABRemovalList[ItemID] = nil
			FillBuffList()
		end
	end
end

local SpClass, SPCLASS = UnitClass("player")
function SpellsLvlFill(i,lvlspells) 
	local SpellsTables = {}
	local TempSpellsTables = {}
	local WarlockTempSpellsTables = {}
	local SortList = {}
	local TempChecker = false
	if lvlspells then FakeClass, TempClass = UnitClass("player") TempSpellSearch = nil end
	for Level, LevelTable in pairs(AllClasses2[TempClass]) do
		if i == Level then
			for index, indextable in pairs(LevelTable) do
				local TempName = GetSpellInfo(indextable.id)
				if TempName ~= nil then
					if TempClass ~= SPCLASS or (TempClass == SPCLASS and ((not isAbilityKnown(indextable.id) and not TempClassAll) or (TempClassAll and lvlspells == nil)) and
						((indextable.requiredTalentId == nil or indextable.requiredTalentId and isAbilityKnown(indextable.requiredTalentId)) or (indextable.requiredTalentId == nil or (indextable.requiredTalentId and Display.db.profile.UnlearntTalents == true)))) then
						
						if TempSpellsTables[TempName] == nil then
							TempSpellsTables[TempName] =  indextable.id
						elseif type(TempSpellsTables[TempName]) == "table" then
							table.insert(TempSpellsTables[TempName], indextable.id)
						else
							local TempID = TempSpellsTables[TempName]
							TempSpellsTables[TempName] = {}
							table.insert(TempSpellsTables[TempName], TempID)
							table.insert(TempSpellsTables[TempName], indextable.id)
						end
					end
				else
					if TempName == nil then FatCooldowns:GetModule("Display"):FCDPrefixPrint(indextable.id)
						tooltip:ClearLines()
						tooltip:SetHyperlink("spell:"..indextable.id)
						TempChecker = true
					end
				end
			end

			if i == 1 or i == 20 then
				for weaponname, weapontable in pairs(FatCooldowns.Weapons[TempClass]) do
					if (weaponname == "Polearms" and i == 20) or (weaponname ~= "Polearms" and i == 1) then
						local WeaponSkillKnoown = isWeaponKnown(TempClass, weaponname)
						if not WeaponSkillKnoown then
							local TempName = GetSpellInfo(weapontable.id)
							TempSpellsTables[TempName] =  weapontable.id
						end
					end
				end
			end

			for ItemName, ItemID in pairs(TempSpellsTables) do
				if TempSpellSearch == nil or TempSpellSearch == "" or lvlspells ~= nil then
					if type(ItemID) == "table" then
						for id1, id2 in pairs(ItemID) do
							table.insert(SortList, "spell:"..id2)
						end
					else
						table.insert(SortList, "spell:"..ItemID)
					end
				else
					if ItemName:lower():find(TempSpellSearch) then
						if type(ItemID) == "table" then
							for id1, id2 in pairs(ItemID) do
								table.insert(SortList, "spell:"..id2)
							end
						else
							table.insert(SortList, "spell:"..ItemID)
						end
					end
				end
			end

			if TempClass == L["WARLOCK"] then
				if FatCooldowns.TomesSpells[i] ~= nil and next(FatCooldowns.TomesSpells[i]) then
					for LevelIndex, TomeIDTable in pairs(FatCooldowns.TomesSpells[i]) do
						if TomeIDTable.id ~= nil then 
							tooltip:ClearLines()
							tooltip:SetHyperlink("item:"..TomeIDTable.id)
							local name, rank = GetItemSpell(TomeIDTable.id)
							if name ~= nil and rank ~= nil and not PetSpellBookCheck(name, rank) and (TomeIDTable.requiredTalentId == nil or TomeIDTable.requiredTalentId ~= nil and (isAbilityKnown(TomeIDTable.requiredTalentId or Display.db.profile.UnlearntTalents == true))) then
								if WarlockTempSpellsTables[name] == nil then
									WarlockTempSpellsTables[name] = TomeIDTable.id
								else
									local TempID = WarlockTempSpellsTables[TempName]
									table.insert(WarlockTempSpellsTables[TempName], TempID)
									table.insert(WarlockTempSpellsTables[TempName], TomeIDTable.id)
								end
							end
						end
					end
				end

				for ItemName, ItemID in pairs(WarlockTempSpellsTables) do
					if TempSpellSearch == nil or TempSpellSearch == "" then
						if type(ItemID) == "table" then
							for id1, id2 in pairs(ItemID) do
								table.insert(SortList, "item:"..id2)
							end
						else
							table.insert(SortList, "item:"..ItemID)
						end
					else
						if ItemName:lower():find(TempSpellSearch) then
							if type(ItemID) == "table" then
								for id1, id2 in pairs(ItemID) do
									table.insert(SortList, "item:"..id2)
								end
							else
								table.insert(SortList, "item:"..ItemID)
							end
						end
					end
				end
			end

			if TempChecker then
				local TempFailList = {}
				FailedToLoadItems = FailedToLoadItems + 1
				FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Failed to load items, refreshing the tab. Count: "..FailedToLoadItems)
				if FailedToLoadItems <= 9 then
					FatCooldowns:ScheduleTimer(function() Display:ShowConfig() end, 1)
				else
					FailedToLoadItems = 0
					Display:UpdateConfig("yes")
				end
				return TempFailList
			else
				SortList = FCDTableSort(SortList, 1, true)
				for x, ItemName in pairs(SortList) do
					if ItemName:find("spell") then
						local RealID = select(3,strfind(ItemName, "spell:(%d+)"))
						local TempName, rank = GetSpellInfo(RealID)
						if rank == nil or rank == "" or rank == " " or rank == "Rank 1" then rank = "" else rank = "("..rank..") " end
						SpellsLvlPrint[i] = SpellsLvlPrint[i] or {}
						SpellsLvlPrint[i][x] = "spell:"..tostring(RealID)

						if i == 1 or i == 20 then
							for weaponname, weapontable in pairs(FatCooldowns.Weapons[TempClass]) do
								if (weaponname == "Polearms" and i == 20) or (weaponname ~= "Polearms" and i == 1) then
									if tostring(weapontable.id) == RealID then rank = "("..weapontable.location..")" end
								end
							end
						end

						if TempClass == "ROGUE" then
							for Level, LevelTable in pairs(AllClasses2[TempClass]) do
								for index, indextable in pairs(LevelTable) do
									if tostring(indextable.id) == RealID then
										if indextable.skills and indextable.skills[1].level then rank = rank.."(Poisions Level: "..indextable.skills[1].level..") " end
									end
								end
							end
						end

						if Display.db.profile.SpellsLvlcost then
							for index, indextable in pairs(LevelTable) do
								if RealID == tostring(indextable.id) and indextable.cost ~= nil then rank = rank.."(Cost: "..GetCoinTextureString(indextable.cost)..")" end
							end
						end
						
						SpellsTables[x] = {"spell:"..tostring(RealID), " "..rank}
					else
						local RealID = select(3,strfind(ItemName, "item:(%d+)"))
						SpellsLvlPrint[i] = SpellsLvlPrint[i] or {}
						SpellsLvlPrint[i][x] = "item:"..tostring(RealID)
					
						local rank = ""
						if TempClass == "WARLOCK" then
							if Display.db.profile.SpellsLvlcost then
								for index, indextable in pairs(FatCooldowns.TomesSpells[i]) do
									if RealID == tostring(indextable.id) and indextable.cost ~= nil then rank = rank.."(Cost: "..GetCoinTextureString(indextable.cost)..")" end
								end
							end
						end

						SpellsTables[x] = {"item:"..tostring(RealID), " "..rank}
					end
				end
				LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
				return SpellsTables
			end
		end
	end
	return {}
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FatCooldowns.RefreshFrameListOptionsAndVariables = RefreshFrameListOptionsAndVariables

function RaidPlayersNames(TargetInc)
	local playernametable = {}
	if UnitInRaid("player") then
		for x = 1, GetNumRaidMembers() do
			playernametable[UnitName("raid"..x)] = FCDColorName(UnitName("raid"..x))
		end
	elseif GetNumPartyMembers() >= 1 then
		for x = 1, GetNumPartyMembers() do
			playernametable[UnitName("party"..x)] = FCDColorName(UnitName("party"..x))
		end
		playernametable[UnitName("player")] = FCDColorName(UnitName("player"))
	else
		playernametable[UnitName("player")] = FCDColorName(UnitName("player"))
	end
	playernametable["Player"] = "|cFF9d9d9dPlayer - |r"..FCDColorName(UnitName("player"))
	if TargetInc then playernametable["Target"] = "|cFF9d9d9dPlayer's Target|r" end
	return playernametable
end

function FCDDEMacro(DEItemName, itemLink, Force)
	if DEItemName == nil then return end
	local NumGlobal = GetNumMacros()
	for i = 1, NumGlobal, 1 do
		local MacroName, MacroIcon, MacroBody  = GetMacroInfo(i)
		if string.find(string.lower(MacroBody), string.lower("/fcd de")) then
			EditMacro(i, nil, nil, "#showtooltip Disenchant\n/fcd de\n/cast Disenchant\n/use item:"..DEItemName)
			if Display.db.profile.DisenchantPrint and not Force then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Disenchanting "..itemLink) end
		end
	end
end

function FCDAuctionPriceMarket(link)
	if not link then return nil end
	local sellPrice, numSeen = AucAdvanced.API.GetMarketValue(link)
	if numSeen == nil then return 0, 0 end
	return sellPrice, numSeen
end

function FCDAuctionPriceMinBuyout(link)
	if not link then return nil end
	local imgSeen, image, matchBid, matchBuy, lowBid, lowBuy, aveBuy, aSeen = AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems(link)
	local sellPrice, numSeen = AucAdvanced.API.GetMarketValue(link)
	if imgSeen <= 0 then return FCDAuctionPriceMarket(link) end
	return lowBuy, numSeen
end

function FCDDisenchantValue(link, itemType, itemRarity, itemLevel)
	local itemID = select(3,strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
	local hsp, med, mkt, five = Enchantrix.Storage.GetItemDisenchantTotals(itemID)
	return mkt or -1
end
function FCDDisenchantValue2(itemType, itemRarity, itemLevel)
	local auctoarde = Atr_CalcDisenchantPrice(itemType, itemRarity, itemLevel)
	return auctoarde or -1
end

function FCDItemInEquipmentSet(ItemLink)
	local equipsets = GetNumEquipmentSets()
	if equipsets == 0 then return false end
	local Outfits = {}
	for setnum = 1, equipsets do 
		local setname = GetEquipmentSetInfo(setnum)
		local set = GetEquipmentSetLocations(setname)
		for k, location in pairs(set) do
			local wearing, bank, bags, slot, bag = EquipmentManager_UnpackLocation(location)
			if wearing or bank or bags then
				local h
				if not bags then h = GetInventoryItemLink("player", slot)
				else h = GetContainerItemLink(bag, slot) end
				if h == ItemLink then return true end
			end
		end
	end
end

function FCDItemrack(ItemLink, ItemID)
	if not IsAddOnLoaded("ItemRack") then return false end
	local Outfits = {}
	for setname, set in pairs(ItemRackUser.Sets) do
		for k, setitem in pairs(set.equip) do
			if not (setitem == 0 or setitem == nil) then
				if ItemID == setitem then return true end
			end
		end
	end
	return false
end

function FCDOutfitter(ItemLink)
	if not IsAddOnLoaded("Outfitter") or not Outfitter_IsInitialized() then return false end
	local ItemInfo = Outfitter_GetItemInfoFromLink(ItemLink)
	if not ItemInfo then return false end	
	local Outfits = Outfitter_GetOutfitsUsingItem(ItemInfo)
	if not Outfits or next(Outfits) == nil then return false end
	for _, o in pairs( Outfits ) do
		if o and o.Name then return true end
	end 
	return false
end

function FCDDE(Force)
	local DESkill = 0
	for skillIndex = 1, GetNumSkillLines() do
		local skillName1, isHeader1, _, skillRank1 = GetSkillLineInfo(skillIndex)
		if isHeader1 == nil then
			if skillName1 == "Enchanting" then DESkill = skillRank1 end
		end
	end
	if DESkill == 0 then return end
	for x = 0, 4 do 
		for y = 1, GetContainerNumSlots(x) do
   			local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue = GetContainerItemInfo(x,y)
   			if itemLink ~= nil then
				local ItemName, _, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemLink)
				local WEAPON, ARMOR = GetAuctionItemClasses()
				if (itemType == ARMOR or itemType == WEAPON) and quality and itemLevel and itemLevel > Display.db.profile.MinIlvlRange and itemLevel < Display.db.profile.MaxIlvlRange then 
					if Display.db.profile.DEQuality[quality] ~= nil and Display.db.profile.DEQuality[quality] then
						if (Display.db.profile.DEItemTypeLimiter[1] == false and itemType == WEAPON) or (Display.db.profile.DEItemTypeLimiter[2] == false and itemType == ARMOR) then
						else
							local ItemID = select(3,strfind(itemLink, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
							if itemLevel and itemLevel > 0 and ItemID and not Display.db.profile.DisenchantBlackList[ItemID] then
								local RealItemLink = select(3,strfind(itemLink, ".*|Hitem:(.+)%[.+"))
								local NowDE = true
								local FCDnotDisenchantable = {
									["11290"] = true,
									["11289"] = true,
									["11288"] = true,
									["11287"] = true,
									["20406"] = true,
									["20407"] = true,
									["20408"] = true,
									["21766"] = true,
								}
								local IsBound = isSoulbound(x,y)
								if FCDnotDisenchantable[ItemID] then NowDE = false end

								if FCDOutfitter(itemLink) then NowDE = false end
								if FCDItemInEquipmentSet(itemLink) then NowDE = false end
								if FCDItemrack(itemLink, ItemID) then NowDE = false end
								local FCDDEVal, FCDDEVal2

								if select(4, GetAddOnInfo("Auctionator")) == 1 then
									FCDDEVal = FCDDisenchantValue2(itemType, itemRarity, itemLevel)
									if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then
									else
										if Display.db.profile.DisenchantVVendorPrice and FCDDEVal ~= 0 and itemSellPrice > FCDDEVal then NowDE = false end
									end
								end

								if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then
									local FCDAucMin, FCDAucMinSeen = FCDAuctionPriceMinBuyout(itemLink)
									local FCDAucMarket, FCDAucMarketSeen = FCDAuctionPriceMarket(itemLink)
									if not Enchantrix then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: Could not find addon Enchantrix") return end
									FCDDEVal2 = FCDDisenchantValue(itemLink)
									if FCDDEVal2 > FCDDEVal then FCDDEVal = FCDDEVal2 end

									if FCDAucMin == nil then FCDAucMin = 0 elseif FCDAucMin > 0 then FCDAucMin = (FCDAucMin * 0.95) - (itemSellPrice * 0.6) end
									if FCDAucMinSeen == nil then FCDAucMinSeen = 0 end
									if FCDAucMarket == nil then FCDAucMarket = 0 elseif FCDAucMarket > 0 then FCDAucMarket = (FCDAucMarket * 0.95) - (itemSellPrice * 0.6) end
									if FCDAucMarketSeen == nil then FCDAucMarketSeen = 0 end

									if Display.db.profile.DisenchantVVendorPrice and FCDDEVal ~= 0 and itemSellPrice > FCDDEVal then NowDE = false end

									if not IsBound and NowDE and Display.db.profile.FCDAucMinPrice < FCDAucMin then NowDE = false end
									if not IsBound and NowDE and Display.db.profile.FCDAucMarketPrice < FCDAucMarket then NowDE = false end
									if not IsBound and NowDE and Display.db.profile.DisenchantVMinPrice and FCDAucMin > FCDDEVal then 
										if FCDAucMinSeen < Display.db.profile.AucSeenCount then 
										else
											NowDE = false
										end
									end
									if not IsBound and NowDE and Display.db.profile.DisenchantVMarketPrice and FCDAucMarket > FCDDEVal then 
										if FCDAucMinSeen < Display.db.profile.AucSeenCount then 
										else 
											NowDE = false
										end
									end
								end
								
								if NowDE then
									if quality == 2 then
										if  (DESkill >= 1 and DESkill < 25 and itemLevel <= 20) or
											(DESkill >= 25 and DESkill < 50 and itemLevel <= 25) or
											(DESkill >= 50 and DESkill < 75 and itemLevel <= 30) or
											(DESkill >= 75 and DESkill < 100 and itemLevel <= 35) or
											(DESkill >= 100 and DESkill < 125 and itemLevel <= 40) or
											(DESkill >= 125 and DESkill < 150 and itemLevel <= 45) or
											(DESkill >= 150 and DESkill < 175 and itemLevel <= 50) or
											(DESkill >= 175 and DESkill < 200 and itemLevel <= 55) or
											(DESkill >= 200 and DESkill < 225 and itemLevel <= 60) or
											(DESkill >= 225 and DESkill < 275 and itemLevel <= 99) or
											(DESkill >= 275 and DESkill < 325 and itemLevel <= 120) or
											(DESkill >= 325 and DESkill < 350 and itemLevel <= 150) or
											(DESkill >= 350 and DESkill < 375 and itemLevel <= 182) or
											(DESkill >= 375 and itemLevel <= 333) 
												then 
													FCDDEMacro(RealItemLink, itemLink, Force)
													return
										end
									elseif quality == 3 then
										if  (DESkill >= 1 and DESkill < 25 and itemLevel <= 20) or
											(DESkill >= 25 and DESkill < 50 and itemLevel <= 25) or
											(DESkill >= 50 and DESkill < 75 and itemLevel <= 30) or
											(DESkill >= 75 and DESkill < 100 and itemLevel <= 35) or
											(DESkill >= 100 and DESkill < 125 and itemLevel <= 40) or
											(DESkill >= 125 and DESkill < 150 and itemLevel <= 45) or
											(DESkill >= 150 and DESkill < 175 and itemLevel <= 50) or
											(DESkill >= 175 and DESkill < 200 and itemLevel <= 55) or
											(DESkill >= 200 and DESkill < 225 and itemLevel <= 60) or
											(DESkill >= 225 and DESkill < 275 and itemLevel <= 99) or
											(DESkill >= 275 and DESkill < 325 and itemLevel <= 120) or
											(DESkill >= 325 and itemLevel <= 333) 
												then
													FCDDEMacro(RealItemLink, itemLink, Force)
													return
										end
									elseif quality == 4 then
										if  (DESkill >= 1 and DESkill < 25 and itemLevel <= 20) or
											(DESkill >= 25 and DESkill < 50 and itemLevel <= 25) or
											(DESkill >= 50 and DESkill < 75 and itemLevel <= 30) or
											(DESkill >= 75 and DESkill < 100 and itemLevel <= 35) or
											(DESkill >= 100 and DESkill < 125 and itemLevel <= 40) or
											(DESkill >= 125 and DESkill < 150 and itemLevel <= 45) or
											(DESkill >= 150 and DESkill < 175 and itemLevel <= 50) or
											(DESkill >= 175 and DESkill < 200 and itemLevel <= 55) or
											(DESkill >= 200 and DESkill < 225 and itemLevel <= 60) or
											(DESkill >= 225 and DESkill < 275 and itemLevel <= 99) or
											(DESkill >= 275 and DESkill < 300 and itemLevel <= 89) or
											(DESkill >= 300 and DESkill < 375 and itemLevel <= 151) or
											(DESkill >= 375 and DESkill < 475 and itemLevel <= 416)
												then
													FCDDEMacro(RealItemLink, itemLink, Force)
													return
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

local ZIndex = {"Howling Fjord", "Borean Tundra", "Dragonblight", "Grizzly Hills", "Zul'Drak", "Sholazar Basin", "The Storm Peaks", "Crystalsong Forest", "Icecrown", "Wintergrasp", "Coldarra", "The Frozen Sea"}
function CanFlyHere()
	if not IsFlyableArea() then return false end
	local ColdWeatherFlying = IsUsableSpell(tostring(GetSpellInfo(54197)))
	if GetRealZoneText() == L["Dalaran"] then 
		if ColdWeatherFlying then 
			local posX, posY = GetPlayerMapPosition("player")
			if GetMinimapZoneText() == L["Krasus' Landing"] then
				return true
			elseif GetMinimapZoneText() == L["The Underbelly"] then
				if posX <= 0.3 then return true end
			elseif GetMinimapZoneText() == L["The Violet Citadel"] then
				if (posX - 0.24) ^2 + (posY - 0.39) ^2 < 0.9 then return true end
			elseif (posX - 0.87) ^2 + (posY - 0.62) ^2 < 0.008 then return true
			elseif (posX - 0.47) ^2 + (posY - 0.42) ^2 < 0.002 then return true
			elseif (posX - 0.47) ^2 + (posY - 0.38) ^2 < 0.002 then return true			
			end
		end
		return false
	end
	local WintergraspWaitTime = GetWintergraspWaitTime()
	if GetRealZoneText() == L["Wintergrasp"] and WintergraspWaitTime == nil then return false end

	local zoneText = GetRealZoneText()
	for i, zone in ipairs(ZIndex) do
		if zoneText == L[zone] then
			if ColdWeatherFlying then
				return true
			else
				return false
			end
		end
	end
	return true
end

local FlyingUseMount = {}
local GroundUseMount = {}

function FCDMountMacro(UseableMounts)
	if InCombatLockdown() then return end
	local instancename, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
	if instancename == L["The Oculus"] and Display.db.profile.OculusMounts and (GetItemCount(L["Amber Essence"]) == 1 or GetItemCount(L["Ruby Essence"]) == 1 or GetItemCount(L["Emerald Essence"]) == 1) then
		local NumGlobal = GetNumMacros()
		for i = 1, NumGlobal, 1 do
			local MacroName, MacroIcon, MacroBody  = GetMacroInfo(i)
			if string.find(string.lower(MacroBody), string.lower("/fcd fcdmount")) then
				if GetItemCount(L["Amber Essence"]) == 1 then
					EditMacro(i, nil, nil, "#showtooltip Amber Essence\n/fcd fcdmount\n/use item:37859")
				elseif GetItemCount(L["Ruby Essence"]) == 1 then
					EditMacro(i, nil, nil, "#showtooltip Ruby Essence\n/fcd fcdmount\n/use item:37860")
				elseif GetItemCount(L["Emerald Essence"]) == 1 then
					EditMacro(i, nil, nil, "#showtooltip Emerald Essence\n/fcd fcdmount\n/use item:37815")
				end
			end
		end
	elseif (UnitClass("player") ~= L["Druid"] and UnitClass("player") ~= L["Shaman"]) then
		if UseableMounts == nil then FCDMount(true) return end
		local creatureID, creatureName, _, icon = GetCompanionInfo("MOUNT", UseableMounts)
		local NumGlobal = GetNumMacros()
		for i = 1, NumGlobal, 1 do
			local MacroName, MacroIcon, MacroBody  = GetMacroInfo(i)
			if string.find(string.lower(MacroBody), string.lower("/fcd fcdmount")) then
				EditMacro(i, nil, nil, "#showtooltip "..creatureName.."\n/fcd fcdmount")
			end
		end
	else
		local NumGlobal = GetNumMacros()
		local RidingSkill = 0
		for skillIndex = 1, GetNumSkillLines() do
			local skillName2, isHeader2, _, skillRank2 = GetSkillLineInfo(skillIndex)
			if isHeader2 == nil then
				if skillName2 == L["Riding"] then RidingSkill = skillRank2 end
			end
		end

		for i = 1, NumGlobal, 1 do
			local DruidEditMacro = false
			local MacroName, MacroIcon, MacroBody  = GetMacroInfo(i)
			if string.find(string.lower(MacroBody), string.lower("/fcd fcdmount")) then
				DruidEditMacro = true
			end
			if DruidEditMacro then
				if IsSwimming() and UnitClass("player") == L["Druid"] then 
					local SeaTrutle = nil
					for i=1,GetNumCompanions("MOUNT"),1 do
						local _, _, creatureSpellID = GetCompanionInfo("MOUNT", i)
						if creatureSpellID == 64731 then SeaTrutle = i end
					end
					if SeaTrutle ~= nil then
						local _, creatureName, _, icon = GetCompanionInfo("MOUNT", SeaTrutle)
						EditMacro(i, nil, nil, "#showtooltip "..creatureName.."\n/cancelform\n/fcd fcdmount")
					elseif IsSpellKnown(1066) or IsUsableSpell(tostring(GetSpellInfo(1066))) then 
						EditMacro(i, nil, nil, "#showtooltip aquatic form\n/cancelform\n/fcd fcdmount\n/cast "..tostring(GetSpellInfo(1066)))
					end				
				elseif not Display.db.profile.UseDruidForm then
					if UseableMounts == nil then FCDMount(true) return end
					local creatureID, creatureName, _, icon = GetCompanionInfo("MOUNT", UseableMounts)
					EditMacro(i, nil, nil, "'showtooltip "..creatureName.."\n/cancelform\n/fcd fcdmount")
				elseif (IsSpellKnown(40120) or IsUsableSpell(tostring(GetSpellInfo(40120)))) and CanFlyHere() then
					if Display.db.profile.DruidFormOneClick then EditMacro(i, nil, nil, "#showtooltip swift flight form\n/cancelform\n/fcd fcdmount\n/cast "..tostring(GetSpellInfo(40120))) else EditMacro(i, nil, nil, "#showtooltip swift flight form\n/fcd fcdmount\n/cast "..tostring(GetSpellInfo(40120)))  end
				elseif (IsSpellKnown(33943) or IsUsableSpell(tostring(GetSpellInfo(33943)))) and CanFlyHere() then
					if Display.db.profile.DruidFormOneClick then EditMacro(i, nil, nil, "#showtooltip flight form\n/cancelform\n/fcd fcdmount\n/cast "..tostring(GetSpellInfo(33943))) else EditMacro(i, nil, nil, "#showtooltip flight form\n/fcd fcdmount\n/cast "..tostring(GetSpellInfo(33943))) end
				elseif (IsSpellKnown(783) or IsUsableSpell(tostring(GetSpellInfo(783)))) and ((not CanFlyHere() and not next(GroundUseMount)) or RidingSkill == 0 or (IsIndoors() and Display.db.profile.DruidFormOneClickInDoor)) then
					if Display.db.profile.DruidFormOneClick or IsIndoors() and Display.db.profile.DruidFormOneClickInDoor then EditMacro(i, nil, nil, "#showtooltip\n/cancelform\n/fcd fcdmount\n/cast "..tostring(GetSpellInfo(783))) else EditMacro(i, nil, nil, "#showtooltip\n/fcd fcdmount\n/cast "..tostring(GetSpellInfo(783))) end
				elseif (IsSpellKnown(2645) or IsUsableSpell(tostring(GetSpellInfo(2645)))) and ((not CanFlyHere() and not next(GroundUseMount)) or RidingSkill == 0 or (IsIndoors() and Display.db.profile.DruidFormOneClickInDoor)) then
					if Display.db.profile.DruidFormOneClick or IsIndoors() and Display.db.profile.DruidFormOneClickInDoor then EditMacro(i, nil, nil, "#showtooltip\n/cancelform\n/fcd fcdmount\n/cast "..tostring(GetSpellInfo(2645))) else EditMacro(i, nil, nil, "#showtooltip\n/fcd fcdmount\n/cast "..tostring(GetSpellInfo(2645))) end
				elseif next(GroundUseMount) ~= nil then
					if UseableMounts ~= nil then
						local creatureID, creatureName, _, icon = GetCompanionInfo("MOUNT", UseableMounts)
						EditMacro(i, nil, nil, "#showtooltip "..creatureName.."\n/cancelform\n/fcd fcdmount")
					end
				end
			end
		end
	end
end

function MountIDITable(UseableMounts, ID)
	if ID == nil then return end
	for TableIndex, TableValue in pairs(UseableMounts) do
		if TableValue == ID then return end
	end
	table.insert(UseableMounts, ID)
end

local MountTimer = nil
function FCDMount(DontMount, IsDruid)
	if not DontMount then
		if IsMounted() then
			if Display.db.profile.SafeDismount then
				if MountTimer ~= nil and GetTime() - MountTimer < 1 then
					Dismount()
				else
					MountTimer = GetTime()
				end
			else
				Dismount()
			end
			if not Display.db.profile.OneClickMount then return end
		end
		if UnitInVehicle(UnitName("player")) then
			VehicleExit()
			return
		end
		if InCombatLockdown() then return end
		if IsIndoors() then return end
		if Display.db.profile.DBWRemove then Display:RemoveDBWBuff() end
		if Zone == L["The Oculus"] and Display.db.profile.OculusMounts then return end
	end

	local RidingSkill = 100
	for skillIndex = 1, GetNumSkillLines() do
		local skillName3, isHeader3, _, skillRank3 = GetSkillLineInfo(skillIndex)
		if isHeader3 == nil then
			if skillName3 == L["Riding"] then RidingSkill = skillRank3 end
		end
	end

	local NumMounts = GetNumCompanions("MOUNT")
	local UseableMounts = {}
	local BackUpMounts = {}
	local FinalBackUpMounts = {}
	table.wipe(UseableMounts)
	table.wipe(BackUpMounts)
	table.wipe(FinalBackUpMounts)

	if CanFlyHere() and RidingSkill >= 225 then
		local SeaTrutle = nil
		for x = 1, NumMounts, 1 do
			local creatureID, creatureName, creatureSpellID, icon, issummoned, mountType = GetCompanionInfo("MOUNT", x)
			if creatureSpellID == 64731 then SeaTrutle = x end
			if FatCooldowns.EpicFlyingMountInfo[creatureSpellID] and (Display.db.profile.MountBlackList == nil or (Display.db.profile.MountBlackList ~= nil and Display.db.profile.MountBlackList[creatureName] == nil)) then UseableMounts[creatureSpellID] = x 
			elseif FatCooldowns.FastFlyingMountInfo[creatureSpellID] and (Display.db.profile.MountBlackList == nil or (Display.db.profile.MountBlackList ~= nil and Display.db.profile.MountBlackList[creatureName] == nil)) then BackUpMounts[creatureSpellID] = x 
			elseif FatCooldowns.FlyingMountInfo[creatureSpellID] and (Display.db.profile.MountBlackList == nil or (Display.db.profile.MountBlackList ~= nil and Display.db.profile.MountBlackList[creatureName] == nil)) then FinalBackUpMounts[creatureSpellID] = x 
			end
		end

		table.wipe(FlyingUseMount)
		if next(UseableMounts) ~= nil then 
			for y, u in pairs(UseableMounts) do 
			 	MountIDITable(FlyingUseMount, u) 
			end
			if Display.db.profile.IncludeFFMount then
				if next(BackUpMounts) ~= nil then 
					for y, u in pairs(BackUpMounts) do 
						MountIDITable(FlyingUseMount, u) 
					end
				end
			end
		elseif next(BackUpMounts) ~= nil then 
			for y, u in pairs(BackUpMounts) do 
				MountIDITable(FlyingUseMount, u) 
			end
		elseif next(FinalBackUpMounts) ~= nil then 
			for y, u in pairs(FinalBackUpMounts) do 
				MountIDITable(FlyingUseMount, u) 
			end
		else 
			if UnitClass("player") ~= L["Druid"] or (UnitClass("player") == L["Druid"] and not Display.db.profile.UseDruidForm) then
				return
			end 
		end
		
		if UnitClass("player") == L["Druid"] and Display.db.profile.UseDruidForm and IsDruid == nil then
			local NumGlobal = GetNumMacros()
			for i = 1, NumGlobal, 1 do
				local MacroName, MacroIcon, MacroBody  = GetMacroInfo(i)
				if string.find(string.lower(MacroBody), string.lower("/fcd fcdmount\n/cast "..tostring(GetSpellInfo(40120)))) or string.find(string.lower(MacroBody), string.lower("/fcd fcdmount\n/cast "..tostring(GetSpellInfo(33943)))) then DontMount = true end
			end
		end

		if next(FlyingUseMount) then
			local SummonMount = FlyingUseMount[random(#FlyingUseMount)]
			if IsSwimming() and SeaTrutle then SummonMount = SeaTrutle end
			if not DontMount and ((IsSwimming() and SeaTrutle) or not IsSwimming()) then CallCompanion("MOUNT", SummonMount) end
			if not InCombatLockdown() then FatCooldowns:ScheduleTimer(function() FCDMountMacro(SummonMount) end, 0.1) end
		else
			if not InCombatLockdown() then FatCooldowns:ScheduleTimer(function() FCDMountMacro() end, 0.1) end
		end
	else 
		local SeaTrutle = nil
		for x = 1, NumMounts, 1 do
			local creatureID, creatureName, creatureSpellID, icon, issummoned, mountType = GetCompanionInfo("MOUNT", x)
			if creatureSpellID == 64731 then SeaTrutle = x end
			if FatCooldowns.FastGroundMountInfo[creatureSpellID] and (Display.db.profile.MountBlackList == nil or (Display.db.profile.MountBlackList ~= nil and Display.db.profile.MountBlackList[creatureName] == nil)) then UseableMounts[creatureSpellID] = x
			elseif FatCooldowns.GroundMountInfo[creatureSpellID] and (Display.db.profile.MountBlackList == nil or (Display.db.profile.MountBlackList ~= nil and Display.db.profile.MountBlackList[creatureName] == nil)) then BackUpMounts[creatureSpellID] = x
			end
		end

		table.wipe(GroundUseMount)
		if next(UseableMounts) ~= nil then 
			for y, u in pairs(UseableMounts) do
				MountIDITable(GroundUseMount, u) 
			end
		elseif next(BackUpMounts) ~= nil then 
			for y, u in pairs(BackUpMounts) do
				MountIDITable(GroundUseMount, u) 
			end
		else
			if UnitClass("player") ~= L["Druid"] or (UnitClass("player") == L["Druid"] and not Display.db.profile.UseDruidForm) then
				return
			end  
		end

		if UnitClass("player") == L["Druid"] and Display.db.profile.UseDruidForm and IsDruid == nil then
			local NumGlobal = GetNumMacros()
			for i = 1, NumGlobal, 1 do
				local MacroName, MacroIcon, MacroBody  = GetMacroInfo(i)
				if string.find(string.lower(MacroBody), string.lower("/fcd fcdmount\n/cast "..tostring(GetSpellInfo(783)))) then DontMount = true end
			end
		end
		if UnitClass("player") == L["Shaman"] and Display.db.profile.UseDruidForm and IsDruid == nil then
			local NumGlobal = GetNumMacros()
			for i = 1, NumGlobal, 1 do
				local MacroName, MacroIcon, MacroBody  = GetMacroInfo(i)
				if string.find(string.lower(MacroBody), string.lower("/fcd fcdmount\n/cast "..tostring(GetSpellInfo(2645)))) then DontMount = true end
			end
		end

		local instancename, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
	 	if instancename == L["The Oculus"] and Display.db.profile.OculusMounts and (GetItemCount(L["Amber Essence"]) == 1 or GetItemCount(L["Ruby Essence"]) == 1 or GetItemCount(L["Emerald Essence"]) == 1) then DontMount = true end

		if next(GroundUseMount) then
			local SummonMount = GroundUseMount[random(#GroundUseMount)]
			if IsSwimming() and SeaTrutle then SummonMount = SeaTrutle end
			if not DontMount and ((IsSwimming() and SeaTrutle) or not IsSwimming()) then CallCompanion("MOUNT", SummonMount) end
			if not InCombatLockdown() then FatCooldowns:ScheduleTimer(function() FCDMountMacro(SummonMount) end, 0.1) end
		else
			if not InCombatLockdown() then FatCooldowns:ScheduleTimer(function() FCDMountMacro() end, 0.1) end
		end
	end
end

function FatCooldowns:ReMakeCurrentRaid2(PlayersTable)
	if not UnitInRaid("player") and GetNumPartyMembers() > 0 then ConvertToRaid() end
	InviteUnit(PlayersTable)
end

function FatCooldowns:ReMakeCurrentRaid(PlayersTable)
	local Timer = 1.5
	for PlayerNameIndex, PlayerName in pairs(PlayersTable) do
		FatCooldowns:ScheduleTimer(function() FatCooldowns:ReMakeCurrentRaid2(PlayerName) end, Timer)
		Timer = Timer + 1.5
	end
end

Display.configOptions = options
LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("FatCooldowns", options)

function FatCooldowns:OpenConfigDialog()
	Display:ToggleConfig()
end

function ToggleButton()
	TempSearch = nil 
	table.wipe(CurrentSearchList)
	table.wipe(TempSearchList)
	tinsert(UISpecialFrames, "MyGlobalFrameName")
	HideUIPanel(GameMenuFrame)
end

function FCDLIST(msg)
	local msg = msg:lower()
	if (not msg or msg == "") then
		FatCooldowns:OpenConfigDialog()
	elseif msg == "help" then
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD - will open config")
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD RESET - will reset a bars")
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD TEST - will test the bars")
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD DISABLE - will toggle HideAllFrames")
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD ENABLE - will toggle HideAllFrames")
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD UPDATE - will force bars to update")
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD RAIDUPDATE - will force a rescan of the raid to add permanent missing bars")
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD RESETSPELLS - will reset all the spells you have set the addon to track")
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD RemoveDBW - will remove all DBW Procs allowing you to mount")
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD DE - will disenchant items based on the settings in Disenchant tab")
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD FCDMount - will mount based on the settings in the FCDMount tab")
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD DOWNLOAD - will send a chat message with a discord link showing people were to download this addon")
	elseif msg == "reset" then
		Display:Reset()
	elseif msg == "close" then
		Display:CloseConfig()
	elseif msg == "test" then
		Display:Test()
	elseif msg == "resetspells" then
		Display:resetspells()
	elseif msg == "enable" or msg == "disable" then
		if Display.db.profile.HideAllFrames == false then Display.db.profile.HideAllFrames = true
		elseif Display.db.profile.HideAllFrames == true then Display.db.profile.HideAllFrames = false end
		Display:UpdateDisplay()
	elseif msg == "update" then
		Display:UpdateDisplay()
	elseif msg == "fcdmount" then
		FCDMount()
	elseif msg == "removedbw" then
		Display:RemoveDBWBuff()
	elseif msg == "raidupdate" then
		FatCooldowns:RaidScan("force")
	elseif msg == "config" then
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FatCooldowns: /FCD CONFIG - is no longer a command, you can use '/FCD HELP' for a list of current commands")
	elseif msg == "de" then
		FCDDE()
	elseif msg == "drinksandfood" then
		Display:DrinksAndFood()
	elseif msg == "ver" then
		SendAddonMessage("FCD","FCDVerSend", (select(2, IsInInstance()) == "pvp" and BATTLEGROUND) or (GetNumRaidMembers() > 0 and "RAID") or "PARTY")
	elseif msg == "download" then
		FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("You can download FCD Shekles Version addon here: https://discord.gg/deVHwh2Jny", (GetNumRaidMembers() > 0 and RAID) or PARTY)
	end
end

SLASH_FCD1 = '/fcd'
SLASH_FCD2 = '/fatcooldowns'
SlashCmdList["FCD"] = FCDLIST
