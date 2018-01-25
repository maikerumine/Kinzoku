default.file = minetest.get_worldpath() .. "/default.mt"
default.load = function()
	local input = io.open(default.file, "r")
	local data = nil
	if input then
		data = input:read('*all')
	end
	if data and data ~= "" then
		local lines = string.split(data,"\n")
		for _, line in ipairs(lines) do
			data = string.split(line, ' ', 2)
			default.skins[data[1]] = data[2]
		end
		io.close(input)
	end
end
default.load()

default.save = function()
	local output = io.open(default.file,'w')
	for name, skin in pairs(default.skins) do
		if name and skin then
			output:write(name .. " " .. skin .. "\n")
		end
	end
	io.close(output)
end

