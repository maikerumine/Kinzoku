-- Skins mod for minetest
-- Adds a skin gallery to the inventory, using inventory_plus
-- Released by Zeg9 under WTFPL
-- Have fun !

--skins = {}
default.type = { SPRITE=0, MODEL=1 }

default.skins = {}
default.default = function()
	return "character_1"
end

default.get_type = function(texture)
	if not texture then return end
	if string.sub(texture,0,string.len("character")) == "character" then
		return default.type.MODEL
	end
	if string.sub(texture,0,string.len("player")) == "player" then
		return default.type.SPRITE
	end
end

default.modpath = minetest.get_modpath("default")
dofile(default.modpath.."/skins_skinlist.lua")
dofile(default.modpath.."/skins_meta.lua")
dofile(default.modpath.."/skins_players.lua")

default.update_player_skin = function(player)
	local name = player:get_player_name()
	if default.get_type(default.skins[name]) == default.type.SPRITE then
		player:set_properties({
			visual = "upright_sprite",
			textures = {default.skins[name]..".png",default.skins[name]..".png"},
			visual_size = {x=1, y=2},
		})
	elseif default.get_type(default.skins[name]) == default.type.MODEL then
		player:set_properties({
			visual = "mesh",
			textures = {default.skins[name]..".png"},
			visual_size = {x=1, y=1},
		})
	end
	default.save()
end

default.formspec = {}
default.formspec.main = function(name)
	local page = default.pages[name]
	if page == nil then page = 0 end
	local formspec = "size[8,7.5]"
		.. "button[0,0;2,.5;main;Back]"
	if default.get_type(default.skins[name]) == default.type.MODEL then
		formspec = formspec
			.. "image[0,.75;1,2;"..default.skins[name]..".png]"
			.. "image[1,.75;1,2;"..default.skins[name]..".png]"
			.. "label[6,.5;Raw texture:]"
			.. "image[6,1;2,1;"..default.skins[name]..".png]"
		
	else
		formspec = formspec
			.. "image[0,.75;1,2;"..default.skins[name]..".png]"
			.. "image[1,.75;1,2;"..default.skins[name]..".png]"
	end
	local meta = default.meta[default.skins[name]]
	if meta then
		if meta.name then
			formspec = formspec .. "label[2,.5;Name: "..meta.name.."]"
		end
		if meta.author then
			formspec = formspec .. "label[2,1;Author: "..meta.author.."]"
		end
		if meta.description then
			formspec = formspec .. "label[2,1.5;"..meta.description.."]"
		end
		if meta.comment then
			formspec = formspec .. 'label[2,2;"'..meta.comment..'"]'
		end
	end
	local index = 0
	local skip = 0 -- Skip skins, used for pages
	for i, skin in ipairs(default.list) do
		if skip < page*16 then skip = skip + 1 else
			if index < 16 then
				formspec = formspec .. "image_button["..(index%8)..","..((math.floor(index/8))*2+3)..";1,2;"..skin
				if default.get_type(skin) == default.type.MODEL then
					formspec = formspec .. ""
				end
				formspec = formspec .. ".png;skins_set_"..i..";]"
			end
			index = index +1
		end
	end
	if page > 0 then
		formspec = formspec .. "button[0,7;1,.5;skins_page_"..(page-1)..";<<]"
	else
		formspec = formspec .. "button[0,7;1,.5;skins_page_"..page..";<<]"
	end
	formspec = formspec .. "button[.75,7;6.5,.5;skins_page_"..page..";Page "..(page+1).."/"..math.floor(#default.list/16+1).."]" -- a button is used so text is centered
	if index > 16 then
		formspec = formspec .. "button[7,7;1,.5;skins_page_"..(page+1)..";>>]"
	else
		formspec = formspec .. "button[7,7;1,.5;skins_page_"..page..";>>]"
	end
	return formspec
end

default.pages = {}


minetest.register_on_joinplayer(function(player)
	if not default.skins[player:get_player_name()] then
		default.skins[player:get_player_name()] = default.default()
	end
	default.update_player_skin(player)
	default.register_button(player,"skins","Skin")
end)

minetest.register_on_player_receive_fields(function(player,formname,fields)
	if fields.skins then
		default.set_inventory_formspec(player,default.formspec.main(player:get_player_name()))
	end
	for field, _ in pairs(fields) do
		if string.sub(field,0,string.len("skins_set_")) == "skins_set_" then
			default.skins[player:get_player_name()] = default.list[tonumber(string.sub(field,string.len("skins_set_")+1))]
			default.update_player_skin(player)
			default.set_inventory_formspec(player,default.formspec.main(player:get_player_name()))
		end
		if string.sub(field,0,string.len("skins_page_")) == "skins_page_" then
			default.pages[player:get_player_name()] = tonumber(string.sub(field,string.len("skins_page_")+1))
			default.set_inventory_formspec(player,default.formspec.main(player:get_player_name()))
		end
	end
end)

