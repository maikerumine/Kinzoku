-- our API object
--default = {}

-- private data
local _doors = {}
default.registered_doors = {}
default.registered_trapdoors = {}

local function replace_old_owner_information(pos)
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("doors_owner")
	if owner and owner ~= "" then
		meta:set_string("owner", owner)
		meta:set_string("doors_owner", "")
	end
end

-- returns an object to a door object or nil
function default.get(pos)
	local node_name = minetest.get_node(pos).name
	if _default.registered_doors[node_name] then
		-- A normal upright door
		return {
			pos = pos,
			open = function(self, player)
				if self:state() then
					return false
				end
				return _default.door_toggle(self.pos, nil, player)
			end,
			close = function(self, player)
				if not self:state() then
					return false
				end
				return _default.door_toggle(self.pos, nil, player)
			end,
			toggle = function(self, player)
				return _default.door_toggle(self.pos, nil, player)
			end,
			state = function(self)
				local state = minetest.get_meta(self.pos):get_int("state")
				return state %2 == 1
			end
		}
	elseif _default.registered_trapdoors[node_name] then
		-- A trapdoor
		return {
			pos = pos,
			open = function(self, player)
				if self:state() then
					return false
				end
				return _default.trapdoor_toggle(self.pos, nil, player)
			end,
			close = function(self, player)
				if not self:state() then
					return false
				end
				return _default.trapdoor_toggle(self.pos, nil, player)
			end,
			toggle = function(self, player)
				return _default.trapdoor_toggle(self.pos, nil, player)
			end,
			state = function(self)
				return minetest.get_node(self.pos).name:sub(-5) == "_open"
			end
		}
	else
		return nil
	end
end

-- this hidden node is placed on top of the bottom, and prevents
-- nodes from being placed in the top half of the door.
minetest.register_node("default:hidden", {
	description = "Hidden Door Segment",
	-- can't use airlike otherwise falling nodes will turn to entities
	-- and will be forever stuck until door is removed.
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	-- has to be walkable for falling nodes to stop falling.
	walkable = true,
	pointable = false,
	diggable = false,
	buildable_to = false,
	floodable = false,
	drop = "",
	groups = {not_in_creative_inventory = 1},
	on_blast = function() end,
	tiles = {"doors_blank.png"},
	-- 1px transparent block inside door hinge near node top.
	node_box = {
		type = "fixed",
		fixed = {-15/32, 13/32, -15/32, -13/32, 1/2, -13/32},
	},
	-- collision_box needed otherise selection box would be full node size
	collision_box = {
		type = "fixed",
		fixed = {-15/32, 13/32, -15/32, -13/32, 1/2, -13/32},
	},
})

-- table used to aid door opening/closing
local transform = {
	{
		{v = "_a", param2 = 3},
		{v = "_a", param2 = 0},
		{v = "_a", param2 = 1},
		{v = "_a", param2 = 2},
	},
	{
		{v = "_b", param2 = 1},
		{v = "_b", param2 = 2},
		{v = "_b", param2 = 3},
		{v = "_b", param2 = 0},
	},
	{
		{v = "_b", param2 = 1},
		{v = "_b", param2 = 2},
		{v = "_b", param2 = 3},
		{v = "_b", param2 = 0},
	},
	{
		{v = "_a", param2 = 3},
		{v = "_a", param2 = 0},
		{v = "_a", param2 = 1},
		{v = "_a", param2 = 2},
	},
}

