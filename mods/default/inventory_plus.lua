--[[

Inventory Plus for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-inventory_plus
License: BSD-3-Clause https://raw.github.com/cornernote/minetest-inventory_plus/master/LICENSE

Edited by TenPlus1 (23rd March 2016)

]]--

-- expose api
--inventory_plus = {}

-- define buttons
default.buttons = {}

-- default inventory page
default.default = minetest.setting_get("inventory_default") or "craft"

-- register_button
default.register_button = function(player, name, label)

	local player_name = player:get_player_name()

	if default.buttons[player_name] == nil then
		default.buttons[player_name] = {}
	end

	default.buttons[player_name][name] = label
end

-- set_inventory_formspec
default.set_inventory_formspec = function(player, formspec)

	 -- error checking
	if not formspec then
		return
	end

	if minetest.setting_getbool("creative_mode") then

		-- if creative mode is on then wait a bit
		minetest.after(0.01,function()
			player:set_inventory_formspec(formspec)
		end)
	else
		player:set_inventory_formspec(formspec)
	end
end

-- create detached inventory for trashcan
local trashInv = minetest.create_detached_inventory(
	"trash", {
		on_put = function(inv, toList, toIndex, stack, player)
			inv:set_stack(toList, toIndex, ItemStack(nil))
		end
	})

trashInv:set_size("main", 1)

-- get_formspec
default.get_formspec = function(player, page)

	if not player then
		return
	end

	-- default inventory page
	local formspec = "size[8,7.5]"
		.. default.gui_bg
		.. default.gui_bg_img
		.. default.gui_slots
		.. "list[current_player;main;0,3.5;8,4;]"

	-- craft page
	if page == "craft" then

		local inv = player:get_inventory() or nil

		if not inv then
			print ("NO INVENTORY FOUND")
			return
		end

		formspec = formspec
			.. "button[0,1;2,0.5;main;Back]"
			.. "list[current_player;craftpreview;7,1;1,1;]"
			.. "list[current_player;craft;3,0;3,3;]"
			.. "listring[current_name;craft]"
			.. "listring[current_player;main]"
			-- trash icon
			.. "list[detached:trash;main;1,2;1,1;]"
			.. "image[1.1,2.1;0.8,0.8;tnt_boom.png]"
			--.. "image[1.1,2.1;0.8,0.8;crushingfurnace_front_active.png]"
	end

	-- creative page
	if page == "creative" then

		return player:get_inventory_formspec()
			.. "button[5.4,4.2;2.65,0.3;main;Back]"
	end
	
	-- main page
	if page == "main" then

		-- buttons
		local x, y = 0, 1

		for k, v in pairs(default.buttons[player:get_player_name()]) do

			formspec = formspec .. "button[" .. x .. ","
				 .. y .. ";2,0.5;" .. k .. ";" .. v .. "]"

			x = x + 2

			if x == 8 then
				x = 0
				y = y + 1
			end
		end
	end
	
	return formspec
end

-- register_on_joinplayer
minetest.register_on_joinplayer(function(player)

	default.register_button(player,"craft", "Craft")

	if minetest.setting_getbool("creative_mode") then
		default.register_button(player, "creative_prev", "Creative")
	end

	minetest.after(1, function()

		default.set_inventory_formspec(player,
			default.get_formspec(player, default.default))
	end)
end)

-- register_on_player_receive_fields
minetest.register_on_player_receive_fields(function(player, formname, fields)

	-- main

	if fields.main then

		default.set_inventory_formspec(player,
			default.get_formspec(player, "main"))

		return
	end

	-- craft
	if fields.craft then

		default.set_inventory_formspec(player,
			default.get_formspec(player, "craft"))

		return
	end

	-- creative
	if fields.creative_prev
	or fields.creative_next then

		minetest.after(0.1, function()

			default.set_inventory_formspec(player,
				default.get_formspec(player, "creative"))
		end)

		return
	end
end)



--[[
Copyright (c) 2013, Brett O'Donnell http://cornernote.github.io
All rights reserved.
 _____     _____ _____     _____ _____     _____
|     |___| __  |   | |___| __  |   | |___|_   _|___
|   --| . |    -| | | | -_|    -| | | | . | | | | -_|
|_____|___|__|__|_|___|___|__|__|_|___|___| |_| |___|


Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this
  list of conditions and the following disclaimer in the documentation and/or
  other materials provided with the distribution.

* Neither the name of the organization nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


# Inventory Plus for Minetest

## Description

Allows additional formspec buttons to be added to the player inventory.


## Features

- Allows additional formspec buttons to be added to the player inventory screen.
- These are processed by your own mod, they can show other formspec screens, or perform in game functionality.
- Adds support for refill/trash to Creative Inventory.


## Project Resources

* [Home](http://cornernote.github.io/minetest-inventory_plus/)
* [Download](https://github.com/cornernote/minetest-inventory_plus/archive/master.zip)
* [Project](https://github.com/cornernote/minetest-inventory_plus)
* [Forum](http://forum.minetest.net/viewtopic.php?t=6204)
* [Bower](https://minetest-bower.herokuapp.com/mods/inventory_plus)

This version of the mod has been edited by TenPlus1 to work on Minetest 0.4.13+

## Support

- Does this README need improvement?  Go ahead and [suggest a change](https://github.com/cornernote/minetest-inventory_plus/edit/master/README.md).
- Found a bug, or need help using this project?  Check the [open issues](https://github.com/cornernote/minetest-inventory_plus/issues) or [create an issue](https://github.com/cornernote/minetest-inventory_plus/issues/new).


## About

This module is open source, so it's distributed freely. If you find it useful then I ask not for your wealth, but simply to spare your time to consider the world we share by watching [Earthlings](http://earthlings.com/), a multi-award winning film available to watch online for free. A must-see for anyone who wishes to make the world a better place.


## License

[BSD-3-Clause](https://raw.github.com/cornernote/minetest-inventory_plus/master/LICENSE), Copyright © 2013-2014 [Brett O'Donnell](http://cornernote.github.io/)




]]