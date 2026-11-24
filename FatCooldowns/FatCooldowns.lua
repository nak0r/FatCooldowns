local MINOR_VERSION = tonumber(("$Revision: 3 $"):match("%d+"))

FatCooldowns = LibStub("AceAddon-3.0"):NewAddon("FatCooldowns", "AceConsole-3.0", "AceComm-3.0", "AceEvent-3.0", "AceTimer-3.0","AceSerializer-3.0")
local LGT = LibStub("LibGroupTalents-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("FatCooldowns")
local Media = LibStub("LibSharedMedia-3.0")
local TipHooker = LibStub("LibTipHooker-1.1")
local lootdata = LibStub("LibInstanceLootData-1.0")

FatCooldowns.MINOR_VERSION = MINOR_VERSION
local UnitName = _G.UnitName
FatCooldowns.raidRoster = nil

FatCooldowns.FCDVer = 51

local BacklashStacks,BacklashTime, FrostBeaconCheckerLimiter = {},{}, false
local Oozetimestamp = nil
local Valk25MaxHP = 2992000
local Valkyrs = {}
local healers, lastcheckedpickedup = {}, 1
local RemoteSpam = {}
local markid, DispelTime, marktimestamp, DispellerTime, DispellerSend, DispellerMDTable, DispellerMDRun = nil, nil, {}, {}, false, {}, true
local LastDispelled = nil
local RaptureTimeStamp = {}
local PenTimeStamp = {}
local GasName1, GasName2, GasName3, GasDelay = nil, nil, nil, nil
local warriorhowls, warriorhowlschecked = {}, nil
local vilegastargets = {}
local summonvalktimestamp = nil
local Sundercount, Sundercountchecked, sundercountplayers, warrtank = {}, 0, false, false
local combatstarttimestamp, combatfinished = nil, nil
local ppsummonooze, ppsummonooze2, doublesummonooze, oozedead = nil, nil, false, false
local TimeH2, TimeH = 1, 1
local HolyPriest = nil
local backuptargetid = {}
local backuptargetspellname = {}
FatCooldowns.specchangertimestamp = nil
local NecroticTimer, lasthitbyplague, Necroticfailinfo, NecroTime = nil, nil, nil, {}
local weaponname1 = nil
local StealingBiteSpam = {}
local TotemAntiSpamp = {}
local TotemAntiSpamp2 = {}
local HuntMD = {}
local ToTRemover = nil
local manacheckcd = nil
local ValkGrabbed, GrabbedIcon = {}, 2
local WarlockBoomkinFail = 0
local SealSpamTimer = {}
local vehiclechecked = nil
local vehiclechecked2 = nil
local EmpShockTargetsTanks, EmpShockTargetsHealers, EmpShockDone = {}, {}, nil
local specchecked = nil
local FMCheck = true
local ScanIcons = true
local TempDeleteItems = true
local battlegrountargets = {}
local IsCombat = false
local DefileTimer = 0
local SpiritTimer = 0
local ParryCounter, ParryCounterSetMembers, ParryCounterSetMembersSindra, ParryCounterH1, ParryCounterH2, ParryCounterH3, ParryCounterH4,ParryAntiSpam = {}, nil, nil, {}, {}, {}, {}, {}
local PlayingSound = false
local FCDBossName = nil
local TrashWorking = false
local DreamDebuffs, DreamwalkerTimer = {}, true
local EventsFilters = {["UNIT_DIED"] = true, ["SPELL_CAST_SUCCESS"] = true, ["SPELL_AURA_APPLIED"] = true, ["SPELL_AURA_APPLIED_DOSE"] = true, ["SPELL_DISPEL"] = true, ["SPELL_PERIODIC_DAMAGE"] = true, ["SPELL_AURA_REMOVED"] = true,
["SPELL_CAST_START"] = true, ["SPELL_HEAL"] = true, ["SPELL_ENERGIZE"] = true, ["SPELL_AURA_REFRESH"] = true, ["SPELL_RESURRECT"] = true, ["SPELL_SUMMON"] = true, ["PARTY_KILL"] = true, ["SWING_DAMAGE"] = true, ["SWING_MISSED"] = true,
["RANGE_DAMAGE"] = true, ["SPELL_DAMAGE"] = true, ["SPELL_CREATE"] = true,

["SPELL_PERIODIC_DRAIN"] = false, ["SPELL_LEECH"] = false,
["SPELL_MISSED"] = false, ["SPELL_CAST_FAILED"] = false, ["ENCHANT_APPLIED"] = false, ["SPELL_PERIODIC_HEAL"] = false, ["ENVIRONMENTAL_DAMAGE"] = false, ["SPELL_PERIODIC_ENERGIZE"] = false, ["SPELL_STOLEN"] = false,
["ENCHANT_REMOVED"] = false, ["SPELL_PERIODIC_MISSED"] = false, ["SPELL_INTERRUPT"] = false, ["DAMAGE_SHIELD_MISSED"] = false, ["DAMAGE_SHIELD"] = false, ["SPELL_DISPEL_FAILED"] = false, ["SPELL_BUILDING_DAMAGE"] = false,
["RANGE_MISSED"] = false, ["SPELL_DRAIN"] = false, ["SPELL_AURA_REMOVED_DOSE"] = false, ["SPELL_PERIODIC_LEECH"] = false, ["DAMAGE_SPLIT"] = false, ["SPELL_EXTRA_ATTACKS"] = false, ["SPELL_INSTAKILL"] = false,}

local printed = {}
local buffsandprocs, buffsandprocscheck = {59528,57335,871,20217,59529,59516,70335,59842,59530,59522,59523,59533,59531,59525,59521,59524,59526,59527,90355,59532,59534,19434,59626,20572,50060,33697,26297,2825,106951,198106,226991,104773,58983,10060,57934,21849,1126,976,27683,57838,51124,61336,65081,51750,82023,18562,48518,48519,5217,12536,13174,58501,58875,95637,52610,24907,17007,25048,24858,49016,29801,58507,58194,24606,11129,48108,30506,43039,12043,64382,11889,20154,31850,18119,14751,15258,13877,5171,16166,16880,53817,88330,28880,30706,44614,47845,81022,39171,28176,29001,83632,109773,18288,20661,27280}, nil

function FatCooldowns:RaidScan(force)
	local newRaidRoster = {}
	local members = nil
	if self.raidRoster and force == nil then
		local newPlayers = {}

		if UnitInRaid("player") then
			members = GetNumRaidMembers()
		else
			members = GetNumPartyMembers() + 1
		end

		if members == 1 then
			if not self:GetModule("Display").db then return end
			if not self:GetModule("Display").db.profile.KeepWhenSolo then
				self.raidRoster = nil
				self:GetModule("Display"):Reset()
			end
			return
		end	

		for i = 1,members,1 do
			local ScanName = nil
			if UnitInRaid("player") then 
				ScanName = UnitName("raid" .. i)
			elseif not UnitInRaid("player") and i <= GetNumPartyMembers() then
				ScanName = UnitName("party" .. i)
			else
				ScanName = UnitName("player")
			end
			if ScanName == "Unknown" or ScanName == nil then
				self:ScheduleTimer(function() self:RaidScan(1) end, 10)
				return
			end
			newRaidRoster[ScanName] = true
			if self.raidRoster[ScanName] then
				self.raidRoster[ScanName] = nil
			else
				newPlayers[ScanName] = true
			end
		end
			
		if newPlayers ~= self.raidRoster then
			self:GetModule("Display"):RaidUpdate(newPlayers,self.raidRoster)
			self.raidRoster = newRaidRoster
		end
	else 
		if UnitInRaid("player") then
			members = GetNumRaidMembers()
		else 
			members = GetNumPartyMembers() + 1
		end

		if members == 1 then
			if not self:GetModule("Display").db then return end
			if not self:GetModule("Display").db.profile.KeepWhenSolo then
				self.raidRoster = nil
				self:GetModule("Display"):Reset()
			end
			return
		end	

		for i = 1,members,1 do
			local ScanName = nil
			if UnitInRaid("player") then
				ScanName = UnitName("raid"..i)
			elseif not UnitInRaid("player") and i <= GetNumPartyMembers() then
				ScanName = UnitName("party"..i)
			else 
				ScanName = UnitName("player")
			end
			if ScanName == "Unknown" or ScanName == nil then
				self:ScheduleTimer(function() self:RaidScan(1) end, 10)
				return
			end
			newRaidRoster[ScanName] = true
		end
			
		local verified = self:GetModule("Display"):RaidUpdate(newRaidRoster,{})
		if verified then
			self.raidRoster = newRaidRoster
		end
	end
	
	if not self:GetModule("Display").db then return end
	if UnitInRaid("player") and self:GetModule("Display").db.profile.RMEnableRL and not UnitInBattleground("player") then
		local _, month, day, year = CalendarGetDate()
		local hour, minute = GetGameTime();
		local RaidTime = time({year = year, month = month, day = day, hour = hour, min = minute})
		local CurrentRaidLeader = {}
		local CurrentRaidMembers = {}

		for i = 1, GetNumRaidMembers(), 1 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
			if rank == 2 then CurrentRaidLeader = {name = name, class = class} elseif rank == 0 then rank = nil end
			CurrentRaidMembers[name] = {name = name, class = class, rank = rank, role = role, ML = isML}
		end

		local RaidFound = false
		for RaidLogIndex, RaidLogTable in pairs(self:GetModule("Display").db.profile.RMRaidLog) do
			if RaidLogTable.Leader.name == CurrentRaidLeader.name then 
				RaidFound = true
				if RaidLogTable.UpdateTime and RaidTime - RaidLogTable.UpdateTime < 900 then
					RaidLogTable.UpdateTime = RaidTime
					for RaidLogPlayerIndex, RaidLogPlayerTable in pairs(CurrentRaidMembers) do
						RaidLogTable.Members[RaidLogPlayerIndex] = RaidLogPlayerTable
					end
				else
					local TableToBeAdded = {
						OG = RaidTime,
						UpdateTime = RaidTime,
						Leader = CurrentRaidLeader and CurrentRaidLeader or {name = "Unknown", class = "Priest"},
						FTime = {year = year, month = month, day = day, hour = hour, min = minute},
						Members = CurrentRaidMembers,
						You = {name = UnitName("player"), class = CustomUnitClass("player")},
						BossInfo = {},
					}
					table.insert(RaidLogTable, TableToBeAdded)
				end			
			end		
		end
		if not RaidFound then
			local TableToBeAdded = {
				OG = RaidTime,
				UpdateTime = RaidTime,
				Leader = CurrentRaidLeader and CurrentRaidLeader or {name = "Unknown", class = "Priest"},
				FTime = {year = year, month = month, day = day, hour = hour, min = minute},
				Members = CurrentRaidMembers,
				You = {name = UnitName("player"), class = CustomUnitClass("player")},
				BossInfo = {},
			}
			table.insert(self:GetModule("Display").db.profile.RMRaidLog, TableToBeAdded)

			local RMLCount = 0
			local RMLTable = self:GetModule("Display").db.profile.RMRaidLog
			local RMLTable2 = {}
			table.sort(RMLTable, function(a,b) return a["OG"] > b["OG"] end)
			if self:GetModule("Display").db.profile.RMRaidCount > 50 then self:GetModule("Display").db.profile.RMRaidCount = 50 end
			for RaidLogIndex, RaidLogTable in pairs(RMLTable) do		
				if RMLCount <= self:GetModule("Display").db.profile.RMRaidCount then
					table.insert(RMLTable2, RaidLogTable)
					RMLCount = RMLCount + 1
				end
			end
			self:GetModule("Display").db.profile.RMRaidLog = RMLTable2
		
		end
	end
end

function FCDColorName2(CName,CColor)
	if CName == nil or CColor == nil then return nil end
	local _, ClassColorName = CustomUnitClass(CColor)
	if ClassColorName ~= nil then
        local CCName = RAID_CLASS_COLORS[ClassColorName]
        if CCName == nil then CCName = {r = 1, g = 1, b = 1} end
        CName = format("|cff%02x%02x%02x%s|r", CCName.r*255, CCName.g*255, CCName.b*255, CName)
        return CName
	else
		return CName
	end
end
 
function FCDColorName(CName)
	if CName == nil then return nil end
	local _, ClassColorName = CustomUnitClass(CName)
	if ClassColorName ~= nil then
        local CCName = RAID_CLASS_COLORS[ClassColorName]
        if CCName == nil then CCName = {r = 1, g = 1, b = 1} end
        CName = format("|cff%02x%02x%02x%s|r", CCName.r*255, CCName.g*255, CCName.b*255, CName)
        return CName
	else
		return CName
	end
end

local function FCDClasses(ClassCheck)
	local ClassTable = {
		["Death Knight"] = true,
		["Druid"] = true,
		["Hunter"] = true,
		["Mage"] = true,
		["Paladin"] = true,
		["Priest"] = true,
		["Rogue"] = true,
		["Shaman"] = true,
		["Warlock"] = true,
		["Warrior"] = true,
	}
	local ClassTable2 = false
	for c,v in pairs(ClassTable) do
		if L[c] == ClassCheck then ClassTable2 = true end
	end
	if ClassTable2 == true then return true else return false end
end

function CustomUnitClassL(ClassChecker, Size, force)
	if ClassChecker == nil then return end
	local classes = {["Death Knight"] = "DEATHKNIGHT", ["Druid"] = "DRUID", ["Hunter"] = "HUNTER", ["Mage"] = "MAGE", ["Paladin"] = "PALADIN", ["Priest"] = "PRIEST", ["Rogue"] = "ROGUE", ["Shaman"] = "SHAMAN", ["Warlock"] = "WARLOCK", ["Warrior"] = "WARRIOR"}
	local ReturnCheker = nil
	for c,v in pairs(classes) do
		if L[c] ~= nil and L[c] == ClassChecker then ReturnCheker = ClassChecker end
		if v == ClassChecker then ReturnCheker = ClassChecker end
	end
	if ReturnCheker ~= nil then
		if not force then return ReturnCheker else return L[ReturnCheker.."1"] end
	else
		if not Size then return L["Priest"] else return L["PRIEST"] end
	end
end

function CustomUnitClassP(ClassChecker)
	if ClassChecker == nil then return end
	local classes = {["Death Knight"] = "DEATHKNIGHT", ["Druid"] = "DRUID", ["Hunter"] = "HUNTER", ["Mage"] = "MAGE", ["Paladin"] = "PALADIN", ["Priest"] = "PRIEST", ["Rogue"] = "ROGUE", ["Shaman"] = "SHAMAN", ["Warlock"] = "WARLOCK", ["Warrior"] = "WARRIOR"}
	local ReturnCheker = false
	for c,v in pairs(classes) do
		if L[c] ~= nil and L[c] == ClassChecker then ReturnCheker = true end
		if L[v] ~= nil and L[v] == ClassChecker then ReturnCheker = true end
	end
	return ReturnCheker
end

local TempPlaerysClass = {}
function CustomUnitClass(classname)
	local classone, classtwo = nil, nil
	local weekday, month, day, year = CalendarGetDate()
	if classname == nil then return end
	if TempPlaerysClass[classname] ~= nil and TempPlaerysClass[classname].s ~= nil and TempPlaerysClass[classname].l ~= nil and CustomUnitClassP(TempPlaerysClass[classname].s) then 
		if TempPlaerysClass[classname].s ~= nil then return TempPlaerysClass[classname].s, TempPlaerysClass[classname].l end
	end
	if classname == UnitName("player") then 
		classone, classtwo = UnitClass(classname)
		if classone ~= nil then
			TempPlaerysClass[classname] = TempPlaerysClass[classname] or {}
			TempPlaerysClass[classname].s = CustomUnitClassL(classone)
			TempPlaerysClass[classname].l = CustomUnitClassL(classtwo, true)
		end
		return UnitClass("player")
	elseif UnitInRaid("player") and UnitInRaid(classname) then 
		classone, classtwo = UnitClass(classname)
		if classone ~= nil then
			TempPlaerysClass[classname] = TempPlaerysClass[classname] or {}
			TempPlaerysClass[classname].s = CustomUnitClassL(classone)
			TempPlaerysClass[classname].l = CustomUnitClassL(classtwo, true)
			if FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfo then FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname] = {month = month, class = classone} end 
		end
		return UnitClass(classname)
	elseif UnitInParty("player") and UnitInParty(classname) then
		classone, classtwo = UnitClass(classname)
		if classone ~= nil then
			TempPlaerysClass[classname] = TempPlaerysClass[classname] or {}
			TempPlaerysClass[classname].s = CustomUnitClassL(classone)
			TempPlaerysClass[classname].l = CustomUnitClassL(classtwo, true)
			if FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfo then FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname] = {month = month, class = classone} end 
		end
		return UnitClass(classname)
	elseif UnitName("arena1") ~= nil then
		for a = 1, 5, 1 do
			if UnitName("arena"..a) ~= nil then
				if classname:find("[%a]+%-[%a]+") then
					local realscrnameone, realscrnametwo = select(3, classname:find("(%a+)%-(%a+)"))
					classone, classtwo = UnitClass("arena"..a)
					if classone ~= nil then
						TempPlaerysClass[classname] = TempPlaerysClass[classname] or {}
						TempPlaerysClass[classname].s = CustomUnitClassL(classone)
						TempPlaerysClass[classname].l = CustomUnitClassL(classtwo, true)
					end
					if realscrnameone == UnitName("arena"..a) then
						if classone ~= nil then
							if FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfo then FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname] = {month = month, class = classone} end
						end
						return UnitClass("arena"..a)
					end
				elseif UnitName("arena"..a) == classname then
					classone, classtwo = UnitClass("arena"..a)
					if classone ~= nil then
						TempPlaerysClass[classname] = TempPlaerysClass[classname] or {}
						TempPlaerysClass[classname].s = CustomUnitClassL(classone)
						TempPlaerysClass[classname].l = CustomUnitClassL(classtwo, true)
						if FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfo then FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname] = {month = month, class = classone} end
					end
					return UnitClass("arena"..a)
				end
			end
		end
	elseif UnitInBattleground("player") then
		if battlegrountargets[classname] == nil then 
			for i = 1, GetNumBattlefieldScores() do
	    		local name, killingBlows, honorKills, deaths, honorGained, faction, rank, race, classbg, filename, damageDone, healingDone = GetBattlefieldScore(i)
	    		local realscrnameone, realscrnametwo = nil, nil
	    		if name ~= nil then
					if name:find("[%a]+%-[%a]+") then
						realscrnameone, realscrnametwo = select(3, name:find("(%a+)%-(%a+)"))
					end
		    		if (name == classname or realscrnameone == classname) and classbg and classname ~= nil then
						if FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfo then FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname] = {month = month, class = classbg} end
						battlegrountargets[classname] = {class1 = classbg, class2 = CustomUnitClassL(classbg, true, true)}
						TempPlaerysClass[classname] = TempPlaerysClass[classname] or {}
						TempPlaerysClass[classname].s = CustomUnitClassL(classbg)
						TempPlaerysClass[classname].l = CustomUnitClassL(classbg, true, true)
						return classbg, CustomUnitClassL(classbg, true, true)
		    		end
		    	end
	    	end
	    else
	    	TempPlaerysClass[classname] = TempPlaerysClass[classname] or {}
			TempPlaerysClass[classname].s = battlegrountargets[classname].class1
			TempPlaerysClass[classname].l = battlegrountargets[classname].class2 
	    	return battlegrountargets[classname].class1, battlegrountargets[classname].class2
	    end
	elseif UnitName("target") ~= nil and classname == UnitName("target") then
		classone, classtwo = UnitClass("target")
		if CustomUnitClassP(classone) then
			if classone ~= nil then
				if FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfo then FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname] = {month = month, class = classone} end
				TempPlaerysClass[classname] = TempPlaerysClass[classname] or {}
				TempPlaerysClass[classname].s = CustomUnitClassL(classone)
				TempPlaerysClass[classname].l = CustomUnitClassL(classtwo, true)
			end
			return UnitClass("target")
		else
			return nil
		end
	elseif UnitName("focus") ~= nil and classname == UnitName("focus") then
		classone, classtwo = UnitClass("focus") 
		if CustomUnitClassP(classone) then
			if classone ~= nil then
				if FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfo then FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname] = {month = month, class = classone} end
				TempPlaerysClass[classname] = TempPlaerysClass[classname] or {}
				TempPlaerysClass[classname].s = CustomUnitClassL(classone)
				TempPlaerysClass[classname].l = CustomUnitClassL(classtwo, true)
			end
			return UnitClass("focus")
		else
			return nil
		end
	elseif FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfo and FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname] ~= nil then
			if FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname].class ~= nil and CustomUnitClassP(FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname].class) then
				return FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname].class, CustomUnitClassL(FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname].class, true, true)
			end
	elseif FatCooldowns:GetModule("Display").db.profile.DeepClassScan and UnitInRaid("player") then
		for x = 1, GetNumRaidMembers() do
			if UnitName("raid"..x.."target") ~= nil and classname == UnitName("raid"..x.."target") then
				classone, classtwo = UnitClass("raid"..x.."target") 
				if CustomUnitClassP(classone) then
					if classone ~= nil then
						if FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfo then FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[classname] = {month = month, class = CustomUnitClassL(classone)} end
						classone, classtwo = UnitClass("raid"..x.."target")
						TempPlaerysClass[classname] = TempPlaerysClass[classname] or {}
						TempPlaerysClass[classname].s = CustomUnitClassL(classone)
						TempPlaerysClass[classname].l = CustomUnitClassL(classtwo, true)
					end
					return UnitClass("raid"..x.."target")
				end
			end
		end
	end
	return nil
end

function CustomUnitIsPlayer(playername)
	if UnitIsPlayer(playername) then return UnitIsPlayer(playername)
	elseif UnitName("arena1") ~= nil then
		for a = 1, 5, 1 do
			if UnitName("arena"..a) ~= nil then
				if playername:find("[%a]+%-[%a]+") then
					local realscrnameone, realscrnametwo = select(3, playername:find("(%a+)%-(%a+)"))
					if realscrnameone == UnitName("arena"..a) then
						return UnitIsPlayer("arena"..a)
					end
				elseif UnitName("arena"..a) == playername then
					return UnitIsPlayer("arena"..a)
				end
			end
		end
	elseif UnitInBattleground("player") then
		if battlegrountargets[playername] ~= nil then return true end
	elseif playername == UnitName("target") then return UnitIsPlayer("target")
	elseif UnitName("focus") ~= nil and playername == UnitName("focus") then return UnitIsPlayer("focus")
	elseif FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfo and FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[playername] ~= nil then
			if FatCooldowns:GetModule("Display").db.profile.StoreClaSSInfoExtra[playername].class ~= nil then return true end
	elseif FatCooldowns:GetModule("Display").db.profile.DeepClassScan then
		for x = 1, GetNumRaidMembers() do
			if UnitName("raid"..x.."target") ~= nil and playername == UnitName("raid"..x.."target") then return UnitIsPlayer("raid"..x.."target") end
		end
	end
end

local FClass, RClass = UnitClass("player")
local PlayersScanned = {}
local function addLine(self,id,isItem,Caster)
	if FatCooldowns:GetModule("Display").db ~= nil then
		if FatCooldowns:GetModule("Display").db.profile ~= nil then
			if isItem and FatCooldowns:GetModule("Display").db.profile.reporter[99892] then
				self:AddDoubleLine("ItemID:","|cffffffff"..id)
			elseif Caster and FatCooldowns:GetModule("Display").db.profile.reporter[99892] and FatCooldowns.ExPac == 2 then
				local _, class = UnitClass(Caster)
		        local c = RAID_CLASS_COLORS[class]
		        local ExtraTalentAndGlyph = ""
				local srcSource = format("|cff%02x%02x%02x%s|r", c.r*255, c.g*255, c.b*255, GetUnitName(Caster, true))
				if Caster == "pet" or Caster == "vehicle" then
					_, class = UnitClass("player")
					c = RAID_CLASS_COLORS[class]
					srcSource = format("%s (|cff%02x%02x%02x%s|r)", GetUnitName(Caster), c.r*255, c.g*255, c.b*255, GetUnitName("player", true))
				else
					local partypet = Caster:match("^partypet(%d+)$")
					local raidpet = Caster:match("^raidpet(%d+)$")
					if partypet then
						--_, class = UnitClass(GetUnitName("party"..partypet, true))
						c = RAID_CLASS_COLORS[L["WARRIOR"]]
						srcSource = format("%s (|cff%02x%02x%02x%s|r)", GetUnitName(Caster), c.r*255, c.g*255, c.b*255, GetUnitName("party"..partypet, true))
					elseif raidpet then
						--_, class = UnitClass(GetUnitName("raid"..raidpet, true))
						c = RAID_CLASS_COLORS[L["WARRIOR"]]
						srcSource = format("%s (|cff%02x%02x%02x%s|r)", GetUnitName(Caster), c.r*255, c.g*255, c.b*255, GetUnitName("raid"..raidpet, true))
					end
				end
				for classTG, TGTable in pairs(FatCooldowns.TalentAndGlyphInfo) do
					if classTG == class then
						if TGTable[tostring(GetSpellInfo(id))] and TGTable[tostring(GetSpellInfo(id))].rankIDs == nil then
							if TGTable[tostring(GetSpellInfo(id))].improved then
								if PlayersScanned[Caster] == nil or GetTime() - PlayersScanned[Caster] > 300 then
									PlayersScanned[Caster] = GetTime()
									LGT:RefreshTalentsByUnit(Caster)
								end
								local HasT = TGTable[tostring(GetSpellInfo(id))].improved and LGT:UnitHasTalent(Caster, TGTable[tostring(GetSpellInfo(id))].improved) or 0
								local MaxT = TGTable[tostring(GetSpellInfo(id))].maxTalentPoints or 0
								if HasT ~= 0 then
									ExtraTalentAndGlyph = ExtraTalentAndGlyph.."\n   "..TGTable[GetSpellInfo(id)].improved..": "..HasT.."/"..MaxT
								end
							end
							if TGTable[tostring(GetSpellInfo(id))].glyphImproved then
								if TGTable[tostring(GetSpellInfo(id))].glyphImproved ~= "table" then
									if PlayersScanned[Caster] == nil or GetTime() - PlayersScanned[Caster] > 300 then
										PlayersScanned[Caster] = GetTime()
										LGT:RefreshTalentsByUnit(Caster)
									end
									if LGT:UnitHasGlyph(Caster, TGTable[tostring(GetSpellInfo(id))].glyphImproved) then 
										ExtraTalentAndGlyph = ExtraTalentAndGlyph.."\n   "..TGTable[tostring(GetSpellInfo(id))].glyphImproved
									end
								elseif TGTable[tostring(GetSpellInfo(id))].glyphImproved == "table" then
									for y,t in pairs(TGTable[tostring(GetSpellInfo(id))].glyphImproved) do
										if PlayersScanned[Caster] == nil or GetTime() - PlayersScanned[Caster] > 300 then
											PlayersScanned[Caster] = GetTime()
											LGT:RefreshTalentsByUnit(Caster)
										end
										if LGT:UnitHasGlyph(Caster, t) then
											ExtraTalentAndGlyph = ExtraTalentAndGlyph.."\n   "..t
										end
									end
								end
							end
						else
							for u, p in pairs(TGTable) do 
								if p.rankIDs ~= nil and type(p.rankIDs) == "table" then
									for e, r in pairs(p.rankIDs) do
										if r == id then
											if PlayersScanned[Caster] == nil or GetTime() - PlayersScanned[Caster] > 300 then
												PlayersScanned[Caster] = GetTime()
												LGT:RefreshTalentsByUnit(Caster)
											end
											local HasT = p.improved and LGT:UnitHasTalent(Caster, p.improved) or 0
											local MaxT = p.maxTalentPoints or 0
											if HasT ~= 0 then
												ExtraTalentAndGlyph = ExtraTalentAndGlyph.."\n   "..p.improved..": "..HasT.."/"..MaxT
											end
										end
									end
								end
							end
						end
					elseif classTG == "ALL" then
						for SI, IT in pairs(TGTable) do
							if class == IT.class then
								for ITI, ITID in pairs(IT.rankIDs) do
									if ITID == id then 
										if PlayersScanned[Caster] == nil or GetTime() - PlayersScanned[Caster] > 300 then
											PlayersScanned[Caster] = GetTime()
											LGT:RefreshTalentsByUnit(Caster)
										end
										local HasT = TGTable[SI].improved and LGT:UnitHasTalent(Caster, TGTable[SI].improved) or 0
										local MaxT = TGTable[SI].maxTalentPoints or 0
										if HasT ~= 0 then
											ExtraTalentAndGlyph = ExtraTalentAndGlyph.."\n   "..TGTable[SI].improved..": "..HasT.."/"..MaxT
										end
										break
									end
								end
							end
						end
					end
				end
				if ExtraTalentAndGlyph ~= "" then self:AddDoubleLine(srcSource..ExtraTalentAndGlyph,"|cffffffff"..id) else self:AddDoubleLine(srcSource,"|cffffffff"..id) end
			elseif FatCooldowns:GetModule("Display").db.profile.reporter[99892] then
				local name, rank = GetSpellInfo(id)
				local ranknow = rank
				if rank ~= nil and rank ~= "" then ranknow = rank.." - " end
				self:AddDoubleLine("SpellID:","|cffffffff"..ranknow..id)
			end
			self:Show()
		end
	end
end

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local id = select(11,UnitBuff(...))
	local name = select(8, UnitBuff(...))
	if id and name then 
		addLine(self,id,nil,name)
	elseif id then
		addLine(self,id)
	end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(11,UnitDebuff(...));
	local name = select(8, UnitDebuff(...));
	if id and name then 
		addLine(self,id,nil,name)
	elseif id then
		addLine(self,id)
	end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11,UnitAura(...));
	local name = select(8, UnitAura(...));
	if id and name then 
		addLine(self,id,nil,name)
	elseif id then
		addLine(self,id)
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3,self:GetSpell())
	if id then addLine(self,id) end
end)

hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if id then addLine(ItemRefTooltip,id) end
end)

local CurrentSpec = "None"
local function attachItemTooltip(self)
	if not self then return end
	if FatCooldowns:GetModule("Display").db ~= nil then
		if FatCooldowns:GetModule("Display").db.profile ~= nil then
			local link = select(2,self:GetItem())
			if not link then return end
			local id = select(3,strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
			if id then
				addLine(self,id,true)
				if FatCooldowns.ExPac == 0 or FatCooldowns.ExPac == 1 then
					if UnitClass("player") == L["Warlock"] then
						if next(FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets) then 
							if FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")] then 
								local name, rank = GetItemSpell(id)
								if name ~= nil and FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")][name] then
									local SPRank1 = select(3,strfind(rank, "Rank (%d)"))
									local SPRank2 = select(3,strfind(FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")][name], "Rank (%d+)"))
									if (FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")][name] == rank) or (SPRank1 ~= nil and SPRank2 ~= nil and SPRank1 <= SPRank2) then
										self:AddDoubleLine("|cffC41F3BAlready Known|r")
									end
								end
							end
						end
					end
				end
				if FatCooldowns:GetModule("Display").db.profile.AGToolTip2 ~= 1 then
					local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice = GetItemInfo(link)
					if itemType == L["Armor"] or itemType == L["Weapon"] then
						if FatCooldowns:GetModule("Display").db.profile.AGToolTip2 == 2 then
							local ItemScore = FatCooldowns:FCDGearScore(link, nil)
							if ItemScore ~= nil and ItemScore ~= 0.0001 and ItemScore ~= 0 then
								self:AddDoubleLine("FCD AG: "..CurrentSpec, ItemScore)
							end
						elseif FatCooldowns:GetModule("Display").db.profile.AGToolTip2 == 3 then
							for x,c in pairs(FatCooldowns.DefaultItemWeights[RClass]) do
								local ItemScore = FatCooldowns:FCDGearScore(link, nil, x)
								if ItemScore ~= nil and ItemScore ~= 0.0001 and ItemScore ~= 0 then
									self:AddDoubleLine("FCD AG: "..x, ItemScore)
								end
							end
						end
					end
				end
			end
		end 
	end
end

TipHooker:Hook(attachItemTooltip, "item")	

function FatCooldowns:DistanceChecker(unit1,unit2)
	if UnitName("boss1") ~= L["Sindragosa"] or not UnitInRaid(unit1) or not UnitInRaid(unit2) then return 99 end
	SetMapToCurrentZone()
	local x1,y1 = GetPlayerMapPosition(unit1)
	local x2,y2 = GetPlayerMapPosition(unit2)
	local Lw,Lh = 720.60965618252, 481.1621506613
	local dx = (x2 - x1) * Lw
	local dy = (y2 - y1) * Lh
	return (dx*dx + dy*dy)^(0.5)
end

local itemCounts = {}
local function GetCharacterItemCount(character, searchedID)
	itemCounts[1], itemCounts[2] = DataStore:GetContainerItemCount(character, tonumber(searchedID))
	itemCounts[3] = DataStore:GetAuctionHouseItemCount(character, tonumber(searchedID))
	itemCounts[4] = DataStore:GetInventoryItemCount(character, tonumber(searchedID))
	itemCounts[5] = DataStore:GetMailItemCount(character, tonumber(searchedID))
	itemCounts[6] = DataStore:GetCurrencyItemCount(character, tonumber(searchedID))
	local charCount = 0
	for _, v in pairs(itemCounts) do
		charCount = charCount + v
	end
	return charCount
end

local function GetAccountItemCount(account, searchedID)
	local realm = GetRealmName()
	local count = 0
	for _, character in pairs(DataStore:GetCharacters(realm, account)) do
		count = count + GetCharacterItemCount(character, searchedID)
	end
	return count
end

function FatCooldowns:AutoBuyMerchant()
	local MessageSent = false
	local Fclass, Rclass = UnitClass("player")
	if FatCooldowns:GetModule("Display").db.profile.ABEnable and not IsShiftKeyDown() then
		if next(FatCooldowns:GetModule("Display").db.profile.ABList) then
			local ReamlId = GetRealmName()
			for ABItemID, ABTable in pairs(FatCooldowns:GetModule("Display").db.profile.ABList) do
				FatCooldowns:GetModule("Display").db.profile.ABList[ABItemID]["servers"] = FatCooldowns:GetModule("Display").db.profile.ABList[ABItemID]["servers"] or {}
				if FatCooldowns:GetModule("Display").db.profile.ABList[ABItemID]["servers"][ReamlId] == nil then FatCooldowns:GetModule("Display").db.profile.ABList[ABItemID]["servers"][ReamlId] = false end
				if FatCooldowns:GetModule("Display").db.profile.ABList[ABItemID]["servers"][ReamlId] then
					FatCooldowns:GetModule("Display").db.profile.ABList[ABItemID]["class"] = FatCooldowns:GetModule("Display").db.profile.ABList[ABItemID]["class"] or false
					FatCooldowns:GetModule("Display").db.profile.ABList[ABItemID]["classes"] = FatCooldowns:GetModule("Display").db.profile.ABList[ABItemID]["classes"] or {}
					if FatCooldowns:GetModule("Display").db.profile.ABList[ABItemID]["class"] == false or (FatCooldowns:GetModule("Display").db.profile.ABList[ABItemID]["class"] == true and FatCooldowns:GetModule("Display").db.profile.ABList[ABItemID]["classes"][Rclass]) then
						if ABTable["shared"] then
							if IsAddOnLoaded("Datastore") then
								local count = 0
								count = count + GetAccountItemCount("Default", ABItemID)
								for i = 1,  GetMerchantNumItems() do
									local ItemLink = GetMerchantItemLink(i)
									if ItemLink ~= nil then
										local RLItemID = select(3,strfind(ItemLink, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
										if RLItemID ~= nil and RLItemID == ABItemID then
											local name, texture, price, quantity, numAvailable = GetMerchantItemInfo(i)
											if numAvailable ~= 0 then
												local NumNeeded = ABTable["count"] - count
												if NumNeeded > 0 then
													if quantity ~= nil and quantity > 0 then NumNeeded = math.floor(NumNeeded/quantity) end
													if NumNeeded > 0 then
														if numAvailable > 0 and numAvailable < NumNeeded then
															BuyMerchantItem(i, numAvailable)
														else
															BuyMerchantItem(i,NumNeeded)
														end
													end
												end
											end
										end
									end
								end
							else
								if not MessageSent then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Datastore not loaded") end
							end
						else
							local count = GetItemCount(tonumber(ABItemID))
							if ABTable["count"] > count then 
								for i = 1,  GetMerchantNumItems() do 
									local ItemLink = GetMerchantItemLink(i)
									if ItemLink ~= nil then
										local RLItemID = select(3,strfind(ItemLink, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
										if RLItemID ~= nil and RLItemID == ABItemID then
											local name, texture, price, quantity, numAvailable = GetMerchantItemInfo(i)
											if numAvailable ~= 0 then
												local NumNeeded = ABTable["count"] - count
												if NumNeeded > 0 then
													if quantity ~= nil and quantity > 0 then NumNeeded = math.floor(NumNeeded/quantity) end
													if NumNeeded > 0 then
														if numAvailable > 0 and numAvailable < NumNeeded then
															BuyMerchantItem(i, numAvailable)
														else
															BuyMerchantItem(i,NumNeeded)
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
			end
		end
	end
end

local DontSellItems = {
	["Skinning Knife"] = true,
	["Mining Pick"] = true,
	["Blacksmith Hammer"] = true,
	["Dragonbreath Chili"] = true,
	["Dirge's Kickin' Chimaerok Chops"] = true,
	["Baby Spice"] = true,
	["Gnomish Battle Chicken"] = true,
	["Arclight Spanner"] = true,
}

function FatCooldowns:MERCHANT_SHOW()
	FatCooldowns:GetModule("Display"):UpdateMF()
	FatCooldowns:GetModule("Display"):UpdateBF()
	self:AutoBuyMerchant()
	if UnitLevel("player") == 80 and FatCooldowns:GetModule("Display").db.profile.reporter[99891] then
		local currentstock = nil
		if UnitClass("player") == L["Druid"] then
			currentstock = GetItemCount(L["Wild Spineleaf"])
			if currentstock < 20 then
				local numtobuy = 20 - currentstock
				for i=1, GetMerchantNumItems() do
					if GetMerchantItemInfo(i) == L["Wild Spineleaf"] then BuyMerchantItem(i, numtobuy) end
				end
			end
		elseif UnitClass("player") == L["Priest"] then
			currentstock = GetItemCount(L["Devout Candle"])
			if currentstock < 20 then
				local numtobuy = 20 - currentstock
				for i=1, GetMerchantNumItems() do
					if GetMerchantItemInfo(i) == L["Devout Candle"] then BuyMerchantItem(i, numtobuy) end
				end
			end
		elseif UnitClass("player") == L["Paladin"] then
			currentstock = GetItemCount(L["Symbol of Divinity"])
			if currentstock < 5 then
				local numtobuy = 5 - currentstock
				for i=1, GetMerchantNumItems() do
					if GetMerchantItemInfo(i) == L["Symbol of Divinity"] then BuyMerchantItem(i, numtobuy) end
				end
			end
			currentstock = math.floor(GetItemCount(L["Symbol of Kings"]) / 20)
			if currentstock < 5 then
				local numtobuy = 5 - currentstock
				for i=1, GetMerchantNumItems() do
					if GetMerchantItemInfo(i) == L["Symbol of Kings"] then BuyMerchantItem(i, numtobuy) end
				end
			end
		elseif UnitClass("player") == L["Mage"] then
			currentstock = GetItemCount(L["Rune of Portals"])
			if currentstock < 20 then
				local numtobuy = 20 - currentstock
				for i=1, GetMerchantNumItems() do
					if GetMerchantItemInfo(i) == L["Rune of Portals"] then BuyMerchantItem(i, numtobuy) end
				end
			end
			currentstock = GetItemCount(L["Arcane Powder"])
			if currentstock < 100 then
				local numtobuy = 100 - currentstock
				for i=1, GetMerchantNumItems() do
					if GetMerchantItemInfo(i) == L["Arcane Powder"] then BuyMerchantItem(i, numtobuy) end
				end
			end
		elseif UnitClass("player") == L["Rogue"] then
			currentstock = GetItemCount(L["Deadly Poison IX"])
			if currentstock < 20 then
				local numtobuy = 20 - currentstock
				for i=1, GetMerchantNumItems() do
					if GetMerchantItemInfo(i) == L["Deadly Poison IX"] then
						local MerchLink = GetMerchantItemLink(i)
						local ItemID = select(3,strfind(MerchLink, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
						if ItemID == "43233" then
							BuyMerchantItem(i, numtobuy)
						end
					end
				end
			end
			currentstock = GetItemCount(L["Instant Poison IX"])
			if currentstock < 20 then
				local numtobuy = 20 - currentstock
				for i=1, GetMerchantNumItems() do
					if GetMerchantItemInfo(i) == L["Instant Poison IX"] then
						local MerchLink = GetMerchantItemLink(i)
						local ItemID = select(3,strfind(MerchLink, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
						if ItemID == "43231" then
							BuyMerchantItem(i, numtobuy)
						end
					end
				end
			end
		end
	end
	if FatCooldowns:GetModule("Display").db.profile.reporter[99889] and CanMerchantRepair() then
		local repairAllCost, canRepair  = GetRepairAllCost()
		if repairAllCost ~= nil and repairAllCost ~= 0 and canRepair and repairAllCost <= GetMoney() then
			if CanGuildBankRepair() then
				RepairAllItems(1)
				local repairAllCost2, canRepair2  = GetRepairAllCost()
				if repairAllCost2 ~= nil and repairAllCost2 ~= 0 and canRepair2 and repairAllCost2 <= GetMoney() then
					local editedcost = repairAllCost - repairAllCost2
					RepairAllItems(0)
					if editedcost ~= nil and editedcost ~= 0 then DEFAULT_CHAT_FRAME:AddMessage("Guild: Items have been repaired for "..GetCoinText(editedcost,", ")..".",255,255,0) end
					DEFAULT_CHAT_FRAME:AddMessage("Guild: Items have been repaired for "..GetCoinText(repairAllCost2,", ")..".",255,255,0)
				else
				DEFAULT_CHAT_FRAME:AddMessage("Guild: Items have been repaired for "..GetCoinText(repairAllCost,", ")..".",255,255,0)
				end
			else
				RepairAllItems(0)
				DEFAULT_CHAT_FRAME:AddMessage("Self: Items have been repaired for "..GetCoinText(repairAllCost,", ")..".",255,255,0)
			end
		elseif repairAllCost ~= nil and repairAllCost ~= 0 and canRepair and repairAllCost >= GetMoney() then
			DEFAULT_CHAT_FRAME:AddMessage("Self: You need more gold for repairs",255,255,0)
		end
	end
	if FatCooldowns:GetModule("Display").db.profile.AutoSell then
		local SellProtection = 0
		local TotalSellPrice = 0
		for x = 0, 4 do 
   			for y = 1, GetContainerNumSlots(x) do
				local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue = GetContainerItemInfo(x,y)
				local QuestItem = GetContainerItemQuestInfo(x,y)
				local UCLASS, PCLASS = UnitClass("player")
				if QuestItem ~= nil and QuestItem then itemLink = nil end
				if itemLink ~= nil then 
					local ItemName, itemLink2, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemLink)
					local ItemID = tostring(GetContainerItemID(x,y))
					local TempSell = false
					local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
					local ItemIDFull = select(3,strfind(itemLink, "|H(.+):.+|h%["))
					local StackSizeAndPrice = ""
					if itemCount ~= nil and itemCount ~= 0 then StackSizeAndPrice = " x"..itemCount.." "..GetCoinTextureString((itemSellPrice * itemCount)) end

					if FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[1] ~= nil and FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[1] == true and itemType == L["Consumable"] and itemSubType == L["Food & Drink"] and
						UnitLevel("player") - itemLevel > FatCooldowns:GetModule("Display").db.profile.FoodLvl and itemLevel < 70 and itemSubType ~= L["Miscellaneous"] then
							local TempSell2 = true
							for c,v in pairs(DontSellItems) do
								if L[c] == ItemName then TempSell2 = false end
							end
							if TempSell2 then TempSell = true end
					end

					if FatCooldowns:GetModule("Display").db.profile.SellSBItems[itemRarity] ~= nil and FatCooldowns:GetModule("Display").db.profile.SellSBItems[itemRarity] == true and IsEquippableItem(itemLink) and FatCooldowns:GetModule("Display").db.profile.TMDisenchantVendorVal and isSoulbound(x, y) then
						local FCDDEVal, FCDDEVal2
						if select(4, GetAddOnInfo("Auctionator")) == 1 then FCDDEVal = FCDDisenchantValue2(itemType, itemRarity, itemLevel) end
						if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then FCDDEVal2 = FCDDisenchantValue(itemLink) if FCDDEVal2 > FCDDEVal then FCDDEVal = FCDDEVal2 end end
						if FCDDEVal ~= nil and FCDDEVal ~= 0 and itemSellPrice > FCDDEVal then TempSell = true end
					end

					if FatCooldowns:GetModule("Display").db.profile.SellSBItems[itemRarity] ~= nil and FatCooldowns:GetModule("Display").db.profile.SellSBItems[itemRarity] == true and IsEquippableItem(itemLink) and FatCooldowns:GetModule("Display").db.profile.TMFunctional and isSoulbound(x, y) and not isSoulbound(x, y, nil, nil, nil, PCLASS) then TempSell = true end
					if FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[2] ~= nil and FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[2] == true and itemType == L["Consumable"] and itemSubType == L["Scroll"] and itemLevel < 90 then TempSell = true end
					if FatCooldowns:GetModule("Display").db.profile.SellSBItems[itemRarity] ~= nil and FatCooldowns:GetModule("Display").db.profile.SellSBItems[itemRarity] == true and IsEquippableItem(itemLink) and isSoulbound(x, y) and not isSoulbound(x, y, nil, true) then TempSell = true end
					if FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[3] ~= nil and FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[3] == true and quality == 1 and IsEquippableItem(itemLink) and itemEquipLoc ~= "INVTYPE_TABARD" and isSoulbound(x, y, nil, nil, true) and
						itemSubType ~= L["Miscellaneous"] and DontSellItems[ItemName] == nil and itemSubType ~= L["Fishing Poles"] and Enchant == "0" and Gem1 == "0" and Gem2 == "0" and Gem3 == "0" and Gem4 == "0" then TempSell = true end
					if FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[4] ~= nil and FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[4] == true and FatCooldowns:GetModule("Display").db.profile.SellList2[ItemIDFull] == nil and itemType == L["Recipe"] and itemSubType ~= L["Book"] then TempSell = true end

					if itemRarity == 0 or FatCooldowns:GetModule("Display").db.profile.SellList2[ItemIDFull] == ItemIDFull or TempSell then
						if itemSellPrice == 0 and not TempSell then
							if not FatCooldowns:GetModule("Display").db.profile.SellSilence then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Destorying "..itemLink.." Cant Sell") end
	   						PickupContainerItem(x,y)
             				DeleteCursorItem()
             				self:ScheduleTimer(function() self:MERCHANT_SHOW() end, 0.5)
             				return
						elseif itemSellPrice ~= 0 then
							if SellProtection == 12 and FatCooldowns:GetModule("Display").db.profile.SellProtection then TempSell = false return end
							SellProtection = SellProtection + 1
							if not FatCooldowns:GetModule("Display").db.profile.SellSilence then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Selling "..itemLink..StackSizeAndPrice) end
							TotalSellPrice = TotalSellPrice + (itemSellPrice * itemCount)
							UseContainerItem(x,y)
						end
					end
					TempSell = false
				end
   			end
   		end
   		if TotalSellPrice ~= 0 and not FatCooldowns:GetModule("Display").db.profile.SellSilence then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Total Sell "..GetCoinTextureString(TotalSellPrice)) end
	end
end

function FatCooldowns:READY_CHECK()
	if (FatCooldowns:GetModule("Display").db.profile.reporter[99890] or FatCooldowns:GetModule("Display").db.profile.reporter[99790]) and not (IsModifierKeyDown() or UnitIsAFK("player") or UnitIsDND("player")) then
		if FatCooldowns:GetModule("Display").db.profile.reporter[99790] then
			self:ScheduleTimer(function() ConfirmReadyCheck(1) ReadyCheckFrame:Hide() end, 3)
		else
			ConfirmReadyCheck(1)
			ReadyCheckFrame:Hide()
		end
	end
end

function FatCooldowns:AvgIlvl(force, playerwho, AVGILvlTable)
	if playerwho == nil then playerwho = "player" end
	local AvgIlvlT, AvgIlvlC, AvgIlvlL = 0, 0, nil
	if AVGILvlTable then
		for i = 1, 18 do
			if AVGILvlTable[i] and AVGILvlTable[i].itemLevel then
				AvgIlvlT = AvgIlvlT + tonumber((AVGILvlTable[i] and AVGILvlTable[i].itemLevel) or 0)
				AvgIlvlC = AvgIlvlC + 1
			end
		end
	else
		for i = 1, 18 do
			AvgIlvlL = GetInventoryItemLink(playerwho,i)
			if i ~= 4 and AvgIlvlL then
				AvgIlvlT = AvgIlvlT + tonumber(select(4,GetItemInfo(AvgIlvlL)) or 0)
				AvgIlvlC = AvgIlvlC + 1
			end
		end
	end
	if force ~= nil then
		return AvgIlvlT / AvgIlvlC
	else
		return string.format("%.1f", AvgIlvlT / AvgIlvlC)
	end
end

function FatCooldowns:RollNow(Event, RollID, ARName, ItemLink, Message, NumRoll)
	if ItemLink ~= nil and ItemLink ==  GetLootRollItemLink(RollID) then
		RollOnLoot(RollID, NumRoll)
		ConfirmLootRoll(RollID, NumRoll)
		StaticPopup_Hide(Event, RollID)
		if ItemLink ~= nil and not FatCooldowns:GetModule("Display").db.profile.SilentARRemove then FatCooldowns:GetModule("Display"):FCDPrefixPrint(ARName.." Rolls "..Message.." on "..ItemLink) end
	end
end

function FatCooldowns:START_LOOT_ROLL(Event, RollID, ...)
	local ItemLink = GetLootRollItemLink(RollID)
	local ItemID = select(3,strfind(ItemLink, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
	local texture, name, count, quality, bindOnPickUp, canNeed, canGreed, canDisenchant, reasonNeed, reasonGreed, reasonDisenchant, deSkillRequired = GetLootRollItemInfo(RollID)
	local ItemName, _, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(ItemLink)

	if ItemID ~= nil and FatCooldowns:GetModule("Display").db.profile.LootBlackList2[ItemID] == ItemID then return end
	
	local TempRolled = false
	for i = 1, 10, 1 do
		if TempRolled then return end
		if  i <= FatCooldowns:GetModule("Display").db.profile.ARCount then
			if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)] ~= nil then
				if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].AREnable then
					if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].GroupType == 1 or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].GroupType == 2 and not UnitInRaid("player")) or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].GroupType == 3 and UnitInRaid("player")) then
						if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].PLevel == 0 or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].PlevelType == 1 and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].PLevel > UnitLevel("player")) or
							(FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].PlevelType == 2 and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].PLevel < UnitLevel("player")) then 
							if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARQuality[quality] ~= nil and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARQuality[quality] then 
								if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].EQ == 1 or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].EQ == 2 and ItemLink ~= nil and IsEquippableItem(ItemLink)) or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].EQ == 3 and ItemLink ~= nil and not IsEquippableItem(ItemLink)) then
									if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARUEQ == 1 or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARUEQ == 2 and ItemLink ~= nil and IsEquippableItem(ItemLink) and isSoulbound(nil, nil, ItemLink, true)) or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARUEQ == 3 and ItemLink ~= nil and IsEquippableItem(ItemLink) and not isSoulbound(nil, nil, ItemLink, true)) then
										if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].BagSpace == 0 or FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].BagSpace < self:BagsFree() then 
											if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].IA == 0 or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].IAT == 1 and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].IA > self:AvgIlvl("true")) or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].IAT == 2 and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].IA < self:AvgIlvl("true")) then
												if not FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].UnableToRType.Need or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].UnableToRType.Need and not canNeed) then
													if not FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].UnableToRType.DE or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].UnableToRType.DE and not canDisenchant) then 
														if not FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].EIL or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].EIL and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ItemList ~= nil and ItemID ~= nil and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ItemList[ItemID]) then
															if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARLeader == 1 or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARLeader == 2 and (UnitInRaid("player") or UnitInParty("player")) and UnitIsGroupLeader("player")) or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARLeader == 3 and (UnitInRaid("player") or UnitInParty("player")) and not UnitIsGroupLeader("player")) then
														 		local _, PClass = UnitClass("player")
																if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].AREFunctional == 1 or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].AREFunctional == 2 and isSoulbound(nil, nil, ItemLink, nil, nil, PClass) ) or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].AREFunctional == 3 and not isSoulbound(nil, nil, ItemLink, nil, nil, PClass)) then
																	if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARILvL == 0 or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARILvL ~= 0 and itemLevel ~= nil and ((FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARILvL > itemLevel and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARILvLType == 1) or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARILvL < itemLevel and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARILvLType == 2))) then
																		local BOPORNO = isSoulbound(nil, nil, ItemLink)
																		if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARBind == 1 or (BOPORNO ~= nil and BOPORNO == true and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARBind == 2) or (BOPORNO ~= nil and BOPORNO == false and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARBind == 3) then
																			local iType, instance, boss, difficulty, droprate = lootdata:FindItem(ItemID)
																			if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARBOssItem == 1 or (boss ~= nil and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARBOssItem == 2) or (boss == nil and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARBOssItem == 3) then

																			if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARSellPrice == 1 or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARSellPrice == 2 and itemSellPrice) or (FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARSellPrice == 3 and not itemSellPrice) then
																				local FCDDEVal
																				if canDisenchant == nil then canDisenchant = false end
																				if select(4, GetAddOnInfo("Auctionator")) == 1 then
																					FCDDEVal = FCDDisenchantValue2(itemType, itemRarity, itemLevel)
																					if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then
																					else
																						if canDisenchant and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].VendorPrice and itemSellPrice > FCDDEVal then canDisenchant = false end
																					end
																				end
																				if select(4, GetAddOnInfo("Auc-Advanced")) == 1 and AucAdvanced then
																					local FCDAucMin, FCDAucMinSeen = FCDAuctionPriceMinBuyout(ItemLink)
																					local FCDAucMarket, FCDAucMarketSeen = FCDAuctionPriceMarket(ItemLink)
																					if not Enchantrix then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: Could not find addon Enchantrix") return end
																					FCDDEVal2 = FCDDisenchantValue(ItemLink)
																					if FCDDEVal2 > FCDDEVal then FCDDEVal = FCDDEVal2 end

																					if FCDAucMin == nil then FCDAucMin = 0 elseif FCDAucMin > 0 then FCDAucMin = (FCDAucMin * 0.95) - (itemSellPrice * 0.6) end
																					if FCDAucMinSeen == nil then FCDAucMinSeen = 0 end
																					if FCDAucMarket == nil then FCDAucMarket = 0 elseif FCDAucMarket > 0 then FCDAucMarket = (FCDAucMarket * 0.95) - (itemSellPrice * 0.6) end
																					if FCDAucMarketSeen == nil then FCDAucMarketSeen = 0 end

																					if canDisenchant and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].VendorPrice and itemSellPrice > FCDDEVal then canDisenchant = false end 
																					if not BOPORNO and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].AucMinPrice and FCDAucMin > FCDDEVal then
																						if FCDAucMinSeen <= FatCooldowns:GetModule("Display").db.profile.AucSeen then 
																						else 
																							if canDisenchant then canDisenchant = false end
																						end
																					end
																					if not BOPORNO and FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].AucMarketPrice and FCDAucMarket > FCDDEVal then 
																						if FCDAucMinSeen <= FatCooldowns:GetModule("Display").db.profile.AucSeen then
																						else
																							if canDisenchant then canDisenchant = false end
																						end
																					end
																				end

								if (quality == 2 or quality == 3 or quality == 4) and RollID ~= nil then
									local ARName = nil
									if next(FatCooldowns:GetModule("Display").db.profile.ARNameT) and FatCooldowns:GetModule("Display").db.profile.ARNameT[i] then
										ARName = "FCD AR: "..FatCooldowns:GetModule("Display").db.profile.ARNameT[i]..":"
									else
										ARName = "FCD AutoRoller "..i..":"
									end 

									if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].RType.Need and canNeed then
										if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARDelay ~= 0 then
											self:ScheduleTimer(function() self:RollNow(Event, RollID, ARName, ItemLink, "Need", 1) end, FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARDelay)
											TempRolled = true
										else 
											self:RollNow(Event, RollID, ARName, ItemLink, "Need", 1)
											TempRolled = true
										end
									elseif FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].RType.DE and canDisenchant then
										if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARDelay ~= 0 then
											self:ScheduleTimer(function() self:RollNow(Event, RollID, ARName, ItemLink, "Disenchant", 3) end, FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARDelay)
											TempRolled = true
										else
											self:RollNow(Event, RollID, ARName, ItemLink, "Disenchant", 3)
											TempRolled = true
										end
									elseif FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].RType.Greed and canGreed then
										if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARDelay ~= 0 then
											self:ScheduleTimer(function() self:RollNow(Event, RollID, ARName, ItemLink, "Greed", 2) end, FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARDelay)
											TempRolled = true
										else
											self:RollNow(Event, RollID, ARName, ItemLink, "Greed", 2)
											TempRolled = true
										end
									elseif FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].RType.Pass then
										if FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARDelay ~= 0 then
											self:ScheduleTimer(function() self:RollNow(Event, RollID, ARName, ItemLink, "Pass", 0) end, FatCooldowns:GetModule("Display").db.profile.ARTable[tostring(i)].ARDelay)
											TempRolled = true
										else
											self:RollNow(Event, RollID, ARName, ItemLink, "Pass", 0)
											TempRolled = true
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
	end
end

local ADDON_NAME = "FatCooldowns"
local CHFrame = CreateFrame("Frame")
function SendMessages()
	local TempTable
	CHFrame.IsPrinting = true
	local PrintableTable = {}
	for CHEvent, CHEventEnable in pairs(FatCooldowns:GetModule("Display").db.profile.ChatHistoryMessages) do
		table.insert(PrintableTable, CHEventEnable)
	end
	table.sort(PrintableTable, function(a,b) return a[31] < b[31] end)
	for CHEvent, CHEventEnable in pairs(PrintableTable) do
		if FatCooldowns:GetModule("Display").db.profile.ChatHistoryList[CHEventEnable[30]] then 
			TempTable = PrintableTable[CHEvent]
			for i = 1, NUM_CHAT_WINDOWS do
				if _G["ChatFrame"..i] ~= COMBATLOG then
					ChatFrame_MessageEventHandler(_G["ChatFrame"..i], TempTable[30], unpack(TempTable))
				end
			end
		end
	end
	CHFrame.IsPrinting = false
	CHFrame.HasPrinted = true
	if TempTable then
		for i = 1, NUM_CHAT_WINDOWS do
			if _G["ChatFrame"..i] ~= COMBATLOG then
				_G["ChatFrame"..i]:AddMessage("---> Previous Message's <---")
			end
		end
	end
end

function Save(event, ...)
	local TempTable = {...}
	if TempTable[1] then
		local AddTrue = true
		TempTable[30] = event
		TempTable[31] = time()
		if event == "CHAT_MSG_WHISPER" then
			for x,c in pairs(FatCooldowns.HistoryFilterChecker) do
				if TempTable[2] == c.name and TempTable[1] == c.msg then AddTrue = false end
			end
		end
		if AddTrue then
			table.insert(FatCooldowns:GetModule("Display").db.profile.ChatHistoryMessages, 1, TempTable)
			for i = FatCooldowns:GetModule("Display").db.profile.MessageLimit, #FatCooldowns:GetModule("Display").db.profile.ChatHistoryMessages do
				table.remove(FatCooldowns:GetModule("Display").db.profile.ChatHistoryMessages, FatCooldowns:GetModule("Display").db.profile.MessageLimit)
			end
		end
	end
end

function Init()
	FatCooldowns:GetModule("Display").db.profile.ChatHistoryMessages = type(FatCooldowns:GetModule("Display").db.profile.ChatHistoryMessages) == "table" and FatCooldowns:GetModule("Display").db.profile.ChatHistoryMessages or {}
	_G["CHAT_FLAG_CHAT_HISTORY_PLAYER_ENTRY"] = ""
	local IsPrintingWait = IsPrintingWait2
	function IsPrintingWait2(...)
		if CHFrame.IsPrinting then return end
		return IsPrintingWait(...)
	end
	for CHEvent, CHEventEnable in pairs(FatCooldowns:GetModule("Display").db.profile.ChatHistoryList) do
		if CHEventEnable then CHFrame:RegisterEvent(CHEvent) end
	end
	if IsLoggedIn() then
		OnEvent(CHFrame, "PLAYER_LOGIN")
	else
		CHFrame:RegisterEvent("PLAYER_LOGIN")
	end
end

function OnEvent(CHFrame, event, ...)
	if event == "ADDON_LOADED" then
		if ADDON_NAME == "FatCooldowns" then
			CHFrame:UnregisterEvent(event)
			FatCooldowns:ScheduleTimer(function() Init() end, 2)			
		end
	elseif event == "PLAYER_LOGIN" then
		CHFrame:UnregisterEvent(event)
		if FatCooldowns:GetModule("Display").db.profile.EnableChatHistory then SendMessages() end
	elseif CHFrame.HasPrinted then
		Save(event, ...)
	end
end
CHFrame:RegisterEvent("ADDON_LOADED")
CHFrame:SetScript("OnEvent", OnEvent)

function FatCooldowns:OnInitialize()
	self:SetEnabledState(true)

	self.prefix = "FRCD3Shekles20"
	self.prefixB = "FRCD3BShekles20" -- broadcast
	self.prefixR = "FRCD3RShekles20" -- request
	self.prefixI = "FRCD3IShekles20" -- infodump
	self.prefixS = "FRCD3SShekles20" -- singleReport
	self.prefixL = "FRCD3LShekles" 
	self.prefixC = "FCDPARRYCOUNTER"
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("UNIT_SPELLCAST_SENT")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	self:RegisterEvent("MERCHANT_SHOW")
	self:RegisterEvent("READY_CHECK")
	self:RegisterEvent("UNIT_EXITED_VEHICLE")
	self:RegisterEvent("RAID_TARGET_UPDATE")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("START_LOOT_ROLL")
	self:RegisterEvent("LOOT_OPENED")
	self:RegisterEvent("UPDATE_INSTANCE_INFO")
	--self:RegisterEvent("LFG_PROPOSAL_SHOW")
	self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:RegisterEvent("CHAT_MSG_LOOT")
	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
	self:RegisterEvent("UI_INFO_MESSAGE")
	self:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
	self:RegisterEvent("MAIL_SHOW")
	self:RegisterEvent("MAIL_CLOSED")
	self:RegisterEvent("UI_ERROR_MESSAGE")
	self:RegisterEvent("IGNORELIST_UPDATE")
	self:RegisterEvent("FRIENDLIST_UPDATE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("ACHIEVEMENT_EARNED")
	self:RegisterEvent("TRADE_ACCEPT_UPDATE")
	self:RegisterEvent("TRADE_SHOW")
	self:RegisterEvent("TRADE_CLOSE")
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("INSPECT_TALENT_READY")
	self:RegisterEvent("CHAT_MSG_GUILD")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")


end

function FatCooldowns:PLAYER_REGEN_DISABLED() FatCooldowns:GetModule("Display"):UpdateDisplay() end
function FatCooldowns:PLAYER_REGEN_ENABLED() FatCooldowns:GetModule("Display"):UpdateDisplay() end


function FatCooldowns:OnEnable()
	self:RegisterComm(self.prefix)
	self:RegisterComm(self.prefixB)
	self:RegisterComm(self.prefixR)
	self:RegisterComm(self.prefixI)
	self:RegisterComm(self.prefixS)
	self:RegisterComm(self.prefixL)
	self:RegisterComm(self.prefixC)
	
	local modulename, module
	for modulename, module in self:IterateModules() do
		if not module:IsEnabled() then
			self:EnableModule(modulename)
		end
	end
	
	self:RaidScan()
end

function FatCooldowns:CHAT_MSG_WHISPER(eventtype, text, playerName, languageName, channelName, playerName2)
	if FatCooldowns:GetModule("Display").db.profile.IAKW then 
		if next(FatCooldowns:GetModule("Display").db.profile.IAKW) then
			for i,word in pairs(FatCooldowns:GetModule("Display").db.profile.IAKW) do
				if text:find("^%s*"..word.."%s*$") then InviteUnit(playerName) end
			end
		end
	end
end

function FatCooldowns:CHAT_MSG_GUILD(eventtype, text, playerName, languageName, channelName, playerName2)
	if FatCooldowns:GetModule("Display").db.profile.IAKW and GetTime() - FatCooldowns.GuildInviteButtonPressed < FatCooldowns:GetModule("Display").db.profile.GuildWordsInvite then 
		if next(FatCooldowns:GetModule("Display").db.profile.IAKW) then
			for i,word in pairs(FatCooldowns:GetModule("Display").db.profile.IAKW) do
				if text:find("^%s*"..word.."%s*$") then InviteUnit(playerName) end
			end
		end
	end
end

local LastSentInspect = 0
function FatCooldowns:INSPECT_TALENT_READY()
	if GetTime() - LastSentInspect > 1 then LastSentInspect = GetTime() self:GetModule("Display"):InspectFrame() end 
end

function FatCooldowns:FillTradeSpells(Type)
	local SpellList = {
		MageDrinks = {
			[5504] = 5350,
			[5505] = 2288,
			[5506] = 2136,
			[6127] = 3772,
			[10138] = 8077,
			[10139] = 8078,
			[10140] = 8079,
			[37420] = 30703,
			[27090] = 22018,
			[42955] = 43518,
			[42956] = 43523,
		},
		MageFood = {
			[587] = 5349,
			[597] = 1113,
			[990] = 1114,
			[6129] = 1487,
			[10144] = 8075,
			[10145] = 8076,
			[28612] = 22895,
			[33717] = 22019,
			[42955] = 43518,
			[42956] = 43523,
		},
		WarlockHealthstone = {
			[6201] = 5512,
			[6202] = 5511,
			[5699] = 5509,
			[11729] = 5510,
			[11730] = 9421,
		},
		WarlockHealthstone2 = {
			[19005] = 5512,
			[19004] = 5512,
			[19007] = 5511,
			[19006] = 5511,
			[19009] = 5509,
			[19008] = 5509,
			[19011] = 5510,
			[19010] = 5510,
			[19013] = 9421,
			[19012] = 9421,
		}
	}
	local TradersLevel = UnitLevel("NPC")
	local HighestItemLevel = nil
	local HighestItemLevel2 = nil
	local SpellFromItem = nil
	for ClassIndex, ClassTable in pairs(SpellList) do
		if Type == ClassIndex then
			for Spell, ItemID in pairs(ClassTable) do
				if IsSpellKnown(Spell) then
					local itemName, itemLink, _, _, itemMinLevel, _, _, itemStackCount, _, itemIcon, _, itemClassID, _, bindType = GetItemInfo(ItemID)
					if TradersLevel ~= nil and itemMinLevel ~= nil and TradersLevel >= itemMinLevel then
						if HighestItemLevel == nil then 
							HighestItemLevel = ItemID
							HighestItemLevel2 = itemMinLevel
							SpellFromItem = Spell
						elseif HighestItemLevel2 < itemMinLevel then 
							HighestItemLevel = ItemID
							HighestItemLevel2 = itemMinLevel
							SpellFromItem = Spell
						end
					end
				end
			end
		end
	end 
	if HighestItemLevel ~= nil then
		return HighestItemLevel, SpellFromItem 
	else
		if Type == "MageDrinks" then 
			return 5350,5504
		elseif Type == "MageFood" then
			return 5349,587
		elseif Type == "WarlockHealthstone" then
			return 5512,6201
		end
	end
end

function FatCooldowns:FillTradeSplit()
	for x = 0, 4 do 
		for y = 1, GetContainerNumSlots(x) do
			local ItemID = GetContainerItemID(x,y)
			if ItemID == nil then
				PickupContainerItem(x,y)
				FatCooldowns:ScheduleTimer(function() self:FillTradePlace(x,y) end, 0.3)
			end
		end
	end
end

function FatCooldowns:FillTradePlace(x,y)
	if x == nil or y == nil then return end
	local ItemID = GetContainerItemID(x,y)
	if ItemID ~= nil then
		PickupContainerItem(x,y)
		local TableSlot = TradeFrame_GetAvailableSlot()
		ClickTradeButton(TableSlot)
	end
end

function FatCooldowns:FillTradeSetting(SettingType)
	if SettingType == "MageDrinks" then
		if UnitInParty("NPC") == nil then
			return true, FatCooldowns:GetModule("Display").db.profile.TradeDrinksSolo
		elseif UnitInRaid("NPC") ~= nil then
			return true, FatCooldowns:GetModule("Display").db.profile.TradeDrinksR
		elseif UnitInParty("NPC") ~= nil then
			return true, FatCooldowns:GetModule("Display").db.profile.TradeDrinksP
		end
	elseif SettingType == "MageFood" then
		if UnitInParty("NPC") == nil then
			return true, FatCooldowns:GetModule("Display").db.profile.TradeFoodSolo
		elseif UnitInRaid("NPC") ~= nil then
			return true, FatCooldowns:GetModule("Display").db.profile.TradeFoodR
		elseif UnitInParty("NPC") ~= nil then
			return true, FatCooldowns:GetModule("Display").db.profile.TradeFoodP
		end
	end
	return false, 0
end

function FatCooldowns:FillTrade(Water,Food,Stone,Lock,ForButton)
	if FatCooldowns:GetModule("Display").db.profile.Trade then
		local SettingD, AmountD = self:FillTradeSetting("MageDrinks")
		local SettingF, AmountF = self:FillTradeSetting("MageFood")
		local ClassNPCFake, ClassNPC = UnitClass("NPC")
		local TradeableDrinks, SpellFromItemDrinks = self:FillTradeSpells("MageDrinks")
		local TradeableFood, SpellFromItemFood = self:FillTradeSpells("MageFood")
		local TradeableStone, SpellFromItemStone = self:FillTradeSpells("WarlockHealthstone")
		local TradeableStone2, SpellFromItemStone2 = self:FillTradeSpells("WarlockHealthstone2")

		if ForButton ~= nil then
			if ForButton == "MageDrinks" then
				return TradeableDrinks, SpellFromItemDrinks, AmountD, ClassNPC
			elseif ForButton == "MageFood" then
				return TradeableFood, SpellFromItemFood, AmountF, ClassNPC
			elseif ForButton == "HealthStone" then
				return TradeableStone, SpellFromItemStone, ClassNPC
			end
			return nil
		end

		for x = 0, 4 do 
			for y = 1, GetContainerNumSlots(x) do
				local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue = GetContainerItemInfo(x,y)
				if itemLink ~= nil then		
					local ItemID = GetContainerItemID(x,y)
					local ItemName, itemLink2, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemLink)
					if UnitClass("player") == L["Mage"] then
						if SettingD and FatCooldowns:GetModule("Display").db.profile.TradeDrinkClasses[ClassNPC] ~= nil and FatCooldowns:GetModule("Display").db.profile.TradeDrinkClasses[ClassNPC] and AmountD > 0 and Water == true then
							if ItemID == TradeableDrinks then
								if itemCount ~= AmountD and itemCount > AmountD and self:BagsFree() > 0 then
									SplitContainerItem(x,y,AmountD)
									self:FillTradeSplit()
									FatCooldowns:ScheduleTimer(function() self:FillTrade(false,Food,Stone,Lock) end, 0.6)
									return
								elseif itemCount == AmountD then
									local TableSlot = TradeFrame_GetAvailableSlot()
									PickupContainerItem(x,y)
									ClickTradeButton(TableSlot)
									FatCooldowns:ScheduleTimer(function() self:FillTrade(false,Food,Stone,Lock) end, 0.6)
									return
								end
							end
						end
						if SettingF and FatCooldowns:GetModule("Display").db.profile.TradeFoodClasses[ClassNPC] ~= nil and FatCooldowns:GetModule("Display").db.profile.TradeFoodClasses[ClassNPC] and AmountF > 0 and Food == true then 
							if ItemID == TradeableFood then
								if itemCount ~= AmountF and itemCount > AmountF and self:BagsFree() > 0 then
									SplitContainerItem(x,y,AmountF)
									self:FillTradeSplit()
									FatCooldowns:ScheduleTimer(function() self:FillTrade(Water,false,Stone,Lock) end, 0.6)
									return
								elseif itemCount == AmountF then
									local TableSlot = TradeFrame_GetAvailableSlot()
									PickupContainerItem(x,y)
									ClickTradeButton(TableSlot)	
									FatCooldowns:ScheduleTimer(function() self:FillTrade(Water,false,Stone,Lock) end, 0.6)
									return
								end
							end
						end
					elseif UnitClass("player") == L["Warlock"] then
						if FatCooldowns:GetModule("Display").db.profile.TradeStone[ClassNPC] ~= nil and FatCooldowns:GetModule("Display").db.profile.TradeStone[ClassNPC] and Stone == true then
							if ItemID == TradeableStone or ItemID == SpellFromItemStone2 then
								local TableSlot = TradeFrame_GetAvailableSlot()
								PickupContainerItem(x,y)
								ClickTradeButton(TableSlot)
								FatCooldowns:ScheduleTimer(function() self:FillTrade(Water,Food,false,Lock) end, 0.6)
								return
							end
						end
					end
					if UnitClass("player") ~= L["Rogue"] then
						local RogueLockBoxes = {
							[5759] = 5759,
							[43622] = 43622,
							[12033] = 12033,
							[4636] = 4636,
							[31952] = 31952,
							[4637] = 4637,
							[5758] = 5758,
							[4632] = 4632,
							[43624] = 43624,
							[5760] = 5760,
							[4638] = 4638,
							[4633] = 4633,
							[4634] = 4634,
							[16884] = 16884,
						}
						if FatCooldowns:GetModule("Display").db.profile.Lockboxes and UnitClass("NPC") == L["Rogue"] and Lock == true then 
							if ItemID ~= nil and RogueLockBoxes[tonumber(ItemID)] then
								PickupContainerItem(x,y)
								ClickTradeButton(TRADE_ENCHANT_SLOT)
								FatCooldowns:ScheduleTimer(function() self:FillTrade(Water,Food,Stone,false) end, 0.6)
								return
							end
						end
					end
				end
			end
		end
	end
end

function FatCooldowns:TRADE_SHOW()
	self:FillTrade(true, true, true, true)
	FatCooldowns:GetModule("Display"):TradeButtons()
end
function FatCooldowns:TRADE_CLOSE()
	FatCooldowns:GetModule("Display"):TradeButtons()
end

function FatCooldowns:ChatBubblesIcons()
	if Prat then
		return 
	else
		self.update = self.update or CreateFrame('Frame');
		self.throttle = 0.1
		self.update:SetScript("OnUpdate", 
		function(frame, elapsed) 
			self.throttle = self.throttle - elapsed
			if frame:IsShown() and self.throttle < 0 then
				self.throttle = 0.1
				self:IterateChatBubbles("FormatCallback")
			end
		end)
		if FatCooldowns:GetModule("Display").db.profile.reporter[98875] then self.update:Show() else self.update:Hide() end
	end
end

local MAX_CHATBUBBLE_WIDTH = 300
function FatCooldowns:FormatCallback(frame, fontstring)
	if not frame:IsShown() then fontstring.lastText = nil return end
	MAX_CHATBUBBLE_WIDTH = math.max(frame:GetWidth(), MAX_CHATBUBBLE_WIDTH)
	local text = fontstring:GetText() or ""
	if text == fontstring.lastText then return end
	if FatCooldowns:GetModule("Display").db.profile.reporter[98875] then
		local term
		for tag in string.gmatch(text, "%b{}") do
			term = strlower(string.gsub(tag, "[{}]", ""))
			if (ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]]) then text = string.gsub(text, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t") end
		end  
	end
	fontstring:SetText(text)    
	fontstring.lastText = text  
	fontstring:SetWidth(math.min(fontstring:GetStringWidth(), MAX_CHATBUBBLE_WIDTH - 14))
end

function FatCooldowns:IterateChatBubbles(funcToCall)
	for i=1,WorldFrame:GetNumChildren() do
		local v = select(i, WorldFrame:GetChildren())
		local b = v:GetBackdrop()
		if b and b.bgFile == "Interface\\Tooltips\\ChatBubble-Background" then
			for i=1,v:GetNumRegions() do
				local frame = v
				local v = select(i, v:GetRegions())
				if v:GetObjectType() == "FontString" then
					local fontstring = v
					if type(funcToCall) == "function" then
						funcToCall(frame, fontstring)
					else 
						self[funcToCall](self, frame, fontstring)
					end
				end
			end
		end
	end
end

function FatCooldowns:GOSSIP_SHOW()
	if FatCooldowns:GetModule("Display").db.profile.reporter[98878] then
		if GetNumGossipActiveQuests() > 0 or GetNumGossipAvailableQuests() > 0 or IsShiftKeyDown() then return end
		if GetNumGossipOptions() == 1 then
			SelectGossipOption(1)
			FatCooldowns:ScheduleTimer(function() self:GOSSIP_SHOW() end, 0.5)
		end
	end
end

function FatCooldowns:ZONE_CHANGED() FCDMountMacro() end
function FatCooldowns:UPDATE_SHAPESHIFT_USABLE() FCDMount(true,true) end

local SavedAddIgnore = nil
local SavedDelIgnore = nil
local SavedAddFriend = nil
local SavedRemoveFriend = nil
local SavedAddOrDelIgnore = nil

local Realm = GetRealmName()
local Faction = UnitFactionGroup("player")

local WarnTimer = {}
function FatCooldowns:PartyWarn()
	if not FatCooldowns:GetModule("Display").db then return end
	if not FatCooldowns:GetModule("Display").db.profile.IShare and not FatCooldowns:GetModule("Display").db.profile.FShare then return end
	if FatCooldowns:GetModule("Display").db.profile.IshareList ~= nil and FatCooldowns:GetModule("Display").db.profile.IshareList[Realm] ~= nil and FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction] ~= nil then
		for IgnoredPlayer in pairs(FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction]) do
			if UnitInRaid(IgnoredPlayer) then
				if FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][IgnoredPlayer] ~= nil and FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][IgnoredPlayer].warn and (WarnTimer[IgnoredPlayer] == nil or GetTime() - WarnTimer[IgnoredPlayer] > 600) then
					local WarningExtraText = FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][IgnoredPlayer].note or ""
					FatCooldowns:ScheduleTimer(function()
						if UnitInRaid(IgnoredPlayer) then 
							RaidNotice_AddMessage(RaidWarningFrame, "FCD Warning: Ignored player "..FCDColorName(IgnoredPlayer).." is in Raid "..WarningExtraText, ChatTypeInfo["RAID_WARNING"])
							FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: Ignored player "..FCDColorName(IgnoredPlayer).." is in Raid "..WarningExtraText)
						end
					end, 2)
					WarnTimer[IgnoredPlayer] = GetTime()
				end
			elseif UnitInParty(IgnoredPlayer) then
				if FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][IgnoredPlayer] ~= nil and FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][IgnoredPlayer].warn and (WarnTimer[IgnoredPlayer] == nil or GetTime() - WarnTimer[IgnoredPlayer] > 600) then
					local WarningExtraText = FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][IgnoredPlayer].note or ""
					FatCooldowns:ScheduleTimer(function() 
						if UnitInParty(IgnoredPlayer) then 
							RaidNotice_AddMessage(RaidWarningFrame, "FCD Warning: Ignored player "..FCDColorName(IgnoredPlayer).." is in Party "..WarningExtraText, ChatTypeInfo["RAID_WARNING"])
							FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: Ignored player "..FCDColorName(IgnoredPlayer).." is in Party "..WarningExtraText)
						end
					end, 2)
					WarnTimer[IgnoredPlayer] = GetTime()
				end
			end
		end
	end
	if FatCooldowns:GetModule("Display").db.profile.FshareList ~= nil and FatCooldowns:GetModule("Display").db.profile.FshareList[Realm] ~= nil and FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction] ~= nil then
		for IgnoredPlayer in pairs(FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction]) do
			if UnitInRaid(IgnoredPlayer) then
				if FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][IgnoredPlayer] ~= nil and FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][IgnoredPlayer].warn and (WarnTimer[IgnoredPlayer] == nil or GetTime() - WarnTimer[IgnoredPlayer] > 600) then
					FatCooldowns:ScheduleTimer(function()
						if UnitInRaid(IgnoredPlayer) then 
							RaidNotice_AddMessage(RaidWarningFrame, "FCD Warning: Friendly player "..FCDColorName(IgnoredPlayer).." is in Raid", ChatTypeInfo["RAID_WARNING"])
							FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: Friendly player "..FCDColorName(IgnoredPlayer).." is in Raid")
						end
					end, 2)
					WarnTimer[IgnoredPlayer] = GetTime()
				end
			elseif UnitInParty(IgnoredPlayer) then
				if FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][IgnoredPlayer] ~= nil and FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][IgnoredPlayer].warn and (WarnTimer[IgnoredPlayer] == nil or GetTime() - WarnTimer[IgnoredPlayer] > 600) then
					FatCooldowns:ScheduleTimer(function() 
						if UnitInParty(IgnoredPlayer) then 
							RaidNotice_AddMessage(RaidWarningFrame, "FCD Warning: Friendly player "..FCDColorName(IgnoredPlayer).." is in Party", ChatTypeInfo["RAID_WARNING"]) 
							FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: Friendly player "..FCDColorName(IgnoredPlayer).." is in Party")
						end
					end, 2)
					WarnTimer[IgnoredPlayer] = GetTime()
				end
			end
		end
	end
	if WarnTimer ~= nil then
		for WarnPlayer, WarnTimer in pairs(WarnTimer) do
			if UnitInRaid("player") then
				if not UnitInRaid(WarnPlayer) then WarnPlayer = nil end
			elseif UnitInParty("player") then
				if not UnitInParty(WarnPlayer) then WarnPlayer = nil end
			else
				WarnPlayer = nil
			end
		end
	end 
end

local LoadedIFShare = false
function FatCooldowns:PLAYER_ENTERING_WORLD()
	FatCooldowns:ScheduleTimer(function() FCDMount(true,true) end, 4)
	FatCooldowns:ScheduleTimer(function() FCDMountMacro() end, 5)
	FatCooldowns:ScheduleTimer(function() FCDDE(1) end, 5)
	self:ChatBubblesIcons()

	if not LoadedIFShare then
		SavedAddIgnore = AddIgnore
		AddIgnore = FCDAddIgnore
		SavedDelIgnore = DelIgnore
		DelIgnore = FCDDelIgnore

		SavedAddOrDelIgnore = AddOrDelIgnore
		AddOrDelIgnore = FCDAddOrDelIgnore

		SavedAddFriend = AddFriend
		AddFriend = FCDAddFriend
		SavedRemoveFriend = RemoveFriend
		RemoveFriend = FCDRemoveFriend

		LoadedIFShare = true

		FatCooldowns:GetModule("Display").db.profile.IshareList[Realm] = FatCooldowns:GetModule("Display").db.profile.IshareList[Realm] or {}
		FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction] = FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction] or {}
		FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm] = FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm] or {}
		FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction] = FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction] or {}

		FatCooldowns:GetModule("Display").db.profile.FshareList[Realm] = FatCooldowns:GetModule("Display").db.profile.FshareList[Realm] or {}
		FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction] = FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction] or {}
		FatCooldowns:GetModule("Display").db.profile.RFshareList[Realm] = FatCooldowns:GetModule("Display").db.profile.RFshareList[Realm] or {}
		FatCooldowns:GetModule("Display").db.profile.RFshareList[Realm][Faction] = FatCooldowns:GetModule("Display").db.profile.RFshareList[Realm][Faction] or {}

		FatCooldowns:GetModule("Display").db.profile.IFShareList2[Realm] = FatCooldowns:GetModule("Display").db.profile.IFShareList2[Realm] or {}
		FatCooldowns:GetModule("Display").db.profile.IFShareList2[Realm][Faction] = FatCooldowns:GetModule("Display").db.profile.IFShareList2[Realm][Faction] or {}

		FatCooldowns:GetModule("Display").db.profile.IFShareList[Realm] = FatCooldowns:GetModule("Display").db.profile.IFShareList[Realm] or {}
		FatCooldowns:GetModule("Display").db.profile.IFShareList[Realm][Faction] = FatCooldowns:GetModule("Display").db.profile.IFShareList[Realm][Faction] or {}

	end
end

function FatCooldowns:FCDCurrentIgnores()
	local TIgnores = GetNumIgnores()
	local CIgnores = {}
	for IgnoredPlayer in pairs(FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction]) do
		if IgnoredPlayer:find("%d") then IgnoredPlayer = nil end
	end

	for i = 1, TIgnores do
		local Name = GetIgnoreName(i)
		if Name and Name ~= UNKNOWN then
			if Name:find("%d") then FCDDelIgnore(Name) else CIgnores[Name] = Name end
		end
	end
	return CIgnores
end

local IgnoredRemoved = {}
function FatCooldowns:IGNORELIST_UPDATE_Delay()
	if not FatCooldowns:GetModule("Display").db then return end
	if not FatCooldowns:GetModule("Display").db.profile.IShare then return end
	for i = 1, 50 do
		if _G["FCDIgnoreNotes" .. i] ~= nil then _G["FCDIgnoreNotes" .. i]:SetText("") end
	end
	for i = 1, 50 do
		if _G["FriendsFrameIgnoreButton" .. i] ~= nil and i ~= 1 then
			local RealIgnoreName = GetIgnoreName(i - 1)
			if RealIgnoreName ~= nil and RealIgnoreName ~= "" and RealIgnoreName ~= "Unknown" and RealIgnoreName ~= Unknown then
				if _G["FCDIgnoreNotes" .. i] == nil then
					_G["FCDIgnoreNotes" .. i] = _G["FriendsFrameIgnoreButton" .. i]:CreateFontString("FCDIgnoreNotesCreated"..i, "OVERLAY", "GameTooltipText")
					_G["FCDIgnoreNotes" .. i]:SetPoint("LEFT", _G["FriendsFrameIgnoreButton" .. i], "LEFT", 95, 0)
					_G["FCDIgnoreNotes" .. i]:SetFont(Media:Fetch("font", FatCooldowns:GetModule("Display").db.profile.fontFace), 11)
					_G["FCDIgnoreNotes" .. i]:SetWidth(_G["FriendsFrameIgnoreButton" .. i]:GetWidth() - 95)
					_G["FCDIgnoreNotes" .. i]:SetHeight(_G["FriendsFrameIgnoreButton" .. i]:GetHeight())
					_G["FCDIgnoreNotes" .. i]:SetText(FatCooldowns:GetModule("Display").db.profile.IshareList[Realm]
						and FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction] and FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][RealIgnoreName]
						and FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][RealIgnoreName].note or "")
					else
					_G["FCDIgnoreNotes" .. i]:SetText(FatCooldowns:GetModule("Display").db.profile.IshareList[Realm]
						and FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction] and FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][RealIgnoreName]
						and FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][RealIgnoreName].note or "")
				end
			end
		end
	end

	local CIgnores = self:FCDCurrentIgnores()
	local weekday, month, day, year = CalendarGetDate()
	for IgnoredPlayer in pairs(FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction]) do
		if FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][IgnoredPlayer].faction == Faction and FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][IgnoredPlayer].realm == Realm and not FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][IgnoredPlayer] and
		not CIgnores[IgnoredPlayer] then
			CIgnores[IgnoredPlayer] = IgnoredPlayer
			AddIgnore(IgnoredPlayer, 1)
			return
		end
	end
	for IgnoredPlayer in pairs(FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction]) do
		if CIgnores[IgnoredPlayer] and not IgnoredRemoved[IgnoredPlayer] then
			CIgnores[IgnoredPlayer] = nil
			DelIgnore(IgnoredPlayer)
			return
		end
	end
end

function FatCooldowns:IGNORELIST_UPDATE()
	if not FatCooldowns:GetModule("Display").db then return end
	if not FatCooldowns:GetModule("Display").db.profile.IShare then return end
	local CIgnores = self:FCDCurrentIgnores()
	local weekday, month, day, year = CalendarGetDate()
	for i, Name in pairs(CIgnores) do
		if not FatCooldowns:GetModule("Display").db.profile.IFShareList[Realm][Faction][UnitName("player")] then
			FatCooldowns:GetModule("Display").db.profile.IFShareList[Realm][Faction][UnitName("player")] = UnitName("player")
			if not FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name] then
				FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name] = {name = Name, date = day, month = month, year = year, note = "", remove = FatCooldowns:GetModule("Display").db.profile.IDefualtTimer, faction = Faction, warn = true, realm = Realm}
			end
		end
		if not FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name] and not FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][Name] then
			FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name] = {name = Name, date = day, month = month, year = year, note = "", remove = FatCooldowns:GetModule("Display").db.profile.IDefualtTimer, faction = Faction, warn = true, realm = Realm}
		elseif FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name] and not FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][Name] and FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name].remove ~= 1 then
			local FileDate = ((FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name].month * 31) + FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name].date + (FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name].year * 365))
			local CurrentDate = ((month * 31) + day + (year * 365))
			local RemovealDate = 1
			if FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name].remove == 2 then RemovealDate = 1
			elseif FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name].remove == 3 then RemovealDate = 7
			elseif FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name].remove == 4 then RemovealDate = 31
			elseif FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name].remove == 5 then RemovealDate = 365
			end
			if CurrentDate - FileDate > RemovealDate then
				FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][Name] = Name
			end
		end
	end
	FatCooldowns:ScheduleTimer(function() FatCooldowns:IGNORELIST_UPDATE_Delay() end, 1)
end

local LastCap = {}
function FCDCapitalize(str)
	if not LastCap[str] then
    	LastCap[str] = string.lower(str):gsub("^%l", string.upper)
    	return LastCap[str]
    else
    	return LastCap[str]
    end
end

function CheckIgnore(Name)
	local CIgnores = FatCooldowns:FCDCurrentIgnores()
	if not IsIgnored(Name) then FCDDelIgnore(Name) end
end


StaticPopupDialogs["FCD_INVITE_CONFIRM"] = {
    text = "Are you sure you want to Ignore %s?",
    button1 = "Yes",
    button2 = "No",
    OnShow = function (self, data, data2)
    	self.editBox:SetText("")
  	    self.editBox:SetAutoFocus(true)
	end,
    OnAccept = function (self, data, data2) end,
	hasEditBox = true,
    OnCancel = function() end,
    timeout = 0,
    hideOnEscape = true,
    whileDead = true,
    hideOnEscape = true,
    EditBoxOnEscapePressed = function(self, data, data2) self:GetParent():Hide() end,
  	EditBoxOnEnterPressed = function(self, data, data2) end,
}

function FCDAddIgnore(Name, AdddonForce)
	if not Name then return end
	if GetNumIgnores() >= 50 then return end
	local RealName = FCDCapitalize(Name)
	if FatCooldowns:GetModule("Display").db then
		if FatCooldowns:GetModule("Display").db.profile.IShare then
			if FatCooldowns:GetModule("Display").db.profile.IgnoreConfirm and AdddonForce == nil then
				StaticPopupDialogs["FCD_INVITE_CONFIRM"].OnAccept = function (self, data, data2)
			    	local text = self.editBox:GetText()
			    	if text == nil then text = "" end
			    	if FatCooldowns:GetModule("Display").db then
						if FatCooldowns:GetModule("Display").db.profile.IShare then
							FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][RealName] = nil
							FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name].note = text end, 1)
						end
					end
					if not IsIgnored(RealName) then SavedAddIgnore(RealName) end
					FatCooldowns:ScheduleTimer(function() FatCooldowns.RefreshFrameListOptionsAndVariables() end, 0.5)
					FatCooldowns:ScheduleTimer(function() CheckIgnore(Name) end, 25)
				end
				StaticPopupDialogs["FCD_INVITE_CONFIRM"].EditBoxOnEnterPressed = function (self, data, data2)
			    	local text = self:GetText()
			    	if text == nil then text = "" end
			    	if FatCooldowns:GetModule("Display").db then
						if FatCooldowns:GetModule("Display").db.profile.IShare then
							FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][RealName] = nil
							FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name].note = text end, 1)
						end
					end
					if not IsIgnored(RealName) then SavedAddIgnore(RealName) end
					FatCooldowns:ScheduleTimer(function() FatCooldowns.RefreshFrameListOptionsAndVariables() end, 0.5)
					FatCooldowns:ScheduleTimer(function() CheckIgnore(Name) end, 25)
					self:GetParent():Hide()
				end
			    StaticPopup_Show("FCD_INVITE_CONFIRM", Name, 1)
			    return
			else
				FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][RealName] = nil
				FatCooldowns:ScheduleTimer(function() FatCooldowns.RefreshFrameListOptionsAndVariables() end, 0.5)
				FatCooldowns:ScheduleTimer(function() CheckIgnore(Name) end, 25)
				if not IsIgnored(RealName) then SavedAddIgnore(RealName) end
				return
			end
		else
			if not IsIgnored(RealName) then SavedAddIgnore(RealName) end
		end
	end
end

function FCDDelIgnore(NameOrIndex)
	local Name = nil
	if type(NameOrIndex) == "string" then
		Name = NameOrIndex
	else
		Name = GetIgnoreName(NameOrIndex)
	end
	if not Name then return end
	local RealName = FCDCapitalize(Name)
	if FatCooldowns:GetModule("Display").db then
		if FatCooldowns:GetModule("Display").db.profile.IShare then
			FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][RealName] = nil
			FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][RealName] = RealName
			IgnoredRemoved[RealName] = RealName
			FatCooldowns:ScheduleTimer(function() IgnoredRemoved[RealName] = nil end, 1)
		end
	end
	if IsIgnored(RealName) then SavedDelIgnore(RealName) end
	FatCooldowns:ScheduleTimer(function() FatCooldowns.RefreshFrameListOptionsAndVariables() end, 0.5)
end

function FCDAddOrDelIgnore(Name, AdddonForce) 
--	if (Name == "" or Name == nil) and UnitName("target") ~= nil then Name = UnitName("target") end
	if not Name or Name == UnitName("player") then return end
	local RealName = FCDCapitalize(Name)
	if FatCooldowns:GetModule("Display").db then
		if FatCooldowns:GetModule("Display").db.profile.IShare then
			if FatCooldowns:GetModule("Display").db.profile.IgnoreConfirm and AdddonForce == nil then
				StaticPopupDialogs["FCD_INVITE_CONFIRM"].OnAccept = function (self, data, data2)
					local text = self.editBox:GetText()
					if text == nil then text = "" end
					if FatCooldowns:GetModule("Display").db then
						if FatCooldowns:GetModule("Display").db.profile.IShare then
							if not IsIgnored(Name) then
								FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][RealName] = nil
							else
								FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][RealName] = nil
								FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][RealName] = RealName
							end
							FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name].note = text end, 1)
						end
					end
					SavedAddOrDelIgnore(Name)
					FatCooldowns:ScheduleTimer(function() FatCooldowns.RefreshFrameListOptionsAndVariables() end, 0.5)
			    end
			    StaticPopupDialogs["FCD_INVITE_CONFIRM"].EditBoxOnEnterPressed = function (self, data, data2)
					local text = self:GetText()
					if text == nil then text = "" end
					if FatCooldowns:GetModule("Display").db then
						if FatCooldowns:GetModule("Display").db.profile.IShare then
							if not IsIgnored(Name) then
								FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][RealName] = nil
							else
								FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][RealName] = nil
								FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][RealName] = RealName
							end
							FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][Name].note = text end, 1)
						end
					end
					SavedAddOrDelIgnore(Name)
					FatCooldowns:ScheduleTimer(function() FatCooldowns.RefreshFrameListOptionsAndVariables() end, 0.5)
					self:GetParent():Hide()
				end
			    StaticPopup_Show("FCD_INVITE_CONFIRM", Name, 2)
			    return
			else
				if not IsIgnored(Name) then
					FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][RealName] = nil
				else
					FatCooldowns:GetModule("Display").db.profile.IshareList[Realm][Faction][RealName] = nil
					FatCooldowns:GetModule("Display").db.profile.RIshareList[Realm][Faction][RealName] = RealName
				end
			end
		end
		SavedAddOrDelIgnore(Name)
		FatCooldowns:ScheduleTimer(function() FatCooldowns.RefreshFrameListOptionsAndVariables() end, 0.5)
	end
end

function FatCooldowns:FCDCurrentFriends()
	local TFriends = GetNumFriends()
	local CFriends = {}
	for i = 1, TFriends do
		local Name = GetFriendInfo(i)
		if Name and Name ~= UNKNOWN then CFriends[Name] = Name end
	end
	return CFriends
end

function FatCooldowns:FRIENDLIST_UPDATE()
	if not FatCooldowns:GetModule("Display").db then return end
	if not FatCooldowns:GetModule("Display").db.profile.FShare then return end
	local CFriends = self:FCDCurrentFriends()
	local weekday, month, day, year = CalendarGetDate()
	for i, Name in pairs(CFriends) do
		if not FatCooldowns:GetModule("Display").db.profile.IFShareList2[Realm][Faction][UnitName("player")] then
			FatCooldowns:GetModule("Display").db.profile.IFShareList2[Realm][Faction][UnitName("player")] = UnitName("player")
			if not FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name] then
				FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name] = {name = Name, date = day, month = month, year = year, note = "", remove = FatCooldowns:GetModule("Display").db.profile.FDefualtTimer, faction = Faction, warn = false, realm = Realm}
			end
		end
		if not FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name] and not FatCooldowns:GetModule("Display").db.profile.RFshareList[Realm][Faction][Name] then
			FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name] = {name = Name, date = day, month = month, year = year, note = "", remove = FatCooldowns:GetModule("Display").db.profile.FDefualtTimer, faction = Faction, warn = false, realm = Realm}
		elseif FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name] and not FatCooldowns:GetModule("Display").db.profile.RFshareList[Realm][Faction][Name] and FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name].remove ~= 1 then
			local FileDate = ((FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name].month * 31) + FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name].date + (FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name].year * 365))
			local CurrentDate = ((month * 31) + day + (year * 365))
			local RemovealDate = 1
			if FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name].remove == 2 then RemovealDate = 1
			elseif FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name].remove == 3 then RemovealDate = 7
			elseif FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name].remove == 4 then RemovealDate = 31
			elseif FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][Name].remove == 5 then RemovealDate = 365
			end
			if CurrentDate - FileDate > RemovealDate then
				FatCooldowns:GetModule("Display").db.profile.RFshareList[Realm][Faction][Name] = Name
			end
		end
	end
	for IgnoredPlayer in pairs(FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction]) do
		if FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][IgnoredPlayer].faction == Faction and FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][IgnoredPlayer].realm == Realm and not FatCooldowns:GetModule("Display").db.profile.RFshareList[Realm][Faction][IgnoredPlayer] and
		not CFriends[IgnoredPlayer] then
			CFriends[IgnoredPlayer] = IgnoredPlayer
			AddFriend(IgnoredPlayer)
		end
	end
	for IgnoredPlayer in pairs(FatCooldowns:GetModule("Display").db.profile.RFshareList[Realm][Faction]) do
		if CFriends[IgnoredPlayer] then
			CFriends[IgnoredPlayer] = nil
			RemoveFriend(IgnoredPlayer)
		end
	end
end

function FCDAddFriend(Name)
	if not Name then return end
	local RealName = FCDCapitalize(Name)
	SavedAddFriend(RealName)
	if FatCooldowns:GetModule("Display").db then
		if FatCooldowns:GetModule("Display").db.profile.FShare then
			FatCooldowns:GetModule("Display").db.profile.RFshareList[Realm][Faction][RealName] = nil
		end
	end
	FatCooldowns:ScheduleTimer(function() FatCooldowns.RefreshFrameListOptionsAndVariables() end, 0.5)
end

function FCDRemoveFriend(NameOrIndex)
	local Name = nil
	if type(NameOrIndex) == "string" then
		Name = NameOrIndex
	else
		Name = GetFriendInfo(NameOrIndex)
	end
	if not Name then return end
	local RealName = FCDCapitalize(Name)
	SavedRemoveFriend(RealName)
	if FatCooldowns:GetModule("Display").db then
		if FatCooldowns:GetModule("Display").db.profile.FShare then
			FatCooldowns:GetModule("Display").db.profile.FshareList[Realm][Faction][RealName] = nil
			FatCooldowns:GetModule("Display").db.profile.RFshareList[Realm][Faction][RealName] = RealName
		end
	end
	FatCooldowns:ScheduleTimer(function() FatCooldowns.RefreshFrameListOptionsAndVariables() end, 0.5)
end


function FatCooldowns:HasFishingPole()
	local mainHandLink = GetInventoryItemLink("player",GetInventorySlotInfo("MainHandSlot"))
	if mainHandLink then
		local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID = GetItemInfo(mainHandLink)
		if itemType == L["Weapon"] and itemSubType == L["Fishing Poles"] then return true else return false end
	end
end


function FatCooldowns:BagPlacer(EmptyBag, LowestBag) if EmptyBag ~= 19 then PutItemInBag(EmptyBag) else PutItemInBag(19 + LowestBag) end end -- PutItemInBackpack()
function FatCooldowns:BagChanger()
	if UnitAffectingCombat("player") then FatCooldowns:ScheduleTimer(function() FatCooldowns:BagChanger() end, 1) return end
	local EmptyBag = 19
	local LowestBag = nil
	local ChangeBag = 0
	for x = 0, 4 do
		local BagID = GetInventoryItemID("player", x + 19)
		if BagID then 
			local itemName, itemLink2, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice = GetItemInfo(BagID)
			if LowestBag == nil or itemLevel < LowestBag then LowestBag = itemLevel ChangeBag = x end
		end
	end
	for x = 0, 4 do
		if EmptyBag == 19 and GetBagName(x) == nil then EmptyBag = EmptyBag + x end
   		for y = 1, GetContainerNumSlots(x) do
			local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue = GetContainerItemInfo(x,y)
			if itemLink ~= nil then
				local itemName, itemLink2, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice = GetItemInfo(itemLink)
				if itemType == L["Container"] and itemSubType == L["Bag"] and LowestBag ~= nil and LowestBag < itemLevel then
					ClearCursor()
					PickupContainerItem(x, y)
				end
			end
		end
	end
	FatCooldowns:ScheduleTimer(function() FatCooldowns:BagPlacer(EmptyBag, ChangeBag) end, 0.1)
end

function FatCooldowns:FCDCanDualWield()
	local itemEquipLoc1 = ""
	local maindHanInfo = GetInventorySlotInfo("MainHandSlot")
	if maindHanInfo ~= nil then
		local mainHandLink = GetInventoryItemLink("player",maindHanInfo)
		if mainHandLink ~= nil then
			local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice = GetItemInfo(mainHandLink)
			if itemEquipLoc ~= nil then itemEquipLoc1 = itemEquipLoc end
		end
	end

	return 
		UnitClass("player") == L["Rogue"] and true or 
		UnitClass("player") == L["Warrior"] and isAbilityKnown(674) and itemEquipLoc1 ~= "INVTYPE_2HWEAPON" and true or 
		UnitClass("player") == L["Shaman"] and isAbilityKnown(674) and itemEquipLoc1 ~= "INVTYPE_2HWEAPON" and true or false
end

local InventoryIDTable = {
	INVTYPE_HEAD = 1,
	INVTYPE_NECK = 2,
	INVTYPE_SHOULDER = 3,
	INVTYPE_CHEST = 5,
	INVTYPE_WAIST = 6,
	INVTYPE_LEGS = 7,
	INVTYPE_FEET = 8,
	INVTYPE_WRIST = 9,
	INVTYPE_HAND = 10,
	INVTYPE_FINGER = {11, 12},
	INVTYPE_TRINKET = {13, 14},
	INVTYPE_CLOAK = 15,
	INVTYPE_WEAPONMAINHAND = 16,
	INVTYPE_2HWEAPON = 16,
	INVTYPE_WEAPON = {16, 17},
	INVTYPE_HOLDABLE = 17,
	INVTYPE_SHIELD = 17,
	INVTYPE_WEAPONOFFHAND = 17,
	INVTYPE_RANGED = 18,
	INVTYPE_RANGEDRIGHT = 18,
	INVTYPE_THROWN = 18,
	INVTYPE_RELIC = 18,
}

local WeaponUsed = {
	["INVTYPE_WEAPON"] = "INVTYPE_WEAPON",
	["INVTYPE_SHIELD"] = "INVTYPE_SHIELD",
	["INVTYPE_WEAPONMAINHAND"] = "INVTYPE_WEAPONMAINHAND",
	["INVTYPE_WEAPONOFFHAND"]  = "INVTYPE_WEAPONOFFHAND",
	["INVTYPE_2HWEAPON"] = "INVTYPE_2HWEAPON",
	["INVTYPE_RANGED"] = "INVTYPE_RANGED",
	["INVTYPE_HOLDABLE"] = "INVTYPE_HOLDABLE",
	["INVTYPE_RANGEDRIGHT"] = "INVTYPE_RANGEDRIGHT",
}
local HuntWeapons = {
	["Crossbows"] = "Crossbows",
	["Bows"] = "Bows",
	["Guns"] = "Guns",
}
local tooltipFrame = CreateFrame("GameTooltip", "FCDAutoGearerTooltip", UIParent, "GameTooltipTemplate")
function FatCooldowns:FCDGearScore(itemLink, IDSlot, tooltipscan)
	local StatsTable = {}
	FCDAutoGearerTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	FCDAutoGearerTooltip:ClearLines()
	FCDAutoGearerTooltip:SetHyperlink(itemLink)
	local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice = GetItemInfo(itemLink)
	local PSpec = "None"
	local SpecCheck, Tree1, Tree2, Tree3 = LGT:GetUnitTalentSpec("player")
	SpecCheck = L[SpecCheck]
	local RoleCheck = LGT:GetUnitRole("player")
	local RoleTank, RoleHealer, RoleDPS = UnitGroupRolesAssigned("player")
	local playerslevel = UnitLevel("player")
	local BSpac = nil
	local TSpac = nil
	local UsedTalents = true

	FatCooldowns:GetModule("Display").db.profile.AGW[FatCooldowns.ExPac] = FatCooldowns:GetModule("Display").db.profile.AGW[FatCooldowns.ExPac] or {}
	FatCooldowns:GetModule("Display").db.profile.AGW[FatCooldowns.ExPac][RClass] = FatCooldowns:GetModule("Display").db.profile.AGW[FatCooldowns.ExPac][RClass] or {}

	if FatCooldowns.DefaultItemWeights[RClass] then
		for m,v in pairs(FatCooldowns.DefaultItemWeights[RClass]) do
			FatCooldowns:GetModule("Display").db.profile.AGW[FatCooldowns.ExPac][RClass][m] = FatCooldowns:GetModule("Display").db.profile.AGW[FatCooldowns.ExPac][RClass][m] or {}
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.AGW[FatCooldowns.ExPac] and FatCooldowns:GetModule("Display").db.profile.AGW[FatCooldowns.ExPac][RClass] then
		BSpac = FatCooldowns:GetModule("Display").db.profile.AGW[FatCooldowns.ExPac][RClass]
	end

	if Tree1 == 0 and Tree2 == 0 and Tree3 == 0 then UsedTalents = false end
	if SpecCheck and playerslevel > 9 and UsedTalents then
		if FatCooldowns.DefaultItemWeights[RClass][SpecCheck] then
			if FClass == L["Druid"] and Tree2 > Tree1 and Tree2 > Tree3 then
				if FatCooldowns.ExPac == 0 and ((not LGT:UnitHasTalent("player", tostring(GetSpellInfo(16954))) and LGT:UnitHasTalent("player", tostring(GetSpellInfo(16958)))) or (not LGT:UnitHasTalent("player", tostring(GetSpellInfo(16966))) and LGT:UnitHasTalent("player", tostring(GetSpellInfo(16929)))) or UnitBuff("player", tostring(GetSpellInfo(9634))) or UnitBuff("player", tostring(GetSpellInfo(5487)))) then
					PSpec = FatCooldowns.DefaultItemWeights[RClass]["Guardian"]
					if BSpac["Guardian"] then TSpac = BSpac["Guardian"] end
					CurrentSpec = "Guardian"
				elseif FatCooldowns.ExPac == 1 and ((LGT:UnitHasTalent("player", tostring(GetSpellInfo(16862))) and LGT:UnitHasTalent("player", tostring(GetSpellInfo(16949))) and LGT:UnitHasTalent("player", tostring(GetSpellInfo(37117)))) or UnitBuff("player", tostring(GetSpellInfo(9634))) or UnitBuff("player", tostring(GetSpellInfo(5487)))) then
					PSpec = FatCooldowns.DefaultItemWeights[RClass]["Guardian"]
					if BSpac["Guardian"] then TSpac = BSpac["Guardian"] end
					CurrentSpec = "Guardian"
				else
					PSpec = FatCooldowns.DefaultItemWeights[RClass][SpecCheck]
					if BSpac[SpecCheck] then TSpac = BSpac[SpecCheck] end
					CurrentSpec = SpecCheck
				end
			elseif IsEquippedItemType("Shields") then
				if FClass == L["Paladin"] and Tree3 > Tree1 then
					PSpec = FatCooldowns.DefaultItemWeights[RClass]["Protection"]
					if BSpac["Protection"] then TSpac = BSpac["Protection"] end
					CurrentSpec = "Protection"
				elseif FClass == L["Warrior"] then
					PSpec = FatCooldowns.DefaultItemWeights[RClass]["Protection"]
					if BSpac["Protection"] then TSpac = BSpac["Protection"] end
					CurrentSpec = "Protection"
				else
					PSpec = FatCooldowns.DefaultItemWeights[RClass][SpecCheck]
					if BSpac[SpecCheck] then TSpac = BSpac[SpecCheck] end
					CurrentSpec = SpecCheck
				end
			else
				PSpec = FatCooldowns.DefaultItemWeights[RClass][SpecCheck]
				if BSpac[SpecCheck] then TSpac = BSpac[SpecCheck] end
				CurrentSpec = SpecCheck
			end
		else 
			PSpec = FatCooldowns.DefaultItemWeights[RClass]["None"]
			if BSpac["None"] then TSpac = BSpac["None"] end
			CurrentSpec = "None"
		end
	else
		PSpec = FatCooldowns.DefaultItemWeights[RClass]["None"]
		if BSpac["None"] then TSpac = BSpac["None"] end
		CurrentSpec = "None"
	end

	if FatCooldowns:GetModule("Display").db.profile.AGDungeon then 
		if not UnitInRaid("player") and GetNumPartyMembers() > 0 then
			if RoleTank == false and RoleHealer == false and RoleDPS == false then else
				if FClass == L["Druid"] then
					if RoleTank and RoleCheck ~= "tank" then
						PSpec = FatCooldowns.DefaultItemWeights[RClass]["Guardian"]
						if BSpac["Guardian"] then TSpac = BSpac["Guardian"] end
						CurrentSpec = "Guardian"
					elseif RoleHealer and RoleCheck ~= "healer" then 
						PSpec = FatCooldowns.DefaultItemWeights[RClass]["Restoration"]
						if BSpac["Restoration"] then TSpac = BSpac["Restoration"] end
						CurrentSpec = "Restoration"
					elseif RoleDPS and RoleCheck ~= "dps" then
						if Tree1 > Tree2 then
							PSpec = FatCooldowns.DefaultItemWeights[RClass]["Balance"]
							if BSpac["Balance"] then TSpac = BSpac["Balance"] end
							CurrentSpec = "Balance"
						else 
							PSpec = FatCooldowns.DefaultItemWeights[RClass]["Feral"]
							if BSpac["Feral"] then TSpac = BSpac["Feral"] end
							CurrentSpec = "Feral"
						end
					end
				elseif FClass == L["Paladin"] then
					if RoleTank and RoleCheck ~= "tank" then 
						PSpec = FatCooldowns.DefaultItemWeights[RClass]["Protection"] 
						if BSpac["Protection"] then TSpac = BSpac["Protection"] end
						CurrentSpec = "Protection"
					elseif RoleHealer and RoleCheck ~= "healer" then
						PSpec = FatCooldowns.DefaultItemWeights[RClass]["Holy"] 
						if BSpac["Holy"] then TSpac = BSpac["Holy"] end
						CurrentSpec = "Holy"
					elseif RoleDPS and RoleCheck ~= "dps" then
						PSpec = FatCooldowns.DefaultItemWeights[RClass]["Retribution"] 
						if BSpac["Retribution"] then TSpac = BSpac["Retribution"] end
						CurrentSpec = "Retribution"
					end
				elseif FClass == L["Death Knight"] then
					if RoleTank and RoleCheck ~= "tank" then 
						PSpec = FatCooldowns.DefaultItemWeights[RClass]["Blood"]
						if BSpac["Blood"] then TSpac = BSpac["Blood"] end
						CurrentSpec = "Blood"
					elseif RoleDPS and RoleCheck ~= "dps" then 
						if Tree2 > Tree3 then
							PSpec = FatCooldowns.DefaultItemWeights[RClass]["Frost"]
							if BSpac["Frost"] then TSpac = BSpac["Frost"] end
							CurrentSpec = "Frost"
						else 
							PSpec = FatCooldowns.DefaultItemWeights[RClass]["Unholy"]
							if BSpac["Unholy"] then TSpac = BSpac["Unholy"] end
							CurrentSpec = "Unholy"
						end
					end
				elseif FClass == L["Priest"] then
					if RoleHealer and RoleCheck ~= "healer" then 
						PSpec = FatCooldowns.DefaultItemWeights[RClass]["Holy"]
						if BSpac["Holy"] then TSpac = BSpac["Holy"] end
						CurrentSpec = "Holy"
					elseif RoleDPS and RoleCheck ~= "dps" then 
						PSpec = FatCooldowns.DefaultItemWeights[RClass]["Shadow"] 
						if BSpac["Shadow"] then TSpac = BSpac["Shadow"] end
						CurrentSpec = "Shadow"
					end
				elseif FClass == L["Shaman"] then
					if RoleHealer and RoleCheck ~= "healer" then
						PSpec = FatCooldowns.DefaultItemWeights[RClass]["Restoration"] 
						if BSpac["Restoration"] then TSpac = BSpac["Restoration"] end
						CurrentSpec = "Restoration"
					elseif RoleDPS and RoleCheck ~= "dps" then
						if Tree2 > Tree1 then
							PSpec = FatCooldowns.DefaultItemWeights[RClass]["Enhancement"]
							if BSpac["Enhancement"] then TSpac = BSpac["Enhancement"] end
							CurrentSpec = "Enhancement"
						else 
							PSpec = FatCooldowns.DefaultItemWeights[RClass]["Elemental"]
							if BSpac["Elemental"] then TSpac = BSpac["Elemental"] end
							CurrentSpec = "Elemental"
						end 
					end
				elseif FClass == L["Warrior"] then
					if RoleTank and RoleCheck ~= "tank" then 
						PSpec = FatCooldowns.DefaultItemWeights[RClass]["Protection"] 
						if BSpac["Protection"] then TSpac = BSpac["Protection"] end
						CurrentSpec = "Protection"
					elseif RoleDPS and RoleCheck ~= "dps" then
						if Tree2 > Tree1 then
							PSpec = FatCooldowns.DefaultItemWeights[RClass]["Fury"]
							if BSpac["Fury"] then TSpac = BSpac["Fury"] end
							CurrentSpec = "Fury"
						else 
							PSpec = FatCooldowns.DefaultItemWeights[RClass]["Arms"]
							if BSpac["Arms"] then TSpac = BSpac["Arms"] end
							CurrentSpec = "Arms"
						end
					end
				end
			end
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.AGSpecOverWrite[UnitName("player")] ~= nil and FatCooldowns:GetModule("Display").db.profile.AGSpecOverWrite[UnitName("player")][GetActiveTalentGroup()] ~= nil and FatCooldowns:GetModule("Display").db.profile.AGSpecOverWrite[UnitName("player")][GetActiveTalentGroup()] ~= "UnSet" then
		PSpec = FatCooldowns.DefaultItemWeights[RClass][FatCooldowns:GetModule("Display").db.profile.AGSpecOverWrite[UnitName("player")][GetActiveTalentGroup()]]
		TSpac = BSpac[FatCooldowns:GetModule("Display").db.profile.AGSpecOverWrite[UnitName("player")][GetActiveTalentGroup()]]
		CurrentSpec = FatCooldowns:GetModule("Display").db.profile.AGSpecOverWrite[UnitName("player")][GetActiveTalentGroup()]
	end

	if tooltipscan ~= nil then
		PSpec = FatCooldowns.DefaultItemWeights[RClass][tooltipscan]
		TSpac = BSpac[tooltipscan]
	end

	if not isSoulbound(nil, nil, itemLink, true) then return 0.0001, false end

	for i = 1, FCDAutoGearerTooltip:NumLines() do
		local textLeft = getglobal("FCDAutoGearerTooltipTextLeft"..i)
		if textLeft then
			local r, g, b = textLeft:GetTextColor()
			local textLeftText = textLeft:GetText()
			local text = select(1,string.gsub(textLeftText:lower(),",",""))
			if i==1 then
				StatsTable.name = textLeft:GetText()
				if StatsTable.name == L["Retrieving item information"] then return 0.0001, false end
			end
			if string.find(text, L["requires level"]) and ((g==0 or r/g>3) and (b==0 or r/b>3) and math.abs(b-g)<0.1 and r>0.5 and textLeftText) then return 0.0001, false end
		end
	end

	for i = 1, FCDAutoGearerTooltip:NumLines() do
		local textLeft = getglobal("FCDAutoGearerTooltipTextLeft"..i)
		if textLeft then
			local r, g, b = textLeft:GetTextColor()
			local textLeftText = textLeft:GetText()
			local text = select(1,string.gsub(textLeftText:lower(),",",""))
			local multiplier = 1.0
			if string.find(text, L["chance to"]) and not string.find(text, L["improves"]) then multiplier = multiplier/3.0 end
			if string.find(text, L["use:"]) then multiplier = multiplier/6.0 end
			if r < 0.8 and g < 0.8 and b < 0.8 and string.find(text, L["set:"]) then multiplier = 0 end
			if string.find(text, L["deal damage"]) then multiplier = multiplier * (PSpec.DamageProc or 0) end

			if string.find(text, L["for [0-9]+ sec%."]) then
				if string.find(text, L["damage and healing"]) then multiplier = multiplier * math.max((PSpec.HealingProc or 0), (PSpec.DamageProc or 0))
				elseif string.find(text, L["healing spells"]) then multiplier = multiplier * (PSpec.HealingProc or 0)
				elseif string.find(text, L["damage spells"]) then multiplier = multiplier * (PSpec.DamageSpellProc or 0)
				end

				if string.find(text, L["melee and ranged"]) then multiplier = multiplier * math.max((PSpec.MeleeProc or 0), (PSpec.RangedProc or 0))
				elseif string.find(text, L["melee attacks"]) then multiplier = multiplier * (PSpec.MeleeProc or 0)
				elseif string.find(text, L["ranged attacks"]) then multiplier = multiplier * (PSpec.RangedProc or 0)
				end
			end
			
			local value = tonumber(string.match(text, "-?[0-9]+%.?[0-9]*")) or 0
			if value then value = value * multiplier else value = 0 end
			if string.find(text, L["unique"]) then StatsTable.unique = 1 end
			local isHealer = LGT:GetUnitRole("player") == "healer" and true or RoleHealer and true or false
			if string.find(text, L["strength"]) then StatsTable.Strength = (StatsTable.Strength or 0) + value end
			if string.find(text, L["agility"]) then StatsTable.Agility = (StatsTable.Agility or 0) + value end
			if string.find(text, L["intellect"]) then StatsTable.Intellect = (StatsTable.Intellect or 0) + value end
			if string.find(text, L["stamina"]) then StatsTable.Stamina = (StatsTable.Stamina or 0) + value end
			if string.find(text, L["spirit"]) then StatsTable.Spirit = (StatsTable.Spirit or 0) + value end
			if string.find(text, L["armor penetration"]) then StatsTable.ArmorPenetration = (StatsTable.ArmorPenetration or 0) + value end
			if string.find(text, L["armor"]) and not string.find(text, L["lowers their armor"]) then StatsTable.Armor = (StatsTable.Armor or 0) + value end
			if string.find(text, L["attack power"]) and not string.find(text, L["when fighting"]) and (not string.find(text, L["forms only"]) or RClass == L["DRUID"]) then StatsTable.AttackPower = (StatsTable.AttackPower or 0) + value end
			
			if ((string.find(text, L["increases spell power"]) or string.find(text, L["increases spell damage"])) or string.find(text, L["damage and healing"]) or
				(string.find(text, L["frost spell damage"]) or string.find(text, L["frost spell power"]) or string.find(text, L["damage done by frost spells and effects"])) and (SpecCheck == "Frost" or RClass == "MAGE" and SpecCheck == "None") or
				(string.find(text, L["fire spell damage"]) or string.find(text, L["fire spell power"]) or string.find(text, L["damage done by fire spells and effects"])) and (SpecCheck == "Fire" or RClass == "MAGE" and SpecCheck == "None") or
				(string.find(text, L["arcane spell damage"]) or string.find(text, L["arcane spell power"]) or string.find(text, L["damage done by arcane spells and effects"])) and (SpecCheck=="Arcane" or RClass=="MAGE" and SpecCheck=="None") or
				(string.find(text, L["shadow spell damage"]) or string.find(text, L["shadow spell power"]) or string.find(text, L["damage done by shadow spells and effects"])) and (RClass == "WARLOCK") or
				(string.find(text, L["nature spell damage"]) or string.find(text, L["nature spell power"]) or string.find(text, L["damage done by nature spells and effects"])) and (SpecCheck == "Balance" or RClass == "DRUID" and SpecCheck == "None") or
				(string.find(text, L["healing"]) and isHealer) or
				(string.find(text, L["increases healing done"]) and isHealer)) then StatsTable.SpellPower = (StatsTable.SpellPower or 0) + value
			end

			if string.find(text, L["hit with spells by"]) or string.find(text, L["spell hit rating by"]) then StatsTable.SpellHit = (StatsTable.SpellHit or 0) + value end
			if string.find(text, L["critical strike with spells by"]) or string.find(text, L["spell critical strike"]) or string.find(text, L["spell critical rating"]) then StatsTable.SpellCrit = (StatsTable.SpellCrit or 0) + value end
			if string.find(text, L["critical strike"]) and (not string.find(text, L["critical strike with spells by"]) and not string.find(text, L["spell critical strike"])) then StatsTable.Crit = (StatsTable.Crit or 0) + value end

			if string.find(text, L["hit by"]) or string.find(text, L["improves hit rating by"]) or string.find(text, L["your hit rating by"]) then StatsTable.Hit = (StatsTable.Hit or 0) + value end
			if string.find(text, L["haste"]) then StatsTable.Haste = (StatsTable.Haste or 0) + value end
			if string.find(text, L["mana per 5"]) or string.find(text, L["mana every 5"]) then StatsTable.Mp5 = (StatsTable.Mp5 or 0) + value end
			if string.find(text, L["meta socket"]) then StatsTable.MetaSockets = (StatsTable.MetaSockets or 0) + 1 end
			if string.find(text, L["red socket"]) then StatsTable.RedSockets = (StatsTable.RedSockets or 0) + 1 end
			if string.find(text, L["yellow socket"]) then StatsTable.YellowSockets = (StatsTable.YellowSockets or 0) + 1 end
			if string.find(text, L["blue socket"]) then StatsTable.BlueSockets = (StatsTable.BlueSockets or 0) + 1 end
			if string.find(text, L["dodge"]) then StatsTable.Dodge = (StatsTable.Dodge or 0) + value end
			if string.find(text, L["parry"]) then StatsTable.Parry = (StatsTable.Parry or 0) + value end
			if string.find(text, L["block"]) then StatsTable.Block = (StatsTable.Block or 0) + value end
			if string.find(text, L["defense"]) then StatsTable.Defense = (StatsTable.Defense or 0) + value end
			if string.find(text, L["experience gained"]) then StatsTable.Experience = (StatsTable.Experience or 0) + value end

			if WeaponUsed[itemEquipLoc] then
				if string.find(text, L["damage per second"]) then
					if FClass == L["Hunter"] and HuntWeapons[L[itemSubType]] == nil then value = value / 100 end
					StatsTable.DPS = (StatsTable.DPS or 0) + value 
				end
				local minDamage, maxDamage = string.match(text, "([0-9]+%.?[0-9]*) ?%- ?([0-9]+%.?[0-9]*) damage")
				if minDamage and maxDamage then
					StatsTable.Damage = (StatsTable.Damage or 0) + ((tonumber(minDamage) + tonumber(maxDamage))/2)
					minDamage, maxDamage = nil, nil
				end
			end
		end
	end

	local Unusable = 0
	if WeaponUsed[itemEquipLoc]  then
		if itemEquipLoc == "INVTYPE_WEAPONMAINHAND" then
			if ((PSpec.weapons == "dagger")	or (PSpec.weapons == "dagger and any"))	and itemSubType ~= L["Daggers"] then Unusable = 1
			elseif PSpec.weapons == "2h" or (PSpec.weapons == "2hDW" and isAbilityKnown(46917)) then Unusable = 2
			end
		elseif itemEquipLoc == "INVTYPE_SHIELD" then
			if (PSpec.weapons ~= "weapon and shield") and (PSpec.weapons ~= "any") then Unusable = 3 end
		elseif itemEquipLoc == "INVTYPE_2HWEAPON" then
			if PSpec.weapons == "weapon and shield" then Unusable = 4
			elseif PSpec.weapons == "dual wield" and FatCooldowns:FCDCanDualWield() and (not isAbilityKnown(46917)) then Unusable = 13
			elseif PSpec.weapons == "2hDW" and isAbilityKnown(46917) then
				if itemSubType == L["Staff"] then Unusable = 5
				elseif itemSubType == L["Polearm"] then Unusable = 6
				end
			end
		elseif itemEquipLoc == "INVTYPE_HOLDABLE" then
			local IsStaff = GetInventoryItemLink("player",16)
			local IsStaff2 = ""
			local IsStaff3 = false
			if IsStaff ~= nil then IsStaff2 = select(9, GetItemInfo(IsStaff)) if IsStaff2 == L["Staves"] then IsStaff3 = true end end
			if PSpec.weapons == "2h" or (PSpec.weapons == "dual wield" and FatCooldowns:FCDCanDualWield()) or PSpec.weapons == "weapon and shield" or IsStaff3 then Unusable = 8 end
		elseif itemEquipLoc == "INVTYPE_WEAPONOFFHAND" then
			if PSpec.weapons == "2h" then Unusable = 9
			elseif PSpec.weapons == "dagger" and itemSubType ~= L["Daggers"] then Unusable = 10
			elseif PSpec.weapons == "weapon and shield" and itemSubType ~= L["shield"] then Unusable = 11
			elseif PSpec.weapons == "dual wield" and FatCooldowns:FCDCanDualWield() and (not isAbilityKnown(46917)) and itemSubType == L["shield"] then Unusable = 12
			end
		elseif itemEquipLoc == "INVTYPE_WEAPON" then
			if PSpec.weapons == "2h" then Unusable = 14
			elseif PSpec.weapons == "2hDW" and isAbilityKnown(46917) then Unusable = 15
			elseif PSpec.weapons == "dagger" and itemSubType ~= L["Daggers"] then Unusable = 16
			elseif IDSlot ~= nil and IDSlot == 17 and PSpec.weapons == "weapon and shield" then Unusable = 17
			end
		end
	end
	if Unusable ~= 0 then return 0.0001, (StatsTable.unique or false) end
	local score = 
		(TSpac.Strength or PSpec.Strength or 0) * (StatsTable.Strength or 0) +
		(TSpac.Agility or PSpec.Agility or 0) * (StatsTable.Agility or 0) +
		(TSpac.Stamina or PSpec.Stamina or 0) * (StatsTable.Stamina or 0) +
		(TSpac.Intellect or PSpec.Intellect or 0) * (StatsTable.Intellect or 0) +
		(TSpac.Spirit or PSpec.Spirit or 0) * (StatsTable.Spirit or 0) +
		(TSpac.Armor or PSpec.Armor or 0) * (StatsTable.Armor or 0) +
		(TSpac.Dodge or PSpec.Dodge or 0) * (StatsTable.Dodge or 0) +
		(TSpac.Parry or PSpec.Parry or 0) * (StatsTable.Parry or 0) +
		(TSpac.Block or PSpec.Block or 0) * (StatsTable.Block or 0) +
		(TSpac.Defense or PSpec.Defense or 0) * (StatsTable.Defense or 0) +
		(TSpac.SpellPower or PSpec.SpellPower or 0) * (StatsTable.SpellPower or 0) +
		(TSpac.SpellPenetration or PSpec.SpellPenetration or 0) * (StatsTable.SpellPenetration or 0) +
		(TSpac.Haste or PSpec.Haste or 0) * (StatsTable.Haste or 0) +
		(TSpac.Mp5 or PSpec.Mp5 or 0) * (StatsTable.Mp5 or 0) +
		(TSpac.AttackPower or PSpec.AttackPower or 0) * (StatsTable.AttackPower or 0) +
		(TSpac.ArmorPenetration or PSpec.ArmorPenetration or 0) * (StatsTable.ArmorPenetration or 0) +
		(TSpac.Crit or PSpec.Crit or 0) * (StatsTable.Crit or 0) +
		(TSpac.SpellCrit or PSpec.SpellCrit or 0) * (StatsTable.SpellCrit or 0) +
		(TSpac.Hit or PSpec.Hit or 0) * (StatsTable.Hit or 0) +
		(TSpac.SpellHit or PSpec.SpellHit or 0) * (StatsTable.SpellHit or 0) +
		(TSpac.RedSockets or PSpec.RedSockets or 0) * (StatsTable.RedSockets or 0) +
		(TSpac.YellowSockets or PSpec.YellowSockets or 0) * (StatsTable.YellowSockets or 0) +
		(TSpac.BlueSockets or PSpec.BlueSockets or 0) * (StatsTable.BlueSockets or 0) +
		(TSpac.MetaSockets or PSpec.MetaSockets or 0) * (StatsTable.MetaSockets or 0) +
		(TSpac.DPS or PSpec.DPS or 0) * (StatsTable.DPS or 0) +
		(TSpac.Damage or PSpec.Damage or 0) * (StatsTable.Damage or 0) +
		(TSpac.Experience or PSpec.Experience or 0) * (StatsTable.Experience or 0)

		if (itemSubType == L["Axes"] or itemSubType == L["One-Handed Axes"] or itemSubType == L["Two-Handed Axes"]) and isAbilityKnown(20574) and (TSpac.Expertise or PSpec.Expertise) then score = score + ((TSpac.Expertise or PSpec.Expertise) * 5) end
		if (itemSubType == L["Swords"] or itemSubType == L["One-Handed Swords"] or itemSubType == L["Two-Handed Swords"]) and isAbilityKnown(20597) and (TSpac.Expertise or PSpec.Expertise) then score = score + ((TSpac.Expertise or PSpec.Expertise) * 5) end
	if score == 0 then return 0.0001, (StatsTable.unique or false) else return score, (StatsTable.unique or false) end
end
function FatCooldowns:ItemChanger(olditemLink, id, IsBind, itemnotinbags)
	if UnitAffectingCombat("player") then FatCooldowns:ScheduleTimer(function() FatCooldowns:ItemChanger(olditemLink, id, IsBind) end, 1) return end
	if IsBind then FatCooldowns.AGUseItem = true end
	local FoundItem = false
	for x = 0, 4 do 
		for y = 1, GetContainerNumSlots(x) do
			local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue = GetContainerItemInfo(x,y)
			if itemLink ~= nil then
				local ItemIDFull = select(3,strfind(itemLink, "|H(.+)|h%["))
				if olditemLink == ItemIDFull then
					FoundItem = true
					PickupContainerItem(x, y)
					EquipCursorItem(id)
				end
			end
		end
	end
	if FoundItem == false and (itemnotinbags == nil or itemnotinbags < 5) then FatCooldowns:ScheduleTimer(function() FatCooldowns:ItemChanger(olditemLink, id, IsBind, (itemnotinbags or 0) + 1) end, 1) end
	if IsBind then FatCooldowns:ScheduleTimer(function() FatCooldowns.AGUseItem = false end, 0.2) end
end

function FatCooldowns:UniqueChecker(Item1, Item2, ItemName1, ItemName2) if Item1 ~= nil and Item1 == true and Item2 ~= nil and Item2 == true and ItemName1 ~= nil and ItemName2 ~= nil and ItemName1 == ItemName2 then return false else return true end end

function FatCooldowns:AutoGearer(message, message2)
	if TrashWorking then FatCooldowns:ScheduleTimer(function() FatCooldowns:AutoGearer(message, message2) end, 1) return end
	if UnitAffectingCombat("player") or UnitIsDead("player") then FatCooldowns:ScheduleTimer(function() FatCooldowns:AutoGearer(message, message2) end, 1) return end

	local pattern1 = LOOT_ITEM_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)"):gsub("^", "^")
	local pattern2 = LOOT_ITEM_PUSHED_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)"):gsub("^", "^")
	local pattern3 = LOOT_ITEM_CREATED_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)"):gsub("^", "^")
	local pattern4 = LOOT_ITEM_SELF:gsub("%%s", "(.+)"):gsub("^", "^")
	local pattern5 = LOOT_ITEM_PUSHED_SELF:gsub("%%s", "(.+)"):gsub("^", "^")
	local pattern6 = LOOT_ITEM_CREATED_SELF:gsub("%%s", "(.+)"):gsub("^", "^")
	local link, quantity = nil, nil

	if message2 ~= nil then link = message2 end
	if not link then link, quantity = message:match(pattern1)
		if not link then 
			link, quantity = message:match(pattern2)
			if not link then 
				link, quantity = message:match(pattern3)
				if not link then 
					quantity, link = 1, message:match(pattern4)
					if not link then 
						quantity, link = 1, message:match(pattern5)
						if not link then 
							quantity, link = 1, message:match(pattern6)
						end
					end
				end
			end
		end
	end
	if link and not IsEquippableItem(link) then return end
	local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice = GetItemInfo(link)
	if FatCooldowns:GetModule("Display").db.profile.AGQuality[itemQuality] == nil or FatCooldowns:GetModule("Display").db.profile.AGQuality[itemQuality] == false then return end
	local IsBind = not isSoulbound(nil, nil, itemLink)
	if IsBind and not FatCooldowns:GetModule("Display").db.profile.AGBind then return end
	if itemType == L["Container"] and itemSubType == L["Bag"] and FatCooldowns:GetModule("Display").db.profile.AGBags then FatCooldowns:BagChanger() return end
	local ItemIDFull = select(3,strfind(link, "|H(.+)|h%["))

	if not FatCooldowns:HasFishingPole() then
		if InventoryIDTable[itemEquipLoc] then
			if type(InventoryIDTable[itemEquipLoc]) == "table" then
				local UsedItem, Unique1 = nil, nil
				local UsedItem2, Unique2 = nil, nil
				local NewItem, UniqueNew = FatCooldowns:FCDGearScore(link)
				local NewItem2, UniqueNew2 = 0.0001, nil
				local itemName2, itemName3 = nil, nil
				local ReplacedItem1, ReplacedItem2 = nil, nil
				if itemEquipLoc == "INVTYPE_WEAPON" then NewItem2, UniqueNew2 = FatCooldowns:FCDGearScore(link, 17) end
				local EQID = nil
				local EQID2 = nil
				local FailSlotCheck = false
				for index, val in pairs(InventoryIDTable[itemEquipLoc]) do
					local ItemCheck = GetInventoryItemLink("player",val)
					if ItemCheck then
						if UsedItem == nil then
							EQID = val
							UsedItem, Unique1 = FatCooldowns:FCDGearScore(ItemCheck, val)
							itemName2 = GetItemInfo(ItemCheck)
							ReplacedItem1 = GetInventoryItemLink("player",val)
						else
							EQID2 = val
							UsedItem2, Unique2 = FatCooldowns:FCDGearScore(ItemCheck, val)
							itemName3 = GetItemInfo(ItemCheck)
							ReplacedItem2 = GetInventoryItemLink("player",val)
						end
					else
						if EQID == nil then EQID = val elseif EQID2 == nil then EQID2 = val end
					end
				end
				if NewItem ~= nil and NewItem == 0.0001 then return end
				if itemEquipLoc == "INVTYPE_WEAPON" then
					if FatCooldowns:FCDCanDualWield() and NewItem2 ~= 0.0001 then
						if UsedItem ~= nil and UsedItem < NewItem and self:UniqueChecker(UniqueNew, Unique2, itemName, itemName3) then
							FatCooldowns:ItemChanger(ItemIDFull, EQID, IsBind)
							if FatCooldowns:GetModule("Display").db.profile.AGPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AG: Replacing "..GetInventoryItemLink("player",EQID).." score: "..UsedItem.." with "..link.." score: "..NewItem) end
							if ReplacedItem1 ~= nil and message2 == nil then FatCooldowns:ScheduleTimer(function() FatCooldowns:AutoGearer(nil, ReplacedItem1) end, 1) end
						elseif UsedItem2 ~= nil and UsedItem2 < NewItem and self:UniqueChecker(UniqueNew, Unique1, itemName, itemName2) then
							FatCooldowns:ItemChanger(ItemIDFull, EQID2, IsBind)
							if FatCooldowns:GetModule("Display").db.profile.AGPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AG: Replacing "..GetInventoryItemLink("player",EQID2).." score: "..UsedItem2.." with "..link.." score: "..NewItem) end
							if ReplacedItem2 ~= nil and message2 == nil then FatCooldowns:ScheduleTimer(function() FatCooldowns:AutoGearer(nil, ReplacedItem2) end, 1) end
						elseif (UsedItem == nil and self:UniqueChecker(UniqueNew, Unique1, itemName, itemName2)) or (UsedItem2 == nil and self:UniqueChecker(UniqueNew, Unique2, itemName, itemName3)) then
							if UsedItem == nil then FatCooldowns:ItemChanger(ItemIDFull, EQID, IsBind) else FatCooldowns:ItemChanger(ItemIDFull, EQID2, IsBind) end
							if FatCooldowns:GetModule("Display").db.profile.AGPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AG: Equipping "..link.." score: "..NewItem) end
						end
					else
						if UsedItem ~= nil and UsedItem < NewItem and self:UniqueChecker(UniqueNew, Unique2, itemName, itemName3) then
							FatCooldowns:ItemChanger(ItemIDFull, EQID, IsBind)
							if FatCooldowns:GetModule("Display").db.profile.AGPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AG: Replacing "..GetInventoryItemLink("player",EQID).." score: "..UsedItem.." with "..link.." score: "..NewItem) end
						elseif UsedItem == nil and self:UniqueChecker(UniqueNew, Unique1, itemName, itemName2) then
							FatCooldowns:ItemChanger(ItemIDFull, EQID, IsBind)
							if FatCooldowns:GetModule("Display").db.profile.AGPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AG: Equipping "..link.." score: "..NewItem) end
						end
					end
				else
					if UsedItem ~= nil and UsedItem2 ~= nil then
						if UsedItem > UsedItem2 and UsedItem2 < NewItem and self:UniqueChecker(UniqueNew, Unique1, itemName, itemName2) then
							FatCooldowns:ItemChanger(ItemIDFull, EQID2, IsBind)
							if FatCooldowns:GetModule("Display").db.profile.AGPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AG: Replacing "..GetInventoryItemLink("player",EQID2).." score: "..UsedItem2.." with "..link.." score: "..NewItem) end
						elseif UsedItem < NewItem and self:UniqueChecker(UniqueNew, Unique2, itemName, itemName3) then
							FatCooldowns:ItemChanger(ItemIDFull, EQID, IsBind)
							if FatCooldowns:GetModule("Display").db.profile.AGPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AG: Replacing "..GetInventoryItemLink("player",EQID).." score: "..UsedItem.." with "..link.." score: "..NewItem) end
						end
					elseif (UsedItem == nil and self:UniqueChecker(UniqueNew, Unique1, itemName, itemName2)) or (UsedItem2 == nil and self:UniqueChecker(UniqueNew, Unique2, itemName, itemName3)) then
						if UsedItem == nil then FatCooldowns:ItemChanger(ItemIDFull, EQID, IsBind) else FatCooldowns:ItemChanger(ItemIDFull, EQID2, IsBind) end
						if FatCooldowns:GetModule("Display").db.profile.AGPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AG: Equipping "..link.." score: "..NewItem) end
					end
				end
			else
				local ItemCheck = GetInventoryItemLink("player",InventoryIDTable[itemEquipLoc])
				if ItemCheck then
					local UsedItem = FatCooldowns:FCDGearScore(ItemCheck, InventoryIDTable[itemEquipLoc])
					local OffWeapon = GetInventoryItemLink("player",17)
					local NewItem = FatCooldowns:FCDGearScore(link)
					if NewItem ~= nil and NewItem == 0.0001 then return end
					if UsedItem and OffWeapon and itemEquipLoc == "INVTYPE_2HWEAPON" then
						local UsedItem2, Unique2 = nil, nil
						if OffWeapon then UsedItem2 = FatCooldowns:FCDGearScore(OffWeapon, 17) end
						if (UsedItem + UsedItem2) < NewItem then
							FatCooldowns:ItemChanger(ItemIDFull, 17, IsBind)
							if FatCooldowns:GetModule("Display").db.profile.AGPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AG: Replacing "..GetInventoryItemLink("player",16).." and "..GetInventoryItemLink("player",17).." total score: "..(UsedItem + UsedItem2).." with "..link.." score: "..NewItem) end
						end
					elseif UsedItem ~= nil and NewItem ~= nil and UsedItem < NewItem then
						FatCooldowns:ItemChanger(ItemIDFull, InventoryIDTable[itemEquipLoc], IsBind)
						if FatCooldowns:GetModule("Display").db.profile.AGPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AG: Replacing "..ItemCheck.." score: "..UsedItem.." with "..link.." score: "..NewItem) end
					end
				else
					local NewItem = FatCooldowns:FCDGearScore(link)
					if NewItem ~= nil and NewItem == 0.0001 then return end
					FatCooldowns:ItemChanger(ItemIDFull, InventoryIDTable[itemEquipLoc], IsBind)
					if FatCooldowns:GetModule("Display").db.profile.AGPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AG: Equipping "..link.." score: "..NewItem) end
				end
			end 
		end
	end
end

function FatCooldowns:CHAT_MSG_LOOT(self,arg1)
	if FatCooldowns:GetModule("Display").db.profile.AGEnable then
		local maxlevel = (FatCooldowns.ExPac == 2 and UnitLevel("player") == 80 and true) or (FatCooldowns.ExPac == 0 and UnitLevel("player") == 60 and true) or (FatCooldowns.ExPac == 1 and UnitLevel("player") == 70 and true) or false
		if FatCooldowns:GetModule("Display").db.profile.AGMaxLvl == false or (FatCooldowns:GetModule("Display").db.profile.AGMaxLvl == true and not maxlevel) then 	
			if (arg1:find("^"..L["Received item:"]) or arg1:find(L["You receive item:"]) or arg1:find(L["You receive loot:"]) or arg1:find(L["You create:"])) then FatCooldowns:ScheduleTimer(function() FatCooldowns:AutoGearer(arg1) end, 2) end
		end
	end
	local instancename, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
	if FatCooldowns:GetModule("Display").db.profile.FishingDerby and arg1:find(L["You receive loot:"]) and arg1:find(L["Blacktip Shark"]) then
		RaidNotice_AddMessage(RaidWarningFrame, arg1, ChatTypeInfo["RAID_WARNING"])
		if FatCooldowns:GetModule("Display").db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
	end
	if FatCooldowns:GetModule("Display").db.profile.reporter[99856] and arg1:find(L["You receive item:"]) and arg1:find(L["Goblin Rocket Pack"]) and instancename == L["Icecrown Citadel"] and not UnitAffectingCombat("player") then
		FatCooldowns:ScheduleTimer(function() EquipItemByName(L["Goblin Rocket Pack"]) end, 0.5)		
	end
	if FatCooldowns:GetModule("Display").db.profile.OculusMounts and arg1:find(L["You create:"]) and (arg1:find(L["Amber Essence"]) or arg1:find(L["Ruby Essence"]) or arg1:find(L["Emerald Essence"])) then
		FatCooldowns:ScheduleTimer(function() FCDMountMacro() end, 0.1)
	end
	if UnitInRaid("player") or GetNumPartyMembers() > 0 then
		if arg1:find(L["receive loot:"]) or arg1:find(L["receives loot:"]) then
			local ItemID = select(3,strfind(arg1, "|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
			local CurrentItemID = tonumber(string.format("%.0f", ItemID))
			local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice = GetItemInfo(ItemID)
			local BlackListTable = {
				[51971] = true,
				[51993] = true,
				[51959] = true,
				[51977] = true,
				[51985] = true,
				[51961] = true,
				[51991] = true,
				[51969] = true,
				[51975] = true,
				[51983] = true,
				[51995] = true,
				[51960] = true,
				[51979] = true,
				[51987] = true,
				[51967] = true,
				[51972] = true,
				[51962] = true,
				[51963] = true,
				[51981] = true,
				[51982] = true,
				[51989] = true,
				[51990] = true,
				[51974] = true,
				[51992] = true,
				[51966] = true,
				[51976] = true,
				[51984] = true,
				[51973] = true,
				[51996] = true,
				[51965] = true,
				[51980] = true,
				[51968] = true,
				[51994] = true,
				[51964] = true,
				[51978] = true,
			}
			local WhiteListTable = {
				[52028] = true,
				[52029] = true,
				[52030] = true,
				[52027] = true,
				[52026] = true,
				[52025] = true,
			}
			if BlackListTable[CurrentItemID] == nil and (itemQuality == 3 or itemQuality == 4) and isSoulbound(nil, nil, itemLink) and ((IsEquippableItem(itemLink) and isSoulbound(nil, nil, itemLink, nil, true)) or WhiteListTable[CurrentItemID]) then 
				FatCooldowns:GetModule("Display"):StartCooldown(itemName, 99038, 7200, nil, nil, nil, nil, CurrentItemID, nil, 1, true, itemQuality)
			end
		end
	end
 end

function FatCooldowns:MAIL_SHOW() MailTimer = self:ScheduleRepeatingTimer(AutoSendMail, 0.8) end

function FatCooldowns:MAIL_CLOSED() self:CancelTimer(MailTimer, true) end
local MailUnfriendly = {[1] = {Name = "", Time = 0}}
local MailError = false
function AutoSendMail()
	if MailError then return end
	if not MailFrame:IsShown() then FatCooldowns:CancelTimer(MailTimer, true) return end
	local ClearMail = false
	for MaxMail = 1, 12 do
		if not ClearMail and GetSendMailItem(MaxMail) ~= nil then ClearMail = true end
	end
	if ClearMail then ClearSendMail() end
	ClearMail = false

	local ReamlId = GetRealmName()
	if FatCooldowns:GetModule("Display").db.profile.AutoMailerPlayers ~= nil and not IsShiftKeyDown() then
		if next(FatCooldowns:GetModule("Display").db.profile.AutoMailerPlayers) then
			local OldMailer = SendMailNameEditBox:GetText()
			for MailPlayers, MailerFaction in pairs(FatCooldowns:GetModule("Display").db.profile.AutoMailerPlayers) do	
				if MailerFaction == MailPlayers or MailerFaction == UnitFactionGroup("player") then
					if FatCooldowns:GetModule("Display").db.profile.AMMinIlvl[MailPlayers] == nil then FatCooldowns:GetModule("Display").db.profile.AMMinIlvl[MailPlayers] = 277 end			
					if FatCooldowns:GetModule("Display").db.profile.LootMailerList[MailPlayers] ~= nil or (FatCooldowns:GetModule("Display").db.profile.AMExtra[MailPlayers] ~= nil and
						(FatCooldowns:GetModule("Display").db.profile.AMExtra[MailPlayers][2] == true or FatCooldowns:GetModule("Display").db.profile.AMExtra[MailPlayers][3] == true or FatCooldowns:GetModule("Display").db.profile.AMExtra[MailPlayers][4] == true)) then
						if strlower(MailPlayers) ~= strlower(UnitName("player")) and (next(FatCooldowns:GetModule("Display").db.profile.LootMailerList[MailPlayers]) or (FatCooldowns:GetModule("Display").db.profile.AMExtra[MailPlayers] ~= nil and
							(FatCooldowns:GetModule("Display").db.profile.AMExtra[MailPlayers][2] == true or FatCooldowns:GetModule("Display").db.profile.AMExtra[MailPlayers][3] == true or FatCooldowns:GetModule("Display").db.profile.AMExtra[MailPlayers][4] == true))) and
							FatCooldowns:GetModule("Display").db.profile.Realms[MailPlayers] ~= nil and FatCooldowns:GetModule("Display").db.profile.Realms[MailPlayers][ReamlId] then
							for x = 0, 4 do 
					   			for y = 1, GetContainerNumSlots(x) do
									local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue = GetContainerItemInfo(x,y)
									if itemLink ~= nil and not isSoulbound(x, y) then
										local ItemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemLink)
										local ItemID = tostring(GetContainerItemID(x,y))

										if ItemID ~= nil and ItemName ~= nil and GetSendMailItem(12) == nil and
											((FatCooldowns:GetModule("Display").db.profile.LootMailerList[MailPlayers] ~= nil and FatCooldowns:GetModule("Display").db.profile.LootMailerList[MailPlayers][ItemID] ~= nil and
												FatCooldowns:GetModule("Display").db.profile.LootMailerList[MailPlayers][ItemID] == ItemID) or
											(FatCooldowns:GetModule("Display").db.profile.AMExtra[MailPlayers][itemRarity] ~= nil and FatCooldowns:GetModule("Display").db.profile.AMExtra[MailPlayers][itemRarity] and FatCooldowns:GetModule("Display").db.profile.AMMinIlvl[MailPlayers] ~= nil and FatCooldowns:GetModule("Display").db.profile.AMMinIlvl[MailPlayers] > itemLevel and IsEquippableItem(itemLink) and isSoulbound(x, y, nil, nil, true)))
											then
												if (FatCooldowns:GetModule("Display").db.profile.AMItemType[MailPlayers][1] == false and itemType == L["Weapon"]) or (FatCooldowns:GetModule("Display").db.profile.AMItemType[MailPlayers][2] == false and itemType == L["Armor"]) then
												else
													SendMailNameEditBox:SetText(MailPlayers)
													PickupContainerItem(x, y)
													ClickSendMailItemButton(MailCount)
												end
										elseif ItemID ~= nil and ItemName ~= nil and GetSendMailItem(12) ~= nil and 
											((FatCooldowns:GetModule("Display").db.profile.LootMailerList[MailPlayers] ~= nil and FatCooldowns:GetModule("Display").db.profile.LootMailerList[MailPlayers][ItemID] ~= nil and
												FatCooldowns:GetModule("Display").db.profile.LootMailerList[MailPlayers][ItemID] == ItemID) or 
											(FatCooldowns:GetModule("Display").db.profile.AMExtra[MailPlayers][itemRarity] ~= nil and FatCooldowns:GetModule("Display").db.profile.AMExtra[MailPlayers][itemRarity] and FatCooldowns:GetModule("Display").db.profile.AMMinIlvl[MailPlayers] ~= nil and FatCooldowns:GetModule("Display").db.profile.AMMinIlvl[MailPlayers] > itemLevel and IsEquippableItem(itemLink) and isSoulbound(x, y, nil, nil, true)))
											then
											if SendMailNameEditBox:GetText() ~= MailPlayers then if OldMailer ~= nil then SendMailNameEditBox:SetText(OldMailer) end return end
											if SendMailNameEditBox:GetText() == MailPlayers then
												SendMail(MailPlayers, SendMailSubjectEditBox:GetText() or SendMailSubjectEditBox:SetText("FCDAutoMail"), "")
												MailUnfriendly[1].Name = MailPlayers MailUnfriendly[1].Time = GetTime()
												if not FatCooldowns:GetModule("Display").db.profile.SilentMailer then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AutoMailer: Sending mail to "..MailPlayers) end
											end
											if OldMailer ~= nil then SendMailNameEditBox:SetText(OldMailer) end
											return
										end
									end
								end
							end
							local MailCount = 0
							for MaxMail = 1, 12 do
							if GetSendMailItem(MaxMail) ~= nil then MailCount = MailCount + 1 end
							end
							if MailCount ~= 0 then
								if SendMailNameEditBox:GetText() ~= MailPlayers then if OldMailer ~= nil then SendMailNameEditBox:SetText(OldMailer) end return end
								if SendMailNameEditBox:GetText() == MailPlayers then
									SendMail(MailPlayers, SendMailSubjectEditBox:GetText() or SendMailSubjectEditBox:SetText("FCDAutoMail"), "")
									MailUnfriendly[1].Name = MailPlayers MailUnfriendly[1].Time = GetTime()
									if not FatCooldowns:GetModule("Display").db.profile.SilentMailer then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AutoMailer: Sending mail to "..MailPlayers) end
								end
								if OldMailer ~= nil then SendMailNameEditBox:SetText(OldMailer) end
								return
							end
						end
					end
				end
			end
		end
	end
	FatCooldowns:CancelTimer(MailTimer, true)
end

function FatCooldowns:PLAYER_ENTERING_BATTLEGROUND()
	local _, zone40 = IsInInstance()
	if zone40 == "arena" then self:GetModule("Display"):Reset() end
end

function FatCooldowns:UI_ERROR_MESSAGE(event,msg) 
	if FatCooldowns:GetModule("Display").db.profile.AutoMailerPlayers ~= nil and next(FatCooldowns:GetModule("Display").db.profile.AutoMailerPlayers) then
		if msg == L["Internal mail database error."] then
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AutoMailer: Internal Mail Database Error - Continue in 10 seconds.")
			MailError = true
			self:ScheduleTimer(function() MailError = false end, 10)
		elseif msg == "That bag is full." then
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AutoMailer: Recipient's Mailbox is full.")
			MailError = true
			self:ScheduleTimer(function() MailError = false end, 10)
		elseif msg == "Target is unfriendly." and MailUnfriendly[1] ~= nil and MailUnfriendly[1].Name ~= nil and GetTime() - MailUnfriendly[1].Time < 1 and FatCooldowns:GetModule("Display").db.profile.AutoMailerPlayers[MailUnfriendly[1].Name] ~= nil then
			local FactionCanMail = {["Alliance"] = "Horde", ["Horde"] = "Alliance"}
			FatCooldowns:GetModule("Display").db.profile.AutoMailerPlayers[MailUnfriendly[1].Name] = FactionCanMail[UnitFactionGroup("player")]
		end
	end
end
--[[
function FatCooldowns:UI_INFO_MESSAGE(event,msg) 
	if FatCooldowns:GetModule("Display").db.profile.AltTab and FatCooldowns:GetModule("Display").db.profile.BGAltTab and msg:find("Your group has joined the queue for Random Battleground") then
		self:SetSound()
	end
end
]]
function FatCooldowns:UPDATE_BATTLEFIELD_STATUS()
	if (FatCooldowns:GetModule("Display").db.profile.SSBG or FatCooldowns:GetModule("Display").db.profile.SSArena) then
		local winner = GetBattlefieldWinner()
		local isArena = IsActiveBattlefieldArena()
		local SSTaken = false
		if winner == nil then SSTaken = true end
		if not SSTaken then
			if not isArena then
				if winner and FatCooldowns:GetModule("Display").db.profile.SSBG then
					self:FCDTakeScreenShot("BG")
					SSTaken = true
				end
			else
				if not SSTaken and FatCooldowns:GetModule("Display").db.profile.SSArena then 
					self:FCDTakeScreenShot("Arena")
					SSTaken = true
				end
			end
		end
	end
--	if FatCooldowns:GetModule("Display").db.profile.AltTab ~= nil and FatCooldowns:GetModule("Display").db.profile.AltTab and FatCooldowns:GetModule("Display").db.profile.BGAltTab ~= nil and FatCooldowns:GetModule("Display").db.profile.BGAltTab then
--		for i = 1, MAX_BATTLEFIELD_QUEUES do
--			local status, mapName, instanceID = GetBattlefieldStatus(i)
--			if status == L["confirm"] then	self:AltTabPlaySound() break end
--		end
--	end
end
--[[
function FatCooldowns:LFG_PROPOSAL_SHOW() 
	if FatCooldowns:GetModule("Display").db.profile.AltTab and FatCooldowns:GetModule("Display").db.profile.RDFAltTab then
		self:AltTabPlaySound()
	end
end]]

function FatCooldowns:PetSpellsScan()  
	local SpellsLvlPrint = {}
	local playerlevel = UnitLevel("player")
	for i = 1, 80 do
		if i <= playerlevel then
			SpellsLvlPrint[i] = SpellsLvlFill(i,true)
		end
	end
end

function FatCooldowns:CHAT_MSG_SYSTEM(event,msg)  
--	if FatCooldowns:GetModule("Display").db.profile.AltTab and FatCooldowns:GetModule("Display").db.profile.RDFAltTab and msg:find(L["You are now queued in the Dungeon Finder"]) then
--		self:ScheduleTimer(function() self:SetSound() end, 0.1)
--	elseif FatCooldowns:GetModule("Display").db.profile.AltTab and FatCooldowns:GetModule("Display").db.profile.RDFAltTab and msg:find(L["You are no longer queued in the Dungeon Finder"]) then
--		self:ScheduleTimer(function() self:ResetSound() end, 0.1)
--	elseif FatCooldowns:GetModule("Display").db.profile.AltTab and FatCooldowns:GetModule("Display").db.profile.RDFAltTab and msg:find(L["Someone has declined the dungeon invite. You have been returned to the front of the dungeon queue"]) then
--		self:SetSound()
	if FatCooldowns:GetModule("Display").db.profile.SpellLvlLearn and msg:find(L["Your pet has learned a new spell:"]) then
		self:ScheduleTimer(function() self:PetSpellsScan() end, 1)
	end
end
--[[
function FatCooldowns:SetSound(force)
	if not FatCooldowns:GetModule("Display").db.profile.AltTab or UnitAffectingCombat("player") or HasLFGRestrictions() then return end
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
end]]

GameTooltip:HookScript("OnShow",function(self) 
		local point, relativeTo, relativePoint = self:GetPoint()
		if FatCooldowns:GetModule("Display").db.profile.GameTooltipHide and UnitAffectingCombat("player") and point == "BOTTOMRIGHT" and relativeTo == UIParent and relativePoint == "BOTTOMRIGHT" then
			if FatCooldowns:GetModule("Display").db.profile.GameTooltipHideShift and IsShiftKeyDown() then
				self:Show()
			else
				self:Hide()
			end 
		else
			self:Show()
		end
	end) 

function FatCooldowns:UPDATE_INSTANCE_INFO(event, name)
	FatCooldowns:GetModule("Display"):UpdateRF()
end

function FatCooldowns:UNIT_EXITED_VEHICLE(event, name)
  	if UnitName("boss1") == L["The Lich King"] and name:find("raid") and FatCooldowns.ExPac == 2 then
  		self:ValkScanner(event,name)
  		name = UnitName(name)
	end
end

function FatCooldowns:SetGroupLoot2()
  	if IsRaidLeader() and UnitName("boss1") == nil then 
  		SetLootMethod("group")
  		if FatCooldowns:GetModule("Display").db.profile.GLOnBossTH ~= nil then self:ScheduleTimer(function() SetLootThreshold(FatCooldowns:GetModule("Display").db.profile.GLOnBossTH) end, 1) end
	 end
end

function FatCooldowns:SetGroupLoot()
	local instancename, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
  	if FatCooldowns:GetModule("Display").db.profile.GLOnBoss and 
  		((not FatCooldowns:GetModule("Display").db.profile.LCLICC and not FatCooldowns:GetModule("Display").db.profile.LCLRS and not FatCooldowns:GetModule("Display").db.profile.LCLNaxx and not FatCooldowns:GetModule("Display").db.profile.LCLULD) or 
  		(FatCooldowns:GetModule("Display").db.profile.LCLICC and instancename == L["Icecrown Citadel"]) or 
  		(FatCooldowns:GetModule("Display").db.profile.LCLRS and instancename == L["The Ruby Sanctum"]) or 
  		(FatCooldowns:GetModule("Display").db.profile.LCLNaxx and instancename == L["Naxxramas"]) or 
  		(FatCooldowns:GetModule("Display").db.profile.LCLULD and instancename == L["Ulduar"]))	then
  		local lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()
  		if UnitInRaid("player") and IsRaidLeader() and lootmethod ~= "group" then
  			self:ScheduleTimer(function() self:SetGroupLoot2() end, (FatCooldowns:GetModule("Display").db.profile.MLGLDelay or 40))
  		end
  	end
	if FatCooldowns:GetModule("Display").db.profile.reporter[99872] then
		for q=1, GetNumQuestLogEntries() do
			local title, level, _, _, _, _, isComplete = GetQuestLogTitle(q)
			if title == L["Deprogramming"] and level == 80 and isComplete == -1 then
				SelectQuestLogEntry(q)
				SetAbandonQuest()
				AbandonQuest()
			end
		end
	end
end

function FatCooldowns:SetMasterLoot2()
  	if IsRaidLeader() and UnitName("boss1") ~= nil then
		SetLootMethod("master", FatCooldowns:GetModule("Display").db.profile.MLOnBossName)
		if FatCooldowns:GetModule("Display").db.profile.MLOnBossTH ~= nil then self:ScheduleTimer(function() SetLootThreshold(FatCooldowns:GetModule("Display").db.profile.MLOnBossTH) end, 1) end
  	end
end

function FatCooldowns:SetMasterLoot()
	local instancename, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
	if FatCooldowns:GetModule("Display").db.profile.MLOnBoss and 
  		((not FatCooldowns:GetModule("Display").db.profile.LCLICC and not FatCooldowns:GetModule("Display").db.profile.LCLRS and not FatCooldowns:GetModule("Display").db.profile.LCLNaxx and not FatCooldowns:GetModule("Display").db.profile.LCLULD) or 
  		(FatCooldowns:GetModule("Display").db.profile.LCLICC and instancename == L["Icecrown Citadel"]) or 
  		(FatCooldowns:GetModule("Display").db.profile.LCLRS and instancename == L["The Ruby Sanctum"]) or 
  		(FatCooldowns:GetModule("Display").db.profile.LCLNaxx and instancename == L["Naxxramas"]) or 
  		(FatCooldowns:GetModule("Display").db.profile.LCLULD and instancename == L["Ulduar"]))	then
		if FatCooldowns:GetModule("Display").db.profile.MLOnBossName == nil or (FatCooldowns:GetModule("Display").db.profile.MLOnBossName ~= nil and not UnitInRaid(FatCooldowns:GetModule("Display").db.profile.MLOnBossName)) then
			FatCooldowns:GetModule("Display").db.profile.MLOnBossName = UnitName("player")
		end
	end
  	if FatCooldowns:GetModule("Display").db.profile.MLOnBoss then
  		local lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()
  		if UnitInRaid("player") and IsRaidLeader() and lootmethod ~= "master" then
  			self:ScheduleTimer(function() self:SetMasterLoot2() end, 1)
  		end
  	end
end

function FatCooldowns:DeleteItems()
	if FatCooldowns:GetModule("Display").db.profile.EnablePopup then
		if (AuctionFrame ~= nil and AuctionFrame:IsShown()) or MailFrame:IsShown() then TempDeleteItems = true return end
		TrashWorking = true
		if FatCooldowns:GetModule("Display").db.profile.ADList2 ~= nil then
			for x = 0, 4 do 
		   		for y = 1, GetContainerNumSlots(x) do
		   			local icon, itemCount, locked, quality, readable, lootable, itemLink2, isFiltered, noValue = GetContainerItemInfo(x,y)
					if itemLink2 ~= nil then
						local ItemName, itemLink3, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemLink2)
						local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(itemLink2, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
						local ItemIDFull = select(3,strfind(itemLink2, "|H(.+):.+|h%["))
			   			local QuestItem = GetContainerItemQuestInfo(x,y)
						local StackSizeAndPrice = ""
						if itemSellPrice == nil then itemSellPrice = 0 end
						if itemCount ~= nil and itemCount ~= 0 then StackSizeAndPrice = " x"..itemCount.."  "..GetCoinTextureString((itemSellPrice * itemCount)) end

						if ItemIDFull ~= nil and QuestItem ~= nil and QuestItem and FatCooldowns:GetModule("Display").db.profile.ADList2[ItemIDFull] == nil then ItemIDFull = nil end
						if ItemIDFull ~= nil and FatCooldowns:GetModule("Display").db.profile.ADList2[ItemIDFull] == ItemIDFull then
							FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD AD: Destorying "..itemLink2..StackSizeAndPrice)
		   					PickupContainerItem(x,y)
	           				DeleteCursorItem()
       						self:ScheduleTimer(function() self:DeleteItems() end, 0.6)
       						return
	           			end
	               	end
	            end
	        end
	    end
		if FatCooldowns:GetModule("Display").db.profile.KeepSpaceFree > self:BagsFree() then
			local ItemsToDelete = {}
			local ItemsToDeletePrice = {}
			local DelItem = false
			for x = 0, 4 do 
	   			for y = 1, GetContainerNumSlots(x) do
					local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue = GetContainerItemInfo(x,y)
					if itemLink ~= nil then
						local QuestItem = GetContainerItemQuestInfo(x,y)
						local ItemID = tostring(GetContainerItemID(x,y))
						local ItemName, itemLink2, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemLink)
						local TempSell = false
						local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
						local ItemIDFull = select(3,strfind(itemLink, "|H(.+):.+|h%["))
						local StackSizeAndPrice = ""
						if itemSellPrice == nil then itemSellPrice = 0 end
						if itemCount ~= nil and itemCount ~= 0 then StackSizeAndPrice = " x"..itemCount.." "..GetCoinTextureString((itemSellPrice * itemCount)) end

						if QuestItem ~= nil and QuestItem and FatCooldowns:GetModule("Display").db.profile.SellList2[ItemIDFull] == nil then itemLink = nil end
						if itemLink then
							if FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[1] ~= nil and FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[1] == true and FatCooldowns:GetModule("Display").db.profile.SellList2[ItemIDFull] == nil and itemType == L["Consumable"] and itemSubType == L["Food & Drink"] and
								UnitLevel("player") - itemLevel > FatCooldowns:GetModule("Display").db.profile.FoodLvl and itemLevel < 70 and itemSubType ~= L["Miscellaneous"] and DontSellItems[ItemName] == nil then
									TempSell = true
							end
							if FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[2] ~= nil and FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[2] == true and FatCooldowns:GetModule("Display").db.profile.SellList2[ItemIDFull] == nil and itemType == L["Consumable"] and
								itemSubType == "Scroll" and itemLevel < 70 then TempSell = true end
							if FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[3] ~= nil and FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[3] == true and FatCooldowns:GetModule("Display").db.profile.SellList2[ItemIDFull] == nil and quality == 1 and 
								IsEquippableItem(itemLink) and isSoulbound(x, y, nil, nil, true) and itemSubType ~= L["Miscellaneous"] and DontSellItems[ItemName] == nil and itemSubType ~= L["Fishing Poles"] and itemEquipLoc ~= "INVTYPE_TABARD" and Enchant == "0" and Gem1 == "0" and Gem2 == "0" and Gem3 == "0" and Gem4 == "0" then
								TempSell = true
							end
							if FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[4] ~= nil and FatCooldowns:GetModule("Display").db.profile.ExraAutoSell[4] == true and FatCooldowns:GetModule("Display").db.profile.SellList2[ItemIDFull] == nil and itemType == L["Recipe"] and itemSubType ~= L["Book"] then TempSell = true end
							if (itemRarity == 0 or FatCooldowns:GetModule("Display").db.profile.SellList2[ItemIDFull] == ItemIDFull or TempSell) and (itemSellPrice * itemCount) < FatCooldowns:GetModule("Display").db.profile.PriceRange then
								ItemsToDeletePrice[#ItemsToDeletePrice + 1] = (itemSellPrice * itemCount)
								ItemsToDelete[(itemSellPrice * itemCount)] = {bag = x, slot = y, itemLink = itemLink, ItemName = ItemName, ExtraInfo = StackSizeAndPrice}
								DelItem = true
							end
							TempSell = false
						end
					end
	   			end
	   		end
	   		if ItemsToDelete ~= nil and ItemsToDeletePrice ~= nil and DelItem then
	   			self:SortTableNum(ItemsToDeletePrice)
	   			if not FatCooldowns:GetModule("Display").db.profile.SellSilence and ItemsToDelete[ItemsToDeletePrice[1]] ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Destorying "..ItemsToDelete[ItemsToDeletePrice[1]].itemLink..ItemsToDelete[ItemsToDeletePrice[1]].ExtraInfo) end
	   			PickupContainerItem(ItemsToDelete[ItemsToDeletePrice[1]].bag, ItemsToDelete[ItemsToDeletePrice[1]].slot)
             	DeleteCursorItem()
				self:ScheduleTimer(function() self:DeleteItems() end, 0.6)
				return
	   		end
	   	end
	   	TempDeleteItems = true
	else 
		TempDeleteItems = true
	end
	TrashWorking = false
end

function FatCooldowns:LOOT_OPENED() 
	if UnitInRaid("player") and FatCooldowns:GetModule("Display").db.profile.MLAutoLoot then 
		for x = 1, GetNumRaidMembers() do
			if UnitName("player") == UnitName("raid"..x) then 
				local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(x)
				local instancename, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
				if isML and ((not FatCooldowns:GetModule("Display").db.profile.MLLICC and not FatCooldowns:GetModule("Display").db.profile.MLLRS and not FatCooldowns:GetModule("Display").db.profile.MLLNaxx and not FatCooldowns:GetModule("Display").db.profile.MLLULD) or 
			  		(FatCooldowns:GetModule("Display").db.profile.MLLICC and instancename == L["Icecrown Citadel"]) or 
			  		(FatCooldowns:GetModule("Display").db.profile.MLLRS and instancename == L["The Ruby Sanctum"]) or 
			  		(FatCooldowns:GetModule("Display").db.profile.MLLNaxx and instancename == L["Naxxramas"]) or 
			  		(FatCooldowns:GetModule("Display").db.profile.MLLULD and instancename == L["Ulduar"]))	then 
					for y = 1, GetNumRaidMembers() do
						if GetMasterLootCandidate(y) == UnitName("player") then 
							for l = 1, GetNumLootItems() do
								if GetLootSlotLink(l) ~= nil then
									local ItemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(GetLootSlotLink(l))
									local RLItemID = select(3,strfind(itemLink, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
									if RLItemID ~= nil then
										if (FatCooldowns:GetModule("Display").db.profile.MasterLootBlackList2[RLItemID] ~= nil and FatCooldowns:GetModule("Display").db.profile.MasterLootBlackList2[RLItemID] == RLItemID) or
											(FatCooldowns:GetModule("Display").db.profile.MLQuality[itemRarity] ~= nil and FatCooldowns:GetModule("Display").db.profile.MLQuality[itemRarity] == false) then 
										else 
											if not IsShiftKeyDown() then
												GiveMasterLoot(l, y)
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
end

--------------[[		Events		]]--------------
function FatCooldowns:UNIT_INVENTORY_CHANGED(event, arg1)
	if arg1 == "player" and CustomUnitClass("player") == L["Warlock"] and FatCooldowns:GetModule("Display").db.profile.SoulStoneCount ~= nil and FatCooldowns:GetModule("Display").db.profile.SoulStoneCount ~= 0 then
		local SSCount = GetItemCount(L["Soul Shard"])
		for x = 0, 4 do 
   			for y = 1, GetContainerNumSlots(x) do
				if (SSCount > 0 and SSCount > FatCooldowns:GetModule("Display").db.profile.SoulStoneCount) then
    				local link = GetContainerItemLink(x,y)
    				if (link and (GetItemInfo(link) == L["Soul Shard"])) and UnitAffectingCombat("player") then
             			PickupContainerItem(x,y)
             			DeleteCursorItem()
             			self:ScheduleTimer(function() self:UNIT_INVENTORY_CHANGED(event, "player") end, 0.5)
             			return
             		end
             	end
         	end
     	end
	end
	if arg1 == "player" and TempDeleteItems then TempDeleteItems = false self:ScheduleTimer(function() self:DeleteItems() end, 0.5) end
end

function FatCooldowns:SetIconOnPlayer()
	if FatCooldowns:GetModule("Display").db.profile.KeepIcon2Toggle == true and FatCooldowns:GetModule("Display").db.profile.KeepIcon1Toggle == true then 
		if FatCooldowns:GetModule("Display").db.profile.KeepIcon2 ~= nil then
			if ((UnitInRaid("player") and not UnitInRaid(FatCooldowns:GetModule("Display").db.profile.KeepIcon2)) or (not UnitInRaid("player") and not UnitInParty(FatCooldowns:GetModule("Display").db.profile.KeepIcon2))) and FatCooldowns:GetModule("Display").db.profile.KeepIcon2 ~= "Target" then
				FatCooldowns:GetModule("Display").db.profile.KeepIcon2 = nil
			end
		end
		if FatCooldowns:GetModule("Display").db.profile.KeepIcon1 ~= nil then 
			if ((UnitInRaid("player") and not UnitInRaid(FatCooldowns:GetModule("Display").db.profile.KeepIcon1)) or (not UnitInRaid("player") and not UnitInParty(FatCooldowns:GetModule("Display").db.profile.KeepIcon1))) and FatCooldowns:GetModule("Display").db.profile.KeepIcon1 ~= "Target" then
				FatCooldowns:GetModule("Display").db.profile.KeepIcon1 = nil
			end
		end
		if FatCooldowns:GetModule("Display").db.profile.KeepIcon2 ~= nil and FatCooldowns:GetModule("Display").db.profile.KeepIcon1 ~= nil then 
			if FatCooldowns:GetModule("Display").db.profile.KeepIcon2Icon == FatCooldowns:GetModule("Display").db.profile.KeepIcon1Icon then
				FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD KeepIcons: Warning both icons are the same please change")
				ScanIcons = true
				return
			end
			if FatCooldowns:GetModule("Display").db.profile.KeepIcon2 == FatCooldowns:GetModule("Display").db.profile.KeepIcon1 then
				FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD KeepIcons: Warning both names are the same please change")
				ScanIcons = true
				return
			end
		end
	end
	if (UnitInRaid("player") and (IsRaidLeader() or IsRaidOfficer())) or (not UnitInRaid("player") and UnitInParty("player")) or FatCooldowns:GetModule("Display").db.profile.KeepIcon2 == "Target" or FatCooldowns:GetModule("Display").db.profile.KeepIcon1 == "Target" then
		if FatCooldowns:GetModule("Display").db.profile.KeepIcon1Toggle == true and FatCooldowns:GetModule("Display").db.profile.KeepIcon1 ~= nil and 
			(UnitInRaid(FatCooldowns:GetModule("Display").db.profile.KeepIcon1) or FatCooldowns:GetModule("Display").db.profile.KeepIcon1 == "Target" or UnitInParty(FatCooldowns:GetModule("Display").db.profile.KeepIcon1)) and FatCooldowns:GetModule("Display").db.profile.KeepIcon1Icon ~= nil then
			if GetRaidTargetIndex(FatCooldowns:GetModule("Display").db.profile.KeepIcon1) ~= (FatCooldowns:GetModule("Display").db.profile.KeepIcon1Icon - 1) then
				if ((FatCooldowns:GetModule("Display").db.profile.KeepIcon1InRaid and UnitInRaid("player")) or not FatCooldowns:GetModule("Display").db.profile.KeepIcon1InRaid) and 
					((FatCooldowns:GetModule("Display").db.profile.KeepIcon1NotInRaid and not UnitInRaid("player")) or not FatCooldowns:GetModule("Display").db.profile.KeepIcon1NotInRaid) and 
					((FatCooldowns:GetModule("Display").db.profile.KeepIcon1Boss and UnitName("boss1") ~= nil) or not FatCooldowns:GetModule("Display").db.profile.KeepIcon1Boss) and 
					((FatCooldowns:GetModule("Display").db.profile.KeepIcon1NoBoss and UnitName("boss1") == nil) or not FatCooldowns:GetModule("Display").db.profile.KeepIcon1NoBoss) then
					if FatCooldowns:GetModule("Display").db.profile.KeepIcon1 == "Target" then
						if ((FatCooldowns:GetModule("Display").db.profile.KeepIcon1Tank and LGT:GetUnitRole("player") == "tank") or not FatCooldowns:GetModule("Display").db.profile.KeepIcon1Tank) and 
							((FatCooldowns:GetModule("Display").db.profile.KeepIcon1Healer and LGT:GetUnitRole("player") == "healer") or not FatCooldowns:GetModule("Display").db.profile.KeepIcon1Healer) and
							((FatCooldowns:GetModule("Display").db.profile.KeepIcon1DPS and (LGT:GetUnitRole("player") == "caster" or LGT:GetUnitRole("player") == "melee")) or not FatCooldowns:GetModule("Display").db.profile.KeepIcon1DPS) and
							((FatCooldowns:GetModule("Display").db.profile.KeepIcon1Hostile and UnitCanAttack("player","target")) or not FatCooldowns:GetModule("Display").db.profile.KeepIcon1Hostile) and
							(FatCooldowns:GetModule("Display").db.profile.KeepIcon2 == nil or (UnitName("target") ~= nil and UnitName("target") ~= FatCooldowns:GetModule("Display").db.profile.KeepIcon2)) then
							local SetIcon = false
							if FatCooldowns:GetModule("Display").db.profile.KeepIcon1TargetNames == 0 then SetIcon = true
							else
								for ITD, SetName in pairs(FatCooldowns:GetModule("Display").db.profile.KeepIcon1TargetNames) do
									if UnitName("target") == SetName then SetIcon = true end
								end
							end
							if SetIcon then SetRaidTarget(FatCooldowns:GetModule("Display").db.profile.KeepIcon1, FatCooldowns:GetModule("Display").db.profile.KeepIcon1Icon - 1) end
						else
						end
					else 
						SetRaidTarget(FatCooldowns:GetModule("Display").db.profile.KeepIcon1, FatCooldowns:GetModule("Display").db.profile.KeepIcon1Icon - 1)
					end
				end
			end
		end
		if FatCooldowns:GetModule("Display").db.profile.KeepIcon2Toggle == true and FatCooldowns:GetModule("Display").db.profile.KeepIcon2 ~= nil and
			(UnitInRaid(FatCooldowns:GetModule("Display").db.profile.KeepIcon2) or FatCooldowns:GetModule("Display").db.profile.KeepIcon2 == "Target" or UnitInParty(FatCooldowns:GetModule("Display").db.profile.KeepIcon2)) and FatCooldowns:GetModule("Display").db.profile.KeepIcon2Icon ~= nil then
			if GetRaidTargetIndex(FatCooldowns:GetModule("Display").db.profile.KeepIcon2) ~= (FatCooldowns:GetModule("Display").db.profile.KeepIcon2Icon - 1) then
				if ((FatCooldowns:GetModule("Display").db.profile.KeepIcon2InRaid and UnitInRaid("player")) or not FatCooldowns:GetModule("Display").db.profile.KeepIcon2InRaid) and 
					((FatCooldowns:GetModule("Display").db.profile.KeepIcon2NotInRaid and not UnitInRaid("player")) or not FatCooldowns:GetModule("Display").db.profile.KeepIcon2NotInRaid) and 
					((FatCooldowns:GetModule("Display").db.profile.KeepIcon2Boss and UnitName("boss1") ~= nil) or not FatCooldowns:GetModule("Display").db.profile.KeepIcon2Boss) and 
					((FatCooldowns:GetModule("Display").db.profile.KeepIcon2NoBoss and UnitName("boss1") == nil) or not FatCooldowns:GetModule("Display").db.profile.KeepIcon2NoBoss) then
					if FatCooldowns:GetModule("Display").db.profile.KeepIcon2 == "Target" then
						if ((FatCooldowns:GetModule("Display").db.profile.KeepIcon2Tank and LGT:GetUnitRole("player") == "tank") or not FatCooldowns:GetModule("Display").db.profile.KeepIcon2Tank) and 
							((FatCooldowns:GetModule("Display").db.profile.KeepIcon2Healer and LGT:GetUnitRole("player") == "healer") or not FatCooldowns:GetModule("Display").db.profile.KeepIcon2Healer) and
							((FatCooldowns:GetModule("Display").db.profile.KeepIcon2DPS and (LGT:GetUnitRole("player") == "caster" or LGT:GetUnitRole("player") == "melee")) or not FatCooldowns:GetModule("Display").db.profile.KeepIcon2DPS) and
							((FatCooldowns:GetModule("Display").db.profile.KeepIcon2Hostile and UnitCanAttack("player","target")) or not FatCooldowns:GetModule("Display").db.profile.KeepIcon2Hostile) and
							(FatCooldowns:GetModule("Display").db.profile.KeepIcon1 == nil or (UnitName("target") ~= nil and UnitName("target") ~= FatCooldowns:GetModule("Display").db.profile.KeepIcon1)) then
							local SetIcon = false
							if 	FatCooldowns:GetModule("Display").db.profile.KeepIcon2TargetNames == 0 then SetIcon = true
							else
								for ITD, SetName in pairs(FatCooldowns:GetModule("Display").db.profile.KeepIcon2TargetNamesSet) do
									if UnitName("target") == SetName then SetIcon = true end
								end
							end
							if SetIcon then SetRaidTarget(FatCooldowns:GetModule("Display").db.profile.KeepIcon2, FatCooldowns:GetModule("Display").db.profile.KeepIcon2Icon - 1) end
						else
						end
					else 
						SetRaidTarget(FatCooldowns:GetModule("Display").db.profile.KeepIcon2, FatCooldowns:GetModule("Display").db.profile.KeepIcon2Icon - 1)
					end
				end
			end
		end
	end
	self:ScheduleTimer(function() self:SetIconOnPlayer() end, 0.2)
end

function FatCooldowns:PLAYER_TARGET_CHANGED()
	if FatCooldowns:GetModule("Display").db.profile.KeepIcon2Toggle == true or FatCooldowns:GetModule("Display").db.profile.KeepIcon1Toggle == true then 
		if (FatCooldowns:GetModule("Display").db.profile.KeepIcon2 ~= nil and FatCooldowns:GetModule("Display").db.profile.KeepIcon2 == "Target") or
		(FatCooldowns:GetModule("Display").db.profile.KeepIcon1 ~= nil and FatCooldowns:GetModule("Display").db.profile.KeepIcon1 == "Target") then
			if ScanIcons then ScanIcons = false self:ScheduleTimer(function() self:SetIconOnPlayer() end, 0.4) end
		end
	end
end

function FatCooldowns:RAID_TARGET_UPDATE()
	if FatCooldowns:GetModule("Display").db.profile.KeepIcon2Toggle == true or FatCooldowns:GetModule("Display").db.profile.KeepIcon1Toggle == true then 
		if ScanIcons then ScanIcons = false self:ScheduleTimer(function() self:SetIconOnPlayer() end, 0.4) end
	end
end

function FatCooldowns:CHAT_MSG_RAID_BOSS_EMOTE(event, text, playerName, _, _, playerName2)
	if UnitName("boss1") == L["Blood-Queen Lana'thel"] and playerName2 == UnitName("player") then
		if FatCooldowns:GetModule("Display").db.profile.BQL then
			AlertFrameFlashScreen(
				FatCooldowns:GetModule("Display").db.profile.BQLColor["r"],
				FatCooldowns:GetModule("Display").db.profile.BQLColor["g"],
				FatCooldowns:GetModule("Display").db.profile.BQLColor["b"],
				FatCooldowns:GetModule("Display").db.profile.BQLColor["a"])
		end
	end
	if playerName == L["Prince Taldaram"] and playerName2 ~= nil then
		if text:find(L["Empowered Flames speed toward"]) then
			local info = "Empowered Flames on "..playerName2.." run!"
			self:GetModule("Display"):chatreporter(playerName, 99967, 1,playerName2, nil, nil, nil, nil, info)
		end
	end
end

local VerSender = ""
function FatCooldowns:CHAT_MSG_ADDON(event, prefix, msg, channel, sender, target, ...) 
	if event == "CHAT_MSG_ADDON" and msg == "FCDVerSend" then
		if sender == UnitName("player") then VerSender = UnitName("player") else VerSender = "" end
		self:SendCommMessage("FRCD3LShekles", self:Serialize(FatCooldowns.FCDVer), (select(2, IsInInstance()) == "pvp" and "BATTLEGROUND") or (GetNumRaidMembers() > 0 and "RAID") or "PARTY", target)
	end
end

function FatCooldowns:Promo()
	if next(FatCooldowns:GetModule("Display").db.profile.AutoAssist) then
		if GetNumGuildMembers() > 0 and FatCooldowns:GetModule("Display").db.profile.AutoAssist[GetGuildInfo("player")] ~= nil then
			if UnitInRaid("player") and not UnitAffectingCombat("player") and IsRaidLeader() then
				local Ranks = {}
				for i = 1, GuildControlGetNumRanks() do
					local rankName = GuildControlGetRankName(i)
					if Ranks[rankName] == nil then Ranks[rankName] = i end
				end
				for x = 1, GetNumGuildMembers() do
					local name, rankName = GetGuildRosterInfo(x)
					if UnitInRaid(name) then
						for i = 1, GetNumRaidMembers() do
							local PlayerNamePromo, PlayerRankPromo = GetRaidRosterInfo(i)
							if name == PlayerNamePromo and PlayerRankPromo == 0 and Ranks[rankName] ~= nil and Ranks[FatCooldowns:GetModule("Display").db.profile.AutoAssist[GetGuildInfo("player")]] ~= nil and
								Ranks[rankName] <= Ranks[FatCooldowns:GetModule("Display").db.profile.AutoAssist[GetGuildInfo("player")]] then
									PromoteToAssistant(name)
							end
						end
					end
				end	
			end
		end
	end
end

function FatCooldowns:PartyRolesUpdate()
	local members = nil
	local UpdatedRoles = false
	if UnitInRaid("player") then
		members = GetNumRaidMembers()
	else
		members = GetNumPartyMembers() + 1
	end
	if members == 1 then return end	
	
	local RoleTypes = {["healer"] = 3, ["tank"] = 2, ["caster"] = 4, ["melee"] = 4, [""] = 1}
	for i = 1,members,1 do
		if UnitInRaid("player") then
			local PlayersCurrentRole = LGT:GetUnitRole("raid"..i) and RoleTypes[LGT:GetUnitRole("raid"..i)] or 1
			local PlayersCurrentName = UnitName("raid"..i)
			local PlayersCurrentLevel = UnitLevel("raid"..i)
			local PlayersCurrentClass = UnitClass("raid"..i)
			local PlayersCurrentFaction = UnitFactionGroup("raid"..i)
			
			if PlayersCurrentFaction == UnitFactionGroup("player") then
				if FatCooldowns.PlayersRole[PlayersCurrentName] == nil then
					FatCooldowns.PlayersRole[PlayersCurrentName] = {Level = PlayersCurrentLevel, Class = PlayersCurrentClass, Role = PlayersCurrentRole}
					UpdatedRoles = true
				else
					FatCooldowns.PlayersRole[PlayersCurrentName].Level = PlayersCurrentLevel
					FatCooldowns.PlayersRole[PlayersCurrentName].Class = PlayersCurrentClass
					if FatCooldowns.PlayersRole[PlayersCurrentName].Role ~= PlayersCurrentRole then
						if FatCooldowns.PlayersRole[PlayersCurrentName].Role == 1 then
							FatCooldowns.PlayersRole[PlayersCurrentName].Role = PlayersCurrentRole
						elseif FatCooldowns.PlayersRole[PlayersCurrentName].Role == 2 then
							if PlayersCurrentRole == 3 then
								FatCooldowns.PlayersRole[PlayersCurrentName].Role = 5
							elseif PlayersCurrentRole == 4 then
								FatCooldowns.PlayersRole[PlayersCurrentName].Role = 6
							end
						elseif FatCooldowns.PlayersRole[PlayersCurrentName].Role == 3 then
							if PlayersCurrentRole == 2 then
								FatCooldowns.PlayersRole[PlayersCurrentName].Role = 5
							elseif PlayersCurrentRole == 4 then
								FatCooldowns.PlayersRole[PlayersCurrentName].Role = 7
							end
						elseif FatCooldowns.PlayersRole[PlayersCurrentName].Role == 4 then
							if PlayersCurrentRole == 2 then
								FatCooldowns.PlayersRole[PlayersCurrentName].Role = 6
							elseif PlayersCurrentRole == 3 then
								FatCooldowns.PlayersRole[PlayersCurrentName].Role = 7
							end
						end
					end
				end
			end
		elseif not UnitInRaid("player") and i <= GetNumPartyMembers() then
			local PlayersCurrentRole = LGT:GetUnitRole("party"..i) and RoleTypes[LGT:GetUnitRole("party"..i)] or 1
			local PlayersCurrentName = UnitName("party"..i)
			local PlayersCurrentLevel = UnitLevel("party"..i)
			local PlayersCurrentClass = UnitClass("party"..i)
		 	local Role1, Role2, Role3 = UnitGroupRolesAssigned("party"..i)
	 		local HasRole = Role1 and Role1 or Role2 and Role2 or Role3 and Role3 or true and false
			local PlayersCurrentFaction = UnitFactionGroup("party"..i)

	 		if HasRole then
	 			if Role1 then PlayersCurrentRole = 2
	 			elseif Role2 then PlayersCurrentRole = 3
	 			elseif Role3 then PlayersCurrentRole = 4
	 			end
	 		end
			
			if PlayersCurrentFaction == UnitFactionGroup("player") then
				if FatCooldowns.PlayersRole[PlayersCurrentName] == nil then
					FatCooldowns.PlayersRole[PlayersCurrentName] = {Level = PlayersCurrentLevel, Class = PlayersCurrentClass, Role = PlayersCurrentRole}
					UpdatedRoles = true
				else
					FatCooldowns.PlayersRole[PlayersCurrentName].Level = PlayersCurrentLevel
					FatCooldowns.PlayersRole[PlayersCurrentName].Class = PlayersCurrentClass
					if FatCooldowns.PlayersRole[PlayersCurrentName].Role ~= PlayersCurrentRole then
						if FatCooldowns.PlayersRole[PlayersCurrentName].Role == 1 then
							FatCooldowns.PlayersRole[PlayersCurrentName].Role = PlayersCurrentRole
						elseif FatCooldowns.PlayersRole[PlayersCurrentName].Role == 2 then
							if PlayersCurrentRole == 3 then
								FatCooldowns.PlayersRole[PlayersCurrentName].Role = 5
							elseif PlayersCurrentRole == 4 then
								FatCooldowns.PlayersRole[PlayersCurrentName].Role = 6
							end
						elseif FatCooldowns.PlayersRole[PlayersCurrentName].Role == 3 then
							if PlayersCurrentRole == 2 then
								FatCooldowns.PlayersRole[PlayersCurrentName].Role = 5
							elseif PlayersCurrentRole == 4 then
								FatCooldowns.PlayersRole[PlayersCurrentName].Role = 7
							end
						elseif FatCooldowns.PlayersRole[PlayersCurrentName].Role == 4 then
							if PlayersCurrentRole == 2 then
								FatCooldowns.PlayersRole[PlayersCurrentName].Role = 6
							elseif PlayersCurrentRole == 3 then
								FatCooldowns.PlayersRole[PlayersCurrentName].Role = 7
							end
						end
					end
				end
			end
		end
	end
	if UpdatedRoles then 
		FatCooldowns:RefreshFrameListOptionsAndVariables()
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
	end
end

function FatCooldowns:PARTY_MEMBERS_CHANGED(event)
	self:PartyWarn()
	RaidPlayersNames()
	self:Promo()
	FatCooldowns:GetModule("Display"):TalentItemScan("True")
	FatCooldowns:GetModule("Display"):UpdateRF()
	if not UnitAffectingCombat("player") then
		if event == "PARTY_MEMBERS_CHANGED" and IsRaidLeader() and not UnitInBattleground("player") then
			self:SendCommMessage("FRCD3LShekles", self:Serialize("FCDLEADER"), ((select(2, IsInInstance()) == "pvp" and "BATTLEGROUND") or (GetNumRaidMembers() > 0 and "RAID") or "PARTY"), target)
		elseif event == "PARTY_MEMBERS_CHANGED" and IsRaidOfficer() and not UnitInBattleground("player") then
			self:SendCommMessage("FRCD3LShekles", self:Serialize("FCDOFFICER"), ((select(2, IsInInstance()) == "pvp" and "BATTLEGROUND") or (GetNumRaidMembers() > 0 and "RAID") or "PARTY"), target)
		elseif event == "PARTY_MEMBERS_CHANGED" and not IsRaidLeader() and not IsRaidOfficer() then
			self:SendCommMessage("FRCD3LShekles", self:Serialize("FCDPLAYER"), ((select(2, IsInInstance()) == "pvp" and "BATTLEGROUND") or (GetNumRaidMembers() > 0 and "RAID") or "PARTY"), target)
		end
	end
	self:ScheduleTimer(function() self:RaidScan() end, 2)
	if FatCooldowns:GetModule("Display").db.profile.PlayerRole then self:ScheduleTimer(function() self:PartyRolesUpdate() end, 4) end
end

function FatCooldowns:UNIT_SPELLCAST_SENT(event, ...)
	local arg1, arg2, arg3, arg4 = ...
	local senderbackup = arg1
	local spellnamebackup = arg2
	local targetnamebackup = arg4

	if arg3 == L["Summon"] and arg1 == "player" then self:ScheduleTimer(function() self:SpellsPrintRun(true) end, 0.5)  end

	if (UnitInRaid(arg1) and arg1:find("raid[%d]+")) or (UnitInParty(arg1) and arg1:find("party[%d]+")) or arg1 == "player" then senderbackup = UnitName(arg1) end

	if senderbackup ~= nil and senderbackup:find("[%a]+%-[%a]+") and CustomUnitIsPlayer(senderbackup) then
		local realscrnameone, realscrnametwo = select(3, senderbackup:find("(%a+)%-(%a+)"))
		senderbackup = realscrnameone
	end
	if targetnamebackup ~= nil and targetnamebackup:find("^[%a]+%-[%a]+$") and CustomUnitIsPlayer(targetnamebackup) then
		local realscrnameone, realscrnametwo = select(3, targetnamebackup:find("(%a+)%-(%a+)"))
		targetnamebackup = realscrnameone
	end
	backuptargetid[senderbackup] = targetnamebackup
	backuptargetspellname[senderbackup] = spellnamebackup
end

function FatCooldowns:DreamWalkerStackChecker()
	if FatCooldowns:GetModule("Display").db.profile.reporter[98984] then
		local instancename, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
		local DebuffName = L["Twisted Nightmares"]
		if difficultyID == 1 or difficultyID == 2 then DebuffName = L["Emerald Vigor"] end
		if UnitName("boss1") == L["Valithria Dreamwalker"] and UnitHealth("boss1") / UnitHealthMax("boss1") < 0.99 then
			for playername, playerstacks in pairs(DreamDebuffs) do
				for i = 1, GetNumRaidMembers(), 1 do
					if UnitName("raid"..i) == playername then
						local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("raid"..i, DebuffName)
						if count == nil then
							self:GetModule("Display"):chatreporter(playerName, 98984, nil, nil, nil, nil, nil, nil, "FCD: "..UnitName("raid"..i).." has lost stacks, current stacks 0")
							DreamDebuffs[UnitName("raid"..i)] = nil
						elseif count < playerstacks then
							self:GetModule("Display"):chatreporter(playerName, 98984, nil, nil, nil, nil, nil, nil, "FCD: "..UnitName("raid"..i).." has lost stacks, current stacks "..count)
							if count == nil or count == 0 then
								DreamDebuffs[UnitName("raid"..i)] = nil
							else
								DreamDebuffs[UnitName("raid"..i)] = count
							end
						end
					end
				end
			end
		end
	end
end

function FatCooldowns:UNIT_SPELLCAST_SUCCEEDED(event, ...)
	local arg1, arg2, arg3 = ...

	if FatCooldowns.ExPac == 1 and arg2 == "Gnomish Battle Chicken" then
		local senderbackup = arg1
		if UnitInRaid("player") then
			if not senderbackup:find("raid") then return end
				senderbackup = UnitName(arg1)
				FatCooldowns:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED", nil, "SPELL_CAST_SUCCESS", nil, senderbackup, 1297, nil, senderbackup, nil, 23133, "Gnomish Battle Chicken")
		elseif not UnitInRaid("player") and GetNumPartyMembers() >= 1 then
			if not senderbackup:find("player") then
				if not senderbackup:find("party") then return end
				senderbackup = UnitName(arg1)
				FatCooldowns:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED", nil, "SPELL_CAST_SUCCESS", nil, senderbackup, 1297, nil, senderbackup, nil, 23133, "Gnomish Battle Chicken")
			elseif senderbackup:find("player") then
				senderbackup = UnitName("player")
				FatCooldowns:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED", nil, "SPELL_CAST_SUCCESS", nil, senderbackup, 1297, nil, senderbackup, nil, 23133, "Gnomish Battle Chicken")
			end
		elseif not UnitInRaid("player") and GetNumPartyMembers() == 0 then
			if senderbackup == "player" then 
				senderbackup = UnitName("player")
				FatCooldowns:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED", nil, "SPELL_CAST_SUCCESS", nil, senderbackup, 1297, nil, senderbackup, nil, 23133, "Gnomish Battle Chicken")
			else return end
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[98934] and (arg1:find("raid[%d]+") or arg1:find("party[%d]+") or arg1:find("player")) and (arg2 == L["Crashin' Thrashin' Racer Controller"] or arg2 == L["Blue Crashin' Thrashin' Racer Controller"]) then
		if UnitInRaid("player") and arg1:find("raid[%d]+") then self:GetModule("Display"):chatreporter(UnitName(arg1), 98934, 1,dstName, nil, nil, nil, 49352)
		elseif not UnitInRaid("player") and (arg1:find("party[%d]+") or arg1:find("player")) then self:GetModule("Display"):chatreporter(UnitName(arg1), 98934, 1,dstName, nil, nil, nil, 75111)
		end
	end 

	if FatCooldowns:GetModule("Display").db.profile.reporter[98984] then
		if UnitName("boss1") == L["Valithria Dreamwalker"] then
			if (arg2 == L["Summon Nightmare Portal"] or arg2 == L["Summon Dream Portal"]) and DreamwalkerTimer then
				local instancename, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
				DreamwalkerTimer = false
				local Found = false
				local DebuffName = L["Twisted Nightmares"]
				if difficultyID == 1 or difficultyID == 2 then DebuffName = L["Emerald Vigor"] end
				for i = 1, GetNumRaidMembers(), 1 do
					if UnitDebuff("raid"..i, DebuffName) then
						if UnitName("raid"..i) ~= L["Valithria Dreamwalker"] then
							local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("raid"..i, DebuffName)
							if count and count > 0 then DreamDebuffs[UnitName("raid"..i)] = count end
							Found = true
						end
					end
				end
				self:ScheduleTimer(function() DreamwalkerTimer = true end, 5)
				if Found then self:ScheduleTimer(function() self:DreamWalkerStackChecker() end, 40) end
			end
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[98985] then
		local instancename, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
		if instancename == L["Icecrown Citadel"] then
			if arg1:find("raid[%d]+") and arg2 == L["Remove Spear"] then
				local PlayersName = UnitName(arg1)
				if PlayersName and UnitInRaid(PlayersName) then
					FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD: "..PlayersName.." has \124cffffffff\124Hitem:50307:0:0:0:0:0:0:0:0\124h[Infernal Spear]\124h\124r", RAID)
				end
			end
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99806] then
		if UnitName(arg1) == UnitName("player") and LGT:GetUnitTalentSpec("player") == nil then LGT:RefreshTalentsByUnit(UnitName("player")) end
		if UnitClass("player") == L["Warrior"] and arg2 == tostring(GetSpellInfo(2458)) and LGT:GetUnitTalentSpec("player") == L["Fury"] then
			UseEquipmentSet("FCDFury")
		end
	end

	if (arg2 == L["Activate Secondary Spec"] or arg2 == L["Activate Primary Spec"]) and (arg1:find("player") or arg1:find("raid") or arg1:find("party")) then
		self.specchangertimestamp = GetTime()
		local SpecChanger = UnitName(arg1)
		local _, c = CustomUnitClass(SpecChanger)
		if SpecChanger ~= nil then self:ScheduleTimer(function() LGT:RefreshTalentsByUnit(SpecChanger) end, 3) end
		if self.cooldowns[c] then
		local spells = self.cooldowns[c]
			for spellName, spellTable in pairs(self.cooldowns[c]) do
				if spellTable.talent then
					self:GetModule("Display"):StopCooldown(SpecChanger,spellTable.id, "True")
				end
			end
		end
		if self.cooldowns["ITEMS"] then
			local spells = self.cooldowns["ITEMS"]
			for spellName, spellTable in pairs(self.cooldowns["ITEMS"]) do
				if spellTable.item then
					self:GetModule("Display"):StopCooldown(SpecChanger,spellTable.id, "True")
				end
			end
		end
		self:ScheduleTimer(function() self:GetModule("Display"):TalentItemScan("True") end, 5)
	end

	if arg2 == tostring(GetSpellInfo(20549)) then FatCooldowns:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED", nil, "SPELL_CAST_SUCCESS", nil, arg1, nil, nil, nil, nil, 20549, "War Stomp" )
	elseif arg2 == tostring(GetSpellInfo(20594)) then FatCooldowns:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED", nil, "SPELL_CAST_SUCCESS", nil, arg1, nil, nil, nil, nil, 20594, "Stoneform" ) end

	if not FatCooldowns:GetModule("Display").db.profile.Backupcdused and  arg2 ~= tostring(GetSpellInfo(53007)) and arg2 ~= tostring(GetSpellInfo(47537)) and arg2 ~= tostring(GetSpellInfo(11129)) and arg2 ~= tostring(GetSpellInfo(20216)) and arg2 ~= tostring(GetSpellInfo(17116)) and arg2 ~= tostring(GetSpellInfo(12043))  then
		if arg1 == "player" or arg1:find("party") or arg1:find("raid") then
			local senderbackup = arg1
			local spellnamebackup = arg2
			local cooldownbackup = nil
			local spellIdbackup = nil
			if UnitInRaid("player") then
				if not senderbackup:find("raid") then return end
					senderbackup = UnitName(arg1)
			elseif not UnitInRaid("player") and GetNumPartyMembers() >= 1 then
				if not senderbackup:find("player") then
					if not senderbackup:find("party") then return end
					senderbackup = UnitName(arg1)
				elseif senderbackup:find("player") then
					senderbackup = UnitName("player")
				end
			elseif not UnitInRaid("player") and GetNumPartyMembers() == 0 then
				if senderbackup == "player" then senderbackup = UnitName("player") else return end
			end
			if senderbackup ~= nil and CustomUnitIsPlayer(senderbackup) and senderbackup:find("[%a]+%-[%a]+") then
				local realscrnameone, realscrnametwo = select(3, senderbackup:find("(%a+)%-(%a+)"))
				senderbackup = realscrnameone
			end

			local _, c = CustomUnitClass(senderbackup) -- fix cd
			local spells = FatCooldowns.cooldowns[c]
			if c and spells and spellnamebackup ~= nil and spells[spellnamebackup] ~= nil then
				if spells[spellnamebackup].cd ~= nil then cooldownbackup = spells[spellnamebackup].cd spellIdbackup = spells[spellnamebackup].id end
			end

			if spellIdbackup ~= nil and cooldownbackup ~= nil and not UnitInVehicle(senderbackup) then
				local ExPacID = c and spells and spellnamebackup ~= nil and spells[spellnamebackup] and spells[spellnamebackup].ExpacHide and spells[spellnamebackup].ExpacHide[FatCooldowns.ExPac] or c and spells and spellnamebackup ~= nil and spells[spellIdbackup] and spells[spellIdbackup].ExpacHide and spells[spellIdbackup].ExpacHide[FatCooldowns.ExPac]
				if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
					if backuptargetspellname[senderbackup] == spellnamebackup then
						FatCooldowns:GetModule("Display"):backbarscheckercdtimer(senderbackup, spellnamebackup, cooldownbackup, spellIdbackup,backuptargetid[senderbackup])
					else
						FatCooldowns:GetModule("Display"):backbarscheckercdtimer(senderbackup, spellnamebackup, cooldownbackup, spellIdbackup)
					end
				end
			end
			backuptargetid[senderbackup] = nil
			backuptargetspellname[senderbackup] = nil
		 end
	end
end

function isPet(pname) 
	if UnitInRaid("player") then
		for i=1, GetNumRaidMembers() do
       	    if UnitName("raidpet"..i) == pname then
           	   	return true, UnitName("raid"..i)
       		end 
     	end
   		return false
   	elseif UnitInParty("player") and GetNumPartyMembers() > 0 and UnitName("playerpet") ~= pname then
   		for i=1, GetNumPartyMembers() do
       		if UnitName("partypet"..i) == pname then
       	       	return true, UnitName("party"..i)
        	end 
        end
    	return false
    elseif UnitName("playerpet") == pname then
    	return true, UnitName("player")
	end
end

function raidIbyName(Pname)
   	for i=1, GetNumRaidMembers() do
       	if UnitName("raid"..i) == Pname then
           	return "raid"..i, i
       	end  
   	end
   	return false
end 

function FatCooldowns:NecroticScanBars(ncfail)
	local donerep = true
	for nb=1, GetNumRaidMembers() do
		if UnitDebuff("raid"..nb, tostring(GetSpellInfo(70337))) then
			local NecroName = UnitName("raid"..nb)
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(NecroName, tostring(GetSpellInfo(70337)))
			local Ntime = expirationTime and expirationTime - GetTime() or 5
			if Ntime > 10 then Ntime = Ntime - 10
			elseif Ntime > 5 then Ntime = Ntime - 5 end
			if ncfail == nil then self:GetModule("Display"):StartCooldown("Necrotic", 70337, Ntime,NecroName,nil)
			elseif ncfail ~= nil and NecroName ~= nil then
				donerep = false
				self:GetModule("Display"):chatreporter(UnitName("player"), 99961, 1,nil,nil,nil,nil,nil, ncfail..", Necrotic jumps to "..NecroName)
			end
			NecroTime[NecroName] = expirationTime and duration and expirationTime - duration or GetTime()
		end
	end
	if ncfail ~= nil and donerep then self:GetModule("Display"):chatreporter(UnitName("player"), 99961, 1,nil,nil,nil,nil,nil, ncfail) end
end

function FatCooldowns:HuntMDCheckerBuffchecker(srcName)
	for i = 1, 40 do
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff(srcName,i)
		if (CustomUnitClass(srcName) == L["Rogue"] and spellId == 59628) or (CustomUnitClass(srcName) == L["Hunter"] and spellId == 35079) then
			return true
		end
	end 
	return false
end

function FatCooldowns:TOTTalentChecker(srcName)
	if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(58415))) == 1 then return 25
	elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(58415))) == 2 then return 20
	else return 30
	end
end

function FatCooldowns:HuntMDChecker(srcName,timestamp)
	if timestamp == nil then
		if CustomUnitClass(srcName) == L["Hunter"] and not UnitIsDead(srcName) and HuntMD[srcName] == nil then
			if self:HuntMDCheckerBuffchecker(srcName) then return else self:GetModule("Display"):HunterMDRename(srcName, 34477, 30, "FAILED") end
		elseif CustomUnitClass(srcName) == L["Rogue"] and not UnitIsDead(srcName) and HuntMD[srcName] == nil then
			if self:HuntMDCheckerBuffchecker(srcName) then return else self:GetModule("Display"):HunterMDRename(srcName, 57934, self:TOTTalentChecker(srcName), "FAILED") end
		end
	elseif timestamp ~= nil then
		if CustomUnitClass(srcName) == L["Hunter"] and not UnitIsDead(srcName) then
			if self:HuntMDCheckerBuffchecker(srcName) then return elseif HuntMD[srcName] ~= nil and timestamp - HuntMD[srcName] < 3.5 then self:GetModule("Display"):HunterMDRename(srcName, 34477, 30, "REMOVED") end
		elseif CustomUnitClass(srcName) == L["Rogue"] and not UnitIsDead(srcName) then
			if self:HuntMDCheckerBuffchecker(srcName) then return elseif HuntMD[srcName] ~= nil and timestamp - HuntMD[srcName] < 5.5 then self:GetModule("Display"):HunterMDRename(srcName, 57934, self:TOTTalentChecker(srcName), "REMOVED") end
		end		
	end
end

function FatCooldowns:AMAuraCheck(srcName) 
	for i = 1, 40 do 
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff(srcName,i)
		if unitCaster then
			unitCaster = UnitName(unitCaster)
			NameFound = 0
			if unitCaster == srcName then
				local AuraTable = {
					[465] = "Devotion",
					[7294] = "Retribution",
					[19746] = "Concentration",
					[19876] = "Shadow",
					[19888] = "Frost",
					[19891] = "Fire",
					[32223] = "Crusader",
				}
				local AuraTable2 = {
					[465] = "Devo",
					[7294] = "Ret",
					[19746] = "Conc",
					[19876] = "Sha",
					[19888] = "Fro",
					[19891] = "Fir",
					[32223] = "Cru",
				}
				local AuraTable3 = {
					[465] = "|TInterface\\Icons\\spell_holy_devotionaura:24:24:0:0:64:64:6:58:6:58|t",
					[7294] = "|TInterface\\Icons\\spell_holy_auraoflight:24:24:0:0:64:64:6:58:6:58|t",
					[19746] = "|TInterface\\Icons\\spell_holy_mindsooth:24:24:0:0:64:64:6:58:6:58|t",
					[19876] = "|TInterface\\Icons\\spell_shadow_sealofkings:24:24:0:0:64:64:6:58:6:58|t",
					[19888] = "|TInterface\\Icons\\spell_frost_wizardmark:24:24:0:0:64:64:6:58:6:58|t",
					[19891] = "|TInterface\\Icons\\spell_fire_sealoffire:24:24:0:0:64:64:6:58:6:58|t",
					[32223] = "|TInterface\\Icons\\spell_holy_crusaderaura:24:24:0:0:64:64:6:58:6:58|t",
				}
				for u,o in pairs(AuraTable) do
					if GetSpellInfo(u) == name then NameFound = u end
				end
				for u,o in pairs(AuraTable2) do
					if GetSpellInfo(u) == name then NameFound = u end
				end
				for u,o in pairs(AuraTable3) do
					if GetSpellInfo(u) == name then NameFound = u end
				end
				if NameFound ~= 0 then
					if FatCooldowns:GetModule("Display").db.profile.AMType == 1 then return nil
					elseif FatCooldowns:GetModule("Display").db.profile.AMType == 2 then return AuraTable[NameFound]
					elseif FatCooldowns:GetModule("Display").db.profile.AMType == 3 then return AuraTable2[NameFound]
					elseif FatCooldowns:GetModule("Display").db.profile.AMType == 4 then return AuraTable3[NameFound]
					end
				end
			end
		end
	end 
end

function FatCooldowns:HealerCheck(HealerID)
	if UnitInRaid("player") then
		members = GetNumRaidMembers()
	else
		members = GetNumPartyMembers() + 1
	end
	
	local HealerFound = false
	for i = 1,members,1 do
		if UnitInRaid("player") then 
			if LGT:GetUnitRole(UnitName("raid"..i)) == "healer" then
				HealerFound = true
				if UnitName("raid"..i) == HealerID then return true end
			end
		elseif not UnitInRaid("player") and i <= GetNumPartyMembers() then
			if LGT:GetUnitRole(UnitName("party"..i)) == "healer" then
				HealerFound = true
				if UnitName("party"..i) == HealerID then return true end
			end			
		end
	end
	if HealerFound then return false else return true end
end


function FatCooldowns:CCChecker(RTimes, Trigger, srcName, dstName, spellId, spellName, HasRole, Role1, Role2, Role3)
	local _, _, _, _, _, duration, expirationTime = UnitDebuff(dstName, spellName) 
	if duration then
		duration = tonumber(string.format("%.1f", duration))
		local CCCMessage = ""
		local RoleTypes = {["healer"] = "Healer", ["tank"] = "Tank", ["caster"] = "DPS", ["melee"] = "DPS", [""] = "" }
		if FatCooldowns:GetModule("Display").db.profile.CCCRoleMessage then
			local RoleCurrent = LGT:GetUnitRole(dstName) and LGT:GetUnitRole(dstName) or ""
			if (RoleTypes[RoleCurrent] == "tank" and Role1) or (RoleTypes[RoleCurrent] == "healer" and Role2) or ((RoleTypes[RoleCurrent] == "melee" or RoleTypes[RoleCurrent] == "caster") and Role3) then
				CCCMessage = RoleTypes[RoleCurrent].." "..dstName..": "..Trigger.." "..duration.." Sec"
			elseif HasRole then
				RoleCurrent = Role1 and "Tank" or Role2 and "Healer" or Role3 and "DPS"
				CCCMessage = RoleCurrent.." "..dstName..": "..Trigger.." "..duration.." Sec"
			else
				CCCMessage = RoleTypes[RoleCurrent].." "..dstName..": "..Trigger.." "..duration.." Sec"
			end
		else
			CCCMessage = dstName..": "..Trigger.." "..duration.." Sec"
		end
		if duration >= FatCooldowns:GetModule("Display").db.profile.CCCMinDur then
			if UnitInRaid("player") then
				if FatCooldowns:GetModule("Display").db.profile.CCCRC ~= 1 then
					local ChatChannels = {[1] = "None", [2] = "SAY", [3] = "YELL", [4] = "RAID"}
					FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(CCCMessage, ChatChannels[FatCooldowns:GetModule("Display").db.profile.CCCRC])
				end
			elseif not UnitInRaid("player") and GetNumPartyMembers() > 1 then
				if FatCooldowns:GetModule("Display").db.profile.CCCPC ~= 1 then
					local ChatChannels = {[1] = "None", [2] = "SAY", [3] = "YELL", [4] = "PARTY"}
					FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(CCCMessage, ChatChannels[FatCooldowns:GetModule("Display").db.profile.CCCPC])
				end
			end
			PlaySoundFile(FatCooldowns.FCDSounds[FatCooldowns:GetModule("Display").db.profile.CCCS], "Master",false) 
		end
	elseif RTimes > 0 then
		self:ScheduleTimer(function() self:CCChecker(RTimes - 1, Trigger, srcName, dstName, spellId, spellName) end, 0.1)
	end
end

function FatCooldowns:FCDTakeScreenShot2(CurrentUIAplha)
	Screenshot()
	self:ScheduleTimer(function() self:FCDTakeScreenShot3(CurrentUIAplha) end, 0.05)
end
function FatCooldowns:FCDTakeScreenShot3(CurrentUIAplha)
	UIParent:SetAlpha(CurrentUIAplha)
end
function FatCooldowns:FCDTakeScreenShot4(HideUI)
	if HideUI then
		local CurrentUIAplha = UIParent:GetAlpha()
		UIParent:SetAlpha(0)
		self:ScheduleTimer(function() self:FCDTakeScreenShot2(CurrentUIAplha) end, 0.05)
	else
		Screenshot()
	end
end
function FatCooldowns:FCDTakeScreenShot(SSType)
	if SSType == "Trade" then
		if FatCooldowns:GetModule("Display").db.profile.SSTradeDelay > 0 then
			self:ScheduleTimer(function() self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSTradeHide) end, FatCooldowns:GetModule("Display").db.profile.SSTradeDelay)
		else 
			self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSTradeHide)
		end
	elseif SSType == "Boss" then
		if FatCooldowns:GetModule("Display").db.profile.SSBossDelay > 0 then
			self:ScheduleTimer(function() self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSBossHide) end, FatCooldowns:GetModule("Display").db.profile.SSBossDelay)
		else 
			self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSBossHide)
		end
	elseif SSType == "Achiv" then
		if FatCooldowns:GetModule("Display").db.profile.SSAchivDelay > 0 then
			self:ScheduleTimer(function() self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSAchivHide) end, FatCooldowns:GetModule("Display").db.profile.SSAchivDelay)
		else 
			self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSAchivHide)
		end
	elseif SSType == "Death" then
		local _,zone2=IsInInstance()
		if (zone2 ~= "arena" and zone2 ~= "pvp") or ((zone2 == "arena" or zone2 == "pvp") and FatCooldowns:GetModule("Display").db.profile.SSDeathInBG) then
			if FatCooldowns:GetModule("Display").db.profile.SSDeathDelay > 0 then
				self:ScheduleTimer(function() self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSDeathHide) end, FatCooldowns:GetModule("Display").db.profile.SSDeathDelay)
			else 
				self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSDeathHide)
			end
		end
	elseif SSType == "Level" then
		if FatCooldowns:GetModule("Display").db.profile.SSLvlDelay > 0 then
			self:ScheduleTimer(function() self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSLvlHide) end, FatCooldowns:GetModule("Display").db.profile.SSLvlDelay)
		else 
			self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSLvlHide)
		end
	elseif SSType == "BG" then
		if FatCooldowns:GetModule("Display").db.profile.SSBGDelay > 0 then
			self:ScheduleTimer(function() self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSBGHide) end, FatCooldowns:GetModule("Display").db.profile.SSBGDelay)
		else 
			self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSBGHide)
		end
	elseif SSType == "Arena" then
		if FatCooldowns:GetModule("Display").db.profile.SSArenaDelay > 0 then
			self:ScheduleTimer(function() self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSArenaHide) end, FatCooldowns:GetModule("Display").db.profile.SSArenaDelay)
		else 
			self:FCDTakeScreenShot4(FatCooldowns:GetModule("Display").db.profile.SSArenaHide)
		end
	end
end
function FatCooldowns:SpellsLvlAV(Spells)
	local Printable = false
	for lvl, lvltable in pairs(Spells) do
		for spellindex, spelltable in pairs(lvltable) do
			if spelltable[1] then Printable = true end
		end
	end
	if Printable then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Avalible Spells ") end
	for lvl, lvltable in pairs(Spells) do
		for spellindex, spelltable in pairs(lvltable) do
			if spelltable[1]:find("spell") then
				local ItemID = select(3,strfind(spelltable[1], "^spell:(%d+)"))
				FatCooldowns:GetModule("Display"):FCDPrefixPrint(GetSpellLink(ItemID)..spelltable[2])
			else
				local ItemID = select(3,strfind(spelltable[1], "^item:(%d+)"))
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(ItemID)
				FatCooldowns:GetModule("Display"):FCDPrefixPrint(itemLink..spelltable[2])
			end
		end
	end
end
function FatCooldowns:CHAT_MSG_MONSTER_YELL(self,msg) if FatCooldowns:GetModule("Display").db.profile.SSBoss and FatCooldowns.FCDBossyells[msg] then FatCooldowns:FCDTakeScreenShot("Boss") end end
function FatCooldowns:SpellsPrintRun(noprint) 
	if FatCooldowns:GetModule("Display").db.profile.SpellLvlLearn then
		local SpellsLvlPrint = {}
		local playerlevel = UnitLevel("player") + 1
		for i = 1, 80 do
			if i <= playerlevel then
				SpellsLvlPrint[i] = SpellsLvlFill(i,true)
			end
		end
		if noprint == nil then self:ScheduleTimer(function() self:SpellsLvlAV(SpellsLvlPrint) end, 4) end
	end
end
function FatCooldowns:PLAYER_LEVEL_UP(noprint) 
	if FatCooldowns:GetModule("Display").db.profile.SSLvl then self:FCDTakeScreenShot("Level") end
	self:SpellsPrintRun() 
end
function FatCooldowns:ACHIEVEMENT_EARNED() if FatCooldowns:GetModule("Display").db.profile.SSAchiv then self:FCDTakeScreenShot("Achiv") end end
function FatCooldowns:TRADE_ACCEPT_UPDATE(strEvent, strPlayer, strTarget)
	if FatCooldowns:GetModule("Display").db.profile.SSTrade and ((strPlayer == 1 and strTarget == 0) or (strPlayer == 0 and strTarget == 1)) then
		self:FCDTakeScreenShot("Trade")
	end
end

function FatCooldowns:TableCounter(SpellTable) 
	local count = 0
	for index, value in pairs(SpellTable) do
		count = count + 1
	end
	return count
end

function FatCooldowns:DispellerReportDM(Name,SpellTable)
	DispellerMDRun = true
	if Name == nil or SpellTable == nil then return end
	local ChatTable = {[1] = "Self", [2] = "SAY", [3] = "YELL", [4] = "PARTY", [5] = "RAID"}
	local msg = Name
	local NMD = true
	for PlayerName, PlayerTable in pairs(DispellerMDTable) do
		if Name == PlayerName then
			for Spell, SpellTable2 in pairs(PlayerTable) do
				local SpellLink = GetSpellLink(Spell)
				local SMD = true
				local Counting = 1
				local TableCounter = self:TableCounter(SpellTable2)
				for DSPlayer, DSPlayerTable in pairs(SpellTable2) do
					if NMD then NMD = false msg = msg .. "'s " .. GetSpellLink(32375) .. " - " end
					if SMD then SMD = false msg = msg .. SpellLink .. ": " end
					local Timers = ""
					if DSPlayerTable ~= "?" then Timers = DSPlayerTable.."s" else Timers = DSPlayerTable end
					if Counting < TableCounter then
						Counting = Counting + 1
						msg = msg .. DSPlayer .. " " .. Timers .. ", "
					else
						Counting = Counting + 1
						msg = msg .. DSPlayer .. " " .. Timers .. " "
					end
				end
				if NMD == false then 
					self:DispellerReport(msg,SpellTable)
					msg = Name
					NMD = true
				end
			end
		end
	end
	DispellerMDTable[Name] = nil
end

function FatCooldowns:DispellerReport(msg,SpellTable)
	if msg == nil or SpellTable == nil then return end
	local ChatTable = {[1] = "Self", [2] = "SAY", [3] = "YELL", [4] = "PARTY", [5] = "RAID"}
	if SpellTable["chat"] == 1 then 
		FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..msg)
	else
		if UnitInRaid("player") and (IsRaidLeader() or IsRaidOfficer()) then
			FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD: "..msg, ChatTable[SpellTable["chat"]])
		elseif not UnitInRaid("player") then
			if SpellTable["chat"] ~= 5 then
				FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD: "..msg, ChatTable[SpellTable["chat"]])
			end
		end
	end
end

function FatCooldowns:FCDGetNPCID(GUID)
	local first3 = tonumber("0x"..strsub(GUID, 3, 5))
	local unitType = bit.band(first3, 0x007)
	if ((unitType == 0x003) or (unitType == 0x005)) then
		return tonumber("0x"..strsub(GUID, 9, 12))
	else
		return nil
	end
end

function FatCooldowns:FrostBeaconChecker()
	local HasDebuff = UnitDebuff("player", 71266)
	if FatCooldowns:GetModule("Display").db.profile.SindraOn and HasDebuff then 
		AlertFrameFlashScreen(
			FatCooldowns:GetModule("Display").db.profile.SindraOnColor["r"],
			FatCooldowns:GetModule("Display").db.profile.SindraOnColor["g"],
			FatCooldowns:GetModule("Display").db.profile.SindraOnColor["b"],
			FatCooldowns:GetModule("Display").db.profile.SindraOnColor["a"])
	elseif FatCooldowns:GetModule("Display").db.profile.SindraNot and not HasDebuff then
		AlertFrameFlashScreen(
			FatCooldowns:GetModule("Display").db.profile.SindraNotColor["r"],
			FatCooldowns:GetModule("Display").db.profile.SindraNotColor["g"],
			FatCooldowns:GetModule("Display").db.profile.SindraNotColor["b"],
			FatCooldowns:GetModule("Display").db.profile.SindraNotColor["a"])
	end
	FrostBeaconCheckerLimiter = false
end

function FatCooldowns:DispellerNumChecker(srcName)
	local Amount = 0
	local members = nil
	local ScanName = nil
	if UnitInRaid("player") then members = GetNumRaidMembers() else members = GetNumPartyMembers() + 1 end
	for i = 1, members, 1 do
		if UnitInRaid("player") then 
			if srcName == UnitName("raid"..i) then ScanName = "raid"..i end
		elseif not UnitInRaid("player") and i <= GetNumPartyMembers() then
			if srcName == UnitName("party"..i) then ScanName = "party"..i end
		else
			ScanName = UnitName("player") 
		end
	end
	for SpellIndex, SpellTable in pairs(FatCooldowns:GetModule("Display").db.profile.DispellerList) do
		if SpellTable["enable"] then 
			if SpellTable["instance"] == 1 or FatCooldowns.Instances[SpellTable["instance"]] == instancename then 
				if SpellTable["boss"] == 1 or FatCooldowns.Boss[SpellTable["boss"]] == UnitName("boss1") then
					local SpName, SpRank, SpIcon = GetSpellInfo(SpellIndex)					
					for i = 1, 40 do
						if ScanName ~= nil then
							local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(ScanName,i)
							if spellId == SpellIndex or SpName == name then Amount = Amount + 1	end
						end
					end
				end
			end
		end
	end
	return Amount
end

function FatCooldowns:DispellerSpellChecker(DispellerText, SpellTable)
	if DispellerSend then
		self:DispellerReport(DispellerText, SpellTable)
		DispellerSend = false
		if DispellerTime[dstName] ~= nil then table.remove(DispellerTime, DispellerTime[dstName]) end
	end
end

--													0		1			2		3			4		5			6		7		8		9			10
function FatCooldowns:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, ...)
	if EventsFilters[eventType] == nil then	return end
	local instancename, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
	local arg = {...}
	--print(event, timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, ...)
	if UnitName("player") == srcName then
		--local itemName, itemLink = GetItemInfo(49623) 
		--local itemName2, itemLink2 = GetItemInfo(50640) 
		--FatCooldowns:GetModule("Display"):FCDPrefixPrint(event, "testing1", nil, GetSpellLink(2687), GetSpellLink(57755).. "testing".. GetSpellLink(18499), nil, itemLink2, nil,itemLink.." "..itemLink2, nil)
	end

	if eventType == "SPELL_SUMMON" and UnitClass("player") == L["Warlock"] then self:ScheduleTimer(function() self:SpellsPrintRun(true) end, 0.5)  end

	if eventType == "UNIT_DIED" and dstName == UnitName("player") and FatCooldowns:GetModule("Display").db.profile.SSDeath then self:FCDTakeScreenShot("Death") end
	if eventType == "UNIT_DIED" and FatCooldowns:GetModule("Display").db.profile.SSBoss and FatCooldowns.BossID[self:FCDGetNPCID(dstGUID)] then self:FCDTakeScreenShot("Boss") end

	if eventType == "SPELL_AURA_APPLIED" and dstName == UnitName("player") and FatCooldowns:GetModule("Display").db.profile.ABRemovalList ~= nil and type(FatCooldowns:GetModule("Display").db.profile.ABRemovalList) == "table" and next(FatCooldowns:GetModule("Display").db.profile.ABRemovalList) and FatCooldowns:GetModule("Display").db.profile.ABRemovalList[tostring(spellId)] then
		if UnitBuff("player", spellName) then CancelUnitBuff("player", spellName) end
	end

	if FatCooldowns:GetModule("Display").db.profile.CInt and eventType == "SPELL_INTERRUPT" then
		local _, zone2 = IsInInstance()
		if (UnitInParty(dstName) or UnitInRaid(dstName) or dstName == UnitName("player") or zone2 == "arena" or UnitInBattleground("player")) then
		 	if not FatCooldowns:GetModule("Display").db.profile.CIntPlayer or (FatCooldowns:GetModule("Display").db.profile.CIntPlayer and dstName == UnitName("player")) then
		 		if not FatCooldowns:GetModule("Display").db.profile.CIntArena or (FatCooldowns:GetModule("Display").db.profile.CIntArena and zone2 == "arena") then

		 			local Role1, Role2, Role3 = UnitGroupRolesAssigned(dstName)
		 			local HasRole = Role1 and Role1 or Role2 and Role2 or Role3 and Role3 or true and false
			 		if not FatCooldowns:GetModule("Display").db.profile.CIntHealer or (FatCooldowns:GetModule("Display").db.profile.CIntHealer and ((HasRole and Role2 and self:HealerCheck(dstName)) or (not HasRole and LGT:GetUnitRole(dstName) == "healer"))) then
						local InteruptedTime, TimerKnown = isSoulbound(nil, nil, GetSpellLink(spellId), nil, nil, nil, true)
						if InteruptedTime then
							InteruptedTime = tonumber(string.format("%.1f", InteruptedTime))
							local IntMessage = ""
							local RoleTypes = {["healer"] = "Healer", ["tank"] = "Tank", ["caster"] = "DPS", ["melee"] = "DPS", [""] = "" }
							local IntTime = InteruptedTime and InteruptedTime.." Sec." or ""
							if TimerKnown then IntTime = IntTime.." Aprox" end
							if FatCooldowns:GetModule("Display").db.profile.CIntRoleMessage then
								local RoleCurrent = LGT:GetUnitRole(dstName) and LGT:GetUnitRole(dstName) or ""
								if (RoleTypes[RoleCurrent] == "tank" and Role1) or (RoleTypes[RoleCurrent] == "healer" and Role2) or ((RoleTypes[RoleCurrent] == "melee" or RoleTypes[RoleCurrent] == "caster") and Role3) then
									IntMessage = RoleTypes[RoleCurrent].." "..dstName..": Interupted "..IntTime
								elseif HasRole then
									RoleCurrent = Role1 and "Tank" or Role2 and "Healer" or Role3 and "DPS"
									IntMessage = RoleCurrent.." "..dstName..": Interupted "..IntTime
								else
									IntMessage = RoleTypes[RoleCurrent].." "..dstName..": Interupted "..IntTime
								end
							else
								IntMessage = dstName..": Interupted "..IntTime
							end
							if tonumber(InteruptedTime) >= FatCooldowns:GetModule("Display").db.profile.CIntMinDur then
								if UnitInRaid("player") and FatCooldowns:GetModule("Display").db.profile.CIntRC ~= 1 then
									local ChatChannels = {[1] = "None", [2] = "SAY", [3] = "YELL", [4] = "RAID"}		
									FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(IntMessage, ChatChannels[FatCooldowns:GetModule("Display").db.profile.CIntRC])
								elseif not UnitInRaid("player") and GetNumPartyMembers() > 1 and FatCooldowns:GetModule("Display").db.profile.CIntPC ~= 1 then
									local ChatChannels = {[1] = "None", [2] = "SAY", [3] = "YELL", [4] = "PARTY"}		
									FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(IntMessage, ChatChannels[FatCooldowns:GetModule("Display").db.profile.CIntPC])
								end
								PlaySoundFile(FatCooldowns.FCDSounds[FatCooldowns:GetModule("Display").db.profile.CIntS], "Master",false)
							end
						end
					end
				end
			end
		end
	end
	if FatCooldowns:GetModule("Display").db.profile.CCC and eventType == "SPELL_AURA_APPLIED" and (UnitInParty(dstName) or UnitInRaid(dstName) or dstName == UnitName("player")) and arg[2] and arg[2] == "DEBUFF" then
		if not FatCooldowns:GetModule("Display").db.profile.CCCPlayer or (FatCooldowns:GetModule("Display").db.profile.CCCPlayer and dstName == UnitName("player")) then
 			local _, zone2 = IsInInstance()
	 		if not FatCooldowns:GetModule("Display").db.profile.CCCArena or (FatCooldowns:GetModule("Display").db.profile.CCCArena and zone2 == "arena") then
	 			local Role1, Role2, Role3 = UnitGroupRolesAssigned(dstName)
	 			local HasRole = Role1 and Role1 or Role2 and Role2 or Role3 and Role3 or true and false
 				if not FatCooldowns:GetModule("Display").db.profile.CCCHealer or (FatCooldowns:GetModule("Display").db.profile.CCCHealer and ((HasRole and Role2 and self:HealerCheck(dstName)) or (not HasRole and LGT:GetUnitRole(dstName) == "healer"))) then
					local Trigger = ""
					if FatCooldowns.CCInfoV2[spellName] then Trigger = "CC"
					elseif FatCooldowns.SilenceInfoV2[spellName] then Trigger = "Silence" end
					if Trigger ~= "" then 
						if isSoulbound(nil, nil, GetSpellLink(spellId), nil, nil, nil, nil, true) then
							self:CCChecker(2, Trigger, srcName, dstName, spellId, spellName, HasRole, Role1, Role2, Role3)
						end
					end
				end
			end
		end
	end

	if EventsFilters[eventType] == false then return end



	if FatCooldowns:GetModule("Display").db.profile.DispellerEnable and eventType == "SPELL_AURA_APPLIED" then
		if dstName == UnitName("player") or UnitInRaid(dstName) or UnitInParty(dstName) then
			for SpellIndex, SpellTable in pairs(FatCooldowns:GetModule("Display").db.profile.DispellerList) do
				if SpellTable["applied"] then 
					if SpellTable["instance2"] == 1 or FatCooldowns.Instances[SpellTable["instance2"]] == instancename then 
						if SpellTable["boss2"] == 1 or FatCooldowns.Boss[SpellTable["boss2"]] == UnitName("boss1") then
							if not SpellTable["self"] or SpellTable["self"] and dstName == UnitName("player") then
								local SpName, SpRank, SpIcon = GetSpellInfo(SpellIndex)
								if SpellIndex == spellId or spellName == SpName then
									local ChatTable = {[1] = "Self", [2] = "SAY", [3] = "YELL", [4] = "PARTY", [5] = "RAID"}
									local PersonsName = dstName
									if dstName == UnitName("player") then PersonsName = "me" end
									if SpellTable["chat2"] == 1 then 
										FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: "..GetSpellLink(SpellIndex).." on "..PersonsName.." dispel")
									else
										if UnitInRaid("player") and (IsRaidLeader() or IsRaidOfficer()) then
											FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD: "..GetSpellLink(SpellIndex).." on "..PersonsName.." dispel", ChatTable[SpellTable["chat2"]])
										elseif not UnitInRaid("player") then
											if SpellTable["chat2"] ~= 5 then
												FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD: "..GetSpellLink(SpellIndex).." on "..PersonsName.." dispel", ChatTable[SpellTable["chat2"]])
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

	if FatCooldowns:GetModule("Display").db.profile.DispellerEnable and (eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REMOVED" or eventType == "UNIT_DIED" or eventType == "SPELL_DISPEL" or (eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(642)) or spellName == tostring(GetSpellInfo(31224)) or spellName == tostring(GetSpellInfo(45438))))) then
		if dstName == UnitName("player") or UnitInRaid(dstName) or UnitInParty(dstName) then
			for SpellIndex, SpellTable in pairs(FatCooldowns:GetModule("Display").db.profile.DispellerList) do
				if SpellTable["enable"] then 
					if SpellTable["instance"] == 1 or FatCooldowns.Instances[SpellTable["instance"]] == instancename then 
						if SpellTable["boss"] == 1 or FatCooldowns.Boss[SpellTable["boss"]] == UnitName("boss1") then 
							local SpName, SpRank, SpIcon = GetSpellInfo(SpellIndex)
							local ColordstName = dstName
							local ColorsrcName = srcName
							if SpellTable["chat"] == 1 then
								ColordstName = FCDColorName(dstName)
								ColorsrcName = FCDColorName(srcName)
							end
							if eventType == "SPELL_AURA_REMOVED" and arg[2] == "DEBUFF" and (SpellIndex == spellId or spellName == SpName) then
								if SpellTable["timeout"] then
									local DebuffTime, Aprox = isSoulbound(nil, nil, GetSpellLink(SpellIndex), nil, nil, nil, true)
									local RemovalTime = string.format("%.2f", timestamp - DispellerTime[dstName])
									if DebuffTime or RemovalTime then
										if RemovalTime and self:DispellerNumChecker(dstName) == 0 then
											DispellerText = GetSpellLink(SpellIndex).." was not dispelled ("..ColordstName..") "..RemovalTime.." sec"
										else
											if Aprox then
												DispellerText = GetSpellLink(SpellIndex).." was not dispelled ("..ColordstName..") "..DebuffTime.." sec Aprox"
											else
												DispellerText = GetSpellLink(SpellIndex).." was not dispelled ("..ColordstName..") "..DebuffTime.." sec Aprox"
											end
										end
										DispellerSend = true
										self:ScheduleTimer(function() self:DispellerSpellChecker(DispellerText, SpellTable) end, 0.2)
									end
								end
							elseif eventType == "UNIT_DIED" and UnitDebuff(dstName, SpName) and SpellTable["death"] then
								if DispellerTime[dstName] ~= nil and self:DispellerNumChecker(dstName) == 0 then
									DispelTime = string.format("%.2f", (timestamp - DispellerTime[dstName]))
								else
									DispelTime = "?"								
								end
								DispellerText = ColordstName.." died with "..GetSpellLink(SpellIndex).." after "..DispelTime.." seconds"
								self:DispellerReport(DispellerText, SpellTable)
								DispellerText = nil
								if DispellerTime[dstName] ~= nil then table.remove(DispellerTime, DispellerTime[dstName]) end
							elseif eventType == "SPELL_AURA_APPLIED" and arg[2] == "DEBUFF" and (SpellIndex == spellId or spellName == SpName) then
								DispellerTime[dstName] = timestamp
							elseif (eventType == "SPELL_DISPEL" and (arg[3] == SpName or arg[2] == SpellIndex)) or (eventType == "SPELL_CAST_SUCCESS" and UnitDebuff(srcName, SpName) and (spellName == tostring(GetSpellInfo(642)) or spellName == tostring(GetSpellInfo(31224)) or spellName == tostring(GetSpellInfo(45438)))) then
								if eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(642)) or spellName == tostring(GetSpellInfo(31224)) or spellName == tostring(GetSpellInfo(45438))) then
									local DNumCheck = self:DispellerNumChecker(srcName)
									local DebuffTime, Aprox = isSoulbound(nil, nil, GetSpellLink(SpellIndex), nil, nil, nil, true)
									if DispellerTime[srcName] ~= nil and DNumCheck == 0 then
										DispelTime = timestamp - DispellerTime[srcName]
										if type(DebuffTime) == "number" and DispelTime > DebuffTime then DispelTime = "?" else DispelTime = string.format("%.0f", (DispelTime))end
									else
										DispelTime = "?"
									end
									local RemovalTime = nil
									if DispelTime == "?" then
										if DNumCheck == 0 and UnitDebuff(dstName, SpellIndex)  then
											local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(dstName, SpellIndex)
											RemovalTime =  expirationTime and expirationTime - GetTime()
										end
										if RemovalTime ~= nil then DispelTime = string.format("%.2f", RemovalTime) end
									end
									DispellerText = ColorsrcName.." dispelled mark with Bubble, Cloak or Ice Block after "..DispelTime.." sec"
									if CustomUnitClass(srcName) == L["Paladin"] then DispellerText = srcName.." dispelled "..GetSpellLink(SpellIndex).." with "..GetSpellLink(642).." after "..DispelTime.." sec" 
									elseif CustomUnitClass(srcName) == L["Mage"] then DispellerText = srcName.." dispelled "..GetSpellLink(SpellIndex).." with "..GetSpellLink(45438).." after "..DispelTime.." sec" 
									elseif CustomUnitClass(srcName) == L["Rogue"] then DispellerText = srcName.." dispelled "..GetSpellLink(SpellIndex).." with "..GetSpellLink(31224).." after "..DispelTime.." sec"
									end
									DispellerSend = false
									self:DispellerReport(DispellerText, SpellTable)
									DispellerText = nil
									if DispellerTime[dstName] ~= nil then table.remove(DispellerTime, DispellerTime[dstName]) end
								elseif UnitInRaid("player") and not UnitInRaid(srcName) then 
									local checkPet, oname = isPet(srcName)
									if CustomUnitClass(oname) == L["Warlock"] then
										local DNumCheck = self:DispellerNumChecker(dstName)
										local DebuffTime, Aprox = isSoulbound(nil, nil, GetSpellLink(SpellIndex), nil, nil, nil, true)
										if DispellerTime[dstName] ~= nil and DNumCheck == 0 then
											DispelTime = timestamp - DispellerTime[dstName]
											if type(DebuffTime) == "number" and DispelTime > DebuffTime then DispelTime = "?" else DispelTime = string.format("%.0f", (DispelTime))end
										else
											DispelTime = "?"
										end
										if DispelTime == "?" then
											if DNumCheck == 0 and UnitDebuff(dstName, SpellIndex) then
												local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(dstName, SpellIndex)
												RemovalTime =  expirationTime and expirationTime - GetTime()
											end
											if RemovalTime ~= nil then DispelTime = string.format("%.2f", RemovalTime) end
										end
										local Coloroname = oname
										if SpellTable["chat"] == 1 then Coloroname = FCDColorName(oname) end
										DispellerText = oname.."'s pet dispelled "..GetSpellLink(arg[2]).." ("..ColordstName..") "..DispelTime.." sec"
										self:DispellerReport(DispellerText, SpellTable)
										DispellerText = nil
										checkPet = nil
										oname = nil
										DispellerSend = false
										if DispellerTime[dstName] ~= nil then table.remove(DispellerTime, DispellerTime[dstName]) end
									end
								elseif spellName == tostring(GetSpellInfo(32375)) then
									local DNumCheck = self:DispellerNumChecker(dstName)
									local DebuffTime, Aprox = isSoulbound(nil, nil, GetSpellLink(SpellIndex), nil, nil, nil, true)
									if DispellerTime[dstName] ~= nil and DNumCheck == 0 then
										DispelTime = timestamp - DispellerTime[dstName]
										if type(DebuffTime) == "number" and DispelTime > DebuffTime then DispelTime = "?" else DispelTime = string.format("%.2f", (DispelTime))end
									else
										DispelTime = "?"
									end		
									if DispelTime == "?" then
										if DNumCheck == 0 and UnitDebuff(dstName, SpellIndex) then
											local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(dstName, SpellIndex)
											RemovalTime =  expirationTime and expirationTime - GetTime()
										end
										if RemovalTime ~= nil then DispelTime = string.format("%.2f", RemovalTime) end
									end
									if FatCooldowns:GetModule("Display").db.profile.DispellerMDEnable then
										DispellerMDTable[srcName] = DispellerMDTable[srcName] or {}
										DispellerMDTable[srcName][arg[2]] = DispellerMDTable[srcName][arg[2]] or {}
										DispellerMDTable[srcName][arg[2]][dstName] = DispelTime
										if DispellerMDRun == true then DispellerMDRun = false self:ScheduleTimer(function() self:DispellerReportDM(srcName, SpellTable) end, 0.1) end
									end
									DispellerSend = false
									if DispellerTime[dstName] ~= nil then table.remove(DispellerTime, DispellerTime[dstName]) end									
								else
									local DNumCheck = self:DispellerNumChecker(dstName)
									local DebuffTime, Aprox = isSoulbound(nil, nil, GetSpellLink(SpellIndex), nil, nil, nil, true)
									if DispellerTime[dstName] ~= nil and DNumCheck == 0 then
										DispelTime = timestamp - DispellerTime[dstName]
										if type(DebuffTime) == "number" and DispelTime > DebuffTime then DispelTime = "?" else DispelTime = string.format("%.2f", (DispelTime))end
									else
										DispelTime = "?"
									end		
									if DispelTime == "?" then
										if DNumCheck == 0 and UnitDebuff(dstName, SpellIndex) then
											local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(dstName, SpellIndex)
											RemovalTime =  expirationTime and expirationTime - GetTime()
										end
										if RemovalTime ~= nil then DispelTime = string.format("%.2f", RemovalTime) end
									end
									DispellerText = ColorsrcName.." dispelled "..GetSpellLink(arg[2]).." ("..ColordstName..") "..DispelTime.." sec"
									self:DispellerReport(DispellerText, SpellTable)
									DispellerText = nil
									DispellerSend = false
									if DispellerTime[dstName] ~= nil then table.remove(DispellerTime, DispellerTime[dstName]) end
								end
							end

						end
					end
				end
			end
		end
	end

	if srcName ~= nil and srcName:find("^[%a]+%-[%a]+$") and CustomUnitIsPlayer(srcName) then
		local realscrnameone, realscrnametwo = select(3, srcName:find("(%a+)%-(%a+)"))
		srcName = realscrnameone
	end
	if dstName ~= nil and dstName:find("^[%a]+%-[%a]+$") and CustomUnitIsPlayer(dstName) then
		local realscrnameone, realscrnametwo = select(3, dstName:find("(%a+)%-(%a+)"))
		dstName = realscrnameone
	end

	if (spellId == 33697 and spellName == tostring(GetSpellInfo(33702))) or (spellId == 20572 and spellName == tostring(GetSpellInfo(33702))) then spellId = 33702 end
	if spellName == tostring(GetSpellInfo(118)) and (spellId == 28271 or spellId == 28272 or spellId == 61025 or spellId == 61305 or spellId == 61721 or spellId == 61780 or spellId == 71319) then spellId = 12826 end
	self:FCDCHATREPORTER(event, timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, ...)

	if eventType == "UNIT_DIED" and (UnitInRaid(dstName) or UnitName("player") or UnitInParty(dstName)) and UnitBuff(dstName, tostring(GetSpellInfo(5384))) then self:GetModule("Display"):SyncCooldown(dstName, 5384, 25, nil,nil) end 
	if eventType == "UNIT_DIED" and UnitInRaid(dstName) then FatCooldowns:GetModule("Display"):UpdateDisplay() end
	if eventType == "UNIT_DIED" then return end

	if not UnitIsPlayer(srcName) and (eventType == "SPELL_CAST_SUCCESS" or (eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(47236)))) and (UnitPlayerOrPetInParty(srcName) or UnitPlayerOrPetInRaid(srcName) or UnitName("playerpet") == srcName) then
		local checkPet, oname = isPet(srcName)
		if checkPet and not UnitInVehicle(oname) and (CustomUnitClass(oname) == L["Hunter"] or CustomUnitClass(oname) == L["Warlock"]) then
			local _, c = CustomUnitClass(oname)
			if self.cooldowns[c] then 
			local spells = self.cooldowns[c]
				if spells[spellName] or spells[spellId] then
					local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
					if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
						if dstName == srcName or dstName == oname then dstName = nil end
						srcName = oname
						local cd = spells[spellName] and spells[spellName].cd or spells[spellId] and spells[spellId].cd
						local SpellIdMax = spells[spellName] and spells[spellName].id or spells[spellId] and spells[spellId].id or spellId

						if spellName == tostring(GetSpellInfo(53434)) or spellName == tostring(GetSpellInfo(19574)) or spellName == tostring(GetSpellInfo(19577)) or spellName == tostring(GetSpellInfo(61685)) or spellName == tostring(GetSpellInfo(53477)) then
							if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == nil or LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == 0 then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd ,dstName,nil) return -- pet spells
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == 1 then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.9,dstName,nil) return -- pet spells
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == 2 then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.8,dstName,nil) return -- pet spells
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == 3 then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.7,dstName,nil) return -- pet spells
							end
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd,dstName,nil)
						else
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd,dstName,nil)
						end
					end
				end
			end
		end
		return
	end
	
	if spellName == "War Stomp" or spellName == "Stoneform" then
		if eventType == "SPELL_CAST_SUCCESS" then
			if UnitInRaid("player") then
				if not srcName:find("raid") then return end
				srcName = UnitName(srcName)
			elseif not UnitInRaid("player") and GetNumPartyMembers() >= 1 then
				if not srcName:find("player") then
					if not srcName:find("party") then return end
					srcName = UnitName(srcName)
				else srcName = UnitName("player") end
			elseif not UnitInRaid("player") and GetNumPartyMembers() == 0 then
				if srcName == "player" then srcName = UnitName("player") else return end
			end
		else
			return
		end
	end

	if instancename == L["Icecrown Citadel"] and UnitName("boss1") == L["Sindragosa"] and FatCooldowns.ExPac == 2 then
		if eventType == "SPELL_AURA_APPLIED" and spellId == 70126 and not FrostBeaconCheckerLimiter then
			FrostBeaconCheckerLimiter = true
			self:ScheduleTimer(function() self:FrostBeaconChecker() end, 0.5)
		end
		if eventType == "SPELL_AURA_APPLIED" and spellId == 69766 then  
			self:GetModule("Display"):SyncCooldown(dstName, 69766, 5,"1",nil) 
 		elseif eventType == "SPELL_AURA_APPLIED_DOSE" and spellId == 69766 then 
			self:GetModule("Display"):SyncCooldown(dstName, 69766, 5,tostring(arg[3]),nil)
		end
    end

  	if UnitName("boss1") == L["The Lich King"] and FatCooldowns.ExPac == 2 then
		if eventType == "SPELL_AURA_APPLIED" and (dstName == L["Shambling Horror"] or srcName == L["Shambling Horror"]) and spellName == tostring(GetSpellInfo(72143)) then  
			self:GetModule("Display"):StartCooldown(L["Shambling Horror"], 72143, 5,nil,nil) 
		end
		if eventType == "SPELL_AURA_REMOVED" and (dstName == L["Shambling Horror"] or srcName == L["Shambling Horror"]) and spellName == tostring(GetSpellInfo(72143)) then  
			self:GetModule("Display"):StopCooldown(L["Shambling Horror"], 72143)
		end
		if spellName == tostring(GetSpellInfo(70337)) or arg[3] == tostring(GetSpellInfo(70337)) then
			if eventType == "SPELL_DISPEL" then self:GetModule("Display"):StopCooldown("Necrotic"..dstName, 70337) end
			self:ScheduleTimer(function() self:NecroticScanBars() end, 0.2)
			if FatCooldowns:GetModule("Display").db.profile.reporter[99961] then
				if eventType == "SPELL_CAST_SUCCESS" and spellName == tostring(GetSpellInfo(31224)) and UnitDebuff(srcName,tostring(GetSpellInfo(70337))) then
					self:GetModule("Display"):chatreporter(srcName, 99961, 1,nil,nil,nil,nil,nil, srcName.." used Cloak of Shadows with Necrotic")
				elseif eventType == "SPELL_PERIODIC_DAMAGE" and UnitInRaid(dstName) then
					self:GetModule("Display"):chatreporter(srcName, 99961, 1,nil,nil,nil,nil,nil, dstName.." was hit by Necrotic")
				elseif eventType == "SPELL_DISPEL" and arg[3] == tostring(GetSpellInfo(70337)) then
					local dispeller = srcName
					if srcName == dstName and spellName == tostring(GetSpellInfo(10872)) and UnitBuff(dstName, tostring(GetSpellInfo(552))) then
						local realdispeler = select(8, UnitBuff(dstName, tostring(GetSpellInfo(552))))
						dispeller = UnitName(realdispeler)
					end
					if NecroTime[dstName] then
						local NPTime = string.format("%.1f", (GetTime() - NecroTime[dstName]))
						if GetTime() - NecroTime[dstName] > 6 then NPTime = "after ? sec" else NPTime = " after "..NPTime.."s" end
						local nctext = dispeller.." has dispelled Necrotic from "..dstName..NPTime
						self:ScheduleTimer(function() self:NecroticScanBars(nctext) end, 0.2)
						--self:GetModule("Display"):chatreporter(srcName, 99961, 1,nil,nil,nil,nil,nil, dispeller.." has dispelled Necrotic from "..dstName..NPTime)
					end
				end
			end
		end
		if dstName == L["Shambling Horror"] then -- shambing ccs

		end
    end

    if eventType == "SPELL_AURA_REMOVED" and FatCooldowns:GetModule("Display").db.profile.Removal then
		local _, c = CustomUnitClass(srcName)
		if c ~= nil and self.cooldowns[c] then
			local spells = self.cooldowns[c]
			local id = spells[spellName] and spells[spellName].id or spells[spellId] and spells[spellId].id
			local remove = spells[spellName] and spells[spellName].remove or spells[spellId] and spells[spellId].remove
			local IsSpell = FatCooldowns.SpellData[spellId] or FatCooldowns.TalentProcData[spellId]
			local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
			if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
				if id and remove and IsSpell then
					if UnitName("player") == dstName or UnitInParty(dstName) or UnitInRaid(dstName) then
						self:GetModule("Display"):StopCooldown(srcName, id)
					else
						self:GetModule("Display"):StopCooldown(srcName, id, true)
					end
				end
			end
			remove = false
		end
    end

	if srcName ~= UnitName("player") and not UnitInParty(srcName) and not UnitInRaid(srcName) and not FatCooldowns:GetModule("Display").db.profile.ArenaMode then return end -- checks if player is in raid



















	if eventType == "SPELL_AURA_APPLIED" and spellId == 23060 then
		local AmountBuff = 0
		for i = 1, 40 do
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff(dstName,i)
			if name == GetSpellInfo(23060) then
				AmountBuff = AmountBuff + 1
			end
		end
		self:GetModule("Display"):RenameBar(dstName, AmountBuff)
	end


	if spellName == tostring(GetSpellInfo(34477)) and FatCooldowns.ExPac == 2 then
		if spellId == 34477 and eventType == "SPELL_AURA_REMOVED" then 
			self:ScheduleTimer(function() self:HuntMDChecker(srcName) end, 1.2)
			HuntMD[srcName] = nil
		end
		if spellId == 35079 then
			if eventType == "SPELL_AURA_APPLIED" then 
				HuntMD[srcName] = timestamp
			end
 			if eventType == "SPELL_AURA_REMOVED" then
				self:ScheduleTimer(function() self:HuntMDChecker(srcName,timestamp) end, 1.2)
				self:ScheduleTimer(function() self:HuntMDChecker(srcName,timestamp) end, 1.7)
 			end
		end	
	end

	if spellName == tostring(GetSpellInfo(57934)) and FatCooldowns.ExPac == 2 then
		if spellId == 57934 and eventType == "SPELL_AURA_REMOVED" then 
			self:ScheduleTimer(function() self:HuntMDChecker(srcName) end, 1.2)
			HuntMD[srcName] = nil
		end
		if spellId == 59628 then
			if eventType == "SPELL_AURA_APPLIED" then 
				HuntMD[srcName] = timestamp
			end
 			if eventType == "SPELL_AURA_REMOVED" then 
				self:ScheduleTimer(function() self:HuntMDChecker(srcName,timestamp) end, 1.2)
				self:ScheduleTimer(function() self:HuntMDChecker(srcName,timestamp) end, 1.7)
			end
		end	
	end

	if spellName == tostring(GetSpellInfo(23989)) and eventType == "SPELL_CAST_SUCCESS" then
		HuntMD[srcName] = nil
		self:GetModule("Display"):StopCooldown(srcName, 19263)
		self:GetModule("Display"):StopCooldown(srcName, 781)
		self:GetModule("Display"):StopCooldown(srcName, 3045)
		self:GetModule("Display"):StopCooldown(srcName, 49067)
	end

	if eventType == "SPELL_CAST_SUCCESS" and (srcName == UnitName("player") or UnitInParty(srcName) or UnitInRaid(srcName)) and LGT:GetUnitRole(srcName) == "tank" then
		if self.cooldowns["Tank Only Cooldowns"] then
			local spells = self.cooldowns["Tank Only Cooldowns"]
			if spells[spellName] or spells[spellId] then
				local cd = spells[spellName] and spells[spellName].cd or spells[spellId] and spells[spellId].cd
				local id = spells[spellName] and spells[spellName].id or spells[spellId] and spells[spellId].id
				local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
				if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
					if spellName == tostring(GetSpellInfo(1038)) and (dstName == srcName or dstName == nil) then
						self:GetModule("Display"):StartCooldown(srcName, id, spells[spellName].cd,nil,nil,nil,nil,nil,"TankCooldown")
					elseif spellName == tostring(GetSpellInfo(871)) then
						if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(12312))) then 
							if LGT:UnitHasGlyph(srcName, 63329) then 
								self:GetModule("Display"):StartCooldown(srcName, id, 120,nil,nil,nil,nil,nil,"TankCooldown")
							else 
								self:GetModule("Display"):StartCooldown(srcName, id, 240,nil,nil,nil,nil,nil,"TankCooldown")
							end
						else 
							self:GetModule("Display"):StartCooldown(srcName, id, spells[spellName].cd,nil,nil,nil,nil,nil,"TankCooldown")
						end
					elseif spellName == tostring(GetSpellInfo(12975)) then
						if LGT:UnitHasGlyph(srcName, 58376) then
							self:GetModule("Display"):StartCooldown(srcName, id, 120,nil,nil,nil,nil,nil,"TankCooldown") 
						else
							 self:GetModule("Display"):StartCooldown(srcName, id, cd,nil,nil,nil,nil,nil,"TankCooldown")
						end
					else
						self:GetModule("Display"):StartCooldown(srcName, id, cd,nil,nil,nil,nil,nil,"TankCooldown")
					end	
				end
			end
		end
	end 

	if (eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_CAST_START") and (spellId == 33786 or spellId == 12826 or spellId == 8129 or spellId == 6215 or spellId == 17928 or spellId == 605 or spellId == 63321 or
		spellId == 10955 or spellId == 18647 or spellId == 14327) then 
		local _, c = CustomUnitClass(srcName)
		if c ~= nil and self.cooldowns[c] then
			local spells = self.cooldowns[c]
			local cd = spells[spellName] and spells[spellName].cd or spells[spellId] and spells[spellId].cd
			if spells[spellName] or spells[spellId] then self:GetModule("Display"):SyncCooldown(srcName, spellId, cd,dstName,nil) end
		end
		return
	end

	if eventType == "SPELL_CAST_SUCCESS" and (spellId == 633 or spellId == 2800 or spellId == 10310 or spellId == 27154 or spellId == 48788) then
		local _, c = CustomUnitClass(srcName)
		if c ~= nil and self.cooldowns[c] then
			local spells = self.cooldowns[c]
			local SpellIdMax = spells[spellName] and spells[spellName].id or spells[spellId] and spells[spellId].id or spellId
			local cd = spells[spellName] and spells[spellName].cd or spells[spellId] and spells[spellId].cd
			if spells[spellName] or spells[SpellIdMax] then
				local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
				if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
					if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(20234))) == 2 then 
						if LGT:UnitHasGlyph(srcName, 57955) then 
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 660,dstName,nil)
						else
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 960,dstName,nil)
						end
					elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(20234))) == 1 then
						if LGT:UnitHasGlyph(srcName, 57955) then 
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 780,dstName,nil)
						else
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 1080,dstName,nil)
						end
					else 
						if LGT:UnitHasGlyph(srcName, 57955) then 
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 900,dstName,nil)
						else
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 1200,dstName,nil)
						end
					end
				end
			end
		end
		return
	end


	if eventType == "SPELL_CAST_SUCCESS" and spellId == 47788 then HolyPriest = srcName end
	if eventType == "SPELL_HEAL" and spellId == 48153 and HolyPriest ~= nil and FatCooldowns.ExPac == 2 then self:GetModule("Display"):SyncCooldown(HolyPriest, 47788, -108,dstName,nil) return end

	if eventType == "SPELL_ENERGIZE" and spellId == 47755 then
		if RaptureTimeStamp[srcName] == nil or timestamp - RaptureTimeStamp[srcName] > 10 then
		local _, c = CustomUnitClass(srcName)
			if self.cooldowns[c] then
			local spells = self.cooldowns[c]
				if spells[spellName] or spells[spellId] then
					local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
					if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
						self:GetModule("Display"):SyncCooldown(srcName, 47755, 12,nil,nil)
						RaptureTimeStamp[srcName] = timestamp
					end
				end 
			end
		end
		return
	end

	if eventType == "SPELL_CAST_SUCCESS" and (spellId == 52985 or spellName == tostring(GetSpellInfo(47540))) then
		if PenTimeStamp[srcName] == nil or timestamp - PenTimeStamp[srcName] > 7 then
		local _, c = CustomUnitClass(srcName)
			if self.cooldowns[c] then
			local spells = self.cooldowns[c]
				if spells[spellName] or spells[spellId] then
					local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
					if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
						self:GetModule("Display"):SyncCooldown(srcName, 52985, 12,nil,nil)
						PenTimeStamp[srcName] = timestamp
					end
				end 
			end
		end
		return
	end

	if eventType == "SPELL_CAST_START" and spellId == 1842 then
		local _, c = CustomUnitClass(srcName)
		if self.cooldowns[c] then
			local spells = self.cooldowns[c]
			local ExPacID = spells[tostring(GetSpellInfo(1842))] and spells[tostring(GetSpellInfo(1842))].ExpacHide and spells[tostring(GetSpellInfo(1842))].ExpacHide[FatCooldowns.ExPac] or spells[1842] and spells[1842].ExpacHide and spells[1842].ExpacHide[FatCooldowns.ExPac]
			if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
				self:GetModule("Display"):SyncCooldown(srcName, spellId, 5,nil, nil, nil)
			end
		end
	end

	if spellId == 28682 or spellId == 20216 or spellId == 16188 or spellId == 17116 or spellId == 12043 or spellName == tostring(GetSpellInfo(11129)) or spellName == tostring(GetSpellInfo(20216)) or spellName == tostring(GetSpellInfo(17116)) or spellName == tostring(GetSpellInfo(12043)) then
		if eventType == "SPELL_AURA_REMOVED" then
		local _, c = CustomUnitClass(srcName)
			if self.cooldowns[c] then
			local spells = self.cooldowns[c]
				if spells[spellName] or spells[spellId] then
					local cd = spells[spellName] and spells[spellName].cd or spells[spellId] and spells[spellId].cd
					local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
					if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
						self:GetModule("Display"):SyncCooldown(srcName, spellId, cd, dstName)
					end
				end 
			end
		end
		return
	end 

	if (eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH") and (spellId == 54153 or spellId == 16886) then
		local _, c = CustomUnitClass(srcName)
		if self.cooldowns[c] then
			local spells = self.cooldowns[c]
			if spells[spellName] or spells[spellId] then
				local cd = spells[spellName] and spells[spellName].cd or spells[spellId] and spells[spellId].cd
				local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
				if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
					self:GetModule("Display"):SyncCooldown(srcName, spellId, cd)
				end
			end 
		end
		return
	end

	if eventType == "SPELL_CAST_SUCCESS" and (spellId == 48827 or spellId == 53595 or spellId == 53023) then -- target no target
		local _, c = CustomUnitClass(srcName)
		if self.cooldowns[c] then
			local spells = self.cooldowns[c]
			if spells[spellName] or spells[spellId] then
				local cd = spells[spellName] and spells[spellName].cd or spells[spellId] and spells[spellId].cd
				local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
				if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
					self:GetModule("Display"):SyncCooldown(srcName, spellId, cd)
				end
			end 
		end
		return
	end

	local function isEquipped(itemID)
		local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemID)
		local slots = {
			AMMOSLOT = 0,
			INVTYPE_HEAD = 1,
			INVTYPE_NECK = 2,
			INVTYPE_SHOULDER = 3,
			INVTYPE_BODY = 4,
			INVTYPE_CHEST = 5,
			INVTYPE_WAIST = 6,
			INVTYPE_LEGS = 7,
			INVTYPE_FEET = 8,
			INVTYPE_WRIST = 9,
			INVTYPE_HAND = 10,
			INVTYPE_FINGER = {11, 12},
			INVTYPE_TRINKET = {13, 14},
			INVTYPE_CLOAK = 15,
			INVTYPE_WEAPONMAINHAND = 16,
			INVTYPE_2HWEAPON = 16,
			INVTYPE_WEAPON = {16, 17},
			INVTYPE_HOLDABLE = 17,
			INVTYPE_SHIELD = 17,
			INVTYPE_WEAPONOFFHAND = 17,
			INVTYPE_RANGED = 18
		}
		local slot = slots[equipLoc]
		
		if type(slot) == "table" then
			for _, v in ipairs(slot) do
				local link = GetInventoryItemLink("player", v)
				if link and link:match(("item:%s"):format(itemID)) then
					return true
				end
			end
		else
			local link = GetInventoryItemLink("player", slot)
			if link and link:match(("item:%s"):format(itemID)) then
				return true
			end
		end
		return false
	end

	local function checkSlotForEnchantID(slot, enchantID)
		local link = GetInventoryItemLink("player", slot)
		if not link then return false end
		local itemID, enchant = link:match("item:(%d+):(%d+)")
		if tonumber(enchant or -1) == enchantID then
			return true, tonumber(itemID)
		else
			return false
		end
	end

	if srcName == UnitName("player") and not (eventType == "SPELL_AURA_REMOVED" or eventType == "SPELL_AURA_REFRESH" or eventType == "SPELL_AURA_APPLIED_DOSE") then 
		if self.AuraToItemID[spellId] then
			if type(self.AuraToItemID[spellId]) == "table" then
				for k, v in ipairs(self.AuraToItemID[spellId]) do
					local _, _, _, _, _, _, _, _, EQSlot = GetItemInfo(v)
					if EQSlot == "INVTYPE_WEAPONMAINHAND" or EQSlot == "INVTYPE_2HWEAPON" or EQSlot == "INVTYPE_WEAPONOFFHAND" then EQSlot = "INVTYPE_WEAPON" end
					if EQSlot and isEquipped(v) then
						if self.cooldowns["ITEM PROC"] then
							local spells = self.cooldowns["ITEM PROC"]
							if spells[EQSlot] then
								self:GetModule("Display"):StartCooldown(srcName, v, self.ItemIDCooldown[spellId] or 45, nil, nil, nil, nil, nil, nil, EQSlot)
							end
						end
					end
					link = nil
					EQSlot = nil
				end
			else 
				local _, _, _, _, _, _, _, _, EQSlot = GetItemInfo(self.AuraToItemID[spellId])
				if EQSlot == "INVTYPE_WEAPONMAINHAND" or EQSlot == "INVTYPE_2HWEAPON" or EQSlot == "INVTYPE_WEAPONOFFHAND" then EQSlot = "INVTYPE_WEAPON" end
				if EQSlot and isEquipped(self.AuraToItemID[spellId]) then 
					if self.cooldowns["ITEM PROC"] then 
						local spells = self.cooldowns["ITEM PROC"]
						if spells[EQSlot] then 
							self:GetModule("Display"):StartCooldown(srcName, self.AuraToItemID[spellId], self.ItemIDCooldown[spellId] or 45, nil, nil, nil, nil, nil, nil, EQSlot)
						end
					end
				end
				link = nil
			end
		elseif self.EnchantToItemID[spellId] then 
			if type(self.EnchantToItemID[spellId]) == "table" then 
				local EnchantID, EnchantSlot = unpack(self.EnchantToItemID[spellId])
				if EnchantID and EnchantSlot then
					local Equip, EquipItemID = checkSlotForEnchantID(EnchantSlot, EnchantID)
					if Equip then 
						local link = GetInventoryItemLink("player", EnchantSlot)
						local _, _, _, _, _, _, _, _, EQSlot = GetItemInfo(link)
						if EQSlot == "INVTYPE_WEAPONMAINHAND" or EQSlot == "INVTYPE_2HWEAPON" or EQSlot == "INVTYPE_WEAPONOFFHAND" then EQSlot = "INVTYPE_WEAPON" end
						if self.cooldowns["ITEM PROC"] then 
							local spells = self.cooldowns["ITEM PROC"]
							if spells[EQSlot] then 
								self:GetModule("Display"):StartCooldown(srcName, EquipItemID, self.ItemIDCooldown[spellId] or 45, nil, nil, nil, nil, EquipItemID, nil, EQSlot)
							end
						end
					end
				end
			end
		end
	end


		
	local removefail = true
	removefail = true
	if FatCooldowns:GetModule("Display").db.profile.Removal then
	    if (eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_REFRESH" or eventType == "SPELL_AURA_APPLIED") then
			local _, c = CustomUnitClass(srcName)
			if c ~= nil and self.cooldowns[c] then
				local spells = self.cooldowns[c]
				local id = spells[spellName] and spells[spellName].id or spells[spellId] and spells[spellId].id
				local remove = spells[spellName] and spells[spellName].remove or spells[spellId] and spells[spellId].remove
				if (spells[spellName] or spells[spellId]) and id == spellId and remove then
				if eventType == "SPELL_AURA_REFRESH" then eventType = "SPELL_AURA_APPLIED" end
				removefail = false end
			end
	    end
		if eventType == "SPELL_CAST_SUCCESS" and not removefail and spellName ~= tostring(GetSpellInfo(57623)) then return end -- for removal
	end
	if (eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_ENERGIZE") and (spellName == tostring(GetSpellInfo(1454)) or spellName == tostring(GetSpellInfo(47236))) then return end
	if eventType ~= "SPELL_CAST_SUCCESS" and spellName == tostring(GetSpellInfo(57623)) then return end

	if eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(34477)) and spellId ~= 35079 then return end
	if eventType ~= "SPELL_CAST_SUCCESS" and eventType ~= "SPELL_RESURRECT" and (eventType ~= "SPELL_SUMMON" or (spellName ~= tostring(GetSpellInfo(1122)) and spellName ~= tostring(GetSpellInfo(48087)))) and (eventType ~= "SPELL_AURA_APPLIED" or
		(spellName ~= tostring(GetSpellInfo(70654)) and spellName ~= tostring(GetSpellInfo(70845)) and spellName ~= tostring(GetSpellInfo(54861)) and spellName ~= tostring(GetSpellInfo(28714)) and spellName ~= tostring(GetSpellInfo(16190)) and spellName ~= tostring(GetSpellInfo(64382)) and spellName ~= tostring(GetSpellInfo(29858)) and
		spellName ~= tostring(GetSpellInfo(35079)) and removefail and spellName ~= tostring(GetSpellInfo(59628)) and spellName ~= tostring(GetSpellInfo(66233)) and spellName ~= tostring(GetSpellInfo(51514)) and spellName ~= tostring(GetSpellInfo(48518)) and spellName ~= tostring(GetSpellInfo(47883)) and
		spellName ~= tostring(GetSpellInfo(48517)))) then return end

	local _, c = CustomUnitClass(srcName)
	if self.cooldowns["ITEMS"] and c ~= nil then
		local spells = self.cooldowns["ITEMS"]
		if spells[spellName] or spells[spellId] then
			local cd = spells[spellName] and spells[spellName].cd or spells[spellId].cd
			local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
			if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
				if dstName ~= nil then
					self:GetModule("Display"):SyncCooldown(srcName, spellId, cd,dstName,nil)
				else
					self:GetModule("Display"):SyncCooldown(srcName, spellId, cd,nil,nil)
				end
			end
			return
		end
	end
	
	if self.cooldowns["RACIALS"] and c ~= nil then
		local spells = self.cooldowns["RACIALS"]
		if spells[spellName] or spells[spellId] then
			local cd = spells[spellName] and spells[spellName].cd or spells[spellId].cd
			local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
			if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
				if dstName ~= nil then
					self:GetModule("Display"):SyncCooldown(srcName, spellId, cd,dstName,nil)
				else
					self:GetModule("Display"):SyncCooldown(srcName, spellId, cd,nil,nil)
				end
			end
			return
		end
	end

	if self.cooldowns["CONSUMABLES"] and c ~= nil then
		local spells = self.cooldowns["CONSUMABLES"]
		if spells[spellName] or spells[spellId] then
			local cd = spells[spellName] and spells[spellName].cd or spells[spellId].cd
			local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
			if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
				if dstName ~= nil then
					self:GetModule("Display"):SyncCooldown(srcName, spellId, cd,dstName,nil)
				else
					self:GetModule("Display"):SyncCooldown(srcName, spellId, cd,nil,nil)
				end
			end
			return
		end
	end

	if self.cooldowns[c] then 	
		local spells = self.cooldowns[c]
		if spells[spellName] or spells[spellId] then
	--	print(eventType,srcName,dstName,spellName, spellId)
			if spells[spellName] or spells[spellId] then 
				local cd = spells[spellName] and spells[spellName].cd or spells[spellId] and spells[spellId].cd or spells[GetSpellInfo(spellId)] and spells[GetSpellInfo(spellId)].cd or 0
				local SpellIdMax = spells[spellName] and spells[spellName].id or spells[spellId] and spells[spellId].id or spellId 
				local ExPacID = spells[spellName] and spells[spellName].ExpacHide and spells[spellName].ExpacHide[FatCooldowns.ExPac] or spells[spellId] and spells[spellId].ExpacHide and spells[spellId].ExpacHide[FatCooldowns.ExPac]
				if ExPacID == nil or ExPacID ~= nil and ExPacID == false then
					if spellName == tostring(GetSpellInfo(31821)) then dstName = self:AMAuraCheck(srcName) end

					if spellName == tostring(GetSpellInfo(498)) or spellName == tostring(GetSpellInfo(42650)) or spellName == tostring(GetSpellInfo(871)) or spellName == tostring(GetSpellInfo(12975)) or spellName == tostring(GetSpellInfo(34433)) or spellName == tostring(GetSpellInfo(53601)) or spellName == tostring(GetSpellInfo(10308)) or spellName == tostring(GetSpellInfo(48517)) then
						if LGT:GetUnitTalentSpec(srcName) == nil and (UnitInRaid(srcName) or UnitInParty(srcName) or UnitName("player") == srcName) then
							LGT:RefreshTalentsByUnit(srcName) 
						end
					end

					if spellName == tostring(GetSpellInfo(35079)) or spellName == tostring(GetSpellInfo(34477)) or spellName == tostring(GetSpellInfo(59628)) or spellName == tostring(GetSpellInfo(57934)) then -- md tot
						if spellName == tostring(GetSpellInfo(35079)) then self:GetModule("Display"):SyncCooldown(srcName, 34477, spells[spellName].cd,dstName,nil) return
						elseif spellName == tostring(GetSpellInfo(59628)) then self:GetModule("Display"):StartCooldown(srcName, 57934, self:TOTTalentChecker(srcName),dstName,nil, nil, eventType, nil, spellId) return
						end
					elseif spellName == tostring(GetSpellInfo(498)) and LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31848))) then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 120,nil,nil) return
					elseif spellName == tostring(GetSpellInfo(33357)) and LGT:UnitHasGlyph(srcName, 59219) then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.8,nil,nil) return -- dash
					elseif spellName == tostring(GetSpellInfo(8983)) then -- bash
						if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(16940))) == nil or LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(16940))) == 0 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd,nil,nil) return
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(16940))) == 1 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.7 ,nil,nil) return
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(16940))) == 2 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.6 ,nil,nil) return
						end 
					elseif spellName == tostring(GetSpellInfo(48447)) then -- tranq
						if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(17123))) == nil or LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(17123))) == 0 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd,nil,nil) return
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(17123))) == 1 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.7 ,nil,nil) return
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(17123))) == 2 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.4 ,nil,nil) return
						end 
					elseif spellName == tostring(GetSpellInfo(42650)) and tostring(GetSpellInfo(55620)) ~= nil and tostring(GetSpellInfo(55620)) ~= "" and LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(55620))) then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 360,nil,nil) return --dk army
					elseif spellName == tostring(GetSpellInfo(871)) and LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(12312))) then 
							if LGT:UnitHasGlyph(srcName, 63329) then 
								self:GetModule("Display"):StartCooldown(srcName, SpellIdMax, 120,nil) return
							else 
								self:GetModule("Display"):StartCooldown(srcName, SpellIdMax, 240,nil) return end
					elseif spellName == tostring(GetSpellInfo(12975)) and LGT:UnitHasGlyph(srcName, 58376) then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 120,nil,nil) return --last stand
					elseif spellName == tostring(GetSpellInfo(34433)) and LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(15274))) then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 180,dstName,nil) return --sp pet
					elseif spellName == tostring(GetSpellInfo(53601)) and LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53530))) then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 60,dstName,nil) return -- Sacred shield
					elseif spellName == tostring(GetSpellInfo(10278)) then -- hop
						if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(20174))) == nil or LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(20174))) == 0 then
							if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == nil then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd,dstName,nil) return
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == 1 then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 30,dstName,nil) return
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == 2 then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 60,dstName,nil) return
							end
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(20174))) == 1 then
							if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == nil then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 60,dstName,nil) return
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == 1 then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 90,dstName,nil) return
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == 2 then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 120,dstName,nil) return
							end
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(20174))) == 2 then
							if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == nil then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 120,dstName,nil) return
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == 1 then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 150,dstName,nil) return
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == 2 then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 180,dstName,nil) return
							end
						end --hop
					elseif spellName == tostring(GetSpellInfo(642)) then -- DS
						if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == nil or LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == 0 then
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd,dstName,nil) return
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == 1 then 
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 30,dstName,nil) return
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == 2 then
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 60,dstName,nil) return
						end --DS
					elseif spellName == tostring(GetSpellInfo(2687)) and LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(46908))) then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 40,nil,nil) return -- bloodrage
					elseif spellName == tostring(GetSpellInfo(3045)) then
						if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(34948))) == nil or LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(31849))) == 0 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd,nil,nil) return
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(34948))) == 1 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 60,nil,nil) return
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(34948))) == 2 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 120,nil,nil) return
						end 
					elseif spellName == tostring(GetSpellInfo(19574)) then
						if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == nil or LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == 0 then
							if LGT:UnitHasGlyph(srcName,tostring(GetSpellInfo(56830))) then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 20,nil,nil) return -- pet spells
							else
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd,nil,nil) return -- pet spells
							end
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == 1 then
							if LGT:UnitHasGlyph(srcName,tostring(GetSpellInfo(56830))) then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, (cd - 20) * 0.9,nil,nil) return -- pet spells
							else
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.9,nil,nil) return -- pet spells
							end
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == 2 then
							if LGT:UnitHasGlyph(srcName,tostring(GetSpellInfo(56830))) then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, (cd - 20) * 0.8 - 20,nil,nil) return -- pet spells
							else
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.8,nil,nil) return -- pet spells
							end
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == 3 then
							if LGT:UnitHasGlyph(srcName,tostring(GetSpellInfo(56830))) then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, (cd - 20) * 0.7,nil,nil) return -- pet spells
							else
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.7,nil,nil) return -- pet spells
							end
						end
					elseif spellName == tostring(GetSpellInfo(53434)) or spellName == tostring(GetSpellInfo(19577)) or spellName == tostring(GetSpellInfo(61685)) or spellName == tostring(GetSpellInfo(53477)) then
						if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == nil or LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == 0 then
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd,nil,nil) return -- pet spells
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == 1 then
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.9,nil,nil) return -- pet spells
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == 2 then
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.8,nil,nil) return -- pet spells
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53264))) == 3 then
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd * 0.7,nil,nil) return -- pet spells
						end
					elseif spellName == tostring(GetSpellInfo(21169)) and LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(16184))) then
						if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(16184))) == 1 then
							if FatCooldowns.ExPac == 0 then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 600,dstName,nil) return -- Reincarnation
							else
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 420,dstName,nil) return -- Reincarnation
							end
						else
							if FatCooldowns.ExPac == 0 then
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 1200,dstName,nil) return -- Reincarnation
							else
								self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 840,dstName,nil) return -- Reincarnation
							end
						end
					elseif spellName == tostring(GetSpellInfo(48113)) and LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(47562))) then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, 7,dstName,nil) return -- mending
					elseif spellName == tostring(GetSpellInfo(10060)) then 
						if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(47507))) == 1 then
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, (cd * 0.9),dstName,nil) return -- pi
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(47507))) == 2 then
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, (cd * 0.8),dstName,nil) return -- pi
						else
							self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd,dstName,nil) return -- pi
						end
					elseif spellName == tostring(GetSpellInfo(10308)) then 
						if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(20487))) == nil then
							if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53695))) == nil then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd, dstName,nil) return
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53695))) == 1 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 5, dstName,nil) return
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53695))) == 2 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 10, dstName,nil) return
							end
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(20487))) == 1 then
							if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53695))) == nil then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 10, dstName,nil) return
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53695))) == 1 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 15, dstName,nil) return
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53695))) == 2 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 20, dstName,nil) return
							end
						elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(20487))) == 2 then
							if LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53695))) == nil then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 20, dstName,nil) return
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53695))) == 1 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 25, dstName,nil) return
							elseif LGT:UnitHasTalent(srcName, tostring(GetSpellInfo(53695))) == 2 then self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd - 30, dstName,nil) return
							end
						end -- Hammer of Justice 
					end

					if dstName ~= nil then
						self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd,dstName,nil)
					else 
						self:GetModule("Display"):SyncCooldown(srcName, SpellIdMax, cd,nil,nil)
					end
				end
			end
			return
		end
	end	
	return
end	

function FatCooldowns:AutoWeapon() UseEquipmentSet("FCDLDW") end

function FatCooldowns:BagsFree()
	local freeslots = 0
	for x = 0, 4 do 
   		local tempfreeslots = GetContainerNumFreeSlots(x)
   		freeslots = freeslots + tempfreeslots
   	end
   	return freeslots
end

function FatCooldowns:isnotbosstarget(sname)
	if sname == nil then return end
	if UnitName("boss1") == nil then return false end
	if UnitName("boss1") ~= nil and UnitName("boss1target") == sname then return false end 
	if UnitName("boss2") ~= nil and UnitName("boss1target") == sname then return false end 
	if UnitName("boss3") ~= nil and UnitName("boss1target") == sname then return false end 
	return true
end

function FatCooldowns:SortTable(TableName)
	if TableName == nil then return end
	table.sort(TableName, function(a, b) return a:lower() < b:lower() end)
end
function FatCooldowns:SortTableNum(TableName)
	if TableName == nil then return end
	table.sort(TableName, function(a, b) return a < b end)
end

function FatCooldowns:ValkScannerReporter(healer)
	if healer == nil or FatCooldowns.ExPac ~= 2 then return end
	if healers[healer] ~= nil then 
		if FatCooldowns:GetModule("Display").db.profile.reporter[99990] then
			if CustomUnitClass(healer) == L["Priest"] then 
				if LGT:GetUnitTalentSpec(healer) == L["Holy"] then
					PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\Hpriest.mp3", "Master")
				else
					PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\Disc.mp3", "Master")
				end
			elseif CustomUnitClass(healer) == L["Paladin"] then PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\Hpala.mp3", "Master")
			elseif CustomUnitClass(healer) == L["Shaman"] then PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\Shaman.mp3", "Master")
			elseif CustomUnitClass(healer) == L["Druid"] then PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\Druid.mp3", "Master")
			end
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[99989] or FatCooldowns:GetModule("Display").db.profile.reporter[98874] then
			local GrabbedHealer = nil
			local GrabbedIcons = {
				[1] = "{Star}",
				[2] = "{Circle}",
				[3] = "{Diamond}",
				[4] = "{Triangle}",
				[5] = "{Moon}",
				[6] = "{Square}",
				[7] = "{Cross}",
				[8] = "{Skull}",
			}
			if CustomUnitClass(healer) == L["Priest"] then
				if LGT:GetUnitTalentSpec(healer) == "Holy" then
					if FatCooldowns:GetModule("Display").db.profile.reporter[98874] then 
						GrabbedHealer = "Hpriest is "..GrabbedIcons[GrabbedIcon].."!"
					else
						GrabbedHealer = "Hpriest is Grabbed!"
					end
				else
					if FatCooldowns:GetModule("Display").db.profile.reporter[98874] then 
						GrabbedHealer = "Disc is "..GrabbedIcons[GrabbedIcon].."!"
					else
						GrabbedHealer = "Disc is Grabbed!"
					end
				end
			elseif CustomUnitClass(healer) == L["Paladin"] then if FatCooldowns:GetModule("Display").db.profile.reporter[98874] then GrabbedHealer = "Hpala is "..GrabbedIcons[GrabbedIcon].."!" else GrabbedHealer = "Hpala is Grabbed!" end
			elseif CustomUnitClass(healer) == L["Shaman"] then if FatCooldowns:GetModule("Display").db.profile.reporter[98874] then GrabbedHealer = "Rsham is "..GrabbedIcons[GrabbedIcon].."!" else GrabbedHealer = "Rsham is Grabbed!" end
			elseif CustomUnitClass(healer) == L["Druid"] then if FatCooldowns:GetModule("Display").db.profile.reporter[98874] then GrabbedHealer = "Rdruid is "..GrabbedIcons[GrabbedIcon].."!" else GrabbedHealer = "Rdruid is Grabbed!" end
			end
			if GrabbedHealer ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(GrabbedHealer, "SAY") end
		end
	end
end

function FatCooldowns:ValkScanner(valkevent, grabbedname)
	if grabbedname ~= nil then grabbedname = UnitName(grabbedname) end
	if summonvalktimestamp == nil or (GetTime() - summonvalktimestamp < 10) then
		if valkevent == nil and grabbedname == nil then
			for x=1, GetNumRaidMembers() do
				local Valkplayer = UnitName("raid"..x)
				if UnitInVehicle(Valkplayer) and not ValkGrabbed[Valkplayer] then
					self:GetModule("Display"):StartCooldown(Valkplayer, 69037, 30," |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_"..GrabbedIcon..":20:20|t")
					self:ValkScannerReporter(Valkplayer)
					ValkGrabbed[Valkplayer] = true 
					GrabbedIcon = GrabbedIcon + 1
				end
			end
			self:ScheduleTimer(function() self:ValkScanner() end, 0.5)
		elseif grabbedname ~= nil and not ValkGrabbed[grabbedname] then
			self:GetModule("Display"):StartCooldown(grabbedname, 69037, 30," |TInterface\\TargetingFrame\\UI-RaidTargetingIcon_"..GrabbedIcon..":20:20|t")
			self:ValkScannerReporter(grabbedname)
			ValkGrabbed[grabbedname] = true 
			GrabbedIcon = GrabbedIcon + 1
		end
	elseif summonvalktimestamp ~= nil and (GetTime() - summonvalktimestamp > 15) and (GetTime() - summonvalktimestamp < 30) and valkevent ~= nil and grabbedname ~= nil then
		self:GetModule("Display"):StopCooldown(grabbedname,69037, "True")
		table.wipe(ValkGrabbed)
		GrabbedIcon = 2
	else
		table.wipe(ValkGrabbed)
		GrabbedIcon = 2
	end
end

function FatCooldowns:RemoveToT()
	for i = 1, 40 do
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId  = UnitBuff("player",i)
		if spellId == 59628 then
			CancelUnitBuff("player",i)
		end
	end 
end

function FatCooldowns:DefileFlash(event, timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName)
	if FatCooldowns:GetModule("Display").db.profile.LKDefileOnYou and ((eventType == "SPELL_CAST_START" and spellName == tostring(GetSpellInfo(27177)) and UnitName("boss1target") == UnitName("player")) or (UnitCastingInfo("boss1") == tostring(GetSpellInfo(27177)) and UnitName("boss1target") == UnitName("player"))) then
		AlertFrameFlashScreen(
			FatCooldowns:GetModule("Display").db.profile.LKDefileOnYouColor["r"],
			FatCooldowns:GetModule("Display").db.profile.LKDefileOnYouColor["g"],
			FatCooldowns:GetModule("Display").db.profile.LKDefileOnYouColor["b"],
			FatCooldowns:GetModule("Display").db.profile.LKDefileOnYouColor["a"])
	elseif FatCooldowns:GetModule("Display").db.profile.LKDefileNotOnYou and ((eventType == "SPELL_CAST_START" and spellName == tostring(GetSpellInfo(27177)) and UnitName("boss1target") ~= UnitName("player")) or (UnitCastingInfo("boss1") == tostring(GetSpellInfo(27177)) and UnitName("boss1target") ~= UnitName("player"))) then
		AlertFrameFlashScreen(
			FatCooldowns:GetModule("Display").db.profile.LKDefileNotOnYouColor["r"],
			FatCooldowns:GetModule("Display").db.profile.LKDefileNotOnYouColor["g"],
			FatCooldowns:GetModule("Display").db.profile.LKDefileNotOnYouColor["b"],
			FatCooldowns:GetModule("Display").db.profile.LKDefileNotOnYouColor["a"])
	end
end

function FatCooldowns:SpiritFlash(event, timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName)
	if FatCooldowns:GetModule("Display").db.profile.LDYSpirits then
		AlertFrameFlashScreen(
			FatCooldowns:GetModule("Display").db.profile.LDYSpiritsColor["r"],
			FatCooldowns:GetModule("Display").db.profile.LDYSpiritsColor["g"],
			FatCooldowns:GetModule("Display").db.profile.LDYSpiritsColor["b"],
			FatCooldowns:GetModule("Display").db.profile.LDYSpiritsColor["a"])
	end
end

function FatCooldowns:FCDCHATREPORTER(event, timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, ...)
	local instancename, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
	local arg = {...}
	
	if not UnitAffectingCombat("player") and UnitName("boss1") == nil and not IsStealthed() and not UnitBuff("player", tostring(GetSpellInfo(1856))) and not UnitBuff("player", tostring(GetSpellInfo(5384))) and not UnitBuff("player", tostring(GetSpellInfo(66))) then
		combatstarttimestamp = nil Sundercount = nil sundercountplayers = false Sundercountchecked = 0 warrtank = false TimeH = 1 TimeH2 = 1 RolesChecked = true table.wipe(healers) ppsummonooze = nil ppsummonooze2 = nil
		weaponname1 = nil GasDelay = nil GasName1 = nil GasName2 = nil GasName3 = nil WarlockBoomkinFail = 0 table.wipe(EmpShockTargetsTanks) table.wipe(EmpShockTargetsHealers) specchecked = nil
		if UnitInRaid("player") and IsCombat then IsCombat = false self:ScheduleTimer(function() self:SetGroupLoot() end, 0.5) end
	end

	if UnitInRaid("player") and not IsCombat and UnitAffectingCombat("player") and UnitName("boss1") ~= nil then IsCombat = true self:ScheduleTimer(function() self:SetMasterLoot() end, 0.5) end

	if UnitAffectingCombat("player") and UnitName("boss1") ~= nil and combatstarttimestamp == nil then combatstarttimestamp = GetTime() end

	if FatCooldowns:GetModule("Display").db.profile.reporter[98876] and dstName == UnitName("player") and eventType == "SPELL_AURA_APPLIED" and arg[2] and arg[2] == "DEBUFF" and spellId == 15571 and UnitBuff("player", tostring(GetSpellInfo(13159))) then
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("player", tostring(GetSpellInfo(13159)))
		if UnitInRaid("player") then
			FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(GetSpellLink(15571).." applied from "..UnitName(unitCaster).."'s: "..GetSpellLink(13159), RAID)
		else
			FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(GetSpellLink(15571).." applied from "..UnitName(unitCaster).."'s: "..GetSpellLink(13159), PARTY) 
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99857] and UnitName("boss1") ~= nil and eventType == "SPELL_CAST_SUCCESS" and spellName == tostring(GetSpellInfo(8647)) and UnitInRaid(srcName) and maxPlayers == 25 then
		self:GetModule("Display"):chatreporter(srcName, 99857, 1,nil,nil,nil,nil,nil, "Warning: "..srcName.." Cast Expose Armor on "..dstName)
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[98984] then
		if UnitName("boss1") == L["Valithria Dreamwalker"] and UnitHealth("boss1") / UnitHealthMax("boss1") < 0.99 then
			if eventType == "SPELL_AURA_REMOVED" and (spellName == L["Twisted Nightmares"] or spellName == L["Emerald Vigor"]) and dstName ~= L["Valithria Dreamwalker"] and spellId ~= 71940 then
				self:GetModule("Display"):chatreporter(playerName, 98984, nil, nil, nil, nil, nil, nil, "FCD: "..dstName.." has lost stacks, current stacks 0")
				DreamDebuffs[dstName] = nil
			end
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99888] then
		if ParryCounterSetMembersSindra == "true" and not UnitAffectingCombat("player") and UnitName("boss1") == nil and not IsStealthed() and not UnitBuff("player", tostring(GetSpellInfo(1856))) and not UnitBuff("player", tostring(GetSpellInfo(5384))) and not UnitBuff("player", tostring(GetSpellInfo(66))) then 
			local ParryCounterText = nil
			if ParryCounter ~= nil then self:SortTable(ParryCounter) end
			for player in pairs(ParryCounter) do
				if ParryCounterText == nil and ParryCounter[player][1] ~= 0 then
					ParryCounterText = player.." - "..ParryCounter[player][1]
				elseif ParryCounterText ~= nil and ParryCounter[player][1] ~= 0 then
					ParryCounterText = ParryCounterText..", "..player.." - "..ParryCounter[player][1]
				end
			end
			if ParryCounterText ~= nil then 
				self:GetModule("Display"):chatreporter(srcName, 99888, 1,nil,nil,nil,nil,nil, "ParryCounter: "..ParryCounterText)
			end	
			ParryCounterSetMembersSindra = nil
			ParryCounter = nil
			ParryCounterText = nil
		end	
		if UnitName("boss1") == L["Sindragosa"] then
			if ParryCounterSetMembersSindra == nil then 
				for x=1, GetNumRaidMembers() do
					local player = UnitName("raid"..x)
					ParryCounter = ParryCounter or {}
					ParryCounter[player] = ParryCounter[player] or {}
					ParryCounter[player][1] = ParryCounter[player][1] or 0
				end
				ParryCounterSetMembersSindra = "true"
			elseif (arg[2] == "PARRY" or spellId == "PARRY") and dstName == L["Sindragosa"] and UnitInRaid(srcName) and UnitIsPlayer(srcName) and UnitName("boss1target") ~= nil then 
				local player = srcName
				if not ParryCounter[player] then 
				else
					ParryCounter[player][1] = ParryCounter[player][1] + 1
				end
			end
		end
	end

  	if UnitName("boss1") == L["The Lich King"] then
  		if ((eventType == "SPELL_CAST_START" and spellName == tostring(GetSpellInfo(27177))) or (UnitCastingInfo("boss1") == tostring(GetSpellInfo(27177)))) and (DefileTimer == 0 or GetTime() - DefileTimer > 20) then
	  		self:ScheduleTimer(function() self:DefileFlash(event, timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName) end, 0.2)
	  		DefileTimer = GetTime()
		end
  	end


	if dstName == L["Halion"] and (arg[2] == "PARRY" or spellId == "PARRY") then
		local TempSrcName = srcName
		local checkPet, oname = isPet(srcName)
		if checkPet then TempSrcName = oname end
		local Phase = nil
		if UnitName("boss1") == L["Halion"] and UnitHealth("boss1") / UnitHealthMax("boss1") > 0.75 then Phase = 1
		elseif UnitName("boss1") == L["Halion"] and UnitHealth("boss1") / UnitHealthMax("boss1") > 0.50 then Phase = 2
		elseif UnitName("boss1") == L["Halion"] and UnitHealth("boss1") / UnitHealthMax("boss1") < 0.50 and UnitBuff("boss1", tostring(GetSpellInfo(75476))) then Phase = 3
		elseif UnitName("boss1") == L["Halion"] and UnitHealth("boss1") / UnitHealthMax("boss1") < 0.50 and not UnitBuff("boss1", tostring(GetSpellInfo(75476))) then Phase = 4
		end
		if Phase ~= nil then self:SendCommMessage("FCDPARRYCOUNTER", self:Serialize("FCDPARRYCOUNTER "..TempSrcName.." "..time().." "..Phase), "RAID", target) Phase = nil end
	end

	if (FatCooldowns:GetModule("Display").db.profile.reporter[99880] or FatCooldowns:GetModule("Display").db.profile.reporter[99881] or FatCooldowns:GetModule("Display").db.profile.reporter[99882]) then
		if ParryCounterSetMembers == "true" and not UnitAffectingCombat("player") and UnitName("boss1") == nil and not IsStealthed() and not UnitBuff("player", tostring(GetSpellInfo(1856))) and not UnitBuff("player", tostring(GetSpellInfo(5384))) and not UnitBuff("player", tostring(GetSpellInfo(66))) then 
			if FatCooldowns:GetModule("Display").db.profile.reporter[99880] then 
				local ParryCounterText1 = nil
				if ParryCounterH1 ~= nil then self:SortTable(ParryCounterH1) end
				for player in pairs(ParryCounterH1) do
					if ParryCounterText1 == nil and ParryCounterH1[player][1] ~= 0 then 
						ParryCounterText1 = player.." - "..ParryCounterH1[player][1]
					elseif ParryCounterText1 ~= nil and ParryCounterH1[player][1] ~= 0 then 
						ParryCounterText1 = ParryCounterText1..", "..player.." - "..ParryCounterH1[player][1]
					end
				end
				if ParryCounterText1 ~= nil then 
					self:GetModule("Display"):chatreporter(srcName, 99880, 1,nil,nil,nil,nil,nil, "ParryCounterP1: "..ParryCounterText1)
				end	
				ParryCounterSetMembers = nil
				table.wipe(ParryCounterH1)
				ParryCounterText1 = nil
			end
			if FatCooldowns:GetModule("Display").db.profile.reporter[99881] then
				local ParryCounterText2 = nil
				if ParryCounterH2 ~= nil then self:SortTable(ParryCounterH2) end
				for player in pairs(ParryCounterH2) do
					if ParryCounterText2 == nil and ParryCounterH2[player][1] ~= 0 then
						ParryCounterText2 = player.." - "..ParryCounterH2[player][1]
					elseif ParryCounterText2 ~= nil and ParryCounterH2[player][1] ~= 0 then
						ParryCounterText2 = ParryCounterText2..", "..player.." - "..ParryCounterH2[player][1]
					end
				end
				if ParryCounterText2 ~= nil then 
					self:GetModule("Display"):chatreporter(srcName, 99881, 1,nil,nil,nil,nil,nil, "ParryCounterP2: "..ParryCounterText2)
				end	
				ParryCounterSetMembers = nil
				table.wipe(ParryCounterH2)
				ParryCounterText2 = nil
			end
			if FatCooldowns:GetModule("Display").db.profile.reporter[99882] then
				local ParryCounterText3 = nil
				if ParryCounterH3 ~= nil then self:SortTable(ParryCounterH3) end
				for player in pairs(ParryCounterH3) do
					if ParryCounterText3 == nil and ParryCounterH3[player][1] ~= 0 then
						ParryCounterText3 = player.." - "..ParryCounterH3[player][1]
					elseif ParryCounterText3 ~= nil and ParryCounterH3[player][1] ~= 0 then
						ParryCounterText3 = ParryCounterText3..", "..player.." - "..ParryCounterH3[player][1]
					end
				end
				if ParryCounterText3 ~= nil then 
					self:GetModule("Display"):chatreporter(srcName, 99882, 1,nil,nil,nil,nil,nil, "ParryCounterP3(In): "..ParryCounterText3)
				end	
				ParryCounterSetMembers = nil
				table.wipe(ParryCounterH3)
				ParryCounterText3 = nil
			end
			if FatCooldowns:GetModule("Display").db.profile.reporter[99882] then
				local ParryCounterText4 = nil
				if ParryCounterH4 ~= nil then self:SortTable(ParryCounterH4) end
				for player in pairs(ParryCounterH4) do
					if ParryCounterText4 == nil and ParryCounterH4[player][1] ~= 0 then
						ParryCounterText4 = player.." - "..ParryCounterH4[player][1]
					elseif ParryCounterText4 ~= nil and ParryCounterH4[player][1] ~= 0 then
						ParryCounterText4 = ParryCounterText4..", "..player.." - "..ParryCounterH4[player][1]
					end
				end
				if ParryCounterText4 ~= nil then 
					self:GetModule("Display"):chatreporter(srcName, 99882, 1,nil,nil,nil,nil,nil, "ParryCounterP3(Out): "..ParryCounterText4)
				end	
				ParryCounterSetMembers = nil
				table.wipe(ParryCounterH4)
				ParryCounterText4 = nil
			end
		end	
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99997] and (eventType == "UNIT_DIED" or eventType == "PARTY_KILL") and (dstName == L["Gas Cloud"] or dstName == L["Ooze Variable"]) then oozedead = false end

	if eventType == "UNIT_DIED" and UnitName("boss1") ~= L["Sindragosa"] and UnitName("boss1") ~= L["Halion"] then return end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99805] and UnitName("boss1") == L["Lady Deathwhisper"] and self:BagsFree() > 3 and GetNumEquipmentSets() <= 9 then 
		if weaponname1 == nil then
			if LGT:GetUnitTalentSpec("player") == nil then LGT:RefreshTalentsByUnit(UnitName("player")) end
			if LGT:GetUnitRole("player") == "melee" then
				SaveEquipmentSet("FCDLDW",769)
			end
			weaponname1 = "done"
		elseif ((eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED") and spellName == tostring(GetSpellInfo(7645)) and dstName == UnitName("player")) or (not HasFullControl() and not UnitIsDead("player")) or UnitDebuff("player", tostring(GetSpellInfo(7645))) then 
			if LGT:GetUnitRole("player") == "melee" and CustomUnitClass("player") ~= L["Hunter"] then
				PickupInventoryItem(16)
	            PutItemInBackpack()
    	        PickupInventoryItem(17)
        	    PutItemInBackpack()
				weaponname2 = "done"
            elseif CustomUnitClass("player") == L["Hunter"] then
				PickupInventoryItem(18)
                PutItemInBackpack()
				weaponname2 = "done"
            end
        elseif weaponname2 == "done" and not UnitIsDead("player") then
        	weaponname2 = nil
        	self:ScheduleTimer(function() self:AutoWeapon() end, 10.2)
			self:ScheduleTimer(function() self:AutoWeapon() end, 11.7)
			self:ScheduleTimer(function() self:AutoWeapon() end, 13.3)
			self:ScheduleTimer(function() self:AutoWeapon() end, 14.7)
			self:ScheduleTimer(function() self:AutoWeapon() end, 16.3)
			self:ScheduleTimer(function() self:AutoWeapon() end, 17.7)
			self:ScheduleTimer(function() self:AutoWeapon() end, 19.2)
			self:ScheduleTimer(function() self:AutoWeapon() end, 20.7)
        elseif eventType == "SPELL_AURA_REMOVED" and spellName == tostring(GetSpellInfo(7645)) and dstName == UnitName("player") then 
	      	if LGT:GetUnitRole("player") == "melee" then
				self:ScheduleTimer(function() self:AutoWeapon() end, 0.2)
				self:ScheduleTimer(function() self:AutoWeapon() end, 1.7)
				self:ScheduleTimer(function() self:AutoWeapon() end, 3.3)
				self:ScheduleTimer(function() self:AutoWeapon() end, 4.7)
				self:ScheduleTimer(function() self:AutoWeapon() end, 6.3)
				self:ScheduleTimer(function() self:AutoWeapon() end, 7.7)
				self:ScheduleTimer(function() self:AutoWeapon() end, 9.2)
				self:ScheduleTimer(function() self:AutoWeapon() end, 10.7)
            end
        end
    end

   if FatCooldowns:GetModule("Display").db.profile.reporter[99894] and UnitName("boss1") == L["Lady Deathwhisper"] then
    	if (eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED") and spellName == tostring(GetSpellInfo(7645)) and dstName == UnitName("player") then
    		for k,v in pairs(buffsandprocs) do
    			local SpellNameBuff = GetSpellInfo(v)
    			if SpellNameBuff ~= nil and UnitBuff("player", SpellNameBuff) then CancelUnitBuff("player", SpellNameBuff) end
    		end
    		buffsandprocscheck = GetTime()
    	end
    end

    if FatCooldowns:GetModule("Display").db.profile.reporter[99893] and UnitName("boss1") ~= nil and LGT:GetUnitRole("player") == "melee" then
     	if  UnitBuff("player", tostring(GetSpellInfo(10278))) then CancelUnitBuff("player", tostring(GetSpellInfo(10278))) end 
     	if  UnitBuff("player", tostring(GetSpellInfo(5599))) then CancelUnitBuff("player", tostring(GetSpellInfo(5599))) end 
     	if  UnitBuff("player", tostring(GetSpellInfo(1022))) then CancelUnitBuff("player", tostring(GetSpellInfo(1022))) end 
    end
    if FatCooldowns:GetModule("Display").db.profile.reporter[99885] and UnitName("boss1") ~= nil and LGT:GetUnitRole("player") == "tank" then
     	if  UnitBuff("player", tostring(GetSpellInfo(10278))) then CancelUnitBuff("player", tostring(GetSpellInfo(10278))) end 
     	if  UnitBuff("player", tostring(GetSpellInfo(5599))) then CancelUnitBuff("player", tostring(GetSpellInfo(5599))) end 
     	if  UnitBuff("player", tostring(GetSpellInfo(1022))) then CancelUnitBuff("player", tostring(GetSpellInfo(1022))) end 
     end
    if FatCooldowns:GetModule("Display").db.profile.reporter[99864] and UnitName("boss1") ~= nil and LGT:GetUnitRole("player") == "tank" and UnitBuff("player", tostring(GetSpellInfo(642))) then	CancelUnitBuff("player", tostring(GetSpellInfo(642))) end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99965] and UnitName("boss1") == L["Festergut"] and maxPlayers == 25 then 
		if eventType == "SPELL_CAST_SUCCESS" and spellName == tostring(GetSpellInfo(69240)) then
			if GasName1 == nil and dstName ~= GasName3 and dstName ~= GasName2 then GasName1 = dstName end		
			if GasName2 == nil and dstName ~= GasName1 and dstName ~= GasName3 then GasName2 = dstName end		
			if GasName3 == nil and dstName ~= GasName1 and dstName ~= GasName2 then GasName3 = dstName end
			GasDelay = GetTime()
		elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(69240)) and GasDelay ~= nil and GetTime() - GasDelay < 2.8 then
			if dstName ~= GasName1 and dstName ~= GasName3 and dstName ~= GasName2 then
				vilegastargets[#vilegastargets + 1] = dstName
			end
		elseif GasDelay ~= nil and GetTime() - GasDelay > 2.8 and GasName3 ~= nil and GasName2 ~= nil and GasName1 ~= nil then
			local GasText = nil
			for index, vilegasplayertargets in pairs(vilegastargets) do
				if GasText == nil then
					GasText = vilegasplayertargets
				else
					GasText = GasText..", "..vilegasplayertargets
				end
			end
			if GasText == nil then
				local text = "Vile Gas on: "..GasName1..", "..GasName2..", "..GasName3
				self:GetModule("Display"):chatreporter(srcName, 99965, 1,nil,nil,nil,nil,nil, text)
			else
				local text = "Vile Gas on: "..GasName1..", "..GasName2..", "..GasName3.." Extra: "..GasText
				self:GetModule("Display"):chatreporter(srcName, 99965, 1,nil,nil,nil,nil,nil, text)
			end
			GasText = nil
			GasName1 = nil
			GasName2 = nil
			GasName3 = nil
			GasDelay = nil
			table.wipe(vilegastargets)
		end 
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99964] and UnitName("boss1") ~= nil and UnitName("boss1") ~= L["Professor Putricide"] and UnitName("boss1") ~= L["Prince Keleseth"] and UnitName("boss1") ~= L["Prince Taldaram"] and UnitName("boss1") ~= L["Prince Valanar"] and
		combatstarttimestamp ~= nil and maxPlayers == 25 then
		if sundercountplayers == false then 
			for x=1, GetNumRaidMembers() do
				local player = UnitName("raid"..x)
				local playerclass = CustomUnitClass(player)
				if playerclass == L["Warrior"] then
					if UnitHealthMax(player) >= 55000 then warrtank = true end
					Sundercount = Sundercount or {}
					Sundercount[player] = Sundercount[player] or {}
					Sundercount[player][1] = Sundercount[player][1] or 0 
				end
				playerclass = nil
				player = nil
			end
			sundercountplayers = true
		end
		if eventType == "SPELL_AURA_REMOVED" and spellName == tostring(GetSpellInfo(7386)) and srcName == UnitName("boss1") then Sundercountchecked = 0 end
		if UnitInRaid(srcName) and (spellName == tostring(GetSpellInfo(7386)) or spellId == 7386) and eventType == "SPELL_CAST_SUCCESS" and UnitLevel(raidIbyName(srcName).."target") == -1 then
			local player = srcName
			if not Sundercount[player] then
			else
				Sundercount[player][1] = Sundercount[player][1] + 1
				Sundercountchecked = Sundercountchecked + 1
			end
			if Sundercountchecked == 5 and not warrtank then
				local Sundertext = nil
				if Sundercount ~= nil then self:SortTable(Sundercount) end
				for player in pairs(Sundercount) do
					if Sundertext == nil then
						Sundertext = player.." - "..Sundercount[player][1]
					else
						Sundertext = Sundertext..", "..player.." - "..Sundercount[player][1]
					end
				end
				if Sundertext ~= nil then
					local time = string.format("%.0f", (GetTime() - combatstarttimestamp))
					self:GetModule("Display"):chatreporter(srcName, 99964, 1,nil,nil,nil,nil,nil, "5 Sunder's "..time.."sec: "..Sundertext)
					player = nil
					time = nil
					Sundertext = nil
				end
			end
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99966] and not UnitAffectingCombat("player") and UnitName("boss1") ~= L["The Lich King"] and not IsStealthed() and not UnitBuff("player", tostring(GetSpellInfo(1856))) and not UnitBuff("player", tostring(GetSpellInfo(66))) then
		if warriorhowlschecked == 1 then 
			local Holwstext = nil
			if warriorhowls ~= nil then self:SortTable(warriorhowls) end
			for player in pairs(warriorhowls) do
				if Holwstext == nil then
					Holwstext = player.." - "..warriorhowls[player][1]
				else
					Holwstext = Holwstext..", "..player.." - "..warriorhowls[player][1]
				end
			end
			if Holwstext ~= nil then 
				self:GetModule("Display"):chatreporter(srcName, 99966, 1,nil,nil,nil,nil,nil, "Piercing Howl's: "..Holwstext)
				Holwstext = nil
			end
		end
		if warriorhowlschecked == 1 or warriorhowlschecked == true then 
			warriorhowls = nil
			warriorhowlschecked = nil
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99966] and UnitName("boss1") == L["The Lich King"] and maxPlayers == 25 then 
		if warriorhowlschecked == nil and UnitHealth("boss1") / UnitHealthMax("boss1") > 0.90 then 
			for sx=1, GetNumRaidMembers() do
				local player = UnitName("raid"..sx)
				local playerclass = CustomUnitClass(player)
				if playerclass == L["Warrior"] then
					warriorhowls = warriorhowls or {}
					warriorhowls[player] = warriorhowls[player] or {}
					warriorhowls[player][1] = warriorhowls[player][1] or 0 
				end
				player = nil
				playerclass = nil
			end
			warriorhowlschecked = true
		elseif UnitHealth("boss1") / UnitHealthMax("boss1") > 0.38 and UnitHealth("boss1") / UnitHealthMax("boss1") < 0.68 then 
			if eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(12323)) or spellId == 12323) and UnitInRaid(srcName) and summonvalktimestamp ~= nil and GetTime() - summonvalktimestamp <= 30  then 
				local player = srcName
				if not warriorhowls[player][1] then
				else
					warriorhowls[player][1] = warriorhowls[player][1] + 1
					warriorhowlschecked = 1
				end
				player = nil
			end
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99962] and UnitName("boss1") == L["The Lich King"] and maxPlayers == 25 and spellId == 69200 and eventType == "SPELL_CAST_SUCCESS" then
		if WarlockBoomkinFail == 0 or WarlockBoomkinFail == 4 then
			if not UnitDebuff("boss1", tostring(GetSpellInfo(1490))) then self:GetModule("Display"):chatreporter(srcName, 99962, 1,nil,nil,nil,nil,nil, "Warning: Warlock Fail no \124cff71d5ff\124Hspell:47865\124h[Curse of the Elements]\124h\124r on LK") end
			if not UnitDebuff("boss1", tostring(GetSpellInfo(770))) then self:GetModule("Display"):chatreporter(srcName, 99962, 1,nil,nil,nil,nil,nil, "Warning: Boomkin Fail no \124cff71d5ff\124Hspell:770\124h[Faerie Fire]\124h\124r on LK") end
		end
		WarlockBoomkinFail = WarlockBoomkinFail + 1
	end

	if UnitName("boss1") == L["The Lich King"] and spellId == 69037 and eventType == "SPELL_SUMMON" and FatCooldowns.ExPac == 2 then
		if summonvalktimestamp == nil or (summonvalktimestamp ~= nil and GetTime() - summonvalktimestamp > 15) then
			summonvalktimestamp = GetTime()
		end
		Valkyrs[dstGUID] = Valk25MaxHP
		self:ValkScanner()
	end

	if FatCooldowns:GetModule("Display").db.profile.AutoIconValk and FatCooldowns:GetModule("Display").db.profile.AutoIconValkName ~= nil then
		if not UnitInRaid(FatCooldowns:GetModule("Display").db.profile.AutoIconValkName) then FatCooldowns:GetModule("Display").db.profile.AutoIconValkName = nil end
	end
	if FatCooldowns:GetModule("Display").db.profile.AutoIconValk and FatCooldowns:GetModule("Display").db.profile.AutoIconFrostmourne ~= nil then
		if not UnitInRaid(FatCooldowns:GetModule("Display").db.profile.AutoIconFrostmourneName) then FatCooldowns:GetModule("Display").db.profile.AutoIconFrostmourneName = nil end
	end

	if FatCooldowns:GetModule("Display").db.profile.AutoIconValk and UnitName("boss1") == L["The Lich King"] and (IsRaidLeader() or IsRaidOfficer()) and spellId == 72262 and dynamicDifficulty == 1 and
		FatCooldowns:GetModule("Display").db.profile.AutoIconValkName ~= nil and
		UnitInRaid(FatCooldowns:GetModule("Display").db.profile.AutoIconValkName) and FatCooldowns:GetModule("Display").db.profile.AutoIconValkIcon ~= nil and FatCooldowns:GetModule("Display").db.profile.AutoIconValkIcon ~= 1 then
		local iconinusevalk = false
		if iconinusevalk then iconinusevalk = false end
		for x=1, GetNumRaidMembers() do
			if GetRaidTargetIndex("raid"..x) == (FatCooldowns:GetModule("Display").db.profile.AutoIconValkIcon - 1) then iconinusevalk = true end
		end
		if not iconinusevalk then SetRaidTarget(FatCooldowns:GetModule("Display").db.profile.AutoIconValkName, (FatCooldowns:GetModule("Display").db.profile.AutoIconValkIcon - 1)) iconinusevalk = true end
	end
	if FatCooldowns:GetModule("Display").db.profile.AutoIconFrostmourne and UnitName("boss1") == L["The Lich King"] and (IsRaidLeader() or IsRaidOfficer()) and spellId == 74296 and dynamicDifficulty == 1 and
		FatCooldowns:GetModule("Display").db.profile.AutoIconFrostmourneName ~= nil and
		UnitInRaid(FatCooldowns:GetModule("Display").db.profile.AutoIconFrostmourneName) and FatCooldowns:GetModule("Display").db.profile.AutoIconFrostmourneIcon ~= nil and FatCooldowns:GetModule("Display").db.profile.AutoIconFrostmourneIcon ~= 1 then
		local iconinusefrost = false
		if iconinusefrost then iconinusefrost = false end
		for x=1, GetNumRaidMembers() do
			if GetRaidTargetIndex("raid"..x) == (FatCooldowns:GetModule("Display").db.profile.AutoIconFrostmourneIcon - 1) then iconinusefrost = true end
		end
		if not iconinusefrost then SetRaidTarget(FatCooldowns:GetModule("Display").db.profile.AutoIconFrostmourneName, (FatCooldowns:GetModule("Display").db.profile.AutoIconFrostmourneIcon - 1)) iconinusefrost = true end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99977] and srcName == UnitName("player") and eventType == "SPELL_DISPEL" and LastDispelled ~= arg[2] then
		LastDispelled = arg[2]			
		text = FCDColorName(srcName).." Dispelled "..GetSpellLink(arg[2]).." From "..(FCDColorName(dstName) or "?")
		if FatCooldowns:GetModule("Display").db.profile.reporter[99977] then FatCooldowns:GetModule("Display"):FCDPrefixPrint(text) text = nil end
	end 

	if instancename == L["The Ruby Sanctum"] and (FatCooldowns:GetModule("Display").db.profile.reporter[99979] or FatCooldowns:GetModule("Display").db.profile.reporter[99978]) then
		if spellId == 74833 and spellName == tostring(GetSpellInfo(74826)) and eventType == "SPELL_AURA_APPLIED" and UnitHealth("boss1") / UnitHealthMax("boss1") > 0.07  then
			if FatCooldowns:GetModule("Display").db.profile.reporter[99979] then PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\StopDamage.mp3", "Master") end
			if FatCooldowns:GetModule("Display").db.profile.reporter[99978] then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("Stop Damege, 70%/30%", "SAY") end
		end
	end

	if instancename == L["The Ruby Sanctum"] and FatCooldowns:GetModule("Display").db.profile.reporter[99960] and (eventType == "SWING_DAMAGE" or eventType == "SWING_MISSED") and srcName == L["Halion"] and dynamicDifficulty == 1 then
		TimeH = TimeH2
		TimeH2 = timestamp
		if (TimeH2 - TimeH) <= 1.5 then
			self:GetModule("Display"):chatreporter(srcName, 99960, 1,nil,nil,nil,nil,nil, "Boss has done a PARRY HASTED attack")
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99883] and (UnitName("boss1") == L["Prince Valanar"] or UnitName("boss1") == L["Prince Keleseth"] or UnitName("boss1") == L["Prince Taldaram"]) then
		if eventType == "SPELL_CAST_SUCCESS" and dstName == tostring(GetSpellInfo(72052)) and (spellName == tostring(GetSpellInfo(100)) or spellName == tostring(GetSpellInfo(47482)) or spellName == tostring(GetSpellInfo(30151))) then
			local checkPet, oname = isPet(srcName)
			if checkPet then self:GetModule("Display"):chatreporter(srcName, 99883, 1,nil,nil,nil,nil,nil, "Warning: "..oname.."'s pet used "..spellName.." on Kinetic") end
			checkPet = nil
			oname = nil
		end
	end

	if instancename == L["The Ruby Sanctum"] then
		if eventType == "SPELL_AURA_APPLIED" then
			if FatCooldowns:GetModule("Display").db.profile.RSDFCOn and spellName == tostring(GetSpellInfo(74562)) and dstName == UnitName("player") then
				AlertFrameFlashScreen(
					FatCooldowns:GetModule("Display").db.profile.RSDFCColor["r"],
					FatCooldowns:GetModule("Display").db.profile.RSDFCColor["g"],
					FatCooldowns:GetModule("Display").db.profile.RSDFCColor["b"],
					FatCooldowns:GetModule("Display").db.profile.RSDFCColor["a"])
			end
			if FatCooldowns:GetModule("Display").db.profile.RSDSCOn and spellName == tostring(GetSpellInfo(74792)) and dstName == UnitName("player") then
				AlertFrameFlashScreen(
					FatCooldowns:GetModule("Display").db.profile.RSDSCColor["r"],
					FatCooldowns:GetModule("Display").db.profile.RSDSCColor["g"],
					FatCooldowns:GetModule("Display").db.profile.RSDSCColor["b"],
					FatCooldowns:GetModule("Display").db.profile.RSDSCColor["a"])
			end
		end
	end

	if instancename == L["The Ruby Sanctum"] and FatCooldowns:GetModule("Display").db.profile.reporter[99991] then
		local text = nil
		if eventType == "SPELL_AURA_REMOVED" and (spellName == tostring(GetSpellInfo(74562)) or spellName == tostring(GetSpellInfo(74792))) and marktimestamp[dstName] ~= nil and timestamp - marktimestamp[dstName] > 28 then
			if spellName == tostring(GetSpellInfo(74562)) then
				text = dstName.." Failed to move with "..GetSpellLink(74567).." after 30Sec"
				self:GetModule("Display"):chatreporter(srcName, 99991, 1,nil,nil,nil,nil,nil, text)
				table.remove(marktimestamp, marktimestamp[dstName])
			elseif spellName == tostring(GetSpellInfo(74792)) then
				text = dstName.." Failed to move with "..GetSpellLink(74795).." after 30Sec"
				self:GetModule("Display"):chatreporter(srcName, 99991, 1,nil,nil,nil,nil,nil, text)
				table.remove(marktimestamp, marktimestamp[dstName])
		end
		elseif  eventType == "UNIT_DIED" and (UnitDebuff(dstName, tostring(GetSpellInfo(74562))) or UnitDebuff(dstName, tostring(GetSpellInfo(74792))) or UnitDebuff(dstName, tostring(GetSpellInfo(74567))) or UnitDebuff(dstName, tostring(GetSpellInfo(74795)))) then
			if marktimestamp[dstName] == nil then return else DispelTime = string.format("%.1f", (timestamp - marktimestamp[dstName])) end
			text = dstName.." died with Debuff after "..DispelTime.." Seconds"
			self:GetModule("Display"):chatreporter(dstName, 99991, 1,nil,nil,nil,nil,nil, text)
			text = nil
			if marktimestamp[dstName] ~= nil then table.remove(marktimestamp, marktimestamp[dstName]) end
		elseif (spellName == tostring(GetSpellInfo(74567)) or spellName == tostring(GetSpellInfo(74795))) and eventType == "SPELL_AURA_APPLIED" then
			marktimestamp[dstName] = timestamp
		elseif (eventType == "SPELL_DISPEL" and (arg[3] == tostring(GetSpellInfo(74562)) or arg[3] == tostring(GetSpellInfo(74792)) or arg[3] == tostring(GetSpellInfo(74567)) or arg[3] == tostring(GetSpellInfo(74795)))) or (eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(642)) or spellName == tostring(GetSpellInfo(31224)) or spellName == tostring(GetSpellInfo(45438))) and (UnitDebuff(srcName, tostring(GetSpellInfo(74795))) or UnitDebuff(srcName, tostring(GetSpellInfo(74567)))))  then
			if eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(642)) or spellName == tostring(GetSpellInfo(31224)) or spellName == tostring(GetSpellInfo(45438))) then 
				if UnitDebuff(srcName, tostring(GetSpellInfo(74795))) then markid = GetSpellLink(74795) 
				elseif UnitDebuff(srcName, tostring(GetSpellInfo(74567))) then markid = GetSpellLink(74567) end
				if marktimestamp[srcName] ~= nil then DispelTime = string.format("%.1f", (timestamp - marktimestamp[srcName])) else DispelTime = "?" end
				text = srcName.." has dispelled the mark with Bubble, Cloak or Ice Block after "..DispelTime.." Seconds"
				if CustomUnitClass(srcName) == L["Paladin"] then text = srcName.." has dispelled "..markid.." with "..GetSpellLink(642).." after "..DispelTime.." Seconds" 
				elseif CustomUnitClass(srcName) == L["Mage"] then text = srcName.." has dispelled "..markid.." with "..GetSpellLink(45438).." after "..DispelTime.." Seconds" 
				elseif CustomUnitClass(srcName) == L["Rogue"] then text = srcName.." has dispelled "..markid.." with "..GetSpellLink(31224).." after "..DispelTime.." Seconds" end
				self:GetModule("Display"):chatreporter(srcName, 99991, 1,nil,nil,nil,nil,nil, text)
				text = nil
				if marktimestamp[dstName] ~= nil then table.remove(marktimestamp, marktimestamp[dstName]) end
			elseif not UnitInRaid(srcName) then 
				local checkPet, oname = isPet(srcName)
				if CustomUnitClass(oname) == L["Warlock"] then
				if marktimestamp[dstName] ~= nil then DispelTime = string.format("%.1f", (timestamp - marktimestamp[dstName])) else DispelTime = "?" end
				text = oname.."'s pet has dispelled "..GetSpellLink(arg[2]).." from "..dstName.." after "..DispelTime.." Seconds"
				self:GetModule("Display"):chatreporter(oname, 99991, 1,nil,nil,nil,nil,nil, text)
				text = nil
				checkPet = nil
				oname = nil
				if marktimestamp[dstName] ~= nil then table.remove(marktimestamp, marktimestamp[dstName]) end end
			else
				if marktimestamp[dstName] ~= nil then DispelTime = string.format("%.1f", (timestamp - marktimestamp[dstName])) else DispelTime = "?" end
				text = srcName.." dispelled "..GetSpellLink(arg[2]).." from "..dstName.." after "..DispelTime.." Seconds"
				self:GetModule("Display"):chatreporter(srcName, 99991, 1,nil,nil,nil,nil,nil, text)
				text = nil
				if marktimestamp[dstName] ~= nil then table.remove(marktimestamp, marktimestamp[dstName]) end
			end
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99901] and UnitName("boss1") == L["Lady Deathwhisper"] and instancename == L["Icecrown Citadel"] and dynamicDifficulty == 1 and (maxPlayers == 25 or maxPlayers == 10) then		
		if (eventType == "SWING_DAMAGE" or eventType == "SWING_MISSED") and srcName == L["Vengeful Shade"] then
			self:GetModule("Display"):chatreporter(dstName, 99901, 1,srcName, nil, nil, eventType, nil, dstName.." has been hit by Vengeful Shade!")
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.LDYSpirits and UnitName("boss1") == L["Lady Deathwhisper"] and instancename == L["Icecrown Citadel"] and eventType == "SPELL_SUMMON" and srcName == L["Lady Deathwhisper"] and dstName == L["Vengeful Shade"] then		
	  	if (SpiritTimer == 0 or GetTime() - SpiritTimer > 10) then
	  		self:ScheduleTimer(function() self:SpiritFlash(event, timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName) end, 0.2)
	  		SpiritTimer = GetTime()
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99902] and UnitName("boss1") == L["Professor Putricide"] then
		if (eventType == "SWING_DAMAGE" or eventType == "SWING_MISSED") and srcName == "Gas Cloud" then
			self:GetModule("Display"):chatreporter(dstName, 99902, 1,srcName, nil, nil, eventType,nil,"Red Ooze")
		end
	end
	if UnitName("boss1") == L["Professor Putricide"] then
		if FatCooldowns:GetModule("Display").db.profile.PPGreen and eventType == "SPELL_AURA_APPLIED" and (spellId == 70352 or spellId == 74118) then --Ooze Variable/Green
			AlertFrameFlashScreen(
				FatCooldowns:GetModule("Display").db.profile.PPGreenColor["r"],
				FatCooldowns:GetModule("Display").db.profile.PPGreenColor["g"],
				FatCooldowns:GetModule("Display").db.profile.PPGreenColor["b"],
				FatCooldowns:GetModule("Display").db.profile.PPGreenColor["a"])
		elseif FatCooldowns:GetModule("Display").db.profile.PPOrange and eventType == "SPELL_AURA_APPLIED" and (spellId == 70353 or spellId == 74119) then -- Gas Variable/Orange
			AlertFrameFlashScreen(
				FatCooldowns:GetModule("Display").db.profile.PPOrangeColor["r"],
				FatCooldowns:GetModule("Display").db.profile.PPOrangeColor["g"],
				FatCooldowns:GetModule("Display").db.profile.PPOrangeColor["b"],
				FatCooldowns:GetModule("Display").db.profile.PPOrangeColor["a"])
		end
		if spellName == tostring(GetSpellInfo(70351)) then 
			oozedead = true
			ppsummonooze2 = ppsummonooze
			ppsummonooze = GetTime()
			if ppsummonooze2 ~= nil and ppsummonooze - ppsummonooze2 <= 18 then doublesummonooze = true else doublesummonooze = false end
		end
	end
	

	if instancename == L["Icecrown Citadel"] and UnitName("boss1") == L["Blood-Queen Lana'thel"] then
		if FatCooldowns:GetModule("Display").db.profile.reporter[99800] and UnitBuff("player", tostring(GetSpellInfo(1038))) and UnitHealth("boss1") / UnitHealthMax("boss1") > 0.9 then CancelUnitBuff("player", tostring(GetSpellInfo(1038))) end
		if FatCooldowns:GetModule("Display").db.profile.reporter[99993] and spellName == tostring(GetSpellInfo(70946)) and eventType == "SPELL_CAST_SUCCESS" then
			local text = srcName.." has bitten "..dstName
			self:GetModule("Display"):chatreporter(srcName, 99993, 1, dstName, nil, nil, nil, nil, text)
			text = nil
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[99992] and spellName == tostring(GetSpellInfo(70923)) and eventType == "SPELL_AURA_APPLIED" then
			local text = dstName.." has failed to bite"
			self:GetModule("Display"):chatreporter(srcName, 99992, 1, dstName, nil, nil, nil, nil, text)
			text = nil
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99998] and instancename == L["Icecrown Citadel"] and UnitName("boss1") == L["Sindragosa"] and dynamicDifficulty == 1 then
		if eventType == "UNIT_DIED" and srcName == nil then srcName = dstName end
		if (eventType == "SPELL_AURA_REMOVED" and spellId == 69766 and (BacklashStacks[srcName] ~= nil and BacklashStacks[srcName] ~= 0)) or
		(eventType == "SPELL_CAST_SUCCESS" and (spellId == 642 or spellId == 45438) and (UnitDebuff(srcName, tostring(GetSpellInfo(69770))) or (BacklashStacks[srcName] ~= nil and BacklashStacks[srcName] ~= 0))) or
		(eventType == "UNIT_DIED" and (UnitDebuff(srcName, tostring(GetSpellInfo(69770))) or (BacklashStacks[srcName] ~= nil and BacklashStacks[srcName] ~= 0))) then
			local text = nil
			local time = ""
			local BacklashCount = 0
			for bx=1, GetNumRaidMembers() do
				if not UnitIsDeadOrGhost("raid"..bx) and self:DistanceChecker(srcName,"raid"..bx) <= 20 then
					BacklashCount = BacklashCount + 1
					if BacklashCount <= 14 then
						if text == nil then text = UnitName("raid"..bx)
						else text = text..", "..UnitName("raid"..bx)
						end
					end
				end
			end
			if BacklashTime[srcName] ~= nil and (5 - (GetTime() - BacklashTime[srcName])) > 0.1 then
				time =  " "..string.format("%.1f",5 - (GetTime() - BacklashTime[srcName])).."Sec"
			end

			if eventType == "SPELL_CAST_SUCCESS" and spellId == 642 and text ~= nil then text = srcName.." Bubble".." "..BacklashStacks[srcName].." Hits: "..BacklashCount.." "..text
			elseif eventType == "SPELL_CAST_SUCCESS" and spellId == 45438 and text ~= nil then text = srcName.." Ice Block".." "..BacklashStacks[srcName].." Hits: "..BacklashCount.." "..text
			elseif text ~= nil then text = srcName..time.." "..BacklashStacks[srcName].." Hits: "..BacklashCount..": "..text end
			if text ~= nil and  (BacklashStacks[srcName] >= 5 and (UnitHealth("boss1") / UnitHealthMax("boss1") > 0.30)) or spellId == 642 or spellId == 45438 then
				self:GetModule("Display"):chatreporter(srcName, 99998, 1, dstName, nil, nil, nil, nil, text)
			elseif text ~= nil and BacklashStacks[srcName] >= 1 and (UnitHealth("boss1") / UnitHealthMax("boss1") < 0.30) then
				self:GetModule("Display"):chatreporter(srcName, 99998, 1, dstName, nil, nil, nil, nil, text)
			end
			text = nil
			time = ""
			BacklashStacks[srcName] = 0
			BacklashTime[srcName] = nil
			BacklashCount = 0
		end

		if eventType == "SPELL_AURA_APPLIED" and spellId == 69766 then  
   			BacklashStacks[dstName] = 1
   			BacklashTime[dstName] = GetTime()
 		elseif eventType == "SPELL_AURA_APPLIED_DOSE" and spellId == 69766 then 
    		BacklashStacks[dstName] = arg[3]
    		BacklashTime[dstName] = GetTime()
      	end
    end
	
	if instancename == L["Icecrown Citadel"] and eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(70981)) then Oozetimestamp = timestamp end

	if ((FatCooldowns:GetModule("Display").db.profile.reporter[99985] and dstName == L["Sindragosa"]) or (FatCooldowns:GetModule("Display").db.profile.reporter[99984] and dstName == L["Halion"])) and (instancename == L["The Ruby Sanctum"] or instancename == L["Icecrown Citadel"]) and dynamicDifficulty == 1 then
		if (arg[2] == "PARRY" or spellId == "PARRY") and srcName ~= L["Army of the Dead Ghoul"] and srcName ~= L["Treant"] and srcName ~= L["Venomous Snake"] then
			local playersname = srcName
			local text = nil
			local checkPet, oname = isPet(srcName)
			local bosstarget = UnitName("boss1target")
			if FatCooldowns:GetModule("Display").db.profile.reporter[99874] then 
				playersname = FCDColorName(playersname)
				if bosstarget ~= nil then bosstarget = FCDColorName(bosstarget) end
			end
			if checkPet or oname ~= nil then
				if FatCooldowns:GetModule("Display").db.profile.reporter[99874] then 
					playersname = FCDColorName(oname).."'s pet ("..srcName..")"
					checkPet = nil
					oname = nil 
				else
					playersname = oname.."'s pet ("..srcName..")"
					checkPet = nil
					oname = nil
				end 
			end
			if dstName == L["Sindragosa"] then
				if UnitName("boss1target") ~= nil then
					text = "PARRY: "..playersname.." has caused a PARRY! Boss Target: "..bosstarget
				else
					text = "PARRY: "..playersname.." has caused a PARRY!"
				end
				if FatCooldowns:GetModule("Display").db.profile.reporter[99874] then
					FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Warning "..text)
				else
					self:GetModule("Display"):chatreporter(srcName, 99985, 1,nil,nil,nil,nil,nil,text)
				end
				text = nil
			elseif dstName == L["Halion"] then
				if UnitName("boss1target") ~= nil then
					text = "PARRY: "..playersname.." has caused a PARRY! Boss Target: "..bosstarget
				else
					text = "PARRY: "..playersname.." has caused a PARRY!"
				end
				if FatCooldowns:GetModule("Display").db.profile.reporter[99874] then
					FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Warning "..text)
				else
					self:GetModule("Display"):chatreporter(srcName, 99984, 1,nil,nil,nil,nil,nil,text)
				end
				text = nil
			end
		end	
	end

	if srcName ~= UnitName("player")  and not UnitInParty(srcName) and not UnitInRaid(srcName) then return end -- checks if player is in raid



































	if FatCooldowns:GetModule("Display").db.profile.reporter[99879] and UnitClass("player") == L["Rogue"] then
		if eventType == "SPELL_CAST_SUCCESS" and spellId == 57934 and UnitName("player") == srcName then
			ToTRemover = dstName
		end
		if eventType == "SPELL_AURA_APPLIED" and spellId == 59628 and UnitName("player") == srcName and ToTRemover ~= nil then
			if (UnitClass(ToTRemover) ~= L["Rogue"] or (UnitClass(ToTRemover) == L["Rogue"] and FatCooldowns:GetModule("Display").db.profile.reporter[98879])) then
				local FoundRole = LGT:GetUnitRole(ToTRemover)
				local CustomTankFound = false
				local BuffNameTotRemove = UnitFactionGroup("player") == "Alliance" and tostring(GetSpellInfo(73828)) or tostring(GetSpellInfo(73822))
				if UnitHealthMax(ToTRemover) > (46000 * 1.3) and UnitBuff(ToTRemover,BuffNameTotRemove) then CustomTankFound = true elseif UnitHealthMax(ToTRemover) > 46000  then CustomTankFound = true end
				if UnitBuff(ToTRemover, tostring(GetSpellInfo(48263))) or UnitBuff(ToTRemover, tostring(GetSpellInfo(25780))) then CustomTankFound = true end 
				if FoundRole ~= nil and FoundRole ~= "tank" and CustomTankFound == false then
					self:ScheduleTimer(function() self:RemoveToT() end, 0.1)
				end
			end
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99884] and UnitInRaid("player") and spellName == tostring(GetSpellInfo(8512)) and eventType == "SPELL_SUMMON" and (instancename == L["Icecrown Citadel"] or instancename == L["The Ruby Sanctum"]) and
		(TotemAntiSpamp[srcName] == nil or GetTime() - TotemAntiSpamp[srcName] > 60) then
		local frostdk = nil
		local missingbuffcount = 0
		for fdk=1, GetNumRaidMembers() do
			if UnitBuff("raid"..fdk, tostring(GetSpellInfo(55610))) then frostdk = true end
			if not UnitBuff("raid"..fdk, tostring(GetSpellInfo(3738))) and isUnitRelevant(UnitName("raid"..fdk)) then missingbuffcount = missingbuffcount + 1 end
		end
		if missingbuffcount > 0 then missingbuffcount = " "..missingbuffcount.." missing Spell Haste buff" elseif missingbuffcount == 0 then missingbuffcount = "" end
		if frostdk == true then	self:GetModule("Display"):chatreporter(srcName, 99884, 1,nil,nil,nil,nil,nil,"Warning: "..srcName.." used Windfury Totem with Icy Talons buff in raid"..missingbuffcount) end
		TotemAntiSpamp[srcName] = GetTime()
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99863] and UnitInRaid("player") and spellName == tostring(GetSpellInfo(8075)) and eventType == "SPELL_SUMMON" and (instancename == L["Icecrown Citadel"] or instancename == L["The Ruby Sanctum"]) and
		(TotemAntiSpamp2[srcName] == nil or GetTime() - TotemAntiSpamp2[srcName] > 60) and LGT:GetUnitTalentSpec(srcName) ~= nil and LGT:GetUnitTalentSpec(srcName) ~= L["Enhancement"] then
		local StoneT = nil
		local missingbuffcount = 0
		local missingbuffcount2 = 0
		for ST=1, GetNumRaidMembers() do
			if UnitClass("raid"..ST) == L["Death Knight"] then StoneT = true end
			if not UnitBuff("raid"..ST, tostring(GetSpellInfo(8071))) and isUnitRelevant(UnitName("raid"..ST)) then missingbuffcount = missingbuffcount + 1 missingbuffcount2 = missingbuffcount2 + 1 end
		end
		if missingbuffcount > 0 then missingbuffcount = " "..missingbuffcount.." missing Stoneskin Totem buff" elseif missingbuffcount == 0 then missingbuffcount = "" end
		if StoneT == true and missingbuffcount2 > 0 then 
			self:GetModule("Display"):chatreporter(srcName, 99863, 1,nil,nil,nil,nil,nil,"Warning: "..srcName.." used Strength of the Earth Totem with DK buff in raid"..missingbuffcount) 
		end
		TotemAntiSpamp2[srcName] = GetTime()
	end


	if FatCooldowns:GetModule("Display").db.profile.reporter[99963] and	UnitInRaid("player") and UnitName("boss1") ~= nil and UnitName("boss1") ~= L["Valithria Dreamwalker"] and UnitClass("player") ~= L["Druid"] and (manacheckcd == nil or GetTime() - manacheckcd > 60) and
		((UnitHealth("boss1") / UnitHealthMax("boss1") > 0.15 and UnitName("boss1") ~= L["The Lich King"]) or (UnitHealth("boss1") / UnitHealthMax("boss1") > 0.25 and UnitName("boss1") == L["The Lich King"])) then
		if LGT:GetUnitTalentSpec("player") == nil then LGT:RefreshTalentsByUnit(UnitName("player")) end
		if LGT:GetUnitRole("player") == "healer" and not UnitIsDead("player") and UnitMana("player") / UnitManaMax("player") < 0.2 then
			local druidinraid = false
			for drinraid = 1, GetNumRaidMembers() do
				if UnitClass("raid"..drinraid) == L["Druid"] then druidinraid = true end
			end
			if druidinraid then
				FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(GetSpellLink(29166).." me please")
				manacheckcd = GetTime()
			end
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99976] and UnitName("boss1") == L["Prince Keleseth"] and UnitBuff("player", tostring(GetSpellInfo(71905))) then
		local stacks = select(4, UnitBuff("player", tostring(GetSpellInfo(71905))))
		if stacks >= 5 then CancelUnitBuff("player", tostring(GetSpellInfo(71905))) end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99886] and UnitBuff("player", tostring(GetSpellInfo(24741))) then CancelUnitBuff("player", tostring(GetSpellInfo(24741))) end

	if (FatCooldowns:GetModule("Display").db.profile.reporter[99986] or FatCooldowns:GetModule("Display").db.profile.reporter[99983]) and UnitName("boss1") == L["The Lich King"] and UnitHealth("boss1") / UnitHealthMax("boss1") > 0.40 then
		if LGT:GetUnitTalentSpec("player") == nil then LGT:RefreshTalentsByUnit(UnitName("player")) end
		if (CustomUnitClass("player") == L["Warrior"] and LGT:GetUnitRole("player") == "melee" and FatCooldowns:GetModule("Display").db.profile.reporter[99986]) or (CustomUnitClass("player") == L["Druid"] and UnitBuff("player", tostring(GetSpellInfo(24858))) and FatCooldowns:GetModule("Display").db.profile.reporter[99983]) then
			if UnitBuff("player", tostring(GetSpellInfo(17))) then CancelUnitBuff("player", tostring(GetSpellInfo(17))) end
			if UnitBuff("player", tostring(GetSpellInfo(53601))) then CancelUnitBuff("player", tostring(GetSpellInfo(53601))) end
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99801] and UnitBuff("player", tostring(GetSpellInfo(73422))) and UnitClass("player") == L["Paladin"] then CancelUnitBuff("player", tostring(GetSpellInfo(73422))) end

	if (FatCooldowns:GetModule("Display").db.profile.reporter[99990] or FatCooldowns:GetModule("Display").db.profile.reporter[99989] or FatCooldowns:GetModule("Display").db.profile.reporter[98874]) and UnitName("boss1") == L["The Lich King"] and UnitHealth("boss1") / UnitHealthMax("boss1") > 0.65 then
		if eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(974)) or spellName == tostring(GetSpellInfo(61295))) then healers[srcName] = srcName 
		elseif eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(53563)) or spellName == tostring(GetSpellInfo(20473))) then healers[srcName] = srcName
		elseif (eventType == "SPELL_ENERGIZE" and spellName == tostring(GetSpellInfo(47535))) or ((spellName == tostring(GetSpellInfo(10060)) or spellName == tostring(GetSpellInfo(47540)) or spellName == tostring(GetSpellInfo(34861))) and eventType == "SPELL_CAST_SUCCESS" ) then healers[srcName] = srcName 
		elseif eventType == "SPELL_CAST_SUCCESS" and spellName == tostring(GetSpellInfo(48438)) then healers[srcName] = srcName
		elseif eventType == "SPELL_CAST_SUCCESS" and spellName == tostring(GetSpellInfo(18562)) then healers[srcName] = srcName
		elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(51562)) then healers[srcName] = srcName
		elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(52795)) then healers[srcName] = srcName
		elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(31833)) then healers[srcName] = srcName 
		elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(53671)) then healers[srcName] = srcName 
		elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(33150)) then healers[srcName] = srcName 
		elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(63730)) then healers[srcName] = srcName 
		elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(34753)) then healers[srcName] = srcName 
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99896] and (UnitName("boss1") == L["Prince Valanar"] or UnitName("boss1") == L["Prince Taldaram"] or UnitName("boss1") == L["Prince Keleseth"]) then
		if spellName == tostring(GetSpellInfo(72038)) and dstName == UnitName("player") then
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("Warning: I was knocked by "..FCDColorName(srcName))
		end
	end

	if (FatCooldowns:GetModule("Display").db.profile.reporter[99988] or FatCooldowns:GetModule("Display").db.profile.reporter[99895]) and (UnitName("boss1") == L["Prince Valanar"] or UnitName("boss1") == L["Prince Taldaram"] or UnitName("boss1") == L["Prince Keleseth"]) then
		if spellName ~= "Empowered Shock Vortex" then
			if eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(974)) or spellName == tostring(GetSpellInfo(61295))) then healers[srcName] = srcName 
			elseif eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(53563)) or spellName == tostring(GetSpellInfo(20473))) then healers[srcName] = srcName
			elseif (eventType == "SPELL_ENERGIZE" and spellName == tostring(GetSpellInfo(47535))) or ((spellName == tostring(GetSpellInfo(10060))  or spellName == tostring(GetSpellInfo(47540)) or spellName == tostring(GetSpellInfo(34861))) and eventType == "SPELL_CAST_SUCCESS" ) then healers[srcName] = srcName 
			elseif eventType == "SPELL_CAST_SUCCESS" and spellName == tostring(GetSpellInfo(48438)) then healers[srcName] = srcName
			elseif eventType == "SPELL_CAST_SUCCESS" and spellName == tostring(GetSpellInfo(18562)) then healers[srcName] = srcName
			elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(51562)) then healers[srcName] = srcName
			elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(52795)) then healers[srcName] = srcName
			elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(31833)) then healers[srcName] = srcName
			elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(53671)) then healers[srcName] = srcName  
			elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(33150)) then healers[srcName] = srcName 
			elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(63730)) then healers[srcName] = srcName 
			elseif eventType == "SPELL_AURA_APPLIED" and spellName == tostring(GetSpellInfo(34753)) then healers[srcName] = srcName 
			end
		end
		if UnitInRaid(dstName) and spellName == tostring(GetSpellInfo(72038)) then
			if FatCooldowns:GetModule("Display").db.profile.reporter[99895] and ((healers[dstName] ~= nil and healers[dstName] == dstName) or LGT:GetUnitRole(dstName) == "healer") then
				EmpShockTargetsHealers = EmpShockTargetsHealers or {}
				EmpShockTargetsHealers[dstName] = EmpShockTargetsHealers[dstName] or {}
				table.insert(EmpShockTargetsHealers[dstName], srcName)
				EmpShockDone = GetTime()
			elseif FatCooldowns:GetModule("Display").db.profile.reporter[99988] and (UnitName("boss1target") == dstName or UnitName("boss3target") == dstName or UnitName("boss2target") == dstName or LGT:GetUnitRole(dstName) == "tank") then
				EmpShockTargetsTanks = EmpShockTargetsTanks or {}
				EmpShockTargetsTanks[dstName] = EmpShockTargetsTanks[dstName] or {}
				table.insert(EmpShockTargetsTanks[dstName], srcName)
				EmpShockDone = GetTime()
			end
		end
		if EmpShockDone ~= nil and GetTime() - EmpShockDone > 2.5 then
			if FatCooldowns:GetModule("Display").db.profile.reporter[99988] then
				for key,val in pairs(EmpShockTargetsTanks) do 
					local KnockedTanks2 = nil
					for k,v in pairs(EmpShockTargetsTanks[key]) do
						if KnockedTanks2 == nil then
							KnockedTanks2 = "Warning: "..key.." Tank knocked by "..v
						else
							KnockedTanks2 = KnockedTanks2..", "..v
						end
					end
					if KnockedTanks2 ~= nil then 
						self:GetModule("Display"):chatreporter(srcName, 99988, 1,nil,nil,nil,nil,nil,KnockedTanks2)
					end
					KnockedTanks2 = nil
				end
				EmpShockDone = nil
			end
			if FatCooldowns:GetModule("Display").db.profile.reporter[99895] then
				for key,val in pairs(EmpShockTargetsHealers) do 
					local KnockedHeals2 = nil
					for k,v in pairs(EmpShockTargetsHealers[key]) do 
						if KnockedHeals2 == nil then
							KnockedHeals2 = "Warning: "..key.." Healer knocked by "..v
						else
							KnockedHeals2 = KnockedHeals2..", "..v
						end
					end
					if KnockedHeals2 ~= nil then 
						self:GetModule("Display"):chatreporter(srcName, 99895, 1,nil,nil,nil,nil,nil,KnockedHeals2)
					end
					KnockedHeals2 = nil
				end
				EmpShockDone = nil
			end
			KnockedTanks2 = nil
			EmpShockDone = nil
			KnockedHeals2 = nil
			table.wipe(EmpShockTargetsTanks)
			table.wipe(EmpShockTargetsHealers)
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99995] and (dstName == L["Blood-Queen Lana'thel"] or (UnitName("boss1") == L["Blood-Queen Lana'thel"] and spellName == tostring(GetSpellInfo(71)))) and (UnitHealth("boss1") / UnitHealthMax("boss1") > 0.90) then
		if self:isnotbosstarget(srcName) and (spellName == tostring(GetSpellInfo(71)) or (UnitBuff(srcName, tostring(GetSpellInfo(25780))) or UnitBuff(srcName, tostring(GetSpellInfo(48263))))) and (UnitInRaid(srcName) or UnitInParty(srcName) or UnitName("player") == srcName) and LGT:GetUnitTalentSpec(srcName) == nil then LGT:RefreshTalentsByUnit(srcName) end
		if spellName == tostring(GetSpellInfo(5676)) and CustomUnitClass(srcName) == L["Warlock"] and UnitInRaid(srcName) and eventType == "SPELL_CAST_SUCCESS" then
			local StealingBite = nil
			StealingBite = "Stealing Bite: "..srcName.." used Searing Pain" self:GetModule("Display"):chatreporter(srcName, 99995, 1, dstName, nil, nil, nil, nil, StealingBite) StealingBite = nil
		elseif (CustomUnitClass(srcName) == L["Warrior"] and eventType == "SPELL_AURA_REMOVED" and spellName == tostring(GetSpellInfo(71)) and LGT:GetUnitRole(srcName) == "melee" and not UnitBuff(srcName, tostring(GetSpellInfo(70867)))) then
			local StealingBite = nil StealingBite = "Stealing Bite: "..srcName.." had Defensive Stance on" self:GetModule("Display"):chatreporter(srcName, 99995, 1, dstName, nil, nil, nil, nil, StealingBite) StealingBite = nil
		elseif (UnitBuff(srcName, tostring(GetSpellInfo(25780))) or UnitBuff(srcName, tostring(GetSpellInfo(48263)))) and LGT:GetUnitRole(srcName) == "melee" and (StealingBiteSpam[srcName] == nil or StealingBiteSpam[srcName] < 4) then
			if eventType == "SPELL_CAST_SUCCESS" and not UnitBuff(srcName, tostring(GetSpellInfo(70867))) then
				local StealingBite = nil
				if CustomUnitClass(srcName) == L["Paladin"] then
					StealingBite = "Stealing Bite: "..srcName.." has Righteous Fury" self:GetModule("Display"):chatreporter(srcName, 99995, 1, dstName, nil, nil, nil, nil, StealingBite) StealingBite = nil
					if StealingBiteSpam[srcName] == nil then StealingBiteSpam[srcName] = 1 else StealingBiteSpam[srcName] = StealingBiteSpam[srcName] + 1 end 
				elseif CustomUnitClass(srcName) == L["Death Knight"] then
					StealingBite = "Stealing Bite: "..srcName.." has Frost Presence" self:GetModule("Display"):chatreporter(srcName, 99995, 1, dstName, nil, nil, nil, nil, StealingBite) StealingBite = nil
					if StealingBiteSpam[srcName] == nil then StealingBiteSpam[srcName] = 1 else StealingBiteSpam[srcName] = StealingBiteSpam[srcName] + 1 end
				end
			end
		end
	end 

	if FatCooldowns:GetModule("Display").db.profile.reporter[99996] and (spellId == 60122 or spellName == tostring(GetSpellInfo(60122))) and eventType == "SPELL_CAST_SUCCESS" then
		if dstName == UnitName("boss1") or dstName == L["Lord Marrowgar"] or dstName == L["Lady Deathwhisper"] or dstName == L["Deathbringer Saurfang"] or dstName == L["Festergut"] or dstName == L["Rotface"] or dstName == L["Professor Putricide"] or
			dstName == L["Blood-Queen Lana'thel"] or dstName == L["Sindragosa"] or dstName == L["The Lich King"] or dstName == L["Halion"] or dstName == L["Prince Valanar"] or dstName == L["Prince Taldaram"] or dstName == L["Prince Keleseth"] then
			local spice = srcName.." used "..GetSpellLink(60122).." on "..dstName
			self:GetModule("Display"):chatreporter(srcName, 99996, 1, dstName, nil, nil, nil, nil, spice) spice = nil
		end
		return
	end
	
	if FatCooldowns:GetModule("Display").db.profile.reporter[99997] and instancename == L["Icecrown Citadel"] and maxPlayers == 25 and UnitName("boss1") == L["Professor Putricide"] and dynamicDifficulty == 1 and not doublesummonooze and oozedead then
		if eventType == "SPELL_AURA_APPLIED" and spellName == L["Gas Variable"] or spellName == L["Ooze Variable"] then Oozetimestamp = timestamp end

		if (eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED") and
			(spellName == tostring(GetSpellInfo(53209)) or spellName == tostring(GetSpellInfo(19434)) or spellName == tostring(GetSpellInfo(56641)) or
		 	 spellName == tostring(GetSpellInfo(686)) or spellName == tostring(GetSpellInfo(348)) or spellName == tostring(GetSpellInfo(689)) or spellName == tostring(GetSpellInfo(29722)) or spellName == tostring(GetSpellInfo(6353)) or
		 	 spellName == tostring(GetSpellInfo(8921)) or spellName == tostring(GetSpellInfo(5176)) or spellName == tostring(GetSpellInfo(2912)) or spellName == tostring(GetSpellInfo(1822)) or spellName == tostring(GetSpellInfo(5221)) or spellName == tostring(GetSpellInfo(33876)) or
		 	 spellName == tostring(GetSpellInfo(35395)) or spellName == tostring(GetSpellInfo(53385)) or
		 	 spellName == tostring(GetSpellInfo(45902)) or spellName == tostring(GetSpellInfo(49143)) or spellName == tostring(GetSpellInfo(55090)) or spellName == tostring(GetSpellInfo(45477)) or spellName == tostring(GetSpellInfo(45462)) or
		 	 spellName == tostring(GetSpellInfo(34914)) or spellName == tostring(GetSpellInfo(15407)) or spellName == tostring(GetSpellInfo(589)) or spellName == tostring(GetSpellInfo(2944)) or
		 	 spellName == tostring(GetSpellInfo(60103)) or spellName == tostring(GetSpellInfo(17364)) or spellName == tostring(GetSpellInfo(403)) or spellName == tostring(GetSpellInfo(8050)) or spellName == tostring(GetSpellInfo(51505)) or
		 	 spellName == tostring(GetSpellInfo(1752)) or spellName == tostring(GetSpellInfo(1329)) or
		 	 spellName == tostring(GetSpellInfo(23881)) or spellName == tostring(GetSpellInfo(5308)) or spellName == tostring(GetSpellInfo(78)) or
		 	 spellName == tostring(GetSpellInfo(133)) or spellName == tostring(GetSpellInfo(44457)) or spellName == tostring(GetSpellInfo(44425)) or spellName == tostring(GetSpellInfo(30451)) or spellName == tostring(GetSpellInfo(5143))) then
			if (UnitDebuff(srcName, L["Ooze Variable"]) and dstName == L["Gas Cloud"]) or (UnitDebuff(srcName, L["Gas Variable"]) and dstName == L["Volatile Ooze"]) then
				if Oozetimestamp ~= nil then
					if (timestamp - Oozetimestamp) < 25 and (timestamp - Oozetimestamp) > 4 then
						local Oozetext = nil
						Oozetext = "Incorrect Ooze Damage: " .. srcName .. " used " .. GetSpellLink(spellId) .. " on " .. dstName .. " with incorrect debuff"
						self:GetModule("Display"):chatreporter(srcName, 99997, 1, dstName, nil, nil, nil, nil, Oozetext) Oozetext = nil
					end
				end
			end
		end
	end 

	if (FatCooldowns:GetModule("Display").db.profile.reporter[99994] or FatCooldowns:GetModule("Display").db.profile.reporter[99999]) and instancename == L["Icecrown Citadel"] then 
		if dstName == L["Val'kyr Shadowguard"] then
			if Valkyrs[dstGUID] then 
				if eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" or eventType == "RANGE_DAMAGE" then Valkyrs[dstGUID] = Valkyrs[dstGUID] - arg[2] end
				if eventType == "SWING_DAMAGE" then Valkyrs[dstGUID] = Valkyrs[dstGUID] - spellId end
			else
				if eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" or eventType == "RANGE_DAMAGE" then Valkyrs[dstGUID] = Valk25MaxHP - arg[2] end
				if eventType == "SWING_DAMAGE" then Valkyrs[dstGUID] = Valk25MaxHP - spellId end
			end
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99999] and instancename == L["Icecrown Citadel"] then
		if (spellName == tostring(GetSpellInfo(845)) or spellName == tostring(GetSpellInfo(20375))) and self:isnotbosstarget(srcName) and (UnitInRaid(dstName) or UnitInParty(dstName) or UnitName("player") == dstName) and LGT:GetUnitTalentSpec(srcName) == nil then LGT:RefreshTalentsByUnit(srcName) end
		if (dstName == L["Blood Beast"] and eventType == "SPELL_AURA_APPLIED" and (spellName == tostring(GetSpellInfo(44457)) or spellName == tostring(GetSpellInfo(8921)) or spellName == tostring(GetSpellInfo(5570)) or spellName == tostring(GetSpellInfo(348)) or spellName == tostring(GetSpellInfo(589)))) or
			(UnitName("boss1") == L["Deathbringer Saurfang"] and eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(48045)) or spellName == tostring(GetSpellInfo(1510)) or spellName == tostring(GetSpellInfo(16914)) or spellName == tostring(GetSpellInfo(2120)) or spellName == tostring(GetSpellInfo(5740)) or
			spellName == tostring(GetSpellInfo(27243)) or spellName == tostring(GetSpellInfo(10)) or spellName == tostring(GetSpellInfo(51723)) or spellName == tostring(GetSpellInfo(62078)))) or 


			((dstName == L["Little Ooze"] or dstName == L["Big Ooze"]) and eventType == "SPELL_AURA_APPLIED" and (spellName == tostring(GetSpellInfo(44457)) or spellName == tostring(GetSpellInfo(589)) or spellName == tostring(GetSpellInfo(34914)) or spellName == tostring(GetSpellInfo(8921)) or spellName == tostring(GetSpellInfo(5570))  or spellName == tostring(GetSpellInfo(348)))) or
			(UnitName("boss1") == L["Rotface"] and eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(48045)) or spellName == tostring(GetSpellInfo(1510)) or spellName == tostring(GetSpellInfo(16914)) or spellName == tostring(GetSpellInfo(2120)) or spellName == tostring(GetSpellInfo(5740)) or
			spellName == tostring(GetSpellInfo(27243)) or spellName == tostring(GetSpellInfo(10)) or spellName == tostring(GetSpellInfo(20375)) or (spellName == tostring(GetSpellInfo(845)) and ((LGT:GetUnitRole(srcName) == "melee" and self:isnotbosstarget(srcName)) or (LGT:GetUnitRole(srcName) == nil and self:isnotbosstarget(srcName) and UnitHealthMax(srcName) <= 55000))) or spellName == tostring(GetSpellInfo(51723)) or spellName == tostring(GetSpellInfo(62078)))) or


			(UnitName("boss1") ==  L["Prince Keleseth"] and eventType == "SPELL_CAST_SUCCESS" and spellName == tostring(GetSpellInfo(13877))) or
			
			((UnitName("boss1") == L["Prince Valanar"] or UnitName("boss1") ==  L["Prince Keleseth"] or UnitName("boss1") ==  L["Prince Taldaram"]) and eventType == "SPELL_DAMAGE" and spellName == tostring(GetSpellInfo(20375)) and (SealSpamTimer[srcName] == nil or GetTime() - SealSpamTimer[srcName] > 7) and
				((LGT:GetUnitRole(srcName) == "melee" and self:isnotbosstarget(srcName)) or (LGT:GetUnitRole(srcName) == nil and self:isnotbosstarget(srcName) and UnitHealthMax(srcName) <= 55000))) or
			

			(dstName == "Dark Nucleus" and eventType == "SPELL_AURA_APPLIED" and (spellName == tostring(GetSpellInfo(44457)) or spellName == tostring(GetSpellInfo(348)) or spellName == tostring(GetSpellInfo(589)) or spellName == tostring(GetSpellInfo(34914)))) or 
			((UnitName("boss1") == L["Prince Valanar"] or UnitName("boss1") ==  L["Prince Keleseth"] or UnitName("boss1") ==  L["Prince Taldaram"]) and eventType == "SPELL_CAST_SUCCESS" and 
			(spellName == tostring(GetSpellInfo(48045)) or spellName == tostring(GetSpellInfo(1510)) or spellName == tostring(GetSpellInfo(16914)) or spellName == tostring(GetSpellInfo(2120)) or spellName == tostring(GetSpellInfo(5740)) or
			spellName == tostring(GetSpellInfo(27243)) or spellName == tostring(GetSpellInfo(10)) or (spellName == tostring(GetSpellInfo(20375)) and ((LGT:GetUnitRole(srcName) == "melee" and self:isnotbosstarget(srcName)) or (LGT:GetUnitRole(srcName) == nil and self:isnotbosstarget(srcName) and UnitHealthMax(srcName) <= 55000))) or (spellName == tostring(GetSpellInfo(845)) and ((LGT:GetUnitRole(srcName) == "melee" and self:isnotbosstarget(srcName)) or (LGT:GetUnitRole(srcName) == nil and self:isnotbosstarget(srcName) and UnitHealthMax(srcName) <= 55000))) or spellName == tostring(GetSpellInfo(51723)) or spellName == tostring(GetSpellInfo(62078)))) or

			(dstName == L["Vile Spirit"] and dynamicDifficulty == 1 and (eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(27243)) or spellName == tostring(GetSpellInfo(48045)) or spellName == tostring(GetSpellInfo(2643)) or spellName == tostring(GetSpellInfo(44457))))) or

			(((dstName == L["Drudge Ghoul"] or dstName == L["Shambling Horror"]) and UnitName("boss1") == L["The Lich King"] and (UnitHealth("boss1") / UnitHealthMax("boss1") > 0.73)) and maxPlayers == 25 and eventType == "SPELL_AURA_APPLIED" and
			 (spellName == tostring(GetSpellInfo(44457)) or spellName == tostring(GetSpellInfo(348)) or spellName == tostring(GetSpellInfo(8921)) or spellName == tostring(GetSpellInfo(5570))  or spellName == tostring(GetSpellInfo(34914)) or spellName == tostring(GetSpellInfo(27243)) or spellName == tostring(GetSpellInfo(172)) or spellName == tostring(GetSpellInfo(589)))) or

			(eventType == "SPELL_CAST_SUCCESS" and spellName == tostring(GetSpellInfo(2812)) and UnitHealthMax(srcName) < 55000 and dynamicDifficulty == 1 and maxPlayers == 25 and UnitName("boss1") == L["The Lich King"] and (UnitHealth("boss1") / UnitHealthMax("boss1") > 0.73))  or
			
			(UnitName("boss1") == L["The Lich King"] and (UnitHealth("boss1") / UnitHealthMax("boss1") > 0.72) and maxPlayers == 25 and eventType == "SPELL_CAST_SUCCESS" and (spellName == tostring(GetSpellInfo(48045)) or spellName == tostring(GetSpellInfo(1510)) or spellName == tostring(GetSpellInfo(16914)) or spellName == tostring(GetSpellInfo(2643)) or
			spellName == tostring(GetSpellInfo(2120)) or spellName == tostring(GetSpellInfo(5740)) or spellName == tostring(GetSpellInfo(27243)) or spellName == tostring(GetSpellInfo(10)) or (spellName == tostring(GetSpellInfo(20375)) and ((LGT:GetUnitRole(srcName) == "melee" and self:isnotbosstarget(srcName)) or (LGT:GetUnitRole(srcName) == nil and self:isnotbosstarget(srcName) and UnitHealthMax(srcName) <= 55000))) or spellName == tostring(GetSpellInfo(51723)) or spellName == tostring(GetSpellInfo(50516)) or spellName == tostring(GetSpellInfo(62078))))
	 	then
	 		if	((UnitName("boss1") == L["Prince Valanar"] or UnitName("boss1") ==  L["Prince Keleseth"] or UnitName("boss1") ==  L["Prince Taldaram"]) and eventType == "SPELL_DAMAGE" and spellName == tostring(GetSpellInfo(20375)) and (SealSpamTimer[srcName] == nil or GetTime() - SealSpamTimer[srcName] > 7)) then SealSpamTimer[srcName] = GetTime() end
			if dstName == nil then dstName = UnitName("boss1") .. " or adds" end
			self:GetModule("Display"):chatreporter(srcName, 99999, 1,dstName, nil, nil, nil, spellId)
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99994] and instancename == L["Icecrown Citadel"] and Valkyrs[dstGUID] ~= nil then
		if (dynamicDifficulty == 1 and maxPlayers == 25 and dstName == L["Val'kyr Shadowguard"] and Valkyrs[dstGUID] / Valk25MaxHP < 0.48 and (eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_CAST_SUCCESS") and (spellName == tostring(GetSpellInfo(44457)) or spellName == tostring(GetSpellInfo(48045)) or spellName == tostring(GetSpellInfo(2643)) or spellName == tostring(GetSpellInfo(27243))))	then
			local ValkHealthFormated = string.format("%.0f", Valkyrs[dstGUID]/Valk25MaxHP*100)
			local ValkHealth = dstName.." with "..ValkHealthFormated .."% HP"
			self:GetModule("Display"):chatreporter(srcName, 99999, 1,ValkHealth, nil, nil, nil, spellId)
			ValkHealthFormated = nil
			ValkHealth = nil
		elseif
			(dynamicDifficulty == 1 and maxPlayers == 25 and dstName == L["Val'kyr Shadowguard"] and Valkyrs[dstGUID] / Valk25MaxHP < 0.48 and (eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_CAST_SUCCESS") and
			(spellName == tostring(GetSpellInfo(133)) or spellName == tostring(GetSpellInfo(44425)) or spellName == tostring(GetSpellInfo(30451)) or spellName == tostring(GetSpellInfo(5143)) or 
			spellName == tostring(GetSpellInfo(15407)) or spellName == tostring(GetSpellInfo(589)) or spellName == tostring(GetSpellInfo(2944)) or spellName == tostring(GetSpellInfo(34914)) or 
			spellName == tostring(GetSpellInfo(53209)) or spellName == tostring(GetSpellInfo(19434)) or spellName == tostring(GetSpellInfo(56641)) or
	 		spellName == tostring(GetSpellInfo(686)) or spellName == tostring(GetSpellInfo(348)) or spellName == tostring(GetSpellInfo(689)) or spellName == tostring(GetSpellInfo(29722)) or spellName == tostring(GetSpellInfo(6353)) or spellName == tostring(GetSpellInfo(172)) or 
 			spellName == tostring(GetSpellInfo(8921)) or spellName == tostring(GetSpellInfo(5176)) or spellName == tostring(GetSpellInfo(2912)) or spellName == tostring(GetSpellInfo(1822)) or spellName == tostring(GetSpellInfo(5221)) or spellName == tostring(GetSpellInfo(33876))))
		 	then
		 		local ValkHealthFormated = string.format("%.0f", Valkyrs[dstGUID]/Valk25MaxHP*100)
				local ValkHealth = dstName.." with "..ValkHealthFormated .."% HP"
				self:GetModule("Display"):chatreporter(srcName, 99994, 1,ValkHealth, nil, nil, nil, spellId, "Warning: "..srcName.." has used "..GetSpellLink(spellId).." on "..ValkHealth)
				ValkHealthFormated = nil
				ValkHealth = nil
			return
		end
	end

	if FatCooldowns:GetModule("Display").db.profile.reporter[99999] and instancename == L["Icecrown Citadel"] then
		if (eventType == "SPELL_AURA_APPLIED" and (UnitName("boss2") == dstName or UnitName("boss3") == dstName) and (spellName == tostring(GetSpellInfo(44457)) or spellName == tostring(GetSpellInfo(34914))) and Oozetimestamp ~= nil and (timestamp - Oozetimestamp) > 3 and not UnitDebuff(dstName, tostring(GetSpellInfo(70981)))) then
			local PrinceHealth = dstName.." with 1HP"
			self:GetModule("Display"):chatreporter(srcName, 99999, 1,PrinceHealth, nil, nil, nil, spellId) PrinceHealth = nil
			return
		end
	end

	if IsInInstance() ~= "none" then
		if FatCooldowns:GetModule("Display").db.profile.reporter[27433] and eventType == "SPELL_CAST_SUCCESS" and spellId == 27433 then
			self:GetModule("Display"):chatreporter(srcName, spellId, 1,dstName, nil, nil, eventType)
		end

		if FatCooldowns:GetModule("Display").db.profile.reporter[49844] then
			if (eventType == "SPELL_CAST_START" or eventType == "SPELL_CREATE") and spellId == 49844 then
				if (eventType == "SPELL_CAST_START" and spellId == 49844 and (RemoteSpam[srcName] == nil or timestamp - RemoteSpam[srcName] > 120)) or (eventType == "SPELL_CREATE" and spellId == 49844) then
					self:GetModule("Display"):chatreporter(srcName, spellId, 1,dstName, nil, nil, eventType)
					RemoteSpam[srcName] = timestamp
				elseif eventType ~= "SPELL_CAST_START" and spellId ~= 49844 then
					self:GetModule("Display"):chatreporter(srcName, spellId, 1,dstName, nil, nil, eventType)
				end 
				return
			end
		end

		if FatCooldowns:GetModule("Display").db.profile.reporter[98999] ~= 1 and spellId == 53142 then
			self:GetModule("Display"):chatreporter(srcName, 98999, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[98998] ~= 1 and spellId == 11419 then
			self:GetModule("Display"):chatreporter(srcName, 98998, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[98997] ~= 1 and spellId == 32266 then
			self:GetModule("Display"):chatreporter(srcName, 98997, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[98996] ~= 1 and spellId == 11416 then
			self:GetModule("Display"):chatreporter(srcName, 98996, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[98995] ~= 1 and spellId == 10059 then
			self:GetModule("Display"):chatreporter(srcName, 98995, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[98994] ~= 1 and spellId == 11417 then
			self:GetModule("Display"):chatreporter(srcName, 98994, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[98993] ~= 1 and spellId == 32267 then
			self:GetModule("Display"):chatreporter(srcName, 98993, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[98992] ~= 1 and spellId == 11420 then
			self:GetModule("Display"):chatreporter(srcName, 98992, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[98991] ~= 1 and spellId == 11418 then
			self:GetModule("Display"):chatreporter(srcName, 98991, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[98989] ~= 1 and spellId == 49360 then
			self:GetModule("Display"):chatreporter(srcName, 98989, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[98988] ~= 1 and spellId == 49361 then
			self:GetModule("Display"):chatreporter(srcName, 98988, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[98987] ~= 1 and spellId == 33691 then
			self:GetModule("Display"):chatreporter(srcName, 98987, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end
		if FatCooldowns:GetModule("Display").db.profile.reporter[98986] ~= 1 and spellId == 35717 then
			self:GetModule("Display"):chatreporter(srcName, 98986, 1,dstName, nil, nil, eventType, spellId, spellId)
			return
		end

		if eventType == "SPELL_CAST_SUCCESS" and spellId == 57397 and FatCooldowns:GetModule("Display").db.profile.FishCount > 0 then
			self:GetModule("Display"):chatreporter(srcName, 99987, 1,dstName, nil, nil, eventType)
			return
		end 
	end

end

--------------[[		Comm Methods		]]--------------
function FatCooldowns:OnCommReceived(prefix, msg, distro, sender)
	if prefix == "FRCD3LShekles" then
	    --local success, t = self:Deserialize(msg)
	    local success, newmsg = self:Deserialize(msg)

	    if newmsg == "FCDLEADER" then self:GetModule("Display"):leadcheck(sender, 99980, nil,nil, nil, nil, nil, nil, newmsg)
		elseif newmsg == "FCDOFFICER" then self:GetModule("Display"):leadcheck(sender, 99980, nil,nil, nil, nil, nil, nil, newmsg) 
		elseif newmsg == "FCDPLAYER" then self:GetModule("Display"):leadcheck(sender, 99980, nil,nil, nil, nil, nil, nil, newmsg)
		end
		if newmsg ~= "FCDLEADER" and newmsg ~= "FCDOFFICER" and newmsg ~= "FCDPLAYER" and UnitName("player") == VerSender then
			FatCooldowns:GetModule("Display"):FCDPrefixPrint(FCDColorName(sender).." Has FCD V"..newmsg)
		end
	    return
	end

	if prefix == "FCDPARRYCOUNTER" and (FatCooldowns:GetModule("Display").db.profile.reporter[99880] or FatCooldowns:GetModule("Display").db.profile.reporter[99881] or FatCooldowns:GetModule("Display").db.profile.reporter[99882]) then
	    local success2, newmsg2 = self:Deserialize(msg)
	    if newmsg2 ~= nil then 
	    	ParryPrefix, ParryPlayerName, ParryTime, ParryPhase = select(3, newmsg2:find("(%a+) (%a+) (%d+) (%d+)"))
	    	if ParryAntiSpam[ParryPlayerName] == nil or (ParryAntiSpam[ParryPlayerName] ~= nil and GetTime() - ParryAntiSpam[ParryPlayerName] > 1) then
		    	if ParryPhase == "1" then
		    		ParryCounterH1[ParryPlayerName] = ParryCounterH1[ParryPlayerName] or {}
		    		ParryCounterH1[ParryPlayerName][1] = ParryCounterH1[ParryPlayerName][1] or 0
		    		ParryCounterH1[ParryPlayerName][1] = ParryCounterH1[ParryPlayerName][1] + 1
		    	elseif ParryPhase == "2" then 
		    		ParryCounterH2[ParryPlayerName] = ParryCounterH2[ParryPlayerName] or {}
		    		ParryCounterH2[ParryPlayerName][1] = ParryCounterH2[ParryPlayerName][1] or 0
		    		ParryCounterH2[ParryPlayerName][1] = ParryCounterH2[ParryPlayerName][1] + 1
		    	elseif ParryPhase == "3" then 
		    		ParryCounterH3[ParryPlayerName] = ParryCounterH3[ParryPlayerName] or {}
		    		ParryCounterH3[ParryPlayerName][1] = ParryCounterH3[ParryPlayerName][1] or 0
		    		ParryCounterH3[ParryPlayerName][1] = ParryCounterH3[ParryPlayerName][1] + 1
		    	elseif ParryPhase == "4" then 
		    		ParryCounterH4[ParryPlayerName] = ParryCounterH4[ParryPlayerName] or {}
		    		ParryCounterH4[ParryPlayerName][1] = ParryCounterH4[ParryPlayerName][1] or 0
		    		ParryCounterH4[ParryPlayerName][1] = ParryCounterH4[ParryPlayerName][1] + 1
		    	end
		    	ParryAntiSpam[ParryPlayerName] = GetTime()
				ParryCounterSetMembers = "true"
		    end
		end
	end

	if self:GetModule("Display").db.profile.hideSelf and sender == playerName then return end

	if self:GetModule("Display").db.profile.DisableSync then return end

	if prefix == self.prefix then
		local classCDs = {}
		local _, class = CustomUnitClass(sender)
		if self.cooldowns[class] then
			for spellName, spellTable in pairs(self.cooldowns[class]) do
				classCDs[spellTable.id] = true
			end
		end
		
		local spellId, cooldown
		for w in string.gmatch(msg,"([^,]*),") do
			spellId = nil cooldown = nil
			spellId, cooldown = select(3, w:find("(%d+)-(%d+)"))
			if not spellId or not cooldown or not tonumber(spellId) or not tonumber(cooldown) then FatCooldowns:GetModule("Display"):FCDPrefixPrint("Recieving false cooldown data from",sender,"b7rc2") return end
			spellId = tonumber(spellId)
			cooldown = tonumber(cooldown)
			classCDs[spellId] = nil
			--print("has CD",spellId)
			if not UnitInRaid(sender) and not UnitInParty(sender) and UnitName("player") ~= sender then return end
			self:GetModule("Display"):SyncCooldown(sender, spellId, cooldown, nil, sender,true)
		end
		
		for spellID, v in pairs(classCDs) do
			--print("no CD",spellID)
			if not UnitInRaid(sender) and not UnitInParty(sender) and UnitName("player") ~= sender then return end
			self:GetModule("Display"):SyncCooldown(sender, spellID, 0, nil, sender,true)
		end
	elseif prefix == self.prefixB then
		--if sender == UnitName("player") then return end
		--self:ReCountCooldowns()
		local i = 1
		for w in string.gmatch(msg," ([0-9]+)") do 
			if i > FatCooldowns.syncCount then --print("Recieving false cooldown data from",sender,"3k5s") 
				return 
			end
			
			if tonumber(w) > FatCooldowns.syncCooldowns[i].count then
				self:SendCommMessage(FatCooldowns.prefixR, tostring(i), "WHISPER", sender)
			end
			i = i + 1
		end
	elseif prefix == self.prefixR then
		if not tonumber(msg) or tonumber(msg) > FatCooldowns.syncCount then FatCooldowns:GetModule("Display"):FCDPrefixPrint("Recieving false cooldown data from",sender,"4q5d") return end
		local message = msg .. ","
		for caster,cdTable in pairs(FatCooldowns.syncCooldowns[tonumber(msg)].cooldowns) do
			if cdTable.timer > GetTime() + 1 then
				message = message .. caster .. math.ceil(cdTable.timer-GetTime())
				if cdTable.target then message = message .. cdTable.target end
				message = message .. ","
			end
		end
		self:SendCommMessage(FatCooldowns.prefixI, message, "WHISPER", sender)
	elseif prefix == self.prefixI then
		local index = nil
		for w in string.gmatch(msg,"([^,]*),") do
			if not index then 
				if not tonumber(w) or tonumber(w) > FatCooldowns.syncCount then FatCooldowns:GetModule("Display"):FCDPrefixPrint("Recieving false cooldown data from",sender,"8hf4") return end
				index = tonumber(w)
			else
				local caster = nil local cd = nil local target = nil
				caster, cd, target = select(3, w:find("(%a+)(%d+)(%a*)"))
				if not caster or not cd or not tonumber(cd) then FatCooldowns:GetModule("Display"):FCDPrefixPrint("Recieving false cooldown data from",sender,"s4t3") return end
				cd = tonumber(cd)
				if target == "" then target = nil end
				
				if not FatCooldowns.syncCooldowns[index].cooldowns[caster] then
					if CustomUnitClass(caster) ~= L["Priest"] and FatCooldowns.syncCooldowns[index].id == 47788 then return end
					if not UnitInRaid(caster) and not UnitInParty(caster) and UnitName("player") ~= caster then return end
					self:GetModule("Display"):SyncCooldown(caster, FatCooldowns.syncCooldowns[index].id, cd, target, sender)
				end
			end
		end
	elseif prefix == self.prefixS then
		--if sender == UnitName("player") then return end
		--self:ReCountCooldowns()
		local spellId, caster, cooldown, target = select(3, msg:find("(%d+)(%a+)(%d+)(%a*)"))
		if spellId and tonumber(spellId) and caster and cooldown and tonumber(cooldown) then
			if target == "" then target = nil end
			if not UnitInRaid(caster) and not UnitInParty(caster) and UnitName("player") ~= caster then return end
			self:GetModule("Display"):SyncCooldown(caster, tonumber(spellId), tonumber(cooldown), target, sender)
		end
	end
end