function default.door_toggle(pos, node, clicker)
	local meta = minetest.get_meta(pos)
	node = node or minetest.get_node(pos)
	local def = minetest.registered_nodes[node.name]
	local name = def.door.name

	local state = meta:get_string("state")
	if state == "" then
		-- fix up lvm-placed right-hinged doors, default closed
		if node.name:sub(-2) == "_b" then
			state = 2
		else
			state = 0
		end
	else
		state = tonumber(state)
	end

	replace_old_owner_information(pos)

	if clicker and not default.can_interact_with_node(clicker, pos) then
		return false
	end

	-- until Lua-5.2 we have no bitwise operators :(
	if state % 2 == 1 then
		state = state - 1
	else
		state = state + 1
	end

	local dir = node.param2
	if state % 2 == 0 then
		minetest.sound_play(def.door.sounds[1],
			{pos = pos, gain = 0.3, max_hear_distance = 10})
	else
		minetest.sound_play(def.door.sounds[2],
			{pos = pos, gain = 0.3, max_hear_distance = 10})
	end

	minetest.swap_node(pos, {
		name = name .. transform[state + 1][dir+1].v,
		param2 = transform[state + 1][dir+1].param2
	})
	meta:set_int("state", state)

	return true
end


local function on_place_node(place_to, newnode,
	placer, oldnode, itemstack, pointed_thing)
	-- Run script hook
	for _, callback in ipairs(minetest.registered_on_placenodes) do
		-- Deepcopy pos, node and pointed_thing because callback can modify them
		local place_to_copy = {x = place_to.x, y = place_to.y, z = place_to.z}
		local newnode_copy =
			{name = newnode.name, param1 = newnode.param1, param2 = newnode.param2}
		local oldnode_copy =
			{name = oldnode.name, param1 = oldnode.param1, param2 = oldnode.param2}
		local pointed_thing_copy = {
			type  = pointed_thing.type,
			above = vector.new(pointed_thing.above),
			under = vector.new(pointed_thing.under),
			ref   = pointed_thing.ref,
		}
		callback(place_to_copy, newnode_copy, placer,
			oldnode_copy, itemstack, pointed_thing_copy)
	end
end

local function can_dig_door(pos, digger)
	replace_old_owner_information(pos)
	if default.can_interact_with_node(digger, pos) then
		return true
	else
		minetest.record_protection_violation(pos, digger:get_player_name())
		return false
	end
end

function default.register(name, def)
	if not name:find(":") then
		name = "default:" .. name
	end

	-- replace old doors of this type automatically
	minetest.register_lbm({
		name = ":default:replace_" .. name:gsub(":", "_"),
		nodenames = {name.."_b_1", name.."_b_2"},
		action = function(pos, node)
			local l = tonumber(node.name:sub(-1))
			local meta = minetest.get_meta(pos)
			local h = meta:get_int("right") + 1
			local p2 = node.param2
			local replace = {
				{{type = "a", state = 0}, {type = "a", state = 3}},
				{{type = "b", state = 1}, {type = "b", state = 2}}
			}
			local new = replace[l][h]
			-- retain infotext and doors_owner fields
			minetest.swap_node(pos, {name = name .. "_" .. new.type, param2 = p2})
			meta:set_int("state", new.state)
			-- properly place default:hidden at the right spot
			local p3 = p2
			if new.state >= 2 then
				p3 = (p3 + 3) % 4
			end
			if new.state % 2 == 1 then
				if new.state >= 2 then
					p3 = (p3 + 1) % 4
				else
					p3 = (p3 + 3) % 4
				end
			end
			-- wipe meta on top node as it's unused
			minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z},
				{name = "default:hidden", param2 = p3})
		end
	})

	minetest.register_craftitem(":" .. name, {
		description = def.description,
		inventory_image = def.inventory_image,
		groups = table.copy(def.groups),

		on_place = function(itemstack, placer, pointed_thing)
			local pos

			if not pointed_thing.type == "node" then
				return itemstack
			end

			local node = minetest.get_node(pointed_thing.under)
			local pdef = minetest.registered_nodes[node.name]
			if pdef and pdef.on_rightclick and
					not (placer and placer:is_player() and
					placer:get_player_control().sneak) then
				return pdef.on_rightclick(pointed_thing.under,
						node, placer, itemstack, pointed_thing)
			end

			if pdef and pdef.buildable_to then
				pos = pointed_thing.under
			else
				pos = pointed_thing.above
				node = minetest.get_node(pos)
				pdef = minetest.registered_nodes[node.name]
				if not pdef or not pdef.buildable_to then
					return itemstack
				end
			end

			local above = {x = pos.x, y = pos.y + 1, z = pos.z}
			local top_node = minetest.get_node_or_nil(above)
			local topdef = top_node and minetest.registered_nodes[top_node.name]

			if not topdef or not topdef.buildable_to then
				return itemstack
			end

			local pn = placer and placer:get_player_name() or ""
			if minetest.is_protected(pos, pn) or minetest.is_protected(above, pn) then
				return itemstack
			end

			local dir = placer and minetest.dir_to_facedir(placer:get_look_dir()) or 0

			local ref = {
				{x = -1, y = 0, z = 0},
				{x = 0, y = 0, z = 1},
				{x = 1, y = 0, z = 0},
				{x = 0, y = 0, z = -1},
			}

			local aside = {
				x = pos.x + ref[dir + 1].x,
				y = pos.y + ref[dir + 1].y,
				z = pos.z + ref[dir + 1].z,
			}

			local state = 0
			if minetest.get_item_group(minetest.get_node(aside).name, "door") == 1 then
				state = state + 2
				minetest.set_node(pos, {name = name .. "_b", param2 = dir})
				minetest.set_node(above, {name = "default:hidden", param2 = (dir + 3) % 4})
			else
				minetest.set_node(pos, {name = name .. "_a", param2 = dir})
				minetest.set_node(above, {name = "default:hidden", param2 = dir})
			end

			local meta = minetest.get_meta(pos)
			meta:set_int("state", state)

			if def.protected then
				meta:set_string("owner", pn)
				meta:set_string("infotext", "Owned by " .. pn)
			end

			if not (creative and creative.is_enabled_for and creative.is_enabled_for(pn)) then
				itemstack:take_item()
			end

			minetest.sound_play(def.sounds.place, {pos = pos})

			on_place_node(pos, minetest.get_node(pos),
				placer, node, itemstack, pointed_thing)

			return itemstack
		end
	})
	def.inventory_image = nil

	if def.recipe then
		minetest.register_craft({
			output = name,
			recipe = def.recipe,
		})
	end
	def.recipe = nil

	if not def.sounds then
		def.sounds = default.node_sound_wood_defaults()
		--sounds = default.node_sound_wood_defaults(),
	end

	if not def.sound_open then
		def.sound_open = "doors_door_open"
	end

	if not def.sound_close then
		def.sound_close = "doors_door_close"
	end

	def.groups.not_in_creative_inventory = 1
	def.groups.door = 1
	def.drop = name
	def.door = {
		name = name,
		sounds = { def.sound_close, def.sound_open },
	}

	def.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		default.door_toggle(pos, node, clicker)
		return itemstack
	end
	def.after_dig_node = function(pos, node, meta, digger)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
		minetest.check_for_falling({x = pos.x, y = pos.y + 1, z = pos.z})
	end
	def.on_rotate = function(pos, node, user, mode, new_param2)
		return false
	end

	if def.protected then
		def.can_dig = can_dig_door
		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = default.get(pos)
			door:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			replace_old_owner_information(pos)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this locked door.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked door", owner
		end
		def.node_dig_prediction = ""
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			-- hidden node doesn't get blasted away.
			minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
			return {name}
		end
	end

	def.on_destruct = function(pos)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
	end

	def.drawtype = "mesh"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.sunlight_propagates = true
	def.walkable = true
	def.is_ground_content = false
	def.buildable_to = false
	def.selection_box = {type = "fixed", fixed = {-1/2,-1/2,-1/2,1/2,3/2,-6/16}}
	def.collision_box = {type = "fixed", fixed = {-1/2,-1/2,-1/2,1/2,3/2,-6/16}}

	def.mesh = "door_a.obj"
	minetest.register_node(":" .. name .. "_a", def)

	def.mesh = "door_b.obj"
	minetest.register_node(":" .. name .. "_b", def)

	default.registered_doors[name .. "_a"] = true
	default.registered_doors[name .. "_b"] = true
