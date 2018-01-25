--[[
More Blocks: crafting recipes

Copyright (c) 2011-2017 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
--]]

if minetest.settings:get_bool("default.circular_saw_crafting") ~= false then -- “If nil or true then”
	minetest.register_craft({
		output = "default:circular_saw",
		recipe = {
			{ "",  "default:wall_steelblock",  "" },
			{ "default:steelblock_brown",  "default:steelblock_brown",  "default:steelblock_brown"},
			{ "default:steelblock_brown",  "",  "default:steelblock_brown"},
		}
	})
end
