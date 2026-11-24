assert(FatCooldowns, "FatCooldowns not found!")

local MINOR_VERSION = tonumber(("$Revision: 49 $"):match("%d+"))
local AceConfig = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local Media = LibStub("LibSharedMedia-3.0")
local TalentQuery = LibStub:GetLibrary("LibTalentQuery-1.0")
local RC = LibStub("LibRangeCheck-2.0")
local wholib = LibStub('LibWho-2.0')
local LGT = LibStub("LibGroupTalents-1.0")
local FatCooldowns = FatCooldowns
local mod = FatCooldowns:NewModule("Display", nil, "AceComm-3.0", "AceEvent-3.0", "AceConsole-3.0", "SheklesLibBars-1.0", "AceTimer-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("FatCooldowns")

local pairs = _G.pairs
local UnitName, UnitClass = _G.UnitName, _G.UnitClass
local tonumber, tostring, type = _G.tonumber, _G.tostring, _G.type

local barGroups = nil
local FishTable = {}
local PortalTable = {}
local owner = false
local checked = false
local AntiSpamLeader, AntiSpamOfficer = UnitName("player"), UnitName("player")
local AntiSpamMessage = true
local AntiSpamCleave = {}
local scantimestamp = nil
local raidupdateroaterdelay = nil
local chatfilterfailcheck = true
local talentscantimer = {}
local itemscantimer = {}
local LastSoundPlay = {}
local LastMessageSent = {}
FatCooldowns.BWList = {}
FatCooldowns.LogInTime = nil
FatCooldowns.LastSent = {}

FatCooldowns.FCDSounds = {
	["Batman Punch"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\BatmanPunch.mp3",
	["Bike Horn"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\BikeHorn.mp3",
	["Boxing Arena Gong"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\BoxingArenaSound.mp3",
	["Bleat"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Bleat.mp3",
	["Cat Meow"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\CatMeow2.mp3",
	["Kitten Meow"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\KittenMeow.mp3",
	["Robot Blip"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\RobotBlip.mp3",
	["Sharp Punch"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\SharpPunch.mp3",
	["Water Drop"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\WaterDrop.mp3",
	["Air Horn"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\AirHorn.mp3",
	["Applause"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Applause.mp3",
	["Banana Peel Slip"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\BananaPeelSlip.mp3",
	["Blast"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Blast.mp3",
	["Cartoon Voice Baritone"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\CartoonVoiceBaritone.mp3",
	["Cartoon Walking"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\CartoonWalking.mp3",
	["Cow Mooing"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\CowMooing.mp3",
	["Ringing Phone"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\RingingPhone.mp3",
	["Roaring Lion"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\RoaringLion.mp3",
	["Shotgun"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Shotgun.mp3",
	["Squish Fart"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\SquishFart.mp3",
	["Temple Bell"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\TempleBellHuge.mp3",
	["Torch"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Torch.mp3",
	["Warning Siren"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\WarningSiren.mp3",
	["Bell Toll Alliance"] = "Sound\\Doodad\\BellTollAlliance.wav",
	["Bell Toll Horde"] = "Sound\\Doodad\\BellTollHorde.wav",
	["PvP Flag Taken"] = "Sound\\Spells\\PVPFlagTaken.wav",
	["Bad Press"] = "Sound\\Spells\\SimonGame_Visual_BadPress.wav",
	["Run Away"] = "Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav",
	["Low Mana"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\LowMana.mp3",
	["Low Health"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\LowHealth.mp3",
	["Zing Alarm"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\ZingAlarm.mp3",
	["Wobble"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Wobble.mp3",
	["Spread"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Spread.mp3",
	["runaway"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\runaway.mp3",
	["Bottle"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Bottle.mp3",
	["Lift Me"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\LiftMe.mp3",
	["Neo Beep"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\NeoBeep.mp3",
	["FF1 Victory"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\FF1_Victory.mp3",
	["Alert 1"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Alert1.mp3",
	["Alert 2"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Alert2.mp3",
	["Alert 3"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Alert3.mp3",
	["Bam"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Bam.mp3",
	["Beware!"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Beware.mp3",
	["Dominating"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Dominating.mp3",
	["Don't Die"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\DontDie.mp3",
	["God Like"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\GodLike.mp3",
	["Head Shot"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\HeadShot.mp3",
	["Incredible"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Incredible.mp3",
	["Karazhan Bell"] = "Sound\\Doodad\\KharazahnBellToll.wav",
	["Killing Spree"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\KillingSpree.mp3",
	["Ludicrous Kill"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\LudicrousKill.mp3",
	["Mario Die"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\MarioDie.mp3",
	["Monster Kill"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\MonsterKill.mp3",
	["Multi Kill"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\MultiKill.mp3",
	["Murderous Rampage"] = "Sound\\Character\\Gnome\\GnomeVocalFemale\\GnomeFemalePissed01.wav",
	["Rampage"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Rampage.mp3",
	["Ultra Kill"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\UltraKill.mp3",
	["Unstoppable"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\Unstoppable.mp3",
	["You Suck!!"] = "Interface\\AddOns\\FatCooldowns\\sounds\\CustomSounds\\YouSuck.mp3",
}

local SharedMediaSounds = Media:HashTable("sound")
for name, path in pairs(SharedMediaSounds) do
	FatCooldowns.FCDSounds[name] = path
end

local function sortFunc(a, b)
	if a == nil or b == nil then FatCooldowns:GetModule("Display"):FCDPrefixPrint("sorting failed nil val") return end
	if a.isTimer ~= b.isTimer then
		return a.isTimer
	end
	
	local aID, bID
	
	for w in string.gmatch(a.name,"_([0-9]*)$") do 
		aID = tonumber(w);
	end	
	
	for w in string.gmatch(b.name,"_([0-9]*)$") do 
		bID = tonumber(w);
	end

	local aInfo = FatCooldowns.spellInfoTable[aID]
	local bInfo = FatCooldowns.spellInfoTable[bID]

	if (aID == 69766 and bID == 69766) or (aID == 72143 and bID == 72143) or (aID == 70337 and bID == 70337) or (aID == 69037 and bID == 69037) then return a.name > b.name end

 	if FatCooldowns:GetModule("Display").db.profile.orderSpellPriorities[aID] ~= nil then
 		if FatCooldowns:GetModule("Display").db.profile.orderSpells[aID] then
 			aInfo.order = FatCooldowns:GetModule("Display").db.profile.orderSpellPriorities[aID] 
 		else
 			aInfo.order = 500
 		end
 	end
 	if FatCooldowns:GetModule("Display").db.profile.orderSpellPriorities[bID] ~= nil then
 		if FatCooldowns:GetModule("Display").db.profile.orderSpells[bID] then
			bInfo.order = FatCooldowns:GetModule("Display").db.profile.orderSpellPriorities[bID]
		else
			bInfo.order = 500
		end
	end
	if aInfo == nil then
		aInfo = {}
		aInfo.order = 500
		aInfo.class = "ITEM PROC"
	 end 
	if bInfo == nil then
		bInfo = {}
		bInfo.order = 500
		bInfo.class = "ITEM PROC"
	 end

	if a:GetAlpha() ~= nil and b:GetAlpha() ~= nil and type(a:GetAlpha()) == "number" and type(b:GetAlpha()) == "number" and a:GetAlpha() == 0 and b:GetAlpha() > 0 then return 1 > 2
	elseif a:GetAlpha() ~= nil and b:GetAlpha() ~= nil and type(a:GetAlpha()) == "number" and type(b:GetAlpha()) == "number" and b:GetAlpha() == 0 and a:GetAlpha() > 0 then return 2 > 1
	elseif FatCooldowns:GetModule("Display").db.profile.SortOrderTime and not (a.permanent or b.permanent) then 
		if FatCooldowns:GetModule("Display").db.profile.SortOrderDirection then
			return a.value < b.value 
		else
			return a.value > b.value 
		end
	elseif FatCooldowns:GetModule("Display").db.profile.SortOrderBarLength and not (a.permanent or b.permanent) then
		if FatCooldowns:GetModule("Display").db.profile.SortOrderDirection then
			return (a.maxValue / a.value) < (b.maxValue / b.value) 
		else
			return (a.maxValue / a.value) > (b.maxValue / b.value) 
		end
	else
		if (aInfo.order == bInfo.order) then
			if aInfo.class == bInfo.class then
				if aID == bID  and not ((a.permanent or b.permanent) and not FatCooldowns:GetModule("Display").db.profile.PermaMoveingBars) then
					if a.value == b.value then
						return a.name > b.name
					else
						return a.value > b.value
					end
				else
					return aID > bID
				end
			elseif FatCooldowns.classOrder[aInfo.class] ~= nil and FatCooldowns.classOrder[bInfo.class] ~= nil then
				return FatCooldowns.classOrder[aInfo.class] > FatCooldowns.classOrder[bInfo.class]
			else
				return  aInfo.order > bInfo.order
			end
		else
			return aInfo.order > bInfo.order
		end
	end
end

local playerName
local defaults = {
	profile = {
		locked      = false,
		texture     = "Smooth v2",
		fontFace    = nil,
		outline		= "None",
		clamped     = true,
		orientation = 1,
		TargetOrientation = 1,
		frameCount = 1,
		orderSpells = {},
		orderSpellPriorities = {},
		unclickable = false,
		iconzoom = true,
		availability = true,
		ColorTarget = true,
		ColorCaster = true,
		CustomBarColor = false,
		CustomBarColorPicked = {r = 1, g = 1, b = 1, a = 1},
		CustomNameColor = false,
		CustomNameColorPicked = {r = 1, g = 1, b = 1, a = 1},
		HideAllFrames = false,
		DisableSync = false,
		DisableScan = false,
		MaxLvL = true,
		SymbolsStart = "(",
		SymbolsEnd = ")",
		AbbrevName = true,
		SortOrderTime = false,
		SortOrderBarLength = false,
		SortOrderDirection = false,
		removeglow = true,
		removebackground = true,
		FillBackGround = false,
		FillBars = false,
		removereadytext = false,
		loadmore = true,
		KeepWhenSolo = false, 

		chatfilter = {},
		reporter = {},
		
		PermaMoveingBars = false,
		Removal = true,
		StoreClaSSInfo = false,
		StoreClaSSInfoExtra = {},

		AutoIconFrostmourne = false,
		AutoIconFrostmourneName = nil,
		AutoIconFrostmourneIcon = nil,
		AutoIconValk = false,
		AutoIconValkName = nil,
		AutoIconValkIcon = nil,
		ReTarget = nil,
		ILvlAvg = true,
		Backupcdused = false,
		ArenaMode = false,
		DeepClassScan = false,
		CustomChatFilterList = {},
		CustomChatFilterReporter = 0,
		SoulStoneCount = 0,
		ChatFilterMenu = false,
		ChatFilterMenuBubbles = false,
		CFMagicChars = true,
		
		SpellIconAnimation = true,
		SpellIconAnimationReverse = false,

		KeepIcon1Toggle = false,
		KeepIcon1 = nil,
		KeepIcon1Icon = nil,
		KeepIcon1Tank = false,
		KeepIcon1Healer = false,
		KeepIcon1DPS = false,
		KeepIcon1Hostile = false,
		KeepIcon1InRaid = false,
		KeepIcon1NotInRaid = false,
		KeepIcon1Boss = false,
		KeepIcon1NoBoss = false,
		KeepIcon1TargetNames = 0,
		KeepIcon1TargetNamesSet = {},

		KeepIcon2Toggle = false,
		KeepIcon2 = nil,
		KeepIcon2Icon = nil,
		KeepIcon2Tank = false,
		KeepIcon2Healer = false,
		KeepIcon2DPS = false,
		KeepIcon2Hostile = false,
		KeepIcon2InRaid = false,
		KeepIcon2NotInRaid = false,
		KeepIcon2Boss = false,
		KeepIcon2NoBoss = false,
		KeepIcon2TargetNames = 0,
		KeepIcon2TargetNamesSet = {},

		EnableGDButton = true,
		EnableGDisButton = true,

		ChatFilterReporter2 = {},
		GLOnBoss = false,
		MLOnBoss = false,
		MLOnBossName = nil,
		
		LCLICC = false,
		LCLRS = false,
		LCLNaxx = false,
		LCLULD = false,

		FailedQuest = false,
		SilentAdd = false,
		SilentRemove = false,
		HighLightList = {},
		CustomMasterLooterWindow = true,
		CustomMasterLooterWindowV2 = false,
		GameTooltipHideShift = false,
		GameTooltipHide = false,
		EnableBGColor = false,
		BGColor = {r = 0.3, g = 0.3, b = 0.3, a = 0.6},
		BorderColor = false,
		BGBorderColor = {r = 0, g = 0, b = 0, a = 1},
		MLQuality = {[1] = false, [2] = false, [3] = false, [4] = false, [5] = false, [6] = false,},
		MLOnBossTH = 2,
		GLOnBossTH = 2,
		MLGLDelay = 40,

		ColorNamesLoot = false,
		ColorNamesSystem = false,

		ColorNamesLoot2 = true,
		ColorNamesSystem2 = true,

		MasterVolSetting = 100,
		SoundEnabled = false,
		BGSound = false,
		SFXSound = false,
		AltTab = false,
		FoodLvl = 5,
		ChangeMSound = "None",
		SilentMailer = false,
		MaxSound = 100,
		DoublePlay = false,
		RDFAltTab = false,
		BGAltTab = false,
		AMExtra = {},
		AMItemType = {},
		AMMinIlvl = {},
	
		LClick = 1,
		RClick = 1,
		MClick = 1,
		SLClick = 2,
		SRClick = 3,
		SMClick = 4,
		ALClick = 6,
		ARClick = 7,
		AMClick = 5,
		
		GLoot = 1,
		BLoot = 1,
		PLoot = 1,

		SellProtection = false,
		SellSBItems = {[2] = false, [3] = false, [4] = false},
		ExraAutoSell = {[1] = false, [2] = false, [3] = false},
		TMFunctional = false,
		TMDisenchantVendorVal = false,

		SPUP = false,
		SPUPValPrint = false,
		SPUPVal = {
			["CONFIRM_LOOT_ROLL"] = false,
			["DELETE_GOOD_ITEM"] = false,
			["ABANDON_QUEST"] = false,
			["LOOT_BIND"] = false,
		},
		SilentARRemove = false,
		FDefualtTimer = 1,
		IDefualtTimer = 1,
		SPUPConfirm = false,
		
		WhisperPeopleTimer = 1,
		FishingDerby = false,
		STVExt = false,
		PERT = false,
		FSpectacular = false,
		PDay = false,
		DarkMF = {},
		MFFestival = {},
		CWeek = {},
		Ngarden = {},
		LAir = {},
		LFestival = {},
		WVeil = {},
		PBounty = {},
		DDead = {},
		HEnd = {},
		HFestival = {},
		Brewfest = {},
		ERInRaid = false,
		ERSound = false,
		ERTimer = 1,
		AutoMailerPlayers = {},
		LootMailerList = {},
		Realms = {},

		InDungeon = false,
		InBG = false,
		MMinLvl = 0,
		MMaxLvl = 0,
		WhisperMessage = nil,
		WhisperMessageClasses = {},
		PlayerRole = false,
		PlayerRoleDPS = false,
		PlayerRoleHealer = false,
		PlayerRoleTank = false,

		ItemSearchToggle = true,
		SpellsSearchToggle = false,
		
		AutoAssist = {},
		GuildInviteButton = {},
		IAKW = {},
		GuildWordsInvite = 0,
		
		BadagesBar = true,
		BadagesBarConfirm = true,
		BadagesBarCount = 10,
		
		ERTriggerDay = false,
		ERTriggerDayToday = {day = 1, month = 1,},

		MasterLootBlackList2 = {},
		MLAutoLoot = false,
		MLLICC = false,
		MLLRS = false,
		MLLNaxx = false,
		MLLULD = false,

		LootBlackList2 = {},
		EnablePopup = false,
		KeepSpaceFree = 7,
		PriceRange = 5000,
		AutoSell = false,
		SellSilence = false,
		SellList2 = {},
		ADList2 = {},
	
		Border = false,
		BorderThickness = 0,
	
		UnlearntTalents = true,
		SpellLvlLearn = false,
		SpellsLvlcost = false,
		SpellsLvlPets = {},
		SpellsLvlExtra = {},
	
		ChatFilterReporterMessage = {},
	
		soundspells = {},
		soundspellsoptions = {},
	
		SpellsReporter = {},
		spellreporteroptions = {},

		minimap = {hide = false, minimapPos = 2.4,},
	
		ARCount = 0,
		ARTable = {},
		ARNameT = {},

		FShare = false,
		IShare = false,
		FshareList = {},
		RFshareList = {},
		IshareList = {},
		RIshareList = {},
		IFShareList = {},
		IFShareList2 = {},
		IgnoreConfirm = true,

		Background = {
			Texture = "Blizzard Dialog Background",
			BorderTexture = "Blizzard Tooltip",
			Color = {r = 0, g = 0, b = 0, a = 1,},
			BorderColor = {r = 1, g = 1, b = 1, a = 1,},
			Tile = false,
			TileSize = 32,
			EdgeSize = 8,
			BarInset = 4,
		},

		GuildInvMessage = "Invites for Raid Starting Now Leave Group for Invites",
		GuildInvMessage2 = "Invites for Raid Starting in 10 seconds Leave Group for Invites",
		GuildInvMessage3 = "Invites for Raid Starting in 5 seconds Leave Group for Invites",

		LKDefileOnYou = false,
		LKDefileOnYouColor = {r = 1, g = 0, b = 0, a = 0.3},
		LKDefileNotOnYou = false,
		LKDefileNotOnYouColor = {r = 0, g = 1, b = 0, a = 0.3},
		LDYSpirits = false,
		LDYSpiritsColor = {r = 0.5, g = 0, b = 1, a = 0.3},

		LKDefileOnYou = false,
		LKDefileOnYouColor = {r = 1, g = 0, b = 0, a = 0.3},
		LKDefileNotOnYou = false,
		LKDefileNotOnYouColor = {r = 0, g = 1, b = 0, a = 0.3},
		LDYSpirits = false,
		LDYSpiritsColor = {r = 0.5, g = 0, b = 1, a = 0.3},

		PPGreen = false,
		PPGreenColor = {r = 0, g = 1, b = 0, a = 0.3},
		
		PPOrange = false,
		PPOrangeColor = {r = 1, g = 0, b = 0, a = 0.3},

		SindraNot = false,
		SindraNotColor = {r = 0, g = 1, b = 0, a = 0.3},
		
		SindraOn = false,
		SindraOnColor = {r = 1, g = 0, b = 0, a = 0.3},
		
		BQL = false,
		BQLColor = {r = 0.5, g = 0, b = 1, a = 0.3},

		RSDFCOn = false,
		RSDFCColor = {r = 1, g = 0, b = 0, a = 0.3},

		RSDSCOn = false,
		RSDSCColor = {r = 0.5, g = 0, b = 1, a = 0.3},


		LHPN = false,
		LHPNC = {r = 1, g = 0, b = 0},
		LHPH = 1,
		LHPCR = 1,
		LHPNTE = "None",
		LHPC = false,
		LHPS = "None",
		LHPSR = false,
		LHPNTEC = "None",
		LHPPL = 0,
		LHPPLT = 1,
		LHPPCLAE = false,
		LHPPCLA = {},
		LHNFilter = {},

		LMM = false,
		LMNC = {r = 0, g = 0, b = 1},
		LMPH = 1,
		LMPCR = 1,
		LMPNTE = "None",
		LMPC = false,
		LMPS = "None",
		LMPSR = false,
		LMPNTEC = "None",
		LMPPL = 0,
		LMPPLT = 1,
		LMPPCLAE = false,
		LMPPCLA = {},
		LMNFilter = {},

		LPM = false,
		LPNC = {r = 0, g = 0, b = 1},
		LPPH = 1,
		LPPCR = 1,
		LPPNTE = "None",
		LPPC = false,
		LPPS = "None",
		LPPSR = false,
		LPPNTEC = "None",
		LPPPL = 0,
		LPPPLT = 1,
		LPPPCLAE = false,
		LPPPCLA = {},
		LPNFilter = {},

		FCDPrefix = 1,

		UIEEnable = false,
		UIECombat = false,
		UIETimer = false,
		UIEDisable = {},
		UIETable = {
			["You are busy and can't use the taxi service now."] = "You are busy and can't use the taxi service now.",
			["Target not in line of sight"] = "Target not in line of sight",
			["Inventory is full."] = "Inventory is full.",
			["You can't do that while jumping or falling"] = "You can't do that while jumping or falling",
			["Failed attempt"] = "Failed attempt",
			["You need to be closer to interact with that target."] = "You need to be closer to interact with that target.",
			["Can't attack while invulnerable."] = "Can't attack while invulnerable.",
			["Can't do that while incapacitated"] = "Can't do that while incapacitated",
			["Target is too far away."] = "Target is too far away.",
			["Can't attack while dead."] = "Can't attack while dead.",
			["Target needs to be in front of you."] = "Target needs to be in front of you.",
			["Can't attack while polymorphed."] = "Can't attack while polymorphed.",
			["You can't do that while in combat"] = "You can't do that while in combat",
			["Not enough energy"] = "Not enough energy",
			["You can't mount while affected by that shapeshift."] = "You can't mount while affected by that shapeshift.",
			["Nothing to dispel"] = "Nothing to dispel",
			["You can't use that here."] = "You can't use that here.",
			["Another action is in progress"] = "Another action is in progress",
			["Item is not ready yet."] = "Item is not ready yet.",
			["You are in combat"] = "You are in combat",
			["Can't do that while stunned"] = "Can't do that while stunned",
			["Can't attack while asleep."] = "Can't attack while asleep.",
			["Can't attack while disoriented."] = "Can't attack while disoriented.",
			["Can't do that while silenced"] = "Can't do that while silenced",
			["You cannot attack that target."] = "You cannot attack that target.",
			["You are facing the wrong way!"] = "You are facing the wrong way!",
			["Not enough mana"] = "Not enough mana",
			["Ability is not ready yet."] = "Ability is not ready yet.",
			["You are dead"] = "You are dead",
			["Can only use outside"] = "Can only use outside",
			["You can't carry any more of those items."] = "You can't carry any more of those items.",
			["Already looted"] = "Already looted",
			["Players cannot be kicked during loot rolls."] = "Players cannot be kicked during loot rolls.",
			["Target too close"] = "Target too close",
			["Must have a Melee Weapon equipped"] = "Must have a Melee Weapon equipped",
			["Can't do that while asleep"] = "Can't do that while asleep",
			["Can't do that while moving"] = "Can't do that while moving",
			["No path available"] = "No path available",
			["Not enough rage"] = "Not enough rage",
			["You can't do that yet"] = "You can't do that yet",
			["Invalid target"] = "Invalid target",
			["Can only use while swimming"] = "Can only use while swimming",
			["Can't do that while disoriented"] = "Can't do that while disoriented",
			["Can't attack while pacified."] = "Can't attack while pacified.",
			["Out of range."] = "Out of range.",
			["You are too far away!"] = "You are too far away!",
			["Can't attack while stunned."] = "Can't attack while stunned.",
			["Spell is not ready yet."] = "Spell is not ready yet.",
			["Can't attack while fleeing."] = "Can't attack while fleeing.",
			["You are mounted."] = "You are mounted.",
			["There is nothing to attack."] = "There is nothing to attack.",
			["Players cannot be kicked while in combat, or shortly after combat."] = "Players cannot be kicked while in combat, or shortly after combat.",
			["That ability requires combo points"] = "That ability requires combo points",
			["Skill not high enough"] = "Skill not high enough",
			["You are in shapeshift form"] = "You are in shapeshift form",
			["Creature is not skinnable"] = "Creature is not skinnable",
			["You have no target."] = "You have no target.",
			["A more powerful spell is already active"] = "A more powerful spell is already active",
			["Interrupted"] = "Interrupted",
			["You are too far away."] = "You are too far away.",
			["You can't mount here."] = "You can't mount here.",
		},

		OneClickMount = false,
		SafeDismount = false,
		UseDruidForm = true,
		IncludeFFMount = false,
		OculusMounts = true,
		DruidFormOneClick = false,
		DruidFormOneClickInDoor = false,
		MountBlackList = {},
		DBWRemove = false,

		ABEnable = false,
		ABList = {},

		ElvUiCB = "backdrop",

		CInt = false,
		CIntPC = 1,
		CIntRC = 1,
		CIntS = "None",
		CIntHealer = true,
		CIntPlayer = true,
		CIntArena = false,
		CIntRoleMessage = false,
		CIntMinDur = 1,

		CCC = false,
		CCCPC = 1,
		CCCRC = 1,
		CCCS = "None",
		CCCHealer = true,
		CCCPlayer = true,
		CCCArena = false,
		CCCRoleMessage = false,
		CCCMinDur = 1,

		cc = {},
		silence = {},

		ABRemovalList = {["8359"] = "8359",},

		EnableChatHistory = false,
		MessageLimit = 200,
		ChatHistoryList = {},
		ChatHistoryMessages = {},

		DEQuality = {},
		DisenchantBlackList = {},
		MaxIlvlRange = 277,
		MinIlvlRange = 1,
		FCDAucMinPrice = 5000000,
		FCDAucMarketPrice = 5000000,
		DisenchantVMinPrice = false,
		DisenchantVMarketPrice = false,
		DisenchantPrint = true,
		AucSeenCount = 10,
		DisenchantVVendorPrice = true,
		DEItemTypeLimiter = {[1] = true, [2] = true},

		RMRWMessae = "I am re-making the raid stand by for invite.",
		RMRaidLog = {},
		RMRaidCount = 50,

		AMType = 2,

		SSDeath = false,
		SSAchiv = false,
		SSLvl = false,
		SSBoss = false,
		SSBG = false,
		SSArena = false,
		SSTrade = false,

		SSDeathInBG = false,

		SSDeathHide = false,
		SSDeathDelay = 0,
		SSAchivHide = false,
		SSAchivDelay = 0,
		SSLvlHide = false,
		SSLvlDelay = 0,
		SSBossHide = false,
		SSBossDelay = 0,
		SSBGHide = false,
		SSBGDelay = 0,
		SSArenaHide = false,
		SSArenaDelay = 0,
		SSTradeHide = false,
		SSTradeDelay = 0,

		Trade = false,
		TradeDrinksSolo = 5,
		TradeDrinksP = 5,
		TradeDrinksR = 5,
		TradeDrinkClasses = {},
		TradeFoodSolo = 5,
		TradeFoodP = 5,
		TradeFoodR = 5,
		TradeFoodClasses = {},
		TradeButtons = false,
		
		TradeStone = {},

		Lockboxes = false,

		CWEnable = false,
		CWECurrentGuild = false,
		CWEFirends = false,
		CWEAltGuilds = false,
		CWEWho = false,
		CWEAltGuildsSaved = {},
		CWEGroup = false,
		CWEPMed = 0,
		CWLog = {},
		CWESound = true,
		CWEReplyMessage = "FCD Auto Reply: Sorry your message was blocked by an addon",
		CWEPlayerSaved = {},
		CWEZone = false,
		CWEPosted = {},

		samechatmessages = 0,

		AGEnable = false,
		AGDungeon = false,
		AGMaxLvl = false,
		AGPrint = false,
		AGW = {},
		AGHide = false,
		AGBind = false,
		AGBags = false,
		AGToolTip2 = 1,
		AGSpecOverWrite = {},
		AGQuality = {},

		DispellerList = {
			["70410"] = {
				enable = false,
				instance = 1,
				boss = 1,
				chat = 5,
				timeout = false,
				death = false,
				applied = false,
				self = true,
				chat2 = 5,
				instance2 = 1,
				boss2 = 1,
			},
			["69674"] = {
				enable = false,
				instance = 1,
				boss = 1,
				chat = 5,
				timeout = false,
				death = false,
				applied = false,
				self = true,
				chat2 = 5,
				instance2 = 1,
				boss2 = 1,
			},
			["71103"] = {
				enable = false,
				instance = 1,
				boss = 1,
				chat = 5,
				timeout = false,
				death = false,
				applied = false,
				self = true,
				chat2 = 5,
				instance2 = 1,
				boss2 = 1,
			},
		},
		DispellerEnable = false,
		DispellerMDEnable = false,

		FishCount = 0,

		InspectEnable = false,
		ArmorType = true,
		LowLVLItems = 232,
		UnFitStats = true,
		UnGem = true,
		LowGem = true,
		LowEnchant = true,
		UnEnchant = true,
		IFPVPItems = true,
		IFGlyphs = true,
		LVL80 = true,
		IFFishing = true,
		IFTalents = true,
		PermaSum = {},
		IFSizeHight = 424,
		IFSizeWidth = 375,
		IFXOffSet = 345,
		IFYOffSet = -12,
		IFHit = true,
		IFDef = true,
		IFCooking = true,
		IFRaidInfo = true,

		SpammerTable = {},
		SpammerTime = 60,
		SpammerAmount = 0,

		SpellIcons = 20,
		ItemIcons = 20,
		AchivIcons = 20,
		ProfIcons = 20,

		NeedIcons = 20,
		NeedIconsTable = {},
		PassIcons = 20,
		PassIconsTable = {},
		GreedIcons = 20,
		GreedIconsTable = {},

		BlockInvite = 5,

		FCDSPBlackList = {},
		FCDSPMacros = false,
		FCDSPEnable = false,
		FCDSPMessages = false,
		FCDSP80 = false,
		FCDSPPlayer = false,
		FCDSPChannel = 1,
		FCDSPExpac = true,

		ChannelNames = {},
		ChannelNamesSettings = {},

		GlyphIDS = {},

		CustomPrintChatChannels = false,
		CustomPrintChatChannelsTable = {},

		frames = {
			[1] = {
				name 			= "Frame1",
				scale       	= 100.0,
				growUp  	    = false,
				alpha   	    = 100.0,
				opacity			= 100,
				width  			= 150,
				height 			= 14,
				fontsize		= 10,
				hideSelf	 	= false,
				HideArena	 	= false,
				ShowArena	 	= false,
				HideBG 			= false,
				HideInRaid 		= false,
				HideOutRaid		= false,
				HideInWG		= false,
				HideInCombat	= false,
				onlySelf 		= false,
				maxTextLength 	= 12,
				permanent 		= false,
				anchor			= true,
				hideFrame		= false,
				UsedMsg 		= false,
				hidetarget 		= false,
				HideLabel 		= false,
				EnemyFCDCaster 	= false,
				FriendlyCaster 	= false,
				SpellNameLabel 	= false,
				BarBackground 	= false,
				spells 			= {},
			},
		},
	}
}

function DefaultsChecker(Table)
	local TableMSG, CheckedTable, CheckedTable2 = Table[1], Table[2], {}
	for x, i in pairs(CheckedTable) do
		if type(i) == "table" then
			for x2, i2 in pairs(i) do
				if x2 ~= "ChatFilterReporterMessage" and x2 ~= "RMRaidLog" and x2 ~= "StoreClaSSInfoExtra" and x2 ~= "ChatHistoryMessages" then 
					if defaults.profile[x2] ~= i2 then
						CheckedTable2[x] = CheckedTable2[x] or {}
						CheckedTable2[x][x2] = i2
					end
				end
			end
		else
			if defaults.profile[x] ~= i then
				CheckedTable2[x] = i
			end
		end
	end
	return {TableMSG, CheckedTable2}
end

local optFrame
function mod:OnInitialize()
	Media:Register("font", "Adventure",						[[Interface\Addons\FatCooldowns\fonts\Adventure.ttf]])
	Media:Register("font", "ABF",							[[Interface\Addons\FatCooldowns\fonts\ABF.ttf]])
	Media:Register("font", "Vera Serif",					[[Interface\Addons\FatCooldowns\fonts\VeraSe.ttf]])
	Media:Register("font", "Diablo",						[[Interface\Addons\FatCooldowns\fonts\Avqest.ttf]])
	Media:Register("font", "Accidental Presidency",			[[Interface\Addons\FatCooldowns\fonts\Accidental Presidency.ttf]])
	Media:Register("font", "Bazooka",						[[Interface\Addons\FatCooldowns\fonts\Bazooka.ttf]])
	Media:Register("font", "BigNoodleTitling",				[[Interface\Addons\FatCooldowns\fonts\BigNoodleTitling.ttf]])
	Media:Register("font", "BigNoodleTitling-Oblique",		[[Interface\Addons\FatCooldowns\fonts\BigNoodleTitling-Oblique.ttf]])
	Media:Register("font", "BlackChancery",					[[Interface\Addons\FatCooldowns\fonts\BlackChancery.ttf]])
	Media:Register("font", "Emblem",						[[Interface\Addons\FatCooldowns\fonts\Emblem.ttf]])
	Media:Register("font", "Enigmatic",						[[Interface\Addons\FatCooldowns\fonts\Enigma__2.ttf]])
	Media:Register("font", "Movie_Poster-Bold",				[[Interface\Addons\FatCooldowns\fonts\Movie_Poster-Bold.ttf]])
	Media:Register("font", "Porky",							[[Interface\Addons\FatCooldowns\fonts\Porky.ttf]])
	Media:Register("font", "rm_midse",						[[Interface\Addons\FatCooldowns\fonts\rm_midse.ttf]])
	Media:Register("font", "Tangerin",						[[Interface\Addons\FatCooldowns\fonts\Tangerin.ttf]])
	Media:Register("font", "Tw_Cen_MT_Bold",				[[Interface\Addons\FatCooldowns\fonts\Tw_Cen_MT_Bold.ttf]])
	Media:Register("font", "Ultima_Campagnoli",				[[Interface\Addons\FatCooldowns\fonts\Ultima_Campagnoli.ttf]])
	Media:Register("font", "Yellowjacket",					[[Interface\Addons\FatCooldowns\fonts\Yellowjacket.ttf]])
	Media:Register("statusbar", "Aluminium",			[[Interface\Addons\FatCooldowns\statusbar\Aluminium]])
	Media:Register("statusbar", "Armory",				[[Interface\Addons\FatCooldowns\statusbar\Armory]])
	Media:Register("statusbar", "BantoBar",				[[Interface\Addons\FatCooldowns\statusbar\BantoBar]])
	Media:Register("statusbar", "Glaze2",				[[Interface\Addons\FatCooldowns\statusbar\Glaze2]])
	Media:Register("statusbar", "Gloss",				[[Interface\Addons\FatCooldowns\statusbar\Gloss]])
	Media:Register("statusbar", "Graphite",				[[Interface\Addons\FatCooldowns\statusbar\Graphite]])
	Media:Register("statusbar", "Grid",					[[Interface\Addons\FatCooldowns\statusbar\Grid]])
	Media:Register("statusbar", "Healbot",				[[Interface\Addons\FatCooldowns\statusbar\Healbot]])
	Media:Register("statusbar", "LiteStep",				[[Interface\Addons\FatCooldowns\statusbar\LiteStep]])
	Media:Register("statusbar", "Minimalist",			[[Interface\Addons\FatCooldowns\statusbar\Minimalist]])
	Media:Register("statusbar", "Otravi",				[[Interface\Addons\FatCooldowns\statusbar\Otravi]])
	Media:Register("statusbar", "Outline",				[[Interface\Addons\FatCooldowns\statusbar\Outline]])
	Media:Register("statusbar", "Perl",					[[Interface\Addons\FatCooldowns\statusbar\Perl]])
	Media:Register("statusbar", "Smooth",				[[Interface\Addons\FatCooldowns\statusbar\Smooth]])
	Media:Register("statusbar", "Round",				[[Interface\Addons\FatCooldowns\statusbar\Round]])
	Media:Register("statusbar", "TukTex",				[[Interface\Addons\FatCooldowns\statusbar\normTex]])
	self:ScheduleTimer("loadbars", 2)
	Media.RegisterCallback(self, "LibSharedMedia_Registered", "UpdateFCDMedia")
	Media:Register("background", "Bricks", 			[[Interface\AddOns\FatCooldowns\icons\Background\Bricks.tga]])
	Media:Register("background", "Brushed Metal", 	[[Interface\AddOns\FatCooldowns\icons\Background\Brushedmetal.tga]])
	Media:Register("background", "Copper",			[[Interface\AddOns\FatCooldowns\icons\Background\Copper.tga]])
	Media:Register("background", "Moo", 			[[Interface\AddOns\FatCooldowns\icons\Background\Moo.tga]])
	Media:Register("background", "Smoke", 			[[Interface\AddOns\FatCooldowns\icons\Background\Smoke.tga]])
	Media:Register("background", "Low Health 1", 			[[Interface\AddOns\FatCooldowns\icons\Background\FCDLH1.tga]])
	Media:Register("background", "Low Health 2", 			[[Interface\AddOns\FatCooldowns\icons\Background\FCDLH2.tga]])
	Media:Register("background", "Low Health 3", 			[[Interface\AddOns\FatCooldowns\icons\Background\FCDLH3.tga]])
	Media:Register("border", "Ferous 1", 	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous1.tga]])
	Media:Register("border", "Ferous 2", 	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous2.tga]])
	Media:Register("border", "Ferous 3", 	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous3.tga]])
	Media:Register("border", "Ferous 4", 	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous4.tga]])
	Media:Register("border", "Ferous 5", 	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous5.tga]])
	Media:Register("border", "Ferous 6", 	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous6.tga]])
	Media:Register("border", "Ferous 7", 	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous7.tga]])
	Media:Register("border", "Ferous 8",	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous8.tga]])
	Media:Register("border", "Ferous 9", 	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous9.tga]])
	Media:Register("border", "Ferous 10",	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous10.tga]])
	Media:Register("border", "Ferous 11", 	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous11.tga]])
	Media:Register("border", "Ferous 12", 	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous12.tga]])
	Media:Register("border", "Ferous 13", 	[[Interface\AddOns\FatCooldowns\icons\Border\Ferous13.tga]])
	Media:Register("border", "Raeli Glow", 	[[Interface\AddOns\FatCooldowns\icons\Border\RaeliGlow.tga]])
	Media:Register("border", "Raeli Glow Small", 	[[Interface\AddOns\FatCooldowns\icons\Border\RaeliGlowSmall.tga]])
	Media:Register("border", "RothSquare", 			[[Interface\AddOns\FatCooldowns\icons\Border\RothSquare.tga]])
	Media:Register("border", "SeerahScalloped", 	[[Interface\AddOns\FatCooldowns\icons\Border\SeerahScalloped.blp]])
	Media:Register("border", "Text Panel border", [[Interface\GLUES\COMMON\TextPanel-Border.blp]])
	Media:Register("border", "Wood border", [[Interface\AchievementFrame\UI-Achievement-WoodBorder.blp]])
end

function mod:loadbars()
	if self.db.profile.loadmore then
		Media:Register("statusbar", "FCD - Bars",				[[Interface\Addons\FatCooldowns\statusbar\Bars]])
		Media:Register("statusbar", "FCD - Bumps",				[[Interface\Addons\FatCooldowns\statusbar\Bumps]])
		Media:Register("statusbar", "FCD - Button",				[[Interface\Addons\FatCooldowns\statusbar\Button]])
		Media:Register("statusbar", "FCD - Charcoal",			[[Interface\Addons\FatCooldowns\statusbar\Charcoal]])
		Media:Register("statusbar", "FCD - Cilo",				[[Interface\Addons\FatCooldowns\statusbar\Cilo]])
		Media:Register("statusbar", "FCD - Cloud",				[[Interface\Addons\FatCooldowns\statusbar\Cloud]])
		Media:Register("statusbar", "FCD - Comet",				[[Interface\Addons\FatCooldowns\statusbar\Comet]])
		Media:Register("statusbar", "FCD - Dabs",				[[Interface\Addons\FatCooldowns\statusbar\Dabs]])
		Media:Register("statusbar", "FCD - DarkBottom",			[[Interface\Addons\FatCooldowns\statusbar\DarkBottom]])
		Media:Register("statusbar", "FCD - Diagonal",			[[Interface\Addons\FatCooldowns\statusbar\Diagonal]])
		Media:Register("statusbar", "FCD - Empty",				[[Interface\Addons\FatCooldowns\statusbar\Empty]])
		Media:Register("statusbar", "FCD - Falumn",				[[Interface\Addons\FatCooldowns\statusbar\Falumn]])
		Media:Register("statusbar", "FCD - Fifths",				[[Interface\Addons\FatCooldowns\statusbar\Fifths]])
		Media:Register("statusbar", "FCD - Flat",				[[Interface\Addons\FatCooldowns\statusbar\Flat]])
		Media:Register("statusbar", "FCD - Fourths",			[[Interface\Addons\FatCooldowns\statusbar\Fourths]])
		Media:Register("statusbar", "FCD - Frost",				[[Interface\Addons\FatCooldowns\statusbar\Frost]])
		Media:Register("statusbar", "FCD - Glamour",			[[Interface\Addons\FatCooldowns\statusbar\Glamour]])
		Media:Register("statusbar", "FCD - Glamour2",			[[Interface\Addons\FatCooldowns\statusbar\Glamour2]])
		Media:Register("statusbar", "FCD - Glamour3",			[[Interface\Addons\FatCooldowns\statusbar\Glamour3]])
		Media:Register("statusbar", "FCD - Glamour4",			[[Interface\Addons\FatCooldowns\statusbar\Glamour4]])
		Media:Register("statusbar", "FCD - Glamour5",			[[Interface\Addons\FatCooldowns\statusbar\Glamour5]])
		Media:Register("statusbar", "FCD - Glamour6",			[[Interface\Addons\FatCooldowns\statusbar\Glamour6]])
		Media:Register("statusbar", "FCD - Glamour7",			[[Interface\Addons\FatCooldowns\statusbar\Glamour7]])
		Media:Register("statusbar", "FCD - Glass",				[[Interface\Addons\FatCooldowns\statusbar\Glass]])
		Media:Register("statusbar", "FCD - Glaze",				[[Interface\Addons\FatCooldowns\statusbar\Glaze]])
		Media:Register("statusbar", "FCD - Hatched",			[[Interface\Addons\FatCooldowns\statusbar\Hatched]])
		Media:Register("statusbar", "FCD - Lyfe",				[[Interface\Addons\FatCooldowns\statusbar\Lyfe]])
		Media:Register("statusbar", "FCD - LiteStepLite",		[[Interface\Addons\FatCooldowns\statusbar\LiteStepLite]])
		Media:Register("statusbar", "FCD - Melli",				[[Interface\Addons\FatCooldowns\statusbar\Melli]])
		Media:Register("statusbar", "FCD - Melli Dark",			[[Interface\Addons\FatCooldowns\statusbar\MelliDark]])
		Media:Register("statusbar", "FCD - Melli Dark Rough",	[[Interface\Addons\FatCooldowns\statusbar\MelliDarkRough]])
		Media:Register("statusbar", "FCD - Perl v2",			[[Interface\Addons\FatCooldowns\statusbar\Perl2]])
		Media:Register("statusbar", "FCD - Pill",				[[Interface\Addons\FatCooldowns\statusbar\Pill]])
		Media:Register("statusbar", "FCD - Rain",				[[Interface\Addons\FatCooldowns\statusbar\Rain]])
		Media:Register("statusbar", "FCD - Rocks",				[[Interface\Addons\FatCooldowns\statusbar\Rocks]])
		Media:Register("statusbar", "FCD - Ruben",				[[Interface\Addons\FatCooldowns\statusbar\Ruben]])
		Media:Register("statusbar", "FCD - Runes",				[[Interface\Addons\FatCooldowns\statusbar\Runes]])
		Media:Register("statusbar", "FCD - Skewed",				[[Interface\Addons\FatCooldowns\statusbar\Skewed]])
		Media:Register("statusbar", "FCD - Smooth v2",			[[Interface\Addons\FatCooldowns\statusbar\Smoothv2]])
		Media:Register("statusbar", "FCD - Smudge",				[[Interface\Addons\FatCooldowns\statusbar\Smudge]])
		Media:Register("statusbar", "FCD - Steel",				[[Interface\Addons\FatCooldowns\statusbar\Steel]])
		Media:Register("statusbar", "FCD - Striped",			[[Interface\Addons\FatCooldowns\statusbar\Striped]])
		Media:Register("statusbar", "FCD - Tube",				[[Interface\Addons\FatCooldowns\statusbar\Tube]])
		Media:Register("statusbar", "FCD - Water",				[[Interface\Addons\FatCooldowns\statusbar\Water]])
		Media:Register("statusbar", "FCD - Wglass",				[[Interface\Addons\FatCooldowns\statusbar\Wglass]])
		Media:Register("statusbar", "FCD - Wisps",				[[Interface\Addons\FatCooldowns\statusbar\Wisps]])
		Media:Register("statusbar", "FCD - Xeon",				[[Interface\Addons\FatCooldowns\statusbar\Xeon]])
	end
end

function mod:IsWintergraspActive()
	local TTGZ = GetWintergraspWaitTime()
	if GetRealZoneText() == L["Wintergrasp"] and TTGZ == nil then return false end
	return true
end

function mod:UpdateFCDMedia(event, mediatype, key)
	if self.db == nil then return end
	if mediatype == "background" then
		if key == self.db.profile.Background.Texture then self:UpdateBackdrop() end
	elseif mediatype == "border" then
		if key == self.db.profile.Background.BorderTexture then self:UpdateBackdrop() end
	end
end

local bgFrame = {insets = {}}
function mod:UpdateBackdrop()
	bgFrame.bgFile = Media:Fetch("background", self.db.profile.Background.Texture)
	bgFrame.edgeFile = Media:Fetch("border", self.db.profile.Background.BorderTexture)
	bgFrame.tile = self.db.profile.Background.Tile
	bgFrame.tileSize = self.db.profile.Background.TileSize
	bgFrame.edgeSize = self.db.profile.Background.EdgeSize
	local inset = floor(self.db.profile.Background.EdgeSize / 4)
	bgFrame.insets.left = inset
	bgFrame.insets.right = inset
	bgFrame.insets.top = inset
	bgFrame.insets.bottom = inset

	local c = self.db.profile.Background.Color
	local bc = self.db.profile.Background.BorderColor

	if not barGroups then return end
	local _,zone2=IsInInstance()
	for i = 1, 10, 1 do
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and 
			(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and
			(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena") and
			(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
			(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive()) and
			(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player"))
			 then
				barGroups[i]:SetBackDrop(bgFrame)
				barGroups[i]:SetBackDropColor(c.r, c.g, c.b, c.a)
				barGroups[i]:SetBackDropBorderColor(bc.r, bc.g, bc.b, bc.a)
		end
	end
end

function mod:OnProfileChange(event, database, newProfileKey)
	self.db = database;
	mod:Reset();
	FatCooldowns:RefreshFrameListOptionsAndVariables()
	self:SetAnchors(true)
end

local FCDLDB = LibStub("LibDataBroker-1.1"):NewDataObject("FatCooldowns!", {
		type = "data source",
		text = "FatCooldowns!",
		icon = "Interface\\Icons\\achievement_dungeon_outland_dungeon_hero",
		OnTooltipShow = function(tt) tt:AddLine("FCD |cffFF7C0AShekles|r Version") end,
		OnClick = function() FatCooldowns:OpenConfigDialog() end,
	})
local icon = LibStub("LibDBIcon-1.0")
function mod:FCDMiniMap() 
	if self.db.profile.minimap.hide then icon:Hide("FatCooldowns!") else icon:Show("FatCooldowns!") end
end 

function mod:OnEnable()
	self.db = LibStub("AceDB-3.0"):New("FCD_DB", nil, "Default")
	self.db:RegisterDefaults(defaults)	
	
	optFrame = AceConfig:AddToBlizOptions("FatCooldowns", "FatCooldowns", nil, "BlizOptions")
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("FCD-Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))
	self.profilesFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("FCD-Profiles", "Profiles", "FatCooldowns")
	self.configOptions.args.Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.configOptions.args.Profiles.order = 8.99

	self.db.RegisterCallback(mod, "OnProfileChanged", "OnProfileChange")
	self.db.RegisterCallback(mod, "OnProfileCopied", "OnProfileChange")
	self.db.RegisterCallback(mod, "OnProfileReset", "OnProfileChange")

	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PARTY_INVITE_REQUEST")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	playerName = UnitName("player")

	mod:hookChatFrames()
	FatCooldowns.LogInTime = GetTime()

	
	self:CreateFrame()
	FatCooldowns:RefreshFrameListOptionsAndVariables()
	self:SetAnchors(true)
	FatCooldowns:RaidScan()

	icon:Register("FatCooldowns!", FCDLDB, self.db.profile.minimap)
end

function mod:OnDisable() end

function InviteChecker(invitenamer)
	if FatCooldowns.BWList[invitenamer] ~= nil and FatCooldowns.BWList[invitenamer].complete and FatCooldowns.BWList[invitenamer].level ~= nil and FatCooldowns.BWList[invitenamer].level ~= 0 then
		if FatCooldowns.BWList[invitenamer].level < FatCooldowns:GetModule("Display").db.profile.BlockInvite then
			StaticPopup_Hide("PARTY_INVITE")
		end
	end
end

function mod:PARTY_INVITE_REQUEST(self, invitenamer)
	FatCooldowns.BWList[invitenamer] = FatCooldowns.BWList[invitenamer] or {name = invitenamer, level = 0, class = "", zone = "", guild = "", notes = "", complete = false}
	wholib:AskWho({query = 'n-' .. invitenamer, queue = wholib.WHOLIB_QUEUE_QUIET, callback = ChatWhisperBlockerWhoLib}) 
	FatCooldowns:ScheduleTimer(function() InviteChecker(invitenamer) end, 0.3)
end

function mod:FCDColorText(Text,r,g,b)
   	Text = format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, Text)
	return Text
end

function mod:ChangeText(WordToReplace, inText, frame, id, ...)
	local WorkingWithText = strlower(inText)
	local WorkingWithWord = strlower(WordToReplace)
	local OGText = inText
	local Link = FatCooldowns:GetModule("Display").db.profile.HighLightList[WorkingWithWord]
	local b, e, OGWord, ReplaceWord, finishedText, unsearchedText
	local TempCheck = true
	local printable = gsub(WorkingWithText, "\124", "\124\124");
    local StartingCode, MessageCode = select(3, WorkingWithText:find("(.-|h]: )(.+)"))
    local ChannelCode = select(3, WorkingWithText:find("(.-[%a]+: )"))


   	if MessageCode == nil then MessageCode = WorkingWithText end

	if strfind(MessageCode, WorkingWithWord) then
		b, e = strfind(WorkingWithText, WorkingWithWord)
		b2, e2 = strfind(MessageCode, WorkingWithWord)

		if TempCheck then
			local StartingCodeMessage = strsub(MessageCode, 0, b2-1)
			local EndingCodeMessage = strsub(MessageCode, e2+1)

			if ChannelCode ~= nil and #ChannelCode < 8 then ChannelCode = select(3, WorkingWithText:find("(.-[%a]+: .-[%a]+: )")) end
		    if ChannelCode == nil then ChannelCode = select(3, WorkingWithText:find("(.-]|h)")) end
			if ChannelCode ~= nil and #ChannelCode > #StartingCodeMessage then TempCheck = false

			elseif StartingCodeMessage:find("|cff.+|h.+|h[\\[].*") and EndingCodeMessage:find(".*]|h|r") and MessageCode:find("|cff.+|h.+|h[\\[].*"..WorkingWithWord..".*]|h|r") then TempCheck = false 
			elseif StartingCodeMessage:find("|cff.+|hplayer:") and EndingCodeMessage:find("|h[\\[].*") and MessageCode:find("|cff.+|hplayer:"..WorkingWithWord.."|h[\\[].*") then TempCheck = false 
			elseif StartingCodeMessage:find("|hplayer:") and EndingCodeMessage:find("|h[\\[].*") and MessageCode:find("|hplayer:"..WorkingWithWord.."|h[\\[].*") then TempCheck = false 
			elseif StartingCodeMessage:find("|cff.+|hurl:.*") and EndingCodeMessage:find(".*|h[\\[].*"..WorkingWithWord..".*]|h|r") and MessageCode:find("|cff.+|hurl:.*"..WorkingWithWord..".*|h[\\[].*"..WorkingWithWord..".*]|h|r") then TempCheck = false 
			end 
		end

		if TempCheck then	
			if TempCheck then 
				OGWord = strsub(OGText, b, e)
				if next(FatCooldowns:GetModule("Display").db.profile.HighLightList) then
					for v, l in pairs(FatCooldowns:GetModule("Display").db.profile.HighLightList) do
						if v:lower():match(WorkingWithWord) then Link = FatCooldowns:GetModule("Display").db.profile.HighLightList[v] end
					end
				end
				ReplaceWord = self:FCDColorText(OGWord, Link.r, Link.g, Link.b) 
				OGText = gsub(OGText, OGWord, ReplaceWord, 1)
				b, e = strfind(strlower(OGText), WorkingWithWord)
				if strfind(strlower(OGText), WorkingWithWord, e +1) then
					finishedText = strsub(OGText, 1, e)
					unsearchedText = strsub(OGText, e + 1)
					OGText = finishedText .. self:ChangeText(WordToReplace, unsearchedText, frame, id, ...)
				end
			else
				b, e = strfind(strlower(OGText), WorkingWithWord)
				if strfind(strlower(OGText), WorkingWithWord, e +1) then
					finishedText = strsub(OGText, 1, e)
					unsearchedText = strsub(OGText, e + 1)
					OGText = finishedText .. self:ChangeText(WordToReplace, unsearchedText, frame, id, ...)
				end
			end
		else
			b, e = strfind(strlower(OGText), WorkingWithWord)
			if strfind(strlower(OGText), WorkingWithWord, e +1) then
				finishedText = strsub(OGText, 1, e)
				unsearchedText = strsub(OGText, e + 1)
				OGText = finishedText .. self:ChangeText(WordToReplace, unsearchedText, frame, id, ...)
			end
		end
	end
	return OGText
end

FatCooldowns.hookedFunc = {}
function mod:hookChatFrames()
	for i = 1, NUM_CHAT_WINDOWS do
		if _G["ChatFrame" .. i] ~= COMBATLOG then
			FatCooldowns.hookedFunc[_G["ChatFrame"..i]] = {}
			FatCooldowns.hookedFunc[_G["ChatFrame"..i]].org = _G["ChatFrame"..i].AddMessage
			_G["ChatFrame"..i].AddMessage = FCDAddMessage
		end
	end
end

FatCooldowns.MessagedPeople = {}
local AllowedMessage = {}
local MPT = true
function MessagedPeopleTimer()
	for name, time in pairs(FatCooldowns.MessagedPeople) do
		if GetTime() - time > (FatCooldowns:GetModule("Display").db.profile.CWEPMed * 60) then FatCooldowns.MessagedPeople[name] = nil end
	end
end
function CWBlockCheck(CWPlayerName)
	if FatCooldowns.BWList[CWPlayerName] and FatCooldowns.BWList[CWPlayerName].guild then
		if FatCooldowns:GetModule("Display").db.profile.CWEAltGuildsSaved[FatCooldowns.BWList[CWPlayerName].guild] then
			AllowedMessage[CWPlayerName] = true
		else
			AllowedMessage[CWPlayerName] = false
		end
	end
end
local LastPostedMessage = nil
function CWBlockCheckExtra(CWPlayerName)
	if FatCooldowns:GetModule("Display").db.profile.CWECurrentGuild then
		for x = 1, GetNumGuildMembers() do
			local name, rankName = GetGuildRosterInfo(x)
			if name == CWPlayerName then return false end
		end
	end
	if FatCooldowns:GetModule("Display").db.profile.CWEFirends then
		local TFriends = GetNumFriends()
		for i = 1, TFriends do
			local Name = GetFriendInfo(i)
			if Name == CWPlayerName then return false end
		end
	end
	if FatCooldowns:GetModule("Display").db.profile.CWEAltGuilds then
		if IsInGuild() then 
			local GuildName = GetGuildInfo("player")
			if GuildName ~= nil then
				FatCooldowns:GetModule("Display").db.profile.CWEAltGuildsSaved[GuildName] = GuildName
			end
		end
		if CWPlayerName then 
			local guildName, guildRankName, guildRankIndex = GetGuildInfo(CWPlayerName)
			if guildName and FatCooldowns:GetModule("Display").db.profile.CWEAltGuildsSaved[guildName] ~= nil then return false end
		end
	end
	if FatCooldowns:GetModule("Display").db.profile.CWEPlayerSaved[CWPlayerName] ~= nil then return false end
	if FatCooldowns:GetModule("Display").db.profile.CWEGroup then
		if UnitInParty(CWPlayerName) or UnitInRaid(CWPlayerName) then return false end
	end
	if FatCooldowns:GetModule("Display").db.profile.CWEPMed > 0 and FatCooldowns.MessagedPeople[CWPlayerName] ~= nil then
		if GetTime() - FatCooldowns.MessagedPeople[CWPlayerName] < (FatCooldowns:GetModule("Display").db.profile.CWEPMed * 60) then
			if MPT then MPT = false FatCooldowns:ScheduleRepeatingTimer(function() MessagedPeopleTimer() end, 60) end
			return false
		end
	end
	if LastPostedMessage ~= nil and GetTime() - LastPostedMessage < (FatCooldowns:GetModule("Display").db.profile.CWEPostedTimer * 60)  then return false end
	if FatCooldowns:GetModule("Display").db.profile.CWEZone and FatCooldowns.BWList[CWPlayerName] ~= nil and FatCooldowns.BWList[CWPlayerName].complete == true then
		local _,zone2 = GetZoneText()
		if zone2 == FatCooldowns.BWList[CWPlayerName].zone then return false end
	end
	return true
end

function CWLogMessage(Name, Message, class)
	local Name2 = Name
	if class ~= nil then Name2 = FCDColorName3(class, Name) end
	table.insert(FatCooldowns:GetModule("Display").db.profile.CWLog, 1, {[1] = time(), [2] = date("%d/%m/%y").." - "..date("%I:%M:%S %p").." - From: "..Name2.." To: "..FCDColorName(UnitName("player")).." : ".."|cffFF80FF"..Message.."|r"})
	if #FatCooldowns:GetModule("Display").db.profile.CWLog >= 16 then table.remove(FatCooldowns:GetModule("Display").db.profile.CWLog, 16) end
	table.sort(FatCooldowns:GetModule("Display").db.profile.CWLog, function(a,b) return a[1] > b[1] end)
end
local PartyRaidNames = {}
local TEXTURE_LINK_FORMAT_FORMAT = "|T%%s:%d:%d:0:0:64:64:6:58:6:58|t"
local TEXTURE_LINK_FORMAT_SPELLS
local TEXTURE_LINK_FORMAT_ITEMS
local TEXTURE_LINK_FORMAT_ACHIV
local TEXTURE_LINK_FORMAT_PROFESSION

local TEXTURE_LINK_FORMAT_ITEMS_NEED
local TEXTURE_LINK_FORMAT_ITEMS_GREED
local TEXTURE_LINK_FORMAT_ITEMS_PASS

local ITEM_LINK_PATTERN = "|c%x%x%x%x%x%x%x%x|Hitem:(%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:?-?%d*|h"
local SPELL_LINK_PATTERN = "|c%x%x%x%x%x%x%x%x|Hspell:(%d+)|h"
local ACHIEVEMENT_LINK_PATTERN = "|c%x%x%x%x%x%x%x%x|Hachievement:(%d+):[%x:-]+|h"
local PROFESSION_LINK_PATTERN = "|c%x%x%x%x%x%x%x%x|Htrade:(%d+):([-?%d:]*):([^|]*)|h"

function FCDAddMessage(frame, inText, r, g, b, id, ...) -- 2 = say, 7 = yell, 63 = chan 1, 64 = chan 2, 65 = chan 3, 66 = chan 4, 67 = chan 5
	local ColoredName = false
	if FatCooldowns:GetModule("Display").db.profile.CWEnable and id ~= nil and (id == 2 or id == 7 or id == 63 or id == 64 or id == 65 or id == 66 or id == 67) then
		if FatCooldowns.LogInTime == nil then FatCooldowns.LogInTime = GetTime() end
		local startCWPlayerName, CWPlayerName, EndCWPlayerName = select(3, inText:find("(.+Hplayer):(%a+):(.+)"))
		if CWPlayerName == UnitName("player") then
			if id == 2 and FatCooldowns.LogInTime ~= nil and GetTime() - FatCooldowns.LogInTime > 5 then
				if FatCooldowns:GetModule("Display").db.profile.CWEPosted["CHAT_MSG_SAY"] ~= nil and FatCooldowns:GetModule("Display").db.profile.CWEPosted["CHAT_MSG_SAY"] == true then
					LastPostedMessage = GetTime()
				end
			elseif id == 7 and FatCooldowns.LogInTime ~= nil and GetTime() - FatCooldowns.LogInTime > 5 then
				if FatCooldowns:GetModule("Display").db.profile.CWEPosted["CHAT_MSG_YELL"] ~= nil and FatCooldowns:GetModule("Display").db.profile.CWEPosted["CHAT_MSG_YELL"] == true then
					LastPostedMessage = GetTime()
				end
			elseif (id == 63 or id == 64 or id == 65 or id == 66 or id == 67) and FatCooldowns.LogInTime ~= nil and GetTime() - FatCooldowns.LogInTime > 5 then
				if FatCooldowns:GetModule("Display").db.profile.CWEPosted["CHAT_MSG_CHANNEL"] ~= nil and FatCooldowns:GetModule("Display").db.profile.CWEPosted["CHAT_MSG_CHANNEL"] == true then
					LastPostedMessage = GetTime()
				end
			end
		end
	end 
	if id ~= nil and id == 10 and FatCooldowns.LogInTime ~= nil and GetTime() - FatCooldowns.LogInTime > 5 and FatCooldowns:GetModule("Display").db.profile.CWEnable then
		local startCWPlayerName, CWPlayerName, EndCWPlayerName = select(3, inText:find("(.+Hplayer):(%a+):(.+)"))
		if FatCooldowns:GetModule("Display").db.profile.CWEPMed > 0 then FatCooldowns.MessagedPeople[CWPlayerName] = GetTime() end
	end
	if id ~= nil and id == 8 and FatCooldowns.LogInTime ~= nil and GetTime() - FatCooldowns.LogInTime > 5 then
		local arg1, arg2, arg3, arg4, arg5 = ...
		if FatCooldowns:GetModule("Display").db.profile.CWEnable and not inText:find("FCD Auto Reply: Sorry your message was blocked by an addon") then
			local startCWPlayerName, CWPlayerName, EndCWPlayerName = select(3, inText:find("(.+Hplayer):(%a+):(.+)"))
			local startCWPlayerName2, CWPlayerName2, EndCWPlayerName2 = select(3, EndCWPlayerName:find("(.+)(|r]|h whispers: )(.+)"))
			if startCWPlayerName ~= nil and not startCWPlayerName:find("<GM>") and startCWPlayerName2 ~= nil then
				if CWBlockCheckExtra(CWPlayerName) then
					local classfound = nil
					local classcolortable = {
						["DEATHKNIGHT"] = "|cffC41F3B", 
						["DRUID"] = "|cffFF7D0A", 
						["HUNTER"] = "|cffABD473",
						["MAGE"] = "|cff69CCF0",
						["PALADIN"] = "|cffF58CBA",
						["PRIEST"] = "|cffFFFFFF",
						["ROGUE"] = "|cffFFF569",
						["SHAMAN"] = "|cff0070DE",
						["WARLOCK"] = "|cff9482C9",
						["WARRIOR"] = "|cffC79C6E",

						["Death Knight"] = "|cffC41E3A", 
						["Druid"] = "|cffFF7C0A", 
						["Hunter"] = "|cffAAD372",
						["Mage"] = "|cff3FC7EB",
						["Paladin"] = "|cffF48CBA",
						["Priest"] = "|cffFFFFFF",
						["Rogue"] = "|cffFFF468",
						["Shaman"] = "|cff0070DD",
						["Warlock"] = "|cff8788EE",
						["Warrior"] = "|cffC69B6D",

						["Warlock2"] = "|cff9382c9",
						["Mage2"] = "|cff68ccef",

					}
					for x,c in pairs(classcolortable) do
						local lowerc = string.lower(c)
						local startCWPlayerName22 = string.lower(startCWPlayerName2)
						if startCWPlayerName22:lower():find(lowerc) then
							local Tempx = x
							if x == "Warlock2" then Tempx = "Warlock" end
							if x == "Mage2" then Tempx = "Mage" end
							classfound = Tempx
						end
					end
					FatCooldowns.BWList[CWPlayerName] = FatCooldowns.BWList[CWPlayerName] or {name = WhisperName, level = 0, class = "", zone = "", guild = "", notes = "", complete = false}
					if FatCooldowns:GetModule("Display").db.profile.CWEWho then wholib:AskWho({query = 'n-' .. CWPlayerName, queue = wholib.WHOLIB_QUEUE_QUIET, callback = ChatWhisperBlockerWhoLib }) end
					FatCooldowns:ScheduleTimer(function() CWBlockCheck(CWPlayerName) end, 0.3)
					if AllowedMessage[CWPlayerName] == nil then
						FatCooldowns:ScheduleTimer(function() FCDAddMessage(frame, inText, r, g, b, id, arg1, arg2, arg3, arg4, arg5) end, 0.6)
						return
					elseif AllowedMessage[CWPlayerName] ~= nil and AllowedMessage[CWPlayerName] == false then
						if (FatCooldowns.LastSent[CWPlayerName] == nil or FatCooldowns.LastSent[CWPlayerName] ~= nil and GetTime() - FatCooldowns.LastSent[CWPlayerName] > 0.4) and EndCWPlayerName2 ~= nil then
							if FatCooldowns:GetModule("Display").db.profile.CWEReply then SendChatMessage("FCD Auto Reply: Sorry your message was blocked by an addon", "WHISPER", nil, CWPlayerName) end
							if FatCooldowns:GetModule("Display").db.profile.CWESound then PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\Blocked.mp3", "Master",false) end
							FatCooldowns.HistoryFilterChecker[#FatCooldowns.HistoryFilterChecker + 1] = {name = CWPlayerName, msg = EndCWPlayerName2}
							CWLogMessage(CWPlayerName, EndCWPlayerName2, classfound)
							FatCooldowns.LastSent[CWPlayerName] = GetTime()
						end
						return
					end
				end
			end
		end
	end
 	if id ~= nil and 
 		((id == 28 and (FatCooldowns:GetModule("Display").db.profile.ColorNamesLoot or FatCooldowns:GetModule("Display").db.profile.ColorNamesLoot2)) or
 		(id == 1 and (FatCooldowns:GetModule("Display").db.profile.ColorNamesSystem or FatCooldowns:GetModule("Display").db.profile.ColorNamesSystem2))) then 
 		--	local printable = gsub(inText, "\124", "\124\124");
		--	print(printable..id)
		local members, PartyType, ScanName = nil, nil, nil
		if UnitInRaid("player") then
			members = GetNumRaidMembers()
			PartyType = "raid"
		elseif GetNumPartyMembers() > 0 then
			members = GetNumPartyMembers() + 1
			PartyType = "party"
		else
			members = 0
			PartyType = "party"
		end
		for i = 1,members,1 do
			if PartyType == "party" and i > GetNumPartyMembers() then
				ScanName = UnitName("player")
			elseif PartyType == "party" then
				ScanName = UnitName(PartyType..i)
			elseif PartyType == "raid" then
				ScanName = UnitName(PartyType..i)
			end
			if ScanName ~= nil and ScanName ~= "Unknown" and ScanName ~= "" then PartyRaidNames[ScanName] = ScanName end
			if ScanName ~= nil and ScanName ~= "Unknown" and ScanName ~= "" and (inText:find("^"..ScanName.." ") or inText:find(" "..ScanName.."$")) then 
				local PNC = FCDColorName(ScanName)
				if PNC ~= nil and ((FatCooldowns:GetModule("Display").db.profile.ColorNamesSystem and id == 1) or (id == 28 and FatCooldowns:GetModule("Display").db.profile.ColorNamesLoot)) then
					inText = gsub(inText, ScanName, PNC)
					ColoredName = true
				elseif PNC ~= nil and ((FatCooldowns:GetModule("Display").db.profile.ColorNamesSystem2 and id == 1) or (id == 28 and FatCooldowns:GetModule("Display").db.profile.ColorNamesLoot2)) then
					inText = gsub(inText, ScanName, "|Hplayer:"..ScanName.."|h["..PNC.."]|h")
					ColoredName = true
				end
			end
	 	end
	 	if not ColoredName then
	 		if PartyRaidNames then
	 			for PRName, _ in pairs(PartyRaidNames) do
	 				if (inText:find("^"..PRName.." ") or inText:find(" "..PRName.."$")) and not inText:find("|Hplayer:"..PRName) and not inText:find("|h[\\[]"..PRName.."]|h") then
	 					local PNC = FCDColorName(PRName)
						if PNC ~= nil and ((FatCooldowns:GetModule("Display").db.profile.ColorNamesSystem and id == 1) or (id == 28 and FatCooldowns:GetModule("Display").db.profile.ColorNamesLoot)) then
							inText = gsub(inText, PRName, PNC)
						elseif PNC ~= nil and ((FatCooldowns:GetModule("Display").db.profile.ColorNamesSystem2 and id == 1) or (id == 28 and FatCooldowns:GetModule("Display").db.profile.ColorNamesLoot2)) then
							inText = gsub(inText, PRName, "|Hplayer:"..PRName.."|h["..PNC.."]|h")
						end
					end
	 			end
	 		end
	 	end
	 	if inText:find("^[A-Z][%a]+ joins the party.$") then
	 		if FatCooldowns:GetModule("Display").db.profile.ColorNamesSystem2 and id == 1 then
				local realscrnameone, realscrnametwo = select(3, inText:find("(%a+) (.+)"))
				if realscrnameone ~= nil then 
					inText = gsub(inText, realscrnameone, "|Hplayer:"..realscrnameone.."|h["..realscrnameone.."]|h")
				end
	 		elseif FatCooldowns:GetModule("Display").db.profile.ColorNamesSystem and id == 1 then
				local realscrnameone, realscrnametwo = select(3, inText:find("(%a+) (.+)"))
				if realscrnameone ~= nil then 
					local PNC = FCDColorName(realscrnameone)
					if PNC ~= nil then 
						inText = gsub(inText, "^"..realscrnameone, PNC)
					end
				end
			end
 		end
	end
	if id ~= nil and frame ~= nil and id ~= 28 and id ~= 1 and not (inText:find("Left Channel: |Hchannel:") or inText:find("Changed Channel: |Hchannel:") or inText:find("Joined Channel: |Hchannel:")) then
		--local printable = gsub(inText, "\124", "\124\124");
		--print(printable..id)
		for k,v in pairs(FatCooldowns:GetModule("Display").db.profile.HighLightList) do
			local TempEnableChat = false
			if next(FatCooldowns:GetModule("Display").db.profile.HighLightList[k].Filter) then
				for m,n in pairs(FatCooldowns:GetModule("Display").db.profile.HighLightList[k].Filter) do
					if n and GetChatTypeIndex(m) == id then TempEnableChat = true break end
				end
			end
			if TempEnableChat then
				inText = FatCooldowns:GetModule("Display"):ChangeText(k, inText, frame, id, ...)
				if inText:find(k) and (LastSoundPlay[k] == nil or (LastSoundPlay[k] ~= nil and  GetTime() - LastSoundPlay[k] > 1)) then
					PlaySoundFile(FatCooldowns.FCDSounds[FatCooldowns:GetModule("Display").db.profile.HighLightList[k].sound], "Master",false)
					LastSoundPlay[k] = GetTime()
				end
			end
			TempEnableChat = false
		end
	end
	inText = FatCooldowns:GetModule("Display"):ProcessMessage(inText)
	FatCooldowns.hookedFunc[frame].org(frame, inText, r, g, b, id, ...)
end

function mod:parseMessage(s, iconFormat, pattern, geticon)
    local matchStart, matchEnd, match = s:find(pattern)
    if not iconFormat then self:UpdateTextureLinkFormat() return s end
	while match do 
		local icon = geticon(match)
		local iconlength = 0
		if icon then
			local iconstring = iconFormat:format(icon)
			if iconstring then
				iconlength = #iconstring
				s = s:sub(1,matchStart - 1) .." ".. iconstring .. s:sub(matchStart)
			end
		end
		matchStart,matchEnd,match = s:find(pattern,matchEnd + iconlength)
	end
	return s
end
function mod:ProcessMessage(msg)
	if FatCooldowns:GetModule("Display").db.profile.NeedIcons > 0 then
    	msg = self:parseMessage(msg, TEXTURE_LINK_FORMAT_ITEMS, ITEM_LINK_PATTERN, 
    		function(id)
    			if FatCooldowns:GetModule("Display").db.profile.NeedIconsTable[tonumber(id)] then
    				local icon = "Interface\\AddOns\\FatCooldowns\\icons\\Dice.blp" 
    				return icon
    			else
    				return nil
    			end
    		end)
	end
	if FatCooldowns:GetModule("Display").db.profile.GreedIcons > 0 then
    	msg = self:parseMessage(msg, TEXTURE_LINK_FORMAT_ITEMS, ITEM_LINK_PATTERN, 
    		function(id)
    			if FatCooldowns:GetModule("Display").db.profile.GreedIconsTable[tonumber(id)] then
    				local icon = "Interface\\AddOns\\FatCooldowns\\icons\\Coins.blp" 
    				return icon
    			else
    				return nil
    			end
    		end)
	end
	if FatCooldowns:GetModule("Display").db.profile.PassIcons > 0 then
    	msg = self:parseMessage(msg, TEXTURE_LINK_FORMAT_ITEMS, ITEM_LINK_PATTERN, 
    		function(id)
    			if FatCooldowns:GetModule("Display").db.profile.PassIconsTable[tonumber(id)] then
	    			local icon = "Interface\\AddOns\\FatCooldowns\\icons\\Pass.blp"
    				return icon
    			else
    				return nil
    			end
    		end)
	end

    if FatCooldowns:GetModule("Display").db.profile.ItemIcons > 0 then msg = self:parseMessage(msg, TEXTURE_LINK_FORMAT_ITEMS, ITEM_LINK_PATTERN, GetItemIcon) end
    if FatCooldowns:GetModule("Display").db.profile.SpellIcons > 0 then msg = self:parseMessage(msg, TEXTURE_LINK_FORMAT_SPELLS, SPELL_LINK_PATTERN, function(id) local _, _, icon = GetSpellInfo(id) return icon end) end
    if FatCooldowns:GetModule("Display").db.profile.AchivIcons > 0 then msg = self:parseMessage(msg, TEXTURE_LINK_FORMAT_ACHIV, ACHIEVEMENT_LINK_PATTERN, function(id) return select(10, GetAchievementInfo(id)) end) end
    if FatCooldowns:GetModule("Display").db.profile.ProfIcons > 0 then msg = self:parseMessage(msg, TEXTURE_LINK_FORMAT_PROFESSION, PROFESSION_LINK_PATTERN, function(id) local _, _, icon = GetSpellInfo(id) return icon end) end

    return msg
end

function mod:UpdateTextureLinkFormat() 
	TEXTURE_LINK_FORMAT_SPELLS = TEXTURE_LINK_FORMAT_FORMAT:format(FatCooldowns:GetModule("Display").db.profile.SpellIcons, FatCooldowns:GetModule("Display").db.profile.SpellIcons, -4)
	TEXTURE_LINK_FORMAT_ITEMS = TEXTURE_LINK_FORMAT_FORMAT:format(FatCooldowns:GetModule("Display").db.profile.ItemIcons, FatCooldowns:GetModule("Display").db.profile.ItemIcons, -4)
	TEXTURE_LINK_FORMAT_ACHIV = TEXTURE_LINK_FORMAT_FORMAT:format(FatCooldowns:GetModule("Display").db.profile.AchivIcons, FatCooldowns:GetModule("Display").db.profile.AchivIcons, -4)
	TEXTURE_LINK_FORMAT_PROFESSION = TEXTURE_LINK_FORMAT_FORMAT:format(FatCooldowns:GetModule("Display").db.profile.ProfIcons, FatCooldowns:GetModule("Display").db.profile.ProfIcons, -4)
end

function UnitIDByName(IDName)
	local members = nil

	if UnitInRaid("player") then
		members = GetNumRaidMembers()
	elseif GetNumPartyMembers() > 0 then
		members = GetNumPartyMembers() + 1
	else 
		members = 0
	end
	local PartyType = nil
	if UnitInRaid("player") then 
		PartyType = "raid"
	elseif not UnitInRaid("player") and i <= GetNumPartyMembers() then
		PartyType = "party"
	end
	for i = 1,members,1 do
		if IDName == UnitName(PartyType..i) then return i end
	end
end

local hexColors = {}
function ColorNames()
	local FCDClass = {"DEATHKNIGHT", "DRUID", "HUNTER", "MAGE", "PALADIN", "PRIEST", "ROGUE", "SHAMAN", "WARLOCK", "WARRIOR"}
	for k,v in pairs(FCDClass) do
		local CCName = RAID_CLASS_COLORS[v]
		hexColors[v] = string.format("|cff%02x%02x%02x", CCName.r*255, CCName.g*255, CCName.b*255)
	end
	hexColors["UNKNOWN"] = string.format("|cff%02x%02x%02x", 0.6*255, 0.6*255, 0.6*255)
end

local GroupsInRaid = {}
local RaidInRaid = {}
local RaidInRaidID = {}
function init()
	ColorNames()
	table.wipe(GroupsInRaid)
	table.wipe(RaidInRaid)
	table.wipe(RaidInRaidID)
	local Candidate = nil
	local info = UIDropDownMenu_CreateInfo()
	if UIDROPDOWNMENU_MENU_LEVEL == 2 then
		for i = 1, 40 do
			Candidate = GetMasterLootCandidate(i)
			if Candidate and UnitInRaid(Candidate) then
				RaidInRaidID[Candidate] = i
				local InT = false
				for k,v in pairs(RaidInRaid) do
					if Candidate == RaidInRaid[k] then InT = true end
				end
				if not InT then	table.insert(RaidInRaid, Candidate) InT = false end
			end
		end
		table.sort( RaidInRaid )
		for k, Candidate in pairs(RaidInRaid) do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(UnitIDByName(Candidate))
			if subgroup == UIDROPDOWNMENU_MENU_VALUE then
				info.text = Candidate
				info.colorCode = hexColors[fileName] or hexColors["UNKOWN"]
				info.textHeight = 12
				info.value = RaidInRaidID[Candidate]
				info.notCheckable = 1
				info.disabled = nil
				info.func = GroupLootDropDown_GiveLoot
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL)
			end
			if "Raid" == UIDROPDOWNMENU_MENU_VALUE then 
				info.text = Candidate
				info.colorCode = hexColors[fileName] or hexColors["UNKOWN"]
				info.textHeight = 12
				info.value = RaidInRaidID[Candidate]
				info.notCheckable = 1
				info.disabled = nil
				info.func = GroupLootDropDown_GiveLoot
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL)
			end
		end
		return
	end
	info.isTitle = 1
	info.text = GIVE_LOOT
	info.textHeight = 12
	info.notCheckable = 1
	info.disabled = nil
	info.notClickable = nil
	UIDropDownMenu_AddButton(info)
	if GetNumRaidMembers() > 0 then
		for k, v in pairs(GroupsInRaid) do
			GroupsInRaid[k] = nil
		end
		for i = 1, 40 do
			Candidate = GetMasterLootCandidate(i)
			if Candidate and UnitInRaid(Candidate) then
				local name, rank, subgroup, level, class = GetRaidRosterInfo(UnitIDByName(Candidate))
				GroupsInRaid[subgroup] = GroupsInRaid[subgroup] or subgroup
			end		
		end
		for k, v in pairs(GroupsInRaid) do
			info.isTitle = nil
			info.text = "Group "..k
			info.colorCode = "|cff999999"
			info.textHeight = 12
			info.hasArrow = 1
			info.notCheckable = 1
			info.value = k
			info.func = nil
			info.disabled = nil
			UIDropDownMenu_AddButton(info)
		end
		info.isTitle = nil
		info.text = "Raid"
		info.colorCode = "|cff999999"
		info.textHeight = 12
		info.hasArrow = 1
		info.notCheckable = 1
		info.value = k
		info.func = nil
		info.disabled = nil
		UIDropDownMenu_AddButton(info)
	else
		for i=1, MAX_PARTY_MEMBERS+1, 1 do
			Candidate = GetMasterLootCandidate(i)
			if Candidate then
				info.text = Candidate
				info.colorCode = hexColors[fileName] or hexColors["UNKOWN"]
				info.textHeight = 12
				info.value = i
				info.notCheckable = 1
				info.hasArrow = nil
				info.isTitle = nil
				info.disabled = nil
				info.func = GroupLootDropDown_GiveLoot
				UIDropDownMenu_AddButton(info)
			end
		end
	end
end
function init2()
	ColorNames()
	table.wipe(RaidInRaid)
	table.wipe(RaidInRaidID)
	local Candidate = nil
	local info = UIDropDownMenu_CreateInfo()
	for i = 1, 40 do
		Candidate = GetMasterLootCandidate(i)
			if Candidate and UnitInRaid(Candidate) then
			RaidInRaidID[Candidate] = i
			local InT = false
			for k,v in pairs(RaidInRaid) do
				if Candidate == RaidInRaid[k] then InT = true end
			end
			if not InT then	table.insert(RaidInRaid, Candidate) InT = false end
		end
	end
	table.sort( RaidInRaid )
	for k, Candidate in pairs(RaidInRaid) do
		local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(UnitIDByName(Candidate))
		info.text = Candidate
		info.colorCode = hexColors[fileName] or hexColors["UNKOWN"]
		info.textHeight = 12
		info.value = RaidInRaidID[Candidate]
		info.notCheckable = 1
		info.disabled = nil
		info.func = GroupLootDropDown_GiveLoot
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL)	
	end
end

local function MoveItems(Link, itemType2, itemSubType2, ItemID2)
	for x = 0, 4 do 
		for y = 1, GetContainerNumSlots(x) do
			local icon, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(x,y)
			if itemLink ~= nil then 
				local ItemName, itemLink2, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemLink)
				local ItemID = tostring(GetContainerItemID(x,y))
				if FatCooldowns:GetModule("Display").db.profile.MoveItemType and itemType2 == itemType then
					UseContainerItem(x,y)
				elseif FatCooldowns:GetModule("Display").db.profile.MoveItemSubType and itemSubType2 == itemSubType then
					UseContainerItem(x,y)
				elseif FatCooldowns:GetModule("Display").db.profile.MoveID and ItemID2 == ItemID then
					UseContainerItem(x,y)
				end
			end
		end
	end
end
local isBankOpen = false
local function ItemHook(self, button)
	if isBankOpen and IsAltKeyDown() and button == "RightButton" then 
		local icon, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(self:GetParent():GetID(), self:GetID())
		local ItemName, itemLink2, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemLink)
		local ItemID = tostring(GetContainerItemID(self:GetParent():GetID(), self:GetID()))
		MoveItems(itemLink, itemType, itemSubType, ItemID)
	end
end
local BankMoveItems = CreateFrame("Frame")
BankMoveItems:RegisterEvent("BANKFRAME_OPENED")
BankMoveItems:RegisterEvent("BANKFRAME_CLOSED")
BankMoveItems:SetScript("OnEvent", function(self, event)
	if event == "BANKFRAME_OPENED" then
		isBankOpen = true
	else
		isBankOpen = false
	end
end)
hooksecurefunc("ContainerFrameItemButton_OnClick", ItemHook)
hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", ItemHook)

local InspectedHook = false
if not InspectedHook then hooksecurefunc("NotifyInspect", function(...) return mod:NotifyInspect(...) end) end
local InspectedTable = {}
local AorHTable = {
	["Orc"] = "Horde",
	["Troll"] = "Horde",
	["Tauren"] = "Horde",
	["BloodElf"] = "Horde",
	["Undead"] = "Horde",
	["Scourge"] = "Horde",
	["Human"] = "Alliance",
	["NightElf"] = "Alliance",
	["Dwarf"] = "Alliance",
	["Gnome"] = "Alliance",
	["Draenei"] = "Alliance",
}
function mod:NotifyInspect(unit)
--    if not InspectFrame or not InspectFrame:IsShown() then return end

	if (not (UnitExists(unit) and UnitIsVisible(unit) and UnitIsConnected(unit) and CheckInteractDistance(unit, 4))) then return end
	if InspectFrame ~= nil and InspectFrame.unit ~= nil and UnitName(InspectFrame.unit) ~= UnitName(unit) then return end

	InspectedTable.lastInspectUnit = unit
	InspectedTable.lastInspectGUID = UnitGUID(unit)
	InspectedTable.lastInspectName = UnitName(unit)
	InspectedTable.lastInspectTime = GetTime()
	InspectedTable.lastInspectClass = UnitClass(unit)
	InspectedTable.lastInspectLevel = UnitLevel(unit)
	local FRace, RRace = UnitRace(unit)
	InspectedTable.lastInspectFaction = RRace
	if IsAddOnLoaded("GearScoreLite") then InspectedTable.lastInspectGS = GearScore_GetScore(UnitName(unit), unit) end
end

local Inspected = false
local AddInspectFrameHooks = true
local LastHidden = ""
local FrameContainer
local LastInspectTime = 0
local FrameContainerSimpleText2 = {}
local FrameContainerAmLink
local FrameContainerScroller
function HideInspectWindow()
	if Inspected then FrameContainer:Release() ClearAchievementComparisonUnit() end
	Inspected = false
end
function mod:InspectFrame(ModSettings, ModSettings2, ModSettings3)
	if FatCooldowns:GetModule("Display").db.profile.InspectEnable and InspectFrame and InspectFrame:IsVisible() and AorHTable[InspectedTable.lastInspectFaction] == UnitFactionGroup("player") and InspectedTable.lastInspectLevel ~= -1 then
		if UnitName(InspectFrame.unit) == InspectedTable.lastInspectName then
			if not Inspected then
				Inspected = true
				FrameContainer = AceGUI:Create("Window")
				FrameContainer:SetWidth(FatCooldowns:GetModule("Display").db.profile.IFSizeWidth)
				FrameContainer:SetHeight(FatCooldowns:GetModule("Display").db.profile.IFSizeHight)
				FrameContainer:SetPoint("TOP", InspectFrame, "TOP", FatCooldowns:GetModule("Display").db.profile.IFXOffSet, FatCooldowns:GetModule("Display").db.profile.IFYOffSet)
				FrameContainer:SetStatusText("FCD: Inspect Window")
				FrameContainer:SetFullWidth(true)
				FrameContainer:SetLayout("Fill")
				FrameContainer:EnableResize(false)

				if AddInspectFrameHooks then 
					InspectFrame:HookScript("OnHide", HideInspectWindow)
					hooksecurefunc("InspectFrame_UnitChanged", HideInspectWindow)
					AddInspectFrameHooks = false
				end

				FrameContainerScroller = AceGUI:Create("ScrollFrame")
				FrameContainerScroller:SetFullWidth(true)
				FrameContainer:AddChild(FrameContainerScroller)

				FrameContainer.Name = InspectedTable.lastInspectName

				FrameContainerAmLink = AceGUI:Create("EditBox")
				FrameContainerAmLink:SetLabel("Warmane Armory Link")
				FrameContainerAmLink:SetFullWidth(true)
				FrameContainerScroller:AddChild(FrameContainerAmLink)
				FrameContainerAmLink:DisableButton(true)

				for x = 1, 100 do
					FrameContainerSimpleText2[x] = AceGUI:Create("InteractiveLabel")
					FrameContainerScroller:AddChild(FrameContainerSimpleText2[x])
					FrameContainerSimpleText2[x]:SetFullWidth(true)
			        FrameContainerSimpleText2[x]:SetFont("Fonts\\FRIZQT__.TTF", 11)
			        FrameContainerSimpleText2[x]:SetText(' ')
				end

				if InspectedTable.lastInspectLevel == 80 and FatCooldowns:GetModule("Display").db.profile.LVL80 or not FatCooldowns:GetModule("Display").db.profile.LVL80 then FatCooldowns:ScheduleTimer(function() mod:FillInspectFrame() end, 0.3) else FrameContainer:Hide() end
			elseif ModSettings == 1 then
				FrameContainer:SetWidth(ModSettings2)
				FrameContainer:SetHeight(ModSettings3)
			elseif ModSettings == 2 then
				FrameContainer:SetPoint("TOP", InspectFrame, "TOP", ModSettings2, ModSettings3)
			elseif InspectedTable.lastInspectTime - LastInspectTime > 1 then
				if LastHidden ~= InspectedTable.lastInspectName then FrameContainer:Show() end
				if InspectedTable.lastInspectLevel == 80 and FatCooldowns:GetModule("Display").db.profile.LVL80 or not FatCooldowns:GetModule("Display").db.profile.LVL80 then FatCooldowns:ScheduleTimer(function() mod:FillInspectFrame() end, 0.3) else FrameContainer:Hide() end
				LastInspectTime = GetTime()
				FrameContainer.Name = InspectedTable.lastInspectName
			elseif FrameContainer.Name ~= InspectedTable.lastInspectName then
				LastInspectTime = 0
				FrameContainer.Name = InspectedTable.lastInspectName
				if InspectedTable.lastInspectLevel == 80 and FatCooldowns:GetModule("Display").db.profile.LVL80 or not FatCooldowns:GetModule("Display").db.profile.LVL80 then FatCooldowns:ScheduleTimer(function() mod:FillInspectFrame() end, 0.3) else FrameContainer:Hide() end
			end
			SetAchievementComparisonUnit(InspectFrame.unit)
		else
			LastInspectTime = 0
			if FrameContainer then
				if InspectedTable.lastInspectLevel == 80 and FatCooldowns:GetModule("Display").db.profile.LVL80 or not FatCooldowns:GetModule("Display").db.profile.LVL80 then
					mod:FillInspectFrame()
				else
					FrameContainer:Hide()
				end
			 end
		end
	else
		if FrameContainer then FrameContainer:Hide() end
	end
end

function OnTitleClick(name,role,gs)
    return function(self, button)
	    local name2 = name
		if role then name2 = name2..role end
		if gs then name2 = name2..gs end
		if IsShiftKeyDown() then
			if UnitInRaid("player") then
				if name2 ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(name2, RAID) end
			elseif GetNumPartyMembers() > 0 then
				if name2 ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(name2, PARTY) end
			else
				if name2 ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixPrint(name2) end
			end
		elseif IsAltKeyDown() then
			if name2 ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(name2, "WHISPER", nil, name) end
		end
	end
end

function FillInspectWindow(count, icon, text, link, onclickmessage, onclickmessage2)
	if icon then FrameContainerSimpleText2[count]:SetText("|T"..icon..":24:24:0:0:64:64:6:58:6:58|t"..text) else FrameContainerSimpleText2[count]:SetText(text) end
	if link then FrameContainerSimpleText2[count]:SetCallback("OnEnter", function(widget) GameTooltip:SetOwner(widget.frame, "ANCHOR_BOTTOMRIGHT") GameTooltip:SetHyperlink(link) GameTooltip:Show() end) end
	if link then FrameContainerSimpleText2[count]:SetCallback("OnLeave", function(widget) GameTooltip:Hide() end) end
	if onclickmessage then 
		FrameContainerSimpleText2[count]:SetCallback("OnClick", function(widget) 
			if IsShiftKeyDown() then
				if UnitInRaid("player") then
					 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(onclickmessage, RAID)
					if onclickmessage2 ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(onclickmessage2, RAID) end
				elseif GetNumPartyMembers() > 0 then
					 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(onclickmessage, PARTY)
					if onclickmessage2 ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(onclickmessage2, PARTY) end
				else
					FatCooldowns:GetModule("Display"):FCDPrefixPrint(onclickmessage)
					if onclickmessage2 ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixPrint(onclickmessage2) end
				end
			elseif IsAltKeyDown() then
				 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(onclickmessage, "WHISPER", nil, InspectedTable.lastInspectName)
				if onclickmessage2 ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(onclickmessage2, "WHISPER", nil, InspectedTable.lastInspectName) end
			end
		end) 
	end
end
function ResetInspectWindow(count)
	FrameContainerSimpleText2[count]:SetText('')
	FrameContainerSimpleText2[count]:SetCallback("OnEnter", function(widget) end)
	FrameContainerSimpleText2[count]:SetCallback("OnLeave", function(widget) end)
	FrameContainerSimpleText2[count]:SetCallback("OnClick", function(widget) end)
end


local LastTalentScan = {}
local LastFill = 0
function mod:FillInspectFrame()
	if InspectFrame.unit ~= nil and InspectedTable.lastInspectName ~= nil and UnitName(InspectFrame.unit) ~= InspectedTable.lastInspectName then return end
	if LastFill ~= nil and GetTime() - LastFill < 0.5 then return end
	LastFill = GetTime()
	for x = 1, 100 do ResetInspectWindow(x) end
	local ItemsInfo = {}
	if (UnitInRaid(InspectedTable.lastInspectName) or UnitInParty(InspectedTable.lastInspectName)) and LastTalentScan[InspectedTable.lastInspectName] == nil or (LastTalentScan[InspectedTable.lastInspectName] ~= nil and GetTime() - LastTalentScan[InspectedTable.lastInspectName] > 20) then 
		LGT:GetUnitTalents(InspectedTable.lastInspectName, true)
		LastTalentScan[InspectedTable.lastInspectName] = GetTime() 
	end
	
	local HadFoundRole = nil
	if UnitInRaid(InspectedTable.lastInspectName) or UnitInParty(InspectedTable.lastInspectName) then HadFoundRole = LGT:GetUnitTalentSpec(InspectedTable.lastInspectName) if HadFoundRole ~= nil then HadFoundRole = L[HadFoundRole] end end
	local HadFoundRole2 = ""
	if HadFoundRole then HadFoundRole2 = ": "..HadFoundRole end
	local IFGS = ""
	if InspectedTable.lastInspectGS then IFGS = " (GS: "..InspectedTable.lastInspectGS..")" end
	FrameContainer:SetTitle(FCDColorName3(InspectedTable.lastInspectClass, InspectedTable.lastInspectName)..HadFoundRole2..IFGS)
	FrameContainer.title:SetScript("OnMouseDown", OnTitleClick(InspectedTable.lastInspectName,HadFoundRole2,IFGS))

	local EditBoxTextToBe = {}
	local EditBoxTextToBeCount = 1

	FrameContainerAmLink:SetText('armory.warmane.com/character/'..InspectedTable.lastInspectName..'/'..GetRealmName())
	EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}

	local SummaryLine = (#EditBoxTextToBe + 1)
	EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
	EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}

	for i = 1, 18, 1 do
		Link = GetInventoryItemLink(InspectedTable.lastInspectUnit,i)
		if Link ~= nil and i ~= 4 then
			local itemName, itemLink2, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice = GetItemInfo(Link)
			local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(Link, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
			local SlotNumber = {
				["INVTYPE_HEAD"] = "Head",
				["INVTYPE_NECK"] = "Neck",
				["INVTYPE_SHOULDER"] = "Shoulder",
				["INVTYPE_ROBE"] = "Chest",
				["INVTYPE_CHEST"] = "Chest",
				["INVTYPE_WAIST"] = "Waist",
				["INVTYPE_LEGS"] = "Legs",
				["INVTYPE_FEET"] = "Feet",
				["INVTYPE_WRIST"] = "Wrists",
				["INVTYPE_HAND"] = "Hands",
				["INVTYPE_FINGER"] = "Finger",
				["INVTYPE_TRINKET"] = "Trinket",
				["INVTYPE_CLOAK"] = "Cloak",
				["INVTYPE_SHIELD"] = "Shield",
				["INVTYPE_WEAPON"] = "Weapon",
				["INVTYPE_2HWEAPON"] = "2h Weapon",
				["INVTYPE_WEAPONMAINHAND"] = "MH Weapon",
				["INVTYPE_WEAPONOFFHAND"] = "OH Weapon",
				["INVTYPE_HOLDABLE"] = "Off-Hand",
				["INVTYPE_RANGED"] = "Ranged",
				["INVTYPE_RANGEDRIGHT"] = "Ranged",
				["INVTYPE_RELIC"] = "Relic",
				["INVTYPE_THROWN"] = "Ranged", 
			}
			ItemsInfo[i] = ItemsInfo[i] or {}
			ItemsInfo[i].Link = Link
			ItemsInfo[i].itemLevel = itemLevel
			ItemsInfo[i].Type = itemSubType
			ItemsInfo[i].Slot = SlotNumber[itemEquipLoc]
			ItemsInfo[i].Id = Id
			ItemsInfo[i].Enchant = Enchant
			ItemsInfo[i].Icon = itemTexture
			ItemsInfo[i].Gem1, ItemsInfo[i].Gem1Link = GetItemGem(Link, 1)
			ItemsInfo[i].Gem2, ItemsInfo[i].Gem2Link = GetItemGem(Link, 2)
			ItemsInfo[i].Gem3, ItemsInfo[i].Gem3Link = GetItemGem(Link, 3)
			ItemsInfo[i].Gem4, ItemsInfo[i].Gem4Link = GetItemGem(Link, 4)
			ItemsInfo[i].Hit = 0
			ItemsInfo[i].Def = 0
		end
	end

	local FailedCount = 0
	local OrderTable = {}
	for index, itemtable in pairs(ItemsInfo) do
		if itemtable.Link ~= nil then
			local IsFailed = isSoulbound(nil,nil,itemtable.Link,nil,nil,nil,nil,nil,nil,nil,L["retrieving item information"])
			if IsFailed then 
				FailedCount = FailedCount + 1
				OrderTable[#OrderTable + 1] = {Text = L["Retrieving item information"]}
			end
		end
	end
	if FailedCount ~= 0 then
		EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Failed to Load Items: "..FailedCount.." --|r"}
		for b,n in pairs(OrderTable) do
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = n.Text}
		end
		EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
	end 

	if (FatCooldowns:GetModule("Display").db.profile.IFHit or FatCooldowns:GetModule("Display").db.profile.IFDef) and FatCooldowns.ExPac == 2 then
		local IFSpec = LGT:GetUnitTalentSpec(InspectedTable.lastInspectName)
		for x,c in pairs(ItemsInfo) do 
			local hitRatingMatch, HitAmount = isSoulbound(nil, nil, c.Link, nil, nil, nil, nil, nil, nil, nil, "hit rating", nil, true)
			local defRatingMatch, DefAmount = isSoulbound(nil, nil, c.Link, nil, nil, nil, nil, nil, nil, nil, "defense rating", nil, true)
			if FatCooldowns:GetModule("Display").db.profile.IFHit and hitRatingMatch and HitAmount and HitAmount > 0 then c.Hit = HitAmount end
			if FatCooldowns:GetModule("Display").db.profile.IFDef and defRatingMatch and DefAmount and DefAmount > 0 then c.Def = tonumber(DefAmount) end
		end
		local TotalHit, TotalDef = 0,0
		for x,c in pairs(ItemsInfo) do 
			if c.Hit ~= nil and c.Hit > 0 then TotalHit = TotalHit + c.Hit end
			if c.Def ~= nil and c.Def > 0 then TotalDef = TotalDef + c.Def end
		end
		local AmountMissingHit, AmountMissingDef, AmountNeededHit, AmountNeededDef = "Unkown",0,"Unkown",0
		if IFSpec ~= nil then
			local HitNeeded = FatCooldowns.WotLKHitCaps[AorHTable[InspectedTable.lastInspectFaction]][L[InspectedTable.lastInspectClass]][IFSpec] or 0
			AmountMissingHit = HitNeeded - TotalHit
			AmountNeededHit = HitNeeded
		else
			local BackupHitStat = {
		        ["Death Knight"] = 263,
		        ["Hunter"] = 263,
                ["Druid"] = 263,
		        ["Rogue"] = 263,
                ["Mage"] = 367,
                ["Paladin"] = 263,
                ["Priest"] = 289,
                ["Warlock"] = 368,
   		        ["Warrior"] = 263,
				["Shaman"] = 263,
		    }
		    if BackupHitStat[InspectedTable.lastInspectClass] ~= nil and TotalHit > 50 then
		    	AmountMissingHit = BackupHitStat[InspectedTable.lastInspectClass] - TotalHit
				AmountNeededHit = BackupHitStat[InspectedTable.lastInspectClass]
			end
		end
		local DefNeeded = 689
		local TankClasses = {
			["Death Knight"] = true,
            ["Paladin"] = true,
			["Warrior"] = true,
		}
		if TotalDef > 50 and TotalDef < DefNeeded and TankClasses[InspectedTable.lastInspectClass] ~= nil then
			AmountMissingDef = string.format("%.0f",((DefNeeded - TotalDef) / 4.92))
			AmountNeededDef = string.format("%.0f",(DefNeeded / 4.92))
		end
		EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Stat Caps --|r", OnClickMessage = "FCD Stat Caps "}
		if TotalHit ~= 0 then
			local MissingOrOver = "Missing"
			if AmountMissingHit ~= "Unkown" and AmountMissingHit ~= 0 then 
				if AmountMissingHit > 0 then
					MissingOrOver = "Missing"
				elseif AmountMissingHit < 0 then
					AmountMissingHit = math.abs(AmountMissingHit)
					MissingOrOver = "Over"
				end
			end 
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "Hit: "..TotalHit.." Total Needed: "..AmountNeededHit.." "..MissingOrOver..": "..AmountMissingHit, OnClickMessage = "FCD: Missing Stat Caps - Hit: "..TotalHit.." Total Needed: "..AmountNeededHit.." "..MissingOrOver..": "..AmountMissingHit} 
		end
		if AmountMissingDef ~= 0 then 
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "Def: "..string.format("%.0f",((TotalDef/4.92))).." Total Needed: "..AmountNeededDef.." Missing: "..AmountMissingDef, OnClickMessage = "FCD: Missing Stat Caps - Def: "..TotalDef.." Total Needed: "..AmountNeededDef.." Missing: "..AmountMissingDef} 
		end
		EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
	end

	if FatCooldowns:GetModule("Display").db.profile.IFGlyphs and FatCooldowns.ExPac == 2 and (UnitInRaid(InspectedTable.lastInspectName) or UnitInParty(InspectedTable.lastInspectName)) then
        local glyphs = {LGT:GetUnitGlyphs(InspectedTable.lastInspectName)}
        local MAglyphLinks = {}
        local MIglyphLinks = {}
        local hasGlyphs = false
        local ClassGlyphs = FatCooldowns.GlyphIDS[L[InspectedTable.lastInspectClass]]
        for i, glyph in ipairs(glyphs) do
            if glyph then
                hasGlyphs = true
                if ClassGlyphs["Minor"][tonumber(glyph)] then
                    MIglyphLinks[#MIglyphLinks + 1] = GetSpellLink(glyph)
                elseif ClassGlyphs["Major"][tonumber(glyph)] then
                    MAglyphLinks[#MAglyphLinks + 1] = GetSpellLink(glyph)
                end
            end
        end
        local MAglyphsMessage = "FCD Major Glyphs: " .. InspectedTable.lastInspectName .. " - "
        local MIglyphsMessage = "FCD Minor Glyphs: " .. InspectedTable.lastInspectName .. " - "
        if hasGlyphs then
            MAglyphsMessage = MAglyphsMessage .. table.concat(MAglyphLinks, ", ")
            MIglyphsMessage = MIglyphsMessage .. table.concat(MIglyphLinks, ", ")
            EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Major Glyphs --|r", OnClickMessage = MAglyphsMessage}
            for i, link in ipairs(MAglyphLinks) do
                EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = i .. ". " .. link, Link = link, OnClickMessage = "FCD Major Glyph: " .. InspectedTable.lastInspectName .. " - " .. link}
            end
            EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
            EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Minor Glyphs --|r", OnClickMessage = MIglyphsMessage}
            for i, link in ipairs(MIglyphLinks) do
                EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = i .. ". " .. link, Link = link, OnClickMessage = "FCD Minor Glyph: " .. InspectedTable.lastInspectName .. " - " .. link}
            end
        else
            EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Glyphs --|r", OnClickMessage = "FCD Glyphs: None/Unknown"}
            EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "None or Unknown"}
        end
        EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
    end

    if FatCooldowns:GetModule("Display").db.profile.IFCooking then
    	local CookingInfo = GetAchievementComparisonInfo(125)
    	if CookingInfo then 
    		EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Cooking 450 --|r", OnClickMessage = "FCD: "..InspectedTable.lastInspectName.." has Cooking 450"}
    		EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
    	end
    end

	if FatCooldowns:GetModule("Display").db.profile.IFRaidInfo then
		local N10, Bane, N25, LOD, TOGC, ULD = GetComparisonStatistic(4653), GetComparisonStatistic(4686), GetComparisonStatistic(4687), GetComparisonStatistic(4688), GetComparisonStatistic(4047), GetComparisonStatistic(2883)
		if N10 == "--" then N10 = "0" end
		if Bane == "--" then Bane = nil end
		if N25 == "--" then N25 = "0" end
		if LOD == "--" then LOD = nil end
		if TOGC == "--" then TOGC = "0" end
		if ULD == "--" then ULD = "0" end
    	EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Raid Info --|r", OnClickMessage = "FCD Raid Info "}
    	local H10 = Bane and "Bane: "..Bane or "ICC10: "..N10
    	local H25 = LOD and "LOD: "..LOD or "ICC25: "..N25
		EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = H10.." "..H25.." TOGC: "..TOGC.." ULD: "..ULD, OnClickMessage = "FCD: Raid Info for - "..InspectedTable.lastInspectName.." ("..H10.." "..H25.." TOGC: "..TOGC.." ULD: "..ULD..")"}
		EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
    end

	local UnFitTalents = 0
	local TempUST = LGT:GetUnspentTalentPoints(InspectedTable.lastInspectName)
	local UnSpentTalents = "0"
	if TempUST ~= nil and TempUST ~= 0 then UnSpentTalents = " - Unspent Talents: "..TempUST end
	if FatCooldowns:GetModule("Display").db.profile.IFTalents and FatCooldowns.ExPac == 2 and (UnitInRaid(InspectedTable.lastInspectName) or UnitInParty(InspectedTable.lastInspectName)) then
		local IFTalents = {
			["Druid"] = {
				[GetSpellInfo(48539)] = {Found = "Missing", Spec = {["Restoration"] = true}, ID = 48545, Rank = 3},
				[GetSpellInfo(50516)] = {Found = "Missing", Spec = {["Balance"] = true}, ID = 61384, Rank = 1},
				[GetSpellInfo(48488)] = {Found = "Missing", Spec = {["Balance"] = true}, ID = 48514, Rank = 2},

			},
			["Death Knight"] = {
				[GetSpellInfo(49027)] = {Found = "Has", Spec = {["Blood"] = true}, ID = 49543, Rank = 3},
				[GetSpellInfo(55610)] = {Found = "Missing", Spec = {["Blood"] = true, ["Frost"] = true}, ID = 55610, Rank = 1},

			},
			["Hunter"] = {
				[GetSpellInfo(19376)] = {Found = "Missing", Spec = {["Marksmanship"] = true}, ID = 63458, Rank = 3},

			},
			["Warlock"] = {
				[GetSpellInfo(18692)] = {Found = "Has", Spec = {["Demonology"] = true}, ID = 18692, Rank = 2},
				[GetSpellInfo(47236)] = {Found = "Has", Spec = {["Demonology"] = true}, ID = 47240, Rank = 5},

			},
			["Warrior"] = {
				[GetSpellInfo(12323)] = {Found = "Has", Spec = {["Fury"] = true}, ID = 12323, Rank = 1},

			},
			["Paladin"] = {
				[GetSpellInfo(20375)] = {Found = "Missing", Spec = {["Protection"] = true, ["Retribution"] = true}, ID = 20375, Rank = 1},
				[GetSpellInfo(9452)] = {Found = "Missing", Spec = {["Protection"] = true, ["Retribution"] = true}, ID = 26016, Rank = 2},
				[GetSpellInfo(53695)] = {Found = "Missing", Spec = {["Protection"] = true}, ID = 53696, Rank = 2},
				[GetSpellInfo(53527)] = {Found = "Missing", Spec = {["Protection"] = true, ["Holy"] = true}, ID = 53530, Rank = 2},
				[GetSpellInfo(31821)] = {Found = "Missing", Spec = {["Retribution"] = true, ["Holy"] = true}, ID = 31821, Rank = 1},

			},
		}
		local IFSpec = LGT:GetUnitTalentSpec(InspectedTable.lastInspectName)
		local OrderTable = {}
		if IFSpec ~= nil then
			if L[IFSpec] ~= nil then IFSpec = L[IFSpec] end
			if IFTalents[L[InspectedTable.lastInspectClass]] ~= nil and type(IFTalents[L[InspectedTable.lastInspectClass]]) == "table" then
				for index, itemtable in pairs(IFTalents[L[InspectedTable.lastInspectClass]]) do
					indexreal = index
					if IFSpec ~= nil and itemtable.Spec[IFSpec] ~= nil and itemtable.Spec[IFSpec] == true then 
						local ScanCurrentTalent = LGT:UnitHasTalent(InspectedTable.lastInspectName, indexreal)
						local Tname, Trank, Ticon = GetSpellInfo(itemtable.ID)
						local CFound = itemtable.Found
						if CFound == "Has" then CFound = "|cff1eff00"..CFound.."|r" elseif CFound == "Missing" then CFound = "|cffC41E3A"..CFound.."|r"  end
						if (ScanCurrentTalent ~= nil and ScanCurrentTalent >= 1 and itemtable.Found == "Has") or ((ScanCurrentTalent == nil or (ScanCurrentTalent ~= nil and itemtable.Rank > ScanCurrentTalent)) and itemtable.Found == "Missing") then
							OrderTable[#OrderTable + 1] = {Text = "|cff71d5ff|Hspell:"..itemtable.ID.."|h["..indexreal.."]|h|r".." ("..CFound..")", Link = "|cff71d5ff|Hspell:"..itemtable.ID.."|h["..indexreal.."]|h|r", Icon = Ticon, OnClickMessage = "FCD Talent: "..InspectedTable.lastInspectName.." - "..itemtable.Found..": ".."|cff71d5ff|Hspell:"..itemtable.ID.."|h["..indexreal.."]|h|r"}
							UnFitTalents = UnFitTalents + 1
						end
					end
				end
			end
		end
		if UnFitTalents ~= 0 then
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Talent Warning: "..UnFitTalents..UnSpentTalents.." --|r", OnClickMessage = "FCD Talent Warning: "..InspectedTable.lastInspectName.." - "..UnFitTalents..UnSpentTalents}
			for b,n in pairs(OrderTable) do
				EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = n.Text, Link = n.Link, Icon = n.Icon, OnClickMessage = n.OnClickMessage}
			end
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
		end 
	end

	local HasFishingPole = 0
	if FatCooldowns:GetModule("Display").db.profile.IFFishing then
		if ItemsInfo[16] ~= nil and ItemsInfo[16].Type ~= nil and ItemsInfo[16].Type == L["Fishing Poles"] then
			HasFishingPole = 1
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = ItemsInfo[16].Link.." ("..ItemsInfo[16].Type..")", Link = ItemsInfo[16].Link, Icon = ItemsInfo[16].Icon} 
		end
		if HasFishingPole ~= 0 then 
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Fishing Pole Equipped --|r", OnClickMessage = "FCD Warning: Fishing Pole"}
		end 
	end

	local LowGemmed = 0
	if FatCooldowns:GetModule("Display").db.profile.LowGem and FatCooldowns.ExPac == 2 then
		local OrderTable = {}
 		for index, itemtable in pairs(ItemsInfo) do
			local AlreadtAddedLowGem = false
			if AlreadtAddedLowGem == false and itemtable.Gem1Link ~= nil then
				local itemName, itemLink2, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice = GetItemInfo(itemtable.Gem1Link)
				if (itemQuality ~= 4 and itemSubType ~= "Meta") or itemLevel ~= 80 then
					OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..itemtable.Slot..")", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD Low Gem: "..InspectedTable.lastInspectName.." - "..itemtable.Link}
					AlreadtAddedLowGem = true
					LowGemmed = LowGemmed + 1
				end
			end
			if AlreadtAddedLowGem == false and itemtable.Gem2Link ~= nil then
				local itemName, itemLink2, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice = GetItemInfo(itemtable.Gem2Link)
				if (itemQuality ~= 4 and itemSubType ~= "Meta") or itemLevel ~= 80 then 
					OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..itemtable.Slot..")", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD Low Gem: "..InspectedTable.lastInspectName.." - "..itemtable.Link} 
					AlreadtAddedLowGem = true 
					LowGemmed = LowGemmed + 1 
				end
			end
			if AlreadtAddedLowGem == false and itemtable.Gem3Link ~= nil then 
				local itemName, itemLink2, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice = GetItemInfo(itemtable.Gem3Link)
				if (itemQuality ~= 4 and itemSubType ~= "Meta") or itemLevel ~= 80 then 
					OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..itemtable.Slot..")", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD Low Gem: "..InspectedTable.lastInspectName.." - "..itemtable.Link} 
					AlreadtAddedLowGem = true 
					LowGemmed = LowGemmed + 1 
				end
			end
			if AlreadtAddedLowGem == false and itemtable.Gem4Link ~= nil then 
				local itemName, itemLink2, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice = GetItemInfo(itemtable.Gem4Link)
				if (itemQuality ~= 4 and itemSubType ~= "Meta") or itemLevel ~= 80 then 
					OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..itemtable.Slot..")", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD Low Gem: "..InspectedTable.lastInspectName.." - "..itemtable.Link} 
					AlreadtAddedLowGem = true 
					LowGemmed = LowGemmed + 1 
				end
			end
		end
		if LowGemmed ~= 0 then 
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Low Lvl Gemmed Items: "..LowGemmed.." --|r", OnClickMessage = "FCD Low Gem: "..InspectedTable.lastInspectName.." - Count: "..LowGemmed}
			for b,n in pairs(OrderTable) do
				EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = n.Text, Link = n.Link, Icon = n.Icon, n.OnClickMessage}
			end
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "} 
		end 
	end

	local PVPCount = 0
	if FatCooldowns:GetModule("Display").db.profile.IFPVPItems and FatCooldowns.ExPac == 2 then
		local OrderTable = {}
		for index, itemtable in pairs(ItemsInfo) do
			if itemtable.Link ~= nil then
				local ItemID = select(3,strfind(itemtable.Link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
				local _, UnSetLink = GetItemInfo("item:"..ItemID)
				local IsPvP = isSoulbound(nil,nil,UnSetLink,nil,nil,nil,nil,nil,nil,nil, L["resilience"])
				if IsPvP then 
					PVPCount = PVPCount + 1
					OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..itemtable.Slot..")", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD PVP Item: "..InspectedTable.lastInspectName.." - "..itemtable.Link}
				end
			end
		end
		if PVPCount ~= 0 then
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- PVP Items: "..PVPCount.." --|r", OnClickMessage = "FCD PVP Items: "..InspectedTable.lastInspectName.." - Count: "..PVPCount}
			for b,n in pairs(OrderTable) do
				EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = n.Text, Link = n.Link, Icon = n.Icon, OnClickMessage = n.OnClickMessage}
			end
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
		end 
	end

	local UnGem = 0
	if FatCooldowns:GetModule("Display").db.profile.UnGem and FatCooldowns.ExPac == 2 then
		local OrderTable = {}
		local sockettext = {EMPTY_SOCKET_RED, EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_BLUE, EMPTY_SOCKET_PRISMATIC, EMPTY_SOCKET_META}
		for index, itemtable in pairs(ItemsInfo) do
			if itemtable.Link ~= nil then
				local AlreadyUnGem = false
				for GemIndex, GemVal in pairs(sockettext) do
					local IsGem = isSoulbound(nil,nil,itemtable.Link,nil,nil,nil,nil,nil,nil,nil,string.lower(GemVal), true)
					if IsGem and AlreadyUnGem == false then 
						UnGem = UnGem + 1
						OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..itemtable.Slot..")", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD UnGem Item: "..InspectedTable.lastInspectName.." - "..itemtable.Link}
						AlreadyUnGem = true
					end
				end
			end
		end
		if UnGem ~= 0 then 
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Un-Gemmed Items: "..UnGem.." --|r", OnClickMessage = "FCD UnGem Items: "..InspectedTable.lastInspectName.." - Count: "..UnGem} 
			for b,n in pairs(OrderTable) do
				EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = n.Text, Link = n.Link, Icon = n.Icon, n.OnClickMessage}
			end
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
		end
	end

	local UnEnchant = 0
	if FatCooldowns:GetModule("Display").db.profile.UnEnchant then
		local OrderTable = {}
		local CanEnchant = {
			[1] = true,
			[3] = true,
			[5] = true,
			[6] = true,
			[7] = true,
			[8] = true,
			[9] = true,
			[10] = true,
			[15] = true,
			[16] = true,
			[17] = true,
			[18] = true,
		}
		for index, itemtable in pairs(ItemsInfo) do
			if CanEnchant[index] ~= nil and itemtable.Link ~= nil then
				if index == 18 then
					if InspectedTable.lastInspectClass == L["Hunter"] and itemtable.Enchant == 0 then
						UnEnchant = UnEnchant + 1
						OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..itemtable.Type..")", Link = itemtable.Link, Icon = itemtable.Icon}
					end
				elseif index == 6 and InspectedTable.lastInspectLevel >= 70 then
					local sockettext = {EMPTY_SOCKET_RED, EMPTY_SOCKET_YELLOW, EMPTY_SOCKET_BLUE, EMPTY_SOCKET_PRISMATIC, EMPTY_SOCKET_META}
					local GemCount = 0
					local GemCount2 = 0
					local ItemID = select(3,strfind(itemtable.Link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
					local _, UnSetLink = GetItemInfo("item:"..ItemID)
					for GemIndex, GemItemTable in pairs(sockettext) do
						local IsGemCount = isSoulbound(nil,nil,UnSetLink,nil,nil,nil,nil,nil,nil,nil,string.lower(GemItemTable), true, true, true)
						GemCount = GemCount + IsGemCount
					end
					if itemtable.Gem1 ~= nil then GemCount2 = GemCount2 + 1 end 
					if itemtable.Gem2 ~= nil then GemCount2 = GemCount2 + 1 end 
					if itemtable.Gem3 ~= nil then GemCount2 = GemCount2 + 1 end 
					if itemtable.Gem4 ~= nil then GemCount2 = GemCount2 + 1 end 
					if GemCount2 == 0 or (GemCount == GemCount2) then
						UnEnchant = UnEnchant + 1
						OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." (Belt Buckle)", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD UnEnchanted Item: "..InspectedTable.lastInspectName.." - "..itemtable.Link}
					end
				elseif itemtable.Enchant == "0" and itemtable.Slot ~= L["Off-Hand"] then
					UnEnchant = UnEnchant + 1
					OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..itemtable.Slot..")", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD UnEnchanted Item: "..InspectedTable.lastInspectName.." - "..itemtable.Link}
				end
			end
		end
		if UnEnchant ~= 0 then 
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Un-Enchanted Items: "..UnEnchant.." --|r", OnClickMessage = "FCD UnEnchanted Items: "..InspectedTable.lastInspectName.." - Count: "..UnEnchant} 
			for b,n in pairs(OrderTable) do
				EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = n.Text, Link = n.Link, Icon = n.Icon, OnClickMessage = n.OnClickMessage}
			end
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
		end
	end

	local LowEnchant = 0
	if FatCooldowns:GetModule("Display").db.profile.LowEnchant then
		local OrderTable = {}
		local HighLvlEnchants = {
			["tank"] = {
				["2673"] = true, -- mongoose
				["3870"] = true, -- blood draining
				["3241"] = true, -- lifeward
				["3730"] = true, -- Swordguard Embroidery
				["3869"] = true, -- blade ward
				["3818"] = true, -- head 37 stam 20 def
				["3811"] = true, -- shoulder 20 dodge 15 def
				["3822"] = true, -- legs 55 stam 22 agl
				["3850"] = true, -- wrists 40 stam
				["3253"] = true, -- gloves 2% treat and 10 parry
				["3860"] = true, -- gloves 885 armor
				["3791"] = true, -- finger 30 stam
				["3294"] = true, -- back 225 armor
				["3852"] = true, -- shoulder pvp enchant 30 stam
				["3330"] = true, -- lw kit 18 stam
				["1075"] = true, -- feet 22 stam
				["3847"] = true, -- weapon stoneskin dk enchant
				["3878"] = true, -- head 45 stam eng
				["3849"] = true, -- shield titanium plating
			},
			["healer"] = {
				["3722"] = true, -- lightweave embroidery
				["3728"] = true, -- darkglow embroidery 
				["3820"] = true, -- head 30 sp 20 crit
				["3810"] = true, -- shoulder 24 sp 15 crit
				["1147"] = true, -- feet 18 spirit
				["2332"] = true, -- wrists 30 sp
				["3831"] = true, -- back 23 haste
				["3834"] = true, -- mh 64 sp
				["3246"] = true, -- gloves 28 sp
				["3721"] = true, -- legs 50 sp 20 crit
				["1119"] = true, -- wrists 16 int
				["3872"] = true, -- legs 50 sp 20 spirit
				["1128"] = true, -- shield 25 int
				["3854"] = true, -- staff 81 sp
				["3838"] = true, -- shoulder 70 sp 15 crit scribe 
                ["3719"] = true, -- legs 50 sp 20 spirit
                ["3758"] = true, -- wrists 76 sp lw
				["3840"] = true, -- finger 23 sp

			},
			["melee"] = {
				["3789"] = true, -- berserking
				["3225"] = true, -- executioner
				["3730"] = true, -- Swordguard Embroidery
				["3817"] = true, -- head 50 ap 20 crit
				["3808"] = true, -- shoulder 40 ap 15 crit
				["3823"] = true, ["3328"] = true, -- legs 75 ap 22 crit
				["3756"] = true, -- wrists 130 ap
				["3605"] = true, -- back 23 agl
				["3833"] = true, -- 1h 65 ap
				["3608"] = true, -- ranged 40 crit
				["3845"] = true, -- wrists 50 ap
				["1603"] = true, -- gloves 44 ap
				["1597"] = true, -- feet 32 ap
				["3826"] = true, -- feet 12 hit 13 crit
				["1099"] = true, -- back 22 agl
				["3839"] = true, -- finger 40 ap
				["3368"] = true, -- weapon fallen crusader dk enchant
				["3370"] = true, -- weapon razorice dk enchant
				["3247"] = true, -- weapon 140 vs Undead
				["3827"] = true, -- weapon 110 ap
				["3835"] = true, -- shoulder 120 ap 15 crit scribe
			},
			["caster"] = {
				["3722"] = true, -- lightweave embroidery
				["3728"] = true, -- darkglow embroidery 
				["3790"] = true, -- Black magic (caster only)
				["3820"] = true, -- head 30 sp 20 crit
				["3810"] = true, -- shoulder 24 sp 15 crit
				["3719"] = true, -- legs 50 sp 20 spirit
				["1147"] = true, -- feet 18 spirit
				["2332"] = true, -- wrists 30 sp
				["3831"] = true, -- back 23 haste
				["3834"] = true, -- mh 64 sp
				["3246"] = true, -- gloves 28 sp
				["3872"] = true, -- legs 50 sp 20 spirit
				["3826"] = true, -- feet 12 hit 13 crit
				["3840"] = true, -- finger 23 sp
				["3854"] = true, -- staff 81 sp
                ["3758"] = true, -- wrists 76 sp lw

			},
			["all"] = {
				["3832"] = true, -- 10 stats on Chest
				["3601"] = true, -- belt bomb
				["3606"] = true, -- rocket boots
				["3604"] = true, -- gloves eng 340 haste
				["3232"] = true, -- boots 15 stam movespeed
				["3859"] = true, -- back eng enchant fall speed and 23 agl
			}
		}
		local IFSpec = nil
		if UnitInRaid(InspectedTable.lastInspectName) or UnitInParty(InspectedTable.lastInspectName) then IFSpec = LGT:GetUnitRole(InspectedTable.lastInspectName) end
		for index, itemtable in pairs(ItemsInfo) do
			if IFSpec ~= nil then
				if itemtable.Link ~= nil and itemtable.Enchant ~= nil and itemtable.Enchant ~= "0" and not HighLvlEnchants[IFSpec][itemtable.Enchant] and not HighLvlEnchants["all"][itemtable.Enchant] then
					LowEnchant = LowEnchant + 1
					OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..itemtable.Slot..")", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD Low Lvl Enchant Item: "..InspectedTable.lastInspectName.." - "..itemtable.Link}
				end
			else
				if itemtable.Link ~= nil and itemtable.Enchant ~= nil and itemtable.Enchant ~= "0" and not HighLvlEnchants["tank"][itemtable.Enchant] and not HighLvlEnchants["caster"][itemtable.Enchant] and not HighLvlEnchants["all"][itemtable.Enchant] and not HighLvlEnchants["healer"][itemtable.Enchant] and not HighLvlEnchants["melee"][itemtable.Enchant] then
					LowEnchant = LowEnchant + 1
					OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..itemtable.Slot..")", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD Low Lvl Enchant Item: "..InspectedTable.lastInspectName.." - "..itemtable.Link}
				end
			end
		end
		if LowEnchant ~= 0 then 
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Low Lvl Enchants: "..LowEnchant.." --|r", OnClickMessage = "FCD Low Lvl Enchants: "..InspectedTable.lastInspectName.." - Count: "..LowEnchant} 
			for b,n in pairs(OrderTable) do
				EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = n.Text, Link = n.Link, Icon = n.Icon, OnClickMessage = n.OnClickMessage}
			end
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
		end
	end

	local UnFitStat = 0
	if FatCooldowns:GetModule("Display").db.profile.UnFitStats then
		local OrderTable = {}
		local ClassesUnFit = {
			["Death Knight"] = {
				["Spell Power"] = true,
				["Mana Per 5 Sec"] = true,
				["Intellect"] = true,
				["Spirit"] = true,
			},
			["Hunter"] = {
				["Spell Power"] = true,
				["Defense"] = true,
				["Parry"] = true,
				["Dodge"] = true,
				["Spirit"] = true,
				["Expertise"] = true,
			},
			["Mage"] = {
				["Defense"] = true,
				["Parry"] = true,
				["Dodge"] = true,
				["Strength"] = true,
				["Agility"] = true,
				["Expertise"] = true,
				["Armor Penetration"] = true,
				["Attack Power"] = true,
			},
			["Priest"] = {
				["Defense"] = true,
				["Parry"] = true,
				["Dodge"] = true,
				["Strength"] = true,
				["Agility"] = true,
				["Expertise"] = true,
				["Armor Penetration"] = true,
				["Attack Power"] = true,
			},
			["Rogue"] = {
				["Spell Power"] = true,
				["Defense"] = true,
				["Parry"] = true,
				["Dodge"] = true,
				["Mana Per 5 Sec"] = true,
				["Intellect"] = true,
				["Spirit"] = true,
			},
			["Shaman"] = {
				["Defense"] = true,
				["Parry"] = true,
				["Dodge"] = true,
			},
			["Warlock"] = {
				["Defense"] = true,
				["Parry"] = true,
				["Dodge"] = true,
				["Strength"] = true,
				["Agility"] = true,
				["Expertise"] = true,
				["Armor Penetration"] = true,
				["Attack Power"] = true,
			},
			["Warrior"] = {
				["Spell Power"] = true,
				["Mana Per 5 Sec"] = true,
				["Intellect"] = true,
				["Spirit"] = true,
			},
			["Druid"] = {
				["Mana Per 5 Sec"] = true,
			},
			["Paladin"] = {
				["Spirit"] = true,
			},
		}
		local UnFitRole = {
			["tank"] = {"Intellect", "Spirit"}, 
			["melee"] = {"Dodge", "Parry", "Intellect", "Spirit"}, 
			["range"] = {"Dodge", "Parry", "Spirit", "Expertise"}, 
			["caster"] = {"Strength", "Agility", "Expertise", "Dodge", "Parry", "Attack Power"},
			["healer"] = { "Strength", "Agility", "Hit", "Expertise", "Dodge", "Parry", "Attack Power"}
		}
		for index, itemtable in pairs(ItemsInfo) do
			if itemtable.Link ~= nil and ClassesUnFit[L[InspectedTable.lastInspectClass]] ~= nil then
				local AddItemIsFunFit = ""
				for stat, statenable in pairs(ClassesUnFit[L[InspectedTable.lastInspectClass]]) do
					local IsUnFit = isSoulbound(nil,nil,itemtable.Link,nil,nil,nil,nil,nil,nil,nil,string.lower(stat))
					if FatCooldowns.ExPac ~= 2 and stat == "Spirit" then 
					else
						if IsUnFit then AddItemIsFunFit = stat end
					end
				end
				local HadFoundRole = LGT:GetUnitRole(InspectedTable.lastInspectName)
				if InspectedTable.lastInspectClass ~= nil and InspectedTable.lastInspectClass == L["Hunter"] then HadFoundRole = "range" end
				if HadFoundRole and AddItemIsFunFit == "" then
					for stat, statenable in pairs(UnFitRole[HadFoundRole]) do
						local IsUnFit = isSoulbound(nil,nil,itemtable.Link,nil,nil,nil,nil,nil,nil,nil,string.lower(statenable))
						if FatCooldowns.ExPac ~= 2 and statenable == "Spirit" then 
						else
							if IsUnFit then AddItemIsFunFit = statenable end
						end
					end
				end
				if AddItemIsFunFit ~= "" then 
					UnFitStat = UnFitStat + 1
					OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..AddItemIsFunFit..")", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD UnFitStats: "..InspectedTable.lastInspectName.." - "..itemtable.Link}
				end
			end
		end
		if UnFitStat ~= 0 then 
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Un-Fit Stats Items: "..UnFitStat.." --|r", OnClickMessage = "FCD UnFitStats Items: "..InspectedTable.lastInspectName.." - Count: "..UnFitStat} 
			for b,n in pairs(OrderTable) do
				EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = n.Text, Link = n.Link, Icon = n.Icon, OnClickMessage = n.OnClickMessage}
			end
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "} 
		end
	end

	local UnitArmorType = 0
	if FatCooldowns:GetModule("Display").db.profile.ArmorType then
		local ClassesArmorType = {["Death Knight"] = "Cloth", ["Hunter"] = "Cloth", ["Paladin"] = "Cloth", ["Rogue"] = "Cloth", ["Warrior"] = "Cloth"}
		local OrderTable = {}
		if ClassesArmorType[InspectedTable.lastInspectClass] ~= nil then
			for index, itemtable in pairs(ItemsInfo) do
				if index ~= 15 and itemtable.Type == ClassesArmorType[InspectedTable.lastInspectClass] then
					OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..itemtable.Type..")", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD UnFitArmorType: "..InspectedTable.lastInspectName.." - "..itemtable.Link}
					UnitArmorType = UnitArmorType + 1
				end
			end
		end
		if UnitArmorType ~= 0 then 
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Un-Fit Armor Type Items: "..UnitArmorType.."-- |r", OnClickMessage = "FCD UnFitArmorType Items: "..InspectedTable.lastInspectName.." - Count: "..UnitArmorType} 
			for b,n in pairs(OrderTable) do
				EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = n.Text, Link = n.Link, Icon = n.Icon, OnClickMessage = n.OnClickMessage}
			end
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
		end
	end

	local TotalLow = 0
	if FatCooldowns:GetModule("Display").db.profile.LowLVLItems then
		local OrderTable = {}
		local TotalLows = {}
		for index, itemtable in pairs(ItemsInfo) do
			if itemtable.itemLevel ~= nil and itemtable.itemLevel <= FatCooldowns:GetModule("Display").db.profile.LowLVLItems then TotalLow = TotalLow + 1 TotalLows[itemtable.Link] = itemtable.Link end
		end
		if TotalLow > 0 then
			for index, itemtable in pairs(ItemsInfo) do
				if TotalLows[itemtable.Link] ~= nil then
					OrderTable[#OrderTable + 1] = {Text = itemtable.Link.." ("..itemtable.itemLevel..")", Link = itemtable.Link, Icon = itemtable.Icon, OnClickMessage = "FCD LowLvl Item: "..InspectedTable.lastInspectName.." - "..itemtable.Link}
				end
			end
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = "|cFFFFFF00-- Low LVL Items: "..TotalLow.." - Avg Ilvl: "..FatCooldowns:AvgIlvl(nil, InspectedTable.lastInspectUnit, ItemsInfo).." --|r", OnClickMessage = "FCD LowLvl Items: "..InspectedTable.lastInspectName.." - Count: "..TotalLow}
			for b,n in pairs(OrderTable) do
				EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = n.Text, Link = n.Link, Icon = n.Icon, OnClickMessage = n.OnClickMessage}
			end
			EditBoxTextToBe[#EditBoxTextToBe + 1] = {Text = " "}
		end
	end
	
	if (UnFitTalents and (UnFitTalents ~= 0 or UnFitTalents == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[1])) or
		(UnSpentTalents and (UnSpentTalents ~= "0" or UnSpentTalents == "0" and FatCooldowns:GetModule("Display").db.profile.PermaSum[2])) or
		(HasFishingPole and HasFishingPole ~= 0) or
		(LowGemmed and (LowGemmed ~= 0 or LowGemmed == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[3])) or
		(PVPCount and (PVPCount ~= 0 or PVPCount == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[4])) or
		(UnGem and (UnGem ~= 0 or UnGem == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[5])) or
		(UnEnchant and (UnEnchant ~= 0 or UnEnchant == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[6])) or
		(UnFitStat and (UnFitStat ~= 0 or UnFitStat == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[7])) or
		(UnitArmorType and (UnitArmorType ~= 0 or UnitArmorType == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[8])) or
		(TotalLow and (TotalLow ~= 0 or TotalLow == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[9])) then
		EditBoxTextToBe[SummaryLine] = {
			Text = "|cFFFFFF00-- Summary --|r"..
				(UnFitTalents and (UnFitTalents ~= 0 or UnFitTalents == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[1]) and "\nTalent Warning: "..UnFitTalents or "")..
				(UnSpentTalents and (UnSpentTalents ~= "0" or UnSpentTalents == "0" and FatCooldowns:GetModule("Display").db.profile.PermaSum[2]) and "\nUnspent Talents: "..UnSpentTalents or "")..
				(HasFishingPole and HasFishingPole ~= 0 and "\nFishingpole: "..HasFishingPole or "")..
				(LowGemmed and (LowGemmed ~= 0 or LowGemmed == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[3]) and "\nLow Lvl Gems: "..LowGemmed or "")..
				(PVPCount and (PVPCount ~= 0 or PVPCount == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[4]) and "\nPVP Items: "..PVPCount or "")..
				(UnGem and (UnGem ~= 0 or UnGem == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[5]) and "\nUnGemmed Items: "..UnGem or "")..
				(UnEnchant and (UnEnchant ~= 0 or UnEnchant == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[6]) and "\nUnEnchanted Items: "..UnEnchant or "")..
				(UnFitStat and (UnFitStat ~= 0 or UnFitStat == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[7]) and "\nUnFitStats: "..UnFitStat or "")..
				(UnitArmorType and (UnitArmorType ~= 0 or UnitArmorType == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[8]) and "\nUnFitArmorType: "..UnitArmorType or "")..
				(TotalLow and (TotalLow ~= 0 or TotalLow == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[9]) and "\nLowLvl Items: "..TotalLow or ""),
			OnClickMessage = InspectedTable.lastInspectName.." (GS: "..InspectedTable.lastInspectGS..") - "..
				(UnFitTalents and (UnFitTalents ~= 0 or UnFitTalents == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[1]) and "Talent Warning: "..UnFitTalents..", " or "")..
				(UnSpentTalents and (UnSpentTalents ~= "0" or UnSpentTalents == "0" and FatCooldowns:GetModule("Display").db.profile.PermaSum[2]) and "Unspent Talents: "..UnSpentTalents..", " or "")..
				(HasFishingPole and HasFishingPole ~= 0 and "Fishingpole: "..HasFishingPole..", " or "")..
				(LowGemmed and (LowGemmed ~= 0 or LowGemmed == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[3]) and "Low Lvl Gems: "..LowGemmed..", " or "")..
				(PVPCount and (PVPCount ~= 0 or PVPCount == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[4]) and "PVP Items: "..PVPCount..", " or "")..
				(UnGem and (UnGem ~= 0 or UnGem == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[5]) and "UnGemmed Items: "..UnGem..", " or "")..
				(UnEnchant and (UnEnchant ~= 0 or UnEnchant == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[6]) and "UnEnchanted Items: "..UnEnchant..", " or "")..
				(UnFitStat and (UnFitStat ~= 0 or UnFitStat == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[7]) and "UnFitStats: "..UnFitStat..", " or "")..
				(UnitArmorType and (UnitArmorType ~= 0 or UnitArmorType == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[8]) and "UnFitArmorType: "..UnitArmorType..", " or "")..
				(TotalLow and (TotalLow ~= 0 or TotalLow == 0 and FatCooldowns:GetModule("Display").db.profile.PermaSum[9]) and "LowLvl Items: "..TotalLow..", " or "")
		}
	end
	for c,v in pairs(EditBoxTextToBe) do
		FillInspectWindow(c, v.Icon, v.Text, v.Link, v.OnClickMessage, v.OnClickMessage2)
	end
	FrameContainerScroller:OnHeightSet(#EditBoxTextToBe + 100)
end

local AuConTimer = CreateFrame("Frame")
AuConTimer:RegisterEvent("ADDON_ACTION_FORBIDDEN")
AuConTimer:RegisterEvent("ADDON_ACTION_BLOCKED")
AuConTimer:SetScript("OnEvent", function() if AuConTimer.Timer then AuConTimer.Timer = nil end end)

local BlockList = {}
local function AuConUpdate(self)
	self:SetScript("OnUpdate", nil)
	local which = self:GetParent().which
	if FatCooldowns:GetModule("Display").db.profile.SPUP == nil or FatCooldowns:GetModule("Display").db.profile.SPUP == false then return end
	if FatCooldowns:GetModule("Display").db.profile.SPUPVal[which] == nil then FatCooldowns:GetModule("Display").db.profile.SPUPVal[which] = false end
	if which == "EQUIP_BIND" and FatCooldowns:GetModule("Display").db.profile.AGBind and FatCooldowns.AGUseItem == true and (BlockList[which] == nil or BlockList[which] > time()) then 
		AuConTimer.Timer = which
		local BTNType = "1"
		if self == StaticPopup1Button1 then BTNType = "1" elseif self == StaticPopup2Button1 then BTNType = "2" elseif self == StaticPopup3Button1 then BTNType = "3" end
		local button = _G["StaticPopup"..BTNType.."Button1"]
		if button and (button.IsShown or button:IsShown()) then
			if button.Click then
				button:Click("LeftButton")
				if FatCooldowns:GetModule("Display").db.profile.SPUPValPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Auto Confirmed: "..which) end
			end
			local BlockThis = BlockList[which]
			BlockList[which] = -1
			FatCooldowns:ScheduleTimer(function()
				if AuConTimer.Timer then
					AuConTimer.Timer = nil
					BlockList[which] = BlockThis
				end
			end, 0.2)
		end
		FatCooldowns.AGUseItem = false
	end
	if FatCooldowns:GetModule("Display").db.profile.SPUPVal[which] ~= nil and FatCooldowns:GetModule("Display").db.profile.SPUPVal[which] == true then
		AuConTimer.Timer = which
		local BTNType = "1"
		if self == StaticPopup1Button1 then BTNType = "1" elseif self == StaticPopup2Button1 then BTNType = "2" elseif self == StaticPopup3Button1 then BTNType = "3" end
		local button = _G["StaticPopup"..BTNType.."Button1"]
		if button and (button.IsShown or button:IsShown()) then
			local editbox = _G["StaticPopup"..BTNType.."EditBox"]
			if editbox and editbox.IsShown and editbox:IsShown() then editbox:SetText(DELETE_ITEM_CONFIRM_STRING) end
			if button.Click and ((not editbox) or (editbox and not editbox:IsShown()) or (editbox and editbox:IsShown() and editbox:GetText() == DELETE_ITEM_CONFIRM_STRING)) then
				button:Click("LeftButton")
				if FatCooldowns:GetModule("Display").db.profile.SPUPValPrint then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Auto Confirmed: "..which) end
			end
			local BlockThis = BlockList[which]
			BlockList[which] = -1
			FatCooldowns:ScheduleTimer(function()
				if AuConTimer.Timer then
					AuConTimer.Timer = nil
					BlockList[which] = BlockThis
				end
			end, 0.2)
		end
	end
	return
end
local function AuConShow(self) self:SetScript("OnUpdate", AuConUpdate) end
StaticPopup1Button1:HookScript("OnShow", AuConShow)
StaticPopup2Button1:HookScript("OnShow", AuConShow)
StaticPopup3Button1:HookScript("OnShow", AuConShow)

local EventReminderTimer
function mod:EventReminderSetTimer()
	local ERTimerSet = {[1] = 0, [2] = 60, [3] = 300, [4] = 900, [5] = 1800, [6] = 3600, [7] = 7200, [8] = 14400, [9] = 21600}
	self:CancelTimer(EventReminderTimer, true)
	if self.db.profile.ERTimer ~= 1 then EventReminderTimer = self:ScheduleRepeatingTimer(function() mod:EventReminder(true) end, ERTimerSet[self.db.profile.ERTimer]) end
end

function mod:EventReminder(FCDERTimer)
	local ERTimerSet = {[1] = 0, [2] = 60, [3] = 300, [4] = 900, [5] = 1800, [6] = 3600, [7] = 7200, [8] = 14400, [9] = 21600}
	if not EventReminderTimer and self.db.profile.ERTimer ~= 1 then EventReminderTimer = self:ScheduleRepeatingTimer(function() mod:EventReminder(true) end, ERTimerSet[self.db.profile.ERTimer]) end
	if self.db.profile.ERInRaid and UnitInRaid("player") then return end

	local weekday, month, day, year = CalendarGetDate()
	local NumTodayEvents = CalendarGetNumDayEvents(0, day)
	local Hours, Minutes = GetGameTime()
	for TodayEvents = 1, NumTodayEvents, 1 do
		local title, hour, minute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus, invitedBy, difficulty, inviteType, sequenceIndex, numSequenceDayss = CalendarGetDayEvent(0, day, TodayEvents)
		local CTime = (Hours * 60) + Minutes
		local ETime = (hour * 60) + minute

		if not FCDERTimer and
			((self.db.profile.FishingDerby and title == "Kalu'ak Fishing Derby" and ETime - CTime >= 0) or
			(self.db.profile.FSpectacular and title == "Fireworks Spectacular" and ETime - CTime >= 0) or
			(self.db.profile.STVExt and title == "Stranglethorn Fishing Extravaganza" and ETime - CTime >= 0)) and
			self.db.profile.PERT then

			for Index, ERTimeDo in pairs(ERTimerSet) do
				if Index ~= 1 and ((ETime - CTime) * 60) > ERTimeDo then
					self:ScheduleTimer(function() self:EventReminder(true) end, ((ETime - CTime) * 60) - ERTimeDo)
				end
			end
		end
	end
	for TodayEvents = 1, NumTodayEvents, 1 do
		local title, hour, minute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus, invitedBy, difficulty, inviteType, sequenceIndex, numSequenceDayss = CalendarGetDayEvent(0, day, TodayEvents)
		local CTime = (Hours * 60) + Minutes
		local ETime = (hour * 60) + minute

		if self.db.profile.ERTriggerDay and day == self.db.profile.ERTriggerDayToday.day and month == self.db.profile.ERTriggerDayToday.month and FCDERTimer == nil then return end

		if self.db.profile.FishingDerby and title == "Kalu'ak Fishing Derby" and ETime - CTime >= 0 then
			local Timer = FCDFormatTime2(ETime - CTime)
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts in " .. Timer .. ".", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts in " .. Timer .. ".")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.STVExt and title == "Stranglethorn Fishing Extravaganza" and ETime - CTime >= 0 then
			local Timer = FCDFormatTime2(ETime - CTime)
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts in " .. Timer .. ".", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts in " .. Timer .. ".")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.FSpectacular and title == "Fireworks Spectacular" and ETime - CTime >= 0 then
			local Timer = FCDFormatTime2(ETime - CTime)
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts in" .. Timer .. ".", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts in " .. Timer .. ".")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.PDay and title == "Pirates' Day" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Active.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Active.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end


		elseif self.db.profile.DarkMF[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.DarkMF[sequenceType] and title == "Darkmoon Faire" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.DarkMF[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.DarkMF[sequenceType] and title == "Darkmoon Faire" and sequenceType == "ONGOING" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Active.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Active.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.DarkMF[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.DarkMF[sequenceType] and title == "Darkmoon Faire" and sequenceType == "END" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Ending Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Ending Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.MFFestival[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.MFFestival[sequenceType] and title == "Midsummer Fire Festival" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.MFFestival[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.MFFestival[sequenceType] and title == "Midsummer Fire Festival" and sequenceType == "ONGOING" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Active.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Active.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.MFFestival[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.MFFestival[sequenceType] and title == "Midsummer Fire Festival" and sequenceType == "END" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Ending Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Ending Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.CWeek[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.CWeek[sequenceType] and title == "Children's Week" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.CWeek[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.CWeek[sequenceType] and title == "Children's Week" and sequenceType == "ONGOING" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Active.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Active.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.CWeek[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.CWeek[sequenceType] and title == "Children's Week" and sequenceType == "END" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Ending Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Ending Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.Ngarden[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.Ngarden[sequenceType] and title == "Noblegarden" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.Ngarden[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.Ngarden[sequenceType] and title == "Noblegarden" and sequenceType == "ONGOING" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Active.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Active.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.Ngarden[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.Ngarden[sequenceType] and title == "Noblegarden" and sequenceType == "END" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Ending Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Ending Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.LAir[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.LAir[sequenceType] and title == "Love is in the Air" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.LAir[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.LAir[sequenceType] and title == "Love is in the Air" and sequenceType == "ONGOING" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Active.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Active.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.LAir[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.LAir[sequenceType] and title == "Love is in the Air" and sequenceType == "END" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Ending Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Ending Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.LFestival[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.LFestival[sequenceType] and title == "Lunar Festival" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.LFestival[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.LFestival[sequenceType] and title == "Lunar Festival" and sequenceType == "ONGOING" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Active.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Active.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.LFestival[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.LFestival[sequenceType] and title == "Lunar Festival" and sequenceType == "END" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Ending Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Ending Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.WVeil[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.WVeil[sequenceType] and title == "Feast of Winter Veil" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.WVeil[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.WVeil[sequenceType] and title == "Feast of Winter Veil" and sequenceType == "ONGOING" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Active.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Active.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.WVeil[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.WVeil[sequenceType] and title == "Feast of Winter Veil" and sequenceType == "END" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Ending Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Ending Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.PBounty[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.PBounty[sequenceType] and title == "Pilgrim's Bounty" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.PBounty[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.PBounty[sequenceType] and title == "Pilgrim's Bounty" and sequenceType == "ONGOING" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Active.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Active.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.PBounty[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.PBounty[sequenceType] and title == "Pilgrim's Bounty" and sequenceType == "END" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Ending Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Ending Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.DDead[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.DDead[sequenceType] and title == "Day of the Dead" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.DDead[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.DDead[sequenceType] and title == "Day of the Dead" and sequenceType == "END" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Ending Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Ending Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.HEnd[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.HEnd[sequenceType] and title == "Hallow's End" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.HEnd[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.HEnd[sequenceType] and title == "Hallow's End" and sequenceType == "ONGOING" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Active.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Active.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.HEnd[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.HEnd[sequenceType] and title == "Hallow's End" and sequenceType == "END" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Ending Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Ending Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.HFestival[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.HFestival[sequenceType] and title == "Harvest Festival" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.HFestival[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.HFestival[sequenceType] and title == "Harvest Festival" and sequenceType == "ONGOING" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Active.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Active.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.HFestival[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.HFestival[sequenceType] and title == "Harvest Festival" and sequenceType == "END" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Ending Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Ending Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.Brewfest[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.Brewfest[sequenceType] and title == "Brewfest" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.Brewfest[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.Brewfest[sequenceType] and title == "Brewfest" and sequenceType == "ONGOING" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Active.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Active.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end
		elseif self.db.profile.Brewfest[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.Brewfest[sequenceType] and title == "Brewfest" and sequenceType == "END" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Is Ending Today.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Is Ending Today.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

			
		end
	end

	self.db.profile.ERTriggerDayToday.day = day
	self.db.profile.ERTriggerDayToday.month = month

	if FCDERTimer then return end
	local BackupMonth = 0
	if month == 1 or month == 3 or month == 5 or month == 7 or month == 8 or month == 10 or month == 12 then
		if day == 31 then
			BackupMonth = 1
			day = 1 
		else
			day = day + 1
		end
	elseif month == 2 then
		if day == 28 then
			BackupMonth = 1
			day = 1 
		else
			day = day + 1
		end
	else 
		if day == 30 then 
			BackupMonth = 1
			day = 1
		else
			day = day + 1
		end
	end
	NumTodayEvents = CalendarGetNumDayEvents(BackupMonth, day)

	for TodayEvents = 1, NumTodayEvents, 1 do
		local title, hour, minute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus, invitedBy, difficulty, inviteType, sequenceIndex, numSequenceDayss = CalendarGetDayEvent(BackupMonth, day, TodayEvents)

		if self.db.profile.DarkMF[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.DarkMF[sequenceType] and title == "Darkmoon Faire" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Tomorrow.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Tomorrow.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.MFFestival[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.MFFestival[sequenceType] and title == "Midsummer Fire Festival" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Tomorrow.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Tomorrow.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.CWeek[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.CWeek[sequenceType] and title == "Children's Week" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Tomorrow.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Tomorrow.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.Ngarden[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.Ngarden[sequenceType] and title == "Noblegarden" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Tomorrow.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Tomorrow.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.LAir[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.LAir[sequenceType] and title == "Love is in the Air" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Tomorrow.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Tomorrow.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.LFestival[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.LFestival[sequenceType] and title == "Lunar Festival" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Tomorrow.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Tomorrow.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.WVeil[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.WVeil[sequenceType] and title == "Feast of Winter Veil" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Tomorrow.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Tomorrow.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.PBounty[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.PBounty[sequenceType] and title == "Pilgrim's Bounty" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Tomorrow.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Tomorrow.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.DDead[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.DDead[sequenceType] and title == "Day of the Dead" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Tomorrow.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Tomorrow.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.HEnd[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.HEnd[sequenceType] and title == "Hallow's End" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Tomorrow.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Tomorrow.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.HFestival[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.HFestival[sequenceType] and title == "Harvest Festival" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Tomorrow.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Tomorrow.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		elseif self.db.profile.Brewfest[sequenceType] ~= nil and FCDERTimer == nil and self.db.profile.Brewfest[sequenceType] and title == "Brewfest" and sequenceType == "START" then
			RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFFFF" .. title .. "|r" .. " Starts Tomorrow.", ChatTypeInfo["RAID_WARNING"])
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD EventReminder: " .. title .. " Starts Tomorrow.")
			if self.db.profile.ERSound then PlaySoundFile("Sound\\Interface\\RaidWarning.wav") end

		end
	end
end

function mod:RemoveDBWBuff()
	if not UnitAffectingCombat("player") then
		if UnitBuff("player", "Agility of the Vrykul") then CancelUnitBuff("player", "Agility of the Vrykul") end
		if UnitBuff("player", "Aim of the Iron Dwarves") then CancelUnitBuff("player", "Aim of the Iron Dwarves") end
		if UnitBuff("player", "Power of the Taunka") then CancelUnitBuff("player", "Power of the Taunka") end
		if UnitBuff("player", "Precision of the Iron Dwarves") then CancelUnitBuff("player", "Precision of the Iron Dwarves") end
		if UnitBuff("player", "Strength of the Vrykul") then CancelUnitBuff("player", "Strength of the Vrykul") end
		if UnitBuff("player", "Strength of the Taunka") then CancelUnitBuff("player", "Strength of the Taunka") end
		if UnitBuff("player", "Speed of the Vrykul") then CancelUnitBuff("player", "Speed of the Vrykul") end
	end
end

			--				1		2			3		4		5		6			7			8			9
function mod:SyncCooldown(caster, spellId, cooldown, target, sender, confirmed, eventTypeone, whoringinfo, backlash) 
--	print(caster,GetSpellLink(spellId),spellId,cooldown,target,sender,confirmed, eventTypeone, whoringinfo) 
	if spellId == 47788 and CustomUnitClass(caster) ~= L["Priest"] then return end
	if sender == UnitName("player") and not confirmed then return end
	if not cooldown or cooldown == 0 then  
		if sender == caster then
			if FatCooldowns.syncIndex[spellId] and not self.db.profile.DisableSync then
				local info = FatCooldowns.syncCooldowns[FatCooldowns.syncIndex[spellId]]
				info.cooldowns[caster] = nil;
				info.count = info.count - 1;
			end
			self:StopCooldown(caster, spellId) 
			return
		else
			if not barGroups then return end			
			local _, zone2 = IsInInstance()
			for i = 1, 10, 1 do
				if i <= self.db.profile.frameCount and not self.db.profile.DisableSync and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and
				(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and
				(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
				(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
				(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena") and
				(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
				(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player")) and
				(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive()) then
					if self.db.profile.frames[i].spells[spellId] then 
						local bar = barGroups[i]:GetBar(caster .. "_" .. spellId)
						if bar and not bar.ready then
							local message = bar.spellId .. bar.caster .. math.ceil(bar.value);
							if bar.target then message = message .. bar.target end
							FatCooldowns:SendCommMessage(FatCooldowns.prefixS, message, "RAID") 
						end
						return
					end
				end
			end
		end
	end
	
	if FatCooldowns.syncIndex[spellId] and not self.db.profile.DisableSync then
		local info = FatCooldowns.syncCooldowns[FatCooldowns.syncIndex[spellId]]
		
		if info.cooldowns[caster] then
			if info.cooldowns[caster].timer < GetTime() or not sender or sender == caster then
				if cooldown >= 0 then
					if info.cooldowns[caster].timer > GetTime() and not target then
						info.cooldowns[caster] = {timer = GetTime() + cooldown, target = info.cooldowns[caster].target};
						self:StartCooldown(caster, spellId, cooldown, info.cooldowns[caster].target, nil, nil)
					else
						info.cooldowns[caster] = {timer = GetTime() + cooldown, target = target};
						self:StartCooldown(caster, spellId, cooldown, target, nil, nil)
					end
				else
					local newTimer = info.cooldowns[caster].timer - cooldown
					info.cooldowns[caster] = {timer = newTimer, target = info.cooldowns[caster].target};
					self:StartCooldown(caster, spellId, newTimer - GetTime(), info.cooldowns[caster].target, nil)
				end
			end
		else
			if cooldown < 0 then cooldown = 174 end -- Guardian Spirit procd and didnt see cd - set 174
			info.cooldowns[caster] = {timer = GetTime() + cooldown, target = target};
			self:StartCooldown(caster, spellId, cooldown,target, nil, nil)
			info.count = info.count + 1;
		end
	else 
		self:StartCooldown(caster, spellId, cooldown, target, false, sender)
	end 
end

local function ButtonClicksRCDtoR(self, button)
	local item = nil
	local spells = FatCooldowns.cooldowns["ITEMS"]
	if spells[self.spellId] then item = spells[self.spellId].itemlink end
	local spells = FatCooldowns.cooldowns["CONSUMABLES"]
	if spells[self.spellId] then item = spells[self.spellId].itemlink end
	if self.ready then
		local message = self.spellId .. self.caster .. 0;
		FatCooldowns:SendCommMessage(FatCooldowns.prefixS, message, (select(2, IsInInstance()) == "pvp" and "BATTLEGROUND") or (GetNumRaidMembers() > 0 and "RAID") or "PARTY")

		if 	self.label:GetText(text):find("Zone - ") or self.label:GetText(text):find("Dead - ") or self.label:GetText(text):find("Offline - ") then
			message = self.label:GetText(text) .. " has " .. (item or GetSpellLink(self.spellId)) .. " ready."
		else
			message = self.caster .. " has " .. (item or GetSpellLink(self.spellId)) .. " ready."
		end
		if GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then
			 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(message, (select(2, IsInInstance()) == "pvp" and "BATTLEGROUND") or (GetNumRaidMembers() > 0 and RAID) or PARTY)
		else 
			FatCooldowns:GetModule("Display"):FCDPrefixPrint(message)
		end
	else
		local message = self.spellId .. self.caster .. math.ceil(self.fill and self.maxValue - self.value or self.value);
		if self.target then message = message .. self.target end
		FatCooldowns:SendCommMessage(FatCooldowns.prefixS, message, (select(2, IsInInstance()) == "pvp" and "BATTLEGROUND") or (GetNumRaidMembers() > 0 and "RAID") or "PARTY")
		
		if self.label:GetText(text):find("Zone - ") or self.label:GetText(text):find("Dead - ") or self.label:GetText(text):find("Offline - ") then
			message = self.label:GetText(text) .. "'s " .. (item or GetSpellLink(self.spellId)) .. " will be ready in " 
		else
			message = self.caster .. "'s " .. (item or GetSpellLink(self.spellId)) .. " will be ready in " 
		end
		local failedorremoved = ""
		if self.spellId == 57934 or self.spellId == 34477 then
			if self:GetLabel():find(" F$") then failedorremoved = " FAILED"
			elseif self:GetLabel():find(" R$") then failedorremoved = " REMOVED"
			end
		end
		if self.target then
			if self.spellId == 31821 then
				local AuraTable = {
					["Devotion"] = "Devotion",
					["Retribution"] = "Retribution",
					["Concentration"] = "Concentration",
					["Shadow"] = "Shadow",
					["Frost"] = "Frost",
					["Fire"] = "Fire",
					["Crusader"] = "Crusader",
				}
				local AuraTable2 = {
					["Devotion"] = "Devo",
					["Retribution"] = "Ret",
					["Concentration"] = "Conc",
					["Shadow"] = "Sha",
					["Frost"] = "Fro",
					["Fire"] = "Fir",
					["Crusader"] = "Cru",
				}
				local AuraTable3 = {
					["Devotion"] = "|TInterface\\Icons\\spell_holy_devotionaura:24:24:0:0:64:64:6:58:6:58|t",
					["Retribution"] = "|TInterface\\Icons\\spell_holy_auraoflight:24:24:0:0:64:64:6:58:6:58|t",
					["Concentration"] = "|TInterface\\Icons\\spell_holy_mindsooth:24:24:0:0:64:64:6:58:6:58|t",
					["Shadow"] = "|TInterface\\Icons\\spell_shadow_sealofkings:24:24:0:0:64:64:6:58:6:58|t",
					["Frost"] = "|TInterface\\Icons\\spell_frost_wizardmark:24:24:0:0:64:64:6:58:6:58|t",
					["Fire"] = "|TInterface\\Icons\\spell_fire_sealoffire:24:24:0:0:64:64:6:58:6:58|t",
					["Crusader"] = "|TInterface\\Icons\\spell_holy_crusaderaura:24:24:0:0:64:64:6:58:6:58|t",
				}
				local RealAura = self.target
				for amindex, amvalue in pairs(AuraTable) do
					if amvalue == self.target then RealAura = amindex break end
				end
				for amindex, amvalue in pairs(AuraTable2) do
					if amvalue == self.target then RealAura = amindex break end
				end
				for amindex, amvalue in pairs(AuraTable3) do
					if amvalue == self.target then RealAura = amindex break end
				end
				message = self.caster .. "'s " .. (item or GetSpellLink(self.spellId)) .. " was used on " .. RealAura
			else
				message = self.caster .. "'s " .. (item or GetSpellLink(self.spellId)) .. " was used on " .. self.target .. failedorremoved 
			end
		end
		message = message .. " (CD " .. FCDFormatTime(self.fill and self.maxValue - self.value or self.value) .. ")"	
		if GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then
			 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(message, (select(2, IsInInstance()) == "pvp" and "BATTLEGROUND") or (GetNumRaidMembers() > 0 and RAID) or PARTY)
		else
			FatCooldowns:GetModule("Display"):FCDPrefixPrint(message)
		end
	end
end

local function ButtonClicksRCDtoW(self, button)
	local item = nil
	local spells = FatCooldowns.cooldowns["ITEMS"]
	if spells[self.spellId] then item = spells[self.spellId].itemlink end
	local spells = FatCooldowns.cooldowns["CONSUMABLES"]
	if spells[self.spellId] then item = spells[self.spellId].itemlink end
	if self.ready then
		local message = self.spellId .. self.caster .. 0;
		FatCooldowns:SendCommMessage(FatCooldowns.prefixS, message, (select(2, IsInInstance()) == "pvp" and "BATTLEGROUND") or (GetNumRaidMembers() > 0 and "RAID") or "PARTY")
		
		if 	self.label:GetText(text):find("Zone - ") or self.label:GetText(text):find("Dead - ") or self.label:GetText(text):find("Offline - ") then
			message = self.label:GetText(text) .. " has " .. (item or GetSpellLink(self.spellId)) .. " ready."
		else
			message = self.caster .. " has " .. (item or GetSpellLink(self.spellId)) .. " ready."
		end	
		 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(message, "WHISPER", nil, self.caster)
	else 
		local message = self.spellId .. self.caster .. math.ceil(self.fill and self.maxValue - self.value or self.value)
		if self.target then message = message .. self.target end
		FatCooldowns:SendCommMessage(FatCooldowns.prefixS, message, (select(2, IsInInstance()) == "pvp" and "BATTLEGROUND") or (GetNumRaidMembers() > 0 and "RAID") or "PARTY")
	
		if 	self.label:GetText(text):find("Zone - ") or self.label:GetText(text):find("Dead - ") or self.label:GetText(text):find("Offline - ") then
			message = self.label:GetText(text) .. "'s " .. (item or GetSpellLink(self.spellId)) .. " will be ready in " 
		else
			message = self.caster .. "'s " .. (item or GetSpellLink(self.spellId)) .. " will be ready in " 
		end
		local failedorremoved = ""
		if self.spellId == 57934 or  self.spellId == 34477 then
			if self:GetLabel():find(" F$") then failedorremoved = " FAILED"
			elseif self:GetLabel():find(" R$") then failedorremoved = " REMOVED"
			end
		end
		if self.target then
			if self.spellId == 31821 then
				local AuraTable = {
					["Devotion"] = "Devotion",
					["Retribution"] = "Retribution",
					["Concentration"] = "Concentration",
					["Shadow"] = "Shadow",
					["Frost"] = "Frost",
					["Fire"] = "Fire",
					["Crusader"] = "Crusader",
				}
				local AuraTable2 = {
					["Devotion"] = "Devo",
					["Retribution"] = "Ret",
					["Concentration"] = "Conc",
					["Shadow"] = "Sha",
					["Frost"] = "Fro",
					["Fire"] = "Fir",
					["Crusader"] = "Cru",
				}
				local AuraTable3 = {
					["Devotion"] = "|TInterface\\Icons\\spell_holy_devotionaura:24:24:0:0:64:64:6:58:6:58|t",
					["Retribution"] = "|TInterface\\Icons\\spell_holy_auraoflight:24:24:0:0:64:64:6:58:6:58|t",
					["Concentration"] = "|TInterface\\Icons\\spell_holy_mindsooth:24:24:0:0:64:64:6:58:6:58|t",
					["Shadow"] = "|TInterface\\Icons\\spell_shadow_sealofkings:24:24:0:0:64:64:6:58:6:58|t",
					["Frost"] = "|TInterface\\Icons\\spell_frost_wizardmark:24:24:0:0:64:64:6:58:6:58|t",
					["Fire"] = "|TInterface\\Icons\\spell_fire_sealoffire:24:24:0:0:64:64:6:58:6:58|t",
					["Crusader"] = "|TInterface\\Icons\\spell_holy_crusaderaura:24:24:0:0:64:64:6:58:6:58|t",
				}
				local RealAura = self.target
				for amindex, amvalue in pairs(AuraTable) do
					if amvalue == self.target then RealAura = amindex break end
				end
				for amindex, amvalue in pairs(AuraTable2) do
					if amvalue == self.target then RealAura = amindex break end
				end
				for amindex, amvalue in pairs(AuraTable3) do
					if amvalue == self.target then RealAura = amindex break end
				end
				message = self.caster .. "'s " .. (item or GetSpellLink(self.spellId)) .. " was used on " .. RealAura
			else
				message = self.caster .. "'s " .. (item or GetSpellLink(self.spellId)) .. " was used on " .. self.target .. failedorremoved
			end
		end
		message = message .. " (CD " .. FCDFormatTime(self.fill and self.maxValue - self.value or self.value) .. ")"
		 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(message, "WHISPER", nil, self.caster)
	end
end

local function ButtonClicksPCDUOn(self, button)
	local item = nil
	local spells = FatCooldowns.cooldowns["ITEMS"]
	if spells[self.spellId] then item = spells[self.spellId].itemlink end
	local spells = FatCooldowns.cooldowns["CONSUMABLES"]
	if spells[self.spellId] then item = spells[self.spellId].itemlink end
	local temptarget = self.target
	if temptarget == nil or self.target == self.caster then temptarget = "No Target/Self"
	elseif temptarget ~= nil then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD: "..self.caster.." previously used "..(item or GetSpellLink(self.spellId)).." on "..temptarget, RAID) end
end

local function ButtonClicksLNRCD(self, button)
	local item = nil
	local spells = FatCooldowns.cooldowns["ITEMS"]
	if spells[self.spellId] then item = spells[self.spellId].itemlink end
	local spells = FatCooldowns.cooldowns["CONSUMABLES"]
	if spells[self.spellId] then item = spells[self.spellId].itemlink end
	local notready = false
	local message = nil
	local bars = self.ownerGroup:GetBars()
	if type(bars) == "table" then
		for key, bar in pairs(bars) do
			if bar.spellId == self.spellId and not bar.ready then
				notready = true
				if message == nil then message = bar.caster.." ("..FCDFormatTime(bar.fill and bar.maxValue - bar.value or bar.value)..")"
				elseif message ~= nil then message = message..", "..bar.caster.." ("..FCDFormatTime(bar.fill and bar.maxValue - bar.value or bar.value)..")"
				end 
			end 
		end
		if notready then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD: "..message.." until "..(item or GetSpellLink(self.spellId)).." is ready!", RAID) notready = false end
	end
end

local function ButtonClicksLRCD(self, button)
	local item = nil
	local spells = FatCooldowns.cooldowns["ITEMS"]
	if spells[self.spellId] then item = spells[self.spellId].itemlink end
	local spells = FatCooldowns.cooldowns["CONSUMABLES"]
	if spells[self.spellId] then item = spells[self.spellId].itemlink end
	local isready = false
	local message = nil
	local bars = self.ownerGroup:GetBars()
	if type(bars) == "table" then
		for key, bar in pairs(bars) do
			if bar.spellId == self.spellId and bar.ready then
				isready = true
				if message == nil then message = bar.caster 
				elseif message ~= nil then message = message..", "..bar.caster 
				end 
			end 
		end
		if isready then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD: "..message.." has "..(item or GetSpellLink(self.spellId)).." ready!", RAID) isready = false end
	end
end

local function ButtonClicksRCD(self, button)
	local item = nil
	local spells = FatCooldowns.cooldowns["ITEMS"]
	if spells[self.spellId] then item = spells[self.spellId].itemlink end
	local spells = FatCooldowns.cooldowns["CONSUMABLES"]
	if spells[self.spellId] then item = spells[self.spellId].itemlink end
	FatCooldowns:GetModule("Display"):StopCooldown(self.caster, self.spellId, "True")
end

local function ButtonClicksLoot(self, button)
	local itemName, itemLink = GetItemInfo(self.ItemLinkLoot) 
	if UnitInRaid("player") then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("FCD: "..itemLink.." time remaning: "..FCDFormatTime3(self.fill and self.maxValue - self.value or self.value), RAID) end
end

local function buttonClickDo(self, button, ValueClick)
	if ValueClick == 1 then
	elseif ValueClick == 2 then if self.spellId == 99038 then ButtonClicksLoot(self, button) else ButtonClicksRCDtoR(self, button) end
	elseif ValueClick == 3 then if self.spellId == 99038 then ButtonClicksLoot(self, button) else ButtonClicksRCDtoW(self, button) end
	elseif ValueClick == 4 then if self.spellId == 99038 then ButtonClicksLoot(self, button) else ButtonClicksLRCD(self, button) end
	elseif ValueClick == 5 then if self.spellId == 99038 then ButtonClicksLoot(self, button) else ButtonClicksLNRCD(self, button) end
	elseif ValueClick == 6 then if self.spellId == 99038 then ButtonClicksLoot(self, button) else ButtonClicksPCDUOn(self, button) end
	elseif ValueClick == 7 then ButtonClicksRCD(self, button)
	end
end

local function buttonClick(self, button)
	if self.spellId == 69037 or self.spellId == 70337 or self.spellId == 72143 or self.spellId == 69037 then return end
	if button == "LeftButton" then
		if not IsShiftKeyDown() and not IsAltKeyDown() then buttonClickDo(self, button, FatCooldowns:GetModule("Display").db.profile.LClick)
		elseif IsShiftKeyDown() then buttonClickDo(self, button, FatCooldowns:GetModule("Display").db.profile.SLClick)
		elseif IsAltKeyDown() then buttonClickDo(self, button, FatCooldowns:GetModule("Display").db.profile.ALClick)
		end
	elseif button == "RightButton" then
	 	if not IsShiftKeyDown() and not IsAltKeyDown() then buttonClickDo(self, button, FatCooldowns:GetModule("Display").db.profile.RClick)
		elseif IsShiftKeyDown() then buttonClickDo(self, button, FatCooldowns:GetModule("Display").db.profile.SRClick)
		elseif IsAltKeyDown() then buttonClickDo(self, button, FatCooldowns:GetModule("Display").db.profile.ARClick)
		end
	elseif button == "MiddleButton" then
		if not IsShiftKeyDown() and not IsAltKeyDown() then buttonClickDo(self, button, FatCooldowns:GetModule("Display").db.profile.MClick)
		elseif IsShiftKeyDown() then buttonClickDo(self, button, FatCooldowns:GetModule("Display").db.profile.SMClick)
		elseif IsAltKeyDown() then buttonClickDo(self, button, FatCooldowns:GetModule("Display").db.profile.AMClick)
		end
	end
end

function FCDFormatTime(time) if time == nil then return end return string.format("%02i:%02i", time/60%60, time%60) end
function FCDFormatTime2(time) if time == nil then return end return string.format("%i Hours and %i Minutes", time/60%60, time%60) end
function FCDFormatTime3(time)
	if time == nil then
		return 
	else
		local hours = math.floor(time / 3600)
		local minutes = math.floor((time % 3600) / 60)
		local seconds = math.floor(time % 60)
		if hours > 0 then 
			return string.format("%i Hours and %i Minutes", hours, minutes)
		else
			return string.format("%i Minutes", minutes)
		end
	end
end
						
function mod:ClickableChange()
	if not barGroups then return end
	self = mod
	for i = 1, 10, 1 do
		local bars = barGroups[i]:GetBars()
		if type(bars) == "table" then
			for k, bar in pairs(bars) do
				bar:EnableMouse(not self.db.profile.unclickable)
			end
		end
	end
end


function mod:backbarscheckercdtimer(backup1,backup2, backup3, backup4, backup5) self:ScheduleTimer(function() mod:backbarscheckercd(backup1, backup2, backup3, backup4, backup5) end, 0.5) end

function mod:backbarscheckercd(senderbackup, spellnamebackup, cooldownbackup, spellIdbackup, targetbackup)
if targetbackup == "" then targetbackup = nil end
if targetbackup ~= nil and targetbackup:find("[%s]+") and self.db.profile.AbbrevName then if CustomUnitIsPlayer(targetbackup) then else targetbackup = abbrev(targetbackup) end end
if not barGroups then return end 
	local _,zone2=IsInInstance()
	for i = 1, 10, 1 do 
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and
			(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and
			(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena") and
			(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
			(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player")) and
			(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive()) then
			if (self.db.profile.frames[i].EnemyFCDCaster and not IsEnemyFCDCaster(senderbackup)) or
				(self.db.profile.frames[i].FriendlyCaster and not IsFriendlyFCDCaster(senderbackup)) or
				(self.db.profile.frames[i].hideSelf and senderbackup == playerName) or (self.db.profile.frames[i].onlySelf and senderbackup ~= playerName) then
			else
				if self.db.profile.frames[i].spells[spellIdbackup] then
					--print(senderbackup, spellnamebackup, cooldownbackup, spellIdbackup, targetbackup)
					local bar = barGroups[i]:GetBar(senderbackup .. "_" .. spellIdbackup)
					if bar == nil then --or bar.ready then
						if targetbackup and targetbackup ~= senderbackup then 
							local maxl = self.db.profile.frames[i].maxTextLength;
							local maxsenderl = self.db.profile.frames[i].maxTextLength;
							local leftbr = " "..self.db.profile.SymbolsStart
							local rightbr = self.db.profile.SymbolsEnd
							if self.db.profile.frames[i].hidetarget then maxl = 0 end
							if maxl == 0 then leftbr = "" rightbr = "" end
							local backuplabel = (self.db.profile.ColorCaster and FCDColorName2(string.sub(senderbackup,1,maxsenderl), senderbackup) or string.sub(senderbackup,1,maxsenderl)) .. ((self.db.profile.ReTarget and "") or (spellIdbackup == 70337 and targetbackup) or  (leftbr .. (self.db.profile.ColorTarget and FCDColorName2(string.sub(targetbackup,1,maxsenderl), targetbackup) or string.sub(targetbackup,1,maxl)) ..rightbr))
							if self.db.profile.frames[i].HideLabel then backuplabel = "" end
							if self.db.profile.frames[i].SpellNameLabel then backuplabel = GetSpellInfo(spellIdbackup) end
							bar = barGroups[i]:NewTimerBar((senderbackup .. "_" .. spellIdbackup), backuplabel, cooldownbackup, cooldownbackup, spellIdbackup)
						else
							local maxsenderl = self.db.profile.frames[i].maxTextLength;
							local backuplabel = self.db.profile.ColorCaster and FCDColorName2(string.sub(senderbackup,1,maxsenderl), senderbackup) or string.sub(senderbackup,1,maxsenderl)
							if self.db.profile.frames[i].HideLabel then backuplabel = "" end
							if self.db.profile.frames[i].SpellNameLabel then backuplabel = GetSpellInfo(spellIdbackup) end

							bar = barGroups[i]:NewTimerBar((senderbackup .. "_" .. spellIdbackup), backuplabel, cooldownbackup, cooldownbackup, spellIdbackup)
						end
							bar:SetScript("OnMouseUp", buttonClick)
							bar:EnableMouse(not self.db.profile.unclickable)
												
						bar.target = targetbackup
						if UnitInRaid("player") or GetNumPartyMembers() >= 1 then bar.permanent = self.db.profile.frames[i].permanent and not test; end
						bar.caster  = senderbackup
						if self.db.profile.ColorCaster then bar.castercolor = FCDColorName2(string.sub(senderbackup,1,self.db.profile.frames[i].maxTextLength), senderbackup) end
						bar.targetcolor = nil
						if targetbackup ~= nil and self.db.profile.ColorTarget then bar.targetcolor = FCDColorName2(string.sub(targetbackup,1,self.db.profile.frames[i].maxTextLength), targetbackup) end
						bar.spellId = spellIdbackup
						if self.db.profile.removeglow then bar.spark:SetTexture(nil) end
						if self.db.profile.FillBackGround then bar.FillBackground = true elseif not self.db.profile.FillBackGround then bar.FillBackground = false end
						if self.db.profile.FillBars then bar.fill = true elseif not self.db.profile.FillBars then bar.fill = false end
						if self.db.profile.ReTarget and bar:GetLabel2() == nil then
							if targetbackup ~= senderbackup then
								bar:SetLabel2(bar.targetcolor or bar.target)
							else
								bar:SetLabel2(nil)
							end
							if self.db.profile.frames[i].fontsize == nil or self.db.profile.frames[i].fontsize == 0 then self.db.profile.frames[i].fontsize = 10 end
							barGroups[i]:SetFont(Media:Fetch("font", self.db.profile.fontFace), self.db.profile.frames[i].fontsize * 0.8, self.db.profile.outline, true)
						end
						if self.db.profile.iconzoom then bar.icon:SetTexCoord(0.08,0.92,0.08,0.92) else bar.icon:SetTexCoord(0,1,0,1) end
						bar.time = cooldownbackup
						bar:SetTexture(Media:Fetch("statusbar", self.db.profile.texture))
					elseif bar.ready then
						bar:SetTimer(cooldownbackup, cooldownbackup, true)
						bar.time = cooldownbackup
						if targetbackup and targetbackup ~= senderbackup then 
							local maxl = self.db.profile.frames[i].maxTextLength;
							local maxsenderbackupl = self.db.profile.frames[i].maxTextLength;
							local leftbr = " "..self.db.profile.SymbolsStart
							local rightbr = self.db.profile.SymbolsEnd
							if self.db.profile.frames[i].hidetarget then maxl = 0 end
							if maxl == 0 then leftbr = "" rightbr = "" end
							if spellIdbackup == 69037 then maxl = 99 end
							local labelcooldown = (self.db.profile.ColorCaster and FCDColorName2(string.sub(senderbackup,1,maxsenderbackupl), senderbackup) or string.sub(senderbackup,1,maxsenderbackupl)) .. (self.db.profile.ReTarget and "" or (leftbr .. (self.db.profile.ColorTarget and FCDColorName2(string.sub(targetbackup,1,maxsenderl), targetbackup) or string.sub(targetbackup,1,maxl)) ..rightbr))
							if self.db.profile.frames[i].HideLabel then labelcooldown = "" end
							if self.db.profile.frames[i].SpellNameLabel then backuplabel = GetSpellInfo(spellIdbackup) end

							bar.target = targetbackup
							bar.targetcolor = nil
							if targetbackup ~= nil and self.db.profile.ColorTarget then bar.targetcolor = FCDColorName2(string.sub(targetbackup,1,self.db.profile.frames[i].maxTextLength), targetbackup) end

							if self.db.profile.ReTarget then
							if targetbackup ~= senderbackup then
								bar:SetLabel2(bar.targetcolor or bar.target)
							else
								bar:SetLabel2(nil)
							end
							if self.db.profile.frames[i].fontsize == nil or self.db.profile.frames[i].fontsize == 0 then self.db.profile.frames[i].fontsize = 10 end
							barGroups[i]:SetFont(Media:Fetch("font", self.db.profile.fontFace), self.db.profile.frames[i].fontsize * 0.8, self.db.profile.outline, true) end
							bar:SetLabel(labelcooldown)
						else 
							local maxl = self.db.profile.frames[i].maxTextLength;
							local maxsenderbackupl = self.db.profile.frames[i].maxTextLength;
							if spellIdbackup == 69037 then maxl = 99 end
							local labelcooldown = self.db.profile.ColorCaster and FCDColorName2(string.sub(senderbackup,1,maxsenderbackupl), senderbackup) or string.sub(senderbackup,1,maxsenderbackupl)
							if self.db.profile.frames[i].HideLabel then labelcooldown = "" end
							if self.db.profile.frames[i].SpellNameLabel then backuplabel = GetSpellInfo(spellIdbackup) end
								
							bar:SetLabel(labelcooldown)
						end
					end
					local _, c = CustomUnitClass(senderbackup)
					if not c then
						for k, v in pairs(FatCooldowns.cooldowns) do
							for k2, v2 in pairs(v) do
								if v2.id == spellIdbackup then
									c = k
								end
							end
						end
					end
					if self.db.profile.frames[i].BarBackground then
						bar.bgtexture:Hide() bar.texture:Hide() bar.timerLabel:Hide() barGroups[i]:SetWidth(1) self.db.profile.frames[i].anchor = false barGroups[i]:HideAnchor()
					else
						bar.bgtexture:Show() bar.texture:Show() bar.timerLabel:Show() barGroups[i]:SetWidth(self.db.profile.frames[i].width) 
					end
					if RC:GetRange(bar.caster) ~= nil and RC:GetRange(bar.caster) >= 80 then
						if self.db.profile.frames[i].opacity == nil then self.db.profile.frames[i].opacity = 100 end
						bar.barop = self.db.profile.frames[i].opacity / 100 
						bar:SetAlpha(self.db.profile.frames[i].opacity / 100)
					else
						bar.barop = self.db.profile.frames[i].alpha / 100
					end	
					if self.db.profile.CustomNameColor then
						if bar:GetLabel() ~= nil then bar:SetLabel(self:FCDColorText(bar:GetLabel(), self.db.profile.CustomNameColorPicked.r, self.db.profile.CustomNameColorPicked.g, self.db.profile.CustomNameColorPicked.b)) end
						if bar:GetLabel2() ~= nil then bar:SetLabel(self:FCDColorText(bar:GetLabel(), self.db.profile.CustomNameColorPicked.r, self.db.profile.CustomNameColorPicked.g, self.db.profile.CustomNameColorPicked.b)) end
					end
					local color = RAID_CLASS_COLORS[c]
					if type(color) == "table" and not self.db.profile.CustomBarColor then
						bar:SetColorAt(1.00, color.r, color.g, color.b, 1)
						bar:SetColorAt(0.00, color.r, color.g, color.b, 1)
					elseif self.db.profile.CustomBarColor then
						bar:SetColorAt(1.00, self.db.profile.CustomBarColorPicked.r, self.db.profile.CustomBarColorPicked.g, self.db.profile.CustomBarColorPicked.b, self.db.profile.CustomBarColorPicked.a)
						bar:SetColorAt(0.00, self.db.profile.CustomBarColorPicked.r, self.db.profile.CustomBarColorPicked.g, self.db.profile.CustomBarColorPicked.b, self.db.profile.CustomBarColorPicked.a)
					end
				end 
			end
		else
			barGroups[i]:Hide();
		end
	end 
end

function abbrev(name)
	local letters, lastWord = "", string.match(name, ".+%s(.+)$")
	if lastWord then
		for word in gmatch(name, ".-%s") do
			local firstLetter = string.utf8sub(gsub(word, "^[%s%p]*", ""), 1, 1)
			if firstLetter ~= string.utf8lower(firstLetter) then
				letters = format("%s%s. ", letters, firstLetter)
			end
		end
		name = format("%s%s", letters, lastWord)
	end
	return name
end

function IsEnemyFCDCaster(sender)
	if UnitInRaid(sender) or UnitInParty(sender) or UnitName("player") == sender then return false end
	if UnitInBattleground("player") ~= nil and (not UnitInRaid(sender) or not UnitInParty(sender)) then return true end 
	if not UnitInRaid(sender) and not UnitInParty(sender) and
		((UnitName("focus") ~= nil and sender == UnitName("focus") and UnitCanAttack("player","focus")) or
		(UnitName("target") ~= nil and sender == UnitName("target") and UnitCanAttack("player","target"))) then
		return true
	else
		return false
	end
end

function IsFriendlyFCDCaster(sender) if not IsEnemyFCDCaster(sender) then return true else return false end end

function mod:AuraMasteryChecker(bar, sender, spellId, cooldown, target, count)
	if count ~= nil and count > 0 then
		local NextAura = FatCooldowns:AMAuraCheck(sender)
		if target ~= nil and NextAura ~= nil and target ~= NextAura then
			local CurrentBarName = bar:GetLabel()
			local AuraTable = {
				["Devotion Aura"] = "Devotion",
				["Retribution Aura"] = "Retribution",
				["Concentration Aura"] = "Concentration",
				["Shadow Resistance Aura"] = "Shadow",
				["Frost Resistance Aura"] = "Frost",
				["Fire Resistance Aura"] = "Fire",
				["Crusader Aura"] = "Crusader",
			}
			local AuraTable2 = {
				["Devotion Aura"] = "Devo",
				["Retribution Aura"] = "Ret",
				["Concentration Aura"] = "Conc",
				["Shadow Resistance Aura"] = "Sha",
				["Frost Resistance Aura"] = "Fro",
				["Fire Resistance Aura"] = "Fir",
				["Crusader Aura"] = "Cru",
			}
			local AuraTable3 = {
				["Devotion Aura"] = "|TInterface\\Icons\\spell_holy_devotionaura:24:24:0:0:64:64:6:58:6:58|t",
				["Retribution Aura"] = "|TInterface\\Icons\\spell_holy_auraoflight:24:24:0:0:64:64:6:58:6:58|t",
				["Concentration Aura"] = "|TInterface\\Icons\\spell_holy_mindsooth:24:24:0:0:64:64:6:58:6:58|t",
				["Shadow Resistance Aura"] = "|TInterface\\Icons\\spell_shadow_sealofkings:24:24:0:0:64:64:6:58:6:58|t",
				["Frost Resistance Aura"] = "|TInterface\\Icons\\spell_frost_wizardmark:24:24:0:0:64:64:6:58:6:58|t",
				["Fire Resistance Aura"] = "|TInterface\\Icons\\spell_fire_sealoffire:24:24:0:0:64:64:6:58:6:58|t",
				["Crusader Aura"] = "|TInterface\\Icons\\spell_holy_crusaderaura:24:24:0:0:64:64:6:58:6:58|t",
			}
			if FatCooldowns:GetModule("Display").db.profile.AMType == 1 then
				if CurrentBarName ~= nil and NextAura ~= nil and CurrentBarName:find("^[%a]+ %- [%a]+$") then
					local FirstPart, SecondPart = select(3, CurrentBarName:find("(.+) %- (.+)"))
					if FirstPart ~= nil and SecondPart ~= nil then
						bar:SetLabel(FirstPart)
					end
				end
			elseif FatCooldowns:GetModule("Display").db.profile.AMType == 2 then
				for am, amname in pairs(AuraTable) do
					if CurrentBarName ~= nil and amname ~= nil and NextAura ~= nil and CurrentBarName:find(amname) then
						CurrentBarName = gsub(CurrentBarName, amname, NextAura)
						bar:SetLabel(CurrentBarName)
					end
				end
			elseif FatCooldowns:GetModule("Display").db.profile.AMType == 3 then
				for am, amname in pairs(AuraTable2) do
					if CurrentBarName ~= nil and amname ~= nil and NextAura ~= nil and CurrentBarName:find(amname) then
						CurrentBarName = gsub(CurrentBarName, amname, NextAura)
						bar:SetLabel(CurrentBarName)
					end
				end
			elseif FatCooldowns:GetModule("Display").db.profile.AMType == 4 then
				for am, amname in pairs(AuraTable3) do
					if CurrentBarName ~= nil and amname ~= nil and NextAura ~= nil and CurrentBarName:find(amname) then
						CurrentBarName = gsub(CurrentBarName, amname, NextAura)
						bar:SetLabel(CurrentBarName)
					end
				end
			end
		end
		self:ScheduleTimer(function() self:AuraMasteryChecker(bar, sender, spellId, cooldown, target, count - 0.5) end, 0.5)
	end
end

function mod:BuffChecker()
	if (not UnitInRaid("player") and GetNumPartyMembers() == 0) or not barGroups or not self.db.profile.Removal then self:ScheduleTimer(function() self:BuffChecker() end, 120) return end
	local _,zone2=IsInInstance()
	self = mod
	for i = 1, 10, 1 do
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and
		(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and
		(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
		(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
		(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena") and
		(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
		(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player")) and
		(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive()) then
			local bars = barGroups[i]:GetBars()
			if type(bars) == "table" then
				for key, bar in pairs(bars) do
					if bar.target ~= nil and not bar.ready and ((UnitInRaid(bar.caster) and UnitInRaid(bar.target)) or (UnitInParty(bar.caster) and UnitInParty(bar.target))) then 
						local _, c = CustomUnitClass(bar.caster)
						if c ~= nil and FatCooldowns.cooldowns[c] then 
							local spells = FatCooldowns.cooldowns[c]
							local spellnamebuffchecker = GetSpellInfo(bar.spellId)
							if spells[spellnamebuffchecker] and spells[spellnamebuffchecker].remove then 
								if not UnitBuff(bar.target, spellnamebuffchecker) then 
									bar:SetTimer(0.1, bar.maxValue, true)
								end							
							end
						end
					end
				end
			end
		end
	end
	self:ScheduleTimer(function() self:BuffChecker() end, 10)
end

function mod:HunterMDRename(sender, spellId, cooldown, target, test, infoSender, eventTypeone, whoringinfo, backlash)
	--print(sender, spellId, cooldown, target, test, infoSender, eventTypeone, whoringinfo, backlash)
	for i = 1, 10, 1 do 
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and
		(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and
		(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
		(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
		(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena") and
		(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
		(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player")) and
		(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive()) then
			if (self.db.profile.frames[i].EnemyFCDCaster and not IsEnemyFCDCaster(sender)) or
				(self.db.profile.frames[i].FriendlyCaster and not IsFriendlyFCDCaster(sender)) or
				(self.db.profile.frames[i].hideSelf and sender == playerName) or (self.db.profile.frames[i].onlySelf and sender ~= playerName)  then 
			else
				if self.db.profile.frames[i].spells[spellId] then 
					local bar = barGroups[i]:GetBar(sender .. "_" .. spellId)
					local addicon = nil
					if target == "FAILED" then addicon = " F" else addicon = " R" end
					
					if bar ~= nil then
						if bar.target == nil then return end
						local maxl = self.db.profile.frames[i].maxTextLength;
						local maxsenderl = self.db.profile.frames[i].maxTextLength;
						local leftbr = " "..self.db.profile.SymbolsStart
						local rightbr = self.db.profile.SymbolsEnd
						if self.db.profile.frames[i].hidetarget then maxl = 0 end
						if maxl == 0 then leftbr = "" rightbr = "" end
						local labelcooldown =  (self.db.profile.ColorCaster and FCDColorName2(string.sub(sender,1,maxsenderl), sender) or string.sub(sender,1,maxsenderl)) .. (self.db.profile.ReTarget and "" or (leftbr .. (self.db.profile.ColorTarget and FCDColorName2(string.sub(bar.target,1,maxl), bar.target) or string.sub(bar.target,1,maxl)) ..rightbr..addicon))
						if self.db.profile.frames[i].HideLabel then labelcooldown = "" end
						if self.db.profile.frames[i].SpellNameLabel then labelcooldown = GetSpellInfo(spellId) end
					
						if target == "FAILED" then
							bar:SetTimer(cooldown, cooldown, true)
						else 
							bar:SetTimer(bar.value, cooldown, true)
						end
							bar.time = cooldown
							bar:SetLabel(labelcooldown)
							
						local _, c = CustomUnitClass(sender)
						if not c then
							for k, v in pairs(FatCooldowns.cooldowns) do
								for k2, v2 in pairs(v) do
									if v2.id == spellId then
										c = k
									end
								end
							end
						end
					
						local color = RAID_CLASS_COLORS[c]
						if type(color) == "table" and not self.db.profile.CustomBarColor then
							bar:SetColorAt(1.00, color.r, color.g, color.b, 1)
							bar:SetColorAt(0.00, color.r, color.g, color.b, 1)
						elseif self.db.profile.CustomBarColor then
							bar:SetColorAt(1.00, self.db.profile.CustomBarColorPicked.r, self.db.profile.CustomBarColorPicked.g, self.db.profile.CustomBarColorPicked.b, self.db.profile.CustomBarColorPicked.a)
							bar:SetColorAt(0.00, self.db.profile.CustomBarColorPicked.r, self.db.profile.CustomBarColorPicked.g, self.db.profile.CustomBarColorPicked.b, self.db.profile.CustomBarColorPicked.a)
						end
					end
				end 
			end
		else
			barGroups[i]:Hide();
		end
	end 
end

function mod:FCDPrefixPrint(...)
    if self.db.profile.FCDPrefix == 1 then
	    local args = {...}
	    local lastIndex = 0
	    local filteredArgs = {}
        for i = 1, select("#", ...) do
       	 if args[i] ~= nil then lastIndex = i end
        end
	    for i = 1, lastIndex do
	        if args[i] == nil then filteredArgs[i] = "nil" else filteredArgs[i] = args[i] end
	    end
        local output = table.concat(filteredArgs, " ")
        if not self.db.profile.CustomPrintChatChannels then
      		_G["ChatFrame".."1"]:AddMessage(output, 1,1,1)
      	else
      		for x,c in pairs(self.db.profile.CustomPrintChatChannelsTable) do
      			if c ~= nil and c == true then
      				_G["ChatFrame"..x]:AddMessage(output, 1,1,1)
      			end
      		end
      	end
        --print(output)
    else
        local PrefixIcons = {
            [1] = "",
            [2] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t",
            [3] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t",
            [4] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t",
            [5] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t",
            [6] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t",
            [7] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t",
            [8] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t",
            [9] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t",
        }
	    local args = {...}
	    local lastIndex = 0
	    local filteredArgs = {}
        for i = 1, select("#", ...) do
       	 if args[i] ~= nil then lastIndex = i end
        end
	    for i = 1, lastIndex do
	        if args[i] == nil then filteredArgs[i] = "nil" else filteredArgs[i] = args[i] end
	    end
	    local output = PrefixIcons[self.db.profile.FCDPrefix] .. table.concat(filteredArgs, " ")
        if not self.db.profile.CustomPrintChatChannels then
      		_G["ChatFrame".."1"]:AddMessage(output, 1,1,1)
      	else
      		for x,c in pairs(self.db.profile.CustomPrintChatChannelsTable) do
      			if c ~= nil and c == true then
      				_G["ChatFrame"..x]:AddMessage(output, 1,1,1)
      			end
      		end
      	end
      	--print(output)
	end
end

function mod:FCDPrefixSendChatMessage(arg1,arg2,arg3,arg4)
	if self.db.profile.FCDPrefix == 1 then
		SendChatMessage(arg1,arg2,arg3,arg4)
	else
		local PrefixIcons = {
			[1] = "",
			[2] = "{rt1}",
			[3] = "{rt2}",
			[4] = "{rt3}",
			[5] = "{rt4}",
			[6] = "{rt5}",
			[7] = "{rt6}",
			[8] = "{rt7}",
			[9] = "{rt8}",
		}
		if arg1:find("FCD Warning: ") then
			arg1 = gsub(arg1, "FCD Warning: ", "")
		elseif arg1:find("FCD: ") then
			arg1 = gsub(arg1, "FCD: ", "")
		end
		SendChatMessage(PrefixIcons[self.db.profile.FCDPrefix].."- "..arg1,arg2,arg3,arg4)
	end
end

function mod:FCDSendChatMessage(msg, msg2, msg3, msg4, channel)
	local Fmsg = msg or ""
	local Fmsg2 = msg2 or ""
	local Fmsg3 = msg3 or ""
	local Fmsg4 = msg4 or ""
	if channel ~= 1 then
		if Fmsg2:find("|Hspell:31821|h") then
			local AuraTable = {
				[48942] = "|TInterface\\Icons\\spell_holy_devotionaura:24:24:0:0:64:64:6:58:6:58|t",
				[54043] = "|TInterface\\Icons\\spell_holy_auraoflight:24:24:0:0:64:64:6:58:6:58|t",
				[19746] = "|TInterface\\Icons\\spell_holy_mindsooth:24:24:0:0:64:64:6:58:6:58|t",
				[48943] = "|TInterface\\Icons\\spell_shadow_sealofkings:24:24:0:0:64:64:6:58:6:58|t",
				[48945] = "|TInterface\\Icons\\spell_frost_wizardmark:24:24:0:0:64:64:6:58:6:58|t",
				[48947] = "|TInterface\\Icons\\spell_fire_sealoffire:24:24:0:0:64:64:6:58:6:58|t",
				[32223] = "|TInterface\\Icons\\spell_holy_crusaderaura:24:24:0:0:64:64:6:58:6:58|t",
			}
			for amindex, amvalue in pairs(AuraTable) do
				if amvalue == Fmsg3 then Fmsg3 = GetSpellLink(amindex) break end
			end 
		end
	end
	if channel == 1 then
		if msg3 ~= nil then
			FatCooldowns:GetModule("Display"):FCDPrefixPrint(FCDColorName(Fmsg)..Fmsg2..FCDColorName(Fmsg3)..Fmsg4)
		else
			FatCooldowns:GetModule("Display"):FCDPrefixPrint(FCDColorName(Fmsg)..Fmsg2)
		end
	elseif channel == 2 then
		if GetNumPartyMembers() > 0 then
			 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Fmsg..Fmsg2..Fmsg3..Fmsg4, PARTY)
		else
			self:FCDSendChatMessage(msg, msg2, msg3, msg4, 1)
		end
	elseif channel == 3 then
		if UnitInRaid("player") and (IsRaidLeader() or IsRaidOfficer()) then
			 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Fmsg..Fmsg2..Fmsg3..Fmsg4, RAID)
		else
			self:FCDSendChatMessage(msg, msg2, msg3, msg4, 1)
		end
	elseif channel == 4 then
		if UnitInRaid("player") and (IsRaidLeader() or IsRaidOfficer()) then
			 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Fmsg..Fmsg2..Fmsg3..Fmsg4, RAID)
		elseif GetNumPartyMembers() > 0 then
			 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(Fmsg..Fmsg2..Fmsg3..Fmsg4, PARTY)
		else
			self:FCDSendChatMessage(msg, msg2, msg3, msg4, 1)
		end
	end
end

function mod:StartCooldown(sender, spellId, cooldown, target, test, infoSender, eventTypeone, whoringinfo, backlash, itemproc, LootItem, LootItem2)
 if target ~= nil and spellId ~= 69766 and spellId ~= 69037 and target:find("[%s]+") and self.db.profile.AbbrevName then if CustomUnitIsPlayer(target) then else target = abbrev(target) end end
	if sender ~= nil and CustomUnitIsPlayer(sender) and sender:find("[%a]+%-[%a]+") then
		local realscrnameone, realscrnametwo = select(3, sender:find("(%a+)%-(%a+)"))
		sender = realscrnameone
	end
	if target ~= nil and CustomUnitIsPlayer(target) and target:find("[%a]+%-[%a]+") then
		local realscrnameone, realscrnametwo = select(3, target:find("(%a+)%-(%a+)"))
		target = realscrnameone
	end 
	if not barGroups then return end 
	local _,zone2=IsInInstance()
	local _, playerclass = UnitClass("player")
	local spells = FatCooldowns.cooldowns["ITEMS"]
	local spells2 = FatCooldowns.cooldowns["CONSUMABLES"]
	local IsItem = nil
	local tempcooldown = nil
--	print(sender, spellId, cooldown, target, test, infoSender, eventTypeone, whoringinfo, backlash, itemproc, LootItem, LootItem2,2)
	
	if (self.db.profile.soundspells[spellId] or self.db.profile.SpellsReporter[spellId]) and (test == nil or test == false) then
		local _, class = CustomUnitClass(sender)
		if spellId ~= 70337 and spellId ~= 72143 and class ~= nil and FatCooldowns.cooldowns[class] then
			for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
				if spellTable.id == spellId then 
					if spellTable.cd2 ~= nil and cooldown == spellTable.cd2 then tempcooldown = spellTable.cd2
					elseif spellTable.cd3 ~= nil and cooldown == spellTable.cd3 then tempcooldown = spellTable.cd3
					elseif cooldown == spellTable.cd then tempcooldown = spellTable.cd
					end
				end
			end
			for spellName, spellTable in pairs(FatCooldowns.cooldowns["ITEMS"]) do
				if spellTable.id == spellId then tempcooldown = spellTable.cd IsItem = spells[spellName].itemlink end
			end	
			for spellName, spellTable in pairs(FatCooldowns.cooldowns["RACIALS"]) do
				if spellTable.id == spellId then tempcooldown = spellTable.cd end
			end	
			for spellName, spellTable in pairs(FatCooldowns.cooldowns["CONSUMABLES"]) do
				if spellTable.id == spellId then tempcooldown = spellTable.cd IsItem = spells2[spellName].itemlink end
			end	
		end
	end

	if tempcooldown ~= nil and tempcooldown == cooldown and (test == nil or test == false) then
		if self.db.profile.soundspells[spellId] and
			(not self.db.profile.soundspellsoptions[spellId].PlayerClassEnable or (self.db.profile.soundspellsoptions[spellId].PlayerClassEnable and self.db.profile.soundspellsoptions[spellId].PlayerClass[playerclass] ~= nil and self.db.profile.soundspellsoptions[spellId].PlayerClass[playerclass])) and
			((not self.db.profile.soundspellsoptions[spellId].Spec1 and not self.db.profile.soundspellsoptions[spellId].Spec1) or (self.db.profile.soundspellsoptions[spellId].Spec1 and GetActiveTalentGroup() == 1) or (self.db.profile.soundspellsoptions[spellId].Spec2 and GetActiveTalentGroup() == 2)) and
			((not self.db.profile.soundspellsoptions[spellId].EnemyCaster or (self.db.profile.soundspellsoptions[spellId].EnemyCaster and IsEnemyFCDCaster(sender))) and
			(not self.db.profile.soundspellsoptions[spellId].FriendlyCaster or (self.db.profile.soundspellsoptions[spellId].FriendlyCaster and IsFriendlyFCDCaster(sender))) and
			(not self.db.profile.soundspellsoptions[spellId].TargetMe or (self.db.profile.soundspellsoptions[spellId].TargetMe and target == UnitName("player"))) and
			(not self.db.profile.soundspellsoptions[spellId].NotSelf or (self.db.profile.soundspellsoptions[spellId].NotSelf and sender ~= UnitName("player"))) and
			(not self.db.profile.soundspellsoptions[spellId].Self or (self.db.profile.soundspellsoptions[spellId].Self and sender == UnitName("player"))) and
			(not self.db.profile.soundspellsoptions[spellId].NotTargetMe or (self.db.profile.soundspellsoptions[spellId].NotTargetMe and target ~= UnitName("player"))))
		then
			if self.db.profile.soundspellsoptions[spellId].CDUsed then 
				if self.db.profile.soundspellsoptions[spellId].EnableCustomSound then
					PlaySoundFile(FatCooldowns.FCDSounds[self.db.profile.soundspellsoptions[spellId].CustomSound], "Master",false)
					if self.db.profile.soundspellsoptions[spellId].CDUsedSound then self:ScheduleTimer(function() PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\Used.mp3", "Master", false) end, FatCooldowns.SoundsDuration[SpellNameByID]) end
				else
					local SpellNameByID = GetSpellInfo(spellId)
					if SpellNameByID:find(":") then SpellNameByID = gsub(SpellNameByID, ": ", " ") end
					if spellId == 61685 or spellId == 47996 or spellId == 53477 then SpellNameByID = gsub(SpellNameByID, SpellNameByID, "Pet "..SpellNameByID) end
					PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\SpellSounds\\"..SpellNameByID..".mp3", "Master",false)
					if self.db.profile.soundspellsoptions[spellId].CDUsedSound then self:ScheduleTimer(function() PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\Used.mp3", "Master", false) end, FatCooldowns.SoundsDuration[SpellNameByID]) end
				end
			end
		end

		if self.db.profile.SpellsReporter[spellId] and
			(not self.db.profile.spellreporteroptions[spellId].PlayerClassEnable or (self.db.profile.spellreporteroptions[spellId].PlayerClassEnable and self.db.profile.spellreporteroptions[spellId].PlayerClass[playerclass] ~= nil and self.db.profile.spellreporteroptions[spellId].PlayerClass[playerclass])) and
			(self.db.profile.spellreporteroptions[spellId].Spec == 1 or ((self.db.profile.spellreporteroptions[spellId].Spec == 2 and GetActiveTalentGroup() == 1) or (self.db.profile.spellreporteroptions[spellId].Spec == 3 and GetActiveTalentGroup() == 2))) and
			(self.db.profile.spellreporteroptions[spellId].EnemyCaster == 1 or ((self.db.profile.spellreporteroptions[spellId].EnemyCaster == 2 and IsEnemyFCDCaster(sender)) or (self.db.profile.spellreporteroptions[spellId].EnemyCaster == 3 and IsFriendlyFCDCaster(sender)))) and
			(self.db.profile.spellreporteroptions[spellId].TargetMe == 1  or ((self.db.profile.spellreporteroptions[spellId].TargetMe == 2 and target == UnitName("player")) or (self.db.profile.spellreporteroptions[spellId].TargetMe == 3 and target ~= UnitName("player")))) and
			(self.db.profile.spellreporteroptions[spellId].Self == 1 or ((self.db.profile.spellreporteroptions[spellId].Self == 2 and sender == UnitName("player")) or (self.db.profile.spellreporteroptions[spellId].Self == 3 and sender ~= UnitName("player")))) and
			(self.db.profile.spellreporteroptions[spellId].Raid == 1 or ((self.db.profile.spellreporteroptions[spellId].Raid == 2 and UnitInRaid("player") ~= nil and UnitInRaid("player") == true) or (self.db.profile.spellreporteroptions[spellId].Raid == 3 and (UnitInRaid("player") == nil or UnitInRaid("player") ~= nil and UnitInRaid("player") == false)))) and
			(self.db.profile.spellreporteroptions[spellId].BG == 1 or ((self.db.profile.spellreporteroptions[spellId].BG == 2 and zone2 == "pvp") or (self.db.profile.spellreporteroptions[spellId].BG == 3 and zone2 ~= "pvp"))) and
			(self.db.profile.spellreporteroptions[spellId].Arena == 1 or ((self.db.profile.spellreporteroptions[spellId].Arena == 2 and zone2 == "arena") or (self.db.profile.spellreporteroptions[spellId].Arena == 3 and zone2 ~= "arena")))
		then
			if self.db.profile.spellreporteroptions[spellId].CDUsed then
			--	print(sender, spellId, cooldown, target, test, infoSender, eventTypeone, whoringinfo, backlash, itemproc, LootItem, LootItem2,2)
				if target ~= nil and target ~= sender then
					if eventTypeone ~= nil and eventTypeone == "SPELL_AURA_APPLIED" then 
					else	
						self:FCDSendChatMessage(sender, " has used "..(IsItem or GetSpellLink(spellId)).." on ",target," "..FCDFormatTime(cooldown).." Sec CD", self.db.profile.spellreporteroptions[spellId].Channel)
					end
				else
					if (tostring(GetSpellInfo(34477)) == GetSpellInfo(spellId) or (tostring(GetSpellInfo(57934)) == GetSpellInfo(spellId) and (eventTypeone ~= nil and eventTypeone == "SPELL_AURA_APPLIED") and (backlash ~= nil and backlash ~= 57934))) then
						self:FCDSendChatMessage(sender, "'s "..(IsItem or GetSpellLink(spellId)).." is Active "..FCDFormatTime(cooldown).." Sec CD", nil, nil, self.db.profile.spellreporteroptions[spellId].Channel)
					elseif backlash ~= nil and backlash == 57934 then
					else
						self:FCDSendChatMessage(sender, " has used "..(IsItem or GetSpellLink(spellId)).." "..FCDFormatTime(cooldown).." Sec CD", nil, nil, self.db.profile.spellreporteroptions[spellId].Channel)
					end
				end
			end
		end
	end

	for i = 1, 10, 1 do 
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and
		(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and
		(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
		(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
		(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena") and
		(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
		(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player")) and
		(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive()) then
			if (self.db.profile.frames[i].EnemyFCDCaster and not IsEnemyFCDCaster(sender)) or
				(self.db.profile.frames[i].FriendlyCaster and not IsFriendlyFCDCaster(sender)) or
				(self.db.profile.frames[i].hideSelf and sender == playerName) or (self.db.profile.frames[i].onlySelf and sender ~= playerName)  then 
			else
				if self.db.profile.frames[i].spells[spellId] or (itemproc and self.db.profile.frames[i].spells[itemproc]) or (LootItem and self.db.profile.frames[i].spells[99038]) then  
		--print(sender, spellId, cooldown, target, test, infoSender, eventTypeone, whoringinfo, backlash, itemproc, LootItem, LootItem2,1)
					self:UpdateDisplay()
				
               		if backlash == "TankCooldown" and (spellId >= 89999  or spellId == 99038) then
               			for spellName, spellTable in pairs(FatCooldowns.cooldowns["Tank Only Cooldowns"]) do
               				if spellId == spellTable.id then spellId = spellTable.realid end
               			end
               		end
               		if spellId >= 89999 and spellId ~= 99038 then return end

					local bar = barGroups[i]:GetBar(sender .. "_" .. spellId)
					if bar == nil then
						if target and target ~= sender then
							local leftbr = " "..self.db.profile.SymbolsStart
							local rightbr = self.db.profile.SymbolsEnd
							if self.db.profile.frames[i].hidetarget then maxl = 0 end
							if maxl == 0 then leftbr = "" rightbr = "" end
							if spellId == 69037 then maxl = 99 end
							if spellId == 70337 then sender = target target = "Necrotic" end
							local labelcooldown = (self.db.profile.ColorCaster and FCDColorName2(string.sub(sender,1,maxsenderl), sender) or string.sub(sender,1,maxsenderl)) .. ((self.db.profile.ReTarget and "") or (leftbr .. (self.db.profile.ColorTarget and FCDColorName2(string.sub(target,1,maxl), target) or string.sub(target,1,maxl)) ..rightbr))
							if self.db.profile.frames[i].HideLabel then labelcooldown = "" end
							if self.db.profile.frames[i].SpellNameLabel then
								for class, k in pairs(FatCooldowns.cooldowns) do
									for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
										if class == "CONSUMABLES" or class == "ITEMS" then
											if spellTable.itemid ~= nil and spellTable.id == spellId then labelcooldown = GetItemInfo(spellTable.itemid) end
										elseif class == "ITEM PROC" or spellId == 99038 then
											if itemproc ~= nil then 
												if whoringinfo ~= nil then 
													labelcooldown = GetItemInfo(whoringinfo)
												else 
													labelcooldown = GetItemInfo(spellId)
												end
											end
										else
											if spellTable.id == spellId then labelcooldown = GetSpellInfo(spellTable.id) end
										end
									end
								end
							end
					
							if spellId == 70337 then target = sender sender = "Necrotic"..target end
							bar = barGroups[i]:NewTimerBar((sender .. "_" .. spellId), labelcooldown, cooldown, cooldown, spellId)
							if spellId == 70337 then sender = "Necrotic" end
						else
							local maxsenderl = self.db.profile.frames[i].maxTextLength;
							local labelcooldown = self.db.profile.ColorCaster and FCDColorName2(string.sub(sender,1,maxsenderl), sender) or string.sub(sender,1,maxsenderl)
							if self.db.profile.frames[i].HideLabel then labelcooldown = "" end
							if self.db.profile.frames[i].SpellNameLabel then
								for class, k in pairs(FatCooldowns.cooldowns) do
									for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
										if class == "CONSUMABLES" or class == "ITEMS" then
											if spellTable.itemid ~= nil and spellTable.id == spellId then labelcooldown = GetItemInfo(spellTable.itemid) end
										elseif class == "ITEM PROC" then
											if itemproc ~= nil then 
												if whoringinfo ~= nil then 
													labelcooldown = GetItemInfo(whoringinfo)
												else
													labelcooldown = GetItemInfo(spellId)
												end
											end
										else
											if spellTable.id == spellId then labelcooldown = GetSpellInfo(spellTable.id) end
										end
									end
								end
							end
							
							if spellId == 70337 then sender = target.."Necrotic" end
							bar = barGroups[i]:NewTimerBar((sender .. "_" .. spellId), labelcooldown, cooldown, cooldown, spellId)
							if spellId == 70337 then sender = "Necrotic" end
						end
						
						if not test then
							bar:SetScript("OnMouseUp", buttonClick)
							bar:EnableMouse(not self.db.profile.unclickable)
						end
						
						if itemproc ~= nil then bar.SpellName = GetItemInfo(spellId) end
						bar.target = target
						if UnitInRaid("player") or GetNumPartyMembers() >= 1 and spellId ~= 70337 and spellId ~= 69037 then bar.permanent = self.db.profile.frames[i].permanent and not test; end
						bar.caster  = sender
						if self.db.profile.ColorCaster then bar.castercolor = FCDColorName2(string.sub(sender,1,self.db.profile.frames[i].maxTextLength), sender) end
						bar.targetcolor = nil
						if target ~= nil and self.db.profile.ColorTarget then bar.targetcolor = FCDColorName2(string.sub(target,1,self.db.profile.frames[i].maxTextLength), target) end
						if self.db.profile.ReTarget then
							if sender ~= target then
								bar:SetLabel2(spellId == 70337 and target or bar.targetcolor or bar.target)
							else
								bar:SetLabel2(nil)
							end
							if self.db.profile.frames[i].fontsize == nil or self.db.profile.frames[i].fontsize == 0 then self.db.profile.frames[i].fontsize = 10 end
							barGroups[i]:SetFont(Media:Fetch("font", self.db.profile.fontFace), self.db.profile.frames[i].fontsize * 0.8, self.db.profile.outline, true)
						end
						bar.spellId = spellId
						bar.time = cooldown
						if self.db.profile.removeglow then bar.spark:SetTexture(nil) end
						if self.db.profile.FillBackGround then bar.FillBackground = true elseif not self.db.profile.FillBackGround then bar.FillBackground = false end
						if self.db.profile.FillBars then bar.fill = true elseif not self.db.profile.FillBars then bar.fill = false end
						
						if self.db.profile.iconzoom then bar.icon:SetTexCoord(0.08,0.92,0.08,0.92) else bar.icon:SetTexCoord(0,1,0,1) end
						bar:SetTexture(Media:Fetch("statusbar", self.db.profile.texture))

						if itemproc and spellId == 99038 then 
							bar.ItemLinkLoot = whoringinfo
							bar:SetIcon(whoringinfo, whoringinfo)
							if self.db.profile.iconzoom then bar.icon:SetTexCoord(0.08,0.92,0.08,0.92) else bar.icon:SetTexCoord(0,1,0,1) end
	 					end
					else 
						if not infoSender or infoSender == sender then
							if cooldown < bar.maxValue then
								if spellId == 70337 then
									bar:SetTimer(cooldown, 5, true)
								elseif spellId == 57934 and cooldown < 28 then
									bar:SetTimer(cooldown, FatCooldowns:TOTTalentChecker(sender), true)
								else
									if target ~= nil and target ~= sender then 
										local maxl = self.db.profile.frames[i].maxTextLength;
										local maxsenderl = self.db.profile.frames[i].maxTextLength;
										local leftbr = " "..self.db.profile.SymbolsStart
										local rightbr = self.db.profile.SymbolsEnd
										if self.db.profile.frames[i].hidetarget then maxl = 0 end
										if maxl == 0 then leftbr = "" rightbr = "" end
										local labelcooldown = (self.db.profile.ColorCaster and FCDColorName2(string.sub(sender,1,maxsenderl), sender) or string.sub(sender,1,maxsenderl)) .. (self.db.profile.ReTarget and "" or (leftbr .. (self.db.profile.ColorTarget and FCDColorName2(string.sub(target,1,maxsenderl), target) or string.sub(target,1,maxl)) ..rightbr))
										if self.db.profile.frames[i].HideLabel then labelcooldown = "" end
										if self.db.profile.frames[i].SpellNameLabel then
											for class, k in pairs(FatCooldowns.cooldowns) do
												for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
													if class == "CONSUMABLES" or class == "ITEMS" then
														if spellTable.itemid ~= nil and spellTable.id == spellId then labelcooldown = GetItemInfo(spellTable.itemid) end
													elseif class == "ITEM PROC" or spellId == 99038 then
														if itemproc ~= nil then 
															if whoringinfo ~= nil then labelcooldown = GetItemInfo(whoringinfo)
															else labelcooldown = GetItemInfo(spellId)
															end
														end
													else
														if spellTable.id == spellId then labelcooldown = GetSpellInfo(spellTable.id) end
													end
												end
											end
										end
										if itemproc ~= nil then bar.SpellName = GetItemInfo(spellId) end

										bar:SetLabel(labelcooldown)
										bar.target = target
										bar.caster  = sender
										if self.db.profile.ColorCaster then bar.castercolor = FCDColorName2(string.sub(sender,1,self.db.profile.frames[i].maxTextLength), sender) end
										bar.targetcolor = nil
										if target ~= nil and  self.db.profile.ColorTarget then bar.targetcolor = FCDColorName2(string.sub(target,1,self.db.profile.frames[i].maxTextLength), target) end
										if self.db.profile.ReTarget then
											if sender ~= target then
												bar:SetLabel2(spellId == 70337 and target or bar.targetcolor or bar.target)
											else
												bar:SetLabel2(nil)
											end
											if self.db.profile.frames[i].fontsize == nil or self.db.profile.frames[i].fontsize == 0 then self.db.profile.frames[i].fontsize = 10 end
											barGroups[i]:SetFont(Media:Fetch("font", self.db.profile.fontFace), self.db.profile.frames[i].fontsize * 0.8, self.db.profile.outline, true)
										end
										bar.spellId = spellId
										bar.time = cooldown
									else
										local maxl = self.db.profile.frames[i].maxTextLength;
										local maxsenderl = self.db.profile.frames[i].maxTextLength;
										if spellId == 69037 then maxl = 99 end
										local labelcooldown = (self.db.profile.ColorCaster and FCDColorName2(string.sub(sender,1,maxsenderl), sender)) or string.sub(sender,1,maxsenderl)
										if self.db.profile.frames[i].HideLabel then labelcooldown = "" end
										if self.db.profile.frames[i].SpellNameLabel then
											for class, k in pairs(FatCooldowns.cooldowns) do
												for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
													if class == "CONSUMABLES" or class == "ITEMS" then
														if spellTable.itemid ~= nil and spellTable.id == spellId then labelcooldown = GetItemInfo(spellTable.itemid) end
													elseif class == "ITEM PROC" or spellId == 99038 then
														if itemproc ~= nil then 
															if whoringinfo ~= nil then labelcooldown = GetItemInfo(whoringinfo)
															else labelcooldown = GetItemInfo(spellId)
															end
														end
													else
														if spellTable.id == spellId then labelcooldown = GetSpellInfo(spellTable.id) end
													end
												end
											end
										end
					
										if itemproc ~= nil then bar.SpellName = GetItemInfo(spellId) end
										bar:SetLabel(labelcooldown)
										bar.target = target
										bar.caster = sender
										if self.db.profile.ColorCaster then bar.castercolor = FCDColorName2(string.sub(sender,1,self.db.profile.frames[i].maxTextLength), sender) end
										bar.spellId = spellId
										bar.time = cooldown
									end
									bar:SetTimer(cooldown, cooldown, true)
								end
								bar.time = cooldown
								bar.maxValue = cooldown
							else
								if spellId == 34477 and bar.target ~= nil and target == bar.target and not bar.ready and FatCooldowns.ExPac == 2 then 
									local maxl = self.db.profile.frames[i].maxTextLength;
									local maxsenderl = self.db.profile.frames[i].maxTextLength;
									local leftbr = " "..self.db.profile.SymbolsStart
									local rightbr = self.db.profile.SymbolsEnd
									if self.db.profile.frames[i].hidetarget then maxl = 0 end
									if maxl == 0 then leftbr = "" rightbr = "" end
									local labelcooldown = (self.db.profile.ColorCaster and FCDColorName2(string.sub(sender,1,maxsenderl), sender) or string.sub(sender,1,maxsenderl)) .. (self.db.profile.ReTarget and "" or (leftbr .. (self.db.profile.ColorTarget and FCDColorName2(string.sub(target,1,maxsenderl), target) or string.sub(target,1,maxl)) ..rightbr.." +"))
									if self.db.profile.frames[i].HideLabel then labelcooldown = "" end
									if self.db.profile.frames[i].SpellNameLabel then
										for class, k in pairs(FatCooldowns.cooldowns) do
											for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
												if class == "CONSUMABLES" or class == "ITEMS" then
													if spellTable.itemid ~= nil and spellTable.id == spellId then labelcooldown = GetItemInfo(spellTable.itemid) end
												elseif class == "ITEM PROC" or spellId == 99038 then
													if itemproc ~= nil then 
														if whoringinfo ~= nil then labelcooldown = GetItemInfo(whoringinfo)
														else labelcooldown = GetItemInfo(spellId)
														end
													end
												else
													if spellTable.id == spellId then labelcooldown = GetSpellInfo(spellTable.id) end
												end
											end
										end
									end
					
									bar:SetTimer(cooldown, cooldown, true)
									bar.time = cooldown
									bar:SetLabel(labelcooldown)
									if itemproc ~= nil then bar.SpellName = GetItemInfo(spellId) end

									bar.target = target
									bar.caster  = sender
									if self.db.profile.ColorCaster then bar.castercolor = FCDColorName2(string.sub(sender,1,self.db.profile.frames[i].maxTextLength), sender) end
									bar.targetcolor = nil
									if target ~= nil and self.db.profile.ColorTarget then bar.targetcolor = FCDColorName2(string.sub(target,1,self.db.profile.frames[i].maxTextLength), target) end
									if self.db.profile.ReTarget then
										if sender ~= target then
											bar:SetLabel2(spellId == 70337 and target or bar.targetcolor or bar.target)
										else
											bar:SetLabel2(nil)
										end
										if self.db.profile.frames[i].fontsize == nil or self.db.profile.frames[i].fontsize == 0 then self.db.profile.frames[i].fontsize = 10 end
										barGroups[i]:SetFont(Media:Fetch("font", self.db.profile.fontFace), self.db.profile.frames[i].fontsize * 0.8, self.db.profile.outline, true)
									end
									bar.spellId = spellId
									bar.time = cooldown
								elseif spellId == 34477 or spellId == 57934 then
									if target ~= nil and target ~= sender then 
										bar:SetTimer(cooldown, cooldown, true)

										local maxl = self.db.profile.frames[i].maxTextLength;
										local maxsenderl = self.db.profile.frames[i].maxTextLength;
										local leftbr = " "..self.db.profile.SymbolsStart
										local rightbr = self.db.profile.SymbolsEnd
										if self.db.profile.frames[i].hidetarget then maxl = 0 end
										if maxl == 0 then leftbr = "" rightbr = "" end
										local labelcooldown = (self.db.profile.ColorCaster and FCDColorName2(string.sub(sender,1,maxsenderl), sender) or string.sub(sender,1,maxsenderl)) .. (self.db.profile.ReTarget and "" or (leftbr .. (self.db.profile.ColorTarget and FCDColorName2(string.sub(target,1,maxsenderl), target) or string.sub(target,1,maxl)) ..rightbr))
										if self.db.profile.frames[i].HideLabel then labelcooldown = "" end
										if self.db.profile.frames[i].SpellNameLabel then
											for class, k in pairs(FatCooldowns.cooldowns) do
												for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
													if class == "CONSUMABLES" or class == "ITEMS" then
														if spellTable.itemid ~= nil and spellTable.id == spellId then labelcooldown = GetItemInfo(spellTable.itemid) end
													elseif class == "ITEM PROC" or spellId == 99038 then
														if itemproc ~= nil then 
															if whoringinfo ~= nil then labelcooldown = GetItemInfo(whoringinfo)
															else labelcooldown = GetItemInfo(spellId)
															end
														end
													else
														if spellTable.id == spellId then labelcooldown = GetSpellInfo(spellTable.id) end
													end
												end
											end
										end
										if itemproc ~= nil then bar.SpellName = GetItemInfo(spellId) end

										bar:SetLabel(labelcooldown)
										bar.target = target
										bar.caster  = sender
										if self.db.profile.ColorCaster then bar.castercolor = FCDColorName2(string.sub(sender,1,self.db.profile.frames[i].maxTextLength), sender) end
										bar.targetcolor = nil
										if target ~= nil and  self.db.profile.ColorTarget then bar.targetcolor = FCDColorName2(string.sub(target,1,self.db.profile.frames[i].maxTextLength), target) end
										if self.db.profile.ReTarget then
											if sender ~= target then
												bar:SetLabel2(spellId == 70337 and target or bar.targetcolor or bar.target)
											else
												bar:SetLabel2(nil)
											end
											if self.db.profile.frames[i].fontsize == nil or self.db.profile.frames[i].fontsize == 0 then self.db.profile.frames[i].fontsize = 10 end
											barGroups[i]:SetFont(Media:Fetch("font", self.db.profile.fontFace), self.db.profile.frames[i].fontsize * 0.8, self.db.profile.outline, true)
										end
										bar.spellId = spellId
										bar.time = cooldown
									else 
										bar:SetTimer(cooldown, cooldown, true)
									end
								else
									if spellId == 70337 then
										bar:SetTimer(cooldown, 5, true)
									else
										bar:SetTimer(cooldown, cooldown, true)
									end
									bar.time = cooldown
									if target and target ~= sender then
										local maxl = self.db.profile.frames[i].maxTextLength;
										local maxsenderl = self.db.profile.frames[i].maxTextLength;
										local leftbr = " "..self.db.profile.SymbolsStart
										local rightbr = self.db.profile.SymbolsEnd
										if self.db.profile.frames[i].hidetarget then maxl = 0 end
										if maxl == 0 then leftbr = "" rightbr = "" end
										if spellId == 69037 then maxl = 99 end
										local labelcooldown = (self.db.profile.ColorCaster and FCDColorName2(string.sub(sender,1,maxsenderl), sender) or string.sub(sender,1,maxsenderl)) .. (self.db.profile.ReTarget and "" or (leftbr .. (self.db.profile.ColorTarget and FCDColorName2(string.sub(target,1,maxsenderl), target) or string.sub(target,1,maxl)) ..rightbr))
										if self.db.profile.frames[i].HideLabel then labelcooldown = "" end
										if self.db.profile.frames[i].SpellNameLabel then
											for class, k in pairs(FatCooldowns.cooldowns) do
												for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
													if class == "CONSUMABLES" or class == "ITEMS" then
														if spellTable.itemid ~= nil and spellTable.id == spellId then labelcooldown = GetItemInfo(spellTable.itemid) end
													elseif class == "ITEM PROC" or spellId == 99038 then
														if itemproc ~= nil then 
															if whoringinfo ~= nil then labelcooldown = GetItemInfo(whoringinfo)
															else labelcooldown = GetItemInfo(spellId)
															end
														end
													else
														if spellTable.id == spellId then labelcooldown = GetSpellInfo(spellTable.id) end
													end
												end
											end
										end
					
										if itemproc ~= nil then bar.SpellName = GetItemInfo(spellId) end
										bar:SetLabel(labelcooldown)
										bar.target = target
										bar.caster  = sender
										if self.db.profile.ColorCaster then bar.castercolor = FCDColorName2(string.sub(sender,1,self.db.profile.frames[i].maxTextLength), sender) end
										bar.targetcolor = nil
										if target ~= nil and self.db.profile.ColorTarget then bar.targetcolor = FCDColorName2(string.sub(target,1,self.db.profile.frames[i].maxTextLength), target) end
										if self.db.profile.ReTarget then
											if sender ~= target then
												bar:SetLabel2(spellId == 70337 and target or bar.targetcolor or bar.target)
											else
												bar:SetLabel2(nil)
											end
											if self.db.profile.frames[i].fontsize == nil or self.db.profile.frames[i].fontsize == 0 then self.db.profile.frames[i].fontsize = 10 end
											barGroups[i]:SetFont(Media:Fetch("font", self.db.profile.fontFace), self.db.profile.frames[i].fontsize * 0.8, self.db.profile.outline, true)
										end			
										bar.spellId = spellId
										bar.time = cooldown
									else
										local maxl = self.db.profile.frames[i].maxTextLength;
										local maxsenderl = self.db.profile.frames[i].maxTextLength;
										if spellId == 69037 then maxl = 99 end
										local labelcooldown = (self.db.profile.ColorCaster and FCDColorName2(string.sub(sender,1,maxsenderl), sender)) or string.sub(sender,1,maxsenderl)
										if self.db.profile.frames[i].HideLabel then labelcooldown = "" end
										if self.db.profile.frames[i].SpellNameLabel then
											for class, k in pairs(FatCooldowns.cooldowns) do
												for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
													if class == "CONSUMABLES" or class == "ITEMS" then
														if spellTable.itemid ~= nil and spellTable.id == spellId then labelcooldown = GetItemInfo(spellTable.itemid) end
													elseif class == "ITEM PROC" or spellId == 99038 then
														if itemproc ~= nil then 
															if whoringinfo ~= nil then labelcooldown = GetItemInfo(whoringinfo)
															else labelcooldown = GetItemInfo(spellId)
															end
														end
													else
														if spellTable.id == spellId then labelcooldown = GetSpellInfo(spellTable.id) end
													end
												end
											end
										end
					
										if itemproc ~= nil then bar.SpellName = GetItemInfo(spellId) end
										bar:SetLabel(labelcooldown)
										bar.target = target
										bar.caster = sender
										if self.db.profile.ColorCaster then bar.castercolor = FCDColorName2(string.sub(sender,1,self.db.profile.frames[i].maxTextLength), sender) end
										bar.spellId = spellId
										bar.time = cooldown							
									end
								end
							end
						end
					end
					if itemproc and (self.db.profile.frames[i].spells[itemproc] or spellId == 99038) then
						bar.ItemLinkLoot = whoringinfo
						if whoringinfo == nil then
							bar:SetIcon(spellId, spellId)
							if self.db.profile.iconzoom then bar.icon:SetTexCoord(0.08,0.92,0.08,0.92) else bar.icon:SetTexCoord(0,1,0,1) end
						else
							bar:SetIcon(whoringinfo, whoringinfo)
							if self.db.profile.iconzoom then bar.icon:SetTexCoord(0.08,0.92,0.08,0.92) else bar.icon:SetTexCoord(0,1,0,1) end
						end
 					end
 					if self.db.profile.CustomNameColor then
						if bar:GetLabel() ~= nil then bar:SetLabel(self:FCDColorText(bar:GetLabel(), self.db.profile.CustomNameColorPicked.r, self.db.profile.CustomNameColorPicked.g, self.db.profile.CustomNameColorPicked.b)) end
						if bar:GetLabel2() ~= nil then bar:SetLabel(self:FCDColorText(bar:GetLabel(), self.db.profile.CustomNameColorPicked.r, self.db.profile.CustomNameColorPicked.g, self.db.profile.CustomNameColorPicked.b)) end
					end
					--if i == 9 then bar.bgtexture:SetTexture(nil) bar.texture:SetTexture(nil) bar.timerLabel:Hide() end -- icononly
 					local _, c = CustomUnitClass(sender)
					if not c then
						for k, v in pairs(FatCooldowns.cooldowns) do
							for k2, v2 in pairs(v) do
								if v2.id == spellId then
									c = k
								end
							end
						end
					end
					bar.backlash = backlash
					if self.db.profile.frames[i].BarBackground then
						bar.bgtexture:Hide() bar.texture:Hide() bar.timerLabel:Hide() barGroups[i]:SetWidth(1) self.db.profile.frames[i].anchor = false barGroups[i]:HideAnchor()
					else
						bar.bgtexture:Show() bar.texture:Show() bar.timerLabel:Show() barGroups[i]:SetWidth(self.db.profile.frames[i].width) 
					end
					if RC:GetRange(bar.caster) ~= nil and RC:GetRange(bar.caster) >= 80 then
						if self.db.profile.frames[i].opacity == nil then self.db.profile.frames[i].opacity = 100 end
						bar.barop = self.db.profile.frames[i].opacity / 100
						bar:SetAlpha(self.db.profile.frames[i].opacity / 100)
					else
						bar.barop = self.db.profile.frames[i].alpha / 100
					end	
					local color = RAID_CLASS_COLORS[c]
					if spellId == 70337 then color = {r = 0.1, g = 0.9, b = 0.1} end -- np
					if spellId == 72143 then color = {r = 0.64, g = 0.41, b = 0.18} end -- enrage
					if spellId == 99038 then 
						if LootItem2 == 4 then bar.whoringinfo = 4 color = {r = 0.64, g = 0.21, b = 0.93} -- loot timer
						elseif LootItem2 == 3 then bar.whoringinfo = 3 color = {r = 0.00, g = 0.44, b = 0.87} end -- loot timer
					end
					if type(color) == "table" and not self.db.profile.CustomBarColor then
						bar:SetColorAt(1.00, color.r, color.g, color.b, 1)
						bar:SetColorAt(0.00, color.r, color.g, color.b, 1)
					elseif self.db.profile.CustomBarColor then
						bar:SetColorAt(1.00, self.db.profile.CustomBarColorPicked.r, self.db.profile.CustomBarColorPicked.g, self.db.profile.CustomBarColorPicked.b, self.db.profile.CustomBarColorPicked.a)
						bar:SetColorAt(0.00, self.db.profile.CustomBarColorPicked.r, self.db.profile.CustomBarColorPicked.g, self.db.profile.CustomBarColorPicked.b, self.db.profile.CustomBarColorPicked.a)
					end
					if spellId == 31821 and bar ~= nil and not test then self:AuraMasteryChecker(bar, sender, spellId, cooldown, target, 6) end
				end 
			end
		else
			barGroups[i]:Hide();
		end
	end 
end

function mod:leadcheck(sender, spellId, cooldown, target, test, infoSender, eventTypeone, whoringinfo, backlash)
	if spellId == 99980 then 
		if backlash == "FCDLEADER" then AntiSpamLeader = sender AntiSpamOfficer = sender AntiSpamPlayer = sender
	 		elseif backlash == "FCDOFFICER" then AntiSpamOfficer = sender AntiSpamPlayer = sender
	 		elseif backlash == "FCDPLAYER" then AntiSpamPlayer = sender
	 	end
	end
	return
end

function mod:chatreporter(sender, spellId, cooldown, target, test, infoSender, eventTypeone, whoringinfo, backlash)
	--print(sender, spellId, cooldown, target, test, infoSender, eventTypeone, whoringinfo, backlash)
	if self.db.profile.reporter[spellId] or (self.db.profile.FishCount > 0 and spellId == 99987) then
		if owner == false and checked == false then
			local PlayersName = UnitName("player")
			if PlayersName == "Mixbreed" or PlayersName == "Fellowhuman" or PlayersName == "Jogger" or PlayersName == "Skeksis" or PlayersName == "Shekles" or PlayersName == "Dissident" or
				PlayersName == "Wegotgrowth" or PlayersName == "Gamerword" or PlayersName == "Echoez" or PlayersName == "Propaganda" or PlayersName == "Sheklez" or PlayersName == "Longearz" or PlayersName == "Sheckles" then
				owner = true checked = true
			end
		end
		
		if (backlash ~= nil or whoringinfo ~= nil) and owner == false and self.db.profile.reporter[99980] then
			AntiSpamOfficer = UnitName("player") 
			AntiSpamLeader = UnitName("player") 
		end		

		if backlash ~= nil and spellId == 99991 then  --RS Dispels
			if (IsRaidLeader() or IsRaidOfficer() or owner) and not self.db.profile.reporter[99877] then
				 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(backlash, RAID)
			else
				FatCooldowns:GetModule("Display"):FCDPrefixPrint(backlash)
			end
	    return
	    end 

	    

		if (backlash ~= nil or whoringinfo ~= nil) and owner == false and not self.db.profile.reporter[99980] then
			if AntiSpamLeader ~= UnitName("player") then if AntiSpamMessage then AntiSpamMessage = false FatCooldowns:GetModule("Display"):FCDPrefixPrint("AntiSpam has been enabled, your raid leader has FCD you will no longer report messages to the raid") end return
			elseif AntiSpamLeader ~= UnitName("player") and AntiSpamOfficer ~= UnitName("player") then if AntiSpamMessage then AntiSpamMessage = false FatCooldowns:GetModule("Display"):FCDPrefixPrint("AntiSpam has been enabled, your raid leader has FCD you will no longer report messages to the raid") end return
			elseif AntiSpamLeader ~= UnitName("player") and AntiSpamOfficer ~= UnitName("player") and AntiSpamPlayer ~= UnitName("player") then if AntiSpamMessage then AntiSpamMessage = false FatCooldowns:GetModule("Display"):FCDPrefixPrint("AntiSpam has been enabled, your raid leader has FCD you will no longer report messages to the raid") end return end
		end	
			
		if spellId == 98984 then  --Dreamwalker 
			if (IsRaidLeader() or IsRaidOfficer() or owner) and not self.db.profile.reporter[99877] then
				 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(backlash, RAID)
			else
				FatCooldowns:GetModule("Display"):FCDPrefixPrint(backlash)
			end
	    return
	    end 
	    								
		if backlash ~= nil and
			(spellId == 99996 or  --Baby Spice
			spellId == 99988 or  --BPC EMP Shock tank
			spellId == 99895 or  --BPC EMP Shock healer
			(spellId == 99985 or spellId == 99984)  or  --Parry
			spellId == 99967 or  --emp flames
			spellId == 99992 or  --Failing Bite BQL
			spellId == 99995 or  --StealingBite
			spellId == 99998 or --Backlash Reporter
			spellId == 99993 or --Who Bites who at BQL
			spellId == 99997 or  -- Incorrect Ooze Damage
			spellId == 99963 or  -- Valk Stuns
			spellId == 99960 or  -- Successful PARRY HASTED attack from Halion
			spellId == 99966 or  -- howls
			spellId == 99965 or  -- vile gas
			spellId == 99963 or  -- warlock fail debuff lk
			spellId == 99994 or -- single target valk
			spellId == 99901 or -- lady spirit
			spellId == 99961 or -- necro plague
			spellId == 99962 or -- FF COTE on lk
			spellId == 99883 or -- bpc charge
			spellId == 99888 or -- Parrycounter sindra
			spellId == 99880 or -- Parrycounter hp1
			spellId == 99881 or -- Parrycounter hp2
			spellId == 99882 or -- Parrycounter ph3
			spellId == 99884 or -- totem
			spellId == 99863 or -- totem 2
			spellId == 99857 or -- expose 
			spellId == 99964) then -- 5 sunders
			if (IsRaidLeader() or IsRaidOfficer() or owner) and not self.db.profile.reporter[99877] then
				 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(backlash, RAID)
			else
				FatCooldowns:GetModule("Display"):FCDPrefixPrint(backlash)
			end
	    return
	    end

		if spellId == 99999 then
			if whoringinfo == 47520 and AntiSpamCleave[sender] == nil then AntiSpamCleave[sender] = 1 elseif whoringinfo == 47520 and AntiSpamCleave[sender] >= 1 then AntiSpamCleave[sender] = AntiSpamCleave[sender] + 1 end
			if whoringinfo == 47520 and AntiSpamCleave[sender] == 5 then
				if not self.db.profile.reporter[99877]  then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(sender.." is spaming cleave anti-spam has been enabled for "..sender, RAID) else FatCooldowns:GetModule("Display"):FCDPrefixPrint(sender.." is spaming cleave anti-spam has been enabled for "..sender) end
				return elseif whoringinfo == 47520 and AntiSpamCleave[sender] >= 6 then return end
				if (IsRaidLeader() or IsRaidOfficer() or owner) and not self.db.profile.reporter[99877] then -- whoringinfo
					 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("Warning: "..sender.." has used "..GetSpellLink(whoringinfo).." on "..target, RAID)
				else
					FatCooldowns:GetModule("Display"):FCDPrefixPrint("Warning:", FCDColorName(sender),"has used", GetSpellLink(whoringinfo),"on", target)
				end
			return
		end

		if spellId == 99902 and backlash == "Red Ooze" then
			if (IsRaidLeader() or IsRaidOfficer() or owner) and not self.db.profile.reporter[99877] then
				self:ScheduleTimer(function() FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(sender.." has been hit by Gas Cloud!",RAID) end, 1)
	        else
	        	FatCooldowns:GetModule("Display"):FCDPrefixPrint(FCDColorName(sender)," has been hit by Gas Cloud!")
	       	end
	    return
	    end

		if spellId == 49844 or spellId == 27433 then
			local channel = SAY
			if GetNumRaidMembers() > 0 and (IsRaidLeader() or IsRaidOfficer()) then
	    		channel = "RAID_WARNING"
	        elseif GetNumRaidMembers() > 0 then
	           	channel = RAID
	        elseif GetNumPartyMembers() > 0 then
	        	channel = PARTY
	        end 
	        if channel == SAY then return end
			if (eventTypeone == "SPELL_CAST_START" and spellId == 49844) then
				 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(sender.." is casting ".."\124cff0070dd\124Hitem:37863:0:0:0:0:0:0:0:0\124h[Direbrew's Remote]\124h\124r".." you have 10 seconds to stop.", channel)
			elseif (eventTypeone == "SPELL_CREATE" and spellId == 49844) then
				 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(sender.." has created ".."\124cff0070dd\124Hitem:37863:0:0:0:0:0:0:0:0\124h[Direbrew's Remote]\124h\124r".." do not click it.", channel)
			elseif (eventTypeone == "SPELL_CAST_SUCCESS" and spellId == 27433) then
				 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(sender.." has created ".."\124cffffffff\124Hitem:21946:0:0:0:0:0:0:0:0\124h[Ectoplasmic Distiller]\124h\124r", channel) 
			end
		return
		end

		if (eventTypeone == "SPELL_CAST_START" or eventTypeone == "SPELL_CREATE") and backlash ~= nil and whoringinfo ~= nil and backlash == whoringinfo then
			local channel = SAY
			if GetNumRaidMembers() > 0 then
	        	channel = RAID
	        elseif GetNumPartyMembers() > 0 then
	        	channel = PARTY
	        end
			if PortalTable[sender] == nil then PortalTable[sender] = {time = GetTime(), count = 1}
			elseif GetTime() - PortalTable[sender]["time"] > 30 then PortalTable[sender] = {time = GetTime(), count = 1}
	        end
	        if (PortalTable[sender]["count"] == 1 and eventTypeone == "SPELL_CAST_START") or eventTypeone == "SPELL_CREATE" then
	        	if eventTypeone == "SPELL_CAST_START" and (self.db.profile.reporter[spellId] == 2 or self.db.profile.reporter[spellId] == 3 or self.db.profile.reporter[spellId] == 4 or self.db.profile.reporter[spellId] == 5) then
			        if self.db.profile.reporter[spellId] == 2 or self.db.profile.reporter[spellId] == 4 then
						 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(sender.." is casting "..GetSpellLink(whoringinfo).." you have 10 seconds to stop", channel)
					elseif self.db.profile.reporter[spellId] == 3 or self.db.profile.reporter[spellId] == 5 then
						 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(sender.." is casting "..GetSpellLink(whoringinfo), channel)
					end
					FatCooldowns:ScheduleTimer(function() PortalTable[sender]["count"] = 1 end, 30)
					PortalTable[sender]["count"] = 2
				elseif eventTypeone == "SPELL_CREATE" and (self.db.profile.reporter[spellId] == 2 or self.db.profile.reporter[spellId] == 3 or self.db.profile.reporter[spellId] == 6 or self.db.profile.reporter[spellId] == 7) then
			        if self.db.profile.reporter[spellId] == 2 or self.db.profile.reporter[spellId] == 6 then
						 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(sender.." created "..GetSpellLink(whoringinfo), channel)
					elseif self.db.profile.reporter[spellId] == 3 or self.db.profile.reporter[spellId] == 7 then
						 FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(sender.." created "..GetSpellLink(whoringinfo), channel)
					end
					PortalTable[sender]["count"] = 1
				end
			else
			end
			return
		end

		if spellId == 98934 then
			local channel = SAY
			if GetNumRaidMembers() > 0 and (IsRaidLeader() or IsRaidOfficer()) then
	    		channel = "RAID_WARNING"
	        elseif GetNumRaidMembers() > 0 then
	           	channel = RAID
	        elseif GetNumPartyMembers() > 0 then
	        	channel = PARTY
	        end 
   	        if channel == SAY then return end
	        FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(sender.." created "..GetSpellLink(whoringinfo), channel)
			return
		end

		if spellId == 99987 and eventTypeone == "SPELL_CAST_SUCCESS" and self.db.profile.FishCount > 0 then
			local channel = SAY
			if GetNumRaidMembers() > 0 then
	        	channel = RAID
	        elseif GetNumPartyMembers() > 0 then
	        	channel = PARTY
	        end

	        if FishTable[sender] == nil then FishTable[sender] = {time = GetTime(), count = 1}
	        elseif GetTime() - FishTable[sender]["time"] > 30 then FishTable[sender] = {time = GetTime(), count = 1}
	        else 
	        	FishTable[sender]["count"] = FishTable[sender]["count"] + 1
				if FishTable[sender]["count"] >= self.db.profile.FishCount then
					FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(sender.." has clicked the ".."\124cffffffff\124Hitem:43015:0:0:0:0:0:0:0:0\124h[Fish Feast]\124h\124r".." at least "..FishTable[sender]["count"].." times.", channel)
					FishTable[sender]["count"] = 0
					FatCooldowns:ScheduleTimer(function() FishTable[sender]["count"] = 1 end, 30)
				end
			end
			return
		end
	end			
end

function mod:StopCooldown(sender, spellId, force)
	if not barGroups then return end
	if sender == nil or spellId == nil then return end
	local _,zone2=IsInInstance()
	--print(sender, spellId, force, "StopCooldown")
	for i = 1, 10, 1 do
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and 
		(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and
		(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
		(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
		(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena") and
		(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
		(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player")) and
		(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive()) then 
			local bar = barGroups[i]:GetBar(sender .. "_" .. spellId)
			if bar then 
				if self.db.profile.frames[i].permanent and force == nil then 
					bar:SetTimer(0.1, bar.maxValue, true)
				elseif force == nil then 
					bar:SetTimer(0.1, bar.maxValue, true)
				else 
					barGroups[i]:RemoveBar(bar) 
				end  
			end
		else
			barGroups[i]:Hide();
		end
	end self:UpdateDisplay()
end

function mod:RaidUpdate(newPlayers,leftPlayers,index)
	if not barGroups then return false end
	local _,zone2=IsInInstance()
	self = mod
	for i = 1, 10, 1 do
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and
			(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and
			(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena") and
			(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
			(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player")) and
			(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive()) and
			self.db.profile.frames[i].permanent and (not index or index == i) then
			local bars = barGroups[i]:GetBars()
			if type(bars) == "table" then
				for key, bar in pairs(bars) do
					if (leftPlayers ~= nil and leftPlayers[bar.caster]) or
						(not UnitInRaid(bar.caster) and not UnitInParty(bar.caster) and
						UnitName("arena1") ~= bar.caster and
						UnitName("arena2") ~= bar.caster and
						UnitName("arena3") ~= bar.caster and
						UnitName("arena4") ~= bar.caster and
						UnitName("arena5") ~= bar.caster) then
						if bar.ready then
							barGroups[i]:RemoveBar(key)
						else
							bar.permanent = nil
						end 
					end
				end
			end
			
			if type(newPlayers) == "table" then
				for player, v in pairs(newPlayers) do
					local _, class = CustomUnitClass(player)
					if FatCooldowns.cooldowns[class] and not (UnitName("player") == player and self.db.profile.frames[i].hideSelf) and not (self.db.profile.frames[i].onlySelf and UnitName("player") ~= player) and (not self.db.profile.MaxLvL or (self.db.profile.MaxLvL and ((UnitLevel(player) == 80 and FatCooldowns.ExPac == 2) or (UnitLevel(player) == 70 and FatCooldowns.ExPac == 1) or (UnitLevel(player) == 60 and FatCooldowns.ExPac == 0)))) then
						for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
							local TankCDFound = 0
							for spellName2, spellTable2 in pairs(FatCooldowns.cooldowns["Tank Only Cooldowns"]) do
								if spellTable2.realid == spellTable.id and LGT:GetUnitRole(player) == "tank" then TankCDFound = spellTable2.id break end
							end
							if ((self.db.profile.frames[i].spells[spellTable.id] and not spellTable.spec) or (TankCDFound ~= 0 and self.db.profile.frames[i].spells[TankCDFound])) and not spellTable.ExpacHide[FatCooldowns.ExPac] then
								local bar = barGroups[i]:GetBar(player .. "_" .. spellTable.id)
								if bar == nil then
									local maxsenderl = self.db.profile.frames[i].maxTextLength;
									local labelcooldownnewplayer = self.db.profile.ColorCaster and FCDColorName2(string.sub(player,1,maxsenderl), player) or string.sub(player,1,maxsenderl)
									if self.db.profile.frames[i].HideLabel then labelcooldownnewplayer = "" end
									if self.db.profile.frames[i].SpellNameLabel then labelcooldownnewplayer = GetSpellInfo(spellTable.id) end					
									local bar = barGroups[i]:NewTimerBar((player .. "_" .. spellTable.id), labelcooldownnewplayer, 0.5, spellTable.cd, spellTable.id)
													
									bar:SetScript("OnMouseUp", buttonClick)
									bar:EnableMouse(not self.db.profile.unclickable)
									bar.permanent = true 
									bar.caster  = player

									if self.db.profile.ColorCaster then bar.castercolor = FCDColorName2(string.sub(player,1,self.db.profile.frames[i].maxTextLength), player) end
									if self.db.profile.removeglow then bar.spark:SetTexture(nil) end
									if self.db.profile.FillBackGround then bar.FillBackground = true elseif not self.db.profile.FillBackGround then bar.FillBackground = false end
									if self.db.profile.FillBars then bar.fill = true elseif not self.db.profile.FillBars then bar.fill = false end
									
									if self.db.profile.iconzoom then bar.icon:SetTexCoord(0.08,0.92,0.08,0.92) else bar.icon:SetTexCoord(0,1,0,1) end
									bar.spellId = spellTable.id
									bar.time = 0.5
									bar:SetTexture(Media:Fetch("statusbar", self.db.profile.texture))
									local _, c = CustomUnitClass(player)
									if not c then
										for k, v in pairs(FatCooldowns.cooldowns) do
											for k2, v2 in pairs(v) do
												if v2.id == spellId then
													c = k
												end
											end
										end
									end

									if self.db.profile.CustomNameColor then
										if bar:GetLabel() ~= nil then bar:SetLabel(self:FCDColorText(bar:GetLabel(), self.db.profile.CustomNameColorPicked.r, self.db.profile.CustomNameColorPicked.g, self.db.profile.CustomNameColorPicked.b)) end
										if bar:GetLabel2() ~= nil then bar:SetLabel(self:FCDColorText(bar:GetLabel(), self.db.profile.CustomNameColorPicked.r, self.db.profile.CustomNameColorPicked.g, self.db.profile.CustomNameColorPicked.b)) end
									end
									if self.db.profile.frames[i].BarBackground then
										bar.bgtexture:Hide() bar.texture:Hide() bar.timerLabel:Hide() barGroups[i]:SetWidth(1) self.db.profile.frames[i].anchor = false barGroups[i]:HideAnchor()
									else
										bar.bgtexture:Show() bar.texture:Show() bar.timerLabel:Show() barGroups[i]:SetWidth(self.db.profile.frames[i].width) 
									end
									if RC:GetRange(bar.caster) ~= nil and RC:GetRange(bar.caster) >= 80 then
										if self.db.profile.frames[i].opacity == nil then self.db.profile.frames[i].opacity = 100 end
										bar.barop = self.db.profile.frames[i].opacity / 100 
										bar:SetAlpha(self.db.profile.frames[i].opacity / 100)
									else
										bar.barop = self.db.profile.frames[i].alpha / 100
									end	

									local color = RAID_CLASS_COLORS[c]
									if bar.spellId == 70337 then color = {r = 0.1, g = 0.9, b = 0.1} end -- np
									if bar.spellId == 72143 then color = {r = 0.64, g = 0.41, b = 0.18} end -- enrage
									if bar.spellId == 99038 then
										if bar.whoringinfo == 4 then color = {r = 0.64, g = 0.21, b = 0.93} -- loot timer
										elseif bar.whoringinfo == 3 then color = {r = 0.00, g = 0.44, b = 0.87} end -- loot timer
									end
									if type(color) == "table" and not self.db.profile.CustomBarColor then
										bar:SetColorAt(1.00, color.r, color.g, color.b, 1)
										bar:SetColorAt(0.00, color.r, color.g, color.b, 1)
									elseif self.db.profile.CustomBarColor then
										bar:SetColorAt(1.00, self.db.profile.CustomBarColorPicked.r, self.db.profile.CustomBarColorPicked.g, self.db.profile.CustomBarColorPicked.b, self.db.profile.CustomBarColorPicked.a)
										bar:SetColorAt(0.00, self.db.profile.CustomBarColorPicked.r, self.db.profile.CustomBarColorPicked.g, self.db.profile.CustomBarColorPicked.b, self.db.profile.CustomBarColorPicked.a)
									end
								end
							end						
						end
					end
				end
			end
		end
	end
	self:ScheduleTimer(function() mod:UpdateDisplay() end, 1)
	return true;
end

function mod:welcome()
	FatCooldowns:GetModule("Display"):FCDPrefixPrint("Welcome to FCD |cffff7d0aShekles|r Version (v"..FatCooldowns.FCDVer.."), Please report bugs to |cffff7d0aShekles|r.")
	if GetLocale() ~= "enUS" then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD Warning: you are not using the English client a lot of options will not work") end

	LGT:RefreshTalentsByUnit("player")
	self:UpdateDisplay()
	if self.db.profile.AltTab then FatCooldowns:ResetSound(1) end
	OpenCalendar()

	if FatCooldowns:GetModule("Display").db.profile.CWEWho then
		for GuildIndex, GuildName in pairs(FatCooldowns:GetModule("Display").db.profile.CWEAltGuildsSaved) do
			wholib:AskWho({query = 'g-' .. GuildName, queue = wholib.WHOLIB_QUEUE_QUIET, callback = ChatWhisperBlockerWhoLib })
		end
	end

    self:JoinChannelIfNeeded()
    
	local weekday, month, day, year = CalendarGetDate()
	for player, value in pairs(self.db.profile.StoreClaSSInfoExtra) do
		if value.month ~= month then self.db.profile.StoreClaSSInfoExtra[player] = nil end
	end
end

function mod:raidupdatetimer()
	self:ScheduleTimer("raidupdatetimer", 40)
	if not UnitAffectingCombat("player") and UnitInRaid("player") then self:UpdateDisplay() end

	if not UnitAffectingCombat("player") and UnitName("boss1") == nil and not IsStealthed() and not UnitBuff("player", "Vanish") and not UnitBuff("player", "Feign Death") and not UnitBuff("player", "Invisibility") then
		for k,v in pairs(AntiSpamCleave) do
			AntiSpamCleave[k] = nil
		end
	end
end

function mod:ignorelistclear()
	if self.db.profile.reporter[99802] then
		for i=1, GetNumIgnores() do
			if i > 0 then
				name = GetIgnoreName(i)
				DelIgnore(name)
			end
		end
	end
end

function table.removekey(table, key)
   local element = table[key]
   table[key] = nil
   return element
end

function mod:MissingSettings()
	local temptablesettings = {}
	for key,val in pairs(defaults.profile.frames[1]) do
		temptablesettings[key] = val
	end
	for i = 1, 10, 1 do
		if i > 1 and i <= self.db.profile.frameCount then
			if self.db.profile.frames[i].maxTextLength == 12 then self.db.profile.frames[i].maxTextLength = 99 end
			if self.db.profile.frames[i].fontsize == nil or self.db.profile.frames[i].fontsize == 0 then self.db.profile.frames[i].fontsize = 10 end
			for key2,val2 in pairs(FatCooldowns:GetModule("Display").db.profile.frames[i]) do
				if temptablesettings[key2] == nil and key2 ~= "posX" and key2 ~= "posY" and key2 ~= "spells" then
					table.removekey(FatCooldowns:GetModule("Display").db.profile.frames[i],key2)
				end
			end
			for key3,val3 in pairs(temptablesettings) do
				if FatCooldowns:GetModule("Display").db.profile.frames[i][key3] == nil then FatCooldowns:GetModule("Display").db.profile.frames[i][key3] = val3 end
			end
			if next(self.db.profile.soundspellsoptions) then
				for e, v in pairs(self.db.profile.soundspellsoptions) do
					if next(self.db.profile.soundspellsoptions[e]) then
						for i, c in pairs(self.db.profile.soundspellsoptions[e]) do 
							if i == "PlayerClass" then
								if next(c) then
									for n, l in pairs(c) do
										if n == "DEATHKNIGHT" then
											c["DEATH KNIGHT"] = l
											c[n] = nil
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
	temptablesettings = nil
end

local FNDTimer = nil
function mod:DrinksAndFood()
	if FNDTimer == nil or (FNDTimer ~= nil and GetTime() - FNDTimer > 3.5) then
		self:ScheduleTimer(function() FatCooldowns:TRADE_SHOW()  end, 4)
		FNDTimer = GetTime()
	end
end

local function countItem(item)
	local c = 0
	for x = 0, 4 do 
		for y = 1, GetContainerNumSlots(x) do
			local ItemID = GetContainerItemID(x,y)
			local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue = GetContainerItemInfo(x,y)
			if ItemID ~= nil and item == ItemID then c = c + itemCount end
		end
	end
	return c
end

local TradeButtonsData = false
local TradeButtonsDatatexture = false
function mod:TradeButtons()
	if not TradeFrame or (TradeFrame and not TradeFrame:IsVisible()) then return end
	local SpellToCast = 0
	if FatCooldowns:GetModule("Display").db.profile.TradeButtons and UnitClass("player") == L["Mage"] then
		if not TradeButtonsData then
			local ItemIDDrinks, SpellIDDrinks, AmountD, ClassNPC = FatCooldowns:FillTrade(false,false,false,false,"MageDrinks")
			local ItemIDFood, SpellIDFood, AmountF, ClassNPC = FatCooldowns:FillTrade(false,false,false,false,"MageFood")
			local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(SpellIDDrinks)
			local name2, rank2, icon2, castTime2, minRange2, maxRange2, spellID2 = GetSpellInfo(SpellIDFood)
			
			local FCDTradebtn = CreateFrame("Button", "FCDTradeButtonCreate", TradeFrame,"SecureActionButtonTemplate")
			FCDTradebtn:SetPoint("BOTTOMLEFT", TradeFrameCloseButton, "BOTTOMLEFT", 29, -15)
			FCDTradebtn:SetSize(40,40)
			
			local FCDTradebtntexture = FCDTradebtn:CreateTexture("FCDTradeButtonCreateTexture", "BACKGROUND")
			FCDTradebtntexture:SetAllPoints()
			FCDTradebtntexture:SetTexCoord(0.08,0.92,0.08,0.92)

			if countItem(ItemIDDrinks) < AmountD and self.db.profile.TradeDrinkClasses[ClassNPC] ~= nil and self.db.profile.TradeDrinkClasses[ClassNPC] then
				SpellToCast = 1
			elseif countItem(ItemIDFood) < AmountD and self.db.profile.TradeFoodClasses[ClassNPC] ~= nil and self.db.profile.TradeFoodClasses[ClassNPC] then
				SpellToCast = 2
			end

			if SpellToCast == 1 then
				if rank ~= nil and rank ~= "" then rank = "("..rank..")" else rank = "" end
				FCDTradebtn:SetAttribute("type","macro")
				FCDTradebtn:SetAttribute("macrotext","/fcd drinksandfood\n/cast "..name..rank)
				FCDTradebtntexture:SetTexture(icon)
			elseif SpellToCast == 2 then
				if rank2 ~= nil and rank2 ~= "" then rank2 = "("..rank2..")" else rank2 = "" end
				FCDTradebtn:SetAttribute("type","macro")
				FCDTradebtn:SetAttribute("macrotext","/fcd drinksandfood\n/cast "..name2..rank2)
				FCDTradebtntexture:SetTexture(icon2)
			end
			TradeButtonsData = FCDTradebtn
			TradeButtonsDatatexture = FCDTradebtntexture
		else
			local ItemIDDrinks, SpellIDDrinks, AmountD, ClassNPC = FatCooldowns:FillTrade(false,false,false,false,"MageDrinks")
			local ItemIDFood, SpellIDFood, AmountF, ClassNPC = FatCooldowns:FillTrade(false,false,false,false,"MageFood")
			local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(SpellIDDrinks)
			local name2, rank2, icon2, castTime2, minRange2, maxRange2, spellID2 = GetSpellInfo(SpellIDFood)

			if countItem(ItemIDDrinks) < AmountD and self.db.profile.TradeDrinkClasses[ClassNPC] ~= nil and self.db.profile.TradeDrinkClasses[ClassNPC] then
				SpellToCast = 1
			elseif countItem(ItemIDFood) < AmountD and self.db.profile.TradeFoodClasses[ClassNPC] ~= nil and self.db.profile.TradeFoodClasses[ClassNPC] then
				SpellToCast = 2
			else
				SpellToCast = 0
			end

			if SpellToCast == 1 then
				if rank ~= nil and rank ~= "" then rank = "("..rank..")" else rank = "" end
				TradeButtonsData:SetAttribute("type","macro")
				TradeButtonsData:SetAttribute("macrotext","/fcd drinksandfood\n/cast "..name..rank)
				TradeButtonsDatatexture:SetTexture(icon)
			elseif SpellToCast == 2 then
				if rank2 ~= nil and rank2 ~= "" then rank2 = "("..rank2..")" else rank2 = "" end
				TradeButtonsData:SetAttribute("type","macro")
				TradeButtonsData:SetAttribute("macrotext","/fcd drinksandfood\n/cast "..name2..rank2)
				TradeButtonsDatatexture:SetTexture(icon2)
			end
		end
	elseif FatCooldowns:GetModule("Display").db.profile.TradeButtons and UnitClass("player") == L["Rogue"] then
		if not TradeButtonsData then
			local FCDTradebtn = CreateFrame("Button", "FCDTradeButtonCreate", TradeFrame,"SecureActionButtonTemplate")
			FCDTradebtn:SetPoint("BOTTOMLEFT", TradeFrameCloseButton, "BOTTOMLEFT", 29, -15)
			FCDTradebtn:SetSize(40,40)
			
			local FCDTradebtntexture = FCDTradebtn:CreateTexture("FCDTradeButtonCreateTexture", "BACKGROUND")
			FCDTradebtntexture:SetAllPoints()
			FCDTradebtntexture:SetTexCoord(0.08,0.92,0.08,0.92)
			FCDTradebtn:SetAttribute("type","macro")
			FCDTradebtn:SetAttribute("macrotext","/cast pick lock\n/click TradeRecipientItem7ItemButton")
			FCDTradebtntexture:SetTexture(icon)

			SpellToCast = 1
			
			TradeButtonsData = FCDTradebtn
			TradeButtonsDatatexture = FCDTradebtntexture
		end
	elseif FatCooldowns:GetModule("Display").db.profile.TradeButtons and UnitClass("player") == L["Warlock"] then
		if not TradeButtonsData then
			local TradeableStone, SpellFromItemStone, ClassNPC = FatCooldowns:FillTrade(false,false,false,false,"HealthStone")
			local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(SpellFromItemStone)

			local FCDTradebtn = CreateFrame("Button", "FCDTradeButtonCreate", TradeFrame,"SecureActionButtonTemplate")
			FCDTradebtn:SetPoint("BOTTOMLEFT", TradeFrameCloseButton, "BOTTOMLEFT", 29, -15)
			FCDTradebtn:SetSize(40,40)
			
			local FCDTradebtntexture = FCDTradebtn:CreateTexture("FCDTradeButtonCreateTexture", "BACKGROUND")
			FCDTradebtntexture:SetAllPoints()
			FCDTradebtntexture:SetTexCoord(0.08,0.92,0.08,0.92)

			if rank ~= nil and rank ~= "" then rank = "("..rank..")" else rank = "" end

			FCDTradebtn:SetAttribute("type","macro")
			FCDTradebtn:SetAttribute("macrotext","/fcd drinksandfood\n/cast "..name..rank)
			FCDTradebtntexture:SetTexture(icon)

			if countItem(6265) > 0 and self.db.profile.TradeStone[ClassNPC] ~= nil and self.db.profile.TradeStone[ClassNPC] then SpellToCast = 1 end

			TradeButtonsData = FCDTradebtn
			TradeButtonsDatatexture = FCDTradebtntexture
		else
			local TradeableStone, SpellFromItemStone, ClassNPC = FatCooldowns:FillTrade(false,false,false,false,"HealthStone")
			local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(SpellFromItemStone)
			
			if rank ~= nil and rank ~= "" then rank = "("..rank..")" else rank = "" end

			FCDTradebtn:SetAttribute("type","macro")
			FCDTradebtn:SetAttribute("macrotext","/fcd drinksandfood\n/cast "..name..rank)
			FCDTradebtntexture:SetTexture(icon)

			if countItem(6265) > 0 and self.db.profile.TradeStone[ClassNPC] ~= nil and self.db.profile.TradeStone[ClassNPC] then SpellToCast = 1 else SpellToCast = 0 end

			TradeButtonsData = FCDTradebtn
			TradeButtonsDatatexture = FCDTradebtntexture
		end
	end
	if TradeButtonsData then if FatCooldowns:GetModule("Display").db.profile.TradeButtons and SpellToCast ~= 0 then TradeButtonsData:Show() else TradeButtonsData:Hide() end end
end

local elapsed = 0
local Spammer = CreateFrame("Frame")
function mod:FCDSpammerMessage()
    local totalWeight = 0
    for _, item in ipairs(FatCooldowns:GetModule("Display").db.profile.SpammerTable) do
        if item.enable and item.msg ~= "" then totalWeight = totalWeight + item.prio end
    end
    if totalWeight ~= 0 then
	    local rand = math.random(1, totalWeight)
	    local cumulativeWeight = 0
	    for _, item in ipairs(FatCooldowns:GetModule("Display").db.profile.SpammerTable) do
	        cumulativeWeight = cumulativeWeight + item.prio
	        if rand <= cumulativeWeight and item.enable and item.msg ~= "" then
	        	local IsChannel = 0
	        	for i = 1, 10 do
					local TempChannelID, TempChannelName = GetChannelName(i)
	        		if item.channel == TempChannelName then IsChannel = i end
	        	end
	        	if IsChannel ~= 0 then
	        		FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(item.msg, "CHANNEL", nil, IsChannel)
	        	else
	        		FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(item.msg, item.channel,nil,nil)
	        	end
	            return
	        end
	    end
	end
end

Spammer:SetScript("OnUpdate", function(self, elapsedTime)
    elapsed = elapsed + elapsedTime
    if elapsed >= FatCooldowns:GetModule("Display").db.profile.SpammerTime then
        FatCooldowns:GetModule("Display"):FCDSpammerMessage()
        elapsed = 0
    end
end)


local LoadEU = true
local E, _, V, P, G
function mod:PLAYER_ENTERING_WORLD() -- triggers when change instance
	FatCooldowns:GetModule("Chat"):Chatfiltercheck()
	if IsAddOnLoaded("ElvUI") and FatCooldowns:GetModule("Display").db.profile.ChatFilterReporter2[99917] then
		if LoadEU then E, _, V, P, G = unpack(ElvUI) LoadEU = false end
		E.private.general.chatBubbles = FatCooldowns:GetModule("Display").db.profile.ElvUiCB
		local M = E:GetModule("Misc")
		M:LoadChatBubbles()
	end
	self:UpdateTextureLinkFormat()
	FatCooldowns.LogInTime = GetTime()
end

function mod:FCDDelPopup() 
	local FCDDelPopupInfo = StaticPopupDialogs["DELETE_ITEM"]
	if FatCooldowns:GetModule("Display").db.profile.EnablePopup then
		FCDDelPopupInfo.text = DELETE_ITEM .. "\n\n\n"
		FCDDelPopupInfo.button3 = "FCD: Sell List"
		FCDDelPopupInfo.OnAlt = function(self) 
			local infoType, itemID, ItemLink = GetCursorInfo()
			if ItemLink and infoType and infoType == "item" and itemID then
				local ItemID = select(3,strfind(ItemLink, "|H(.+):.+|h%["))
				FatCooldowns:GetModule("Display").db.profile.SellList2[ItemID] = ItemID
				DeleteCursorItem()
			end
		end
	else
		FCDDelPopupInfo.text = DELETE_ITEM
		FCDDelPopupInfo.button3 = nil
		FCDDelPopupInfo.OnAlt = nil
	end
	local FCDDelPopupInfo = StaticPopupDialogs["DELETE_GOOD_ITEM"]
	if FatCooldowns:GetModule("Display").db.profile.EnablePopup then
		FCDDelPopupInfo.text = DELETE_GOOD_ITEM .. "\n\n"
		FCDDelPopupInfo.button3 = "FCD: Sell List"
		FCDDelPopupInfo.OnAlt = function(self) 
			local infoType, itemID, ItemLink = GetCursorInfo()
			if ItemLink and infoType and infoType == "item" and itemID then
				local ItemID = select(3,strfind(ItemLink, "|H(.+):.+|h%["))
				FatCooldowns:GetModule("Display").db.profile.SellList2[ItemID] = ItemID
				DeleteCursorItem()
			end
		end
	else
		FCDDelPopupInfo.text = DELETE_GOOD_ITEM
		FCDDelPopupInfo.button3 = nil
		FCDDelPopupInfo.OnAlt = nil
	end
end

function mod:CMasterLooterWindow() 
	if self.db.profile.CustomMasterLooterWindow then UIDropDownMenu_Initialize(GroupLootDropDown, init, "MENU") 
	elseif self.db.profile.CustomMasterLooterWindowV2 then UIDropDownMenu_Initialize(GroupLootDropDown, init2, "MENU") end
end

function mod:GuildInv()
	if self.db.profile.GuildInvMessage then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(self.db.profile.GuildInvMessage, "GUILD") end
	local Ranks = {}
	local RaidPlaerys = {}
	for i = 1, GuildControlGetNumRanks() do
		local rankName = GuildControlGetRankName(i)
		if Ranks[rankName] == nil then Ranks[rankName] = i end
	end
	for i = 1, GetNumGuildMembers() do
		local name, rankName, _, level, _, _, _, _, online = GetGuildRosterInfo(i)
		if online and level == 80 and name ~= UnitName("player") and not UnitInRaid(name) then
			if self.db.profile.GuildInviteButton[GetGuildInfo("player")] ~= nil then
				if Ranks[rankName] <= Ranks[self.db.profile.GuildInviteButton[GetGuildInfo("player")]] then
					RaidPlaerys[name] = name
				end
			else
				RaidPlaerys[name] = name
			end
		end
	end
	FatCooldowns:ReMakeCurrentRaid(RaidPlaerys)
end

function mod:DisbandRaid()
	for i=1, GetNumRaidMembers() do
		if UnitInRaid("player") and UnitName("raid"..i) ~= UnitName("player") then
			UninviteUnit("raid"..i, " Disbanding Raid")
		end
	end
end

function mod:GuildInvDisable(FCDbtn)
	if GInvName == 0 then 
		GInvName = nil
		FCDbtn:Enable()
		FCDbtn:SetText("Guild Invite")
	elseif GInvName == nil then
		GInvName = 15
		FCDbtn:Disable()
		FCDbtn:SetText("("..GInvName..")")
		self:ScheduleTimer(function() self:GuildInvDisable(FCDbtn) end, 1)
	else
		if GInvName == 7 then FatCooldowns:GetModule("Display"):GuildInv()  end
		GInvName = GInvName - 1
		FCDbtn:SetText("("..GInvName..")")
		self:ScheduleTimer(function() self:GuildInvDisable(FCDbtn) end, 1)
	end
end

function ButtonControl()
	if UnitInRaid("player") and IsRaidOfficer() then
		RaidFrameRaidBrowserButton:Hide()
	else
		RaidFrameRaidBrowserButton:Show()
	end
end

local GInvName = nil
local RGFDone = false
local RGFDone2 = nil
function mod:UpdateRF()
	if not RaidFrame or not RaidFrameRaidBrowserButton then return end
	if IsRaidOfficer() then
		if FatCooldowns:GetModule("Display").db.profile.EnableGDButton or FatCooldowns:GetModule("Display").db.profile.EnableGDisButton then
			RaidFrameRaidBrowserButton:SetScript("OnUpdate", ButtonControl)
			RaidFrameRaidBrowserButton:SetScript("OnEvent", ButtonControl)
		end
		if FatCooldowns:GetModule("Display").db.profile.EnableGDButton then
			if not RGFDone then
				local FCDbtn = CreateFrame("Button","GInviteFCDbtn",RaidFrame,"UIPanelButtonTemplate")
				FCDbtn:SetSize(RaidFrameRaidBrowserButton:GetSize())
				FCDbtn:SetText("Guild Invite")
				FCDbtn:SetPoint("BOTTOMLEFT", RaidFrameRaidBrowserButton, "BOTTOMLEFT", 0, 0)
				FCDbtn:SetScript("OnClick", function()
					if GetNumGuildMembers() == 0 then FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: you are not in a guild") return end
					FatCooldowns.GuildInviteButtonPressed = GetTime()
					if self.db.profile.GuildInvMessage2 then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(self.db.profile.GuildInvMessage2, "GUILD") end
					FatCooldowns:ScheduleTimer(function()
							if self.db.profile.GuildInvMessage3 then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage(self.db.profile.GuildInvMessage3, "GUILD") end
					end, 5)
					FatCooldowns:ScheduleTimer(function() FatCooldowns:GetModule("Display"):GuildInvDisable(FCDbtn) FatCooldowns:GetModule("Display"):GuildInv() end, 10)		
				end)
				FCDbtn:SetNormalFontObject(GameFontNormalSmall)
				FCDbtn:SetHighlightFontObject(GameFontHighlightSmall)
				RGFDone = FCDbtn
			end
		end
		if FatCooldowns:GetModule("Display").db.profile.EnableGDisButton then
			if not RGFDone2 then
				local FCDbtn2 = CreateFrame("Button","DisbandRaidFCDbtn",RaidFrame,"UIPanelButtonTemplate")
				FCDbtn2:SetSize(RaidFrameRaidBrowserButton:GetSize())
				FCDbtn2:SetText("Dispand Raid")
				FCDbtn2:SetPoint("BOTTOMLEFT", RaidFrameRaidBrowserButton, "TOPLEFT", 0, 2)
				FCDbtn2:SetScript("OnClick", function()
					StaticPopupDialogs["Disband_the_raid"] = {
						text = "Do you want to Disband the Raid?",
						button1 = "Yes",
						button2 = "No",
						OnAccept = function()
							if IsRaidLeader() then
								if UnitInRaid("player") then FatCooldowns:GetModule("Display"):FCDPrefixSendChatMessage("Disbanding Raid", RAID) end
						    	FatCooldowns:GetModule("Display"):DisbandRaid()
							else
								FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: you are not the raid leader")
							end
					 	end,
						timeout = 0,
						whileDead = true,
						hideOnEscape = true,
					}
					StaticPopup_Show("Disband_the_raid")
				end)
				FCDbtn2:SetNormalFontObject(GameFontNormalSmall)
				FCDbtn2:SetHighlightFontObject(GameFontHighlightSmall)
				RGFDone2 = FCDbtn2
			end
		end
		if RGFDone then if FatCooldowns:GetModule("Display").db.profile.EnableGDButton then RGFDone:Show() else RGFDone:Hide() end end
		if RGFDone2 then if FatCooldowns:GetModule("Display").db.profile.EnableGDisButton then RGFDone2:Show() else RGFDone2:Hide() end end
	else
		if RGFDone then RGFDone:Hide() end
		if RGFDone2 then RGFDone2:Hide() end
	end
end

function mod:MFSellITemAddSellList2()
	local maxitem = 0
	for i = 1, 12, 1 do
		if GetBuybackItemInfo(i) ~= nil then maxitem = i end
	end
	if maxitem ~= 0 then
		local itemLink = GetBuybackItemLink(maxitem)
		local ItemName, itemLink2, itemRarity = GetItemInfo(itemLink)
		local ItemID = select(3,strfind(itemLink, "|H(.+):.+|h%["))
		if ItemName ~= nil and itemRarity ~= 0 then
			FatCooldowns:GetModule("Display").db.profile.SellList2[ItemID] = ItemID
			FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Added to Sell List "..itemLink2)
		end
	end
end

local MFDone = false
function mod:UpdateMF()
	if not MerchantFrameTab2 or not FatCooldowns:GetModule("Display").db.profile.EnablePopup then return end
	if not MFDone then
		local FCDbtn3 = CreateFrame("Button","MFFCDSellList2",MerchantFrame, "UIPanelButtonTemplate")
		FCDbtn3:SetSize(100, 25)
		FCDbtn3:SetText("FCD: Sell List")
		FCDbtn3:SetPoint("BOTTOMRIGHT", MerchantMoneyFrame, "BOTTOMRIGHT", 0, -30)
		FCDbtn3:SetScript("OnClick", function() FatCooldowns:GetModule("Display"):MFSellITemAddSellList2() end)
		FCDbtn3:SetNormalFontObject(GameFontNormalSmall)
		FCDbtn3:SetHighlightFontObject(GameFontHighlightSmall)
		FCDbtn3:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:ClearLines()
			GameTooltip:SetText("Adds the last sold item to the auto sell list", 1, .82, 0, 1)
			GameTooltip:Show()
		end)
		FCDbtn3:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		MFDone = FCDbtn3
	elseif MFDone then
		MFDone:Show()
	end
end

function mod:BuyItemFromBF(BFItem)
	local Amount = FatCooldowns:GetModule("Display").db.profile.BadagesBarCount
	if BFItem == nil then return end
	if BFItem == "Emblem of Triumph" then
		for i=1, GetMerchantNumItems() do
			if GetMerchantItemInfo(i) == "Emblem of Triumph" then 
				BuyMerchantItem(i,Amount)
			end
		end
	elseif BFItem == "Emblem of Conquest" then
		for i=1, GetMerchantNumItems() do
			if GetMerchantItemInfo(i) == "Emblem of Conquest" then 
				BuyMerchantItem(i,Amount)
			end
		end
	elseif BFItem == "Emblem of Valor" then
		for i=1, GetMerchantNumItems() do
			if GetMerchantItemInfo(i) == "Emblem of Valor" then 
				BuyMerchantItem(i,Amount)
			end
		end
	elseif BFItem == "Emblem of Heroism" then
		for i=1, GetMerchantNumItems() do
			if GetMerchantItemInfo(i) == "Emblem of Heroism" then 
				BuyMerchantItem(i,Amount)
			end
		end
	elseif BFItem == "Wintergrasp Commendation" then
		for i=1, GetMerchantNumItems() do
			if GetMerchantItemInfo(i) == "Wintergrasp Commendation" then 
				local itemTexture, itemValue, itemLink, currencyName = GetMerchantItemCostItem(i, 1)
				if itemValue == 30 then
					BuyMerchantItem(i,1)
				end
			end
		end
	elseif BFItem == "Primordial Saronite" then
		for i=1, GetMerchantNumItems() do
			if GetMerchantItemInfo(i) == "Primordial Saronite" then 
				BuyMerchantItem(i,1)
			end
		end
	end
end

local BFDone = false
local BFDone2 = nil
local BFDone3 = nil
local BFDone4 = nil
local BFDone5 = nil
local BFDone6 = nil
function mod:UpdateBFHideShow()
	for i=1, GetMerchantNumItems() do
		if GetMerchantItemInfo(i) == "Emblem of Triumph" then BFDone:Show() end
		if GetMerchantItemInfo(i) == "Emblem of Conquest" then BFDone2:Show() end
		if GetMerchantItemInfo(i) == "Emblem of Valor" then BFDone3:Show() end
		if GetMerchantItemInfo(i) == "Emblem of Heroism" then BFDone4:Show() end
		if GetMerchantItemInfo(i) == "Wintergrasp Commendation" then BFDone5:Show() end
		if GetMerchantItemInfo(i) == "Primordial Saronite" then BFDone6:Show() end
	end
end

function mod:UpdateBF()
	if not MerchantFrameTab2 or not FatCooldowns:GetModule("Display").db.profile.BadagesBar then return end
	if not BFDone then
		local FCDbtn10 = CreateFrame("Button","BFBar2",MerchantFrame, nil) -- Triumph
		FCDbtn10:SetSize(60, 20)
		FCDbtn10:SetPoint("TOP", MerchantFrameCloseButton, "TOP", 40, -60)
		FCDbtn10:SetScript("OnClick", function()
			if not FatCooldowns:GetModule("Display").db.profile.BadagesBarConfirm then
				self:BuyItemFromBF("Emblem of Triumph")
			else
			StaticPopupDialogs["Emblem_of_Triumph"] = {
				text = "Do you want to Buy "..FatCooldowns:GetModule("Display").db.profile.BadagesBarCount.." of Emblem of Triumph",
				button1 = "Yes",
				button2 = "No",
				OnAccept = function() self:BuyItemFromBF("Emblem of Triumph") end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				}
				StaticPopup_Show("Emblem_of_Triumph")
			end
		end)
		FCDbtn10:SetHighlightTexture(nil)
		local FCDbtn10T = FCDbtn10:CreateTexture(nil, "OVERLAY")
		FCDbtn10T:SetTexture("Interface\\AddOns\\FatCooldowns\\icons\\ExtraB\\Frost")
		FCDbtn10T:SetAllPoints()	

		local FCDbtn5 = CreateFrame("Button","BFBar3",MerchantFrame, nil) --Conquest
		FCDbtn5:SetSize(60, 20)
		FCDbtn5:SetPoint("TOPLEFT", BFBar2, "BOTTOMLEFT", 0, -10)
		FCDbtn5:SetScript("OnClick", function()
			if not FatCooldowns:GetModule("Display").db.profile.BadagesBarConfirm then
				self:BuyItemFromBF("Emblem of Conquest")
			else
			StaticPopupDialogs["Emblem_of_Conquest"] = {
				text = "Do you want to Buy "..FatCooldowns:GetModule("Display").db.profile.BadagesBarCount.." of Emblem of Conquest",
				button1 = "Yes",
				button2 = "No",
				OnAccept = function() self:BuyItemFromBF("Emblem of Conquest") end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				}
				StaticPopup_Show("Emblem_of_Conquest")
			end
		end)
		FCDbtn5:SetHighlightTexture(nil)
		local FCDbtn5T = FCDbtn5:CreateTexture(nil, "OVERLAY")
		FCDbtn5T:SetTexture("Interface\\AddOns\\FatCooldowns\\icons\\ExtraB\\Triumph")
		FCDbtn5T:SetAllPoints()	

		local FCDbtn6 = CreateFrame("Button","BFBar4",MerchantFrame, nil) -- Valor
		FCDbtn6:SetSize(60, 20)
		FCDbtn6:SetPoint("TOPLEFT", BFBar3, "BOTTOMLEFT", 0, -10)
		FCDbtn6:SetScript("OnClick", function()
						if not FatCooldowns:GetModule("Display").db.profile.BadagesBarConfirm then
				self:BuyItemFromBF("Emblem of Valor")
			else
			StaticPopupDialogs["Emblem_of_Valor"] = {
				text = "Do you want to Buy "..FatCooldowns:GetModule("Display").db.profile.BadagesBarCount.." of Emblem of Valor",
				button1 = "Yes",
				button2 = "No",
				OnAccept = function() self:BuyItemFromBF("Emblem of Valor") end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				}
				StaticPopup_Show("Emblem_of_Valor")
			end
		end)
		FCDbtn6:SetHighlightTexture(nil)
		local FCDbtn6T = FCDbtn6:CreateTexture(nil, "OVERLAY")
		FCDbtn6T:SetTexture("Interface\\AddOns\\FatCooldowns\\icons\\ExtraB\\Conquest")
		FCDbtn6T:SetAllPoints()	

		local FCDbtn7 = CreateFrame("Button","BFBar5",MerchantFrame, nil) --Heroism
		FCDbtn7:SetSize(60, 20)
		FCDbtn7:SetPoint("TOPLEFT", BFBar4, "BOTTOMLEFT", 0, -10)
		FCDbtn7:SetScript("OnClick", function()
						if not FatCooldowns:GetModule("Display").db.profile.BadagesBarConfirm then
				self:BuyItemFromBF("Emblem of Heroism")
			else
			StaticPopupDialogs["Emblem_of_Heroism"] = {
				text = "Do you want to Buy "..FatCooldowns:GetModule("Display").db.profile.BadagesBarCount.." of Emblem of Heroism",
				button1 = "Yes",
				button2 = "No",
				OnAccept = function() self:BuyItemFromBF("Emblem of Heroism") end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				}
				StaticPopup_Show("Emblem_of_Heroism")
			end
		end)
		FCDbtn7:SetHighlightTexture(nil)
		local FCDbtn7T = FCDbtn7:CreateTexture(nil, "OVERLAY")
		FCDbtn7T:SetTexture("Interface\\AddOns\\FatCooldowns\\icons\\ExtraB\\Valor")
		FCDbtn7T:SetAllPoints()	

		local FCDbtn8 = CreateFrame("Button","BFBar6",MerchantFrame, nil) -- Wintergrasp Commendation VOA
		FCDbtn8:SetSize(60, 20)
		FCDbtn8:SetPoint("TOPLEFT", BFBar5, "BOTTOMLEFT", 0, -10)
		FCDbtn8:SetScript("OnClick", function()
						if not FatCooldowns:GetModule("Display").db.profile.BadagesBarConfirm then
				self:BuyItemFromBF("Wintergrasp Commendation")
			else
			StaticPopupDialogs["Wintergrasp_Commendation"] = {
				text = "Do you want to Buy Wintergrasp Commendation",
				button1 = "Yes",
				button2 = "No",
				OnAccept = function() self:BuyItemFromBF("Wintergrasp Commendation") end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				}
				StaticPopup_Show("Wintergrasp_Commendation")
			end
		end)
		FCDbtn8:SetHighlightTexture(nil)
		local FCDbtn8T = FCDbtn8:CreateTexture(nil, "OVERLAY")
		FCDbtn8T:SetTexture("Interface\\AddOns\\FatCooldowns\\icons\\ExtraB\\Mark")
		FCDbtn8T:SetAllPoints()	

		local FCDbtn9 = CreateFrame("Button","BFBar7",MerchantFrame, nil) -- Primordial Saronite
		FCDbtn9:SetSize(60, 20)
		FCDbtn9:SetPoint("TOPLEFT", BFBar6, "BOTTOMLEFT", 0, -10)
		FCDbtn9:SetScript("OnClick", function()
						if not FatCooldowns:GetModule("Display").db.profile.BadagesBarConfirm then
				self:BuyItemFromBF("Primordial Saronite")
			else
			StaticPopupDialogs["Primordial_Saronite"] = {
				text = "Do you want to Buy Primordial Saronite",
				button1 = "Yes",
				button2 = "No",
				OnAccept = function() self:BuyItemFromBF("Primordial Saronite") end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				}
				StaticPopup_Show("Primordial_Saronite")
			end
		end)
		FCDbtn9:SetHighlightTexture(nil)
		local FCDbtn9T = FCDbtn9:CreateTexture(nil, "OVERLAY")
		FCDbtn9T:SetTexture("Interface\\AddOns\\FatCooldowns\\icons\\ExtraB\\Primo")
		FCDbtn9T:SetAllPoints()

		BFDone = FCDbtn10
		BFDone2 = FCDbtn5
		BFDone3 = FCDbtn6
		BFDone4 = FCDbtn7
		BFDone5 = FCDbtn8
		BFDone6 = FCDbtn9
	end
		BFDone:Hide()
		BFDone2:Hide()
		BFDone3:Hide()
		BFDone4:Hide()
		BFDone5:Hide()
		BFDone6:Hide()
	self:UpdateBFHideShow()
end

local RegDone = false
function mod:RegHook()
	if RaidGroupFrame_Update and not RegDone then
		hooksecurefunc("RaidGroupFrame_Update",self.UpdateRF)
		hooksecurefunc("RaidGroupFrame_UpdateLevel",self.UpdateRF)
		RegDone = true
	end
end

function mod:UpdateIgnoreListSettings()
	FatCooldowns:IGNORELIST_UPDATE(nil,true)
end
function mod:UpdateFriendsListSettings()
	FatCooldowns:FRIENDLIST_UPDATE(nil,true)
end

function mod:JoinChannelIfNeeded()
	local MaxTabs = 0
	for ChannelName, ChannelTable in pairs(FatCooldowns:GetModule("Display").db.profile.ChannelNames) do
		for i = 1, 10 do
			if ChannelTable[i] ~= nil and ChannelTable[i] == true then
				if i > MaxTabs then MaxTabs = i end
			end
		end
	end

	for i = 1, MaxTabs do
		local TabName = GetChatWindowInfo(i)
		if TabName == nil or TabName == "" then
 			FCF_OpenNewWindow("Tab "..i)
    	end
	end

	for ChannelName, ChannelTable in pairs(FatCooldowns:GetModule("Display").db.profile.ChannelNames) do
		local IsFound = true
		for i = 1, 10 do
			local id, name = GetChannelName(i)
			if name == ChannelName then IsFound = false end
		end
		if IsFound then JoinChannelByName(ChannelName) end
		for i = 1, 10 do
			if IsFound and ChannelTable[i] ~= nil and ChannelTable[i] == true then
				ChatFrame_AddChannel(_G["ChatFrame"..i], ChannelName)
			elseif IsFound and ChannelTable[i] ~= nil and ChannelTable[i] == false then
				ChatFrame_RemoveChannel(_G["ChatFrame"..i], ChannelName)
			end
		end
	end
end

local RepeatRangeCheck = nil
function mod:PLAYER_LOGIN()
	self:ScheduleTimer("welcome", 6)
	self:ScheduleTimer("TalentItemScan", 8)
	self:ScheduleTimer("BuffChecker", 8)
	self:ScheduleTimer("raidupdatetimer", 8)
	FatCooldowns:GetModule("Chat"):Chatfiltercheck()
	self:ScheduleTimer("ignorelistclear", 6)
	self:ScheduleTimer("MissingSettings", 6)
	self:ScheduleTimer("FCDDelPopup", 6)
	self:ScheduleTimer("CMasterLooterWindow", 6)
	self:ScheduleTimer("RegHook", 6)
	self:ScheduleTimer("EventReminder", 25)
	self:ScheduleTimer("UpdateIgnoreListSettings", 6)
	self:ScheduleTimer("UpdateFriendsListSettings", 6)
	if not RepeatRangeCheck then RepeatRangeCheck = self:ScheduleRepeatingTimer(function() self:RangeChecker() end, 2) end
    for _, item in ipairs(FatCooldowns:GetModule("Display").db.profile.SpammerTable) do
    	if item.keep then item.enable = true else item.enable = false end
    end
end

function mod:ShowConfig()
	AceConfig:SetDefaultSize("FatCooldowns", 975, 675) -- w h size open window
	AceConfig:Open("FatCooldowns", configFrame)
end
function mod:ToggleConfig()
	if not AceConfig.OpenFrames["FatCooldowns"] then
		LibStub("AceConfigRegistry-3.0").NotifyChange("FatCooldowns")
		InterfaceOptionsFrame:Hide()
		HideUIPanel(GameMenuFrame)
		self:ShowConfig()
	else
		ToggleButton()
		AceConfig:Close("FatCooldowns")
	end
	self:UpdateConfig()
end
function mod:UpdateConfig(force)
	if AceConfig.OpenFrames["FatCooldowns"] then
		local FCDTable = AceConfig:GetStatusTable("FatCooldowns",self.configOptions)
		if FCDTable ~= nil then
			if FCDTable.groups ~= nil then
				if FCDTable.groups.selected ~= nil then
					if force == nil then
						if FCDTable.groups.selected == "other" then
							AceConfig:SelectGroup("FatCooldowns", "display")
							AceConfig:SelectGroup("FatCooldowns", "other")
						end
					elseif force == "yes" then
						AceConfig:SelectGroup("FatCooldowns", "display")
					end
				end
			end
		end
	end
end

function mod:Test()
	if not barGroups then return end
	local _,zone2=IsInInstance()
	self = mod
	local cd = 1
	for i = 1, 10, 1 do
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and
		(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and 
		(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
		(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
		(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena") and
		(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
		(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player")) and
		(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive()) then
			for class, classSpells in pairs(FatCooldowns.cooldowns) do
				for _, spell in pairs(classSpells) do
					if self.db.profile.frames[i].spells[spell.id] then
						if type(spell.id) == "number" then
							self:StartCooldown("TestCooldown", spell.id, 10 + (cd * 7) % 20,"onTestTarget",true)
							cd = cd + 1
						end
					end
				end
			end
		else
			barGroups[i]:Hide();
		end
	end	
end

function mod:Reset()
	if not barGroups then return end
	local _,zone2=IsInInstance()
	self = mod
	for i = 1, 10, 1 do
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and
			(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and 
			(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena")  and
			(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
			(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player")) and
			(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive()) then
			local bars = barGroups[i]:GetBars()
			if type(bars) == "table" then
				for k, v in pairs(bars) do
					barGroups[i]:RemoveBar(k)
				end
			end
		else
			barGroups[i]:Hide();
		end
	end
	self:RaidUpdate(FatCooldowns.raidRoster,{})
end

function mod:SpellToggle(barIndex,spell, val)
	if not barGroups then return end
	if val == true then return end
	local _,zone2=IsInInstance()	
	local removed = false
	if barIndex <= self.db.profile.frameCount and not self.db.profile.frames[barIndex].hideFrame and not self.db.profile.HideAllFrames and
		(not self.db.profile.frames[barIndex].HideBG or self.db.profile.frames[barIndex].HideBG and zone2 ~= "pvp") and 
		(not self.db.profile.frames[barIndex].HideInRaid or self.db.profile.frames[barIndex].HideInRaid and not UnitInRaid("player")) and
		(not self.db.profile.frames[barIndex].HideOutRaid or self.db.profile.frames[barIndex].HideOutRaid and UnitInRaid("player")) and
		(not self.db.profile.frames[barIndex].HideArena or self.db.profile.frames[barIndex].HideArena and zone2 ~= "arena") and
		(not self.db.profile.frames[barIndex].ShowArena or self.db.profile.frames[barIndex].ShowArena and zone2 == "arena") and
		(not self.db.profile.frames[barIndex].HideInCombat or self.db.profile.frames[barIndex].HideInCombat and not UnitAffectingCombat("player")) and
		(not self.db.profile.frames[barIndex].HideInWG or self.db.profile.frames[barIndex].HideInWG and self:IsWintergraspActive()) then
		local bars = barGroups[barIndex]:GetBars()
		if type(bars) == "table" then
			for k, v in pairs(bars) do
				if spell == v.spellId then
					barGroups[barIndex]:RemoveBar(k)
					removed = true
				end
			end
		end
	else
		barGroups[barIndex]:Hide();
	end	
	if removed then
		self:UpdateDisplay()
	end
end

--[[		Bar Group Anchor		]]--

function mod:CreateFrame()
	barGroups = {}
	for i = 1, 10, 1 do
		if not barGroups[i] then
			local name = "FatCooldowns"..i
			if i <= self.db.profile.frameCount then name = self.db.profile.frames[i].name end
			barGroups[i] = self:NewBarGroup(name, nil, 100, 100, "FCDD_Anchor")
			barGroups[i]:SetSortFunction(sortFunc)
			barGroups[i]:SetFlashPeriod(0)
			
			barGroups[i].RegisterCallback(self, "AnchorClicked")
			barGroups[i].RegisterCallback(self, "AnchorMoved")
			barGroups[i].RegisterCallback(self, "TimerFinished")
			barGroups[i].RegisterCallback(self, "TimerStarted")
			barGroups[i]:Hide();
		end
	end
	self:UpdateBackdrop()
end


function isUnitRelevant(sname)
	for i=1, GetNumRaidMembers() do
        if UnitName("raid"..i) == sname then 
		local _, _, _, _, _, _, zone, online = GetRaidRosterInfo(i);
    	local ZoneName = GetRealZoneText();
    		if online ~= 1 then return "Offline"
    		elseif zone ~= ZoneName then return "Zone"
    		elseif UnitIsDead("raid"..i) then return "Dead"
    		else
        		return true 
    		end
    	end
    end
end

function mod:resetspells()
	for i = 1, 15, 1 do
		if i <= self.db.profile.frameCount then
			if self.db.profile.frames[i].spells ~= nil then self.db.profile.frames[i].spells = {} end
		end
	end
	FatCooldowns:GetModule("Display"):FCDPrefixPrint("FCD: Spells have been reset, you are no longer tracking any spells.")
end

function mod:RenameBar(sender, amount)
	if not barGroups then return end
	local _,zone2=IsInInstance()
	for i = 1, 10, 1 do
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and 
			(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and
			(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena") and
			(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
			(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player")) and
			(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive()) then
		 	
	 		local bars = barGroups[i]:GetBars()
			if type(bars) == "table" then
				for key, bar in pairs(bars) do
					if bar.spellId == 23133 and sender == bar.caster then
						bar.target = amount

						local maxl = self.db.profile.frames[i].maxTextLength;
						local maxsenderl = self.db.profile.frames[i].maxTextLength;
						local leftbr = " "..self.db.profile.SymbolsStart
						local rightbr = self.db.profile.SymbolsEnd

						if self.db.profile.frames[i].hidetarget then maxl = 0 end
						if maxl == 0 then leftbr = "" rightbr = "" end
						local labelcooldown =  
								(self.db.profile.ColorCaster and FCDColorName2(string.sub(bar.caster,1,maxsenderl), bar.caster) or string.sub(bar.caster,1,maxsenderl)) ..
								(self.db.profile.ReTarget and "" or (leftbr .. amount..rightbr))
						
						if self.db.profile.frames[i].HideLabel then labelcooldown = "" end
						if self.db.profile.frames[i].SpellNameLabel then labelcooldown = GetSpellInfo(spellId) end
						bar:SetLabel(labelcooldown)
					end
				end
			end
			barGroups[i]:Show();
		else
			barGroups[i]:Hide();
		end
	end
end

function mod:UpdateDisplay(force)
	if not barGroups then return end
	local _,zone2=IsInInstance()
	for i = 1, 10, 1 do
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and 
			(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and
			(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena") and
			(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
			(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player")) and
			(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive())
			 then

			if self.db.profile.locked then
				barGroups[i]:Lock()
			else
				barGroups[i]:Unlock()
			end

			if self.db.profile.SpellIconAnimation then
				barGroups[i]:SetIconAnimation(true)
			else 			
				barGroups[i]:SetIconAnimation(false)
			end
			if self.db.profile.SpellIconAnimationReverse then
				barGroups[i]:SetIconAnimationReverse(true)
			else 			
				barGroups[i]:SetIconAnimationReverse(false)
			end

			if self.db.profile.Border then
				barGroups[i]:setBorder(true)
			else
				barGroups[i]:setBorder(false)
			end

			if self.db.profile.EnableBGColor then
				barGroups[i]:SetBGColor(self.db.profile.BGColor.r,self.db.profile.BGColor.g,self.db.profile.BGColor.b,self.db.profile.BGColor.a)
			else
				barGroups[i]:SetBGColor(0.3,0.3,0.3,0.6)
			end

			if self.db.profile.BorderColor then
				barGroups[i]:SetBGBorderColor(self.db.profile.BGBorderColor.r,self.db.profile.BGBorderColor.g,self.db.profile.BGBorderColor.b,self.db.profile.BGBorderColor.a)
			else
				barGroups[i]:SetBGBorderColor(0,0,0,1)
			end

			if self.db.profile.BorderThickness ~= 0 then
				barGroups[i]:setBorderThickness(self.db.profile.BorderThickness)
			else
				barGroups[i]:setBorderThickness(0)
			end
			
			if force == "yes" then 
				local bars = barGroups[i]:GetBars()
				if type(bars) == "table" then 
					for key, bar in pairs(bars) do
						if self.db.profile.frames[i].permanent then
							if bar.ready and self.db.profile.removebackground then 
								bar:SetTexture(nil) 
							else
				 				bar:SetTexture(Media:Fetch("statusbar", self.db.profile.texture))
				 			end

				 			if bar.ready and self.db.profile.EnableBGColor then
								bar:SetBackgroundColor(self.db.profile.BGColor.r,self.db.profile.BGColor.g,self.db.profile.BGColor.b,self.db.profile.BGColor.a)
							else
								bar:SetBackgroundColor(0.3,0.3,0.3,0.6)
							end
				 			
				 			if self.db.profile.removeglow then 
				 				bar.spark:SetTexture(nil)
				 			else
				 				bar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
				 			end

							if self.db.profile.FillBars then
				 				bar.fill = true
				 			else
				 				bar.fill = false
				 			end

							if self.db.profile.FillBackGround then
				 				bar.FillBackground = true 
				 			else
				 				bar.FillBackground = false 
				 			end

				 			if self.db.profile.iconzoom then
				 				bar.icon:SetTexCoord(0.08,0.92,0.08,0.92)
				 			else
				 				bar.icon:SetTexCoord(0,1,0,1)
				 			end
				 		end
				 		if self.db.profile.Border then
				 			bar:ShowBorder()
				 			if self.db.profile.BorderColor then
								bar:SetBorderColor(self.db.profile.BGBorderColor.r,self.db.profile.BGBorderColor.g,self.db.profile.BGBorderColor.b,self.db.profile.BGBorderColor.a)
							else
								bar:SetBorderColor(0,0,0,1)
							end
						else 
				 			bar:HideBorder()
						end	
				 	end
				end
			end	

			barGroups[i].name = self.db.profile.frames[i].name
			barGroups[i]:SetOrientation(self.db.profile.orientation)
			barGroups[i]:SetTargetOrientation(self.db.profile.TargetOrientation)
			barGroups[i]:SetClampedToScreen(self.db.profile.clamped)
			barGroups[i]:SetFont(Media:Fetch("font", self.db.profile.fontFace), self.db.profile.frames[i].fontsize, self.db.profile.outline)
			if not self.db.profile.removebackground then barGroups[i]:SetTexture(Media:Fetch("statusbar", self.db.profile.texture)) end
			
			if self.db.profile.removereadytext then 
				barGroups[i]:setreadytext(true)
			else
				barGroups[i]:setreadytext(false)
			end

			barGroups[i]:SetScale(self.db.profile.frames[i].scale / 100.0)
			barGroups[i]:ReverseGrowth(self.db.profile.frames[i].growUp)
			barGroups[i]:SetAlpha(self.db.profile.frames[i].alpha / 100.0)
			barGroups[i]:SetWidth(self.db.profile.frames[i].width)
			barGroups[i]:SetHeight(self.db.profile.frames[i].height)
			
			if self.db.profile.frames[i].anchor then
				barGroups[i]:ShowAnchor()
			else
				barGroups[i]:HideAnchor()
			end

			if self.db.profile.frames[i].permanent then
				local bars = barGroups[i]:GetBars()
				if type(bars) == "table" then
					for key, bar in pairs(bars) do
						if bar.ready then
							local maxl = self.db.profile.frames[i].maxTextLength
							if not self.db.profile.frames[i].SpellNameLabel and not self.db.profile.frames[i].HideLabel and self.db.profile.availability then
								if self.db.profile.ColorCaster and bar.castercolor == nil then bar.castercolor = FCDColorName2(string.sub(bar.caster,1,self.db.profile.frames[i].maxTextLength), bar.caster) end
								if not self.db.profile.ColorCaster and bar.castercolor ~= nil then bar.castercolor = nil end
								if isUnitRelevant(bar.caster) == "Zone" then bar:SetLabel("Zone - "..(self.db.profile.ColorCaster and bar.castercolor or string.sub(bar.caster,1,maxl)))
								elseif isUnitRelevant(bar.caster) == "Dead" then bar:SetLabel("Dead - "..(self.db.profile.ColorCaster and bar.castercolor or string.sub(bar.caster,1,maxl)))
								elseif isUnitRelevant(bar.caster) == "Offline" then bar:SetLabel("Offline - "..(self.db.profile.ColorCaster and bar.castercolor or string.sub(bar.caster,1,maxl)))
								elseif isUnitRelevant(bar.caster) == true then 
									if self.db.profile.removereadytext then
										bar:SetLabel((self.db.profile.ColorCaster and bar.castercolor ~= nil and bar.castercolor or string.sub(bar.caster,1,maxl)))
									else
										bar:SetLabel("R - "..(self.db.profile.ColorCaster and bar.castercolor ~= nil and bar.castercolor or string.sub(bar.caster,1,maxl)))
									end
								end
							elseif self.db.profile.frames[i].SpellNameLabel then
								if bar.SpellName ~= nil then bar:SetLabel(bar.SpellName)
								else
									for class, k in pairs(FatCooldowns.cooldowns) do
										for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
											if class == "CONSUMABLES" or class == "ITEMS" then
												if spellTable.id == bar.spellId and spellTable.itemid ~= nil then bar:SetLabel(GetItemInfo(spellTable.itemid)) end
											else
												if spellTable.id == bar.spellId then bar:SetLabel(GetSpellInfo(spellTable.id)) end
											end
										end
									end
								end
							elseif self.db.profile.frames[i].HideLabel then
								bar:SetLabel("")
							end
						end						
						if self.db.profile.CustomNameColor then
							if bar:GetLabel() ~= nil then bar:SetLabel(self:FCDColorText(bar:GetLabel(), self.db.profile.CustomNameColorPicked.r, self.db.profile.CustomNameColorPicked.g, self.db.profile.CustomNameColorPicked.b)) end
							if bar:GetLabel2() ~= nil then bar:SetLabel(self:FCDColorText(bar:GetLabel(), self.db.profile.CustomNameColorPicked.r, self.db.profile.CustomNameColorPicked.g, self.db.profile.CustomNameColorPicked.b)) end
						end
					end 
				end
			end
			barGroups[i]:Show();
		else
			barGroups[i]:Hide();
		end
	end
end

function mod:RangeChecker()
	if not barGroups then return end
	local RunUpdate = false
	for i = 1, 10, 1 do
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames and 
			(not self.db.profile.frames[i].HideBG or self.db.profile.frames[i].HideBG and zone2 ~= "pvp") and
			(not self.db.profile.frames[i].HideInRaid or self.db.profile.frames[i].HideInRaid and not UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideOutRaid or self.db.profile.frames[i].HideOutRaid and UnitInRaid("player")) and
			(not self.db.profile.frames[i].HideArena or self.db.profile.frames[i].HideArena and zone2 ~= "arena") and
			(not self.db.profile.frames[i].ShowArena or self.db.profile.frames[i].ShowArena and zone2 == "arena") and
			(not self.db.profile.frames[i].HideInCombat or self.db.profile.frames[i].HideInCombat and not UnitAffectingCombat("player")) and
			(not self.db.profile.frames[i].HideInWG or self.db.profile.frames[i].HideInWG and self:IsWintergraspActive())
			 then
			 	if self.db.profile.frames[i].opacity == nil then self.db.profile.frames[i].opacity = 100 end
				if self.db.profile.frames[i].opacity ~= 100 then
				local bars = barGroups[i]:GetBars()
				if type(bars) == "table" then
					for key, bar in pairs(bars) do
						if bar ~= nil and bar.caster ~= nil then
							local CasterRange = RC:GetRange(bar.caster)
							if CasterRange ~= nil and CasterRange >= 80 then
								if bar:GetAlpha() ~= self.db.profile.frames[i].opacity / 100 then
									bar.barop = self.db.profile.frames[i].opacity / 100
									bar:SetAlpha(self.db.profile.frames[i].opacity / 100)
									RunUpdate = true
								end
							else 
								if bar:GetAlpha() ~= self.db.profile.frames[i].alpha / 100 then
									bar.barop = self.db.profile.frames[i].alpha / 100
									bar:SetAlpha(self.db.profile.frames[i].alpha / 100)
									RunUpdate = true
								end
							end
						end
					end
				end
			end
		end
	end
	if RunUpdate then self:UpdateDisplay() end
end


function mod:TalentItemScan(NoTimer)
	if NoTimer == nil then self:ScheduleTimer("TalentItemScan", 45) end
	if not barGroups or (not UnitInRaid("player") and GetNumPartyMembers() == 0) or UnitAffectingCombat("player") then return end
	local _, zone2 = IsInInstance()
	local numbmembers = 0
	local tempname = ""
	if UnitInRaid("player") then
		numbmembers = GetNumRaidMembers()
		tempname = "raid" 
	else
		numbmembers = GetNumPartyMembers() + 1
		tempname = "party"
	end
	for x = 1, numbmembers do
		local player = UnitName(tempname..x)
		local PlayerRoleScan = LGT:GetUnitRole("player") 
		if player == nil then player = UnitName("player") end
		if player == "Unknown" then FatCooldowns:RaidScan("yes") return end
		local _, class = CustomUnitClass(player)
		for i = 1, 10, 1 do
			if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and self.db.profile.frames[i].permanent and not self.db.profile.HideAllFrames and not (UnitName("player") == player and
				self.db.profile.frames[i].hideSelf) and not (self.db.profile.frames[i].onlySelf and UnitName("player") ~= player) then
				if FatCooldowns.cooldowns[class] then	
					for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
						if (self.db.profile.frames[i].spells[spellTable.id] or (self.db.profile.frames[i].spells[99974] ~= nil and self.db.profile.frames[i].spells[99974] and spellTable.id == 64205 and PlayerRoleScan == "tank")) and spellTable.talent and not spellTable.ExpacHide[FatCooldowns.ExPac] then
							local SpellNameByID = GetSpellInfo(spellTable.id)
							local bar = barGroups[i]:GetBar(player .. "_" .. spellTable.id)

							if bar ~= nil and LGT:GetUnitTalentSpec(player) ~= nil and not LGT:UnitHasTalent(player, SpellNameByID) then
								if bar.ready then
									bar.permanent = false
									self:StopCooldown(player,spellTable.id, "True")
								elseif not bar.ready then
									bar.permanent = false
								end
							end
							if bar == nil and LGT:UnitHasTalent(player, SpellNameByID) then
								local maxsenderl = self.db.profile.frames[i].maxTextLength;
								local labelcooldownnewtalent = self.db.profile.ColorCaster and FCDColorName2(string.sub(player,1,maxsenderl), player) or string.sub(player,1,maxsenderl)
								if self.db.profile.frames[i].HideLabel then labelcooldownnewtalent = "" end
								if self.db.profile.frames[i].SpellNameLabel then labelcooldownnewtalent = GetSpellInfo(spellTable.id) end
								local bar = barGroups[i]:NewTimerBar((player .. "_" .. spellTable.id), labelcooldownnewtalent, 0.5, spellTable.cd, spellTable.id)
													
								bar:SetScript("OnMouseUp", buttonClick)
								bar:EnableMouse(not self.db.profile.unclickable)
								bar.permanent = true
								bar.caster  = player

								if self.db.profile.ColorCaster then bar.castercolor = FCDColorName2(string.sub(player,1,self.db.profile.frames[i].maxTextLength), player) end
								if self.db.profile.removeglow then bar.spark:SetTexture(nil) end
								if self.db.profile.FillBackGround then bar.FillBackground = true elseif not self.db.profile.FillBackGround then bar.FillBackground = false end
								if self.db.profile.FillBars then bar.fill = true elseif not self.db.profile.FillBars then bar.fill = false end
								
								if self.db.profile.iconzoom then bar.icon:SetTexCoord(0.08,0.92,0.08,0.92) else bar.icon:SetTexCoord(0,1,0,1) end
								bar.spellId = spellTable.id
								bar.time = 0.5
								bar:SetTexture(Media:Fetch("statusbar", self.db.profile.texture))
								local _, c = CustomUnitClass(player)
								if not c then
									for k, v in pairs(FatCooldowns.cooldowns) do
										for k2, v2 in pairs(v) do
											if v2.id == spellId then
												c = k
											end
										end
									end
								end
								if self.db.profile.CustomNameColor then
									if bar:GetLabel() ~= nil then bar:SetLabel(self:FCDColorText(bar:GetLabel(), self.db.profile.CustomNameColorPicked.r, self.db.profile.CustomNameColorPicked.g, self.db.profile.CustomNameColorPicked.b)) end
									if bar:GetLabel2() ~= nil then bar:SetLabel(self:FCDColorText(bar:GetLabel(), self.db.profile.CustomNameColorPicked.r, self.db.profile.CustomNameColorPicked.g, self.db.profile.CustomNameColorPicked.b)) end
								end
								if self.db.profile.frames[i].BarBackground then
									bar.bgtexture:Hide() bar.texture:Hide() bar.timerLabel:Hide() barGroups[i]:SetWidth(1) self.db.profile.frames[i].anchor = false barGroups[i]:HideAnchor()
								else
									bar.bgtexture:Show() bar.texture:Show() bar.timerLabel:Show() barGroups[i]:SetWidth(self.db.profile.frames[i].width) 
								end
								if RC:GetRange(bar.caster) ~= nil and RC:GetRange(bar.caster) >= 80 then
									if self.db.profile.frames[i].opacity == nil then self.db.profile.frames[i].opacity = 100 end
									bar.barop = self.db.profile.frames[i].opacity / 100 
									bar:SetAlpha(self.db.profile.frames[i].opacity / 100)
								else
									bar.barop = self.db.profile.frames[i].alpha / 100
								end	
								local color = RAID_CLASS_COLORS[c]
								if bar.spellId == 70337 then color = {r = 0.1, g = 0.9, b = 0.1} end -- np
								if bar.spellId == 72143 then color = {r = 0.64, g = 0.41, b = 0.18} end -- enrage
								if bar.spellId == 99038 then
									if bar.whoringinfo == 4 then color = {r = 0.64, g = 0.21, b = 0.93} -- loot timer
									elseif bar.whoringinfo == 3 then color = {r = 0.00, g = 0.44, b = 0.87} end -- loot timer
								end
								if type(color) == "table" and not self.db.profile.CustomBarColor then
									bar:SetColorAt(1.00, color.r, color.g, color.b, 1)
									bar:SetColorAt(0.00, color.r, color.g, color.b, 1)
								elseif self.db.profile.CustomBarColor then
									bar:SetColorAt(1.00, self.db.profile.CustomBarColorPicked.r, self.db.profile.CustomBarColorPicked.g, self.db.profile.CustomBarColorPicked.b, self.db.profile.CustomBarColorPicked.a)
									bar:SetColorAt(0.00, self.db.profile.CustomBarColorPicked.r, self.db.profile.CustomBarColorPicked.g, self.db.profile.CustomBarColorPicked.b, self.db.profile.CustomBarColorPicked.a)
								end
							end
						end
					end
				end
				if FatCooldowns.cooldowns["ITEMS"] then
					local ItemID1 = GetInventoryItemID(tempname..x, 13)
					local ItemID2 = GetInventoryItemID(tempname..x, 14)
					for spellName, spellTable in pairs(FatCooldowns.cooldowns["ITEMS"]) do
						if self.db.profile.frames[i].spells[spellTable.id] and not spellTable.ExpacHide[FatCooldowns.ExPac] then
	            	        if ItemID1 ~= nil and ItemID2 ~= nil then
	            	        	local tempItemID = nil
	            	        	for y = 1, 2, 1 do
	            	        		if y == 1 then tempItemID = ItemID1 elseif y == 2 then tempItemID = ItemID2 end
	                    			local bar = barGroups[i]:GetBar(player .. "_" .. spellTable.id)

									if bar == nil and (tempItemID == spellTable.itemid or tempItemID == spellTable.itemid2) then
										local maxsenderl = self.db.profile.frames[i].maxTextLength;
										local labelcooldownnewtalent = self.db.profile.ColorCaster and FCDColorName2(string.sub(player,1,maxsenderl), player) or string.sub(player,1,maxsenderl)
										if self.db.profile.frames[i].HideLabel then labelcooldownnewtalent = "" end
										if self.db.profile.frames[i].SpellNameLabel then labelcooldownnewtalent = GetItemInfo(tempItemID) end
										local bar = barGroups[i]:NewTimerBar((player .. "_" .. spellTable.id), labelcooldownnewtalent, 0.5, spellTable.cd, spellTable.id)
										bar:SetScript("OnMouseUp", buttonClick)
										bar:EnableMouse(not self.db.profile.unclickable)
										bar.permanent = true 
										bar.caster  = player
										if RC:GetRange(bar.caster) ~= nil and RC:GetRange(bar.caster) >= 80 then
											if self.db.profile.frames[i].opacity == nil then self.db.profile.frames[i].opacity = 100 end
											bar.barop = self.db.profile.frames[i].opacity / 100 
											bar:SetAlpha(self.db.profile.frames[i].opacity / 100)
										else
											bar.barop = self.db.profile.frames[i].alpha / 100
										end	
										if self.db.profile.ColorCaster then bar.castercolor = FCDColorName2(string.sub(player,1,self.db.profile.frames[i].maxTextLength), player) end
										if self.db.profile.removeglow then bar.spark:SetTexture(nil) end
										if self.db.profile.FillBackGround then bar.FillBackground = true elseif not self.db.profile.FillBackGround then bar.FillBackground = false end
										if self.db.profile.FillBars then bar.fill = true elseif not self.db.profile.FillBars then bar.fill = false end
										
										if self.db.profile.iconzoom then bar.icon:SetTexCoord(0.08,0.92,0.08,0.92) else bar.icon:SetTexCoord(0,1,0,1) end
										bar.spellId = spellTable.id
										bar.time = 0.5
										bar:SetTexture(Media:Fetch("statusbar", self.db.profile.texture))
										local _, c = CustomUnitClass(player)
										if not c then
											for k, v in pairs(FatCooldowns.cooldowns) do
												for k2, v2 in pairs(v) do
													if v2.id == spellId then
														c = k
													end
												end
											end
										end
										if self.db.profile.frames[i].BarBackground then
											bar.bgtexture:Hide() bar.texture:Hide() bar.timerLabel:Hide() barGroups[i]:SetWidth(1) self.db.profile.frames[i].anchor = false barGroups[i]:HideAnchor()
										else
											bar.bgtexture:Show() bar.texture:Show() bar.timerLabel:Show() barGroups[i]:SetWidth(self.db.profile.frames[i].width) 
										end
										if self.db.profile.CustomNameColor then
											if bar:GetLabel() ~= nil then bar:SetLabel(self:FCDColorText(bar:GetLabel(), self.db.profile.CustomNameColorPicked.r, self.db.profile.CustomNameColorPicked.g, self.db.profile.CustomNameColorPicked.b)) end
											if bar:GetLabel2() ~= nil then bar:SetLabel(self:FCDColorText(bar:GetLabel(), self.db.profile.CustomNameColorPicked.r, self.db.profile.CustomNameColorPicked.g, self.db.profile.CustomNameColorPicked.b)) end
										end
										local color = RAID_CLASS_COLORS[c]
										if bar.spellId == 70337 then color = {r = 0.1, g = 0.9, b = 0.1} end -- np
										if bar.spellId == 72143 then color = {r = 0.64, g = 0.41, b = 0.18} end -- enrage
										if bar.spellId == 99038 then
											if bar.whoringinfo == 4 then color = {r = 0.64, g = 0.21, b = 0.93} -- loot timer
											elseif bar.whoringinfo == 3 then color = {r = 0.00, g = 0.44, b = 0.87} end -- loot timer
										end
										if type(color) == "table" and not self.db.profile.CustomBarColor then
											bar:SetColorAt(1.00, color.r, color.g, color.b, 1)
											bar:SetColorAt(0.00, color.r, color.g, color.b, 1)
										elseif self.db.profile.CustomBarColor then
											bar:SetColorAt(1.00, self.db.profile.CustomBarColorPicked.r, self.db.profile.CustomBarColorPicked.g, self.db.profile.CustomBarColorPicked.b, self.db.profile.CustomBarColorPicked.a)
											bar:SetColorAt(0.00, self.db.profile.CustomBarColorPicked.r, self.db.profile.CustomBarColorPicked.g, self.db.profile.CustomBarColorPicked.b, self.db.profile.CustomBarColorPicked.a)
										end
									end
								end
		                 	   	if (spellTable.itemid or spellTable.itemid2) then
	    	                		if ItemID2 == (spellTable.itemid or spellTable.itemid2) or ItemID1 == (spellTable.itemid or spellTable.itemid2) then
	    	                			-- do nothing
	    	                		else
				       					for i = 1, 10, 1 do
			   	                 			local bar = barGroups[i]:GetBar(player .. "_" .. spellTable.id)
			                    			if bar ~= nil and bar.ready then
												bar.permanent = false
												self:StopCooldown(player,spellTable.id, "True")
											elseif bar ~= nil and not bar.ready then
												bar.permanent = false
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

function mod:SetAnchors(useDB)
	if not barGroups then return end
	if useDB ~= false then useDB = true end
	local _,zone2=IsInInstance()
	for i = 1, 10, 1 do
		if i <= self.db.profile.frameCount and not self.db.profile.frames[i].hideFrame and not self.db.profile.HideAllFrames then
			local up = self.db.profile.frames[i].growUp
			local x, y
			if useDB then
				x, y = self.db.profile.frames[i].posX, self.db.profile.frames[i].posY
				if not x and not y then
					barGroups[i]:ClearAllPoints()
					barGroups[i]:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
					return
				end
			elseif up then
				x, y = barGroups[i]:GetLeft(), barGroups[i]:GetBottom()
			else
				x, y = barGroups[i]:GetLeft(), barGroups[i]:GetTop()
			end
			barGroups[i]:ClearAllPoints()
			if up then
				barGroups[i]:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x, y)
			else
				barGroups[i]:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
			end
			self.db.profile.frames[i].posX, self.db.profile.frames[i].posY = x, y
		else
			barGroups[i]:Hide();
		end
	end
	self:UpdateBackdrop()
end

function mod:AnchorClicked(cbk, group, button)
	if button == "RightButton" then
		FatCooldowns:OpenConfigDialog()
	end
end

function mod:AnchorMoved(cbk, group, x, y)
	self:SetAnchors(false)
end

function mod:TimerFinished(cbk, group, bar, name, force)
	local spellId = bar.spellId
	local sender = bar.caster
	local target = bar.target
	local tempcooldown = nil
	local cooldown = bar.time
	bar.targetcolor = nil
	bar.DisableClick = nil
	local _, playerclass = UnitClass("player")
	local IsItem = nil
	local backlash = bar.backlash
	local spells = FatCooldowns.cooldowns["ITEMS"]
	local spells2 = FatCooldowns.cooldowns["CONSUMABLES"]

	if force ~= "yes" and bar.time ~= 0.5 then
		if (self.db.profile.soundspells[spellId] or self.db.profile.SpellsReporter[spellId]) then
			local _, class = CustomUnitClass(sender)
			if spellId ~= 70337 and spellId ~= 72143 and class ~= nil and FatCooldowns.cooldowns[class] then
				for spellName, spellTable in pairs(FatCooldowns.cooldowns[class]) do
					if spellTable.id == spellId then 
						if spellTable.cd2 ~= nil and cooldown == spellTable.cd2 then tempcooldown = spellTable.cd2
						elseif spellTable.cd3 ~= nil and cooldown == spellTable.cd3 then tempcooldown = spellTable.cd3
						elseif cooldown == spellTable.cd then tempcooldown = spellTable.cd
						end
					end
				end
				for spellName, spellTable in pairs(FatCooldowns.cooldowns["ITEMS"]) do
					if spellTable.id == spellId then tempcooldown = spellTable.cd IsItem = spells[spellName].itemlink end
				end	
				for spellName, spellTable in pairs(FatCooldowns.cooldowns["RACIALS"]) do
					if spellTable.id == spellId then tempcooldown = spellTable.cd end
				end	
				for spellName, spellTable in pairs(FatCooldowns.cooldowns["CONSUMABLES"]) do
					if spellTable.id == spellId then tempcooldown = spellTable.cd IsItem = spells2[spellName].itemlink end
				end	
			end
		end

		if self.db.profile.soundspells[spellId] and (LastSoundPlay[spellId] == nil or (LastSoundPlay[spellId] ~= nil and GetTime() - LastSoundPlay[spellId] > 1)) and tempcooldown == cooldown and self.db.profile.soundspellsoptions[spellId].CDReady and
			(not self.db.profile.soundspellsoptions[spellId].PlayerClassEnable or (self.db.profile.soundspellsoptions[spellId].PlayerClassEnable and self.db.profile.soundspellsoptions[spellId].PlayerClass[playerclass])) and
			((not self.db.profile.soundspellsoptions[spellId].Spec1 and not self.db.profile.soundspellsoptions[spellId].Spec1) or (self.db.profile.soundspellsoptions[spellId].Spec1 and GetActiveTalentGroup() == 1) or (self.db.profile.soundspellsoptions[spellId].Spec2 and GetActiveTalentGroup() == 2)) and
			((not self.db.profile.soundspellsoptions[spellId].EnemyCaster or (self.db.profile.soundspellsoptions[spellId].EnemyCaster and IsEnemyFCDCaster(sender))) and
			(not self.db.profile.soundspellsoptions[spellId].FriendlyCaster or (self.db.profile.soundspellsoptions[spellId].FriendlyCaster and IsFriendlyFCDCaster(sender))) and
			(not self.db.profile.soundspellsoptions[spellId].TargetMe or (self.db.profile.soundspellsoptions[spellId].TargetMe and target == UnitName("player"))) and
			(not self.db.profile.soundspellsoptions[spellId].NotSelf or (self.db.profile.soundspellsoptions[spellId].NotSelf and sender ~= UnitName("player"))) and
			(not self.db.profile.soundspellsoptions[spellId].Self or (self.db.profile.soundspellsoptions[spellId].Self and sender == UnitName("player"))) and
			(not self.db.profile.soundspellsoptions[spellId].NotTargetMe or (self.db.profile.soundspellsoptions[spellId].NotTargetMe and target ~= UnitName("player"))))
		then
			if self.db.profile.soundspellsoptions[spellId].EnableCustomSound then
				local SpellNameByID = GetSpellInfo(spellId)
				if SpellNameByID:find(":") then SpellNameByID = gsub(SpellNameByID, ": ", " ") end
				PlaySoundFile(FatCooldowns.FCDSounds[self.db.profile.soundspellsoptions[spellId].CustomSound], "Master",false)
				if self.db.profile.soundspellsoptions[spellId].CDReadySound then self:ScheduleTimer(function() PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\Ready.mp3", "Master", false) end, FatCooldowns.SoundsDuration[SpellNameByID]) end
			else
				local SpellNameByID = GetSpellInfo(spellId)
				if SpellNameByID:find(":") then SpellNameByID = gsub(SpellNameByID, ": ", " ") end
				if spellId == 61685 or spellId == 47996 or spellId == 53477 then SpellNameByID = gsub(SpellNameByID, SpellNameByID, "Pet "..SpellNameByID) end
				PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\SpellSounds\\"..SpellNameByID..".mp3", "Master", false)
				if self.db.profile.soundspellsoptions[spellId].CDReadySound then self:ScheduleTimer(function() PlaySoundFile("Interface\\AddOns\\FatCooldowns\\sounds\\Ready.mp3", "Master", false) end, FatCooldowns.SoundsDuration[SpellNameByID]) end
			end
			LastSoundPlay[spellId] = GetTime()
		end

		if self.db.profile.SpellsReporter[spellId] and (LastMessageSent[spellId] == nil or (LastMessageSent[spellId] ~= nil and GetTime() - LastMessageSent[spellId] > 0.5)) and tempcooldown == cooldown and self.db.profile.spellreporteroptions[spellId].CDReady and
			(not self.db.profile.spellreporteroptions[spellId].PlayerClassEnable or (self.db.profile.spellreporteroptions[spellId].PlayerClassEnable and self.db.profile.spellreporteroptions[spellId].PlayerClass[playerclass] ~= nil and self.db.profile.spellreporteroptions[spellId].PlayerClass[playerclass])) and
			(self.db.profile.spellreporteroptions[spellId].Spec == 1 or ((self.db.profile.spellreporteroptions[spellId].Spec == 2 and GetActiveTalentGroup() == 1) or (self.db.profile.spellreporteroptions[spellId].Spec == 3 and GetActiveTalentGroup() == 2))) and
			(self.db.profile.spellreporteroptions[spellId].EnemyCaster == 1 or ((self.db.profile.spellreporteroptions[spellId].EnemyCaster == 2 and IsEnemyFCDCaster(sender)) or (self.db.profile.spellreporteroptions[spellId].EnemyCaster == 3 and IsFriendlyFCDCaster(sender)))) and
			(self.db.profile.spellreporteroptions[spellId].TargetMe == 1  or ((self.db.profile.spellreporteroptions[spellId].TargetMe == 2 and target == UnitName("player")) or (self.db.profile.spellreporteroptions[spellId].TargetMe == 3 and target ~= UnitName("player")))) and
			(self.db.profile.spellreporteroptions[spellId].Self == 1 or ((self.db.profile.spellreporteroptions[spellId].Self == 2 and sender == UnitName("player")) or (self.db.profile.spellreporteroptions[spellId].Self == 3 and sender ~= UnitName("player")))) and
			(self.db.profile.spellreporteroptions[spellId].Raid == 1 or ((self.db.profile.spellreporteroptions[spellId].Raid == 2 and UnitInRaid("player") ~= nil and UnitInRaid("player") == true) or (self.db.profile.spellreporteroptions[spellId].Raid == 3 and (UnitInRaid("player") == nil or UnitInRaid("player") ~= nil and UnitInRaid("player") == false)))) and
			(self.db.profile.spellreporteroptions[spellId].BG == 1 or ((self.db.profile.spellreporteroptions[spellId].BG == 2 and zone2 == "pvp") or (self.db.profile.spellreporteroptions[spellId].BG == 3 and zone2 ~= "pvp"))) and
			(self.db.profile.spellreporteroptions[spellId].Arena == 1 or ((self.db.profile.spellreporteroptions[spellId].Arena == 2 and zone2 == "arena") or (self.db.profile.spellreporteroptions[spellId].Arena == 3 and zone2 ~= "arena")))
		then
			if self.db.profile.spellreporteroptions[spellId] then
				if self.db.profile.spellreporteroptions[spellId].Channel then
					self:FCDSendChatMessage(sender, "'s "..(IsItem or GetSpellLink(spellId)).." is ready!", nil, nil, self.db.profile.spellreporteroptions[spellId].Channel) 
				end
			end
			LastMessageSent[spellId] = GetTime()
		end
		--print(cbk, group, bar, name, force, spellId, sender, target, backlash)
	end

	if bar.permanent and self.db.profile.removebackground then bar:SetTexture(nil) end
	if bar.permanent then if UnitInRaid("player") or GetNumPartyMembers() >= 1 then else FatCooldowns:GetModule("Display"):StopCooldown(bar.caster, bar.spellId, "True") end end
	self:UpdateDisplay()
end

function mod:TimerStarted(cbk, group, bar, name)
	if bar.permanent and self.db.profile.removebackground then bar:SetTexture(Media:Fetch("statusbar", self.db.profile.texture)) end
end