end

default.register("door_wood", {
		tiles = {{ name = "doors_door_steel.png", backface_culling = true }},
		description = "Steel Door",
		inventory_image = "doors_item_steel.png",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		recipe = {
			{"default:slab_steelblock", "default:slab_steelblock"},
			{"default:slab_steelblock", "default:slab_steelblock"},
			{"default:slab_steelblock", "default:slab_steelblock"},
		}
})

-- Capture mods using the old API as best as possible.
function default.register_door(name, def)
	if def.only_placer_can_open then
		def.protected = true
	end
	def.only_placer_can_open = nil

	local i = name:find(":")
	local modname = name:sub(1, i - 1)
	if not def.tiles then
		if def.protected then
			def.tiles = {{name = "doors_door_steel.png", backface_culling = true}}
		else
			def.tiles = {{name = "doors_door_steel.png", backface_culling = true}}
		end
		minetest.log("warning", modname .. " registered door \"" .. name .. "\" " ..
				"using deprecated API method \"default.register_door()\" but " ..
				"did not provide the \"tiles\" parameter. A fallback tiledef " ..
				"will be used instead.")
	end

	default.register(name, def)
end

----trapdoor----

function default.trapdoor_toggle(pos, node, clicker)
	node = node or minetest.get_node(pos)

	replace_old_owner_information(pos)

	if clicker and not default.can_interact_with_node(clicker, pos) then
		return false
	end

	local def = minetest.registered_nodes[node.name]

	if string.sub(node.name, -5) == "_open" then
		minetest.sound_play(def.sound_close,
			{pos = pos, gain = 0.3, max_hear_distance = 10})
		minetest.swap_node(pos, {name = string.sub(node.name, 1,
			string.len(node.name) - 5), param1 = node.param1, param2 = node.param2})
	else
		minetest.sound_play(def.sound_open,
			{pos = pos, gain = 0.3, max_hear_distance = 10})
		minetest.swap_node(pos, {name = node.name .. "_open",
			param1 = node.param1, param2 = node.param2})
	end
