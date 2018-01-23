

default.register = function(wall_name, wall_desc, wall_texture, wall_mat, wall_sounds)
	-- inventory node, and pole-type wall start item
	minetest.register_node(wall_name, {
		description = wall_desc,
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {{-1/4, -1/2, -1/4, 1/4, 1/2, 1/4}},
			-- connect_bottom =
			connect_front = {{-3/16, -1/2, -1/2,  3/16, 3/8, -1/4}},
			connect_left = {{-1/2, -1/2, -3/16, -1/4, 3/8,  3/16}},
			connect_back = {{-3/16, -1/2,  1/4,  3/16, 3/8,  1/2}},
			connect_right = {{ 1/4, -1/2, -3/16,  1/2, 3/8,  3/16}},
		},
		connects_to = { "group:wall", "group:stone" },
		paramtype = "light",
		is_ground_content = false,
		tiles = { wall_texture, },
		walkable = true,
		groups = { cracky = 3, wall = 1, stone = 2},
		sounds = wall_sounds,
	})

	-- crafting recipe
	minetest.register_craft({
		output = wall_name .. " 6",
		recipe = {
			{ '', '', '' },
			{ wall_mat, wall_mat, wall_mat},
			{ wall_mat, wall_mat, wall_mat},
		}
	})

end
--[[
default.register("default:wall_cobble", "Cobblestone Wall", "default_cobble.png",
		"default:cobble", default.node_sound_stone_defaults())

default.register("default:wall_mossycobble", "Mossy Cobblestone Wall", "default_mossycobble.png",
		"default:mossycobble", default.node_sound_stone_defaults())

]]

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



default.register("default:wall_steelblock",
"Steelblock Wall",
"default_steel_block.png",
"default:steelblock",
default.node_sound_metal_defaults()
)

default.register("default:wall_steelblock_" .. colours[i][1],
colours[i][2] .. " Steelblock",
"default_steel_block.png^[colorize:" .. colours[i][3],
"default:steelblock_" .. colours[i][1],
default.node_sound_metal_defaults()
)
--[[
default.register("default:wall_steelblock_" .. colours[i][1],
colours[i][2] .. " Steelblock",
"default_steel_block.png^[colorize:" .. colours[i][3],
"default:steelblock_brown",
default.node_sound_metal_defaults()
)

default.register("default:wall_steelblock_" .. colours[i][1],
colours[i][2] .. " Steelblock",
"default_steel_block.png^[colorize:" .. colours[i][3],
"default:steelblock_orange",
default.node_sound_metal_defaults()
)

default.register("default:wall_steelblock_" .. colours[i][1],
colours[i][2] .. " Steelblock",
"default_steel_block.png^[colorize:" .. colours[i][3],
"default:steelblock_cyan",
default.node_sound_metal_defaults()
)
]]		
end		