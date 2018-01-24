

-- Simple shaped bed

default.register_bed("default:bed", {
	description = "Simple Bed",
	inventory_image = "beds_bed.png",
	wield_image = "beds_bed.png",
	tiles = {
		bottom = {
			"default_steel_block.png^[colorize:#BB0000:180",
			"default_steel_block.png^[colorize:#a78c4570:180",
			"default_steel_block.png^[colorize:#BB0000:180.png",
			"default_steel_block.png^[colorize:#BB0000:180.png",
			"beds_transparent.png",
			"default_steel_block.png^[colorize:#BB0000:180"
		},
		top = {
			"default_steel_block.png^[colorize:#BBBBBB:180",
			"default_steel_block.png^[colorize:#a78c4570:180",
			"default_steel_block.png^[colorize:#BBBBBB:180.png",
			"default_steel_block.png^[colorize:#BBBBBB:180.png",
			"default_steel_block.png^[colorize:#FFFFFF:180",
			"beds_transparent.png",
		}
	},
	nodebox = {
		bottom = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
		top = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	recipe = {
		{"default:steelblock_red", "default:steelblock_red", "default:steelblock_white"},
		{"default:steelblock_brown", "default:steelblock_brown", "default:steelblock_brown"}
	},
})

-- Aliases for PilzAdam's beds mod

minetest.register_alias("default:bed_bottom_red", "default:bed_bottom")
minetest.register_alias("default:bed_top_red", "default:bed_top")

-- Fuel

minetest.register_craft({
	type = "fuel",
	recipe = "default:fancy_bed_bottom",
	burntime = 13,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:bed_bottom",
	burntime = 12,
})
