local world_path = minetest.get_worldpath()
local org_file = world_path .. "/beds_spawns"
local file = world_path .. "/beds_spawns"
local bkwd = false

-- check for PA's beds mod spawns
local cf = io.open(world_path .. "/beds_player_spawns", "r")
if cf ~= nil then
	io.close(cf)
	file = world_path .. "/beds_player_spawns"
	bkwd = true
end

function default.read_spawns()
	local spawns = default.spawn
	local input = io.open(file, "r")
	if input and not bkwd then
		repeat
			local x = input:read("*n")
			if x == nil then
				break
			end
			local y = input:read("*n")
			local z = input:read("*n")
			local name = input:read("*l")
			spawns[name:sub(2)] = {x = x, y = y, z = z}
		until input:read(0) == nil
		io.close(input)
	elseif input and bkwd then
		default.spawn = minetest.deserialize(input:read("*all"))
		input:close()
		default.save_spawns()
		os.rename(file, file .. ".backup")
		file = org_file
	end
end

default.read_spawns()

function default.save_spawns()
	if not default.spawn then
		return
	end
	local data = {}
	local output = io.open(org_file, "w")
	for k, v in pairs(default.spawn) do
		table.insert(data, string.format("%.1f %.1f %.1f %s\n", v.x, v.y, v.z, k))
	end
	output:write(table.concat(data))
	io.close(output)
end

function default.set_spawns()
	for name,_ in pairs(default.player) do
		local player = minetest.get_player_by_name(name)
		local p = player:getpos()
		-- but don't change spawn location if borrowing a bed
		if not minetest.is_protected(p, name) then
			default.spawn[name] = p
		end
	end
	default.save_spawns()
end
