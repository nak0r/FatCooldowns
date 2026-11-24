assert(FatCooldowns, "FatCooldowns not found!")
local hero = (UnitFactionGroup("player") == "Alliance") and 32182 or 2825
local SJH = (UnitFactionGroup("player") == "Alliance") and "\124cffa335ee\124Hitem:47088:0:0:0:0:0:0:0:0\124h[Satrina's Impeding Scarab]\124h\124r" or "\124cffa335ee\124Hitem:47451:0:0:0:0:0:0:0:0\124h[Juggernaut's Vitality]\124h\124r"
local SJN = (UnitFactionGroup("player") == "Alliance") and "\124cffa335ee\124Hitem:47080:0:0:0:0:0:0:0:0\124h[Satrina's Impeding Scarab]\124h\124r" or "\124cffa335ee\124Hitem:47290:0:0:0:0:0:0:0:0\124h[Juggernaut's Vitality]\124h\124r"
local pvptrinketitemlink = (UnitFactionGroup("player") == "Alliance") and "\124cffa335ee\124Hitem:51377:0:0:0:0:0:0:0:0\124h[Medallion of the Alliance]\124h\124r" or "\124cffa335ee\124Hitem:51378:0:0:0:0:0:0:0:0\124h[Medallion of the Horde]\124h\124r"
local pvptrinketiconlink = (UnitFactionGroup("player") == "Alliance") and "inv_jewelry_trinketpvp_01" or "inv_jewelry_trinketpvp_02"
local pvptrinketitemlinkID = (UnitFactionGroup("player") == "Alliance") and 51377 or 51378
local removeproc = "Note: Will remove tracking when aura is removed"
local AccExpac = GetAccountExpansionLevel()
local ExpacCDType = AccExpac == 0 and "V" or AccExpac == 1 and "T" or AccExpac == 2 and "W"
local ExpacCDs = {
	["V"] = {
		[GetSpellInfo(48477)] = 1800,		-- Rebirth
		[GetSpellInfo(29166)] = 360,		-- Innervate
		[GetSpellInfo(871)] = 1800,			-- Shield Wall
		[GetSpellInfo(33357)] = 300,		-- Dash
		[GetSpellInfo(12975)] = 600,		-- Last Stand
		[GetSpellInfo(19263)] = 300,		-- Deterrence
		[GetSpellInfo(19801)] = 20,			-- Tranquilizing Shot
		[GetSpellInfo(1719)] = 1800,		-- Recklessness
		[GetSpellInfo(26889)] = 300,		-- Vanish
		[GetSpellInfo(2094)] = 300,			-- Blind
		[GetSpellInfo(13750)] = 300,			-- Adrenaline Rush
		[GetSpellInfo(11305)] = 300,			-- Sprint
		[GetSpellInfo(26669)] = 300,			-- Evasion
		[GetSpellInfo(21169)] = 3600,			-- Reincarnation
		[GetSpellInfo(47883)] = 1800,			-- Soulstone Resurrection
		[GetSpellInfo(34477)] = 1800,			-- Misdirection
		[GetSpellInfo(48447)] = 400,			-- Tranquility
		[GetSpellInfo(10278)] = 300,			-- Hand of Protection
		[GetSpellInfo(hero)] = 300,			-- Bloodlust/Heroism
		[GetSpellInfo(33206)] = 144,			-- Pain Suppression
		[GetSpellInfo(498)] = 300,			-- Divine Protection
		[GetSpellInfo(6795)] = 10,			-- Growl
		[GetSpellInfo(355)] = 10,			-- Taunt
		[GetSpellInfo(31789)] = 15,			-- Righteous Defense
		[GetSpellInfo(48788)] = 3600,			-- Lay on Hands
		[GetSpellInfo(48788)] = 600,			-- Challenging Roar
		[GetSpellInfo(1161)] = 600,			-- Challenging Shout
		[GetSpellInfo(10060)] = 96,			-- Power Infusion

	},
	["T"] = {
		[GetSpellInfo(48477)] = 1200,		-- Rebirth
		[GetSpellInfo(29166)] = 360,		-- Innervate
		[GetSpellInfo(871)] = 300,			-- Shield Wall
		[GetSpellInfo(33357)] = 300,		-- Dash
		[GetSpellInfo(12975)] = 480,		-- Last Stand
		[GetSpellInfo(19263)] = 90,			-- Deterrence
		[GetSpellInfo(19801)] = 8,			-- Tranquilizing Shot
		[GetSpellInfo(1719)] = 200,			-- Recklessness
		[GetSpellInfo(26889)] = 120,		-- Vanish
		[GetSpellInfo(2094)] = 240,			-- Blind
		[GetSpellInfo(13750)] = 120,			-- Adrenaline Rush
		[GetSpellInfo(11305)] = 240,			-- Sprint
		[GetSpellInfo(26669)] = 150,			-- Evasion
		[GetSpellInfo(21169)] = 3600,			-- Reincarnation
		[GetSpellInfo(47883)] = 1800,			-- Soulstone Resurrection
		[GetSpellInfo(34477)] = 120,			-- Misdirection
		[GetSpellInfo(48447)] = 600,			-- Tranquility
		[GetSpellInfo(10278)] = 300,			-- Hand of Protection
		[GetSpellInfo(hero)] = 600,			-- Bloodlust/Heroism
		[GetSpellInfo(33206)] = 120,			-- Pain Suppression
		[GetSpellInfo(498)] = 300,			-- Divine Protection
		[GetSpellInfo(6795)] = 10,			-- Growl
		[GetSpellInfo(355)] = 10,			-- Taunt
		[GetSpellInfo(31789)] = 15,			-- Righteous Defense
		[GetSpellInfo(48788)] = 3600,			-- Lay on Hands
		[GetSpellInfo(48788)] = 600,			-- Challenging Roar
		[GetSpellInfo(1161)] = 600,			-- Challenging Shout
		[GetSpellInfo(10060)] = 180,			-- Power Infusion

	},
	["W"] = {
		[GetSpellInfo(48477)] = 600,		-- Rebirth
		[GetSpellInfo(29166)] = 180,		-- Innervate
		[GetSpellInfo(871)] = 300,			-- Shield Wall
		[GetSpellInfo(33357)] = 180,		-- Dash
		[GetSpellInfo(12975)] = 180,		-- Last Stand
		[GetSpellInfo(19263)] = 90,			-- Deterrence
		[GetSpellInfo(19801)] = 8,			-- Tranquilizing Shot
		[GetSpellInfo(1719)] = 200,			-- Recklessness
		[GetSpellInfo(26889)] = 180,		-- Vanish
		[GetSpellInfo(2094)] = 180,			-- Blind
		[GetSpellInfo(13750)] = 180,			-- Adrenaline Rush
		[GetSpellInfo(11305)] = 240,			-- Sprint
		[GetSpellInfo(26669)] = 150,			-- Evasion
		[GetSpellInfo(21169)] = 1800,			-- Reincarnation
		[GetSpellInfo(47883)] = 900,			-- Soulstone Resurrection
		[GetSpellInfo(34477)] = 30,			-- Misdirection
		[GetSpellInfo(48447)] = 480,			-- Tranquility
		[GetSpellInfo(10278)] = 300,			-- Hand of Protection
		[GetSpellInfo(hero)] = 300,			-- Bloodlust/Heroism
		[GetSpellInfo(33206)] = 144,			-- Pain Suppression
		[GetSpellInfo(498)] = 180,			-- Divine Protection
		[GetSpellInfo(6795)] = 8,			-- Growl
		[GetSpellInfo(355)] = 8,			-- Taunt
		[GetSpellInfo(31789)] = 8,			-- Righteous Defense
		[GetSpellInfo(48788)] = 1200,			-- Lay on Hands
		[GetSpellInfo(5209)] = 180,			-- Challenging Roar
		[GetSpellInfo(1161)] = 180,			-- Challenging Shout
		[GetSpellInfo(10060)] = 120,			-- Power Infusion

	},
}


