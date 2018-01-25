--[[
More Blocks: configuration handling

Copyright (c) 2011-2017 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
--]]

default.config = {}

local function getbool_default(setting, def)
	local value = minetest.settings:get_bool(setting)
	if value == nil then
		value = def
	end
	return value
end

local function setting(settingtype, name, def)
	if settingtype == "bool" then
		default.config[name] =
			getbool_default("default." .. name, def)
	else
		default.config[name] =
			minetest.settings:get("default." .. name) or def
	end
end

-- Show stairs/slabs/panels/microblocks in creative inventory (true or false):
setting("bool", "stairsplus_in_creative_inventory", false)
