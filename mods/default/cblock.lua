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
--[[
	{"gunmetal",   "Gunmetal",   "#2c353999"},
	{"dark_slate_grey",   "Dark Slate Grey",   "#25383c99"},
	{"metallic_silver",   "Metallic Silver",   "#bcc6cc99"},
	{"blue_marble",   "Blue Marble",   "#566d7e99"},
	{"blue_steel",   "Blue Steel",   "#4863a099"},
	{"blue_jay",   "Blue Jay",   "#2b547e99"},
	{"blue_navy",   "Blue Navy",   "#00008099"},
	{"blue_orchid",   "Blue Orchid",   "#1f45fc99"},
	{"blue_dodger",   "Blue Dodger",   "#1589ff99"},
	{"blue_sea",   "Blue Sea",   "#c2dfff99"},
	{"blue_electric",   "Blue Electric",   "#9afeff99"},
	{"blue_green",   "Blue Green",   "#7bccb599"},
	
	{"green_light_sea",   "Green Light Sea",   "#3ea99f99"},
	{"green_sea_turtle",   "Green Sea Turtle",   "#438d8099"},
	{"greenish_blue",   "Greenish Blue",   "#307d7e99"},
	{"green_teal",   "Green Teal",   "#00808099"},
	{"green_sea",   "Green Sea",   "#4e897599"},
	{"green_camouflage",   "Green Camouflage",   "#78866b99"},
	{"green_sage",   "Green Sage",   "#78866b99"},
	{"green_hazel",   "Green Hazel",   "#617c5899"},
	{"green_venom",   "Green Venom",   "#728c0099"},
	{"green_fern",   "Green Fern",   "#667c2699"},
	{"green_dark_forest",   "Green Dark Forest",   "#25411799"},
	]]
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
		{"default:steelblock","default:steelblock", "default:" .. colours[i][1]},
	}
})
--[[
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
	]]
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_black" ,"default:steelblock_black", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_blue" ,"default:steelblock_blue", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_brown" ,"default:steelblock_brown", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_cyan" ,"default:steelblock_cyan", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_dark_green" ,"default:steelblock_dark_green", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_dark_grey" ,"default:steelblock_dark_grey", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_green" ,"default:steelblock_green", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_grey" ,"default:steelblock_grey", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_magenta" ,"default:steelblock_magenta", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_orange" ,"default:steelblock_orange", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_pink" ,"default:steelblock_pink", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_red" ,"default:steelblock_red", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_violet" ,"default:steelblock_violet", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_white" ,"default:steelblock_white", "default:" .. colours[i][1]},
	}
})
minetest.register_craft({
	output = "default:steelblock_".. colours[i][1] .. " 2",
	recipe = {
		{"default:steelblock_yellow" ,"default:steelblock_yellow", "default:" .. colours[i][1]},
	}
})


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