local cooldowns = {
	["DEATHKNIGHT"] = {
		[GetSpellInfo(48707)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 48707, cd = 45, sort = 1 },            								-- Anti-Magic Shell
		[GetSpellInfo(51052)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 51052, spec = true, cd = 120 , talent = true, sort = 2},         	-- Anti-magic Zone
		[GetSpellInfo(42650)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 42650, cd2 = 360, cd = 600 , sort = 3},         						-- Army of the Dead
		[GetSpellInfo(45529)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 45529, cd = 60, sort = 4 },          			  				   	-- Blood Tap
		[GetSpellInfo(49222)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 49222, spec = true, cd = 60 , talent = true, sort = 5},          	-- Bone Shield
		[GetSpellInfo(49028)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 49028, spec = true, cd = 90, talent = true , sort = 6},           	-- Dancing Rune Weapon
		[GetSpellInfo(56222)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 56222, cd = 8 , sort = 7},             			 					-- Dark Command
		[GetSpellInfo(49796)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 49796, cd = 120, sort = 7.5},								        -- DeathChill
		[GetSpellInfo(49938)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 49938, cd = 30, sort = 8},								            -- Death and Decay
		[GetSpellInfo(49576)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 49576, cd = 35 , talent = true, sort = 9},            				-- Death Grip
		[GetSpellInfo(48743)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 48743, cd = 120, sort = 10}, 										-- Death Pact
		[GetSpellInfo(47568)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 47568, cd = 300 , sort = 11},            							-- Empower Rune Weapon
		[GetSpellInfo(59052)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 59052, remove = true, sortname = "*"..GetSpellInfo(59052), desc = removeproc, spec = true, cd = 15, talent = true, sort = 12.5}, 				-- Freezing Fog
		[GetSpellInfo(57623)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 57623, cd = 120, remove = true, desc = "Note: Shows Buff Timer not Cooldown", sort = 11.5}, 				-- horn of winter
		[GetSpellInfo(49203)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 49203, spec = true, cd = 60, talent = true, sort = 12}, 				-- Hungering Cold
		[GetSpellInfo(49016)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 49016, spec = true, cd = 180, talent = true, sort = 13},          	-- Hysteria
		[GetSpellInfo(48792)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 48792, cd = 120, spec = true , sort = 14},          					-- Icebound Fortitude
		[GetSpellInfo(51124)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 51124, remove = true, sortname = "*"..GetSpellInfo(51124), desc = removeproc, cd = 30, spec = true , sort = 14.5},          					-- Killing Machine
		[GetSpellInfo(49039)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 49039, spec = true, cd = 120 , talent = true, sort = 15},           	-- Lichborne
		[GetSpellInfo(49005)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 49005, spec = true, cd = 180 , talent = true, sort = 16},           	-- Mark of Blood
		[GetSpellInfo(47528)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 47528, cd = 10 , sort = 17},            								-- Mind Freeze
		[GetSpellInfo(3714)] = {ExpacHide = {[0] = true, [1] =  true, [2] = false}, id = 3714, cd = 5 , sort = 17.5},            								-- Path of Frost
		[GetSpellInfo(61999)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 61999, spec = true, cd = 30 , sort = 18},            				-- Raise Ally
		[GetSpellInfo(48982)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 48982, spec = true, cd = 30, sort = 19 },            				-- Rune Tap
		[GetSpellInfo(47476)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 47476, cd = 120 , sort = 20},          			     				-- Strangulate
		[GetSpellInfo(49206)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 49206, spec = true, cd = 180 , talent = true, sort = 21},           	-- Summon Gargoyle
		[GetSpellInfo(51271)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 51271, spec = true, cd = 60 , talent = true, sort = 22},          	-- Unbreakable Armor
		[GetSpellInfo(55233)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 55233, spec = true, cd = 60 , talent = true, sort = 23},          	-- Vampiric Blood
		[GetSpellInfo(70654)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 70654, spec = true, cd = 60, sort = 24, sortname = "Prot 4Set/Blood Armor" , icon = "Interface\\Icons\\inv_chest_plate_26"}, 	-- Blood Armor
	},
	["DRUID"] = {
		[GetSpellInfo(2893)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 2893, spec = true, cd = 5, sort = 1},             					-- Abolish Poison
		[GetSpellInfo(22812)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 22812, cd = 60, sort = 2},          									-- Barkskin
		[GetSpellInfo(8983)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 8983, cd = 60, cd2 = 45, cd3 = 30, spec = true , sort = 3},            					-- Bash
		[GetSpellInfo(50334)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 50334, spec = true, cd = 180 , sort = 4},           					-- Berserk
		[GetSpellInfo(5209)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 5209,  cd = ExpacCDs[ExpacCDType][GetSpellInfo(5209)], spec = true , sort = 5 },          					-- Challenging Roar
		[GetSpellInfo(33786)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 33786, cd = 5 , sort = 6, sortname = "*Cyclone", desc = "Note: Triggers when a player starts casting, does not show target"},	-- Cyclone   			
		[GetSpellInfo(33357)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 33357, spec = true, cd = ExpacCDs[ExpacCDType][GetSpellInfo(33357)], cd2 = 144, sort = 7 },           					-- Dash
		[GetSpellInfo(48518)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 48518, spec = true, cd = 30 , sort = 8, sortname = "* "..GetSpellInfo(48518), desc = "Note: Shows cooldown timer not proc timer"},              				-- Eclipse (Lunar)
		[GetSpellInfo(48517)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 48517, spec = true, cd = 30 , sort = 9, sortname = "* "..GetSpellInfo(48517), desc = "Note: Shows cooldown timer not proc timer"},              				-- Eclipse (Solar)
		[GetSpellInfo(5229)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 5229, spec = true, cd = 60 , sort = 10},              				-- Enrage
		[GetSpellInfo(16857)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 16857, spec = true, cd = 6, sort = 11 },             				-- Faerie Fire (Feral)
		[GetSpellInfo(33831)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 33831, cd = 180, spec = true, talent = true , sort = 12},         	-- Force of Nature
		[GetSpellInfo(22842)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 22842, spec = true, cd = 180 , sort = 13},           				-- Frenzied Regeneration
		[GetSpellInfo(6795)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 6795, cd = ExpacCDs[ExpacCDType][GetSpellInfo(6795)], spec = true , sort = 14},              					-- Growl
		[GetSpellInfo(48467)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 48467, cd = 5, sort = 15},              								-- Hurricane
		[GetSpellInfo(29166)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 29166, cd = ExpacCDs[ExpacCDType][GetSpellInfo(29166)], sort = 16}, 	-- Innervate
		[GetSpellInfo(16886)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 16886, cd = 3, spec = true, talent = true, sort = 17},	         	-- Nature's Grace   			
		[GetSpellInfo(53312)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 53312, cd = 60 , sort = 18},   							         	-- Nature's Grasp   			
		[GetSpellInfo(17116)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 17116, spec = true, cd = 180 , talent = true, sort = 19},           	-- Nature's Swiftness
		[GetSpellInfo(48477)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 48477, cd = ExpacCDs[ExpacCDType][GetSpellInfo(48477)], sort = 20},  	-- Rebirth
		[GetSpellInfo(2782)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 2782, spec = true, cd = 5, sort = 21},            					-- Remove Curse
		[GetSpellInfo(53201)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 53201, spec = true, cd = 60 , talent = true, sort = 22},            	-- Starfall
		[GetSpellInfo(61336)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 61336, spec = true, cd = 180 , talent = true, sort = 23},           	-- Survival Instincts
		[GetSpellInfo(18562)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 18562, spec = true, cd = 15 , talent = true, sort = 24},            	-- Swiftmend
		[GetSpellInfo(50213)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 50213, spec = true,cd = 30 , sort = 25},           			 		-- Tiger's Fury
		[GetSpellInfo(48447)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 48447, spec = true, cd = ExpacCDs[ExpacCDType][GetSpellInfo(48447)], cd2 = 336, cd3 = 192, sort = 26},           			 		-- Tranquility
		[GetSpellInfo(53227)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 53227, spec = true, cd = 20 , talent = true, sort = 27, icon = "Interface\\Icons\\ability_druid_typhoon"},		-- Typhoon   			
		[GetSpellInfo(53251)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 53251, spec = true, cd = 6 , talent = true, sort = 28},            	-- Wild Growth   			
	},
	["HUNTER"] = {	
		[GetSpellInfo(49071)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 49071, spec = true, cd = 5 , sort = 1},      		 				-- Aspect of the Wild				
		[GetSpellInfo(13159)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 13159, spec = true, cd = 5 , sort = 1.2},      		 				-- Aspect of the Pack				
		[GetSpellInfo(19574)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 19574, spec = true, cd = 120, talent = true , sort = 2},          	-- Bestial Wrath
		[GetSpellInfo(53434)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 53434, cd = 300, sort = 3},  						 				-- Call of the wild
		[GetSpellInfo(19263)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 19263, cd = ExpacCDs[ExpacCDType][GetSpellInfo(19263)] , sort = 4},           				 				-- Deterrence
		[GetSpellInfo(781)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 781, cd = 25 , sort = 5},            				 					-- Disengage
		[GetSpellInfo(20736)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 20736, spec = true,cd = 8 , sort = 6},								-- Distracting Shot
		[GetSpellInfo(49067)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 49067, cd = 30, sort = 7},  						 					-- Explosive Trap
		[GetSpellInfo(5384)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 5384, cd = 25, sort = 8},  			 								-- Feign Death
		[GetSpellInfo(60192)]  = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 60192,  cd = 30 , sort = 9},            			 				-- Freezing Arrow	
		[GetSpellInfo(13809)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 13809, cd = 30 , sort = 10},            			 					-- Frost Trap
		[GetSpellInfo(19577)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 19577, cd = 60, talent = true, spec = true , sort = 11},             -- Intimidation
		[GetSpellInfo(53271)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 53271, cd = 60, sort = 11.5},             -- Masters Call
		[GetSpellInfo(34477)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 34477, cd = ExpacCDs[ExpacCDType][GetSpellInfo(34477)] , desc = "Note: Failed - The MD didnt Trigger, Removed - the MD was removed after the trigger.", sort = 12},		-- Misdirection
		[GetSpellInfo(61685)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 61685, spec = true, cd = 25 , sort = 13, sortname = "Pet Charge"},	-- Pet Charge				
		[GetSpellInfo(3045)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 3045, cd = 300, cd2 = 180, sort = 14},  						 					-- Rapid Fire
		[GetSpellInfo(23989)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 23989, spec = true, cd = 180 , talent = true, sort = 15},  		 	-- Readiness
		[GetSpellInfo(19503)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 19503, cd = 30, talent = true, spec = true , sort = 16},             -- Scatter Shot
		[GetSpellInfo(14327)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 14327, cd = 5, sort = 16.5, sortname = "*Scare Beast", desc = "Note: Triggers when a player starts casting, does not show target"},             -- Scare Beast
		[GetSpellInfo(34600)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 34600, cd = 30, sort = 17},  						 				-- Snake Trap
		[GetSpellInfo(34490)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 34490, spec = true, cd = 30 , talent = true, sort = 18},  			-- Silencing Shot
		[GetSpellInfo(53477)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 53477, cd = 180, spec = true, sort = 19, sortname = "Pet Taunt"},  	-- Pet Taunt
		[GetSpellInfo(19801)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 19801, cd = ExpacCDs[ExpacCDType][GetSpellInfo(19801)] , sort = 20},             			 					-- Tranquilizing Shot
		[GetSpellInfo(49012)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 49012, cd = 60, talent = true, spec = true , sort = 21},             -- Wyvern Sting
	},
	["MAGE"] = {
		[GetSpellInfo(12042)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 12042, cd = 120, spec = true, talent = true, sort = 1 }, 			-- Arcane Power
		[GetSpellInfo(42945)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 42945, cd = 30, spec = true, talent = true, sort = 2 }, 				-- Blast Wave
		[GetSpellInfo(1953)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 1953, cd = 15 , sort = 3},           				 					-- Blink
		[GetSpellInfo(42940)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 42940, cd = 5 , sort = 4},											-- Blizzard
		[GetSpellInfo(11958)] = {id = 11958, cd = 400 , sort = 5, spec = true, talent = true}, 				-- Cold Snap
		[GetSpellInfo(28682)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 28682,  cd = 120 , talent = true, sort = 6,spec = true},           	-- Combustion
		[GetSpellInfo(2139)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 2139,  cd = 24, sort = 7 },           				 				-- Counterspell
		[GetSpellInfo(44572)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 44572, cd = 30, talent = true, spec = true, sort = 8 },           	-- Deep Freeze
		[GetSpellInfo(42950)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 42950, cd = 20, spec = true, talent = true, sort = 9 }, 				-- Dragon's Breath
		[GetSpellInfo(12051)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 12051, cd = 240 , sort = 10},           								-- Evocation
		[GetSpellInfo(42917)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 42917, cd = 20 , sort = 10.2},           								-- Frost Nova
		[GetSpellInfo(54646)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 54646, cd = 1800 , remove = true, sortname = "*Focus Magic", desc = removeproc, sort = 10.5},           								-- Focus Magic
		[GetSpellInfo(48108)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 48108, cd = 10, spec = true, remove = true, sortname = "*Hot Streak", desc = removeproc, sort = 10.5 }, 			-- Hot Streak
		[GetSpellInfo(43039)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 43039, cd = 30, spec = true, talent = true, sort = 11 }, 			-- Ice Barrier
		[GetSpellInfo(45438)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 45438, cd = 300 , sort = 12},           			 					-- Ice Block
		[GetSpellInfo(12472)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 12472, cd = 144 , sort = 12.5},           			 				-- Icy Veins
		[GetSpellInfo(66)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 66, cd = 180, sort = 13 },           					 				-- Invisibility
		[GetSpellInfo(55342)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 55342, cd = 180 , sort = 14},           			 					-- Mirror Image
		[GetSpellInfo(475)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 475, cd = 5, talent = true, sort = 15.5},           	-- Remove Curse
		[GetSpellInfo(31687)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 31687, cd = 180, talent = true, spec = true, sort = 15 },           	-- Summon Water Elemental
		[GetSpellInfo(12826)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 12826, cd = 5, spec = true,sort = 16 , sortname = "*Polymorph", desc = "Note: Triggers when a player starts casting, does not show target"},		-- Polymorph
		[GetSpellInfo(12043)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 12043, cd = 120, spec = true, talent = true, sort = 17 }, 			-- Presence of Mind
		[GetSpellInfo(70753)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 70753, cd = 5, spec = true, remove = true, sortname = "*Pushing the Limit", desc = removeproc, sort = 18}, 			-- Pushing the Limit
	},
	["PALADIN"] = {	
		[GetSpellInfo(66233)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 66233, cd = 120, spec = true, talent = true, sort = 1},          	-- Ardent Defender  
		[GetSpellInfo(31821)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 31821, spec = true, cd = 120 , talent = true, sort = 2},           	-- Aura Mastery
		[GetSpellInfo(48827)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 48827, spec = true, cd = 30 , talent = true, sort = 3},           	-- Avenger's Sheild
		[GetSpellInfo(31884)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 31884, cd = 120 , cd2 = 180, sort = 4},          				 				-- Avenging Wrath
		[GetSpellInfo(53563)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 53563, talent = true, spec = true, cd = 90, sort = 5, remove = true, sortname = "*Beacon of Light", desc = removeproc},	-- Beacon of Light
		[GetSpellInfo(4987)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 4987, cd = 5, spec = true, sort = 6},          	 					-- Cleanse
		[GetSpellInfo(20216)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 20216, cd = 120, spec = true, talent = true, sort = 7},          	-- Divine Favor
		[GetSpellInfo(31842)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 31842, cd = 180, spec = true, talent = true, sort = 8},          	-- Divine Illumination
		[GetSpellInfo(19752)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 19752, spec = true, cd = 600, sort = 9}, 			 				-- Divine Intervention
		[GetSpellInfo(54428)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 54428, cd = 60 , sort = 10},          				 				-- Divine Plea
		[GetSpellInfo(498)]   = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 498,  cd2 = 180, cd = ExpacCDs[ExpacCDType][GetSpellInfo(498)], spec = true, sort = 11},            		-- Divine Protection
		[GetSpellInfo(64205)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 64205, spec = true, cd = 120, talent = true, sort = 12},          	-- Divine Sacrifice
		[GetSpellInfo(642)]   = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 642, cd = 300, cd2 = 270 ,cd3 =  240, sort = 13},           			 	 				-- Divine Shield
		[GetSpellInfo(10308)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 10308, cd2 = 30, cd = 60 , cd3 = 40, sort = 14},          				 		-- Hammer of Justice
		[GetSpellInfo(1044)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 1044, cd = 25 , sort = 15},          				 					-- Hand of Freedom
		[GetSpellInfo(10278)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 10278, cd2 = 180, cd3 = 240, cd = ExpacCDs[ExpacCDType][GetSpellInfo(10278)] , sort = 16},           			 		-- Hand of Protection
		[GetSpellInfo(62124)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 62124, cd = 8, spec = true, sort = 17},          	 				-- Hand of Reckoning	
		[GetSpellInfo(6940)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 6940, cd = 120 , sort = 18},          				 				-- Hand of Sacrifice
		[GetSpellInfo(1038)] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 1038, cd = 120 , sort = 19},          				 				-- Hand of Salvation
		[GetSpellInfo(53595)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 53595, cd = 6 , spec = true, talent = true, sort = 20},				-- Hand of The Righteous
		[GetSpellInfo(48825)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 48825, cd = 6 , spec = true, talent = true, sort = 21},				-- Holy Shock	
		[GetSpellInfo(48817)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 48817, cd = 30 , sort = 22},          				 				-- Holy Wrath	
		[GetSpellInfo(54153)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 54153, cd = 60 , spec = true, talent = true, sort = 23, remove = true, sortname = "*Jugment of the Pure", desc = removeproc},		-- Jugment of the Pure
		[GetSpellInfo(48788)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 48788, cd = ExpacCDs[ExpacCDType][GetSpellInfo(48788)], cd2 = 900, sort = 24},          								-- Lay on Hands
		[GetSpellInfo(20066)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 20066, spec = true, cd = 60 , talent = true, sort = 25},          	-- Repentance
		[GetSpellInfo(31789)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 31789, cd = ExpacCDs[ExpacCDType][GetSpellInfo(31789)], spec = true, sort = 26},          	 				-- Righteous Defense
		[GetSpellInfo(53601)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 53601, cd2 = 60, cd = 30, sort = 27, remove = true, sortname = "*Sacred Shield", desc = removeproc},					-- Sacred Shield
	},
	["PRIEST"] = {	
		[GetSpellInfo(552)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 552, spec = true, cd = 5 , sort = 1},             						-- Abolish Disease
		[GetSpellInfo(48089)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 48089, talent = true, spec = true, cd = 6 , sort = 2},				-- Circle of Healing
		[GetSpellInfo(528)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 528, spec = true, cd = 5 , sort = 4},             						-- Cure Disease
		[GetSpellInfo(988)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 988, spec = true, cd = 5 , sort = 3},             						-- Dispel Magic
		[GetSpellInfo(47585)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 47585, spec = true, cd = 75 , talent = true, sort = 5},            	-- Dispersion
		[GetSpellInfo(64843)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 64843, cd = 480 , sort = 6},           			 					-- Divine Hymn
		[GetSpellInfo(586)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 586, cd = 30, sort = 7 },           					 				-- Fade
		[GetSpellInfo(6346)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 6346,  cd = 180 , sort = 8},           			 					-- Fear Ward
		[GetSpellInfo(47788)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 47788, spec = true, cd = 72 , talent = true, sort = 9},           	-- Guardian Spirit
		[GetSpellInfo(64901)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 64901, cd = 360, sort = 10 },										-- Hymn of Hope
		[GetSpellInfo(48087)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 48087, cd = 180, spec = true,talent = true,sort = 11}, 				-- Lightwell
		[GetSpellInfo(8129)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 8129, cd = 5 , sort = 12, sortname = "*Mana Burn", desc = "Note: Triggers when a player starts casting, does not show target"},		-- Mana Burn
		[GetSpellInfo(605)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 605, cd = 5 , sort = 13, sortname = "*Mind Control", desc = "Note: Triggers when a player starts casting, does not show target"},		-- Mind Control
		[GetSpellInfo(53023)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 53023, cd = 5 , sort = 14},											-- Mind Sear
		[GetSpellInfo(33206)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 33206, spec = true, cd = ExpacCDs[ExpacCDType][GetSpellInfo(33206)] , talent = true, sort = 15},           	-- Pain Suppression
		[GetSpellInfo(52985)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 52985, spec = true, cd = 12 , talent = true, sort = 16},     		-- Penance
		[GetSpellInfo(10060)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 10060, spec = true, cd = ExpacCDs[ExpacCDType][GetSpellInfo(10060)], cd2 = 96, talent = true, sort = 17},           	-- Power Infusion
		[GetSpellInfo(48066)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 48066, cd = 4, sort = 18 },             			 					-- Power Word: Shield
		[GetSpellInfo(48113)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 48113, spec = true, cd2 = 7, cd = 10 , sort = 19},					-- Prayer of Mending
		[GetSpellInfo(64044)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 64044, spec = true, cd = 120, talent = true, sort = 20},           	-- Psychic Horror
		[GetSpellInfo(10890)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 10890, cd = 30 , sort = 21},            			 					-- Psychic Scream
		[GetSpellInfo(47755)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 47755, spec = true, cd = 12 , talent = true, sort = 22},      		-- Rapture
		[GetSpellInfo(10955)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 10955, cd = 5 , sort = 23},           			 					-- Shackle Undead
		[GetSpellInfo(34433)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 34433, cd2 = 180, cd = 300 , sort = 24},								-- Shadowfiend
		[GetSpellInfo(15487)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 15487, spec = true, cd = 45 , talent = true, sort = 25},            	-- Silence
	},
	["ROGUE"] = {	
		[GetSpellInfo(13750)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 13750, spec = true, cd = ExpacCDs[ExpacCDType][GetSpellInfo(13750)] , talent = true, sort = 1}, 			-- Adrenaline Rush
		[GetSpellInfo(13877)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 13877, spec = true, cd = 120, talent = true , sort = 2}, 			-- Blade Flurry
		[GetSpellInfo(2094)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 2094, cd = ExpacCDs[ExpacCDType][GetSpellInfo(2094)], sort = 3},					  		 				-- Blind
		[GetSpellInfo(31224)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 31224, cd = 90 , sort = 4},            			 					-- Cloak of Shadows
		[GetSpellInfo(14177)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 14177, spec = true, cd = 180 , talent = true, sort = 5}, 			-- Cold Blood
		[GetSpellInfo(1842)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 1842, spec = true, cd = 5 , sort = 6}, 			 					-- Disarm Trap
		[GetSpellInfo(51722)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 51722, cd = 60 , sort = 7},					     					-- Dismantle
		[GetSpellInfo(1725)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 1725, spec = true, cd = 30, sort = 8 }, 			 					-- Distract
		[GetSpellInfo(26669)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 26669,  cd = ExpacCDs[ExpacCDType][GetSpellInfo(26669)] , sort = 9},         			 					-- Evasion
		[GetSpellInfo(51723)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 51723, cd = 5 , sort = 10},					     					-- Fan of Knives
		[GetSpellInfo(48659)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 48659, cd = 10 , sort = 11},					     					-- Feint
		[GetSpellInfo(1766)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 1766,  cd = 10, sort = 12 },            			 					-- Kick
		[GetSpellInfo(8643)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 8643,  cd = 5, sort = 13 },											-- Kidney Shot
		[GetSpellInfo(51690)]  = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 51690, spec = true,  cd = 120 , talent = true, sort = 14},         	-- Killing Spree
		[GetSpellInfo(14185)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 14185, spec = true, cd = 480 , talent = true, sort = 15}, 			-- Preparation
		[GetSpellInfo(51724)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 51724,  cd = 5 , sort = 16},         			 					-- Sap
		[GetSpellInfo(51713)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 51713, spec = true, cd = 60 , talent = true, sort = 17}, 			-- Shadow Dance
		[GetSpellInfo(36554)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 36554, spec = true, cd = 20 , talent = true, sort = 18}, 			-- Shadowstep
		[GetSpellInfo(11305)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 11305, cd = ExpacCDs[ExpacCDType][GetSpellInfo(11305)] , sort = 19},					     				-- Sprint
		[GetSpellInfo(57934)]  = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 57934,  cd = 30 , desc = "Note: Failed - The ToT didnt Trigger, Removed - the ToT was removed after the trigger.", sort = 20},		-- Tricks of the Trade
		[GetSpellInfo(26889)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 26889,  cd = ExpacCDs[ExpacCDType][GetSpellInfo(26889)], sort = 21},         			 					-- Vanish
	},
	["SHAMAN"] = {	
		[GetSpellInfo(hero)]  = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = hero,  cd = ExpacCDs[ExpacCDType][GetSpellInfo(hero)] , sort = 1},         				 				-- Bloodlust/Heroism
		[GetSpellInfo(51886)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 51886, spec = true, cd = 5 , sort = 2},             					-- Cleanse Spirit
		[GetSpellInfo(526)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 526, spec = true, cd = 5 , sort = 3},             						-- Cure Toxins
		[GetSpellInfo(2062)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 2062, spec = true, cd = 600 , sort = 4},             					-- Earth Elemental Totem
		[GetSpellInfo(49284)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 49284, talent = true, spec = true, remove = true, sortname = "*"..GetSpellInfo(49284), desc = removeproc, cd = 600 , sort = 4.5},             					-- Earth Shield
		[GetSpellInfo(25454)] = {ExpacHide = {[0] = false, [1] = false, [2] = true}, id = 25454, cd = 6 , sort = 4.51},             					-- Earth Shock
		[GetSpellInfo(16166)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 16166, spec = true, cd = 180 , talent = true, sort = 5},           	-- Elemental Mastery
		[GetSpellInfo(51533)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 51533, spec = true, cd = 180 , talent = true, sort = 6},           	-- Feral Spirit
		[GetSpellInfo(2894)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 2894, spec = true, cd = 600 , sort = 7},             					-- Fire Elemental Totem
		[GetSpellInfo(51514)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 51514, cd = 45 , sort = 8},            			 					-- Hex    				
		[GetSpellInfo(49281)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 49281, remove = true, sortname = "*"..GetSpellInfo(49281), desc = removeproc, cd = 600 , sort = 8.5},            			 					-- Lightning Shield    				
		[GetSpellInfo(16190)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 16190, spec = true, cd = 300 , talent = true, sort = 9},           	-- Mana Tide Totem
		[GetSpellInfo(16188)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 16188, spec = true, cd = 120 , talent = true, sort = 10},           	-- Nature's Swiftness
		[GetSpellInfo(21169)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 21169, descid = 20608, cd = ExpacCDs[ExpacCDType][GetSpellInfo(21169)], sort = 11},			 			-- Reincarnation
		[GetSpellInfo(30823)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 30823, cd = 60, spec = true, talent = true , sort = 12},        		-- Shamanistic Rage
		[GetSpellInfo(59159)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 59159, spec = true, cd = 35 , talent = true, sort = 13},            	-- Thunderstorm
		[GetSpellInfo(55198)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 55198, cd = 180, talent = true, spec = true , sort = 14},		 	-- Tidal Force
		[GetSpellInfo(57960)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 57960, remove = true, cd = 600 , sortname = "*"..GetSpellInfo(57960), desc = removeproc , sort = 14.5},             			 					-- Water Shield
		[GetSpellInfo(57994)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 57994, cd = 6 , sort = 15},             			 					-- Wind Shear
	},
	["WARLOCK"] = {	
		[GetSpellInfo(18647)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 18647, spec = true, cd = 5, sort = 1, sortname = "*Banish", desc = "Note: Triggers when a player starts casting, does not show target"},				-- Banish
		[GetSpellInfo(48090)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 48090, spec = true, cd = 20, sort = 1.5, remove = true, sortname = "*Demonic Pact", desc = removeproc},				-- Demonic Pact
		[GetSpellInfo(47865)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 47865, cd = 5 , sort = 3.5},             						-- Curse of the Elements
		[GetSpellInfo(11719)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 11719, spec = true, cd = 5, sort = 2},  		     					-- Curse of Tongues
		[GetSpellInfo(47860)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 47860, cd = 120, sort = 2.5 },            			 				-- Death Coil
		[GetSpellInfo(48020)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 48020, cd = 30, sort = 3 },            			 					-- Demonic Circle: Teleport
		[GetSpellInfo(47193)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 47193, spec = true, cd = 42, talent = true, sort = 4},  		     	-- Demonic Empowerment
		[GetSpellInfo(48011)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 48011, cd = 24, spec = true, sort = 5},       		 				-- Devour Magic	
		[GetSpellInfo(6215)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 6215, cd = 5, sort = 6, sortname = "*Fear", desc = "Note: Triggers when a player starts casting, does not show target"},		-- Fear
		[GetSpellInfo(18708)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 18708, cd = 130, spec = true, sort = 7},  		     				-- Fel Domination
		[GetSpellInfo(17928)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 17928, cd = 40, sort = 8, sortname = "*Howl of Terror", desc = "Note: Triggers when a player starts casting, does not show target"},		-- Howl of Terror
		[GetSpellInfo(63321)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 63321, cd = 40, sort = 9, remove = true, sortname = "*Life Tap", desc = removeproc},								-- Life Tap
		[GetSpellInfo(47241)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 47241, spec = true, cd = 126, talent = true, sort = 10},  		    -- Metamorphosis
		[GetSpellInfo(47996)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 47996, cd = 30 , sort = 11, spec = true},           					-- Pet Intercept
		[GetSpellInfo(698)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 698, cd = 120, sort = 12},  		     								-- Ritual of Summoning
		[GetSpellInfo(47847)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 47847, cd = 20, sort = 13}, 											-- Shadowfury
		[GetSpellInfo(29858)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 29858, cd = 300 , sort = 14},           			 					-- Soulshatter
		[GetSpellInfo(47883)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 47883, cd = ExpacCDs[ExpacCDType][GetSpellInfo(47883)], sort = 15},  						 				-- Soulstone Resurrection
		[GetSpellInfo(19647)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 19647, cd = 24 , sort = 16},						 					-- Spell Lock
		[GetSpellInfo(1122)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 1122, cd = 600, sort = 17}, 											-- Summon Infernal
		[GetSpellInfo(58887)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 58887, cd = 300, sort = 18}, 											-- Ritual of Souls
	},
	["WARRIOR"] = {
		[GetSpellInfo(46924)]  = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 46924,  cd = 90 ,spec = true, talent = true, sort = 1},				-- Bladestorm
		[GetSpellInfo(23881)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 23881,  cd = 4, spec = true, talent = true, sort = 2},   		 	-- Bloodthirst
		[GetSpellInfo(2687)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 2687, cd = 60, cd2 = 40, sort = 3},									-- BloodRage
		[GetSpellInfo(1161)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 1161,  cd = ExpacCDs[ExpacCDType][GetSpellInfo(1161)], spec = true, sort = 4},            					-- Challenging Shout
		[GetSpellInfo(12809)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 12809,  cd = 30 ,spec = true, talent = true, sort = 5},				-- Concussion Blow
		[GetSpellInfo(12292)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 12292, spec = true,  cd = 121 , talent = true, sort = 6},         	-- Death Wish
		[GetSpellInfo(676)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 676,  cd = 60 , sort = 7},							 				-- Disarm
		[GetSpellInfo(55694)] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 55694,  cd = 180 , sort = 8 }, 										-- Enraged Regeneration
		[GetSpellInfo(60970)]  = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 60970,  cd = 45 ,spec = true , talent = true, sort = 9},			-- Heroic Fury		
		[GetSpellInfo(3411)]  = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 3411,  cd = 30 , sort = 10},            			 					-- Intervene
		[GetSpellInfo(5246)]   = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 5246,   cd = 120 , sort = 11},						 				-- Intimidating Shout
		[GetSpellInfo(12975)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 12975, spec = true, cd2 = 120 ,cd = ExpacCDs[ExpacCDType][GetSpellInfo(12975)], talent = true, sort = 12},	-- Last Stand
		[GetSpellInfo(47486)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 47486,  cd = 6 ,spec = true, talent = true, sort = 13},				-- Mortal Strike
		[GetSpellInfo(12323)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 12323,  cd = 5 ,spec = true, talent = true, sort = 14},				-- Piercing Howl
		[GetSpellInfo(6552)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 6552,  cd = 10 , spec = true, sort = 15},           					-- Pummel
		[GetSpellInfo(1719)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 1719,  cd = ExpacCDs[ExpacCDType][GetSpellInfo(1719)] , talent = true, sort = 16},           			 	-- Recklessness
		[GetSpellInfo(20230)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 20230,  cd = 300 ,spec = true, sort = 17},						 	-- Retaliation
		[GetSpellInfo(64382)]  = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 64382,  cd = 300 , sort = 18},         			 					-- Shattering Throw  		
		[GetSpellInfo(72)]    = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 72,    cd = 12 , spec = true , sort = 19},            			 	-- Shield Bash
		[GetSpellInfo(2565)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 2565,  cd = 40, spec = true, sort = 20},   		     				-- Shield Block
		[GetSpellInfo(871)]   = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 871, cd2 = 120,  cd = ExpacCDs[ExpacCDType][GetSpellInfo(871)], spec = true, sort = 21},            		-- Shield Wall
		[GetSpellInfo(46968)]  = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 46968,  cd = 20,spec = true , talent = true, sort = 22},			-- Shockwave
		[GetSpellInfo(12328)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 12328,  cd = 30 ,spec = true, talent = true, sort = 23},			-- Sweeping Strikes
		[GetSpellInfo(355)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 355,  cd = ExpacCDs[ExpacCDType][GetSpellInfo(355)], spec = true , sort = 24 },            	 				-- Taunt
		[GetSpellInfo(1680)]  = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 1680,  cd = 8, spec = true, sort = 25},   		     				-- Whirlwind
		[GetSpellInfo(70845)]  = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 70845,  cd = 60, spec = true, sort = 26, sortname = "Prot 4Set/Stoicism", icon = "Interface\\Icons\\inv_chest_plate_25"},  -- Stoicism
	},
	["ITEMS"] = {
		[75490] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 75490, cd = 120, spec = true, item = true, itemidline = 8, sortname = "GTS Normal", itemid = 54573, itemlink = "\124cffa335ee\124Hitem:54573:0:0:0:0:0:0:0:0\124h[Glowing Twilight Scale]\124h\124r", icon = "Interface\\Icons\\inv_misc_rubysanctum1"},            				 
		[75495] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 75495, cd = 120, spec = true, item = true, itemidline = 9, sortname = "GTS Heroic", itemid = 54589, itemlink = "\124cffa335ee\124Hitem:54589:0:0:0:0:0:0:0:0\124h[Glowing Twilight Scale]\124h\124r", icon = "Interface\\Icons\\inv_misc_rubysanctum1"},   		 				 
		[71635] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 71635, cd = 60, spec = true, item = true, itemidline = 8, sortname = "SFF Normal", itemid = 50361, itemlink = "\124cffa335ee\124Hitem:50361:0:0:0:0:0:0:0:0\124h[Sindragosa's Flawless Fang]\124h\124r", icon = "Interface\\Icons\\inv_jewelry_trinket_06"},                         
		[71638] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 71638, cd = 60, spec = true, item = true, itemidline = 9, sortname = "SFF Heroic", itemid = 50364, itemlink = "\124cffa335ee\124Hitem:50364:0:0:0:0:0:0:0:0\124h[Sindragosa's Flawless Fang]\124h\124r", icon = "Interface\\Icons\\inv_jewelry_trinket_06"},   						 
		[71586] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 71586, cd = 120, spec = true, item = true, itemidline = 8, sortname = "Skeleton Key", itemid = 50356, itemlink = "\124cffa335ee\124Hitem:50356:0:0:0:0:0:0:0:0\124h[Corroded Skeleton Key]\124h\124r", icon = "Interface\\Icons\\inv_misc_key_15"},   						 		 
		[67753] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 67753, cd = 180, spec = true, item = true, itemidline = 9, sortname = "Sat/Jug Heroic", itemid = 47088, itemid2 = 47451, itemlink = SJH, icon = "Interface\\Icons\\inv_scarab_crystal"},   						 	 
		[67699] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 67699, cd = 180, spec = true, item = true, itemidline = 8, sortname = "Sat/Jug Normal", itemid = 47080, itemid2 = 47290, itemlink = SJN, icon = "Interface\\Icons\\inv_scarab_crystal"},   						 	 
		[23133] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 23133, cd = 1200, spec = true, item = true, sortname = "Battle Chicken", itemid = 10725, itemlink = "\124cffffffff\124Hitem:10725:0:0:0:0:0:0:0:0\124h[Gnomish Battle Chicken]\124h\124r"},   						 		 
		[54861] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 54861, cd = 180, spec = true, item = true, sortname = "Nitro Boosts", itemid = 41118, itemlink = "\124cff71d5ff\124Hspell:55004\124h[Nitro Boosts]\124h\124r"},   						 	
		["PvP Trinket"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 42292, cd = 120, spec = true, item = true, sortname = "PVP Trinket", itemid = pvptrinketitemlinkID, itemlink = pvptrinketitemlink, icon = "Interface\\Icons\\"..pvptrinketiconlink},   						 	
	
		[30486] = {ExpacHide = {[0] = true, [1] = false, [2] = true}, id = 30486, cd = 300, spec = true, item = true, sortname = "Super Sapper Charge", itemid = 23827, itemlink = "\124cffffffff\124Hitem:23827:0:0:0:0:0:0:0:0\124h[Super Sapper Charge]\124h\124r"},   						 	
		[19821] = {ExpacHide = {[0] = true, [1] = false, [2] = true}, id = 19821, cd = 60, spec = true, item = true, sortname = "Arcane Bomb", itemid = 16040, itemlink = "\124cffffffff\124Hitem:16040:0:0:0:0:0:0:0:0\124h[Arcane Bomb]\124h\124r"},  				 	

	},
	["RACIALS"] = {
		[GetSpellInfo(26297)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 26297, cd = 180, spec = true},            				 			 -- Berserking
		[GetSpellInfo(20594)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 20594, cd = 120, spec = true},            							 -- Stoneform
		[GetSpellInfo(33702)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 33702, cd = 120, spec = true},            				 			 -- Blood Fury
		[GetSpellInfo(28730)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 28730, cd = 120, spec = true},            				 			 -- Arcane Torrent 
		[GetSpellInfo(20549)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 20549, cd = 120, spec = true},            				 			 -- War Stomp 
		[GetSpellInfo(20589)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 20589, cd = 105, spec = true},            				 			 -- Escape Artist
		[GetSpellInfo(59752)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 59752, cd = 120, spec = true},            				 			 -- EveryMan  
		[GetSpellInfo(20577)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 20577, cd = 120, spec = true},            				 			 -- Cannibalize 
		[GetSpellInfo(58984)] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 58984, cd = 120, spec = true},            				 			 -- Shadowmeld  
	},
	["CONSUMABLES"] = {
		[53908] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 53908, cd = 60, spec = true, itemid = 40211, sortname = "Potion of Speed", itemlink = "\124cffffffff\124Hitem:40211:0:0:0:0:0:0:0:0\124h[Potion of Speed]\124h\124r"},   						-- speed pot
		[53909] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 53909, cd = 60, spec = true, itemid = 40212, sortname = "Potion of Wild Magic", itemlink = "\124cffffffff\124Hitem:40212:0:0:0:0:0:0:0:0\124h[Potion of Wild Magic]\124h\124r"},   					-- wild magic pot
		[53762] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 53762, cd = 60, spec = true, itemid = 40093, sortname = "Indestructible Potion", itemlink = "\124cffffffff\124Hitem:40093:0:0:0:0:0:0:0:0\124h[Indestructible Potion]\124h\124r"},   					-- Indestructible pot
		[56350] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 56350, cd = 60, spec = true, itemid = 41119 , sortname = "Saronite Bomb", itemlink = "\124cffffffff\124Hitem:41119:0:0:0:0:0:0:0:0\124h[Saronite Bomb]\124h\124r", icon = "Interface\\Icons\\inv_misc_enggizmos_32"},   						 	-- Saronite Bomb
		[56488] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 56488, cd = 300, spec = true, itemid = 42641, sortname = "Global Thermal Sapper Charge", itemlink = "\124cffffffff\124Hitem:42641:0:0:0:0:0:0:0:0\124h[Global Thermal Sapper Charge]\124h\124r", icon = "Interface\\Icons\\inv_gizmo_supersappercharge"},   			-- Global Thermal Sapper Charge
		[35476] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 35476, cd = 120, spec = true, itemid = 29529, sortname = "Drums of Battle", itemlink = "\124cff1eff00\124Hitem:29529:0:0:0:0:0:0:0:0\124h[Drums of Battle]\124h\124r"},   						-- Drums of Battle
		[35477] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 35477, cd = 120, spec = true, itemid = 29530, sortname = "Drums of Speed", itemlink = "\124cff1eff00\124Hitem:29530:0:0:0:0:0:0:0:0\124h[Drums of Speed]\124h\124r" },   						-- Drums of Speed
		[28494] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 28494, cd = 60, spec = true, itemid = 22828, sortname = "Insane Strength Potion", itemlink = "\124cffffffff\124Hitem:22828:0:0:0:0:0:0:0:0\124h[Insane Strength Potion]\124h\124r"},   					-- Insane Strength Potion
		[2379] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 2379, cd = 60, spec = true, itemid = 2459, sortname = "Swiftness Potion", itemlink = "\124cffffffff\124Hitem:2459:0:0:0:0:0:0:0:0\124h[Swiftness Potion]\124h\124r", icon = "Interface\\Icons\\inv_potion_95" },   							-- Swiftness Potion
		[28714] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 28714, cd = 180, spec = true, itemid = 22788, sortname = "Flame Cap", itemlink = "\124cffffffff\124Hitem:22788:0:0:0:0:0:0:0:0\124h[Flame Cap]\124h\124r"},   						 		-- Flame Cap
	},
	["Tank Only Cooldowns"] = { 
		["Hand of Salvation"] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 99982, realid = 1038, cd = 120, spec = true, sortname = "Glyph of Salvation", icon = "Interface\\Icons\\Spell_Holy_SealOfSalvation"  },        -- Glyph of Salvation
		["Divine Protection"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99975, realid = 498, cd = 120, spec = true, icon = "Interface\\Icons\\Spell_Holy_Restoration" },          		-- Divine Protection
		["Divine Sacrifice"] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 99974, talent = true, realid = 64205 ,cd = 120, spec = true, icon = "Interface\\Icons\\spell_holy_powerwordbarrier" },          			-- Divine Sacrifice
		["Icebound Fortitude"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99973, realid = 48792,cd = 120, spec = true, icon = "Interface\\Icons\\Spell_DeathKnight_IceBoundFortitude" },          		-- Icebound Fortitude
		["Anti-Magic Shell"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99972, realid = 48707,cd = 45, spec = true, icon = "Interface\\Icons\\Spell_Shadow_AntiMagicShell" },          			-- Anti-Magic Shell
		["Barkskin"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99971, realid = 22812,cd = 60, spec = true, icon = "Interface\\Icons\\Spell_Nature_StoneClawTotem"},          					-- Barkskin
		["Last Stand"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99970, realid = 12975 ,cd = 180, spec = true, icon= "Interface\\Icons\\Spell_Holy_AshesToAshes" },          				-- Last Stand
		["Shield Wall"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99969, realid = 871,cd = 300, spec = true, icon = "Interface\\Icons\\Ability_Warrior_ShieldWall" },          				-- Shield Wall
		["Death Grip"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99968, realid = 49576,cd = 35, spec = true, icon = "Interface\\Icons\\Spell_DeathKnight_Strangulate"  },          				-- Death Grip
		["Army of the Dead"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99903, realid = 42650 ,cd = 600, spec = true, icon = "Interface\\Icons\\Spell_DeathKnight_ArmyOfTheDead"},          			-- Army of the dead
		["Blood Tap"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99935, realid = 45529,cd = 60, spec = true, icon = "Interface\\Icons\\Spell_DeathKnight_BloodTap"  },          					-- Blood Tap
	},
	["OTHER BARS"] = {
		[69766] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 69766, cd = 5, spec = true, sort = 1, sortname = "Backlash Bars", desc = "Shows Bars for Backlash Debuff on Sindragosa.\n\nNote: the bars will still show even if the person removes the debuff with bubble, ice block or via any other means.\n\nBacklash Reporter is more accurate"},		-- Shows Bars for Backlash Debuff on Sindragosa
		[72143] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 72143, cd = 5, spec = true, sort = 2, sortname = "Shambling Enrage", desc = "Shows Bars for Shambling Enrage"},			-- Shows Bars for Shambling Enrage
		[70337] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 70337, cd = 5, spec = true, sort = 3, sortname = "Necrotic Plague", desc = "Shows Bars for Nercotic Plague"},				-- Shows Bars for Nercotic Plague
		[69037] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 69037, icon = "Interface\\Icons\\ability_druid_flightform", cd = 15, spec = true, sort = 4, sortname = "Valk Grabbed", desc = "Shows Bars for who is Grabbed by Valks\n\nNote: Icons may not always be correct if there is less than 3 showing"},				-- Shows Bars for Valk Grabbed
		[99038] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99038, proc = true, icon = "Interface\\Icons\\inv_axe_113", cd = 5, spec = true, sort = 5, sortname = "Loot Timers", desc = "Shows Bars for tradeable BOP loot"},				-- Shows Bars for Loot Timers
	},
	["ITEM PROC"] = {
		["INVTYPE_HAND"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = "INVTYPE_HAND", proc = true, cd = 5, spec = true, sort = 1, icon = "Interface\\Icons\\Spell_Holy_SealOfSalvation", sortname = "Gloves", desc = "Shows Bars for Procs from Gloves"},
		["INVTYPE_FINGER"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = "INVTYPE_FINGER", proc = true, cd = 5, spec = true, sort = 1, icon = "Interface\\Icons\\Spell_Holy_SealOfSalvation", sortname = "Rings", desc = "Shows Bars for Procs from Rings"},
		["INVTYPE_TRINKET"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = "INVTYPE_TRINKET", proc = true, cd = 5, spec = true, sort = 1, icon = "Interface\\Icons\\Spell_Holy_SealOfSalvation", sortname = "Trinkets", desc = "Shows Bars for Procs from Trinkets"},
		["INVTYPE_WEAPON"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = "INVTYPE_WEAPON", proc = true, cd = 5, spec = true, sort = 1, icon = "Interface\\Icons\\Spell_Holy_SealOfSalvation", sortname = "Weapons", desc = "Shows Bars for Procs from Weapons"},
		["INVTYPE_CLOAK"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = "INVTYPE_CLOAK", proc = true, cd = 5, spec = true, sort = 1, icon = "Interface\\Icons\\Spell_Holy_SealOfSalvation", sortname = "Cloaks", desc = "Shows Bars for Procs from Cloaks"},
	},	
} 

