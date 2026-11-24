# FatCooldowns (`FCD`)

**FatCooldowns** is a multi-purpose World of Warcraft addon (built on Ace3) featuring customizable cooldown tracking frames, audio and chat spell reporters, raid leader utilities, loot automation, gear scoring, and quality-of-life tools—with dedicated support for Wrath of the Lich King (`3.3.5a`) encounters and mechanics.

---

## Features

### ⏱️ Cooldown Tracking & Bar Frames
* **Up to 10 Independent Frames:** Configure scale, dimensions, font size, opacity, out-of-range alpha (`80+` yards), X/Y anchors, and upward bar growth, or clone settings between frames.
* **Granular Filtering:** Filter bars by context (Always, Battlegrounds, Arenas, Raids, Wintergrasp, or In Combat) and unit affiliation (Self, Enemy, Friendly, or Hide Self).
* **Visual & Text Customization:** Toggle permanent "ready" bars, solo/arena modes, bar orientation, background fills, custom borders, icon zoom/animations, class or custom colors, name truncation, and target symbols.
* **Sorting & Click Actions:** Sort dynamically by remaining duration or custom spell priority (`1–1000`), and bind Left, Right, Middle, Shift, and Alt clicks to announce cooldowns, whisper casters, list ready status, or clear bars.

### 🔊 Sound & Chat Reporters
* **Spell Sound Alerts:** Play custom `LibSharedMedia` sounds on spell cast or spell ready with conditions for faction, target (`Targeting Me`), self-cast, active spec, and player class.
* **Spell & Encounter Reporters:** Announce tracked spells, items, racials, and consumables to Self, Party, or Raid, alongside specialized encounter announcements (Soulstones, Aura Mastery, Portals, Lich King, Blood-Queen Lana'thel, Blood Prince Council, and Parry reporting).
* **Chat Spammer:** Configure up to 20 reusable macro-style messages with custom channel routing, priority ordering, and login persistence.

### 🛡️ Raid Leader & Loot Utilities
* **Loot Changer & Master Looter Tools:** Automatically toggle between Group Loot and Master Loot around boss encounters, replace the default Master Looter frame (`V1`/`V2`), and auto-loot eligible items by quality, instance, and blacklist.
* **AutoRoller (Up to 10 Rules):** Priority-ordered automatic loot rolling (`Need > Disenchant > Greed > Pass`) with item level, BoP/BoE, usable equipment, bag space, group type, and Auctionator/Auctioneer disenchant value checks.
* **Raid & Invite Management:** One-click Guild Invite and Disband Raid buttons, keyword auto-invites, rank-based auto-assist, raid remake utilities, and persistent Raid Logs (up to 50 snapshots).
* **Dispeller & Icon Control:** Track dispels, debuff durations, timeouts, and Mass Dispel targets, and automate raid target markers for boss mechanics (such as Heroic Lich King Val'kyr and Frostmourne stacking) or custom raid roles.
* **Inspect Summary:** View a compact equipment audit on inspect covering item level, PvP gear, armor mismatches, missing/low gems and enchants, glyphs, defense/hit caps, and boss kill progress.

### ⚠️ Screen Flash Alerts & Chat Filtering
* **Vitals & Boss Flashes:** Configurable screen-edge flash and audio alerts for Low HP, Low Mana, and Low Pet Health, plus WotLK raid alerts (Ruby Sanctum, The Lich King, Sindragosa, Professor Putricide, Blood-Queen Lana'thel, and Lady Deathwhisper).
* **Chat & Error Filtering:** Filter global channels, loot spam, chat bubbles (including language and NPC filters), duplicate messages, and red UI error text.
* **Crowd Control & Interrupt Alerts:** Announce interrupts and crowd control effects on players or healers in chat and audio.

### 🎒 Personal Quality-of-Life & Automation
* **AutoGear:** Automatically equip upgrades from loot and quests using customizable per-class and per-spec stat, gem, and proc weights, with tooltip upgrade scores.
* **AutoMailer:** Batch-mail BoE gear, items by quality/ilvl/armor type, or custom item lists to designated alts across your realm.
* **Cross-Alt Social Lists:** Share Friends and Ignore lists per realm/faction with notes, timestamps, group alerts, and auto-expiration timers.
* **FCDMount, Auto Confirm & Badges Bar:** Context-aware random mount macro (`/fcd fcdmount`), automatic dialog confirmations, invite blocking, Alt+Right-Click bag-to-bank transfers, and quick-trade emblem buttons at vendors.

### 📦 Profile Export & Import
* Serialize, Deflate-compress, and share specific configuration modules (cooldown frames, spell sounds, spell priorities, AutoRoller, AutoMailer, and vendor lists) via `AceSerializer` and `LibDeflate`.

---

## Dependencies

* **Ace3** (`AceConfig-3.0`, `AceSerializer-3.0`)
* **LibSharedMedia-3.0**
* **LibDeflate**
* *(Optional)* **Auctionator** or **Auc-Advanced** for disenchant vs. auction value comparisons in AutoRoller.