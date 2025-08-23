# pfUI: ZezThemes

Zezez Themes for pfUI. Clean and minimalistic.
Inspired by World of Warcraft's Classic UI.

- [Official Home](https://github.com/Arcitec/pfUI-ZezThemes)


## Installation

### Easy Method (Recommended)

- Use [GitAddonsManager](https://woblight.gitlab.io/overview/gitaddonsmanager/),
  which makes it very easy to install and update addons. Or alternatively, you
  can use **Turtle WoW's launcher**, which also has a Git installation feature.
- Install this addon, and everything from the "Requirements" section below.

### Manual Installation

- Install everything from the "Requirements" section below.
- Download the latest version of [pfUI-ZezThemes](https://github.com/Arcitec/pfUI-ZezThemes/archive/refs/heads/main.zip).
- Extract the ZIP file.
- Rename the directory from `pfUI-ZezThemes-main` to `pfUI-ZezThemes`.
- Put `pfUI-ZezThemes` in `World of Warcraft\Interface\AddOns`.
- Restart the game.


## Requirements

You must also install the following addons:

- [pfUI](https://github.com/shagu/pfUI)
- [pfUI-CustomMedia](https://github.com/mrrosh/pfUI-CustomMedia)
- [pfUI-EliteOverlay](https://github.com/shagu/pfUI-eliteoverlay)
- [pfUI-Gryphons](https://github.com/mrrosh/pfUI-Gryphons)
- [Bagshui](https://github.com/veechs/Bagshui) (Optional)

Bagshui is highly recommended. It's a far superior bag system which improves
inventory management, and it perfectly follows pfUI's active theme design.


## Dynamic Per-Character Themes

All themes are dynamic and will automatically adjust themselves based on the
active character's class and their loaded addons whenever the theme is applied.

- Right Panel's "First/Left-most Slot":
  - Hunters: Shows the hunter's ranged weapon ammunition counter.
  - Warlocks: Shows how many soul shards you are carrying.
  - Everyone Else: Shows how many free bag slots are available.
  - You can manually change the panel's contents via *"pfUI Config: Panel: Right
    Panel - Left".*
- pfUI's Vanilla Bags Skin:
  - The "basic vanilla bags skin" will automatically enable/disable itself based
    on whether the Bagshui addon is loaded, thus avoiding bag addon conflicts.


## Available Themes

The following themes are available via pfUI's settings:

- `ZezRetro-Diablo`
- `ZezRetro-Gryphons`


## Activating a Theme

To activate a theme, go to *"pfUI Config: Settings: General: Profiles" (dropdown menu).*

Select a theme, and then press *"Load Profile".*


## Applying Theme Updates

If you update this addon, pfUI requires you to manually activate the theme again
to see the changes. This is because pfUI saves separate per-character theme
configurations, which contain a permanent *copy* of the last-loaded theme's settings.

You don't need to keep track of updates manually. Whenever a new version of this
theme is installed, you'll receive a friendly in-game notification dialog,
reminding you to refresh your theme settings!
