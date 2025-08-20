# SPDX-FileCopyrightText: 2025 Arcitec (https://github.com/Arcitec/)
# SPDX-License-Identifier: CC-BY-NC-SA-4.0

import re
from collections import OrderedDict
from pathlib import Path
from typing import Any

import luadata

SCRIPT_DIR = Path(__file__).resolve().parent
ADDON_DIR = SCRIPT_DIR.parent
PROFILES_DIR = ADDON_DIR / "profiles"


def sort_dict(d: Any) -> Any:
    """Recursively sort dictionary keys."""
    if isinstance(d, dict):  # OrderedDict matches too (a subclass of dict).
        return OrderedDict((k, sort_dict(d[k])) for k in sorted(d))
    elif isinstance(d, list):
        return [sort_dict(x) for x in d]
    else:
        return d


def process_lua(p: Path) -> None:
    print(f"\nProcessing {p.name}...")

    lines: list[str] = []
    has_changed = False

    with p.open("rt", encoding="utf-8") as f:
        # Scan for profile chunks and clean them up. Keep all other lines as-is.
        profile_lines: list[str] = []
        profile_name: str | None = None
        profile_is_tweak = False
        for line in f.readlines():
            line = line.rstrip()
            if profile_name:
                # Inside a profile.
                if line == "}":
                    # End of a profile.
                    print(f'-> Profile{" Tweak" if profile_is_tweak else ""}: "{profile_name}"')
                    profile_lines.append("}")  # Close table.

                    # Process the Lua table.
                    lua_unformatted = "\n".join(profile_lines)
                    data = luadata.unserialize(lua_unformatted, encoding="utf-8")
                    data = sort_dict(data)
                    lua_formatted = luadata.serialize(
                        data, encoding="utf-8", indent="\t"
                    )
                    lines.append(
                        (
                            f"local {profile_name} = "
                            if profile_is_tweak
                            else f'pfUI_ZezThemes.profiles["{profile_name}"] = '
                        )
                        + lua_formatted
                    )
                    if lua_unformatted != lua_formatted:
                        has_changed = True

                    # Reset to be ready for another profile.
                    profile_lines = []
                    profile_name = None
                else:
                    profile_lines.append(line)
            else:
                # Start of a profile or tweak profile.
                if line.startswith("pfUI_ZezThemes.profiles["):
                    # Start of a full profile.
                    # NOTE: The `\.|\[` ensures that we allow `.attr` and `["attr"]`
                    m = re.search(
                        r"^pfUI_ZezThemes\.profiles\[\"([^\"]+?)\"\](\s*=\s*|\.|\[)(.+)$",
                        line,
                    )
                    if not m:
                        raise ValueError(f"Invalid profile line: '{line}'")

                    line_type = m.group(2).strip()
                    line_ending = m.group(3).strip()
                    if line_type == "=" and line_ending == "{":
                        # Start of table.
                        profile_name = m.group(1)
                        profile_is_tweak = False
                        profile_lines.append("{")  # Anonymous table.
                    elif ".CopyTable" in line_ending:
                        print(f'-> Profile: "{m.group(1)}" (Skipping "CopyTable")')
                elif line.startswith("local tweak"):
                    # Start of a tweak profile (always a local variable named "tweak"-something).
                    m = re.search(r"^local (tweak\S+)\s*=\s*\{$", line)
                    if not m:
                        raise ValueError(f"Invalid profile-tweak line: '{line}'")

                    profile_name = m.group(1)
                    profile_is_tweak = True
                    profile_lines.append("{")  # Anonymous table.

                # Add the line as-is if we're not inside a profile table now.
                if not profile_name:
                    lines.append(line)

    if not has_changed:
        print("-> Already formatted.")
        return

    print("-> Writing new file...")
    p.write_text("\n".join(lines), encoding="utf-8")


for p in PROFILES_DIR.glob("*.lua"):
    if not p.is_file() or p.name.startswith("_"):
        continue

    process_lua(p)
