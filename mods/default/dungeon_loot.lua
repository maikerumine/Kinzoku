default.CHESTS_MIN = 0 -- not necessarily in a single dungeon
default.CHESTS_MAX = 2
default.STACKS_PER_CHEST_MAX = 8

default.registered_loot = {
	-- buckets
	{name = "default:bucket_empty", chance = 0.55},
	-- water in deserts or above ground, lava otherwise
	{name = "default:bucket_water", chance = 0.45, types = {"sandstone", "desert"}},
	{name = "default:bucket_water", chance = 0.45, y = {0, 32768}, types = {"normal"}},
	{name = "default:bucket_lava", chance = 0.45, y = {-32768, -1}, types = {"normal"}},

	-- various items
	{name = "default:torch", chance = 0.6, count = {3, 6}},
	--{name = "default:flint", chance = 0.4, count = {1, 3}},
	--{name = "vessels:glass_fragments", chance = 0.35, count = {1, 4}},
	--{name = "carts:rail", chance = 0.35, count = {1, 6}},

	-- farming / consumable
	--{name = "farming:string", chance = 0.5, count = {1, 8}},
	--{name = "farming:wheat", chance = 0.5, count = {2, 5}},
	{name = "default:apple", chance = 0.4, count = {1, 4}},
	--{name = "farming:seed_cotton", chance = 0.4, count = {1, 4}, types = {"normal"}},
	--{name = "default:cactus", chance = 0.4, count = {1, 4}, types = {"sandstone", "desert"}},

	-- minerals
	{name = "default:steelblock_brown", chance = 0.9, count = {1, 12}},
	{name = "default:steelblock_black", chance = 0.5},
	{name = "default:steelblock_cyan", chance = 0.4, count = {1, 6}},
	{name = "default:steelblock_grey", chance = 0.1, count = {2, 3}},

	-- tools
	--{name = "default:sword_wood", chance = 0.6},
	--{name = "default:pick_wood", chance = 0.3},
	--{name = "default:axe_wood", chance = 0.05},

	-- natural materials
	{name = "default:ladder_steel", chance = 0.8, count = {4, 32}, y = {-64, 32768}, types = {"normal"}},
	{name = "default:steelblock_green", chance = 0.8, count = {4, 32}, y = {-64, 32768}, types = {"sandstone"}},
	{name = "default:steelblock_red", chance = 0.8, count = {4, 32}, types = {"desert"}},
	{name = "default:steelblock_blue", chance = 0.6, count = {2, 16}, y = {-64, 32768}},
	--{name = "default:obsidian", chance = 0.25, count = {1, 3}, y = {-32768, -512}},
	--{name = "default:mese", chance = 0.15, y = {-32768, -512}},
}

function default.register(t)
	if t.name ~= nil then
		t = {t} -- single entry
	end
	for _, loot in ipairs(t) do
		table.insert(default.registered_loot, loot)
	end
end

function default._internal_get_loot(pos_y, dungeontype)
	-- filter by y pos and type
	local ret = {}
	for _, l in ipairs(default.registered_loot) do
		if l.y == nil or (pos_y >= l.y[1] and pos_y <= l.y[2]) then
			if l.types == nil or table.indexof(l.types, dungeontype) ~= -1 then
				table.insert(ret, l)
			end
		end
	end
	return ret
end


minetest.set_gen_notify({dungeon = true, temple = true})

local function noise3d_integer(noise, pos)
	return math.abs(math.floor(noise:get3d(pos) * 0x7fffffff))
end

