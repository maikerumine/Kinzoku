dofile(minetest.get_modpath("default").."/mobs_api.lua")

--Andrey created mob for his world needs
--maikerumine added to it





--lags mobs

default:register_mob("default:griefer_ghost", {
	type = "monster",
	--full_name = Oerkii,
	hp_max = 20,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
	visual = "mesh",
	mesh = "mobs_oerkki.x",
	textures = {"mobs_oerkki.png"},
	visual_size = {x=5, y=5},
	makes_footstep_sound = true,
	view_range = 10,
	walk_velocity = 1,
	run_velocity = 3,
	damage = 1,
	lifetimer=300,
	drops = {
		{name = "default:steelblock_green",
		chance = 1,
		min = 1,
		max = 2,
		},
		{name = "default:steelblock_pink",
		chance = 1,
		min = 1,
		max = 2,
		},
		{name = "default:bones",
			chance = 1,
			min = 1,
			max=1,
		},
	},

	
	bone_drops = {
		{name = "default:steelblock_green",
		chance = 1,
		min = 1,
		max = 2,
		},
		{name = "default:steelblock_pink",
		chance = 1,
		min = 1,
		max = 2,
		},
		{name = "default:bones",
		chance = 1,
		min = 1,
		max = 1,
		},
	},
	
	armor = 60,
	drawtype = "front",
	light_resistant = true,
	water_damage = 0,
	lava_damage = 1,
	light_damage = 0,
	attack_type = "dogfight",
	lifetimer=30,
	animation = {
		stand_start = 0,
		stand_end = 23,
		walk_start = 24,
		walk_end = 36,
		run_start = 37,
		run_end = 49,
		punch_start = 37,
		punch_end = 49,
		speed_normal = 15,
		speed_run = 15,
	},
	follow="",
	jump=true,

})
--function default:register_spawn_near(name, nodes, max_light, min_light, tries)
default:register_spawn_near("default:griefer_ghost", "default:steelblock_dark_green", 4, -1, 2)

default:register_mob("default:stone_monster", {
	type = "monster",
	--full_name = Stoney,
	hp_max = 15,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
	visual = "mesh",
	mesh = "mobs_stone_monster.x",
	textures = {"mobs_stone_monster.png"},
	visual_size = {x=3, y=2.6},
	makes_footstep_sound = true,
	view_range = 10,
	walk_velocity = 0.5,
	run_velocity = 1,
	damage = 2,
	
	drops = {
		{name = "default:torch",
		chance = 1,
		min = 1,
		max = 5,},
		{name = "default:bones",
			chance = 1,
			min = 1,
			max=1,
		},
	},
	
	bone_drops = {
		{name = "default:torch",
		chance = 1,
		min = 2,
		max = 5,
		},
		{name = "default:steelblock_pink",
		chance = 1,
		min = 2,
		max = 5,
		},
		--{name = "default:grass_1",
		--chance = 20,
		--min = 1,
		--max = 2,
		--},
	},
	light_resistant = true,
	armor = 60,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 1,
	light_damage = 0,
	attack_type = "dogfight",
	lifetimer=300,
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 14,
		walk_start = 15,
		walk_end = 38,
		run_start = 40,
		run_end = 63,
		punch_start = 40,
		punch_end = 63,
	}
})
--function default:register_spawn(name, nodes, max_light, min_light, chance, active_object_count, max_height, min_height, spawn_func)
--default:register_spawn("default:stone_monster", "default:stone", 3, -1, 9000, 20 500, 0) --was48
default:register_spawn("default:stone_monster", "group:cracky", 3, -1, 9000, 48, 500, 0) --was48
default:register_spawn("default:stone_monster", "default:steelblock_dark_green", 3, -1, 9000, 48, 500, 0) --was48




if minetest.setting_get("log_mods") then
	minetest.log("action", "mobs loaded")
end



--[[
=== MOBS-MOD for MINETEST-C55 ===
by PilzAdam

Inroduction:
This mod adds some basic hostile and friendly mobs to the game.

How to install:
Unzip the archive an place it in minetest-base-directory/mods/minetest/
if you have a windows client or a linux run-in-place client. If you have
a linux system-wide instalation place it in ~/.minetest/mods/minetest/.
If you want to install this mod only in one world create the folder
worldmods/ in your worlddirectory.
For further information or help see:
http://wiki.minetest.com/wiki/Installing_Mods

How to use the mod:
See https://github.com/PilzAdam/mobs/wiki

For developers:
The API documentation is moved to https://github.com/PilzAdam/mobs/wiki/API

License:
Sourcecode: WTFPL (see below)
Grahpics: WTFPL (see below)
Models: WTFPL (by Pavel_S, see below)

See also:
http://minetest.net/

         DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO. 

MIT License

Copyright (c) 2018 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


]]