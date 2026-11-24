# FCD (Shekles) - Addon Changelog

A comprehensive World of Warcraft (WotLK / TBC / Vanilla) utility, cooldown tracker, raid reporter, and chat filter addon. This document contains the complete version history and changelog from v1 through v51.

---

## Table of Contents
- [v51](#v51) | [v50](#v50) | [v49](#v49) | [v48](#v48) | [v47](#v47) | [v46](#v46) | [v45](#v45) | [v44](#v44) | [v43](#v43) | [v42](#v42) | [v41](#v41)
- [v40](#v40) | [v39](#v39) | [v38](#v38) | [v37](#v37) | [v36](#v36) | [v35](#v35) | [v34](#v34) | [v33](#v33) | [v32](#v32) | [v31](#v31)
- [v30](#v30) | [v29](#v29) | [v28](#v28) | [v27](#v27) | [v26](#v26) | [v25](#v25) | [v24](#v24) | [v23](#v23) | [v22](#v22) | [v21](#v21)
- [v20](#v20) | [v19](#v19) | [v18](#v18) | [v17](#v17) | [v16](#v16) | [v15](#v15) | [v14](#v14) | [v13](#v13) | [v12.5](#v125) | [v12](#v12) | [v11](#v11) | [v1 - v10](#v1---v10)

---

## v51

### Added
- Need, pass, and greed icons.
- **Auto Roller:**
  - `ilvl`: Above, below.
  - `bind`: Both, yes, no.
- Hide frames in combat.
- Horn of Winter tracking.
- New lib and boss items in AR.

### Fixed & Changed
- `fcdde` and `auto roller` no longer check auction prices for soulbound items.
- Added tabs for chat highlighter.
- Made `fcdmount`, `de`, and `extra` locals.
- Added code to remove renamed players (e.g., `C_18484545`).
- Added raid info name in inspect frame.
- Fixed `sendmessage` code in battlegrounds for non-English clients.
- Scan for tank CDs (needs more work).
- Added instance check for portals, fish, remote, and distiller.
- Added Raid Warning to spammer.
- Fixed restock reagents for non-English clients.
- Fixed stack sizes for auto buy, fixed removal error, and increased auto buy limit from 200 to 500.
- Added message back in for spell ready in sound and reporter.
- Changed `yes/no` options to `yes - bop only` and `no - boe only`.

---

## v50

### Added
- Profession icons.
- Hide in Wintergrasp option.
- Spell rank checker.
- **Inspect Frame:** Cooking, raid info, hit, and defense stats.
- **Chat Filter:** `FCDGroupPlayer`, case sensitivity option, global raids filter, custom print tabs, chat menu bubbles, and menu option to add messages to custom chat filter.
- Include PvP in screenshot death.
- **Cooldowns Added:** Earth Shock, Arcane Bomb, Super Sapper Charge.

### Fixed & Changed
- Prevented spells from being added to bars when in raids where they shouldn't be (e.g., Tricks of the Trade in Onyxia/TBC).
- Updated ToT remove logic to check `maxhp > 46000` outside ICC (or `46000 * 1.3` inside ICC), checking for Righteous Fury and Frost Presence buffs too.
- Fixed Druid attack power showing for everyone in inspect frame; added color coding for "has" and "missing" and split glyphs in inspect frame.
- Spammer improvements: added button to send message and reset timer; fixed issue where changing channel (e.g., global) switched to LFG.
- Fixed Wintergrasp hide, FCD mount code, and removed a lot of old code.
- Fixed Power Infusion sound and report when player has talents to reduce cooldown.
- Updated channel options config, aura code for pets, whisper block code, alt-tab code, and `fcdanylink` code.
- Started splitting code for module modes.
- Added magic char code and toggle to custom chat filter, plus chat events for custom chat menu blocker.
- Added player roles in messages.
- Added combat check for poisons in TBC/Vanilla and removed poison check for spells in TBC/Vanilla.
- Fixed chat filter not resetting print message channel when disabled, and fixed a general bug in chat filter.
- Fixed bug when disabling a spell (`bas`).
- Custom chat filter reporter now works with chat bubbles.
- Fixed lock tooltip bug in TBC.
- `fcdde` now works with Auctionator and tracks "seen" items correctly.
- Trader now stocks higher-level drinks and food.
- Fixed BQL Remove Salvation, Rapid Fire CD, and fish spam.

---

## v49

### Added
- Prefix for most reports.
- Spammer alt to auto flood.
- `/fcd ver` and `/fcd download` commands (check `/fcd help`).
- Item, spell, and achievement icons added for chat.

### Fixed & Changed
- Fixed Rogue Tricks of the Trade spell reporter.
- Fixed Crashin' Thrashin' Racer from Devo and made it work in party as well.
- Fixed hunter/pet cooldown times with talent modifiers.
- Reverted code so spell sound and spell reporter require bars again.
- Updated chicken proc and aura tooltip info code.

---

## v48

### Added
- Solo mode to stop bars from being removed when leaving groups.
- Spells reporter.
- Invite and assist - auto invite from guild chat.
- Crashin' Thrashin' Racer Controller reporter.

### Fixed & Changed
- Fixed AutoGear code for dual-wield specs when a 2H weapon is equipped, plus max level fixes.
- Fixed whisper block timers and removed Auto Roller delay when set to `0`.
- Added `libhooker` and fixed max level for Onyxia server.
- Fixed spell order not working on load, `tostring` for `GetSpellInfo`, and border rendering.
- Reworked config code and added tabs for spell sounds.
- Added code to stop repeatedly trying to load failed items.
- Fixed Ectoplasmic Distiller reporter and inspect low-level items range.
- Updated channel code and cooldown time logic in spell reporter/sound (temporarily decoupled from bars).
- Reduced raid log limit from 500 to 50 and fixed it tracking battlegrounds.

---

## v47

### Added
- Druid indoors one-click support to `fcdmount`.
- Invite blocker / auto-decline invites from players below a set level (in Auto Confirm).
- Confirmation window added for ignore and friends lists, with ignore notes now visible in the ignore window.

### Fixed & Changed
- Updated `sendaddoncommand`, hunter spell talents, cooldown reduction calculations, and Unholy DK Gargoyle/Army CD fixes.
- Fixed Hand of Protection removal code, Misdirection CD for Onyxia, Onyxia polearm location, and Soulstone aura ID-to-spellname mapping.
- Improved class colors and extra handling in blocked whispers, plus reply timer for whispers (removed option to edit auto-reply whisper).
- Warning for friends in group is now off by default.
- Fixed "already known" detection for Warlock pet spells.
- Fixed guild invite button converting to raid.

---

## v46

### Added
- Import/export settings.
- Auto Ready Check delay.
- Auto Roller delay.

### Fixed & Changed
- Fixed buff removal for Lady Deathwhisper Mind Control.
- Fixed print price error in Trash Manager and aura info errors.
- Fixed Valithria Dreamwalker double message and report on boss stacks.
- Disabled Salvation tracking for Vanilla.
- Added combat check for `fcdmount` and rogue ToT remover.
- Excluded raid log info, class info, and chat history from "All" in export/import settings.
- Updated translation code, TBC spell levels, and AutoGear Druid tank auto-checks.

---

## v45

### Added
- Hide bar background option.
- Print notification for Auto Confirm.

### Fixed & Changed
- Fixed inspect frame errors (including Undead models) and updated custom class checker code.
- Set a 5-second timer for every part of the whisper blocker and updated whisper block message table.
- Changed dispel timer to `0.01` sec and updated Mass Dispel and dispel reporting messages.
- Added total sell print to Trash Manager.
- Fixed guild invite button repeating invites/messages.
- Added spam blocker and start/end options for portal reporting.
- Updated Auto Confirm and AutoGear 2H Fury logic.

---

## v44

### Added
- Bank move functionality.
- Inspect frame low-level enchants check.

### Fixed & Changed
- Fixed `extradata` error and item information retrieval in inspect window; dropped rescan timer from 5s to 0.5s.
- Added reporting and summary features to the inspect frame, plus an inspect frame enable button.
- Auto Mailer now detects cross-faction recipients and stops attempting to send mail to the wrong faction.
- Fixed AutoGear DK item weight errors.
- **Whisper Blocker:** Added custom message, log of blocked messages, whitelist support, and GM message exemption.
- Guild invite button now runs on a timer with additional messages.
- Keyword auto-invite now matches whole words rather than substrings.
- Massive localization updates so the addon works smoothly on non-English clients without full translation.
- Fixed Power Infusion and Soulstone cooldown tracking.

---

## v43

### Added
- Inspect module.

### Fixed & Changed
- Changed AutoGear tooltip to allow single or all comparisons, updated AG stats, proc checks, ranged weapons, replaced-item checks, 1H Expertise on Onyxia, and hunter weapon DPS.
- Fixed duplicate messages blocking all messages.
- **Trash Manager:** Added `[Gnomish Battle Chicken]`, `[Arclight Spanner]`, Recipes, and Miscellaneous items to the white-item blacklist; prevented selling/deleting white items with gems/enchants; added price and stack info to print output.
- Fixed Auto Confirm code, fireworks event timer, and added an extra table for unarmed and rogue poisons in `spellslvl`.

---

## v42

### Added
- AutoGearer in tooltips.
- `/who` lookup and people you messaged added to chat whispers.

### Fixed & Changed
- Fixed Polearms location not showing in spells, poisons code in spells, and spells print output.
- Reworked AutoGearer code (bind, loot received, and experience tracking).
- Fixed friends being blocked in chat whispers when allowed, alt guild checks, color names, and message blocking on reload/relog with chat history enabled.
- Made `fcdmount` work on Onyxia.
- Reset Trash Manager item list to support granular filtering by stats, enchants, and gems.
- Fixed frame strata order/stacking.

---

## v41

### Added
- Chat whispers module.
- Same chat message filter for global channels.
- Extra check for learned Warlock pet tomes displayed in tooltips.

### Fixed & Changed
- Added Healthstone and Pick Lock buttons to the trader window.
- Updated Aspect of the Pack daze report code and Valithria Dreamwalker lose stacks code.
- Reorganized config layout: moved chat history and auto buy, increased config size, made separators smaller, and reordered chat filter config.
- Updated item functional checks to inspect all stats.
- Fixed Warlock pet tomes search blocking print output and config bugs, plus Mana Tide ranks 2/3 showing without rank 1.
- Fixed Trash Manager deleting white items when the option was disabled.

---

## v40

### Added
- Ruby Sanctum (RS) flash screen.
- Print learnable spells in chat when leveling up.
- Trader window enhancements.

### Fixed & Changed
- Fixed `fcdbacklash` chat filter error, Sindragosa flash screen, and boss screenshots firing when disabled.
- Portals reporter can now announce or warn (requires re-enabling).
- Fixed spelling mistakes in Infernal Spear reporter, auto master looter, and RS auto loot change.
- Added "ask for dispel" to Dispeller.
- Fixed quest items in autosell/destroy list, Trash Manager stack price counting, and player target icons being removed.
- Improved compatibility with Onyxia server.
- Updated raid logs max count, spells code, FCD sell list tooltip, and server options for Auto Buy.
- `fcdmount` now supports Ghost Wolf and powershifting (one-click) for Travel Form and Ghost Wolf.

---

## v39

### Added
- Auto screenshot.
- Dispeller module.
- Portals reporter.
- Flash screen alerts for Sindragosa bombs (on you and not on you), BQL shadows, and Professor Putricide Ooze.
- Infernal Spear reporter.
- Valithria Dreamwalker drop stacks reporter.

### Fixed & Changed
- ICC marks now properly display in loot timers.
- Changed "print last target" to "report last target" (sends to raid/party chat).
- Added instance limiter for Master Looter, fixed UI hiding delay on screenshots, added customizable threshold for fish reporter, and fixed aura info glyph bugs.

---

## v38

### Added
- Raid logs to remake raids.
- Emote option to chat filter.

### Fixed & Changed
- Changed default Auto Master Looter to full name and extended support to other players.
- Fixed tank-only cooldowns, Filthy Tricks talent checker, and raid remake functionality.
- Enabled linking loot timers to raid chat and displaying ICC marks in loot timers.

---

## v37

### Added
- Chat bubble icons.
- Lich King healer grabbed icons.
- Aura Mastery display type.
- Loot timers.
- Disenchant weapon and armor limiter options.
- Auto mail weapon and armor limiter options.
- Trash Manager auto-sell inequitable/unfit items (e.g., spell power gear on a Warrior).

### Fixed & Changed
- Colored link names in chat highlighter, fixed table sorting, and fixed "button click print last target".
- Report messages now print locally if not in a party/raid.
- Added extra safeguards in Trash Manager against deleting quest items and added vendor price check for disenchanting.
- Added class check for player roles in mass whisper, allowed bar removal when clicks are disabled, and removed Strength from Rogue unfit stats.

---

## v36

### Added
- Chat bubbles and Raid Warning frame support in custom chat filter.
- Buff removal.
- Player roles in messenger.
- Chat history.
- Disenchant module.
- Item level (`ilvl`) filtering for Auto Mail.
- Priority and disenchant options in Auto Roll.

### Fixed & Changed
- Moved custom chat filter to its own tab and removed automatic lowercasing.
- Updated controlled code, alpha range code (to hide missing spaces), aura info code, and party/raid name coloring warnings.

---

## v35

### Added
- Range Alpha.
- Chat highlighter for loot/system links.
- Spell/item IDs and talent/glyph info in aura source.
- "Controlled" alert when someone is interrupted or crowd-controlled.
- Reporter for daze with Aspect of the Pack/Cheetah.

### Fixed & Changed
- Fixed auto-promote errors, chat bubbles code, gold message filter IDs, friend/ignore share code, and chat hook code.
- Holding `Shift` now pauses Auto Buy.
- Added temp table for `UnitClass`, minimum letter threshold for chat highlighter, pet flash screen fix, custom sounds path fix, and Aura Mastery checker bug fix.
- Renamed "aura source" to "aura info".

---

## v34

### Added
- Chat filter for gold share system messages in party/raid.
- Auto Buy module.
- Option to remove Tricks of the Trade proc when used on a Rogue.

### Fixed & Changed
- Fixed spelling mistakes, chat highlighter code, `fcdmount` Oculus and ground mount order, chat reporter bubbles error, and ElvUI chat bubble filter.
- Paladin Aura Mastery now displays the active aura type.
- Fixed auto-promote bug and hidden `/fcd` button issue.

---

## v33

### Added
- *No new features added.*

### Fixed & Changed
- Fixed bugs with ignore/friends lists and inability to remove certain items from Auto Master Loot and Auto Roller loot lists.
- Added icons to `fcdmount` lists, updated UI font, and updated bundled libraries.

---

## v32

### Added
- *No new features added.*

### Fixed & Changed
- Fixed additional bugs with ignore and friends lists.
- Split guild invite and disband button options.
- Split "Only ICC and RS" toggles and added more granular options.

---

## v31

### Added
- Delay timer and group loot threshold for loot changer.
- Target names to icon control.

### Fixed & Changed
- Fixed loot changer bug and additional ignore/friends bugs.

---

## v30

### Added
- *No new features added.*

### Fixed & Changed
- Fixed spells code, ignore/friend share crash bug, and `fcdmount` changes.
- Auto Mailer now resets the recipient name field after sending mail.

---

## v29

### Added
- Food range, auto-sell white equipment, spellbook, and auto-delete in Trash Manager.
- Friends and ignore share list.
- Anchor options and random mount support.
- Low HP and Mana flash screen with sound.
- Error filter and Lady Deathwhisper flash screen on spirits.
- **Icon Control Options:** In raid, not in raid, boss fight, not in boss fight, and player target role/type (tank, DPS, healer, hostile).

### Fixed & Changed
- Updated Auto Mail for non-soulbound equipment and auto-delete for food/scrolls (prevented deletion while at the Auction House).
- Added neck, finger, trinket, off-hand, and back slots to item lists.
- Renamed "Keep Icons" to "Icon Control" and lowered messenger list limit from 30 to 25.
- Overhauled Auto Roller with new settings, added borders/backgrounds/sounds, moved flash screen into Personal, added guild invite message editing, and added Lay on Hands glyph/talent checks.

---

## v28

### Added
- Auto-equip Goblin Rocket Pack.
- "Not inside BG" condition for messenger.
- Border color customization.
- Loot threshold setting for Master Loot changer.
- Auto Mailer option to send unbound equipment.
- Auto confirm popup.

### Fixed & Changed
- Added trigger for Kalu'ak Fishing Derby when receiving loot.
- Fixed spelling mistakes, RS/ICC-only loot changer logic, Defile flash screen trigger when disabled, and alt-tabber setting sound in combat.
- Overhauled table sorting for blacklists, Trash Manager, and mailer, as well as the Auto Master Looter UI and options.
- Updated border, backdrop, whisper timer, mailer, icon print, and `FCD: sell` button code.

---

## v27

### Added
- Enable/disable all buttons toggle.
- Messenger & Auto Mailer modules.
- Flash screen alerts & event reminder.
- Hide in raid / hide when not in raid options.
- Expose Armor reporter.
- Minimap icon.
- Trash Manager auto-sell unequippable soulbound items.

### Fixed & Changed
- Fixed spell removal code, DK spell sounds, lower-rank spell checks, custom chat filter case sensitivity, and RS/ICC Auto Master Looter logic.
- Added class-colored names/icons, colored raid icons, and player selection to Keep Icons and Master Looter.
- Displayed current item level in Auto Roller, lowered Keep Icon timer from `1.0` to `0.2`, and prevented Trash Manager from deleting items at a mailbox or disconnecting when deleting 3+ unsellable items.

---

## v26

### Added
- Show only in Arena option.

### Fixed & Changed
- Added profile options to `/fcd` config window.
- Moved hide/show toggles into individual frames, added spell resets when entering arenas, and updated alt-tab, highlighter, backup CD, spell labeling, and custom name color code.

---

## v25

### Added
- "Receives loot" Raid Warning chat filter.
- Hide in Battlegrounds and hide in Arena options.
- Bag Manager (new item selling system).
- Word highlighter with sounds and player name highlighting.
- Custom chat filter & Alt-Tab helper.
- Search functionality for items and spells.

### Fixed & Changed
- Chat filter reporter titles now only appear when an option is selected.
- Fixed overlapping raid browser button, item descriptions, spelling mistakes, event reporting, and max-rank spell checks.
- Removed "Hide in PvP" (split into BG/Arena) and legacy item selling, and refreshed the config UI layout.

---

## v24

### Added
- Change target location.
- Strength of Earth / Stoneskin totem reporter.
- `EnsidiaFailsSpam`, `DoTimer`, `FlasknFood`, and `ReadyCheckMessages` chat filters.
- "Only ICC and RS" toggle for auto-change loot.
- Auto assist & rank selection for guild invite button.
- Item proc bars.

### Fixed & Changed
- Fixed MD/ToT errors, spell icon animations, color names (expanded max char length from 12 to 99), and `removedbw` proc spelling.
- Added vehicle and battleground checks for custom player/class checks and backup triggers, plus checks for players renamed in PvP.
- Updated PhoenixStyle chat filter to block Lady Deathwhisper spirits during combat, and improved chat bubble blocking for self-messages (e.g., asking for Innervate).

---

## v23

### Added
- Border thickness, custom bar background/name colors, background color changer, and custom sounds.
- `/fcd removedbw` command to cancel Deathbringer's Will procs for mounting.
- Custom Master Looter window (v1 and v2) and auto-loot when Master Looter.
- **Global Chat Filter:** Guild, spam, buying/selling, arena, transmog, non-English.
- Guild invite button, disband raid button, and badges bar.
- Average item level (`avg ilvl`) option for Auto Roll.
- Icon animation/reverse, hide tooltip in combat (show with `Shift`), and tank auto-remove Divine Shield during boss fights.

### Fixed & Changed
- Fixed raid/party auto-roll, Shield Wall glyph/talent scan, auto master/group loot switching (increased group loot timer from 20s to 40s), Necrotic Plague backup timer, and Professor Putricide icons filter.
- Removed Seal of Command from Deathbringer Saurfang checks and prevented auto-sell from checking max price.

---

## v22

### Added
- Chat filter icons on Professor Putricide fight.
- Default clicks button.
- Auto-delete failed Lady Deathwhisper quest.
- Spec option in sounds & copy frame settings.
- Auto-roll (greed, need, pass, disenchant) on loot.
- Auto-delete on low bag space and vendor auto-sell.

### Fixed & Changed
- Fixed border placement, left-to-right border rendering, unknown Necrotic Plague timers, and Sindragosa pet parries.
- Improved talent scan error handling so failed scans don't remove bars.
- Added Monster Say to NPC bubbles and custom inputs for Val'kyr, Frostmourne, and Keep Icons.

---

## v21

### Added
- "Report to self" option in Other tab, self-reporting for parries, and raid report listing who has a spell on cooldown.
- Keep icon on player, removal buff checker, and scan for old talents/items removal.
- Button clicks options, border option, About tab, and auto group/master loot.
- **New Cooldowns & Sounds:** Shaman shields, Killing Machine, Deathchill, Freezing Fog, Path of Frost, Focus Magic, Hot Streak proc, Pushing the Limit, Icy Veins, Remove Curse, Frost Nova, Death Coil, Banish, Curse of the Elements, Master's Call, Scare Beast.

### Fixed & Changed
- Updated ToT/MD failed/removed messages to show `Caster (Target) R` or `Caster (Target) F`.
- Merged healer-grabbed tracking into Val'kyr scanner bars, showing targets even when DBM doesn't.
- Improved Necrotic Plague tracking with bar timers, priest dispel-over-time names, and jump tracking.
- Innervate requests now check if a Druid is in the raid and disable on Valithria Dreamwalker or if you are a Druid.
- Lady Deathwhisper weapon management no longer equips DPS weapons while tanking or healing, and Ruby Sanctum fail-to-move alerts now report to raid chat.

---

## v20
*(Note: Mislabelled release; identical to v19.)*

---

## v19

### Added
- Auto-remove Wisp Costume, Tricks of the Trade threat cancel, aura removal, and tank auto-remove Hand of Protection during boss fights.
- Blood Prince Council (BPC) self-knock and pet charge reporters.
- Fill bars, fill background, hide label, label spell name, spell icons in config, and new sort orders/directions.
- Lich King debuff and Shaman enrage removal on dispel, plus Val'kyr grabbed removal when dropped.
- Parry counter for Sindragosa and Halion.
- Windfury Totem reporter when a Frost DK is in the raid.
- **Cooldowns Added:** Life Tap, Demonic Pact, Holy Shock, Judgment of the Pure, Avenger's Shield, Hammer of the Righteous, Tiger's Fury, Eclipse, Nature's Grace, Bloodrage, Hurricane, Fan of Knives, Mind Sear, Blizzard, PvP Trinket.

### Fixed & Changed
- Lady Deathwhisper buffs are now only removed when Mind Control is cast on you, and weapons unequip on death during LDW.
- Split tank/healer BPC knock logic, added pet owner names to parry reporter, and increased parry-hasted attack window.
- Prevented multiple sounds from firing when tracking the same spell across multiple bars, and made filtered chat names clickable links.

---

## v18

### Added
- "Bubbles only" mode (hides chat bubbles without removing messages from the chat frame).
- Symbol customization options, cast-by-self sound filter, and spell ready sounds (requires tracking via bars).
- Option to lock/unlock permanent bar movement.
- Lady Deathwhisper buff removal on Mind Control and melee Hand of Protection auto-cancel.
- Aura source tracking, reagents restocker, auto repair, auto ready check, and talent scan for reduced HoP cooldown.
- Added Life Tap and Demonic Pact cooldowns.

### Fixed & Changed
- Fixed Innervate request timer, LDW weapon management backup trigger, bite-stealing spam, and Faerie Fire / Curse of the Elements anti-spam (once per wave).
- Added Seal of Command to BPC padding checks, required Ruby Sanctum IDs for RS reporting, and fixed shared cooldowns triggering for players outside your group.
- Removed `-DKP` tag from resurrection alerts and moved font size settings to individual frames.

---

## v17

### Added
- UTF-8 library for abbreviated names and class storage info (auto-purges entries older than 1 month).
- Chat filter reporter window and Necrotic Plague reporter.
- Raid loot chat filter (poor loot, need, pass, greed, disenchant).
- Warlock auto-delete Soul Shards *(warning: moving bag items during deletion may delete the wrong item)*.
- Lady Deathwhisper weapon swap (unequip/re-equip) and Warrior Weapon Management.
- Low-mana `/say` request for Innervate, "not cast by me" sound option, parry-hasted attack chat filter, disable deep scan, hide target, and MD/ToT fail/remove tracking.

### Fixed & Changed
- Updated chat filter IDs for RSA, Curse of the Elements, and PhoenixStyle; fixed backlash and chat bubble toggle issues.
- Added talent cooldown scans for Shadowfiend and Sacred Shield, capped Professor Putricide incorrect ooze damage alerts at 5 messages, and fixed spelling mistakes.

---

## v16

### Added
- Cleanup for leftover bars when players leave the raid, and `Alt + Left-Click` to whisper/self-print who a spell was last used on.
- Chat filters for raid achievements, Omen, and RankWatch.
- Remove Salvation for Blood-Queen Lana'thel and Paladin auto-remove Seal of Martyrdom/Blood buff.
- Auto-icons for Val'kyr stacking and Frostmourne, plus `-DKP` target warning when Battle Resurrection is overlapped.
- Backup spell trigger for Warmane combat log quirks, "Only Self" cooldown filter, spell sounds, Arena mode, color names, abbreviated names, and clear ignore list.
- **Cooldowns Added:** Nature's Grasp, Hungering Cold, Death Pact, Cyclone, Intimidation, Wyvern Sting, Scatter Shot, Deep Freeze, Polymorph, Blast Wave, Ice Barrier, Arcane Power, Presence of Mind, Dragon's Breath, Beacon of Light, Mana Burn, Sap, Shamanistic Rage, Fear, Howl of Terror, Shadowfury, Distracting Shot, Army of the Dead (tank), Blood Tap (tank).

### Fixed & Changed
- Reworked talent scanning, Val'kyr pickup tracking, Sunder Armor sorting, and spec-change bar cleanup.
- Fixed `Alt + Right-Click` bar removal, Warrior bite-stealing false positives, Guardian Spirit showing on non-Priests, Battle Chicken chat linking, and Hex tracking.
- Restricted permanent bars to active party/raid groups and split chat bubble filters from the main Shekles list.

---

## v15

### Added
- **Extensive Chat Filters:** Details deaths, icon spam, RBS deaths, "Spell is ready" spam, FCD alerts (Vile Gas, BQL Bite, Ooze Damage, Backlash, Padding, RS Dispel, BPC Knocks, 5 Sunders), smart buff filter, Flump, PhoenixStyle, EnsidiaFails, Imp in a Ball, whispers, flasks/food, Raeli's Spell Announcer (RSA), chat/NPC bubbles, CJK and Russian chat/bubbles, WhoTaunted, Big Brother, resurrection spam, LK Announce Filter, custom macros/WeakAuras, DBM announcements, and OptiTaunt.
- **Cooldowns Added:** Shield Block, Enraged Regeneration, Cold Snap, Lightwell, Summon Infernal, Ritual of Souls, plus additional racials.
- Reporters for Val'kyr stuns (excluding Holy Wrath) and Warlock fail debuff on Lich King.
- Raid update timer and `/fcd` reset spells command/button.

### Fixed & Changed
- Disabled Sunder reporter when a Warrior tank is present or during BPC/PP encounters.
- Prevented Readiness from resetting Misdirection and added a `+` indicator on double MD casts.
- Fixed Icebound Fortitude, Divine Protection (2m vs 3m), Barkskin, Stoneform, War Stomp, and Lua errors when scanning talents for unknown players.

---

## v14

### Added
- Buttons to remove bar spark, remove background, hide in PvP (Arena/BG), and change non-permanent bar sorting.
- Additional bar frames with load toggles and Sunder Armor reporter with timer.
- **Cooldowns Added:** 5-second dispels, Mortal Strike, Bladestorm, Concussion Blow, Sweeping Strikes, Cold Blood, Shadowstep, Shadow Dance, Preparation, Disarm Trap, Distract, Retaliation, Dancing Rune Weapon, Death and Decay, Raise Ally, Righteous Defense, Earth Elemental Totem, Summon Water Elemental, Curse of Tongues, Demonic Empowerment, Summon, Fel Domination, Feign Death, Hunter Pet Taunt.

### Fixed & Changed
- Bundled all required libraries so the addon runs completely standalone.
- Stabilized permanent bar positioning, added Divine Sacrifice to talent scans, and fixed ready/used announcements with anti-spam and raid-lead checks.
- Added Holy Wrath to Lich King Phase 1 padding checks, sorted spells alphabetically in config, and increased max bar scale and height.

---

## v13

### Added
- Automatic talent/item scanning to populate permanent bars in raids (powered by `LibTalentQuery` and `LibGroupTalents`, with a disable toggle and max-level-only filter).
- `Alt + Right-Click` to remove individual bars.
- **Reporters:** Festergut Vile Gas (primary and splash targets), Empowered Flames, Halion parry-hasted attacks, and Lich King Piercing Howl post-fight count.
- Dedicated bars for Sindragosa Unchained Magic.
- `/fcd enable`, `/fcd disable`, and `/fcd update` slash commands.

### Fixed & Changed
- Fixed BPC Soul Fragment removal, boss-less parry filtering, `nil` player Lua errors, and spell priority sorting.

---

## v12.5

### Added
- "Hide all frames" toggle to disable the addon.
- Auto-cancel Soul Fragment proc on Blood Prince Council (Prince Keleseth) at 5+ stacks.
- Spell Availability toggle to hide zone/dead/offline statuses on permanent bars.
- Tank-only mode with dedicated tank cooldowns.
- `Middle-Click` on bars to list players who currently have that spell ready.

### Fixed & Changed
- `/fcd` now opens the resized configuration window directly.
- Readiness now properly resets Hunter spell cooldowns, and Multi-Shot was added to LK Phase 1 padding checks.
- Fixed double-triggering on spell cast + aura application, target name visibility outside party/raid, and item linking when clicking bars.

---

## v12

### Added
- Chat filters for MPR, Fatality, Crybaby, Emblem, Parry, Shambling, Orcish/Common, WarmaneCustomDBM, `***`, and `###`.
- Balance Druid auto-removal of Priest/Paladin shields (matching Warrior behavior from v11).
- Mana Tide Totem sound alert and Protection Paladin 4pc / Glyph of Salvation tracking.
- Personal dispel notifications with spell links and anti-spam.
- Professor Putricide red ooze melee hit reporter and Halion Corporeality sound/say alerts.
- Text outline, icon zoom (border crop), offline/zone/dead bar indicators, and a dedicated "Other" configuration tab.

### Fixed & Changed
- Updated DK 4-set icon to match Warrior's (distinguishing it from Vampiric Blood).
- Added Vampire Touch to Rotface/Putricide oozes, Seed of Corruption to LK Phase 1 padding, and Warlock Searing Pain to BQL bite-stealing checks.
- Improved Backlash reporting to include deaths, full target lists, and hit counts without errors on Bubble/Ice Block.

---

## v11

### Added
- Blood Prince Council tank-knock reporter.
- Ruby Sanctum dispel reporter with timer (includes Divine Shield, Cloak of Shadows, and Ice Block).
- Sound and `/say` alert when a healer is grabbed by a Val'kyr.
- Backlash hit reporter (including Bubble/Ice Block usage) and global reporting anti-spam.
- Warrior auto-removal of Priest shields during Lich King Phases 1 & 2 when above 70% HP for rage generation.
- Heroic Sindragosa and Halion parry reporter.

### Fixed & Changed
- Fixed BQL failed-bite reporting, Rotface/BPC cleave padding, LK >73% HP add padding spam, and Warrior bite-stealing accuracy.
- Improved permanent bar stability in parties/RDF and compatibility when group members run older FCD versions.

---

## v1 - v10

### Added
- Initial changelog, consumable categories, and extensive spell/item tracking.
- **Core Reporters (prints to self if not Raid Lead/Assist):** Lady Deathwhisper spirits, Backlash, Baby Spice on bosses, Fish Feast spam, Direbrew's Remote, Ectoplasmic Distiller, incorrect ooze damage, padding/useless damage, BQL bite-stealing (Warrior, Paladin, DK), and BQL bite success/failure tracking.

### Fixed & Changed
- Reworked deep spell/pet tracking logic and icon resolution for spells and items.
- Fixed permanent bar targets, doubled Tricks of the Trade / Misdirection active tracking windows, and added spec-change bar cleanup in raids.
- Updated bar click bindings to `Shift + Click` (report CD to raid) and `Shift + Right-Click` (whisper report).