FatCooldowns.classOrder = {
	["DRUID"] = 1,
	["PRIEST"] = 2,
	["SHAMAN"] = 3,
	["DEATHKNIGHT"] = 4,
	["HUNTER"] = 5,
	["MAGE"] = 6,
	["ROGUE"] = 7,
	["WARLOCK"] = 8,
	["WARRIOR"] = 9,
	["PALADIN"] = 10,
	["ITEMS"] = 11,
	["RACIALS"] = 12,
	["Tank Only Cooldowns"] = 13,
	["CONSUMABLES"] = 14,
	["OTHER BARS"] = 15,
	["ITEM PROC"] = 16,
}

local reporter = {
	["OTHER"] = {
		["Disable AntiSpam For |cffFFF468Chat Reporter|r tab"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99980, sort = 1, desc = "Disables the build in anti-spam. The built in anti-spam checks if your raid leader have FCD and then blocks your reporting."},  	
		["|cffFFF468Chat Reporter|r Prints to Self"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99877, sort = 1.5, desc = "makes most of the (Chat Reporter) options report to self and not the raid"},  

		["Header1"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99876, sort = 1.9, desc = "EXTRA"},  															

		["Personal Dispels (Self)"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99977, sort = 2, desc = "Sends a message to yourself with a link to the spell your dispelled.", icon = "|TInterface\\Icons\\spell_holy_dispelmagic:24:24:0:0:64:64:6:58:6:58|t "}, 		
		["Remove Ignored Players"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99802, sort = 3, desc = "Removes clears your ignore list when you relog or reload ui", icon = "|TInterface\\AddOns\\FatCooldowns\\icons\\Remove:24:24|t "},  															
		["Add Aura Info"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99892, sort = 4,desc = "adds the aura source and some talent/glyph info to the tooltip", icon = "|TInterface\\AddOns\\FatCooldowns\\icons\\Aura:24:24|t "},  															
		["Restock Reagents"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99891, sort = 5,desc = "Auto buys reagents for druid, mage, paladin, priest, rogue(instant and deadly)", icon = "|TInterface\\AddOns\\FatCooldowns\\icons\\Coin:24:24|t "},  															
		["Auto Ready Check"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99890, sort = 6,desc = "Auto clicks yes to ready checks when your not AFK, DND or holding down a modifier key", icon = "|TInterface\\AddOns\\FatCooldowns\\icons\\Ready:24:24|t "},  															
		["Auto Ready Check Delay"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99790, sort = 6,desc = "Same as Auto Ready Check but this has a 3 sec delay", icon = "|TInterface\\AddOns\\FatCooldowns\\icons\\Ready:24:24|t "},  															
		["Auto Repair"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99889, sort = 7,desc = "Auto repairs armor from guild then youself when you open a merchant window", icon = "|TInterface\\Icons\\trade_blacksmithing:24:24:0:0:64:64:6:58:6:58|t "},  															
		["LDW: Delete Failed Quest"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99872, sort = 7.3, desc = "Auto Delete Failed LDW Quest", icon = "|TInterface\\AddOns\\FatCooldowns\\icons\\Quest:24:24|t "},  															
		["Gunship: Auto Equip Rocket"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99856, sort = 7.4, desc = "Auto Equip Goblin Rocket Pack for Gunship in ICC.", icon = "|TInterface\\Icons\\ability_mount_rocketmount:24:24:0:0:64:64:6:58:6:58|t "},  															
		["Auto Gossip"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 98878, sort = 7.45, desc = "Auto select when there is only 1 gossip option for NPC's E.G. when to go to the bank in Org/SW\n\nNote: Hold Shift will disable.", icon = "|TInterface\\AddOns\\FatCooldowns\\icons\\Gossip:24:24|t "},  															
		["Aspect of the Pack"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 98876, sort = 7.49, desc = "Reports in Party/Raid Chat when you get daze debuff with Aspect of the Pack", icon = "|TInterface\\Icons\\ability_mount_whitetiger:24:24:0:0:64:64:6:58:6:58|t "},  															
		["Chat Bubble Icons"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 98875, sort = 7.499, desc = "Changes chat bubbles to show the icons intead of {rt1} or {Skull}\n\nNote: Does not work with prat", icon = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:24:24|t "},  															

		["Header2"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 98880, sort = 7.5,desc = "REMOVAL"},  															

		["Auto Remove Wisp Costume"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99886, sort = 8,desc = "Auto removes Wisp Costume", icon = "|TInterface\\Icons\\spell_nature_wispsplode:24:24:0:0:64:64:6:58:6:58|t "},  	
		["Melee: Remove HOP"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99893, sort = 9,desc = "Auto removes HOP when your a melee in a boss fight", icon = "|TInterface\\Icons\\spell_holy_sealofprotection:24:24:0:0:64:64:6:58:6:58|t "},  															
		["Tank: Remove HOP"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99885, sort = 10,desc = "Auto removes HOP when your a tank in a boss fight", icon = "|TInterface\\Icons\\spell_holy_sealofprotection:24:24:0:0:64:64:6:58:6:58|t "},  																									
		["Tank: Remove Bubble"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99864, sort = 10,desc = "Auto removes Bubble when your a tank in a boss fight", icon = "|TInterface\\Icons\\spell_holy_divineintervention:24:24:0:0:64:64:6:58:6:58|t "},  																									
		["LDW: Weapon Management"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99805, sort = 11,desc = "Auto Remove and Re-Equip weapons for LDW.\n\nNote: works for MDPS and hunter's. You will need 3 bags slots free and 1 Equipment Manager slot free\n\nWarning: /equip in macro's may equip weapons after the addon removes them, its best to not to use /equip macro", icon = "|TInterface\\Icons\\ability_dualwield:24:24:0:0:64:64:6:58:6:58|t "},
		["BPC: Cancel Soul Fragment"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99976, sort = 12,desc = "Auto cancels Soul fragment from shadowmourne, only on kele and when over 5 stacks.", icon = "|TInterface\\Icons\\inv_axe_113:24:24:0:0:64:64:6:58:6:58|t "}, 
		["BQL: Remove Salv"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99800, sort = 13,desc = "Removes Salv when BQL is above 90% hp to stop trolls.", icon = "|TInterface\\Icons\\spell_holy_sealofsalvation:24:24:0:0:64:64:6:58:6:58|t "},  															
		["LDW: Remove Buffs/Procs on MC"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99894, sort = 14,desc = "Auto removes buffs and procs when you get MCed", icon = "|TInterface\\Icons\\spell_shadow_shadowworddominate:24:24:0:0:64:64:6:58:6:58|t "},  															
		
		["Header4"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 98882, sort = 14.5,desc = "CLASS SPECIFIC"},  															

		["Warrior: Remove bubbles"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99986, sort = 15,desc = "Warrior: Remove Priest and Paladin shields for LK phase 1 and 2 for Enrage buff", icon = "|TInterface\\Icons\\spell_holy_powerwordshield:24:24:0:0:64:64:6:58:6:58|t "}, 	
		["Boomkin: Remove bubbles"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99983, sort = 16,desc = "Boomkin: Remove Priest and Paladin shields for LK phase 1 and 2 for Enrage buff", icon = "|TInterface\\Icons\\spell_holy_powerwordshield:24:24:0:0:64:64:6:58:6:58|t "},  															
		["Paladin: Remove Chaos Bane"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99801, sort = 17,desc = "Removes Chaos Bane buff from Shadowmourne", icon = "|TInterface\\Icons\\spell_shadow_chilltouch:24:24:0:0:64:64:6:58:6:58|t "},  															
		["Warrior: Weapon Management"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99806, sort = 18,desc = "Auto Equip Weapons when you go into Berserker Stance\n\nNote: you will need to create a Equipment Manager slot called FCDFury", icon = "|TInterface\\Icons\\ability_warrior_innerrage:24:24:0:0:64:64:6:58:6:58|t "},  															
		["Rogue: Remove ToT Proc on DPS"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99879, sort = 19,desc = "Auto removes the threat transfer when ToT is used on a DPS\n\nNote: Does not remove the damage buff, does not remove when used on a rogue", icon = "|TInterface\\Icons\\ability_rogue_tricksofthetrade:24:24:0:0:64:64:6:58:6:58|t "},  
		["Rogue: Remove ToT Proc on Rogue"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 98879, sort = 20,desc = "Auto removes the threat transfer when ToT is used on a rogue\n\nNote: requires Rogue: Remove ToT Proc on DPS", icon = "|TInterface\\Icons\\ability_rogue_tricksofthetrade:24:24:0:0:64:64:6:58:6:58|t "},  

		--["Header5"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 98883, sort = 19.5, desc = ""},  															

		["Warlock: Max Soul Shards"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99804, max = 32, sort = 21, desc = "Auto Deletes Soul Shards above this number.\n\nNote: 0 = Disabled, Only works when your incombat", icon = "|TInterface\\Icons\\inv_misc_gem_amethyst_02:24:24:0:0:64:64:6:58:6:58|t "},
		["Paladin: Aura Mastery"] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 99803, sort = 22, desc = "Select how you would like to display the aura type the paladin had when aura mastery was used", icon = "|TInterface\\Icons\\spell_holy_auramastery:24:24:0:0:64:64:6:58:6:58|t "},
	},
	["ITEMS"] = {
		["Fish Feast"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99987, cd = 2,  desc = "Sends a message to raid chat when someone has clicked the fish fest for thee selected amount.\n\nNote: 0 means this is disabled", icon = "|TInterface\\Icons\\inv_misc_fish_52:24:24:0:0:64:64:6:58:6:58|t "}, 																
		["Direbrew's Remote"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 49844, cd = 3600,  desc = "Sends a message to raid chat when someone used Direbrew Remote.", icon = "|TInterface\\Icons\\inv_gizmo_goblingtonkcontroller:24:24:0:0:64:64:6:58:6:58|t "},    																			
		["Ectoplasmic Distiller"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 27433, cd = 3600,  desc = "Sends a message to raid chat when someone used Ectoplasmic Distiller.", icon = "|TInterface\\Icons\\inv_misc_enggizmos_essencedistiller:24:24:0:0:64:64:6:58:6:58|t "},    																
		["Baby Spice"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99996, desc = "Sends a message to raid chat when someone has used Baby Spice on the boss.", icon = "|TInterface\\Icons\\inv_misc_powder_green:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Infernal Spear"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 98985, desc = "Sends a message to raid chat when someone loots Infernal Spear from the valk in ICC.", icon = "|TInterface\\Icons\\inv_weapon_halberd18:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Crashin' Thrashin' Racer Controller"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 98934, desc = "Sends a message to raid chat when someone creates Crashin' Thrashin' Racer Controller.", icon = "|TInterface\\Icons\\inv_gizmo_goblingtonkcontroller:24:24:0:0:64:64:6:58:6:58|t "}, 																		
	},
	["PORTALS"] = {
		["Portal: Dalaran"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 98999, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portaldalaran:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Portal: Darnassus"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, side = "A", id = 98998, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portaldarnassus:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Portal: Exodar"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, side = "A", id = 98997, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portalexodar:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Portal: Ironforge"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, side = "A", id = 98996, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portalironforge:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Portal: Stormwind"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, side = "A", id = 98995, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portalstormwind:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Portal: Orgrimmar"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, side = "H", id = 98994, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portalorgrimmar:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Portal: Silvermoon"] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, side = "H", id = 98993, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portalsilvermoon:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Portal: Thunder Bluff"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, side = "H", id = 98992, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portalthunderbluff:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Portal: Undercity"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, side = "H", id = 98991, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portalundercity:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Portal: Theramore"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, side = "A", id = 98989, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portaltheramore:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Portal: Stonard"] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, side = "H", id = 98988, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portalstonard:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Portal: Shattrath"] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, side = "A", id = 98987, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portalshattrath:24:24:0:0:64:64:6:58:6:58|t "}, 																		
		["Portal: Shattrath"] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, side = "H", id = 98986, desc = "Sends a message to raid chat when someone is casting a portal.", icon = "|TInterface\\Icons\\spell_arcane_portalshattrath:24:24:0:0:64:64:6:58:6:58|t "}, 																		
	},
	["MULTIPLE BOSSES"] = {
		["Whoring And Useless Damage"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99999, desc = "Sends a message to raid chat when someone is whoring or does unless damage.", icon = "|TInterface\\Icons\\ability_warrior_cleave:24:24:0:0:64:64:6:58:6:58|t "}, 														 
		["5 Sunderss"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99964, desc = "Sends a message to raid chat when the 1st 5 sunders are up listing the people who cast sunder 25m only", icon = "|TInterface\\Icons\\ability_warrior_sunder:24:24:0:0:64:64:6:58:6:58|t "}, 														
		["Windfury Totem When FDK in raid"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99884, desc = "Sends a message to raid chat a shaman uses windfury totem when you have a frost death knight in the raid", icon = "|TInterface\\Icons\\spell_nature_windfury:24:24:0:0:64:64:6:58:6:58|t "}, 														
		["Strength of Earth Totem When no Stoneskin Totem in raid"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99863, desc = "Sends a message to raid chat a shaman uses Strength of the Earth Totem when you have do not have a Stoneskin in the raid\n\nNote: Ignoes Enhancement Totems", icon = "|TInterface\\Icons\\spell_nature_earthbindtotem:24:24:0:0:64:64:6:58:6:58|t "}, 														
		["Expose Armor"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99857, desc = "Sends a message to raid chat a a Rogue uses Expose Armor in a boss fight 25m only", icon = "|TInterface\\Icons\\ability_warrior_riposte:24:24:0:0:64:64:6:58:6:58|t "}, 														
	},
	["BPC AND BQL"] = {
		["BPC: EMP Shock Tanks"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99988, desc = "Sends a message to raid chat when someone knocks the tanks at BPC with Emp shock.", icon = "|TInterface\\Icons\\spell_nature_earthbind:24:24:0:0:64:64:6:58:6:58|t "}, 														
		["BPC: EMP Shock Healers"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99895, desc = "Sends a message to raid chat when someone knocks the healers at BPC with Emp shock.", icon = "|TInterface\\Icons\\spell_nature_earthbind:24:24:0:0:64:64:6:58:6:58|t "}, 														
		["BPC: EMP Shock Self"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99896, desc = "Sends a message to self chat when someone knocks you at BPC with Emp shock.", icon = "|TInterface\\Icons\\spell_nature_earthbind:24:24:0:0:64:64:6:58:6:58|t "}, 														
		["BQL: Who Bites Who"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99993, desc = "Sends a message to raid chat when one raid member bites another raid member at Blood-Queen Lana'thel.", icon = "|TInterface\\Icons\\ability_warlock_improvedsoulleech:24:24:0:0:64:64:6:58:6:58|t "}, 														 
		["BQL: Who Fails Bites"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99992, desc = "Sends a message to raid chat when someone fails to bite at Blood-Queen Lana'thel.", icon = "|TInterface\\Icons\\ability_warlock_improvedsoulleech:24:24:0:0:64:64:6:58:6:58|t "}, 																
		["BQL: Stealing Bite"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99995, desc = "Sends a message to raid chat when someone is trying to steal the bite on Blood-Queen Lana'thel e.g. Righteous Fury.", icon = "|TInterface\\Icons\\ability_warlock_improvedsoulleech:24:24:0:0:64:64:6:58:6:58|t "}, 				
		["BPC: EMP Flames"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99967, desc = "Sends a message to raid chat when someone is targeted by the Empowered Flames on BPC", icon = "|TInterface\\Icons\\spell_fire_sealoffire:24:24:0:0:64:64:6:58:6:58|t "}, 
		["BPC: Pet Charge Kinetic"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99883, desc = "Sends a message to raid chat when a pet charges Kinetic", icon = "|TInterface\\Icons\\ability_hunter_pet_bear:24:24:0:0:64:64:6:58:6:58|t "}, 
	},
	["OTHER BOSSES"] = {
		["PP: Incorrect Ooze Damage"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99997, desc = "Sends a message to raid chat when someone dealt damage the Incorrect Ooze on Professor Putricide.", icon = "|TInterface\\Icons\\inv_inscription_inkgreen03:24:24:0:0:64:64:6:58:6:58|t "},    															
		["PP: Red Ooze"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99902, desc = "Sends a message to raid chat when someone has been hit by PP's Red Ooze.", icon = "|TInterface\\Icons\\spell_holiday_tow_spicecloud:24:24:0:0:64:64:6:58:6:58|t "}, 																				
		["Festergut: Vile Gas"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99965, desc = "Sends a message to raid chat when people are effected by vile gas, includes list of people that didnt spread 25m only", icon = "|TInterface\\Icons\\ability_creature_cursed_01:24:24:0:0:64:64:6:58:6:58|t "}, 														
		["Sindra HC: Backlash"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99998, desc = "Sends a message to raid chat when someone drops stacks on Sindragosa.\n\nNote: Name Time(does not show if 0s) Stacks and NextPerson(if drop at same time)", icon = "|TInterface\\Icons\\spell_arcane_arcanetorrent:24:24:0:0:64:64:6:58:6:58|t "},    																
		["LDW: Vengeful Shade"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99901, desc = "Sends a message to raid chat when someone has been hit by Lady Deathwhisper Spirits.", icon = "|TInterface\\Icons\\spell_shadow_deathsembrace:24:24:0:0:64:64:6:58:6:58|t "}, 			 											
		["RS: Dispels with timer"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99991, desc = "Sends a message to raid chat when someone dispels the debuff in RS, this includes bubble, ice block and cloak.", icon = "|TInterface\\Icons\\spell_shadow_soulleech_3:24:24:0:0:64:64:6:58:6:58|t "}, 																				
		["Dreamwalker Stacks"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 98984, desc = "Sends a message to raid chat when someone loses there healing stacks.", icon = "|TInterface\\Icons\\spell_nature_wispsplodegreen:24:24:0:0:64:64:6:58:6:58|t "}, 																				
	},
	["THE LICH KING"] = {
		["Piercing Howl's"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99966, desc = "Sends a message to raid chat after the fight listing the amount of piercing howls each warr has done 25m only", icon = "|TInterface\\Icons\\spell_shadow_deathscream:24:24:0:0:64:64:6:58:6:58|t "}, 														
		["Missing CotE/FF"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99962, desc = "Sends a message to raid chat when there is no Curse of the Elements/Faerie Fire on LK for transition phase. 25m only", icon = "|TInterface\\Icons\\spell_nature_faeriefire:24:24:0:0:64:64:6:58:6:58|t "}, 														
		["Valk Single Target Whoring"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99994, desc = "Sends a message to raid chat when someone has dealt damage to a Valk below 47% hp.", icon = "|TInterface\\Icons\\ability_druid_flightform:24:24:0:0:64:64:6:58:6:58|t "}, 																			
		["Necrotic Plague Dispel and Jump"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99961, desc = "Sends a message to raid chat when someone dispels Nercotic Plague and list what raid member it may have jumped to.", icon = "|TInterface\\Icons\\ability_creature_disease_02:24:24:0:0:64:64:6:58:6:58|t "}, 																			
	},
	["PARRY REPORTER"] = {
		["Sindra HC"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99985, desc = "Sends a message to raid chat when someone parrys the boss, includes the bosses target.", icon = "|TInterface\\Icons\\ability_parry:24:24:0:0:64:64:6:58:6:58|t "}, 					
		["Halion HC"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99984, desc = "Sends a message to raid chat when someone parrys the boss, includes the bosses target.", icon = "|TInterface\\Icons\\ability_parry:24:24:0:0:64:64:6:58:6:58|t "}, 				
		["Self Reporter"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99874, desc = "Makes Parry reporting for (Sindra HC and Halion HC) go to self instead of raid chat", icon = "|TInterface\\Icons\\ability_parry:24:24:0:0:64:64:6:58:6:58|t "}, 				
		["ParryCounter: Sindra"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99888, desc = "Sends a message to raid chat after the fight is over with the total parrys counted.\n\nNote: Parrys from pets or if the boss does not have a target are not counted", icon = "|TInterface\\Icons\\ability_parry:24:24:0:0:64:64:6:58:6:58|t "}, 				
		["ParryCounter: Halion(P1)"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99880, desc = "Sends a message to raid chat after the fight is over with the total parrys counted.\n\nNote: Pets are counted as there owner", icon = "|TInterface\\Icons\\ability_parry:24:24:0:0:64:64:6:58:6:58|t "}, 				
		["ParryCounter: Halion(P2)"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99881, desc = "Sends a message to raid chat after the fight is over with the total parrys counted.\n\nNote: Pets are counted as there owner", icon = "|TInterface\\Icons\\ability_parry:24:24:0:0:64:64:6:58:6:58|t "}, 				
		["ParryCounter: Halion(P3)"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99882, desc = "Sends a message to raid chat after the fight is over with the total parrys counted.\n\nNote: Pets are counted as there owner", icon = "|TInterface\\Icons\\ability_parry:24:24:0:0:64:64:6:58:6:58|t "}, 				
		["PARRY HASTED attacks from Halion"] = {ExpacHide = {[0] = true, [1] = false, [2] = false}, id = 99960, desc = "Sends a message to raid chat when the boss has done a successful parry haste attack (1.25 sec time difference between).", icon = "|TInterface\\Icons\\ability_parry:24:24:0:0:64:64:6:58:6:58|t "}, 				
	},
	["SOUND AND SAY"] = {
		["Healer Grabbed Sound"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99990, desc = "Plays a message when a healer is grabbed by a Valk at LK.", icon = "|TInterface\\Icons\\inv_misc_horn_03:24:24:0:0:64:64:6:58:6:58|t "}, 					
		["Healer Grabbed Say"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99989, desc = "Sends a message to say chat when a healer is grabbed by a Valk at LK.", icon = "|TInterface\\AddOns\\FatCooldowns\\icons\\Text:24:24|t "},  
		["Healer Grabbed Say With Icons"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 98874, desc = "Sends a message to say chat when a healer is grabbed by a Valk at LK.", icon = "|TInterface\\AddOns\\FatCooldowns\\icons\\Text:24:24|t "},  
		["RS Stop Damage Sound"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99979, desc = "Plays a message when you are at 70%/30% in RS.", icon = "|TInterface\\Icons\\inv_misc_horn_03:24:24:0:0:64:64:6:58:6:58|t "},							
		["RS Stop Damage Say"] = {ExpacHide = {[0] = true, [1] = true, [2] = false}, id = 99978, desc = "Sends a message to say chat when you are at 70%/30% in RS.", icon = "|TInterface\\AddOns\\FatCooldowns\\icons\\Text:24:24|t "},  
		["Ask for Innervate Say"] = {ExpacHide = {[0] = false, [1] = false, [2] = false}, id = 99963, desc = "Sends a message to say chat when your low on mana as a healer.\n\nNote: boss needs to be above 15% hp, you need to be below 20% mana. cd 1min.\n\nHealers only", icon = "|TInterface\\AddOns\\FatCooldowns\\icons\\Text:24:24|t "},  			
	},
}

