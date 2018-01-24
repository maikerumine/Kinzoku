--Originally made by TenPlus1
--maikerumine added slabs and stairs
--20160321
--20171121  -added more blocks and intergrate with moreblocks / stairs plus
--for extreme survival game

local colours = {
	{"black",      "Black",      "#000000b0"},
	{"blue",       "Blue",       "#015dbb70"},
	{"brown",      "Brown",      "#a78c4570"},
	{"cyan",       "Cyan",       "#01ffd870"},
	{"dark_green", "Dark Green", "#005b0770"},
	{"dark_grey",  "Dark Grey",  "#303030b0"},
	{"green",      "Green",      "#61ff0170"},
	{"grey",       "Grey",       "#5b5b5bb0"},
	{"magenta",    "Magenta",    "#ff05bb70"},
	{"orange",     "Orange",     "#ff840170"},
	{"pink",       "Pink",       "#ff65b570"},
	{"red",        "Red",        "#ff000070"},
	{"violet",     "Violet",     "#2000c970"},
	{"white",      "White",      "#abababc0"},
	{"yellow",     "Yellow",     "#e3ff0070"},
}

for i = 1, #colours, 1 do
--example
--[[
minetest.register_node("default:stonebrick_red", {
	description = "Red Stone Brick -EXAMPLE FOR ALL default: Glass, Wood, Stonebrick, and Clay",
	tiles = {"default_stone_brick.png^[colorize:#ff000070"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
]]



--Steelblock
minetest.register_node( "default:steelblock_" .. colours[i][1], {
	description = colours[i][2] .. " Steelblock",
	tiles = {"default_steel_block.png^[colorize:" .. colours[i][3]},
	is_ground_content = false,
	--groups = {cracky = 2, soil = 1, tree = 1, not_in_craft_guide=1},
	groups = {cracky = 2, soil = 1, tree = 1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock","default:steelblock", "dye:" .. colours[i][1]},
	}
})


--[[
--Bronzeblock
minetest.register_node( "default:bronzeblock_" .. colours[i][1], {
	description = colours[i][2] .. " Bronzeblock",
	tiles = {"default_bronze_block.png^[colorize:" .. colours[i][3]},
	is_ground_content = false,
	groups = {cracky = 3, not_in_craft_guide=1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "default:bronzeblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:bronzeblock","default:bronzeblock", "dye:" .. colours[i][1]},
	}
})

--Copperblock
minetest.register_node( "default:copperblock_" .. colours[i][1], {
	description = colours[i][2] .. " Copperblock",
	tiles = {"default_copper_block.png^[colorize:" .. colours[i][3]},
	is_ground_content = false,
	groups = {cracky = 3, not_in_craft_guide=1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "default:copperblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:copperblock","default:copperblock", "dye:" .. colours[i][1]},
	}
})

--Tinblock
minetest.register_node( "default:tinblock_" .. colours[i][1], {
	description = colours[i][2] .. " Tinblock",
	tiles = {"default_tin_block.png^[colorize:" .. colours[i][3]},
	is_ground_content = false,
	groups = {cracky = 3, not_in_craft_guide=1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "default:tinblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:tinblock","default:tinblock", "dye:" .. colours[i][1]},
	}
})

--Goldblock
minetest.register_node( "default:goldblock_" .. colours[i][1], {
	description = colours[i][2] .. " Goldblock",
	tiles = {"default_gold_block.png^[colorize:" .. colours[i][3]},
	is_ground_content = false,
	groups = {cracky = 3, not_in_craft_guide=1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "default:goldblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:goldblock","default:goldblock", "dye:" .. colours[i][1]},
	}
})
]]
		
--[[		
if minetest.get_modpath("moreblocks") then


--Steelblock
	stairsplus:register_all("steelblock_" .. colours[i][1], "steelblock", "default:steelblock_" .. colours[i][1], {
		description = "Coloured Steelblock",
		tiles ={"default_steel_block.png^[colorize:" .. colours[i][3]},
		groups = {cracky = 3},
		sounds = default.node_sound_metal_defaults(),
		sunlight_propagates = true,
	})

end
]]

end



--[[

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO. 
  
  
  
  CBlocks (Coloured Blocks) mod for Minetest

This mod adds coloured wood and stonebrick blocks to the game without the need for any additional textures.  To craft place 2 wood or stonebrick blocks and then 1 coloured dye.

https://forum.minetest.net/viewtopic.php?f=9&t=13303

Released under WTFPL

0.1 - Initial release
0.2 - Added coloured glass and fixed violet
0.3 - Added stair and slabs -maikerumine 20160321
0.4 - Added clay to the mix -maikerumine 20160331


]]