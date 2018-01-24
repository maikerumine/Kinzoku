-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.


-- Namespace for functions

--flowers = {}


-- Map Generation

dofile(minetest.get_modpath("default") .. "/flowers_mapgen.lua")


--
-- Flowers
--

-- Aliases for original flowers mod

minetest.register_alias("flowers:flowers_rose", "default:rose")
minetest.register_alias("flowers:flowers_tulip", "default:tulip")
minetest.register_alias("flowers:flowers_dandelion_yellow", "default:dandelion_yellow")
minetest.register_alias("flowers:flowers_geranium", "default:geranium")
minetest.register_alias("flowers:flowers_viola", "default:viola")
minetest.register_alias("flowers:flowers_dandelion_white", "default:dandelion_white")


-- Flower registration

local function add_simple_flower(name, desc, box, f_groups)
	-- Common flowers' groups
	f_groups.snappy = 3
	f_groups.flower = 1
	f_groups.flora = 1
	f_groups.attached_node = 1

	minetest.register_node("default:" .. name, {
		description = desc,
		--drawtype = "plantlike",
		waving = 1,
			drawtype = "nodebox",
			node_box = {
			type = "fixed",
			fixed = box
			--fixed = {-0.25, -0.5, 0, 0, 0, 0.25}
			},
		--tiles = {"default_steel_block.png^[colorize:#FF0000:200"},
		tiles = {"flowers_" .. name .. ".png"},
		inventory_image =  name .. ".png",
		wield_image = "flowers_" .. name .. ".png",
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		stack_max = 99,
		groups = f_groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = box
		}
	})
end

default.datas = {
	{
		"flowers_rose",
		"Red Rose",
		{-2 / 16, -0.5, -2 / 16, 2 / 16, 5 / 16, 2 / 16},
		{color_red = 1, flammable = 1}
	},
	{
		"flowers_tulip",
		"Orange Tulip",
		{-2 / 16, -0.5, -2 / 16, 2 / 16, 3 / 16, 2 / 16},
		{color_orange = 1, flammable = 1}
	},
	{
		"flowers_dandelion_yellow",
		"Yellow Dandelion",
		{-4 / 16, -0.5, -4 / 16, 4 / 16, -2 / 16, 4 / 16},
		{color_yellow = 1, flammable = 1}
	},
	{
		"flowers_geranium",
		"Blue Geranium",
		{-2 / 16, -0.5, -2 / 16, 2 / 16, 2 / 16, 2 / 16},
		{color_blue = 1, flammable = 1}
	},
	{
		"flowers_viola",
		"Viola",
		{-5 / 16, -0.5, -5 / 16, 5 / 16, -1 / 16, 5 / 16},
		{color_violet = 1, flammable = 1}
	},
	{
		"flowers_dandelion_white",
		"White Dandelion",
		{-5 / 16, -0.5, -5 / 16, 5 / 16, -2 / 16, 5 / 16},
		{color_white = 1, flammable = 1}
	},
}

for _,item in pairs(default.datas) do
	add_simple_flower(unpack(item))
end


-- Flower spread
-- Public function to enable override by mods

function default.flower_spread(pos, node)
	pos.y = pos.y - 1
	local under = minetest.get_node(pos)
	pos.y = pos.y + 1
	-- Replace flora with dry shrub in desert sand and silver sand,
	-- as this is the only way to generate them.
	-- However, preserve grasses in sand dune biomes.
	if minetest.get_item_group(under.name, "sand") == 1 and
			under.name ~= "default:steelblock_yellow" then
		minetest.set_node(pos, {name = "default:dry_shrub"})
		return
	end

	if minetest.get_item_group(under.name, "soil") == 0 then
		return
	end

	local light = minetest.get_node_light(pos)
	if not light or light < 13 then
		return
	end

	local pos0 = vector.subtract(pos, 4)
	local pos1 = vector.add(pos, 4)
	if #minetest.find_nodes_in_area(pos0, pos1, "group:flora") > 3 then
		return
	end

	local soils = minetest.find_nodes_in_area_under_air(
		pos0, pos1, "group:soil")
	if #soils > 0 then
		local seedling = soils[math.random(#soils)]
		local seedling_above =
			{x = seedling.x, y = seedling.y + 1, z = seedling.z}
		light = minetest.get_node_light(seedling_above)
		if not light or light < 13 or
				-- Desert sand is in the soil group
				minetest.get_node(seedling).name == "default:steelblock_orange" then
			return
		end

		minetest.set_node(seedling_above, {name = node.name})
	end
end

minetest.register_abm({
	label = "Flower spread",
	nodenames = {"group:flora"},
	interval = 13,
	chance = 96,
	action = function(...)
		default.flower_spread(...)
	end,
})


--
-- Mushrooms
--

minetest.register_node("default:mushroom_red", {
	description = "Red Mushroom",
	tiles = {"flowers_flowers_mushroom_red.png"},
	inventory_image = "flowers_mushroom_red.png",
	wield_image = "flowers_mushroom_red.png",
			drawtype = "nodebox",
			node_box = {
			type = "fixed",
			--fixed = {-0.25, -0.5, 0, 0, 0, 0.25}
			fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
			},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	on_use = minetest.item_eat(-5),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	}
})

minetest.register_node("default:mushroom_brown", {
	description = "Brown Mushroom",
	tiles = {"flowers_flowers_mushroom_brown.png"},
	inventory_image = "flowers_mushroom_brown.png",
	wield_image = "flowers_mushroom_brown.png",
			drawtype = "nodebox",
			node_box = {
			type = "fixed",
			--fixed = {-0.25, -0.5, 0, 0, 0, 0.25}
			fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, -2 / 16, 3 / 16},
			},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, attached_node = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	on_use = minetest.item_eat(1),
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, -2 / 16, 3 / 16},
	}
})