local chatfilter = {
	["CHAT FILTER - Deaths"] = {
		["Details Death Spam"] = { id = 99949, desc = "Blocks Details Deaths from raid chat."},														
		["Fatality"] = { id = 99952, desc = "Blocks Fatality from raid chat."}, 																
		["RBS Deaths Spam"] = { id = 99946, desc = "Blocks RBS Deaths from raid chat."}, 									
		["Skada Death Spam"] = { id = 99981, desc = "Blocks Skada Deaths from raid chat."}, 									
	},
	["CHAT FILTER - Other"] = {
		["Warmane System Spam"] = { id = 99950, desc = "Blocks the green system messages from warmane.\n\nbeware of phishing scams offering...\nplayers can now trade their characters on our website..."},  												
		["Orcish and Common"] = { id = 99956, desc = "Blocks Orcish and Common from say and yell (very nice for dalaran).\n\n[Common] BOR Se DAna Ras Lo Ruff Nagan ve E E Hir Far eynes vassild SE SE\n[Orcish] AAZ GOLAR N ZAGA GESH A ZAGA TAGO KIL GI A GI Maza gi mog Uruk Maka KA"},							
		["Emblem Spam"] = { id = 99957, desc = "Blocks the spam you would normally get when people receive Emblems."},									
		["Icons Spam"] = { id = 99947, desc = "Blocks set icon message's from people who are not raid leader."}, 									
		["Icons PP"] = { id = 99873, desc = "Blocks set icon message's for Professor Putricide fight."}, 									
		["Imp in a Ball Spam"] = { id = 99921, desc = "Blocks party messages from the pet imp in a ball."}, 											
		["Whispers Spam"] = { id = 99920, desc = "Blocks whisper messages i.e.\n\nThanks for Spell\nSpell on you\nyou have no flask\nyou're out of range"}, 
	},
	["CHAT FILTER - Bubbles"] = {
		["Enable Bubbles Filters"] = { id = 99917, desc = "Enables Blocks bubbles and chat message."},  
		["Bubbles Only"] = { id = 99897, desc = "Blocks bubbles but not chat message for all bubbles filters."},  
		["Bubbles Shekles Spam List"] = { id = 99934, desc = "Blocks bubbles and chat message for specific messages some examples are\n\nHand Of Freedom cast on XXXX\nMalleables\ncyka bleat !\nDemonic language\nunbound plague on me!\n\nNote: i will not make a full list as its too long."}, 
		["Monster/NPC Bubbles"] = { id = 99916, desc = "Blocks bubbles and chat message for monster/NPC's\n\nNote: this requires Bubble Spam to be enabled and monster yell to be enabled in your chat settings.\n\nNote: To enable Monter Yell right click a chat window tab > Settings > Other > Creature Messages > Yell and SAY."}, 
		["Japanese, Chinese and Korean Bubbles"] = { id = 99915, desc = "Blocks Japanese, Chinese and Korean Bubbles.\n\nNote: this requires Bubble Spam to be enabled"}, 				
		["Russian Bubbles"] = { id = 99913, desc = "Blocks Russian Bubbles.\n\nNote: this requires Bubble Spam to be enabled"},  
		["Innervate Bubbles"] = { id = 99933, desc = "Blocks Bubbles and chat messages about Innervate when you are not on a druid and incombat"},  
		["Spanish Bubbles"] = { id = 99937, desc = "Blocks Spanish message that use unicode from chat and bubbles examples\n\nü\n¡\ná"},  
		["Unbound Plague"] = { id = 99938, desc = "Blocks Unbound Plague from chat and bubbles"},  
		["Demonic language"] = { id = 98938, desc = "Blocks Demonic language from warocks from chat and bubbles"},  
		["ElvUi ChatBubbles Style"] = { id = 99765, desc = "If you use ElvUi you will need to select your chat bubble style"},  
	},
	["CHAT FILTER - Raid"] = {
		["MPR"] = { id = 99951, desc = "Blocks MPR from raid chat."}, 																				
		["RankWatch"] = { id = 99936, desc = "Blocks RankWatch messages from raid chat"}, 																				
		["Warmane Custom DBM"] = { id = 99954, desc = "Blocks the custom DBM Messages from raid chat.\n\nGained_Instability\nInstability_Reset"}, 						
		["Parry Spam"] = { id = 99958, desc = "Blocks parry reporting messages from chat."},															
		["DBM Raid Chat Announce"] = { id = 99959, desc = "Blocks DBM from raid chat.\n\nFrost Beacon icon {skull} set on PlayerName"},											
		["Smart RaidBuff"] = { id = 99945, desc = "Blocks buff messages in chat from RaidBuffStatus that are not relevent for your class e.g. paladin buffs when your on a warrior"},				
		["PhoenixStyle and EnsidiaFails"] = { id = 99943, desc = "Blocks buff messages in chat from PhoenixStyle addon"},						
		["Flasks and Food Check Spam"] = { id = 99919, desc = "Blocks messages about flasks in raid chat.\n\nNote: does not block messages when your name is listed"},											
		["Japanese, Chinese and Korean"] = { id = 99914, desc = "Blocks Japanese, Chinese and Korean messages in raid chat."},									
		["Russian"] = { id = 99912, desc = "Blocks Japanese, Chinese and Korean messages in raid chat."},									
		["LK Announce"] = { id = 99908, desc = "Blocks LK Announce addon messages in raid chat.\n\nInfest #1 coming up!\n{Skull}Defile on melee PlayerName{Skull}\nShambling Horror 1 Frenzy in 10*s! Plague will kill it 5s later."},									
		["Achivment Fails"] = { id = 99904, desc = "Blocks raid chat messages about achivment fails."},									
		["Omen"] = { id = 99931, desc = "Blocks raid chat messages about Omen."},									
		["RaidWarning Shekles List"] = { id = 99878, desc = "Blocks raid warning messages (currently mostly LK Announce)"},									
		["RaidWarning receive/won loot"] = { id = 99858, desc = "Blocks raid warning messages about players receiveing loot (not bidding or rolling)\n\nNote: needs RaidWarning Shekles List enabled"},									
		["MRT Receive Loot Spam"] = { id = 99865, desc = "Blocks raid messages about player receiving loot"},									
		["Ensidia Fails"] = { id = 99862, desc = "Blocks raid messages from the addon Ensidia Fails"},									
		["Ready Messages"] = { id = 99859, desc = "Blocks raid messages about who is afk and ready"},									
	},
	["CHAT FILTER - Global"] = {
		["Buying/Selling"] = { id = 99871, desc = "Blocks messages from global chat"},									
		["Arena"] = { id = 99870, desc = "Blocks messages from global chat"},									
		["Guild"] = { id = 99869, desc = "Blocks messages from global chat"},									
		["None English"] = { id = 99868, desc = "Blocks messages from global chat"},									
		["Spam"] = { id = 99867, desc = "Blocks messages from global chat"},									
		["Tmog/Old Raids"] = { id = 99866, desc = "Blocks messages from global chat"},								
		["Same Messages"] = { id = 99766, desc = "Blocks duplicate messages on global chat from the same person for the set amount of seconds.\n\nNote: 0 = disabled"},								
	},
	["CHAT FILTER - Global Raids"] = {
		["Already Started Raids"] = { id = 99670, sort = 1, desc = "Blocks messages from global chat"},									
		["ICC 10 Low GS"] = { id = 99671, sort = 2, desc = "Blocks messages from global chat"},									
		["ICC 10 High GS"] = { id = 99672, sort = 3, desc = "Blocks messages from global chat"},									
		["ICC 25 Low GS"] = { id = 99673, sort = 4, desc = "Blocks messages from global chat"},									
		["ICC 25 High GS"] = { id = 99674, sort = 5, desc = "Blocks messages from global chat"},									
		["ICC Rep"] = { id = 99675, sort = 6, desc = "Blocks messages from global chat"},									
		["Naxx"] = { id = 99676, sort = 7, desc = "Blocks messages from global chat"},									
		["Onixya"] = { id = 99677, sort = 8, desc = "Blocks messages from global chat"},									
		["OS"] = { id = 99678, sort = 9, desc = "Blocks messages from global chat"},									
		["RS"] = { id = 99679, sort = 10, desc = "Blocks messages from global chat"},									
		["TOC 10 N"] = { id = 99680, sort = 11, desc = "Blocks messages from global chat"},									
		["TOC 10 HC"] = { id = 99681, sort = 12, desc = "Blocks messages from global chat"},									
		["TOC 25 N"] = { id = 99682, sort = 13, desc = "Blocks messages from global chat"},									
		["TOC 25 HC"] = { id = 99683, sort = 14, desc = "Blocks messages from global chat"},									
		["Ulduar"] = { id = 99684, sort = 15, desc = "Blocks messages from global chat"},									
		["VOA 10"] = { id = 99685, sort = 16, desc = "Blocks messages from global chat"},									
		["VOA 25"] = { id = 99686, sort = 17, desc = "Blocks messages from global chat"},									
	},
	["CHAT FILTER - RaidLoot"] = {								
		["Need"] = { id = 99940, desc = "Blocks raid chat messages for needing on loot when in a raid."},									
		["DE"] = { id = 99941, desc = "Blocks raid chat messages for DE on loot when in a raid."},									
		["Pass"] = { id = 99942, desc = "Blocks raid chat messages for Pass on loot when in a raid."},									
		["Greed"] = { id = 99939, desc = "Blocks raid chat messages for Greed on loot when in a raid."},									
		["Poor Loot"] = { id = 99898, desc = "Blocks raid chat messages for Poor loot when in a raid."},									
		["Gold"] = { id = 99849, desc = "Blocks raid chat messages about your share of the gold when in a raid."},									
	},
	["CHAT FILTER - GroupLoot"] = {								
		["Need"] = { id = 99850, desc = "Blocks chat messages for needing on loot."},									
		["DE"] = { id = 99851, desc = "Blocks chat messages for DE on loot."},									
		["Pass"] = { id = 99852, desc = "Blocks chat messages for Pass on loot."},									
		["Greed"] = { id = 99853, desc = "Blocks chat messages for Greed on loot."},									
		["Poor Loot"] = { id = 99854, desc = "Blocks chat messages for Poor loot."},	
		["Gold"] = { id = 99855, desc = "Blocks chat messages about your share of the gold."},																	
	},
	["CHAT FILTER - Spells"] = {
		["Spell is ready Spam"] = { id = 99948, desc = "Blocks reports when a spell is ready from raid chat.\n\nPlayerName's SpellName is ready"},										
		["Crybaby"] = { id = 99953, desc = "Blocks Crybaby from raid chat."}, 																		
		["*** And ###"] = { id = 99955, desc = "Blocks the addons that spam raid chat with message tthat start and end with *** or ###."}, 			
		["Flump Spam"] = { id = 99944, desc = "Blocks buff messages in chat from Flump addon e.g. \n\nPlayer used Spellink\nSpelllink faded from Player"},								
		["RSA Spam"] = { id = 99918, desc = "Blocks messages from the addon RSA e.g.\n\nAura Mastery Activated!\nAura Mastery Faded!"},									
		["WhoTaunted Spam"] = { id = 99911, desc = "Blocks WhoTaunted addon messages in raid chat."},									
		["BigBrother Spam"] = { id = 99910, desc = "Blocks BigBrother addon messages in raid chat.\n\nPlayerName cast SpellName"},									
		["Ress Spam"] = { id = 99909, desc = "Blocks ress messages in raid chat."},		
		["Custom Macros and Weakaurs"] = { id = 99907, desc = "Blocks Custom messages people have made in macros and weakaurs."},																
		["OptiTaunt"] = { id = 99905, desc = "Blocks messages from the addon OptiTaunt e.g.\n\n+++ SpellName activated (10s)+++\n--- SpellName ends ---\n>>> SpellName (5s) - STUNNED<<<"},	
		["Interrupt"] = { id = 99932, desc = "Blocks raid chat messages about Interrupts."},																								
		["Announce"] = { id = 99899, desc = "Blocks raid chat messages from the addon Announce"},																								
		["DoTimer"] = { id = 99861, desc = "Blocks raid chat messages from the addon DoTimer"},																								
		["Trainer"] = { id = 99860, desc = "Blocks chat messages about upgraded spells when you train, you will only see new spells"},																								
	},
	["CHAT FILTER - FCD"] = {
		["Vile Gas"] = { id = 99929, desc = "Blocks FCD Reporter message's about Vile Gas."},  												
		["BQL Bite"] = { id = 99928, desc = "Blocks FCD Reporter message's about BQL Bite."},  											
		["Incorrect Ooze Damage"] = { id = 99927, desc = "Blocks FCD Reporter message's about Incorrect Ooze Damage."},  									
		["Sindragosa Backlash"] = { id = 99926, desc = "Blocks FCD Reporter/Other addon reporting message's about Sindragosa Backlash."},  					
		["Whoring"] = { id = 99925, desc = "Blocks FCD Reporter/Other addon message's about Whoring, includes other whoring addon messages"},  												
		["Valk Single Target Whoring"] = { id = 99924, desc = "Blocks FCD Reporter message's about Single Target Whoring on Valks."},  											
		["RS Dispel"] = { id = 99923, desc = "Blocks FCD Reporter message's about RS Dispels."},  												
		["BPC Knocks"] = { id = 99922, desc = "Blocks FCD Reporter message's about BPC Knocks on Tank's."},  											
		["5 Sunders"] = { id = 99906, desc = "Blocks FCD Reporter message's about 5 Sunders."},  											
		["Halion Parry Hasted Attack"] = { id = 99887, desc = "Blocks FCD Reporter message's about parry hasted attacks from Halion"},  											
		["Nercotic Dispel"] = { id = 99930, desc = "Blocks FCD Reporter message's about Nercotic Dispel"},  	
		["ParryCounter"] = { id = 99875, desc = "Blocks FCD Reporter message's about ParryCounter"},  																					
	},
}