end

function default.register_trapdoor(name, def)
	if not name:find(":") then
		name = "default:" .. name
	end

	local name_closed = name
	local name_opened = name.."_open"

	def.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		default.trapdoor_toggle(pos, node, clicker)
		return itemstack
	end

	-- Common trapdoor configuration
	def.drawtype = "nodebox"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.is_ground_content = false

	if def.protected then
		def.can_dig = can_dig_door
		def.after_place_node = function(pos, placer, itemstack, pointed_thing)
			local pn = placer:get_player_name()
			local meta = minetest.get_meta(pos)
			meta:set_string("owner", pn)
			meta:set_string("infotext", "Owned by "..pn)

			return (creative and creative.is_enabled_for and creative.is_enabled_for(pn))
		end

		def.on_blast = function() end
		def.on_key_use = function(pos, player)
			local door = default.get(pos)
			door:toggle(player)
		end
		def.on_skeleton_key_use = function(pos, player, newsecret)
			replace_old_owner_information(pos)
			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("owner")
			local pname = player:get_player_name()

			-- verify placer is owner of lockable door
			if owner ~= pname then
				minetest.record_protection_violation(pos, pname)
				minetest.chat_send_player(pname, "You do not own this trapdoor.")
				return nil
			end

			local secret = meta:get_string("key_lock_secret")
			if secret == "" then
				secret = newsecret
				meta:set_string("key_lock_secret", secret)
			end

			return secret, "a locked trapdoor", owner
		end
		def.node_dig_prediction = ""
	else
		def.on_blast = function(pos, intensity)
			minetest.remove_node(pos)
			return {name}
		end
	end

	if not def.sounds then
		def.sounds = default.node_sound_wood_defaults()
	end

	if not def.sound_open then
		def.sound_open = "doors_door_open"
	end

	if not def.sound_close then
		def.sound_close = "doors_door_close"
	end

	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -6/16, 0.5}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -6/16, 0.5}
	}
	def_closed.tiles = {def.tile_front,
			def.tile_front .. '^[transformFY',
			def.tile_side, def.tile_side,
			def.tile_side, def.tile_side}

	def_opened.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 6/16, 0.5, 0.5, 0.5}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 6/16, 0.5, 0.5, 0.5}
	}
	def_opened.tiles = {def.tile_side, def.tile_side,
			def.tile_side .. '^[transform3',
			def.tile_side .. '^[transform1',
			def.tile_front .. '^[transform46',
			def.tile_front .. '^[transform6'}

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)

	default.registered_trapdoors[name_opened] = true
	default.registered_trapdoors[name_closed] = true
end

default.register_trapdoor("default:trapdoor", {
	description = "Steel Trapdoor",
	inventory_image = "doors_trapdoor_steel.png",
	wield_image = "doors_trapdoor_steel.png",
	tile_front = "doors_trapdoor_steel.png",
	tile_side = "doors_trapdoor_steel_side.png",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1},
})

minetest.register_craft({
	output = 'default:trapdoor 2',
	recipe = {
		{'default:slab_steelblock', 'default:slab_steelblock', 'default:slab_steelblock'},
		{'default:slab_steelblock', 'default:slab_steelblock', 'default:slab_steelblock'},
		{'', '', ''},
	}
})

minetest.register_craft({
	output = 'default:trapdoor_steel',
	recipe = {
		{'default:slab_steelblock', 'default:slab_steelblock'},
		{'default:slab_steelblock', 'default:slab_steelblock'},
	}
})