-- Mushroom spread and death

minetest.register_abm({
	label = "Mushroom spread",
	nodenames = {"default:mushroom_brown", "default:mushroom_red"},
	interval = 11,
	chance = 50,
	action = function(pos, node)
		if minetest.get_node_light(pos, nil) == 15 then
			minetest.remove_node(pos)
			return
		end
		local random = {
			x = pos.x + math.random(-2, 2),
			y = pos.y + math.random(-1, 1),
			z = pos.z + math.random(-2, 2)
		}
		local random_node = minetest.get_node_or_nil(random)
		if not random_node or random_node.name ~= "air" then
			return
		end
		local node_under = minetest.get_node_or_nil({x = random.x,
			y = random.y - 1, z = random.z})
		if not node_under then
			return
		end

		if (minetest.get_item_group(node_under.name, "soil") ~= 0 or
				minetest.get_item_group(node_under.name, "tree") ~= 0) and
				minetest.get_node_light(pos, 0.5) <= 3 and
				minetest.get_node_light(random, 0.5) <= 3 then
			minetest.set_node(random, {name = node.name})
		end
	end
})


-- These old mushroom related nodes can be simplified now

minetest.register_alias("default:mushroom_spores_brown", "default:mushroom_brown")
minetest.register_alias("default:mushroom_spores_red", "default:mushroom_red")
minetest.register_alias("default:mushroom_fertile_brown", "default:mushroom_brown")
minetest.register_alias("default:mushroom_fertile_red", "default:mushroom_red")
minetest.register_alias("mushroom:brown_natural", "default:mushroom_brown")
minetest.register_alias("mushroom:red_natural", "default:mushroom_red")
minetest.register_alias("flowers:mushroom_brown", "default:mushroom_brown")
minetest.register_alias("flowers:mushroom_red", "default:mushroom_red")
minetest.register_alias("flowers:waterlily", "default:waterlily")


--
-- Waterlily
--

minetest.register_node("default:waterlily", {
	description = "Waterlily",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {"flowers_flowers_waterlily.png", "flowers_flowers_waterlily_bottom.png^[colorize:#CCCCCC:33"},
	inventory_image = "flowers_waterlily.png",
	wield_image = "flowers_waterlily.png",
	liquids_pointable = true,
	walkable = true,
	buildable_to = true,
	sunlight_propagates = true,
	floodable = true,
	groups = {snappy = 3, flower = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	node_placement_prediction = "",
	node_box = {
		type = "fixed",
		--fixed = {-0.5, -31 / 64, -0.5, 0.5, -15 / 32, 0.5}
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, -15 / 32, 7 / 16}
	},
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, -15 / 32, 7 / 16}
	},

	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		local node = minetest.get_node(pointed_thing.under).name
		local def = minetest.registered_nodes[node]
		local player_name = placer:get_player_name()

		if def and def.liquidtype == "source" and
				minetest.get_item_group(node, "water") > 0 then
			if not minetest.is_protected(pos, player_name) then
				minetest.set_node(pos, {name = "default:waterlily",
					param2 = math.random(0, 3)})
				if not (creative and creative.is_enabled_for
						and creative.is_enabled_for(player_name)) then
					itemstack:take_item()
				end
			else
				minetest.chat_send_player(player_name, "Node is protected")
				minetest.record_protection_violation(pos, player_name)
			end
		end

		return itemstack
	end
})


--[[
License of source code
----------------------

The MIT License (MIT)
Copyright (C) 2012-2016 Ironzorg, VanessaE
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
Copyright (C) 2014-2016 RHRhino
Copyright (C) 2015-2016 Gambit
Copyright (C) 2016 yyt16384
Copyright (C) 2017 paramat

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


Minetest Game mod: flowers
==========================
See license.txt for license information.

Authors of source code
----------------------
Originally by Ironzorg (MIT) and VanessaE (MIT)
Various Minetest developers and contributors (MIT)

Authors of media (textures)
---------------------------
RHRhino (CC BY-SA 3.0):
  flowers_dandelion_white.png
  flowers_geranium.png
  flowers_rose.png
  flowers_tulip.png
  flowers_viola.png

Gambit (CC BY-SA 3.0):
  flowers_mushroom_brown.png
  flowers_mushroom_red.png
  flowers_waterlily.png

yyt16384 (CC BY-SA 3.0):
  flowers_waterlily_bottom.png -- Derived from Gambit's texture

paramat (CC BY-SA 3.0):
  flowers_dandelion_yellow.png -- Derived from RHRhino's texture



]]