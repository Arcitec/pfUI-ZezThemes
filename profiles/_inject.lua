-- SPDX-FileCopyrightText: 2025 Arcitec (https://github.com/Arcitec/)
-- SPDX-License-Identifier: CC-BY-NC-SA-4.0

-- Register all profiles after SavedVars have been loaded (includes `/reloadui`).
-- NOTE: Overwrites any old or customized values in the `pfUI_profiles` database,
-- since that's stored in a SavedVar and may contain outdated profile data.
local profile_injector = CreateFrame("Frame")
profile_injector:RegisterEvent("VARIABLES_LOADED")
profile_injector:SetScript("OnEvent", function()
	-- NOTE: It's safe to register profiles made for old pfUI versions. pfUI's
	-- profile loader always performs auto-upgrades of outdated profiles. It
	-- automatically fills in missing defaults, and then migrates old fields
	-- by checking `["version"]` and progressively modernizing the settings.
	if pfUI_ZezThemes then
		for profile_name, profile in pairs(pfUI_ZezThemes.profiles) do
			pfUI_profiles[profile_name] = profile
		end
	end

	-- Don't react to any further events.
	this:UnregisterAllEvents()

	-- Release injector table reference to allow garbage collection.
	pfUI_ZezThemes = nil
end)