----fence gate----

function default.register_fencegate(name, def)
	local fence = {
		description = def.description,
		drawtype = "mesh",
		tiles = {},
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		is_ground_content = false,
		drop = name .. "_closed",
		connect_sides = {"left", "right"},
		groups = def.groups,
		sounds = def.sounds,
		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			local node_def = minetest.registered_nodes[node.name]
			minetest.swap_node(pos, {name = node_def.gate, param2 = node.param2})
			minetest.sound_play(node_def.sound, {pos = pos, gain = 0.3,
				max_hear_distance = 8})
			return itemstack
		end,
		selection_box = {
			type = "fixed",
			fixed = {-1/2, -1/2, -1/4, 1/2, 1/2, 1/4},
		},
	}


	if type(def.texture) == "string" then
		fence.tiles[1] = {name = def.texture, backface_culling = true}
	elseif def.texture.backface_culling == nil then
		fence.tiles[1] = table.copy(def.texture)
		fence.tiles[1].backface_culling = true
	else
		fence.tiles[1] = def.texture
	end

	if not fence.sounds then
		fence.sounds = default.node_sound_wood_defaults()
	end

	fence.groups.fence = 1

	local fence_closed = table.copy(fence)
	fence_closed.mesh = "doors_fencegate_closed.obj"
	fence_closed.gate = name .. "_open"
	fence_closed.sound = "doors_fencegate_open"
	fence_closed.collision_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/4, 1/2, 1/2, 1/4},
	}

	local fence_open = table.copy(fence)
	fence_open.mesh = "doors_fencegate_open.obj"
	fence_open.gate = name .. "_closed"
	fence_open.sound = "doors_fencegate_close"
	fence_open.groups.not_in_creative_inventory = 1
	fence_open.collision_box = {
		type = "fixed",
		fixed = {{-1/2, -1/2, -1/4, -3/8, 1/2, 1/4},
			{-1/2, -3/8, -1/2, -3/8, 3/8, 0}},
	}

	minetest.register_node(":" .. name .. "_closed", fence_closed)
	minetest.register_node(":" .. name .. "_open", fence_open)

	minetest.register_craft({
		output = name .. "_closed",
		recipe = {
			{"default:wall_steelblock_brown", def.material, "default:wall_steelblock_brown"},
			{"default:wall_steelblock_brown", def.material, "default:wall_steelblock_brown"}
		}
	})
end

default.register_fencegate("default:gate_steelblock", {
	description = "Steelblock Fence Gate",
	texture = "default_steel_block.png",
	material = "default:steelblock",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2}
})

----fuels----

minetest.register_craft({
	type = "fuel",
	recipe = "default:trapdoor",
	burntime = 7,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:door_wood",
	burntime = 14,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:gate_wood_closed",
	burntime = 7,
})