local AuraToItemID = {
	[64411] = 46017,					-- Val'anyr, Hammer of Ancient Kings
	[60065] = {44914, 40684, 49074},	-- Anvil of the Titans, Mirror of Truth, Coren's Chromium Coaster
	[60488] = 40373,					-- Extract of Necromatic Power
	[64713] = 45518,					-- Flare of the Heavens
	[60064] = {44912, 40682, 49706},	-- Flow of Knowledge, Sundial of the Exiled, Mithril Pocketwatch
	[67703]	= {47303, 47115},			-- Death's Choice, Death's Verdict (AGI)
	[67708]	= {47303, 47115},			-- Death's Choice, Death's Verdict (STR)
	[67772] = {47464, 47131},			-- Death's Choice, Death's Verdict (Heroic) (AGI)
	[67773] = {47464, 47131},			-- Death's Choice, Death's Verdict (Heroic) (STR)
	[72416] = {50398, 50397},			-- ICC Rep Ring
	[72412] = {50402, 50401},			-- ICC Rep Ring
	[72418] = {50399, 50400},			-- ICC Rep Ring
	[72414] = {50404, 50403},			-- ICC Rep Ring
	[75480] = 54591,					-- RS Tank Trinket
	[71485] = 50362,					-- Deathbringer's Will (Non-heroic)	
	[71492] = 50362,					-- Deathbringer's Will (Non-heroic)	
	[71486] = 50362,					-- Deathbringer's Will (Non-heroic)	
	[71484] = 50362,					-- Deathbringer's Will (Non-heroic)	
	[71491] = 50362,					-- Deathbringer's Will (Non-heroic)	
	[71487] = 50362,					-- Deathbringer's Will (Non-heroic)	
	[71556] = 50363,					-- Deathbringer's Will (Heroic)
	[71560] = 50363,					-- Deathbringer's Will (Heroic)
	[71558] = 50363,					-- Deathbringer's Will (Heroic)
	[71561] = 50363,					-- Deathbringer's Will (Heroic)
	[71559] = 50363,					-- Deathbringer's Will (Heroic)
	[71557] = 50363,					-- Deathbringer's Will (Heroic)
	[71403] = 50198,			-- Needle-Encrusted Scorpion
	[71610] = 50359,			-- Althor's Abacus
	[71633] = 50352,			-- Corpse-tongue coin
	[71601] = 50353,			-- Dislodged Foreign Object
	[71584] = 50358,			-- Purified Lunar Dust
	[71401] = 50342,			-- Whispering Fanged Skull
	[71541] = 50343,			-- Whispering Fanged Skull
	[71641] = 50366,			-- Althor's Abacus
	[71639] = 50349,			-- Corpse-tongue coin
	[71644] = 50348,			-- Dislodged Foreign Object
	[75456] = 54590,            -- Sharpened Twilight Scale HC
	[75458] = 54569,			-- Sharpened Twilight Scale NM
    [75473] = 54588,            -- Charred Twilight Scale
    [71636] = 50365,            -- Phylactery of the Nameless Lich
	[67671] = 47214,			-- Banner of Victory
	[67669] = 47213, 			-- Abyssal Rune 
	[64772] = 45609, 			-- Comet's Trail
	[65024] = 46038, 			-- Dark Matter
	[60443] = 40371,			-- Bandit's Insignia
	[64790] = 45522,			-- Blood of the Old God
	[60203] = 42990,			-- Darkmoon Card: Death
	[60494] = 40255,			-- Dying Curse
	[65004] = 65005,			-- Elemental Focus Stone
	[60492] = 39229,			-- Embrace of the Spider
	[60530] = 40258,			-- Forethought Talisman
	[60437] = 40256,			-- Grim Toll
	[49623] = 37835, 			-- Je'Tze's Bell
	[65019] = 45931, 			-- Mjolnir Runestone
	[64741] = 45490,			-- Pandora's Plea
	[65014] = 45286,			-- Pyrite Infuser
	[65003] = 45929, 			-- Sif's Remembrance
	[60538] = 40382,			-- Soul of the Dead
	[58904] = 43573,			-- Tears of Bitter Anguish
	[60062] = {40685, 49078},	-- The Egg of Mortal Essence, Ancient Pickled Egg
	[64765] = 45507, 			-- The General's Heart
	[51353]	= 38358,			-- Arcane Revitalizer
	[60218] = 37220,			-- Essence of Gossamer
	[60479] = 37660,			-- Forge Ember
	[51348] = 38359,			-- Goblin Repetition Reducer
	[63250] = 45131,			-- Jouster's Fury
	[63250] = 45219,			-- Jouster's Fury
	[60302] = 37390,			-- Meteorite Whetstone
	[54808] = 40865, 			-- Noise Machine
	[60483] = 37264, 			-- Pendulum of Telluric Currents
	[52424] = 38675, 			-- Signet of the Dark Brotherhood
	[55018] = 40767,			-- Sonic Booster
	[52419] = 38674,			-- Soul Harvester's Charm
	[60520] = 37657,			-- Spark of Life
	[60307] = 37064,			-- Vestige of Haldor
	[60233] = {44253, 44254, 44255, 42987},		-- Greatness, AGI
	[60235] = {44253, 44254, 44255, 42987},		-- Greatness, SPI
	[60229] = {44253, 44254, 44255, 42987},		-- Greatness, INT
	[60234] = {44253, 44254, 44255, 42987},		-- Greatness, STR
}

