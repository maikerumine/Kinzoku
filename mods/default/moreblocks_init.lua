--[[
=====================================================================
** More Blocks **
By Calinou, with the help of ShadowNinja and VanessaE.

Copyright (c) 2011-2017 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
=====================================================================
--]]

--moreblocks = {}

local S
if minetest.global_exists("intllib") then
	if intllib.make_gettext_pair then
		S = intllib.make_gettext_pair()
	else
		S = intllib.Getter()
	end
else
	S = function(s) return s end
end
default.intllib = S

local modpath = minetest.get_modpath("default")

dofile(modpath .. "/config.lua")
dofile(modpath .. "/moreblocks_circular_saw.lua")
dofile(modpath .. "/stairsplus/init.lua")
--dofile(modpath .. "/moreblocks_nodes.lua")
--dofile(modpath .. "/moreblocks_redefinitions.lua")
dofile(modpath .. "/moreblocks_crafting.lua")
--dofile(modpath .. "/moreblocks_aliases.lua")

if minetest.settings:get_bool("log_mods") then
	minetest.log("action", S("[moreblocks] loaded."))
end


--[[

# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

- 3 new node shapes in the circular saw (thin slabs, available in
  "L-shaped", "corner-shaped" and "U-shaped" variations), all with 1/16
  thickness.
- Stone Block, Desert Stone Block, Obsidian Block, Sandstone Block, Coral
  Skeleton and Straw are now present as Stairs+ nodes.

## [1.0.0] - 2017-02-19

- Initial versioned release.



# zlib license

Copyright (c) 2011-2017 Hugo Locurcio and contributors

**This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.**

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.

# More Blocks

More Blocks for [Minetest](http://minetest.net), a free and open source infinite
world block sandbox game.

To install, just clone this repository into your "mods" directory.

More Blocks code is licensed under the zlib license, textures are by Calinou and are licensed under CC BY-SA 3.0 Unported.

moreblocks_copperpatina.png is by pithydon licensed under CC0 1.0

**Forum topic:** <https://forum.minetest.net/viewtopic.php?f=11&t=509>


# Contribution Guide

Thank you for your interest in this mod! Before contributing, be sure to know
about these few guidelines:

- Contributions have to be under the zlib license (or compatible) for code,
  and CC BY-SA 3.0 license (or compatible) for assets.
- Make sure to update the change log, keeping the
  [change log format](http://keepachangelog.com/) we use.
- Don't bump the version yourself. Maintainers will do this when necessary.

Adds various miscellaneous blocks to the game.











]]