-- SPDX-FileCopyrightText: 2025 Arcitec (https://github.com/Arcitec/)
-- SPDX-License-Identifier: CC-BY-NC-SA-4.0

local _G = _G or getfenv(0)

local ADDON_NAME = "pfUI-ZezThemes"

pfUI_ZezThemes_DB = {}

pfUI_ZezThemes = {
	profiles = {},
}

function pfUI_ZezThemes:print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cff33ffccpf|cffffffffUI [ZezThemes]: " .. msg)
end

pfUI_ZezThemes.CopyTable = pfUI.api.CopyTable

function pfUI_ZezThemes.DeepMerge(src, dst)
	local lookup_table = {}

	local function _merge(src, dst)
		if type(src) ~= "table" then
			return src
		elseif lookup_table[src] then
			return lookup_table[src]
		end

		if type(dst) ~= "table" then
			dst = {}
		end

		lookup_table[src] = dst

		for k, v in pairs(src) do
			if type(v) == "table" then
				dst[k] = _merge(v, dst[k])
			else
				dst[k] = v
			end
		end

		return dst
	end

	return _merge(src, dst)
end

function pfUI_ZezThemes:UpdateCheck()
	local current_version = GetAddOnMetadata(ADDON_NAME, "Version")
	local db_version = pfUI_ZezThemes_DB.version

	if current_version == nil then
		self:print("Unable to detect current version. Please reinstall the latest version of this addon.")
		return
	end

	if db_version ~= current_version then
		local msg_popup = "A new version of ZezThemes has been installed (v"
			.. current_version
			.. ").\n\n"
			.. "Please load the pfUI profile again on all characters, to apply the update."
		local msg_print = string.gsub(msg_popup, "\n+", " ")

		self:print(msg_print)
		ZezThemesPopupText:SetText(msg_popup)
		ZezThemesPopup:Show()

		-- Don't display the notification again until the next update.
		pfUI_ZezThemes_DB.version = current_version
	end
end

function pfUI_ZezThemes:DetectDynamicSlot()
	-- Default: Bag Space.
	-- Example: "5 (47/52)"
	local dynamic_slot = "bagspace"

	if self.player_class == "HUNTER" then
		-- Hunter: Ammo Counter
		-- Example: "Ammo: 957"
		-- NOTE: Warriors and Rogues also need Bow/Gun ammo, but it's pretty
		-- uninteresting for them, and most prefer Thrown for pulling instead.
		dynamic_slot = "ammo"
	elseif self.player_class == "WARLOCK" then
		-- Warlock: Soulshard Counter
		-- Example: "Soulshards: 21"
		dynamic_slot = "soulshard"
	end

	return dynamic_slot
end

function pfUI_ZezThemes:Init()
	self.event_frame = CreateFrame("Frame")
	self.event_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.event_frame:SetScript("OnEvent", function()
		if self[event] then
			self[event](self, arg1, arg2, arg3, arg4)
		end
	end)
end

-- Register all profiles after the player character data has been loaded and
-- their SavedVars have been loaded (this also reacts to `/reloadui`).
-- NOTE: Overwrites any old or customized values in the `pfUI_profiles` database,
-- since that's stored in a SavedVar and may contain outdated profile data.
-- NOTE: This event fires after `ADDON_LOADED` and `VARIABLES_LOADED`.
function pfUI_ZezThemes:PLAYER_ENTERING_WORLD()
	-- Detect the current player's class.
	_, self.player_class = UnitClass("player")

	-- Determine what to display in the current character's dynamic panel slot.
	local dynamic_slot = self:DetectDynamicSlot()

	-- Determine whether to disable pfUI's basic "Bags" skin.
	-- NOTE: This is necessary when using third-party bag addons. For example,
	-- you would see multiple Bank windows if you use Bagshui + pfUI Bags together.
	local disable_bags_skin = Bagshui ~= nil

	-- NOTE: It's safe to register profiles made for old pfUI versions. pfUI's
	-- profile loader always performs auto-upgrades of outdated profiles. It
	-- automatically fills in missing defaults, and then migrates old fields
	-- by checking `["version"]` and progressively modernizing the settings.
	for profile_name, profile in pairs(self.profiles) do
		-- Set the right panel's first slot to the dynamic choice.
		profile.panel.right.left = dynamic_slot

		-- Disable pfUI's own "Bags" skin if using a 3rd party bag-addon.
		profile.disabled.bags = (disable_bags_skin and "1" or "0")

		-- Register the profile in pfUI's global SavedVars.
		pfUI_profiles[profile_name] = profile
	end

	-- Detect whether ZezThemes has been updated and needs to be applied again.
	self:UpdateCheck()

	-- Don't react to the event again, since it fires after every loading screen.
	self.event_frame:UnregisterEvent("PLAYER_ENTERING_WORLD")

	-- Release injector table reference to allow garbage collection.
	pfUI_ZezThemes = nil
end

pfUI_ZezThemes:Init()