local EnchantToItemID = {	-- spell ID = {enchant ID, slot1[, slot2]}
	[55637] = {3722, 15},			-- Lightweave
	[55775] = {3730, 15},			-- Swordguard
	[55767] = {3728, 15},			-- Darkglow
	[59626] = {3790, 16}, 			-- Black Magic
	[59625] = {3790, 16}, 			-- Black Magic
	[54758] = {3604, 10}, 			-- Hyperspeed Accelerators
}

local ItemIDCooldown = {
	[72416] = 60,
	[72412] = 60,
	[72418] = 60,
	[72414] = 60,
	[60488] = 15,
	[51348] = 10,
	[51353] = 10,
	[54808] = 60,
	[55018] = 60,
	[52419] = 30,
	[59620] = 90,
	[75456] = 45,
	[55382] = 15,
	[32848] = 15,
	[55341] = 90,
	[48517] = 30,
	[48518] = 30,
	[75473] = 45,
	[71636] = 90,
	[47755] = 12,
	[71485] = 105,
	[71492] = 105,
	[71486] = 105,
	[71484] = 105,
	[71491] = 105,
	[71487] = 105,
	[71556] = 105,
	[71560] = 105,
	[71558] = 105,
	[71561] = 105,
	[71559] = 105,
	[71557] = 105,
	[59626] = 35,
	[59625] = 35, 	
	[54758] = 60, 	
}

