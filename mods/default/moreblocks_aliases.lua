--[[
More Blocks: alias definitions

Copyright (c) 2011-2017 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
--]]

-- More Blocks aliases:
minetest.register_alias("sweeper", "default:sweeper")
minetest.register_alias("circular_saw", "default:circular_saw")
minetest.register_alias("jungle_stick", "default:jungle_stick")

-- Old block/item replacement:
minetest.register_alias("default:oerkkiblock", "default:mossycobble")
minetest.register_alias("default:screwdriver", "screwdriver:screwdriver")

-- Node and item renaming:
minetest.register_alias("default:stone_bricks", "default:stonebrick")
minetest.register_alias("default:stonebrick", "default:stonebrick")
minetest.register_alias("default:junglewood", "default:junglewood")
minetest.register_alias("default:jungle_wood", "default:junglewood")
minetest.register_alias("default:fence_jungle_wood", "default:fence_junglewood")
minetest.register_alias("default:jungle_stick", "default:stick")

for _, t in pairs(circular_saw.names) do
	minetest.register_alias("default:" .. t[1] .. "_jungle_wood" .. t[2],
			"default:" .. t[1] .. "_junglewood" .. t[2])
end
minetest.register_alias("default:horizontaltree", "default:horizontal_tree")
minetest.register_alias("default:horizontaljungletree", "default:horizontal_jungle_tree")
minetest.register_alias("default:stonesquare", "default:stone_tile")
minetest.register_alias("default:circlestonebrick", "default:circle_stone_bricks")
minetest.register_alias("default:ironstonebrick", "default:iron_stone_bricks")
minetest.register_alias("default:fence_junglewood", "default:fence_jungle_wood")
minetest.register_alias("default:coalstone", "default:coal_stone")
minetest.register_alias("default:ironstone", "default:iron_stone")
minetest.register_alias("default:woodtile", "default:wood_tile")
minetest.register_alias("default:woodtile_full", "default:wood_tile_full")
minetest.register_alias("default:woodtile_centered", "default:wood_tile_centered")
minetest.register_alias("default:woodtile_up", "default:wood_tile_up")
minetest.register_alias("default:woodtile_down", "default:wood_tile_down")
minetest.register_alias("default:woodtile_left", "default:wood_tile_left")
minetest.register_alias("default:woodtile_right", "default:wood_tile_right")
minetest.register_alias("default:coalglass", "default:coal_glass")
minetest.register_alias("default:ironglass", "default:iron_glass")
minetest.register_alias("default:glowglass", "default:glow_glass")
minetest.register_alias("default:superglowglass", "default:super_glow_glass")
minetest.register_alias("default:trapglass", "default:trap_glass")
minetest.register_alias("default:trapstone", "default:trap_stone")
minetest.register_alias("default:cactuschecker", "default:cactus_checker")
minetest.register_alias("default:coalchecker", "default:coal_checker")
minetest.register_alias("default:ironchecker", "default:iron_checker")
minetest.register_alias("default:cactusbrick", "default:cactus_brick")
minetest.register_alias("default:cleanglass", "default:clean_glass")
minetest.register_alias("default:emptybookshelf", "default:empty_bookshelf")
minetest.register_alias("default:junglestick", "default:jungle_stick")
minetest.register_alias("default:splitstonesquare","default:split_stone_tile")
minetest.register_alias("default:allfacestree","default:all_faces_tree")

-- ABM for horizontal trees (fix facedir):
local horizontal_tree_convert_facedir = {7, 12, 9, 18}

minetest.register_abm({
	nodenames = {"default:horizontal_tree","default:horizontal_jungle_tree"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		if node.name == "default:horizontal_tree" then
			node.name = "default:tree"
		else
			node.name = "default:jungletree"
		end
		node.param2 = node.param2 < 3 and node.param2 or 0
		minetest.set_node(pos, {
			name = node.name,
			param2 = horizontal_tree_convert_facedir[node.param2 + 1]
		})
	end,
})
