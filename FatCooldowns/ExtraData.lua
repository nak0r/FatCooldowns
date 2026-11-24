FatCooldowns.ExPac = GetAccountExpansionLevel()

FatCooldowns.AGUseItem = false
FatCooldowns.HistoryFilterChecker = {}
FatCooldowns.GuildInviteButtonPressed = 0

FatCooldowns.Boss = {
	[1] = "All",
	[2] = "Anub'Rekhan",
	[3] = "Grand Widow Faerlina",
	[4] = "Maexxna",
	[5] = "Noth the Plaguebringer",
	[6] = "Heigan the Unclean",
	[7] = "Loatheb",
	[8] = "Instructor Razuvious",
	[9] = "Gothik the Harvester",
	[10] = "Patchwerk",
	[11] = "Grobbulus",
	[12] = "Gluth",
	[13] = "Thaddius",
	[14] = "Sapphiron",
	[15] = "Kel'Thuzad",
	[16] = "Sartharion",
	[17] = "Malygos",
	[18] = "Archavon the Stone Watcher",
	[19] = "Emalon the Storm Watcher",
	[20] = "Koralon the Flame Watcher",
	[21] = "Toravon the Ice Watcher",
	[22] = "Flame Leviathan",
	[23] = "Ignis the Furnace Master",
	[24] = "Razorscale",
	[25] = "XT-002 Deconstructor",
	[26] = "Kologarn",
	[27] = "Auriaya",
	[28] = "General Vezax",
	[29] = "Yogg-Saron",
	[30] = "Onyxia",
	[31] = "Icehowl",
	[32] = "Lord Jaraxxus",
	[33] = "Anub'arak",
	[34] = "Lord Marrowgar",
	[35] = "Lady Deathwhisper",
	[36] = "Deathbringer Saurfang",
	[37] = "Festergut",
	[38] = "Rotface",
	[39] = "Professor Putricide", 
	[40] = "Blood-Queen Lana'thel",
	[41] = "Sindragosa",
	[42] = "The Lich King",
}

FatCooldowns.Instances = {
	[1] = "All",
	[2] = "The Ruby Sanctum",
	[3] = "Icecrown Citadel"
}

FatCooldowns.BossID = {
	--Naxxramas
		[15956] = "Anub'Rekhan",
		[15953] = "Grand Widow Faerlina",
		[15952] = "Maexxna",
		[15954] = "Noth the Plaguebringer",
		[15936] = "Heigan the Unclean",
		[16011] = "Loatheb",
		[16061] = "Instructor Razuvious",
		[16060] = "Gothik the Harvester",
		-- Four Horsemen will need bossyell
		[16028] = "Patchwerk",
		[15931] = "Grobbulus",
		[15932] = "Gluth",
		[15928] = "Thaddius",
		[15989] = "Sapphiron",
		[15990] = "Kel'Thuzad",
	--The Obsidian Sanctum--
		[28860] = "Sartharion",
	--Eye of Eternity--
		[28859] = "Malygos",
	--Archavon's Chamber--
		[31125] = "Archavon the Stone Watcher",
		[33993] = "Emalon the Storm Watcher",
		[35013] = "Koralon the Flame Watcher",
		[38433] = "Toravon the Ice Watcher",
	--Ulduar--
		[33113] = "Flame Leviathan",
		[33118] = "Ignis the Furnace Master",
		[33186] = "Razorscale",
		[33293] = "XT-002 Deconstructor",
		-- The Assembly of Iron bossyell
		[32930] = "Kologarn",
		[33515] = "Auriaya",
		-- Freya, Hodir, Mimiron and Thorim bossyell
		[33271] = "General Vezax",
		[33288] = "Yogg-Saron",
		-- Algalon bossyell
	--Onyxias Lair--
		[10184] = "Onyxia",
	--Trial of the Crusader--
		[34797] = "Icehowl",
		[34780] = "Lord Jaraxxus",
		-- Faction Champions bossyell
		-- Val'kyr Twins bossyell
		[34564] = "Anub'arak",
	--Icecrown Citadel--
		[36612] = "Lord Marrowgar",
		[36855] = "Lady Deathwhisper",
		-- Gunship Battle bossyell
		[37813] = "Deathbringer Saurfang",
		[36626] = "Festergut",
		[36627] = "Rotface",
		[36678] = "Professor Putricide", 
		-- Blood Prince Council bossyell
		[37955] = "Blood-Queen Lana'thel",
		-- Dreamwalker bossyell
		[36853] = "Sindragosa",
		[36597] = "The Lich King",
	--The Ruby Sanctum--
		--Halion bossyell
}

function FCDIsInstanceUlduar(boss)
	local instanceInfoName = GetInstanceInfo()
	if instanceInfoName == "Ulduar" then
		return boss
	else
		return nil
	end
end

FatCooldowns.FCDBossyells = {
	-- Naxxramas
		["I grow tired of these games. Proceed, and I will banish your souls to oblivion!"] = "Four Horsemen",
	-- Ulduar
		["You rush headlong into the maw of madness!"] = "Iron Council",
		["What have you gained from my defeat? You are no less doomed, mortals!"] = "Iron Council",
		["Impossible..."] = FCDIsInstanceUlduar("Iron Council"),
		["I... I am released from his grasp... at last."] = "Hodir",
		["Stay your arms! I yield!"] = "Thorim",
		["His hold on me dissipates. I can see clearly once more. Thank you, heroes."] = "Freya",
		["It would appear that I've made a slight miscalculation. I allowed my mind to be corrupted by the fiend in the prison, overriding my primary directive. All systems seem to be functional now. Clear."] = "Mimiron",
		["I've rearranged the reply code. Your planet will be spared. I cannot be certain of my own calculations anymore."] = "Algalon",
	-- Trial of the Crusader
		["A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death."] = "Faction Champions",
		["The Scourge cannot be stopped..."] = "Val'kyr Twins",
	-- Icecrown Citadel
		["Don't say I didn't warn ya, scoundrels! Onward, brothers and sisters!"] = "Gunship Battle",
		["The Alliance falter. Onward to the Lich King!"] = "Gunship Battle",
		["My queen, they... come."] = "Blood Prince Council",
		["I AM RENEWED! Ysera grant me the favor to lay these foul creatures to rest!"] = "Valithria Dreamwalker",
	-- Ruby Sanctum
		["Relish this victory, mortals, for it will be your last. This world will burn with the master's return!"] = "Halion",
}

FatCooldowns.IgnoreLoot = {
	-- Emblems
		[40752] = true,
		[40753] = true,
		[45624] = true,
		[47241] = true,
		[49426] = true,
	-- Gems
		[36931] = true,
		[36919] = true,
		[36928] = true,
		[36934] = true,
		[36922] = true,
		[36925] = true,
	-- Shards
		[34057] = true,
}


FatCooldowns.BGZoneData = {
	["Eye of the Storm"] = false,
	["Warsong Gulch"] = false,
	["Arathi Basin"] = false,
	["Alterac Valley"] = false,
	["Strand of the Ancients"] = false,
	["Isle of Conquest"] = false,
}

FatCooldowns.ZoneData = {
	["Abyssal Depths"] = "Abyssal Depths",
	["Ahn'Qiraj"] = "Ahn'Qiraj",
	["Ahn'Qiraj: The Fallen Kingdom"] = "Ahn'Qiraj: The Fallen Kingdom",
	["Ahn'kahet: The Old Kingdom"] = "Ahn'kahet: The Old Kingdom",
	["Alliance Base"] = "Alliance Base",
	["Alterac Mountains"] = "Alterac Mountains",
	["Alterac Valley"] = "Alterac Valley",
	["Amani Pass"] = "Amani Pass",
	["Arathi Basin"] = "Arathi Basin",
	["Arathi Highlands"] = "Arathi Highlands",
	["Armory"] = "Armory",
	["Ashenvale"] = "Ashenvale",
	["Auberdine"] = "Auberdine",
	["Auchenai Crypts"] = "Auchenai Crypts",
	["Auchindoun"] = "Auchindoun",
	["Azeroth"] = "Azeroth",
	["Azjol-Nerub"] = "Azjol-Nerub",
	["Azshara"] = "Azshara",
	["Azuremyst Isle"] = "Azuremyst Isle",
	["Badlands"] = "Badlands",
	["Bash'ir Landing"] = "Bash'ir Landing",
	["Black Temple"] = "Black Temple",
	["Blackfathom Deeps"] = "Blackfathom Deeps",
	["Blackrock Caverns"] = "Blackrock Caverns",
	["Blackrock Depths"] = "Blackrock Depths",
	["Blackrock Mountain"] = "Blackrock Mountain",
	["Blackrock Spire"] = "Blackrock Spire",
	["Blackwind Lake"] = "Blackwind Lake",
	["Blackwing Descent"] = "Blackwing Descent",
	["Blackwing Lair"] = "Blackwing Lair",
	["Blade's Edge Arena"] = "Blade's Edge Arena",
	["Blade's Edge Mountains"] = "Blade's Edge Mountains",
	["Blasted Lands"] = "Blasted Lands",
	["Bloodmyst Isle"] = "Bloodmyst Isle",
	["Booty Bay"] = "Booty Bay",
	["Borean Tundra"] = "Borean Tundra",
	["Burning Steppes"] = "Burning Steppes",
	["Cathedral"] = "Cathedral",
	["Caverns of Time"] = "Caverns of Time",
	["Champions' Hall"] = "Champions' Hall",
	["Coilfang Reservoir"] = "Coilfang Reservoir",
	["Coldarra"] = "Coldarra",
	["Cosmic map"] = "Cosmic map",
	["Crystal Spine"] = "Crystal Spine",
	["Crystalsong Forest"] = "Crystalsong Forest",
	["Dalaran"] = "Dalaran",
	["Dalaran Arena"] = "Dalaran Arena",
	["Dalaran Sewers"] = "Dalaran Sewers",
	["Darkmoon Faire"] = "Darkmoon Faire",
	["Darkshore"] = "Darkshore",
	["Darnassus"] = "Darnassus",
	["Deadwind Pass"] = "Deadwind Pass",
	["Deepholm"] = "Deepholm",
	["Deeprun Tram"] = "Deeprun Tram",
	["Desolace"] = "Desolace",
	["Dire Maul"] = "Dire Maul",
	["Dire Maul (East)"] = "Dire Maul (East)",
	["Dire Maul (North)"] = "Dire Maul (North)",
	["Dire Maul (West)"] = "Dire Maul (West)",
	["Dragonblight"] = "Dragonblight",
	["Drak'Tharon Keep"] = "Drak'Tharon Keep",
	["Dun Morogh"] = "Dun Morogh",
	["Durotar"] = "Durotar",
	["Duskwood"] = "Duskwood",
	["Dustwallow Marsh"] = "Dustwallow Marsh",
	["Eastern Kingdoms"] = "Eastern Kingdoms",
	["Eastern Plaguelands"] = "Eastern Plaguelands",
	["Elwynn Forest"] = "Elwynn Forest",
	["Everlook"] = "Everlook",
	["Eversong Woods"] = "Eversong Woods",
	["Eye of the Storm"] = "Eye of the Storm",
	["Felwood"] = "Felwood",
	["Feralas"] = "Feralas",
	["Forge Camp: Terror"] = "Forge Camp: Terror",
	["Forge Camp: Wrath"] = "Forge Camp: Wrath",
	["Frostwyrm Lair"] = "Frostwyrm Lair",
	["Furywing's Perch"] = "Furywing's Perch",
	["Gadgetzan"] = "Gadgetzan",
	["Gates of Ahn'Qiraj"] = "Gates of Ahn'Qiraj",
	["Ghostlands"] = "Ghostlands",
	["Gilneas"] = "Gilneas",
	["Gilneas City"] = "Gilneas City",
	["Gnomeregan"] = "Gnomeregan",
	["Graveyard"] = "Graveyard",
	["Grim Batol"] = "Grim Batol",
	["Grizzly Hills"] = "Grizzly Hills",
	["Grom'gol Base Camp"] = "Grom'gol Base Camp",
	["Gruul's Lair"] = "Gruul's Lair",
	["Gundrak"] = "Gundrak",
	["Hall of Champions"] = "Hall of Champions",
	["Hall of Legends"] = "Hall of Legends",
	["Halls of Lightning"] = "Halls of Lightning",
	["Halls of Origination"] = "Halls of Origination",
	["Halls of Reflection"] = "Halls of Reflection",
	["Halls of Stone"] = "Halls of Stone",
	["Hellfire Citadel"] = "Hellfire Citadel",
	["Hellfire Peninsula"] = "Hellfire Peninsula",
	["Hellfire Ramparts"] = "Hellfire Ramparts",
	["Hillsbrad Foothills"] = "Hillsbrad Foothills",
	["Horde Encampment"] = "Horde Encampment",
	["Howling Fjord"] = "Howling Fjord",
	["Hrothgar's Landing"] = "Hrothgar's Landing",
	["Hyjal"] = "Hyjal",
	["Hyjal Summit"] = "Hyjal Summit",
	["Icecrown"] = "Icecrown",
	["Icecrown Citadel"] = "Icecrown Citadel",
	["Insidion's Perch"] = "Insidion's Perch",
	["Ironforge"] = "Ironforge",
	["Isle of Conquest"] = "Isle of Conquest",
	["Isle of Quel'Danas"] = "Isle of Quel'Danas",
	["Kalimdor"] = "Kalimdor",
	["Karazhan"] = "Karazhan",
	["Kelp'thar Forest"] = "Kelp'thar Forest",
	["Kezan"] = "Kezan",
	["Krasus' Landing"] = "Krasus' Landing",
	["Library"] = "Library",
	["Loch Modan"] = "Loch Modan",
	["Lost City of the Tol'vir"] = "Lost City of the Tol'vir",
	["Lower Blackrock Spire"] = "Lower Blackrock Spire",
	["Magisters' Terrace"] = "Magisters' Terrace",
	["Magtheridon's Lair"] = "Magtheridon's Lair",
	["Mana-Tombs"] = "Mana-Tombs",
	["Maraudon"] = "Maraudon",
	["Marshlight Lake"] = "Marshlight Lake",
	["Menethil Harbor"] = "Menethil Harbor",
	["Molten Core"] = "Molten Core",
	["Moonglade"] = "Moonglade",
	["Mount Hyjal"] = "Mount Hyjal",
	["Mulgore"] = "Mulgore",
	["Nagrand"] = "Nagrand",
	["Nagrand Arena"] = "Nagrand Arena",
	["Naxxramas"] = "Naxxramas",
	["Netherstorm"] = "Netherstorm",
	["Night Elf Village"] = "Night Elf Village",
	["Northern Barrens"] = "Northern Barrens",
	["Northern Stranglethorn"] = "Northern Stranglethorn",
	["Northrend"] = "Northrend",
	["Obsidia's Perch"] = "Obsidia's Perch",
	["Ogri'la"] = "Ogri'la",
	["Old Hillsbrad Foothills"] = "Old Hillsbrad Foothills",
	["Old Stratholme"] = "Old Stratholme",
	["Onyxia's Lair"] = "Onyxia's Lair",
	["Orgrimmar"] = "Orgrimmar",
	["Outland"] = "Outland",
	["Pit of Saron"] = "Pit of Saron",
	["Plaguelands: The Scarlet Enclave"] = "Plaguelands: The Scarlet Enclave",
	["Plaguewood"] = "Plaguewood",
	["Quel'thalas"] = "Quel'thalas",
	["Ragefire Chasm"] = "Ragefire Chasm",
	["Ratchet"] = "Ratchet",
	["Razorfen Downs"] = "Razorfen Downs",
	["Razorfen Kraul"] = "Razorfen Kraul",
	["Redridge Mountains"] = "Redridge Mountains",
	["Ring of Observance"] = "Ring of Observance",
	["Rivendark's Perch"] = "Rivendark's Perch",
	["Ruins of Ahn'Qiraj"] = "Ruins of Ahn'Qiraj",
	["Ruins of Gilneas"] = "Ruins of Gilneas",
	["Ruins of Lordaeron"] = "Ruins of Lordaeron",
	["Scalebeard's Cave"] = "Scalebeard's Cave",
	["Scarlet Monastery"] = "Scarlet Monastery",
	["Scholomance"] = "Scholomance",
	["Searing Gorge"] = "Searing Gorge",
	["Serpent Lake"] = "Serpent Lake",
	["Serpentshrine Cavern"] = "Serpentshrine Cavern",
	["Sethekk Halls"] = "Sethekk Halls",
	["Shadow Labyrinth"] = "Shadow Labyrinth",
	["Shadowfang Keep"] = "Shadowfang Keep",
	["Shadowmoon Valley"] = "Shadowmoon Valley",
	["Shartuul's Transporter"] = "Shartuul's Transporter",
	["Shattrath"] = "Shattrath",
	["Shattrath City"] = "Shattrath City",
	["Shimmering Expanse"] = "Shimmering Expanse",
	["Sholazar Basin"] = "Sholazar Basin",
	["Silithus"] = "Silithus",
	["Silvermoon City"] = "Silvermoon City",
	["Silverpine Forest"] = "Silverpine Forest",
	["Skyguard Outpost"] = "Skyguard Outpost",
	["Skysong Lake"] = "Skysong Lake",
	["Southern Barrens"] = "Southern Barrens",
	["Sporewind Lake"] = "Sporewind Lake",
	["Stonard"] = "Stonard",
	["Stonetalon Mountains"] = "Stonetalon Mountains",
	["Stormwind"] = "Stormwind",
	["Stormwind City"] = "Stormwind City",
	["Strand of the Ancients"] = "Strand of the Ancients",
	["Stranglethorn Vale"] = "Stranglethorn Vale",
	["Stratholme"] = "Stratholme",
	["Sunken Temple"] = "Sunken Temple",
	["Sunwell Plateau"] = "Sunwell Plateau",
	["Swamp of Sorrows"] = "Swamp of Sorrows",
	["Tanaris"] = "Tanaris",
	["Teldrassil"] = "Teldrassil",
	["Tempest Keep"] = "Tempest Keep",
	["Temple of Ahn'Qiraj"] = "Temple of Ahn'Qiraj",
	["Terokk's Rest"] = "Terokk's Rest",
	["Terokkar Forest"] = "Terokkar Forest",
	["The Arachnid Quarter"] = "The Arachnid Quarter",
	["The Arcatraz"] = "The Arcatraz",
	["The Argent Coliseum"] = "The Argent Coliseum",
	["The Barrens"] = "The Barrens",
	["The Bastion of Twilight"] = "The Bastion of Twilight",
	["The Black Morass"] = "The Black Morass",
	["The Blood Furnace"] = "The Blood Furnace",
	["The Bone Wastes"] = "The Bone Wastes",
	["The Botanica"] = "The Botanica",
	["The Cape of Stranglethorn"] = "The Cape of Stranglethorn",
	["The Construct Quarter"] = "The Construct Quarter",
	["The Culling of Stratholme"] = "The Culling of Stratholme",
	["The Dark Portal"] = "The Dark Portal",
	["The Deadmines"] = "The Deadmines",
	["The Descent into Madness"] = "The Descent into Madness",
	["The Exodar"] = "The Exodar",
	["The Eye"] = "The Eye",
	["The Eye of Eternity"] = "The Eye of Eternity",
	["The Forbidding Sea"] = "The Forbidding Sea",
	["The Forge of Souls"] = "The Forge of Souls",
	["The Frozen Halls"] = "The Frozen Halls",
	["The Frozen Sea"] = "The Frozen Sea",
	["The Great Sea"] = "The Great Sea",
	["The Halls of Winter"] = "The Halls of Winter",
	["The Hinterlands"] = "The Hinterlands",
	["The Mechanar"] = "The Mechanar",
	["The Military Quarter"] = "The Military Quarter",
	["The Nexus"] = "The Nexus",
	["The North Sea"] = "The North Sea",
	["The Obsidian Sanctum"] = "The Obsidian Sanctum",
	["The Oculus"] = "The Oculus",
	["The Plague Quarter"] = "The Plague Quarter",
	["The Prison of Yogg-Saron"] = "The Prison of Yogg-Saron",
	["The Ring of Valor"] = "The Ring of Valor",
	["The Ruby Sanctum"] = "The Ruby Sanctum",
	["The Scarlet Enclave"] = "The Scarlet Enclave",
	["The Shattered Halls"] = "The Shattered Halls",
	["The Slave Pens"] = "The Slave Pens",
	["The Spark of Imagination"] = "The Spark of Imagination",
	["The Steamvault"] = "The Steamvault",
	["The Stockade"] = "The Stockade",
	["The Stonecore"] = "The Stonecore",
	["The Storm Peaks"] = "The Storm Peaks",
	["The Temple of Atal'Hakkar"] = "The Temple of Atal'Hakkar",
	["The Underbog"] = "The Underbog",
	["The Veiled Sea"] = "The Veiled Sea",
	["The Violet Hold"] = "The Violet Hold",
	["The Vortex Pinnacle"] = "The Vortex Pinnacle",
	["Theramore Isle"] = "Theramore Isle",
	["Thousand Needles"] = "Thousand Needles",
	["Throne of the Four Winds"] = "Throne of the Four Winds",
	["Throne of the Tides"] = "Throne of the Tides",
	["Thunder Bluff"] = "Thunder Bluff",
	["Tirisfal"] = "Tirisfal",
	["Tirisfal Glades"] = "Tirisfal Glades",
	["Trial of the Champion"] = "Trial of the Champion",
	["Trial of the Crusader"] = "Trial of the Crusader",
	["Twilight Highlands"] = "Twilight Highlands",
	["Twisting Nether"] = "Twisting Nether",
	["Uldaman"] = "Uldaman",
	["Ulduar"] = "Ulduar",
	["Uldum"] = "Uldum",
	["Un'Goro Crater"] = "Un'Goro Crater",
	["Undercity"] = "Undercity",
	["Upper Blackrock Spire"] = "Upper Blackrock Spire",
	["Utgarde Keep"] = "Utgarde Keep",
	["Utgarde Pinnacle"] = "Utgarde Pinnacle",
	["Vashj'ir"] = "Vashj'ir",
	["Vault of Archavon"] = "Vault of Archavon",
	["Wailing Caverns"] = "Wailing Caverns",
	["Warsong Gulch"] = "Warsong Gulch",
	["Western Plaguelands"] = "Western Plaguelands",
	["Westfall"] = "Westfall",
	["Wetlands"] = "Wetlands",
	["Wintergrasp"] = "Wintergrasp",
	["Winterspring"] = "Winterspring",
	["Wyrmrest Temple"] = "Wyrmrest Temple",
	["Zangarmarsh"] = "Zangarmarsh",
	["Zul'Aman"] = "Zul'Aman",
	["Zul'Drak"] = "Zul'Drak",
	["Zul'Farrak"] = "Zul'Farrak",
	["Zul'Gurub"] = "Zul'Gurub",
}

FatCooldowns.Classic = {
	["Blackfathom Deeps"] = false,
	["Blackrock Depths"] = false,
	["Lower Blackrock Spire"] = false,
	["Upper Blackrock Spire"] = false,
	["Blackwing Lair"] = false,
	["The Deadmines"] = false,
	["Dire Maul"] = false,
	["Dire Maul (East)"] = false,
	["Dire Maul (West)"] = false,
	["Dire Maul (North)"] = false,
	["Gnomeregan"] = false,
	["Maraudon"] = false,
	["Molten Core"] = false,
	["Ragefire Chasm"] = false,
	["Razorfen Downs"] = false,
	["Razorfen Kraul"] = false,
	["Ruins of Ahn'Qiraj"] = false,
	["Scarlet Monastery"] = false,
	["Scholomance"] = false,
	["Shadowfang Keep"] = false,
	["The Stockade"] = false,
	["Stratholme"] = false,
	["Temple of Ahn'Qiraj"] = false,
	["The Temple of Atal'Hakkar"] = false,
	["Uldaman"] = false,
	["Wailing Caverns"] = false,
	["Zul'Farrak"] = false,
	["Zul'Gurub"] = false,
}

FatCooldowns.TBC = {
	["Auchindoun"] = false,
	["Mana-Tombs"] = false,
	["Auchenai Crypts"] = false,
	["Sethekk Halls"] = false,
	["Shadow Labyrinth"] = false,
	["Black Temple"] = false,
	["Caverns of Time"] = false,
	["Old Hillsbrad Foothills"] = false,
	["The Black Morass"] = false,
	["Hyjal Summit"] = false,
	["Coilfang Reservoir"] = false,
	["The Slave Pens"] = false,
	["The Underbog"] = false,
	["The Steamvault"] = false,
	["Serpentshrine Cavern"] = false,
	["Gruul's Lair"] = false,
	["Hellfire Citadel"] = false,
	["Hellfire Ramparts"] = false,
	["The Blood Furnace"] = false,
	["The Shattered Halls"] = false,
	["Magtheridon's Lair"] = false,
	["Karazhan"] = false,
	["Magisters' Terrace"] = false,
	["Sunwell Plateau"] = false,
	["Tempest Keep"] = false,
	["The Mechanar"] = false,
	["The Botanica"] = false,
	["The Arcatraz"] = false,
	["The Eye"] = false,
	["Zul'Aman"] = false,
}

FatCooldowns.Wotlk = {
	["Ahn'kahet: The Old Kingdom"] = false,
	["Azjol-Nerub"] = false,
	["Caverns of Time"] = false,
	["The Culling of Stratholme"] = false,
	["Drak'Tharon Keep"] = false,
	["Gundrak"] = false,
	["Halls of Lightning"] = false,
	["Halls of Stone"] = false,
	["Halls of Reflection"] = false,
	["Icecrown Citadel"] = false,
	["Naxxramas"] = false,
	["Onyxia's Lair"] = false,
	["Pit of Saron"] = false,
	["The Ruby Sanctum"] = false,
	["The Eye of Eternity"] = false,
	["The Forge of Souls"] = false,
	["The Nexus"] = false,
	["The Obsidian Sanctum"] = false,
	["The Oculus"] = false,
	["Trial of the Champion"] = false,
	["Trial of the Crusader"] = false,
	["Ulduar"] = false,
	["Utgarde Keep"] = false,
	["Utgarde Pinnacle"] = false,
	["Vault of Archavon"] = false,
	["The Violet Hold"] = false,
}

FatCooldowns.QirajiMountInfo = {
	[25953] = {"Blue Qiraji Battle Tank"},
	[64656] = {"Blue Skeletal Warhorse"},
	[26056] = {"Green Qiraji Battle Tank"},
	[26054] = {"Red Qiraji Battle Tank"},
	[26055] = {"Yellow Qiraji Battle Tank"}
}

FatCooldowns.GroundMountInfo = {
	[35022] = {"Black Hawkstrider"},
	[59572] = {"Black Polar Bear"},
	[64977] = {"Black Skeletal Horse"},
	[470] = {"Black Stallion"},
	[578] = {"Black Wolf"},
	[64658] = {"Black Wolf"},
	[35020] = {"Blue Hawkstrider"},
	[10969] = {"Blue Mechanostrider"},
	[33630] = {"Blue Mechanostrider"},
	[6897] = {"Blue Ram"},
	[50869] = {"Brewfest Kodo"},
	[43899] = {"Brewfest Ram"},
	[50870] = {"Brewfest Ram"},
	[49378] = {"Brewfest Riding Kodo"},
	[34406] = {"Brown Elekk"},
	[458] = {"Brown Horse"},
	[18990] = {"Brown Kodo"},
	[6899] = {"Brown Ram"},
	[6648] = {"Chestnut Mare"},
	[5784] = {"Felsteed"},
	[17458] = {"Fluorescent Green Mechanostrider"},
	[16060] = {"Golden Sabercat"},
	[35710] = {"Gray Elekk"},
	[18989] = {"Gray Kodo"},
	[6777] = {"Gray Ram"},
	[459] = {"Gray Wolf"},
	[15780] = {"Green Mechanostrider"},
	[17453] = {"Green Mechanostrider"},
	[10798] = {"Obsidian Raptor"},
	[471] = {"Palamino"},
	[472] = {"Pinto"},
	[16058] = {"Primal Leopard"},
	[35711] = {"Purple Elekk"},
	[35018] = {"Purple Hawkstrider"},
	[17455] = {"Purple Mechanostrider"},
	[17456] = {"Red and Blue Mechanostrider"},
	[34795] = {"Red Hawkstrider"},
	[10873] = {"Red Mechanostrider"},
	[18363] = {"Riding Kodo"},
	[64731] = {"Sea Turtle"},
	[8980] = {"Skeletal Horse"},
	[42776] = {"Spectral Tiger"},
	[10789] = {"Spotted Frostsaber"},
	[15781] = {"Steel Mechanostrider"},
	[66847] = {"Striped Dawnsaber"},
	[8394] = {"Striped Frostsaber"},
	[10793] = {"Striped Nightsaber"},
	[34769] = {"Summon Warhorse"},
	[16059] = {"Tawny Sabercat"},
	[17454] = {"Unpainted Mechanostrider"},
	[13819] = {"Warhorse"},
	[64657] = {"White Kodo"},
	[6898] = {"White Ram"},

	[17463] = {"Blue Skeletal Horse"},
	[17464] = {"Brown Skeletal Horse"},
	[6654] = {"Brown Wolf"},
	[6653] = {"Dire Wolf"},
	[8395] = {"Emerald Raptor"},
	[17462] = {"Red Skeletal Horse"},
	[580] = {"Timber Wolf"},
	[10796] = {"Turquoise Raptor"},
	[10799] = {"Violet Raptor"},
}

FatCooldowns.FastGroundMountInfo = {
	[43688] = {"Amani War Bear"},
	[16056] = {"Ancient Frostsaber"},
	[48778] = {"Acherus Deathcharger"},
	[66906] = {"Argent Charger"},
	[67466] = {"Argent Warhorse"},
	[60114] = {"Armored Brown Bear"},
	[60116] = {"Armored Brown Bear"},
	[51412] = {"Big Battle Bear"},
	[22719] = {"Black Battlestrider"},
	[16055] = {"Black Nightsaber"},
	[26656] = {"Black Qiraji Battle Tank"},
	[6896] = {"Black Ram"},
	[17461] = {"Black Ram"},
	[60118] = {"Black War Bear"},
	[60119] = {"Black War Bear"},
	[48027] = {"Black War Elekk"},
	[22718] = {"Black War Kodo"},
	[59785] = {"Black War Mammoth"},
	[59788] = {"Black War Mammoth"},
	[22720] = {"Black War Ram"},
	[22717] = {"Black War Steed"},
	[22723] = {"Black War Tiger"},
	[59573] = {"Brown Polar Bear"},
	[23214] = {"Charger"},
	[39315] = {"Cobalt Riding Talbuk"},
	[34896] = {"Cobalt War Talbuk"},
	[39316] = {"Dark Riding Talbuk"},
	[34790] = {"Dark War Talbuk"},
	[63635] = {"Darkspear Raptor"},
	[63637] = {"Darnassian Nightsaber"},
	[23161] = {"Dreadsteed"},
	[63639] = {"Exodar Elekk"},
	[36702] = {"Fiery Warhorse"},
	[63643] = {"Forsaken Warhorse"},
	[17460] = {"Frost Ram"},
	[63638] = {"Gnomeregan Mechanostrider"},
	[59810] = {"Grand Black War Mammoth"},
	[59811] = {"Grand Black War Mammoth"},
	[61465] = {"Grand Black War Mammoth"},
	[61467] = {"Grand Black War Mammoth"},
	[60136] = {"Grand Caravan Mammoth"},
	[60140] = {"Grand Caravan Mammoth"},
	[59802] = {"Grand Ice Mammoth"},
	[59804] = {"Grand Ice Mammoth"},
	[61469] = {"Grand Ice Mammoth"},
	[61470] = {"Grand Ice Mammoth"},
	[63639] = {"Great Azuremyst Elekk"},
	[35713] = {"Great Blue Elekk"},
	[49379] = {"Great Brewfest Kodo"},
	[23249] = {"Great Brown Kodo"},
	[34407] = {"Great Elite Elekk"},
	[65641] = {"Great Golden Kodo"},
	[23248] = {"Great Gray Kodo"},
	[35712] = {"Great Green Elekk"},
	[63641] = {"Great Mulgore Kodo"},
	[35714] = {"Great Purple Elekk"},
	[65637] = {"Great Red Elekk"},
	[23247] = {"Great White Kodo"},
	[18991] = {"Green Kodo"},
	[59797] = {"Ice Mammoth"},
	[59799] = {"Ice Mammoth"},
	[17459] = {"Icy Blue Mechanostrider Mod A"},
	[63636] = {"Ironforge Ram"},
	[10795] = {"Ivory Raptor"},
	[17450] = {"Ivory Raptor"},
	[65917] = {"Magic Rooster"},
	[66122] = {"Magic Rooster"},
	[66123] = {"Magic Rooster"},
	[66124] = {"Magic Rooster"},
	[55531] = {"Mechano-hog"},
	[60424] = {"Mekgineer's Chopper"},
	[16084] = {"Mottled Red Raptor"},
	[29059] = {"Naxxramas Deathcharger"},
	[66846] = {"Ochre Skeletal Warhorse"},
	[63640] = {"Orgrimmar Wolf"},
	[16082] = {"Palomino"},
	[66090] = {"Quel'dorei Steed"},
	[41252] = {"Raven Lord"},
	[579] = {"Red Wolf"},
	[16080] = {"Red Wolf"},
	[39317] = {"Silver Riding Talbuk"},
	[34898] = {"Silver War Talbuk"},
	[63642] = {"Silvermoon Hawkstrider"},
	[23510] = {"Stormpike Battle Charger"},
	[63232] = {"Stormwind Steed"},
	[34767] = {"Summon Charger"},
	[66091] = {"Sunreaver Hawkstrider"},
	[68057] = {"Swift Alliance Steed"},
	[43900] = {"Swift Brewfest Ram"},
	[23238] = {"Swift Brown Ram"},
	[23229] = {"Swift Brown Steed"},
	[65646] = {"Swift Burgundy Wolf"},
	[63635] = {"Swift Darkspear Raptor"},
	[63637] = {"Swift Darnassian Mistsaber"},
	[23220] = {"Swift Dawnsaber"},
	[63232] = {"Swift Elwynn Steed"},
	[23221] = {"Swift Frostsaber"},
	[23239] = {"Swift Gray Ram"},
	[65640] = {"Swift Gray Steed"},
	[35025] = {"Swift Green Hawkstrider"},
	[23225] = {"Swift Green Mechanostrider"},
	[68056] = {"Swift Horde Wolf"},
	[63636] = {"Swift Ironforge Ram"},
	[23219] = {"Swift Mistsaber"},
	[65636] = {"Swift Moonsaber"},
	[65638] = {"Swift Moonsaber"},
	[63640] = {"Swift Orgrimmar Wolf"},
	[23227] = {"Swift Palomino"},
	[33660] = {"Swift Pink Hawkstrider"},
	[35027] = {"Swift Purple Hawkstrider"},
	[65644] = {"Swift Purple Raptor"},
	[24242] = {"Swift Razzashi Raptor"},
	[65639] = {"Swift Red Hawkstrider"},
	[63642] = {"Swift Silvermoon Hawkstrider"},
	[23338] = {"Swift Stormsaber"},
	[65643] = {"Swift Violet Ram"},
	[47037] = {"Swift War Elekk"},
	[35028] = {"Swift Warstrider"},
	[46628] = {"Swift White Hawkstrider"},
	[23223] = {"Swift White Mechanostrider"},
	[23240] = {"Swift White Ram"},
	[23228] = {"Swift White Steed"},
	[23222] = {"Swift Yellow Mechanostrider"},
	[48954] = {"Swift Zhevra"},
	[49322] = {"Swift Zhevra"},
	[24252] = {"Swift Zulian Tiger"},
	[39318] = {"Tan Riding Talbuk"},
	[34899] = {"Tan War Talbuk"},
	[18992] = {"Teal Kodo"},
	[63641] = {"Thunder Bluff Kodo"},
	[61425] = {"Traveler's Tundra Mammoth"},
	[61447] = {"Traveler's Tundra Mammoth"},
	[65642] = {"Turbostrider"},
	[42781] = {"Upper Deck - Spectral Tiger Mount"},
	[64659] = {"Venomhide Ravasaur"},
	[46102] = {"Venomhide Ravasaur"},
	[15779] = {"White Mechanostrider Mod B"},
	[54753] = {"White Polar Bear Mount"},
	[39319] = {"White Riding Talbuk"},
	[65645] = {"White Skeletal Warhorse"},
	[468] = {"White Stallion"},
	[16083] = {"White Stallion"},
	[34897] = {"White War Talbuk"},
	[581] = {"Winter Wolf"},
	[16081] = {"Winter Wolf"},
	[17229] = {"Winterspring Frostsaber"},
	[59791] = {"Wooly Mammoth"},
	[59793] = {"Wooly Mammoth"},

	[72286] = {"Invincible"},
	[48025] = {"Headless Horseman's Mount"},
	[73313] = {"Crimson Deathcharger"},
	[75614] = {"Celestial Steed"},
	[71342] = {"Big Love Rocket"},

	[58983] = {"Big Blizzard Bear"},
	[42777] = {"Swift Spectral Tiger"},
	[22721] = {"Black War Raptor"},
	[22724] = {"Black War Wolf"},
	[23509] = {"Frostwolf Howler"},
	[17465] = {"Green Skeletal Warhorse"},
	[23246] = {"Purple Skeletal Warhorse"},
	[22722] = {"Red Skeletal Warhorse"},
	[17481] = {"Rivendare's Deathcharger"},
	[23241] = {"Swift Blue Raptor"},
	[23250] = {"Swift Brown Wolf"},
	[23252] = {"Swift Gray Wolf"},
	[23242] = {"Swift Olive Raptor"},
	[23243] = {"Swift Orange Raptor"},
	[23251] = {"Swift Timber Wolf"},
}

FatCooldowns.FastFlyingMountInfo = {
	[60025] = {"Albino Drake"},
	[63844] = {"Argent Hippogryph"},
	[61230] = {"Armored Blue Wind Rider"},
	[61229] = {"Armored Snowy Gryphon"},
	[59567] = {"Azure Drake"},
	[41514] = {"Azure Netherwing Drake"},
	[62048] = {"Black Dragonhawk Mount"},
	[59650] = {"Black Drake"},
	[61996] = {"Blue Dragonhawk"},
	[59568] = {"Blue Drake"},
	[59996] = {"Blue Proto-Drake"},
	[39803] = {"Blue Riding Nether Ray"},
	[59569] = {"Bronze Drake"},
	[58615] = {"Brutal Nether Drake"},
	[43927] = {"Cenarion War Hippogryph"},
	[41515] = {"Cobalt Netherwing Drake"},
	[64927] = {"Deadly Gladiator's Frostwyrm"},
	[43810] = {"Frost Wyrm"},
	[51960] = {"Frostwyrm Mount"},
	[75596] = {"Frosty Flying Carpet"},
	[61294] = {"Green Proto-Drake"},
	[39798] = {"Green Riding Nether Ray"},
	[61309] = {"Magnificent Flying Carpet"},
	[44317] = {"Merciless Nether Drake"},
	[44744] = {"Merciless Nether Drake"},
	[3363] = {"Nether Drake"},
	[28828] = {"Nether Drake"},
	[41513] = {"Onyx Netherwing Drake"},
	[32345] = {"Peep the Phoenix Mount"},
	[41516] = {"Purple Netherwing Drake"},
	[39801] = {"Purple Riding Nether Ray"},
	[61997] = {"Red Dragonhawk"},
	[59570] = {"Red Drake"},
	[59961] = {"Red Proto-Drake"},
	[39800] = {"Red Riding Nether Ray"},
	[66087] = {"Silver Covenant Hippogryph"},
	[39802] = {"Silver Riding Nether Ray"},
	[66088] = {"Sunreaver Dragonhawk"},
	[32242] = {"Swift Blue Gryphon"},
	[32290] = {"Swift Green Gryphon"},
	[32295] = {"Swift Green Wind Rider"},
	[61442] = {"Swift Mooncloth Carpet"},
	[32292] = {"Swift Purple Gryphon"},
	[32297] = {"Swift Purple Wind Rider"},
	[32289] = {"Swift Red Gryphon"},
	[32246] = {"Swift Red Wind Rider"},
	[61444] = {"Swift Shadoweave Carpet"},
	[61446] = {"Swift Spellfire Carpet"},
	[32296] = {"Swift Yellow Wind Rider"},
	[60002] = {"Time-Lost Proto-Drake"},
	[44151] = {"Turbo-Charged Flying Machine"},
	[59571] = {"Twilight Drake"},
	[49193] = {"Vengeful Nether Drake"},
	[41517] = {"Veridian Netherwing Drake"},
	[41518] = {"Violet Netherwing Drake"},
	[46197] = {"X-51 Nether-Rocket"},
	[46199] = {"X-51 Nether-Rocket X-TREME"},

	[54729] = {"Winged Steed of the Ebon Blade"},
	[48025] = {"Headless Horseman's Mount"},
	[75614] = {"Celestial Steed"},
	[71342] = {"Big Love Rocket"},
}

FatCooldowns.FlyingMountInfo = {
	[32244] = {"Blue Wind Rider"},
	[32239] = {"Ebon Gryphon"},
	[61451] = {"Flying Carpet"},
	[44153] = {"Flying Machine"},
	[32235] = {"Golden Gryphon"},
	[32245] = {"Green Wind Rider"},
	[32240] = {"Snowy Gryphon"},
	[32243] = {"Tawny Wind Rider"},
}

FatCooldowns.EpicFlyingMountInfo = {
	[40192] = {"Ashes of Al'ar"},
	[59976] = {"Black Proto-Drake"},
	[72808] = {"Bloodbathed Frostbrood Vanquisher"},
	[72807] = {"Icebound Frostbrood Vanquisher"},
	[63956] = {"Ironbound Proto-Drake"},
	[63796] = {"Mimiron's Head"},
	[69395] = {"Onyxian Drake"},
	[60021] = {"Plagued Proto-Drake"},
	[63963] = {"Rusted Proto-Drake"},
	[37015] = {"Swift Nether Drake"},
	[60024] = {"Violet Proto-Drake"},
	[75973] = {"X-53 Touring Rocket"},

	[72286] = {"Invincible"},
}

FatCooldowns.TalentProcData = {
	-- DEATHKNIGHT
	[59052] = true,
	[51124] = true,

	--MAGE
	[70753] = true,
	[48108] = true,
	[54646] = true,

	--PALADIN
	[54153] = true,
	[54152] = true,
	[53657] = true,
	[53656] = true,
	[53655] = true,
	[53563] = true,

	--WARLOCK
	[48090] = true,
	[63321] = true,
}

FatCooldowns.SpellsFaction = {
	--Paladin
	[34769] = "Horde",
	[34767] = "Horde",
	[348704] = "Horde",
	[53736] = "Horde",

	-- Shaman
	[2825] = "Horde",

	--Mage
	[3567] = "Horde",
	[3563] = "Horde",
	[32272] = "Horde",
	[3566] = "Horde",
	[49361] = "Horde",
	[49358] = "Horde",
	[11417] = "Horde",
	[11418] = "Horde",
	[32267] = "Horde",
	[11420] = "Horde",
	[35715] = "Horde",
	[35717] = "Horde",

	--Paladin
	[31801] = "Alliance",

	--Shaman
	[32182] = "Alliance",

	--Mage
	[3561] = "Alliance",
	[3562] = "Alliance",
	[32271] = "Alliance",
	[3565] = "Alliance",
	[49360] = "Alliance",
	[49359] = "Alliance",
	[10059] = "Alliance",
	[11416] = "Alliance",
	[32266] = "Alliance",
	[11419] = "Alliance",
	[33690] = "Alliance",
	[33691] = "Alliance",
}

FatCooldowns.SpellDataTalents = {
	[25899] = "Blessing of Sanctuary",
	[5487] = "Bear Form",
	[54785] = "Metamorphosis",
	[50581] = "Metamorphosis",
	[50589] = "Metamorphosis",

	[20911] = true,

	[33876] = true,
	[33982] = true,
	[33983] = true,
	[48565] = true,
	[48566] = true,
	

	[33878] = true,
	[33986] = true,
	[33987] = true,
	[48563] = true,
	[48564] = true,
	

	[33891] = true,

	
	[12524] = true,
	[60051] = true,
	[25248] = true,
	[47827] = true,
	[20925] = true,
	[20929] = true,
	[63669] = true,
	[55262] = true,
	[55270] = true,
	[49158] = true,
	[53007] = true,
	[48951] = true,
	[59159] = true,
	[18937] = true,
	[27870] = true,
	[48999] = true,
	[20910] = true,
	[48505] = true,
	[42950] = true,
	[51326] = true,
	[27133] = true,
	[44457] = true,
	[61295] = true,
	[19240] = true,
	[48952] = true,
	[48824] = true,
	[60052] = true,
	[21551] = true,
	[51490] = true,
	[51325] = true,
	[53199] = true,
	[19306] = true,
	[15407] = true,
	[49143] = true,
	[55271] = true,
	[43039] = true,
	[16511] = true,
	[48155] = true,
	[42945] = true,
	[30405] = true,
	[55261] = true,
	[30022] = true,
	[33405] = true,
	[63670] = true,
	[18809] = true,
	[55359] = true,
	[49283] = true,
	[18867] = true,
	[32700] = true,
	[47486] = true,
	[53223] = true,
	[17312] = true,
	[19236] = true,
	[27265] = true,
	[24974] = true,
	[42944] = true,
	[20902] = true,
	[48825] = true,
	[60053] = true,
	[63672] = true,
	[17348] = true,
	[34411] = true,
	[53200] = true,
	[20930] = true,
	[63671] = true,
	[61384] = true,
	[18938] = true,
	[59164] = true,
	[53248] = true,
	[48156] = true,
	[49184] = true,
	[48172] = true,
	[11366] = true,
	[31935] = true,
	[59161] = true,
	[30413] = true,
	[28275] = true,
	[27871] = true,
	[43038] = true,
	[53201] = true,
	[30404] = true,
	[12526] = true,
	[12525] = true,
	[51328] = true,
	[27134] = true,
	[49049] = true,
	[13032] = true,
	[19241] = true,
	[42949] = true,
	[48826] = true,
	[59170] = true,
	[21552] = true,
	[18869] = true,
	[20903] = true,
	[27174] = true,
	[48666] = true,
	[33072] = true,
	[34865] = true,
	[33041] = true,
	[20901] = true,
	[53249] = true,
	[18870] = true,
	[55050] = true,
	[48173] = true,
	[724] = true,
	[42891] = true,
	[18807] = true,
	[55090] = true,
	[33933] = true,
	[50516] = true,
	[32593] = true,
	[12505] = true,
	[42890] = true,
	[13019] = true,
	[13021] = true,
	[17313] = true,
	[34413] = true,
	[49050] = true,
	[24975] = true,
	[13031] = true,
	[13033] = true,
	[48827] = true,
	[18871] = true,
	[53225] = true,
	[48086] = true,
	[51409] = true,
	[51417] = true,
	[44780] = true,
	[55258] = true,
	[34866] = true,
	[44781] = true,
	[27067] = true,
	[31661] = true,
	[12294] = true,
	[53005] = true,
	[34914] = true,
	[34412] = true,
	[27065] = true,
	[59163] = true,
	[30414] = true,
	[20473] = true,
	[49011] = true,
	[30330] = true,
	[20909] = true,
	[50796] = true,
	[12523] = true,
	[47497] = true,
	[55360] = true,
	[51419] = true,
	[57721] = true,
	[1329] = true,
	[19242] = true,
	[51411] = true,
	[48088] = true,
	[32699] = true,
	[21553] = true,
	[33042] = true,
	[51410] = true,
	[51418] = true,
	[27179] = true,
	[55259] = true,
	[59092] = true,
	[47846] = true,
	[51416] = true,
	[53251] = true,
	[48159] = true,
	[61299] = true,
	[30016] = true,
	[48438] = true,
	[59156] = true,
	[30283] = true,
	[59172] = true,
	[30546] = true,
	[61300] = true,
	[32594] = true,
	[20927] = true,
	[49012] = true,
	[47498] = true,
	[5570] = true,
	[17314] = true,
	[11113] = true,
	[57722] = true,
	[24976] = true,
	[20900] = true,
	[20904] = true,
	[18868] = true,
	[48087] = true,
	[19386] = true,
	[33043] = true,
	[47841] = true,
	[30108] = true,
	[20928] = true,
	[55260] = true,
	[55268] = true,
	[33938] = true,
	[27068] = true,
	[26864] = true,
	[48160] = true,
	[57720] = true,
	[34916] = true,
	[34864] = true,
	[59171] = true,
	[27263] = true,
	[17347] = true,
	[48660] = true,
	[53226] = true,
	[12522] = true,
	[47847] = true,
	[48468] = true,
	[11426] = true,
	[49284] = true,
	[27132] = true,
	[30706] = true,
	[47843] = true,
	[61301] = true,
	[19243] = true,
	[25437] = true,
	[47485] = true,
	[18220] = true,
	[47826] = true,
	[48089] = true,
	[25387] = true,
	[55265] = true,
	[63668] = true,
	[34861] = true,
	[19434] = true,
	[24132] = true,
	[17877] = true,
	[48663] = true,
	[53006] = true,
	[34863] = true,
	[34917] = true,
	[20243] = true,
	[59158] = true,
	[53301] = true,
	[3674] = true,
	[24133] = true,
	[974] = true,
	[48998] = true,
	[44425] = true,
	[13018] = true,
	[13020] = true,
	[17311] = true,
	[51327] = true,
	[19238] = true,
	[27013] = true,
	[24977] = true,
	[47540] = true,
	[48181] = true,
	[49376] = true,
	[16979] = true,

}

FatCooldowns.SpellDataFails = {
	{465,10290,643,10291,1032,10292,10293,27149,48941,48942},
	{633,2800,10310,27154,48788},
	{7294,10298,10299,10300,10301,27150,54043},
	{19876,19895,19896,27151,48943},
	{19888,19897,19898,27152,48945},
	{19891,19899,19900,27153,48947},
	{31785,33776},
	{99,1735,9490,9747,9898,26998,48559,48560},
	{779,780,769,9754,9908,26997,48561,48562},
	{1079,9492,9493,9752,9894,9896,27008,49799,49800},
	{1082,3029,5201,9849,9850,27000,48569,48570},
	{1822,1823,1824,9904,27003,48573,48574},
	{1850,9821,33357},
	{5211,6798,8983},
	{5215},
	{5217,6793,9845,9846,50212,50213},
	{5221,6800,8992,9829,9830,27001,27002,48571,48572},
	{6785,6787,9866,9867,27005,48578,48579},
	{6807,6808,6809,8972,9745,9880,9881,26996,48479,48480},
	{8998,9000,9892,31709,27004,48575},
	{9005,9823,9827,27006,49803},
	{16857},
	{22568,22827,22828,22829,31018,24248,48576,48577},
	{22570,49802},
	{22842},
	{33745,48567,48568},
	{33876,33982,33983,48565,48566},
	{33878,33986,33987,48563,48564},
	{33943,40120},
	{72},
	{78,284,285,1608,11564,11565,11566,11567,25286,29707,30324,47449,47450},
	{100,6178,11578},
	{469,47439,47440},
	{694},
	{772,6546,6547,6548,11572,11573,11574,25208,46845,47465},
	{845,7369,11608,11609,20569,25231,47519,47520},
	{1160,6190,11554,11555,11556,25202,25203,47437},
	{1464,8820,11604,11605,25241,25242,47474,47475},
	{1715},
	{6673,5242,6192,11549,11550,11551,25289,2048,47436},
	{5308,20658,20660,20661,20662,25234,25236,47470,47471},
	{6343,8198,8204,8205,11580,11581,25264,47501,47502},
	{6552},
	{6572,6574,7379,11600,11601,25288,25269,30357,57823},
	{7384},
	{7386},
	{20252},
	{23922,23923,23924,23925,25258,30356,47487,47488},
	{12294,21551,21552,21553,25248,30330,47485,47486},
	{20243,30016,30022,47497,47498},
	{23881},
	{29801},
	{43265,49936,49937,49938},
	{45462,49917,49918,49919,49920,49921},
	{49998,49999,45463,49923,49924},
	{45477,49896,49903,49904,49909},
	{45902,49926,49927,49928,49929,49930},
	{47541,49892,49893,49894,49895},
	{48721,49939,49940,49941},
	{49020,51423,51424,51425},
	{57330,57623},
	{49143,51416,51417,51418,51419,55268},
	{49158,51325,51326,51327,51328},
	{49184,51409,51410,51411},
	{55050,55258,55259,55260,55261,55262},
	{55090,55265,55270,55271},
	{53,2589,2590,2591,8721,11279,11280,11281,25300,26863,48656,48657},
	{408,8643},
	{703,8631,8632,8633,11289,11290,26839,26884,48675,48676},
	{1752,1757,1758,1759,1760,8621,11293,11294,26861,26862,48637,48638},
	{1766},
	{1776},
	{1784},
	{1856,1857,26889},
	{1943,8639,8640,11273,11274,11275,26867,48671,48672},
	{1966,6768,8637,11303,25302,27448,48658,48659},
	{6770,2070,11297,51724},
	{2098,6760,6761,6762,8623,8624,11299,11300,31016,26865,48667,48668},
	{2983,8696,11305},
	{5171,6774},
	{5277,26669},
	{8647},
	{8676,8724,8725,11267,11268,11269,27441,48689,48690,48691},
	{26679,48673,48674},
	{32645,32684,57992,57993},
	{1329,34411,34412,34413,48663,48666}
}

FatCooldowns.SpellData = {
	[10] = { level=20, rank=1, next=6141, class="MAGE" }, -- Blizzard
	[17] = { level=6, rank=1, next=592, class="PRIEST" }, -- Power Word: Shield
	[53] = { level=4, rank=1, next=2589, class="ROGUE" }, -- Backstab
	[66] = { level=68, class="MAGE" }, -- Invisibility
	[71] = { level=10, class="WARRIOR" }, -- Defensive Stance
	[72] = { level=12, class="WARRIOR" }, -- Shield Bash
	[1126] = { level=1, rank=1, next=5232, class="DRUID" }, -- Mark of the Wild
	[99] = { level=10, rank=1, next=1735, class="DRUID" }, -- Demoralizing Roar
	[100] = { level=4, rank=1, next=6178, class="WARRIOR" }, -- Charge
	[116] = { level=4, rank=1, next=205, class="MAGE" }, -- Frostbolt
	[118] = { level=8, rank=1, next=12824, class="MAGE" }, -- Polymorph
	[120] = { level=26, rank=1, next=8492, class="MAGE" }, -- Cone of Cold
	[122] = { level=10, rank=1, next=865, class="MAGE" }, -- Frost Nova
	[126] = { level=22, class="WARLOCK" }, -- Eye of Kilrogg
	[130] = { level=12, class="MAGE" }, -- Slow Fall
	[131] = { level=22, class="SHAMAN" }, -- Water Breathing
	[132] = { level=26, class="WARLOCK" }, -- Detect Invisibility
	[5176] = { level=1, rank=1, next=5177, class="DRUID" }, -- Wrath
	[136] = { level=12, rank=1, next=3111, class="HUNTER" }, -- Mend Pet
	[139] = { level=8, rank=1, next=6074, class="PRIEST" }, -- Renew
	[143] = { level=6, rank=2, next=145, class="MAGE" }, -- Fireball
	[145] = { level=12, rank=3, next=3140, class="MAGE" }, -- Fireball
	[5185] = { level=1, rank=1, next=5186, class="DRUID" }, -- Healing Touch
	[172] = { level=4, rank=1, next=6222, class="WARLOCK" }, -- Corruption
	[205] = { level=8, rank=2, next=837, class="MAGE" }, -- Frostbolt
	[284] = { level=8, rank=2, next=285, class="WARRIOR" }, -- Heroic Strike
	[285] = { level=16, rank=3, next=1608, class="WARRIOR" }, -- Heroic Strike
	[324] = { level=8, rank=1, next=325, class="SHAMAN" }, -- Lightning Shield
	[325] = { level=16, rank=2, next=905, class="SHAMAN" }, -- Lightning Shield
	[2973] = { level=1, rank=1, next=14260, class="HUNTER" }, -- Raptor Strike
	[332] = { level=6, rank=2, next=547, class="SHAMAN" }, -- Healing Wave
	[339] = { level=8, rank=1, next=1062, class="DRUID" }, -- Entangling Roots
	[133] = { level=1, rank=1, next=143, class="MAGE" }, -- Fireball
	[355] = { level=10, class="WARRIOR" }, -- Taunt
	[370] = { level=12, rank=1, next=8012, class="SHAMAN" }, -- Purge
	[168] = { level=1, rank=1, next=7300, class="MAGE" }, -- Frost Armor
	[408] = { level=30, rank=1, next=8643, class="ROGUE" }, -- Kidney Shot
	[421] = { level=32, rank=1, next=930, class="SHAMAN" }, -- Chain Lightning
	[453] = { level=20, class="PRIEST" }, -- Mind Soothe
	[1459] = { level=1, rank=1, next=1460, class="MAGE" }, -- Arcane Intellect
	[467] = { level=6, rank=1, next=782, class="DRUID" }, -- Thorns
	[469] = { level=68, rank=1, next=47439, class="WARRIOR" }, -- Commanding Shout
	[475] = { level=18, class="MAGE" }, -- Remove Curse
	[498] = { level=6, class="PALADIN" }, -- Divine Protection
	[526] = { level=16, class="SHAMAN" }, -- Cure Toxins
	[527] = { level=18, rank=1, next=988, class="PRIEST" }, -- Dispel Magic
	[528] = { level=14, class="PRIEST" }, -- Cure Disease
	[529] = { level=8, rank=2, next=548, class="SHAMAN" }, -- Lightning Bolt
	[543] = { level=20, rank=1, next=8457, class="MAGE" }, -- Fire Ward
	[546] = { level=28, class="SHAMAN" }, -- Water Walking
	[547] = { level=12, rank=3, next=913, class="SHAMAN" }, -- Healing Wave
	[548] = { level=14, rank=3, next=915, class="SHAMAN" }, -- Lightning Bolt
	[552] = { level=32, class="PRIEST" }, -- Abolish Disease
	[556] = { level=30, class="SHAMAN" }, -- Astral Recall
	[465] = { level=1, rank=1, next=10290, class="PALADIN" }, -- Devotion Aura
	[586] = { level=8, class="PRIEST" }, -- Fade
	[587] = { level=6, rank=1, next=597, class="MAGE" }, -- Conjure Food
	[588] = { level=12, rank=1, next=7128, class="PRIEST" }, -- Inner Fire
	[589] = { level=4, rank=1, next=594, class="PRIEST" }, -- Shadow Word: Pain
	[591] = { level=6, rank=2, next=598, class="PRIEST" }, -- Smite
	[592] = { level=12, rank=2, next=600, class="PRIEST" }, -- Power Word: Shield
	[594] = { level=10, rank=2, next=970, class="PRIEST" }, -- Shadow Word: Pain
	[596] = { level=30, rank=1, next=996, class="PRIEST" }, -- Prayer of Healing
	[597] = { level=12, rank=2, next=990, class="MAGE" }, -- Conjure Food
	[598] = { level=14, rank=3, next=984, class="PRIEST" }, -- Smite
	[600] = { level=18, rank=3, next=3747, class="PRIEST" }, -- Power Word: Shield
	[602] = { level=30, rank=3, next=1006, class="PRIEST" }, -- Inner Fire
	[603] = { level=60, rank=1, next=30910, class="WARLOCK" }, -- Curse of Doom
	[604] = { level=12, rank=1, next=8450, class="MAGE" }, -- Dampen Magic
	[605] = { level=30, class="PRIEST" }, -- Mind Control
	[31935] = { level=50, rank=1, next=32699, class="PALADIN" }, -- Avenger's Shield
	[19742] = { level=14, rank=1, next=19850, class="PALADIN" }, -- Blessing of Wisdom
	[19850] = { level=24, rank=2, next=19852, class="PALADIN" }, -- Blessing of Wisdom
	[642] = { level=34, class="PALADIN" }, -- Divine Shield
	[643] = { level=20, rank=3, next=10291, class="PALADIN" }, -- Devotion Aura
	[19852] = { level=34, rank=3, next=19853, class="PALADIN" }, -- Blessing of Wisdom
	[676] = { level=18, class="WARRIOR" }, -- Disarm
	[635] = { level=1, rank=1, next=639, class="PALADIN" }, -- Holy Light
	[585] = { level=1, rank=1, next=591, class="PRIEST" }, -- Smite
	[689] = { level=14, rank=1, next=699, class="WARLOCK" }, -- Drain Life
	[691] = { level=30, class="WARLOCK" }, -- Summon Felhunter
	[693] = { level=18, rank=1, next=20752, class="WARLOCK" }, -- Create Soulstone
	[694] = { level=16, class="WARRIOR" }, -- Mocking Blow
	[695] = { level=6, rank=2, next=705, class="WARLOCK" }, -- Shadow Bolt
	[696] = { level=10, rank=2, next=706, class="WARLOCK" }, -- Demon Skin
	[697] = { level=10, class="WARLOCK" }, -- Summon Voidwalker
	[698] = { level=20, class="WARLOCK" }, -- Ritual of Summoning
	[699] = { level=22, rank=2, next=709, class="WARLOCK" }, -- Drain Life
	[702] = { level=4, rank=1, next=1108, class="WARLOCK" }, -- Curse of Weakness
	[703] = { level=14, rank=1, next=8631, class="ROGUE" }, -- Garrote
	[705] = { level=12, rank=3, next=1088, class="WARLOCK" }, -- Shadow Bolt
	[706] = { level=20, rank=1, next=1086, class="WARLOCK" }, -- Demon Armor
	[707] = { level=10, rank=2, next=1094, class="WARLOCK" }, -- Immolate
	[709] = { level=30, rank=3, next=7651, class="WARLOCK" }, -- Drain Life
	[710] = { level=28, rank=1, next=18647, class="WARLOCK" }, -- Banish
	[712] = { level=20, class="WARLOCK" }, -- Summon Succubus
	[724] = { level=40, rank=1, next=27870, class="PRIEST" }, -- Lightwell
	[740] = { level=30, rank=1, next=8918, class="DRUID" }, -- Tranquility
	[755] = { level=12, rank=1, next=3698, class="WARLOCK" }, -- Health Funnel
	[759] = { level=28, rank=1, next=3552, class="MAGE" }, -- Conjure Mana Gem
	[768] = { level=20, class="DRUID" }, -- Cat Form
	[769] = { level=34, rank=3, next=9754, class="DRUID" }, -- Swipe (Bear)
	[770] = { level=18, class="DRUID" }, -- Faerie Fire
	[772] = { level=4, rank=1, next=6546, class="WARRIOR" }, -- Rend
	[774] = { level=4, rank=1, next=1058, class="DRUID" }, -- Rejuvenation
	[779] = { level=16, rank=1, next=780, class="DRUID" }, -- Swipe (Bear)
	[780] = { level=24, rank=2, next=769, class="DRUID" }, -- Swipe (Bear)
	[781] = { level=20, class="HUNTER" }, -- Disengage
	[782] = { level=14, rank=2, next=1075, class="DRUID" }, -- Thorns
	[783] = { level=16, class="DRUID" }, -- Travel Form
	[837] = { level=14, rank=3, next=7322, class="MAGE" }, -- Frostbolt
	[845] = { level=20, rank=1, next=7369, class="WARRIOR" }, -- Cleave
	[853] = { level=8, rank=1, next=5588, class="PALADIN" }, -- Hammer of Justice
	[865] = { level=26, rank=2, next=6131, class="MAGE" }, -- Frost Nova
	[871] = { level=28, class="WARRIOR" }, -- Shield Wall
	[19853] = { level=44, rank=4, next=19854, class="PALADIN" }, -- Blessing of Wisdom
	[883] = { level=10, class="HUNTER" }, -- Call Pet
	[905] = { level=24, rank=3, next=945, class="SHAMAN" }, -- Lightning Shield
	[913] = { level=18, rank=4, next=939, class="SHAMAN" }, -- Healing Wave
	[915] = { level=20, rank=4, next=943, class="SHAMAN" }, -- Lightning Bolt
	[921] = { level=4, class="ROGUE" }, -- Pick Pocket
	[930] = { level=40, rank=2, next=2860, class="SHAMAN" }, -- Chain Lightning
	[939] = { level=24, rank=5, next=959, class="SHAMAN" }, -- Healing Wave
	[943] = { level=26, rank=5, next=6041, class="SHAMAN" }, -- Lightning Bolt
	[945] = { level=32, rank=4, next=8134, class="SHAMAN" }, -- Lightning Shield
	[959] = { level=32, rank=6, next=8005, class="SHAMAN" }, -- Healing Wave
	[970] = { level=18, rank=3, next=992, class="PRIEST" }, -- Shadow Word: Pain
	[974] = { level=50, rank=1, next=32593, class="SHAMAN" }, -- Earth Shield
	[976] = { level=30, rank=1, next=10957, class="PRIEST" }, -- Shadow Protection
	[980] = { level=8, rank=1, next=1014, class="WARLOCK" }, -- Curse of Agony
	[982] = { level=10, class="HUNTER" }, -- Revive Pet
	[984] = { level=22, rank=4, next=1004, class="PRIEST" }, -- Smite
	[988] = { level=36, rank=2, class="PRIEST" }, -- Dispel Magic
	[990] = { level=22, rank=3, next=6129, class="MAGE" }, -- Conjure Food
	[992] = { level=26, rank=4, next=2767, class="PRIEST" }, -- Shadow Word: Pain
	[996] = { level=40, rank=2, next=10960, class="PRIEST" }, -- Prayer of Healing
	[1002] = { level=14, class="HUNTER" }, -- Eyes of the Beast
	[1004] = { level=30, rank=5, next=6060, class="PRIEST" }, -- Smite
	[1006] = { level=40, rank=4, next=10951, class="PRIEST" }, -- Inner Fire
	[1008] = { level=18, rank=1, next=8455, class="MAGE" }, -- Amplify Magic
	[1014] = { level=18, rank=2, next=6217, class="WARLOCK" }, -- Curse of Agony
	[1022] = { level=10, rank=1, next=5599, class="PALADIN" }, -- Hand of Protection
	[19854] = { level=54, rank=5, next=25290, class="PALADIN" }, -- Blessing of Wisdom
	[1032] = { level=40, rank=5, next=10292, class="PALADIN" }, -- Devotion Aura
	[1038] = { level=26, class="PALADIN" }, -- Hand of Salvation
	[25290] = { level=60, rank=6, next=27142, class="PALADIN" }, -- Blessing of Wisdom
	[1044] = { level=18, class="PALADIN" }, -- Hand of Freedom
	[1058] = { level=10, rank=2, next=1430, class="DRUID" }, -- Rejuvenation
	[1062] = { level=18, rank=2, next=5195, class="DRUID" }, -- Entangling Roots
	[1064] = { level=40, rank=1, next=10622, class="SHAMAN" }, -- Chain Heal
	[1066] = { level=16, class="DRUID" }, -- Aquatic Form
	[1075] = { level=24, rank=3, next=8914, class="DRUID" }, -- Thorns
	[1079] = { level=20, rank=1, next=9492, class="DRUID" }, -- Rip
	[1082] = { level=20, rank=1, next=3029, class="DRUID" }, -- Claw
	[1086] = { level=30, rank=2, next=11733, class="WARLOCK" }, -- Demon Armor
	[1088] = { level=20, rank=4, next=1106, class="WARLOCK" }, -- Shadow Bolt
	[1094] = { level=20, rank=3, next=2941, class="WARLOCK" }, -- Immolate
	[1098] = { level=30, rank=1, next=11725, class="WARLOCK" }, -- Enslave Demon
	[1106] = { level=28, rank=5, next=7641, class="WARLOCK" }, -- Shadow Bolt
	[1108] = { level=12, rank=2, next=6205, class="WARLOCK" }, -- Curse of Weakness
	[1120] = { level=10, rank=1, next=8288, class="WARLOCK" }, -- Drain Soul
	[1122] = { level=50, class="WARLOCK" }, -- Inferno
	[1243] = { level=1, rank=1, next=1244, class="PRIEST" }, -- Power Word: Fortitude
	[1130] = { level=6, rank=1, next=14323, class="HUNTER" }, -- Hunter's Mark
	[27142] = { level=65, rank=7, next=48935, class="PALADIN" }, -- Blessing of Wisdom
	[1160] = { level=14, rank=1, next=6190, class="WARRIOR" }, -- Demoralizing Shout
	[1161] = { level=26, class="WARRIOR" }, -- Challenging Shout
	[2050] = { level=1, rank=1, next=2052, class="PRIEST" }, -- Lesser Heal
	[1244] = { level=12, rank=2, next=1245, class="PRIEST" }, -- Power Word: Fortitude
	[1245] = { level=24, rank=3, next=2791, class="PRIEST" }, -- Power Word: Fortitude
	[1329] = { level=50, rank=1, next=34411, class="ROGUE" }, -- Mutilate
	[1430] = { level=16, rank=3, next=2090, class="DRUID" }, -- Rejuvenation
	[1449] = { level=14, rank=1, next=8437, class="MAGE" }, -- Arcane Explosion
	[1454] = { level=6, rank=1, next=1455, class="WARLOCK" }, -- Life Tap
	[1455] = { level=16, rank=2, next=1456, class="WARLOCK" }, -- Life Tap
	[1456] = { level=26, rank=3, next=11687, class="WARLOCK" }, -- Life Tap
	[1752] = { level=1, rank=1, next=1757, class="ROGUE" }, -- Sinister Strike
	[1460] = { level=14, rank=2, next=1461, class="MAGE" }, -- Arcane Intellect
	[1461] = { level=28, rank=3, next=10156, class="MAGE" }, -- Arcane Intellect
	[1462] = { level=24, class="HUNTER" }, -- Beast Lore
	[1463] = { level=20, rank=1, next=8494, class="MAGE" }, -- Mana Shield
	[1464] = { level=30, rank=1, next=8820, class="WARRIOR" }, -- Slam
	[1490] = { level=32, rank=1, next=11721, class="WARLOCK" }, -- Curse of the Elements
	[1495] = { level=16, rank=1, next=14269, class="HUNTER" }, -- Mongoose Bite
	[1499] = { level=20, rank=1, next=14310, class="HUNTER" }, -- Freezing Trap
	[1510] = { level=40, rank=1, next=14294, class="HUNTER" }, -- Volley
	[1513] = { level=14, rank=1, next=14326, class="HUNTER" }, -- Scare Beast
	[1515] = { level=10, class="HUNTER" }, -- Tame Beast
	[1535] = { level=12, rank=1, next=8498, class="SHAMAN" }, -- Fire Nova
	[1543] = { level=32, class="HUNTER" }, -- Flare
	[1608] = { level=24, rank=4, next=11564, class="WARRIOR" }, -- Heroic Strike
	[1680] = { level=36, class="WARRIOR" }, -- Whirlwind
	[1706] = { level=34, class="PRIEST" }, -- Levitate
	[1714] = { level=26, rank=1, next=11719, class="WARLOCK" }, -- Curse of Tongues
	[1715] = { level=8, class="WARRIOR" }, -- Hamstring
	[1719] = { level=50, class="WARRIOR" }, -- Recklessness
	[1725] = { level=22, class="ROGUE" }, -- Distract
	[1735] = { level=20, rank=2, next=9490, class="DRUID" }, -- Demoralizing Roar
	[1784] = { level=1, rank=1, class="ROGUE" }, -- Stealth
	[1757] = { level=6, rank=2, next=1758, class="ROGUE" }, -- Sinister Strike
	[1758] = { level=14, rank=3, next=1759, class="ROGUE" }, -- Sinister Strike
	[1759] = { level=22, rank=4, next=1760, class="ROGUE" }, -- Sinister Strike
	[1760] = { level=30, rank=5, next=8621, class="ROGUE" }, -- Sinister Strike
	[1766] = { level=12, class="ROGUE" }, -- Kick
	[1776] = { level=6, class="ROGUE" }, -- Gouge
	[2098] = { level=1, rank=1, next=6760, class="ROGUE" }, -- Eviscerate
	[1804] = { level=16, class="ROGUE" }, -- Pick Lock
	[1822] = { level=24, rank=1, next=1823, class="DRUID" }, -- Rake
	[1823] = { level=34, rank=2, next=1824, class="DRUID" }, -- Rake
	[1824] = { level=44, rank=3, next=9904, class="DRUID" }, -- Rake
	[1833] = { level=26, class="ROGUE" }, -- Cheap Shot
	[1842] = { level=30, class="ROGUE" }, -- Disarm Trap
	[1850] = { level=26, rank=1, next=9821, class="DRUID" }, -- Dash
	[1856] = { level=22, rank=1, next=1857, class="ROGUE" }, -- Vanish
	[1857] = { level=42, rank=2, next=26889, class="ROGUE" }, -- Vanish
	[1860] = { level=40, class="ROGUE" }, -- Safe Fall
	[1943] = { level=20, rank=1, next=8639, class="ROGUE" }, -- Rupture
	[1949] = { level=30, rank=1, next=11683, class="WARLOCK" }, -- Hellfire
	[1953] = { level=20, class="MAGE" }, -- Blink
	[1966] = { level=16, rank=1, next=6768, class="ROGUE" }, -- Feint
	[1978] = { level=4, rank=1, next=13549, class="HUNTER" }, -- Serpent Sting
	[2006] = { level=10, rank=1, next=2010, class="PRIEST" }, -- Resurrection
	[2008] = { level=12, rank=1, next=20609, class="SHAMAN" }, -- Ancestral Spirit
	[2010] = { level=22, rank=2, next=10880, class="PRIEST" }, -- Resurrection
	[2048] = { level=69, rank=8, next=47436, class="WARRIOR" }, -- Battle Shout
	[331] = { level=1, rank=1, next=332, class="SHAMAN" }, -- Healing Wave
	[2052] = { level=4, rank=2, next=2053, class="PRIEST" }, -- Lesser Heal
	[2053] = { level=10, rank=3, next=2054, class="PRIEST" }, -- Lesser Heal
	[2054] = { level=16, rank=1, next=2055, class="PRIEST" }, -- Heal
	[2055] = { level=22, rank=2, next=6063, class="PRIEST" }, -- Heal
	[2060] = { level=40, rank=1, next=10963, class="PRIEST" }, -- Greater Heal
	[2061] = { level=20, rank=1, next=9472, class="PRIEST" }, -- Flash Heal
	[2062] = { level=66, class="SHAMAN" }, -- Earth Elemental Totem
	[2070] = { level=28, rank=2, next=11297, class="ROGUE" }, -- Sap
	[2090] = { level=22, rank=4, next=2091, class="DRUID" }, -- Rejuvenation
	[2091] = { level=28, rank=5, next=3627, class="DRUID" }, -- Rejuvenation
	[2094] = { level=34, class="ROGUE" }, -- Blind
	[2096] = { level=22, rank=1, next=10909, class="PRIEST" }, -- Mind Vision
	[403] = { level=1, rank=1, next=529, class="SHAMAN" }, -- Lightning Bolt
	[2120] = { level=16, rank=1, next=2121, class="MAGE" }, -- Flamestrike
	[2121] = { level=24, rank=2, next=8422, class="MAGE" }, -- Flamestrike
	[2136] = { level=6, rank=1, next=2137, class="MAGE" }, -- Fire Blast
	[2137] = { level=14, rank=2, next=2138, class="MAGE" }, -- Fire Blast
	[2138] = { level=22, rank=3, next=8412, class="MAGE" }, -- Fire Blast
	[2139] = { level=24, class="MAGE" }, -- Counterspell
	[2362] = { level=36, rank=1, next=17727, class="WARLOCK" }, -- Create Spellstone
	[2458] = { level=30, class="WARRIOR" }, -- Berserker Stance
	[2484] = { level=6, class="SHAMAN" }, -- Earthbind Totem
	[2565] = { level=16, class="WARRIOR" }, -- Shield Block
	[2589] = { level=12, rank=2, next=2590, class="ROGUE" }, -- Backstab
	[2590] = { level=20, rank=3, next=2591, class="ROGUE" }, -- Backstab
	[2591] = { level=28, rank=4, next=8721, class="ROGUE" }, -- Backstab
	[2637] = { level=18, rank=1, next=18657, class="DRUID" }, -- Hibernate
	[2641] = { level=10, class="HUNTER" }, -- Dismiss Pet
	[2643] = { level=18, rank=1, next=14288, class="HUNTER" }, -- Multi-Shot
	[2645] = { level=16, class="SHAMAN" }, -- Ghost Wolf
	[2687] = { level=10, class="WARRIOR" }, -- Bloodrage
	[2767] = { level=34, rank=5, next=10892, class="PRIEST" }, -- Shadow Word: Pain
	[2782] = { level=24, class="DRUID" }, -- Remove Curse
	[2791] = { level=36, rank=4, next=10937, class="PRIEST" }, -- Power Word: Fortitude
	[48935] = { level=71, rank=8, next=48936, class="PALADIN" }, -- Blessing of Wisdom
	[48936] = { level=77, rank=9, class="PALADIN" }, -- Blessing of Wisdom
	[2818] = { level=30, rank=1, next=2819, class="ROGUE" }, -- Deadly Poison
	[2819] = { level=38, rank=2, next=11353, class="ROGUE" }, -- Deadly Poison II
	[2823] = { level=30, rank=1, next=2824, class="ROGUE" }, -- Deadly Poison
	[2824] = { level=38, rank=2, next=11355, class="ROGUE" }, -- Deadly Poison II
	[2825] = { level=70, class="SHAMAN", faction="Horde" }, -- Bloodlust
	[2836] = { level=24, class="ROGUE" }, -- Detect Traps
	[2860] = { level=48, rank=3, next=10605, class="SHAMAN" }, -- Chain Lightning
	[2893] = { level=26, rank=1, class="DRUID" }, -- Abolish Poison
	[2894] = { level=68, class="SHAMAN" }, -- Fire Elemental Totem
	[2908] = { level=22, rank=1, next=8955, class="DRUID" }, -- Soothe Animal
	[2912] = { level=20, rank=1, next=8949, class="DRUID" }, -- Starfire
	[2941] = { level=30, rank=4, next=11665, class="WARLOCK" }, -- Immolate
	[2944] = { level=20, rank=1, next=19276, class="PRIEST" }, -- Devouring Plague
	[2948] = { level=22, rank=1, next=8444, class="MAGE" }, -- Scorch
	[8017] = { level=1, rank=1, next=8018, class="SHAMAN" }, -- Rockbiter Weapon
	[2974] = { level=12, class="HUNTER" }, -- Wing Clip
	[2983] = { level=10, rank=1, next=8696, class="ROGUE" }, -- Sprint
	[3029] = { level=28, rank=2, next=5201, class="DRUID" }, -- Claw
	[3034] = { level=36, class="HUNTER" }, -- Viper Sting
	[3043] = { level=22, class="HUNTER" }, -- Scorpid Sting
	[3044] = { level=6, rank=1, next=14281, class="HUNTER" }, -- Arcane Shot
	[3045] = { level=26, class="HUNTER" }, -- Rapid Fire
	[3111] = { level=20, rank=2, next=3661, class="HUNTER" }, -- Mend Pet
	[3140] = { level=18, rank=4, next=8400, class="MAGE" }, -- Fireball
	[3411] = { level=70, class="WARRIOR" }, -- Intervene
	[4987] = { level=42, class="PALADIN" }, -- Cleanse
	[3552] = { level=38, rank=2, next=10053, class="MAGE" }, -- Conjure Mana Gem
	[3561] = { level=20, class="MAGE", faction="Alliance" }, -- Teleport: Stormwind
	[3562] = { level=20, class="MAGE", faction="Alliance" }, -- Teleport: Ironforge
	[3563] = { level=20, class="MAGE", faction="Horde" }, -- Teleport: Undercity
	[3565] = { level=30, class="MAGE", faction="Alliance" }, -- Teleport: Darnassus
	[3566] = { level=30, class="MAGE", faction="Horde" }, -- Teleport: Thunder Bluff
	[3567] = { level=20, class="MAGE", faction="Horde" }, -- Teleport: Orgrimmar
	[3599] = { level=10, rank=1, next=6363, class="SHAMAN" }, -- Searing Totem
	[3627] = { level=34, rank=6, next=8910, class="DRUID" }, -- Rejuvenation
	[3661] = { level=28, rank=3, next=3662, class="HUNTER" }, -- Mend Pet
	[3662] = { level=36, rank=4, next=13542, class="HUNTER" }, -- Mend Pet
	[3674] = { level=50, rank=1, next=63668, class="HUNTER" }, -- Black Arrow
	[3698] = { level=20, rank=2, next=3699, class="WARLOCK" }, -- Health Funnel
	[3699] = { level=28, rank=3, next=3700, class="WARLOCK" }, -- Health Funnel
	[3700] = { level=36, rank=4, next=11693, class="WARLOCK" }, -- Health Funnel
	[3714] = { level=61, class="DEATHKNIGHT" }, -- Path of Frost
	[3738] = { level=64, class="SHAMAN" }, -- Wrath of Air Totem
	[3747] = { level=24, rank=4, next=6065, class="PRIEST" }, -- Power Word: Shield
	[19746] = { level=22, class="PALADIN" }, -- Concentration Aura
	[5116] = { level=8, class="HUNTER" }, -- Concussive Shot
	[5118] = { level=16, class="HUNTER" }, -- Aspect of the Cheetah
	[5138] = { level=24, class="WARLOCK" }, -- Drain Mana
	[5143] = { level=8, rank=1, next=5144, class="MAGE" }, -- Arcane Missiles
	[5144] = { level=16, rank=2, next=5145, class="MAGE" }, -- Arcane Missiles
	[5145] = { level=24, rank=3, next=8416, class="MAGE" }, -- Arcane Missiles
	[5171] = { level=10, rank=1, next=6774, class="ROGUE" }, -- Slice and Dice
	[348] = { level=1, rank=1, next=707, class="WARLOCK" }, -- Immolate
	[5177] = { level=6, rank=2, next=5178, class="DRUID" }, -- Wrath
	[5178] = { level=14, rank=3, next=5179, class="DRUID" }, -- Wrath
	[5179] = { level=22, rank=4, next=5180, class="DRUID" }, -- Wrath
	[5180] = { level=30, rank=5, next=6780, class="DRUID" }, -- Wrath
	[686] = { level=1, rank=1, next=695, class="WARLOCK" }, -- Shadow Bolt
	[5186] = { level=8, rank=2, next=5187, class="DRUID" }, -- Healing Touch
	[5187] = { level=14, rank=3, next=5188, class="DRUID" }, -- Healing Touch
	[5188] = { level=20, rank=4, next=5189, class="DRUID" }, -- Healing Touch
	[5189] = { level=26, rank=5, next=6778, class="DRUID" }, -- Healing Touch
	[5195] = { level=28, rank=3, next=5196, class="DRUID" }, -- Entangling Roots
	[5196] = { level=38, rank=4, next=9852, class="DRUID" }, -- Entangling Roots
	[5201] = { level=38, rank=3, next=9849, class="DRUID" }, -- Claw
	[5209] = { level=28, class="DRUID" }, -- Challenging Roar
	[5211] = { level=14, rank=1, next=6798, class="DRUID" }, -- Bash
	[5215] = { level=20, rank=1, class="DRUID" }, -- Prowl
	[5217] = { level=24, rank=1, next=6793, class="DRUID" }, -- Tiger's Fury
	[5221] = { level=22, rank=1, next=6800, class="DRUID" }, -- Shred
	[5225] = { level=32, class="DRUID" }, -- Track Humanoids
	[5229] = { level=12, class="DRUID" }, -- Enrage
	[5232] = { level=10, rank=2, next=6756, class="DRUID" }, -- Mark of the Wild
	[5234] = { level=30, rank=4, next=8907, class="DRUID" }, -- Mark of the Wild
	[5242] = { level=12, rank=2, next=6192, class="WARRIOR" }, -- Battle Shout
	[5246] = { level=22, class="WARRIOR" }, -- Intimidating Shout
	[5277] = { level=8, rank=1, next=26669, class="ROGUE" }, -- Evasion
	[5308] = { level=24, rank=1, next=20658, class="WARRIOR" }, -- Execute
	[5384] = { level=30, class="HUNTER" }, -- Feign Death
	[5394] = { level=20, rank=1, next=6375, class="SHAMAN" }, -- Healing Stream Totem
	[5484] = { level=40, rank=1, next=17928, class="WARLOCK" }, -- Howl of Terror
	[5487] = { level=10, class="DRUID" }, -- Bear Form
	[5500] = { level=24, class="WARLOCK" }, -- Sense Demons
	[20116] = { level=30, rank=2, next=20922, class="PALADIN" }, -- Consecration
	[5504] = { level=4, rank=1, next=5505, class="MAGE" }, -- Conjure Water
	[5505] = { level=10, rank=2, next=5506, class="MAGE" }, -- Conjure Water
	[5506] = { level=20, rank=3, next=6127, class="MAGE" }, -- Conjure Water
	[5570] = { level=30, rank=1, next=24974, class="DRUID" }, -- Insect Swarm
	[5588] = { level=24, rank=2, next=5589, class="PALADIN" }, -- Hammer of Justice
	[5589] = { level=40, rank=3, next=10308, class="PALADIN" }, -- Hammer of Justice
	[5599] = { level=24, rank=2, next=10278, class="PALADIN" }, -- Hand of Protection
	[20922] = { level=40, rank=3, next=20923, class="PALADIN" }, -- Consecration
	[20923] = { level=50, rank=4, next=20924, class="PALADIN" }, -- Consecration
	[5675] = { level=26, rank=1, next=10495, class="SHAMAN" }, -- Mana Spring Totem
	[5676] = { level=18, rank=1, next=17919, class="WARLOCK" }, -- Searing Pain
	[5697] = { level=16, class="WARLOCK" }, -- Unending Breath
	[5699] = { level=34, rank=3, next=11729, class="WARLOCK" }, -- Create Healthstone
	[5730] = { level=8, rank=1, next=6390, class="SHAMAN" }, -- Stoneclaw Totem
	[5740] = { level=20, rank=1, next=6219, class="WARLOCK" }, -- Rain of Fire
	[5782] = { level=8, rank=1, next=6213, class="WARLOCK" }, -- Fear
	[5938] = { level=70, class="ROGUE" }, -- Shiv
	[6041] = { level=32, rank=6, next=10391, class="SHAMAN" }, -- Lightning Bolt
	[6060] = { level=38, rank=6, next=10933, class="PRIEST" }, -- Smite
	[6063] = { level=28, rank=3, next=6064, class="PRIEST" }, -- Heal
	[6064] = { level=34, rank=4, next=2060, class="PRIEST" }, -- Heal
	[6065] = { level=30, rank=5, next=6066, class="PRIEST" }, -- Power Word: Shield
	[6066] = { level=36, rank=6, next=10898, class="PRIEST" }, -- Power Word: Shield
	[6074] = { level=14, rank=2, next=6075, class="PRIEST" }, -- Renew
	[6075] = { level=20, rank=3, next=6076, class="PRIEST" }, -- Renew
	[6076] = { level=26, rank=4, next=6077, class="PRIEST" }, -- Renew
	[6077] = { level=32, rank=5, next=6078, class="PRIEST" }, -- Renew
	[6078] = { level=38, rank=6, next=10927, class="PRIEST" }, -- Renew
	[6117] = { level=34, rank=1, next=22782, class="MAGE" }, -- Mage Armor
	[6127] = { level=30, rank=4, next=10138, class="MAGE" }, -- Conjure Water
	[6129] = { level=32, rank=4, next=10144, class="MAGE" }, -- Conjure Food
	[6131] = { level=40, rank=3, next=10230, class="MAGE" }, -- Frost Nova
	[6141] = { level=28, rank=2, next=8427, class="MAGE" }, -- Blizzard
	[6143] = { level=22, rank=1, next=8461, class="MAGE" }, -- Frost Ward
	[6178] = { level=26, rank=2, next=11578, class="WARRIOR" }, -- Charge
	[6190] = { level=24, rank=2, next=11554, class="WARRIOR" }, -- Demoralizing Shout
	[6192] = { level=22, rank=3, next=11549, class="WARRIOR" }, -- Battle Shout
	[6196] = { level=26, class="SHAMAN" }, -- Far Sight
	[6197] = { level=14, class="HUNTER" }, -- Eagle Eye
	[6201] = { level=10, rank=1, next=6202, class="WARLOCK" }, -- Create Healthstone
	[6202] = { level=22, rank=2, next=5699, class="WARLOCK" }, -- Create Healthstone
	[6205] = { level=22, rank=3, next=7646, class="WARLOCK" }, -- Curse of Weakness
	[6213] = { level=32, rank=2, next=6215, class="WARLOCK" }, -- Fear
	[6215] = { level=56, rank=3, class="WARLOCK" }, -- Fear
	[6217] = { level=28, rank=3, next=11711, class="WARLOCK" }, -- Curse of Agony
	[6219] = { level=34, rank=2, next=11677, class="WARLOCK" }, -- Rain of Fire
	[6222] = { level=14, rank=2, next=6223, class="WARLOCK" }, -- Corruption
	[6223] = { level=24, rank=3, next=7648, class="WARLOCK" }, -- Corruption
	[6229] = { level=32, rank=1, next=11739, class="WARLOCK" }, -- Shadow Ward
	[6343] = { level=6, rank=1, next=8198, class="WARRIOR" }, -- Thunder Clap
	[6346] = { level=20, class="PRIEST" }, -- Fear Ward
	[6353] = { level=48, rank=1, next=17924, class="WARLOCK" }, -- Soul Fire
	[6363] = { level=20, rank=2, next=6364, class="SHAMAN" }, -- Searing Totem
	[6364] = { level=30, rank=3, next=6365, class="SHAMAN" }, -- Searing Totem
	[6365] = { level=40, rank=4, next=10437, class="SHAMAN" }, -- Searing Totem
	[6366] = { level=28, rank=1, next=17951, class="WARLOCK" }, -- Create Firestone
	[6375] = { level=30, rank=2, next=6377, class="SHAMAN" }, -- Healing Stream Totem
	[6377] = { level=40, rank=3, next=10462, class="SHAMAN" }, -- Healing Stream Totem
	[6390] = { level=18, rank=2, next=6391, class="SHAMAN" }, -- Stoneclaw Totem
	[6391] = { level=28, rank=3, next=6392, class="SHAMAN" }, -- Stoneclaw Totem
	[6392] = { level=38, rank=4, next=10427, class="SHAMAN" }, -- Stoneclaw Totem
	[6495] = { level=34, class="SHAMAN" }, -- Sentry Totem
	[6546] = { level=10, rank=2, next=6547, class="WARRIOR" }, -- Rend
	[6547] = { level=20, rank=3, next=6548, class="WARRIOR" }, -- Rend
	[6548] = { level=30, rank=4, next=11572, class="WARRIOR" }, -- Rend
	[6552] = { level=38, class="WARRIOR" }, -- Pummel
	[6572] = { level=14, rank=1, next=6574, class="WARRIOR" }, -- Revenge
	[6574] = { level=24, rank=2, next=7379, class="WARRIOR" }, -- Revenge
	[687] = { level=1, rank=1, next=696, class="WARLOCK" }, -- Demon Skin
	[6756] = { level=20, rank=3, next=5234, class="DRUID" }, -- Mark of the Wild
	[6760] = { level=8, rank=2, next=6761, class="ROGUE" }, -- Eviscerate
	[6761] = { level=16, rank=3, next=6762, class="ROGUE" }, -- Eviscerate
	[6762] = { level=24, rank=4, next=8623, class="ROGUE" }, -- Eviscerate
	[6768] = { level=28, rank=2, next=8637, class="ROGUE" }, -- Feint
	[6770] = { level=10, rank=1, next=2070, class="ROGUE" }, -- Sap
	[6774] = { level=42, rank=2, class="ROGUE" }, -- Slice and Dice
	[6778] = { level=32, rank=6, next=8903, class="DRUID" }, -- Healing Touch
	[6780] = { level=38, rank=6, next=8905, class="DRUID" }, -- Wrath
	[6785] = { level=32, rank=1, next=6787, class="DRUID" }, -- Ravage
	[6787] = { level=42, rank=2, next=9866, class="DRUID" }, -- Ravage
	[6789] = { level=42, rank=1, next=17925, class="WARLOCK" }, -- Death Coil
	[6793] = { level=36, rank=2, next=9845, class="DRUID" }, -- Tiger's Fury
	[6795] = { level=10, class="DRUID" }, -- Growl
	[6798] = { level=30, rank=2, next=8983, class="DRUID" }, -- Bash
	[6800] = { level=30, rank=2, next=8992, class="DRUID" }, -- Shred
	[6807] = { level=10, rank=1, next=6808, class="DRUID" }, -- Maul
	[6808] = { level=18, rank=2, next=6809, class="DRUID" }, -- Maul
	[6809] = { level=26, rank=3, next=8972, class="DRUID" }, -- Maul
	[6940] = { level=46, class="PALADIN" }, -- Hand of Sacrifice
	[6991] = { level=10, class="HUNTER" }, -- Feed Pet
	[7128] = { level=20, rank=2, next=602, class="PRIEST" }, -- Inner Fire
	[7294] = { level=16, rank=1, next=10298, class="PALADIN" }, -- Retribution Aura
	[7300] = { level=10, rank=2, next=7301, class="MAGE" }, -- Frost Armor
	[7301] = { level=20, rank=3, next=7302, class="MAGE" }, -- Frost Armor
	[7302] = { level=30, rank=1, next=7320, class="MAGE" }, -- Ice Armor
	[7320] = { level=40, rank=2, next=10219, class="MAGE" }, -- Ice Armor
	[7322] = { level=20, rank=4, next=8406, class="MAGE" }, -- Frostbolt
	[20924] = { level=60, rank=5, next=27173, class="PALADIN" }, -- Consecration
	[7369] = { level=30, rank=2, next=11608, class="WARRIOR" }, -- Cleave
	[7379] = { level=34, rank=3, next=11600, class="WARRIOR" }, -- Revenge
	[7384] = { level=12, class="WARRIOR" }, -- Overpower
	[7386] = { level=10, class="WARRIOR" }, -- Sunder Armor
	[7641] = { level=36, rank=6, next=11659, class="WARLOCK" }, -- Shadow Bolt
	[7646] = { level=32, rank=4, next=11707, class="WARLOCK" }, -- Curse of Weakness
	[7648] = { level=34, rank=4, next=11671, class="WARLOCK" }, -- Corruption
	[7651] = { level=38, rank=4, next=11699, class="WARLOCK" }, -- Drain Life
	[8004] = { level=20, rank=1, next=8008, class="SHAMAN" }, -- Lesser Healing Wave
	[8005] = { level=40, rank=7, next=10395, class="SHAMAN" }, -- Healing Wave
	[8008] = { level=28, rank=2, next=8010, class="SHAMAN" }, -- Lesser Healing Wave
	[8010] = { level=36, rank=3, next=10466, class="SHAMAN" }, -- Lesser Healing Wave
	[8012] = { level=32, rank=2, class="SHAMAN" }, -- Purge
	[78] = { level=1, rank=1, next=284, class="WARRIOR" }, -- Heroic Strike
	[8018] = { level=8, rank=2, next=8019, class="SHAMAN" }, -- Rockbiter Weapon
	[8019] = { level=16, rank=3, next=10399, class="SHAMAN" }, -- Rockbiter Weapon
	[8024] = { level=10, rank=1, next=8027, class="SHAMAN" }, -- Flametongue Weapon
	[8027] = { level=18, rank=2, next=8030, class="SHAMAN" }, -- Flametongue Weapon
	[8030] = { level=26, rank=3, next=16339, class="SHAMAN" }, -- Flametongue Weapon
	[8033] = { level=20, rank=1, next=8038, class="SHAMAN" }, -- Frostbrand Weapon
	[8038] = { level=28, rank=2, next=10456, class="SHAMAN" }, -- Frostbrand Weapon
	[8042] = { level=4, rank=1, next=8044, class="SHAMAN" }, -- Earth Shock
	[8044] = { level=8, rank=2, next=8045, class="SHAMAN" }, -- Earth Shock
	[8045] = { level=14, rank=3, next=8046, class="SHAMAN" }, -- Earth Shock
	[8046] = { level=24, rank=4, next=10412, class="SHAMAN" }, -- Earth Shock
	[8050] = { level=10, rank=1, next=8052, class="SHAMAN" }, -- Flame Shock
	[8052] = { level=18, rank=2, next=8053, class="SHAMAN" }, -- Flame Shock
	[8053] = { level=28, rank=3, next=10447, class="SHAMAN" }, -- Flame Shock
	[8056] = { level=20, rank=1, next=8058, class="SHAMAN" }, -- Frost Shock
	[8058] = { level=34, rank=2, next=10472, class="SHAMAN" }, -- Frost Shock
	[8071] = { level=4, rank=1, next=8154, class="SHAMAN" }, -- Stoneskin Totem
	[8075] = { level=10, rank=1, next=8160, class="SHAMAN" }, -- Strength of Earth Totem
	[8092] = { level=10, rank=1, next=8102, class="PRIEST" }, -- Mind Blast
	[8102] = { level=16, rank=2, next=8103, class="PRIEST" }, -- Mind Blast
	[8103] = { level=22, rank=3, next=8104, class="PRIEST" }, -- Mind Blast
	[8104] = { level=28, rank=4, next=8105, class="PRIEST" }, -- Mind Blast
	[8105] = { level=34, rank=5, next=8106, class="PRIEST" }, -- Mind Blast
	[8106] = { level=40, rank=6, next=10945, class="PRIEST" }, -- Mind Blast
	[8122] = { level=14, rank=1, next=8124, class="PRIEST" }, -- Psychic Scream
	[8124] = { level=28, rank=2, next=10888, class="PRIEST" }, -- Psychic Scream
	[8129] = { level=24, class="PRIEST" }, -- Mana Burn
	[8134] = { level=40, rank=5, next=10431, class="SHAMAN" }, -- Lightning Shield
	[8143] = { level=18, class="SHAMAN" }, -- Tremor Totem
	[8154] = { level=14, rank=2, next=8155, class="SHAMAN" }, -- Stoneskin Totem
	[8155] = { level=24, rank=3, next=10406, class="SHAMAN" }, -- Stoneskin Totem
	[8160] = { level=24, rank=2, next=8161, class="SHAMAN" }, -- Strength of Earth Totem
	[8161] = { level=38, rank=3, next=10442, class="SHAMAN" }, -- Strength of Earth Totem
	[8170] = { level=38, class="SHAMAN" }, -- Cleansing Totem
	[8177] = { level=30, class="SHAMAN" }, -- Grounding Totem
	[8181] = { level=24, rank=1, next=10478, class="SHAMAN" }, -- Frost Resistance Totem
	[8184] = { level=28, rank=1, next=10537, class="SHAMAN" }, -- Fire Resistance Totem
	[8190] = { level=26, rank=1, next=10585, class="SHAMAN" }, -- Magma Totem
	[8198] = { level=18, rank=2, next=8204, class="WARRIOR" }, -- Thunder Clap
	[8204] = { level=28, rank=3, next=8205, class="WARRIOR" }, -- Thunder Clap
	[8205] = { level=38, rank=4, next=11580, class="WARRIOR" }, -- Thunder Clap
	[8227] = { level=28, rank=1, next=8249, class="SHAMAN" }, -- Flametongue Totem
	[8232] = { level=30, rank=1, next=8235, class="SHAMAN" }, -- Windfury Weapon
	[8235] = { level=40, rank=2, next=10486, class="SHAMAN" }, -- Windfury Weapon
	[8249] = { level=38, rank=2, next=10526, class="SHAMAN" }, -- Flametongue Totem
	[8288] = { level=24, rank=2, next=8289, class="WARLOCK" }, -- Drain Soul
	[8289] = { level=38, rank=3, next=11675, class="WARLOCK" }, -- Drain Soul
	[8400] = { level=24, rank=5, next=8401, class="MAGE" }, -- Fireball
	[8401] = { level=30, rank=6, next=8402, class="MAGE" }, -- Fireball
	[8402] = { level=36, rank=7, next=10148, class="MAGE" }, -- Fireball
	[8406] = { level=26, rank=5, next=8407, class="MAGE" }, -- Frostbolt
	[8407] = { level=32, rank=6, next=8408, class="MAGE" }, -- Frostbolt
	[8408] = { level=38, rank=7, next=10179, class="MAGE" }, -- Frostbolt
	[8412] = { level=30, rank=4, next=8413, class="MAGE" }, -- Fire Blast
	[8413] = { level=38, rank=5, next=10197, class="MAGE" }, -- Fire Blast
	[8416] = { level=32, rank=4, next=8417, class="MAGE" }, -- Arcane Missiles
	[8417] = { level=40, rank=5, next=10211, class="MAGE" }, -- Arcane Missiles
	[8422] = { level=32, rank=3, next=8423, class="MAGE" }, -- Flamestrike
	[8423] = { level=40, rank=4, next=10215, class="MAGE" }, -- Flamestrike
	[8427] = { level=36, rank=3, next=10185, class="MAGE" }, -- Blizzard
	[8437] = { level=22, rank=2, next=8438, class="MAGE" }, -- Arcane Explosion
	[8438] = { level=30, rank=3, next=8439, class="MAGE" }, -- Arcane Explosion
	[8439] = { level=38, rank=4, next=10201, class="MAGE" }, -- Arcane Explosion
	[8444] = { level=28, rank=2, next=8445, class="MAGE" }, -- Scorch
	[8445] = { level=34, rank=3, next=8446, class="MAGE" }, -- Scorch
	[8446] = { level=40, rank=4, next=10205, class="MAGE" }, -- Scorch
	[8450] = { level=24, rank=2, next=8451, class="MAGE" }, -- Dampen Magic
	[8451] = { level=36, rank=3, next=10173, class="MAGE" }, -- Dampen Magic
	[8455] = { level=30, rank=2, next=10169, class="MAGE" }, -- Amplify Magic
	[8457] = { level=30, rank=2, next=8458, class="MAGE" }, -- Fire Ward
	[8458] = { level=40, rank=3, next=10223, class="MAGE" }, -- Fire Ward
	[8461] = { level=32, rank=2, next=8462, class="MAGE" }, -- Frost Ward
	[8462] = { level=42, rank=3, next=10177, class="MAGE" }, -- Frost Ward
	[8492] = { level=34, rank=2, next=10159, class="MAGE" }, -- Cone of Cold
	[8494] = { level=28, rank=2, next=8495, class="MAGE" }, -- Mana Shield
	[8495] = { level=36, rank=3, next=10191, class="MAGE" }, -- Mana Shield
	[8498] = { level=22, rank=2, next=8499, class="SHAMAN" }, -- Fire Nova
	[8499] = { level=32, rank=3, next=11314, class="SHAMAN" }, -- Fire Nova
	[8512] = { level=32, class="SHAMAN" }, -- Windfury Totem
	[8621] = { level=38, rank=6, next=11293, class="ROGUE" }, -- Sinister Strike
	[8623] = { level=32, rank=5, next=8624, class="ROGUE" }, -- Eviscerate
	[8624] = { level=40, rank=6, next=11299, class="ROGUE" }, -- Eviscerate
	[8631] = { level=22, rank=2, next=8632, class="ROGUE" }, -- Garrote
	[8632] = { level=30, rank=3, next=8633, class="ROGUE" }, -- Garrote
	[8633] = { level=38, rank=4, next=11289, class="ROGUE" }, -- Garrote
	[8637] = { level=40, rank=3, next=11303, class="ROGUE" }, -- Feint
	[8639] = { level=28, rank=2, next=8640, class="ROGUE" }, -- Rupture
	[8640] = { level=36, rank=3, next=11273, class="ROGUE" }, -- Rupture
	[8643] = { level=50, rank=2, class="ROGUE" }, -- Kidney Shot
	[8647] = { level=14, class="ROGUE" }, -- Expose Armor
	[8676] = { level=18, rank=1, next=8724, class="ROGUE" }, -- Ambush
	[8679] = { level=20, rank=1, next=8685, class="ROGUE" }, -- Instant Poison
	[8680] = { level=20, rank=1, next=8686, class="ROGUE" }, -- Instant Poison
	[8685] = { level=28, rank=2, next=8688, class="ROGUE" }, -- Instant Poison II
	[8686] = { level=28, rank=2, next=8689, class="ROGUE" }, -- Instant Poison II
	[8688] = { level=36, rank=3, next=11335, class="ROGUE" }, -- Instant Poison III
	[8689] = { level=36, rank=3, next=11338, class="ROGUE" }, -- Instant Poison III
	[8696] = { level=34, rank=2, next=11305, class="ROGUE" }, -- Sprint
	[8721] = { level=36, rank=5, next=11279, class="ROGUE" }, -- Backstab
	[8724] = { level=26, rank=2, next=8725, class="ROGUE" }, -- Ambush
	[8725] = { level=34, rank=3, next=11267, class="ROGUE" }, -- Ambush
	[8820] = { level=38, rank=2, next=11604, class="WARRIOR" }, -- Slam
	[8903] = { level=38, rank=7, next=9758, class="DRUID" }, -- Healing Touch
	[8905] = { level=46, rank=7, next=9912, class="DRUID" }, -- Wrath
	[8907] = { level=40, rank=5, next=9884, class="DRUID" }, -- Mark of the Wild
	[8910] = { level=40, rank=7, next=9839, class="DRUID" }, -- Rejuvenation
	[8914] = { level=34, rank=4, next=9756, class="DRUID" }, -- Thorns
	[8918] = { level=40, rank=2, next=9862, class="DRUID" }, -- Tranquility
	[8921] = { level=4, rank=1, next=8924, class="DRUID" }, -- Moonfire
	[8924] = { level=10, rank=2, next=8925, class="DRUID" }, -- Moonfire
	[8925] = { level=16, rank=3, next=8926, class="DRUID" }, -- Moonfire
	[8926] = { level=22, rank=4, next=8927, class="DRUID" }, -- Moonfire
	[8927] = { level=28, rank=5, next=8928, class="DRUID" }, -- Moonfire
	[8928] = { level=34, rank=6, next=8929, class="DRUID" }, -- Moonfire
	[8929] = { level=40, rank=7, next=9833, class="DRUID" }, -- Moonfire
	[8936] = { level=12, rank=1, next=8938, class="DRUID" }, -- Regrowth
	[8938] = { level=18, rank=2, next=8939, class="DRUID" }, -- Regrowth
	[8939] = { level=24, rank=3, next=8940, class="DRUID" }, -- Regrowth
	[8940] = { level=30, rank=4, next=8941, class="DRUID" }, -- Regrowth
	[8941] = { level=36, rank=5, next=9750, class="DRUID" }, -- Regrowth
	[8946] = { level=14, rank=1, class="DRUID" }, -- Cure Poison
	[8949] = { level=26, rank=2, next=8950, class="DRUID" }, -- Starfire
	[8950] = { level=34, rank=3, next=8951, class="DRUID" }, -- Starfire
	[8951] = { level=42, rank=4, next=9875, class="DRUID" }, -- Starfire
	[8955] = { level=38, rank=2, next=9901, class="DRUID" }, -- Soothe Animal
	[8972] = { level=34, rank=4, next=9745, class="DRUID" }, -- Maul
	[8983] = { level=46, rank=3, class="DRUID" }, -- Bash
	[8992] = { level=38, rank=3, next=9829, class="DRUID" }, -- Shred
	[8998] = { level=28, rank=1, next=9000, class="DRUID" }, -- Cower
	[9000] = { level=40, rank=2, next=9892, class="DRUID" }, -- Cower
	[9005] = { level=36, rank=1, next=9823, class="DRUID" }, -- Pounce
	[9472] = { level=26, rank=2, next=9473, class="PRIEST" }, -- Flash Heal
	[9473] = { level=32, rank=3, next=9474, class="PRIEST" }, -- Flash Heal
	[9474] = { level=38, rank=4, next=10915, class="PRIEST" }, -- Flash Heal
	[9484] = { level=20, rank=1, next=9485, class="PRIEST" }, -- Shackle Undead
	[9485] = { level=40, rank=2, next=10955, class="PRIEST" }, -- Shackle Undead
	[9490] = { level=32, rank=3, next=9747, class="DRUID" }, -- Demoralizing Roar
	[9492] = { level=28, rank=2, next=9493, class="DRUID" }, -- Rip
	[9493] = { level=36, rank=3, next=9752, class="DRUID" }, -- Rip
	[9634] = { level=40, class="DRUID" }, -- Dire Bear Form
	[9745] = { level=42, rank=5, next=9880, class="DRUID" }, -- Maul
	[9747] = { level=42, rank=4, next=9898, class="DRUID" }, -- Demoralizing Roar
	[9750] = { level=42, rank=6, next=9856, class="DRUID" }, -- Regrowth
	[9752] = { level=44, rank=4, next=9894, class="DRUID" }, -- Rip
	[9754] = { level=44, rank=4, next=9908, class="DRUID" }, -- Swipe (Bear)
	[9756] = { level=44, rank=5, next=9910, class="DRUID" }, -- Thorns
	[9758] = { level=44, rank=8, next=9888, class="DRUID" }, -- Healing Touch
	[9821] = { level=46, rank=2, next=33357, class="DRUID" }, -- Dash
	[9823] = { level=46, rank=2, next=9827, class="DRUID" }, -- Pounce
	[9827] = { level=56, rank=3, next=27006, class="DRUID" }, -- Pounce
	[9829] = { level=46, rank=4, next=9830, class="DRUID" }, -- Shred
	[9830] = { level=54, rank=5, next=27001, class="DRUID" }, -- Shred
	[9833] = { level=46, rank=8, next=9834, class="DRUID" }, -- Moonfire
	[9834] = { level=52, rank=9, next=9835, class="DRUID" }, -- Moonfire
	[9835] = { level=58, rank=10, next=26987, class="DRUID" }, -- Moonfire
	[9839] = { level=46, rank=8, next=9840, class="DRUID" }, -- Rejuvenation
	[9840] = { level=52, rank=9, next=9841, class="DRUID" }, -- Rejuvenation
	[9841] = { level=58, rank=10, next=25299, class="DRUID" }, -- Rejuvenation
	[9845] = { level=48, rank=3, next=9846, class="DRUID" }, -- Tiger's Fury
	[9846] = { level=60, rank=4, next=50212, class="DRUID" }, -- Tiger's Fury
	[9849] = { level=48, rank=4, next=9850, class="DRUID" }, -- Claw
	[9850] = { level=58, rank=5, next=27000, class="DRUID" }, -- Claw
	[9852] = { level=48, rank=5, next=9853, class="DRUID" }, -- Entangling Roots
	[9853] = { level=58, rank=6, next=26989, class="DRUID" }, -- Entangling Roots
	[9856] = { level=48, rank=7, next=9857, class="DRUID" }, -- Regrowth
	[9857] = { level=54, rank=8, next=9858, class="DRUID" }, -- Regrowth
	[9858] = { level=60, rank=9, next=26980, class="DRUID" }, -- Regrowth
	[9862] = { level=50, rank=3, next=9863, class="DRUID" }, -- Tranquility
	[9863] = { level=60, rank=4, next=26983, class="DRUID" }, -- Tranquility
	[9866] = { level=50, rank=3, next=9867, class="DRUID" }, -- Ravage
	[9867] = { level=58, rank=4, next=27005, class="DRUID" }, -- Ravage
	[9875] = { level=50, rank=5, next=9876, class="DRUID" }, -- Starfire
	[9876] = { level=58, rank=6, next=25298, class="DRUID" }, -- Starfire
	[9880] = { level=50, rank=6, next=9881, class="DRUID" }, -- Maul
	[9881] = { level=58, rank=7, next=26996, class="DRUID" }, -- Maul
	[9884] = { level=50, rank=6, next=9885, class="DRUID" }, -- Mark of the Wild
	[9885] = { level=60, rank=7, next=26990, class="DRUID" }, -- Mark of the Wild
	[9888] = { level=50, rank=9, next=9889, class="DRUID" }, -- Healing Touch
	[9889] = { level=56, rank=10, next=25297, class="DRUID" }, -- Healing Touch
	[9892] = { level=52, rank=3, next=31709, class="DRUID" }, -- Cower
	[9894] = { level=52, rank=5, next=9896, class="DRUID" }, -- Rip
	[9896] = { level=60, rank=6, next=27008, class="DRUID" }, -- Rip
	[9898] = { level=52, rank=5, next=26998, class="DRUID" }, -- Demoralizing Roar
	[9901] = { level=54, rank=3, next=26995, class="DRUID" }, -- Soothe Animal
	[9904] = { level=54, rank=4, next=27003, class="DRUID" }, -- Rake
	[9908] = { level=54, rank=5, next=26997, class="DRUID" }, -- Swipe (Bear)
	[9910] = { level=54, rank=6, next=26992, class="DRUID" }, -- Thorns
	[9912] = { level=54, rank=8, next=26984, class="DRUID" }, -- Wrath
	[10053] = { level=48, rank=3, next=10054, class="MAGE" }, -- Conjure Mana Gem
	[10054] = { level=58, rank=4, next=27101, class="MAGE" }, -- Conjure Mana Gem
	[10059] = { level=40, class="MAGE", faction="Alliance" }, -- Portal: Stormwind
	[10138] = { level=40, rank=5, next=10139, class="MAGE" }, -- Conjure Water
	[10139] = { level=50, rank=6, next=10140, class="MAGE" }, -- Conjure Water
	[10140] = { level=60, rank=7, next=37420, class="MAGE" }, -- Conjure Water
	[10144] = { level=42, rank=5, next=10145, class="MAGE" }, -- Conjure Food
	[10145] = { level=52, rank=6, next=28612, class="MAGE" }, -- Conjure Food
	[10148] = { level=42, rank=8, next=10149, class="MAGE" }, -- Fireball
	[10149] = { level=48, rank=9, next=10150, class="MAGE" }, -- Fireball
	[10150] = { level=54, rank=10, next=10151, class="MAGE" }, -- Fireball
	[10151] = { level=60, rank=11, next=25306, class="MAGE" }, -- Fireball
	[10156] = { level=42, rank=4, next=10157, class="MAGE" }, -- Arcane Intellect
	[10157] = { level=56, rank=5, next=27126, class="MAGE" }, -- Arcane Intellect
	[10159] = { level=42, rank=3, next=10160, class="MAGE" }, -- Cone of Cold
	[10160] = { level=50, rank=4, next=10161, class="MAGE" }, -- Cone of Cold
	[10161] = { level=58, rank=5, next=27087, class="MAGE" }, -- Cone of Cold
	[10169] = { level=42, rank=3, next=10170, class="MAGE" }, -- Amplify Magic
	[10170] = { level=54, rank=4, next=27130, class="MAGE" }, -- Amplify Magic
	[10173] = { level=48, rank=4, next=10174, class="MAGE" }, -- Dampen Magic
	[10174] = { level=60, rank=5, next=33944, class="MAGE" }, -- Dampen Magic
	[10177] = { level=52, rank=4, next=28609, class="MAGE" }, -- Frost Ward
	[10179] = { level=44, rank=8, next=10180, class="MAGE" }, -- Frostbolt
	[10180] = { level=50, rank=9, next=10181, class="MAGE" }, -- Frostbolt
	[10181] = { level=56, rank=10, next=25304, class="MAGE" }, -- Frostbolt
	[10185] = { level=44, rank=4, next=10186, class="MAGE" }, -- Blizzard
	[10186] = { level=52, rank=5, next=10187, class="MAGE" }, -- Blizzard
	[10187] = { level=60, rank=6, next=27085, class="MAGE" }, -- Blizzard
	[10191] = { level=44, rank=4, next=10192, class="MAGE" }, -- Mana Shield
	[10192] = { level=52, rank=5, next=10193, class="MAGE" }, -- Mana Shield
	[10193] = { level=60, rank=6, next=27131, class="MAGE" }, -- Mana Shield
	[10197] = { level=46, rank=6, next=10199, class="MAGE" }, -- Fire Blast
	[10199] = { level=54, rank=7, next=27078, class="MAGE" }, -- Fire Blast
	[10201] = { level=46, rank=5, next=10202, class="MAGE" }, -- Arcane Explosion
	[10202] = { level=54, rank=6, next=27080, class="MAGE" }, -- Arcane Explosion
	[10205] = { level=46, rank=5, next=10206, class="MAGE" }, -- Scorch
	[10206] = { level=52, rank=6, next=10207, class="MAGE" }, -- Scorch
	[10207] = { level=58, rank=7, next=27073, class="MAGE" }, -- Scorch
	[10211] = { level=48, rank=6, next=10212, class="MAGE" }, -- Arcane Missiles
	[10212] = { level=56, rank=7, next=25345, class="MAGE" }, -- Arcane Missiles
	[10215] = { level=48, rank=5, next=10216, class="MAGE" }, -- Flamestrike
	[10216] = { level=56, rank=6, next=27086, class="MAGE" }, -- Flamestrike
	[10219] = { level=50, rank=3, next=10220, class="MAGE" }, -- Ice Armor
	[10220] = { level=60, rank=4, next=27124, class="MAGE" }, -- Ice Armor
	[10223] = { level=50, rank=4, next=10225, class="MAGE" }, -- Fire Ward
	[10225] = { level=60, rank=5, next=27128, class="MAGE" }, -- Fire Ward
	[10230] = { level=54, rank=4, next=27088, class="MAGE" }, -- Frost Nova
	[10278] = { level=38, rank=3, class="PALADIN" }, -- Hand of Protection
	[10290] = { level=10, rank=2, next=643, class="PALADIN" }, -- Devotion Aura
	[10291] = { level=30, rank=4, next=1032, class="PALADIN" }, -- Devotion Aura
	[10292] = { level=50, rank=6, next=10293, class="PALADIN" }, -- Devotion Aura
	[10293] = { level=60, rank=7, next=27149, class="PALADIN" }, -- Devotion Aura
	[10298] = { level=26, rank=2, next=10299, class="PALADIN" }, -- Retribution Aura
	[10299] = { level=36, rank=3, next=10300, class="PALADIN" }, -- Retribution Aura
	[10300] = { level=46, rank=4, next=10301, class="PALADIN" }, -- Retribution Aura
	[10301] = { level=56, rank=5, next=27150, class="PALADIN" }, -- Retribution Aura
	[10308] = { level=54, rank=4, class="PALADIN" }, -- Hammer of Justice
	[26573] = { level=20, rank=1, next=20116, class="PALADIN" }, -- Consecration
	[27173] = { level=70, rank=6, next=48818, class="PALADIN" }, -- Consecration
	[48818] = { level=75, rank=7, next=48819, class="PALADIN" }, -- Consecration
	[48819] = { level=80, rank=8, class="PALADIN" }, -- Consecration
	[54428] = { level=71, class="PALADIN" }, -- Divine Plea
	[879] = { level=20, rank=1, next=5614, class="PALADIN" }, -- Exorcism
	[5614] = { level=28, rank=2, next=5615, class="PALADIN" }, -- Exorcism
	[5615] = { level=36, rank=3, next=10312, class="PALADIN" }, -- Exorcism
	[10312] = { level=44, rank=4, next=10313, class="PALADIN" }, -- Exorcism
	[10313] = { level=52, rank=5, next=10314, class="PALADIN" }, -- Exorcism
	[10391] = { level=38, rank=7, next=10392, class="SHAMAN" }, -- Lightning Bolt
	[10392] = { level=44, rank=8, next=15207, class="SHAMAN" }, -- Lightning Bolt
	[10395] = { level=48, rank=8, next=10396, class="SHAMAN" }, -- Healing Wave
	[10396] = { level=56, rank=9, next=25357, class="SHAMAN" }, -- Healing Wave
	[10399] = { level=24, rank=4, next=8232, class="SHAMAN" }, -- Rockbiter Weapon
	[10406] = { level=34, rank=4, next=10407, class="SHAMAN" }, -- Stoneskin Totem
	[10407] = { level=44, rank=5, next=10408, class="SHAMAN" }, -- Stoneskin Totem
	[10408] = { level=54, rank=6, next=25508, class="SHAMAN" }, -- Stoneskin Totem
	[10412] = { level=36, rank=5, next=10413, class="SHAMAN" }, -- Earth Shock
	[10413] = { level=48, rank=6, next=10414, class="SHAMAN" }, -- Earth Shock
	[10414] = { level=60, rank=7, next=25454, class="SHAMAN" }, -- Earth Shock
	[10427] = { level=48, rank=5, next=10428, class="SHAMAN" }, -- Stoneclaw Totem
	[10428] = { level=58, rank=6, next=25525, class="SHAMAN" }, -- Stoneclaw Totem
	[10431] = { level=48, rank=6, next=10432, class="SHAMAN" }, -- Lightning Shield
	[10432] = { level=56, rank=7, next=25469, class="SHAMAN" }, -- Lightning Shield
	[10437] = { level=50, rank=5, next=10438, class="SHAMAN" }, -- Searing Totem
	[10438] = { level=60, rank=6, next=25533, class="SHAMAN" }, -- Searing Totem
	[10442] = { level=52, rank=4, next=25361, class="SHAMAN" }, -- Strength of Earth Totem
	[10447] = { level=40, rank=4, next=10448, class="SHAMAN" }, -- Flame Shock
	[10448] = { level=52, rank=5, next=29228, class="SHAMAN" }, -- Flame Shock
	[10456] = { level=38, rank=3, next=16355, class="SHAMAN" }, -- Frostbrand Weapon
	[10462] = { level=50, rank=4, next=10463, class="SHAMAN" }, -- Healing Stream Totem
	[10463] = { level=60, rank=5, next=25567, class="SHAMAN" }, -- Healing Stream Totem
	[10466] = { level=44, rank=4, next=10467, class="SHAMAN" }, -- Lesser Healing Wave
	[10467] = { level=52, rank=5, next=10468, class="SHAMAN" }, -- Lesser Healing Wave
	[10468] = { level=60, rank=6, next=25420, class="SHAMAN" }, -- Lesser Healing Wave
	[10472] = { level=46, rank=3, next=10473, class="SHAMAN" }, -- Frost Shock
	[10473] = { level=58, rank=4, next=25464, class="SHAMAN" }, -- Frost Shock
	[10478] = { level=38, rank=2, next=10479, class="SHAMAN" }, -- Frost Resistance Totem
	[10479] = { level=54, rank=3, next=25560, class="SHAMAN" }, -- Frost Resistance Totem
	[10486] = { level=50, rank=3, next=16362, class="SHAMAN" }, -- Windfury Weapon
	[10495] = { level=36, rank=2, next=10496, class="SHAMAN" }, -- Mana Spring Totem
	[10496] = { level=46, rank=3, next=10497, class="SHAMAN" }, -- Mana Spring Totem
	[10497] = { level=56, rank=4, next=25570, class="SHAMAN" }, -- Mana Spring Totem
	[10526] = { level=48, rank=3, next=16387, class="SHAMAN" }, -- Flametongue Totem
	[10537] = { level=42, rank=2, next=10538, class="SHAMAN" }, -- Fire Resistance Totem
	[10538] = { level=58, rank=3, next=25563, class="SHAMAN" }, -- Fire Resistance Totem
	[10585] = { level=36, rank=2, next=10586, class="SHAMAN" }, -- Magma Totem
	[10586] = { level=46, rank=3, next=10587, class="SHAMAN" }, -- Magma Totem
	[10587] = { level=56, rank=4, next=25552, class="SHAMAN" }, -- Magma Totem
	[10595] = { level=30, rank=1, next=10600, class="SHAMAN" }, -- Nature Resistance Totem
	[10600] = { level=44, rank=2, next=10601, class="SHAMAN" }, -- Nature Resistance Totem
	[10601] = { level=60, rank=3, next=25574, class="SHAMAN" }, -- Nature Resistance Totem
	[10605] = { level=56, rank=4, next=25439, class="SHAMAN" }, -- Chain Lightning
	[10622] = { level=46, rank=2, next=10623, class="SHAMAN" }, -- Chain Heal
	[10623] = { level=54, rank=3, next=25422, class="SHAMAN" }, -- Chain Heal
	[10880] = { level=34, rank=3, next=10881, class="PRIEST" }, -- Resurrection
	[10881] = { level=46, rank=4, next=20770, class="PRIEST" }, -- Resurrection
	[10888] = { level=42, rank=3, next=10890, class="PRIEST" }, -- Psychic Scream
	[10890] = { level=56, rank=4, class="PRIEST" }, -- Psychic Scream
	[10892] = { level=42, rank=6, next=10893, class="PRIEST" }, -- Shadow Word: Pain
	[10893] = { level=50, rank=7, next=10894, class="PRIEST" }, -- Shadow Word: Pain
	[10894] = { level=58, rank=8, next=25367, class="PRIEST" }, -- Shadow Word: Pain
	[10898] = { level=42, rank=7, next=10899, class="PRIEST" }, -- Power Word: Shield
	[10899] = { level=48, rank=8, next=10900, class="PRIEST" }, -- Power Word: Shield
	[10900] = { level=54, rank=9, next=10901, class="PRIEST" }, -- Power Word: Shield
	[10901] = { level=60, rank=10, next=25217, class="PRIEST" }, -- Power Word: Shield
	[10909] = { level=44, rank=2, class="PRIEST" }, -- Mind Vision
	[10915] = { level=44, rank=5, next=10916, class="PRIEST" }, -- Flash Heal
	[10916] = { level=50, rank=6, next=10917, class="PRIEST" }, -- Flash Heal
	[10917] = { level=56, rank=7, next=25233, class="PRIEST" }, -- Flash Heal
	[10927] = { level=44, rank=7, next=10928, class="PRIEST" }, -- Renew
	[10928] = { level=50, rank=8, next=10929, class="PRIEST" }, -- Renew
	[10929] = { level=56, rank=9, next=25315, class="PRIEST" }, -- Renew
	[10933] = { level=46, rank=7, next=10934, class="PRIEST" }, -- Smite
	[10934] = { level=54, rank=8, next=25363, class="PRIEST" }, -- Smite
	[10937] = { level=48, rank=5, next=10938, class="PRIEST" }, -- Power Word: Fortitude
	[10938] = { level=60, rank=6, next=25389, class="PRIEST" }, -- Power Word: Fortitude
	[10945] = { level=46, rank=7, next=10946, class="PRIEST" }, -- Mind Blast
	[10946] = { level=52, rank=8, next=10947, class="PRIEST" }, -- Mind Blast
	[10947] = { level=58, rank=9, next=25372, class="PRIEST" }, -- Mind Blast
	[10951] = { level=50, rank=5, next=10952, class="PRIEST" }, -- Inner Fire
	[10952] = { level=60, rank=6, next=25431, class="PRIEST" }, -- Inner Fire
	[10955] = { level=60, rank=3, class="PRIEST" }, -- Shackle Undead
	[10957] = { level=42, rank=2, next=10958, class="PRIEST" }, -- Shadow Protection
	[10958] = { level=56, rank=3, next=25433, class="PRIEST" }, -- Shadow Protection
	[10960] = { level=50, rank=3, next=10961, class="PRIEST" }, -- Prayer of Healing
	[10961] = { level=60, rank=4, next=25316, class="PRIEST" }, -- Prayer of Healing
	[10963] = { level=46, rank=2, next=10964, class="PRIEST" }, -- Greater Heal
	[10964] = { level=52, rank=3, next=10965, class="PRIEST" }, -- Greater Heal
	[10965] = { level=58, rank=4, next=25314, class="PRIEST" }, -- Greater Heal
	[11113] = { level=30, rank=1, next=13018, class="MAGE" }, -- Blast Wave
	[11267] = { level=42, rank=4, next=11268, class="ROGUE" }, -- Ambush
	[11268] = { level=50, rank=5, next=11269, class="ROGUE" }, -- Ambush
	[11269] = { level=58, rank=6, next=27441, class="ROGUE" }, -- Ambush
	[11273] = { level=44, rank=4, next=11274, class="ROGUE" }, -- Rupture
	[11274] = { level=52, rank=5, next=11275, class="ROGUE" }, -- Rupture
	[11275] = { level=60, rank=6, next=26867, class="ROGUE" }, -- Rupture
	[11279] = { level=44, rank=6, next=11280, class="ROGUE" }, -- Backstab
	[11280] = { level=52, rank=7, next=11281, class="ROGUE" }, -- Backstab
	[11281] = { level=60, rank=8, next=25300, class="ROGUE" }, -- Backstab
	[11289] = { level=46, rank=5, next=11290, class="ROGUE" }, -- Garrote
	[11290] = { level=54, rank=6, next=26839, class="ROGUE" }, -- Garrote
	[11293] = { level=46, rank=7, next=11294, class="ROGUE" }, -- Sinister Strike
	[11294] = { level=54, rank=8, next=26861, class="ROGUE" }, -- Sinister Strike
	[11297] = { level=48, rank=3, next=51724, class="ROGUE" }, -- Sap
	[11299] = { level=48, rank=7, next=11300, class="ROGUE" }, -- Eviscerate
	[11300] = { level=56, rank=8, next=31016, class="ROGUE" }, -- Eviscerate
	[11303] = { level=52, rank=4, next=25302, class="ROGUE" }, -- Feint
	[11305] = { level=58, rank=3, class="ROGUE" }, -- Sprint
	[11314] = { level=42, rank=4, next=11315, class="SHAMAN" }, -- Fire Nova
	[11315] = { level=52, rank=5, next=25546, class="SHAMAN" }, -- Fire Nova
	[11335] = { level=44, rank=4, next=11336, class="ROGUE" }, -- Instant Poison IV
	[11336] = { level=52, rank=5, next=11337, class="ROGUE" }, -- Instant Poison V
	[11337] = { level=60, rank=6, next=26890, class="ROGUE" }, -- Instant Poison VI
	[11338] = { level=44, rank=4, next=11339, class="ROGUE" }, -- Instant Poison IV
	[11339] = { level=52, rank=5, next=11340, class="ROGUE" }, -- Instant Poison V
	[11340] = { level=60, rank=6, next=26891, class="ROGUE" }, -- Instant Poison VI
	[11353] = { level=46, rank=3, next=11354, class="ROGUE" }, -- Deadly Poison III
	[11354] = { level=54, rank=4, next=25349, class="ROGUE" }, -- Deadly Poison IV
	[11355] = { level=46, rank=3, next=11356, class="ROGUE" }, -- Deadly Poison III
	[11356] = { level=54, rank=4, next=25351, class="ROGUE" }, -- Deadly Poison IV
	[11366] = { level=20, rank=1, next=12505, class="MAGE" }, -- Pyroblast
	[11416] = { level=40, class="MAGE", faction="Alliance" }, -- Portal: Ironforge
	[11417] = { level=40, class="MAGE", faction="Horde" }, -- Portal: Orgrimmar
	[11418] = { level=40, class="MAGE", faction="Horde" }, -- Portal: Undercity
	[11419] = { level=50, class="MAGE", faction="Alliance" }, -- Portal: Darnassus
	[11420] = { level=50, class="MAGE", faction="Horde" }, -- Portal: Thunder Bluff
	[11426] = { level=40, rank=1, next=13031, class="MAGE" }, -- Ice Barrier
	[11549] = { level=32, rank=4, next=11550, class="WARRIOR" }, -- Battle Shout
	[11550] = { level=42, rank=5, next=11551, class="WARRIOR" }, -- Battle Shout
	[11551] = { level=52, rank=6, next=25289, class="WARRIOR" }, -- Battle Shout
	[11554] = { level=34, rank=3, next=11555, class="WARRIOR" }, -- Demoralizing Shout
	[11555] = { level=44, rank=4, next=11556, class="WARRIOR" }, -- Demoralizing Shout
	[11556] = { level=54, rank=5, next=25202, class="WARRIOR" }, -- Demoralizing Shout
	[11564] = { level=32, rank=5, next=11565, class="WARRIOR" }, -- Heroic Strike
	[11565] = { level=40, rank=6, next=11566, class="WARRIOR" }, -- Heroic Strike
	[11566] = { level=48, rank=7, next=11567, class="WARRIOR" }, -- Heroic Strike
	[11567] = { level=56, rank=8, next=25286, class="WARRIOR" }, -- Heroic Strike
	[11572] = { level=40, rank=5, next=11573, class="WARRIOR" }, -- Rend
	[11573] = { level=50, rank=6, next=11574, class="WARRIOR" }, -- Rend
	[11574] = { level=60, rank=7, next=25208, class="WARRIOR" }, -- Rend
	[11578] = { level=46, rank=3, class="WARRIOR" }, -- Charge
	[11580] = { level=48, rank=5, next=11581, class="WARRIOR" }, -- Thunder Clap
	[11581] = { level=58, rank=6, next=25264, class="WARRIOR" }, -- Thunder Clap
	[11600] = { level=44, rank=4, next=11601, class="WARRIOR" }, -- Revenge
	[11601] = { level=54, rank=5, next=25288, class="WARRIOR" }, -- Revenge
	[11604] = { level=46, rank=3, next=11605, class="WARRIOR" }, -- Slam
	[11605] = { level=54, rank=4, next=25241, class="WARRIOR" }, -- Slam
	[11608] = { level=40, rank=3, next=11609, class="WARRIOR" }, -- Cleave
	[11609] = { level=50, rank=4, next=20569, class="WARRIOR" }, -- Cleave
	[11659] = { level=44, rank=7, next=11660, class="WARLOCK" }, -- Shadow Bolt
	[11660] = { level=52, rank=8, next=11661, class="WARLOCK" }, -- Shadow Bolt
	[11661] = { level=60, rank=9, next=25307, class="WARLOCK" }, -- Shadow Bolt
	[11665] = { level=40, rank=5, next=11667, class="WARLOCK" }, -- Immolate
	[11667] = { level=50, rank=6, next=11668, class="WARLOCK" }, -- Immolate
	[11668] = { level=60, rank=7, next=25309, class="WARLOCK" }, -- Immolate
	[11671] = { level=44, rank=5, next=11672, class="WARLOCK" }, -- Corruption
	[11672] = { level=54, rank=6, next=25311, class="WARLOCK" }, -- Corruption
	[11675] = { level=52, rank=4, next=27217, class="WARLOCK" }, -- Drain Soul
	[11677] = { level=46, rank=3, next=11678, class="WARLOCK" }, -- Rain of Fire
	[11678] = { level=58, rank=4, next=27212, class="WARLOCK" }, -- Rain of Fire
	[11683] = { level=42, rank=2, next=11684, class="WARLOCK" }, -- Hellfire
	[11684] = { level=54, rank=3, next=27213, class="WARLOCK" }, -- Hellfire
	[11687] = { level=36, rank=4, next=11688, class="WARLOCK" }, -- Life Tap
	[11688] = { level=46, rank=5, next=11689, class="WARLOCK" }, -- Life Tap
	[11689] = { level=56, rank=6, next=27222, class="WARLOCK" }, -- Life Tap
	[11693] = { level=44, rank=5, next=11694, class="WARLOCK" }, -- Health Funnel
	[11694] = { level=52, rank=6, next=11695, class="WARLOCK" }, -- Health Funnel
	[11695] = { level=60, rank=7, next=27259, class="WARLOCK" }, -- Health Funnel
	[11699] = { level=46, rank=5, next=11700, class="WARLOCK" }, -- Drain Life
	[11700] = { level=54, rank=6, next=27219, class="WARLOCK" }, -- Drain Life
	[11707] = { level=42, rank=5, next=11708, class="WARLOCK" }, -- Curse of Weakness
	[11708] = { level=52, rank=6, next=27224, class="WARLOCK" }, -- Curse of Weakness
	[11711] = { level=38, rank=4, next=11712, class="WARLOCK" }, -- Curse of Agony
	[11712] = { level=48, rank=5, next=11713, class="WARLOCK" }, -- Curse of Agony
	[11713] = { level=58, rank=6, next=27218, class="WARLOCK" }, -- Curse of Agony
	[11719] = { level=50, rank=2, class="WARLOCK" }, -- Curse of Tongues
	[11721] = { level=46, rank=2, next=11722, class="WARLOCK" }, -- Curse of the Elements
	[11722] = { level=60, rank=3, next=27228, class="WARLOCK" }, -- Curse of the Elements
	[11725] = { level=44, rank=2, next=11726, class="WARLOCK" }, -- Enslave Demon
	[11726] = { level=58, rank=3, next=61191, class="WARLOCK" }, -- Enslave Demon
	[11729] = { level=46, rank=4, next=11730, class="WARLOCK" }, -- Create Healthstone
	[11730] = { level=58, rank=5, next=27230, class="WARLOCK" }, -- Create Healthstone
	[11733] = { level=40, rank=3, next=11734, class="WARLOCK" }, -- Demon Armor
	[11734] = { level=50, rank=4, next=11735, class="WARLOCK" }, -- Demon Armor
	[11735] = { level=60, rank=5, next=27260, class="WARLOCK" }, -- Demon Armor
	[11739] = { level=42, rank=2, next=11740, class="WARLOCK" }, -- Shadow Ward
	[11740] = { level=52, rank=3, next=28610, class="WARLOCK" }, -- Shadow Ward
	[12051] = { level=20, class="MAGE" }, -- Evocation
	[12294] = { level=40, rank=1, next=21551, class="WARRIOR" }, -- Mortal Strike
	[12505] = { level=24, rank=2, next=12522, class="MAGE" }, -- Pyroblast
	[12522] = { level=30, rank=3, next=12523, class="MAGE" }, -- Pyroblast
	[12523] = { level=36, rank=4, next=12524, class="MAGE" }, -- Pyroblast
	[12524] = { level=42, rank=5, next=12525, class="MAGE" }, -- Pyroblast
	[12525] = { level=48, rank=6, next=12526, class="MAGE" }, -- Pyroblast
	[12526] = { level=54, rank=7, next=18809, class="MAGE" }, -- Pyroblast
	[12678] = { level=20, class="WARRIOR" }, -- Stance Mastery
	[12824] = { level=20, rank=2, next=12825, class="MAGE" }, -- Polymorph
	[12825] = { level=40, rank=3, next=12826, class="MAGE" }, -- Polymorph
	[12826] = { level=60, rank=4, class="MAGE" }, -- Polymorph
	[13018] = { level=36, rank=2, next=13019, class="MAGE" }, -- Blast Wave
	[13019] = { level=44, rank=3, next=13020, class="MAGE" }, -- Blast Wave
	[13020] = { level=52, rank=4, next=13021, class="MAGE" }, -- Blast Wave
	[13021] = { level=60, rank=5, next=27133, class="MAGE" }, -- Blast Wave
	[13031] = { level=46, rank=2, next=13032, class="MAGE" }, -- Ice Barrier
	[13032] = { level=52, rank=3, next=13033, class="MAGE" }, -- Ice Barrier
	[13033] = { level=58, rank=4, next=27134, class="MAGE" }, -- Ice Barrier
	[13159] = { level=40, class="HUNTER" }, -- Aspect of the Pack
	[13161] = { level=30, class="HUNTER" }, -- Aspect of the Beast
	[13163] = { level=4, rank=1, next=61846, class="HUNTER" }, -- Aspect of the Monkey
	[13165] = { level=10, rank=1, next=14318, class="HUNTER" }, -- Aspect of the Hawk
	[13218] = { level=32, rank=1, next=13222, class="ROGUE" }, -- Wound Poison
	[13219] = { level=32, rank=1, next=13225, class="ROGUE" }, -- Wound Poison
	[13222] = { level=40, rank=2, next=13223, class="ROGUE" }, -- Wound Poison II
	[13223] = { level=48, rank=3, next=13224, class="ROGUE" }, -- Wound Poison III
	[13224] = { level=56, rank=4, next=27188, class="ROGUE" }, -- Wound Poison IV
	[13225] = { level=40, rank=2, next=13226, class="ROGUE" }, -- Wound Poison II
	[13226] = { level=48, rank=3, next=13227, class="ROGUE" }, -- Wound Poison III
	[13227] = { level=56, rank=4, next=27189, class="ROGUE" }, -- Wound Poison IV
	[13542] = { level=44, rank=5, next=13543, class="HUNTER" }, -- Mend Pet
	[13543] = { level=52, rank=6, next=13544, class="HUNTER" }, -- Mend Pet
	[13544] = { level=60, rank=7, next=27046, class="HUNTER" }, -- Mend Pet
	[13549] = { level=10, rank=2, next=13550, class="HUNTER" }, -- Serpent Sting
	[13550] = { level=18, rank=3, next=13551, class="HUNTER" }, -- Serpent Sting
	[13551] = { level=26, rank=4, next=13552, class="HUNTER" }, -- Serpent Sting
	[13552] = { level=34, rank=5, next=13553, class="HUNTER" }, -- Serpent Sting
	[13553] = { level=42, rank=6, next=13554, class="HUNTER" }, -- Serpent Sting
	[13554] = { level=50, rank=7, next=13555, class="HUNTER" }, -- Serpent Sting
	[13555] = { level=58, rank=8, next=25295, class="HUNTER" }, -- Serpent Sting
	[13795] = { level=16, rank=1, next=14302, class="HUNTER" }, -- Immolation Trap
	[13809] = { level=28, class="HUNTER" }, -- Frost Trap
	[13813] = { level=34, rank=1, next=14316, class="HUNTER" }, -- Explosive Trap
	[14260] = { level=8, rank=2, next=14261, class="HUNTER" }, -- Raptor Strike
	[14261] = { level=16, rank=3, next=14262, class="HUNTER" }, -- Raptor Strike
	[14262] = { level=24, rank=4, next=14263, class="HUNTER" }, -- Raptor Strike
	[14263] = { level=32, rank=5, next=14264, class="HUNTER" }, -- Raptor Strike
	[14264] = { level=40, rank=6, next=14265, class="HUNTER" }, -- Raptor Strike
	[14265] = { level=48, rank=7, next=14266, class="HUNTER" }, -- Raptor Strike
	[14266] = { level=56, rank=8, next=27014, class="HUNTER" }, -- Raptor Strike
	[14269] = { level=30, rank=2, next=14270, class="HUNTER" }, -- Mongoose Bite
	[14270] = { level=44, rank=3, next=14271, class="HUNTER" }, -- Mongoose Bite
	[14271] = { level=58, rank=4, next=36916, class="HUNTER" }, -- Mongoose Bite
	[14281] = { level=12, rank=2, next=14282, class="HUNTER" }, -- Arcane Shot
	[14282] = { level=20, rank=3, next=14283, class="HUNTER" }, -- Arcane Shot
	[14283] = { level=28, rank=4, next=14284, class="HUNTER" }, -- Arcane Shot
	[14284] = { level=36, rank=5, next=14285, class="HUNTER" }, -- Arcane Shot
	[14285] = { level=44, rank=6, next=14286, class="HUNTER" }, -- Arcane Shot
	[14286] = { level=52, rank=7, next=14287, class="HUNTER" }, -- Arcane Shot
	[14287] = { level=60, rank=8, next=27019, class="HUNTER" }, -- Arcane Shot
	[14288] = { level=30, rank=2, next=14289, class="HUNTER" }, -- Multi-Shot
	[14289] = { level=42, rank=3, next=14290, class="HUNTER" }, -- Multi-Shot
	[14290] = { level=54, rank=4, next=25294, class="HUNTER" }, -- Multi-Shot
	[14294] = { level=50, rank=2, next=14295, class="HUNTER" }, -- Volley
	[14295] = { level=58, rank=3, next=27022, class="HUNTER" }, -- Volley
	[14302] = { level=26, rank=2, next=14303, class="HUNTER" }, -- Immolation Trap
	[14303] = { level=36, rank=3, next=14304, class="HUNTER" }, -- Immolation Trap
	[14304] = { level=46, rank=4, next=14305, class="HUNTER" }, -- Immolation Trap
	[14305] = { level=56, rank=5, next=27023, class="HUNTER" }, -- Immolation Trap
	[14310] = { level=40, rank=2, next=14311, class="HUNTER" }, -- Freezing Trap
	[14311] = { level=60, rank=3, class="HUNTER" }, -- Freezing Trap
	[14316] = { level=44, rank=2, next=14317, class="HUNTER" }, -- Explosive Trap
	[14317] = { level=54, rank=3, next=27025, class="HUNTER" }, -- Explosive Trap
	[14318] = { level=18, rank=2, next=14319, class="HUNTER" }, -- Aspect of the Hawk
	[14319] = { level=28, rank=3, next=14320, class="HUNTER" }, -- Aspect of the Hawk
	[14320] = { level=38, rank=4, next=14321, class="HUNTER" }, -- Aspect of the Hawk
	[14321] = { level=48, rank=5, next=14322, class="HUNTER" }, -- Aspect of the Hawk
	[14322] = { level=58, rank=6, next=25296, class="HUNTER" }, -- Aspect of the Hawk
	[14323] = { level=22, rank=2, next=14324, class="HUNTER" }, -- Hunter's Mark
	[14324] = { level=40, rank=3, next=14325, class="HUNTER" }, -- Hunter's Mark
	[14325] = { level=58, rank=4, next=53338, class="HUNTER" }, -- Hunter's Mark
	[14326] = { level=30, rank=2, next=14327, class="HUNTER" }, -- Scare Beast
	[14327] = { level=46, rank=3, class="HUNTER" }, -- Scare Beast
	[14752] = { level=30, rank=1, next=14818, class="PRIEST" }, -- Divine Spirit
	[14818] = { level=40, rank=2, next=14819, class="PRIEST" }, -- Divine Spirit
	[14819] = { level=50, rank=3, next=27841, class="PRIEST" }, -- Divine Spirit
	[14914] = { level=20, rank=1, next=15262, class="PRIEST" }, -- Holy Fire
	[15207] = { level=50, rank=9, next=15208, class="SHAMAN" }, -- Lightning Bolt
	[15208] = { level=56, rank=10, next=25448, class="SHAMAN" }, -- Lightning Bolt
	[15237] = { level=20, rank=1, next=15430, class="PRIEST" }, -- Holy Nova
	[15261] = { level=60, rank=8, next=25384, class="PRIEST" }, -- Holy Fire
	[15262] = { level=24, rank=2, next=15263, class="PRIEST" }, -- Holy Fire
	[15263] = { level=30, rank=3, next=15264, class="PRIEST" }, -- Holy Fire
	[15264] = { level=36, rank=4, next=15265, class="PRIEST" }, -- Holy Fire
	[15265] = { level=42, rank=5, next=15266, class="PRIEST" }, -- Holy Fire
	[15266] = { level=48, rank=6, next=15267, class="PRIEST" }, -- Holy Fire
	[15267] = { level=54, rank=7, next=15261, class="PRIEST" }, -- Holy Fire
	[15407] = { level=20, rank=1, next=17311, class="PRIEST" }, -- Mind Flay
	[15430] = { level=28, rank=2, next=15431, class="PRIEST" }, -- Holy Nova
	[15431] = { level=36, rank=3, next=27799, class="PRIEST" }, -- Holy Nova
	[16339] = { level=36, rank=4, next=16341, class="SHAMAN" }, -- Flametongue Weapon
	[16341] = { level=46, rank=5, next=16342, class="SHAMAN" }, -- Flametongue Weapon
	[16342] = { level=56, rank=6, next=25489, class="SHAMAN" }, -- Flametongue Weapon
	[16355] = { level=48, rank=4, next=16356, class="SHAMAN" }, -- Frostbrand Weapon
	[16356] = { level=58, rank=5, next=25500, class="SHAMAN" }, -- Frostbrand Weapon
	[16362] = { level=60, rank=4, next=25505, class="SHAMAN" }, -- Windfury Weapon
	[16387] = { level=58, rank=4, next=25557, class="SHAMAN" }, -- Flametongue Totem
	[16511] = { level=30, rank=1, next=17347, class="ROGUE" }, -- Hemorrhage
	[16689] = { level=10, rank=1, next=16810, class="DRUID" }, -- Nature's Grasp
	[16810] = { level=18, rank=2, next=16811, class="DRUID" }, -- Nature's Grasp
	[16811] = { level=28, rank=3, next=16812, class="DRUID" }, -- Nature's Grasp
	[16812] = { level=38, rank=4, next=16813, class="DRUID" }, -- Nature's Grasp
	[16813] = { level=48, rank=5, next=17329, class="DRUID" }, -- Nature's Grasp
	[16857] = { level=18, class="DRUID" }, -- Faerie Fire (Feral)
	[16914] = { level=40, rank=1, next=17401, class="DRUID" }, -- Hurricane
	[16979] = { level=30, class="DRUID" }, -- Feral Charge - Bear
	[17311] = { level=28, rank=2, next=17312, class="PRIEST" }, -- Mind Flay
	[17312] = { level=36, rank=3, next=17313, class="PRIEST" }, -- Mind Flay
	[17313] = { level=44, rank=4, next=17314, class="PRIEST" }, -- Mind Flay
	[17314] = { level=52, rank=5, next=18807, class="PRIEST" }, -- Mind Flay
	[17329] = { level=58, rank=6, next=27009, class="DRUID" }, -- Nature's Grasp
	[17347] = { level=46, rank=2, next=17348, class="ROGUE" }, -- Hemorrhage
	[17348] = { level=58, rank=3, next=26864, class="ROGUE" }, -- Hemorrhage
	[17401] = { level=50, rank=2, next=17402, class="DRUID" }, -- Hurricane
	[17402] = { level=60, rank=3, next=27012, class="DRUID" }, -- Hurricane
	[17727] = { level=48, rank=2, next=17728, class="WARLOCK" }, -- Create Spellstone
	[17728] = { level=60, rank=3, next=28172, class="WARLOCK" }, -- Create Spellstone
	[17877] = { level=20, rank=1, next=18867, class="WARLOCK" }, -- Shadowburn
	[17919] = { level=26, rank=2, next=17920, class="WARLOCK" }, -- Searing Pain
	[17920] = { level=34, rank=3, next=17921, class="WARLOCK" }, -- Searing Pain
	[17921] = { level=42, rank=4, next=17922, class="WARLOCK" }, -- Searing Pain
	[17922] = { level=50, rank=5, next=17923, class="WARLOCK" }, -- Searing Pain
	[17923] = { level=58, rank=6, next=27210, class="WARLOCK" }, -- Searing Pain
	[17924] = { level=56, rank=2, next=27211, class="WARLOCK" }, -- Soul Fire
	[17925] = { level=50, rank=2, next=17926, class="WARLOCK" }, -- Death Coil
	[17926] = { level=58, rank=3, next=27223, class="WARLOCK" }, -- Death Coil
	[17928] = { level=54, rank=2, class="WARLOCK" }, -- Howl of Terror
	[17951] = { level=36, rank=2, next=17952, class="WARLOCK" }, -- Create Firestone
	[17952] = { level=46, rank=3, next=17953, class="WARLOCK" }, -- Create Firestone
	[17953] = { level=56, rank=4, next=27250, class="WARLOCK" }, -- Create Firestone
	[18220] = { level=40, rank=1, next=18937, class="WARLOCK" }, -- Dark Pact
	[18499] = { level=32, class="WARRIOR" }, -- Berserker Rage
	[18540] = { level=60, class="WARLOCK" }, -- Ritual of Doom
	[18647] = { level=48, rank=2, class="WARLOCK" }, -- Banish
	[18657] = { level=38, rank=2, next=18658, class="DRUID" }, -- Hibernate
	[18658] = { level=58, rank=3, class="DRUID" }, -- Hibernate
	[18807] = { level=60, rank=6, next=25387, class="PRIEST" }, -- Mind Flay
	[18809] = { level=60, rank=8, next=27132, class="MAGE" }, -- Pyroblast
	[18867] = { level=24, rank=2, next=18868, class="WARLOCK" }, -- Shadowburn
	[18868] = { level=32, rank=3, next=18869, class="WARLOCK" }, -- Shadowburn
	[18869] = { level=40, rank=4, next=18870, class="WARLOCK" }, -- Shadowburn
	[18870] = { level=48, rank=5, next=18871, class="WARLOCK" }, -- Shadowburn
	[18871] = { level=56, rank=6, next=27263, class="WARLOCK" }, -- Shadowburn
	[18937] = { level=50, rank=2, next=18938, class="WARLOCK" }, -- Dark Pact
	[18938] = { level=60, rank=3, next=27265, class="WARLOCK" }, -- Dark Pact
	[18960] = { level=10, class="DRUID" }, -- Teleport: Moonglade
	[19236] = { level=20, rank=1, next=19238, class="PRIEST" }, -- Desperate Prayer
	[19238] = { level=26, rank=2, next=19240, class="PRIEST" }, -- Desperate Prayer
	[19240] = { level=34, rank=3, next=19241, class="PRIEST" }, -- Desperate Prayer
	[19241] = { level=42, rank=4, next=19242, class="PRIEST" }, -- Desperate Prayer
	[19242] = { level=50, rank=5, next=19243, class="PRIEST" }, -- Desperate Prayer
	[19243] = { level=58, rank=6, next=25437, class="PRIEST" }, -- Desperate Prayer
	[19263] = { level=60, class="HUNTER" }, -- Deterrence
	[19276] = { level=28, rank=2, next=19277, class="PRIEST" }, -- Devouring Plague
	[19277] = { level=36, rank=3, next=19278, class="PRIEST" }, -- Devouring Plague
	[19278] = { level=44, rank=4, next=19279, class="PRIEST" }, -- Devouring Plague
	[19279] = { level=52, rank=5, next=19280, class="PRIEST" }, -- Devouring Plague
	[19280] = { level=60, rank=6, next=25467, class="PRIEST" }, -- Devouring Plague
	[19306] = { level=30, rank=1, next=20909, class="HUNTER" }, -- Counterattack
	[19386] = { level=40, rank=1, next=24132, class="HUNTER" }, -- Wyvern Sting
	[19434] = { level=20, rank=1, next=20900, class="HUNTER" }, -- Aimed Shot
	[19740] = { level=4, rank=1, next=19834, class="PALADIN" }, -- Blessing of Might
	[10314] = { level=60, rank=6, next=27138, class="PALADIN" }, -- Exorcism
	[27138] = { level=68, rank=7, next=48800, class="PALADIN" }, -- Exorcism
	[48800] = { level=73, rank=8, next=48801, class="PALADIN" }, -- Exorcism
	[19752] = { level=30, class="PALADIN" }, -- Divine Intervention
	[19801] = { level=60, class="HUNTER" }, -- Tranquilizing Shot
	[19834] = { level=12, rank=2, next=19835, class="PALADIN" }, -- Blessing of Might
	[19835] = { level=22, rank=3, next=19836, class="PALADIN" }, -- Blessing of Might
	[19836] = { level=32, rank=4, next=19837, class="PALADIN" }, -- Blessing of Might
	[19837] = { level=42, rank=5, next=19838, class="PALADIN" }, -- Blessing of Might
	[19838] = { level=52, rank=6, next=25291, class="PALADIN" }, -- Blessing of Might
	[48801] = { level=79, rank=9, class="PALADIN" }, -- Exorcism
	[19750] = { level=20, rank=1, next=19939, class="PALADIN" }, -- Flash of Light
	[19939] = { level=26, rank=2, next=19940, class="PALADIN" }, -- Flash of Light
	[19940] = { level=34, rank=3, next=19941, class="PALADIN" }, -- Flash of Light
	[19876] = { level=28, rank=1, next=19895, class="PALADIN" }, -- Shadow Resistance Aura
	[19878] = { level=32, class="HUNTER" }, -- Track Demons
	[19879] = { level=50, class="HUNTER" }, -- Track Dragonkin
	[19880] = { level=26, class="HUNTER" }, -- Track Elementals
	[19882] = { level=40, class="HUNTER" }, -- Track Giants
	[19883] = { level=10, class="HUNTER" }, -- Track Humanoids
	[19884] = { level=18, class="HUNTER" }, -- Track Undead
	[19885] = { level=24, class="HUNTER" }, -- Track Hidden
	[19888] = { level=32, rank=1, next=19897, class="PALADIN" }, -- Frost Resistance Aura
	[19891] = { level=36, rank=1, next=19899, class="PALADIN" }, -- Fire Resistance Aura
	[19895] = { level=40, rank=2, next=19896, class="PALADIN" }, -- Shadow Resistance Aura
	[19896] = { level=52, rank=3, next=27151, class="PALADIN" }, -- Shadow Resistance Aura
	[19897] = { level=44, rank=2, next=19898, class="PALADIN" }, -- Frost Resistance Aura
	[19898] = { level=56, rank=3, next=27152, class="PALADIN" }, -- Frost Resistance Aura
	[19899] = { level=48, rank=2, next=19900, class="PALADIN" }, -- Fire Resistance Aura
	[19900] = { level=60, rank=3, next=27153, class="PALADIN" }, -- Fire Resistance Aura
	[19941] = { level=42, rank=4, next=19942, class="PALADIN" }, -- Flash of Light
	[19942] = { level=50, rank=5, next=19943, class="PALADIN" }, -- Flash of Light
	[19943] = { level=58, rank=6, next=27137, class="PALADIN" }, -- Flash of Light
	[27137] = { level=66, rank=7, next=48784, class="PALADIN" }, -- Flash of Light
	[48784] = { level=74, rank=8, next=48785, class="PALADIN" }, -- Flash of Light
	[20043] = { level=46, rank=1, next=20190, class="HUNTER" }, -- Aspect of the Wild
	[48785] = { level=79, rank=9, class="PALADIN" }, -- Flash of Light
	[20164] = { level=22, class="PALADIN" }, -- Seal of Justice
	[25894] = { level=54, rank=1, next=25918, class="PALADIN" }, -- Greater Blessing of Wisdom
	[25918] = { level=60, rank=2, next=27143, class="PALADIN" }, -- Greater Blessing of Wisdom
	[20190] = { level=56, rank=2, next=27045, class="HUNTER" }, -- Aspect of the Wild
	[20217] = { level=20, class="PALADIN" }, -- Blessing of Kings
	[20230] = { level=20, class="WARRIOR" }, -- Retaliation
	[20243] = { level=50, rank=1, next=30016, class="WARRIOR" }, -- Devastate
	[20252] = { level=30, class="WARRIOR" }, -- Intercept
	[20271] = { level=4, class="PALADIN" }, -- Judgement of Light
	[27143] = { level=65, rank=3, next=48937, class="PALADIN" }, -- Greater Blessing of Wisdom
	[20484] = { level=20, rank=1, next=20739, class="DRUID" }, -- Rebirth
	[20569] = { level=60, rank=5, next=25231, class="WARRIOR" }, -- Cleave
	[20608] = { level=30, class="SHAMAN" }, -- Reincarnation
	[20609] = { level=24, rank=2, next=20610, class="SHAMAN" }, -- Ancestral Spirit
	[20610] = { level=36, rank=3, next=20776, class="SHAMAN" }, -- Ancestral Spirit
	[20658] = { level=32, rank=2, next=20660, class="WARRIOR" }, -- Execute
	[20660] = { level=40, rank=3, next=20661, class="WARRIOR" }, -- Execute
	[20661] = { level=48, rank=4, next=20662, class="WARRIOR" }, -- Execute
	[20662] = { level=56, rank=5, next=25234, class="WARRIOR" }, -- Execute
	[20719] = { level=40, class="DRUID" }, -- Feline Grace
	[20736] = { level=12, rank=1, class="HUNTER" }, -- Distracting Shot
	[20739] = { level=30, rank=2, next=20742, class="DRUID" }, -- Rebirth
	[20742] = { level=40, rank=3, next=20747, class="DRUID" }, -- Rebirth
	[20747] = { level=50, rank=4, next=20748, class="DRUID" }, -- Rebirth
	[20748] = { level=60, rank=5, next=26994, class="DRUID" }, -- Rebirth
	[20752] = { level=30, rank=2, next=20755, class="WARLOCK" }, -- Create Soulstone
	[20755] = { level=40, rank=3, next=20756, class="WARLOCK" }, -- Create Soulstone
	[20756] = { level=50, rank=4, next=20757, class="WARLOCK" }, -- Create Soulstone
	[20757] = { level=60, rank=5, next=27238, class="WARLOCK" }, -- Create Soulstone
	[20770] = { level=58, rank=5, next=25435, class="PRIEST" }, -- Resurrection
	[48937] = { level=71, rank=4, next=48938, class="PALADIN" }, -- Greater Blessing of Wisdom
	[48938] = { level=77, rank=5, class="PALADIN" }, -- Greater Blessing of Wisdom
	[20776] = { level=48, rank=4, next=20777, class="SHAMAN" }, -- Ancestral Spirit
	[20777] = { level=60, rank=5, next=25590, class="SHAMAN" }, -- Ancestral Spirit
	[20900] = { level=28, rank=2, next=20901, class="HUNTER" }, -- Aimed Shot
	[20901] = { level=36, rank=3, next=20902, class="HUNTER" }, -- Aimed Shot
	[20902] = { level=44, rank=4, next=20903, class="HUNTER" }, -- Aimed Shot
	[20903] = { level=52, rank=5, next=20904, class="HUNTER" }, -- Aimed Shot
	[20904] = { level=60, rank=6, next=27065, class="HUNTER" }, -- Aimed Shot
	[20909] = { level=42, rank=2, next=20910, class="HUNTER" }, -- Counterattack
	[20910] = { level=54, rank=3, next=27067, class="HUNTER" }, -- Counterattack
	[6673] = { level=1, rank=1, next=5242, class="WARRIOR" }, -- Battle Shout
	[639] = { level=6, rank=2, next=647, class="PALADIN" }, -- Holy Light
	[647] = { level=14, rank=3, next=1026, class="PALADIN" }, -- Holy Light
	[1026] = { level=22, rank=4, next=1042, class="PALADIN" }, -- Holy Light
	[20927] = { level=50, rank=2, next=20928, class="PALADIN" }, -- Holy Shield
	[20928] = { level=60, rank=3, next=27179, class="PALADIN" }, -- Holy Shield
	[1042] = { level=30, rank=5, next=3472, class="PALADIN" }, -- Holy Light
	[3472] = { level=38, rank=6, next=10328, class="PALADIN" }, -- Holy Light
	[21551] = { level=48, rank=2, next=21552, class="WARRIOR" }, -- Mortal Strike
	[21552] = { level=54, rank=3, next=21553, class="WARRIOR" }, -- Mortal Strike
	[21553] = { level=60, rank=4, next=25248, class="WARRIOR" }, -- Mortal Strike
	[21562] = { level=48, rank=1, next=21564, class="PRIEST" }, -- Prayer of Fortitude
	[21564] = { level=60, rank=2, next=25392, class="PRIEST" }, -- Prayer of Fortitude
	[21849] = { level=50, rank=1, next=21850, class="DRUID" }, -- Gift of the Wild
	[21850] = { level=60, rank=2, next=26991, class="DRUID" }, -- Gift of the Wild
	[22568] = { level=32, rank=1, next=22827, class="DRUID" }, -- Ferocious Bite
	[22570] = { level=62, rank=1, next=49802, class="DRUID" }, -- Maim
	[22782] = { level=46, rank=2, next=22783, class="MAGE" }, -- Mage Armor
	[22783] = { level=58, rank=3, next=27125, class="MAGE" }, -- Mage Armor
	[22812] = { level=44, class="DRUID" }, -- Barkskin
	[22827] = { level=40, rank=2, next=22828, class="DRUID" }, -- Ferocious Bite
	[22828] = { level=48, rank=3, next=22829, class="DRUID" }, -- Ferocious Bite
	[22829] = { level=56, rank=4, next=31018, class="DRUID" }, -- Ferocious Bite
	[22842] = { level=36, rank=1, class="DRUID" }, -- Frenzied Regeneration
	[23028] = { level=56, rank=1, next=27127, class="MAGE" }, -- Arcane Brilliance
	[23920] = { level=64, class="WARRIOR" }, -- Spell Reflection
	[23922] = { level=40, rank=1, next=23923, class="WARRIOR" }, -- Shield Slam
	[23923] = { level=48, rank=2, next=23924, class="WARRIOR" }, -- Shield Slam
	[23924] = { level=54, rank=3, next=23925, class="WARRIOR" }, -- Shield Slam
	[23925] = { level=60, rank=4, next=25258, class="WARRIOR" }, -- Shield Slam
	[24132] = { level=50, rank=2, next=24133, class="HUNTER" }, -- Wyvern Sting
	[24133] = { level=60, rank=3, next=27068, class="HUNTER" }, -- Wyvern Sting
	[24239] = { level=60, rank=3, next=27180, class="PALADIN" }, -- Hammer of Wrath
	[24248] = { level=63, rank=6, next=48576, class="DRUID" }, -- Ferocious Bite
	[24274] = { level=52, rank=2, next=24239, class="PALADIN" }, -- Hammer of Wrath
	[24275] = { level=44, rank=1, next=24274, class="PALADIN" }, -- Hammer of Wrath
	[24398] = { level=62, rank=7, next=33736, class="SHAMAN" }, -- Water Shield
	[24974] = { level=30, rank=2, next=24975, class="DRUID" }, -- Insect Swarm
	[24975] = { level=40, rank=3, next=24976, class="DRUID" }, -- Insect Swarm
	[24976] = { level=50, rank=4, next=24977, class="DRUID" }, -- Insect Swarm
	[24977] = { level=60, rank=5, next=27013, class="DRUID" }, -- Insect Swarm
	[25202] = { level=62, rank=6, next=25203, class="WARRIOR" }, -- Demoralizing Shout
	[25203] = { level=70, rank=7, next=47437, class="WARRIOR" }, -- Demoralizing Shout
	[25208] = { level=68, rank=8, next=46845, class="WARRIOR" }, -- Rend
	[25210] = { level=63, rank=6, next=25213, class="PRIEST" }, -- Greater Heal
	[25213] = { level=68, rank=7, next=48062, class="PRIEST" }, -- Greater Heal
	[25217] = { level=65, rank=11, next=25218, class="PRIEST" }, -- Power Word: Shield
	[25218] = { level=70, rank=12, next=48065, class="PRIEST" }, -- Power Word: Shield
	[25221] = { level=65, rank=11, next=25222, class="PRIEST" }, -- Renew
	[25222] = { level=70, rank=12, next=48067, class="PRIEST" }, -- Renew
	[25231] = { level=68, rank=6, next=47519, class="WARRIOR" }, -- Cleave
	[25233] = { level=61, rank=8, next=25235, class="PRIEST" }, -- Flash Heal
	[25234] = { level=65, rank=6, next=25236, class="WARRIOR" }, -- Execute
	[25235] = { level=67, rank=9, next=48070, class="PRIEST" }, -- Flash Heal
	[25236] = { level=70, rank=7, next=47470, class="WARRIOR" }, -- Execute
	[25241] = { level=61, rank=5, next=25242, class="WARRIOR" }, -- Slam
	[25242] = { level=69, rank=6, next=47474, class="WARRIOR" }, -- Slam
	[25248] = { level=66, rank=5, next=30330, class="WARRIOR" }, -- Mortal Strike
	[25258] = { level=66, rank=5, next=30356, class="WARRIOR" }, -- Shield Slam
	[25264] = { level=67, rank=7, next=47501, class="WARRIOR" }, -- Thunder Clap
	[25269] = { level=63, rank=7, next=30357, class="WARRIOR" }, -- Revenge
	[25286] = { level=60, rank=9, next=29707, class="WARRIOR" }, -- Heroic Strike
	[25288] = { level=60, rank=6, next=25269, class="WARRIOR" }, -- Revenge
	[25289] = { level=60, rank=7, next=2048, class="WARRIOR" }, -- Battle Shout
	[10328] = { level=46, rank=7, next=10329, class="PALADIN" }, -- Holy Light
	[25291] = { level=60, rank=7, next=27140, class="PALADIN" }, -- Blessing of Might
	[10329] = { level=54, rank=8, next=25292, class="PALADIN" }, -- Holy Light
	[25294] = { level=60, rank=5, next=27021, class="HUNTER" }, -- Multi-Shot
	[25295] = { level=60, rank=9, next=27016, class="HUNTER" }, -- Serpent Sting
	[25296] = { level=60, rank=7, next=27044, class="HUNTER" }, -- Aspect of the Hawk
	[25297] = { level=60, rank=11, next=26978, class="DRUID" }, -- Healing Touch
	[25298] = { level=60, rank=7, next=26986, class="DRUID" }, -- Starfire
	[25299] = { level=60, rank=11, next=26981, class="DRUID" }, -- Rejuvenation
	[25300] = { level=60, rank=9, next=26863, class="ROGUE" }, -- Backstab
	[25302] = { level=60, rank=5, next=27448, class="ROGUE" }, -- Feint
	[25304] = { level=60, rank=11, next=27071, class="MAGE" }, -- Frostbolt
	[25306] = { level=62, rank=12, next=27070, class="MAGE" }, -- Fireball
	[25307] = { level=62, rank=10, next=27209, class="WARLOCK" }, -- Shadow Bolt
	[25308] = { level=68, rank=6, next=48072, class="PRIEST" }, -- Prayer of Healing
	[25309] = { level=60, rank=8, next=27215, class="WARLOCK" }, -- Immolate
	[25311] = { level=60, rank=7, next=27216, class="WARLOCK" }, -- Corruption
	[25312] = { level=70, rank=5, next=48073, class="PRIEST" }, -- Divine Spirit
	[25314] = { level=60, rank=5, next=25210, class="PRIEST" }, -- Greater Heal
	[25315] = { level=60, rank=10, next=25221, class="PRIEST" }, -- Renew
	[25316] = { level=60, rank=5, next=25308, class="PRIEST" }, -- Prayer of Healing
	[25331] = { level=68, rank=7, next=48077, class="PRIEST" }, -- Holy Nova
	[25345] = { level=60, rank=8, next=27075, class="MAGE" }, -- Arcane Missiles
	[25349] = { level=60, rank=5, next=26967, class="ROGUE" }, -- Deadly Poison V
	[25351] = { level=60, rank=5, next=26968, class="ROGUE" }, -- Deadly Poison V
	[25357] = { level=60, rank=10, next=25391, class="SHAMAN" }, -- Healing Wave
	[25361] = { level=60, rank=5, next=25528, class="SHAMAN" }, -- Strength of Earth Totem
	[25363] = { level=61, rank=9, next=25364, class="PRIEST" }, -- Smite
	[25364] = { level=69, rank=10, next=48122, class="PRIEST" }, -- Smite
	[25367] = { level=65, rank=9, next=25368, class="PRIEST" }, -- Shadow Word: Pain
	[25368] = { level=70, rank=10, next=48124, class="PRIEST" }, -- Shadow Word: Pain
	[25372] = { level=63, rank=10, next=25375, class="PRIEST" }, -- Mind Blast
	[25375] = { level=69, rank=11, next=48126, class="PRIEST" }, -- Mind Blast
	[25384] = { level=66, rank=9, next=48134, class="PRIEST" }, -- Holy Fire
	[25387] = { level=68, rank=7, next=48155, class="PRIEST" }, -- Mind Flay
	[25389] = { level=70, rank=7, next=48161, class="PRIEST" }, -- Power Word: Fortitude
	[25391] = { level=63, rank=11, next=25396, class="SHAMAN" }, -- Healing Wave
	[25392] = { level=70, rank=3, next=48162, class="PRIEST" }, -- Prayer of Fortitude
	[25396] = { level=70, rank=12, next=49272, class="SHAMAN" }, -- Healing Wave
	[25420] = { level=66, rank=7, next=49275, class="SHAMAN" }, -- Lesser Healing Wave
	[25422] = { level=61, rank=4, next=25423, class="SHAMAN" }, -- Chain Heal
	[25423] = { level=68, rank=5, next=55458, class="SHAMAN" }, -- Chain Heal
	[25431] = { level=69, rank=7, next=48040, class="PRIEST" }, -- Inner Fire
	[25433] = { level=68, rank=4, next=48169, class="PRIEST" }, -- Shadow Protection
	[25435] = { level=68, rank=6, next=48171, class="PRIEST" }, -- Resurrection
	[25437] = { level=66, rank=7, next=48172, class="PRIEST" }, -- Desperate Prayer
	[25439] = { level=63, rank=5, next=25442, class="SHAMAN" }, -- Chain Lightning
	[25442] = { level=70, rank=6, next=49270, class="SHAMAN" }, -- Chain Lightning
	[25448] = { level=62, rank=11, next=25449, class="SHAMAN" }, -- Lightning Bolt
	[25449] = { level=67, rank=12, next=49237, class="SHAMAN" }, -- Lightning Bolt
	[25454] = { level=69, rank=8, next=49230, class="SHAMAN" }, -- Earth Shock
	[25457] = { level=70, rank=7, next=49232, class="SHAMAN" }, -- Flame Shock
	[25464] = { level=68, rank=5, next=49235, class="SHAMAN" }, -- Frost Shock
	[25467] = { level=68, rank=7, next=48299, class="PRIEST" }, -- Devouring Plague
	[25469] = { level=63, rank=8, next=25472, class="SHAMAN" }, -- Lightning Shield
	[25472] = { level=70, rank=9, next=49280, class="SHAMAN" }, -- Lightning Shield
	[25489] = { level=64, rank=7, next=58785, class="SHAMAN" }, -- Flametongue Weapon
	[25500] = { level=66, rank=6, next=58794, class="SHAMAN" }, -- Frostbrand Weapon
	[25505] = { level=68, rank=5, next=58801, class="SHAMAN" }, -- Windfury Weapon
	[25508] = { level=63, rank=7, next=25509, class="SHAMAN" }, -- Stoneskin Totem
	[25509] = { level=70, rank=8, next=58751, class="SHAMAN" }, -- Stoneskin Totem
	[25525] = { level=67, rank=7, next=58580, class="SHAMAN" }, -- Stoneclaw Totem
	[25528] = { level=65, rank=6, next=57622, class="SHAMAN" }, -- Strength of Earth Totem
	[25533] = { level=69, rank=7, next=58699, class="SHAMAN" }, -- Searing Totem
	[25546] = { level=61, rank=6, next=25547, class="SHAMAN" }, -- Fire Nova
	[25547] = { level=70, rank=7, next=61649, class="SHAMAN" }, -- Fire Nova
	[25552] = { level=65, rank=5, next=58731, class="SHAMAN" }, -- Magma Totem
	[25557] = { level=67, rank=5, next=58649, class="SHAMAN" }, -- Flametongue Totem
	[25560] = { level=67, rank=4, next=58741, class="SHAMAN" }, -- Frost Resistance Totem
	[25563] = { level=68, rank=4, next=58737, class="SHAMAN" }, -- Fire Resistance Totem
	[25567] = { level=69, rank=6, next=58755, class="SHAMAN" }, -- Healing Stream Totem
	[25570] = { level=65, rank=5, next=58771, class="SHAMAN" }, -- Mana Spring Totem
	[25574] = { level=69, rank=4, next=58746, class="SHAMAN" }, -- Nature Resistance Totem
	[25590] = { level=69, rank=6, next=49277, class="SHAMAN" }, -- Ancestral Spirit
	[25780] = { level=16, class="PALADIN" }, -- Righteous Fury
	[25782] = { level=52, rank=1, next=25916, class="PALADIN" }, -- Greater Blessing of Might
	[25292] = { level=60, rank=9, next=27135, class="PALADIN" }, -- Holy Light
	[25898] = { level=60, class="PALADIN" }, -- Greater Blessing of Kings
	[25899] = { level=60, class="PALADIN" }, -- Greater Blessing of Sanctuary
	[20911] = { level=30, class="PALADIN" }, -- Blessing of Sanctuary
	[25916] = { level=60, rank=2, next=27141, class="PALADIN" }, -- Greater Blessing of Might
	[27135] = { level=62, rank=10, next=27136, class="PALADIN" }, -- Holy Light
	[27136] = { level=70, rank=11, next=48781, class="PALADIN" }, -- Holy Light
	[26669] = { level=50, rank=2, class="ROGUE" }, -- Evasion
	[26679] = { level=64, rank=1, next=48673, class="ROGUE" }, -- Deadly Throw
	[26688] = { level=68, rank=1, next=57981, class="ROGUE" }, -- Anesthetic Poison
	[26785] = { level=68, rank=1, next=57982, class="ROGUE" }, -- Anesthetic Poison
	[26839] = { level=61, rank=7, next=26884, class="ROGUE" }, -- Garrote
	[26861] = { level=62, rank=9, next=26862, class="ROGUE" }, -- Sinister Strike
	[26862] = { level=70, rank=10, next=48637, class="ROGUE" }, -- Sinister Strike
	[26863] = { level=68, rank=10, next=48656, class="ROGUE" }, -- Backstab
	[26864] = { level=70, rank=4, next=48660, class="ROGUE" }, -- Hemorrhage
	[26865] = { level=64, rank=10, next=48667, class="ROGUE" }, -- Eviscerate
	[26867] = { level=68, rank=7, next=48671, class="ROGUE" }, -- Rupture
	[26884] = { level=70, rank=8, next=48675, class="ROGUE" }, -- Garrote
	[26889] = { level=62, rank=3, class="ROGUE" }, -- Vanish
	[26890] = { level=68, rank=7, next=57964, class="ROGUE" }, -- Instant Poison VII
	[26891] = { level=68, rank=7, next=57967, class="ROGUE" }, -- Instant Poison VII
	[26967] = { level=62, rank=6, next=27186, class="ROGUE" }, -- Deadly Poison VI
	[26968] = { level=62, rank=6, next=27187, class="ROGUE" }, -- Deadly Poison VI
	[26978] = { level=62, rank=12, next=26979, class="DRUID" }, -- Healing Touch
	[26979] = { level=69, rank=13, next=48377, class="DRUID" }, -- Healing Touch
	[26980] = { level=65, rank=10, next=48442, class="DRUID" }, -- Regrowth
	[26981] = { level=63, rank=12, next=26982, class="DRUID" }, -- Rejuvenation
	[26982] = { level=69, rank=13, next=48440, class="DRUID" }, -- Rejuvenation
	[26983] = { level=70, rank=5, next=48446, class="DRUID" }, -- Tranquility
	[26984] = { level=61, rank=9, next=26985, class="DRUID" }, -- Wrath
	[26985] = { level=69, rank=10, next=48459, class="DRUID" }, -- Wrath
	[26986] = { level=67, rank=8, next=48464, class="DRUID" }, -- Starfire
	[26987] = { level=63, rank=11, next=26988, class="DRUID" }, -- Moonfire
	[26988] = { level=70, rank=12, next=48462, class="DRUID" }, -- Moonfire
	[26989] = { level=68, rank=7, next=53308, class="DRUID" }, -- Entangling Roots
	[26990] = { level=70, rank=8, next=48469, class="DRUID" }, -- Mark of the Wild
	[26991] = { level=70, rank=3, next=48470, class="DRUID" }, -- Gift of the Wild
	[26992] = { level=64, rank=7, next=53307, class="DRUID" }, -- Thorns
	[26994] = { level=69, rank=6, next=48477, class="DRUID" }, -- Rebirth
	[26995] = { level=70, rank=4, class="DRUID" }, -- Soothe Animal
	[26996] = { level=67, rank=8, next=48479, class="DRUID" }, -- Maul
	[26997] = { level=64, rank=6, next=48561, class="DRUID" }, -- Swipe (Bear)
	[26998] = { level=62, rank=6, next=48559, class="DRUID" }, -- Demoralizing Roar
	[27000] = { level=67, rank=6, next=48569, class="DRUID" }, -- Claw
	[27001] = { level=61, rank=6, next=27002, class="DRUID" }, -- Shred
	[27002] = { level=70, rank=7, next=48571, class="DRUID" }, -- Shred
	[27003] = { level=64, rank=5, next=48573, class="DRUID" }, -- Rake
	[27004] = { level=69, rank=5, next=48575, class="DRUID" }, -- Cower
	[27005] = { level=66, rank=5, next=48578, class="DRUID" }, -- Ravage
	[27006] = { level=66, rank=4, next=49803, class="DRUID" }, -- Pounce
	[27008] = { level=67, rank=7, next=49799, class="DRUID" }, -- Rip
	[27009] = { level=68, rank=7, next=53312, class="DRUID" }, -- Nature's Grasp
	[27012] = { level=70, rank=4, next=48467, class="DRUID" }, -- Hurricane
	[27013] = { level=70, rank=6, next=48468, class="DRUID" }, -- Insect Swarm
	[27014] = { level=63, rank=9, next=48995, class="HUNTER" }, -- Raptor Strike
	[27016] = { level=67, rank=10, next=49000, class="HUNTER" }, -- Serpent Sting
	[27019] = { level=69, rank=9, next=49044, class="HUNTER" }, -- Arcane Shot
	[27021] = { level=67, rank=6, next=49047, class="HUNTER" }, -- Multi-Shot
	[27022] = { level=67, rank=4, next=58431, class="HUNTER" }, -- Volley
	[27023] = { level=65, rank=6, next=49055, class="HUNTER" }, -- Immolation Trap
	[27025] = { level=61, rank=4, next=49066, class="HUNTER" }, -- Explosive Trap
	[27044] = { level=68, rank=8, next=61846, class="HUNTER" }, -- Aspect of the Hawk
	[27045] = { level=68, rank=3, next=49071, class="HUNTER" }, -- Aspect of the Wild
	[27046] = { level=68, rank=8, next=48989, class="HUNTER" }, -- Mend Pet
	[27065] = { level=70, rank=7, next=49049, class="HUNTER" }, -- Aimed Shot
	[27067] = { level=66, rank=4, next=48998, class="HUNTER" }, -- Counterattack
	[27068] = { level=70, rank=4, next=49011, class="HUNTER" }, -- Wyvern Sting
	[27070] = { level=66, rank=13, next=38692, class="MAGE" }, -- Fireball
	[27071] = { level=63, rank=12, next=27072, class="MAGE" }, -- Frostbolt
	[27072] = { level=69, rank=13, next=38697, class="MAGE" }, -- Frostbolt
	[27073] = { level=65, rank=8, next=27074, class="MAGE" }, -- Scorch
	[27074] = { level=70, rank=9, next=42858, class="MAGE" }, -- Scorch
	[27075] = { level=63, rank=9, next=38699, class="MAGE" }, -- Arcane Missiles
	[27078] = { level=61, rank=8, next=27079, class="MAGE" }, -- Fire Blast
	[27079] = { level=70, rank=9, next=42872, class="MAGE" }, -- Fire Blast
	[27080] = { level=62, rank=7, next=27082, class="MAGE" }, -- Arcane Explosion
	[27082] = { level=70, rank=8, next=42920, class="MAGE" }, -- Arcane Explosion
	[27085] = { level=68, rank=7, next=42939, class="MAGE" }, -- Blizzard
	[27086] = { level=64, rank=7, next=42925, class="MAGE" }, -- Flamestrike
	[27087] = { level=65, rank=6, next=42930, class="MAGE" }, -- Cone of Cold
	[27088] = { level=67, rank=5, next=42917, class="MAGE" }, -- Frost Nova
	[27090] = { level=70, rank=9, next=42955, class="MAGE" }, -- Conjure Water
	[27101] = { level=68, rank=5, next=42985, class="MAGE" }, -- Conjure Mana Gem
	[27124] = { level=69, rank=5, next=43008, class="MAGE" }, -- Ice Armor
	[27125] = { level=69, rank=4, next=43023, class="MAGE" }, -- Mage Armor
	[27126] = { level=70, rank=6, next=42995, class="MAGE" }, -- Arcane Intellect
	[27127] = { level=70, rank=2, next=43002, class="MAGE" }, -- Arcane Brilliance
	[27128] = { level=69, rank=6, next=43010, class="MAGE" }, -- Fire Ward
	[27130] = { level=63, rank=5, next=33946, class="MAGE" }, -- Amplify Magic
	[27131] = { level=68, rank=7, next=43019, class="MAGE" }, -- Mana Shield
	[27132] = { level=66, rank=9, next=33938, class="MAGE" }, -- Pyroblast
	[27133] = { level=65, rank=6, next=33933, class="MAGE" }, -- Blast Wave
	[27134] = { level=64, rank=5, next=33405, class="MAGE" }, -- Ice Barrier
	[48781] = { level=75, rank=12, next=48782, class="PALADIN" }, -- Holy Light
	[48782] = { level=80, rank=13, class="PALADIN" }, -- Holy Light
	[20925] = { level=40, rank=1, next=20927, class="PALADIN" }, -- Holy Shield
	[20473] = { level=40, rank=1, next=20929, class="PALADIN" }, -- Holy Shock
	[20929] = { level=48, rank=2, next=20930, class="PALADIN" }, -- Holy Shock
	[27140] = { level=70, rank=8, next=48931, class="PALADIN" }, -- Blessing of Might
	[27141] = { level=70, rank=3, next=48933, class="PALADIN" }, -- Greater Blessing of Might
	[20930] = { level=56, rank=3, next=27174, class="PALADIN" }, -- Holy Shock
	[27174] = { level=64, rank=4, next=33072, class="PALADIN" }, -- Holy Shock
	[27149] = { level=70, rank=8, next=48941, class="PALADIN" }, -- Devotion Aura
	[27150] = { level=66, rank=6, next=54043, class="PALADIN" }, -- Retribution Aura
	[27151] = { level=63, rank=4, next=48943, class="PALADIN" }, -- Shadow Resistance Aura
	[27152] = { level=68, rank=4, next=48945, class="PALADIN" }, -- Frost Resistance Aura
	[27153] = { level=70, rank=4, next=48947, class="PALADIN" }, -- Fire Resistance Aura
	[33072] = { level=70, rank=5, next=48824, class="PALADIN" }, -- Holy Shock
	[48824] = { level=75, rank=6, next=48825, class="PALADIN" }, -- Holy Shock
	[48825] = { level=80, rank=7, class="PALADIN" }, -- Holy Shock
	[27179] = { level=70, rank=4, next=48951, class="PALADIN" }, -- Holy Shield
	[27180] = { level=68, rank=4, next=48805, class="PALADIN" }, -- Hammer of Wrath
	[27186] = { level=70, rank=7, next=57969, class="ROGUE" }, -- Deadly Poison VII
	[27187] = { level=70, rank=7, next=57972, class="ROGUE" }, -- Deadly Poison VII
	[27188] = { level=64, rank=5, next=57974, class="ROGUE" }, -- Wound Poison V
	[27189] = { level=64, rank=5, next=57977, class="ROGUE" }, -- Wound Poison V
	[27209] = { level=69, rank=11, next=47808, class="WARLOCK" }, -- Shadow Bolt
	[27210] = { level=65, rank=7, next=30459, class="WARLOCK" }, -- Searing Pain
	[27211] = { level=64, rank=3, next=30545, class="WARLOCK" }, -- Soul Fire
	[27212] = { level=69, rank=5, next=47819, class="WARLOCK" }, -- Rain of Fire
	[27213] = { level=68, rank=4, next=47823, class="WARLOCK" }, -- Hellfire
	[27215] = { level=69, rank=9, next=47810, class="WARLOCK" }, -- Immolate
	[27216] = { level=65, rank=8, next=47812, class="WARLOCK" }, -- Corruption
	[27217] = { level=67, rank=5, next=47855, class="WARLOCK" }, -- Drain Soul
	[27218] = { level=67, rank=7, next=47863, class="WARLOCK" }, -- Curse of Agony
	[27219] = { level=62, rank=7, next=27220, class="WARLOCK" }, -- Drain Life
	[27220] = { level=69, rank=8, next=47857, class="WARLOCK" }, -- Drain Life
	[27222] = { level=68, rank=7, next=57946, class="WARLOCK" }, -- Life Tap
	[27223] = { level=68, rank=4, next=47859, class="WARLOCK" }, -- Death Coil
	[27224] = { level=61, rank=7, next=30909, class="WARLOCK" }, -- Curse of Weakness
	[27228] = { level=69, rank=4, next=47865, class="WARLOCK" }, -- Curse of the Elements
	[27230] = { level=68, rank=6, next=47871, class="WARLOCK" }, -- Create Healthstone
	[27238] = { level=70, rank=6, next=47884, class="WARLOCK" }, -- Create Soulstone
	[27243] = { level=70, rank=1, next=47835, class="WARLOCK" }, -- Seed of Corruption
	[27250] = { level=66, rank=5, next=60219, class="WARLOCK" }, -- Create Firestone
	[27259] = { level=67, rank=8, next=47856, class="WARLOCK" }, -- Health Funnel
	[27260] = { level=70, rank=6, next=47793, class="WARLOCK" }, -- Demon Armor
	[27263] = { level=63, rank=7, next=30546, class="WARLOCK" }, -- Shadowburn
	[27265] = { level=70, rank=4, next=59092, class="WARLOCK" }, -- Dark Pact
	[27441] = { level=66, rank=7, next=48689, class="ROGUE" }, -- Ambush
	[27448] = { level=64, rank=6, next=48658, class="ROGUE" }, -- Feint
	[27681] = { level=60, rank=1, next=32999, class="PRIEST" }, -- Prayer of Spirit
	[27683] = { level=56, rank=1, next=39374, class="PRIEST" }, -- Prayer of Shadow Protection
	[27799] = { level=44, rank=4, next=27800, class="PRIEST" }, -- Holy Nova
	[27800] = { level=52, rank=5, next=27801, class="PRIEST" }, -- Holy Nova
	[27801] = { level=60, rank=6, next=25331, class="PRIEST" }, -- Holy Nova
	[27841] = { level=60, rank=4, next=25312, class="PRIEST" }, -- Divine Spirit
	[27870] = { level=50, rank=2, next=27871, class="PRIEST" }, -- Lightwell
	[27871] = { level=60, rank=3, next=28275, class="PRIEST" }, -- Lightwell
	[28172] = { level=66, rank=4, next=47886, class="WARLOCK" }, -- Create Spellstone
	[28176] = { level=62, rank=1, next=28189, class="WARLOCK" }, -- Fel Armor
	[28189] = { level=69, rank=2, next=47892, class="WARLOCK" }, -- Fel Armor
	[28271] = { level=60, class="MAGE" }, -- Polymorph: Turtle
	[28272] = { level=60, class="MAGE" }, -- Polymorph: Pig
	[28275] = { level=70, rank=4, next=48086, class="PRIEST" }, -- Lightwell
	[28609] = { level=60, rank=5, next=32796, class="MAGE" }, -- Frost Ward
	[28610] = { level=60, rank=4, next=47890, class="WARLOCK" }, -- Shadow Ward
	[28612] = { level=60, rank=7, next=33717, class="MAGE" }, -- Conjure Food
	[29166] = { level=40, class="DRUID" }, -- Innervate
	[29228] = { level=60, rank=6, next=25457, class="SHAMAN" }, -- Flame Shock
	[29707] = { level=66, rank=10, next=30324, class="WARRIOR" }, -- Heroic Strike
	[29722] = { level=64, rank=1, next=32231, class="WARLOCK" }, -- Incinerate
	[29858] = { level=66, class="WARLOCK" }, -- Soulshatter
	[29893] = { level=68, rank=1, next=58887, class="WARLOCK" }, -- Ritual of Souls
	[30016] = { level=60, rank=2, next=30022, class="WARRIOR" }, -- Devastate
	[30022] = { level=70, rank=3, next=47497, class="WARRIOR" }, -- Devastate
	[30108] = { level=50, rank=1, next=30404, class="WARLOCK" }, -- Unstable Affliction
	[30283] = { level=50, rank=1, next=30413, class="WARLOCK" }, -- Shadowfury
	[30324] = { level=70, rank=11, next=47449, class="WARRIOR" }, -- Heroic Strike
	[30330] = { level=70, rank=6, next=47485, class="WARRIOR" }, -- Mortal Strike
	[30356] = { level=70, rank=6, next=47487, class="WARRIOR" }, -- Shield Slam
	[30357] = { level=70, rank=8, next=57823, class="WARRIOR" }, -- Revenge
	[30404] = { level=60, rank=2, next=30405, class="WARLOCK" }, -- Unstable Affliction
	[30405] = { level=70, rank=3, next=47841, class="WARLOCK" }, -- Unstable Affliction
	[30413] = { level=60, rank=2, next=30414, class="WARLOCK" }, -- Shadowfury
	[30414] = { level=70, rank=3, next=47846, class="WARLOCK" }, -- Shadowfury
	[30449] = { level=70, class="MAGE" }, -- Spellsteal
	[30451] = { level=64, rank=1, next=42894, class="MAGE" }, -- Arcane Blast
	[30455] = { level=66, rank=1, next=42913, class="MAGE" }, -- Ice Lance
	[30459] = { level=70, rank=8, next=47814, class="WARLOCK" }, -- Searing Pain
	[30482] = { level=62, rank=1, next=43045, class="MAGE" }, -- Molten Armor
	[30545] = { level=70, rank=4, next=47824, class="WARLOCK" }, -- Soul Fire
	[30546] = { level=70, rank=8, next=47826, class="WARLOCK" }, -- Shadowburn
	[30706] = { level=50, rank=1, next=57720, class="SHAMAN" }, -- Totem of Wrath
	[30909] = { level=69, rank=8, next=50511, class="WARLOCK" }, -- Curse of Weakness
	[30910] = { level=70, rank=2, next=47867, class="WARLOCK" }, -- Curse of Doom
	[31016] = { level=60, rank=9, next=26865, class="ROGUE" }, -- Eviscerate
	[31018] = { level=60, rank=5, next=24248, class="DRUID" }, -- Ferocious Bite
	[31224] = { level=66, class="ROGUE" }, -- Cloak of Shadows
	[31661] = { level=50, rank=1, next=33041, class="MAGE" }, -- Dragon's Breath
	[31709] = { level=60, rank=4, next=27004, class="DRUID" }, -- Cower
	[31789] = { level=14, class="PALADIN" }, -- Righteous Defense
	[31801] = { level=64, class="PALADIN", faction="Alliance" }, -- Seal of Vengeance
	[31884] = { level=70, class="PALADIN" }, -- Avenging Wrath
	[2812] = { level=50, rank=1, next=10318, class="PALADIN" }, -- Holy Wrath
	[32182] = { level=70, class="SHAMAN", faction="Alliance" }, -- Heroism
	[32223] = { level=62, class="PALADIN" }, -- Crusader Aura
	[32231] = { level=70, rank=2, next=47837, class="WARLOCK" }, -- Incinerate
	[32266] = { level=40, class="MAGE", faction="Alliance" }, -- Portal: Exodar
	[32267] = { level=40, class="MAGE", faction="Horde" }, -- Portal: Silvermoon
	[32271] = { level=20, class="MAGE", faction="Alliance" }, -- Teleport: Exodar
	[32272] = { level=20, class="MAGE", faction="Horde" }, -- Teleport: Silvermoon
	[32375] = { level=70, class="PRIEST" }, -- Mass Dispel
	[32379] = { level=62, rank=1, next=32996, class="PRIEST" }, -- Shadow Word: Death
	[32546] = { level=64, rank=1, next=48119, class="PRIEST" }, -- Binding Heal
	[32593] = { level=60, rank=2, next=32594, class="SHAMAN" }, -- Earth Shield
	[32594] = { level=70, rank=3, next=49283, class="SHAMAN" }, -- Earth Shield
	[32645] = { level=62, rank=1, next=32684, class="ROGUE" }, -- Envenom
	[32684] = { level=69, rank=2, next=57992, class="ROGUE" }, -- Envenom
	[32699] = { level=60, rank=2, next=32700, class="PALADIN" }, -- Avenger's Shield
	[32700] = { level=70, rank=3, next=48826, class="PALADIN" }, -- Avenger's Shield
	[32796] = { level=70, rank=6, next=43012, class="MAGE" }, -- Frost Ward
	[32996] = { level=70, rank=2, next=48157, class="PRIEST" }, -- Shadow Word: Death
	[32999] = { level=70, rank=2, next=48074, class="PRIEST" }, -- Prayer of Spirit
	[33041] = { level=56, rank=2, next=33042, class="MAGE" }, -- Dragon's Breath
	[33042] = { level=64, rank=3, next=33043, class="MAGE" }, -- Dragon's Breath
	[33043] = { level=70, rank=4, next=42949, class="MAGE" }, -- Dragon's Breath
	[10318] = { level=60, rank=2, next=27139, class="PALADIN" }, -- Holy Wrath
	[33076] = { level=68, rank=1, next=48112, class="PRIEST" }, -- Prayer of Mending
	[33357] = { level=65, rank=3, class="DRUID" }, -- Dash
	[33405] = { level=70, rank=6, next=43038, class="MAGE" }, -- Ice Barrier
	[33690] = { level=60, class="MAGE", faction="Alliance" }, -- Teleport: Shattrath
	[33691] = { level=65, class="MAGE", faction="Alliance" }, -- Portal: Shattrath
	[33717] = { level=70, rank=8, next=42955, class="MAGE" }, -- Conjure Food
	[33736] = { level=69, rank=8, next=57960, class="SHAMAN" }, -- Water Shield
	[33745] = { level=66, rank=1, next=48567, class="DRUID" }, -- Lacerate
	[33763] = { level=64, rank=1, next=48450, class="DRUID" }, -- Lifebloom
	[33786] = { level=70, class="DRUID" }, -- Cyclone
	[33876] = { level=50, rank=1, next=33982, class="DRUID" }, -- Mangle (Cat)
	[33878] = { level=50, rank=1, next=33986, class="DRUID" }, -- Mangle (Bear)
	[33891] = { level=50, class="DRUID" }, -- Tree of Life
	[33933] = { level=70, rank=7, next=42944, class="MAGE" }, -- Blast Wave
	[33938] = { level=70, rank=10, next=42890, class="MAGE" }, -- Pyroblast
	[33943] = { level=60, class="DRUID" }, -- Flight Form
	[33944] = { level=67, rank=6, next=43015, class="MAGE" }, -- Dampen Magic
	[33946] = { level=69, rank=6, next=43017, class="MAGE" }, -- Amplify Magic
	[33982] = { level=58, rank=2, next=33983, class="DRUID" }, -- Mangle (Cat)
	[33983] = { level=68, rank=3, next=48565, class="DRUID" }, -- Mangle (Cat)
	[33986] = { level=58, rank=2, next=33987, class="DRUID" }, -- Mangle (Bear)
	[33987] = { level=68, rank=3, next=48563, class="DRUID" }, -- Mangle (Bear)
	[34026] = { level=66, class="HUNTER" }, -- Kill Command
	[34074] = { level=20, class="HUNTER" }, -- Aspect of the Viper
	[34120] = { level=62, rank=2, next=49051, class="HUNTER" }, -- Steady Shot
	[34411] = { level=50, rank=2, next=34412, class="ROGUE" }, -- Mutilate
	[34412] = { level=60, rank=3, next=34413, class="ROGUE" }, -- Mutilate
	[34413] = { level=70, rank=4, next=48663, class="ROGUE" }, -- Mutilate
	[34428] = { level=6, class="WARRIOR" }, -- Victory Rush
	[34433] = { level=66, class="PRIEST" }, -- Shadowfiend
	[34477] = { level=70, class="HUNTER" }, -- Misdirection
	[34600] = { level=68, class="HUNTER" }, -- Snake Trap
	[34861] = { level=50, rank=1, next=34863, class="PRIEST" }, -- Circle of Healing
	[34863] = { level=56, rank=2, next=34864, class="PRIEST" }, -- Circle of Healing
	[34864] = { level=60, rank=3, next=34865, class="PRIEST" }, -- Circle of Healing
	[34865] = { level=65, rank=4, next=34866, class="PRIEST" }, -- Circle of Healing
	[34866] = { level=70, rank=5, next=48088, class="PRIEST" }, -- Circle of Healing
	[34914] = { level=50, rank=1, next=34916, class="PRIEST" }, -- Vampiric Touch
	[34916] = { level=60, rank=2, next=34917, class="PRIEST" }, -- Vampiric Touch
	[34917] = { level=70, rank=3, next=48159, class="PRIEST" }, -- Vampiric Touch
	[35715] = { level=60, class="MAGE", faction="Horde" }, -- Teleport: Shattrath
	[35717] = { level=65, class="MAGE", faction="Horde" }, -- Portal: Shattrath
	[36916] = { level=70, rank=5, next=53339, class="HUNTER" }, -- Mongoose Bite
	[36936] = { level=30, class="SHAMAN" }, -- Totemic Recall
	[37420] = { level=65, rank=8, next=27090, class="MAGE" }, -- Conjure Water
	[38692] = { level=70, rank=14, next=42832, class="MAGE" }, -- Fireball
	[38697] = { level=70, rank=14, next=42841, class="MAGE" }, -- Frostbolt
	[38699] = { level=69, rank=10, next=38704, class="MAGE" }, -- Arcane Missiles
	[38704] = { level=70, rank=11, next=42843, class="MAGE" }, -- Arcane Missiles
	[39374] = { level=70, rank=2, next=48170, class="PRIEST" }, -- Prayer of Shadow Protection
	[40120] = { level=71, class="DRUID" }, -- Swift Flight Form
	[42650] = { level=80, class="DEATHKNIGHT" }, -- Army of the Dead
	[42832] = { level=74, rank=15, next=42833, class="MAGE" }, -- Fireball
	[42833] = { level=78, rank=16, class="MAGE" }, -- Fireball
	[42841] = { level=75, rank=15, next=42842, class="MAGE" }, -- Frostbolt
	[42842] = { level=79, rank=16, class="MAGE" }, -- Frostbolt
	[42843] = { level=75, rank=12, next=42846, class="MAGE" }, -- Arcane Missiles
	[42846] = { level=79, rank=13, class="MAGE" }, -- Arcane Missiles
	[42858] = { level=73, rank=10, next=42859, class="MAGE" }, -- Scorch
	[42859] = { level=78, rank=11, class="MAGE" }, -- Scorch
	[42872] = { level=74, rank=10, next=42873, class="MAGE" }, -- Fire Blast
	[42873] = { level=80, rank=11, class="MAGE" }, -- Fire Blast
	[42890] = { level=73, rank=11, next=42891, class="MAGE" }, -- Pyroblast
	[42891] = { level=77, rank=12, class="MAGE" }, -- Pyroblast
	[42894] = { level=71, rank=2, next=42896, class="MAGE" }, -- Arcane Blast
	[42896] = { level=76, rank=3, next=42897, class="MAGE" }, -- Arcane Blast
	[42897] = { level=80, rank=4, class="MAGE" }, -- Arcane Blast
	[42913] = { level=72, rank=2, next=42914, class="MAGE" }, -- Ice Lance
	[42914] = { level=78, rank=3, class="MAGE" }, -- Ice Lance
	[42917] = { level=75, rank=6, class="MAGE" }, -- Frost Nova
	[42920] = { level=76, rank=9, next=42921, class="MAGE" }, -- Arcane Explosion
	[42921] = { level=80, rank=10, class="MAGE" }, -- Arcane Explosion
	[42925] = { level=72, rank=8, next=42926, class="MAGE" }, -- Flamestrike
	[42926] = { level=79, rank=9, class="MAGE" }, -- Flamestrike
	[42930] = { level=72, rank=7, next=42931, class="MAGE" }, -- Cone of Cold
	[42931] = { level=79, rank=8, class="MAGE" }, -- Cone of Cold
	[42939] = { level=74, rank=8, next=42940, class="MAGE" }, -- Blizzard
	[42940] = { level=80, rank=9, class="MAGE" }, -- Blizzard
	[42944] = { level=75, rank=8, next=42945, class="MAGE" }, -- Blast Wave
	[42945] = { level=80, rank=9, class="MAGE" }, -- Blast Wave
	[42949] = { level=75, rank=5, next=42950, class="MAGE" }, -- Dragon's Breath
	[42950] = { level=80, rank=6, class="MAGE" }, -- Dragon's Breath
	[42955] = { level=75, rank=1, next=42956, class="MAGE" }, -- Conjure Refreshment
	[42956] = { level=80, rank=2, class="MAGE" }, -- Conjure Refreshment
	[42985] = { level=77, rank=6, class="MAGE" }, -- Conjure Mana Gem
	[42995] = { level=80, rank=7, class="MAGE" }, -- Arcane Intellect
	[43002] = { level=80, rank=3, class="MAGE" }, -- Arcane Brilliance
	[43008] = { level=79, rank=6, class="MAGE" }, -- Ice Armor
	[43010] = { level=78, rank=7, class="MAGE" }, -- Fire Ward
	[43012] = { level=79, rank=7, class="MAGE" }, -- Frost Ward
	[43015] = { level=76, rank=7, class="MAGE" }, -- Dampen Magic
	[43017] = { level=77, rank=7, class="MAGE" }, -- Amplify Magic
	[43019] = { level=73, rank=8, next=43020, class="MAGE" }, -- Mana Shield
	[43020] = { level=79, rank=9, class="MAGE" }, -- Mana Shield
	[43023] = { level=71, rank=5, next=43024, class="MAGE" }, -- Mage Armor
	[43024] = { level=79, rank=6, class="MAGE" }, -- Mage Armor
	[43038] = { level=75, rank=7, next=43039, class="MAGE" }, -- Ice Barrier
	[43039] = { level=80, rank=8, class="MAGE" }, -- Ice Barrier
	[43045] = { level=71, rank=2, next=43046, class="MAGE" }, -- Molten Armor
	[43046] = { level=79, rank=3, class="MAGE" }, -- Molten Armor
	[43265] = { level=60, rank=1, next=49936, class="DEATHKNIGHT" }, -- Death and Decay
	[43987] = { level=70, rank=1, next=58659, class="MAGE" }, -- Ritual of Refreshment
	[44425] = { level=60, rank=1, next=44780, class="MAGE" }, -- Arcane Barrage
	[44457] = { level=60, rank=1, next=55359, class="MAGE" }, -- Living Bomb
	[44614] = { level=75, rank=1, next=47610, class="MAGE" }, -- Frostfire Bolt
	[44780] = { level=70, rank=2, next=44781, class="MAGE" }, -- Arcane Barrage
	[44781] = { level=80, rank=3, class="MAGE" }, -- Arcane Barrage
	[45438] = { level=30, class="MAGE" }, -- Ice Block
	[45462] = { level=55, rank=1, next=49917, class="DEATHKNIGHT" }, -- Plague Strike
	[45463] = { level=70, rank=3, next=49923, class="DEATHKNIGHT" }, -- Death Strike
	[45477] = { level=55, rank=1, next=49896, class="DEATHKNIGHT" }, -- Icy Touch
	[45524] = { level=58, class="DEATHKNIGHT" }, -- Chains of Ice
	[45529] = { level=64, class="DEATHKNIGHT" }, -- Blood Tap
	[45902] = { level=55, rank=1, next=49926, class="DEATHKNIGHT" }, -- Blood Strike
	[46584] = { level=56, class="DEATHKNIGHT" }, -- Raise Dead
	[46845] = { level=71, rank=9, next=47465, class="WARRIOR" }, -- Rend
	[47436] = { level=78, rank=9, class="WARRIOR" }, -- Battle Shout
	[47437] = { level=79, rank=8, class="WARRIOR" }, -- Demoralizing Shout
	[47439] = { level=74, rank=2, next=47440, class="WARRIOR" }, -- Commanding Shout
	[47440] = { level=80, rank=3, class="WARRIOR" }, -- Commanding Shout
	[47449] = { level=72, rank=12, next=47450, class="WARRIOR" }, -- Heroic Strike
	[47450] = { level=76, rank=13, class="WARRIOR" }, -- Heroic Strike
	[47465] = { level=76, rank=10, class="WARRIOR" }, -- Rend
	[47470] = { level=73, rank=8, next=47471, class="WARRIOR" }, -- Execute
	[47471] = { level=80, rank=9, class="WARRIOR" }, -- Execute
	[47474] = { level=74, rank=7, next=47475, class="WARRIOR" }, -- Slam
	[47475] = { level=79, rank=8, class="WARRIOR" }, -- Slam
	[47476] = { level=59, class="DEATHKNIGHT" }, -- Strangulate
	[47485] = { level=75, rank=7, next=47486, class="WARRIOR" }, -- Mortal Strike
	[47486] = { level=80, rank=8, class="WARRIOR" }, -- Mortal Strike
	[47487] = { level=75, rank=7, next=47488, class="WARRIOR" }, -- Shield Slam
	[47488] = { level=80, rank=8, class="WARRIOR" }, -- Shield Slam
	[47497] = { level=75, rank=4, next=47498, class="WARRIOR" }, -- Devastate
	[47498] = { level=80, rank=5, class="WARRIOR" }, -- Devastate
	[47501] = { level=73, rank=8, next=47502, class="WARRIOR" }, -- Thunder Clap
	[47502] = { level=78, rank=9, class="WARRIOR" }, -- Thunder Clap
	[47519] = { level=72, rank=7, next=47520, class="WARRIOR" }, -- Cleave
	[47520] = { level=77, rank=8, class="WARRIOR" }, -- Cleave
	[47528] = { level=57, class="DEATHKNIGHT" }, -- Mind Freeze
	[47540] = { level=60, rank=1, next=53005, class="PRIEST" }, -- Penance
	[47541] = { level=55, rank=1, next=49892, class="DEATHKNIGHT" }, -- Death Coil
	[47568] = { level=75, class="DEATHKNIGHT" }, -- Empower Rune Weapon
	[47610] = { level=80, rank=2, class="MAGE" }, -- Frostfire Bolt
	[47793] = { level=76, rank=7, next=47889, class="WARLOCK" }, -- Demon Armor
	[47808] = { level=74, rank=12, next=47809, class="WARLOCK" }, -- Shadow Bolt
	[47809] = { level=79, rank=13, class="WARLOCK" }, -- Shadow Bolt
	[47810] = { level=75, rank=10, next=47811, class="WARLOCK" }, -- Immolate
	[47811] = { level=80, rank=11, class="WARLOCK" }, -- Immolate
	[47812] = { level=71, rank=9, next=47813, class="WARLOCK" }, -- Corruption
	[47813] = { level=77, rank=10, class="WARLOCK" }, -- Corruption
	[47814] = { level=74, rank=9, next=47815, class="WARLOCK" }, -- Searing Pain
	[47815] = { level=79, rank=10, class="WARLOCK" }, -- Searing Pain
	[47819] = { level=72, rank=6, next=47820, class="WARLOCK" }, -- Rain of Fire
	[47820] = { level=79, rank=7, class="WARLOCK" }, -- Rain of Fire
	[47823] = { level=78, rank=5, class="WARLOCK" }, -- Hellfire
	[47824] = { level=75, rank=5, next=47825, class="WARLOCK" }, -- Soul Fire
	[47825] = { level=80, rank=6, class="WARLOCK" }, -- Soul Fire
	[47826] = { level=75, rank=9, next=47827, class="WARLOCK" }, -- Shadowburn
	[47827] = { level=80, rank=10, class="WARLOCK" }, -- Shadowburn
	[47835] = { level=75, rank=2, next=47836, class="WARLOCK" }, -- Seed of Corruption
	[47836] = { level=80, rank=3, class="WARLOCK" }, -- Seed of Corruption
	[47837] = { level=74, rank=3, next=47838, class="WARLOCK" }, -- Incinerate
	[47838] = { level=80, rank=4, class="WARLOCK" }, -- Incinerate
	[47841] = { level=75, rank=4, next=47843, class="WARLOCK" }, -- Unstable Affliction
	[47843] = { level=80, rank=5, class="WARLOCK" }, -- Unstable Affliction
	[47846] = { level=75, rank=4, next=47847, class="WARLOCK" }, -- Shadowfury
	[47847] = { level=80, rank=5, class="WARLOCK" }, -- Shadowfury
	[47855] = { level=77, rank=6, class="WARLOCK" }, -- Drain Soul
	[47856] = { level=76, rank=9, class="WARLOCK" }, -- Health Funnel
	[47857] = { level=78, rank=9, class="WARLOCK" }, -- Drain Life
	[47859] = { level=73, rank=5, next=47860, class="WARLOCK" }, -- Death Coil
	[47860] = { level=78, rank=6, class="WARLOCK" }, -- Death Coil
	[47863] = { level=73, rank=8, next=47864, class="WARLOCK" }, -- Curse of Agony
	[47864] = { level=79, rank=9, class="WARLOCK" }, -- Curse of Agony
	[47865] = { level=78, rank=5, class="WARLOCK" }, -- Curse of the Elements
	[47867] = { level=80, rank=3, class="WARLOCK" }, -- Curse of Doom
	[47871] = { level=73, rank=7, next=47878, class="WARLOCK" }, -- Create Healthstone
	[47878] = { level=79, rank=8, class="WARLOCK" }, -- Create Healthstone
	[47884] = { level=76, rank=7, class="WARLOCK" }, -- Create Soulstone
	[47886] = { level=72, rank=5, next=47888, class="WARLOCK" }, -- Create Spellstone
	[47888] = { level=78, rank=6, class="WARLOCK" }, -- Create Spellstone
	[47889] = { level=80, rank=8, class="WARLOCK" }, -- Demon Armor
	[47890] = { level=72, rank=5, next=47891, class="WARLOCK" }, -- Shadow Ward
	[47891] = { level=78, rank=6, class="WARLOCK" }, -- Shadow Ward
	[47892] = { level=74, rank=3, next=47893, class="WARLOCK" }, -- Fel Armor
	[47893] = { level=79, rank=4, class="WARLOCK" }, -- Fel Armor
	[47897] = { level=75, rank=1, next=61290, class="WARLOCK" }, -- Shadowflame
	[48018] = { level=80, class="WARLOCK" }, -- Demonic Circle: Summon
	[48020] = { level=80, class="WARLOCK" }, -- Demonic Circle: Teleport
	[48040] = { level=71, rank=8, next=48168, class="PRIEST" }, -- Inner Fire
	[48045] = { level=75, rank=1, next=53023, class="PRIEST" }, -- Mind Sear
	[48062] = { level=73, rank=8, next=48063, class="PRIEST" }, -- Greater Heal
	[48063] = { level=78, rank=9, class="PRIEST" }, -- Greater Heal
	[48065] = { level=75, rank=13, next=48066, class="PRIEST" }, -- Power Word: Shield
	[48066] = { level=80, rank=14, class="PRIEST" }, -- Power Word: Shield
	[48067] = { level=75, rank=13, next=48068, class="PRIEST" }, -- Renew
	[48068] = { level=80, rank=14, class="PRIEST" }, -- Renew
	[48070] = { level=73, rank=10, next=48071, class="PRIEST" }, -- Flash Heal
	[48071] = { level=79, rank=11, class="PRIEST" }, -- Flash Heal
	[48072] = { level=76, rank=7, class="PRIEST" }, -- Prayer of Healing
	[48073] = { level=80, rank=6, class="PRIEST" }, -- Divine Spirit
	[48074] = { level=80, rank=3, class="PRIEST" }, -- Prayer of Spirit
	[48077] = { level=75, rank=8, next=48078, class="PRIEST" }, -- Holy Nova
	[48078] = { level=80, rank=9, class="PRIEST" }, -- Holy Nova
	[48086] = { level=75, rank=5, next=48087, class="PRIEST" }, -- Lightwell
	[48087] = { level=80, rank=6, class="PRIEST" }, -- Lightwell
	[48088] = { level=75, rank=6, next=48089, class="PRIEST" }, -- Circle of Healing
	[48089] = { level=80, rank=7, class="PRIEST" }, -- Circle of Healing
	[48112] = { level=74, rank=2, next=48113, class="PRIEST" }, -- Prayer of Mending
	[48113] = { level=79, rank=3, class="PRIEST" }, -- Prayer of Mending
	[48119] = { level=72, rank=2, next=48120, class="PRIEST" }, -- Binding Heal
	[48120] = { level=78, rank=3, class="PRIEST" }, -- Binding Heal
	[48122] = { level=74, rank=11, next=48123, class="PRIEST" }, -- Smite
	[48123] = { level=79, rank=12, class="PRIEST" }, -- Smite
	[48124] = { level=75, rank=11, next=48125, class="PRIEST" }, -- Shadow Word: Pain
	[48125] = { level=80, rank=12, class="PRIEST" }, -- Shadow Word: Pain
	[48126] = { level=74, rank=12, next=48127, class="PRIEST" }, -- Mind Blast
	[48127] = { level=79, rank=13, class="PRIEST" }, -- Mind Blast
	[48134] = { level=72, rank=10, next=48135, class="PRIEST" }, -- Holy Fire
	[48135] = { level=78, rank=11, class="PRIEST" }, -- Holy Fire
	[48155] = { level=74, rank=8, next=48156, class="PRIEST" }, -- Mind Flay
	[48156] = { level=80, rank=9, class="PRIEST" }, -- Mind Flay
	[48157] = { level=75, rank=3, next=48158, class="PRIEST" }, -- Shadow Word: Death
	[48158] = { level=80, rank=4, class="PRIEST" }, -- Shadow Word: Death
	[48159] = { level=75, rank=4, next=48160, class="PRIEST" }, -- Vampiric Touch
	[48160] = { level=80, rank=5, class="PRIEST" }, -- Vampiric Touch
	[48161] = { level=80, rank=8, class="PRIEST" }, -- Power Word: Fortitude
	[48162] = { level=80, rank=4, class="PRIEST" }, -- Prayer of Fortitude
	[48168] = { level=77, rank=9, class="PRIEST" }, -- Inner Fire
	[48169] = { level=76, rank=5, class="PRIEST" }, -- Shadow Protection
	[48170] = { level=77, rank=3, class="PRIEST" }, -- Prayer of Shadow Protection
	[48171] = { level=78, rank=7, class="PRIEST" }, -- Resurrection
	[48172] = { level=73, rank=8, next=48173, class="PRIEST" }, -- Desperate Prayer
	[48173] = { level=80, rank=9, class="PRIEST" }, -- Desperate Prayer
	[48181] = { level=60, rank=1, next=59161, class="WARLOCK" }, -- Haunt
	[48263] = { level=57, class="DEATHKNIGHT" }, -- Frost Presence
	[48265] = { level=70, class="DEATHKNIGHT" }, -- Unholy Presence
	[48299] = { level=73, rank=8, next=48300, class="PRIEST" }, -- Devouring Plague
	[48300] = { level=79, rank=9, class="PRIEST" }, -- Devouring Plague
	[48377] = { level=74, rank=14, next=48378, class="DRUID" }, -- Healing Touch
	[48378] = { level=79, rank=15, class="DRUID" }, -- Healing Touch
	[48438] = { level=60, rank=1, next=53248, class="DRUID" }, -- Wild Growth
	[48440] = { level=75, rank=14, next=48441, class="DRUID" }, -- Rejuvenation
	[48441] = { level=80, rank=15, class="DRUID" }, -- Rejuvenation
	[48442] = { level=71, rank=11, next=48443, class="DRUID" }, -- Regrowth
	[48443] = { level=77, rank=12, class="DRUID" }, -- Regrowth
	[48446] = { level=75, rank=6, next=48447, class="DRUID" }, -- Tranquility
	[48447] = { level=80, rank=7, class="DRUID" }, -- Tranquility
	[48450] = { level=72, rank=2, next=48451, class="DRUID" }, -- Lifebloom
	[48451] = { level=80, rank=3, class="DRUID" }, -- Lifebloom
	[48459] = { level=74, rank=11, next=48461, class="DRUID" }, -- Wrath
	[48461] = { level=79, rank=12, class="DRUID" }, -- Wrath
	[48462] = { level=75, rank=13, next=48463, class="DRUID" }, -- Moonfire
	[48463] = { level=80, rank=14, class="DRUID" }, -- Moonfire
	[48464] = { level=72, rank=9, next=48465, class="DRUID" }, -- Starfire
	[48465] = { level=78, rank=10, class="DRUID" }, -- Starfire
	[48467] = { level=80, rank=5, class="DRUID" }, -- Hurricane
	[48468] = { level=80, rank=7, class="DRUID" }, -- Insect Swarm
	[48469] = { level=80, rank=9, class="DRUID" }, -- Mark of the Wild
	[48470] = { level=80, rank=4, class="DRUID" }, -- Gift of the Wild
	[48477] = { level=79, rank=7, class="DRUID" }, -- Rebirth
	[48479] = { level=73, rank=9, next=48480, class="DRUID" }, -- Maul
	[48480] = { level=79, rank=10, class="DRUID" }, -- Maul
	[48505] = { level=60, rank=1, next=53199, class="DRUID" }, -- Starfall
	[48559] = { level=71, rank=7, next=48560, class="DRUID" }, -- Demoralizing Roar
	[48560] = { level=77, rank=8, class="DRUID" }, -- Demoralizing Roar
	[48561] = { level=72, rank=7, next=48562, class="DRUID" }, -- Swipe (Bear)
	[48562] = { level=77, rank=8, class="DRUID" }, -- Swipe (Bear)
	[48563] = { level=75, rank=4, next=48564, class="DRUID" }, -- Mangle (Bear)
	[48564] = { level=80, rank=5, class="DRUID" }, -- Mangle (Bear)
	[48565] = { level=75, rank=4, next=48566, class="DRUID" }, -- Mangle (Cat)
	[48566] = { level=80, rank=5, class="DRUID" }, -- Mangle (Cat)
	[48567] = { level=73, rank=2, next=48568, class="DRUID" }, -- Lacerate
	[48568] = { level=80, rank=3, class="DRUID" }, -- Lacerate
	[48569] = { level=73, rank=7, next=48570, class="DRUID" }, -- Claw
	[48570] = { level=79, rank=8, class="DRUID" }, -- Claw
	[48571] = { level=75, rank=8, next=48572, class="DRUID" }, -- Shred
	[48572] = { level=80, rank=9, class="DRUID" }, -- Shred
	[48573] = { level=72, rank=6, next=48574, class="DRUID" }, -- Rake
	[48574] = { level=78, rank=7, class="DRUID" }, -- Rake
	[48575] = { level=76, rank=6, class="DRUID" }, -- Cower
	[48576] = { level=72, rank=7, next=48577, class="DRUID" }, -- Ferocious Bite
	[48577] = { level=78, rank=8, class="DRUID" }, -- Ferocious Bite
	[48578] = { level=73, rank=6, next=48579, class="DRUID" }, -- Ravage
	[48579] = { level=79, rank=7, class="DRUID" }, -- Ravage
	[48637] = { level=76, rank=11, next=48638, class="ROGUE" }, -- Sinister Strike
	[48638] = { level=80, rank=12, class="ROGUE" }, -- Sinister Strike
	[48656] = { level=74, rank=11, next=48657, class="ROGUE" }, -- Backstab
	[48657] = { level=80, rank=12, class="ROGUE" }, -- Backstab
	[48658] = { level=72, rank=7, next=48659, class="ROGUE" }, -- Feint
	[48659] = { level=78, rank=8, class="ROGUE" }, -- Feint
	[48660] = { level=80, rank=5, class="ROGUE" }, -- Hemorrhage
	[48663] = { level=75, rank=5, next=48666, class="ROGUE" }, -- Mutilate
	[48666] = { level=80, rank=6, class="ROGUE" }, -- Mutilate
	[48667] = { level=73, rank=11, next=48668, class="ROGUE" }, -- Eviscerate
	[48668] = { level=79, rank=12, class="ROGUE" }, -- Eviscerate
	[48671] = { level=74, rank=8, next=48672, class="ROGUE" }, -- Rupture
	[48672] = { level=79, rank=9, class="ROGUE" }, -- Rupture
	[48673] = { level=70, rank=2, next=48674, class="ROGUE" }, -- Deadly Throw
	[48674] = { level=76, rank=3, class="ROGUE" }, -- Deadly Throw
	[48675] = { level=75, rank=9, next=48676, class="ROGUE" }, -- Garrote
	[48676] = { level=80, rank=10, class="ROGUE" }, -- Garrote
	[48689] = { level=70, rank=8, next=48690, class="ROGUE" }, -- Ambush
	[48690] = { level=75, rank=9, next=48691, class="ROGUE" }, -- Ambush
	[48691] = { level=80, rank=10, class="ROGUE" }, -- Ambush
	[48707] = { level=68, class="DEATHKNIGHT" }, -- Anti-Magic Shell
	[48721] = { level=58, rank=1, next=49939, class="DEATHKNIGHT" }, -- Blood Boil
	[48743] = { level=66, class="DEATHKNIGHT" }, -- Death Pact
	[27139] = { level=69, rank=3, next=48816, class="PALADIN" }, -- Holy Wrath
	[48816] = { level=72, rank=4, next=48817, class="PALADIN" }, -- Holy Wrath
	[48817] = { level=78, rank=5, class="PALADIN" }, -- Holy Wrath
	[633] = { level=10, rank=1, next=2800, class="PALADIN" }, -- Lay on Hands
	[2800] = { level=30, rank=2, next=10310, class="PALADIN" }, -- Lay on Hands
	[48792] = { level=62, class="DEATHKNIGHT" }, -- Icebound Fortitude
	[10310] = { level=50, rank=3, next=27154, class="PALADIN" }, -- Lay on Hands
	[27154] = { level=69, rank=4, next=48788, class="PALADIN" }, -- Lay on Hands
	[48805] = { level=74, rank=5, next=48806, class="PALADIN" }, -- Hammer of Wrath
	[48806] = { level=80, rank=6, class="PALADIN" }, -- Hammer of Wrath
	[48788] = { level=78, rank=5, class="PALADIN" }, -- Lay on Hands
	[1152] = { level=8, next=4987, class="PALADIN" }, -- Purify
	[7328] = { level=12, rank=1, next=10322, class="PALADIN" }, -- Redemption
	[10322] = { level=24, rank=2, next=10324, class="PALADIN" }, -- Redemption
	[10324] = { level=36, rank=3, next=20772, class="PALADIN" }, -- Redemption
	[20772] = { level=48, rank=4, next=20773, class="PALADIN" }, -- Redemption
	[48826] = { level=75, rank=4, next=48827, class="PALADIN" }, -- Avenger's Shield
	[48827] = { level=80, rank=5, class="PALADIN" }, -- Avenger's Shield
	[48931] = { level=73, rank=9, next=48932, class="PALADIN" }, -- Blessing of Might
	[48932] = { level=79, rank=10, class="PALADIN" }, -- Blessing of Might
	[48933] = { level=73, rank=4, next=48934, class="PALADIN" }, -- Greater Blessing of Might
	[48934] = { level=79, rank=5, class="PALADIN" }, -- Greater Blessing of Might
	[20773] = { level=60, rank=5, next=48949, class="PALADIN" }, -- Redemption
	[48949] = { level=72, rank=6, next=48950, class="PALADIN" }, -- Redemption
	[48950] = { level=79, rank=7, class="PALADIN" }, -- Redemption
	[53601] = { level=80, rank=1, class="PALADIN" }, -- Sacred Shield
	[48941] = { level=74, rank=9, next=48942, class="PALADIN" }, -- Devotion Aura
	[48942] = { level=79, rank=10, class="PALADIN" }, -- Devotion Aura
	[48943] = { level=76, rank=5, class="PALADIN" }, -- Shadow Resistance Aura
	[48945] = { level=77, rank=5, class="PALADIN" }, -- Frost Resistance Aura
	[48947] = { level=78, rank=5, class="PALADIN" }, -- Fire Resistance Aura
	[20165] = { level=30, class="PALADIN" }, -- Seal of Light
	[20166] = { level=38, class="PALADIN" }, -- Seal of Wisdom
	[48951] = { level=75, rank=5, next=48952, class="PALADIN" }, -- Holy Shield
	[48952] = { level=80, rank=6, class="PALADIN" }, -- Holy Shield
	[48989] = { level=74, rank=9, next=48990, class="HUNTER" }, -- Mend Pet
	[48990] = { level=80, rank=10, class="HUNTER" }, -- Mend Pet
	[48995] = { level=71, rank=10, next=48996, class="HUNTER" }, -- Raptor Strike
	[48996] = { level=77, rank=11, class="HUNTER" }, -- Raptor Strike
	[48998] = { level=72, rank=5, next=48999, class="HUNTER" }, -- Counterattack
	[48999] = { level=78, rank=6, class="HUNTER" }, -- Counterattack
	[49000] = { level=73, rank=11, next=49001, class="HUNTER" }, -- Serpent Sting
	[49001] = { level=79, rank=12, class="HUNTER" }, -- Serpent Sting
	[49011] = { level=75, rank=5, next=49012, class="HUNTER" }, -- Wyvern Sting
	[49012] = { level=80, rank=6, class="HUNTER" }, -- Wyvern Sting
	[49020] = { level=61, rank=1, next=51423, class="DEATHKNIGHT" }, -- Obliterate
	[49044] = { level=73, rank=10, next=49045, class="HUNTER" }, -- Arcane Shot
	[49045] = { level=79, rank=11, class="HUNTER" }, -- Arcane Shot
	[49047] = { level=74, rank=7, next=49048, class="HUNTER" }, -- Multi-Shot
	[49048] = { level=80, rank=8, class="HUNTER" }, -- Multi-Shot
	[49049] = { level=75, rank=8, next=49050, class="HUNTER" }, -- Aimed Shot
	[49050] = { level=80, rank=9, class="HUNTER" }, -- Aimed Shot
	[49051] = { level=71, rank=3, next=49052, class="HUNTER" }, -- Steady Shot
	[49052] = { level=77, rank=4, class="HUNTER" }, -- Steady Shot
	[49055] = { level=72, rank=7, next=49056, class="HUNTER" }, -- Immolation Trap
	[49056] = { level=78, rank=8, class="HUNTER" }, -- Immolation Trap
	[49066] = { level=71, rank=5, next=49067, class="HUNTER" }, -- Explosive Trap
	[49067] = { level=77, rank=6, class="HUNTER" }, -- Explosive Trap
	[49071] = { level=76, rank=4, class="HUNTER" }, -- Aspect of the Wild
	[49143] = { level=50, rank=1, next=51416, class="DEATHKNIGHT" }, -- Frost Strike
	[49158] = { level=20, rank=1, next=51325, class="DEATHKNIGHT" }, -- Corpse Explosion
	[49184] = { level=60, rank=1, next=51409, class="DEATHKNIGHT" }, -- Howling Blast
	[49230] = { level=74, rank=9, next=49231, class="SHAMAN" }, -- Earth Shock
	[49231] = { level=79, rank=10, class="SHAMAN" }, -- Earth Shock
	[49232] = { level=75, rank=8, next=49233, class="SHAMAN" }, -- Flame Shock
	[49233] = { level=80, rank=9, class="SHAMAN" }, -- Flame Shock
	[49235] = { level=73, rank=6, next=49236, class="SHAMAN" }, -- Frost Shock
	[49236] = { level=78, rank=7, class="SHAMAN" }, -- Frost Shock
	[49237] = { level=73, rank=13, next=49238, class="SHAMAN" }, -- Lightning Bolt
	[49238] = { level=79, rank=14, class="SHAMAN" }, -- Lightning Bolt
	[49270] = { level=74, rank=7, next=49271, class="SHAMAN" }, -- Chain Lightning
	[49271] = { level=80, rank=8, class="SHAMAN" }, -- Chain Lightning
	[49272] = { level=75, rank=13, next=49273, class="SHAMAN" }, -- Healing Wave
	[49273] = { level=80, rank=14, class="SHAMAN" }, -- Healing Wave
	[49275] = { level=72, rank=8, next=49276, class="SHAMAN" }, -- Lesser Healing Wave
	[49276] = { level=77, rank=9, class="SHAMAN" }, -- Lesser Healing Wave
	[49277] = { level=80, rank=7, class="SHAMAN" }, -- Ancestral Spirit
	[49280] = { level=75, rank=10, next=49281, class="SHAMAN" }, -- Lightning Shield
	[49281] = { level=80, rank=11, class="SHAMAN" }, -- Lightning Shield
	[49283] = { level=75, rank=4, next=49284, class="SHAMAN" }, -- Earth Shield
	[49284] = { level=80, rank=5, class="SHAMAN" }, -- Earth Shield
	[49358] = { level=35, class="MAGE", faction="Horde" }, -- Teleport: Stonard
	[49359] = { level=35, class="MAGE", faction="Alliance" }, -- Teleport: Theramore
	[49360] = { level=35, class="MAGE", faction="Alliance" }, -- Portal: Theramore
	[49361] = { level=35, class="MAGE", faction="Horde" }, -- Portal: Stonard
	[49376] = { level=30, class="DRUID" }, -- Feral Charge - Cat
	[49799] = { level=71, rank=8, next=49800, class="DRUID" }, -- Rip
	[49800] = { level=80, rank=9, class="DRUID" }, -- Rip
	[49802] = { level=74, rank=2, class="DRUID" }, -- Maim
	[49803] = { level=77, rank=5, class="DRUID" }, -- Pounce
	[49892] = { level=62, rank=2, next=49893, class="DEATHKNIGHT" }, -- Death Coil
	[49893] = { level=68, rank=3, next=49894, class="DEATHKNIGHT" }, -- Death Coil
	[49894] = { level=76, rank=4, next=49895, class="DEATHKNIGHT" }, -- Death Coil
	[49895] = { level=80, rank=5, class="DEATHKNIGHT" }, -- Death Coil
	[49896] = { level=61, rank=2, next=49903, class="DEATHKNIGHT" }, -- Icy Touch
	[49903] = { level=67, rank=3, next=49904, class="DEATHKNIGHT" }, -- Icy Touch
	[49904] = { level=73, rank=4, next=49909, class="DEATHKNIGHT" }, -- Icy Touch
	[49909] = { level=78, rank=5, class="DEATHKNIGHT" }, -- Icy Touch
	[49917] = { level=60, rank=2, next=49918, class="DEATHKNIGHT" }, -- Plague Strike
	[49918] = { level=65, rank=3, next=49919, class="DEATHKNIGHT" }, -- Plague Strike
	[49919] = { level=70, rank=4, next=49920, class="DEATHKNIGHT" }, -- Plague Strike
	[49920] = { level=75, rank=5, next=49921, class="DEATHKNIGHT" }, -- Plague Strike
	[49921] = { level=80, rank=6, class="DEATHKNIGHT" }, -- Plague Strike
	[49923] = { level=75, rank=4, next=49924, class="DEATHKNIGHT" }, -- Death Strike
	[49924] = { level=80, rank=5, class="DEATHKNIGHT" }, -- Death Strike
	[49926] = { level=59, rank=2, next=49927, class="DEATHKNIGHT" }, -- Blood Strike
	[49927] = { level=64, rank=3, next=49928, class="DEATHKNIGHT" }, -- Blood Strike
	[49928] = { level=69, rank=4, next=49929, class="DEATHKNIGHT" }, -- Blood Strike
	[49929] = { level=74, rank=5, next=49930, class="DEATHKNIGHT" }, -- Blood Strike
	[49930] = { level=80, rank=6, class="DEATHKNIGHT" }, -- Blood Strike
	[49936] = { level=67, rank=2, next=49937, class="DEATHKNIGHT" }, -- Death and Decay
	[49937] = { level=73, rank=3, next=49938, class="DEATHKNIGHT" }, -- Death and Decay
	[49938] = { level=80, rank=4, class="DEATHKNIGHT" }, -- Death and Decay
	[49939] = { level=66, rank=2, next=49940, class="DEATHKNIGHT" }, -- Blood Boil
	[49940] = { level=72, rank=3, next=49941, class="DEATHKNIGHT" }, -- Blood Boil
	[49941] = { level=78, rank=4, class="DEATHKNIGHT" }, -- Blood Boil
	[49998] = { level=56, rank=1, next=49999, class="DEATHKNIGHT" }, -- Death Strike
	[49999] = { level=63, rank=2, next=45463, class="DEATHKNIGHT" }, -- Death Strike
	[50212] = { level=71, rank=5, next=50213, class="DRUID" }, -- Tiger's Fury
	[50213] = { level=79, rank=6, class="DRUID" }, -- Tiger's Fury
	[50464] = { level=80, rank=1, class="DRUID" }, -- Nourish
	[50511] = { level=71, rank=9, class="WARLOCK" }, -- Curse of Weakness
	[50516] = { level=50, rank=1, next=53223, class="DRUID" }, -- Typhoon
	[50581] = { level=60, class="WARLOCK" }, -- Shadow Cleave
	[50589] = { level=60, class="WARLOCK" }, -- Immolation Aura
	[50763] = { level=80, rank=7, class="DRUID" }, -- Revive
	[50764] = { level=69, rank=6, next=50763, class="DRUID" }, -- Revive
	[50765] = { level=60, rank=5, next=50764, class="DRUID" }, -- Revive
	[50766] = { level=48, rank=4, next=50765, class="DRUID" }, -- Revive
	[50767] = { level=36, rank=3, next=50766, class="DRUID" }, -- Revive
	[50768] = { level=24, rank=2, next=50767, class="DRUID" }, -- Revive
	[50769] = { level=12, rank=1, next=50768, class="DRUID" }, -- Revive
	[50796] = { level=60, rank=1, next=59170, class="WARLOCK" }, -- Chaos Bolt
	[50842] = { level=56, class="DEATHKNIGHT" }, -- Pestilence
	[51325] = { level=60, rank=2, next=51326, class="DEATHKNIGHT" }, -- Corpse Explosion
	[51326] = { level=70, rank=3, next=51327, class="DEATHKNIGHT" }, -- Corpse Explosion
	[51327] = { level=75, rank=4, next=51328, class="DEATHKNIGHT" }, -- Corpse Explosion
	[51328] = { level=80, rank=5, class="DEATHKNIGHT" }, -- Corpse Explosion
	[51409] = { level=70, rank=2, next=51410, class="DEATHKNIGHT" }, -- Howling Blast
	[51410] = { level=75, rank=3, next=51411, class="DEATHKNIGHT" }, -- Howling Blast
	[51411] = { level=80, rank=4, class="DEATHKNIGHT" }, -- Howling Blast
	[51416] = { level=60, rank=2, next=51417, class="DEATHKNIGHT" }, -- Frost Strike
	[51417] = { level=65, rank=3, next=51418, class="DEATHKNIGHT" }, -- Frost Strike
	[51418] = { level=70, rank=4, next=51419, class="DEATHKNIGHT" }, -- Frost Strike
	[51419] = { level=75, rank=5, next=55268, class="DEATHKNIGHT" }, -- Frost Strike
	[51423] = { level=67, rank=2, next=51424, class="DEATHKNIGHT" }, -- Obliterate
	[51424] = { level=73, rank=3, next=51425, class="DEATHKNIGHT" }, -- Obliterate
	[51425] = { level=79, rank=4, class="DEATHKNIGHT" }, -- Obliterate
	[51490] = { level=60, rank=1, next=59156, class="SHAMAN" }, -- Thunderstorm
	[51505] = { level=75, rank=1, next=60043, class="SHAMAN" }, -- Lava Burst
	[51514] = { level=80, class="SHAMAN" }, -- Hex
	[51722] = { level=20, class="ROGUE" }, -- Dismantle
	[51723] = { level=80, class="ROGUE" }, -- Fan of Knives
	[51724] = { level=71, rank=4, class="ROGUE" }, -- Sap
	[51730] = { level=30, rank=1, next=51988, class="SHAMAN" }, -- Earthliving Weapon
	[51988] = { level=40, rank=2, next=51991, class="SHAMAN" }, -- Earthliving Weapon
	[51991] = { level=50, rank=3, next=51992, class="SHAMAN" }, -- Earthliving Weapon
	[51992] = { level=60, rank=4, next=51993, class="SHAMAN" }, -- Earthliving Weapon
	[51993] = { level=70, rank=5, next=51994, class="SHAMAN" }, -- Earthliving Weapon
	[51994] = { level=80, rank=6, class="SHAMAN" }, -- Earthliving Weapon
	[52127] = { level=20, rank=1, next=52129, class="SHAMAN" }, -- Water Shield
	[52129] = { level=28, rank=2, next=52131, class="SHAMAN" }, -- Water Shield
	[52131] = { level=34, rank=3, next=52134, class="SHAMAN" }, -- Water Shield
	[52134] = { level=41, rank=4, next=52136, class="SHAMAN" }, -- Water Shield
	[52136] = { level=48, rank=5, next=52138, class="SHAMAN" }, -- Water Shield
	[52138] = { level=55, rank=6, next=24398, class="SHAMAN" }, -- Water Shield
	[52610] = { level=75, rank=1, class="DRUID" }, -- Savage Roar
	[53005] = { level=70, rank=2, next=53006, class="PRIEST" }, -- Penance
	[53006] = { level=75, rank=3, next=53007, class="PRIEST" }, -- Penance
	[53007] = { level=80, rank=4, class="PRIEST" }, -- Penance
	[53023] = { level=80, rank=2, class="PRIEST" }, -- Mind Sear
	[53140] = { level=71, class="MAGE" }, -- Teleport: Dalaran
	[53142] = { level=74, class="MAGE" }, -- Portal: Dalaran
	[53199] = { level=70, rank=2, next=53200, class="DRUID" }, -- Starfall
	[53200] = { level=75, rank=3, next=53201, class="DRUID" }, -- Starfall
	[53201] = { level=80, rank=4, class="DRUID" }, -- Starfall
	[53223] = { level=60, rank=2, next=53225, class="DRUID" }, -- Typhoon
	[53225] = { level=70, rank=3, next=53226, class="DRUID" }, -- Typhoon
	[53226] = { level=75, rank=4, next=61384, class="DRUID" }, -- Typhoon
	[53248] = { level=70, rank=2, next=53249, class="DRUID" }, -- Wild Growth
	[53249] = { level=75, rank=3, next=53251, class="DRUID" }, -- Wild Growth
	[53251] = { level=80, rank=4, class="DRUID" }, -- Wild Growth
	[53271] = { level=75, class="HUNTER" }, -- Master's Call
	[53301] = { level=60, rank=1, next=60051, class="HUNTER" }, -- Explosive Shot
	[53307] = { level=74, rank=8, class="DRUID" }, -- Thorns
	[53308] = { level=78, rank=8, class="DRUID" }, -- Entangling Roots
	[53312] = { level=78, rank=8, class="DRUID" }, -- Nature's Grasp
	[53338] = { level=76, rank=5, class="HUNTER" }, -- Hunter's Mark
	[53339] = { level=80, rank=6, class="HUNTER" }, -- Mongoose Bite
	[53351] = { level=71, rank=1, next=61005, class="HUNTER" }, -- Kill Shot
	[53407] = { level=28, class="PALADIN" }, -- Judgement of Justice
	[53408] = { level=12, class="PALADIN" }, -- Judgement of Wisdom
	[53600] = { level=75, rank=1, next=61411, class="PALADIN" }, -- Shield of Righteousness
	[5502] = { level=20, class="PALADIN" }, -- Sense Undead
	[53736] = { level=66, class="PALADIN", faction="Horde" }, -- Seal of Corruption
	[54043] = { level=76, rank=7, class="PALADIN" }, -- Retribution Aura
	[10326] = { level=24, class="PALADIN" }, -- Turn Evil
	[54785] = { level=60, class="WARLOCK" }, -- Demon Charge
	[55050] = { level=50, rank=1, next=55258, class="DEATHKNIGHT" }, -- Heart Strike
	[55090] = { level=50, rank=1, next=55265, class="DEATHKNIGHT" }, -- Scourge Strike
	[55258] = { level=59, rank=2, next=55259, class="DEATHKNIGHT" }, -- Heart Strike
	[55259] = { level=64, rank=3, next=55260, class="DEATHKNIGHT" }, -- Heart Strike
	[55260] = { level=69, rank=4, next=55261, class="DEATHKNIGHT" }, -- Heart Strike
	[55261] = { level=74, rank=5, next=55262, class="DEATHKNIGHT" }, -- Heart Strike
	[55262] = { level=80, rank=6, class="DEATHKNIGHT" }, -- Heart Strike
	[55265] = { level=67, rank=2, next=55270, class="DEATHKNIGHT" }, -- Scourge Strike
	[55268] = { level=80, rank=6, class="DEATHKNIGHT" }, -- Frost Strike
	[55270] = { level=73, rank=3, next=55271, class="DEATHKNIGHT" }, -- Scourge Strike
	[55271] = { level=79, rank=4, class="DEATHKNIGHT" }, -- Scourge Strike
	[55342] = { level=80, class="MAGE" }, -- Mirror Image
	[55359] = { level=70, rank=2, next=55360, class="MAGE" }, -- Living Bomb
	[55360] = { level=80, rank=3, class="MAGE" }, -- Living Bomb
	[55458] = { level=74, rank=6, next=55459, class="SHAMAN" }, -- Chain Heal
	[55459] = { level=80, rank=7, class="SHAMAN" }, -- Chain Heal
	[55694] = { level=75, class="WARRIOR" }, -- Enraged Regeneration
	[56222] = { level=65, class="DEATHKNIGHT" }, -- Dark Command
	[56641] = { level=50, rank=1, next=34120, class="HUNTER" }, -- Steady Shot
	[56815] = { level=67, class="DEATHKNIGHT" }, -- Rune Strike
	[57330] = { level=65, rank=1, next=57623, class="DEATHKNIGHT" }, -- Horn of Winter
	[57622] = { level=75, rank=7, next=58643, class="SHAMAN" }, -- Strength of Earth Totem
	[57623] = { level=75, rank=2, class="DEATHKNIGHT" }, -- Horn of Winter
	[57720] = { level=60, rank=2, next=57721, class="SHAMAN" }, -- Totem of Wrath
	[57721] = { level=70, rank=3, next=57722, class="SHAMAN" }, -- Totem of Wrath
	[57722] = { level=80, rank=4, class="SHAMAN" }, -- Totem of Wrath
	[57755] = { level=80, class="WARRIOR" }, -- Heroic Throw
	[57823] = { level=80, rank=9, class="WARRIOR" }, -- Revenge
	[57934] = { level=75, class="ROGUE" }, -- Tricks of the Trade
	[57946] = { level=80, rank=8, class="WARLOCK" }, -- Life Tap
	[57960] = { level=76, rank=9, class="SHAMAN" }, -- Water Shield
	[57964] = { level=73, rank=8, next=57965, class="ROGUE" }, -- Instant Poison VIII
	[57965] = { level=79, rank=9, class="ROGUE" }, -- Instant Poison IX
	[57967] = { level=73, rank=8, next=57968, class="ROGUE" }, -- Instant Poison VIII
	[57968] = { level=79, rank=9, class="ROGUE" }, -- Instant Poison IX
	[57969] = { level=76, rank=8, next=57970, class="ROGUE" }, -- Deadly Poison VIII
	[57970] = { level=80, rank=9, class="ROGUE" }, -- Deadly Poison IX
	[57972] = { level=76, rank=8, next=57973, class="ROGUE" }, -- Deadly Poison VIII
	[57973] = { level=80, rank=9, class="ROGUE" }, -- Deadly Poison IX
	[57974] = { level=72, rank=6, next=57975, class="ROGUE" }, -- Wound Poison VI
	[57975] = { level=78, rank=7, class="ROGUE" }, -- Wound Poison VII
	[57977] = { level=72, rank=6, next=57978, class="ROGUE" }, -- Wound Poison VI
	[57978] = { level=78, rank=7, class="ROGUE" }, -- Wound Poison VII
	[57981] = { level=77, rank=2, class="ROGUE" }, -- Anesthetic Poison II
	[57982] = { level=77, rank=2, class="ROGUE" }, -- Anesthetic Poison II
	[57992] = { level=74, rank=3, next=57993, class="ROGUE" }, -- Envenom
	[57993] = { level=80, rank=4, class="ROGUE" }, -- Envenom
	[57994] = { level=16, class="SHAMAN" }, -- Wind Shear
	[58431] = { level=74, rank=5, next=58434, class="HUNTER" }, -- Volley
	[58434] = { level=80, rank=6, class="HUNTER" }, -- Volley
	[58580] = { level=71, rank=8, next=58581, class="SHAMAN" }, -- Stoneclaw Totem
	[58581] = { level=75, rank=9, next=58582, class="SHAMAN" }, -- Stoneclaw Totem
	[58582] = { level=78, rank=10, class="SHAMAN" }, -- Stoneclaw Totem
	[58643] = { level=80, rank=8, class="SHAMAN" }, -- Strength of Earth Totem
	[58649] = { level=71, rank=6, next=58652, class="SHAMAN" }, -- Flametongue Totem
	[58652] = { level=75, rank=7, next=58656, class="SHAMAN" }, -- Flametongue Totem
	[58656] = { level=80, rank=8, class="SHAMAN" }, -- Flametongue Totem
	[58659] = { level=80, rank=2, class="MAGE" }, -- Ritual of Refreshment
	[58699] = { level=71, rank=8, next=58703, class="SHAMAN" }, -- Searing Totem
	[58703] = { level=75, rank=9, next=58704, class="SHAMAN" }, -- Searing Totem
	[58704] = { level=80, rank=10, class="SHAMAN" }, -- Searing Totem
	[58731] = { level=73, rank=6, next=58734, class="SHAMAN" }, -- Magma Totem
	[58734] = { level=78, rank=7, class="SHAMAN" }, -- Magma Totem
	[58737] = { level=75, rank=5, next=58739, class="SHAMAN" }, -- Fire Resistance Totem
	[58739] = { level=80, rank=6, class="SHAMAN" }, -- Fire Resistance Totem
	[58741] = { level=75, rank=5, next=58745, class="SHAMAN" }, -- Frost Resistance Totem
	[58745] = { level=80, rank=6, class="SHAMAN" }, -- Frost Resistance Totem
	[58746] = { level=75, rank=5, next=58749, class="SHAMAN" }, -- Nature Resistance Totem
	[58749] = { level=80, rank=6, class="SHAMAN" }, -- Nature Resistance Totem
	[58751] = { level=73, rank=9, next=58753, class="SHAMAN" }, -- Stoneskin Totem
	[58753] = { level=78, rank=10, class="SHAMAN" }, -- Stoneskin Totem
	[58755] = { level=71, rank=7, next=58756, class="SHAMAN" }, -- Healing Stream Totem
	[58756] = { level=76, rank=8, next=58757, class="SHAMAN" }, -- Healing Stream Totem
	[58757] = { level=80, rank=9, class="SHAMAN" }, -- Healing Stream Totem
	[58771] = { level=71, rank=6, next=58773, class="SHAMAN" }, -- Mana Spring Totem
	[58773] = { level=76, rank=7, next=58774, class="SHAMAN" }, -- Mana Spring Totem
	[58774] = { level=80, rank=8, class="SHAMAN" }, -- Mana Spring Totem
	[58785] = { level=71, rank=8, next=58789, class="SHAMAN" }, -- Flametongue Weapon
	[58789] = { level=76, rank=9, next=58790, class="SHAMAN" }, -- Flametongue Weapon
	[58790] = { level=80, rank=10, class="SHAMAN" }, -- Flametongue Weapon
	[58794] = { level=71, rank=7, next=58795, class="SHAMAN" }, -- Frostbrand Weapon
	[58795] = { level=76, rank=8, next=58796, class="SHAMAN" }, -- Frostbrand Weapon
	[58796] = { level=80, rank=9, class="SHAMAN" }, -- Frostbrand Weapon
	[58801] = { level=71, rank=6, next=58803, class="SHAMAN" }, -- Windfury Weapon
	[58803] = { level=76, rank=7, next=58804, class="SHAMAN" }, -- Windfury Weapon
	[58804] = { level=80, rank=8, class="SHAMAN" }, -- Windfury Weapon
	[58887] = { level=80, rank=2, class="WARLOCK" }, -- Ritual of Souls
	[59092] = { level=80, rank=5, class="WARLOCK" }, -- Dark Pact
	[59156] = { level=70, rank=2, next=59158, class="SHAMAN" }, -- Thunderstorm
	[59158] = { level=75, rank=3, next=59159, class="SHAMAN" }, -- Thunderstorm
	[59159] = { level=80, rank=4, class="SHAMAN" }, -- Thunderstorm
	[59161] = { level=70, rank=2, next=59163, class="WARLOCK" }, -- Haunt
	[59163] = { level=75, rank=3, next=59164, class="WARLOCK" }, -- Haunt
	[59164] = { level=80, rank=4, class="WARLOCK" }, -- Haunt
	[59170] = { level=70, rank=2, next=59171, class="WARLOCK" }, -- Chaos Bolt
	[59171] = { level=75, rank=3, next=59172, class="WARLOCK" }, -- Chaos Bolt
	[59172] = { level=80, rank=4, class="WARLOCK" }, -- Chaos Bolt
	[60043] = { level=80, rank=2, class="SHAMAN" }, -- Lava Burst
	[60051] = { level=70, rank=2, next=60052, class="HUNTER" }, -- Explosive Shot
	[60052] = { level=75, rank=3, next=60053, class="HUNTER" }, -- Explosive Shot
	[60053] = { level=80, rank=4, class="HUNTER" }, -- Explosive Shot
	[60192] = { level=80, rank=1, class="HUNTER" }, -- Freezing Arrow
	[60219] = { level=74, rank=6, next=60220, class="WARLOCK" }, -- Create Firestone
	[60220] = { level=80, rank=7, class="WARLOCK" }, -- Create Firestone
	[61005] = { level=75, rank=2, next=61006, class="HUNTER" }, -- Kill Shot
	[61006] = { level=80, rank=3, class="HUNTER" }, -- Kill Shot
	[61024] = { level=80, rank=7, class="MAGE" }, -- Dalaran Intellect
	[61191] = { level=72, rank=4, class="WARLOCK" }, -- Enslave Demon
	[61290] = { level=80, rank=2, class="WARLOCK" }, -- Shadowflame
	[61295] = { level=60, rank=1, next=61299, class="SHAMAN" }, -- Riptide
	[61299] = { level=70, rank=2, next=61300, class="SHAMAN" }, -- Riptide
	[61300] = { level=75, rank=3, next=61301, class="SHAMAN" }, -- Riptide
	[61301] = { level=80, rank=4, class="SHAMAN" }, -- Riptide
	[61305] = { level=60, class="MAGE" }, -- Polymorph: Black Cat
	[61316] = { level=80, rank=3, class="MAGE" }, -- Dalaran Brilliance
	[61384] = { level=80, rank=5, class="DRUID" }, -- Typhoon
	[61411] = { level=80, rank=2, class="PALADIN" }, -- Shield of Righteousness
	[61649] = { level=75, rank=8, next=61657, class="SHAMAN" }, -- Fire Nova
	[61657] = { level=80, rank=9, class="SHAMAN" }, -- Fire Nova
	[61721] = { level=60, class="MAGE" }, -- Polymorph: Rabbit
	[61780] = { level=60, class="MAGE" }, -- Polymorph: Turkey
	[61846] = { level=74, rank=1, next=61847, class="HUNTER" }, -- Aspect of the Dragonhawk
	[61847] = { level=80, rank=2, class="HUNTER" }, -- Aspect of the Dragonhawk
	[61999] = { level=72, class="DEATHKNIGHT" }, -- Raise Ally
	[62078] = { level=71, rank=1, class="DRUID" }, -- Swipe (Cat)
	[62124] = { level=16, class="PALADIN" }, -- Hand of Reckoning
	[62600] = { level=40, class="DRUID" }, -- Savage Defense
	[62757] = { level=80, class="HUNTER" }, -- Call Stabled Pet
	[63668] = { level=57, rank=2, next=63669, class="HUNTER" }, -- Black Arrow
	[63669] = { level=63, rank=3, next=63670, class="HUNTER" }, -- Black Arrow
	[63670] = { level=69, rank=4, next=63671, class="HUNTER" }, -- Black Arrow
	[63671] = { level=75, rank=5, next=63672, class="HUNTER" }, -- Black Arrow
	[63672] = { level=80, rank=6, class="HUNTER" }, -- Black Arrow
	[64382] = { level=71, class="WARRIOR" }, -- Shattering Throw
	[64843] = { level=80, rank=1, class="PRIEST" }, -- Divine Hymn
	[64901] = { level=80, class="PRIEST" }, -- Hymn of Hope
	[66842] = { level=30, class="SHAMAN" }, -- Call of the Elements
	[66843] = { level=40, class="SHAMAN" }, -- Call of the Ancestors
	[66844] = { level=50, class="SHAMAN" }, -- Call of the Spirits
}

FatCooldowns.TalentAndGlyphInfo = {
	["DEATHKNIGHT"] = {
		[GetSpellInfo(48263)] = {									-- Frost Presence
			improved = GetSpellInfo(50384),							-- Improved Frost Presence
			maxTalentPoints = 2,
		},
		[GetSpellInfo(48266)] = {									-- Blood Presence
			improved = GetSpellInfo(50365),							-- Improved Blood Presence
			maxTalentPoints = 2,
		},
		[GetSpellInfo(55972)] = {									-- Abomination's Might
			improved = GetSpellInfo(53138),							-- Abomination's Might
			maxTalentPoints = 2,
		},
		[GetSpellInfo(55095)] = {									-- Frost Fever
			improved = GetSpellInfo(51456),							-- Improved Icy Touch
			maxTalentPoints = 3,
		},
	},
	["DRUID"] = {
		[GetSpellInfo(48396)] = {									-- Improved Moonkin Form
			improved = GetSpellInfo(48396),							-- Ferocious Inspiration
			maxTalentPoints = 3,
		},
		[GetSpellInfo(48560)] = {									-- Demoralizing Roar
			improved = GetSpellInfo(16862),							-- Feral Aggression
			maxTalentPoints = 5,
			ranksIDs = {99, 1735, 9490, 9747, 9898, 26998, 48559, 48560},
		},
		[GetSpellInfo(48468)] = {									-- Insect Swarm
			glyphImproved = {GetSpellInfo(54830),GetSpellInfo(54830)},	-- Glyphd for Insect Swarm
		},
		[GetSpellInfo(770)] = {										-- Faerie Fire
			improved = GetSpellInfo(33602),							-- Improved Faerie Fire
			maxTalentPoints = 3,
		},
	},
	["HUNTER"] = {
		[GetSpellInfo(34460)] = {									-- Ferocious Inspiration
			improved = GetSpellInfo(34460),							-- Ferocious Inspiration
			maxTalentPoints = 3,
		},
	},
	["MAGE"] = {
		[GetSpellInfo(168)] = {										-- Frost Armor
			improved = GetSpellInfo(11189),							-- Frost Warding
			maxTalentPoints = 2,
		},
		[GetSpellInfo(7302)] = {									-- Ice Armor
			improved = GetSpellInfo(11189),							-- Frost Warding
			maxTalentPoints = 2,
		},
		[GetSpellInfo(1008)] = {									-- Amplify Magic
			improved = GetSpellInfo(11247),							-- Magic Attunement
			maxTalentPoints = 2,
		},
		[GetSpellInfo(604)] = {										-- Dampen Magic
			improved = GetSpellInfo(11247),							-- Magic Attunement
			maxTalentPoints = 2,
		},
		[GetSpellInfo(31583)] = {									-- Arcane Empowerment
			improved = GetSpellInfo(31583),							-- Arcane Empowerment
			maxTalentPoints = 3,
		},
		[GetSpellInfo(12873)] = {									-- Improved Scorch
			maxTalentPoints = 5,
			improved = GetSpellInfo(12873),							-- Improved Scorch
		},
		[GetSpellInfo(28593)] = {									-- Winter's Chill
			maxTalentPoints = 3,
			improved = GetSpellInfo(28593),							-- Winter's Chill
		},
	},
	["PALADIN"] = {
		[GetSpellInfo(48932)] = {									-- Blessing of Might
			rankIDs = {19740, 19834, 19835, 19836, 19837, 19838, 25291, 27140, 48931, 48932},
			maxTalentPoints = 2,
			improved = GetSpellInfo(20045),							-- Improved Blessing of Might
		},
		[GetSpellInfo(31869)] = {									-- Sanctified Retribution
			improved = GetSpellInfo(31869),							-- Sanctified Retribution
			maxTalentPoints = 3,
		},
		[GetSpellInfo(26017)] = {									-- Vindication
			rankIDs = {26017,67},
			improved = GetSpellInfo(26017),							-- Vindication
			maxTalentPoints = 2,
		},
	},
	["PRIEST"] = {
		[GetSpellInfo(17)] = {										-- Power Word: Shield
			improved = GetSpellInfo(14748),							-- Improved Power Word: Shield
			maxTalentPoints = 3,
		},
		[GetSpellInfo(25431)] = {									-- Inner Fire
			improved = GetSpellInfo(14747),							-- Improved Inner Fire
			maxTalentPoints = 3,
		},
		[GetSpellInfo(15363)] = {									-- Inspiration
			improved = GetSpellInfo(15363),							-- Inspiration
			maxTalentPoints = 3,
		},
	},
	["ROGUE"] = {
		[GetSpellInfo(57934)] = {									-- Tricks of the Trade
			glyphImproved = GetSpellInfo(63898),					-- Glyph of Tricks of the Trade
		},
		[GetSpellInfo(51662)] = {									-- Hunger For Blood
			glyphImproved = 63249,									-- Glyph of Hunger For Blood
		},
	},
	["SHAMAN"] = {
		[GetSpellInfo(325)] = {										-- Lightning Shield
			improved = GetSpellInfo(16261),							-- Improved Shields
			glyphImproved = GetSpellInfo(55553),
			maxTalentPoints = 3,
		},
		[GetSpellInfo(52127)] = {									-- Water Shield
			improved = GetSpellInfo(16261),							-- Improved Shields
			maxTalentPoints = 3,
		},
		[GetSpellInfo(49284)] = {									-- Earth Shield
			improved = GetSpellInfo(16261),							-- Improved Shields
			maxTalentPoints = 3,
		},
		[GetSpellInfo(8512)] = {									-- Windfury Totem
			improved = GetSpellInfo(29193),							-- Improved Windfury Totem
			maxTalentPoints = 2,
		},
		[GetSpellInfo(58754)] = {									-- Stoneskin
			improved = GetSpellInfo(16258),
			maxTalentPoints = 2,
		},
		[GetSpellInfo(58753)] = {									-- Stoneskin Totem
			improved = GetSpellInfo(16258),
			maxTalentPoints = 2,
		},
		[GetSpellInfo(30809)] = {									-- Unleashed Rage
			improved = GetSpellInfo(30809),							-- Unleashed Rage
			maxTalentPoints = 3,
		},
		[GetSpellInfo(51470)] = {		
			improved = GetSpellInfo(51470),							-- Elemental Oath
			maxTalentPoints = 2,
		},
		[GetSpellInfo(16177)] = {									-- Ancestral Fortitude
			improved = GetSpellInfo(16176),							-- Ancestral Healing
			maxTalentPoints = 3,
		},
		[GetSpellInfo(58646)] = {									-- Strength of Earth
			improved = GetSpellInfo(52456),							-- Enhancing Totems
			maxTalentPoints = 3,
			rankIDs = {8075, 8160, 8161, 10442, 25361, 25528, 57622, 58643},
		},
	},
	["WARLOCK"] = {
		[GetSpellInfo(47240)] = {									-- Demonic Pact
			improved = GetSpellInfo(47240),							-- Demonic Pact
			maxTalentPoints = 5,
		},
	},
	["WARRIOR"] = {
		[GetSpellInfo(47436)] = {									-- Battle Shout
			maxTalentPoints = 5,
			improved = GetSpellInfo(12861),							-- Commanding Presence
			rankIDs = {6673, 5242, 6192, 11549, 11550, 11551, 25289, 2048, 47436},
		},
		[GetSpellInfo(47440)] = {									-- Commanding Shout
			maxTalentPoints = 5,
			improved = GetSpellInfo(12861),							-- Commanding Presence
			rankIDs = {469,47439,47440},
		},
		[GetSpellInfo(47437)] = {									-- Demoralizing Shout
			maxTalentPoints = 5,
			improved = GetSpellInfo(12879),							-- Improved Demoralizing Shout
			rankIDs = {1160, 6190, 11554, 11555, 11556, 25202, 25203, 47437},
		},
		[GetSpellInfo(46855)] = {										-- Trauma
			maxTalentPoints = 2,
			improved = GetSpellInfo(46855),								-- Trauma
		},
		[GetSpellInfo(47502)] = {										-- Thunder Clap
			maxTalentPoints = 3,
			improved = GetSpellInfo(12666),							-- Improved Thunder Clap
		},
	},
	["ALL"] = {
		[GetSpellInfo(53648)] = {									-- Swift Retribution
			improved = GetSpellInfo(53648),							-- Swift Retribution
			class = "PALADIN",
			maxTalentPoints = 3,
			rankIDs = {19746,32223,465,643,1032,10290,10291,10292,10293,27149,48941,48942,19891,19899,19900,27153,48947,19888,19897,19898,27152,48945,7294,10298,10299,10300,10301,27150,54043,19876,19895,19896,27151,48943,},
		},
		[GetSpellInfo(20140)] = {									-- Improved Devotion Aura
			improved = GetSpellInfo(20140),							-- Improved Devotion Aura
			maxTalentPoints = 3,
			class = "PALADIN",
			rankIDs = {19746,32223,465,643,1032,10290,10291,10292,10293,27149,48941,48942,19891,19899,19900,27153,48947,19888,19897,19898,27152,48945,7294,10298,10299,10300,10301,27150,54043,19876,19895,19896,27151,48943,},
		},
		[GetSpellInfo(19746)] = {									-- Improved Concentration Aura
			improved = GetSpellInfo(20256),							-- Improved Concentration Aura
			maxTalentPoints = 3,
			class = "PALADIN",
			rankIDs = {19746,32223,465,643,1032,10290,10291,10292,10293,27149,48941,48942,19891,19899,19900,27153,48947,19888,19897,19898,27152,48945,7294,10298,10299,10300,10301,27150,54043,19876,19895,19896,27151,48943,},
		},
	},
}

FatCooldowns.SilenceInfoV2 = {	
	["Annoying Yipping"] = "Silence",
	["Arcane Bomb"] = "Silence",
	["Arcane Burst"] = "Silence",
	["Arcane Torrent"] = "Silence",
	["Brain Wipe"] = "Silence",
	["Deafening Roar"] = "Silence",
	["Earthquake"] = "Silence",
	["Garrote - Silence"] = "Silence",
	["Garrote"] = "Silence",
	["Improved Counterspell"] = "Silence",
	["Improved Kick"] = "Silence",
	["Jagged Obsidian Shield"] = "Silence",
	["Noxious Poison"] = "Silence",
	["Shield of the Templar"] = "Silence",
	["Shockwave"] = "Silence",
	["Silence Trigger"] = "Silence",
	["Silence"] = "Silence",
	["Silenced - Gag Order"] = "Silence",
	["Silenced - Improved Counterspell"] = "Silence",
	["Silenced - Improved Kick"] = "Silence",
	["Silenced - Shield of the Templar"] = "Silence",
	["Silencing Shot"] = "Silence",
	["Silencing Shriek"] = "Silence",
	["Soul Charge"] = "Silence",
	["Soul Shriek"] = "Silence",
	["Spell Lock"] = "Silence",
	["Strangulate"] = "Silence",
	--mobs
	["Arcane Lightning"] = "Silence",
	["Aspect of Jeklik"] = "Silence",
	["Azure Bindings"] = "Silence",
	["Banshee Screech"] = "Silence",
	["Banshee Shriek"] = "Silence",
	["Chilling Words"] = "Silence",
	["Conservator's Grip"] = "Silence",
	["Deafening Screech"] = "Silence",
	["Enveloping Web"] = "Silence",
	["Harsh Winds"] = "Silence",
	["Holy Ground"] = "Silence",
	["Librarian's Shush"] = "Silence",
	["Lobotomize"] = "Silence",
	["Lost Soul"] = "Silence",
	["Overwhelming Stench"] = "Silence",
	["Putrid Stench"] = "Silence",
	["Sand Storm"] = "Silence",
	["Searing Flames"] = "Silence",
	["Sonic Burst"] = "Silence",
	["Soul Burn"] = "Silence",
	["Shadows Embrace"] = "Silence",
	["Screams of the Past"] = "Silence",
}

FatCooldowns.CCInfoV2 = {
	["Adamantite Grenade"] = "CC",
	["Azure Bindings"] = "CC",
	["Annihilate"] = "CC",
	["Arm of Law"] = "CC",
	["Axe Flurry"] = "CC",
	["Backbreaker"] = "CC",
	["Backhand"] = "CC",
	["Bad Poetry"] = "CC",
	["Banish"] = "CC",
	["Bash"] = "CC",
	["Behemoth Charge"] = "CC",
	["Bellowing Roar"] = "CC",
	["Big Bronze Bomb"] = "CC",
	["Blackout"] = "CC",
	["Blind"] = "CC",
	["Blinding Webs"] = "CC",
	["Brood Affliction: Bronze"] = "CC",
	["Brutal Impact"] = "CC",
	["Chains of Kel'Thuzad"] = "CC",
	["Charge (TEST)"] = "CC",
	["Charge Stun"] = "CC",
	["Charge"] = "CC",
	["Cheap Shot"] = "CC",
	["Chest Pains"] = "CC",
	["CK's Fireball"] = "CC",
	["Cobalt Frag Bomb"] = "CC",
	["Concussion Blow"] = "CC",
	["Concussive Throw"] = "CC",
	["Constricting Chains"] = "CC",
	["Copy of Charge"] = "CC",
	["Cower in Fear"] = "CC",
	["Crafty Bomb"] = "CC",
	["Crystal Prison"] = "CC",
	["Cyclone"] = "CC",
	["Dark Iron Bomb"] = "CC",
	["Dark Iron Pulverizer"] = "CC",
	["Death Coil"] = "CC",
	["Death's Respite"] = "CC",
	["Debris"] = "CC",
	["Deep Freeze"] = "CC",
	["Deep Sleep"] = "CC",
	["Deep Slumber"] = "CC",
	["Deep Thunder"] = "CC",
	["Defiling Horror"] = "CC",
	["Demon Charge"] = "CC",
	["Demon Leap"] = "CC",
	["Despair Stricken"] = "CC",
	["Desperate Blow"] = "CC",
	["Devastating Leap"] = "CC",
	["Dismounting Shot"] = "CC",
	["Dominate Mind"] = "CC",
	["Dragon's Breath"] = "CC",
	["Dreamless Sleep Potion"] = "CC",
	["Dreamless Sleep"] = "CC",
	["Druid's Slumber"] = "CC",
	["Drunken Skull Crack"] = "CC",
	["Enveloping Winds"] = "CC",
	["Earth Stun"] = "CC",
	["Earthquake"] = "CC",
	["Embrace of the Vampyr"] = "CC",
	["Enchanting Lullaby"] = "CC",
	["Exploding Shot"] = "CC",
	["Fear"] = "CC",
	["Fel Iron Bomb"] = "CC",
	["Fel Shock"] = "CC",
	["Fel Stomp"] = "CC",
	["Feral Pounce"] = "CC",
	["Ferocious Butt"] = "CC",
	["Fervor"] = "CC",
	["Flameshocker's Touch"] = "CC",
	["Fleeing in Terror"] = "CC",
	["Forge Force"] = "CC",
	["Freeze"] = "CC",
	["Freezing Arrow Effect"] = "CC",
	["Freezing Touch"] = "CC",
	["Freezing Trap Effect"] = "CC",
	["Frenzied Dive"] = "CC",
	["Frightening Shout"] = "CC",
	["Glacial Roar"] = "CC",
	["Glaive Throw"] = "CC",
	["Gnaw"] = "CC",
	["Goblin Mortar"] = "CC",
	["Goblin Rocket Launcher"] = "CC",
	["Gouge"] = "CC",
	["Greater Dreamless Sleep Potion"] = "CC",
	["Greater Dreamless Sleep"] = "CC",
	["Green Whelp Armor"] = "CC",
	["Ground Smash"] = "CC",
	["Ground Stomp"] = "CC",
	["Hallucination"] = "CC",
	["Hammer of Justice"] = "CC",
	["Hammer Punch"] = "CC",
	["Hand of Ragnaros"] = "CC",
	["Head Crush"] = "CC",
	["Head Smack"] = "CC",
	["Heroic Leap"] = "CC",
	["Hex"] = "CC",
	["Hi-Explosive Bomb"] = "CC",
	["Hibernate"] = "CC",
	["Hoarfrost"] = "CC",
	["Holy Blast"] = "CC",
	["Holy Wrath"] = "CC",
	["Hoof Stomp"] = "CC",
	["Howl of Terror"] = "CC",
	["Hungering Cold"] = "CC",
	["Ice Nova"] = "CC",
	["Ice Shot"] = "CC",
	["Ice Shriek"] = "CC",
	["Ice Stalagmite"] = "CC",
	["Icebolt"] = "CC",
	["Impact"] = "CC",
	["Impending Despair"] = "CC",
	["Improved Fear"] = "CC",
	["Improved Polymorph"] = "CC",
	["Incite Horror"] = "CC",
	["Incite Terror"] = "CC",
	["Inferno Effect"] = "CC",
	["Inferno"] = "CC",
	["Intercept"] = "CC",
	["Intimidating Shout"] = "CC",
	["Intimidation"] = "CC",
	["Iron Grenade"] = "CC",
	["Ja'y's Stunning Shot"] = "CC",
	["Kidney Shot"] = "CC",
	["Knockdown Spin"] = "CC",
	["Knockdown"] = "CC",
	["Knockout"] = "CC",
	["Kodo Stomp"] = "CC",
	["Lag"] = "CC",
	["Lock Jaw"] = "CC",
	["Love Tap"] = "CC",
	["Lumberjack Slam"] = "CC",
	["M73 Frag Grenade"] = "CC",
	["Mace Smash"] = "CC",
	["Magnataur Charge"] = "CC",
	["Maim"] = "CC",
	["Major Dreamless Sleep Potion"] = "CC",
	["Major Dreamless Sleep"] = "CC",
	["Malady of the Mind"] = "CC",
	["Mammoth Charge"] = "CC",
	["Mind Control"] = "CC",
	["Mithril Frag Bomb"] = "CC",
	["Mounted Charge"] = "CC",
	["Naralex's Nightmare"] = "CC",
	["Ninja Grenade [PH]"] = "CC",
	["Nullify"] = "CC",
	["Old God's Influence"] = "CC",
	["Petrify"] = "CC",
	["Polymorph"] = "CC",
	["Polymorph: Chicken"] = "CC",
	["Polymorph: Sheep"] = "CC",
	["Poultryized!"] = "CC",
	["Pounce Bleed"] = "CC",
	["Pounce"] = "CC",
	["Pound"] = "CC",
	["Powerful Attraction"] = "CC",
	["Psychic Horror"] = "CC",
	["Psychic Scream"] = "CC",
	["Pyroclast Barrage"] = "CC",
	["Rampage"] = "CC",
	["Ravage"] = "CC",
	["Repelling Wave"] = "CC",
	["Repentance"] = "CC",
	["Revenge Stun"] = "CC",
	["Rhahk'Zor Slam"] = "CC",
	["Rocket Launch"] = "CC",
	["Rough Copper Bomb"] = "CC",
	["Sablemane's Sleeping Powder"] = "CC",
	["Sacrifice"] = "CC",
	["Sand Blast"] = "CC",
	["Sap"] = "CC",
	["Saronite Grenade"] = "CC",
	["Scald"] = "CC",
	["Scare Beast"] = "CC",
	["Scare Daggerfen"] = "CC",
	["Scatter Shot"] = "CC",
	["Screams of the Dead"] = "CC",
	["Seal of Justice"] = "CC",
	["Second Wind"] = "CC",
	["Seduction"] = "CC",
	["Shackle Undead"] = "CC",
	["Shadow Command"] = "CC",
	["Shadow Prison"] = "CC",
	["Shadowfury"] = "CC",
	["Shadowstalker Slash"] = "CC",
	["Shadowstalker Stab"] = "CC",
	["Shield Charge"] = "CC",
	["Shield Slam"] = "CC",
	["Shield Smash"] = "CC",
	["Shock of Sorrow"] = "CC",
	["Shockwave"] = "CC",
	["Shovelled!"] = "CC",
	["Skull Crack"] = "CC",
	["Slam"] = "CC",
	["Slime"] = "CC",
	["Small Bronze Bomb"] = "CC",
	["Smite Slam"] = "CC",
	["Smoke Bomb"] = "CC",
	["Smoke Cloud"] = "CC",
	["Snake Wrap"] = "CC",
	["Snap Kick"] = "CC",
	["Sonic Blast"] = "CC",
	["Soul Scream"] = "CC",
	["Staff Specialization"] = "CC",
	["Stampy's Stompy-Stomp"] = "CC",
	["Starfire Stun"] = "CC",
	["Startling Flare"] = "CC",
	["Stomp"] = "CC",
	["Stone Grip"] = "CC",
	["Stone Stomp"] = "CC",
	["Stoneclaw Stun"] = "CC",
	["Storm Bolt"] = "CC",
	["Storm Hammer"] = "CC",
	["Stormhammer"] = "CC",
	["Stormherald"] = "CC",
	["Stun 1% for 1 sec"] = "CC",
	["Stun Bomb Attack"] = "CC",
	["Stun Bomb"] = "CC",
	["Stun"] = "CC",
	["Summon Charming Totem"] = "CC",
	["Summon Wrath Hound"] = "CC",
	["Summoning Disorientation"] = "CC",
	["Surprise Attack"] = "CC",
	["Tail Lash"] = "CC",
	["Terrify"] = "CC",
	["Terrifying Howl"] = "CC",
	["Terrifying Roar"] = "CC",
	["Terrifying Screech"] = "CC",
	["The Big One"] = "CC",
	["The Naked Bomb"] = "CC",
	["Thorium Grenade"] = "CC",
	["Throw Rock"] = "CC",
	["Throw Shield"] = "CC",
	["Thundercrack"] = "CC",
	["Thundershock"] = "CC",
	["Tight Pinch"] = "CC",
	["Torment"] = "CC",
	["Towering Chains"] = "CC",
	["Tranquilizing Poison"] = "CC",
	["Turn Evil"] = "CC",
	["Unrelenting Strike"] = "CC",
	["Vile Fumes"] = "CC",
	["Violent Crash"] = "CC",
	["Violent Shield"] = "CC",
	["Waking Nightmare"] = "CC",
	["War Stomp"] = "CC",
	["Warlock Terror"] = "CC",
	["Warp Charge"] = "CC",
	["Water Tomb"] = "CC",
	["Web Spray"] = "CC",
	["Web Wrap"] = "CC",
	["Whirling Trip"] = "CC",
	["Wild Polymorph"] = "CC",
	["Wrench Throw"] = "CC",
	["Wyvern Sting"] = "CC",
	["The Black Sleep"] = "CC",
	["Impending Coma"] = "CC",
	["Sleep"] = "CC",
}

function filter(spellsByLevel, pred)
	local output = {}
	for level, spells in pairs(spellsByLevel) do
		output[level] = {}
		for _, spell in ipairs(spells) do
			if (pred(spell) == true) then
				tinsert(output[level], spell)
			end
		end
	end
	return output
end

local playerFaction = UnitFactionGroup("player")
function FactionFilter(spellsByLevel)
	return filter(spellsByLevel, function(spell)
		return spell.faction == nil or spell.faction == playerFaction
	end)
end

local playerRace = select(3, UnitRace("player"))
function RaceFilter(spellsByLevel)
	return filter(spellsByLevel, function(spell)
		if (spell.race == nil and spell.races == nil) then return true end
		if (spell.races == nil) then return spell.race == playerRace end
		return spell.races[1] == playerRace or spell.races[2] == playerRace
	end)
end

function AddOverriddenSpells(Class, Expac, ...)
	if Class == UnitClass("player") and FatCooldowns.ExPac == Expac then
		local abilityMap = {}
		for _, abilityIds in pairs({...}) do
			for _, abilityId in pairs(abilityIds) do
				abilityMap[abilityId] = abilityIds
			end
		end
		FatCooldowns.overriddenSpellsMap = abilityMap
	end
end

function PetSpellBookCheck(SpellNameCheck, SpellRankCheck)
	if next(FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets) then 
		if FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")] then 
			if FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")][SpellNameCheck] then 
				local SPRank1 = select(3,strfind(SpellRankCheck, "Rank (%d+)"))
				local SPRank2 = select(3,strfind(FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")][SpellNameCheck], "Rank (%d+)"))
				if (FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")][SpellNameCheck] == SpellRankCheck) or (SPRank1 ~= nil and SPRank2 ~= nil and SPRank1 <= SPRank2) then	
					return true
				end
			end
		end
	end
	for i = 1, 100, 1 do
		local spellName, spellRank = GetSpellName(i, BOOKTYPE_PET)
		if spellName ~= nil then
			local SPRank1 = select(3,strfind(SpellRankCheck, "Rank (%d+)"))
			local SPRank2 = select(3,strfind(spellRank, "Rank (%d+)"))
			if spellRank ~= nil and	SpellNameCheck == spellName and	(SpellRankCheck == spellRank or	(SPRank1 ~= nil and SPRank2 ~= nil and SPRank1 <= SPRank2))	then
				FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")] = FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")] or {}
				FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")][spellName] = FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")][spellName] or {}
				FatCooldowns:GetModule("Display").db.profile.SpellsLvlPets[UnitName("player")][spellName] = spellRank
				return true
			end
		end
	end
	return false
end

function IsPlayerSpell(SpellCheck)
	local SpellsTable = {}
	for _, SpellsID in pairs(FatCooldowns.SpellDataFails) do
		for _, SpellsIDs in pairs(SpellsID) do
			SpellsTable[SpellsIDs] = SpellsID
		end
	end
	local SPI, RID = 0, 0
	if SpellsTable == nil or SpellsTable[SpellCheck] == nil then return false end
	for i, FID in pairs(SpellsTable[SpellCheck]) do
		if (FID == SpellCheck) then SPI = i end
		if (IsSpellKnown(FID)) then RID = i end
	end
	if SPI <= RID then return true else return false end	
end

function isMountLearned(spellId)
	local numMounts = GetNumCompanions("MOUNT")
	if numMounts == 0 then
		return false
	else
		local mountSpellId = nil
		for i = 1, numMounts do
			mountSpellId = select(3, GetCompanionInfo("MOUNT", i))
			if mountSpellId == spellId then	return true end
		end
	end
end

function isPreviouslyLearnedAbility(spellId)
	if (FatCooldowns.overriddenSpellsMap == nil or not FatCooldowns.overriddenSpellsMap[spellId]) then return false end
	local spellIndex, knownIndex = 0, 0
	for i, otherId in ipairs(FatCooldowns.overriddenSpellsMap[spellId]) do
		if (otherId == spellId) then spellIndex = i end
		if (IsSpellKnown(otherId) or IsPlayerSpell(otherId) or isMountLearned(otherId)) then
			knownIndex = i
		end
	end
	return spellIndex <= knownIndex
end

function IsProfessionCheck(spellId)
	if IsSpellKnown(2842) then
		if FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")] ~= nil and FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")][spellId] ~= nil and FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")][spellId] == spellId then return true end
		CastSpellByName("Poisons")
		CloseTradeSkill()
		local name, rank = GetSpellInfo(spellId)
		for i = 1, GetNumTradeSkills() do
			local skillName  = GetTradeSkillInfo(i)
			if skillName == name then
				FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")] = FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")] or {}
				FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")][spellId] = FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")][spellId] or {}
				FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")][spellId] = spellId
				return true
			end
		end
	end
	return false
end

function isAbilityKnown(spellId) if (IsSpellKnown(spellId) or IsPlayerSpell(spellId) or isMountLearned(spellId) or isPreviouslyLearnedAbility(spellId) or IsProfessionCheck(spellId)) then return true else return false end end

local once = false
function isWeaponKnown(class, WeaponID)
	for skillIndex = 1, GetNumSkillLines() do
		local skillName, _, isExpanded, skillRank, numTempPoints, skillModifier,skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType, skillDescription  = GetSkillLineInfo(skillIndex)
		if WeaponID == skillName then
			if WeaponID == "Unarmed" then
				if FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")] ~= nil and FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")][WeaponID] ~= nil and FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")][WeaponID] == WeaponID then return true end
				local FakeWeaponsTable = {
					[15906] = "|cff9d9d9d|Hitem:15906:0:0:0:0:0:0:0:0|h[Left-Handed Brass Knuckles]|h|r",
					[20954] = "|cff1eff00|Hitem:20954:0:0:0:0:0:0:0:0|h[Heavy Iron Knuckles]|h|r",
					[51003] = "|cffa335ee|Hitem:51003:0:0:0:0:0:0:0:0|h[Abomination Knuckles]|h|r",
					[11603] = "|cff0070dd|Hitem:11603:0:0:0:0:0:0:0:0|h[Vilerend Slicer]|h|r",
				}
				for Findex, Fweapon in pairs(FakeWeaponsTable) do
					local FakeChecking = isSoulbound(nil, nil, Fweapon, true)
					if IsEquippableItem(Fweapon) then
						FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")] = FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")] or {}
						FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")][WeaponID] = FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")][WeaponID] or {}
						FatCooldowns:GetModule("Display").db.profile.SpellsLvlExtra[UnitName("player")][WeaponID] = WeaponID
						return true
					end
				end
				return false
			else
				return true
			end
		end
	end
	return false
end

FatCooldowns.DeathknightSpells = FactionFilter({
	[56] = {
		{id = 49998, cost = 5600}, 
		{id = 50842, cost = 5600}, 
		{id = 46584, cost = 5600}, 
	},
	[57] = {
		{id = 48263, cost = 5700}, 
		{id = 47528, cost = 5700}, 
	},
	[58] = {
		{id = 48721, cost = 5800}, 
		{id = 45524, cost = 5800}, 
	},
	[59] = {
		{id = 49926, cost = 5900, requiredIds = {45902}}, 
		{id = 55258, cost = 5900, requiredIds = {55050}, requiredTalentId = 55050}, 
		{id = 47476, cost = 5900}, 
	},
	[60] = {
		{id = 51325, cost = 300, requiredIds = {49158}, requiredTalentId = 49158}, 
		{id = 43265, cost = 6000}, 
		{id = 51416, cost = 6200, requiredIds = {49143}, requiredTalentId = 49143}, 
		{id = 49917, cost = 5800, requiredIds = {45462}}, 
	},
	[61] = {
		{id = 49896, cost = 61000, requiredIds = {45477}}, 
		{id = 49020, cost = 61000}, 
		{id = 3714, cost = 64000}, 
	},
	[62] = {
		{id = 49892, cost = 59000, requiredIds = {47541}}, 
		{id = 48792, cost = 62000}, 
	},
	[63] = {
		{id = 49999, cost = 65000, requiredIds = {49998}}, 
	},
	[64] = {
		{id = 49927, cost = 64000, requiredIds = {49926}}, 
		{id = 45529, cost = 64000}, 
		{id = 55259, cost = 3200, requiredIds = {55258}, requiredTalentId = 55050}, 
	},
	[65] = {
		{id = 56222, cost = 65000}, 
		{id = 51417, cost = 3250, requiredIds = {51416}, requiredTalentId = 49143}, 
		{id = 57330, cost = 65000}, 
		{id = 49918, cost = 65000, requiredIds = {49917}}, 
	},
	[66] = {
		{id = 49939, cost = 66000, requiredIds = {48721}}, 
		{id = 48743, cost = 66000}, 
	},
	[67] = {
		{id = 49936, cost = 68000, requiredIds = {43265}}, 
		{id = 49903, cost = 67000, requiredIds = {49896}}, 
		{id = 51423, cost = 67000, requiredIds = {49020}}, 
		{id = 56815, cost = 67000}, 
		{id = 55265, cost = 18000, requiredIds = {55090}, requiredTalentId = 55090}, 
	},
	[68] = {
		{id = 48707, cost = 68000}, 
		{id = 49893, cost = 68000, requiredIds = {49892}}, 
	},
	[69] = {
		{id = 49928, cost = 69000, requiredIds = {49927}}, 
		{id = 55260, cost = 3450, requiredIds = {55259}, requiredTalentId = 55050}, 
	},
	[70] = {
		{id = 51326, cost = 18000, requiredIds = {51325}, requiredTalentId = 49158}, 
		{id = 45463, cost = 63000, requiredIds = {49999}}, 
		{id = 51418, cost = 18000, requiredIds = {51417}, requiredTalentId = 49143}, 
		{id = 51409, cost = 6500, requiredIds = {49184}, requiredTalentId = 49184}, 
		{id = 49919, cost = 360000, requiredIds = {49918}}, 
		{id = 48265, cost = 360000}, 
	},
	[72] = {
		{id = 49940, cost = 360000, requiredIds = {49939}}, 
		{id = 61999, cost = 360000}, 
	},
	[73] = {
		{id = 49937, cost = 360000, requiredIds = {49936}}, 
		{id = 49904, cost = 360000, requiredIds = {49903}}, 
		{id = 51424, cost = 360000, requiredIds = {51423}}, 
		{id = 55270, cost = 18000, requiredIds = {55265}, requiredTalentId = 55090}, 
	},
	[74] = {
		{id = 49929, cost = 360000, requiredIds = {49928}}, 
		{id = 55261, cost = 18000, requiredIds = {55260}, requiredTalentId = 55050}, 
	},
	[75] = {
		{id = 51327, cost = 18000, requiredIds = {51326}, requiredTalentId = 49158}, 
		{id = 49923, cost = 360000, requiredIds = {45463}}, 
		{id = 47568, cost = 360000}, 
		{id = 51419, cost = 18000, requiredIds = {51418}, requiredTalentId = 49143}, 
		{id = 57623, cost = 360000, requiredIds = {57330}}, 
		{id = 51410, cost = 10000, requiredIds = {51409}, requiredTalentId = 49184}, 
		{id = 49920, cost = 360000, requiredIds = {49919}}, 
	},
	[76] = {
		{id = 49894, cost = 360000, requiredIds = {49893}}, 
	},
	[78] = {
		{id = 49941, cost = 360000, requiredIds = {49940}}, 
		{id = 49909, cost = 360000, requiredIds = {49904}}, 
	},
	[79] = {
		{id = 51425, cost = 360000, requiredIds = {51424}}, 
		{id = 55271, cost = 18000, requiredIds = {55270}, requiredTalentId = 55090}, 
	},
	[80] = {
		{id = 42650, cost = 360000}, 
		{id = 49930, cost = 360000, requiredIds = {49929}}, 
		{id = 51328, cost = 18000, requiredIds = {51327}, requiredTalentId = 49158}, 
		{id = 49938, cost = 360000, requiredIds = {49937}}, 
		{id = 49895, cost = 360000, requiredIds = {49894}}, 
		{id = 49924, cost = 360000, requiredIds = {49923}}, 
		{id = 55268, cost = 18000, requiredIds = {51419}, requiredTalentId = 49143}, 
		{id = 55262, cost = 18000, requiredIds = {55261}, requiredTalentId = 55050}, 
		{id = 51411, cost = 10000, requiredIds = {51410}, requiredTalentId = 49184}, 
		{id = 49921, cost = 360000, requiredIds = {49920}} 
	},
})

FatCooldowns.WarriorSpells = {
	[0] = { 
		[1] = {
			{id = 6673, cost = 10}
		},
		[4] = {
			{id = 100, cost = 100},
			{id = 772, cost = 100}
		},
		[6] = {
			{id = 3127, cost = 100},
			{id = 6343, cost = 100}
		},
		[8] = {
			{id = 1715, cost = 200},
			{id = 284, cost = 200, requiredIds = {78}}
		},
		[10] = {
			{id = 2687, cost = 600},
			{id = 6546, cost = 600, requiredIds = {772}}
		},
		[12] = {
			{id = 5242, cost = 1000, requiredIds = {6673}},
			{id = 7384, cost = 1000},
			{id = 72, cost = 1000}
		},
		[14] = {
			{id = 1160, cost = 1500},
			{id = 6572, cost = 1500}
		},
		[16] = {
			{id = 285, cost = 2000, requiredIds = {284}},
			{id = 694, cost = 2000},
			{id = 2565, cost = 2000}
		},
		[18] = {
			{id = 676, cost = 3000},
			{id = 8198, cost = 3000, requiredIds = {6343}}
		},
		[20] = {
			{id = 845, cost = 4000},
			{id = 674, cost = 4000},
			{id = 6547, cost = 4000, requiredIds = {6546}},
			{id = 20230, cost = 4000}
		},
		[22] = {
			{id = 6192, cost = 6000, requiredIds = {5242}},
			{id = 7405, cost = 6000},
			{id = 5246, cost = 6000}
		},
		[24] = {
			{id = 6190, cost = 8000, requiredIds = {1160}},
			{id = 5308, cost = 8000},
			{id = 1608, cost = 8000, requiredIds = {285}},
			{id = 6574, cost = 8000, requiredIds = {6572}}
		},
		[26] = {
			{id = 1161, cost = 10000},
			{id = 6178, cost = 10000, requiredIds = {100}},
			{id = 7400, cost = 10000, requiredIds = {694}}
		},
		[28] = {
			{id = 7887, cost = 11000, requiredIds = {7384}},
			{id = 871, cost = 11000},
			{id = 8204, cost = 11000, requiredIds = {8198}}
		},
		[30] = {
			{id = 7369, cost = 12000, requiredIds = {845}},
			{id = 6548, cost = 12000, requiredIds = {6547}},
			{id = 1464, cost = 12000}
		},
		[32] = {
			{id = 11549, cost = 14000, requiredIds = {6192}},
			{id = 18499, cost = 14000},
			{id = 20658, cost = 14000, requiredIds = {5308}},
			{id = 7372, cost = 14000, requiredIds = {1715}},
			{id = 11564, cost = 14000, requiredIds = {1608}},
			{id = 1671, cost = 14000, requiredIds = {72}}
		},
		[34] = {
			{id = 11554, cost = 16000, requiredIds = {6190}},
			{id = 7379, cost = 16000, requiredIds = {6574}},
			{id = 8380, cost = 16000, requiredIds = {7405}}
		},
		[36] = {
			{id = 7402, cost = 18000, requiredIds = {7400}},
			{id = 1680, cost = 18000}
		},
		[38] = {
			{id = 6552, cost = 20000},
			{id = 8820, cost = 20000, requiredIds = {1464}},
			{id = 8205, cost = 20000, requiredIds = {8204}}
		},
		[40] = {
			{id = 11608, cost = 22000, requiredIds = {7369}},
			{id = 20660, cost = 22000, requiredIds = {20658}},
			{id = 11565, cost = 22000, requiredIds = {11564}},
			{id = 11572, cost = 22000, requiredIds = {6548}}
		},
		[42] = {
			{id = 11550, cost = 32000, requiredIds = {11549}},
			{id = 20616, cost = 32000, requiredTalentId = 20252}
		},
		[44] = {
			{id = 11555, cost = 34000, requiredIds = {11554}},
			{id = 11584, cost = 34000, requiredIds = {7887}},
			{id = 11600, cost = 34000, requiredIds = {7379}}
		},
		[46] = {
			{id = 11578, cost = 36000, requiredIds = {6178}},
			{id = 20559, cost = 36000, requiredIds = {7402}},
			{id = 11604, cost = 36000, requiredIds = {8820}},
			{id = 11596, cost = 36000, requiredIds = {8380}}
		},
		[48] = {
			{id = 23892, cost = 2000, requiredTalentId = 23881},
			{id = 20661, cost = 40000, requiredIds = {20660}},
			{id = 11566, cost = 40000, requiredIds = {11565}},
			{id = 21551, cost = 200, requiredTalentId = 12294},
			{id = 23923, cost = 200, requiredTalentId = 23922},
			{id = 11580, cost = 40000, requiredIds = {8205}}
		},
		[50] = {
			{id = 11609, cost = 42000, requiredIds = {11608}},
			{id = 1719, cost = 42000},
			{id = 11573, cost = 42000, requiredIds = {11572}}
		},
		[52] = {
			{id = 11551, cost = 54000, requiredIds = {11550}},
			{id = 20617, cost = 54000, requiredIds = {20616}, requiredTalentId = 20252},
			{id = 1672, cost = 54000, requiredIds = {1671}}
		},
		[54] = {
			{id = 23893, cost = 2800, requiredIds = {23892}, requiredTalentId = 23881},
			{id = 11556, cost = 56000, requiredIds = {11555}},
			{id = 7373, cost = 56000, requiredIds = {7372}},
			{id = 21552, cost = 2800, requiredIds = {21551}, requiredTalentId = 12294},
			{id = 11601, cost = 56000, requiredIds = {11600}},
			{id = 23924, cost = 2800, requiredIds = {23923}, requiredTalentId = 23922},
			{id = 11605, cost = 56000, requiredIds = {11604}}
		},
		[56] = {
			{id = 20662, cost = 58000, requiredIds = {20661}},
			{id = 11567, cost = 58000, requiredIds = {11566}},
			{id = 20560, cost = 58000, requiredIds = {20559}}
		},
		[58] = {
			{id = 6554, cost = 60000, requiredIds = {6552}},
			{id = 11597, cost = 60000, requiredIds = {11596}},
			{id = 11581, cost = 60000, requiredIds = {11580}}
		},
		[60] = {
			{id = 23894, cost = 3100, requiredIds = {23893}, requiredTalentId = 23881},
			{id = 20569, cost = 62000, requiredIds = {11609}},
			{id = 21553, cost = 3100, requiredIds = {21552}, requiredTalentId = 12294},
			{id = 11585, cost = 62000, requiredIds = {11584}},
			{id = 11574, cost = 62000, requiredIds = {11573}},
			{id = 23925, cost = 3100, requiredIds = {23924}, requiredTalentId = 23922}
		},
	},
	[1] = { 
		[1] = {
			{id = 6673, cost = 10},
		},
		[4] = {
			{id = 100, cost = 100},
			{id = 772, cost = 100},
		},
		[6] = {
			{id = 6343, cost = 100},
			{id = 3127, cost = 100},
		},
		[8] = {
			{id = 1715, cost = 200},
			{id = 284, cost = 200},
		},
		[10] = {
			{id = 6546, cost = 600, requiredIds = {772}},
			{id = 2687, cost = 600},
		},
		[12] = {
			{id = 7384, cost = 1000},
			{id = 5242, cost = 1000, requiredIds = {6673}},
			{id = 72, cost = 1000},
		},
		[14] = {
			{id = 1160, cost = 1500},
			{id = 6572, cost = 1500, requiredIds = {71}},
		},
		[16] = {
			{id = 285, cost = 2000, requiredIds = {284}},
			{id = 694, cost = 2000},
			{id = 2565, cost = 2000, requiredIds = {71}},
		},
		[18] = {
			{id = 8198, cost = 3000, requiredIds = {6343}},
			{id = 676, cost = 3000, requiredIds = {71}},
		},
		[20] = {
			{id = 6547, cost = 4000, requiredIds = {6546}},
			{id = 20230, cost = 4000},
			{id = 674, cost = 4000},
			{id = 845, cost = 4000},
			{id = 12678, cost = 4000},
		},
		[22] = {
			{id = 6192, cost = 6000, requiredIds = {5242}},
			{id = 5246, cost = 6000},
			{id = 7405, cost = 6000},
		},
		[24] = {
			{id = 1608, cost = 8000, requiredIds = {285}},
			{id = 6190, cost = 8000, requiredIds = {1160}},
			{id = 5308, cost = 8000},
			{id = 6574, cost = 8000, requiredIds = {6572}},
		},
		[26] = {
			{id = 6178, cost = 10000, requiredIds = {100}},
			{id = 7400, cost = 10000, requiredIds = {694}},
			{id = 1161, cost = 10000},
		},
		[28] = {
			{id = 7887, cost = 11000, requiredIds = {7384}},
			{id = 8204, cost = 11000, requiredIds = {8198}},
			{id = 871, cost = 11000, requiredIds = {71}},
		},
		[30] = {
			{id = 6548, cost = 12000, requiredIds = {6547}},
			{id = 7369, cost = 12000, requiredIds = {845}},
			{id = 1464, cost = 12000},
		},
		[32] = {
			{id = 7372, cost = 14000, requiredIds = {1715}},
			{id = 11564, cost = 14000, requiredIds = {1608}},
			{id = 11549, cost = 14000, requiredIds = {6192}},
			{id = 18499, cost = 14000, requiredIds = {2458}},
			{id = 20658, cost = 14000, requiredIds = {5308}},
			{id = 1671, cost = 14000, requiredIds = {72}},
		},
		[34] = {
			{id = 11554, cost = 16000, requiredIds = {6190}},
			{id = 7379, cost = 16000, requiredIds = {6574}},
			{id = 8380, cost = 16000, requiredIds = {7405}},
		},
		[36] = {
			{id = 7402, cost = 18000, requiredIds = {7400}},
			{id = 1680, cost = 18000, requiredIds = {2458}},
		},
		[38] = {
			{id = 8205, cost = 20000, requiredIds = {8204}},
			{id = 6552, cost = 20000, requiredIds = {2458}},
			{id = 8820, cost = 20000, requiredIds = {1464}},
		},
		[40] = {
			{id = 11565, cost = 22000, requiredIds = {11564}},
			{id = 11572, cost = 22000, requiredIds = {6548}},
			{id = 11608, cost = 22000, requiredIds = {7369}},
			{id = 20660, cost = 22000, requiredIds = {20658}},
		},
		[42] = {
			{id = 11550, cost = 32000, requiredIds = {11549}},
			{id = 20616, cost = 32000},
		},
		[44] = {
			{id = 11584, cost = 34000, requiredIds = {7887}},
			{id = 11555, cost = 34000, requiredIds = {11554}},
			{id = 11600, cost = 34000, requiredIds = {7379}},
		},
		[46] = {
			{id = 11578, cost = 36000, requiredIds = {6178}},
			{id = 20559, cost = 36000, requiredIds = {7402}},
			{id = 11604, cost = 36000, requiredIds = {8820}},
			{id = 11596, cost = 36000, requiredIds = {8380}},
		},
		[48] = {
			{id = 11566, cost = 40000, requiredIds = {11565}},
			{id = 21551, cost = 2000, requiredIds = {12294}, requiredTalentId = 12294},
			{id = 11580, cost = 40000, requiredIds = {8205}},
			{id = 23892, cost = 2000, requiredIds = {23881}, requiredTalentId = 23881},
			{id = 20661, cost = 40000, requiredIds = {20660}},
			{id = 23923, cost = 2000, requiredIds = {23922}, requiredTalentId = 23922},
		},
		[50] = {
			{id = 11573, cost = 42000, requiredIds = {11572}},
			{id = 11609, cost = 42000, requiredIds = {11608}},
			{id = 1719, cost = 42000, requiredIds = {2458}},
		},
		[52] = {
			{id = 11551, cost = 54000, requiredIds = {11550}},
			{id = 20617, cost = 54000, requiredIds = {20616}},
			{id = 1672, cost = 54000, requiredIds = {1671}},
		},
		[54] = {
			{id = 7373, cost = 56000, requiredIds = {7372}},
			{id = 21552, cost = 2800, requiredIds = {21551}, requiredTalentId = 12294},
			{id = 23893, cost = 2800, requiredIds = {23892}, requiredTalentId = 23881},
			{id = 11556, cost = 56000, requiredIds = {11555}},
			{id = 11605, cost = 56000, requiredIds = {11604}},
			{id = 11601, cost = 56000, requiredIds = {11600}},
			{id = 23924, cost = 2800, requiredIds = {23923}, requiredTalentId = 23922},
		},
		[56] = {
			{id = 11567, cost = 58000, requiredIds = {11566}},
			{id = 20560, cost = 58000, requiredIds = {20559}},
			{id = 20662, cost = 58000, requiredIds = {20661}},
		},
		[58] = {
			{id = 11581, cost = 60000, requiredIds = {11580}},
			{id = 6554, cost = 60000, requiredIds = {6552}},
			{id = 11597, cost = 60000, requiredIds = {11596}},
		},
		[60] = {
			{id = 25286, cost = 60000, requiredIds = {11567}},
			{id = 21553, cost = 3100, requiredIds = {21552}, requiredTalentId = 12294},
			{id = 11585, cost = 62000, requiredIds = {11584}},
			{id = 11574, cost = 62000, requiredIds = {11573}},
			{id = 25289, cost = 65000, requiredIds = {11551}},
			{id = 23894, cost = 3100, requiredIds = {23893}, requiredTalentId = 23881},
			{id = 20569, cost = 62000, requiredIds = {11609}},
			{id = 30030, cost = 3100, requiredIds = {29801}, requiredTalentId = 29801},
			{id = 30016, cost = 3100, requiredIds = {20243}, requiredTalentId = 20243},
			{id = 25288, cost = 56000, requiredIds = {11601}},
			{id = 23925, cost = 3100, requiredIds = {23924}, requiredTalentId = 23922},
		},
		[61] = {
			{id = 25272, cost = 65000, requiredIds = {20617}},
			{id = 25241, cost = 65000, requiredIds = {11605}},
		},
		[62] = {
			{id = 25202, cost = 65000, requiredIds = {11556}},
			{id = 34428, cost = 58000},
		},
		[63] = {
			{id = 25269, cost = 65000, requiredIds = {25288}},
		},
		[64] = {
			{id = 29704, cost = 60000, requiredIds = {1672}},
			{id = 23920, cost = 65000},
		},
		[65] = {
			{id = 25266, cost = 65000, requiredIds = {20560}},
			{id = 25234, cost = 65000, requiredIds = {20662}},
		},
		[66] = {
			{id = 29707, cost = 65000, requiredIds = {25286}},
			{id = 25248, cost = 3250, requiredIds = {21553}, requiredTalentId = 12294},
			{id = 25251, cost = 3250, requiredIds = {23894}, requiredTalentId = 23881},
			{id = 25258, cost = 3250, requiredIds = {23925}, requiredTalentId = 23922},
		},
		[67] = {
			{id = 25212, cost = 65000, requiredIds = {7373}},
			{id = 25264, cost = 65000, requiredIds = {11581}},
			{id = 25225, cost = 65000, requiredIds = {11597}},
		},
		[68] = {
			{id = 25208, cost = 65000, requiredIds = {11574}},
			{id = 25231, cost = 65000, requiredIds = {20569}},
			{id = 469, cost = 65000},
		},
		[69] = {
			{id = 2048, cost = 65000, requiredIds = {25289}},
			{id = 25275, cost = 65000, requiredIds = {25272}},
			{id = 25242, cost = 65000, requiredIds = {25241}},
		},
		[70] = {
			{id = 30330, cost = 3250, requiredIds = {25248}, requiredTalentId = 12294},
			{id = 30335, cost = 3250, requiredIds = {25251}, requiredTalentId = 23881},
			{id = 25203, cost = 65000, requiredIds = {25202}},
			{id = 25236, cost = 65000, requiredIds = {25234}},
			{id = 30033, cost = 3250, requiredIds = {30030}, requiredTalentId = 29801},
			{id = 30022, cost = 3250, requiredIds = {30016}, requiredTalentId = 20243},
			{id = 3411, cost = 65000},
			{id = 30357, cost = 65000, requiredIds = {25269}},
			{id = 30356, cost = 3250, requiredIds = {25258}, requiredTalentId = 23922},
		},
	},
	[2] = { 
		[1] = {
			{id = 6673, cost = 10}, 
		},
		[4] = {
			{id = 100, cost = 100}, 
			{id = 772, cost = 100}, 
		},
		[6] = {
			{id = 6343, cost = 100}, 
			{id = 3127, cost = 100}, 
		},
		[8] = {
			{id = 1715, cost = 200}, 
			{id = 284, cost = 200, requiredIds ={78}}, 
		},
		[10] = {
			{id = 2687, cost = 600}, 
			{id = 6546, cost = 600, requiredIds = {772}}, 
		},
		[12] = {
			{id = 5242, cost = 1000, requiredIds = {6673}}, 
			{id = 7384, cost = 1000}, 
			{id = 72, cost = 1000}, 
		},
		[14] = {
			{id = 1160, cost = 1500}, 
			{id = 6572, cost = 1500, requiredIds = {71}}, 
		},
		[16] = {
			{id = 285, cost = 2000, requiredIds = {284}}, 
			{id = 694, cost = 2000}, 
			{id = 2565, cost = 2000, requiredIds = {71}}, 
		},
		[18] = {
			{id = 676, cost = 3000, requiredIds = {71}}, 
			{id = 8198, cost = 3000, requiredIds = {6343}}, 
		},
		[20] = {
			{id = 845, cost = 4000}, 
			{id = 6547, cost = 4000, requiredIds = {6546}}, 
			{id = 20230, cost = 4000}, 
			{id = 12678, cost = 4000}, 
			{id = 674, cost = 4000}, 
		},
		[22] = {
			{id = 6192, cost = 6000, requiredIds = {5242}}, 
			{id = 5246, cost = 6000}, 
		},
		[24] = {
			{id = 6190, cost = 8000, requiredIds = {1160}}, 
			{id = 5308, cost = 8000}, 
			{id = 1608, cost = 8000, requiredIds = {285}}, 
			{id = 6574, cost = 8000, requiredIds = {6572}}, 
		},
		[26] = {
			{id = 1161, cost = 10000}, 
			{id = 6178, cost = 10000, requiredIds = {100}}, 
		},
		[28] = {
			{id = 871, cost = 11000, requiredIds = {71}}, 
			{id = 8204, cost = 11000, requiredIds = {8198}}, 
		},
		[30] = {
			{id = 7369, cost = 12000, requiredIds = {845}}, 
			{id = 20252, cost = 12000}, 
			{id = 6548, cost = 12000, requiredIds = {6547}}, 
			{id = 1464, cost = 12000}, 
		},
		[32] = {
			{id = 11549, cost = 14000, requiredIds = {6192}}, 
			{id = 18499, cost = 14000, requiredIds = {2458}}, 
			{id = 20658, cost = 14000, requiredIds = {5308}}, 
			{id = 11564, cost = 14000, requiredIds = {1608}}, 
		},
		[34] = {
			{id = 11554, cost = 16000, requiredIds = {6190}}, 
			{id = 7379, cost = 16000, requiredIds = {6574}}, 
		},
		[36] = {
			{id = 1680, cost = 18000, requiredIds = {2458}}, 
		},
		[38] = {
			{id = 6552, cost = 20000, requiredIds = {2458}}, 
			{id = 8820, cost = 20000, requiredIds = {1464}}, 
			{id = 8205, cost = 20000, requiredIds = {8204}}, 
		},
		[40] = {
			{id = 11608, cost = 22000, requiredIds = {7369}}, 
			{id = 20660, cost = 22000, requiredIds = {20658}}, 
			{id = 11565, cost = 22000, requiredIds = {11564}}, 
			{id = 11572, cost = 22000, requiredIds = {6548}}, 
			{id = 23922, cost = 22000}, 
		},
		[42] = {
			{id = 11550, cost = 32000, requiredIds = {11549}}, 
		},
		[44] = {
			{id = 11555, cost = 34000, requiredIds = {11554}}, 
			{id = 11600, cost = 34000, requiredIds = {7379}}, 
		},
		[46] = {
			{id = 11578, cost = 36000, requiredIds = {6178}}, 
			{id = 11604, cost = 36000, requiredIds = {8820}}, 
		},
		[48] = {
			{id = 20661, cost = 40000, requiredIds = {20660}}, 
			{id = 11566, cost = 40000, requiredIds = {11565}}, 
			{id = 21551, cost = 2000, requiredIds = {12294}, requiredTalentId = 12294}, 
			{id = 23923, cost = 40000, requiredIds = {23922}}, 
			{id = 11580, cost = 40000, requiredIds = {8205}}, 
		},
		[50] = {
			{id = 11609, cost = 42000, requiredIds = {11608}}, 
			{id = 1719, cost = 42000, requiredIds = {2458}}, 
			{id = 11573, cost = 42000, requiredIds = {11572}}, 
		},
		[52] = {
			{id = 11551, cost = 54000, requiredIds = {11550}}, 
		},
		[54] = {
			{id = 11556, cost = 56000, requiredIds = {11555}}, 
			{id = 21552, cost = 2800, requiredIds = {21551}, requiredTalentId = 12294}, 
			{id = 11601, cost = 56000, requiredIds = {11600}}, 
			{id = 23924, cost = 56000, requiredIds = {23923}}, 
			{id = 11605, cost = 56000, requiredIds = {11604}}, 
		},
		[56] = {
			{id = 20662, cost = 58000, requiredIds = {20661}}, 
			{id = 11567, cost = 58000, requiredIds = {11566}}, 
		},
		[58] = {
			{id = 11581, cost = 60000, requiredIds = {11580}}, 
		},
		[60] = {
			{id = 25289, cost = 65000, requiredIds = {11551}}, 
			{id = 20569, cost = 62000, requiredIds = {11609}}, 
			{id = 30016, cost = 3100, requiredIds = {20243}, requiredTalentId = 20243}, 
			{id = 25286, cost = 60000, requiredIds = {11567}}, 
			{id = 21553, cost = 3100, requiredIds = {21552}, requiredTalentId = 12294}, 
			{id = 11574, cost = 62000, requiredIds = {11573}}, 
			{id = 25288, cost = 60000, requiredIds = {11601}}, 
			{id = 23925, cost = 62000, requiredIds = {23924}}, 
		},
		[61] = {
			{id = 25241, cost = 65000, requiredIds = {11605}}, 
		},
		[62] = {
			{id = 25202, cost = 65000, requiredIds = {11556}}, 
		},
		[63] = {
			{id = 25269, cost = 65000, requiredIds = {25288}}, 
		},
		[64] = {
			{id = 23920, cost = 65000}, 
		},
		[65] = {
			{id = 25234, cost = 65000, requiredIds = {20662}}, 
		},
		[66] = {
			{id = 29707, cost = 65000, requiredIds = {25286}}, 
			{id = 25248, cost = 3250, requiredIds = {21553}, requiredTalentId = 12294}, 
			{id = 25258, cost = 65000, requiredIds = {23925}}, 
		},
		[67] = {
			{id = 25264, cost = 65000, requiredIds = {11581}}, 
		},
		[68] = {
			{id = 25231, cost = 65000, requiredIds = {20569}}, 
			{id = 469, cost = 65000}, 
			{id = 25208, cost = 65000, requiredIds = {11574}}, 
		},
		[69] = {
			{id = 2048, cost = 71000, requiredIds = {25289}}, 
			{id = 25242, cost = 71000, requiredIds = {25241}}, 
		},
		[70] = {
			{id = 25203, cost = 71000, requiredIds = {25202}}, 
			{id = 30022, cost = 3250, requiredIds = {30016}, requiredTalentId = 20243}, 
			{id = 25236, cost = 71000, requiredIds = {25234}}, 
			{id = 30324, cost = 100000, requiredIds = {29707}}, 
			{id = 3411, cost = 65000}, 
			{id = 30330, cost = 3500, requiredIds = {25248}, requiredTalentId = 12294}, 
			{id = 30357, cost = 260000, requiredIds = {25269}}, 
			{id = 30356, cost = 71000, requiredIds = {25258}}, 
		},
		[71] = {
			{id = 46845, cost = 260000, requiredIds = {25208}}, 
			{id = 64382, cost = 260000}, 
		},
		[72] = {
			{id = 47519, cost = 260000, requiredIds = {25231}}, 
			{id = 47449, cost = 260000, requiredIds = {30324}}, 
		},
		[73] = {
			{id = 47470, cost = 260000, requiredIds = {25236}}, 
			{id = 47501, cost = 260000, requiredIds = {25264}}, 
		},
		[74] = {
			{id = 47439, cost = 100000, requiredIds = {469}}, 
			{id = 47474, cost = 260000, requiredIds = {25242}}, 
		},
		[75] = {
			{id = 47497, cost = 5000, requiredIds = {30022}, requiredTalentId = 20243}, 
			{id = 55694, cost = 100000}, 
			{id = 47485, cost = 13000, requiredIds = {30330}, requiredTalentId = 12294}, 
			{id = 47487, cost = 260000, requiredIds = {30356}}, 
		},
		[76] = {
			{id = 47450, cost = 260000, requiredIds = {47449}}, 
			{id = 47465, cost = 260000, requiredIds = {46845}}, 
		},
		[77] = {
			{id = 47520, cost = 260000, requiredIds = {47519}}, 
		},
		[78] = {
			{id = 47436, cost = 260000, requiredIds = {2048}}, 
			{id = 47502, cost = 26000, requiredIds = {47501}}, 
		},
		[79] = {
			{id = 47437, cost = 260000, requiredIds = {25203}}, 
			{id = 47475, cost = 260000, requiredIds = {47474}}, 
		},
		[80] = {
			{id = 47440, cost = 260000, requiredIds = {47439}}, 
			{id = 47498, cost = 5000, requiredIds = {47497}, requiredTalentId = 20243}, 
			{id = 47471, cost = 260000, requiredIds = {47470}}, 
			{id = 57755, cost = 100000}, 
			{id = 47485, cost = 13000, requiredIds = {47485}, requiredTalentId = 12294}, 
			{id = 57823, cost = 260000, requiredIds = {30357}}, 
			{id = 47488, cost = 260000, requiredIds = {47487}}, 
		},
	},
}

FatCooldowns.HunterSpells = {
	[0] = { 
		[1] = {
			{id = 1494, cost = 10}
		},
		[4] = {
			{id = 13163, cost = 100},
			{id = 1978, cost = 100}
		},
		[6] = {
			{id = 3044, cost = 100},
			{id = 1130, cost = 100}
		},
		[8] = {
			{id = 5116, cost = 200},
			{id = 3127, cost = 200},
			{id = 14260, cost = 200}
		},
		[10] = {
			{id = 13165, cost = 400},
			{id = 13549, cost = 400, requiredIds = {1978}},
			{id = 19883, cost = 400}
		},
		[12] = {
			{id = 14281, cost = 600, requiredIds = {3044}},
			{id = 20736, cost = 600},
			{id = 136, cost = 600, requiredIds = {1515}},
			{id = 2974, cost = 600}
		},
		[14] = {
			{id = 6197, cost = 1200},
			{id = 1002, cost = 1200},
			{id = 1513, cost = 1200}
		},
		[16] = {
			{id = 13795, cost = 1800},
			{id = 1495, cost = 1800},
			{id = 14261, cost = 1800, requiredIds = {14260}}
		},
		[18] = {
			{id = 14318, cost = 2000, requiredIds = {13165}},
			{id = 2643, cost = 2000},
			{id = 13550, cost = 2000, requiredIds = {13549}},
			{id = 19884, cost = 2000}
		},
		[20] = {
			{id = 14282, cost = 2200, requiredIds = {14281}},
			{id = 5118, cost = 2200},
			{id = 781, cost = 2200},
			{id = 14274, cost = 2200, requiredIds = {20736}},
			{id = 674, cost = 2200},
			{id = 1499, cost = 2200},
			{id = 3111, cost = 2200, requiredIds = {136}},
		},
		[22] = {
			{id = 14323, cost = 6000, requiredIds = {1130}},
			{id = 3043, cost = 6000}
		},
		[24] = {
			{id = 1462, cost = 7000},
			{id = 14262, cost = 7000, requiredIds = {14261}},
			{id = 19885, cost = 7000}
		},
		[26] = {
			{id = 14302, cost = 7000, requiredIds = {13795}},
			{id = 3045, cost = 7000},
			{id = 13551, cost = 7000, requiredIds = {13550}},
			{id = 19880, cost = 7000}
		},
		[28] = {
			{id = 20900, cost = 400, requiredIds = {19434}, requiredTalentId = 19434},
			{id = 14283, cost = 8000, requiredIds = {14282}},
			{id = 14319, cost = 8000, requiredIds = {14318}},
			{id = 13809, cost = 8000},
			{id = 3661, cost = 8000, requiredIds = {3111}}
		},
		[30] = {
			{id = 13161, cost = 8000},
			{id = 15629, cost = 8000, requiredIds = {14274}},
			{id = 5384, cost = 8000},
			{id = 14269, cost = 8000, requiredIds = {1495}},
			{id = 14288, cost = 8000, requiredIds = {2643}},
			{id = 14326, cost = 8000, requiredIds = {1513}},
		},
		[32] = {
			{id = 1543, cost = 10000},
			{id = 14263, cost = 10000, requiredIds = {14262}},
			{id = 14275, cost = 10000, requiredIds = {3043}},
			{id = 19878, cost = 10000}
		},
		[34] = {
			{id = 14272, cost = 12000, requiredIds = {781}},
			{id = 13813, cost = 12000},
			{id = 13552, cost = 12000, requiredIds = {13551}}
		},
		[36] = {
			{id = 20901, cost = 700, requiredIds = {20900}, requiredTalentId = 19434},
			{id = 14284, cost = 14000, requiredIds = {14283}},
			{id = 14303, cost = 14000, requiredIds = {14302}},
			{id = 3662, cost = 14000, requiredIds = {3661}},
			{id = 3034, cost = 14000}
		},
		[38] = {
			{id = 14320, cost = 16000, requiredIds = {14319}},
			{id = 14267, cost = 16000, requiredIds = {2974}}
		},
		[40] = {
			{id = 13159, cost = 18000},
			{id = 15630, cost = 18000, requiredIds = {15629}},
			{id = 14310, cost = 18000, requiredIds = {1499}},
			{id = 14324, cost = 18000, requiredIds = {14323}},
			{id = 14264, cost = 18000, requiredIds = {14263}},
			{id = 19882, cost = 18000},
			{id = 1510, cost = 18000},
			{id = 1510, cost = 18000}
		},
		[42] = {
			{id = 20909, cost = 1200, requiredIds = {19306}, requiredTalentId = 19306},
			{id = 14289, cost = 24000, requiredIds = {14288}},
			{id = 14276, cost = 24000, requiredIds = {14275}},
			{id = 13553, cost = 24000, requiredIds = {13552}}
		},
		[44] = {
			{id = 20902, cost = 1300, requiredIds = {20901}, requiredTalentId = 19434},
			{id = 14285, cost = 26000, requiredIds = {14284}},
			{id = 14316, cost = 26000, requiredIds = {13813}},
			{id = 13542, cost = 26000, requiredIds = {3662}},
			{id = 14270, cost = 26000, requiredIds = {14269}}
		},
		[46] = {
			{id = 20043, cost = 28000},
			{id = 14304, cost = 28000, requiredIds = {14303}},
			{id = 14327, cost = 28000, requiredIds = {14326}},
			{id = 14279, cost = 28000, requiredIds = {3034}}
		},
		[48] = {
			{id = 14321, cost = 32000, requiredIds = {14320}},
			{id = 14273, cost = 32000, requiredIds = {14272}},
			{id = 14265, cost = 32000, requiredIds = {14264}}
		},
		[50] = {
			{id = 15631, cost = 36000, requiredIds = {15630}},
			{id = 13554, cost = 36000, requiredIds = {13553}},
			{id = 19879, cost = 36000},
			{id = 20905, cost = 1800, requiredIds = {19506}, requiredTalentId = 19506},
			{id = 14294, cost = 36000, requiredIds = {1510}},
			{id = 24132, cost = 1800, requiredIds = {19386}, requiredTalentId = 19386}
		},
		[52] = {
			{id = 20903, cost = 2000, requiredIds = {20902}, requiredTalentId = 19434},
			{id = 14286, cost = 40000, requiredIds = {14285}},
			{id = 13543, cost = 40000, requiredIds = {13542}},
			{id = 14277, cost = 40000, requiredIds = {14276}}
		},
		[54] = {
			{id = 20910, cost = 2100, requiredIds = {20909}, requiredTalentId = 19306},
			{id = 14317, cost = 42000, requiredIds = {14316}},
			{id = 14290, cost = 42000, requiredIds = {14289}},
		},
		[56] = {
			{id = 20190, cost = 46000, requiredIds = {20043}},
			{id = 14305, cost = 46000, requiredIds = {14304}},
			{id = 14266, cost = 46000, requiredIds = {14265}},
			{id = 14280, cost = 46000, requiredIds = {14279}}
		},
		[58] = {
			{id = 14322, cost = 48000, requiredIds = {14321}},
			{id = 14325, cost = 48000, requiredIds = {14324}},
			{id = 14271, cost = 48000, requiredIds = {14270}},
			{id = 13555, cost = 48000, requiredIds = {13554}},
			{id = 14295, cost = 48000, requiredIds = {14294}}
		},
		[60] = {
			{id = 20904, cost = 2500, requiredIds = {20903}, requiredTalentId = 19434},
			{id = 14287, cost = 50000, requiredIds = {14286}},
			{id = 15632, cost = 50000, requiredIds = {15631}},
			{id = 14311, cost = 50000, requiredIds = {14310}},
			{id = 13544, cost = 50000, requiredIds = {13543}},
			{id = 20906, cost = 2500, requiredIds = {20905}, requiredTalentId = 19506},
			{id = 14268, cost = 50000, requiredIds = {14267}},
			{id = 24133, cost = 2500, requiredIds = {24132}, requiredTalentId = 19386}
		},
	},
	[1] = { 
		[1] = {
			{id = 1494, cost = 10},
		},
		[4] = {
			{id = 13163, cost = 100},
			{id = 1978, cost = 100},
		},
		[6] = {
			{id = 3044, cost = 100},
			{id = 1130, cost = 100},
		},
		[8] = {
			{id = 3127, cost = 200},
			{id = 5116, cost = 200},
			{id = 14260, cost = 200},
		},
		[10] = {
			{id = 13165, cost = 400},
			{id = 13549, cost = 400, requiredIds = {1978}},
			{id = 19883, cost = 400},
		},
		[12] = {
			{id = 136, cost = 600, requiredIds = {1515}},
			{id = 14281, cost = 600, requiredIds = {3044}},
			{id = 20736, cost = 600},
			{id = 2974, cost = 600},
		},
		[14] = {
			{id = 6197, cost = 1200},
			{id = 1002, cost = 1200},
			{id = 1513, cost = 1200},
		},
		[16] = {
			{id = 13795, cost = 1800},
			{id = 1495, cost = 1800},
			{id = 14261, cost = 1800, requiredIds = {14260}},
		},
		[18] = {
			{id = 14318, cost = 2000, requiredIds = {13165}},
			{id = 2643, cost = 2000},
			{id = 13550, cost = 2000, requiredIds = {13549}},
			{id = 19884, cost = 2000},
		},
		[20] = {
			{id = 5118, cost = 2200},
			{id = 3111, cost = 2200, requiredIds = {136}},
			{id = 674, cost = 2200},
			{id = 14282, cost = 2200, requiredIds = {14281}},
			{id = 14274, cost = 2200, requiredIds = {20736}},
			{id = 781, cost = 2200},
			{id = 1499, cost = 2200},
		},
		[22] = {
			{id = 14323, cost = 6000, requiredIds = {1130}},
			{id = 3043, cost = 6000},
		},
		[24] = {
			{id = 1462, cost = 7000},
			{id = 14262, cost = 7000, requiredIds = {14261}},
			{id = 19885, cost = 7000},
		},
		[26] = {
			{id = 3045, cost = 7000},
			{id = 13551, cost = 7000, requiredIds = {13550}},
			{id = 14302, cost = 7000, requiredIds = {13795}},
			{id = 19880, cost = 7000},
		},
		[28] = {
			{id = 14319, cost = 8000, requiredIds = {14318}},
			{id = 3661, cost = 8000, requiredIds = {3111}},
			{id = 20900, cost = 400, requiredIds = {19434}, requiredTalentId = 19434},
			{id = 14283, cost = 8000, requiredIds = {14282}},
			{id = 13809, cost = 8000},
		},
		[30] = {
			{id = 13161, cost = 8000},
			{id = 14326, cost = 8000, requiredIds = {1513}},
			{id = 15629, cost = 8000, requiredIds = {14274}},
			{id = 14288, cost = 8000, requiredIds = {2643}},
			{id = 5384, cost = 8000},
			{id = 14269, cost = 8000, requiredIds = {1495}},
		},
		[32] = {
			{id = 1543, cost = 10000},
			{id = 14263, cost = 10000, requiredIds = {14262}},
			{id = 19878, cost = 10000},
		},
		[34] = {
			{id = 13552, cost = 12000, requiredIds = {13551}},
			{id = 14272, cost = 12000, requiredIds = {781}},
			{id = 13813, cost = 12000},
		},
		[36] = {
			{id = 3662, cost = 14000, requiredIds = {3661}},
			{id = 20901, cost = 700, requiredIds = {20900}, requiredTalentId = 19434},
			{id = 14284, cost = 14000, requiredIds = {14283}},
			{id = 3034, cost = 14000},
			{id = 14303, cost = 14000, requiredIds = {14302}},
		},
		[38] = {
			{id = 14320, cost = 16000, requiredIds = {14319}},
			{id = 14267, cost = 16000, requiredIds = {2974}},
		},
		[40] = {
			{id = 13159, cost = 18000},
			{id = 15630, cost = 18000, requiredIds = {15629}},
			{id = 14324, cost = 18000, requiredIds = {14323}},
			{id = 1510, cost = 18000},
			{id = 14310, cost = 18000, requiredIds = {1499}},
			{id = 14264, cost = 18000, requiredIds = {14263}},
			{id = 19882, cost = 18000},
		},
		[42] = {
			{id = 14289, cost = 24000, requiredIds = {14288}},
			{id = 13553, cost = 24000, requiredIds = {13552}},
			{id = 20909, cost = 1200, requiredIds = {19306}, requiredTalentId = 19306},
		},
		[44] = {
			{id = 13542, cost = 26000, requiredIds = {3662}},
			{id = 20902, cost = 1300, requiredIds = {20901}, requiredTalentId = 19434},
			{id = 14285, cost = 26000, requiredIds = {14284}},
			{id = 14316, cost = 26000, requiredIds = {13813}},
			{id = 14270, cost = 26000, requiredIds = {14269}},
		},
		[46] = {
			{id = 20043, cost = 28000},
			{id = 14327, cost = 28000, requiredIds = {14326}},
			{id = 14279, cost = 28000, requiredIds = {3034}},
			{id = 14304, cost = 28000, requiredIds = {14303}},
		},
		[48] = {
			{id = 14321, cost = 32000, requiredIds = {14320}},
			{id = 14273, cost = 32000, requiredIds = {14272}},
			{id = 14265, cost = 32000, requiredIds = {14264}},
		},
		[50] = {
			{id = 15631, cost = 36000, requiredIds = {15630}},
			{id = 13554, cost = 36000, requiredIds = {13553}},
			{id = 20905, cost = 1800, requiredIds = {19506}, requiredTalentId = 19506},
			{id = 14294, cost = 36000, requiredIds = {1510}},
			{id = 19879, cost = 36000},
			{id = 24132, cost = 1800, requiredIds = {19386}, requiredTalentId = 19386},
		},
		[52] = {
			{id = 13543, cost = 40000, requiredIds = {13542}},
			{id = 20903, cost = 2000, requiredIds = {20902}, requiredTalentId = 19434},
			{id = 14286, cost = 40000, requiredIds = {14285}},
		},
		[54] = {
			{id = 14290, cost = 42000, requiredIds = {14289}},
			{id = 20910, cost = 2100, requiredIds = {20909}, requiredTalentId = 19306},
			{id = 14317, cost = 42000, requiredIds = {14316}},
		},
		[56] = {
			{id = 20190, cost = 46000, requiredIds = {20043}},
			{id = 14280, cost = 46000, requiredIds = {14279}},
			{id = 14305, cost = 46000, requiredIds = {14304}},
			{id = 14266, cost = 46000, requiredIds = {14265}},
		},
		[58] = {
			{id = 14322, cost = 48000, requiredIds = {14321}},
			{id = 14325, cost = 48000, requiredIds = {14324}},
			{id = 13555, cost = 48000, requiredIds = {13554}},
			{id = 14295, cost = 48000, requiredIds = {14294}},
			{id = 14271, cost = 48000, requiredIds = {14270}},
		},
		[60] = {
			{id = 25296, cost = 50000, requiredIds = {14322}},
			{id = 13544, cost = 50000, requiredIds = {13543}},
			{id = 20904, cost = 2500, requiredIds = {20903}, requiredTalentId = 19434},
			{id = 14287, cost = 50000, requiredIds = {14286}},
			{id = 15632, cost = 50000, requiredIds = {15631}},
			{id = 25294, cost = 50000, requiredIds = {14290}},
			{id = 25295, cost = 50000, requiredIds = {13555}},
			{id = 19801, cost = 50000},
			{id = 20906, cost = 2500, requiredIds = {20905}, requiredTalentId = 19506},
			{id = 14311, cost = 50000, requiredIds = {14310}},
			{id = 14268, cost = 50000, requiredIds = {14267}},
			{id = 24133, cost = 2500, requiredIds = {24132}, requiredTalentId = 19386},
		},
		[61] = {
			{id = 27025, cost = 68000, requiredIds = {14317}},
		},
		[62] = {
			{id = 34120, cost = 77000},
			{id = 27015, cost = 77000, requiredIds = {14273}},
		},
		[63] = {
			{id = 27014, cost = 87000, requiredIds = {14266}},
		},
		[64] = {
			{id = 34074, cost = 100000},
		},
		[65] = {
			{id = 27023, cost = 110000, requiredIds = {14305}},
		},
		[66] = {
			{id = 34026, cost = 120000},
			{id = 27018, cost = 120000, requiredIds = {14280}},
			{id = 27067, cost = 2500, requiredIds = {20910}, requiredTalentId = 19306},
		},
		[67] = {
			{id = 27021, cost = 140000, requiredIds = {25294}},
			{id = 27016, cost = 140000, requiredIds = {25295}},
			{id = 27022, cost = 140000, requiredIds = {14295}},
		},
		[68] = {
			{id = 27044, cost = 150000, requiredIds = {25296}},
			{id = 27045, cost = 150000, requiredIds = {20190}},
			{id = 27046, cost = 150000, requiredIds = {13544}},
			{id = 34600, cost = 150000},
		},
		[69] = {
			{id = 27019, cost = 170000, requiredIds = {14287}},
			{id = 27020, cost = 170000, requiredIds = {15632}},
		},
		[70] = {
			{id = 27065, cost = 2700, requiredIds = {20904}, requiredTalentId = 19434},
			{id = 27066, cost = 2700, requiredIds = {20906}, requiredTalentId = 19506},
			{id = 34477, cost = 190000},
			{id = 36916, cost = 190000, requiredIds = {14271}},
			{id = 27068, cost = 2700, requiredIds = {24133}, requiredTalentId = 19386},
		},
	},
	[2] = { 
		[1] = {
			{id =1494, cost = 10},
		},
		[4] = {
			{id = 13163, cost =100},
			{id =1978, cost =100},
		},
		[6] = {
			{id =3044, cost =100},
			{id =1130, cost =100},
		},
		[8] = {
			{id =5116, cost =200},
			{id =3127, cost =200},
			{id = 14260, cost =200, requiredIds = {2973}},
		},
		[10] ={
			{id = 13165, cost =400},
			{id = 13549, cost =400, requiredIds = {1978}},
			{id = 19883, cost =400},
		},
		[12] ={
			{id = 14281, cost =600, requiredIds = {3044}},
			{id = 20736, cost =600},
			{id = 136, cost =600, requiredIds = {1515}},
			{id =2974, cost =600},
		},
		[14] ={
			{id =6197, cost = 1200},
			{id =1002, cost = 1200},
			{id =1513, cost = 1200},
		},
		[16] ={
			{id =5118, cost = 2200},
			{id = 13795, cost = 1800},
			{id =1495, cost = 1800},
			{id = 14261, cost = 1800, requiredIds = {14260}}, 
		},
		[18] ={
			{id = 14318, cost = 2000, requiredIds = {13165}}, 
			{id =2643, cost = 2000},
			{id = 13550, cost = 2000, requiredIds = {13549}}, 
			{id = 19884, cost = 2000},
		},
		[20] ={
			{id = 14282, cost = 2200, requiredIds = {14281}}, 
			{id = 34074, cost = 2200},
			{id = 781, cost = 2200},
			{id =1499, cost = 2200},
			{id =3111, cost = 2200, requiredIds = {136}}, 
			{id = 674, cost = 2200},
		},
		[22] ={
			{id = 14323, cost = 6000, requiredIds = {1130}},
			{id =3043, cost = 6000},
		},
		[24] ={
			{id =1462, cost = 7000},
			{id = 14262, cost = 7000, requiredIds = {14261}}, 
			{id = 19885, cost = 7000},
		},
		[26] ={
			{id = 14302, cost = 7000, requiredIds = {13795}}, 
			{id =3045, cost = 7000},
			{id = 13551, cost = 7000, requiredIds = {13550}}, 
			{id = 19880, cost = 7000},
		},
		[28] ={
			{id = 20900, cost =400, requiredIds = {19434}, requiredTalentId = 19434}, 
			{id = 14283, cost = 8000, requiredIds = {14282}}, 
			{id = 14319, cost = 8000, requiredIds = {14318}}, 
			{id = 13809, cost = 8000},
			{id =3661, cost = 8000, requiredIds = {3111}},
		},
		[30] ={
			{id = 13161, cost = 8000},
			{id =5384, cost = 8000},
			{id = 14269, cost = 8000, requiredIds = {1495}},
			{id = 14288, cost = 8000, requiredIds = {2643}},
			{id = 14326, cost = 8000, requiredIds = {1513}},
		},
		[32] ={
			{id =1543, cost =10000},
			{id = 14263, cost =10000, requiredIds = {14262}}, 
			{id = 19878, cost =10000},
		},
		[34] ={
			{id = 13813, cost =12000},
			{id = 13552, cost =12000, requiredIds = {13551}}, 
		},
		[36] ={
			{id = 20901, cost =700, requiredIds = {20900}, requiredTalentId = 19434}, 
			{id = 14284, cost =14000, requiredIds = {14283}}, 
			{id = 14303, cost =14000, requiredIds = {14302}}, 
			{id =3662, cost =14000, requiredIds = {3661}},
			{id =3034, cost =14000},
		},
		[38] ={
			{id = 14320, cost =16000, requiredIds = {14319}}, 
		},
		[40] ={
			{id = 13159, cost =18000},
			{id = 14310, cost =18000, requiredIds = {1499}},
			{id = 14324, cost =18000, requiredIds = {14323}}, 
			{id = 14264, cost =18000, requiredIds = {14263}}, 
			{id = 19882, cost =18000},
			{id =1510, cost =18000},
		},
		[42] ={
			{id = 20909, cost = 1200, requiredIds = {19306}, requiredTalentId = 19306}, 
			{id = 14289, cost =24000, requiredIds = {14288}}, 
			{id = 13553, cost =24000, requiredIds = {13552}}, 
		},
		[44] ={
			{id = 20902, cost = 1300, requiredIds = {20901}, requiredTalentId = 19434}, 
			{id = 14285, cost =26000, requiredIds = {14284}}, 
			{id = 14316, cost =26000, requiredIds = {13813}}, 
			{id = 13542, cost =26000, requiredIds = {3662}},
			{id = 14270, cost =26000, requiredIds = {14269}}, 
		},
		[46] ={
			{id = 20043, cost =28000},
			{id = 14304, cost =28000, requiredIds = {14303}}, 
			{id = 14327, cost =28000, requiredIds = {14326}}, 
		},
		[48] ={
			{id = 14321, cost =32000, requiredIds = {14320}}, 
			{id = 14265, cost =32000, requiredIds = {14264}}, 
		},
		[50] ={
			{id = 13554, cost =36000, requiredIds = {13553}}, 
			{id = 56641, cost =36000},
			{id = 19879, cost =36000},
			{id = 14294, cost =36000, requiredIds = {1510}},
			{id = 24132, cost = 1800, requiredIds = {19386}, requiredTalentId = 19386}, 
		},
		[52] ={
			{id = 20903, cost = 2000, requiredIds = {20902}, requiredTalentId = 19434}, 
			{id = 14286, cost =40000, requiredIds = {14285}}, 
			{id = 13543, cost =40000, requiredIds = {13542}}, 
		},
		[54] ={
			{id = 20910, cost = 2100, requiredIds = {20909}, requiredTalentId = 19306}, 
			{id = 14317, cost =42000, requiredIds = {14316}}, 
			{id = 14290, cost =42000, requiredIds = {14289}}, 
		},
		[56] ={
			{id = 20190, cost =46000, requiredIds = {20043}}, 
			{id = 14305, cost =46000, requiredIds = {14304}}, 
			{id = 14266, cost =46000, requiredIds = {14265}}, 
		},
		[57] ={
			{id = 63668, cost = 1800, requiredIds = {3674}, requiredTalentId = 3674}, 
		},
		[58] ={
			{id = 14322, cost =48000, requiredIds = {14321}}, 
			{id = 14325, cost =48000, requiredIds = {14324}}, 
			{id = 14271, cost =48000, requiredIds = {14270}}, 
			{id = 13555, cost =48000, requiredIds = {13554}}, 
			{id = 14295, cost =48000, requiredIds = {14294}}, 
		},
		[60] ={
			{id = 20904, cost = 2500, requiredIds = {20903}, requiredTalentId = 19434}, 
			{id = 14287, cost =50000, requiredIds = {14286}}, 
			{id = 25296, cost =50000, requiredIds = {14322}}, 
			{id = 19263, cost = 2200},
			{id = 14311, cost =50000, requiredIds = {14310}}, 
			{id = 13544, cost =50000, requiredIds = {13543}}, 
			{id = 25294, cost =50000, requiredIds = {14290}}, 
			{id = 25295, cost =50000, requiredIds = {13555}}, 
			{id = 19801, cost =50000},
			{id = 24133, cost = 2500, requiredIds = {24132}, requiredTalentId = 19386}, 
		},
		[61] ={
			{id = 27025, cost =68000, requiredIds = {14317}}, 
		},
		[62] ={
			{id = 34120, cost =70000, requiredIds = {56641}}, 
		},
		[63] ={
			{id = 63668, cost = 1800, requiredIds = {63668}, requiredTalentId = 3674},
			{id = 27014, cost =87000, requiredIds = {14266}}, 
		},
		[65] ={
			{id = 27023, cost = 110000, requiredIds = {14305}}, 
		},
		[66] ={
			{id = 27067, cost = 2500, requiredIds = {20910}, requiredTalentId = 19306}, 
			{id = 34026, cost = 120000},
		},
		[67] ={
			{id = 27021, cost = 140000, requiredIds = {25294}}, 
			{id = 27016, cost = 140000, requiredIds = {25295}}, 
			{id = 27022, cost = 140000, requiredIds = {14295}}, 
		},
		[68] ={
			{id = 27044, cost = 150000, requiredIds = {25296}}, 
			{id = 27045, cost = 150000, requiredIds = {20190}}, 
			{id = 27046, cost = 150000, requiredIds = {13544}}, 
			{id = 34600, cost = 150000},
		},
		[69] ={
			{id = 27019, cost = 170000, requiredIds = {14287}}, 
			{id = 63670, cost =10000, requiredIds = {63668}, requiredTalentId = 3674},
		},
		[70] ={
			{id = 27065, cost =10000, requiredIds = {20904}, requiredTalentId = 19434}, 
			{id = 60051, cost =400, requiredIds = {53301}, requiredTalentId = 53301}, 
			{id = 34477, cost = 190000},
			{id = 36916, cost = 190000, requiredIds = {14271}}, 
			{id = 27068, cost = 5000, requiredIds = {24133}, requiredTalentId = 19386}, 
		},
		[71] ={
			{id = 49066, cost = 300000, requiredIds = {27025}}, 
			{id = 53351, cost = 300000},
			{id = 48995, cost = 300000, requiredIds = {27014}}, 
			{id = 49051, cost = 300000, requiredIds = {34120}}, 
		},
		[72] ={
			{id = 48998, cost =15000, requiredIds = {27067}, requiredTalentId = 19306}, 
			{id = 49055, cost = 300000, requiredIds = {27023}}, 
		},
		[73] ={
			{id = 49044, cost = 300000, requiredIds = {27019}}, 
			{id = 49000, cost = 300000, requiredIds = {27016}}, 
		},
		[74] ={
			{id = 61846, cost = 300000, requiredIds = {27044}}, 
			{id = 48989, cost = 300000, requiredIds = {27046}}, 
			{id = 49047, cost = 300000, requiredIds = {27021}}, 
			{id = 58431, cost = 300000, requiredIds = {27022}}, 
		},
		[75] ={
			{id = 49049, cost =10000, requiredIds = {27065}, requiredTalentId = 19434}, 
			{id = 63671, cost =10000, requiredIds = {63670}, requiredTalentId = 3674},
			{id = 60052, cost =400, requiredIds = {60051}, requiredTalentId = 53301}, 
			{id = 61005, cost = 300000, requiredIds = {53351}}, 
			{id = 53271, cost =10000},
			{id = 49011, cost = 100000, requiredIds = {27068}, requiredTalentId = 19386}, 
		},
		[76] ={
			{id = 49071, cost = 300000, requiredIds = {27045}}, 
			{id = 53338, cost =10000, requiredIds = {14325}}, 
		},
		[77] ={
			{id = 49067, cost = 300000, requiredIds = {49066}}, 
			{id = 48996, cost = 300000, requiredIds = {48995}}, 
			{id = 49052, cost = 300000, requiredIds = {49051}}, 
		},
		[78] ={
			{id = 48999, cost =15000, requiredIds = {48998}, requiredTalentId = 19306}, 
			{id = 49056, cost = 300000, requiredIds = {49055}}, 
		},
		[79] ={
			{id = 49045, cost = 300000, requiredIds = {49044}}, 
			{id = 49001, cost = 300000, requiredIds = {49000}}, 
		},
		[80] ={
			{id = 49050, cost =10000, requiredIds = {49049}, requiredTalentId = 19434}, 
			{id = 61847, cost = 300000, requiredIds = {61846}}, 
			{id = 63672, cost =10000, requiredIds = {63671}, requiredTalentId = 3674},
			{id = 62757, cost = 300000},
			{id = 60053, cost = 100000, requiredIds = {60052}, requiredTalentId = 53301}, 
			{id = 60192, cost = 100000},
			{id = 61006, cost = 300000, requiredIds = {61005}}, 
			{id = 48990, cost = 300000, requiredIds = {48989}}, 
			{id = 53339, cost = 300000, requiredIds = {36916}}, 
			{id = 49048, cost = 300000, requiredIds = {49047}}, 
			{id = 58434, cost = 300000, requiredIds = {58431}}, 
			{id = 49012, cost = 100000, requiredIds = {49011}, requiredTalentId = 19386}, 
		},
	},
}

FatCooldowns.WarlockSpells = {
	[0] = { 
		[1] = {
			{id = 348, cost = 10}
		},
		[4] = {
			{id = 172, cost = 100},
			{id = 702, cost = 100}
		},
		[6] = {
			{id = 1454, cost = 100},
			{id = 695, cost = 100, requiredIds = {686}}
		},
		[8] = {
			{id = 980, cost = 200},
			{id = 5782, cost = 200}
		},
		[10] = {
			{id = 6201, cost = 300, requiredIds = {1120}},
			{id = 696, cost = 300, requiredIds = {687}},
			{id = 1120, cost = 300},
			{id = 707, cost = 300, requiredIds = {348}}
		},
		[12] = {
			{id = 1108, cost = 600, requiredIds = {702}},
			{id = 755, cost = 600},
			{id = 705, cost = 600, requiredIds = {695}}
		},
		[14] = {
			{id = 6222, cost = 900, requiredIds = {172}},
			{id = 704, cost = 900},
			{id = 689, cost = 900}
		},
		[16] = {
			{id = 1455, cost = 1200, requiredIds = {1454}},
			{id = 5697, cost = 1200}
		},
		[18] = {
			{id = 693, cost = 1500, requiredIds = {1120}},
			{id = 1014, cost = 1500, requiredIds = {980}},
			{id = 5676, cost = 1500}
		},
		[20] = {
			{id = 706, cost = 2000},
			{id = 3698, cost = 2000, requiredIds = {755}},
			{id = 1094, cost = 2000, requiredIds = {707}},
			{id = 5740, cost = 2000},
			{id = 698, cost = 2000},
			{id = 1088, cost = 2000, requiredIds = {705}}
		},
		[22] = {
			{id = 6202, cost = 2500, requiredIds = {6201}},
			{id = 6205, cost = 2500, requiredIds = {1108}},
			{id = 699, cost = 2500, requiredIds = {689}},
			{id = 126, cost = 2500}
		},
		[24] = {
			{id = 6223, cost = 3000, requiredIds = {6222}},
			{id = 5138, cost = 3000},
			{id = 8288, cost = 3000, requiredIds = {1120}},
			{id = 5500, cost = 3000},
			{id = 18867, cost = 150, requiredTalentId = 17877}
		},
		[26] = {
			{id = 1714, cost = 4000},
			{id = 132, cost = 4000},
			{id = 1456, cost = 4000, requiredIds = {1455}},
			{id = 17919, cost = 4000, requiredIds = {5676}}
		},
		[28] = {
			{id = 710, cost = 5000},
			{id = 6366, cost = 5000},
			{id = 6217, cost = 5000, requiredIds = {1014}},
			{id = 7658, cost = 5000, requiredIds = {704}},
			{id = 3699, cost = 5000, requiredIds = {3698}},
			{id = 1106, cost = 5000, requiredIds = {1088}}
		},
		[30] = {
			{id = 20752, cost = 6000, requiredIds = {693}},
			{id = 1086, cost = 6000, requiredIds = {706}},
			{id = 709, cost = 6000, requiredIds = {699}},
			{id = 1098, cost = 6000},
			{id = 1949, cost = 6000},
			{id = 2941, cost = 6000, requiredIds = {1094}}
		},
		[32] = {
			{id = 7646, cost = 7000, requiredIds = {6205}},
			{id = 1490, cost = 7000},
			{id = 6213, cost = 7000, requiredIds = {5782}},
			{id = 6229, cost = 7000},
			{id = 18868, cost = 350, requiredIds = {18867}, requiredTalentId = 17877}
		},
		[34] = {
			{id = 7648, cost = 8000, requiredIds = {6223}},
			{id = 5699, cost = 8000, requiredIds = {6202}},
			{id = 6226, cost = 8000, requiredIds = {5138}},
			{id = 6219, cost = 8000, requiredIds = {5740}},
			{id = 17920, cost = 8000, requiredIds = {17919}}
		},
		[36] = {
			{id = 17951, cost = 9000, requiredIds = {6366}},
			{id = 2362, cost = 9000, requiredIds = {1120}},
			{id = 3700, cost = 9000, requiredIds = {3699}},
			{id = 11687, cost = 9000, requiredIds = {1456}},
			{id = 7641, cost = 9000, requiredIds = {1106}}
		},
		[38] = {
			{id = 11711, cost = 10000, requiredIds = {6217}},
			{id = 2970, cost = 10000, requiredIds = {132}},
			{id = 7651, cost = 10000, requiredIds = {709}},
			{id = 8289, cost = 10000, requiredIds = {8288}},
			{id = 18879, cost = 500, requiredTalentId = 18265}
		},
		[40] = {
			{id = 20755, cost = 11000, requiredIds = {20752}},
			{id = 11733, cost = 11000, requiredIds = {1086}},
			{id = 5484, cost = 11000},
			{id = 11665, cost = 11000, requiredIds = {2941}},
			{id = 18869, cost = 550, requiredIds = {18868}, requiredTalentId = 17877}
		},
		[42] = {
			{id = 7659, cost = 11000, requiredIds = {7658}},
			{id = 11707, cost = 11000, requiredIds = {7646}},
			{id = 6789, cost = 11000},
			{id = 11683, cost = 9900, requiredIds = {1949}},
			{id = 17921, cost = 11000, requiredIds = {17920}},
			{id = 11739, cost = 11000, requiredIds = {6229}}
		},
		[44] = {
			{id = 11671, cost = 12000, requiredIds = {7648}},
			{id = 17862, cost = 12000},
			{id = 11703, cost = 12000, requiredIds = {6226}},
			{id = 11725, cost = 12000, requiredIds = {1098}},
			{id = 11693, cost = 12000, requiredIds = {3700}},
			{id = 11659, cost = 12000, requiredIds = {7641}}
		},
		[46] = {
			{id = 17952, cost = 13000, requiredIds = {17951}},
			{id = 11729, cost = 13000, requiredIds = {5699}},
			{id = 11721, cost = 13000, requiredIds = {1490}},
			{id = 11699, cost = 13000, requiredIds = {7651}},
			{id = 11688, cost = 13000, requiredIds = {11687}},
			{id = 11677, cost = 13000, requiredIds = {6219}}
		},
		[48] = {
			{id = 18647, cost = 13000, requiredIds = {710}},
			{id = 18930, cost = 700, requiredTalentId = 17962},
			{id = 17727, cost = 14000, requiredIds = {2362}},
			{id = 11712, cost = 14000, requiredIds = {11711}},
			{id = 18870, cost = 700, requiredIds = {18869}, requiredTalentId = 17877},
			{id = 18880, cost = 700, requiredIds = {18879}, requiredTalentId = 18265},
			{id = 6353, cost = 14000}
		},
		[50] = {
			{id = 20756, cost = 15000, requiredIds = {20755}},
			{id = 11719, cost = 15000, requiredIds = {1714}},
			{id = 18937, cost = 750, requiredTalentId = 18220},
			{id = 17925, cost = 15000, requiredIds = {6789}},
			{id = 11734, cost = 15000, requiredIds = {11733}},
			{id = 11743, cost = 15000, requiredIds = {2970}},
			{id = 11667, cost = 15000, requiredIds = {11665}},
			{id = 17922, cost = 15000, requiredIds = {17921}}
		},
		[52] = {
			{id = 11708, cost = 18000, requiredIds = {11707}},
			{id = 11675, cost = 18000, requiredIds = {8289}},
			{id = 11694, cost = 18000, requiredIds = {11693}},
			{id = 11660, cost = 18000, requiredIds = {11659}},
			{id = 11740, cost = 18000, requiredIds = {11739}}
		},
		[54] = {
			{id = 18931, cost = 1000, requiredIds = {18930}, requiredTalentId = 17962},
			{id = 11672, cost = 20000, requiredIds = {11671}},
			{id = 11700, cost = 20000, requiredIds = {11699}},
			{id = 11704, cost = 20000, requiredIds = {11703}},
			{id = 11684, cost = 18000, requiredIds = {11683}},
			{id = 17928, cost = 20000, requiredIds = {5484}}
		},
		[56] = {
			{id = 17953, cost = 22000, requiredIds = {17952}},
			{id = 11717, cost = 22000, requiredIds = {7659}},
			{id = 17937, cost = 22000, requiredIds = {17862}},
			{id = 6215, cost = 22000, requiredIds = {6213}},
			{id = 11689, cost = 22000, requiredIds = {11688}},
			{id = 18871, cost = 22000, requiredIds = {18870}, requiredTalentId = 17877},
			{id = 17924, cost = 22000, requiredIds = {6353}}
		},
		[58] = {
			{id = 11730, cost = 24000, requiredIds = {11730}},
			{id = 11713, cost = 24000, requiredIds = {11712}},
			{id = 17926, cost = 24000, requiredIds = {17925}},
			{id = 11726, cost = 24000, requiredIds = {11725}},
			{id = 11678, cost = 24000, requiredIds = {11677}},
			{id = 17923, cost = 24000, requiredIds = {17922}},
			{id = 18881, cost = 1200, requiredIds = {18880}, requiredTalentId = 18265}
		},
		[60] = {
			{id = 18932, cost = 1300, requiredIds = {18931}, requiredTalentId = 17962},
			{id = 20757, cost = 26000, requiredIds = {20756}},
			{id = 17728, cost = 26000, requiredIds = {17727}},
			{id = 603, cost = 26000},
			{id = 11722, cost = 26000, requiredIds = {11721}},
			{id = 18938, cost = 1300, requiredIds = {18937}, requiredTalentId = 18220},
			{id = 11735, cost = 26000, requiredIds = {11734}},
			{id = 11695, cost = 26000, requiredIds = {11694}},
			{id = 11668, cost = 26000, requiredIds = {11667}},
			{id = 11661, cost = 26000, requiredIds = {11660}}
		},
	},
	[1] = { 
		[1] = {
			{id = 348, cost = 10},
		},
		[4] = {
			{id = 172, cost = 100},
			{id = 702, cost = 100},
		},
		[6] = {
			{id = 1454, cost = 100},
			{id = 695, cost = 100, requiredIds = {686}},
		},
		[8] = {
			{id = 980, cost = 200},
			{id = 5782, cost = 200},
		},
		[10] = {
			{id = 1120, cost = 300},
			{id = 6201, cost = 300, requiredIds = {1120}},
			{id = 696, cost = 300, requiredIds = {687}},
			{id = 707, cost = 300, requiredIds = {348}},
		},
		[12] = {
			{id = 1108, cost = 600, requiredIds = {702}},
			{id = 755, cost = 600},
			{id = 705, cost = 600, requiredIds = {695}},
		},
		[14] = {
			{id = 6222, cost = 900, requiredIds = {172}},
			{id = 704, cost = 900},
			{id = 689, cost = 900},
		},
		[16] = {
			{id = 1455, cost = 1080, requiredIds = {1454}},
			{id = 5697, cost = 1200},
		},
		[18] = {
			{id = 1014, cost = 1500, requiredIds = {980}},
			{id = 693, cost = 1500, requiredIds = {1120}},
			{id = 5676, cost = 1500},
		},
		[20] = {
			{id = 706, cost = 2000},
			{id = 3698, cost = 2000, requiredIds = {755}},
			{id = 698, cost = 2000},
			{id = 1094, cost = 2000, requiredIds = {707}},
			{id = 5740, cost = 2000},
			{id = 1088, cost = 2000, requiredIds = {705}},
		},
		[22] = {
			{id = 6205, cost = 2500, requiredIds = {1108}},
			{id = 699, cost = 2500, requiredIds = {689}},
			{id = 6202, cost = 2500, requiredIds = {6201}},
			{id = 126, cost = 2500},
		},
		[24] = {
			{id = 6223, cost = 3000, requiredIds = {6222}},
			{id = 5138, cost = 3000},
			{id = 8288, cost = 3000, requiredIds = {1120}},
			{id = 5500, cost = 3000},
			{id = 18867, cost = 150, requiredIds = {17877}, requiredTalentId = 17877},
		},
		[26] = {
			{id = 1714, cost = 4000},
			{id = 1456, cost = 3600, requiredIds = {1455}},
			{id = 132, cost = 4000},
			{id = 17919, cost = 4000, requiredIds = {5676}},
		},
		[28] = {
			{id = 6217, cost = 5000, requiredIds = {1014}},
			{id = 7658, cost = 5000, requiredIds = {704}},
			{id = 710, cost = 5000},
			{id = 6366, cost = 5000},
			{id = 3699, cost = 5000, requiredIds = {3698}},
			{id = 1106, cost = 5000, requiredIds = {1088}},
		},
		[30] = {
			{id = 709, cost = 6000, requiredIds = {699}},
			{id = 20752, cost = 6000, requiredIds = {693}},
			{id = 1086, cost = 6000, requiredIds = {706}},
			{id = 1098, cost = 6000},
			{id = 5784, cost = 10000},
			{id = 1949, cost = 6000},
			{id = 2941, cost = 6000, requiredIds = {1094}},
		},
		[32] = {
			{id = 7646, cost = 7000, requiredIds = {6205}},
			{id = 1490, cost = 7000},
			{id = 6213, cost = 7000, requiredIds = {5782}},
			{id = 6229, cost = 7000},
			{id = 18868, cost = 350, requiredIds = {18867}, requiredTalentId = 17877},
		},
		[34] = {
			{id = 7648, cost = 8000, requiredIds = {6223}},
			{id = 6226, cost = 8000, requiredIds = {5138}},
			{id = 5699, cost = 8000, requiredIds = {6202}},
			{id = 6219, cost = 8000, requiredIds = {5740}},
			{id = 17920, cost = 8000, requiredIds = {17919}},
		},
		[36] = {
			{id = 11687, cost = 8100, requiredIds = {1456}},
			{id = 17951, cost = 9000, requiredIds = {6366}},
			{id = 2362, cost = 9000, requiredIds = {1120}},
			{id = 3700, cost = 9000, requiredIds = {3699}},
			{id = 7641, cost = 9000, requiredIds = {1106}},
		},
		[38] = {
			{id = 11711, cost = 10000, requiredIds = {6217}},
			{id = 7651, cost = 10000, requiredIds = {709}},
			{id = 8289, cost = 10000, requiredIds = {8288}},
			{id = 18879, cost = 500, requiredIds = {18265}, requiredTalentId = 18265},
		},
		[40] = {
			{id = 5484, cost = 11000},
			{id = 20755, cost = 11000, requiredIds = {20752}},
			{id = 11733, cost = 11000, requiredIds = {1086}},
			{id = 11665, cost = 11000, requiredIds = {2941}},
			{id = 18869, cost = 550, requiredIds = {18868}, requiredTalentId = 17877},
		},
		[42] = {
			{id = 7659, cost = 11000, requiredIds = {7658}},
			{id = 11707, cost = 11000, requiredIds = {7646}},
			{id = 6789, cost = 11000},
			{id = 11739, cost = 11000, requiredIds = {6229}},
			{id = 11683, cost = 11000, requiredIds = {1949}},
			{id = 17921, cost = 11000, requiredIds = {17920}},
		},
		[44] = {
			{id = 11671, cost = 12000, requiredIds = {7648}},
			{id = 11703, cost = 12000, requiredIds = {6226}},
			{id = 11725, cost = 12000, requiredIds = {1098}},
			{id = 11693, cost = 12000, requiredIds = {3700}},
			{id = 11659, cost = 12000, requiredIds = {7641}},
		},
		[46] = {
			{id = 11721, cost = 13000, requiredIds = {1490}},
			{id = 11699, cost = 13000, requiredIds = {7651}},
			{id = 11688, cost = 11700, requiredIds = {11687}},
			{id = 17952, cost = 13000, requiredIds = {17951}},
			{id = 11729, cost = 13000, requiredIds = {5699}},
			{id = 11677, cost = 13000, requiredIds = {6219}},
		},
		[48] = {
			{id = 11712, cost = 14000, requiredIds = {11711}},
			{id = 18880, cost = 700, requiredIds = {18879}, requiredTalentId = 18265},
			{id = 18647, cost = 14000, requiredIds = {710}},
			{id = 17727, cost = 14000, requiredIds = {2362}},
			{id = 18930, cost = 700, requiredIds = {17962}, requiredTalentId = 17962},
			{id = 18870, cost = 700, requiredIds = {18869}, requiredTalentId = 17877},
			{id = 6353, cost = 14000},
		},
		[50] = {
			{id = 11719, cost = 15000, requiredIds = {1714}},
			{id = 18937, cost = 750, requiredIds = {18220}, requiredTalentId = 18220},
			{id = 17925, cost = 15000, requiredIds = {6789}},
			{id = 20756, cost = 15000, requiredIds = {20755}},
			{id = 11734, cost = 15000, requiredIds = {11733}},
			{id = 11667, cost = 15000, requiredIds = {11665}},
			{id = 17922, cost = 15000, requiredIds = {17921}},
		},
		[52] = {
			{id = 11708, cost = 18000, requiredIds = {11707}},
			{id = 11675, cost = 18000, requiredIds = {8289}},
			{id = 11694, cost = 18000, requiredIds = {11693}},
			{id = 11740, cost = 18000, requiredIds = {11739}},
			{id = 11660, cost = 18000, requiredIds = {11659}},
		},
		[54] = {
			{id = 11672, cost = 20000, requiredIds = {11671}},
			{id = 11700, cost = 20000, requiredIds = {11699}},
			{id = 11704, cost = 20000, requiredIds = {11703}},
			{id = 17928, cost = 20000, requiredIds = {5484}},
			{id = 18931, cost = 1000, requiredIds = {18930}, requiredTalentId = 17962},
			{id = 11684, cost = 20000, requiredIds = {11683}},
		},
		[56] = {
			{id = 11717, cost = 22000, requiredIds = {7659}},
			{id = 6215, cost = 22000, requiredIds = {6213}},
			{id = 11689, cost = 19800, requiredIds = {11688}},
			{id = 17953, cost = 22000, requiredIds = {17952}},
			{id = 18871, cost = 1100, requiredIds = {18870}, requiredTalentId = 17877},
			{id = 17924, cost = 22000, requiredIds = {6353}},
		},
		[58] = {
			{id = 11713, cost = 24000, requiredIds = {11712}},
			{id = 17926, cost = 24000, requiredIds = {17925}},
			{id = 18881, cost = 1200, requiredIds = {18880}, requiredTalentId = 18265},
			{id = 11730, cost = 24000, requiredIds = {11729}},
			{id = 11726, cost = 24000, requiredIds = {11725}},
			{id = 11678, cost = 24000, requiredIds = {11677}},
			{id = 17923, cost = 24000, requiredIds = {17922}},
		},
		[60] = {
			{id = 25311, cost = 26000, requiredIds = {11672}},
			{id = 603, cost = 26000},
			{id = 11722, cost = 26000, requiredIds = {11721}},
			{id = 18938, cost = 1300, requiredIds = {18937}, requiredTalentId = 18220},
			{id = 30404, cost = 2500, requiredIds = {30108}, requiredTalentId = 30108},
			{id = 20757, cost = 26000, requiredIds = {20756}},
			{id = 17728, cost = 26000, requiredIds = {17727}},
			{id = 11735, cost = 26000, requiredIds = {11734}},
			{id = 11695, cost = 26000, requiredIds = {11694}},
			{id = 28610, cost = 34000, requiredIds = {11740}},
			{id = 18932, cost = 1300, requiredIds = {18931}, requiredTalentId = 17962},
			{id = 11668, cost = 26000, requiredIds = {11667}},
			{id = 25309, cost = 26000, requiredIds = {11668}},
			{id = 11661, cost = 26000, requiredIds = {11660}},
			{id = 30413, cost = 2500, requiredIds = {30283}, requiredTalentId = 30283},
		},
		[61] = {
			{id = 27224, cost = 30000, requiredIds = {11708}},
		},
		[62] = {
			{id = 27219, cost = 30000, requiredIds = {11700}},
			{id = 28176, cost = 34000},
			{id = 25307, cost = 26000, requiredIds = {11661}},
		},
		[63] = {
			{id = 27221, cost = 38000, requiredIds = {11704}},
			{id = 27264, cost = 2500, requiredIds = {18881}, requiredTalentId = 18265},
			{id = 27263, cost = 1300, requiredIds = {18871}, requiredTalentId = 17877},
		},
		[64] = {
			{id = 29722, cost = 42000},
			{id = 27211, cost = 42000, requiredIds = {17924}},
		},
		[65] = {
			{id = 27216, cost = 46000, requiredIds = {25311}},
			{id = 27266, cost = 2300, requiredIds = {18932}, requiredTalentId = 17962},
			{id = 27210, cost = 46000, requiredIds = {17923}},
		},
		[66] = {
			{id = 27250, cost = 51000, requiredIds = {17953}},
			{id = 28172, cost = 51000, requiredIds = {17728}},
			{id = 29858, cost = 51000},
		},
		[67] = {
			{id = 27218, cost = 57000, requiredIds = {11713}},
			{id = 27217, cost = 57000, requiredIds = {11675}},
			{id = 27259, cost = 57000, requiredIds = {11695}},
		},
		[68] = {
			{id = 27223, cost = 63000, requiredIds = {17926}},
			{id = 27222, cost = 56700, requiredIds = {11689}},
			{id = 27230, cost = 63000, requiredIds = {11730}},
			{id = 29893, cost = 63000},
			{id = 27213, cost = 63000, requiredIds = {11684}},
		},
		[69] = {
			{id = 27226, cost = 70000, requiredIds = {11717}},
			{id = 30909, cost = 70000, requiredIds = {27224}},
			{id = 27228, cost = 70000, requiredIds = {11722}},
			{id = 27220, cost = 70000, requiredIds = {27219}},
			{id = 28189, cost = 70000, requiredIds = {28176}},
			{id = 27215, cost = 70000, requiredIds = {25309}},
			{id = 27212, cost = 70000, requiredIds = {11678}},
			{id = 27209, cost = 70000, requiredIds = {25307}},
		},
		[70] = {
			{id = 30910, cost = 78000, requiredIds = {603}},
			{id = 27265, cost = 1300, requiredIds = {18938}, requiredTalentId = 18220},
			{id = 30908, cost = 78000, requiredIds = {27221}},
			{id = 27243, cost = 78000},
			{id = 30911, cost = 2500, requiredIds = {27264}, requiredTalentId = 18265},
			{id = 30405, cost = 2500, requiredIds = {30404}, requiredTalentId = 30108},
			{id = 27238, cost = 78000, requiredIds = {20757}},
			{id = 27260, cost = 78000, requiredIds = {11735}},
			{id = 30912, cost = 3900, requiredIds = {27266}, requiredTalentId = 17962},
			{id = 32231, cost = 78000, requiredIds = {29722}},
			{id = 30459, cost = 78000, requiredIds = {27210}},
			{id = 30546, cost = 3900, requiredIds = {27263}, requiredTalentId = 17877},
			{id = 30414, cost = 2500, requiredIds = {30413}, requiredTalentId = 30283},
			{id = 30545, cost = 78000, requiredIds = {27211}},
		},
	},
	[2] = { 
		[1] = {
			{id = 348, cost = 10}, 
			{id = 688, cost = 100}, 
		},
		[4] = {
			{id = 172, cost = 100}, 
			{id = 702, cost = 100}, 
		},
		[6] = {
			{id = 1454, cost = 100}, 
			{id = 695, cost = 100, requiredIds = {686}}, 
		},
		[8] = {
			{id = 980, cost = 200}, 
			{id = 5782, cost = 200}, 
		},
		[10] = {
			{id = 6201, cost = 300, requiredIds = {1120}}, 
			{id = 696, cost = 300, requiredIds = {687}}, 
			{id = 707, cost = 300, requiredIds = {348}}, 
			{id = 1120, cost = 300}, 
		},
		[12] = {
			{id = 1108, cost = 600, requiredIds = {702}}, 
			{id = 755, cost = 600}, 
			{id = 705, cost = 600, requiredIds = {695}}, 
		},
		[14] = {
			{id = 6222, cost = 900, requiredIds = {172}}, 
			{id = 689, cost = 900}, 
		},
		[16] = {
			{id = 1455, cost = 1080, requiredIds = {1454}}, 
			{id = 5697, cost = 1200}, 
		},
		[18] = {
			{id = 1014, cost = 1500, requiredIds = {980}}, 
			{id = 5676, cost = 1500}, 
			{id = 693, cost = 1500, requiredIds = {1120}}, 
		},
		[20] = {
			{id = 706, cost = 2000}, 
			{id = 3698, cost = 2000, requiredIds = {755}}, 
			{id = 1094, cost = 2000, requiredIds = {707}}, 
			{id = 5740, cost = 2000}, 
			{id = 698, cost = 2000}, 
			{id = 1088, cost = 2000, requiredIds = {705}}, 
			{id = 5784, cost = 10000}, 
		},
		[22] = {
			{id = 6202, cost = 2500, requiredIds = {6201}}, 
			{id = 6205, cost = 2500, requiredIds = {1108}}, 
			{id = 699, cost = 2500, requiredIds = {689}}, 
			{id = 126, cost = 2500}, 
		},
		[24] = {
			{id = 6223, cost = 3000, requiredIds = {6222}}, 
			{id = 5138, cost = 3000}, 
			{id = 5500, cost = 3000}, 
			{id = 18867, cost = 148, requiredIds = {17877}, requiredTalentId = 17877}, 
			{id = 8288, cost = 3000, requiredIds = {1120}}, 
		},
		[26] = {
			{id = 1714, cost = 4000}, 
			{id = 132, cost = 4000}, 
			{id = 1456, cost = 3600, requiredIds = {1455}}, 
			{id = 17919, cost = 4000, requiredIds = {5676}}, 
		},
		[28] = {
			{id = 710, cost = 5000}, 
			{id = 6217, cost = 5000, requiredIds = {1014}}, 
			{id = 3699, cost = 5000, requiredIds = {3698}}, 
			{id = 1106, cost = 5000, requiredIds = {1088}}, 
			{id = 6366, cost = 5000}, 
		},
		[30] = {
			{id = 1086, cost = 6000, requiredIds = {706}}, 
			{id = 709, cost = 6000, requiredIds = {699}}, 
			{id = 1098, cost = 6000}, 
			{id = 1949, cost = 6000}, 
			{id = 2941, cost = 6000, requiredIds = {1094}}, 
			{id = 20752, cost = 6000, requiredIds = {693}}, 
		},
		[32] = {
			{id = 1490, cost = 7000}, 
			{id = 7646, cost = 7000, requiredIds = {6205}}, 
			{id = 6213, cost = 7000, requiredIds = {5782}}, 
			{id = 6229, cost = 7000}, 
			{id = 18868, cost = 348, requiredIds = {18867}, requiredTalentId = 17877}, 
		},
		[34] = {
			{id = 7648, cost = 8000, requiredIds = {6223}}, 
			{id = 5699, cost = 8000, requiredIds = {6202}}, 
			{id = 6219, cost = 8000, requiredIds = {5740}}, 
			{id = 17920, cost = 8000, requiredIds = {17919}}, 
		},
		[36] = {
			{id = 3700, cost = 9000, requiredIds = {3699}}, 
			{id = 11687, cost = 8100, requiredIds = {1456}}, 
			{id = 7641, cost = 9000, requiredIds = {1106}}, 
			{id = 17951, cost = 9000, requiredIds = {6366}}, 
			{id = 2362, cost = 9000, requiredIds = {1120}}, 
		},
		[38] = {
			{id = 11711, cost = 10000, requiredIds = {6217}}, 
			{id = 7651, cost = 10000, requiredIds = {709}}, 
			{id = 8289, cost = 10000, requiredIds = {8288}}, 
		},
		[40] = {
			{id = 11733, cost = 11000, requiredIds = {1086}}, 
			{id = 5484, cost = 11000}, 
			{id = 11665, cost = 11000, requiredIds = {2941}}, 
			{id = 18869, cost = 548, requiredIds = {18868}, requiredTalentId = 17877}, 
			{id = 20755, cost = 11000, requiredIds = {20752}}, 
			{id = 23161, cost = 100000}, 
		},
		[42] = {
			{id = 11707, cost = 11000, requiredIds = {7646}}, 
			{id = 6789, cost = 11000}, 
			{id = 11683, cost = 11000, requiredIds = {1949}}, 
			{id = 17921, cost = 11000, requiredIds = {17920}}, 
			{id = 11739, cost = 11000, requiredIds = {6229}}, 
		},
		[44] = {
			{id = 11671, cost = 12000, requiredIds = {7648}}, 
			{id = 11725, cost = 12000, requiredIds = {1098}}, 
			{id = 11693, cost = 12000, requiredIds = {3700}}, 
			{id = 11659, cost = 12000, requiredIds = {7641}}, 
		},
		[46] = {
			{id = 11729, cost = 13000, requiredIds = {5699}}, 
			{id = 11721, cost = 13000, requiredIds = {1490}}, 
			{id = 11699, cost = 13000, requiredIds = {7651}}, 
			{id = 11688, cost = 11700, requiredIds = {11687}}, 
			{id = 11677, cost = 13000, requiredIds = {6219}}, 
			{id = 17952, cost = 13000, requiredIds = {17951}}, 
		},
		[48] = {
			{id = 18647, cost = 14000, requiredIds = {710}}, 
			{id = 11712, cost = 14000, requiredIds = {11711}}, 
			{id = 18870, cost = 700, requiredIds = {18869}, requiredTalentId = 17877}, 
			{id = 6353, cost = 14000}, 
			{id = 17727, cost = 14000, requiredIds = {2362}}, 
		},
		[50] = {
			{id = 11719, cost = 15000, requiredIds = {1714}}, 
			{id = 18937, cost = 748, requiredIds = {18220}, requiredTalentId = 18220}, 
			{id = 17925, cost = 15000, requiredIds = {6789}}, 
			{id = 11734, cost = 15000, requiredIds = {11733}}, 
			{id = 11667, cost = 15000, requiredIds = {11665}}, 
			{id = 17922, cost = 15000, requiredIds = {17921}}, 
			{id = 20756, cost = 15000, requiredIds = {20755}}, 
		},
		[52] = {
			{id = 11708, cost = 18000, requiredIds = {11707}}, 
			{id = 11694, cost = 18000, requiredIds = {11693}}, 
			{id = 11660, cost = 18000, requiredIds = {11659}}, 
			{id = 11740, cost = 18000, requiredIds = {11739}}, 
			{id = 11675, cost = 18000, requiredIds = {8289}}, 
		},
		[54] = {
			{id = 11672, cost = 20000, requiredIds = {11671}}, 
			{id = 11700, cost = 20000, requiredIds = {11699}}, 
			{id = 11684, cost = 20000, requiredIds = {11683}}, 
			{id = 17928, cost = 20000, requiredIds = {5484}}, 
		},
		[56] = {
			{id = 6215, cost = 22000, requiredIds = {6213}}, 
			{id = 11689, cost = 19800, requiredIds = {11688}}, 
			{id = 18871, cost = 1100, requiredIds = {18870}, requiredTalentId = 17877}, 
			{id = 17924, cost = 22000, requiredIds = {6353}}, 
			{id = 17953, cost = 22000, requiredIds = {17952}}, 
		},
		[58] = {
			{id = 11730, cost = 24000, requiredIds = {11729}}, 
			{id = 11713, cost = 24000, requiredIds = {11712}}, 
			{id = 17926, cost = 24000, requiredIds = {17925}}, 
			{id = 11726, cost = 24000, requiredIds = {11725}}, 
			{id = 11678, cost = 24000, requiredIds = {11677}}, 
			{id = 17923, cost = 24000, requiredIds = {17922}}, 
		},
		[60] = {
			{id = 25311, cost = 26000, requiredIds = {11672}}, 
			{id = 603, cost = 26000}, 
			{id = 11722, cost = 26000, requiredIds = {11721}}, 
			{id = 18938, cost = 1300, requiredIds = {18937}, requiredTalentId = 18220}, 
			{id = 11735, cost = 26000, requiredIds = {11734}}, 
			{id = 11695, cost = 26000, requiredIds = {11694}}, 
			{id = 11668, cost = 26000, requiredIds = {11667}}, 
			{id = 25309, cost = 26000, requiredIds = {11668}}, 
			{id = 11661, cost = 26000, requiredIds = {11660}}, 
			{id = 28610, cost = 34000, requiredIds = {11740}}, 
			{id = 30413, cost = 2500, requiredIds = {30283}, requiredTalentId = 30283}, 
			{id = 30404, cost = 2500, requiredIds = {30108}, requiredTalentId = 30108}, 
			{id = 20757, cost = 26000, requiredIds = {20756}}, 
			{id = 17728, cost = 26000, requiredIds = {17727}}, 
		},
		[61] = {
			{id = 27224, cost = 30000, requiredIds = {11708}}, 
		},
		[62] = {
			{id = 27219, cost = 30000, requiredIds = {11700}}, 
			{id = 28176, cost = 34000}, 
			{id = 25307, cost = 26000, requiredIds = {11661}}, 
		},
		[63] = {
			{id = 27263, cost = 1300, requiredIds = {18871}, requiredTalentId = 17877}, 
		},
		[64] = {
			{id = 29722, cost = 42000}, 
			{id = 27211, cost = 42000, requiredIds = {17924}}, 
		},
		[65] = {
			{id = 27216, cost = 46000, requiredIds = {25311}}, 
			{id = 27210, cost = 46000, requiredIds = {17923}}, 
		},
		[66] = {
			{id = 29858, cost = 51000}, 
			{id = 27250, cost = 51000, requiredIds = {17953}}, 
			{id = 28172, cost = 51000, requiredIds = {17728}}, 
		},
		[67] = {
			{id = 27218, cost = 57000, requiredIds = {11713}}, 
			{id = 27259, cost = 57000, requiredIds = {11695}}, 
			{id = 27217, cost = 57000, requiredIds = {11675}}, 
		},
		[68] = {
			{id = 27230, cost = 63000, requiredIds = {11730}}, 
			{id = 27223, cost = 63000, requiredIds = {17926}}, 
			{id = 27213, cost = 63000, requiredIds = {11684}}, 
			{id = 27222, cost = 56700, requiredIds = {11689}}, 
			{id = 29893, cost = 63000}, 
		},
		[69] = {
			{id = 30909, cost = 70000, requiredIds = {27224}}, 
			{id = 27228, cost = 70000, requiredIds = {11722}}, 
			{id = 27220, cost = 70000, requiredIds = {27219}}, 
			{id = 28189, cost = 70000, requiredIds = {28176}}, 
			{id = 27215, cost = 70000, requiredIds = {25309}}, 
			{id = 27212, cost = 70000, requiredIds = {11678}}, 
			{id = 27209, cost = 70000, requiredIds = {25307}}, 
		},
		[70] = {
			{id = 59170, cost = 2500, requiredIds = {50796}, requiredTalentId = 50796}, 
			{id = 30910, cost = 78000, requiredIds = {603}}, 
			{id = 27265, cost = 1300, requiredIds = {18938}, requiredTalentId = 18220}, 
			{id = 27260, cost = 78000, requiredIds = {11735}}, 
			{id = 59161, cost = 2500, requiredIds = {48181}, requiredTalentId = 48181}, 
			{id = 32231, cost = 78000, requiredIds = {29722}}, 
			{id = 30459, cost = 78000, requiredIds = {27210}}, 
			{id = 27243, cost = 78000}, 
			{id = 30546, cost = 3900, requiredIds = {27263}, requiredTalentId = 17877}, 
			{id = 30414, cost = 2500, requiredIds = {30413}, requiredTalentId = 30283}, 
			{id = 30545, cost = 78000, requiredIds = {27211}}, 
			{id = 30405, cost = 2500, requiredIds = {30404}, requiredTalentId = 30108}, 
			{id = 27238, cost = 78000, requiredIds = {20757}}, 
		},
		[71] = {
			{id = 47812, cost = 160000, requiredIds = {27216}}, 
			{id = 50511, cost = 160000, requiredIds = {30909}}, 
		},
		[72] = {
			{id = 61191, cost = 70000, requiredIds = {11726}}, 
			{id = 47819, cost = 160000, requiredIds = {27212}}, 
			{id = 47890, cost = 160000, requiredIds = {28610}}, 
			{id = 47886, cost = 160000, requiredIds = {28172}}, 
		},
		[73] = {
			{id = 47871, cost = 160000, requiredIds = {27230}}, 
			{id = 47863, cost = 160000, requiredIds = {27218}}, 
			{id = 47859, cost = 160000, requiredIds = {27223}}, 
		},
		[74] = {
			{id = 47892, cost = 160000, requiredIds = {28189}}, 
			{id = 47837, cost = 160000, requiredIds = {32231}}, 
			{id = 47814, cost = 160000, requiredIds = {30459}}, 
			{id = 47808, cost = 160000, requiredIds = {27209}}, 
			{id = 60219, cost = 160000, requiredIds = {27250}}, 
		},
		[75] = {
			{id = 59171, cost = 8000, requiredIds = {59170}, requiredTalentId = 50796}, 
			{id = 59163, cost = 8000, requiredIds = {59161}, requiredTalentId = 48181}, 
			{id = 47810, cost = 160000, requiredIds = {27215}}, 
			{id = 47835, cost = 160000, requiredIds = {27243}}, 
			{id = 47826, cost = 8000, requiredIds = {30546}, requiredTalentId = 17877}, 
			{id = 47897, cost = 10000}, 
			{id = 47846, cost = 8000, requiredIds = {30414}, requiredTalentId = 30283}, 
			{id = 47824, cost = 160000, requiredIds = {30545}}, 
			{id = 47841, cost = 8000, requiredIds = {30405}, requiredTalentId = 30108}, 
		},
		[76] = {
			{id = 47793, cost = 160000, requiredIds = {27260}}, 
			{id = 47856, cost = 160000, requiredIds = {27259}}, 
			{id = 47884, cost = 160000, requiredIds = {27238}}, 
		},
		[77] = {
			{id = 47813, cost = 160000, requiredIds = {47812}}, 
			{id = 47855, cost = 160000, requiredIds = {27217}}, 
		},
		[78] = {
			{id = 47865, cost = 160000, requiredIds = {27228}}, 
			{id = 47860, cost = 160000, requiredIds = {47859}}, 
			{id = 47857, cost = 160000, requiredIds = {27220}}, 
			{id = 47823, cost = 160000, requiredIds = {27213}}, 
			{id = 47891, cost = 160000, requiredIds = {47890}}, 
			{id = 47888, cost = 160000, requiredIds = {47886}}, 
		},
		[79] = {
			{id = 47878, cost = 160000, requiredIds = {47871}}, 
			{id = 47864, cost = 160000, requiredIds = {47863}}, 
			{id = 47893, cost = 160000, requiredIds = {47892}}, 
			{id = 47820, cost = 160000, requiredIds = {47819}}, 
			{id = 47815, cost = 160000, requiredIds = {47814}}, 
			{id = 47809, cost = 160000, requiredIds = {47808}}, 
		},
		[80] = {
			{id = 59172, cost = 8000, requiredIds = {59171}, requiredTalentId = 50796}, 
			{id = 47867, cost = 160000, requiredIds = {30910}}, 
			{id = 59092, cost = 160000, requiredIds = {27265}, requiredTalentId = 18220}, 
			{id = 47889, cost = 160000, requiredIds = {47793}}, 
			{id = 48018, cost = 160000}, 
			{id = 48020, cost = 160000}, 
			{id = 59164, cost = 8000, requiredIds = {59163}, requiredTalentId = 48181}, 
			{id = 47811, cost = 160000, requiredIds = {47810}}, 
			{id = 47838, cost = 100000, requiredIds = {47837}}, 
			{id = 57946, cost = 160000, requiredIds = {27222}}, 
			{id = 58887, cost = 160000, requiredIds = {29893}}, 
			{id = 47836, cost = 160000, requiredIds = {47835}}, 
			{id = 47827, cost = 8000, requiredIds = {47826}, requiredTalentId = 17877}, 
			{id = 61290, cost = 10000, requiredIds = {47897}}, 
			{id = 47847, cost = 8000, requiredIds = {47846}, requiredTalentId = 30283}, 
			{id = 47825, cost = 160000, requiredIds = {47824}}, 
			{id = 47843, cost = 8000, requiredIds = {47841}, requiredTalentId = 30108}, 
			{id = 60220, cost = 160000, requiredIds = {60219}}, 
		},
	},
}

FatCooldowns.MageSpells = {
	[0] = { 
		[1] = {
			{id = 1459, cost = 10}
		},
		[4] = {
			{id = 5504, cost = 100},
			{id = 116, cost = 100}
		},
		[6] = {
			{id = 587, cost = 100},
			{id = 2136, cost = 100},
			{id = 143, cost = 100, requiredIds = {133}}
		},
		[8] = {
			{id = 5143, cost = 200},
			{id = 205, cost = 200, requiredIds = {116}},
			{id = 118, cost = 200}
		},
		[10] = {
			{id = 5505, cost = 400, requiredIds = {5504}},
			{id = 7300, cost = 400, requiredIds = {168}},
			{id = 122, cost = 400}
		},
		[12] = {
			{id = 597, cost = 600, requiredIds = {587}},
			{id = 604, cost = 600},
			{id = 145, cost = 600, requiredIds = {143}},
			{id = 130, cost = 600}
		},
		[14] = {
			{id = 1449, cost = 900},
			{id = 1460, cost = 900, requiredIds = {1459}},
			{id = 2137, cost = 900, requiredIds = {2136}},
			{id = 837, cost = 900, requiredIds = {205}}
		},
		[16] = {
			{id = 5144, cost = 1500, requiredIds = {5143}},
			{id = 2855, cost = 1500},
			{id = 2120, cost = 1500}
		},
		[18] = {
			{id = 1008, cost = 1800},
			{id = 3140, cost = 1800, requiredIds = {145}},
			{id = 475, cost = 1800}
		},
		[20] = {
			{id = 1953, cost = 2000},
			{id = 10, cost = 2000},
			{id = 5506, cost = 2000, requiredIds = {5505}},
			{id = 12051, cost = 2000},
			{id = 543, cost = 2000},
			{id = 7301, cost = 2000, requiredIds = {7300}},
			{id = 7322, cost = 2000, requiredIds = {837}},
			{id = 1463, cost = 2000},
			{id = 12824, cost = 2000, requiredIds = {118}},
			{id = 3562, cost = 2000, faction = "Alliance"},
			{id = 3567, cost = 2000, faction = "Horde"},
			{id = 3561, cost = 2000, faction = "Alliance"},
			{id = 3563, cost = 2000, faction = "Horde"}
		},
		[22] = {
			{id = 8437, cost = 3000, requiredIds = {1449}},
			{id = 990, cost = 3000, requiredIds = {597}},
			{id = 2138, cost = 3000, requiredIds = {2137}},
			{id = 6143, cost = 3000},
			{id = 2948, cost = 3000}
		},
		[24] = {
			{id = 5145, cost = 4000, requiredIds = {5144}},
			{id = 2139, cost = 4000},
			{id = 8450, cost = 4000, requiredIds = {604}},
			{id = 8400, cost = 4000, requiredIds = {3140}},
			{id = 2121, cost = 4000, requiredIds = {2120}},
			{id = 12505, cost = 200, requiredIds = {11366}, requiredTalentId = 11366}
		},
		[26] = {
			{id = 120, cost = 5000},
			{id = 865, cost = 5000, requiredIds = {122}},
			{id = 8406, cost = 5000, requiredIds = {7322}}
		},
		[28] = {
			{id = 1461, cost = 7000, requiredIds = {1460}},
			{id = 6141, cost = 7000, requiredIds = {10}},
			{id = 759, cost = 7000},
			{id = 8494, cost = 7000, requiredIds = {1463}},
			{id = 8444, cost = 7000, requiredIds = {2948}}
		},
		[30] = {
			{id = 8455, cost = 8000, requiredIds = {1008}},
			{id = 8438, cost = 8000, requiredIds = {8437}},
			{id = 6127, cost = 8000, requiredIds = {5506}},
			{id = 8412, cost = 8000, requiredIds = {2138}},
			{id = 8457, cost = 8000, requiredIds = {543}},
			{id = 8401, cost = 8000, requiredIds = {8400}},
			{id = 7302, cost = 8000},
			{id = 12522, cost = 400, requiredIds = {12505}, requiredTalentId = 11366},
			{id = 3565, cost = 8000, faction = "Alliance"},
			{id = 3566, cost = 8000, faction = "Horde"}
		},
		[32] = {
			{id = 8416, cost = 10000, requiredIds = {5145}},
			{id = 6129, cost = 10000, requiredIds = {990}},
			{id = 8422, cost = 10000, requiredIds = {2121}},
			{id = 8461, cost = 10000, requiredIds = {6143}},
			{id = 8407, cost = 10000, requiredIds = {8406}}
		},
		[34] = {
			{id = 8492, cost = 12000, requiredIds = {120}},
			{id = 6117, cost = 13000},
			{id = 8445, cost = 12000, requiredIds = {8444}}
		},
		[36] = {
			{id = 13018, cost = 650, requiredIds = {11113}, requiredTalentId = 11113},
			{id = 8427, cost = 13000, requiredIds = {6141}},
			{id = 8451, cost = 15000, requiredIds = {8450}},
			{id = 8402, cost = 13000, requiredIds = {8401}},
			{id = 8495, cost = 13000, requiredIds = {8494}},
			{id = 12523, cost = 650, requiredIds = {12522}, requiredTalentId = 11366}
		},
		[38] = {
			{id = 8439, cost = 14000, requiredIds = {8438}},
			{id = 3552, cost = 14000, requiredIds = {759}},
			{id = 8413, cost = 14000, requiredIds = {8412}},
			{id = 8408, cost = 14000, requiredIds = {8407}}
		},
		[40] = {
			{id = 8417, cost = 15000, requiredIds = {8416}},
			{id = 10138, cost = 15000, requiredIds = {6127}},
			{id = 8458, cost = 15000, requiredIds = {8457}},
			{id = 8423, cost = 15000, requiredIds = {8422}},
			{id = 6131, cost = 15000, requiredIds = {865}},
			{id = 7320, cost = 15000, requiredIds = {7302}},
			{id = 12825, cost = 15000, requiredIds = {12824}},
			{id = 11416, cost = 13500, faction = "Alliance"},
			{id = 11417, cost = 13500, faction = "Horde"},
			{id = 10059, cost = 13500, faction = "Alliance"},
			{id = 11418, cost = 13500, faction = "Horde"},
			{id = 8446, cost = 15000, requiredIds = {8445}}
		},
		[42] = {
			{id = 10169, cost = 18000, requiredIds = {8455}},
			{id = 10156, cost = 22750, requiredIds = {1461}},
			{id = 10159, cost = 22750, requiredIds = {8492}},
			{id = 10144, cost = 22750, requiredIds = {6129}},
			{id = 10148, cost = 22750, requiredIds = {8402}},
			{id = 8462, cost = 18000, requiredIds = {8461}},
			{id = 12524, cost = 900, requiredIds = {12523}, requiredTalentId = 11366}
		},
		[44] = {
			{id = 13019, cost = 1150, requiredIds = {13018}, requiredTalentId = 11113},
			{id = 10185, cost = 23000, requiredIds = {8427}},
			{id = 10179, cost = 23000, requiredIds = {8408}},
			{id = 10191, cost = 23000, requiredIds = {8495}}
		},
		[46] = {
			{id = 10201, cost = 26000, requiredIds = {8439}},
			{id = 10197, cost = 26000, requiredIds = {8413}},
			{id = 13031, cost = 6500, requiredIds = {11426}, requiredTalentId = 11426},
			{id = 22782, cost = 28000, requiredIds = {6117}},
			{id = 10205, cost = 26000, requiredIds = {8446}}
		},
		[48] = {
			{id = 10211, cost = 28000, requiredIds = {8417}},
			{id = 10053, cost = 28000, requiredIds = {3552}},
			{id = 10173, cost = 28000, requiredIds = {8451}},
			{id = 10149, cost = 28000, requiredIds = {10148}},
			{id = 10215, cost = 28000, requiredIds = {8423}},
			{id = 12525, cost = 900, requiredIds = {12524}, requiredTalentId = 11366}
		},
		[50] = {
			{id = 10160, cost = 32000, requiredIds = {10159}},
			{id = 10139, cost = 32000, requiredIds = {10138}},
			{id = 10223, cost = 32000, requiredIds = {8458}},
			{id = 10180, cost = 32000, requiredIds = {10179}},
			{id = 10219, cost = 32000, requiredIds = {7320}},
			{id = 11419, cost = 28800, faction = "Alliance"},
			{id = 11420, cost = 28800, faction = "Horde"}
		},
		[52] = {
			{id = 13020, cost = 1750, requiredIds = {13019}, requiredTalentId = 11113},
			{id = 10186, cost = 35000, requiredIds = {10185}},
			{id = 10145, cost = 35000, requiredIds = {10144}},
			{id = 10177, cost = 35000, requiredIds = {8462}},
			{id = 13032, cost = 8750, requiredIds = {13031}, requiredTalentId = 11426},
			{id = 10192, cost = 35000, requiredIds = {10191}},
			{id = 10206, cost = 35000, requiredIds = {10205}}
		},
		[54] = {
			{id = 10170, cost = 36000, requiredIds = {10169}},
			{id = 10202, cost = 36000, requiredIds = {10201}},
			{id = 10199, cost = 36000, requiredIds = {10197}},
			{id = 10150, cost = 36000, requiredIds = {10149}},
			{id = 10230, cost = 36000, requiredIds = {6131}},
			{id = 12526, cost = 1800, requiredIds = {12525}, requiredTalentId = 11366}
		},
		[56] = {
			{id = 10157, cost = 38000, requiredIds = {10156}},
			{id = 10212, cost = 38000, requiredIds = {10211}},
			{id = 10216, cost = 38000, requiredIds = {10215}},
			{id = 10181, cost = 38000, requiredIds = {10180}}
		},
		[58] = {
			{id = 10161, cost = 40000, requiredIds = {10160}},
			{id = 10054, cost = 40000, requiredIds = {10053}},
			{id = 13033, cost = 9000, requiredIds = {13032}, requiredTalentId = 11426},
			{id = 22783, cost = 40000, requiredIds = {22782}},
			{id = 10207, cost = 40000, requiredIds = {10206}}
		},
		[60] = {
			{id = 13021, cost = 2100, requiredIds = {13020}, requiredTalentId = 11113},
			{id = 10187, cost = 42000, requiredIds = {10186}},
			{id = 10174, cost = 42000, requiredIds = {10173}},
			{id = 10225, cost = 42000, requiredIds = {10223}},
			{id = 10151, cost = 42000, requiredIds = {10150}},
			{id = 10220, cost = 42000, requiredIds = {10219}},
			{id = 10193, cost = 42000, requiredIds = {10192}},
			{id = 12826, cost = 42000, requiredIds = {12825}},
			{id = 18809, cost = 1890, requiredIds = {12526}, requiredTalentId = 11366}
		},
	},
	[1] = { 
		[1] = {
			{id = 1459, cost = 10},
		},
		[4] = {
			{id = 5504, cost = 100},
			{id = 116, cost = 100},
		},
		[6] = {
			{id = 587, cost = 100},
			{id = 2136, cost = 100},
			{id = 143, cost = 100, requiredIds = {133}},
		},
		[8] = {
			{id = 5143, cost = 200},
			{id = 118, cost = 200},
			{id = 205, cost = 200, requiredIds = {116}},
		},
		[10] = {
			{id = 5505, cost = 400, requiredIds = {5504}},
			{id = 7300, cost = 400, requiredIds = {168}},
			{id = 122, cost = 400},
		},
		[12] = {
			{id = 597, cost = 600, requiredIds = {587}},
			{id = 604, cost = 600},
			{id = 130, cost = 600},
			{id = 145, cost = 600, requiredIds = {143}},
		},
		[14] = {
			{id = 1449, cost = 900},
			{id = 1460, cost = 900, requiredIds = {1459}},
			{id = 2137, cost = 900, requiredIds = {2136}},
			{id = 837, cost = 900, requiredIds = {205}},
		},
		[16] = {
			{id = 5144, cost = 1500, requiredIds = {5143}},
			{id = 2120, cost = 1500},
		},
		[18] = {
			{id = 1008, cost = 1800},
			{id = 475, cost = 1800},
			{id = 3140, cost = 1800, requiredIds = {145}},
		},
		[20] = {
			{id = 1953, cost = 2000},
			{id = 5506, cost = 2000, requiredIds = {5505}},
			{id = 12051, cost = 2000},
			{id = 1463, cost = 2000},
			{id = 12824, cost = 2000, requiredIds = {118}},
			{id = 543, cost = 2000},
			{id = 10, cost = 2000},
			{id = 7301, cost = 2000, requiredIds = {7300}},
			{id = 7322, cost = 2000, requiredIds = {837}},
			{id = 3561, cost = 2000, faction = "Alliance"},
			{id = 3562, cost = 2000, faction = "Alliance"},
			{id = 32271, cost = 2000, faction = "Alliance"},
			{id = 3567, cost = 2000, faction = "Horde"},
			{id = 3563, cost = 2000, faction = "Horde"},
			{id = 32272, cost = 2000, faction = "Horde"},
		},
		[22] = {
			{id = 8437, cost = 3000, requiredIds = {1449}},
			{id = 990, cost = 3000, requiredIds = {597}},
			{id = 2138, cost = 3000, requiredIds = {2137}},
			{id = 2948, cost = 3000},
			{id = 6143, cost = 3000},
		},
		[24] = {
			{id = 5145, cost = 4000, requiredIds = {5144}},
			{id = 2139, cost = 4000},
			{id = 8450, cost = 4000, requiredIds = {604}},
			{id = 8400, cost = 4000, requiredIds = {3140}},
			{id = 2121, cost = 4000, requiredIds = {2120}},
			{id = 12505, cost = 1000, requiredIds = {11366}, requiredTalentId = 11366},
		},
		[26] = {
			{id = 120, cost = 5000},
			{id = 865, cost = 5000, requiredIds = {122}},
			{id = 8406, cost = 5000, requiredIds = {7322}},
		},
		[28] = {
			{id = 1461, cost = 7000, requiredIds = {1460}},
			{id = 759, cost = 7000},
			{id = 8494, cost = 7000, requiredIds = {1463}},
			{id = 8444, cost = 7000, requiredIds = {2948}},
			{id = 6141, cost = 7000, requiredIds = {10}},
		},
		[30] = {
			{id = 8455, cost = 8000, requiredIds = {1008}},
			{id = 8438, cost = 8000, requiredIds = {8437}},
			{id = 6127, cost = 8000, requiredIds = {5506}},
			{id = 8412, cost = 8000, requiredIds = {2138}},
			{id = 8457, cost = 8000, requiredIds = {543}},
			{id = 8401, cost = 8000, requiredIds = {8400}},
			{id = 12522, cost = 2000, requiredIds = {12505}, requiredTalentId = 11366},
			{id = 7302, cost = 8000},
			{id = 45438, cost = 8000},
			{id = 3565, cost = 8000, faction = "Alliance"},
			{id = 3566, cost = 8000, faction = "Horde"},
		},
		[32] = {
			{id = 8416, cost = 10000, requiredIds = {5145}},
			{id = 6129, cost = 10000, requiredIds = {990}},
			{id = 8422, cost = 10000, requiredIds = {2121}},
			{id = 8461, cost = 10000, requiredIds = {6143}},
			{id = 8407, cost = 10000, requiredIds = {8406}},
		},
		[34] = {
			{id = 6117, cost = 13000},
			{id = 8445, cost = 12000, requiredIds = {8444}},
			{id = 8492, cost = 12000, requiredIds = {120}},
		},
		[35] = {
			{id = 49360, cost = 15000, faction = "Alliance"},
			{id = 49359, cost = 2000, faction = "Alliance"},
			{id = 49361, cost = 15000, faction = "Horde"},
			{id = 49358, cost = 2000, faction = "Horde"},
		},
		[36] = {
			{id = 8451, cost = 13000, requiredIds = {8450}},
			{id = 8495, cost = 13000, requiredIds = {8494}},
			{id = 13018, cost = 3250, requiredIds = {11113}, requiredTalentId = 11113},
			{id = 8402, cost = 13000, requiredIds = {8401}},
			{id = 12523, cost = 3250, requiredIds = {12522}, requiredTalentId = 11366},
			{id = 8427, cost = 13000, requiredIds = {6141}},
		},
		[38] = {
			{id = 8439, cost = 14000, requiredIds = {8438}},
			{id = 3552, cost = 14000, requiredIds = {759}},
			{id = 8413, cost = 14000, requiredIds = {8412}},
			{id = 8408, cost = 14000, requiredIds = {8407}},
		},
		[40] = {
			{id = 8417, cost = 15000, requiredIds = {8416}},
			{id = 10138, cost = 15000, requiredIds = {6127}},
			{id = 12825, cost = 15000, requiredIds = {12824}},
			{id = 8458, cost = 15000, requiredIds = {8457}},
			{id = 8423, cost = 15000, requiredIds = {8422}},
			{id = 8446, cost = 15000, requiredIds = {8445}},
			{id = 6131, cost = 15000, requiredIds = {865}},
			{id = 7320, cost = 15000, requiredIds = {7302}},
			{id = 10059, cost = 15000, faction = "Alliance"},
			{id = 11416, cost = 15000, faction = "Alliance"},
			{id = 32266, cost = 15000, faction = "Alliance"},
			{id = 11417, cost = 15000, faction = "Horde"},
			{id = 11418, cost = 15000, faction = "Horde"},
			{id = 32267, cost = 15000, faction = "Horde"},
		},
		[42] = {
			{id = 10169, cost = 18000, requiredIds = {8455}},
			{id = 10156, cost = 18000, requiredIds = {1461}},
			{id = 10144, cost = 18000, requiredIds = {6129}},
			{id = 10148, cost = 18000, requiredIds = {8402}},
			{id = 12524, cost = 4500, requiredIds = {12523}, requiredTalentId = 11366},
			{id = 10159, cost = 18000, requiredIds = {8492}},
			{id = 8462, cost = 18000, requiredIds = {8461}},
		},
		[44] = {
			{id = 10191, cost = 23000, requiredIds = {8495}},
			{id = 13019, cost = 5749, requiredIds = {13018}, requiredTalentId = 11113},
			{id = 10185, cost = 23000, requiredIds = {8427}},
			{id = 10179, cost = 23000, requiredIds = {8408}},
		},
		[46] = {
			{id = 10201, cost = 26000, requiredIds = {8439}},
			{id = 22782, cost = 28000, requiredIds = {6117}},
			{id = 10197, cost = 26000, requiredIds = {8413}},
			{id = 10205, cost = 26000, requiredIds = {8446}},
			{id = 13031, cost = 1700, requiredIds = {11426}, requiredTalentId = 11426},
		},
		[48] = {
			{id = 10211, cost = 28000, requiredIds = {8417}},
			{id = 10053, cost = 28000, requiredIds = {3552}},
			{id = 10173, cost = 28000, requiredIds = {8451}},
			{id = 10149, cost = 28000, requiredIds = {10148}},
			{id = 10215, cost = 28000, requiredIds = {8423}},
			{id = 12525, cost = 7000, requiredIds = {12524}, requiredTalentId = 11366},
		},
		[50] = {
			{id = 10139, cost = 32000, requiredIds = {10138}},
			{id = 10223, cost = 32000, requiredIds = {8458}},
			{id = 10160, cost = 32000, requiredIds = {10159}},
			{id = 10180, cost = 32000, requiredIds = {10179}},
			{id = 10219, cost = 32000, requiredIds = {7320}},
			{id = 11419, cost = 32000, faction = "Alliance"},
			{id = 11420, cost = 32000, faction = "Horde"},
		},
		[52] = {
			{id = 10145, cost = 35000, requiredIds = {10144}},
			{id = 10192, cost = 35000, requiredIds = {10191}},
			{id = 13020, cost = 8749, requiredIds = {13019}, requiredTalentId = 11113},
			{id = 10206, cost = 35000, requiredIds = {10205}},
			{id = 10186, cost = 35000, requiredIds = {10185}},
			{id = 10177, cost = 35000, requiredIds = {8462}},
			{id = 13032, cost = 1900, requiredIds = {13031}, requiredTalentId = 11426},
		},
		[54] = {
			{id = 10170, cost = 36000, requiredIds = {10169}},
			{id = 10202, cost = 36000, requiredIds = {10201}},
			{id = 10199, cost = 36000, requiredIds = {10197}},
			{id = 10150, cost = 36000, requiredIds = {10149}},
			{id = 12526, cost = 9000, requiredIds = {12525}, requiredTalentId = 11366},
			{id = 10230, cost = 36000, requiredIds = {6131}},
		},
		[56] = {
			{id = 23028, cost = 38000, requiredIds = {10157}},
			{id = 10157, cost = 38000, requiredIds = {10156}},
			{id = 10212, cost = 38000, requiredIds = {10211}},
			{id = 33041, cost = 1900, requiredIds = {31661}, requiredTalentId = 31661},
			{id = 10216, cost = 38000, requiredIds = {10215}},
			{id = 10181, cost = 38000, requiredIds = {10180}},
		},
		[58] = {
			{id = 10054, cost = 40000, requiredIds = {10053}},
			{id = 22783, cost = 40000, requiredIds = {22782}},
			{id = 10207, cost = 40000, requiredIds = {10206}},
			{id = 10161, cost = 40000, requiredIds = {10160}},
			{id = 13033, cost = 2100, requiredIds = {13032}, requiredTalentId = 11426},
		},
		[60] = {
			{id = 25345, cost = 42000, requiredIds = {10212}},
			{id = 28612, cost = 42000, requiredIds = {10145}},
			{id = 10140, cost = 42000, requiredIds = {10139}},
			{id = 10174, cost = 42000, requiredIds = {10173}},
			{id = 10193, cost = 42000, requiredIds = {10192}},
			{id = 12826, cost = 42000, requiredIds = {12825}},
			{id = 13021, cost = 10500, requiredIds = {13020}, requiredTalentId = 11113},
			{id = 10225, cost = 42000, requiredIds = {10223}},
			{id = 10151, cost = 42000, requiredIds = {10150}},
			{id = 18809, cost = 10500, requiredIds = {12526}, requiredTalentId = 11366},
			{id = 10187, cost = 42000, requiredIds = {10186}},
			{id = 28609, cost = 42000, requiredIds = {10177}},
			{id = 25304, cost = 42000, requiredIds = {10181}},
			{id = 10220, cost = 42000, requiredIds = {10219}},
			{id = 33690, cost = 20000, faction = "Alliance"},
			{id = 35715, cost = 20000, faction = "Horde"},
		},
		[61] = {
			{id = 27078, cost = 46000, requiredIds = {10199}},
		},
		[62] = {
			{id = 27080, cost = 51000, requiredIds = {10202}},
			{id = 25306, cost = 42000, requiredIds = {10151}},
			{id = 30482, cost = 51000},
		},
		[63] = {
			{id = 27130, cost = 57000, requiredIds = {10170}},
			{id = 27075, cost = 57000, requiredIds = {25345}},
			{id = 27071, cost = 57000, requiredIds = {25304}},
		},
		[64] = {
			{id = 30451, cost = 63000},
			{id = 33042, cost = 2200, requiredIds = {33041}, requiredTalentId = 31661},
			{id = 27086, cost = 63000, requiredIds = {10216}},
			{id = 27134, cost = 2500, requiredIds = {13033}, requiredTalentId = 11426},
		},
		[65] = {
			{id = 37420, cost = 70000, requiredIds = {10140}},
			{id = 27133, cost = 10500, requiredIds = {13021}, requiredTalentId = 11113},
			{id = 27073, cost = 70000, requiredIds = {10207}},
			{id = 27087, cost = 70000, requiredIds = {10161}},
			{id = 35717, cost = 150000, faction = "Horde"},
			{id = 33691, cost = 150000, faction = "Alliance"},
		},
		[66] = {
			{id = 27070, cost = 78000, requiredIds = {25306}},
			{id = 27132, cost = 10500, requiredIds = {18809}, requiredTalentId = 11366},
			{id = 30455, cost = 78000},
		},
		[67] = {
			{id = 33944, cost = 87000, requiredIds = {10174}},
			{id = 27088, cost = 87000, requiredIds = {10230}},
		},
		[68] = {
			{id = 27101, cost = 96000, requiredIds = {10054}},
			{id = 66, cost = 96000},
			{id = 27131, cost = 96000, requiredIds = {10193}},
			{id = 27085, cost = 96000, requiredIds = {10187}},
		},
		[69] = {
			{id = 33946, cost = 110000, requiredIds = {27130}},
			{id = 38699, cost = 87000, requiredIds = {27075}},
			{id = 27125, cost = 110000, requiredIds = {22783}},
			{id = 27128, cost = 110000, requiredIds = {10225}},
			{id = 27072, cost = 110000, requiredIds = {27071}},
			{id = 27124, cost = 110000, requiredIds = {10220}},
		},
		[70] = {
			{id = 27082, cost = 120000, requiredIds = {27080}},
			{id = 27126, cost = 120000, requiredIds = {10157}},
			{id = 43987, cost = 120000, requiredIds = {27090,33717}},
			{id = 30449, cost = 120000},
			{id = 33933, cost = 12500, requiredIds = {27133}, requiredTalentId = 11113},
			{id = 33043, cost = 2500, requiredIds = {33042}, requiredTalentId = 31661},
			{id = 27079, cost = 120000, requiredIds = {27078}},
			{id = 33938, cost = 10500, requiredIds = {27132}, requiredTalentId = 11366},
			{id = 27074, cost = 120000, requiredIds = {27073}},
			{id = 32796, cost = 120000, requiredIds = {28609}},
			{id = 33405, cost = 10500, requiredIds = {27134}, requiredTalentId = 11426},
		},
	},
	[2] = { 
		[1] = {
			{id = 1459, cost = 10}, 
		},
		[4] = {
			{id = 116, cost = 100}, 
			{id = 5504, cost = 100}, 
		},
		[6] = {
			{id = 2136, cost = 100}, 
			{id = 143, cost = 100, requiredIds = {133}}, 
			{id = 587, cost = 100}, 
		},
		[8] = {
			{id = 5143, cost = 200}, 
			{id = 205, cost = 200, requiredIds = {116}}, 
			{id = 118, cost = 200}, 
		},
		[10] = {
			{id = 7300, cost = 400, requiredIds = {168}}, 
			{id = 122, cost = 400}, 
			{id = 5505, cost = 400, requiredIds = {5504}}, 
		},
		[12] = {
			{id = 604, cost = 600}, 
			{id = 145, cost = 600, requiredIds = {143}}, 
			{id = 130, cost = 600}, 
			{id = 597, cost = 600, requiredIds = {587}}, 
		},
		[14] = {
			{id = 1449, cost = 900}, 
			{id = 1460, cost = 900, requiredIds = {1459}}, 
			{id = 2137, cost = 900, requiredIds = {2136}}, 
			{id = 837, cost = 900, requiredIds = {205}}, 
		},
		[16] = {
			{id = 5144, cost = 1500, requiredIds = {5143}}, 
			{id = 2120, cost = 1500}, 
		},
		[18] = {
			{id = 1008, cost = 1800}, 
			{id = 3140, cost = 1800, requiredIds = {145}}, 
			{id = 475, cost = 1800}, 
		},
		[20] = {
			{id = 1953, cost = 2000}, 
			{id = 10, cost = 2000}, 
			{id = 12051, cost = 2000}, 
			{id = 543, cost = 2000}, 
			{id = 7301, cost = 2000, requiredIds = {7300}}, 
			{id = 7322, cost = 2000, requiredIds = {837}}, 
			{id = 1463, cost = 2000}, 
			{id = 12824, cost = 2000, requiredIds = {118}}, 
			{id = 32271, cost = 2000, faction = "Alliance"}, 
			{id = 3562, cost = 2000, faction = "Alliance"}, 
			{id = 3561, cost = 2000, faction = "Alliance"}, 
			{id = 3567, cost = 2000, faction = "Horde"}, 
			{id = 32272, cost = 2000, faction = "Horde"}, 
			{id = 3563, cost = 2000, faction = "Horde"}, 
			{id = 5506, cost = 2000, requiredIds = {5505}}, 
		},
		[22] = {
			{id = 8437, cost = 3000, requiredIds = {1449}}, 
			{id = 2138, cost = 3000, requiredIds = {2137}}, 
			{id = 6143, cost = 3000}, 
			{id = 2948, cost = 3000}, 
			{id = 990, cost = 3000, requiredIds = {597}}, 
		},
		[24] = {
			{id = 5145, cost = 4000, requiredIds = {5144}}, 
			{id = 2139, cost = 4000}, 
			{id = 8450, cost = 4000, requiredIds = {604}}, 
			{id = 8400, cost = 4000, requiredIds = {3140}}, 
			{id = 2121, cost = 4000, requiredIds = {2120}}, 
			{id = 12505, cost = 1000, requiredIds = {11366}, requiredTalentId = 11366}, 
		},
		[26] = {
			{id = 120, cost = 5000}, 
			{id = 865, cost = 5000, requiredIds = {122}}, 
			{id = 8406, cost = 5000, requiredIds = {7322}}, 
		},
		[28] = {
			{id = 1461, cost = 7000, requiredIds = {1460}}, 
			{id = 6141, cost = 7000, requiredIds = {10}}, 
			{id = 8494, cost = 7000, requiredIds = {1463}}, 
			{id = 8444, cost = 7000, requiredIds = {2948}}, 
			{id = 759, cost = 7000}, 
		},
		[30] = {
			{id = 8455, cost = 8000, requiredIds = {1008}}, 
			{id = 8438, cost = 8000, requiredIds = {8437}}, 
			{id = 8412, cost = 8000, requiredIds = {2138}}, 
			{id = 8457, cost = 8000, requiredIds = {543}}, 
			{id = 8401, cost = 8000, requiredIds = {8400}}, 
			{id = 7302, cost = 8000}, 
			{id = 45438, cost = 8000}, 
			{id = 12522, cost = 400, requiredIds = {12505}, requiredTalentId = 11366}, 
			{id = 3565, cost = 8000, faction = "Alliance"}, 
			{id = 3566, cost = 8000, faction = "Horde"}, 
			{id = 6127, cost = 8000, requiredIds = {5506}}, 
		},
		[32] = {
			{id = 8416, cost = 10000, requiredIds = {5145}}, 
			{id = 8422, cost = 10000, requiredIds = {2121}}, 
			{id = 8461, cost = 10000, requiredIds = {6143}}, 
			{id = 8407, cost = 10000, requiredIds = {8406}}, 
			{id = 6129, cost = 10000, requiredIds = {990}}, 
		},
		[34] = {
			{id = 8492, cost = 12000, requiredIds = {120}}, 
			{id = 6117, cost = 13000}, 
			{id = 8445, cost = 12000, requiredIds = {8444}}, 
		},
		[35] = {
			{id = 49360, cost = 15000, faction = "Alliance"}, 
			{id = 49359, cost = 2000, faction = "Alliance"}, 
			{id = 49361, cost = 15000, faction = "Horde"}, 
			{id = 49358, cost = 2000, faction = "Horde"}, 
		},
		[36] = {
			{id = 13018, cost = 400, requiredIds = {11113}, requiredTalentId = 11113}, 
			{id = 8427, cost = 13000, requiredIds = {6141}}, 
			{id = 8451, cost = 13000, requiredIds = {8450}}, 
			{id = 8402, cost = 13000, requiredIds = {8401}}, 
			{id = 8495, cost = 13000, requiredIds = {8494}}, 
			{id = 12523, cost = 650, requiredIds = {12522}, requiredTalentId = 11366}, 
		},
		[38] = {
			{id = 8439, cost = 14000, requiredIds = {8438}}, 
			{id = 8413, cost = 14000, requiredIds = {8412}}, 
			{id = 8408, cost = 14000, requiredIds = {8407}}, 
			{id = 3552, cost = 14000, requiredIds = {759}}, 
		},
		[40] = {
			{id = 8417, cost = 15000, requiredIds = {8416}}, 
			{id = 8458, cost = 15000, requiredIds = {8457}}, 
			{id = 8423, cost = 15000, requiredIds = {8422}}, 
			{id = 6131, cost = 15000, requiredIds = {865}}, 
			{id = 7320, cost = 15000, requiredIds = {7302}}, 
			{id = 12825, cost = 15000, requiredIds = {12824}}, 
			{id = 32266, cost = 15000, faction = "Alliance"}, 
			{id = 11416, cost = 15000, faction = "Alliance"}, 
			{id = 10059, cost = 15000, faction = "Alliance"}, 
			{id = 11417, cost = 15000, faction = "Horde"}, 
			{id = 32267, cost = 15000, faction = "Horde"}, 
			{id = 11418, cost = 15000, faction = "Horde"}, 
			{id = 8446, cost = 15000, requiredIds = {8445}}, 
			{id = 10138, cost = 15000, requiredIds = {6127}}, 
		},
		[42] = {
			{id = 10169, cost = 18000, requiredIds = {8455}}, 
			{id = 10156, cost = 18000, requiredIds = {1461}}, 
			{id = 10159, cost = 18000, requiredIds = {8492}}, 
			{id = 10148, cost = 18000, requiredIds = {8402}}, 
			{id = 8462, cost = 18000, requiredIds = {8461}}, 
			{id = 12524, cost = 900, requiredIds = {12523}, requiredTalentId = 11366}, 
			{id = 10144, cost = 18000, requiredIds = {6129}}, 
		},
		[44] = {
			{id = 13019, cost = 1148, requiredIds = {13018}, requiredTalentId = 11113}, 
			{id = 10185, cost = 23000, requiredIds = {8427}}, 
			{id = 10179, cost = 23000, requiredIds = {8408}}, 
			{id = 10191, cost = 23000, requiredIds = {8495}}, 
		},
		[46] = {
			{id = 10201, cost = 26000, requiredIds = {8439}}, 
			{id = 10197, cost = 26000, requiredIds = {8413}}, 
			{id = 13031, cost = 1700, requiredIds = {11426}, requiredTalentId = 11426}, 
			{id = 22782, cost = 1400, requiredIds = {6117}}, 
			{id = 10205, cost = 26000, requiredIds = {8446}}, 
		},
		[48] = {
			{id = 10211, cost = 28000, requiredIds = {8417}}, 
			{id = 10173, cost = 28000, requiredIds = {8451}}, 
			{id = 10149, cost = 28000, requiredIds = {10148}}, 
			{id = 10215, cost = 28000, requiredIds = {8423}}, 
			{id = 12525, cost = 1400, requiredIds = {12524}, requiredTalentId = 11366}, 
			{id = 10053, cost = 28000, requiredIds = {3552}}, 
		},
		[50] = {
			{id = 10160, cost = 32000, requiredIds = {10159}}, 
			{id = 10223, cost = 32000, requiredIds = {8458}}, 
			{id = 10180, cost = 32000, requiredIds = {10179}}, 
			{id = 10219, cost = 32000, requiredIds = {7320}}, 
			{id = 11419, cost = 32000, faction = "Alliance"}, 
			{id = 11420, cost = 32000, faction = "Horde"}, 
			{id = 10139, cost = 32000, requiredIds = {10138}}, 
		},
		[52] = {
			{id = 13020, cost = 1748, requiredIds = {13019}, requiredTalentId = 11113}, 
			{id = 10186, cost = 35000, requiredIds = {10185}}, 
			{id = 10177, cost = 35000, requiredIds = {8462}}, 
			{id = 13032, cost = 1748, requiredIds = {13031}, requiredTalentId = 11426}, 
			{id = 10192, cost = 35000, requiredIds = {10191}}, 
			{id = 10206, cost = 35000, requiredIds = {10205}}, 
			{id = 10145, cost = 35000, requiredIds = {10144}}, 
		},
		[54] = {
			{id = 10170, cost = 36000, requiredIds = {10169}}, 
			{id = 10202, cost = 36000, requiredIds = {10201}}, 
			{id = 10199, cost = 36000, requiredIds = {10197}}, 
			{id = 10150, cost = 36000, requiredIds = {10149}}, 
			{id = 10230, cost = 36000, requiredIds = {6131}}, 
			{id = 12526, cost = 1800, requiredIds = {12525}, requiredTalentId = 11366}, 
		},
		[56] = {
			{id = 23028, cost = 38000, requiredIds = {10157}}, 
			{id = 10157, cost = 38000, requiredIds = {10156}}, 
			{id = 10212, cost = 38000, requiredIds = {10211}}, 
			{id = 33041, cost = 1900, requiredIds = {31661}, requiredTalentId = 31661}, 
			{id = 10216, cost = 38000, requiredIds = {10215}}, 
			{id = 10181, cost = 38000, requiredIds = {10180}}, 
		},
		[58] = {
			{id = 10161, cost = 40000, requiredIds = {10160}}, 
			{id = 13033, cost = 2000, requiredIds = {13032}, requiredTalentId = 11426}, 
			{id = 22783, cost = 40000, requiredIds = {22782}}, 
			{id = 10207, cost = 40000, requiredIds = {10206}}, 
			{id = 10054, cost = 40000, requiredIds = {10053}}, 
		},
		[60] = {
			{id = 25345, cost = 42000, requiredIds = {10212}}, 
			{id = 13021, cost = 2100, requiredIds = {13020}, requiredTalentId = 11113}, 
			{id = 10187, cost = 42000, requiredIds = {10186}}, 
			{id = 10174, cost = 42000, requiredIds = {10173}}, 
			{id = 10225, cost = 42000, requiredIds = {10223}}, 
			{id = 10151, cost = 42000, requiredIds = {10150}}, 
			{id = 28609, cost = 42000, requiredIds = {10177}}, 
			{id = 25304, cost = 42000, requiredIds = {10181}}, 
			{id = 10220, cost = 42000, requiredIds = {10219}}, 
			{id = 10193, cost = 42000, requiredIds = {10192}}, 
			{id = 12826, cost = 42000, requiredIds = {12825}}, 
			{id = 18809, cost = 2100, requiredIds = {12526}, requiredTalentId = 11366}, 
			{id = 33690, cost = 20000, faction = "Alliance"}, 
			{id = 35715, cost = 20000, faction = "Horde"}, 
			{id = 28612, cost = 42000, requiredIds = {10145}}, 
			{id = 10140, cost = 42000, requiredIds = {10139}}, 
		},
		[61] = {
			{id = 27078, cost = 46000, requiredIds = {10199}}, 
		},
		[62] = {
			{id = 27080, cost = 51000, requiredIds = {10202}}, 
			{id = 25306, cost = 42000, requiredIds = {10151}}, 
			{id = 30482, cost = 51000}, 
		},
		[63] = {
			{id = 27130, cost = 57000, requiredIds = {10170}}, 
			{id = 27075, cost = 57000, requiredIds = {25345}}, 
			{id = 27071, cost = 57000, requiredIds = {25304}}, 
		},
		[64] = {
			{id = 30451, cost = 63000}, 
			{id = 33042, cost = 2200, requiredIds = {33041}, requiredTalentId = 31661}, 
			{id = 27086, cost = 63000, requiredIds = {10216}}, 
			{id = 27134, cost = 2500, requiredIds = {13033}, requiredTalentId = 11426}, 
		},
		[65] = {
			{id = 27133, cost = 3500, requiredIds = {13021}, requiredTalentId = 11113}, 
			{id = 27087, cost = 70000, requiredIds = {10161}}, 
			{id = 33691, cost = 150000, faction = "Alliance"}, 
			{id = 35717, cost = 150000, faction = "Horde"}, 
			{id = 27073, cost = 70000, requiredIds = {10207}}, 
			{id = 37420, cost = 70000, requiredIds = {10140}}, 
		},
		[66] = {
			{id = 27070, cost = 78000, requiredIds = {25306}}, 
			{id = 30455, cost = 78000}, 
			{id = 27132, cost = 3900, requiredIds = {18809}, requiredTalentId = 11366}, 
		},
		[67] = {
			{id = 33944, cost = 100000, requiredIds = {10174}}, 
			{id = 27088, cost = 87000, requiredIds = {10230}}, 
		},
		[68] = {
			{id = 27085, cost = 96000, requiredIds = {10187}}, 
			{id = 66, cost = 96000}, 
			{id = 27131, cost = 96000, requiredIds = {10193}}, 
			{id = 27101, cost = 96000, requiredIds = {10054}}, 
		},
		[69] = {
			{id = 33946, cost = 110000, requiredIds = {27130}}, 
			{id = 38699, cost = 87000, requiredIds = {27075}}, 
			{id = 27128, cost = 110000, requiredIds = {10225}}, 
			{id = 27072, cost = 110000, requiredIds = {27071}}, 
			{id = 27124, cost = 110000, requiredIds = {10220}}, 
			{id = 27125, cost = 110000, requiredIds = {22783}}, 
		},
		[70] = {
			{id = 44780, cost = 10000, requiredIds = {44425}, requiredTalentId = 44425}, 
			{id = 27127, cost = 100000, requiredIds = {27126,23028}}, 
			{id = 27082, cost = 120000, requiredIds = {27080}}, 
			{id = 27126, cost = 120000, requiredIds = {10157}}, 
			{id = 38704, cost = 100000, requiredIds = {38699}}, 
			{id = 33933, cost = 6000, requiredIds = {27133}, requiredTalentId = 11113}, 
			{id = 33043, cost = 2500, requiredIds = {33042}, requiredTalentId = 31661}, 
			{id = 27079, cost = 120000, requiredIds = {27078}}, 
			{id = 38692, cost = 150000, requiredIds = {27070}}, 
			{id = 32796, cost = 120000, requiredIds = {28609}}, 
			{id = 38697, cost = 150000, requiredIds = {27072}}, 
			{id = 33405, cost = 6000, requiredIds = {27134}, requiredTalentId = 11426}, 
			{id = 55359, cost = 5000, requiredIds = {44457}, requiredTalentId = 44457}, 
			{id = 33938, cost = 7500, requiredIds = {27132}, requiredTalentId = 11366}, 
			{id = 43987, cost = 120000, requiredIds = {27090,33717}}, 
			{id = 27074, cost = 120000, requiredIds = {27073}}, 
			{id = 30449, cost = 120000}, 
			{id = 33717, cost = 150000, requiredIds = {28612}}, 
			{id = 27090, cost = 150000, requiredIds = {37420}}, 
		},
		[71] = {
			{id = 42894, cost = 150000, requiredIds = {30451}}, 
			{id = 43023, cost = 150000, requiredIds = {27125}}, 
			{id = 43045, cost = 150000, requiredIds = {30482}}, 
			{id = 53140, cost = 100000}, 
		},
		[72] = {
			{id = 42930, cost = 150000, requiredIds = {27087}}, 
			{id = 42925, cost = 150000, requiredIds = {27086}}, 
			{id = 42913, cost = 150000, requiredIds = {30455}}, 
		},
		[73] = {
			{id = 43019, cost = 150000, requiredIds = {27131}}, 
			{id = 42890, cost = 7500, requiredIds = {33938}, requiredTalentId = 11366}, 
			{id = 42858, cost = 150000, requiredIds = {27074}}, 
		},
		[74] = {
			{id = 42939, cost = 150000, requiredIds = {27085}}, 
			{id = 42872, cost = 150000, requiredIds = {27079}}, 
			{id = 42832, cost = 150000, requiredIds = {28692}}, 
			{id = 53142, cost = 100000}, 
		},
		[75] = {
			{id = 42843, cost = 150000, requiredIds = {38704}}, 
			{id = 42944, cost = 7500, requiredIds = {33933}, requiredTalentId = 11113}, 
			{id = 42949, cost = 7500, requiredIds = {33043}, requiredTalentId = 31661}, 
			{id = 42917, cost = 150000, requiredIds = {27088}}, 
			{id = 42841, cost = 150000, requiredIds = {38697}}, 
			{id = 44614, cost = 150000}, 
			{id = 43038, cost = 7500, requiredIds = {33405}, requiredTalentId = 11426}, 
			{id = 42955, cost = 150000, requiredIds = {37420,33717}}, 
		},
		[76] = {
			{id = 42896, cost = 150000, requiredIds = {42894}}, 
			{id = 42920, cost = 150000, requiredIds = {27082}}, 
			{id = 43015, cost = 150000, requiredIds = {33944}}, 
		},
		[77] = {
			{id = 43017, cost = 150000, requiredIds = {33946}}, 
			{id = 42891, cost = 7500, requiredIds = {42890}, requiredTalentId = 11366}, 
			{id = 42985, cost = 150000, requiredIds = {27101}}, 
		},
		[78] = {
			{id = 43010, cost = 150000, requiredIds = {27128}}, 
			{id = 42833, cost = 150000, requiredIds = {42832}}, 
			{id = 42914, cost = 150000, requiredIds = {42913}}, 
			{id = 42859, cost = 150000, requiredIds = {42858}}, 
		},
		[79] = {
			{id = 42846, cost = 150000, requiredIds = {42843}}, 
			{id = 42931, cost = 150000, requiredIds = {42930}}, 
			{id = 42926, cost = 150000, requiredIds = {42925}}, 
			{id = 43012, cost = 150000, requiredIds = {32796}}, 
			{id = 42842, cost = 150000, requiredIds = {42841}}, 
			{id = 43008, cost = 150000, requiredIds = {27124}}, 
			{id = 43024, cost = 150000, requiredIds = {43023}}, 
			{id = 43020, cost = 150000, requiredIds = {43019}}, 
			{id = 43046, cost = 150000, requiredIds = {43045}}, 
		},
		[80] = {
			{id = 44781, cost = 15000, requiredIds = {44780}, requiredTalentId = 44425}, 
			{id = 42897, cost = 150000, requiredIds = {42896}}, 
			{id = 43002, cost = 150000, requiredIds = {42995,27127}}, 
			{id = 42921, cost = 150000, requiredIds = {42920}}, 
			{id = 42995, cost = 150000, requiredIds = {27126}}, 
			{id = 42945, cost = 7500, requiredIds = {42944}, requiredTalentId = 11113}, 
			{id = 42940, cost = 150000, requiredIds = {42939}}, 
			{id = 42950, cost = 7500, requiredIds = {42949}, requiredTalentId = 31661}, 
			{id = 42873, cost = 150000, requiredIds = {42872}}, 
			{id = 47610, cost = 150000, requiredIds = {44614}}, 
			{id = 43039, cost = 7500, requiredIds = {43038}, requiredTalentId = 11426}, 
			{id = 55360, cost = 7500, requiredIds = {55359}, requiredTalentId = 44457}, 
			{id = 55342, cost = 150000}, 
			{id = 58659, cost = 150000, requiredIds = {43987,42956}}, 
			{id = 42956, cost = 150000, requiredIds = {42955}}, 
		},
	},
}

FatCooldowns.PriestSpells =  {
 	[0] = { 
 		[1] = {
 			{id = 1243, cost = 10}
 		},
 		[4] = {
 			{id = 2052, cost = 100, requiredIds = {2050}},
 			{id = 589, cost = 100}
 		},
 		[6] = {
 			{id = 17, cost = 100},
 			{id = 591, cost = 100, requiredIds = {585}}
 		},
 		[8] = {
 			{id = 586, cost = 200},
 			{id = 139, cost = 200}
 		},
 		[10] = {
 			{id = 2053, cost = 300, requiredIds = {2052}},
 			{id = 8092, cost = 300},
 			{id = 2006, cost = 300},
 			{id = 594, cost = 300, requiredIds = {589}}
 		},
 		[12] = {
 			{id = 588, cost = 800},
 			{id = 1244, cost = 800, requiredIds = {1243}},
 			{id = 592, cost = 800, requiredIds = {17}}
 		},
 		[14] = {
 			{id = 528, cost = 1200},
 			{id = 8122, cost = 1200},
 			{id = 6074, cost = 1200, requiredIds = {139}},
 			{id = 598, cost = 1200, requiredIds = {591}}
 		},
 		[16] = {
 			{id = 2054, cost = 1600},
 			{id = 8102, cost = 1600, requiredIds = {8092}}
 		},
 		[18] = {
 			{id = 19236, cost = 100, races = {1, 3}},
 			{id = 527, cost = 2000},
 			{id = 600, cost = 2000, requiredIds = {592}},
 			{id = 970, cost = 2000, requiredIds = {594}},
 			{id = 19296, cost = 100, race = 4}
 		},
 		[20] = {
 			{id = 9578, cost = 3000, requiredIds = {586}},
 			{id = 2061, cost = 3000},
 			{id = 19281, cost = 150, race = 8},
 			{id = 14914, cost = 3000},
 			{id = 7128, cost = 3000, requiredIds = {588}},
 			{id = 453, cost = 3000},
 			{id = 6075, cost = 3000, requiredIds = {6074}},
 			{id = 9484, cost = 3000},
 			{id = 19261, cost = 200, race = 5}
 		},
 		[22] = {
 			{id = 2055, cost = 4000, requiredIds = {2054}},
 			{id = 8103, cost = 4000, requiredIds = {8102}},
 			{id = 2096, cost = 4000},
 			{id = 2010, cost = 4000, requiredIds = {2006}},
 			{id = 984, cost = 4000, requiredIds = {598}}
 		},
 		[24] = {
 			{id = 15262, cost = 5000, requiredIds = {14914}},
 			{id = 8129, cost = 5000},
 			{id = 1245, cost = 5000, requiredIds = {1244}},
 			{id = 3747, cost = 5000, requiredIds = {600}}
 		},
 		[26] = {
 			{id = 19238, cost = 300, races = {1, 3}},
 			{id = 9472, cost = 6000, requiredIds = {2061}},
 			{id = 6076, cost = 6000, requiredIds = {6075}},
 			{id = 992, cost = 6000, requiredIds = {970}},
 			{id = 19299, cost = 300, race = 4, requiredIds = {19296}}
 		},
 		[28] = {
 			{id = 19276, cost = 400, race = 5},
 			{id = 6063, cost = 8000, requiredIds = {2055}},
 			{id = 15430, cost = 400, requiredTalentId = 15237},
 			{id = 8104, cost = 8000, requiredIds = {8103}},
 			{id = 17311, cost = 400, requiredTalentId = 15407},
 			{id = 8124, cost = 8000, requiredIds = {8122}},
 			{id = 19308, cost = 400, race = 8}
 		},
 		[30] = {
 			{id = 19289, cost = 500, race = 4},
 			{id = 9579, cost = 10000, requiredIds = {9578}},
 			{id = 19271, cost = 450, race = 1},
 			{id = 19282, cost = 500, race = 8},
 			{id = 15263, cost = 10000, requiredIds = {15262}},
 			{id = 602, cost = 10000, requiredIds = {7128}},
 			{id = 605, cost = 10000},
 			{id = 6065, cost = 10000, requiredIds = {3747}},
 			{id = 596, cost = 10000},
 			{id = 976, cost = 10000},
 			{id = 1004, cost = 10000, requiredIds = {984}},
 			{id = 19262, cost = 500, race = 5}
 		},
 		[32] = {
 			{id = 552, cost = 11000},
 			{id = 9473, cost = 11000, requiredIds = {9472}},
 			{id = 8131, cost = 11000, requiredIds = {8129}},
 			{id = 6077, cost = 11000, requiredIds = {6076}}
 		},
 		[34] = {
 			{id = 19240, cost = 600, races = {1, 3}},
 			{id = 6064, cost = 12000, requiredIds = {6063}},
 			{id = 1706, cost = 12000},
 			{id = 8105, cost = 12000, requiredIds = {8104}},
 			{id = 10880, cost = 12000, requiredIds = {2010}},
 			{id = 2767, cost = 12000, requiredIds = {992}},
 			{id = 19302, cost = 600, race = 4, requiredIds = {19299}}
 		},
 		[36] = {
 			{id = 19277, cost = 700, race = 5},
 			{id = 988, cost = 14000, requiredIds = {527}},
 			{id = 15264, cost = 14000, requiredIds = {15263}},
 			{id = 15431, cost = 700, requiredIds = {15430}, requiredTalentId = 15237},
 			{id = 17312, cost = 700, requiredIds = {17311}, requiredTalentId = 15407},
 			{id = 8192, cost = 14000, requiredIds = {453}},
 			{id = 2791, cost = 14000, requiredIds = {1245}},
 			{id = 6066, cost = 14000, requiredIds = {6065}},
 			{id = 19309, cost = 700, race = 8}
 		},
 		[38] = {
 			{id = 9474, cost = 16000, requiredIds = {9473}},
 			{id = 6078, cost = 16000, requiredIds = {6077}},
 			{id = 6060, cost = 16000, requiredIds = {1004}}
 		},
 		[40] = {
 			{id = 14818, cost = 900, requiredTalentId = 14752},
 			{id = 19291, cost = 900, race = 4, requiredIds = {19289}},
 			{id = 9592, cost = 18000, requiredIds = {9579}},
 			{id = 19273, cost = 810, race = 1},
 			{id = 2060, cost = 18000},
 			{id = 19283, cost = 900, race = 8},
 			{id = 1006, cost = 18000, requiredIds = {602}},
 			{id = 10874, cost = 18000, requiredIds = {8131}},
 			{id = 8106, cost = 18000, requiredIds = {8105}},
 			{id = 996, cost = 18000, requiredIds = {596}},
 			{id = 9485, cost = 18000, requiredIds = {9484}},
 			{id = 19264, cost = 900, race = 5}
 		},
 		[42] = {
 			{id = 19241, cost = 1100, races = {1, 3}},
 			{id = 15265, cost = 22000, requiredIds = {15264}},
 			{id = 10898, cost = 22000, requiredIds = {6066}},
 			{id = 10888, cost = 22000, requiredIds = {8124}},
 			{id = 10957, cost = 22000, requiredIds = {976}},
 			{id = 10892, cost = 22000, requiredIds = {2767}},
 			{id = 19303, cost = 1100, race = 4, requiredIds = {19302}}
 		},
 		[44] = {
 			{id = 19278, cost = 1200, race = 5},
 			{id = 10915, cost = 24000, requiredIds = {9474}},
 			{id = 27799, cost = 1200, requiredIds = {15431}, requiredTalentId = 15237},
 			{id = 10911, cost = 24000, requiredIds = {605}},
 			{id = 17313, cost = 1200, requiredIds = {17312}, requiredTalentId = 15407},
 			{id = 10909, cost = 24000, requiredIds = {2096}},
 			{id = 10927, cost = 24000, requiredIds = {6078}},
 			{id = 19310, cost = 1000, race = 8}
 		},
 		[46] = {
 			{id = 10963, cost = 26000, requiredIds = {2060}},
 			{id = 10945, cost = 26000, requiredIds = {8106}},
 			{id = 10881, cost = 26000, requiredIds = {10880}},
 			{id = 10933, cost = 26000, requiredIds = {6060}}
 		},
 		[48] = {
 			{id = 15266, cost = 28000, requiredIds = {15265}},
 			{id = 10875, cost = 28000, requiredIds = {10874}},
 			{id = 10937, cost = 28000, requiredIds = {2791}},
 			{id = 10899, cost = 28000, requiredIds = {10898}}
 		},
 		[50] = {
 			{id = 19242, cost = 1500, races = {1, 3}},
 			{id = 14819, cost = 1500, requiredIds = {14818}, requiredTalentId = 14752},
 			{id = 19292, cost = 1500, race = 4, requiredIds = {19291}},
 			{id = 10941, cost = 30000, requiredIds = {9592}},
 			{id = 10916, cost = 30000, requiredIds = {10915}},
 			{id = 19284, cost = 1500, race = 8},
 			{id = 10951, cost = 30000, requiredIds = {1006}},
 			{id = 27870, cost = 1200, requiredTalentId = 724},
 			{id = 10960, cost = 30000, requiredIds = {996}},
 			{id = 10928, cost = 30000, requiredIds = {10927}},
 			{id = 10893, cost = 30000, requiredIds = {10892}},
 			{id = 19304, cost = 1500, race = 4, requiredIds = {19303}},
 			{id = 19265, cost = 1500, race = 5}
 		},
 		[52] = {
 			{id = 19279, cost = 1900, race = 5},
 			{id = 10964, cost = 38000, requiredIds = {10963}},
 			{id = 27800, cost = 1900, requiredIds = {27799}, requiredTalentId = 15237},
 			{id = 10946, cost = 38000, requiredIds = {10945}},
 			{id = 17314, cost = 1900, requiredIds = {17313}, requiredTalentId = 15407},
 			{id = 10953, cost = 38000, requiredIds = {8192}},
 			{id = 19311, cost = 1200, race = 8}
 		},
 		[54] = {
 			{id = 15267, cost = 40000, requiredIds = {15266}},
 			{id = 10900, cost = 40000, requiredIds = {10899}},
 			{id = 10934, cost = 40000, requiredIds = {10933}}
 		},
 		[56] = {
 			{id = 10917, cost = 42000, requiredIds = {10916}},
 			{id = 10876, cost = 42000, requiredIds = {10875}},
 			{id = 10890, cost = 42000, requiredIds = {10888}},
 			{id = 10929, cost = 42000, requiredIds = {10928}},
 			{id = 10958, cost = 42000, requiredIds = {10957}}
 		},
 		[58] = {
 			{id = 19243, cost = 2200, races = {1, 3}},
 			{id = 10965, cost = 44000, requiredIds = {10964}},
 			{id = 10947, cost = 44000, requiredIds = {10946}},
 			{id = 10912, cost = 44000, requiredIds = {10911}},
 			{id = 20770, cost = 44000, requiredIds = {10881}},
 			{id = 10894, cost = 44000, requiredIds = {10893}},
 			{id = 19305, cost = 2200, race = 4, requiredIds = {19304}}
 		},
 		[60] = {
 			{id = 19280, cost = 2300, race = 5},
 			{id = 27841, cost = 2300, requiredIds = {14819}, requiredTalentId = 14752},
 			{id = 19293, cost = 2070, race = 4, requiredIds = {19292}},
 			{id = 10942, cost = 46000, requiredIds = {10941}},
 			{id = 19285, cost = 2300, race = 8},
 			{id = 15261, cost = 46000, requiredIds = {15267}},
 			{id = 27801, cost = 2300, requiredIds = {27800}, requiredTalentId = 15237},
 			{id = 10952, cost = 46000, requiredIds = {10951}},
 			{id = 27871, cost = 1500, requiredIds = {27870}, requiredTalentId = 724},
 			{id = 18807, cost = 2300, requiredIds = {17314}, requiredTalentId = 15407},
 			{id = 10938, cost = 46000, requiredIds = {10937}},
 			{id = 10901, cost = 46000, requiredIds = {10900}},
 			{id = 10961, cost = 46000, requiredIds = {10960}},
 			{id = 27681, cost = 2300, requiredIds = {27841}},
 			{id = 10955, cost = 46000, requiredIds = {9485}},
 			{id = 19312, cost = 2300, race = 8},
 			{id = 19266, cost = 2070, race = 5}
 		}
 	},
 	[1] = { 
 		[1] = {
 			{id = 1243, cost = 10},
 		},
 		[4] = {
 			{id = 2052, cost = 100, requiredIds = {2050}},
 			{id = 589, cost = 100},
 		},
 		[6] = {
 			{id = 17, cost = 100},
 			{id = 591, cost = 100, requiredIds = {585}},
 		},
 		[8] = {
 			{id = 139, cost = 200},
 			{id = 586, cost = 200},
 		},
 		[10] = {
 			{id = 2053, cost = 300, requiredIds = {2052}},
 			{id = 2006, cost = 300},
 			{id = 8092, cost = 300},
 			{id = 594, cost = 300, requiredIds = {589}},
 			{id = 2652, cost = 90, races = {5, 10}},
 			{id = 32548, cost = 100, race = 11},
 			{id = 10797, cost = 90, race = 4},
 			{id = 9035, cost = 90, race = 8},
 			{id = 13908, cost = 90, races = {1, 3}},
 		},
 		[12] = {
 			{id = 588, cost = 800},
 			{id = 1244, cost = 800, requiredIds = {1243}},
 			{id = 592, cost = 800, requiredIds = {17}},
 		},
 		[14] = {
 			{id = 528, cost = 1200},
 			{id = 6074, cost = 1200, requiredIds = {139}},
 			{id = 598, cost = 1200, requiredIds = {591}},
 			{id = 8122, cost = 1200},
 		},
 		[16] = {
 			{id = 2054, cost = 1600},
 			{id = 8102, cost = 1600, requiredIds = {8092}},
 		},
 		[18] = {
 			{id = 527, cost = 2000},
 			{id = 600, cost = 2000, requiredIds = {592}},
 			{id = 970, cost = 2000, requiredIds = {594}},
 			{id = 19296, cost = 100, requiredIds = {10797}, race = 4},
 			{id = 19236, cost = 100, requiredIds = {13908}, races = {1, 3}},
 		},
 		[20] = {
 			{id = 6346, cost = 800},
 			{id = 7128, cost = 3000, requiredIds = {588}},
 			{id = 9484, cost = 3000},
 			{id = 2061, cost = 3000},
 			{id = 14914, cost = 3000},
 			{id = 6075, cost = 3000, requiredIds = {6074}},
 			{id = 2944, cost = 100, race = 5},
 			{id = 9578, cost = 3000, requiredIds = {586}},
 			{id = 453, cost = 3000},
 			{id = 19261, cost = 150, requiredIds = {2652}, races = {5, 10}},
 			{id = 44041, cost = 100, races = {3, 11}},
 			{id = 2651, cost = 100, race = 4},
 			{id = 19281, cost = 150, requiredIds = {9035}, race = 8},
 			{id = 18137, cost = 100, race = 8},
 			{id = 13896, cost = 100, race = 1},
 			{id = 32676, cost = 100, race = 10},
 		},
 		[22] = {
 			{id = 2055, cost = 4000, requiredIds = {2054}},
 			{id = 2010, cost = 4000, requiredIds = {2006}},
 			{id = 984, cost = 4000, requiredIds = {598}},
 			{id = 8103, cost = 4000, requiredIds = {8102}},
 			{id = 2096, cost = 4000},
 		},
 		[24] = {
 			{id = 8129, cost = 5000},
 			{id = 1245, cost = 5000, requiredIds = {1244}},
 			{id = 3747, cost = 5000, requiredIds = {600}},
 			{id = 15262, cost = 5000, requiredIds = {14914}},
 		},
 		[26] = {
 			{id = 9472, cost = 6000, requiredIds = {2061}},
 			{id = 6076, cost = 6000, requiredIds = {6075}},
 			{id = 992, cost = 6000, requiredIds = {970}},
 			{id = 19299, cost = 300, requiredIds = {19296}, race = 4},
 			{id = 19238, cost = 300, requiredIds = {19236}, races = {1, 3}},
 		},
 		[28] = {
 			{id = 6063, cost = 8000, requiredIds = {2055}},
 			{id = 15430, cost = 400, requiredIds = {15237}, requiredTalentId = 15237},
 			{id = 19276, cost = 400, requiredIds = {2944}, race = 5},
 			{id = 8104, cost = 8000, requiredIds = {8103}},
 			{id = 17311, cost = 400, requiredIds = {15407}, requiredTalentId = 15407},
 			{id = 8124, cost = 8000, requiredIds = {8122}},
 			{id = 19308, cost = 400, requiredIds = {18137}, race = 8},
 		},
 		[30] = {
 			{id = 602, cost = 10000, requiredIds = {7128}},
 			{id = 6065, cost = 10000, requiredIds = {3747}},
 			{id = 15263, cost = 10000, requiredIds = {15262}},
 			{id = 596, cost = 10000},
 			{id = 1004, cost = 10000, requiredIds = {984}},
 			{id = 9579, cost = 10000, requiredIds = {9578}},
 			{id = 605, cost = 10000},
 			{id = 976, cost = 10000},
 			{id = 19262, cost = 500, requiredIds = {19261}, races = {5, 10}},
 			{id = 44043, cost = 500, requiredIds = {44041}, races = {3, 11}},
 			{id = 19282, cost = 500, requiredIds = {19281}, race = 8},
 			{id = 19271, cost = 500, requiredIds = {13896}, race = 1},
 		},
 		[32] = {
 			{id = 8131, cost = 11000, requiredIds = {8129}},
 			{id = 552, cost = 11000},
 			{id = 9473, cost = 11000, requiredIds = {9472}},
 			{id = 6077, cost = 11000, requiredIds = {6076}},
 		},
 		[34] = {
 			{id = 1706, cost = 12000},
 			{id = 6064, cost = 12000, requiredIds = {6063}},
 			{id = 10880, cost = 12000, requiredIds = {2010}},
 			{id = 8105, cost = 12000, requiredIds = {8104}},
 			{id = 2767, cost = 12000, requiredIds = {992}},
 			{id = 19302, cost = 600, requiredIds = {19299}, race = 4},
 			{id = 19240, cost = 600, requiredIds = {19238}, races = {1, 3}},
 		},
 		[36] = {
 			{id = 988, cost = 14000, requiredIds = {527}},
 			{id = 2791, cost = 14000, requiredIds = {1245}},
 			{id = 6066, cost = 14000, requiredIds = {6065}},
 			{id = 15264, cost = 14000, requiredIds = {15263}},
 			{id = 15431, cost = 700, requiredIds = {15430}, requiredTalentId = 15237},
 			{id = 19277, cost = 700, requiredIds = {19276}, race = 5},
 			{id = 17312, cost = 700, requiredIds = {17311}, requiredTalentId = 15407},
 			{id = 8192, cost = 14000, requiredIds = {453}},
 			{id = 19309, cost = 700, requiredIds = {19308}, race = 8},
 		},
 		[38] = {
 			{id = 9474, cost = 16000, requiredIds = {9473}},
 			{id = 6078, cost = 16000, requiredIds = {6077}},
 			{id = 6060, cost = 16000, requiredIds = {1004}},
 		},
 		[40] = {
 			{id = 14818, cost = 900, requiredIds = {14752}, requiredTalentId = 14752},
 			{id = 1006, cost = 18000, requiredIds = {602}},
 			{id = 10874, cost = 18000, requiredIds = {8131}},
 			{id = 9485, cost = 18000, requiredIds = {9484}},
 			{id = 2060, cost = 18000},
 			{id = 996, cost = 18000, requiredIds = {596}},
 			{id = 9592, cost = 18000, requiredIds = {9579}},
 			{id = 8106, cost = 18000, requiredIds = {8105}},
 			{id = 19264, cost = 900, requiredIds = {19262}, races = {5, 10}},
 			{id = 44044, cost = 900, requiredIds = {44043}, races = {3, 11}},
 			{id = 19283, cost = 900, requiredIds = {19282}, race = 8},
 			{id = 19273, cost = 900, requiredIds = {19271}, race = 1},
 		},
 		[42] = {
 			{id = 10898, cost = 22000, requiredIds = {6066}},
 			{id = 15265, cost = 22000, requiredIds = {15264}},
 			{id = 10888, cost = 22000, requiredIds = {8124}},
 			{id = 10957, cost = 22000, requiredIds = {976}},
 			{id = 10892, cost = 22000, requiredIds = {2767}},
 			{id = 19303, cost = 1100, requiredIds = {19302}, race = 4},
 			{id = 19241, cost = 1100, requiredIds = {19240}, races = {1, 3}},
 		},
 		[44] = {
 			{id = 10915, cost = 24000, requiredIds = {9474}},
 			{id = 27799, cost = 1200, requiredIds = {15431}, requiredTalentId = 15237},
 			{id = 10927, cost = 24000, requiredIds = {6078}},
 			{id = 19278, cost = 1200, requiredIds = {19277}, race = 5},
 			{id = 10911, cost = 24000, requiredIds = {605}},
 			{id = 17313, cost = 1200, requiredIds = {17312}, requiredTalentId = 15407},
 			{id = 10909, cost = 24000, requiredIds = {2096}},
 			{id = 19310, cost = 1200, requiredIds = {19309}, race = 8},
 		},
 		[46] = {
 			{id = 10963, cost = 26000, requiredIds = {2060}},
 			{id = 10881, cost = 26000, requiredIds = {10880}},
 			{id = 10933, cost = 26000, requiredIds = {6060}},
 			{id = 10945, cost = 26000, requiredIds = {8106}},
 		},
 		[48] = {
 			{id = 10875, cost = 28000, requiredIds = {10874}},
 			{id = 10937, cost = 28000, requiredIds = {2791}},
 			{id = 10899, cost = 28000, requiredIds = {10898}},
 			{id = 21562, cost = 28000, requiredIds = {10937}},
 			{id = 15266, cost = 28000, requiredIds = {15265}},
 		},
 		[50] = {
 			{id = 14819, cost = 1500, requiredIds = {14818}, requiredTalentId = 14752},
 			{id = 10951, cost = 30000, requiredIds = {1006}},
 			{id = 10916, cost = 30000, requiredIds = {10915}},
 			{id = 27870, cost = 1200, requiredIds = {724}, requiredTalentId = 724},
 			{id = 10960, cost = 30000, requiredIds = {996}},
 			{id = 10928, cost = 30000, requiredIds = {10927}},
 			{id = 10941, cost = 30000, requiredIds = {9592}},
 			{id = 10893, cost = 30000, requiredIds = {10892}},
 			{id = 19265, cost = 1500, requiredIds = {19264}, races = {5, 10}},
 			{id = 44045, cost = 1500, requiredIds = {44044}, races = {3, 11}},
 			{id = 19304, cost = 1500, requiredIds = {19303}, race = 4},
 			{id = 19284, cost = 1500, requiredIds = {19283}, race = 8},
 			{id = 19242, cost = 1500, requiredIds = {19241}, races = {1, 3}},
 			{id = 19274, cost = 1500, requiredIds = {19273}, race = 1},
 		},
 		[52] = {
 			{id = 10964, cost = 38000, requiredIds = {10963}},
 			{id = 27800, cost = 1900, requiredIds = {27799}, requiredTalentId = 15237},
 			{id = 19279, cost = 1900, requiredIds = {19278}, race = 5},
 			{id = 10946, cost = 38000, requiredIds = {10945}},
 			{id = 17314, cost = 1900, requiredIds = {17313}, requiredTalentId = 15407},
 			{id = 10953, cost = 38000, requiredIds = {8192}},
 			{id = 19311, cost = 1900, requiredIds = {19310}, race = 8},
 		},
 		[54] = {
 			{id = 10900, cost = 40000, requiredIds = {10899}},
 			{id = 15267, cost = 40000, requiredIds = {15266}},
 			{id = 10934, cost = 40000, requiredIds = {10933}},
 		},
 		[56] = {
 			{id = 10876, cost = 42000, requiredIds = {10875}},
 			{id = 34863, cost = 2100, requiredIds = {34861}, requiredTalentId = 34861},
 			{id = 10917, cost = 42000, requiredIds = {10916}},
 			{id = 10929, cost = 42000, requiredIds = {10928}},
 			{id = 27683, cost = 42000, requiredIds = {10958}},
 			{id = 10890, cost = 42000, requiredIds = {10888}},
 			{id = 10958, cost = 42000, requiredIds = {10957}},
 		},
 		[58] = {
 			{id = 10965, cost = 44000, requiredIds = {10964}},
 			{id = 20770, cost = 44000, requiredIds = {10881}},
 			{id = 10947, cost = 44000, requiredIds = {10946}},
 			{id = 10912, cost = 44000, requiredIds = {10911}},
 			{id = 10894, cost = 44000, requiredIds = {10893}},
 			{id = 19305, cost = 2200, requiredIds = {19304}, race = 4},
 			{id = 19243, cost = 2200, requiredIds = {19242}, races = {1, 3}},
 		},
 		[60] = {
 			{id = 27841, cost = 2300, requiredIds = {14819}, requiredTalentId = 14752},
 			{id = 10952, cost = 46000, requiredIds = {10951}},
 			{id = 10938, cost = 46000, requiredIds = {10937}},
 			{id = 10901, cost = 46000, requiredIds = {10900}},
 			{id = 21564, cost = 46000, requiredIds = {21562}},
 			{id = 27681, cost = 2300, requiredIds = {27841}, requiredTalentId = 14752},
 			{id = 10955, cost = 46000, requiredIds = {9485}},
 			{id = 34864, cost = 2300, requiredIds = {34863}, requiredTalentId = 34861},
 			{id = 25314, cost = 65000, requiredIds = {10965}},
 			{id = 15261, cost = 46000, requiredIds = {15267}},
 			{id = 27801, cost = 2300, requiredIds = {27800}, requiredTalentId = 15237},
 			{id = 27871, cost = 1500, requiredIds = {27870}, requiredTalentId = 724},
 			{id = 10961, cost = 46000, requiredIds = {10960}},
 			{id = 25316, cost = 6500, requiredIds = {10961}},
 			{id = 25315, cost = 6500, requiredIds = {10929}},
 			{id = 19280, cost = 2300, requiredIds = {19279}, race = 5},
 			{id = 10942, cost = 46000, requiredIds = {10941}},
 			{id = 18807, cost = 2300, requiredIds = {17314}, requiredTalentId = 15407},
 			{id = 19266, cost = 2300, requiredIds = {19265}, races = {5, 10}},
 			{id = 34916, cost = 2300, requiredIds = {34914}, requiredTalentId = 34914},
 			{id = 44046, cost = 2300, requiredIds = {44045}, races = {3, 11}},
 			{id = 19285, cost = 2300, requiredIds = {19284}, race = 8},
 			{id = 19312, cost = 2300, requiredIds = {19311}, race = 8},
 			{id = 19275, cost = 2300, requiredIds = {19274}, race = 1},
 		},
 		[61] = {
 			{id = 25233, cost = 53000, requiredIds = {10917}},
 			{id = 25363, cost = 53000, requiredIds = {10934}},
 		},
 		[62] = {
 			{id = 32379, cost = 59000},
 		},
 		[63] = {
 			{id = 25379, cost = 65000, requiredIds = {10876}},
 			{id = 25210, cost = 65000, requiredIds = {25314}},
 			{id = 25372, cost = 65000, requiredIds = {10947}},
 		},
 		[64] = {
 			{id = 32546, cost = 72000},
 		},
 		[65] = {
 			{id = 25217, cost = 80000, requiredIds = {10901}},
 			{id = 34865, cost = 2300, requiredIds = {34864}, requiredTalentId = 34861},
 			{id = 25221, cost = 80000, requiredIds = {25315}},
 			{id = 25367, cost = 80000, requiredIds = {10894}},
 		},
 		[66] = {
 			{id = 25384, cost = 65000, requiredIds = {15261}},
 			{id = 25429, cost = 89000, requiredIds = {10942}},
 			{id = 34433, cost = 89000},
 			{id = 25446, cost = 6500, requiredIds = {19305}, race = 4},
 			{id = 25437, cost = 6500, requiredIds = {19243}, races = {1, 3}},
 		},
 		[67] = {
 			{id = 25235, cost = 99000, requiredIds = {25233}},
 			{id = 25596, cost = 99000, requiredIds = {10953}},
 		},
 		[68] = {
 			{id = 25213, cost = 110000, requiredIds = {25210}},
 			{id = 25331, cost = 3250, requiredIds = {27801}, requiredTalentId = 15237},
 			{id = 25308, cost = 110000, requiredIds = {25316}},
 			{id = 33076, cost = 110000},
 			{id = 25435, cost = 110000, requiredIds = {20770}},
 			{id = 25467, cost = 6500, requiredIds = {19280}, race = 5},
 			{id = 25387, cost = 6500, requiredIds = {18807}, requiredTalentId = 15407},
 			{id = 25433, cost = 110000, requiredIds = {10958}},
 			{id = 25477, cost = 6500, requiredIds = {19312}, race = 8},
 		},
 		[69] = {
 			{id = 25431, cost = 65000, requiredIds = {10952}},
 			{id = 25364, cost = 65000, requiredIds = {25363}},
 			{id = 25375, cost = 65000, requiredIds = {25372}},
 		},
 		[70] = {
 			{id = 25312, cost = 2300, requiredIds = {27841}, requiredTalentId = 14752},
 			{id = 25380, cost = 110000, requiredIds = {25379}},
 			{id = 32375, cost = 110000, requiredIds = {988}},
 			{id = 25389, cost = 65000, requiredIds = {10938}},
 			{id = 25218, cost = 140000, requiredIds = {25217}},
 			{id = 32999, cost = 3400, requiredIds = {25312}, requiredTalentId = 14752},
 			{id = 34866, cost = 2300, requiredIds = {34865}, requiredTalentId = 34861},
 			{id = 28275, cost = 1500, requiredIds = {27871}, requiredTalentId = 724},
 			{id = 25222, cost = 140000, requiredIds = {25221}},
 			{id = 32996, cost = 110000, requiredIds = {32379}},
 			{id = 25368, cost = 140000, requiredIds = {25367}},
 			{id = 25461, cost = 6500, requiredIds = {19266}, races = {5, 10}},
 			{id = 34917, cost = 2300, requiredIds = {34916}, requiredTalentId = 34914},
 			{id = 44047, cost = 3250, requiredIds = {44046}, races = {3, 11}},
 			{id = 25470, cost = 6500, requiredIds = {19285}, race = 8},
 			{id = 25441, cost = 6500, requiredIds = {19275}, race = 1},
 		},
 	},
 	[2] = { 
 		[1] = {
 			{id = 1243, cost = 10}, 
 		},
 		[4] = {
 			{id = 2052, cost = 100, requiredIds = {2050}}, 
 			{id = 589, cost = 100}, 
 		},
 		[6] = {
 			{id = 17, cost = 100}, 
 			{id = 591, cost = 100, requiredIds = {585}}, 
 		},
 		[8] = {
 			{id = 586, cost = 200}, 
 			{id = 139, cost = 200}, 
 		},
 		[10] = {
 			{id = 2053, cost = 300, requiredIds = {2052}}, 
 			{id = 8092, cost = 300}, 
 			{id = 2006, cost = 300}, 
 			{id = 594, cost = 300, requiredIds = {589}}, 
 		},
 		[12] = {
 			{id = 588, cost = 800}, 
 			{id = 1244, cost = 800, requiredIds = {1243}}, 
 			{id = 592, cost = 800, requiredIds = {17}}, 
 		},
 		[14] = {
 			{id = 528, cost = 1200}, 
 			{id = 8122, cost = 1200}, 
 			{id = 6074, cost = 1200, requiredIds = {139}}, 
 			{id = 598, cost = 1200, requiredIds = {591}}, 
 		},
 		[16] = {
 			{id = 2054, cost = 1600}, 
 			{id = 8102, cost = 1600, requiredIds = {8092}}, 
 		},
 		[18] = {
 			{id = 527, cost = 2000}, 
 			{id = 600, cost = 2000, requiredIds = {592}}, 
 			{id = 970, cost = 2000, requiredIds = {594}}, 
 		},
 		[20] = {
 			{id = 2944, cost = 3000}, 
 			{id = 6346, cost = 0800}, 
 			{id = 2061, cost = 3000}, 
 			{id = 14914, cost = 3000}, 
 			{id = 15237, cost = 3000}, 
 			{id = 7128, cost = 3000, requiredIds = {588}}, 
 			{id = 453, cost = 3000}, 
 			{id = 6075, cost = 3000, requiredIds = {6074}}, 
 			{id = 9484, cost = 3000}, 
 		},
 		[22] = {
 			{id = 2055, cost = 4000, requiredIds = {2054}}, 
 			{id = 8103, cost = 4000, requiredIds = {8102}}, 
 			{id = 2096, cost = 4000}, 
 			{id = 2010, cost = 4000, requiredIds = {2006}}, 
 			{id = 984, cost = 4000, requiredIds = {598}}, 
 		},
 		[24] = {
 			{id = 15262, cost = 5000, requiredIds = {14914}}, 
 			{id = 8129, cost = 5000}, 
 			{id = 1245, cost = 5000, requiredIds = {1244}}, 
 			{id = 3747, cost = 5000, requiredIds = {600}}, 
 		},
 		[26] = {
 			{id = 19238, cost = 60, requiredIds = {19236}, requiredTalentId = 19236}, 
 			{id = 9472, cost = 6000, requiredIds = {2061}}, 
 			{id = 6076, cost = 6000, requiredIds = {6075}}, 
 			{id = 992, cost = 6000, requiredIds = {970}}, 
 		},
 		[28] = {
 			{id = 19276, cost = 8000, requiredIds = {2944}}, 
 			{id = 6063, cost = 8000, requiredIds = {2055}}, 
 			{id = 15430, cost = 8000, requiredIds = {15237}}, 
 			{id = 8104, cost = 8000, requiredIds = {8103}}, 
 			{id = 17311, cost = 400, requiredIds = {15407}, requiredTalentId = 15407}, 
 			{id = 8124, cost = 8000, requiredIds = {8122}}, 
 		},
 		[30] = {
 			{id = 14752, cost = 600}, 
 			{id = 15263, cost = 10000, requiredIds = {15262}}, 
 			{id = 602, cost = 10000, requiredIds = {7128}}, 
 			{id = 605, cost = 10000}, 
 			{id = 6065, cost = 10000, requiredIds = {3747}}, 
 			{id = 596, cost = 10000}, 
 			{id = 976, cost = 10000}, 
 			{id = 1004, cost = 10000, requiredIds = {984}}, 
 		},
 		[32] = {
 			{id = 552, cost = 11000}, 
 			{id = 9473, cost = 11000, requiredIds = {9472}}, 
 			{id = 6077, cost = 11000, requiredIds = {6076}}, 
 		},
 		[34] = {
 			{id = 19240, cost = 300, requiredIds = {19238}, requiredTalentId = 19236}, 
 			{id = 6064, cost = 12000, requiredIds = {6063}}, 
 			{id = 1706, cost = 12000}, 
 			{id = 8105, cost = 12000, requiredIds = {8104}}, 
 			{id = 10880, cost = 12000, requiredIds = {2010}}, 
 			{id = 2767, cost = 12000, requiredIds = {992}}, 
 		},
 		[36] = {
 			{id = 19277, cost = 14000, requiredIds = {19276}}, 
 			{id = 988, cost = 14000, requiredIds = {527}}, 
 			{id = 15264, cost = 14000, requiredIds = {15263}}, 
 			{id = 15431, cost = 14000, requiredIds = {15430}}, 
 			{id = 17312, cost = 700, requiredIds = {17311}, requiredTalentId = 15407}, 
 			{id = 2791, cost = 14000, requiredIds = {1245}}, 
 			{id = 6066, cost = 14000, requiredIds = {6065}}, 
 		},
 		[38] = {
 			{id = 9474, cost = 16000, requiredIds = {9473}}, 
 			{id = 6078, cost = 16000, requiredIds = {6077}}, 
 			{id = 6060, cost = 16000, requiredIds = {1004}}, 
 		},
 		[40] = {
 			{id = 14818, cost = 900, requiredIds = {14752}}, 
 			{id = 2060, cost = 18000}, 
 			{id = 1006, cost = 18000, requiredIds = {602}}, 
 			{id = 8106, cost = 18000, requiredIds = {8105}}, 
 			{id = 996, cost = 18000, requiredIds = {596}}, 
 			{id = 9485, cost = 18000, requiredIds = {9484}}, 
 		},
 		[42] = {
 			{id = 19241, cost = 600, requiredIds = {19240}, requiredTalentId = 19236}, 
 			{id = 15265, cost = 22000, requiredIds = {15264}}, 
 			{id = 10898, cost = 22000, requiredIds = {6066}}, 
 			{id = 10888, cost = 22000, requiredIds = {8124}}, 
 			{id = 10957, cost = 22000, requiredIds = {976}}, 
 			{id = 10892, cost = 22000, requiredIds = {2767}}, 
 		},
 		[44] = {
 			{id = 19278, cost = 24000, requiredIds = {19277}}, 
 			{id = 10915, cost = 24000, requiredIds = {9474}}, 
 			{id = 27799, cost = 24000, requiredIds = {15431}}, 
 			{id = 17313, cost = 1200, requiredIds = {17312}, requiredTalentId = 15407}, 
 			{id = 10909, cost = 24000, requiredIds = {2096}}, 
 			{id = 10927, cost = 24000, requiredIds = {6078}}, 
 		},
 		[46] = {
 			{id = 10963, cost = 26000, requiredIds = {2060}}, 
 			{id = 10945, cost = 26000, requiredIds = {8106}}, 
 			{id = 10881, cost = 26000, requiredIds = {10880}}, 
 			{id = 10933, cost = 26000, requiredIds = {6060}}, 
 		},
 		[48] = {
 			{id = 15266, cost = 28000, requiredIds = {15265}}, 
 			{id = 10937, cost = 28000, requiredIds = {2791}}, 
 			{id = 10899, cost = 28000, requiredIds = {10898}}, 
 			{id = 21562, cost = 28000, requiredIds = {10937}}, 
 		},
 		[50] = {
 			{id = 19242, cost = 1100, requiredIds = {19241}, requiredTalentId = 19236}, 
 			{id = 14819, cost = 1500, requiredIds = {14818}}, 
 			{id = 10916, cost = 30000, requiredIds = {10915}}, 
 			{id = 10951, cost = 30000, requiredIds = {1006}}, 
 			{id = 27870, cost = 1200, requiredIds = {724}, requiredTalentId = 724}, 
 			{id = 10960, cost = 30000, requiredIds = {996}}, 
 			{id = 10928, cost = 30000, requiredIds = {10927}}, 
 			{id = 10893, cost = 30000, requiredIds = {10892}}, 
 		},
 		[52] = {
 			{id = 19279, cost = 38000, requiredIds = {19278}}, 
 			{id = 10964, cost = 38000, requiredIds = {10963}}, 
 			{id = 27800, cost = 38000, requiredIds = {27799}}, 
 			{id = 10946, cost = 38000, requiredIds = {10945}}, 
 			{id = 17314, cost = 1900, requiredIds = {17313}, requiredTalentId = 15407}, 
 		},
 		[54] = {
 			{id = 15267, cost = 40000, requiredIds = {15266}}, 
 			{id = 10900, cost = 40000, requiredIds = {10899}}, 
 			{id = 10934, cost = 40000, requiredIds = {10933}}, 
 		},
 		[56] = {
 			{id = 34863, cost = 2100, requiredIds = {34861}, requiredTalentId = 34861}, 
 			{id = 10917, cost = 42000, requiredIds = {10916}}, 
 			{id = 27683, cost = 42000, requiredIds = {10958}}, 
 			{id = 10890, cost = 42000, requiredIds = {10888}}, 
 			{id = 10929, cost = 42000, requiredIds = {10928}}, 
 			{id = 10958, cost = 42000, requiredIds = {10957}}, 
 		},
 		[58] = {
 			{id = 19243, cost = 1500, requiredIds = {19242}, requiredTalentId = 19236}, 
 			{id = 10965, cost = 44000, requiredIds = {10964}}, 
 			{id = 10947, cost = 44000, requiredIds = {10946}}, 
 			{id = 20770, cost = 44000, requiredIds = {10881}}, 
 			{id = 10894, cost = 44000, requiredIds = {10893}}, 
 		},
 		[60] = {
 			{id = 34864, cost = 2300, requiredIds = {34863}, requiredTalentId = 34861}, 
 			{id = 19280, cost = 46000, requiredIds = {19279}}, 
 			{id = 27841, cost = 2300, requiredIds = {14819}}, 
 			{id = 25314, cost = 65000, requiredIds = {10965}}, 
 			{id = 15261, cost = 46000, requiredIds = {15267}}, 
 			{id = 27801, cost = 46000, requiredIds = {27800}}, 
 			{id = 10952, cost = 46000, requiredIds = {10951}}, 
 			{id = 27871, cost = 1500, requiredIds = {27870}, requiredTalentId = 724}, 
 			{id = 18807, cost = 2300, requiredIds = {17314}, requiredTalentId = 15407}, 
 			{id = 10938, cost = 46000, requiredIds = {10937}}, 
 			{id = 10901, cost = 46000, requiredIds = {10900}}, 
 			{id = 21564, cost = 46000, requiredIds = {10938,21562}}, 
 			{id = 10961, cost = 46000, requiredIds = {10960}}, 
 			{id = 25316, cost = 6500, requiredIds = {10961}}, 
 			{id = 27681, cost = 2300, requiredIds = {27841}}, 
 			{id = 25315, cost = 6500, requiredIds = {10929}}, 
 			{id = 10955, cost = 46000, requiredIds = {9485}}, 
 			{id = 34916, cost = 2300, requiredIds = {34914}, requiredTalentId = 34914}, 
 		},
 		[61] = {
 			{id = 25233, cost = 53000, requiredIds = {10917}}, 
 			{id = 25363, cost = 53000, requiredIds = {10934}}, 
 		},
 		[62] = {
 			{id = 32379, cost = 59000}, 
 		},
 		[63] = {
 			{id = 25210, cost = 65000, requiredIds = {25314}}, 
 			{id = 25372, cost = 65000, requiredIds = {10947}}, 
 		},
 		[64] = {
 			{id = 32546, cost = 72000}, 
 		},
 		[65] = {
 			{id = 34865, cost = 4000, requiredIds = {34864}, requiredTalentId = 34861}, 
 			{id = 25217, cost = 80000, requiredIds = {10901}}, 
 			{id = 25221, cost = 80000, requiredIds = {25315}}, 
 			{id = 25367, cost = 80000, requiredIds = {10894}}, 
 		},
 		[66] = {
 			{id = 25437, cost = 2200, requiredIds = {19243}, requiredTalentId = 19236}, 
 			{id = 25384, cost = 65000, requiredIds = {15261}}, 
 			{id = 34433, cost = 89000}, 
 		},
 		[67] = {
 			{id = 25235, cost = 99000, requiredIds = {25233}}, 
 		},
 		[68] = {
 			{id = 25467, cost = 110000, requiredIds = {19280}}, 
 			{id = 25213, cost = 110000, requiredIds = {25210}}, 
 			{id = 25331, cost = 110000, requiredIds = {27801}}, 
 			{id = 25387, cost = 6500, requiredIds = {18807}, requiredTalentId = 15407}, 
 			{id = 25308, cost = 110000, requiredIds = {25316}}, 
 			{id = 33076, cost = 110000}, 
 			{id = 25435, cost = 110000, requiredIds = {20770}}, 
 			{id = 25433, cost = 110000, requiredIds = {10958}}, 
 		},
 		[69] = {
 			{id = 25431, cost = 65000, requiredIds = {10952}}, 
 			{id = 25375, cost = 65000, requiredIds = {25372}}, 
 			{id = 25364, cost = 65000, requiredIds = {25363}}, 
 		},
 		[70] = {
 			{id = 34866, cost = 7000, requiredIds = {34865}, requiredTalentId = 34861}, 
 			{id = 25312, cost = 2300, requiredIds = {27841}}, 
 			{id = 28275, cost = 1500, requiredIds = {27871}, requiredTalentId = 724}, 
 			{id = 32375, cost = 110000, requiredIds = {988}}, 
 			{id = 53005, cost = 5000, requiredIds = {47540}, requiredTalentId = 47540}, 
 			{id = 25389, cost = 65000, requiredIds = {10938}}, 
 			{id = 25218, cost = 140000, requiredIds = {25217}}, 
 			{id = 25392, cost = 100000, requiredIds = {25389,21564}}, 
 			{id = 39374, cost = 100000, requiredIds = {25433,10958}}, 
 			{id = 32999, cost = 3400, requiredIds = {25312,27681}}, 
 			{id = 25222, cost = 140000, requiredIds = {25221}}, 
 			{id = 32996, cost = 110000, requiredIds = {32379}}, 
 			{id = 25368, cost = 140000, requiredIds = {25367}}, 
 			{id = 34917, cost = 2300, requiredIds = {34916}, requiredTalentId = 34914}, 
 		},
 		[71] = {
 			{id = 48040, cost = 180000, requiredIds = {25431}}, 
 		},
 		[72] = {
 			{id = 48119, cost = 180000, requiredIds = {32546}}, 
 			{id = 48134, cost = 180000, requiredIds = {25384}}, 
 		},
 		[73] = {
 			{id = 48172, cost = 3250, requiredIds = {25437}}, 
 			{id = 48299, cost = 180000, requiredIds = {25467}}, 
 			{id = 48070, cost = 180000, requiredIds = {25235}}, 
 			{id = 48062, cost = 180000, requiredIds = {25213}}, 
 		},
 		[74] = {
 			{id = 48126, cost = 180000, requiredIds = {25375}}, 
 			{id = 48155, cost = 9000, requiredIds = {25387}, requiredTalentId = 15407}, 
 			{id = 48112, cost = 100000, requiredIds = {33076}}, 
 			{id = 48122, cost = 180000, requiredIds = {25364}}, 
 		},
 		[75] = {
 			{id = 48088, cost = 9000, requiredIds = {34866}}, 
 			{id = 48077, cost = 180000, requiredIds = {25331}}, 
 			{id = 48086, cost = 9000, requiredIds = {28275}, requiredTalentId = 724}, 
 			{id = 48045, cost = 10000}, 
 			{id = 53006, cost = 9000, requiredIds = {53005}, requiredTalentId = 47540}, 
 			{id = 48065, cost = 180000, requiredIds = {25218}}, 
 			{id = 48067, cost = 180000, requiredIds = {25222}}, 
 			{id = 48157, cost = 180000, requiredIds = {32996}}, 
 			{id = 48124, cost = 180000, requiredIds = {25368}}, 
 			{id = 48159, cost = 9000, requiredIds = {43917}, requiredTalentId = 34914}, 
 		},
 		[76] = {
 			{id = 48072, cost = 180000, requiredIds = {25308}}, 
 			{id = 48169, cost = 180000, requiredIds = {25433}}, 
 		},
 		[77] = {
 			{id = 48168, cost = 180000, requiredIds = {48040}}, 
 			{id = 48170, cost = 180000, requiredIds = {48169, 39374}}, 
 		},
 		[78] = {
 			{id = 48120, cost = 180000, requiredIds = {48119}}, 
 			{id = 48063, cost = 180000, requiredIds = {48062}}, 
 			{id = 48135, cost = 180000, requiredIds = {48134}}, 
 			{id = 48171, cost = 180000, requiredIds = {25435}}, 
 		},
 		[79] = {
 			{id = 48300, cost = 180000, requiredIds = {48299}}, 
 			{id = 48071, cost = 180000, requiredIds = {48070}}, 
 			{id = 48127, cost = 180000, requiredIds = {48126}}, 
 			{id = 48113, cost = 180000, requiredIds = {48112}}, 
 			{id = 48123, cost = 180000, requiredIds = {48122}}, 
 		},
 		[80] = {
 			{id = 48089, cost = 9000, requiredIds = {48088}}, 
 			{id = 48173, cost = 9000, requiredIds = {48172}}, 
 			{id = 64843, cost = 180000}, 
 			{id = 48073, cost = 9000, requiredIds = {25312}}, 
 			{id = 48078, cost = 180000, requiredIds = {48077}}, 
 			{id = 64901, cost = 65000}, 
 			{id = 48087, cost = 9000, requiredIds = {48086}, requiredTalentId = 724}, 
 			{id = 48156, cost = 9000, requiredIds = {48155}, requiredTalentId = 15407}, 
 			{id = 53023, cost = 100000, requiredIds = {48045}}, 
 			{id = 53007, cost = 9000, requiredIds = {53006}, requiredTalentId = 47540}, 
 			{id = 48161, cost = 180000, requiredIds = {25389}}, 
 			{id = 48066, cost = 180000, requiredIds = {48065}}, 
 			{id = 48162, cost = 180000, requiredIds = {48161,25392}}, 
 			{id = 48074, cost = 9000, requiredIds = {48073,32999}}, 
 			{id = 48068, cost = 180000, requiredIds = {48067}}, 
 			{id = 48158, cost = 180000, requiredIds = {48157}}, 
 			{id = 48125, cost = 180000, requiredIds = {48124}}, 
 			{id = 48160, cost = 9000, requiredIds = {48159}, requiredTalentId = 34914}, 
 		},
 	},
}

FatCooldowns.ShamanSpells = {
	[0] = { 
		[1] = {
			{id = 8017, cost = 10}
		},
		[4] = {
			{id = 8042, cost = 100}
		},
		[6] = {
			{id = 2484, cost = 100},
			{id = 332, cost = 100, requiredIds = {331}}
		},
		[8] = {
			{id = 8044, cost = 100, requiredIds = {8042}},
			{id = 529, cost = 100, requiredIds = {403}},
			{id = 324, cost = 100},
			{id = 8018, cost = 100, requiredIds = {8017}},
			{id = 5730, cost = 100}
		},
		[10] = {
			{id = 8050, cost = 400},
			{id = 8024, cost = 400},
			{id = 8075, cost = 400}
		},
		[12] = {
			{id = 2008, cost = 800},
			{id = 1535, cost = 800},
			{id = 547, cost = 800, requiredIds = {332}},
			{id = 370, cost = 720}
		},
		[14] = {
			{id = 8045, cost = 900, requiredIds = {8044}},
			{id = 548, cost = 900, requiredIds = {529}},
			{id = 8154, cost = 900}
		},
		[16] = {
			{id = 526, cost = 1800},
			{id = 325, cost = 1800, requiredIds = {324}},
			{id = 8019, cost = 1800, requiredIds = {8018}}
		},
		[18] = {
			{id = 8052, cost = 2000, requiredIds = {8050}},
			{id = 8027, cost = 2000, requiredIds = {8024}},
			{id = 913, cost = 2000, requiredIds = {547}},
			{id = 6390, cost = 2000, requiredIds = {5730}},
			{id = 8143, cost = 2000}
		},
		[20] = {
			{id = 8056, cost = 2200},
			{id = 8033, cost = 2200},
			{id = 2645, cost = 2200},
			{id = 8004, cost = 2200},
			{id = 915, cost = 2200, requiredIds = {548}},
			{id = 6363, cost = 2200}
		},
		[22] = {
			{id = 8498, cost = 3000, requiredIds = {1535}},
			{id = 8166, cost = 3000},
			{id = 131, cost = 3000},
			{id = 2870, cost = 900}
		},
		[24] = {
			{id = 20609, cost = 3500, requiredIds = {2008}},
			{id = 8046, cost = 3500, requiredIds = {8045}},
			{id = 8181, cost = 3500},
			{id = 939, cost = 3500, requiredIds = {913}},
			{id = 905, cost = 3500, requiredIds = {325}},
			{id = 10399, cost = 3500, requiredIds = {8019}},
			{id = 8155, cost = 3500, requiredIds = {8154}},
			{id = 8160, cost = 3500, requiredIds = {8075}}
		},
		[26] = {
			{id = 6196, cost = 4000},
			{id = 8030, cost = 4000, requiredIds = {8027}},
			{id = 943, cost = 4000, requiredIds = {915}},
			{id = 8190, cost = 4000},
			{id = 5675, cost = 4000}
		},
		[28] = {
			{id = 8184, cost = 6000},
			{id = 8053, cost = 6000, requiredIds = {8052}},
			{id = 8227, cost = 6000},
			{id = 8038, cost = 6000, requiredIds = {8033}},
			{id = 8008, cost = 6000, requiredIds = {8004}},
			{id = 6391, cost = 6000, requiredIds = {6390}},
			{id = 546, cost = 6000}
		},
		[30] = {
			{id = 556, cost = 7000},
			{id = 8177, cost = 7000},
			{id = 6375, cost = 7000},
			{id = 10595, cost = 7000},
			{id = 20608, cost = 7000},
			{id = 6364, cost = 7000, requiredIds = {6363}},
			{id = 8232, cost = 7000}
		},
		[32] = {
			{id = 421, cost = 8000},
			{id = 8499, cost = 8000, requiredIds = {8498}},
			{id = 959, cost = 8000, requiredIds = {939}},
			{id = 6041, cost = 8000, requiredIds = {943}},
			{id = 945, cost = 8000, requiredIds = {905}},
			{id = 8012, cost = 7200, requiredIds = {370}},
			{id = 8512, cost = 8000}
		},
		[34] = {
			{id = 8058, cost = 9000, requiredIds = {8056}},
			{id = 16314, cost = 9000, requiredIds = {10399}},
			{id = 6495, cost = 9000},
			{id = 10406, cost = 9000, requiredIds = {8155}}
		},
		[36] = {
			{id = 20610, cost = 10000, requiredIds = {20609}},
			{id = 10412, cost = 10000, requiredIds = {8046}},
			{id = 16339, cost = 10000, requiredIds = {8030}},
			{id = 8010, cost = 10000, requiredIds = {8008}},
			{id = 10585, cost = 10000, requiredIds = {8190}},
			{id = 10495, cost = 10000, requiredIds = {5675}},
			{id = 15107, cost = 10000}
		},
		[38] = {
			{id = 8170, cost = 11000},
			{id = 8249, cost = 11000, requiredIds = {8227}},
			{id = 10478, cost = 11000, requiredIds = {8181}},
			{id = 10456, cost = 11000, requiredIds = {8038}},
			{id = 10391, cost = 11000, requiredIds = {6041}},
			{id = 6392, cost = 11000, requiredIds = {6391}},
			{id = 8161, cost = 11000, requiredIds = {8160}}
		},
		[40] = {
			{id = 1064, cost = 12000},
			{id = 930, cost = 12000, requiredIds = {421}},
			{id = 10447, cost = 12000, requiredIds = {8053}},
			{id = 6377, cost = 12000, requiredIds = {6375}},
			{id = 8005, cost = 12000, requiredIds = {959}},
			{id = 8134, cost = 12000, requiredIds = {945}},
			{id = 6365, cost = 12000, requiredIds = {6364}},
			{id = 8235, cost = 12000, requiredIds = {8232}}
		},
		[42] = {
			{id = 11314, cost = 16000, requiredIds = {8499}},
			{id = 10537, cost = 16000, requiredIds = {8184}},
			{id = 8835, cost = 16000},
			{id = 10613, cost = 16000, requiredIds = {8512}}
		},
		[44] = {
			{id = 10466, cost = 18000, requiredIds = {8010}},
			{id = 10392, cost = 18000, requiredIds = {10391}},
			{id = 10600, cost = 18000, requiredIds = {10595}},
			{id = 16315, cost = 18000, requiredIds = {16314}},
			{id = 10407, cost = 18000, requiredIds = {10406}}
		},
		[46] = {
			{id = 10622, cost = 20000, requiredIds = {1064}},
			{id = 16341, cost = 20000, requiredIds = {16339}},
			{id = 10472, cost = 20000, requiredIds = {8058}},
			{id = 10586, cost = 20000, requiredIds = {10585}},
			{id = 10496, cost = 20000, requiredIds = {10495}},
			{id = 15111, cost = 20000, requiredIds = {15107}}
		},
		[48] = {
			{id = 20776, cost = 22000, requiredIds = {20610}},
			{id = 2860, cost = 22000, requiredIds = {930}},
			{id = 10413, cost = 22000, requiredIds = {10412}},
			{id = 10526, cost = 22000, requiredIds = {8249}},
			{id = 16355, cost = 22000, requiredIds = {10456}},
			{id = 10395, cost = 22000, requiredIds = {8005}},
			{id = 10431, cost = 22000, requiredIds = {8134}},
			{id = 17354, cost = 55000, requiredTalentId = 16190},
			{id = 10427, cost = 22000, requiredIds = {6392}}
		},
		[50] = {
			{id = 10462, cost = 24000, requiredIds = {6377}},
			{id = 15207, cost = 24000, requiredIds = {10392}},
			{id = 10437, cost = 24000, requiredIds = {6365}},
			{id = 25908, cost = 24000},
			{id = 10486, cost = 24000, requiredIds = {8235}}
		},
		[52] = {
			{id = 11315, cost = 27000, requiredIds = {11314}},
			{id = 10448, cost = 27000, requiredIds = {10447}},
			{id = 10467, cost = 27000, requiredIds = {10466}},
			{id = 10442, cost = 27000, requiredIds = {8161}},
			{id = 10614, cost = 27000, requiredIds = {10613}}
		},
		[54] = {
			{id = 10623, cost = 29000, requiredIds = {10622}},
			{id = 10479, cost = 29000, requiredIds = {10478}},
			{id = 16316, cost = 29000, requiredIds = {16315}},
			{id = 10408, cost = 29000, requiredIds = {10407}}
		},
		[56] = {
			{id = 10605, cost = 30000, requiredIds = {2860}},
			{id = 16342, cost = 30000, requiredIds = {16341}},
			{id = 10627, cost = 30000, requiredIds = {8835}},
			{id = 10396, cost = 30000, requiredIds = {10395}},
			{id = 15208, cost = 30000, requiredIds = {15207}},
			{id = 10432, cost = 30000, requiredIds = {10431}},
			{id = 10587, cost = 30000, requiredIds = {10586}},
			{id = 10497, cost = 30000, requiredIds = {10496}},
			{id = 15112, cost = 30000, requiredIds = {15111}}
		},
		[58] = {
			{id = 10538, cost = 32000, requiredIds = {10537}},
			{id = 16387, cost = 32000, requiredIds = {10526}},
			{id = 10473, cost = 32000, requiredIds = {10472}},
			{id = 16356, cost = 32000, requiredIds = {16355}},
			{id = 17359, cost = 80000, requiredTalentId = 17354},
			{id = 10428, cost = 32000, requiredIds = {10427}}
		},
		[60] = {
			{id = 20777, cost = 34000, requiredIds = {20776}},
			{id = 10414, cost = 34000, requiredIds = {10413}},
			{id = 10463, cost = 34000, requiredIds = {10462}},
			{id = 10468, cost = 34000, requiredIds = {10467}},
			{id = 10601, cost = 34000, requiredIds = {10600}},
			{id = 10438, cost = 34000, requiredIds = {10437}},
			{id = 16362, cost = 34000, requiredIds = {10486}}
		},
	},
	[1] = { 
		[1] = {
			{id = 8017, cost = 10},
		},
		[4] = {
			{id = 8042, cost = 100},
		},
		[6] = {
			{id = 2484, cost = 100},
			{id = 332, cost = 100, requiredIds = {331}},
		},
		[8] = {
			{id = 8044, cost = 100, requiredIds = {8042}},
			{id = 529, cost = 100, requiredIds = {403}},
			{id = 5730, cost = 100},
			{id = 324, cost = 100},
			{id = 8018, cost = 100, requiredIds = {8017}},
		},
		[10] = {
			{id = 8050, cost = 400},
			{id = 8024, cost = 400},
			{id = 8075, cost = 400},
		},
		[12] = {
			{id = 1535, cost = 800},
			{id = 370, cost = 800},
			{id = 2008, cost = 800},
			{id = 547, cost = 800, requiredIds = {332}},
		},
		[14] = {
			{id = 8045, cost = 900, requiredIds = {8044}},
			{id = 548, cost = 900, requiredIds = {529}},
			{id = 8154, cost = 900, requiredIds = {8071}},
		},
		[16] = {
			{id = 325, cost = 1800, requiredIds = {324}},
			{id = 8019, cost = 1800, requiredIds = {8018}},
			{id = 526, cost = 1800},
		},
		[18] = {
			{id = 8052, cost = 2000, requiredIds = {8050}},
			{id = 6390, cost = 2000, requiredIds = {5730}},
			{id = 8027, cost = 2000, requiredIds = {8024}},
			{id = 913, cost = 2000, requiredIds = {547}},
			{id = 8143, cost = 2000},
		},
		[20] = {
			{id = 8056, cost = 2200},
			{id = 915, cost = 2200, requiredIds = {548}},
			{id = 6363, cost = 2200, requiredIds = {3599}},
			{id = 8033, cost = 2200},
			{id = 2645, cost = 2200},
			{id = 8004, cost = 2200},
		},
		[22] = {
			{id = 8498, cost = 3000, requiredIds = {1535}},
			{id = 131, cost = 3000},
			{id = 2870, cost = 3000},
			{id = 8166, cost = 3000},
		},
		[24] = {
			{id = 8046, cost = 3500, requiredIds = {8045}},
			{id = 8181, cost = 3500},
			{id = 905, cost = 3500, requiredIds = {325}},
			{id = 10399, cost = 3500, requiredIds = {8019}},
			{id = 8155, cost = 3500, requiredIds = {8154}},
			{id = 8160, cost = 3500, requiredIds = {8075}},
			{id = 20609, cost = 3500, requiredIds = {2008}},
			{id = 939, cost = 3500, requiredIds = {913}},
		},
		[26] = {
			{id = 943, cost = 4000, requiredIds = {915}},
			{id = 8190, cost = 4000},
			{id = 6196, cost = 4000},
			{id = 8030, cost = 4000, requiredIds = {8027}},
			{id = 5675, cost = 4000},
		},
		[28] = {
			{id = 8053, cost = 6000, requiredIds = {8052}},
			{id = 6391, cost = 6000, requiredIds = {6390}},
			{id = 8184, cost = 6000},
			{id = 8227, cost = 6000},
			{id = 8038, cost = 6000, requiredIds = {8033}},
			{id = 546, cost = 6000},
			{id = 8008, cost = 6000, requiredIds = {8004}},
		},
		[30] = {
			{id = 6364, cost = 7000, requiredIds = {6363}},
			{id = 556, cost = 7000},
			{id = 8177, cost = 7000},
			{id = 10595, cost = 7000},
			{id = 8232, cost = 7000},
			{id = 6375, cost = 7000, requiredIds = {5394}},
			{id = 20608, cost = 7000},
			{id = 36936, cost = 7000},
		},
		[32] = {
			{id = 421, cost = 8000},
			{id = 8499, cost = 8000, requiredIds = {8498}},
			{id = 6041, cost = 8000, requiredIds = {943}},
			{id = 8012, cost = 8000, requiredIds = {370}},
			{id = 945, cost = 8000, requiredIds = {905}},
			{id = 8512, cost = 8000},
			{id = 959, cost = 8000, requiredIds = {939}},
		},
		[34] = {
			{id = 8058, cost = 9000, requiredIds = {8056}},
			{id = 16314, cost = 9000, requiredIds = {10399}},
			{id = 6495, cost = 9000},
			{id = 10406, cost = 9000, requiredIds = {8155}},
		},
		[36] = {
			{id = 10412, cost = 10000, requiredIds = {8046}},
			{id = 10585, cost = 10000, requiredIds = {8190}},
			{id = 16339, cost = 10000, requiredIds = {8030}},
			{id = 15107, cost = 10000},
			{id = 20610, cost = 10000, requiredIds = {20609}},
			{id = 8010, cost = 10000, requiredIds = {8008}},
			{id = 10495, cost = 10000, requiredIds = {5675}},
		},
		[38] = {
			{id = 10391, cost = 11000, requiredIds = {6041}},
			{id = 6392, cost = 11000, requiredIds = {6391}},
			{id = 8249, cost = 11000, requiredIds = {8227}},
			{id = 10478, cost = 11000, requiredIds = {8181}},
			{id = 10456, cost = 11000, requiredIds = {8038}},
			{id = 8161, cost = 11000, requiredIds = {8160}},
			{id = 8170, cost = 11000},
		},
		[40] = {
			{id = 930, cost = 12000, requiredIds = {421}},
			{id = 10447, cost = 12000, requiredIds = {8053}},
			{id = 6365, cost = 12000, requiredIds = {6364}},
			{id = 8134, cost = 12000, requiredIds = {945}},
			{id = 8235, cost = 12000, requiredIds = {8232}},
			{id = 1064, cost = 12000},
			{id = 6377, cost = 12000, requiredIds = {6375}},
			{id = 8005, cost = 12000, requiredIds = {959}},
		},
		[42] = {
			{id = 11314, cost = 16000, requiredIds = {8499}},
			{id = 10537, cost = 16000, requiredIds = {8184}},
			{id = 8835, cost = 16000},
			{id = 10613, cost = 16000, requiredIds = {8512}},
		},
		[44] = {
			{id = 10392, cost = 18000, requiredIds = {10391}},
			{id = 10600, cost = 18000, requiredIds = {10595}},
			{id = 16315, cost = 18000, requiredIds = {16314}},
			{id = 10407, cost = 18000, requiredIds = {10406}},
			{id = 10466, cost = 18000, requiredIds = {8010}},
		},
		[46] = {
			{id = 10472, cost = 20000, requiredIds = {8058}},
			{id = 10586, cost = 20000, requiredIds = {10585}},
			{id = 16341, cost = 20000, requiredIds = {16339}},
			{id = 15111, cost = 20000, requiredIds = {15107}},
			{id = 10622, cost = 20000, requiredIds = {1064}},
			{id = 10496, cost = 20000, requiredIds = {10495}},
		},
		[48] = {
			{id = 2860, cost = 22000, requiredIds = {930}},
			{id = 10413, cost = 22000, requiredIds = {10412}},
			{id = 10427, cost = 22000, requiredIds = {6392}},
			{id = 10526, cost = 22000, requiredIds = {8249}},
			{id = 16355, cost = 22000, requiredIds = {10456}},
			{id = 10431, cost = 22000, requiredIds = {8134}},
			{id = 20776, cost = 22000, requiredIds = {20610}},
			{id = 10395, cost = 22000, requiredIds = {8005}},
		},
		[50] = {
			{id = 15207, cost = 24000, requiredIds = {10392}},
			{id = 10437, cost = 24000, requiredIds = {6365}},
			{id = 10486, cost = 24000, requiredIds = {8235}},
			{id = 10462, cost = 24000, requiredIds = {6377}},
			{id = 25908, cost = 24000},
		},
		[52] = {
			{id = 11315, cost = 27000, requiredIds = {11314}},
			{id = 10448, cost = 27000, requiredIds = {10447}},
			{id = 10442, cost = 27000, requiredIds = {8161}},
			{id = 10614, cost = 27000, requiredIds = {10613}},
			{id = 10467, cost = 27000, requiredIds = {10466}},
		},
		[54] = {
			{id = 10479, cost = 29000, requiredIds = {10478}},
			{id = 16316, cost = 29000, requiredIds = {16315}},
			{id = 10408, cost = 29000, requiredIds = {10407}},
			{id = 10623, cost = 29000, requiredIds = {10622}},
		},
		[56] = {
			{id = 10605, cost = 30000, requiredIds = {2860}},
			{id = 15208, cost = 30000, requiredIds = {15207}},
			{id = 10587, cost = 30000, requiredIds = {10586}},
			{id = 16342, cost = 30000, requiredIds = {16341}},
			{id = 10627, cost = 30000, requiredIds = {8835}},
			{id = 10432, cost = 30000, requiredIds = {10431}},
			{id = 15112, cost = 30000, requiredIds = {15111}},
			{id = 10396, cost = 30000, requiredIds = {10395}},
			{id = 10497, cost = 30000, requiredIds = {10496}},
		},
		[58] = {
			{id = 10473, cost = 32000, requiredIds = {10472}},
			{id = 10428, cost = 32000, requiredIds = {10427}},
			{id = 10538, cost = 32000, requiredIds = {10537}},
			{id = 16387, cost = 32000, requiredIds = {10526}},
			{id = 16356, cost = 32000, requiredIds = {16355}},
		},
		[60] = {
			{id = 10414, cost = 34000, requiredIds = {10413}},
			{id = 29228, cost = 65000, requiredIds = {10448}},
			{id = 10438, cost = 34000, requiredIds = {10437}},
			{id = 25359, cost = 65000, requiredIds = {10627}},
			{id = 10601, cost = 34000, requiredIds = {10600}},
			{id = 25361, cost = 34000, requiredIds = {10442}},
			{id = 16362, cost = 34000, requiredIds = {10486}},
			{id = 20777, cost = 34000, requiredIds = {20776}},
			{id = 32593, cost = 1700, requiredIds = {974}, requiredTalentId = 974},
			{id = 10463, cost = 34000, requiredIds = {10462}},
			{id = 25357, cost = 6500, requiredIds = {10396}},
			{id = 10468, cost = 34000, requiredIds = {10467}},
		},
		[61] = {
			{id = 25546, cost = 34000, requiredIds = {11315}},
			{id = 25585, cost = 34000, requiredIds = {10614}},
			{id = 25422, cost = 34000, requiredIds = {10623}},
		},
		[62] = {
			{id = 25448, cost = 38000, requiredIds = {15208}},
			{id = 25479, cost = 38000, requiredIds = {16316}},
			{id = 24398, cost = 38000},
		},
		[63] = {
			{id = 25439, cost = 42000, requiredIds = {10605}},
			{id = 25469, cost = 42000, requiredIds = {10432}},
			{id = 25508, cost = 42000, requiredIds = {10408}},
			{id = 25391, cost = 42000, requiredIds = {25357}},
		},
		[64] = {
			{id = 25489, cost = 47000, requiredIds = {16342}},
			{id = 3738, cost = 47000},
		},
		[65] = {
			{id = 25552, cost = 52000, requiredIds = {10587}},
			{id = 25528, cost = 52000, requiredIds = {25361}},
			{id = 25577, cost = 52000, requiredIds = {15112}},
			{id = 25570, cost = 52000, requiredIds = {10497}},
		},
		[66] = {
			{id = 2062, cost = 58000},
			{id = 25500, cost = 58000, requiredIds = {16356}},
			{id = 25420, cost = 58000, requiredIds = {10468}},
		},
		[67] = {
			{id = 25449, cost = 64000, requiredIds = {25448}},
			{id = 25525, cost = 64000, requiredIds = {10428}},
			{id = 25557, cost = 64000, requiredIds = {16387}},
			{id = 25560, cost = 64000, requiredIds = {10479}},
		},
		[68] = {
			{id = 2894, cost = 71000},
			{id = 25464, cost = 71000, requiredIds = {10473}},
			{id = 25563, cost = 71000, requiredIds = {10538}},
			{id = 25505, cost = 71000, requiredIds = {16362}},
			{id = 25423, cost = 71000, requiredIds = {25422}},
		},
		[69] = {
			{id = 25454, cost = 79000, requiredIds = {10414}},
			{id = 25533, cost = 79000, requiredIds = {10438}},
			{id = 25574, cost = 79000, requiredIds = {10601}},
			{id = 25567, cost = 79000, requiredIds = {10463}},
			{id = 33736, cost = 79000, requiredIds = {24398}},
		},
		[70] = {
			{id = 25442, cost = 88000, requiredIds = {25439}},
			{id = 25547, cost = 88000, requiredIds = {25546}},
			{id = 25457, cost = 88000, requiredIds = {29228}},
			{id = 2825, cost = 88000, faction = "Horde"},
			{id = 32182, cost = 88000, faction = "Alliance"},
			{id = 25472, cost = 88000, requiredIds = {25469}},
			{id = 25485, cost = 88000, requiredIds = {25479}},
			{id = 25509, cost = 88000, requiredIds = {25508}},
			{id = 25587, cost = 88000, requiredIds = {25585}},
			{id = 32594, cost = 2500, requiredIds = {32593}, requiredTalentId = 974},
			{id = 25396, cost = 88000, requiredIds = {25391}},
		},
	},
	[2] = { 
		[1] = {
			{id = 8017, cost = 10}, 
		},
		[4] = {
			{id = 8042, cost = 100}, 
		},
		[6] = {
			{id = 2484, cost = 100}, 
			{id = 332, cost = 100, requiredIds = {331}}, 
		},
		[8] = {
			{id = 8044, cost = 100, requiredIds = {8042}}, 
			{id = 529, cost = 100, requiredIds = {403}}, 
			{id = 324, cost = 100}, 
			{id = 8018, cost = 100, requiredIds = {8017}}, 
			{id = 5730, cost = 100}, 
		},
		[10] = {
			{id = 8050, cost = 400}, 
			{id = 8024, cost = 400}, 
			{id = 8075, cost = 400}, 
		},
		[12] = {
			{id = 2008, cost = 800}, 
			{id = 1535, cost = 800}, 
			{id = 547, cost = 800, requiredIds = {332}}, 
			{id = 370, cost = 800}, 
		},
		[14] = {
			{id = 8045, cost = 900, requiredIds = {8044}}, 
			{id = 548, cost = 900, requiredIds = {529}}, 
			{id = 8154, cost = 900, requiredIds = {8071}}, 
		},
		[16] = {
			{id = 526, cost = 1800}, 
			{id = 2645, cost = 2200}, 
			{id = 325, cost = 1800, requiredIds = {324}}, 
			{id = 8019, cost = 1800, requiredIds = {8018}}, 
			{id = 57994, cost = 2500}, 
		},
		[18] = {
			{id = 8052, cost = 2000, requiredIds = {8050}}, 
			{id = 8027, cost = 2000, requiredIds = {8024}}, 
			{id = 913, cost = 2000, requiredIds = {547}}, 
			{id = 6390, cost = 2000, requiredIds = {5730}}, 
			{id = 8143, cost = 2000}, 
		},
		[20] = {
			{id = 8056, cost = 2200}, 
			{id = 8033, cost = 2200}, 
			{id = 8004, cost = 2200}, 
			{id = 915, cost = 2200, requiredIds = {548}}, 
			{id = 6363, cost = 2200, requiredIds = {3599}}, 
			{id = 52127, cost = 2200}, 
		},
		[22] = {
			{id = 8498, cost = 3000, requiredIds = {1535}}, 
			{id = 131, cost = 3000}, 
		},
		[24] = {
			{id = 20609, cost = 3500, requiredIds = {2008}}, 
			{id = 8046, cost = 3500, requiredIds = {8045}}, 
			{id = 8181, cost = 3500}, 
			{id = 939, cost = 3500, requiredIds = {913}}, 
			{id = 905, cost = 3500, requiredIds = {325}}, 
			{id = 10399, cost = 3500, requiredIds = {8019}}, 
			{id = 8155, cost = 3500, requiredIds = {8154}}, 
			{id = 8160, cost = 3500, requiredIds = {8075}}, 
		},
		[26] = {
			{id = 6196, cost = 4000}, 
			{id = 8030, cost = 4000, requiredIds = {8027}}, 
			{id = 943, cost = 4000, requiredIds = {915}}, 
			{id = 8190, cost = 4000}, 
			{id = 5675, cost = 4000}, 
		},
		[28] = {
			{id = 8184, cost = 6000}, 
			{id = 8053, cost = 6000, requiredIds = {8052}}, 
			{id = 8227, cost = 6000}, 
			{id = 8038, cost = 6000, requiredIds = {8033}}, 
			{id = 8008, cost = 6000, requiredIds = {8004}}, 
			{id = 6391, cost = 6000, requiredIds = {6390}}, 
			{id = 52129, cost = 6000, requiredIds = {52127}}, 
			{id = 546, cost = 6000}, 
		},
		[30] = {
			{id = 556, cost = 7000}, 
			{id = 66842, cost = 700}, 
			{id = 51730, cost = 7000}, 
			{id = 8177, cost = 7000}, 
			{id = 6375, cost = 7000, requiredIds = {5394}}, 
			{id = 10595, cost = 7000}, 
			{id = 20608, cost = 7000}, 
			{id = 6364, cost = 7000, requiredIds = {6363}}, 
			{id = 36936, cost = 7000}, 
			{id = 8232, cost = 7000}, 
		},
		[32] = {
			{id = 421, cost = 8000}, 
			{id = 8499, cost = 8000, requiredIds = {8498}}, 
			{id = 959, cost = 8000, requiredIds = {939}}, 
			{id = 6041, cost = 8000, requiredIds = {943}}, 
			{id = 945, cost = 8000, requiredIds = {905}}, 
			{id = 8012, cost = 8000, requiredIds = {370}}, 
			{id = 8512, cost = 8000}, 
		},
		[34] = {
			{id = 8058, cost = 9000, requiredIds = {8056}}, 
			{id = 6495, cost = 9000}, 
			{id = 10406, cost = 9000, requiredIds = {8155}}, 
			{id = 52131, cost = 9000, requiredIds = {52129}}, 
		},
		[36] = {
			{id = 20610, cost = 10000, requiredIds = {20609}}, 
			{id = 10412, cost = 10000, requiredIds = {8046}}, 
			{id = 16339, cost = 10000, requiredIds = {8030}}, 
			{id = 8010, cost = 10000, requiredIds = {8008}}, 
			{id = 10585, cost = 10000, requiredIds = {8190}}, 
			{id = 10495, cost = 10000, requiredIds = {5675}}, 
		},
		[38] = {
			{id = 8170, cost = 11000}, 
			{id = 8249, cost = 11000, requiredIds = {8227}}, 
			{id = 10478, cost = 11000, requiredIds = {8181}}, 
			{id = 10456, cost = 11000, requiredIds = {8038}}, 
			{id = 10391, cost = 11000, requiredIds = {6041}}, 
			{id = 6392, cost = 11000, requiredIds = {6391}}, 
			{id = 8161, cost = 11000, requiredIds = {8160}}, 
		},
		[40] = {
			{id = 66843, cost = 700}, 
			{id = 1064, cost = 12000}, 
			{id = 930, cost = 12000, requiredIds = {421}}, 
			{id = 51988, cost = 12000, requiredIds = {51730}}, 
			{id = 10447, cost = 12000, requiredIds = {8053}}, 
			{id = 6377, cost = 12000, requiredIds = {6375}}, 
			{id = 8005, cost = 12000, requiredIds = {959}}, 
			{id = 8134, cost = 12000, requiredIds = {945}}, 
			{id = 6365, cost = 12000, requiredIds = {6364}}, 
			{id = 8235, cost = 12000, requiredIds = {8232}}, 
		},
		[41] = {
			{id = 52134, cost = 12000, requiredIds = {52131}}, 
		},
		[42] = {
			{id = 11314, cost = 16000, requiredIds = {8499}}, 
			{id = 10537, cost = 16000, requiredIds = {8184}}, 
		},
		[44] = {
			{id = 10466, cost = 18000, requiredIds = {8010}}, 
			{id = 10392, cost = 18000, requiredIds = {10391}}, 
			{id = 10600, cost = 18000, requiredIds = {10595}}, 
			{id = 10407, cost = 18000, requiredIds = {10406}}, 
		},
		[46] = {
			{id = 10622, cost = 20000, requiredIds = {1064}}, 
			{id = 16341, cost = 20000, requiredIds = {16339}}, 
			{id = 10472, cost = 20000, requiredIds = {8058}}, 
			{id = 10586, cost = 20000, requiredIds = {10585}}, 
			{id = 10496, cost = 20000, requiredIds = {10495}}, 
		},
		[48] = {
			{id = 20776, cost = 22000, requiredIds = {20610}}, 
			{id = 2860, cost = 22000, requiredIds = {930}}, 
			{id = 10413, cost = 22000, requiredIds = {10412}}, 
			{id = 10526, cost = 22000, requiredIds = {8249}}, 
			{id = 16355, cost = 22000, requiredIds = {10456}}, 
			{id = 10395, cost = 22000, requiredIds = {8005}}, 
			{id = 10431, cost = 22000, requiredIds = {8134}}, 
			{id = 10427, cost = 22000, requiredIds = {6392}}, 
			{id = 52136, cost = 22000, requiredIds = {52134}}, 
		},
		[50] = {
			{id = 66844, cost = 700}, 
			{id = 51991, cost = 24000, requiredIds = {51988}}, 
			{id = 10462, cost = 24000, requiredIds = {6377}}, 
			{id = 15207, cost = 24000, requiredIds = {10392}}, 
			{id = 10437, cost = 24000, requiredIds = {6365}}, 
			{id = 10486, cost = 24000, requiredIds = {8235}}, 
		},
		[52] = {
			{id = 11315, cost = 27000, requiredIds = {11314}}, 
			{id = 10448, cost = 27000, requiredIds = {10447}}, 
			{id = 10467, cost = 27000, requiredIds = {10466}}, 
			{id = 10442, cost = 27000, requiredIds = {8161}}, 
		},
		[54] = {
			{id = 10623, cost = 29000, requiredIds = {10622}}, 
			{id = 10479, cost = 29000, requiredIds = {10478}}, 
			{id = 10408, cost = 29000, requiredIds = {10407}}, 
		},
		[55] = {
			{id = 52138, cost = 29000, requiredIds = {52136}}, 
		},
		[56] = {
			{id = 10605, cost = 30000, requiredIds = {2860}}, 
			{id = 16342, cost = 30000, requiredIds = {16341}}, 
			{id = 10396, cost = 30000, requiredIds = {10395}}, 
			{id = 15208, cost = 30000, requiredIds = {15207}}, 
			{id = 10432, cost = 30000, requiredIds = {10431}}, 
			{id = 10587, cost = 30000, requiredIds = {10586}}, 
			{id = 10497, cost = 30000, requiredIds = {10496}}, 
		},
		[58] = {
			{id = 10538, cost = 32000, requiredIds = {10537}}, 
			{id = 16387, cost = 32000, requiredIds = {10526}}, 
			{id = 10473, cost = 32000, requiredIds = {10472}}, 
			{id = 16356, cost = 32000, requiredIds = {16355}}, 
			{id = 10428, cost = 32000, requiredIds = {10427}}, 
		},
		[60] = {
			{id = 20777, cost = 34000, requiredIds = {20776}}, 
			{id = 32593, cost = 1700, requiredIds = {974}, requiredTalentId = 974}, 
			{id = 10414, cost = 34000, requiredIds = {10413}}, 
			{id = 51992, cost = 34000, requiredIds = {51991}}, 
			{id = 29228, cost = 65000, requiredIds = {10448}}, 
			{id = 10463, cost = 34000, requiredIds = {10462}}, 
			{id = 25357, cost = 6500, requiredIds = {10396}}, 
			{id = 10468, cost = 34000, requiredIds = {10467}}, 
			{id = 10601, cost = 34000, requiredIds = {10600}}, 
			{id = 10438, cost = 34000, requiredIds = {10437}}, 
			{id = 25361, cost = 34000, requiredIds = {10442}}, 
			{id = 57720, cost = 3400, requiredIds = {30706}, requiredTalentId = 30706}, 
			{id = 16362, cost = 34000, requiredIds = {10486}}, 
		},
		[61] = {
			{id = 25422, cost = 34000, requiredIds = {10623}}, 
			{id = 25546, cost = 34000, requiredIds = {11315}}, 
		},
		[62] = {
			{id = 25448, cost = 38000, requiredIds = {15208}}, 
			{id = 24398, cost = 38000, requiredIds = {52138}}, 
		},
		[63] = {
			{id = 25439, cost = 42000, requiredIds = {10605}}, 
			{id = 25391, cost = 42000, requiredIds = {25357}}, 
			{id = 25469, cost = 42000, requiredIds = {10432}}, 
			{id = 25508, cost = 42000, requiredIds = {10408}}, 
		},
		[64] = {
			{id = 25489, cost = 47000, requiredIds = {16342}}, 
			{id = 3738, cost = 47000}, 
		},
		[65] = {
			{id = 25552, cost = 52000, requiredIds = {10587}}, 
			{id = 25570, cost = 52000, requiredIds = {10497}}, 
			{id = 25528, cost = 52000, requiredIds = {25361}}, 
		},
		[66] = {
			{id = 2062, cost = 58000}, 
			{id = 25500, cost = 58000, requiredIds = {16356}}, 
			{id = 25420, cost = 58000, requiredIds = {10468}}, 
		},
		[67] = {
			{id = 25557, cost = 64000, requiredIds = {16387}}, 
			{id = 25560, cost = 64000, requiredIds = {10479}}, 
			{id = 25449, cost = 64000, requiredIds = {25448}}, 
			{id = 25525, cost = 64000, requiredIds = {10428}}, 
		},
		[68] = {
			{id = 25423, cost = 71000, requiredIds = {25422}}, 
			{id = 2894, cost = 71000}, 
			{id = 25563, cost = 71000, requiredIds = {10538}}, 
			{id = 25464, cost = 71000, requiredIds = {10473}}, 
			{id = 25505, cost = 71000, requiredIds = {16362}}, 
		},
		[69] = {
			{id = 25590, cost = 79000, requiredIds = {20777}}, 
			{id = 25454, cost = 79000, requiredIds = {10414}}, 
			{id = 25567, cost = 79000, requiredIds = {10463}}, 
			{id = 25574, cost = 79000, requiredIds = {10601}}, 
			{id = 25533, cost = 79000, requiredIds = {10438}}, 
			{id = 33736, cost = 79000, requiredIds = {24398}}, 
		},
		[70] = {
			{id = 2825, cost = 88000, faction = "Horde"}, 
			{id = 25442, cost = 88000, requiredIds = {25439}}, 
			{id = 32594, cost = 5000, requiredIds = {32593}, requiredTalentId = 974}, 
			{id = 51993, cost = 71000, requiredIds = {51992}}, 
			{id = 25547, cost = 88000, requiredIds = {25546}}, 
			{id = 25457, cost = 88000, requiredIds = {29228}}, 
			{id = 25396, cost = 88000, requiredIds = {25391}}, 
			{id = 32182, cost = 88000, faction = "Alliance"}, 
			{id = 25472, cost = 88000, requiredIds = {25469}}, 
			{id = 61299, cost = 9000, requiredIds = {61295}, requiredTalentId = 61295}, 
			{id = 25509, cost = 88000, requiredIds = {25508}}, 
			{id = 59156, cost = 88000, requiredIds = {51490}, requiredTalentId = 51490}, 
			{id = 57721, cost = 5200, requiredIds = {57720}, requiredTalentId = 30706}, 
		},
		[71] = {
			{id = 58649, cost = 180000, requiredIds = {25557}}, 
			{id = 58785, cost = 180000, requiredIds = {25489}}, 
			{id = 58794, cost = 180000, requiredIds = {25500}}, 
			{id = 58755, cost = 180000, requiredIds = {25567}}, 
			{id = 58771, cost = 180000, requiredIds = {25570}}, 
			{id = 58699, cost = 180000, requiredIds = {25533}}, 
			{id = 58580, cost = 180000, requiredIds = {25525}}, 
			{id = 58801, cost = 180000, requiredIds = {25505}}, 
		},
		[72] = {
			{id = 49275, cost = 180000, requiredIds = {25420}}, 
		},
		[73] = {
			{id = 49235, cost = 180000, requiredIds = {25464}}, 
			{id = 49237, cost = 180000, requiredIds = {25449}}, 
			{id = 58731, cost = 180000, requiredIds = {25552}}, 
			{id = 58751, cost = 180000, requiredIds = {25509}}, 
		},
		[74] = {
			{id = 55458, cost = 180000, requiredIds = {25423}}, 
			{id = 49270, cost = 180000, requiredIds = {25442}}, 
			{id = 49230, cost = 180000, requiredIds = {25454}}, 
		},
		[75] = {
			{id = 49283, cost = 9000, requiredIds = {32594}, requiredTalentId = 974}, 
			{id = 61649, cost = 180000, requiredIds = {25547}}, 
			{id = 58737, cost = 180000, requiredIds = {25563}}, 
			{id = 49232, cost = 180000, requiredIds = {25457}}, 
			{id = 58652, cost = 180000, requiredIds = {58649}}, 
			{id = 58741, cost = 180000, requiredIds = {25560}}, 
			{id = 49272, cost = 180000, requiredIds = {25396}}, 
			{id = 51505, cost = 180000}, 
			{id = 49280, cost = 180000, requiredIds = {25472}}, 
			{id = 58746, cost = 180000, requiredIds = {25574}}, 
			{id = 61300, cost = 9000, requiredIds = {61299}, requiredTalentId = 61295}, 
			{id = 58703, cost = 180000, requiredIds = {58699}}, 
			{id = 58581, cost = 180000, requiredIds = {58580}}, 
			{id = 57622, cost = 180000, requiredIds = {25528}}, 
			{id = 59158, cost = 180000, requiredIds = {59156}, requiredTalentId = 51490}, 
		},
		[76] = {
			{id = 58789, cost = 180000, requiredIds = {58785}}, 
			{id = 58795, cost = 180000, requiredIds = {58794}}, 
			{id = 58756, cost = 180000, requiredIds = {58755}}, 
			{id = 58773, cost = 180000, requiredIds = {58771}}, 
			{id = 57960, cost = 180000, requiredIds = {33736}}, 
			{id = 58803, cost = 180000, requiredIds = {58801}}, 
		},
		[77] = {
			{id = 49276, cost = 180000, requiredIds = {49275}}, 
		},
		[78] = {
			{id = 49236, cost = 180000, requiredIds = {49235}}, 
			{id = 58734, cost = 180000, requiredIds = {58731}}, 
			{id = 58582, cost = 180000, requiredIds = {58581}}, 
			{id = 58753, cost = 180000, requiredIds = {58751}}, 
		},
		[79] = {
			{id = 49231, cost = 180000, requiredIds = {49230}}, 
			{id = 49238, cost = 180000, requiredIds = {49237}}, 
		},
		[80] = {
			{id = 49277, cost = 180000, requiredIds = {25590}}, 
			{id = 55459, cost = 180000, requiredIds = {55458}}, 
			{id = 49271, cost = 180000, requiredIds = {49270}}, 
			{id = 49284, cost = 9000, requiredIds = {49283}, requiredTalentId = 974}, 
			{id = 51994, cost = 180000, requiredIds = {51993}}, 
			{id = 61657, cost = 180000, requiredIds = {61649}}, 
			{id = 58739, cost = 180000, requiredIds = {58737}}, 
			{id = 49233, cost = 180000, requiredIds = {49232}}, 
			{id = 58656, cost = 180000, requiredIds = {58652}}, 
			{id = 58790, cost = 180000, requiredIds = {58789}}, 
			{id = 58745, cost = 180000, requiredIds = {58741}}, 
			{id = 58796, cost = 180000, requiredIds = {58795}}, 
			{id = 58757, cost = 180000, requiredIds = {58756}}, 
			{id = 49273, cost = 180000, requiredIds = {49272}}, 
			{id = 51514, cost = 180000}, 
			{id = 60043, cost = 180000, requiredIds = {51505}}, 
			{id = 49281, cost = 180000, requiredIds = {49280}}, 
			{id = 58774, cost = 180000, requiredIds = {58773}}, 
			{id = 58749, cost = 180000, requiredIds = {58746}}, 
			{id = 61301, cost = 9000, requiredIds = {61300}, requiredTalentId = 61295}, 
			{id = 58704, cost = 180000, requiredIds = {58703}}, 
			{id = 58643, cost = 180000, requiredIds = {57622}}, 
			{id = 59159, cost = 180000, requiredIds = {59158}, requiredTalentId = 51490}, 
			{id = 57722, cost = 10000, requiredIds = {57721}, requiredTalentId = 30706}, 
			{id = 58804, cost = 180000, requiredIds = {58803}}, 
		},
	},
}

FatCooldowns.DruidSpells = {
	[0] = { 
		[1] = {
			{id = 1126, cost = 10}
		},
		[4] = {
			{id = 8921, cost = 100}, 
			{id = 774, cost = 100} 
		},
		[6] = {
			{id = 467, cost = 100}, 
			{id = 5177, cost = 100, requiredIds = {5176}} 
		},
		[8] = {
			{id = 339, cost = 200}, 
			{id = 5186, cost = 200, requiredIds = {5185}} 
		},
		[10] = {
			{id = 99, cost = 300, requiredIds = {5487}}, 
			{id = 5232, cost = 300, requiredIds = {1126}}, 
			{id = 8924, cost = 300, requiredIds = {8921}}, 
			{id = 1058, cost = 300, requiredIds = {774}} 
		},
		[12] = {
			{id = 5229, cost = 800, requiredIds = {5487}}, 
			{id = 8936, cost = 800} 
		},
		[14] = {
			{id = 5211, cost = 900, requiredIds = {5487}}, 
			{id = 5187, cost = 900, requiredIds = {5186}}, 
			{id = 782, cost = 900, requiredIds = {467}},
			{id = 5178, cost = 900, requiredIds = {5177}} 
		},
		[16] = {
			{id = 8925, cost = 1800, requiredIds = {8924}}, 
			{id = 1430, cost = 1800, requiredIds = {1058}}, 
			{id = 779, cost = 1800, requiredIds = {5487}}
		},
		[18] = {
			{id = 1062, cost = 1900, requiredIds = {339}},
			{id = 770, cost = 1900},
			{id = 2637, cost = 1900}, 
			{id = 6808, cost = 1900, requiredIds = {6807}}, 
			{id = 16810, cost = 95, requiredIds = {16689}, requiredTalentId = 16689}, 
			{id = 8938, cost = 1900, requiredIds = {8936}}
		},
		[20] = {
			{id = 768, cost = 2000},
			{id = 1082, cost = 2000, requiredIds = {768}}, 
			{id = 1735, cost = 2000, requiredIds = {99}},
			{id = 5188, cost = 2000, requiredIds = {5187}},
			{id = 6756, cost = 2000, requiredIds = {5232}},
			{id = 5215, cost = 2000, requiredIds = {768}},
			{id = 20484, cost = 2000},
			{id = 1079, cost = 2000, requiredIds = {768}}, 
			{id = 2912, cost = 2000}
		},
		[22] = {
			{id = 8926, cost = 3000, requiredIds = {8925}},
			{id = 2090, cost = 3000, requiredIds = {1430}},
			{id = 5221, cost = 3000, requiredIds = {768}}, 
			{id = 2908, cost = 3000},
			{id = 5179, cost = 3000, requiredIds = {5178}}
		},
		[24] = {
			{id = 1822, cost = 4000, requiredIds = {768}},
			{id = 8939, cost = 4000, requiredIds = {8938}}, 
			{id = 2782, cost = 4000},
			{id = 780, cost = 4000, requiredIds = {779}},
			{id = 1075, cost = 4000, requiredIds = {782}}, 
			{id = 5217, cost = 4000, requiredIds = {768}} 
		},
		[26] = {
			{id = 2893, cost = 4500}, 
			{id = 1850, cost = 4500, requiredIds = {768}},
			{id = 5189, cost = 4500, requiredIds = {5188}}, 
			{id = 6809, cost = 4500, requiredIds = {6808}}, 
			{id = 8949, cost = 4500, requiredIds = {2912}}
		},
		[28] = {
			{id = 5209, cost = 5000, requiredIds = {5487}}, 
			{id = 3029, cost = 5000, requiredIds = {1082}}, 
			{id = 8998, cost = 5000, requiredIds = {768}},
			{id = 5195, cost = 5000, requiredIds = {1062}}, 
			{id = 8927, cost = 5000, requiredIds = {8926}}, 
			{id = 16811, cost = 250, requiredIds = {16810}, requiredTalentId = 16689}, 
			{id = 2091, cost = 5000, requiredIds = {2090}}, 
			{id = 9492, cost = 5000, requiredIds = {1079}}
		},
		[30] = {
			{id = 6798, cost = 6000, requiredIds = {5211}}, 
			{id = 778, cost = 6000, requiredIds = {770}}, 
			{id = 17390, cost = 300, requiredIds = {16857}, requiredTalentId = 16857}, 
			{id = 24974, cost = 300, requiredIds = {5570}, requiredTalentId = 5570}, 
			{id = 5234, cost = 6000, requiredIds = {6756}}, 
			{id = 20739, cost = 6000, requiredIds = {20484}}, 
			{id = 8940, cost = 6000, requiredIds = {8939}}, 
			{id = 6800, cost = 6000, requiredIds = {5221}}, 
			{id = 740, cost = 6000},
			{id = 783, cost = 6000},
			{id = 5180, cost = 6000, requiredIds = {5179}} 
		},
		[32] = {
			{id = 9490, cost = 8000, requiredIds = {1735}}, 
			{id = 22568, cost = 8000, requiredIds = {768}}, 
			{id = 6778, cost = 8000, requiredIds = {5189}}, 
			{id = 6785, cost = 8000, requiredIds = {768}},
			{id = 5225, cost = 8000}
		},
		[34] = {
			{id = 8972, cost = 10000, requiredIds = {6809}}, 
			{id = 8928, cost = 10000, requiredIds = {8927}}, 
			{id = 1823, cost = 10000, requiredIds = {1822}}, 
			{id = 3627, cost = 10000, requiredIds = {2091}}, 
			{id = 8950, cost = 10000, requiredIds = {8949}}, 
			{id = 769, cost = 10000, requiredIds = {780}}, 
			{id = 8914, cost = 10000, requiredIds = {1075}}
		},
		[36] = {
			{id = 22842, cost = 11000, requiredIds = {5487}}, 
			{id = 9005, cost = 11000, requiredIds = {768}}, 
			{id = 8941, cost = 11000, requiredIds = {8940}},
			{id = 9493, cost = 11000, requiredIds = {9492}},
			{id = 6793, cost = 11000, requiredIds = {5217}} 
		},
		[38] = {
			{id = 5201, cost = 12000, requiredIds = {3029}},
			{id = 5196, cost = 12000, requiredIds = {5195}},
			{id = 8903, cost = 12000, requiredIds = {6778}},
			{id = 18657, cost = 12000, requiredIds = {2637}}, 
			{id = 16812, cost = 600, requiredIds = {16811}, requiredTalentId = 16689}, 
			{id = 8992, cost = 12000, requiredIds = {6800}}, 
			{id = 8955, cost = 12000, requiredIds = {2908}}, 
			{id = 6780, cost = 12000, requiredIds = {5180}}
		},
		[40] = {
			{id = 9000, cost = 14000, requiredIds = {8998}},
			{id = 9634, cost = 14000, requiredIds = {5487}},
			{id = 20719, cost = 14000, requiredIds = {768}},
			{id = 22827, cost = 14000, requiredIds = {22568}}, 
			{id = 16914, cost = 14000}, 
			{id = 29166, cost = 14000}, 
			{id = 24975, cost = 700, requiredIds = {24974}, requiredTalentId = 5570}, 
			{id = 8907, cost = 14000, requiredIds = {5234}}, 
			{id = 8929, cost = 14000, requiredIds = {8928}}, 
			{id = 6783, cost = 14000, requiredIds = {5215}}, 
			{id = 20742, cost = 14000, requiredIds = {20739}}, 
			{id = 8910, cost = 14000, requiredIds = {3627}}, 
			{id = 8918, cost = 14000, requiredIds = {740}}
		},
		[42] = {
			{id = 9747, cost = 16000, requiredIds = {9490}}, 
			{id = 9749, cost = 16000, requiredIds = {778}},
			{id = 17391, cost = 800, requiredIds = {17390}, requiredTalentId = 16857}, 
			{id = 9745, cost = 16000, requiredIds = {8972}}, 
			{id = 6787, cost = 16000, requiredIds = {6785}}, 
			{id = 9750, cost = 16000, requiredIds = {8941}}, 
			{id = 8951, cost = 16000, requiredIds = {8950}}
		},
		[44] = {
			{id = 22812, cost = 18000}, 
			{id = 9758, cost = 18000, requiredIds = {8903}}, 
			{id = 1824, cost = 18000, requiredIds = {1823}}, 
			{id = 9752, cost = 18000, requiredIds = {9493}}, 
			{id = 9754, cost = 18000, requiredIds = {769}},
			{id = 9756, cost = 18000, requiredIds = {8914}}
		},
		[46] = {
			{id = 8983, cost = 20000, requiredIds = {6798}},
			{id = 9821, cost = 20000, requiredIds = {1850}},
			{id = 22895, cost = 20000, requiredIds = {22842}}, 
			{id = 9833, cost = 20000, requiredIds = {8929}},
			{id = 9823, cost = 20000, requiredIds = {9005}},
			{id = 9839, cost = 20000, requiredIds = {8910}},
			{id = 9829, cost = 20000, requiredIds = {8992}},
			{id = 8905, cost = 20000, requiredIds = {6780}} 
		},
		[48] = {
			{id = 9849, cost = 22000, requiredIds = {5201}},
			{id = 9852, cost = 22000, requiredIds = {5196}},
			{id = 22828, cost = 22000, requiredIds = {22827}}, 
			{id = 16813, cost = 1100, requiredIds = {16812}, requiredTalentId = 16689}, 
			{id = 9856, cost = 22000, requiredIds = {9750}}, 
			{id = 9845, cost = 22000, requiredIds = {6793}}
		},
		[50] = {
			{id = 9888, cost = 23000, requiredIds = {9758}},
			{id = 17401, cost = 23000, requiredIds = {16914}}, 
			{id = 24976, cost = 1150, requiredIds = {24975}, requiredTalentId = 5570}, 
			{id = 9884, cost = 23000, requiredIds = {8907}}, 
			{id = 9880, cost = 23000, requiredIds = {9745}}, 
			{id = 9866, cost = 23000, requiredIds = {6787}}, 
			{id = 20747, cost = 23000, requiredIds = {20742}}, 
			{id = 9875, cost = 23000, requiredIds = {8951}}, 
			{id = 9862, cost = 23000, requiredIds = {8918}}
		},
		[52] = {
			{id = 9892, cost = 26000, requiredIds = {9000}}, 
			{id = 9898, cost = 26000, requiredIds = {9747}}, 
			{id = 9834, cost = 26000, requiredIds = {9833}}, 
			{id = 9840, cost = 26000, requiredIds = {9839}}, 
			{id = 9894, cost = 26000, requiredIds = {9752}}
		},
		[54] = {
			{id = 9907, cost = 28000, requiredIds = {9749}}, 
			{id = 17392, cost = 1400, requiredIds = {17391}, requiredTalentId = 16857}, 
			{id = 9904, cost = 28000, requiredIds = {1824}}, 
			{id = 9857, cost = 28000, requiredIds = {9856}}, 
			{id = 9830, cost = 28000, requiredIds = {9829}}, 
			{id = 9901, cost = 28000, requiredIds = {8955}}, 
			{id = 9908, cost = 28000, requiredIds = {9754}}, 
			{id = 9910, cost = 28000, requiredIds = {9756}}, 
			{id = 9912, cost = 28000, requiredIds = {8905}}
		},
		[56] = {
			{id = 22829, cost = 30000, requiredIds = {22828}}, 
			{id = 22896, cost = 30000, requiredIds = {22895}}, 
			{id = 9889, cost = 30000, requiredIds = {9888}}, 
			{id = 9827, cost = 30000, requiredIds = {9823}}
		},
		[58] = {
			{id = 9850, cost = 32000, requiredIds = {9849}}, 
			{id = 9853, cost = 32000, requiredIds = {9852}}, 
			{id = 18658, cost = 32000, requiredIds = {18657}}, 
			{id = 9881, cost = 32000, requiredIds = {9880}}, 
			{id = 9835, cost = 32000, requiredIds = {9834}}, 
			{id = 17329, cost = 1600, requiredIds = {16813}, requiredTalentId = 16689}, 
			{id = 9867, cost = 32000, requiredIds = {9866}}, 
			{id = 9841, cost = 32000, requiredIds = {9840}}, 
			{id = 9876, cost = 32000, requiredIds = {9875}}
		},
		[60] = {
			{id = 17402, cost = 34000, requiredIds = {17401}}, 
			{id = 24977, cost = 1700, requiredIds = {24976}, requiredTalentId = 5570}, 
			{id = 9885, cost = 34000, requiredIds = {9884}}, 
			{id = 9913, cost = 34000, requiredIds = {6783}}, 
			{id = 20748, cost = 34000, requiredIds = {20747}}, 
			{id = 9858, cost = 34000, requiredIds = {9857}}, 
			{id = 9896, cost = 34000, requiredIds = {9894}}, 
			{id = 9846, cost = 34000, requiredIds = {9845}}, 
			{id = 9863, cost = 34000, requiredIds = {9862}}
		}
	},
	[1] = { 
		[1] = {
			{id = 1126, cost = 10},
		},
		[4] = {
			{id = 8921, cost = 100},
			{id = 774, cost = 100},
		},
		[6] = {
			{id = 467, cost = 100},
			{id = 5177, cost = 100, requiredIds = {5176}},
		},
		[8] = {
			{id = 339, cost = 200},
			{id = 5186, cost = 200, requiredIds = {5185}},
		},
		[10] = {
			{id = 8924, cost = 300, requiredIds = {8921}},
			{id = 99, cost = 300, requiredIds = {5487}},
			{id = 5232, cost = 300, requiredIds = {1126}},
			{id = 1058, cost = 300, requiredIds = {774}},
		},
		[12] = {
			{id = 5229, cost = 800, requiredIds = {5487}},
			{id = 8936, cost = 800},
		},
		[14] = {
			{id = 782, cost = 900, requiredIds = {467}},
			{id = 5178, cost = 900, requiredIds = {5177}},
			{id = 5211, cost = 900, requiredIds = {5487}},
			{id = 5187, cost = 900, requiredIds = {5186}},
		},
		[16] = {
			{id = 8925, cost = 1800, requiredIds = {8924}},
			{id = 779, cost = 1800, requiredIds = {5487}},
			{id = 1430, cost = 1800, requiredIds = {1058}},
		},
		[18] = {
			{id = 1062, cost = 1900, requiredIds = {339}},
			{id = 770, cost = 1900},
			{id = 2637, cost = 1900},
			{id = 16810, cost = 95, requiredIds = {16689,1062}, requiredTalentId = 16689},
			{id = 6808, cost = 1900, requiredIds = {6807}},
			{id = 8938, cost = 1900, requiredIds = {8936}},
		},
		[20] = {
			{id = 2912, cost = 2000},
			{id = 768, cost = 2000},
			{id = 1082, cost = 2000, requiredIds = {768}},
			{id = 1735, cost = 2000, requiredIds = {99}},
			{id = 5215, cost = 2000, requiredIds = {768}},
			{id = 1079, cost = 2000, requiredIds = {768}},
			{id = 5188, cost = 2000, requiredIds = {5187}},
			{id = 6756, cost = 2000, requiredIds = {5232}},
			{id = 20484, cost = 2000},
		},
		[22] = {
			{id = 8926, cost = 3000, requiredIds = {8925}},
			{id = 2908, cost = 3000},
			{id = 5179, cost = 3000, requiredIds = {5178}},
			{id = 5221, cost = 3000, requiredIds = {768}},
			{id = 2090, cost = 3000, requiredIds = {1430}},
		},
		[24] = {
			{id = 1075, cost = 4000, requiredIds = {782}},
			{id = 1822, cost = 4000, requiredIds = {768}},
			{id = 780, cost = 4000, requiredIds = {779}},
			{id = 5217, cost = 4000, requiredIds = {768}},
			{id = 8939, cost = 4000, requiredIds = {8938}},
			{id = 2782, cost = 4000},
		},
		[26] = {
			{id = 8949, cost = 4500, requiredIds = {2912}},
			{id = 1850, cost = 4500, requiredIds = {768}},
			{id = 6809, cost = 4500, requiredIds = {6808}},
			{id = 2893, cost = 4500},
			{id = 5189, cost = 4500, requiredIds = {5188}},
		},
		[28] = {
			{id = 5195, cost = 5000, requiredIds = {1062}},
			{id = 8927, cost = 5000, requiredIds = {8926}},
			{id = 16811, cost = 250, requiredIds = {16810,5195}, requiredTalentId = 16689},
			{id = 5209, cost = 5000, requiredIds = {5487}},
			{id = 3029, cost = 5000, requiredIds = {1082}},
			{id = 8998, cost = 5000, requiredIds = {768}},
			{id = 9492, cost = 5000, requiredIds = {1079}},
			{id = 2091, cost = 5000, requiredIds = {2090}},
		},
		[30] = {
			{id = 778, cost = 6000, requiredIds = {770}},
			{id = 24974, cost = 300, requiredIds = {5570}, requiredTalentId = 5570},
			{id = 5180, cost = 6000, requiredIds = {5179}},
			{id = 6798, cost = 6000, requiredIds = {5211}},
			{id = 17390, cost = 300, requiredIds = {16857}, requiredTalentId = 16857},
			{id = 6800, cost = 6000, requiredIds = {5221}},
			{id = 783, cost = 6000},
			{id = 5234, cost = 6000, requiredIds = {6756}},
			{id = 20739, cost = 6000, requiredIds = {20484}},
			{id = 8940, cost = 6000, requiredIds = {8939}},
			{id = 740, cost = 6000},
		},
		[32] = {
			{id = 9490, cost = 8000, requiredIds = {1735}},
			{id = 22568, cost = 8000, requiredIds = {768}},
			{id = 6785, cost = 8000, requiredIds = {768}},
			{id = 5225, cost = 8000, requiredIds = {768}},
			{id = 6778, cost = 8000, requiredIds = {5189}},
		},
		[34] = {
			{id = 8928, cost = 10000, requiredIds = {8927}},
			{id = 8950, cost = 10000, requiredIds = {8949}},
			{id = 8914, cost = 10000, requiredIds = {1075}},
			{id = 8972, cost = 10000, requiredIds = {6809}},
			{id = 1823, cost = 10000, requiredIds = {1822}},
			{id = 769, cost = 10000, requiredIds = {780}},
			{id = 3627, cost = 10000, requiredIds = {2091}},
		},
		[36] = {
			{id = 22842, cost = 11000, requiredIds = {5487}},
			{id = 9005, cost = 11000, requiredIds = {768}},
			{id = 9493, cost = 11000, requiredIds = {9492}},
			{id = 6793, cost = 11000, requiredIds = {5217}},
			{id = 8941, cost = 11000, requiredIds = {8940}},
		},
		[38] = {
			{id = 5196, cost = 12000, requiredIds = {5195}},
			{id = 18657, cost = 12000, requiredIds = {2637}},
			{id = 16812, cost = 600, requiredIds = {16811,5196}, requiredTalentId = 16689},
			{id = 8955, cost = 12000, requiredIds = {2908}},
			{id = 6780, cost = 12000, requiredIds = {5180}},
			{id = 5201, cost = 12000, requiredIds = {3029}},
			{id = 8992, cost = 12000, requiredIds = {6800}},
			{id = 8903, cost = 12000, requiredIds = {6778}},
		},
		[40] = {
			{id = 16914, cost = 14000},
			{id = 29166, cost = 14000},
			{id = 24975, cost = 700, requiredIds = {24974}, requiredTalentId = 5570},
			{id = 8929, cost = 14000, requiredIds = {8928}},
			{id = 9000, cost = 14000, requiredIds = {8998}},
			{id = 9634, cost = 14000, requiredIds = {5487}},
			{id = 20719, cost = 14000, requiredIds = {768}},
			{id = 22827, cost = 14000, requiredIds = {22568}},
			{id = 6783, cost = 14000, requiredIds = {5215}},
			{id = 8907, cost = 14000, requiredIds = {5234}},
			{id = 20742, cost = 14000, requiredIds = {20739}},
			{id = 8910, cost = 14000, requiredIds = {3627}},
			{id = 8918, cost = 14000, requiredIds = {740}},
		},
		[42] = {
			{id = 9749, cost = 16000, requiredIds = {778}},
			{id = 8951, cost = 16000, requiredIds = {8950}},
			{id = 9747, cost = 16000, requiredIds = {9490}},
			{id = 17391, cost = 800, requiredIds = {17390}, requiredTalentId = 16857},
			{id = 9745, cost = 16000, requiredIds = {8972}},
			{id = 6787, cost = 16000, requiredIds = {6785}},
			{id = 9750, cost = 16000, requiredIds = {8941}},
		},
		[44] = {
			{id = 22812, cost = 18000},
			{id = 9756, cost = 18000, requiredIds = {8914}},
			{id = 1824, cost = 18000, requiredIds = {1823}},
			{id = 9752, cost = 18000, requiredIds = {9493}},
			{id = 9754, cost = 18000, requiredIds = {769}},
			{id = 9758, cost = 18000, requiredIds = {8903}},
		},
		[46] = {
			{id = 9833, cost = 20000, requiredIds = {8929}},
			{id = 8905, cost = 20000, requiredIds = {6780}},
			{id = 8983, cost = 20000, requiredIds = {6798}},
			{id = 9821, cost = 20000, requiredIds = {1850}},
			{id = 22895, cost = 20000, requiredIds = {22842}},
			{id = 9823, cost = 20000, requiredIds = {9005}},
			{id = 9829, cost = 20000, requiredIds = {8992}},
			{id = 9839, cost = 20000, requiredIds = {8910}},
		},
		[48] = {
			{id = 9852, cost = 22000, requiredIds = {5196}},
			{id = 16813, cost = 1100, requiredIds = {16812,9852}, requiredTalentId = 16689},
			{id = 9849, cost = 22000, requiredIds = {5201}},
			{id = 22828, cost = 22000, requiredIds = {22827}},
			{id = 9845, cost = 22000, requiredIds = {6793}},
			{id = 9856, cost = 22000, requiredIds = {9750}},
		},
		[50] = {
			{id = 17401, cost = 23000, requiredIds = {16914}},
			{id = 24976, cost = 1150, requiredIds = {24975}, requiredTalentId = 5570},
			{id = 9875, cost = 23000, requiredIds = {8951}},
			{id = 9880, cost = 23000, requiredIds = {9745}},
			{id = 9866, cost = 23000, requiredIds = {6787}},
			{id = 21849, cost = 23000, requiredIds = {9884}},
			{id = 9888, cost = 23000, requiredIds = {9758}},
			{id = 9884, cost = 23000, requiredIds = {8907}},
			{id = 20747, cost = 23000, requiredIds = {20742}},
			{id = 9862, cost = 23000, requiredIds = {8918}},
		},
		[52] = {
			{id = 9834, cost = 26000, requiredIds = {9833}},
			{id = 9892, cost = 26000, requiredIds = {9000}},
			{id = 9898, cost = 26000, requiredIds = {9747}},
			{id = 9894, cost = 26000, requiredIds = {9752}},
			{id = 9840, cost = 26000, requiredIds = {9839}},
		},
		[54] = {
			{id = 9907, cost = 28000, requiredIds = {9749}},
			{id = 9901, cost = 28000, requiredIds = {8955}},
			{id = 9910, cost = 28000, requiredIds = {9756}},
			{id = 9912, cost = 28000, requiredIds = {8905}},
			{id = 17392, cost = 1400, requiredIds = {17391}, requiredTalentId = 16857},
			{id = 9904, cost = 28000, requiredIds = {1824}},
			{id = 9830, cost = 28000, requiredIds = {9829}},
			{id = 9908, cost = 28000, requiredIds = {9754}},
			{id = 9857, cost = 28000, requiredIds = {9856}},
		},
		[56] = {
			{id = 22829, cost = 30000, requiredIds = {22828}},
			{id = 22896, cost = 30000, requiredIds = {22895}},
			{id = 9827, cost = 30000, requiredIds = {9823}},
			{id = 9889, cost = 30000, requiredIds = {9888}},
		},
		[58] = {
			{id = 9853, cost = 32000, requiredIds = {9852}},
			{id = 18658, cost = 32000, requiredIds = {18657}},
			{id = 9835, cost = 32000, requiredIds = {9834}},
			{id = 17329, cost = 1600, requiredIds = {16813,9853}, requiredTalentId = 16689},
			{id = 9876, cost = 32000, requiredIds = {9875}},
			{id = 9850, cost = 32000, requiredIds = {9849}},
			{id = 33986, cost = 1700, requiredIds = {33878}, requiredTalentId = 33917},
			{id = 33982, cost = 1700, requiredIds = {33876}, requiredTalentId = 33917},
			{id = 9881, cost = 32000, requiredIds = {9880}},
			{id = 9867, cost = 32000, requiredIds = {9866}},
			{id = 9841, cost = 32000, requiredIds = {9840}},
		},
		[60] = {
			{id = 17402, cost = 34000, requiredIds = {17401}},
			{id = 24977, cost = 1700, requiredIds = {24976}, requiredTalentId = 5570},
			{id = 25298, cost = 34000, requiredIds = {9876}},
			{id = 31709, cost = 34000, requiredIds = {9892}},
			{id = 31018, cost = 30000, requiredIds = {22829}},
			{id = 9913, cost = 34000, requiredIds = {6783}},
			{id = 9896, cost = 34000, requiredIds = {9894}},
			{id = 9846, cost = 34000, requiredIds = {9845}},
			{id = 21850, cost = 34000, requiredIds = {21849}},
			{id = 25297, cost = 34000, requiredIds = {9889}},
			{id = 9885, cost = 34000, requiredIds = {9884}},
			{id = 20748, cost = 34000, requiredIds = {20747}},
			{id = 9858, cost = 34000, requiredIds = {9857}},
			{id = 25299, cost = 34000, requiredIds = {9841}},
			{id = 9863, cost = 34000, requiredIds = {9862}},
		},
		[61] = {
			{id = 26984, cost = 39000, requiredIds = {9912}},
			{id = 27001, cost = 39000, requiredIds = {9830}},
		},
		[62] = {
			{id = 26998, cost = 43000, requiredIds = {9898}},
			{id = 22570, cost = 43000},
			{id = 26978, cost = 43000, requiredIds = {25297}},
		},
		[63] = {
			{id = 26987, cost = 48000, requiredIds = {9835}},
			{id = 24248, cost = 48000, requiredIds = {31018}},
			{id = 26981, cost = 48000, requiredIds = {25299}},
		},
		[64] = {
			{id = 26992, cost = 53000, requiredIds = {9910}},
			{id = 27003, cost = 53000, requiredIds = {9904}},
			{id = 26997, cost = 53000, requiredIds = {9908}},
			{id = 33763, cost = 53000},
		},
		[65] = {
			{id = 33357, cost = 59000, requiredIds = {9821}},
			{id = 26999, cost = 59000, requiredIds = {22896}},
			{id = 26980, cost = 59000, requiredIds = {9858}},
		},
		[66] = {
			{id = 26993, cost = 34000, requiredIds = {9907}},
			{id = 27011, cost = 1700, requiredIds = {17392}, requiredTalentId = 16857},
			{id = 33745, cost = 66000},
			{id = 27006, cost = 66000, requiredIds = {9827}},
			{id = 27005, cost = 66000, requiredIds = {9867}},
		},
		[67] = {
			{id = 26986, cost = 73000, requiredIds = {25298}},
			{id = 27000, cost = 73000, requiredIds = {9850}},
			{id = 26996, cost = 73000, requiredIds = {9881}},
			{id = 27008, cost = 73000, requiredIds = {9896}},
		},
		[68] = {
			{id = 26989, cost = 81000, requiredIds = {9853}},
			{id = 27009, cost = 1700, requiredIds = {17329,26989}, requiredTalentId = 16689},
			{id = 33987, cost = 1900, requiredIds = {33986}, requiredTalentId = 33917},
			{id = 33983, cost = 1700, requiredIds = {33982}, requiredTalentId = 33917},
			{id = 33943, cost = 81000},
		},
		[69] = {
			{id = 26985, cost = 90000, requiredIds = {26984}},
			{id = 27004, cost = 90000, requiredIds = {31709}},
			{id = 26979, cost = 90000, requiredIds = {26978}},
			{id = 26994, cost = 90000, requiredIds = {20748}},
			{id = 26982, cost = 90000, requiredIds = {26981}},
		},
		[70] = {
			{id = 33786, cost = 100000},
			{id = 27012, cost = 100000, requiredIds = {17402}},
			{id = 27013, cost = 2500, requiredIds = {24977}, requiredTalentId = 5570},
			{id = 26988, cost = 100000, requiredIds = {26987}},
			{id = 26995, cost = 100000, requiredIds = {9901}},
			{id = 27002, cost = 100000, requiredIds = {27001}},
			{id = 26990, cost = 100000, requiredIds = {9885}},
			{id = 26983, cost = 100000, requiredIds = {9863}},
		},
	},
	[2] = {
		[1] ={
			{id =1126, cost = 10},
		},
		[4] ={
			{id =8921, cost =100},
			{id = 774, cost =100},
		},
		[6] ={
			{id = 467, cost =100},
			{id =5177, cost =100, requiredIds = {5176}},
		},
		[8] ={
			{id = 339, cost =200},
			{id =5186, cost =200, requiredIds = {5185}},
		},
		[10] ={
			{id =99, cost =300, requiredIds = {5487}},
			{id =5232, cost =300, requiredIds = {1126}},
			{id =8924, cost =300, requiredIds = {8921}},
			{id = 16689, cost =300, requiredIds = {339}},
			{id =1058, cost =300, requiredIds = {774}},
		},
		[12] ={
			{id =5229, cost =800, requiredIds = {5487}},
			{id =8936, cost =800},
			{id = 50769, cost =800},
		},
		[14] ={
			{id =5211, cost =900, requiredIds = {5487}},
			{id =5187, cost =900, requiredIds = {5186}},
			{id = 782, cost =900, requiredIds = {467}},
			{id =5178, cost =900, requiredIds = {5177}},
		},
		[16] ={
			{id =1066, cost =900},
			{id =8925, cost = 1800, requiredIds = {8924}},
			{id =1430, cost = 1800, requiredIds = {1058}},
			{id = 779, cost = 1800, requiredIds = {5487}},
			{id = 783, cost = 6000},
		},
		[18] ={
			{id =1062, cost = 1900, requiredIds = {339}},
			{id = 770, cost = 1900},
			{id = 16857, cost = 1900},
			{id =2637, cost = 1900},
			{id =6808, cost = 1900, requiredIds = {6807}},
			{id = 16810, cost = 1900, requiredIds = {16689,1062}},
			{id =8938, cost = 1900, requiredIds = {8936}},
		},
		[20] ={
			{id = 768, cost = 2000},
			{id =1082, cost = 2000, requiredIds = {768}},
			{id =1735, cost = 2000, requiredIds = {99}},
			{id =5188, cost = 2000, requiredIds = {5187}},
			{id =6756, cost = 2000, requiredIds = {5232}},
			{id =5215, cost = 2000, requiredIds = {768}},
			{id = 20484, cost = 2000},
			{id =1079, cost = 2000, requiredIds = {768}},
			{id =2912, cost = 2000},
		},
		[22] ={
			{id =8926, cost = 3000, requiredIds = {8925}},
			{id =2090, cost = 3000, requiredIds = {1430}},
			{id =5221, cost = 3000, requiredIds = {768}},
			{id =2908, cost = 3000},
			{id =5179, cost = 3000, requiredIds = {5178}},
		},
		[24] ={
			{id =1822, cost = 4000, requiredIds = {768}},
			{id =8939, cost = 4000, requiredIds = {8938}},
			{id =2782, cost = 4000},
			{id = 50768, cost = 4000, requiredIds = {50769}},
			{id = 780, cost = 4000, requiredIds = {779}},
			{id =1075, cost = 4000, requiredIds = {782}},
			{id =5217, cost = 4000, requiredIds = {768}},
		},
		[26] ={
			{id =2893, cost = 4500},
			{id =1850, cost = 4500, requiredIds = {768}},
			{id =5189, cost = 4500, requiredIds = {5188}},
			{id =6809, cost = 4500, requiredIds = {6808}},
			{id =8949, cost = 4500, requiredIds = {2912}},
		},
		[28] ={
			{id =5209, cost = 5000, requiredIds = {5487}},
			{id =3029, cost = 5000, requiredIds = {1082}},
			{id =8998, cost = 5000, requiredIds = {768}},
			{id =5195, cost = 5000, requiredIds = {1062}},
			{id =8927, cost = 5000, requiredIds = {8926}},
			{id = 16811, cost = 5000, requiredIds = {16810,5195}},
			{id =2091, cost = 5000, requiredIds = {2090}},
			{id =9492, cost = 5000, requiredIds = {1079}},
		},
		[30] ={
			{id =6798, cost = 6000, requiredIds = {5211}},
			{id = 24974, cost = 6000, requiredIds = {5570}, requiredTalentId = 5570},
			{id =5234, cost = 6000, requiredIds = {6756}},
			{id = 20739, cost = 6000, requiredIds = {20484}},
			{id =8940, cost = 6000, requiredIds = {8939}},
			{id =6800, cost = 6000, requiredIds = {5221}},
			{id = 740, cost = 6000},
			{id =5180, cost = 6000, requiredIds = {5179}},
		},
		[32] ={
			{id =9490, cost = 8000, requiredIds = {1735}},
			{id = 22568, cost = 8000, requiredIds = {768}},
			{id =6778, cost = 8000, requiredIds = {5189}},
			{id =6785, cost = 8000, requiredIds = {768}},
			{id =5225, cost = 8000, requiredIds = {768}},
		},
		[34] ={
			{id =8972, cost =10000, requiredIds = {6809}},
			{id =8928, cost =10000, requiredIds = {8927}},
			{id =1823, cost =10000, requiredIds = {1822}},
			{id =3627, cost =10000, requiredIds = {2091}},
			{id =8950, cost =10000, requiredIds = {8949}},
			{id = 769, cost =10000, requiredIds = {780}},
			{id =8914, cost =10000, requiredIds = {1075}},
		},
		[36] ={
			{id = 22842, cost =11000, requiredIds = {5487}},
			{id =9005, cost =11000, requiredIds = {768}},
			{id =8941, cost =11000, requiredIds = {8940}},
			{id = 50767, cost =11000, requiredIds = {50768}},
			{id =9493, cost =11000, requiredIds = {9492}},
			{id =6793, cost =11000, requiredIds = {5217}},
		},
		[38] ={
			{id =5201, cost =12000, requiredIds = {3029}},
			{id =5196, cost =12000, requiredIds = {5195}},
			{id =8903, cost =12000, requiredIds = {6778}},
			{id = 18657, cost =12000, requiredIds = {2637}},
			{id = 16812, cost =12000, requiredIds = {16811,5196}},
			{id =8992, cost =12000, requiredIds = {6800}},
			{id =8955, cost =12000, requiredIds = {2908}},
			{id =6780, cost =12000, requiredIds = {5180}},
		},
		[40] ={
			{id =9000, cost =14000, requiredIds = {8998}},
			{id =9634, cost =14000, requiredIds = {5487}},
			{id = 20719, cost =14000, requiredIds = {768}},
			{id = 22827, cost =14000, requiredIds = {22568}},
			{id = 16914, cost =14000},
			{id = 29166, cost =14000},
			{id = 24975, cost =14000, requiredIds = {24974}, requiredTalentId = 5570},
			{id =8907, cost =14000, requiredIds = {5234}},
			{id =8929, cost =14000, requiredIds = {8928}},
			{id = 20742, cost =14000, requiredIds = {20739}},
			{id =8910, cost =14000, requiredIds = {3627}},
			{id = 62600, cost = 4500, requiredIds = {5487}},
			{id =8918, cost =14000, requiredIds = {740}},
		},
		[42] ={
			{id =9747, cost =16000, requiredIds = {9490}},
			{id =9745, cost =16000, requiredIds = {8972}},
			{id =6787, cost =16000, requiredIds = {6785}},
			{id =9750, cost =16000, requiredIds = {8941}},
			{id =8951, cost =16000, requiredIds = {8950}},
		},
		[44] ={
			{id = 22812, cost =18000},
			{id =9758, cost =18000, requiredIds = {8903}},
			{id =1824, cost =18000, requiredIds = {1823}},
			{id =9752, cost =18000, requiredIds = {9493}},
			{id =9754, cost =18000, requiredIds = {769}},
			{id =9756, cost =18000, requiredIds = {8914}},
		},
		[46] ={
			{id =8983, cost =20000, requiredIds = {6798}},
			{id =9821, cost =20000, requiredIds = {1850}},
			{id =9833, cost =20000, requiredIds = {8929}},
			{id =9823, cost =20000, requiredIds = {9005}},
			{id =9839, cost =20000, requiredIds = {8910}},
			{id =9829, cost =20000, requiredIds = {8992}},
			{id =8905, cost =20000, requiredIds = {6780}},
		},
		[48] ={
			{id =9849, cost =22000, requiredIds = {5201}},
			{id =9852, cost =22000, requiredIds = {5196}},
			{id = 22828, cost =22000, requiredIds = {22827}},
			{id = 16813, cost =22000, requiredIds = {16812,9852}},
			{id =9856, cost =22000, requiredIds = {9750}},
			{id = 50766, cost =22000, requiredIds = {50767}},
			{id =9845, cost =22000, requiredIds = {6793}},
		},
		[50] ={
			{id = 21849, cost =23000, requiredIds = {9884}},
			{id =9888, cost =23000, requiredIds = {9758}},
			{id = 17401, cost =23000, requiredIds = {16914}},
			{id = 24976, cost =12000, requiredIds = {24975}, requiredTalentId = 5570},
			{id =9884, cost =23000, requiredIds = {8907}},
			{id =9880, cost =23000, requiredIds = {9745}},
			{id =9866, cost =23000, requiredIds = {6787}},
			{id = 20747, cost =23000, requiredIds = {20742}},
			{id =9875, cost =23000, requiredIds = {8951}},
			{id =9862, cost =23000, requiredIds = {8918}},
		},
		[52] ={
			{id =9892, cost =26000, requiredIds = {9000}},
			{id =9898, cost =26000, requiredIds = {9747}},
			{id =9834, cost =26000, requiredIds = {9833}},
			{id =9840, cost =26000, requiredIds = {9839}},
			{id =9894, cost =26000, requiredIds = {9752}},
		},
		[54] ={
			{id =9904, cost =28000, requiredIds = {1824}},
			{id =9857, cost =28000, requiredIds = {9856}},
			{id =9830, cost =28000, requiredIds = {9829}},
			{id =9901, cost =28000, requiredIds = {8955}},
			{id =9908, cost =28000, requiredIds = {9754}},
			{id =9910, cost =28000, requiredIds = {9756}},
			{id =9912, cost =28000, requiredIds = {8905}},
		},
		[56] ={
			{id = 22829, cost =30000, requiredIds = {22828}},
			{id =9889, cost =30000, requiredIds = {9888}},
			{id =9827, cost =30000, requiredIds = {9823}},
		},
		[58] ={
			{id =9850, cost =32000, requiredIds = {9849}},
			{id =9853, cost =32000, requiredIds = {9852}},
			{id = 18658, cost =32000, requiredIds = {18657}},
			{id = 33986, cost = 1700, requiredIds = {33878}, requiredTalentId = 33917},
			{id = 33982, cost = 1700, requiredIds = {33876}, requiredTalentId = 33917},
			{id =9881, cost =32000, requiredIds = {9880}},
			{id =9835, cost =32000, requiredIds = {9834}},
			{id = 17329, cost =32000, requiredIds = {16813,9853}},
			{id =9867, cost =32000, requiredIds = {9866}},
			{id =9841, cost =32000, requiredIds = {9840}},
			{id =9876, cost =32000, requiredIds = {9875}},
		},
		[60] ={
			{id = 31709, cost =34000, requiredIds = {9892}},
			{id = 31018, cost =30000, requiredIds = {22829}},
			{id = 33943, cost =34000},
			{id = 21850, cost =34000, requiredIds = {21849,9885}},
			{id = 25297, cost =34000, requiredIds = {9889}},
			{id = 17402, cost =34000, requiredIds = {17401}},
			{id = 24977, cost =34000, requiredIds = {24976}, requiredTalentId = 5570},
			{id =9885, cost =34000, requiredIds = {9884}},
			{id = 20748, cost =34000, requiredIds = {20747}},
			{id =9858, cost =34000, requiredIds = {9857}},
			{id = 25299, cost =34000, requiredIds = {9841}},
			{id = 50765, cost =34000, requiredIds = {50766}},
			{id =9896, cost =34000, requiredIds = {9894}},
			{id = 25298, cost =34000, requiredIds = {9876}},
			{id =9846, cost =34000, requiredIds = {9845}},
			{id =9863, cost =34000, requiredIds = {9862}},
			{id = 53223, cost =600, requiredIds = {50516}, requiredTalentId = 50516},
		},
		[61] ={
			{id = 27001, cost =39000, requiredIds = {9830}},
			{id = 26984, cost =39000, requiredIds = {9912}},
		},
		[62] ={
			{id = 26998, cost =43000, requiredIds = {9898}},
			{id = 26978, cost =43000, requiredIds = {25297}},
			{id = 22570, cost =43000},
		},
		[63] ={
			{id = 24248, cost =48000, requiredIds = {31018}},
			{id = 26987, cost =48000, requiredIds = {9835}},
			{id = 26981, cost =48000, requiredIds = {25299}},
		},
		[64] ={
			{id = 33763, cost =53000},
			{id = 27003, cost =53000, requiredIds = {9904}},
			{id = 26997, cost =53000, requiredIds = {9908}},
			{id = 26992, cost =53000, requiredIds = {9910}},
		},
		[65] ={
			{id = 33357, cost =59000, requiredIds = {9821}},
			{id = 26980, cost =59000, requiredIds = {9858}},
		},
		[66] ={
			{id = 33745, cost =66000},
			{id = 27006, cost =66000, requiredIds = {9827}},
			{id = 27005, cost =66000, requiredIds = {9867}},
		},
		[67] ={
			{id = 27000, cost =73000, requiredIds = {9850}},
			{id = 26996, cost =73000, requiredIds = {9881}},
			{id = 27008, cost =73000, requiredIds = {9896}},
			{id = 26986, cost =73000, requiredIds = {25298}},
		},
		[68] ={
			{id = 26989, cost =81000, requiredIds = {9853}},
			{id = 33987, cost = 1900, requiredIds = {33986}, requiredTalentId = 33917},
			{id = 33983, cost = 1700, requiredIds = {33982}, requiredTalentId = 33917},
			{id = 27009, cost =81000, requiredIds = {17329,26989}},
		},
		[69] ={
			{id = 27004, cost =90000, requiredIds = {31709}},
			{id = 26979, cost =90000, requiredIds = {26978}},
			{id = 26994, cost =90000, requiredIds = {20748}},
			{id = 26982, cost =90000, requiredIds = {26981}},
			{id = 50764, cost =90000, requiredIds = {50765}},
			{id = 26985, cost =90000, requiredIds = {26984}},
		},
		[70] ={
			{id = 33786, cost = 100000},
			{id = 26991, cost = 100000, requiredIds = {21850,26990}},
			{id = 27012, cost = 100000, requiredIds = {17402}},
			{id = 27013, cost = 200000, requiredIds = {24977}, requiredTalentId = 5570},
			{id = 26990, cost = 100000, requiredIds = {9885}},
			{id = 26988, cost = 100000, requiredIds = {26987}},
			{id = 27002, cost = 100000, requiredIds = {27001}},
			{id = 26995, cost = 100000, requiredIds = {9901}},
			{id = 53199, cost =10000, requiredIds = {48505}, requiredTalentId = 48505},
			{id = 40120, cost = 200000, requiredIds = {33943}},
			{id = 26983, cost = 100000, requiredIds = {9863}},
			{id = 53225, cost = 1700, requiredIds = {53223}, requiredTalentId = 50516},
			{id = 53248, cost = 1700, requiredIds = {48438}, requiredTalentId = 48438},
		},
		[71] ={
			{id = 48559, cost = 200000, requiredIds = {26998}},
			{id = 48442, cost = 200000, requiredIds = {26980}},
			{id = 49799, cost = 200000, requiredIds = {27008}},
			{id = 62078, cost = 200000},
			{id = 50212, cost = 200000, requiredIds = {9846}},
		},
		[72] ={
			{id = 48576, cost = 200000, requiredIds = {24248}},
			{id = 48450, cost = 200000, requiredIds = {33763}},
			{id = 48573, cost = 200000, requiredIds = {27003}},
			{id = 48464, cost = 200000, requiredIds = {26986}},
			{id = 48561, cost = 200000, requiredIds = {26997}},
		},
		[73] ={
			{id = 48569, cost = 200000, requiredIds = {27000}},
			{id = 48567, cost = 200000, requiredIds = {33745}},
			{id = 48479, cost = 200000, requiredIds = {26996}},
			{id = 48578, cost = 200000, requiredIds = {27005}},
		},
		[74] ={
			{id = 48377, cost = 200000, requiredIds = {26979}},
			{id = 49802, cost = 200000, requiredIds = {22570}},
			{id = 53307, cost = 200000, requiredIds = {26992}},
			{id = 48459, cost = 200000, requiredIds = {26985}},
		},
		[75] ={
			{id = 48563, cost =10000, requiredIds = {33987}, requiredTalentId = 33917},
			{id = 48565, cost =10000, requiredIds = {33983}, requiredTalentId = 33917},
			{id = 48462, cost = 200000, requiredIds = {26988}},
			{id = 48440, cost = 200000, requiredIds = {26982}},
			{id = 52610, cost = 200000},
			{id = 48571, cost = 200000, requiredIds = {27002}},
			{id = 53200, cost =10000, requiredIds = {53199}, requiredTalentId = 48505},
			{id = 48446, cost = 200000, requiredIds = {26983}},
			{id = 53226, cost =10000, requiredIds = {53225}, requiredTalentId = 50516},
			{id = 53249, cost =10000, requiredIds = {53248}, requiredTalentId = 48438},
		},
		[76] ={
			{id = 48575, cost = 200000, requiredIds = {27004}},
		},
		[77] ={
			{id = 48560, cost = 200000, requiredIds = {48559}},
			{id = 49803, cost = 200000, requiredIds = {27006}},
			{id = 48443, cost = 200000, requiredIds = {48442}},
			{id = 48562, cost = 200000, requiredIds = {48561}},
		},
		[78] ={
			{id = 53308, cost = 200000, requiredIds = {26989}},
			{id = 48577, cost = 200000, requiredIds = {48576}},
			{id = 53312, cost = 200000, requiredIds = {27009,53308}},
			{id = 48574, cost = 200000, requiredIds = {48573}},
			{id = 48465, cost = 200000, requiredIds = {48464}},
		},
		[79] ={
			{id = 48570, cost = 200000, requiredIds = {48569}},
			{id = 48378, cost = 200000, requiredIds = {48377}},
			{id = 48480, cost = 200000, requiredIds = {48479}},
			{id = 48579, cost = 200000, requiredIds = {48578}},
			{id = 48477, cost = 200000, requiredIds = {26994}},
			{id = 50213, cost = 200000, requiredIds = {50212}},
			{id = 48461, cost = 200000, requiredIds = {48459}},
		},
		[80] ={
			{id = 48470, cost = 200000, requiredIds = {48469,26991}},
			{id = 48467, cost = 200000, requiredIds = {27012}},
			{id = 48468, cost = 200000, requiredIds = {27013}, requiredTalentId = 5570},
			{id = 48568, cost = 200000, requiredIds = {48567}},
			{id = 48451, cost = 200000, requiredIds = {48450}},
			{id = 48564, cost =10000, requiredIds = {48563}, requiredTalentId = 33917},
			{id = 48566, cost =10000, requiredIds = {48565}, requiredTalentId = 33917},
			{id = 48469, cost = 200000, requiredIds = {26990}},
			{id = 48463, cost = 200000, requiredIds = {48462}},
			{id = 50464, cost = 200000},
			{id = 48441, cost = 200000, requiredIds = {48440}},
			{id = 50763, cost = 200000, requiredIds = {50764}},
			{id = 49800, cost = 200000, requiredIds = {49799}},
			{id = 48572, cost = 200000, requiredIds = {48571}},
			{id = 53201, cost =10000, requiredIds = {53200}, requiredTalentId = 48505},
			{id = 48447, cost = 200000, requiredIds = {48446}},
			{id = 61384, cost =10000, requiredIds = {53226}, requiredTalentId = 50516},
			{id = 53251, cost =10000, requiredIds = {53249}, requiredTalentId = 48438},
		},
	},
}

FatCooldowns.PaladinSpells = {
	[0] = { 
		[1] = {
			{id = 465, cost = 10}
		},
		[4] = {
			{id = 19740, cost = 100},
			{id = 20271, cost = 100}
		},
		[6] = {
			{id = 498, cost = 100},
			{id = 639, cost = 100, requiredIds = {635}},
			{id = 21082, cost = 100}
		},
		[8] = {
			{id = 853, cost = 100},
			{id = 3127, cost = 100},
			{id = 1152, cost = 100}
		},
		[10] = {
			{id = 1022, cost = 300},
			{id = 10290, cost = 300, requiredIds = {465}},
			{id = 633, cost = 300},
			{id = 20287, cost = 300, requiredIds = {21084}}
		},
		[12] = {
			{id = 19834, cost = 1000, requiredIds = {19740}},
			{id = 20162, cost = 1000, requiredIds = {21082}}
		},
		[14] = {
			{id = 19742, cost = 2000},
			{id = 647, cost = 2000, requiredIds = {639}}
		},
		[16] = {
			{id = 7294, cost = 3000},
			{id = 25780, cost = 3000}
		},
		[18] = {
			{id = 1044, cost = 3500},
			{id = 5573, cost = 3500, requiredIds = {498}},
			{id = 20288, cost = 3500, requiredIds = {20287}}
		},
		[20] = {
			{id = 643, cost = 4000, requiredIds = {10290}},
			{id = 879, cost = 4000},
			{id = 19750, cost = 4000}
		},
		[22] = {
			{id = 19835, cost = 4000, requiredIds = {19834}},
			{id = 19746, cost = 4000},
			{id = 1026, cost = 4000, requiredIds = {647}},
			{id = 20164, cost = 4000},
			{id = 20305, cost = 4000, requiredIds = {20162}}
		},
		[24] = {
			{id = 5599, cost = 5000, requiredIds = {1022}},
			{id = 19850, cost = 5000, requiredIds = {19742}},
			{id = 5588, cost = 5000, requiredIds = {853}},
			{id = 10322, cost = 5000},
			{id = 2878, cost = 5000}
		},
		[26] = {
			{id = 1038, cost = 6000},
			{id = 19939, cost = 6000, requiredIds = {19750}},
			{id = 10298, cost = 6000, requiredIds = {7294}},
			{id = 20289, cost = 6000, requiredIds = {20288}}
		},
		[28] = {
			{id = 5614, cost = 9000, requiredIds = {879}},
			{id = 19876, cost = 9000}
		},
		[30] = {
			{id = 20116, cost = 200, requiredTalentId = 26573},
			{id = 10291, cost = 11000, requiredIds = {643}},
			{id = 19752, cost = 11000},
			{id = 1042, cost = 11000, requiredIds = {1026}},
			{id = 2800, cost = 11000, requiredIds = {633}},
			{id = 20915, cost = 200, requiredTalentId = 20375},
			{id = 20165, cost = 11000}
		},
		[32] = {
			{id = 19836, cost = 12000, requiredIds = {19835}},
			{id = 19888, cost = 12000},
			{id = 20306, cost = 12000, requiredIds = {20305}}
		},
		[34] = {
			{id = 19852, cost = 13000, requiredIds = {19850}},
			{id = 642, cost = 13000},
			{id = 19940, cost = 13000, requiredIds = {19939}},
			{id = 20290, cost = 13000, requiredIds = {20289}}
		},
		[36] = {
			{id = 5615, cost = 14000, requiredIds = {5614}},
			{id = 19891, cost = 14000},
			{id = 10324, cost = 14000, requiredIds = {10322}},
			{id = 10299, cost = 14000, requiredIds = {10298}}
		},
		[38] = {
			{id = 10278, cost = 16000, requiredIds = {5599}},
			{id = 3472, cost = 16000, requiredIds = {1042}},
			{id = 20166, cost = 16000},
			{id = 5627, cost = 16000, requiredIds = {2878}}
		},
		[40] = {
			{id = 19977, cost = 20000},
			{id = 20912, cost = 900, requiredTalentId = 20911},
			{id = 20922, cost = 1000, requiredIds = {20116}, requiredTalentId = 26573},
			{id = 1032, cost = 20000, requiredIds = {10291}},
			{id = 5589, cost = 20000, requiredIds = {5588}},
			{id = 20918, cost = 1000, requiredIds = {20915}, requiredTalentId = 20375},
			{id = 20347, cost = 20000, requiredIds = {20165}},
			{id = 19895, cost = 20000, requiredIds = {19876}}
		},
		[42] = {
			{id = 19837, cost = 21000, requiredIds = {19836}},
			{id = 4987, cost = 21000},
			{id = 19941, cost = 21000, requiredIds = {19940}},
			{id = 20291, cost = 21000, requiredIds = {20290}},
			{id = 20307, cost = 21000, requiredIds = {20306}}
		},
		[44] = {
			{id = 19853, cost = 22000, requiredIds = {19852}},
			{id = 10312, cost = 22000, requiredIds = {5615}},
			{id = 19897, cost = 22000, requiredIds = {19888}},
			{id = 24275, cost = 22000}
		},
		[46] = {
			{id = 6940, cost = 24000},
			{id = 10328, cost = 24000, requiredIds = {3472}},
			{id = 10300, cost = 24000, requiredIds = {10299}}
		},
		[48] = {
			{id = 19899, cost = 26000, requiredIds = {19891}},
			{id = 20929, cost = 1170, requiredTalentId = 20473},
			{id = 20772, cost = 26000, requiredIds = {10324}},
			{id = 20356, cost = 26000, requiredIds = {20166}}
		},
		[50] = {
			{id = 19978, cost = 28000, requiredIds = {19977}},
			{id = 20913, cost = 1260, requiredIds = {20912}, requiredTalentId = 20911},
			{id = 20923, cost = 1400, requiredIds = {20922}, requiredTalentId = 26573},
			{id = 10292, cost = 28000, requiredIds = {1032}},
			{id = 1020, cost = 28000, requiredIds = {642}},
			{id = 19942, cost = 28000, requiredIds = {19941}},
			{id = 20927, cost = 1260, requiredTalentId = 20925},
			{id = 2812, cost = 28000},
			{id = 10310, cost = 28000, requiredIds = {2800}},
			{id = 20919, cost = 1260, requiredIds = {20918}, requiredTalentId = 20375},
			{id = 20348, cost = 28000, requiredIds = {20347}},
			{id = 20292, cost = 28000, requiredIds = {20291}}
		},
		[52] = {
			{id = 19838, cost = 34000, requiredIds = {19837}},
			{id = 10313, cost = 34000, requiredIds = {10312}},
			{id = 25782, cost = 46000, requiredIds = {19838}},
			{id = 24274, cost = 34000, requiredIds = {24275}},
			{id = 20308, cost = 34000, requiredIds = {20307}},
			{id = 19896, cost = 34000, requiredIds = {19895}},
			{id = 10326, cost = 34000, requiredIds = {5627}}
		},
		[54] = {
			{id = 20729, cost = 40000, requiredIds = {6940}},
			{id = 19854, cost = 40000, requiredIds = {19853}},
			{id = 25894, cost = 40000, requiredIds = {19854}},
			{id = 10308, cost = 40000, requiredIds = {5589}},
			{id = 10329, cost = 40000, requiredIds = {10328}}
		},
		[56] = {
			{id = 19898, cost = 42000, requiredIds = {19897}},
			{id = 20930, cost = 2100, requiredIds = {20929}, requiredTalentId = 20473},
			{id = 10301, cost = 42000, requiredIds = {10300}}
		},
		[58] = {
			{id = 19943, cost = 44000, requiredIds = {19942}},
			{id = 20293, cost = 44000, requiredIds = {20292}},
			{id = 20357, cost = 44000, requiredIds = {20356}}
		},
		[60] = {
			{id = 19979, cost = 46000, requiredIds = {19978}},
			{id = 20914, cost = 2070, requiredIds = {20913}, requiredTalentId = 20911},
			{id = 20924, cost = 2300, requiredIds = {20923}, requiredTalentId = 26573},
			{id = 10293, cost = 46000, requiredIds = {10292}},
			{id = 10314, cost = 46000, requiredIds = {10313}},
			{id = 19900, cost = 46000, requiredIds = {19899}},
			{id = 25898, cost = 2070, requiredTalentId = 20217},
			{id = 25890, cost = 46000, requiredIds = {19979}},
			{id = 25916, cost = 41400, requiredIds = {25291}},
			{id = 25895, cost = 46000, requiredIds = {1038}},
			{id = 25899, cost = 2070, requiredIds = {20914}, requiredTalentId = 20911},
			{id = 25918, cost = 46000, requiredIds = {25290}},
			{id = 24239, cost = 46000, requiredIds = {24274}},
			{id = 20928, cost = 2070, requiredIds = {20927}, requiredTalentId = 20925},
			{id = 10318, cost = 46000, requiredIds = {2812}},
			{id = 20773, cost = 46000, requiredIds = {20772}},
			{id = 20920, cost = 2070, requiredIds = {20919}, requiredTalentId = 20375},
			{id = 20349, cost = 46000, requiredIds = {20348}}
		},
	},
	[1] = { 
		[1] = {
			{id = 465, cost = 10},
		},
		[4] = {
			{id = 19740, cost = 100},
			{id = 20271, cost = 100},
		},
		[6] = {
			{id = 639, cost = 100, requiredIds = {635}},
			{id = 498, cost = 100},
			{id = 21082, cost = 100},
		},
		[8] = {
			{id = 3127, cost = 100},
			{id = 1152, cost = 100},
			{id = 853, cost = 100},
		},
		[10] = {
			{id = 633, cost = 300},
			{id = 20287, cost = 300, requiredIds = {21084}},
			{id = 1022, cost = 300},
			{id = 10290, cost = 300, requiredIds = {465}},
		},
		[12] = {
			{id = 19834, cost = 1000, requiredIds = {19740}},
			{id = 20162, cost = 1000, requiredIds = {21082}},
		},
		[14] = {
			{id = 19742, cost = 2000},
			{id = 647, cost = 2000, requiredIds = {639}},
			{id = 31789, cost = 4000},
		},
		[16] = {
			{id = 25780, cost = 3000},
			{id = 7294, cost = 3000},
		},
		[18] = {
			{id = 20288, cost = 3500, requiredIds = {20287}},
			{id = 1044, cost = 3500},
			{id = 5573, cost = 3500, requiredIds = {498}},
			{id = 31785, cost = 3500},
		},
		[20] = {
			{id = 26573, cost = 4000},
			{id = 879, cost = 4000},
			{id = 19750, cost = 4000},
			{id = 643, cost = 4000, requiredIds = {10290}},
		},
		[22] = {
			{id = 1026, cost = 4000, requiredIds = {647}},
			{id = 19746, cost = 4000},
			{id = 20164, cost = 4000},
			{id = 19835, cost = 4000, requiredIds = {19834}},
			{id = 20305, cost = 4000, requiredIds = {20162}},
		},
		[24] = {
			{id = 19850, cost = 5000, requiredIds = {19742}},
			{id = 10322, cost = 5000, requiredIds = {7328}},
			{id = 2878, cost = 5000},
			{id = 5599, cost = 5000, requiredIds = {1022}},
			{id = 5588, cost = 5000, requiredIds = {853}},
		},
		[26] = {
			{id = 19939, cost = 6000, requiredIds = {19750}},
			{id = 20289, cost = 6000, requiredIds = {20288}},
			{id = 1038, cost = 6000},
			{id = 10298, cost = 6000, requiredIds = {7294}},
		},
		[28] = {
			{id = 5614, cost = 9000, requiredIds = {879}},
			{id = 19876, cost = 9000},
		},
		[30] = {
			{id = 20116, cost = 11000, requiredIds = {26573}},
			{id = 1042, cost = 11000, requiredIds = {1026}},
			{id = 2800, cost = 11000, requiredIds = {633}},
			{id = 20165, cost = 11000},
			{id = 34769, cost = 10000, faction = "Horde"},
			{id = 10291, cost = 11000, requiredIds = {643}},
			{id = 19752, cost = 11000},
			{id = 20915, cost = 550, requiredIds = {20375}, requiredTalentId = 20375},
		},
		[32] = {
			{id = 19888, cost = 12000},
			{id = 19836, cost = 12000, requiredIds = {19835}},
			{id = 20306, cost = 12000, requiredIds = {20305}},
		},
		[34] = {
			{id = 19852, cost = 13000, requiredIds = {19850}},
			{id = 19940, cost = 13000, requiredIds = {19939}},
			{id = 20290, cost = 13000, requiredIds = {20289}},
			{id = 642, cost = 13000},
		},
		[36] = {
			{id = 5615, cost = 14000, requiredIds = {5614}},
			{id = 10324, cost = 14000, requiredIds = {10322}},
			{id = 19891, cost = 14000},
			{id = 10299, cost = 14000, requiredIds = {10298}},
		},
		[38] = {
			{id = 3472, cost = 16000, requiredIds = {1042}},
			{id = 20166, cost = 16000},
			{id = 5627, cost = 16000, requiredIds = {2878}},
			{id = 10278, cost = 16000, requiredIds = {5599}},
		},
		[40] = {
			{id = 19977, cost = 20000},
			{id = 20922, cost = 20000, requiredIds = {20116}},
			{id = 20347, cost = 20000, requiredIds = {20165}},
			{id = 20912, cost = 1000, requiredIds = {20911}, requiredTalentId = 20911},
			{id = 1032, cost = 20000, requiredIds = {10291}},
			{id = 5589, cost = 20000, requiredIds = {5588}},
			{id = 19895, cost = 20000, requiredIds = {19876}},
			{id = 20918, cost = 1000, requiredIds = {20915}, requiredTalentId = 20375},
		},
		[42] = {
			{id = 4987, cost = 21000},
			{id = 19941, cost = 21000, requiredIds = {19940}},
			{id = 20291, cost = 21000, requiredIds = {20290}},
			{id = 19837, cost = 21000, requiredIds = {19836}},
			{id = 20307, cost = 21000, requiredIds = {20306}},
		},
		[44] = {
			{id = 19853, cost = 22000, requiredIds = {19852}},
			{id = 10312, cost = 22000, requiredIds = {5615}},
			{id = 24275, cost = 22000},
			{id = 19897, cost = 22000, requiredIds = {19888}},
		},
		[46] = {
			{id = 10328, cost = 24000, requiredIds = {3472}},
			{id = 6940, cost = 24000},
			{id = 10300, cost = 24000, requiredIds = {10299}},
		},
		[48] = {
			{id = 20929, cost = 1300, requiredIds = {20473}, requiredTalentId = 20473},
			{id = 20772, cost = 26000, requiredIds = {10324}},
			{id = 20356, cost = 26000, requiredIds = {20166}},
			{id = 19899, cost = 26000, requiredIds = {19891}},
			{id = 31895, cost = 26000, requiredIds = {20164}},
		},
		[50] = {
			{id = 19978, cost = 28000, requiredIds = {19977}},
			{id = 20923, cost = 28000, requiredIds = {20922}},
			{id = 19942, cost = 28000, requiredIds = {19941}},
			{id = 2812, cost = 28000},
			{id = 10310, cost = 28000, requiredIds = {2800}},
			{id = 20348, cost = 28000, requiredIds = {20347}},
			{id = 20292, cost = 28000, requiredIds = {20291}},
			{id = 20913, cost = 1400, requiredIds = {20912}, requiredTalentId = 20911},
			{id = 10292, cost = 28000, requiredIds = {1032}},
			{id = 1020, cost = 28000, requiredIds = {642}},
			{id = 20927, cost = 1400, requiredIds = {20925}, requiredTalentId = 20925},
			{id = 20919, cost = 1400, requiredIds = {20918}, requiredTalentId = 20375},
		},
		[52] = {
			{id = 10313, cost = 34000, requiredIds = {10312}},
			{id = 24274, cost = 34000, requiredIds = {24275}},
			{id = 10326, cost = 34000, requiredIds = {5627}},
			{id = 19896, cost = 34000, requiredIds = {19895}},
			{id = 19838, cost = 34000, requiredIds = {19837}},
			{id = 25782, cost = 46000, requiredIds = {19838}},
			{id = 20308, cost = 34000, requiredIds = {20307}},
		},
		[54] = {
			{id = 19854, cost = 40000, requiredIds = {19853}},
			{id = 25894, cost = 46000, requiredIds = {19854}},
			{id = 10329, cost = 40000, requiredIds = {10328}},
			{id = 20729, cost = 40000, requiredIds = {6940}},
			{id = 10308, cost = 40000, requiredIds = {5589}},
		},
		[56] = {
			{id = 20930, cost = 2100, requiredIds = {20929}, requiredTalentId = 20473},
			{id = 19898, cost = 42000, requiredIds = {19897}},
			{id = 10301, cost = 42000, requiredIds = {10300}},
		},
		[58] = {
			{id = 19943, cost = 44000, requiredIds = {19942}},
			{id = 20293, cost = 44000, requiredIds = {20292}},
			{id = 20357, cost = 44000, requiredIds = {20356}},
		},
		[60] = {
			{id = 19979, cost = 46000, requiredIds = {19978}},
			{id = 25290, cost = 50000, requiredIds = {19854}},
			{id = 20924, cost = 46000, requiredIds = {20923}},
			{id = 10314, cost = 46000, requiredIds = {10313}},
			{id = 25890, cost = 46000, requiredIds = {19979}},
			{id = 25918, cost = 46000, requiredIds = {25290,25894}},
			{id = 24239, cost = 46000, requiredIds = {24274}},
			{id = 25292, cost = 46000, requiredIds = {10329}},
			{id = 10318, cost = 46000, requiredIds = {2812}},
			{id = 20773, cost = 46000, requiredIds = {20772}},
			{id = 20349, cost = 46000, requiredIds = {20348}},
			{id = 32699, cost = 2300, requiredIds = {31935}, requiredTalentId = 31935},
			{id = 20914, cost = 2300, requiredIds = {20913}, requiredTalentId = 20911},
			{id = 10293, cost = 46000, requiredIds = {10292}},
			{id = 19900, cost = 46000, requiredIds = {19899}},
			{id = 25898, cost = 2300, requiredIds = {20217}, requiredTalentId = 20217},
			{id = 25895, cost = 46000, requiredIds = {1038}},
			{id = 25899, cost = 2300, requiredIds = {20914}, requiredTalentId = 20911},
			{id = 20928, cost = 2300, requiredIds = {20927}, requiredTalentId = 20925},
			{id = 25291, cost = 50000, requiredIds = {19838}},
			{id = 25916, cost = 46000, requiredIds = {25291,25782}},
			{id = 20920, cost = 2300, requiredIds = {20919}, requiredTalentId = 20375},
		},
		[61] = {
			{id = 27158, cost = 50000, requiredIds = {20308}},
		},
		[62] = {
			{id = 27135, cost = 55000, requiredIds = {25292}},
			{id = 27147, cost = 55000, requiredIds = {20729}},
			{id = 32223, cost = 55000},
		},
		[63] = {
			{id = 27151, cost = 61000, requiredIds = {19896}},
		},
		[64] = {
			{id = 27174, cost = 3350, requiredIds = {20930}, requiredTalentId = 20473},
			{id = 31801, cost = 67000, faction = "Alliance"},
			{id = 31892, cost = 67000, faction = "Horde"},
		},
		[65] = {
			{id = 27142, cost = 75000, requiredIds = {25290}},
			{id = 27143, cost = 75000, requiredIds = {27142,25918}},
		},
		[66] = {
			{id = 27137, cost = 83000, requiredIds = {19943}},
			{id = 27155, cost = 83000, requiredIds = {20293}},
			{id = 33776, cost = 83000, requiredIds = {31785}},
			{id = 27150, cost = 83000, requiredIds = {10301}},
		},
		[67] = {
			{id = 27166, cost = 92000, requiredIds = {20357}},
		},
		[68] = {
			{id = 27138, cost = 100000, requiredIds = {10314}},
			{id = 27180, cost = 100000, requiredIds = {24239}},
			{id = 27152, cost = 100000, requiredIds = {19898}},
		},
		[69] = {
			{id = 27144, cost = 110000, requiredIds = {19979}},
			{id = 27145, cost = 110000, requiredIds = {27144,25890}},
			{id = 27139, cost = 110000, requiredIds = {10318}},
			{id = 27154, cost = 110000, requiredIds = {10310}},
			{id = 27160, cost = 110000, requiredIds = {20349}},
		},
		[70] = {
			{id = 27173, cost = 130000, requiredIds = {20924}},
			{id = 27136, cost = 130000, requiredIds = {27135}},
			{id = 33072, cost = 6500, requiredIds = {27174}, requiredTalentId = 20473},
			{id = 32700, cost = 2300, requiredIds = {32699}, requiredTalentId = 31935},
			{id = 27148, cost = 130000, requiredIds = {27147}},
			{id = 27168, cost = 2300, requiredIds = {20914}, requiredTalentId = 20911},
			{id = 27149, cost = 130000, requiredIds = {10293}},
			{id = 27153, cost = 130000, requiredIds = {19900}},
			{id = 27169, cost = 2300, requiredIds = {27168,25899}, requiredTalentId = 20911},
			{id = 27179, cost = 2300, requiredIds = {20928}, requiredTalentId = 20925},
			{id = 31884, cost = 130000},
			{id = 27140, cost = 50000, requiredIds = {25291}},
			{id = 27141, cost = 46000, requiredIds = {27140,25916}},
			{id = 27170, cost = 2300, requiredIds = {20920}, requiredTalentId = 20375},
		},
	},
	[2] = { 
		[1] = {
			{id = 465, cost = 10}, 
		},
		[4] = {
			{id = 19740, cost = 100}, 
			{id = 20271, cost = 100}, 
		},
		[6] = {
			{id = 498, cost = 100}, 
			{id = 639, cost = 100, requiredIds = {635}}, 
		},
		[8] = {
			{id = 853, cost = 100}, 
			{id = 3127, cost = 100}, 
			{id = 1152, cost = 100}, 
		},
		[10] = {
			{id = 10290, cost = 300, requiredIds = {465}}, 
			{id = 1022, cost = 300}, 
			{id = 633, cost = 300}, 
		},
		[12] = {
			{id = 19834, cost = 1000, requiredIds = {19740}}, 
			{id = 53408, cost = 1000}, 
		},
		[14] = {
			{id = 19742, cost = 2000}, 
			{id = 647, cost = 2000, requiredIds = {639}}, 
			{id = 31789, cost = 4000}, 
		},
		[16] = {
			{id = 62124, cost = 3000}, 
			{id = 7294, cost = 3000}, 
			{id = 25780, cost = 3000}, 
		},
		[18] = {
			{id = 1044, cost = 3500}, 
		},
		[20] = {
			{id = 20217, cost = 4000}, 
			{id = 26573, cost = 4000}, 
			{id = 643, cost = 4000, requiredIds = {10290}}, 
			{id = 879, cost = 4000}, 
			{id = 19750, cost = 4000}, 
			{id = 5502, cost = 4000}, 
			{id = 13819, cost = 3500, faction = "Alliance"}, 
			{id = 34769, cost = 3500, faction = "Horde"}, 
		},
		[22] = {
			{id = 19835, cost = 4000, requiredIds = {19834}}, 
			{id = 19746, cost = 4000}, 
			{id = 1026, cost = 4000, requiredIds = {647}}, 
			{id = 20164, cost = 4000}, 
		},
		[24] = {
			{id = 19850, cost = 5000, requiredIds = {19742}}, 
			{id = 5588, cost = 5000, requiredIds = {853}}, 
			{id = 5599, cost = 5000, requiredIds = {1022}}, 
			{id = 10322, cost = 5000, requiredIds = {7328}}, 
			{id = 10326, cost = 5000}, 
		},
		[26] = {
			{id = 19939, cost = 6000, requiredIds = {19750}}, 
			{id = 1038, cost = 6000}, 
			{id = 10298, cost = 6000, requiredIds = {7294}}, 
		},
		[28] = {
			{id = 5614, cost = 9000, requiredIds = {879}}, 
			{id = 53407, cost = 9000}, 
			{id = 19876, cost = 9000}, 
		},
		[30] = {
			{id = 20116, cost = 11000, requiredIds = {26573}}, 
			{id = 10291, cost = 11000, requiredIds = {643}}, 
			{id = 19752, cost = 11000}, 
			{id = 1042, cost = 11000, requiredIds = {1026}}, 
			{id = 2800, cost = 11000, requiredIds = {633}}, 
			{id = 20165, cost = 11000}, 
		},
		[32] = {
			{id = 19836, cost = 12000, requiredIds = {19835}}, 
			{id = 19888, cost = 12000}, 
		},
		[34] = {
			{id = 19852, cost = 13000, requiredIds = {19850}}, 
			{id = 642, cost = 13000}, 
			{id = 19940, cost = 13000, requiredIds = {19939}}, 
		},
		[36] = {
			{id = 5615, cost = 14000, requiredIds = {5614}}, 
			{id = 19891, cost = 14000}, 
			{id = 10324, cost = 14000, requiredIds = {10322}}, 
			{id = 10299, cost = 14000, requiredIds = {10298}}, 
		},
		[38] = {
			{id = 10278, cost = 16000, requiredIds = {5599}}, 
			{id = 3472, cost = 16000, requiredIds = {1042}}, 
			{id = 20166, cost = 16000}, 
		},
		[40] = {
			{id = 20922, cost = 20000, requiredIds = {20116}}, 
			{id = 1032, cost = 20000, requiredIds = {10291}}, 
			{id = 5589, cost = 20000, requiredIds = {5588}}, 
			{id = 19895, cost = 20000, requiredIds = {19876}}, 
			{id = 23214, cost = 3500, faction = "Alliance"}, 
			{id = 34767, cost = 3500, faction = "Horde"}, 
		},
		[42] = {
			{id = 19837, cost = 21000, requiredIds = {19836}}, 
			{id = 4987, cost = 21000}, 
			{id = 19941, cost = 21000, requiredIds = {19940}}, 
		},
		[44] = {
			{id = 19853, cost = 22000, requiredIds = {19852}}, 
			{id = 10312, cost = 22000, requiredIds = {5615}}, 
			{id = 19897, cost = 22000, requiredIds = {19888}}, 
			{id = 24275, cost = 22000}, 
		},
		[46] = {
			{id = 6940, cost = 24000}, 
			{id = 10328, cost = 24000, requiredIds = {3472}}, 
			{id = 10300, cost = 24000, requiredIds = {10299}}, 
		},
		[48] = {
			{id = 19899, cost = 26000, requiredIds = {19891}}, 
			{id = 20929, cost = 1300, requiredIds = {20473}, requiredTalentId = 20473}, 
			{id = 20772, cost = 26000, requiredIds = {10324}}, 
		},
		[50] = {
			{id = 20923, cost = 28000, requiredIds = {20922}}, 
			{id = 10292, cost = 28000, requiredIds = {1032}}, 
			{id = 19942, cost = 28000, requiredIds = {19941}}, 
			{id = 20927, cost = 1400, requiredIds = {20925}, requiredTalentId = 20925}, 
			{id = 2812, cost = 28000}, 
			{id = 10310, cost = 28000, requiredIds = {2800}}, 
		},
		[52] = {
			{id = 19838, cost = 34000, requiredIds = {19837}}, 
			{id = 10313, cost = 34000, requiredIds = {10312}}, 
			{id = 25782, cost = 46000, requiredIds = {19838}}, 
			{id = 24274, cost = 34000, requiredIds = {24275}}, 
			{id = 19896, cost = 34000, requiredIds = {19895}}, 
		},
		[54] = {
			{id = 19854, cost = 40000, requiredIds = {19853}}, 
			{id = 25894, cost = 46000, requiredIds = {19854}}, 
			{id = 10308, cost = 40000, requiredIds = {5589}}, 
			{id = 10329, cost = 40000, requiredIds = {10328}}, 
		},
		[56] = {
			{id = 19898, cost = 42000, requiredIds = {19897}}, 
			{id = 20930, cost = 2100, requiredIds = {20929}, requiredTalentId = 20473}, 
			{id = 10301, cost = 42000, requiredIds = {10300}}, 
		},
		[58] = {
			{id = 19943, cost = 44000,requiredIds = {19942}}, 
		},
		[60] = {
			{id = 32699, cost = 2300, requiredIds = {31935}, requiredTalentId = 31935}, 
			{id = 25291, cost = 50000, requiredIds = {19838}}, 
			{id = 25290, cost = 50000, requiredIds = {19854}}, 
			{id = 20924, cost = 46000, requiredIds = {20923}}, 
			{id = 10293, cost = 46000, requiredIds = {10292}}, 
			{id = 10314, cost = 46000, requiredIds = {10313}}, 
			{id = 19900, cost = 46000, requiredIds = {19899}}, 
			{id = 25898, cost = 2300, requiredIds = {20217}}, 
			{id = 25916, cost = 46000, requiredIds = {25291,25782}}, 
			{id = 25899, cost = 2300, requiredIds = {20911}, requiredTalentId = 20911}, 
			{id = 25918, cost = 46000, requiredIds = {25290,25894}}, 
			{id = 24239, cost = 46000, requiredIds = {24274}}, 
			{id = 25292, cost = 46000, requiredIds = {10329}}, 
			{id = 20928, cost = 2300, requiredIds = {20927}, requiredTalentId = 20925}, 
			{id = 10318, cost = 46000, requiredIds = {2812}}, 
			{id = 20773, cost = 46000, requiredIds = {20772}}, 
		},
		[62] = {
			{id = 32223, cost = 55000}, 
			{id = 27135, cost = 55000, requiredIds = {25292}}, 
		},
		[63] = {
			{id = 27151, cost = 61000, requiredIds = {19896}}, 
		},
		[64] = {
			{id = 27174, cost = 3348, requiredIds = {20930}, requiredTalentId = 20473}, 
			{id = 31801, cost = 67000, faction = "Alliance"}, 
		},
		[65] = {
			{id = 27142, cost = 75000, requiredIds = {25290}}, 
			{id = 27143, cost = 75000, requiredIds = {27142,25918}}, 
		},
		[66] = {
			{id = 27137, cost = 83000, requiredIds = {19943}}, 
			{id = 27150, cost = 83000, requiredIds = {10301}}, 
			{id = 53736, cost = 100000, faction = "Horde"}, 
		},
		[68] = {
			{id = 27138, cost = 100000, requiredIds = {10314}}, 
			{id = 27152, cost = 100000, requiredIds = {19898}}, 
			{id = 27180, cost = 100000, requiredIds = {24239}}, 
		},
		[69] = {
			{id = 27139, cost = 110000, requiredIds = {10318}}, 
			{id = 27154, cost = 110000, requiredIds = {10310}}, 
		},
		[70] = {
			{id = 32700, cost = 5000, requiredIds = {32699}, requiredTalentId = 31935}, 
			{id = 31884, cost = 130000}, 
			{id = 27140, cost = 200000, requiredIds = {25291}}, 
			{id = 27173, cost = 130000, requiredIds = {20924}}, 
			{id = 27149, cost = 130000, requiredIds = {10293}}, 
			{id = 27153, cost = 130000, requiredIds = {19900}}, 
			{id = 27141, cost = 100000, requiredIds = {27140,25916}}, 
			{id = 27136, cost = 130000, requiredIds = {27135}}, 
			{id = 27179, cost = 6500, requiredIds = {20928}, requiredTalentId = 20925}, 
			{id = 33072, cost = 6500, requiredIds = {27174}, requiredTalentId = 20473}, 
		},
		[71] = {
			{id = 48935, cost = 200000, requiredIds = {27142}}, 
			{id = 54428, cost = 100000}, 
			{id = 48937, cost = 200000, requiredIds = {48935,27143}}, 
		},
		[72] = {
			{id = 48816, cost = 200000, requiredIds = {27139}}, 
			{id = 48949, cost = 200000, requiredIds = {20773}}, 
		},
		[73] = {
			{id = 48931, cost = 200000, requiredIds = {27140}}, 
			{id = 48800, cost = 200000, requiredIds = {27138}}, 
			{id = 48933, cost = 200000, requiredIds = {48931,27141}}, 
		},
		[74] = {
			{id = 48941, cost = 200000, requiredIds = {27149}}, 
			{id = 48784, cost = 200000, requiredIds = {27137}}, 
			{id = 48805, cost = 200000, requiredIds = {27180}}, 
		},
		[75] = {
			{id = 48826, cost = 10000, requiredIds = {32700}, requiredTalentId = 31935}, 
			{id = 48818, cost = 200000, requiredIds = {27173}}, 
			{id = 48781, cost = 200000, requiredIds = {27136}}, 
			{id = 48951, cost = 10000, requiredIds = {27179}, requiredTalentId = 20925}, 
			{id = 48824, cost = 10000, requiredIds = {33072}, requiredTalentId = 20473}, 
			{id = 53600, cost = 200000}, 
		},
		[76] = {
			{id = 54043, cost = 200000, requiredIds = {27150}}, 
			{id = 48943, cost = 200000, requiredIds = {27151}}, 
		},
		[77] = {
			{id = 48936, cost = 200000, requiredIds = {48935}}, 
			{id = 48945, cost = 200000, requiredIds = {27152}}, 
			{id = 48938, cost = 200000, requiredIds = {48936,48937}}, 
		},
		[78] = {
			{id = 48947, cost = 200000, requiredIds = {27153}}, 
			{id = 48817, cost = 200000, requiredIds = {48816}}, 
			{id = 48788, cost = 200000, requiredIds = {27154}}, 
		},
		[79] = {
			{id = 48932, cost = 200000, requiredIds = {48931}}, 
			{id = 48942, cost = 200000, requiredIds = {48941}}, 
			{id = 48801, cost = 200000, requiredIds = {48800}}, 
			{id = 48785, cost = 200000, requiredIds = {48784}}, 
			{id = 48934, cost = 200000, requiredIds = {48932, 48933}}, 
			{id = 48950, cost = 200000, requiredIds = {48949}}, 
		},
		[80] = {
			{id = 48827, cost = 10000, requiredIds = {48826}, requiredTalentId = 31935}, 
			{id = 48819, cost = 200000, requiredIds = {48818}}, 
			{id = 48806, cost = 200000, requiredIds = {48805}}, 
			{id = 48782, cost = 200000, requiredIds = {48781}}, 
			{id = 48952, cost = 10000, requiredIds = {48951}, requiredTalentId = 20925}, 
			{id = 48825, cost = 10000, requiredIds = {48824}, requiredTalentId = 20473}, 
			{id = 53601, cost = 100000}, 
			{id = 61411, cost = 200000, requiredIds = {53600}}, 
		},
	},
}

FatCooldowns.RogueSpells = {
	[0] = { 
		[1] = {
			{id = 1784, cost = 10}
		},
		[4] = {
			{id = 53, cost = 100},
			{id = 921, cost = 100}
		},
		[6] = {
			{id = 1776, cost = 100},
			{id = 1757, cost = 100, requiredIds = {1752}}
		},
		[8] = {
			{id = 5277, cost = 200},
			{id = 6760, cost = 200, requiredIds = {2098}}
		},
		[10] = {
			{id = 674, cost = 300},
			{id = 6770, cost = 300},
			{id = 5171, cost = 300},
			{id = 2983, cost = 300}
		},
		[12] = {
			{id = 2589, cost = 800, requiredIds = {53}},
			{id = 1766, cost = 800},
			{id = 3127, cost = 800}
		},
		[14] = {
			{id = 8647, cost = 1200},
			{id = 703, cost = 1200},
			{id = 1758, cost = 1200, requiredIds = {1757}}
		},
		[16] = {
			{id = 6761, cost = 1800, requiredIds = {6760}},
			{id = 1966, cost = 1800},
			{id = 1804, cost = 1800}
		},
		[18] = {
			{id = 8676, cost = 2900},
			{id = 1777, cost = 2900, requiredIds = {1776}}
		},
		[20] = {
			{id = 2590, cost = 3000, requiredIds = {2589}},
			{id = 3420, cost = 3000, skills = {{skill = 40, level = 1}}},
			{id = 1943, cost = 3000},
			{id = 1785, cost = 3000, requiredIds = {1784}}
		},
		[22] = {
			{id = 1725, cost = 4000},
			{id = 8631, cost = 4000, requiredIds = {703}},
			{id = 1759, cost = 4000, requiredIds = {1758}},
			{id = 1856, cost = 4000, requiredIds = {1784}}
		},
		[24] = {
			{id = 2836, cost = 5000},
			{id = 6762, cost = 5000, requiredIds = {6761}},
			{id = 5763, cost = 5000, skills = {{skill = 40, level = 100}}}
		},
		[26] = {
			{id = 8724, cost = 6000, requiredIds = {8676}},
			{id = 1833, cost = 6000},
			{id = 8649, cost = 6000, requiredIds = {8647}},
			{id = 1767, cost = 6000, requiredIds = {1766}}
		},
		[28] = {
			{id = 2591, cost = 8000, requiredIds = {2590}},
			{id = 6768, cost = 8000, requiredIds = {1966}},
			{id = 8687, cost = 8000, skills = {{skill = 40, level = 120}}},
			{id = 8639, cost = 8000, requiredIds = {1943}},
			{id = 2070, cost = 8000, requiredIds = {6770}}
		},
		[30] = {
			{id = 2835, cost = 10000, skills = {{skill = 40, level = 130}}},
			{id = 1842, cost = 10000, requiredIds = {2836}},
			{id = 8632, cost = 10000, requiredIds = {8631}},
			{id = 408, cost = 10000},
			{id = 1760, cost = 10000, requiredIds = {1759}}
		},
		[32] = {
			{id = 8623, cost = 12000, requiredIds = {6762}},
			{id = 8629, cost = 12000, requiredIds = {1777}},
			{id = 13220, cost = 12000, skills = {{skill = 40, level = 140}}}
		},
		[34] = {
			{id = 8725, cost = 14000, requiredIds = {8724}},
			{id = 2094, cost = 14000, skills = {{skill = 40, level = 1}}},
			{id = 6510, cost = 14000, skills = {{skill = 40, level = 150}}},
			{id = 8696, cost = 14000, requiredIds = {2983}}
		},
		[36] = {
			{id = 8721, cost = 16000, requiredIds = {2591}},
			{id = 8650, cost = 16000, requiredIds = {8649}},
			{id = 8691, cost = 16000, skills = {{skill = 40, level = 160}}},
			{id = 8640, cost = 16000, requiredIds = {8639}}
		},
		[38] = {
			{id = 2837, cost = 18000, skills = {{skill = 40, level = 170}}},
			{id = 8633, cost = 18000, requiredIds = {8632}},
			{id = 8694, cost = 18000, skills = {{skill = 40, level = 170}}},
			{id = 8621, cost = 18000, requiredIds = {1760}}
		},
		[40] = {
			{id = 8624, cost = 20000, requiredIds = {8623}},
			{id = 8637, cost = 20000, requiredIds = {6768}},
			{id = 1860, cost = 20000},
			{id = 1786, cost = 20000, requiredIds = {1785}},
			{id = 13228, cost = 20000, skills = {{skill = 40, level = 180}}}
		},
		[42] = {
			{id = 11267, cost = 27000, requiredIds = {8725}},
			{id = 1768, cost = 27000, requiredIds = {1767}},
			{id = 6774, cost = 27000, requiredIds = {5171}},
			{id = 1857, cost = 27000, requiredIds = {1856}}
		},
		[44] = {
			{id = 11279, cost = 29000, requiredIds = {8721}},
			{id = 11341, cost = 29000, skills = {{skill = 40, level = 200}}},
			{id = 11273, cost = 29000, requiredIds = {8640}}
		},
		[46] = {
			{id = 11357, cost = 31000, skills = {{skill = 40, level = 210}}},
			{id = 11197, cost = 31000, requiredIds = {8650}},
			{id = 11289, cost = 31000, requiredIds = {8633}},
			{id = 11285, cost = 31000, requiredIds = {8629}},
			{id = 17347, cost = 7750, requiredIds = {16511}, requiredTalentId = 16511},
			{id = 11293, cost = 31000, requiredIds = {8621}}
		},
		[48] = {
			{id = 11299, cost = 33000, requiredIds = {8624}},
			{id = 11297, cost = 33000, requiredIds = {2070}},
			{id = 13229, cost = 33000, skills = {{skill = 40, level = 220}}}
		},
		[50] = {
			{id = 11268, cost = 35000, requiredIds = {11267}},
			{id = 3421, cost = 35000, skills = {{skill = 40, level = 230}}},
			{id = 8643, cost = 35000, requiredIds = {408}}
		},
		[52] = {
			{id = 11280, cost = 46000, requiredIds = {11279}},
			{id = 11303, cost = 46000, requiredIds = {8637}},
			{id = 11342, cost = 46000, skills = {{skill = 40, level = 240}}},
			{id = 11400, cost = 46000, skills = {{skill = 40, level = 240}}},
			{id = 11274, cost = 46000, requiredIds = {11273}}
		},
		[54] = {
			{id = 11358, cost = 48000, skills = {{skill = 40, level = 250}}},
			{id = 11290, cost = 48000, requiredIds = {11289}},
			{id = 11294, cost = 48000, requiredIds = {11293}}
		},
		[56] = {
			{id = 11300, cost = 50000, requiredIds = {11299}},
			{id = 11198, cost = 50000, requiredIds = {11197}},
			{id = 13230, cost = 50000, skills = {{skill = 40, level = 260}}}
		},
		[58] = {
			{id = 11269, cost = 52000, requiredIds = {11268}},
			{id = 17348, cost = 13000, requiredIds = {17347}, requiredTalentId = 16511},
			{id = 1769, cost = 52000, requiredIds = {1768}},
			{id = 11305, cost = 52000, requiredIds = {8696}}
		},
		[60] = {
			{id = 11281, cost = 54000, requiredIds = {11280}},
			{id = 11286, cost = 54000, requiredIds = {11285}},
			{id = 11343, cost = 54000, skills = {{skill = 40, level = 280}}},
			{id = 11275, cost = 54000, requiredIds = {11274}},
			{id = 1787, cost = 54000, requiredIds = {1786}}
		},
	},
	[1] = { 
		[1] = {
			{id = 1784, cost = 10},
		},
		[4] = {
			{id = 53, cost = 100},
			{id = 921, cost = 100},
		},
		[6] = {
			{id = 1776, cost = 100},
			{id = 1757, cost = 100},
		},
		[8] = {
			{id = 6760, cost = 200, requiredIds = {2098}},
			{id = 5277, cost = 200},
		},
		[10] = {
			{id = 5171, cost = 300},
			{id = 2983, cost = 300},
			{id = 674, cost = 300},
			{id = 6770, cost = 300},
		},
		[12] = {
			{id = 2589, cost = 800, requiredIds = {53}},
			{id = 1766, cost = 800},
			{id = 3127, cost = 800},
		},
		[14] = {
			{id = 8647, cost = 1200},
			{id = 703, cost = 1200},
			{id = 1758, cost = 1200, requiredIds = {1757}},
		},
		[16] = {
			{id = 6761, cost = 1800, requiredIds = {6760}},
			{id = 1966, cost = 1800},
			{id = 1804, cost = 1800},
		},
		[18] = {
			{id = 8676, cost = 2900},
			{id = 1777, cost = 2900, requiredIds = {1776}},
		},
		[20] = {
			{id = 1943, cost = 3000},
			{id = 2590, cost = 3000, requiredIds = {2589}},
			{id = 3420, cost = 3000},
			{id = 1785, cost = 3000, requiredIds = {1784}},
		},
		[22] = {
			{id = 8631, cost = 4000, requiredIds = {703}},
			{id = 1759, cost = 4000, requiredIds = {1758}},
			{id = 1725, cost = 4000},
			{id = 1856, cost = 4000, requiredIds = {1784}},
		},
		[24] = {
			{id = 6762, cost = 5000, requiredIds = {6761}},
			{id = 5763, cost = 5000},
			{id = 2836, cost = 5000},
		},
		[26] = {
			{id = 8724, cost = 6000, requiredIds = {8676}},
			{id = 1833, cost = 6000},
			{id = 8649, cost = 6000, requiredIds = {8647}},
			{id = 1767, cost = 6000, requiredIds = {1766}},
		},
		[28] = {
			{id = 8639, cost = 8000, requiredIds = {1943}},
			{id = 2591, cost = 8000, requiredIds = {2590}},
			{id = 6768, cost = 8000, requiredIds = {1966}},
			{id = 8687, cost = 8000},
			{id = 2070, cost = 8000, requiredIds = {6770}},
		},
		[30] = {
			{id = 8632, cost = 10000, requiredIds = {8631}},
			{id = 408, cost = 10000},
			{id = 1760, cost = 10000, requiredIds = {1759}},
			{id = 2835, cost = 10000},
			{id = 1842, cost = 10000, requiredIds = {2836}},
		},
		[32] = {
			{id = 8623, cost = 12000, requiredIds = {6762}},
			{id = 8629, cost = 12000, requiredIds = {1777}},
			{id = 13220, cost = 12000},
		},
		[34] = {
			{id = 8725, cost = 14000, requiredIds = {8724}},
			{id = 8696, cost = 14000, requiredIds = {2983}},
			{id = 2094, cost = 14000},
		},
		[36] = {
			{id = 8650, cost = 16000, requiredIds = {8649}},
			{id = 8640, cost = 16000, requiredIds = {8639}},
			{id = 8721, cost = 16000, requiredIds = {2591}},
			{id = 8691, cost = 16000},
		},
		[38] = {
			{id = 8633, cost = 18000, requiredIds = {8632}},
			{id = 8621, cost = 18000, requiredIds = {1760}},
			{id = 2837, cost = 18000},
			{id = 8694, cost = 18000},
		},
		[40] = {
			{id = 8624, cost = 20000, requiredIds = {8623}},
			{id = 8637, cost = 20000, requiredIds = {6768}},
			{id = 13228, cost = 20000},
			{id = 1860, cost = 20000},
			{id = 1786, cost = 20000, requiredIds = {1785}},
		},
		[42] = {
			{id = 11267, cost = 27000, requiredIds = {8725}},
			{id = 6774, cost = 27000, requiredIds = {5171}},
			{id = 1768, cost = 27000, requiredIds = {1767}},
			{id = 1857, cost = 27000, requiredIds = {1856}},
		},
		[44] = {
			{id = 11273, cost = 29000, requiredIds = {8640}},
			{id = 11279, cost = 29000, requiredIds = {8721}},
			{id = 11341, cost = 29000},
		},
		[46] = {
			{id = 11197, cost = 31000, requiredIds = {8650}},
			{id = 11289, cost = 31000, requiredIds = {8633}},
			{id = 11285, cost = 31000, requiredIds = {8629}},
			{id = 11293, cost = 31000, requiredIds = {8621}},
			{id = 11357, cost = 31000},
			{id = 17347, cost = 384, requiredIds = {16511}, requiredTalentId = 16511},
		},
		[48] = {
			{id = 11299, cost = 33000, requiredIds = {8624}},
			{id = 13229, cost = 33000},
			{id = 11297, cost = 33000, requiredIds = {2070}},
		},
		[50] = {
			{id = 11268, cost = 35000, requiredIds = {11267}},
			{id = 8643, cost = 35000, requiredIds = {408}},
			{id = 34411, cost = 5500, requiredIds = {1329}, requiredTalentId = 1329},
			{id = 26669, cost = 35000, requiredIds = {5277}},
			{id = 3421, cost = 35000},
		},
		[52] = {
			{id = 11274, cost = 46000, requiredIds = {11273}},
			{id = 11280, cost = 46000, requiredIds = {11279}},
			{id = 11303, cost = 46000, requiredIds = {8637}},
			{id = 11342, cost = 46000},
			{id = 11400, cost = 46000},
		},
		[54] = {
			{id = 11290, cost = 48000, requiredIds = {11289}},
			{id = 11294, cost = 48000, requiredIds = {11293}},
			{id = 11358, cost = 48000},
		},
		[56] = {
			{id = 11300, cost = 50000, requiredIds = {11299}},
			{id = 11198, cost = 50000, requiredIds = {11197}},
			{id = 13230, cost = 50000},
		},
		[58] = {
			{id = 11269, cost = 52000, requiredIds = {11268}},
			{id = 1769, cost = 52000, requiredIds = {1768}},
			{id = 11305, cost = 52000, requiredIds = {8696}},
			{id = 17348, cost = 650, requiredIds = {17347}, requiredTalentId = 16511},
		},
		[60] = {
			{id = 31016, cost = 65000, requiredIds = {11300}},
			{id = 34412, cost = 6500, requiredIds = {34411}, requiredTalentId = 1329},
			{id = 11275, cost = 54000, requiredIds = {11274}},
			{id = 11281, cost = 54000, requiredIds = {11280}},
			{id = 25300, cost = 54000, requiredIds = {11281}},
			{id = 25302, cost = 50000, requiredIds = {11303}},
			{id = 11286, cost = 54000, requiredIds = {11285}},
			{id = 25347, cost = 54000},
			{id = 11343, cost = 54000},
			{id = 1787, cost = 54000, requiredIds = {1786}},
		},
		[61] = {
			{id = 26839, cost = 50000, requiredIds = {11290}},
		},
		[62] = {
			{id = 32645, cost = 59000},
			{id = 26861, cost = 50000, requiredIds = {11294}},
			{id = 26969, cost = 65000},
			{id = 26889, cost = 59000, requiredIds = {1857}},
		},
		[64] = {
			{id = 26679, cost = 72000},
			{id = 26865, cost = 140000, requiredIds = {31016}},
			{id = 27448, cost = 72000, requiredIds = {25302}},
			{id = 27283, cost = 80000},
		},
		[66] = {
			{id = 27441, cost = 80000, requiredIds = {11269}},
			{id = 26866, cost = 99000, requiredIds = {11198}},
			{id = 31224, cost = 89000},
		},
		[67] = {
			{id = 38764, cost = 99000, requiredIds = {11286}},
		},
		[68] = {
			{id = 26867, cost = 120000, requiredIds = {11275}},
			{id = 26863, cost = 110000, requiredIds = {25300}},
			{id = 26892, cost = 110000},
			{id = 26786, cost = 110000},
		},
		[69] = {
			{id = 32684, cost = 120000, requiredIds = {32645}},
			{id = 38768, cost = 120000, requiredIds = {1769}},
		},
		[70] = {
			{id = 26884, cost = 140000, requiredIds = {26839}},
			{id = 34413, cost = 7500, requiredIds = {34412}, requiredTalentId = 1329},
			{id = 5938, cost = 140000},
			{id = 26862, cost = 140000, requiredIds = {26861}},
			{id = 27282, cost = 140000},
			{id = 26864, cost = 2700, requiredIds = {17348}, requiredTalentId = 16511},
		},
	},
	[2] = { 
		[1] = {
			{id = 1784, cost = 10}, 
		},
		[4] = {
			{id = 53, cost = 100}, 
			{id = 921, cost = 100}, 
		},
		[6] = {
			{id = 1776, cost = 100}, 
			{id = 1757, cost = 100, requiredIds = {1752}}, 
		},
		[8] = {
			{id = 5277, cost = 200}, 
			{id = 6760, cost = 200, requiredIds = {2098}}, 
		},
		[10] = {
			{id = 6770, cost = 300}, 
			{id = 5171, cost = 300}, 
			{id = 2983, cost = 300}, 
		},
		[12] = {
			{id = 2589, cost = 800, requiredIds = {53}}, 
			{id = 1766, cost = 800}, 
			{id = 3127, cost = 800}, 
		},
		[14] = {
			{id = 8647, cost = 1200}, 
			{id = 703, cost = 1200}, 
			{id = 1758, cost = 1200, requiredIds = {1757}}, 
		},
		[16] = {
			{id = 6761, cost = 1800, requiredIds = {6760}}, 
			{id = 1966, cost = 1800}, 
			{id = 1804, cost = 1800}, 
		},
		[18] = {
			{id = 8676, cost = 2900}, 
		},
		[20] = {
			{id = 2590, cost = 3000, requiredIds = {2589}}, 
			{id = 51722, cost = 3000}, 
			{id = 1943, cost = 3000}, 
		},
		[22] = {
			{id = 1725, cost = 4000}, 
			{id = 8631, cost = 4000, requiredIds = {703}}, 
			{id = 1759, cost = 4000, requiredIds = {1758}}, 
			{id = 1856, cost = 4000, requiredIds = {1784}}, 
		},
		[24] = {
			{id = 2836, cost = 5000}, 
			{id = 6762, cost = 5000, requiredIds = {6761}}, 
		},
		[26] = {
			{id = 8724, cost = 6000, requiredIds = {8676}}, 
			{id = 1833, cost = 6000}, 
		},
		[28] = {
			{id = 2591, cost = 8000, requiredIds = {2590}}, 
			{id = 6768, cost = 8000, requiredIds = {1966}}, 
			{id = 8639, cost = 8000, requiredIds = {1943}}, 
			{id = 2070, cost = 8000, requiredIds = {6770}}, 
		},
		[30] = {
			{id = 1842, cost = 10000, requiredIds = {2836}}, 
			{id = 8632, cost = 10000, requiredIds = {8631}}, 
			{id = 408, cost = 10000}, 
			{id = 1760, cost = 10000, requiredIds = {1759}}, 
		},
		[32] = {
			{id = 8623, cost = 12000, requiredIds = {6762}}, 
		},
		[34] = {
			{id = 8725, cost = 14000, requiredIds = {8724}}, 
			{id = 2094, cost = 14000}, 
			{id = 8696, cost = 14000, requiredIds = {2983}}, 
		},
		[36] = {
			{id = 8721, cost = 16000, requiredIds = {2591}}, 
			{id = 8640, cost = 16000, requiredIds = {8639}}, 
		},
		[38] = {
			{id = 8633, cost = 18000, requiredIds = {8632}}, 
			{id = 8621, cost = 18000, requiredIds = {1760}}, 
		},
		[40] = {
			{id = 8624, cost = 20000, requiredIds = {8623}}, 
			{id = 8637, cost = 20000, requiredIds = {6768}}, 
			{id = 1860, cost = 20000}, 
		},
		[42] = {
			{id = 11267, cost = 27000, requiredIds = {8725}}, 
			{id = 6774, cost = 27000, requiredIds = {5171}}, 
			{id = 1857, cost = 27000, requiredIds = {1856}}, 
		},
		[44] = {
			{id = 11279, cost = 29000, requiredIds = {8721}}, 
			{id = 11273, cost = 29000, requiredIds = {8640}}, 
		},
		[46] = {
			{id = 11289, cost = 31000, requiredIds = {8633}}, 
			{id = 17347, cost = 384, requiredIds = {16511}, requiredTalentId = 16511}, 
			{id = 11293, cost = 31000, requiredIds = {8621}}, 
		},
		[48] = {
			{id = 11299, cost = 33000, requiredIds = {8624}}, 
			{id = 11297, cost = 33000, requiredIds = {2070}}, 
		},
		[50] = {
			{id = 11268, cost = 35000, requiredIds = {11267}}, 
			{id = 26669, cost = 35000, requiredIds = {5277}}, 
			{id = 8643, cost = 35000, requiredIds = {408}}, 
			{id = 34411, cost = 5500, requiredIds = {1329}, requiredTalentId = 1329}, 
		},
		[52] = {
			{id = 11280, cost = 46000, requiredIds = {11279}}, 
			{id = 11303, cost = 46000, requiredIds = {8637}}, 
			{id = 11274, cost = 46000, requiredIds = {11273}}, 
		},
		[54] = {
			{id = 11290, cost = 48000, requiredIds = {11289}}, 
			{id = 11294, cost = 48000, requiredIds = {11293}}, 
		},
		[56] = {
			{id = 11300, cost = 50000, requiredIds = {11299}}, 
		},
		[58] = {
			{id = 11269, cost = 52000, requiredIds = {11268}}, 
			{id = 17348, cost = 650, requiredIds = {17347}, requiredTalentId = 16511}, 
			{id = 11305, cost = 52000, requiredIds = {8696}}, 
		},
		[60] = {
			{id = 11281, cost = 54000, requiredIds = {11280}}, 
			{id = 25300, cost = 72000, requiredIds = {11281}}, 
			{id = 31016, cost = 65000, requiredIds = {11300}}, 
			{id = 25302, cost = 50000, requiredIds = {11303}}, 
			{id = 34412, cost = 6500, requiredIds = {34411}, requiredTalentId = 1329}, 
			{id = 11275, cost = 54000, requiredIds = {11274}}, 
		},
		[61] = {
			{id = 26839, cost = 50000, requiredIds = {11290}}, 
		},
		[62] = {
			{id = 32645, cost = 59000}, 
			{id = 26861, cost = 50000, requiredIds = {11294}}, 
			{id = 26889, cost = 59000, requiredIds = {1857}}, 
		},
		[64] = {
			{id = 26679, cost = 72000}, 
			{id = 26865, cost = 140000, requiredIds = {31016}}, 
			{id = 27448, cost = 72000, requiredIds = {25302}}, 
		},
		[66] = {
			{id = 27441, cost = 80000, requiredIds = {11269}}, 
			{id = 31224, cost = 89000}, 
		},
		[68] = {
			{id = 26863, cost = 110000, requiredIds = {25300}}, 
			{id = 26867, cost = 120000, requiredIds = {11275}}, 
		},
		[69] = {
			{id = 32684, cost = 100000, requiredIds = {32645}}, 
		},
		[70] = {
			{id = 48689, cost = 140000, requiredIds = {27441}}, 
			{id = 48673, cost = 100000, requiredIds = {26679}}, 
			{id = 26884, cost = 100000, requiredIds = {26839}}, 
			{id = 26864, cost = 2700, requiredIds = {17348}, requiredTalentId = 16511}, 
			{id = 34413, cost = 7500, requiredIds = {34412}, requiredTalentId = 1329}, 
			{id = 5938, cost = 100000}, 
			{id = 26862, cost = 100000, requiredIds = {26861}}, 
		},
		[71] = {
			{id = 51724, cost = 300000, requiredIds = {11297}}, 
		},
		[72] = {
			{id = 48658, cost = 300000, requiredIds = {27448}}, 
		},
		[73] = {
			{id = 48667, cost = 300000, requiredIds = {26865}}, 
		},
		[74] = {
			{id = 48656, cost = 300000, requiredIds = {26863}}, 
			{id = 57992, cost = 300000, requiredIds = {32684}}, 
			{id = 48671, cost = 300000, requiredIds = {26867}}, 
		},
		[75] = {
			{id = 48690, cost = 300000, requiredIds = {48689}}, 
			{id = 48675, cost = 300000, requiredIds = {26884}}, 
			{id = 48663, cost = 15000, requiredIds = {34413}, requiredTalentId = 1329}, 
			{id = 57934, cost = 300000}, 
		},
		[76] = {
			{id = 48674, cost = 300000, requiredIds = {48673}}, 
			{id = 48637, cost = 300000, requiredIds = {26862}}, 
		},
		[78] = {
			{id = 48659, cost = 300000, requiredIds = {48658}}, 
		},
		[79] = {
			{id = 48668, cost = 300000, requiredIds = {48667}}, 
			{id = 48672, cost = 300000, requiredIds = {48671}}, 
		},
		[80] = {
			{id = 48691, cost = 300000, requiredIds = {48690}}, 
			{id = 48657, cost = 300000, requiredIds = {48656}}, 
			{id = 57993, cost = 300000, requiredIds = {57992}}, 
			{id = 51723, cost = 300000}, 
			{id = 48676, cost = 300000, requiredIds = {48675}}, 
			{id = 48660, cost = 15000, requiredIds = {26864}, requiredTalentId = 16511}, 
			{id = 48666, cost = 15000, requiredIds = {48663}, requiredTalentId = 1329}, 
			{id = 48638, cost = 300000, requiredIds = {48637}}, 
		},
	},
}

FatCooldowns.TomesSpells = {
	[0] = { 
		[4] = {
			{id = 16321, cost = 100},
		},
		[8] = {
			{id = 16302, cost = 100},
		},
		[12] = {
			{id = 16331, cost = 600},
		},
		[14] = {
			{id = 16322, cost = 900},
			{id = 16326, cost = 900},
		},
		[16] = {
			{id = 16351, cost = 1200},
		},
		[18] = {
			{id = 16316, cost = 1500},
			{id = 16357, cost = 1500},
		},
		[20] = {
			{id = 16346, cost = 2000},
		},
		[22] = {
			{id = 16375, cost = 2500},
		},
		[24] = {
			{id = 16327, cost = 3000},
			{id = 16352, cost = 3000},
			{id = 16363, cost = 3000}
		},
		[26] = {
			{id = 16323, cost = 4000},
			{id = 16358, cost = 4000},
			{id = 16379, cost = 4000}
		},
		[28] = {
			{id = 16317, cost = 5000},
			{id = 16368, cost = 5000},
		},
		[30] = {
			{id = 16347, cost = 6000},
		},
		[32] = {
			{id = 16353, cost = 7000},
			{id = 16380, cost = 7000},
			{id = 16384, cost = 7000}
		},
		[34] = {
			{id = 16328, cost = 8000},
			{id = 16359, cost = 8000},
			{id = 16376, cost = 8000}
		},
		[36] = {
			{id = 16364, cost = 9000},
			{id = 16371, cost = 9000},
			{id = 16388, cost = 9000}
		},
		[38] = {
			{id = 16318, cost = 10000},
			{id = 16324, cost = 10000},
			{id = 16381, cost = 10000}
		},
		[40] = {
			{id = 16348, cost = 11000},
			{id = 16354, cost = 11000},
			{id = 16385, cost = 11000}
		},
		[42] = {
			{id = 16360, cost = 11000},
			{id = 16390, cost = 11000},
		},
		[44] = {
			{id = 16329, cost = 12000},
			{id = 16372, cost = 12000},
		},
		[46] = {
			{id = 16377, cost = 13000},
			{id = 16382, cost = 13000},
		},
		[48] = {
			{id = 16319, cost = 14000},
			{id = 16355, cost = 14000},
			{id = 16365, cost = 14000},
			{id = 16386, cost = 14000}
		},
		[50] = {
			{id = 16325, cost = 15000},
			{id = 16349, cost = 15000},
			{id = 16361, cost = 15000}
		},
		[52] = {
			{id = 16373, cost = 18000},
			{id = 16389, cost = 18000},
		},
		[54] = {
			{id = 16330, cost = 20000},
			{id = 16383, cost = 20000},
		},
		[56] = {
			{id = 16356, cost = 22000},
			{id = 16387, cost = 22000},
		},
		[58] = {
			{id = 16320, cost = 24000},
			{id = 16362, cost = 24000},
			{id = 16378, cost = 24000}
		},
		[60] = {
			{id = 16350, cost = 26000},
			{id = 16366, cost = 26000},
			{id = 16374, cost = 26000}
		},
	},
	[1] = { 
		[4] = {
			{id = 16321, cost = 100}
		},
		[8] = {
			{id = 16302, cost = 100}
		},
		[12] = {
			{id = 16331, cost = 600}
		},
		[14] = {
			{id = 16322, cost = 900},
			{id = 16326, cost = 900}
		},
		[16] = {
			{id = 16351, cost = 1200}
		},
		[18] = {
			{id = 16316, cost = 1500},
			{id = 16357, cost = 1500}
		},
		[20] = {
			{id = 16346, cost = 2000}
		},
		[22] = {
			{id = 16375, cost = 2500}
		},
		[24] = {
			{id = 16327, cost = 3000},
			{id = 16352, cost = 3000},
			{id = 16363, cost = 3000}
		},
		[26] = {
			{id = 16323, cost = 4000},
			{id = 16358, cost = 4000},
			{id = 16379, cost = 4000}
		},
		[28] = {
			{id = 16317, cost = 5000},
			{id = 16368, cost = 5000}
		},
		[30] = {
			{id = 16347, cost = 6000}
		},
		[32] = {
			{id = 16353, cost = 7000},
			{id = 16380, cost = 7000},
			{id = 16384, cost = 7000}
		},
		[34] = {
			{id = 16328, cost = 8000},
			{id = 16359, cost = 8000},
			{id = 16376, cost = 8000}
		},
		[36] = {
			{id = 16364, cost = 9000},
			{id = 16371, cost = 9000},
			{id = 16388, cost = 9000}
		},
		[38] = {
			{id = 16318, cost = 10000},
			{id = 16324, cost = 10000},
			{id = 16381, cost = 10000}
		},
		[40] = {
			{id = 16348, cost = 11000},
			{id = 16354, cost = 11000},
			{id = 16385, cost = 11000}
		},
		[42] = {
			{id = 16360, cost = 11000},
			{id = 16390, cost = 11000}
		},
		[44] = {
			{id = 16329, cost = 12000},
			{id = 16372, cost = 12000}
		},
		[46] = {
			{id = 16377, cost = 13000},
			{id = 16382, cost = 13000}
		},
		[48] = {
			{id = 16319, cost = 14000},
			{id = 16355, cost = 14000},
			{id = 16365, cost = 14000},
			{id = 16386, cost = 14000}
		},
		[50] = {
			{id = 16325, cost = 15000},
			{id = 16349, cost = 15000},
			{id = 16361, cost = 15000},
			{id = 28071, cost = 15000, requiredTalentId = 30146},
			{id = 23734, cost = 15000, requiredTalentId = 30146},
		},
		[52] = {
			{id = 16373, cost = 18000},
			{id = 16389, cost = 18000},
			{id = 23711, cost = 18000, requiredTalentId = 30146},
		},
		[54] = {
			{id = 16330, cost = 20000},
			{id = 16383, cost = 20000}
		},
		[56] = {
			{id = 16356, cost = 22000},
			{id = 16387, cost = 22000},
			{id = 25900, cost = 22000, requiredTalentId = 30146},
		},
		[58] = {
			{id = 16320, cost = 24000},
			{id = 16362, cost = 24000},
			{id = 16378, cost = 24000}
		},
		[60] = {
			{id = 16350, cost = 26000},
			{id = 16366, cost = 26000},
			{id = 16374, cost = 26000},
			{id = 28072, cost = 26000, requiredTalentId = 30146},
			{id = 23745, cost = 15000, requiredTalentId = 30146},
			{id = 25469, cost = 26000, requiredTalentId = 30146},
		},
		[61] = {
			{id = 23730, cost = 26000, requiredTalentId = 30146},
		},
		[62] = {
			{id = 22180, cost = 26000},
			{id = 22188, cost = 29000}
		},
		[63] = {
			{id = 22183, cost = 32000}
		},
		[64] = {
			{id = 22181, cost = 36000},
			{id = 22185, cost = 36000},
			{id = 22190, cost = 36000}
		},
		[66] = {
			{id = 22184, cost = 44000}
		},
		[68] = {
			{id = 22179, cost = 54000},
			{id = 22186, cost = 54000},
			{id = 23755, cost = 60000, requiredTalentId = 30146},
		},
		[69] = {
			{id = 28068, cost = 60000},
			{id = 23731, cost = 60000, requiredTalentId = 30146},
		},
		[70] = {
			{id = 22182, cost = 67000},
			{id = 22187, cost = 67000},
			{id = 22189, cost = 67000},
			{id = 28073, cost = 67000, requiredTalentId = 30146},
		},
	},
}

local WeaponsLocations = {
	[0] = {
		["Alliance"]= {
			["Darnassus"] = {"Daggers", "Unarmed", "Staves", "Bows", "Thrown"},
			["Ironforge"] = {"Guns", "Axes", "Two-Handed Axes", "Maces", "Two-Handed Maces", "Unarmed", "Daggers", "Crossbows", "Thrown"},
			["Stormwind"] = {"Crossbows", "Daggers", "Swords", "Two-Handed Swords", "Polearms", "Staves"},
		},
		["Horde"] = {
			["Orgrimmar"] = {"Bows", "Thrown", "Axes", "Two-Handed Axes", "Staves", "Daggers", "Unarmed"},
			["Thunder Bluff"] = {"Guns", "Maces", "Two-Handed Maces", "Staves"},
			["Undercity"] = {"Crossbows", "Daggers", "Swords", "Two-Handed Swords", "Polearms"},
		}
	},
	[1] = {
		["Alliance"]= {
			["Darnassus"] = {"Daggers", "Unarmed", "Staves", "Bows", "Thrown"},
			["Ironforge"] = {"Guns", "Axes", "Two-Handed Axes", "Maces", "Two-Handed Maces", "Unarmed", "Daggers", "Crossbows", "Thrown"},
			["Stormwind"] = {"Crossbows", "Daggers", "Swords", "Two-Handed Swords", "Polearms", "Staves"},
			["Exodar"] = {"Crossbows", "Daggers", "Swords", "Two-Handed Swords", "Maces", "Two-Handed Maces"},
		},
		["Horde"] = {
			["Orgrimmar"] = {"Bows", "Thrown", "Axes", "Two-Handed Axes", "Staves", "Daggers", "Unarmed"},
			["Thunder Bluff"] = {"Guns", "Maces", "Two-Handed Maces", "Staves"},
			["Undercity"] = {"Crossbows", "Daggers", "Swords", "Two-Handed Swords", "Polearms"},
			["Silvermoon"] = {"Daggers", "Swords", "Two-Handed Swords", "Bows", "Polearms", "Thrown"},
		}
	},
	[2] = {
		["Alliance"]= {
			["Darnassus"] = {"Daggers", "Unarmed", "Staves", "Bows", "Thrown"},
			["Ironforge"] = {"Guns", "Axes", "Two-Handed Axes", "Maces", "Two-Handed Maces", "Unarmed", "Daggers", "Crossbows", "Thrown"},
			["Stormwind"] = {"Crossbows", "Daggers", "Swords", "Two-Handed Swords", "Polearms", "Staves"},
			["Exodar"] = {"Crossbows", "Daggers", "Swords", "Two-Handed Swords", "Maces", "Two-Handed Maces"},
		},
		["Horde"] = {
			["Orgrimmar"] = {"Bows", "Thrown", "Axes", "Two-Handed Axes", "Staves", "Daggers", "Unarmed"},
			["Thunder Bluff"] = {"Guns", "Maces", "Two-Handed Maces", "Staves"},
			["Undercity"] = {"Crossbows", "Daggers", "Swords", "Two-Handed Swords", "Polearms"},
			["Silvermoon"] = {"Daggers", "Swords", "Two-Handed Swords", "Bows", "Polearms", "Thrown"},
		}
	}
}

local WeaponsData = {
	[0] = {
		["DRUID"] = {
			["Maces"] = {id = 198, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
		},
		["HUNTER"] = {
			["Axes"] = {id = 196, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Two-Handed Swords"] = {id = 202, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Bows"] = {id = 264, location = ""},
			["Crossbows"] = {id = 5011, location = ""},
			["Guns"] = {id = 266, location = ""},
		},
		["MAGE"] = {
			["Swords"] = {id = 201, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Wands"] = {id = 5009 , location = ""},
		},
		["PALADIN"] = {
			["Axes"] = {id = 196, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
			["Two-Handed Swords"] = {id = 202, location = ""},
		},
		["PRIEST"] = {
			["Maces"] = {id = 198, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Wands"] = {id = 5009 , location = ""},
		},
		["ROGUE"] = {
			["Swords"] = {id = 201, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Bows"] = {id = 264, location = ""},
			["Crossbows"] = {id = 5011, location = ""},
			["Guns"] = {id = 266, location = ""},
			["Thrown"] = {id = 2764, location = ""},
		},
		["SHAMAN"] = {
			["Axes"] = {id = 196, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
		},
		["WARLOCK"] = {
			["Swords"] = {id = 201, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Wands"] = {id = 5009 , location = ""},
		},
		["WARRIOR"] = {
			["Axes"] = {id = 196, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Two-Handed Swords"] = {id = 202, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Bows"] = {id = 264, location = ""},
			["Crossbows"] = {id = 5011, location = ""},
			["Guns"] = {id = 266, location = ""},
			["Thrown"] = {id = 2764, location = ""},
		},
	},
	[1] = {
		["DEATHKNIGHT"] = {
			["Axes"] = {id = 196, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Two-Handed Swords"] = {id = 202, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
		},
		["DRUID"] = {
			["Maces"] = {id = 198, location = ""},
			--["Polearms"] = {id = 200, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
		},
		["HUNTER"] = {
			["Axes"] = {id = 196, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Two-Handed Swords"] = {id = 202, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Bows"] = {id = 264, location = ""},
			["Crossbows"] = {id = 5011, location = ""},
			["Guns"] = {id = 266, location = ""},
		},
		["MAGE"] = {
			["Swords"] = {id = 201, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Wands"] = {id = 5009 , location = ""},
		},
		["PALADIN"] = {
			["Axes"] = {id = 196, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
			["Two-Handed Swords"] = {id = 202, location = ""},
		},
		["PRIEST"] = {
			["Maces"] = {id = 198, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Wands"] = {id = 5009 , location = ""},
		},
		["ROGUE"] = {
		--	["Axes"] = {id = 196, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Bows"] = {id = 264, location = ""},
			["Crossbows"] = {id = 5011, location = ""},
			["Guns"] = {id = 266, location = ""},
			["Thrown"] = {id = 2764, location = ""},
		},
		["SHAMAN"] = {
			["Axes"] = {id = 196, location = ""},
			["Maces"] = {id = 198, location = ""},
		--	["Polearms"] = {id = 200, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
		},
		["WARLOCK"] = {
			["Swords"] = {id = 201, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Wands"] = {id = 5009 , location = ""},
		},
		["WARRIOR"] = {
			["Axes"] = {id = 196, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Two-Handed Swords"] = {id = 202, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Bows"] = {id = 264, location = ""},
			["Crossbows"] = {id = 5011, location = ""},
			["Guns"] = {id = 266, location = ""},
			["Thrown"] = {id = 2764, location = ""},
		},
	},
	[2] = {
		["DEATHKNIGHT"] = {
			["Axes"] = {id = 196, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Two-Handed Swords"] = {id = 202, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
		},
		["DRUID"] = {
			["Maces"] = {id = 198, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
		},
		["HUNTER"] = {
			["Axes"] = {id = 196, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Two-Handed Swords"] = {id = 202, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Bows"] = {id = 264, location = ""},
			["Crossbows"] = {id = 5011, location = ""},
			["Guns"] = {id = 266, location = ""},
		},
		["MAGE"] = {
			["Swords"] = {id = 201, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Wands"] = {id = 5009 , location = ""},
		},
		["PALADIN"] = {
			["Axes"] = {id = 196, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
			["Two-Handed Swords"] = {id = 202, location = ""},
		},
		["PRIEST"] = {
			["Maces"] = {id = 198, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Wands"] = {id = 5009 , location = ""},
		},
		["ROGUE"] = {
			["Axes"] = {id = 196, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Bows"] = {id = 264, location = ""},
			["Crossbows"] = {id = 5011, location = ""},
			["Guns"] = {id = 266, location = ""},
			["Thrown"] = {id = 2764, location = ""},
		},
		["SHAMAN"] = {
			["Axes"] = {id = 196, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
		},
		["WARLOCK"] = {
			["Swords"] = {id = 201, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Wands"] = {id = 5009 , location = ""},
		},
		["WARRIOR"] = {
			["Axes"] = {id = 196, location = ""},
			["Two-Handed Axes"] = {id = 197, location = ""},
			["Swords"] = {id = 201, location = ""},
			["Two-Handed Swords"] = {id = 202, location = ""},
			["Maces"] = {id = 198, location = ""},
			["Two-Handed Maces"] = {id = 199, location = ""},
			["Polearms"] = {id = 200, location = ""},
			["Staves"] = {id = 227, location = ""},
			["Daggers"] = {id = 1180, location = ""},
			["Unarmed"] = {id = 15590, location = ""},
			["Bows"] = {id = 264, location = ""},
			["Crossbows"] = {id = 5011, location = ""},
			["Guns"] = {id = 266, location = ""},
			["Thrown"] = {id = 2764, location = ""},
		},
	},
}

function WeaponFilter()
	local RebuildTable = {}
	for Class, WeaponTable in pairs(WeaponsData[FatCooldowns.ExPac]) do
		for WeaponID, WeaponTable2 in pairs(WeaponTable) do
			for ExpacId, LocationTable in pairs(WeaponsLocations) do
				if ExpacId == FatCooldowns.ExPac then
					for Faction, locationdata in pairs(LocationTable) do
						if playerFaction == Faction then
							for location2, Weapons in pairs(locationdata) do
								for Weaponindex, WeaponID2 in pairs(Weapons) do
									if WeaponID == WeaponID2 then 
										RebuildTable[Class] = RebuildTable[Class] or {}
										if RebuildTable[Class][WeaponID] ~= nil then
											RebuildTable[Class][WeaponID].location = RebuildTable[Class][WeaponID].location..", "..location2
										else
											RebuildTable[Class][WeaponID] = {id =  WeaponTable2.id, location = location2}
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
	return RebuildTable 
end

FatCooldowns.Weapons = WeaponFilter()

FatCooldowns.WarriorSpells = FatCooldowns.WarriorSpells[FatCooldowns.ExPac]
FatCooldowns.HunterSpells = FatCooldowns.HunterSpells[FatCooldowns.ExPac]
FatCooldowns.WarlockSpells = FatCooldowns.WarlockSpells[FatCooldowns.ExPac]
FatCooldowns.MageSpells = FactionFilter(FatCooldowns.MageSpells[FatCooldowns.ExPac])
FatCooldowns.PriestSpells = RaceFilter(FatCooldowns.PriestSpells[FatCooldowns.ExPac])
FatCooldowns.ShamanSpells = FactionFilter(FatCooldowns.ShamanSpells[FatCooldowns.ExPac])
FatCooldowns.DruidSpells = FatCooldowns.DruidSpells[FatCooldowns.ExPac]
FatCooldowns.PaladinSpells = FactionFilter(FatCooldowns.PaladinSpells[FatCooldowns.ExPac])
FatCooldowns.RogueSpells = FatCooldowns.RogueSpells[FatCooldowns.ExPac]

if FatCooldowns.ExPac == 0 or FatCooldowns.ExPac == 1 then
	FatCooldowns.TomesSpells = FatCooldowns.TomesSpells[FatCooldowns.ExPac]
	FatCooldowns.TomeIds = {}
	for _, tomesByLevel in pairs(FatCooldowns.TomesSpells) do
		for _, tome in ipairs(tomesByLevel) do FatCooldowns.TomeIds[tome.id] = true end
	end
end

local faerieFireFeral = {16857,17390,17391,17392,27011}
local frenziedRegeneration = {22842,22895,22896,26999}
local prowl = {5215,6783,9913}
local demoralizingRoar = {99,1735,9490,9747,9898,26998,48559,48560}
local swipe = {779,780,769,9754,9908,26997,48561,48562}
local rip = {1079,9492,9493,9752,9894,9896,27008,49799,49800}
local claw = {1082,3029,5201,9849,9850,27000,48569,48570}
local rake = {1822,1823,1824,9904,27003,48573,48574}
local dash = {1850,9821,33357}
local bash = {5211,6798,8983}
local tigersFury = {5217,6793,9845,9846,50212,502113}
local shred = {5221,6800,8992,9829,9830,27001,27002,48571,48572}
local ravage = {6785,6787,9866,9867,27005,48578,48579}
local maul = {6807,6808,6809,8972,9745,9880,9881,26996,48479,48480}
local cower = {8998,9000,9892,31709,27004,48575}
local pounce = {9005,9823,9827,27006,49803}
local ferociousBite = {22568,22827,22828,22829,31018,24248,48576,48577}
local mangleCat = {33876,33982,33983,48565,48566}
local mangleBear = {33878,33986,33987,48563,48564}
local layonHands = {633,2800,10310,27154,48788}
local devotionAura = {465,10290,643,10291,1032,10292,10293,27149,48941,48942}
local retributionAura = {7294,10298,10299,10300,10301,27150,54043}
local shadowResistanceAura = {19876,19895,19896,27151,48943}
local frostResistanceAura = {19888,19897,19898,27152,48945}
local fireResistanceAura = {19891,19899,19900,27153,48947}
local spiritualAttunement = {31785,33776}
local stealth = {1784,1785,1786,1787}
local gouge = {1776,1777,8629,11285,11286,38764}
local exposeArmor = {8647,8649,8650,11197,11198,26866}
local kick = {1766,1767,1768,1769,38768}
local cripplingPoison = {3420,3421}
local mindNumbingPoison = {5763,8694,11400}
local instantPoiston = {8681,8687,8691,11341,11342,11343}
local deadlyPoison = {2835,2837,11357,11358,25347}
local sprint = {2983,8696,11305}
local backstab = {53,2589,2590,2591,8721,11279,11280,11281,25300,26863,48656,48657}
local kidneyShot = {408,8643}
local garrote = {703,8631,8632,8633,11289,11290,26839,26884,48675,48676}
local sinisterStrike = {1752,1757,1758,1759,1760,8621,11293,11294,26861,26862,48637,48638}
local vanish = {1856,1857,26889}
local rupture = {1943,8639,8640,11273,11274,11275,26867,48671,48672}
local feint = {1966,6768,8637,11303,25302,27448,48658,48659}
local sap = {6770,2070,11297,51724}
local eviscerate = {2098,6760,6761,6762,8623,8624,11299,11300,31016,26865,48667,48668}
local sprint = {2983,8696,11305}
local sliceandDice = {5171,6774}
local evasion = {5277,26669}
local ambush = {8676,8724,8725,11267,11268,11269,27441,48689,48690,48691}
local envenom = {32645,32684,57992,57993}
local mutilate = {1329,34411,34412,34413,48663,48666}
local shieldBash = {72,1671,1672,29704}
local mockingBlow = {694,7400,7402,20559,20560,25266}
local hamstring = {1715,7372,7373,25212}
local pummel = {6552,6554}
local overpower = {7384,7887,11584,11585}
local sunderArmor = {7386,7405,8380,11596,11597,25225}
local intercept = {20252,20616,20617,25272,25275}
local bloodthirst = {23881,23892,23893,23894,25251,30335}
local rampage = {29801,30030,30033}
local heroicStrike = {78,284,285,1608,11564,11565,11566,11567,25286,29707,30324,47449,47450}
local charge = {100,6178,11578}
local rend = {772,6546,6547,6548,11572,11573,11574,25208,46845,47465}
local cleave = {845,7369,11608,11609,20569,25231,47519,47520}
local demoralizingShout = {1160,6190,11554,11555,11556,25202,25203,47437}
local slam = {1464,8820,11604,11605,25241,25242,47474,47475}
local battleShout = {6673,5242,6192,11549,11550,11551,25289,2048,47436}
local execute = {5308,20658,20660,20661,20662,25234,25236,47470,47471}
local thunderClap = {6343,8198,8204,8205,11580,11581,25264,47501,47502}
local revenge = {6572,6574,7379,11600,11601,25288,25269,30357,57823}
local mortalStrike = {12294,21551,21552,21553,25248,30330,47485,47486}
local devastate = {20243,30016,30022,47497,47498}
local shieldSlam = {23922,23923,23924,23925,25258,30356,47487,47488}

if FatCooldowns.ExPac == 0 then
	AddOverriddenSpells("Druid", FatCooldowns.ExPac, faerieFireFeral, ravage, maul, demoralizingRoar, cower, swipe, shred, rake, pounce, frenziedRegeneration, freociousBite, claw, tigersFury, prowl, rip, bash, dash)
	AddOverriddenSpells("Paladin", FatCooldowns.ExPac, devotionAura, retributionAura, fireResistanceAura, frostResistanceAura, shadowResistanceAura, layonHands)
	AddOverriddenSpells("Rogue", FatCooldowns.ExPac, stealth, backstab, gouge, sap, garrote, feint, rupture, ambush, exposeArmor, kick, cripplingPoison, mindNumbingPoison, instantPoiston, deadlyPoison, sinisterStrike, eviscerate, sprint, sliceAndDice, vanish, kidneyShot)
	AddOverriddenSpells("Warrior", FatCooldowns.ExPac, rend, heroicStrike, bloodthirst, intercept, mortalStrike, shieldSlam, overpower, cleave, thunderClap, sunderArmor, pummel, mockingBlow, execute, slam, revenge, hamstring, demoralizingShout, shieldBash, charge, battleShout)
elseif FatCooldowns.ExPac == 1 then
	AddOverriddenSpells("Druid", FatCooldowns.ExPac, demoralizingRoar, swipe, rip, claw, rake, dash, bash, prowl, tigersFury, shred, ravage, maul, cower, pounce, ferociousBite, frenziedRegeneration, mangleCat, mangleBear, faerieFireFeral)
	AddOverriddenSpells("Paladin", FatCooldowns.ExPac, devotionAura, layonHands, retributionAura, shadowResistanceAura, frostResistanceAura, fireResistanceAura, spiritualAttunement)
	AddOverriddenSpells("Rogue", FatCooldowns.ExPac, backstab, kidneyShot, garrote, sinisterStrike, kick, gouge, stealth, vanish, rupture, feint, sap, eviscerate, deadlyPoison, sprint, cripplingPoison, sliceandDice, evasion, mindnumbingPoison, exposeArmor, ambush, instantPoison, envenom, mutilate)
	AddOverriddenSpells("Warrior", FatCooldowns.ExPac, shieldBash, heroicStrike, charge, mockingBlow, rend, cleave, demoralizingShout, slam, hamstring, battleShout, execute, thunderClap, pummel, revenge, overpower, sunderArmor, intercept, mortalStrike, devastate, bloodthirst, shieldSlam, rampage)
elseif FatCooldowns.ExPac == 2 then
	AddOverriddenSpells("Druid", FatCooldowns.ExPac, demoralizingRoar, swipe, rip, claw, rake, dash, bash, tigersFury, shred, ravage, maul, cower, pounce, ferociousBite, mangleCat, mangleBear)
	AddOverriddenSpells("Paladin", FatCooldowns.ExPac, layonHands, devotionAura, retributionAura, shadowResistanceAura, frostResistanceAura, fireResistanceAura)
	AddOverriddenSpells("Rogue", FatCooldowns.ExPac, backstab, kidneyShot, garrote, sinisterStrike, vanish, rupture, feint, sap, eviscerate, sprint, sliceandDice, evasion, ambush, envenom, mutilate)
	AddOverriddenSpells("Warrior", FatCooldowns.ExPac, heroicStrike, charge, rend, cleave, demoralizingShout, slam, battleShout, execute, thunderClap, revenge, mortalStrike, devastate, shieldSlam)
end

FatCooldowns.DefaultItemWeights = {}
local FCDZero = 0.0001
local DefaultItemWeightsClassic = {
	["DRUID"] = {
		["None"] = {
			["DPS"] = 1,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.1,
			["Intellect"] = 0.2,
			["Spirit"] = 0.5,
			["Strength"] = 0.8,
			["Agility"] = 0.1,
			--off stats
			["ArmorPenetration"] = 0.1,
			["AttackPower"] = 0.1,
			["Hit"] = 0.9,
			["Expertise"] = 0.1,
			["Haste"] = 0.5,
			["SpellPower"] = 0.5,
			["SpellPenetration"] = 0.1,
			["Mp5"] = 0.1,
			["Crit"] = 0.9,
			["SpellHit"] = 0.9,
			["SpellCrit"] = 0.9,
			--def
			["Defense"] = 0.1,
			["Dodge"] = 0.1,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["RangedProc"] = 0,
			["MeleeProc"] = 0,
			["SpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Balance"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.1,
			["Intellect"] = 0.2,
			["Spirit"] = 0.5,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0.9,
			["Expertise"] = 0,
			["Haste"] = 0.7,
			["SpellPower"] = 0.6,
			["SpellPenetration"] = 0.1,
			["Mp5"] = 0.1,
			["Crit"] = 0.4,
			["SpellHit"] = 0.9,
			["SpellCrit"] = 1,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0,
			["DamageSpellProc"] = 0.1,
			["RangedProc"] = 0,
			["MeleeProc"] = 0,
			["SpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Feral"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.08,
			["Stamina"] = 0.4,
			["Intellect"] = 0.1,
			["Spirit"] = 0.2,
			["Strength"] = 0.6,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.9,
			["AttackPower"] = 0.4,
			["Hit"] = 0.4,
			["Expertise"] = 0.4,
			["Haste"] = 0.7,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.7,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0.1,
			["Dodge"] = 0.1,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Feral Combat"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.08,
			["Stamina"] = 0.4,
			["Intellect"] = 0.1,
			["Spirit"] = 0.2,
			["Strength"] = 0.6,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.9,
			["AttackPower"] = 0.4,
			["Hit"] = 0.4,
			["Expertise"] = 0.4,
			["Haste"] = 0.7,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.7,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0.1,
			["Dodge"] = 0.1,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Guardian"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.08,
			["Stamina"] = 1,
			["Intellect"] = 0.1,
			["Spirit"] = 0.2,
			["Strength"] = 0.6,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.1,
			["AttackPower"] = 1,
			["Hit"] = 0.4,
			["Expertise"] = 0.6,
			["Haste"] = 0.7,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.5,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 2,
			["Dodge"] = 0.6,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Restoration"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.1,
			["Intellect"] = 0.6,
			["Spirit"] = 2,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0,
			["Expertise"] = 0,
			["Haste"] = 0.6,
			["SpellPower"] = 0.9,
			["SpellPenetration"] = 0,
			["Mp5"] = 3,
			["Crit"] = 0.5,
			["SpellHit"] = 0,
			["SpellCrit"] = 0.5,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["HUNTER"] = {
		["None"] = {
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.1,
			["Intellect"] = 0.3,
			["Spirit"] = 0.2,
			["Strength"] = 0.6,
			["Agility"] = 2,
			--off stats
			["ArmorPenetration"] = 1,
			["AttackPower"] = 1,
			["Hit"] = 0.4,
			["Expertise"] = 0,
			["Haste"] = 0.6,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.5,
			["Crit"] = 0.6,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0.1,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Beast Mastery"] = {
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.1,
			["Intellect"] = 0.3,
			["Spirit"] = 0.2,
			["Strength"] = 0.6,
			["Agility"] = 2,
			--off stats
			["ArmorPenetration"] = 0.8,
			["AttackPower"] = 1,
			["Hit"] = 1,
			["Expertise"] = 0,
			["Haste"] = 0.8,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.5,
			["Crit"] = 1,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0.1,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Marksmanship"] = {
			["DPS"] = 3,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.1,
			["Intellect"] = 0.3,
			["Spirit"] = 0.2,
			["Strength"] = 0.3,
			["Agility"] = 2.8,
			--off stats
			["ArmorPenetration"] = 1,
			["AttackPower"] = 1,
			["Hit"] = 2,
			["Expertise"] = 0,
			["Haste"] = 1.5,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.5,
			["Crit"] = 0.8,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0.1,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Survival"] = {
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.1,
			["Intellect"] = 0.3,
			["Spirit"] = 0.2,
			["Strength"] = 0.3,
			["Agility"] = 3,
			--off stats
			["ArmorPenetration"] = 0.8,
			["AttackPower"] = 1,
			["Hit"] = 2,
			["Expertise"] = 0,
			["Haste"] = 1.2,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.5,
			["Crit"] = 0.6,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0.1,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["MAGE"] = {
		["None"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.4,
			["Spirit"] = 1,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0.1,
			["Expertise"] = 0,
			["Haste"] = 0.8,
			["SpellPower"] = 1,
			["SpellPenetration"] = 0.1,
			["Mp5"] = 0.1,
			["Crit"] = 1.3,
			["SpellHit"] = 1,
			["SpellCrit"] = 1.3,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Arcane"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.4,
			["Spirit"] = 1,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 1,
			["Expertise"] = 0,
			["Haste"] = 0.5,
			["SpellPower"] = 1,
			["SpellPenetration"] = 0.1,
			["Mp5"] = 0.1,
			["Crit"] = 1.3,
			["SpellHit"] = 1,
			["SpellCrit"] = 1.3,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Fire"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.4,
			["Spirit"] = 1,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 1.5,
			["Expertise"] = 0,
			["Haste"] = 0.8,
			["SpellPower"] = 1,
			["SpellPenetration"] = 0.1,
			["Mp5"] = 0.1,
			["Crit"] = 2.3,
			["SpellHit"] = 1.5,
			["SpellCrit"] = 2.3,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Frost"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.4,
			["Spirit"] = 1,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 1,
			["Expertise"] = 0,
			["Haste"] = 0.8,
			["SpellPower"] = 1,
			["SpellPenetration"] = 0.1,
			["Mp5"] = 0.1,
			["Crit"] = 1.3,
			["SpellHit"] = 1,
			["SpellCrit"] = 1.3,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["PALADIN"] = {
		["None"] = {
			["DPS"] = 1.3,
			["Damage"] = 0.7,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.01,
			["Spirit"] = 1,
			["Strength"] = 2.5,
			["Agility"] = 0.8,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 1,
			["Hit"] = 1.5,
			["Expertise"] = 1.2,
			["Haste"] = 0.8,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.1,
			["Crit"] = 1,
			["SpellHit"] = 0.1,
			["SpellCrit"] = 0.8,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Holy"] = {
			["DPS"] = 0.1,
			["Damage"] = 0.7,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.2,
			["Spirit"] = 1,
			["Strength"] = 0.1,
			["Agility"] = 0.1,
			--off stats
			["ArmorPenetration"] = 0.01,
			["AttackPower"] = 0.1,
			["Hit"] = 0.1,
			["Expertise"] = 0.1,
			["Haste"] = 0.8,
			["SpellPower"] = 0.8,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.1,
			["Crit"] = 0.1,
			["SpellHit"] = 0,
			["SpellCrit"] = 0.1,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Protection"] = {
			["weapons"] = "weapon and shield",
			["DPS"] = 1.3,
			["Damage"] = 0.7,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.1,
			["Stamina"] = 0.5,
			["Intellect"] = 0.1,
			["Spirit"] = 0.3,
			["Strength"] = 1,
			["Agility"] = 0.3,
			--off stats
			["ArmorPenetration"] = 0.1,
			["AttackPower"] = 0.4,
			["Hit"] = 0.1,
			["Expertise"] = 0.2,
			["Haste"] = 0.5,
			["SpellPower"] = 0.05,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.1,
			["Crit"] = 0.3,
			["SpellHit"] = 0.1,
			["SpellCrit"] = 0.1,
			--def
			["Defense"] = 3,
			["Dodge"] = 0.8,
			["Block"] = 0.8,
			["Parry"] = 0.7,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0.5,
			["DamageSpellProc"] = 0.5,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Retribution"] = {
			["weapons"] = "2h",
			["DPS"] = 1,
			["Damage"] = 1,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.1,
			["Spirit"] = 1,
			["Strength"] = 2.5,
			["Agility"] = 0.8,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 1,
			["Hit"] = 1.5,
			["Expertise"] = 1.2,
			["Haste"] = 0.8,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.1,
			["Crit"] = 1,
			["SpellHit"] = 0.1,
			["SpellCrit"] = 0.8,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["PRIEST"] = {
		["None"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.2,
			["Spirit"] = 1,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 1,
			["Expertise"] = 0,
			["Haste"] = 2,
			["SpellPower"] = 2,
			["SpellPenetration"] = 0.1,
			["Mp5"] = 0.7,
			["Crit"] = 0.8,
			["SpellHit"] = 1,
			["SpellCrit"] = 0.8,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Discipline"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.2,
			["Spirit"] = 1,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0,
			["Expertise"] = 0,
			["Haste"] = 2,
			["SpellPower"] = 0.9,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.7,
			["Crit"] = 0.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0.4,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Holy"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.2,
			["Spirit"] = 2,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0,
			["Expertise"] = 0,
			["Haste"] = 2,
			["SpellPower"] = 0.7,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.7,
			["Crit"] = 0.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0.4,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Shadow"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.2,
			["Spirit"] = 1,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 1,
			["Expertise"] = 0,
			["Haste"] = 2,
			["SpellPower"] = 2,
			["SpellPenetration"] = 0.1,
			["Mp5"] = 0.7,
			["Crit"] = 0.8,
			["SpellHit"] = 1,
			["SpellCrit"] = 0.8,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["ROGUE"] = {
		["None"] = {
			["weapons"] = "dual wield",
			["DPS"] = 3,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.6,
			["AttackPower"] = 0.8,
			["Hit"] = 1.7,
			["Expertise"] = 1.8,
			["Haste"] = 1,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.8,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Assassination"] = {
			["weapons"] = "dagger and any",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.6,
			["AttackPower"] = 0.8,
			["Hit"] = 1.7,
			["Expertise"] = 1.8,
			["Haste"] = 1,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.8,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Combat"] = {
			["weapons"] = "dual wield",
			["DPS"] = 3,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.6,
			["AttackPower"] = 0.8,
			["Hit"] = 1.7,
			["Expertise"] = 1.8,
			["Haste"] = 1,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.8,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Subtlety"] = {
			["weapons"] = "dagger and any",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.6,
			["AttackPower"] = 0.8,
			["Hit"] = 1,
			["Expertise"] = 1.8,
			["Haste"] = 1,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.8,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["SHAMAN"] = {
		["None"] = {
			["DPS"] = 1.2,
			["Damage"] = 0.8,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0.2,
			["Spirit"] = 1,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.6,
			["AttackPower"] = 0.8,
			["Hit"] = 2,
			["Expertise"] = 1.5,
			["Haste"] = 1,
			["SpellPower"] = 1,
			["SpellPenetration"] = 1,
			["Mp5"] = 0.1,
			["Crit"] = 1.2,
			["SpellHit"] = 2,
			["SpellCrit"] = 1.2,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Elemental"] = {
			["DPS"] = 0.2,
			["Damage"] = 0.8,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0.5,
			["Spirit"] = 1,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0.5,
			["Expertise"] = 0,
			["Haste"] = 1,
			["SpellPower"] = 0.8,
			["SpellPenetration"] = 0.1,
			["Mp5"] = 0.1,
			["Crit"] = 1.2,
			["SpellHit"] = 0.5,
			["SpellCrit"] = 1.2,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Enhancement"] = {
			["weapons"] = "2h",
			["DPS"] = 1.2,
			["Damage"] = 0.8,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0.3,
			["Spirit"] = 1,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 0.8,
			["Hit"] = 0.8,
			["Expertise"] = 0.5,
			["Haste"] = 1,
			["SpellPower"] = 0.2,
			["SpellPenetration"] = 0.1,
			["Mp5"] = 0.1,
			["Crit"] = 1.2,
			["SpellHit"] = 0.8,
			["SpellCrit"] = 1.2,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Restoration"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0.3,
			["Spirit"] = 1,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0,
			["Expertise"] = 0,
			["Haste"] = 0.5,
			["SpellPower"] = 0.8,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.1,
			["Crit"] = 0.5,
			["SpellHit"] = 0,
			["SpellCrit"] = 0.5,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["WARLOCK"] = {
		["None"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.5,
			["Intellect"] = 0.3,
			["Spirit"] = 0.8,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 5,
			["Expertise"] = 0,
			["Haste"] = 2.4,
			["SpellPower"] = 1,
			["SpellPenetration"] = 0.05,
			["Mp5"] = 1.5,
			["Crit"] = 3,
			["SpellHit"] = 5,
			["SpellCrit"] = 3,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Affliction"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.5,
			["Intellect"] = 0.3,
			["Spirit"] = 0.8,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 5,
			["Expertise"] = 0,
			["Haste"] = 2.4,
			["SpellPower"] = 1,
			["SpellPenetration"] = 0.05,
			["Mp5"] = 1.5,
			["Crit"] = 3,
			["SpellHit"] = 5,
			["SpellCrit"] = 3,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Demonology"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.5,
			["Intellect"] = 0.3,
			["Spirit"] = 0.8,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 5,
			["Expertise"] = 0,
			["Haste"] = 2.4,
			["SpellPower"] = 1,
			["SpellPenetration"] = 0.05,
			["Mp5"] = 1.5,
			["Crit"] = 3,
			["SpellHit"] = 5,
			["SpellCrit"] = 3,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Destruction"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.5,
			["Intellect"] = 0.3,
			["Spirit"] = 0.8,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 5,
			["Expertise"] = 0,
			["Haste"] = 2.4,
			["SpellPower"] = 1,
			["SpellPenetration"] = 0.05,
			["Mp5"] = 1.5,
			["Crit"] = 3,
			["SpellHit"] = 5,
			["SpellCrit"] = 3,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["WARRIOR"] = {
		["None"] = {
			["DPS"] = 1.4,
			["Damage"] = 0.7,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0.01,
			["Strength"] = 2,
			["Agility"] = 0.5,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 0.8,
			["Hit"] = 2,
			["Expertise"] = 1.5,
			["Haste"] = 0.8,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 1.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0.5,
			["Dodge"] = 0.1,
			["Block"] = 0.5,
			["Parry"] = 0.1,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Arms"] = {
			["weapons"] = "2h",
			["DPS"] = 1,
			["Damage"] = 1,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0.01,
			["Strength"] = 2,
			["Agility"] = 0.5,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 0.8,
			["Hit"] = 2,
			["Expertise"] = 1.5,
			["Haste"] = 0.8,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 1.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0.01,
			["Dodge"] = 0.01,
			["Block"] = 0,
			["Parry"] = 0.01,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Fury"] = {
			["weapons"] = "dual wield",
			["DPS"] = 1.2,
			["Damage"] = 0.8,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0.01,
			["Strength"] = 3,
			["Agility"] = 0.5,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 1.4,
			["Hit"] = 2.5,
			["Expertise"] = 2.5,
			["Haste"] = 1.4,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 2,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0.01,
			["Dodge"] = 0.01,
			["Block"] = 0,
			["Parry"] = 0.01,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Protection"] = {
			["weapons"] = "weapon and shield",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.1,
			["Stamina"] = 1.5,
			["Intellect"] = 0,
			["Spirit"] = 0.01,
			["Strength"] = 1.3,
			["Agility"] = 0.5,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 0.4,
			["Hit"] = 0.1,
			["Expertise"] = 0.5,
			["Haste"] = 0.1,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 4,
			["Dodge"] = 1,
			["Block"] = 0.5,
			["Parry"] = 1,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	}
}

local DefaultItemWeightsWotlk = {
	["DEATHKNIGHT"] = {
		["None"] = {
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.1,
			["Stamina"] = 0.5,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 1,
			["Agility"] = 0.1,
			--off stats
			["ArmorPenetration"] = 1,
			["AttackPower"] = 0.4,
			["Hit"] = 1,
			["Expertise"] = 0.5,
			["Haste"] = 0.5,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.5,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Blood"] = {
			["weapons"] = "2h",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.1,
			["Stamina"] = 0.5,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 1,
			["Agility"] = 0.1,
			--off stats
			["ArmorPenetration"] = 0.2,
			["AttackPower"] = 0.4,
			["Hit"] = 0.1,
			["Expertise"] = 0.5,
			["Haste"] = 0.01,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.2,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Frost"] = {
			["weapons"] = "dual wield",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 1,
			["Agility"] = 0.1,
			--off stats
			["ArmorPenetration"] = 0.8,
			["AttackPower"] = 0.4,
			["Hit"] = 1,
			["Expertise"] = 0.8,
			["Haste"] = 0.2,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.5,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Unholy"] = {
			["weapons"] = "2h",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 1,
			["Agility"] = 0.1,
			--off stats
			["ArmorPenetration"] = 0.4,
			["AttackPower"] = 0.4,
			["Hit"] = 0.7,
			["Expertise"] = 0.4,
			["Haste"] = 0.6,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.6,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["DRUID"] = {
		["None"] = {
			["DPS"] = 1,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.2,
			["Spirit"] = 0.5,
			["Strength"] = 0.8,
			["Agility"] = 0.1,
			--off stats
			["ArmorPenetration"] = 0.1,
			["AttackPower"] = 0.1,
			["Hit"] = 0.9,
			["Expertise"] = 0.1,
			["Haste"] = 0.5,
			["SpellPower"] = 0.5,
			["SpellPenetration"] = 0.1,
			["Mp5"] = 0.1,
			["Crit"] = 0.9,
			["SpellHit"] = 0.9,
			["SpellCrit"] = 0.9,
			--def
			["Defense"] = 0.1,
			["Dodge"] = 0.1,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["RangedProc"] = 0,
			["MeleeProc"] = 0,
			["SpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Balance"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0.8,
			["Spirit"] = 0.2,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0.8,
			["Expertise"] = 0,
			["Haste"] = 0.7,
			["SpellPower"] = 0.7,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.01,
			["Crit"] = 0.4,
			["SpellHit"] = 0.8,
			["SpellCrit"] = 0.4,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["RangedProc"] = 0,
			["MeleeProc"] = 0,
			["SpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Feral"] = {
			["DPS"] = 0.8,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 0.8,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.9,
			["AttackPower"] = 0.5,
			["Hit"] = 0.4,
			["Expertise"] = 0.4,
			["Haste"] = 0.5,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.8,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["DamageSpellProc"] = 0,
			["RangedProc"] = 0,
			["MeleeProc"] = 0.1,
			["SpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Feral Combat"] = {
			["DPS"] = 0.8,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 0.8,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.9,
			["AttackPower"] = 0.5,
			["Hit"] = 0.4,
			["Expertise"] = 0.4,
			["Haste"] = 0.5,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.8,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["DamageSpellProc"] = 0,
			["RangedProc"] = 0,
			["MeleeProc"] = 0.1,
			["SpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Guardian"] = {
			["DPS"] = 0.8,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.08,
			["Stamina"] = 0.9,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 0.1,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.01,
			["AttackPower"] = 0.4,
			["Hit"] = 0.2,
			["Expertise"] = 0.2,
			["Haste"] = 0.6,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["DamageSpellProc"] = 0,
			["RangedProc"] = 0,
			["MeleeProc"] = 0.1,
			["SpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Restoration"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.8,
			["Spirit"] = 0.5,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0,
			["Expertise"] = 0,
			["Haste"] = 0.6,
			["SpellPower"] = 0.9,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0.4,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0,
			["DamageSpellProc"] = 0,
			["RangedProc"] = 0,
			["MeleeProc"] = 0,
			["SpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["HUNTER"] = {
		["None"] = {
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.1,
			["Intellect"] = 0.3,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.6,
			["AttackPower"] = 0.8,
			["Hit"] = 0.8,
			["Expertise"] = 0,
			["Haste"] = 0.6,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.2,
			["Crit"] = 0.6,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0.1,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Beast Mastery"] = {
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.1,
			["Intellect"] = 0.3,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.4,
			["AttackPower"] = 0.8,
			["Hit"] = 0.8,
			["Expertise"] = 0,
			["Haste"] = 0.6,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.2,
			["Crit"] = 0.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0.1,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Marksmanship"] = {
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.1,
			["Intellect"] = 0.3,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.6,
			["AttackPower"] = 0.8,
			["Hit"] = 0.8,
			["Expertise"] = 0,
			["Haste"] = 0.6,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.2,
			["Crit"] = 0.6,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0.1,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Survival"] = {
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.1,
			["Intellect"] = 0.3,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.3,
			["AttackPower"] = 0.8,
			["Hit"] = 0.8,
			["Expertise"] = 0,
			["Haste"] = 0.6,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.2,
			["Crit"] = 0.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0.1,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["MAGE"] = {
		["None"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 1.5,
			["Spirit"] = 0.5,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0.7,
			["Expertise"] = 0,
			["Haste"] = 0.8,
			["SpellPower"] = 1,
			["SpellPenetration"] = 0.01,
			["Mp5"] = 0.1,
			["Crit"] = 1,
			["SpellHit"] = 1,
			["SpellCrit"] = 1.3,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Arcane"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 2,
			["Spirit"] = 0.5,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0.7,
			["Expertise"] = 0,
			["Haste"] = 0.8,
			["SpellPower"] = 1.1,
			["SpellPenetration"] = 0.01,
			["Mp5"] = 0.1,
			["Crit"] = 1.3,
			["SpellHit"] = 1,
			["SpellCrit"] = 1.3,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Fire"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.4,
			["Spirit"] = 0.5,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0.7,
			["Expertise"] = 0,
			["Haste"] = 1.2,
			["SpellPower"] = 1.1,
			["SpellPenetration"] = 0.01,
			["Mp5"] = 0.1,
			["Crit"] = 2,
			["SpellHit"] = 1,
			["SpellCrit"] = 2,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Frost"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.4,
			["Spirit"] = 0.5,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0.7,
			["Expertise"] = 0,
			["Haste"] = 0.9,
			["SpellPower"] = 0.8,
			["SpellPenetration"] = 0.01,
			["Mp5"] = 0.1,
			["Crit"] = 1.1,
			["SpellHit"] = 1,
			["SpellCrit"] = 1.1,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["PALADIN"] = {
		["None"] = {
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0.05,
			["Spirit"] = 0,
			["Strength"] = 2.5,
			["Agility"] = 0.8,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 1,
			["Hit"] = 1.5,
			["Expertise"] = 1.2,
			["Haste"] = 0.8,
			["SpellPower"] = 0.5,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.1,
			["Crit"] = 1,
			["SpellHit"] = 0,
			["SpellCrit"] = 0.8,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Holy"] = {
			["DPS"] = 0.1,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 1.3,
			["Spirit"] = 0,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0,
			["Expertise"] = 0,
			["Haste"] = 0.8,
			["SpellPower"] = 1,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.3,
			["Crit"] = 0.6,
			["SpellHit"] = 0,
			["SpellCrit"] = 0.6,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Protection"] = {			
			["weapons"] = "weapon and shield",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.1,
			["Stamina"] = 0.5,
			["Intellect"] = 0.1,
			["Spirit"] = 0,
			["Strength"] = 1,
			["Agility"] = 0.3,
			--off stats
			["ArmorPenetration"] = 0.1,
			["AttackPower"] = 0.3,
			["Hit"] = 0.1,
			["Expertise"] = 0.2,
			["Haste"] = 0.1,
			["SpellPower"] = 0.05,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.05,
			["Crit"] = 0.1,
			["SpellHit"] = 0.05,
			["SpellCrit"] = 0.1,
			--def
			["Defense"] = 3,
			["Dodge"] = 0.8,
			["Block"] = 0.8,
			["Parry"] = 0.7,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0.5,
			["DamageSpellProc"] = 0.5,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Retribution"] = {
			["weapons"] = "2h",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.1,
			["Spirit"] = 0,
			["Strength"] = 2.5,
			["Agility"] = 0.8,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 1,
			["Hit"] = 1.5,
			["Expertise"] = 1.2,
			["Haste"] = 0.8,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.1,
			["Crit"] = 1,
			["SpellHit"] = 0.1,
			["SpellCrit"] = 0.8,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["PRIEST"] = {
		["None"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 1,
			["Spirit"] = 1,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 2,
			["Expertise"] = 0,
			["Haste"] = 2,
			["SpellPower"] = 2.5,
			["SpellPenetration"] = 0.1,
			["Mp5"] = 0.7,
			["Crit"] = 1.8,
			["SpellHit"] = 2,
			["SpellCrit"] = 1.8,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Discipline"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.8,
			["Spirit"] = 0.6,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0,
			["Expertise"] = 0,
			["Haste"] = 0.5,
			["SpellPower"] = 0.9,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.7,
			["Crit"] = 0.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0.4,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Holy"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.8,
			["Spirit"] = 0.8,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0,
			["Expertise"] = 0,
			["Haste"] = 0.4,
			["SpellPower"] = 0.9,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.7,
			["Crit"] = 0.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0.4,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Shadow"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.01,
			["Intellect"] = 0.4,
			["Spirit"] = 0.1,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 1,
			["Expertise"] = 0,
			["Haste"] = 0.5,
			["SpellPower"] = 1,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.2,
			["Crit"] = 0.8,
			["SpellHit"] = 1,
			["SpellCrit"] = 0.8,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["ROGUE"] = {
		["None"] = {
			["weapons"] = "dual wield",
			["DPS"] = 3,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1.2,
			--off stats
			["ArmorPenetration"] = 0.6,
			["AttackPower"] = 0.8,
			["Hit"] = 1.7,
			["Expertise"] = 1.8,
			["Haste"] = 1,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.8,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Assassination"] = {
			["weapons"] = "dagger",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.6,
			["AttackPower"] = 0.8,
			["Hit"] = 1.7,
			["Expertise"] = 1.8,
			["Haste"] = 0.9,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.8,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Combat"] = {
			["weapons"] = "dual wield",
			["DPS"] = 3,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 1,
			["AttackPower"] = 0.6,
			["Hit"] = 1.7,
			["Expertise"] = 1.8,
			["Haste"] = 1,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.8,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Subtlety"] = {
			["weapons"] = "dagger and any",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.6,
			["AttackPower"] = 0.8,
			["Hit"] = 1,
			["Expertise"] = 1.8,
			["Haste"] = 1,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.8,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["SHAMAN"] = {
		["None"] = {
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0.8,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 0.6,
			["Hit"] = 2,
			["Expertise"] = 1.5,
			["Haste"] = 1,
			["SpellPower"] = 1,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.1,
			["Crit"] = 1.2,
			["SpellHit"] = 2,
			["SpellCrit"] = 1.2,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Elemental"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0.5,
			["Spirit"] = 0,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 1,
			["Expertise"] = 0,
			["Haste"] = 0.5,
			["SpellPower"] = 0.8,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.1,
			["Crit"] = 0.7,
			["SpellHit"] = 1,
			["SpellCrit"] = 0.7,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Enhancement"] = {
			["weapons"] = "dual wield",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0.3,
			["Spirit"] = 0,
			["Strength"] = 0.5,
			["Agility"] = 1.2,
			--off stats
			["ArmorPenetration"] = 0.4,
			["AttackPower"] = 0.8,
			["Hit"] = 0.8,
			["Expertise"] = 0.8,
			["Haste"] = 0.7,
			["SpellPower"] = 0.2,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.1,
			["Crit"] = 0.8,
			["SpellHit"] = 0.8,
			["SpellCrit"] = 0.8,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Restoration"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0.9,
			["Spirit"] = 0,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 0,
			["Expertise"] = 0,
			["Haste"] = 0.5,
			["SpellPower"] = 0.7,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.8,
			["Crit"] = 0.6,
			["SpellHit"] = 0,
			["SpellCrit"] = 0.6,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0.1,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["WARLOCK"] = {
		["None"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.5,
			["Intellect"] = 2,
			["Spirit"] = 0.2,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 3,
			["Expertise"] = 0,
			["Haste"] = 2.4,
			["SpellPower"] = 2.8,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.5,
			["Crit"] = 1.5,
			["SpellHit"] = 3,
			["SpellCrit"] = 1.5,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Affliction"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.5,
			["Intellect"] = 2,
			["Spirit"] = 0.2,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 3,
			["Expertise"] = 0,
			["Haste"] = 2.4,
			["SpellPower"] = 2.9,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.5,
			["Crit"] = 1.5,
			["SpellHit"] = 3,
			["SpellCrit"] = 1.5,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Demonology"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.5,
			["Intellect"] = 2,
			["Spirit"] = 0.2,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 3,
			["Expertise"] = 0,
			["Haste"] = 2.2,
			["SpellPower"] = 2.7,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.5,
			["Crit"] = 1.5,
			["SpellHit"] = 3,
			["SpellCrit"] = 1.5,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Destruction"] = {
			["DPS"] = 0.01,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.5,
			["Intellect"] = 1.5,
			["Spirit"] = 0.2,
			["Strength"] = 0,
			["Agility"] = 0,
			--off stats
			["ArmorPenetration"] = 0,
			["AttackPower"] = 0,
			["Hit"] = 3,
			["Expertise"] = 0,
			["Haste"] = 2,
			["SpellPower"] = 2.6,
			["SpellPenetration"] = 0,
			["Mp5"] = 0.5,
			["Crit"] = 0.5,
			["SpellHit"] = 3,
			["SpellCrit"] = 0.5,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0,
			["RangedProc"] = 0,
			["SpellProc"] = 0.1,
			["DamageSpellProc"] = 0.1,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	},
	["WARRIOR"] = {
		["None"] = {
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0.01,
			["Strength"] = 2,
			["Agility"] = 0.5,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 0.8,
			["Hit"] = 2,
			["Expertise"] = 1.5,
			["Haste"] = 0.8,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 1.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Arms"] = {
			["weapons"] = "2h",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0.01,
			["Strength"] = 2,
			["Agility"] = 0.5,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 0.8,
			["Hit"] = 2,
			["Expertise"] = 1.5,
			["Haste"] = 0.8,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 1.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Fury"] = {
			["weapons"] = "2hDW",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.01,
			["Stamina"] = 0.05,
			["Intellect"] = 0,
			["Spirit"] = 0.01,
			["Strength"] = 3,
			["Agility"] = 0.5,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 1.4,
			["Hit"] = 2.5,
			["Expertise"] = 2.5,
			["Haste"] = 1.4,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 2,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 0,
			["Dodge"] = 0,
			["Block"] = 0,
			["Parry"] = 0,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		},
		["Protection"] = {
			["weapons"] = "weapon and shield",
			["DPS"] = 2,
			["Experience"] = 100,
			--main stats
			["Armor"] = 0.1,
			["Stamina"] = 1.5,
			["Intellect"] = 0,
			["Spirit"] = 0.01,
			["Strength"] = 1.3,
			["Agility"] = 0.5,
			--off stats
			["ArmorPenetration"] = 0.5,
			["AttackPower"] = 0.4,
			["Hit"] = 0.1,
			["Expertise"] = 0.5,
			["Haste"] = 0.1,
			["SpellPower"] = 0,
			["SpellPenetration"] = 0,
			["Mp5"] = 0,
			["Crit"] = 0.4,
			["SpellHit"] = 0,
			["SpellCrit"] = 0,
			--def
			["Defense"] = 4,
			["Dodge"] = 1,
			["Block"] = 0.5,
			["Parry"] = 0.7,
			--proc
			["DamageProc"] = 0.1,
			["MeleeProc"] = 0.1,
			["RangedProc"] = 0,
			["SpellProc"] = 0,
			["DamageSpellProc"] = 0,
			["HealingProc"] = 0,
			--gems
			["BlueSockets"] = 1,
			["MetaSockets"] = 1,
			["YellowSockets"] = 1,
			["RedSockets"] = 1,
		}
	}
}

if FatCooldowns.ExPac == 0 then
	local FakeClass, RealClass = UnitClass("player")
	FatCooldowns.DefaultItemWeights = DefaultItemWeightsClassic
else
	local FakeClass, RealClass = UnitClass("player")
	FatCooldowns.DefaultItemWeights = DefaultItemWeightsWotlk
end

FatCooldowns.Classes = {}
if GetLocale() == "enGB" or GetLocale() == "enUS" then
local English = 
{
["Death Knight"] = "Death Knight",
["Druid"] = "Druid",
["Hunter"] = "Hunter",
["Mage"] = "Mage",
["Paladin"] = "Paladin",
["Priest"] = "Priest",
["Rogue"] = "Rogue",
["Shaman"] = "Shaman",
["Warlock"] = "Warlock",
["Warrior"] = "Warrior",
["WARRIOR"] = "WARRIOR",
["DEATHKNIGHT"] = "DEATH KNIGHT",
["DRUID"] = "DRUID",
["HUNTER"] = "HUNTER",
["MAGE"] = "MAGE",
["PALADIN"] = "PALADIN",
["PRIEST"] = "PRIEST",
["ROGUE"] = "ROGUE",
["SHAMAN"] = "SHAMAN",
["WARLOCK"] = "WARLOCK",
["WARRIOR"] = "WARRIOR",
}
FatCooldowns.Classes = English 
end

if GetLocale() == "esES" then
local Spanish = 
{
["Death Knight"] = "Caballero de la Muerte",
["Druid"] = "Druida",
["Hunter"] = "Cazador",
["Mage"] = "Mago",
["Paladin"] = "Paladín",
["Priest"] = "Sacerdote",
["Rogue"] = "Pícaro",
["Shaman"] = "Chamán",
["Warlock"] = "Brujo",
["Warrior"] = "Guerrero",
["DEATHKNIGHT"] = "CABALLERO DE LA MUERTE",
["DRUID"] = "DRUIDA",
["HUNTER"] = "CAZADOR",
["MAGE"] = "MAGO",
["PALADIN"] = "PALADÍN",
["PRIEST"] = "SACERDOTE",
["ROGUE"] = "PÍCARO",
["SHAMAN"] = "CHAMÁN",
["WARLOCK"] = "BRUJO",
["WARRIOR"] = "GUERRERO",
}
FatCooldowns.Classes = Spanish 
end

if GetLocale() == "frFR" then
local French = 
{
["Death Knight"] = "Chevalier de la Mort",
["Druid"] = "Druide",
["Hunter"] = "Chasseur",
["Mage"] = "Mage",
["Paladin"] = "Paladin",
["Priest"] = "Prêtre",
["Rogue"] = "Voleur",
["Shaman"] = "Chaman",
["Warlock"] = "Démoniste",
["Warrior"] = "Guerrier",
["DEATH KNIGHT"] = "CHEVALIER DE LA MORT",
["DRUID"] = "DRUIDE",
["HUNTER"] = "CHASSEUR",
["MAGE"] = "MAGE",
["MONK"] = "MOINE",
["PALADIN"] = "PALADIN",
["PRIEST"] = "PRÊTRE",
["ROGUE"] = "VOLEUR",
["SHAMAN"] = "CHAMANE",
["WARLOCK"] = "DÉMONISTE",
["WARRIOR"] = "GUERRIER" ,
}
FatCooldowns.Classes = French 
end


FatCooldowns.SoundsDuration = {
["AirHorn"] = 2,
["Alert1"] = 1,
["Alert2"] = 1,
["Alert3"] = 1,
["Applause"] = 2,
["Bam"] = 0,
["BananaPeelSlip"] = 0,
["BatmanPunch"] = 0,
["Beware"] = 3,
["BikeHorn"] = 0,
["Blast"] = 2,
["Bleat"] = 1,
["AirHorn"] = 2.5,
["Alert1"] = 1.5,
["Alert2"] = 1.5,
["Alert3"] = 1.5,
["Applause"] = 2.5,
["Bam"] = 0.5,
["BananaPeelSlip"] = 0.5,
["BatmanPunch"] = 0.5,
["Beware"] = 3.5,
["BikeHorn"] = 0.5,
["Blast"] = 2.5,
["Bleat"] = 1.5,
["Bottle"] = 1.5,
["BoxingArenaSound"] = 1.5,
["CartoonVoiceBaritone"] = 2.5,
["CartoonWalking"] = 1.5,
["CatMeow2"] = 1.5,
["CowMooing"] = 1.5,
["Dominating"] = 1.5,
["DontDie"] = 1.5,
["FF1_Victory"] = 3.5,
["GodLike"] = 1.5,
["HeadShot"] = 1.5,
["Incredible"] = 1.5,
["KillingSpree"] = 1.5,
["KittenMeow"] = 0.5,
["LiftMe"] = 1.5,
["LowHealth"] = 0.5,
["LowMana"] = 2.5,
["LudicrousKill"] = 4.5,
["MarioDie"] = 3.5,
["MonsterKill"] = 4.5,
["MultiKill"] = 2.5,
["NeoBeep"] = 1.5,
["Rampage"] = 1.5,
["RingingPhone"] = 2.5,
["RoaringLion"] = 2.5,
["RobotBlip"] = 0.5,
["runaway"] = 0.5,
["SharpPunch"] = 0.5,
["Shotgun"] = 0.5,
["Spread"] = 0.5,
["SquishFart"] = 0.5,
["TempleBellHuge"] = 5.5,
["Torch"] = 1.5,
["UltraKill"] = 1.5,
["Unstoppable"] = 1.5,
["WarningSiren"] = 4.5,
["WaterDrop"] = 0.5,
["Wobble"] = 1.5,
["YouSuck"] = 3.5,
["ZingAlarm"] = 1.5,

["Abolish Disease"] = 0.5,
["Abolish Poison"] = 0.5,
["Adrenaline Rush"] = 0.5,
["Anti-Magic Shell"] = 0.5,
["Anti-magic Zone"] = 0.5,
["Arcane Power"] = 0.5,
["Ardent Defender"] = 0.5,
["Army of the Dead"] = 0.5,
["Aspect of the Wild"] = 0.5,
["Aura Mastery"] = 0.5,
["Avenger's Shield"] = 0.5,
["Avenging Wrath"] = 0.5,
["Banish"] = 0.5,
["Barkskin"] = 0.5,
["Bash"] = 0.5,
["Beacon of Light"] = 0.5,
["Berserk"] = 0.5,
["Bestial Wrath"] = 0.5,
["Blade Flurry"] = 0.5,
["Bladestorm"] = 0.5,
["Blast Wave"] = 0.5,
["Blind"] = 0.5,
["Blink"] = 0.5,
["Blizzard"] = 0.5,
["Blood Armor"] = 0.5,
["Blood Tap"] = 0.5,
["Bloodlust"] = 0.5,
["Bloodrage"] = 0.5,
["Bloodthirst"] = 0.5,
["Bone Shield"] = 0.5,
["Call of the wild"] = 0.5,
["Challenging Roar"] = 0.5,
["Challenging Shout"] = 0.5,
["Cleanse Spirit"] = 0.5,
["Cleanse"] = 0.5,
["Cloak of Shadows"] = 0.5,
["Cold Blood"] = 0.5,
["Cold Snap"] = 0.5,
["Combustion"] = 0.5,
["Concussion Blow"] = 0.5,
["Counterspell"] = 0.5,
["Cure Disease"] = 0.5,
["Cure Toxins"] = 0.5,
["Curse of the Elements"] = 0.5,
["Curse of Tongues"] = 0.5,
["Cyclone"] = 0.5,
["Dancing Rune Weapon"] = 0.5,
["Dark Command"] = 0.5,
["Dash"] = 0.5,
["Death and Decay"] = 0.5,
["Death Coil"] = 0.5,
["Death Grip"] = 0.5,
["Death Pact"] = 0.5,
["Death Wish"] = 0.5,
["Deep Freeze"] = 0.5,
["Demonic Circle Teleport"] = 1.5,
["Demonic Empowerment"] = 0.5,
["Demonic Pact"] = 0.5,
["Deterrence"] = 0.5,
["Devour Magic"] = 0.5,
["Disarm Trap"] = 0.5,
["Disarm"] = 0.5,
["Disengage"] = 0.5,
["Dismantle"] = 0.5,
["Dispel Magic"] = 0.5,
["Dispersion"] = 0.5,
["Distract"] = 0.5,
["Distracting Shot"] = 0.5,
["Divine Favor"] = 0.5,
["Divine Hymn"] = 0.5,
["Divine Illumination"] = 0.5,
["Divine Intervention"] = 0.5,
["Divine Plea"] = 0.5,
["Divine Protection"] = 0.5,
["Divine Sacrifice"] = 0.5,
["Divine Shield"] = 0.5,
["Dragon's Breath"] = 0.5,
["Earth Elemental Totem"] = 0.5,
["Earth Shield"] = 0.5,
["Eclipse (Lunar)"] = 0.5,
["Eclipse (Solar)"] = 0.5,
["Elemental Mastery"] = 0.5,
["Empower Rune Weapon"] = 0.5,
["Enrage"] = 0.5,
["Enraged Regeneration"] = 0.5,
["Evasion"] = 0.5,
["Evocation"] = 0.5,
["Explosive Trap"] = 0.5,
["Fade"] = 0.5,
["Faerie Fire (Feral)"] = 1.5,
["Fan of Knives"] = 0.5,
["Fear Ward"] = 0.5,
["Fear"] = 0.5,
["Feign Death"] = 0.5,
["Feint"] = 0.5,
["Fel Domination"] = 0.5,
["Feral Spirit"] = 0.5,
["Fire Elemental Totem"] = 0.5,
["Focus Magic"] = 0.5,
["Force of Nature"] = 0.5,
["Freezing Arrow"] = 0.5,
["Freezing Fog"] = 0.5,
["Frenzied Regeneration"] = 0.5,
["Frost Nova"] = 0.5,
["Frost Trap"] = 0.5,
["Growl"] = 0.5,
["Guardian Spirit"] = 0.5,
["Hammer of Justice"] = 0.5,
["Hammer Of The Righteous"] = 0.5,
["Hand of Freedom"] = 0.5,
["Hand of Protection"] = 0.5,
["Hand of Reckoning"] = 0.5,
["Hand of Sacrifice"] = 0.5,
["Hand of Salvation"] = 0.5,
["Horn of Winter"] = 1,
["Heroic Fury"] = 0.5,
["Heroism"] = 0.5,
["Hex"] = 0.5,
["Holy Shock"] = 0.5,
["Holy Wrath"] = 0.5,
["Hot Streak"] = 0.5,
["Howl of Terror"] = 0.5,
["Hungering Cold"] = 0.5,
["Hurricane"] = 0.5,
["Hymn of Hope"] = 0.5,
["Hysteria"] = 0.5,
["Ice Barrier"] = 0.5,
["Ice Block"] = 0.5,
["Icebound Fortitude"] = 0.5,
["Icy Veins"] = 0.5,
["Inferno"] = 0.5,
["Innervate"] = 0.5,
["Intervene"] = 0.5,
["Intimidating Shout"] = 0.5,
["Intimidation"] = 0.5,
["Invisibility"] = 0.5,
["Judgment Of The Pure"] = 0.5,
["Kick"] = 0.5,
["Kidney Shot"] = 0.5,
["Killing Machine"] = 0.5,
["Killing Spree"] = 0.5,
["Last Stand"] = 0.5,
["Lay on Hands"] = 0.5,
["Lichborne"] = 0.5,
["Life Tap"] = 0.5,
["Lightning Shield"] = 0.5,
["Lightwell"] = 0.5,
["Mana Burn"] = 0.5,
["Mana Tide Totem"] = 0.5,
["Mark of Blood"] = 0.5,
["Master's Call"] = 0.5,
["Metamorphosis"] = 0.5,
["Mind Control"] = 0.5,
["Mind Freeze"] = 0.5,
["Mind Sear"] = 0.5,
["Mirror Image"] = 0.5,
["Misdirection"] = 0.5,
["Mortal Strike"] = 0.5,
["Nature's Grace"] = 0.5,
["Nature's Grasp"] = 0.5,
["Nature's Swiftness"] = 0.5,
["Necrotic Plague"] = 0.5,
["Pain Suppression"] = 0.5,
["Path of Frost"] = 0.5,
["Penance"] = 0.5,
["Pet Charge"] = 0.5,
["Pet Intercept"] = 0.5,
["Pet Taunt"] = 0.5,
["Piercing Howl"] = 0.5,
["Polymorph"] = 0.5,
["Power Infusion"] = 0.5,
["Power Word Shield"] = 1.5,
["Prayer of Mending"] = 0.5,
["Preparation"] = 0.5,
["Presence of Mind"] = 0.5,
["Psychic Horror"] = 0.5,
["Psychic Scream"] = 0.5,
["Pummel"] = 0.5,
["Pushing the Limit"] = 0.5,
["Raise Ally"] = 0.5,
["Rapid Fire"] = 0.5,
["Rapture"] = 0.5,
["Readiness"] = 0.5,
["Rebirth"] = 0.5,
["Recklessness"] = 0.5,
["Reincarnation"] = 0.5,
["Remove Curse"] = 0.5,
["Repentance"] = 0.5,
["Retaliation"] = 0.5,
["Righteous Defense"] = 0.5,
["Ritual of Souls"] = 0.5,
["Ritual of Summoning"] = 0.5,
["Rune Tap"] = 0.5,
["Sacred Shield"] = 0.5,
["Sap"] = 0.5,
["Scare Beast"] = 0.5,
["Scatter Shot"] = 0.5,
["Shackle Undead"] = 0.5,
["Shadow Dance"] = 0.5,
["Shadowfiend"] = 0.5,
["Shadowfury"] = 0.5,
["Shadowstep"] = 0.5,
["Shamanistic Rage"] = 0.5,
["Shattering Throw"] = 0.5,
["Shield Bash"] = 0.5,
["Shield Block"] = 0.5,
["Shield Wall"] = 0.5,
["Shockwave"] = 0.5,
["Silence"] = 0.5,
["Silencing Shot"] = 0.5,
["Snake Trap"] = 0.5,
["Soulshatter"] = 0.5,
["Soulstone Resurrection"] = 0.5,
["Spell Lock"] = 0.5,
["Sprint"] = 0.5,
["Starfall"] = 0.5,
["Stoicism"] = 0.5,
["Strangulate"] = 0.5,
["Summon Gargoyle"] = 0.5,
["Summon Infernal"] = 0.5,
["Summon Water Elemental"] = 0.5,
["Survival Instincts"] = 0.5,
["Sweeping Strikes"] = 0.5,
["Swiftmend"] = 0.5,
["Taunt"] = 0.5,
["Thunderstorm"] = 0.5,
["Tidal Force"] = 0.5,
["Tiger's Fury"] = 0.5,
["Tranquility"] = 0.5,
["Tranquilizing Shot"] = 0.5,
["Tricks of the Trade"] = 0.5,
["Typhoon"] = 0.5,
["Unbreakable Armor"] = 0.5,
["Vampiric Blood"] = 0.5,
["Vanish"] = 0.5,
["Water Shield"] = 0.5,
["Whirlwind"] = 0.5,
["Wind Shear"] = 0.5,
["Wyvern Sting"] = 0.5,

}

FatCooldowns.GlyphIDS = {
	["Warrior"] = {
		["Minor"] = {
			[58098] = "Glyph of Thunder Clap",
			[58095] = "Glyph of Battle",
			[58097] = "Glyph of Charge",
			[58099] = "Glyph of Mocking Blow",
			[68164] = "Glyph of Command",
			[58096] = "Glyph of Bloodrage",
			[58104] = "Glyph of Enduring Victory",
		},
		["Major"] = {
			[58362] = "Glyph of Heroic Strike",
			[63324] = "Glyph of Bladestorm",
			[63325] = "Glyph of Shockwave",
			[63326] = "Glyph of Vigilance",
			[63327] = "Glyph of Enraged Regeneration",
			[63328] = "Glyph of Spell Reflection",
			[58369] = "Glyph of Bloodthirst",
			[58370] = "Glyph of Whirlwind",
			[58368] = "Glyph of Mortal Strike",
			[63329] = "Glyph of Shield Wall",
			[58386] = "Glyph of Overpower",
			[58387] = "Glyph of Sunder Armor",
			[58375] = "Glyph of Blocking",
			[58376] = "Glyph of Last Stand",
			[58377] = "Glyph of Intervene",
			[58388] = "Glyph of Devastate",
			[58367] = "Glyph of Execution",
			[58366] = "Glyph of Cleaving",
			[58384] = "Glyph of Sweeping Strikes",
			[58382] = "Glyph of Victory Rush",
			[58364] = "Glyph of Revenge",
			[58353] = "Glyph of Taunt",
			[58385] = "Glyph of Rending",
			[58355] = "Glyph of Rapid Charge",
			[58356] = "Glyph of Resonating Power",
			[58357] = "Glyph of Heroic Strike",
			[58365] = "Glyph of Barbaric Insults",
		},
	},
	["Paladin"] = {
		["Minor"] = {
			[57958] = "Glyph of Blessing of Might",
			[57955] = "Glyph of Lay on Hands",
			[57979] = "Glyph of Blessing of Wisdom",
			[57954] = "Glyph of the Wise",
			[57947] = "Glyph of Sense Undead",
			[57937] = "Glyph of Blessing of Kings",
		},
		["Major"] = {
			[63225] = "Glyph of Salvation",
			[54922] = "Glyph of Judgement",
			[54923] = "Glyph of Hammer of Justice",
			[54924] = "Glyph of Spiritual Attunement",
			[54925] = "Glyph of Seal of Command",
			[56414] = "Glyph of Seal of Righteousness",
			[54927] = "Glyph of Crusader Strike",
			[56416] = "Glyph of Seal of Vengeance",
			[54929] = "Glyph of Righteous Defense",
			[54930] = "Glyph of Avenger's Shield",
			[54931] = "Glyph of Turn Evil",
			[54926] = "Glyph of Hammer of Wrath",
			[54934] = "Glyph of Exorcism",
			[54935] = "Glyph of Cleansing",
			[54936] = "Glyph of Flash of Light",
			[54937] = "Glyph of Holy Light",
			[54938] = "Glyph of Avenging Wrath",
			[54939] = "Glyph of Divinity",
			[54940] = "Glyph of Seal of Wisdom",
			[63218] = "Glyph of Beacon of Light",
			[63219] = "Glyph of Hammer of the Righteous",
			[63220] = "Glyph of Divine Storm",
			[54943] = "Glyph of Seal of Light",
			[63222] = "Glyph of Shield of Righteousness",
			[63223] = "Glyph of Divine Plea",
			[63224] = "Glyph of Holy Shock",
			[54928] = "Glyph of Consecration",
		},
	},
	["Shaman"] = {
		["Minor"] = {
			[58063] = "Glyph of Water Shield",
			[62132] = "Glyph of Thunderstorm",
			[58055] = "Glyph of Water Breathing",
			[58057] = "Glyph of Water Walking",
			[58059] = "Glyph of Renewed Life",
			[59289] = "Glyph of Ghost Wolf",
			[58058] = "Glyph of Astral Recall",
		},
		["Major"] = {
			[55444] = "Glyph of Lava Lash",
			[55445] = "Glyph of Windfury Weapon",
			[55446] = "Glyph of Stormstrike",
			[55447] = "Glyph of Flame Shock",
			[55448] = "Glyph of Lightning Shield",
			[55449] = "Glyph of Chain Lightning",
			[55451] = "Glyph of Flametongue Weapon",
			[55452] = "Glyph of Elemental Mastery",
			[55453] = "Glyph of Lightning Bolt",
			[55454] = "Glyph of Lava",
			[63298] = "Glyph of Stoneclaw Totem",
			[55456] = "Glyph of Healing Stream Totem",
			[63270] = "Glyph of Thunder",
			[63271] = "Glyph of Feral Spirit",
			[63273] = "Glyph of Riptide",
			[55436] = "Glyph of Water Mastery",
			[63279] = "Glyph of Earth Shield",
			[55437] = "Glyph of Chain Heal",
			[55438] = "Glyph of Lesser Healing Wave",
			[55439] = "Glyph of Earthliving Weapon",
			[55440] = "Glyph of Healing Wave",
			[63280] = "Glyph of Totem of Wrath",
			[55455] = "Glyph of Fire Elemental Totem",
			[55443] = "Glyph of Frost Shock",
			[63291] = "Glyph of Hex",
		},
	},
	["Rogue"] = {
		["Minor"] = {
			[58032] = "Glyph of Distract",
			[58027] = "Glyph of Pick Lock",
			[58039] = "Glyph of Blurred Speed",
			[58038] = "Glyph of Vanish",
			[58033] = "Glyph of Safe Fall",
			[58017] = "Glyph of Pick Pocket",
		},
		["Major"] = {
			[56808] = "Glyph of Adrenaline Rush",
			[56809] = "Glyph of Gouge",
			[56810] = "Glyph of Slice and Dice",
			[56811] = "Glyph of Sprint",
			[56812] = "Glyph of Garrote",
			[56813] = "Glyph of Ambush",
			[56814] = "Glyph of Ghostly Strike",
			[56818] = "Glyph of Blade Flurry",
			[56819] = "Glyph of Preparation",
			[56820] = "Glyph of Crippling Poison",
			[63269] = "Glyph of Cloak of Shadows",
			[63256] = "Glyph of Tricks of the Trade",
			[63268] = "Glyph of Mutilate",
			[63253] = "Glyph of Shadow Dance",
			[56806] = "Glyph of Deadly Throw",
			[56798] = "Glyph of Sap",
			[56799] = "Glyph of Evasion",
			[56800] = "Glyph of Backstab",
			[56801] = "Glyph of Rupture",
			[56802] = "Glyph of Eviscerate",
			[56803] = "Glyph of Expose Armor",
			[63252] = "Glyph of Killing Spree",
			[56805] = "Glyph of Vigor",
			[63254] = "Glyph of Fan of Knives",
			[56807] = "Glyph of Hemorrhage",
			[56804] = "Glyph of Feint",
		},
	},
	["Mage"] = {
		["Minor"] = {
			[57925] = "Glyph of Slow Fall",
			[57927] = "Glyph of Frost Ward",
			[57924] = "Glyph of Arcane Intellect",
			[57926] = "Glyph of Fire Ward",
			[57928] = "Glyph of Frost Armor",
			[62126] = "Glyph of Blast Wave",
		},
		["Major"] = {
			[56374] = "Glyph of Icy Veins",
			[56375] = "Glyph of Polymorph",
			[56376] = "Glyph of Frost Nova",
			[56377] = "Glyph of Ice Lance",
			[56380] = "Glyph of Evocation",
			[56381] = "Glyph of Arcane Power",
			[62210] = "Glyph of Arcane Blast",
			[56383] = "Glyph of Mage Armor",
			[56384] = "Glyph of Ice Armor",
			[56382] = "Glyph of Molten Armor",
			[56366] = "Glyph of Invisibility",
			[56365] = "Glyph of Blink",
			[56363] = "Glyph of Arcane Missiles",
			[56360] = "Glyph of Arcane Explosion",
			[63095] = "Glyph of Ice Barrier",
			[56364] = "Glyph of Remove Curse",
			[70937] = "Glyph of Eternal Water",
			[63091] = "Glyph of Living Bomb",
			[63092] = "Glyph of Arcane Barrage",
			[63093] = "Glyph of Mirror Image",
			[56367] = "Glyph of Mana Gem",
			[56368] = "Glyph of Fireball",
			[56369] = "Glyph of Fire Blast",
			[56370] = "Glyph of Frostbolt",
			[61205] = "Glyph of Frostfire",
			[56372] = "Glyph of Ice Block",
			[56373] = "Glyph of Water Elemental",
			[63090] = "Glyph of Deep Freeze",
		},
	},
	["Druid"] = {
		["Minor"] = {
			[62970] = "Glyph of Wild Growth",
			[57855] = "Glyph of the Wild",
			[57858] = "Glyph of Challenging Roar",
			[59219] = "Glyph of Dash",
			[57856] = "Glyph of Aquatic Form",
			[62135] = "Glyph of Typhoon",
			[57862] = "Glyph of Thorns",
			[57857] = "Glyph of Unburdened Rebirth",
		},
		["Major"] = {
			[54824] = "Glyph of Swiftmend",
			[54825] = "Glyph of Healing Touch",
			[54826] = "Glyph of Lifebloom",
			[65243] = "Glyph of Survival Instincts",
			[54828] = "Glyph of Starfall",
			[54829] = "Glyph of Moonfire",
			[54830] = "Glyph of Insect Swarm",
			[54831] = "Glyph of Hurricane",
			[54832] = "Glyph of Innervate",
			[67598] = "Glyph of Claw",
			[54743] = "Glyph of Regrowth",
			[63057] = "Glyph of Barkskin",
			[62080] = "Glyph of Focus",
			[63056] = "Glyph of Monsoon",
			[63055] = "Glyph of Savage Roar",
			[54810] = "Glyph of Frenzied Regeneration",
			[54811] = "Glyph of Maul",
			[54756] = "Glyph of Wrath",
			[54813] = "Glyph of Mangle",
			[54845] = "Glyph of Starfire",
			[54815] = "Glyph of Shred",
			[54754] = "Glyph of Rejuvenation",
			[62969] = "Glyph of Berserk",
			[54818] = "Glyph of Rip",
			[71013] = "Glyph of Rapid Rejuvenation",
			[54821] = "Glyph of Rake",
			[54760] = "Glyph of Entangling Roots",
			[54733] = "Glyph of Rebirth",
			[62971] = "Glyph of Nourish",
		},
	},
	["Death Knight"] = {
		["Minor"] = {
			[58640] = "Glyph of Blood Tap",
			[59307] = "Glyph of Corpse Explosion",
			[59309] = "Glyph of Pestilence",
			[60200] = "Glyph of Raise Dead",
		},
		["Major"] = {
			[58669] = "Glyph of Rune Strike",
			[58671] = "Glyph of Obliterate",
			[58613] = "Glyph of Dark Command",
			[59327] = "Glyph of Rune Tap",
			[63330] = "Glyph of Dancing Rune Weapon",
			[63331] = "Glyph of Hungering Cold",
			[63332] = "Glyph of Unholy Blight",
			[63333] = "Glyph of Dark Death",
			[63334] = "Glyph of Disease",
			[63335] = "Glyph of Howling Blast",
			[58686] = "Glyph of the Ghoul",
			[58625] = "Glyph of Icebound Fortitude",
			[58657] = "Glyph of Plague Strike",
			[58629] = "Glyph of Death and Decay",
			[58631] = "Glyph of Icy Touch",
			[62259] = "Glyph of Death Grip",
			[59336] = "Glyph of Death Strike",
			[59332] = "Glyph of Blood Strike",
			[58635] = "Glyph of Unbreakable Armor",
			[58626] = "Glyph of Death Grip",
			[58623] = "Glyph of Anti-Magic Shell",
		},
	},
	["Hunter"] = {
		["Minor"] = {
			[57902] = "Glyph of Scare Beast",
			[57904] = "Glyph of the Pack",
			[57866] = "Glyph of Revive Pet",
			[57903] = "Glyph of Feign Death",
			[57870] = "Glyph of Mend Pet",
			[57900] = "Glyph of Possessed Strength",
		},
		["Major"] = {
			[56841] = "Glyph of Arcane Shot",
			[56842] = "Glyph of Trueshot Aura",
			[56844] = "Glyph of Disengage",
			[56845] = "Glyph of Freezing Trap",
			[56846] = "Glyph of Immolation Trap",
			[56847] = "Glyph of Frost Trap",
			[56848] = "Glyph of Wyvern Sting",
			[56849] = "Glyph of Snake Trap",
			[56850] = "Glyph of Deterrence",
			[56851] = "Glyph of Aspect of the Viper",
			[63086] = "Glyph of Raptor Strike",
			[56826] = "Glyph of Steady Shot",
			[56828] = "Glyph of Rapid Fire",
			[56829] = "Glyph of Hunter's Mark",
			[56832] = "Glyph of Serpent Sting",
			[56824] = "Glyph of Aimed Shot",
			[61389] = "Glyph of Arcane Shot",
			[63069] = "Glyph of Scatter Shot",
			[63065] = "Glyph of Chimera Shot",
			[63066] = "Glyph of Explosive Shot",
			[56836] = "Glyph of Multi-Shot",
			[63068] = "Glyph of Explosive Trap",
			[56838] = "Glyph of Volley",
			[63067] = "Glyph of Kill Shot",
		},
	},
	["Priest"] = {
		["Minor"] = {
			[57986] = "Glyph of Shackle Undead",
			[58009] = "Glyph of Fortitude",
			[58228] = "Glyph of Shadowfiend",
			[57985] = "Glyph of Fading",
			[58015] = "Glyph of Shadow Protection",
			[57987] = "Glyph of Levitate",
		},
		["Major"] = {
			[55692] = "Glyph of Smite",
			[63229] = "Glyph of Dispersion",
			[63231] = "Glyph of Guardian Spirit",
			[63248] = "Glyph of Pain Suppression",
			[63246] = "Glyph of Hymn of Hope",
			[71132] = "Glyph of Shadow Word: Pain",
			[63235] = "Glyph of Penance",
			[55672] = "Glyph of Power Word: Shield",
			[63237] = "Glyph of Mind Sear",
			[55674] = "Glyph of Renew",
			[55675] = "Glyph of Circle of Healing",
			[55676] = "Glyph of Psychic Scream",
			[55677] = "Glyph of Dispel Magic",
			[55678] = "Glyph of Fear Ward",
			[55679] = "Glyph of Flash Heal",
			[55680] = "Glyph of Prayer of Healing",
			[55681] = "Glyph of Shadow Word: Pain",
			[55682] = "Glyph of Shadow Word: Death",
			[55683] = "Glyph of Holy Nova",
			[55684] = "Glyph of Fade",
			[55685] = "Glyph of Spirit of Redemption",
			[55686] = "Glyph of Inner Fire",
			[55687] = "Glyph of Mind Flay",
			[55688] = "Glyph of Mind Control",
			[55689] = "Glyph of Shadow",
			[55690] = "Glyph of Scourge Imprisonment",
			[55691] = "Glyph of Mass Dispel",
			[55673] = "Glyph of Lightwell",
		},
	},
	["Warlock"] = {
		["Minor"] = {
			[58070] = "Glyph of Drain Soul",
			[58079] = "Glyph of Unending Breath",
			[58081] = "Glyph of Kilrogg",
			[58094] = "Glyph of Souls",
			[58068] = "Glyph of Drain Soul",
			[58107] = "Glyph of Enslave Demon",
		},
		["Major"] = {
			[56250] = "Glyph of Succubus",
			[63320] = "Glyph of Life Tap",
			[56224] = "Glyph of Healthstone",
			[63309] = "Glyph of Demonic Circle",
			[56226] = "Glyph of Searing Pain",
			[63312] = "Glyph of Soul Link",
			[56228] = "Glyph of Immolate",
			[56229] = "Glyph of Shadowburn",
			[63310] = "Glyph of Shadowflame",
			[56231] = "Glyph of Soulstone",
			[56232] = "Glyph of Death Coil",
			[56233] = "Glyph of Unstable Affliction",
			[63302] = "Glyph of Haunt",
			[63303] = "Glyph of Metamorphosis",
			[63304] = "Glyph of Chaos Bolt",
			[56235] = "Glyph of Conflagrate",
			[56238] = "Glyph of Health Funnel",
			[56218] = "Glyph of Corruption",
			[56240] = "Glyph of Shadow Bolt",
			[56241] = "Glyph of Curse of Agony",
			[56242] = "Glyph of Incinerate",
			[70947] = "Glyph of Quick Decay",
			[56244] = "Glyph of Fear",
			[56217] = "Glyph of Howl of Terror",
			[56246] = "Glyph of Felguard",
			[56247] = "Glyph of Voidwalker",
			[56248] = "Glyph of Imp",
			[56249] = "Glyph of Felhunter",
			[56216] = "Glyph of Siphon Life",
		},
	},
}


FatCooldowns.WotLKHitCaps = {
    ["Alliance"] = {  
        ["Death Knight"] = {
            ["Blood"] = 263, 
            ["Frost"] = 263, 
            ["Unholy"] = 263, 
        },
        ["Druid"] = {
            ["Balance"] = 263, 
            ["Feral"] = 263, 
            ["Feral Combat"] = 263, 
            ["Restoration"] = 0, 
        },
        ["Hunter"] = {
            ["Beast Mastery"] = 263, 
            ["Marksmanship"] = 263, 
            ["Survival"] = 263, 
        },
        ["Mage"] = {
            ["Arcane"] = 289, 
            ["Fire"] = 367, 
            ["Frost"] = 289, 
        },
        ["Paladin"] = {
            ["Holy"] = 0, 
            ["Protection"] = 263, 
            ["Retribution"] = 263, 
        },
        ["Priest"] = {
            ["Discipline"] = 0, 
            ["Holy"] = 0, 
            ["Shadow"] = 289, 
        },
        ["Rogue"] = {
            ["Assassination"] = 263, 
            ["Combat"] = 363, 
            ["Subtlety"] = 263, 
        },
        ["Shaman"] = {
            ["Elemental"] = 237, 
            ["Enhancement"] = 263, 
            ["Restoration"] = 0, 
        },
        ["Warlock"] = {
            ["Affliction"] = 289, 
            ["Demonology"] = 368, 
            ["Destruction"] = 289, 
        },
        ["Warrior"] = {
            ["Arms"] = 263, 
            ["Fury"] = 263, 
            ["Protection"] = 263, 
        },
    },    
    ["Horde"] = {  
        ["Death Knight"] = {
            ["Blood"] = 263, 
            ["Frost"] = 263, 
            ["Unholy"] = 263, 
        },
        ["Druid"] = {
            ["Balance"] = 263, 
            ["Feral"] = 263, 
            ["Feral Combat"] = 263, 
            ["Restoration"] = 0, 
        },
        ["Hunter"] = {
            ["Beast Mastery"] = 263, 
            ["Marksmanship"] = 263, 
            ["Survival"] = 263, 
        },
        ["Mage"] = {
            ["Arcane"] = 289, 
            ["Fire"] = 367, 
            ["Frost"] = 289, 
        },
        ["Paladin"] = {
            ["Holy"] = 0, 
            ["Protection"] = 263, 
            ["Retribution"] = 263, 
        },
        ["Priest"] = {
            ["Discipline"] = 0, 
            ["Holy"] = 0, 
            ["Shadow"] = 289, 
        },
        ["Rogue"] = {
            ["Assassination"] = 263, 
            ["Combat"] = 363, 
            ["Subtlety"] = 263, 
        },
        ["Shaman"] = {
            ["Elemental"] = 237, 
            ["Enhancement"] = 263, 
            ["Restoration"] = 0, 
        },
        ["Warlock"] = {
            ["Affliction"] = 289, 
            ["Demonology"] = 368, 
            ["Destruction"] = 289, 
        },
        ["Warrior"] = {
            ["Arms"] = 263, 
            ["Fury"] = 263, 
            ["Protection"] = 263, 
        },
    },
}