FatCooldowns.ItemIDCooldown = ItemIDCooldown

FatCooldowns.EnchantToItemID = EnchantToItemID

FatCooldowns.AuraToItemID = AuraToItemID

FatCooldowns.chatfilter = chatfilter

FatCooldowns.reporter = reporter

FatCooldowns.spellInfoTable = {}
for class, classSpells in pairs(cooldowns) do
	for spellName, spellTable in pairs(classSpells) do
		FatCooldowns.spellInfoTable[spellTable.id] = {ExpacHide = spellTable.ExpacHide, id = spellTable.id, cd = spellTable.cd, class = class, name = spellName, order = spellTable.order or 500, itemlink = spellTable.itemlink, cd2 = spellTable.cd2,
			icon = spellTable.icon, realid = spellTable.realid, remove = spellTable.remove, proc = spellTable.proc, descid = spellTable.descid, itemidline = spellTable.itemidline, side = spellTable.side,
			desc = spellTable.desc, talent = spellTable.talent, item = spellTable.item, max = spellTable.max, sortname = spellTable.sortname, sort = spellTable.sort, itemid = spellTable.itemid, itemid2 = spellTable.itemid2}
	end
end

FatCooldowns.cooldowns = cooldowns

FatCooldowns.syncIndex = {
	[48477] = 1,
	[21169] = 2,
	[47883] = 3,
	[2825] = 4,
	[32182] = 5,
	[16190] = 6,
	[64901] = 7,
	[64843] = 8,
	[10278] = 9,
	[642] = 10,
	[45438] = 11,
	[498] = 12,
	[871] = 13,
	[47585] = 14,
	[48792] = 15,
	[33206] = 16,
	[48788] = 17,
	[19752] = 18,
	[47788] = 19,
	[29166] = 20,
	[12051] = 21,
	[66] = 22,
	[64205] = 23,
	[6940] = 24,
	[1038] = 25,
	[31821] = 26,
	[34433] = 27,
	[19647] = 28,
}