--[[
License of source code
----------------------

The MIT License (MIT)
Copyright (C) 2012-2016 PilzAdam
Copyright (C) 2014-2016 BlockMen
Copyright (C) 2015-2016 sofar (sofar@foo-projects.org)
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


Licenses of media (textures, models and sounds)
-----------------------------------------------

Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)
Copyright (C) 2011-2016 Fernando Zapata
Copyright (C) 2014-2016 celeron55
Copyright (C) 2012-2016 PilzAdam
Copyright (C) 2014-2016 BlockMen
Copyright (C) 2015-2016 sofar
Copyright (C) 2016 red-001
Copyright (C) 2016 paramat

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

-----------------------

Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
Copyright (C) 2014-2016 PenguinDad

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
http://creativecommons.org/licenses/by-sa/4.0/

-----------------------

Attribution 3.0 Unported (CC BY 3.0)
Copyright (C) 2014 CGEffex
Copyright (C) 2014 bennstir
Copyright (C) 2016 BarkersPinhead
Copyright (C) 2016 rivernile7
Copyright (C) 2016 HazMatt

You are free to:
Share — copy and redistribute the material in any medium or format.
Adapt — remix, transform, and build upon the material for any purpose, even commercially.
The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:

Attribution — You must give appropriate credit, provide a link to the license, and
indicate if changes were made. You may do so in any reasonable manner, but not in any way
that suggests the licensor endorses you or your use.

No additional restrictions — You may not apply legal terms or technological measures that
legally restrict others from doing anything the license permits.

Notices:

You do not have to comply with the license for elements of the material in the public
domain or where your use is permitted by an applicable exception or limitation.
No warranties are given. The license may not give you all of the permissions necessary
for your intended use. For example, other rights such as publicity, privacy, or moral
rights may limit how you use the material.

For more details:
http://creativecommons.org/licenses/by/3.0/

-----------------------

CC0 1.0 Universal (CC0 1.0) Public Domain Dedication
mhtaylor67
SkeetMasterFunk69

No Copyright

The person who associated a work with this deed has dedicated the work to the public
domain by waiving all of his or her rights to the work worldwide under copyright law,
including all related and neighboring rights, to the extent allowed by law.

You can copy, modify, distribute and perform the work, even for commercial purposes, all
without asking permission. See Other Information below.

Other Information

In no way are the patent or trademark rights of any person affected by CC0, nor are the
rights that other persons may have in the work or in how the work is used, such as
publicity or privacy rights.
Unless expressly stated otherwise, the person who associated a work with this deed makes
no warranties about the work, and disclaims liability for all uses of the work, to the
fullest extent permitted by applicable law.
When using or citing the work, you should not imply endorsement by the author or the
affirmer.

For more details:
https://creativecommons.org/publicdomain/zero/1.0/



Minetest Game mod: doors
========================
See license.txt for license information.

Authors of source code
----------------------
Originally by PilzAdam (MIT)

Modified by BlockMen (MIT): Added sounds, glass doors (glass, obsidian glass) and trapdoor.

Modified by sofar (sofar@foo-projects.org) (MIT):
Added Steel trapdoor.
Re-implemented most of the door algorithms, added meshes, UV wrapped texture.
Added doors API to facilitate coding mods accessing and operating doors.
Added Fence Gate model, code, and sounds.

Various Minetest developers and contributors (MIT)


Authors of media (textures)
---------------------------
Following textures created by Fernando Zapata (CC BY-SA 3.0):
  door_wood.png
  door_wood_a.png
  door_wood_a_r.png
  door_wood_b.png
  door_wood_b_r.png

Following textures created by BlockMen (CC BY-SA 3.0):
  door_trapdoor.png
  door_obsidian_glass_side.png

Following textures created by celeron55 (CC BY-SA 3.0):
  door_glass_a.png
  door_glass_b.png

Following textures created by PenguinDad (CC BY-SA 4.0):
  door_glass.png
  door_obsidian_glass.png

Following textures created by sofar (CC-BY-SA-3.0):
  doors_trapdoor_steel.png
  doors_trapdoor_steel_side.png
  door_trapdoor_side.png

Obsidian door textures by red-001 based on textures by Pilzadam and BlockMen (CC BY-SA 3.0):
  door_obsidian_glass.png

Glass door textures by red-001 based on textures by celeron55 (CC BY-SA 3.0):
  door_glass.png

All other textures (created by PilzAdam) (CC BY-SA 3.0):

Door textures were converted to the new texture map by sofar, paramat and
red-001, under the same license as the originals.


Authors of media (models)
-------------------------
Door 3d models by sofar (CC-BY-SA-3.0)
 - door_a.obj
 - door_b.obj
Fence gate models by sofar (CC-BY-SA-3.0)
 - fencegate_open.obj
 - fencegate_closed.obj


Authors of media (sounds)
-------------------------
Opening-Sound created by CGEffex (CC BY 3.0), modified by BlockMen
  door_open.ogg
Closing-Sound created by bennstir (CC BY 3.0)
  door_close.ogg
fencegate_open.ogg:
  http://www.freesound.org/people/mhtaylor67/sounds/126041/ - (CC0 1.0)
fencegate_close.ogg:
  http://www.freesound.org/people/BarkersPinhead/sounds/274807/ - (CC-BY-3.0)
  http://www.freesound.org/people/rivernile7/sounds/249573/ - (CC-BY-3.0)
Steel door sounds open & close (CC-BY-3.0) by HazMatt
  - http://www.freesound.org/people/HazMattt/sounds/187283/
  doors_steel_door_open.ogg
  doors_steel_door_close.ogg
doors_glass_door_open.ogg, doors_glass_door_close.ogg:
  https://www.freesound.org/people/SkeetMasterFunk69/sounds/235546/ (CC0 1.0)




]]

