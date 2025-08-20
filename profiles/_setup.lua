-- SPDX-FileCopyrightText: 2025 Arcitec (https://github.com/Arcitec/)
-- SPDX-License-Identifier: CC-BY-NC-SA-4.0

pfUI_ZezThemes = {
	profiles = {},
}

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
