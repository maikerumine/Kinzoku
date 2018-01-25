default.list = {}
default.add = function(skin)
	table.insert(default.list,skin)
end

local id

id = 1
while true do
	local f = io.open(minetest.get_modpath("default").."/textures/player_"..id..".png")
	if (not f) then break end
	f:close()
	default.add("player_"..id)
	id = id +1
end

id = 1
while true do
	local f = io.open(minetest.get_modpath("default").."/textures/character_"..id..".png")
	if (not f) then break end
	f:close()
	default.add("character_"..id)
	id = id +1
end

