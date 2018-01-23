-- Minetest 0.4 mod: bucket
-- See README.txt for licensing and other information.

minetest.register_alias("bucket", "default:bucket_empty")
minetest.register_alias("bucket_water", "default:bucket_water")
minetest.register_alias("bucket_lava", "default:bucket_lava")

minetest.register_craft({
	output = 'default:bucket_empty 3',
	recipe = {
		{'default:wall_steelblock_white', '', 'default:wall_steelblock_white'},
		{'', 'default:wall_steelblock_white', ''},
	}
})

bucket = {}
default.liquids = {}

local function check_protection(pos, name, text)
	if minetest.is_protected(pos, name) then
		minetest.log("action", (name ~= "" and name or "A mod")
			.. " tried to " .. text
			.. " at protected position "
			.. minetest.pos_to_string(pos)
			.. " with a bucket")
		minetest.record_protection_violation(pos, name)
		return true
	end
	return false
end

-- Register a new liquid
--    source = name of the source node
--    flowing = name of the flowing node
--    itemname = name of the new bucket item (or nil if liquid is not takeable)
--    inventory_image = texture of the new bucket item (ignored if itemname == nil)
--    name = text description of the bucket item
--    groups = (optional) groups of the bucket item, for example {water_bucket = 1}
--    force_renew = (optional) bool. Force the liquid source to renew if it has a
--                  source neighbour, even if defined as 'liquid_renewable = false'.
--                  Needed to avoid creating holes in sloping rivers.
-- This function can be called from any mod (that depends on bucket).
function default.register_liquid(source, flowing, itemname, inventory_image, name,
		groups, force_renew)
	default.liquids[source] = {
		source = source,
		flowing = flowing,
		itemname = itemname,
		force_renew = force_renew,
	}
	default.liquids[flowing] = default.liquids[source]

	if itemname ~= nil then
		minetest.register_craftitem(itemname, {
			description = name,
			inventory_image = inventory_image,
			stack_max = 1,
			liquids_pointable = true,
			groups = groups,

			on_place = function(itemstack, user, pointed_thing)
				-- Must be pointing to node
				if pointed_thing.type ~= "node" then
					return
				end

				local node = minetest.get_node_or_nil(pointed_thing.under)
				local ndef = node and minetest.registered_nodes[node.name]

				-- Call on_rightclick if the pointed node defines it
				if ndef and ndef.on_rightclick and
						not (user and user:is_player() and
						user:get_player_control().sneak) then
					return ndef.on_rightclick(
						pointed_thing.under,
						node, user,
						itemstack)
				end

				local lpos

				-- Check if pointing to a buildable node
				if ndef and ndef.buildable_to then
					-- buildable; replace the node
					lpos = pointed_thing.under
				else
					-- not buildable to; place the liquid above
					-- check if the node above can be replaced

					lpos = pointed_thing.above
					node = minetest.get_node_or_nil(lpos)
					local above_ndef = node and minetest.registered_nodes[node.name]

					if not above_ndef or not above_ndef.buildable_to then
						-- do not remove the bucket with the liquid
						return itemstack
					end
				end

				if check_protection(lpos, user
						and user:get_player_name()
						or "", "place "..source) then
					return
				end

				minetest.set_node(lpos, {name = source})
				return ItemStack("default:bucket_empty")
			end
		})
	end
end

minetest.register_craftitem("default:bucket_empty", {
	description = "Empty Bucket",
	inventory_image = "bucket.png",
	stack_max = 99,
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type == "object" then
			pointed_thing.ref:punch(user, 1.0, { full_punch_interval=1.0 }, nil)
			return user:get_wielded_item()
		elseif pointed_thing.type ~= "node" then
			-- do nothing if it's neither object nor node
			return
		end
		-- Check if pointing to a liquid source
		local node = minetest.get_node(pointed_thing.under)
		local liquiddef = default.liquids[node.name]
		local item_count = user:get_wielded_item():get_count()

		if liquiddef ~= nil
		and liquiddef.itemname ~= nil
		and node.name == liquiddef.source then
			if check_protection(pointed_thing.under,
					user:get_player_name(),
					"take ".. node.name) then
				return
			end

			-- default set to return filled bucket
			local giving_back = liquiddef.itemname

			-- check if holding more than 1 empty bucket
			if item_count > 1 then

				-- if space in inventory add filled bucked, otherwise drop as item
				local inv = user:get_inventory()
				if inv:room_for_item("main", {name=liquiddef.itemname}) then
					inv:add_item("main", liquiddef.itemname)
				else
					local pos = user:getpos()
					pos.y = math.floor(pos.y + 0.5)
					minetest.add_item(pos, liquiddef.itemname)
				end

				-- set to return empty buckets minus 1
				giving_back = "default:bucket_empty "..tostring(item_count-1)

			end

			-- force_renew requires a source neighbour
			local source_neighbor = false
			if liquiddef.force_renew then
				source_neighbor =
					minetest.find_node_near(pointed_thing.under, 1, liquiddef.source)
			end
			if not (source_neighbor and liquiddef.force_renew) then
				minetest.add_node(pointed_thing.under, {name = "air"})
			end

			return ItemStack(giving_back)
		else
			-- non-liquid nodes will have their on_punch triggered
			local node_def = minetest.registered_nodes[node.name]
			if node_def then
				node_def.on_punch(pointed_thing.under, node, user, pointed_thing)
			end
			return user:get_wielded_item()
		end
	end,
})

default.register_liquid(
	"default:water_source",
	"default:water_flowing",
	"default:bucket_water",
	"bucket_water.png",
	"Water Bucket",
	{water_bucket = 1}
)

default.register_liquid(
	"default:lava_source",
	"default:lava_flowing",
	"default:bucket_lava",
	"bucket_lava.png",
	"Lava Bucket"
)

minetest.register_craft({
	type = "fuel",
	recipe = "default:bucket_lava",
	burntime = 60,
	replacements = {{"default:bucket_lava", "default:bucket_empty"}},
})

--[[
License of source code
----------------------

GNU Lesser General Public License, version 2.1
Copyright (C) 2011-2016 Kahrl <kahrl@gmx.net>
Copyright (C) 2011-2016 celeron55, Perttu Ahola <celeron55@gmail.com>
Copyright (C) 2011-2016 Various Minetest developers and contributors

This program is free software; you can redistribute it and/or modify it under the terms
of the GNU Lesser General Public License as published by the Free Software Foundation;
either version 2.1 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU Lesser General Public License for more details:
https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html


Licenses of media (textures)
----------------------------

Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)
Copyright (C) 2015-2016 ElementW

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


Minetest Game mod: bucket
=========================
See license.txt for license information.

Authors of source code
----------------------
Kahrl <kahrl@gmx.net> (LGPL 2.1)
celeron55, Perttu Ahola <celeron55@gmail.com> (LGPL 2.1)
Various Minetest developers and contributors (LGPL 2.1)

Authors of media (textures)
---------------------------
ElementW (CC BY-SA 3.0)




]]