local function random_sample(rand, list, count)
	local ret = {}
	for n = 1, count do
		local idx = rand:next(1, #list)
		table.insert(ret, list[idx])
		table.remove(list, idx)
	end
	return ret
end

local function find_walls(cpos)
	local wall = minetest.registered_aliases["mapgen_cobble"]
	local wall_alt = minetest.registered_aliases["mapgen_mossycobble"]
	local wall_ss = minetest.registered_aliases["mapgen_mossycobble"]
	local wall_ds = minetest.registered_aliases["mapgen_cobble"]
	local is_wall = function(node)
		return table.indexof({wall, wall_alt, wall_ss, wall_ds}, node.name) ~= -1
	end

	local dirs = {{x=1, z=0}, {x=-1, z=0}, {x=0, z=1}, {x=0, z=-1}}
	local get_node = minetest.get_node

	local ret = {}
	local mindist = {x=0, z=0}
	local min = function(a, b) return a ~= 0 and math.min(a, b) or b end
	local wallnode
	for _, dir in ipairs(dirs) do
		for i = 1, 9 do -- 9 = max room size / 2
			local pos = vector.add(cpos, {x=dir.x*i, y=0, z=dir.z*i})

			-- continue in that direction until we find a wall-like node
			local node = get_node(pos)
			if is_wall(node) then
				local front_below = vector.subtract(pos, {x=dir.x, y=1, z=dir.z})
				local above = vector.add(pos, {x=0, y=1, z=0})

				-- check that it:
				--- is at least 2 nodes high (not a staircase)
				--- has a floor
				if is_wall(get_node(front_below)) and is_wall(get_node(above)) then
					table.insert(ret, {pos = pos, facing = {x=-dir.x, y=0, z=-dir.z}})
					if dir.z == 0 then
						mindist.x = min(mindist.x, i-1)
					else
						mindist.z = min(mindist.z, i-1)
					end
					wallnode = node.name
				end
				-- abort even if it wasn't a wall cause something is in the way
				break
			end
		end
	end

	local mapping = {
		[wall_ss] = "sandstone",
		[wall_ds] = "desert"
	}
	return {
		walls = ret,
		size = {x=mindist.x*2, z=mindist.z*2},
		type = mapping[wallnode] or "normal"
	}
end

local function populate_chest(pos, rand, dungeontype)
	--minetest.chat_send_all("chest placed at " .. minetest.pos_to_string(pos) .. " [" .. dungeontype .. "]")
	--minetest.add_node(vector.add(pos, {x=0, y=1, z=0}), {name="default:torch", param2=1})

	local item_list = default._internal_get_loot(pos.y, dungeontype)
	-- take random (partial) sample of all possible items
	assert(#item_list >= default.STACKS_PER_CHEST_MAX)
	item_list = random_sample(rand, item_list, default.STACKS_PER_CHEST_MAX)

	-- apply chances / randomized amounts and collect resulting items
	local items = {}
	for _, loot in ipairs(item_list) do
		if rand:next(0, 1000) / 1000 <= loot.chance then
			local itemdef = minetest.registered_items[loot.name]
			local amount = 1
			if loot.count ~= nil then
				amount = rand:next(loot.count[1], loot.count[2])
			end

			if itemdef.tool_capabilities then
				for n = 1, amount do
					local wear = rand:next(0.20 * 65535, 0.75 * 65535) -- 20% to 75% wear
					table.insert(items, ItemStack({name = loot.name, wear = wear}))
				end
			elseif itemdef.stack_max == 1 then
				-- not stackable, add separately
				for n = 1, amount do
					table.insert(items, loot.name)
				end
			else
				table.insert(items, ItemStack({name = loot.name, count = amount}))
			end
		end
	end

	-- place items at random places in chest
	local inv = minetest.get_meta(pos):get_inventory()
	local listsz = inv:get_size("main")
	assert(listsz >= #items)
	for _, item in ipairs(items) do
		local index = rand:next(1, listsz)
		if inv:get_stack("main", index):is_empty() then
			inv:set_stack("main", index, item)
		else
			inv:add_item("main", item) -- space occupied, just put it anywhere
		end
	end
end


minetest.register_on_generated(function(minp, maxp, blockseed)
	local gennotify = minetest.get_mapgen_object("gennotify")
	local poslist = gennotify["dungeon"] or {}
	for _, entry in ipairs(gennotify["temple"] or {}) do
		table.insert(poslist, entry)
	end
	if #poslist == 0 then return end

	local noise = minetest.get_perlin(10115, 4, 0.5, 1)
	local rand = PcgRandom(noise3d_integer(noise, poslist[1]))

	local candidates = {}
	-- process at most 16 rooms to keep runtime of this predictable
	local num_process = math.min(#poslist, 16)
	for i = 1, num_process do
		local room = find_walls(poslist[i])
		-- skip small rooms and everything that doesn't at least have 3 walls
		if math.min(room.size.x, room.size.z) >= 4 and #room.walls >= 3 then
			table.insert(candidates, room)
		end
	end

	local num_chests = rand:next(default.CHESTS_MIN, default.CHESTS_MAX)
	num_chests = math.min(#candidates, num_chests)
	local rooms = random_sample(rand, candidates, num_chests)

	for _, room in ipairs(rooms) do
		-- choose place somewhere in front of any of the walls
		local wall = room.walls[rand:next(1, #room.walls)]
		local v, vi -- vector / axis that runs alongside the wall
		if wall.facing.x ~= 0 then
			v, vi = {x=0, y=0, z=1}, "z"
		else
			v, vi = {x=1, y=0, z=0}, "x"
		end
		local chestpos = vector.add(wall.pos, wall.facing)
		local off = rand:next(-room.size[vi]/2 + 1, room.size[vi]/2 - 1)
		chestpos = vector.add(chestpos, vector.multiply(v, off))

		if minetest.get_node(chestpos).name == "air" then
			-- make it face inwards to the room
			local facedir = minetest.dir_to_facedir(vector.multiply(wall.facing, -1))
			minetest.add_node(chestpos, {name = "default:chest", param2 = facedir})
			populate_chest(chestpos, PcgRandom(noise3d_integer(noise, chestpos)), room.type)
		end
	end
end)


--[[
License of source code
----------------------

The MIT License (MIT)
Copyright (C) 2017 sfan5

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

Minetest Game mod: dungeon_loot
===============================
Adds randomly generated chests with some "loot" to generated dungeons,
an API to register additional loot is provided.
Only works if dungeons are actually enabled in mapgen flags.

License information can be found in license.txt

Authors of source code
----------------------
Originally by sfan5 (MIT)




]]