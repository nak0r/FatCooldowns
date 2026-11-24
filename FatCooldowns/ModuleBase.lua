assert(FatCooldowns, "FatCooldowns not found!")

local MINOR_VERSION = tonumber(("$Revision: 3 $"):match("%d+"))
if MINOR_VERSION > FatCooldowns.MINOR_VERSION then FatCooldowns.MINOR_VERSION = MINOR_VERSION end

local pairs = _G.pairs
local GetTime = _G.GetTime
local GetSpellCooldown = _G.GetSpellCooldown
local GetItemCooldown = _G.GetItemCooldown

local base = {}
local refreshTimer = nil;

function base:OnInitialize()
	self:SetEnabledState(false)
end

function base:OnEnable()
	self.canScanCooldowns = true
	self:ScanSpells()
	
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", "Respec")
	self:RegisterEvent("CONFIRM_TALENT_WIPE", "Respec")
	self:RegisterEvent("PLAYER_TALENT_UPDATE", "Respec")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "GenericSpellSuccess")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN", "ScanSpells")
end

function base:OnDisable()
	self:UnregisterAllEvents()
end

function base:Super(t)
	local sup = getmetatable(self)["__index"]
	return sup[t](sup == base and self or sup)
end

function FatCooldowns:ReCountCooldowns()
	for i,spell in ipairs(FatCooldowns.syncCooldowns) do
		local count = 0;
		for caster, endCD in pairs(spell.cooldowns) do
			if endCD.timer > GetTime() then
				count = count + 1;
			else
				spell.cooldowns[caster] = nil;
			end
		end
		spell.count = count;
	end
end

local function SendSyncData()
	local message = "CDs: ";
	FatCooldowns:ReCountCooldowns();
	for i,spell in ipairs(FatCooldowns.syncCooldowns) do
		message = message .. spell.count .. " ";
	end
	
	FatCooldowns:SendCommMessage(FatCooldowns.prefixB, message, "RAID")

end

--------------[[		Combat Events		]]--------------

function base:GenericSpellSuccess(event, unit, spell)
	if not refreshTimer then 
		refreshTimer = GetTime()+5;
	else
		if refreshTimer < GetTime() then
			SendSyncData();
			refreshTimer = GetTime()+5;
		end
	end
	
	if unit ~= "player" then return end
	if self.cooldowns[spell] == nil then return end

	self.canScanCooldowns = true
end

function base:Respec(event)
	self.canScanCooldowns = true
	self:ScanSpells()
end

function base:GetCooldown(spell)
	local remaining = 0
	local startTime, cooldown, enabled = GetSpellCooldown(spell)
	local startTime, cooldown, enabled = GetItemCooldown(spell)

	if startTime and startTime > 0 and cooldown >= 2 and enabled == 1 then
		remaining = math.ceil(startTime + cooldown - GetTime())
	end
	
	return remaining
end

--------------[[		Comm Methods		]]--------------
function base:ScanSpells()
	if self.canScanCooldowns == false then return end
	
	local cooldown
	local message = "";
	
	for spellName, spellTable in pairs(self.cooldowns) do
		cooldown = self:GetCooldown(spellName)
		if cooldown > 2 then
			message = message .. spellTable.id .. "-" .. cooldown .. ",";
		end
	end
	if message ~= "" then
		FatCooldowns:SendCommMessage(FatCooldowns.prefix, message, "RAID")
	end
		
	self.canScanCooldowns = false
end

FatCooldowns.ModuleBase = base