FatCooldowns.syncCount = 28

FatCooldowns.syncCooldowns = {
	[1] = {cooldowns = {}, count = 0, id = 48477}, -- Rebirth
	[2] = {cooldowns = {}, count = 0, id = 21169}, -- Reincarnation
	[3] = {cooldowns = {}, count = 0, id = 47883}, -- Soulstone Resurrection
	[4] = {cooldowns = {}, count = 0, id = 2825}, -- Bloodlust
	[5] = {cooldowns = {}, count = 0, id = 32182}, -- Heroism
	[6] = {cooldowns = {}, count = 0, id = 16190}, -- Mana Tide Totem
	[7] = {cooldowns = {}, count = 0, id = 64901}, -- Hymn of Hope
	[8] = {cooldowns = {}, count = 0, id = 64843}, -- Divine Hymn
	[9] = {cooldowns = {}, count = 0, id = 10278}, -- Hand of Protection
	[10] = {cooldowns = {}, count = 0, id = 642}, -- Divine Shield
	[11] = {cooldowns = {}, count = 0, id = 45438}, -- Ice Block
	[12] = {cooldowns = {}, count = 0, id = 498}, -- Divine Protection
	[13] = {cooldowns = {}, count = 0, id = 871}, -- Shield Wall
	[14] = {cooldowns = {}, count = 0, id = 47585}, -- Dispersion
	[15] = {cooldowns = {}, count = 0, id = 48792},  -- Icebound Fortitude
	[16] = {cooldowns = {}, count = 0, id = 33206}, -- Pain Suppression
	[17] = {cooldowns = {}, count = 0, id = 48788}, -- Lay on Hands
	[18] = {cooldowns = {}, count = 0, id = 19752}, -- Divine Intervention
	[19] = {cooldowns = {}, count = 0, id = 47788}, -- Guardian Spirit      
	[20] = {cooldowns = {}, count = 0, id = 29166}, -- Innervate
	[21] = {cooldowns = {}, count = 0, id = 12051}, -- Evocation
	[22] = {cooldowns = {}, count = 0, id = 66}, -- Invisibility
	[23] = {cooldowns = {}, count = 0, id = 64205}, -- Divine Sacrifice
	[24] = {cooldowns = {}, count = 0, id = 6940}, -- Hand of Sacrifice
	[25] = {cooldowns = {}, count = 0, id = 1038}, -- Hand of Salvation
	[26] = {cooldowns = {}, count = 0, id = 31821}, -- Aura Mastery
	[27] = {cooldowns = {}, count = 0, id = 34433}, -- Shadowfiend
	[28] = {cooldowns = {}, count = 0, id = 19647}, -- Spell Lock
}