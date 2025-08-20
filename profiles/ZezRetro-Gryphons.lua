-- SPDX-FileCopyrightText: 2025 Arcitec (https://github.com/Arcitec/)
-- SPDX-License-Identifier: CC-BY-NC-SA-4.0

pfUI_ZezThemes.profiles["ZezRetro-Gryphons"] = pfUI_ZezThemes.CopyTable(pfUI_ZezThemes.profiles["ZezRetro-Diablo"])

local tweaks = {
	Gryphons = {
		h_off = "-94",
		selectleft = "GryphonHD3",
		v_off = "-5",
	},
}

pfUI_ZezThemes.DeepMerge(tweaks, pfUI_ZezThemes.profiles["ZezRetro-Gryphons"])