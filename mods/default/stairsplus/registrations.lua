--[[
More Blocks: registrations

Copyright (c) 2011-2017 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
--]]

local default_nodes = { -- Default stairs/slabs/panels/microblocks:
	"stone",
	"stone_block",
	"cobble",
	"mossycobble",
	"brick",
	"sandstone",
	"steelblock",
	"goldblock",
	"copperblock",
	"bronzeblock",
	"diamondblock",
	"tinblock",
	"desert_stone",
	"desert_stone_block",
	"desert_cobble",
	"meselamp",
	"glass",
	"tree",
	"wood",
	"jungletree",
	"junglewood",
	"pine_tree",
	"pine_wood",
	"acacia_tree",
	"acacia_wood",
	"aspen_tree",
	"aspen_wood",
	"obsidian",
	"obsidian_block",
	"obsidianbrick",
	"obsidian_glass",
	"stonebrick",
	"desert_stonebrick",
	"sandstonebrick",
	"silver_sandstone",
	"silver_sandstone_brick",
	"silver_sandstone_block",
	"desert_sandstone",
	"desert_sandstone_brick",
	"desert_sandstone_block",
	"sandstone_block",
	"coral_skeleton",
	"farming:straw",
	
	"steelblock_blue",
	"steelblock_black",
	"steelblock_brown",
	"steelblock_cyan",
	"steelblock_dark_green",
	"steelblock_dark_grey",
	"steelblock_green",
	"steelblock_grey",
	"steelblock_magenta",
	"steelblock_orange",
	"steelblock_pink",
	"steelblock_red",
	"steelblock_violet",
	"steelblock_white",
	"steelblock_yellow",
	
	"copperblock_blue",
	"copperblock_black",
	"copperblock_brown",
	"copperblock_cyan",
	"copperblock_dark_green",
	"copperblock_dark_grey",
	"copperblock_green",
	"copperblock_grey",
	"copperblock_magenta",
	"copperblock_orange",
	"copperblock_pink",
	"copperblock_red",
	"copperblock_violet",
	"copperblock_white",
	"copperblock_yellow",

	"bronzeblock_blue",
	"bronzeblock_black",
	"bronzeblock_brown",
	"bronzeblock_cyan",
	"bronzeblock_dark_green",
	"bronzeblock_dark_grey",
	"bronzeblock_green",
	"bronzeblock_grey",
	"bronzeblock_magenta",
	"bronzeblock_orange",
	"bronzeblock_pink",
	"bronzeblock_red",
	"bronzeblock_violet",
	"bronzeblock_white",
	"bronzeblock_yellow",	
	
	"tinblock_blue",
	"tinblock_black",
	"tinblock_brown",
	"tinblock_cyan",
	"tinblock_dark_green",
	"tinblock_dark_grey",
	"tineblock_green",
	"tinblock_grey",
	"tinblock_magenta",
	"tinblock_orange",
	"tinblock_pink",
	"tinblock_red",
	"tinblock_violet",
	"tinblock_white",
	"tinblock_yellow",
	
	"goldblock_blue",
	"goldblock_black",
	"goldblock_brown",
	"goldblock_cyan",
	"goldblock_dark_green",
	"goldblock_dark_grey",
	"goldeblock_green",
	"goldblock_grey",
	"goldblock_magenta",
	"goldblock_orange",
	"goldblock_pink",
	"goldblock_red",
	"goldblock_violet",
	"goldblock_white",
	"goldblock_yellow"
}

for _, name in pairs(default_nodes) do
	local nodename = "default:"..name
	local a,b = string.find(name, ":")
	if b then
		nodename = name
		name = string.sub(name, b+1)
	end
	local ndef = minetest.registered_nodes[nodename]
	if ndef then
		local drop
		if type(ndef.drop) == "string" then
			drop = ndef.drop:sub((b or 8)+1)
		end

		local tiles = ndef.tiles
		if #ndef.tiles > 1 and ndef.drawtype:find("glass") then
			tiles = { ndef.tiles[1] }
		end

		stairsplus:register_all("moreblocks", name, nodename, {
			description = ndef.description,
			drop = drop,
			groups = ndef.groups,
			sounds = ndef.sounds,
			tiles = tiles,
			sunlight_propagates = true,
			light_source = ndef.light_source
		})
	end
end

-- wool registrations

if minetest.get_modpath("wool") then

	local colorlist = {
		{"white",      "White Wool"},
		{"grey",       "Grey Wool"},
		{"black",      "Black Wool"},
		{"red",        "Red Wool"},
		{"yellow",     "Yellow Wool"},
		{"green",      "Green Wool"},
		{"cyan",       "Cyan Wool"},
		{"blue",       "Blue Wool"},
		{"magenta",    "Magenta Wool"},
		{"orange",     "Orange Wool"},
		{"violet",     "Violet Wool"},
		{"brown",      "Brown Wool"},
		{"pink",       "Pink Wool"},
		{"dark_grey",  "Dark Grey Wool"},
		{"dark_green", "Dark Green Wool"},
	}

	for i in ipairs(colorlist) do
		local color = colorlist[i][1]
		local colordesc = colorlist[i][2]
		
		stairsplus:register_all("wool", color, "wool:"..color, {
			description = colordesc,
			tiles = {"wool_"..color..".png"},
			groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,
					flammable=3,wool=1,not_in_creative_inventory=1},
			sounds = default.node_sound_defaults(),
			sunlight_propagates = true,
		})
	end
end
