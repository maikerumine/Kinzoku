-- Other mods can use these for looping through available colors

--dye = {}
default.basecolors = {"white", "grey", "black", "red", "yellow", "green", "cyan", "blue", "magenta"}
default.excolors = {"white", "lightgrey", "grey", "darkgrey", "black", "red", "orange", "yellow",
	"lime", "green", "aqua", "cyan", "sky_blue", "blue", "violet", "magenta", "red_violet"}

-- Make dye names and descriptions available globally

default.dyes = {
	{"white",      "White"},
	{"grey",       "Grey"},
	{"dark_grey",  "Dark grey"},
	{"black",      "Black"},
	{"violet",     "Violet"},
	{"blue",       "Blue"},
	{"cyan",       "Cyan"},
	{"dark_green", "Dark green"},
	{"green",      "Green"},
	{"yellow",     "Yellow"},
	{"brown",      "Brown"},
	{"orange",     "Orange"},
	{"red",        "Red"},
	{"magenta",    "Magenta"},
	{"pink",       "Pink"},
}

-- This collection of colors is partly a historic thing, partly something else

local dyes = {
	{"white",      "White Dye",      {dye=1, basecolor_white=1,   excolor_white=1,      unicolor_white=1}},
	{"grey",       "Grey Dye",       {dye=1, basecolor_grey=1,    excolor_grey=1,       unicolor_grey=1}},
	{"dark_grey",  "Dark Grey Dye",  {dye=1, basecolor_grey=1,    excolor_darkgrey=1,   unicolor_darkgrey=1}},
	{"black",      "Black Dye",      {dye=1, basecolor_black=1,   excolor_black=1,      unicolor_black=1}},
	{"violet",     "Violet Dye",     {dye=1, basecolor_magenta=1, excolor_violet=1,     unicolor_violet=1}},
	{"blue",       "Blue Dye",       {dye=1, basecolor_blue=1,    excolor_blue=1,       unicolor_blue=1}},
	{"cyan",       "Cyan Dye",       {dye=1, basecolor_cyan=1,    excolor_cyan=1,       unicolor_cyan=1}},
	{"dark_green", "Dark Green Dye", {dye=1, basecolor_green=1,   excolor_green=1,      unicolor_dark_green=1}},
	{"green",      "Green Dye",      {dye=1, basecolor_green=1,   excolor_green=1,      unicolor_green=1}},
	{"yellow",     "Yellow Dye",     {dye=1, basecolor_yellow=1,  excolor_yellow=1,     unicolor_yellow=1}},
	{"brown",      "Brown Dye",      {dye=1, basecolor_brown=1,   excolor_orange=1,     unicolor_dark_orange=1}},
	{"orange",     "Orange Dye",     {dye=1, basecolor_orange=1,  excolor_orange=1,     unicolor_orange=1}},
	{"red",        "Red Dye",        {dye=1, basecolor_red=1,     excolor_red=1,        unicolor_red=1}},
	{"magenta",    "Magenta Dye",    {dye=1, basecolor_magenta=1, excolor_red_violet=1, unicolor_red_violet=1}},
	{"pink",       "Pink Dye",       {dye=1, basecolor_red=1,     excolor_red=1,        unicolor_light_red=1}},
}

-- Define items

for _, row in ipairs(dyes) do
	local name = row[1]
	local description = row[2]
	local groups = row[3]
	local item_name = "default:" .. name
	local item_image = "dye_" .. name .. ".png"
	minetest.register_craftitem(item_name, {
		inventory_image = item_image,
		description = description,
		groups = groups
	})
	minetest.register_craft({
		type = "shapeless",
		output = item_name .. " 4",
		recipe = {"group:flower,color_" .. name},
	})
end

-- Manually add coal->black dye

minetest.register_craft({
	type = "shapeless",
	output = "default:black 4",
	recipe = {"default:steelblock_black"},
})

-- Mix recipes
local dye_recipes = {
	-- src1, src2, dst
	-- RYB mixes
	{"red", "blue", "violet"}, -- "purple"
	{"yellow", "red", "orange"},
	{"yellow", "blue", "green"},
	-- RYB complementary mixes
	{"yellow", "violet", "dark_grey"},
	{"blue", "orange", "dark_grey"},
	-- CMY mixes - approximation
	{"cyan", "yellow", "green"},
	{"cyan", "magenta", "blue"},
	{"yellow", "magenta", "red"},
	-- other mixes that result in a color we have
	{"red", "green", "brown"},
	{"magenta", "blue", "violet"},
	{"green", "blue", "cyan"},
	{"pink", "violet", "magenta"},
	-- mixes with black
	{"white", "black", "grey"},
	{"grey", "black", "dark_grey"},
	{"green", "black", "dark_green"},
	{"orange", "black", "brown"},
	-- mixes with white
	{"white", "red", "pink"},
	{"white", "dark_grey", "grey"},
	{"white", "dark_green", "green"},
}

for _, mix in pairs(dye_recipes) do
	minetest.register_craft({
		type = "shapeless",
		output = 'default:' .. mix[3] .. ' 2',
		recipe = {'default:' .. mix[1], 'default:' .. mix[2]},
	})
end



--[[
License of source code
----------------------

The MIT License (MIT)
Copyright (C) 2012-2016 Perttu Ahola (celeron55) <celeron55@gmail.com>
Copyright (C) 2012-2016 Various Minetest developers and contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

For more details:
https://opensource.org/licenses/MIT


Licenses of media (textures)
----------------------------

Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)
Copyright (C) 2012-2016 Perttu Ahola (celeron55) <celeron55@gmail.com>

You are free to:
Share — copy and redistribute the material in any medium or format.
Adapt — remix, transform, and build upon the material for any purpose, even commercially.
The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:

Attribution — You must give appropriate credit, provide a link to the license, and
indicate if changes were made. You may do so in any reasonable manner, but not in any way
that suggests the licensor endorses you or your use.

ShareAlike — If you remix, transform, or build upon the material, you must distribute
your contributions under the same license as the original.

No additional restrictions — You may not apply legal terms or technological measures that
legally restrict others from doing anything the license permits.

Notices:

You do not have to comply with the license for elements of the material in the public
domain or where your use is permitted by an applicable exception or limitation.
No warranties are given. The license may not give you all of the permissions necessary
for your intended use. For example, other rights such as publicity, privacy, or moral
rights may limit how you use the material.

For more details:
http://creativecommons.org/licenses/by-sa/3.0/


Minetest Game mod: dye
======================
See license.txt for license information.
See init.lua for documentation.

Authors of source code
----------------------
Originally by Perttu Ahola (celeron55) <celeron55@gmail.com> (MIT)
Various Minetest developers and contributors (MIT)

Authors of media (textures)
---------------------------
Perttu Ahola (celeron55) <celeron55@gmail.com> (CC BY-SA 3.0)





]]