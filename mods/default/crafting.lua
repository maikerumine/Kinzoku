-- mods/default/crafting.lua

minetest.register_craft({
	output = 'default:torch 4',
	recipe = {
		{'default:wall_steelblock_black'},
		{'default:wall_steelblock_brown'},
	}
})


minetest.register_craft({
	output = 'default:chest',
	recipe = {
		{'default:wall_steelblock_brown', 'default:wall_steelblock_brown', 'default:wall_steelblock_brown'},
		{'default:wall_steelblock_brown', '', 'default:wall_steelblock_brown'},
		{'default:wall_steelblock_brown', 'default:wall_steelblock_brown', 'default:wall_steelblock_brown'},
	}
})

minetest.register_craft({
	output = 'default:chest_locked',
	recipe = {
		{'default:wall_steelblock_brown', 'default:wall_steelblock_brown', 'default:wall_steelblock_brown'},
		{'default:wall_steelblock_brown', 'default:steelblock', 'default:wall_steelblock_brown'},
		{'default:wall_steelblock_brown', 'default:wall_steelblock_brown', 'default:wall_steelblock_brown'},
	}
})

minetest.register_craft( {
	type = "shapeless",
	output = "default:chest_locked",
	recipe = {"default:chest", "default:steelblock"},
})

minetest.register_craft({
	output = 'default:sign_wall_steel 12',
	recipe = {
		{'default:steelblock', 'default:steelblock', 'default:steelblock'},
		{'default:steelblock', 'default:steelblock', 'default:steelblock'},
		{'', 'default:wall_steelblock_brown', ''},
	}
})

minetest.register_craft({
	output = 'default:ladder_steel 60',
	recipe = {
		{'default:wall_steelblock_white', '', 'default:wall_steelblock_white'},
		{'default:wall_steelblock_white', 'default:wall_steelblock_white', 'default:wall_steelblock_white'},
		{'default:wall_steelblock_white', '', 'default:wall_steelblock_white'},
	}
})




--
-- Crafting (tool repair)
--
minetest.register_craft({
	type = "toolrepair",
	additional_wear = -0.02,
})
