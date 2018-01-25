-- ZCG mod for minetest
-- See README for more information
-- Released by Zeg9 under WTFPL

--zcg = {}

default.users = {}
default.crafts = {}
default.itemlist = {}

default.items_in_group = function(group)
	local items = {}
	local ok = true
	for name, item in pairs(minetest.registered_items) do
		-- the node should be in all groups
		ok = true
		for _, g in ipairs(group:split(',')) do
			if not item.groups[g] then
				ok = false
			end
		end
		if ok then table.insert(items,name) end
	end
	return items
end

local table_copy = function(table)
	local out = {}  --GLOBAL
	for k,v in pairs(table) do
		out[k] = v
	end
	return out
end

default.add_craft = function(input, output, groups)
	if minetest.get_item_group(output, "not_in_craft_guide") > 0 then
		return
	end
	if not groups then groups = {} end
	local c = {}
	c.width = input.width
	c.type = input.type
	c.items = input.items
	if c.items == nil then return end
	for i, item in pairs(c.items) do
		if item:sub(0,6) == "group:" then
			local groupname = item:sub(7)
			if groups[groupname] ~= nil then
				c.items[i] = groups[groupname]
			else
				for _, gi in ipairs(default.items_in_group(groupname)) do
					local g2 = groups
					g2[groupname] = gi
					default.add_craft({
						width = c.width,
						type = c.type,
						items = table_copy(c.items)
					}, output, g2) -- it is needed to copy the table, else groups won't work right
				end
				return
			end
		end
	end
	if c.width == 0 then c.width = 3 end
	table.insert(default.crafts[output],c)
end

default.load_crafts = function(name)
	default.crafts[name] = {}
	local _recipes = minetest.get_all_craft_recipes(name)
	if _recipes then
		for i, recipe in ipairs(_recipes) do
			if (recipe and recipe.items and recipe.type) then
				default.add_craft(recipe, name)
			end
		end
	end
	if default.crafts[name] == nil or #default.crafts[name] == 0 then
		default.crafts[name] = nil
	else
		table.insert(default.itemlist,name)
	end
end

default.need_load_all = true

default.load_all = function()
	print("Loading all crafts, this may take some time...")
	local i = 0
	for name, item in pairs(minetest.registered_items) do
		if (name and name ~= "") then
			default.load_crafts(name)
		end
		i = i+1
	end
	table.sort(default.itemlist)
	default.need_load_all = false
	print("All crafts loaded !")
end

default.formspec = function(pn)
	if default.need_load_all then default.load_all() end
	local page = default.users[pn].page  --GLOBAL
	local alt = default.users[pn].alt  --GLOBAL
	local current_item = default.users[pn].current_item  --GLOBAL
	local formspec = "size[8,7.5]"
	.. "button[0,0;2,.5;main;Back]"
	if default.users[pn].history.index > 1 then
		formspec = formspec .. "image_button[0,1;1,1;flowers_flowers_dandelion_white.png;zcg_previous;;false;false;flowers_flowers_rose.png]"
	else
		formspec = formspec .. "image[0,1;1,1;black.png]"
	end
	if default.users[pn].history.index < #default.users[pn].history.list then
		formspec = formspec .. "image_button[1,1;1,1;flowers_flowers_dandelion_white.png;zcg_next;;false;false;flowers_flowers_waterlily.png]"
	else
		formspec = formspec .. "image[1,1;1,1;black.png]"
	end
	-- Show craft recipe
	if current_item ~= "" then
		if default.crafts[current_item] then
			if alt > #default.crafts[current_item] then
				alt = #default.crafts[current_item]
			end
			if alt > 1 then
				formspec = formspec .. "button[7,0;1,1;zcg_alt:"..(alt-1)..";^]"
			end
			if alt < #default.crafts[current_item] then
				formspec = formspec .. "button[7,2;1,1;zcg_alt:"..(alt+1)..";v]"
			end
			local c = default.crafts[current_item][alt]
			if c then
				local x = 3
				local y = 0
				for i, item in pairs(c.items) do
					formspec = formspec .. "item_image_button["..((i-1)%c.width+x)..","..(math.floor((i-1)/c.width+y))..";1,1;"..item..";default:"..item..";]"
				end
				--if c.type == "normal" or c.type == "cooking" then
				--	formspec = formspec .. "image[6,2;1,1;zcg_method_"..c.type..".png]"
				--else -- we don't have an image for other types of crafting
				--	formspec = formspec .. "label[0,2;Method: "..c.type.."]"
				--end
				--formspec = formspec .. "image[6,1;1,1;flowers_flower_geranium.png]"
				formspec = formspec .. "item_image_button[7,1;1,1;"..default.users[pn].current_item..";;]"
			end
		end
	end
	
	-- Node list
	local npp = 8*3 -- nodes per page
	local i = 0 -- for positionning buttons
	local s = 0 -- for skipping pages
	for _, name in ipairs(default.itemlist) do
		if s < page*npp then s = s+1 else
			if i >= npp then break end
			formspec = formspec .. "item_image_button["..(i%8)..","..(math.floor(i/8)+3.5)..";1,1;"..name..";default:"..name..";]"
			i = i+1
		end
	end
	if page > 0 then
		formspec = formspec .. "button[0,7;1,.5;zcg_page:"..(page-1)..";<<]"
	end
	if i >= npp then
		formspec = formspec .. "button[1,7;1,.5;zcg_page:"..(page+1)..";>>]"
	end
	formspec = formspec .. "label[2,6.85;Page "..(page+1).."/"..(math.floor(#default.itemlist/npp+1)).."]" -- The Y is approximatively the good one to have it centered vertically...
	return formspec
end

minetest.register_on_joinplayer(function(player)
	default.register_button(player,"zcg","Craft guide")
end)

minetest.register_on_player_receive_fields(function(player,formname,fields)
	local pn = player:get_player_name();  --maikerumine added local
	if default.users[pn] == nil then default.users[pn] = {current_item = "", alt = 1, page = 0, history={index=0,list={}}} end
	if fields.zcg then
		default.set_inventory_formspec(player, default.formspec(pn))
		return
	elseif fields.zcg_previous then
		if default.users[pn].history.index > 1 then
			default.users[pn].history.index = default.users[pn].history.index - 1
			default.users[pn].current_item = default.users[pn].history.list[default.users[pn].history.index]
			default.set_inventory_formspec(player,default.formspec(pn))
		end
	elseif fields.zcg_next then
		if default.users[pn].history.index < #default.users[pn].history.list then
			default.users[pn].history.index = default.users[pn].history.index + 1
			default.users[pn].current_item = default.users[pn].history.list[default.users[pn].history.index]
			default.set_inventory_formspec(player,default.formspec(pn))
		end
	end
	for k, v in pairs(fields) do
		if (k:sub(0,4)=="default:") then
			local ni = k:sub(5)
			if default.crafts[ni] then
				default.users[pn].current_item = ni
				table.insert(default.users[pn].history.list, ni)
				default.users[pn].history.index = #default.users[pn].history.list
				default.set_inventory_formspec(player,default.formspec(pn))
			end
		elseif (k:sub(0,9)=="zcg_page:") then
			default.users[pn].page = tonumber(k:sub(10))
			default.set_inventory_formspec(player,default.formspec(pn))
		elseif (k:sub(0,8)=="zcg_alt:") then
			default.users[pn].alt = tonumber(k:sub(9))
			default.set_inventory_formspec(player,default.formspec(pn))
		end
	end
end)



--[[




]]
