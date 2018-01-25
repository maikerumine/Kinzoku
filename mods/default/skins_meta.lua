default.meta = {}
for _, i in ipairs(default.list) do
	default.meta[i] = {}
	local f = io.open(default.modpath.."/meta/"..i..".txt")
	local data = nil
	if f then
		data = minetest.deserialize("return {"..f:read('*all').."}")
		f:close()
	end
	data = data or {}
	default.meta[i].name = data.name or ""
	default.meta[i].author = data.author or ""
	default.meta[i].description = data.description or nil
	default.meta[i].comment = data.comment or nil
end
