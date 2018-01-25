minetest.register_on_newplayer(function(player)
--minetest.register_on_joinplayer(function(player)
	if player then
		show_welcome_message(player)
	end
end)

minetest.register_chatcommand("welcome", {
	params = "",
	description = "Show welcome message.",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if player then
			show_welcome_message(player)
		end
		return true
	end,
})

function show_welcome_message(player)
	local formspec =		"size[11,7.7]textarea[0.5,0.5;10.5,7;welcome:welcome_textarea;;"..
							"Welcome "..player:get_player_name().."!\n\n"..
							"This code was copied from Beerholder's Beerarchy Server as a Placeholder. "..
							"I am sorry Beerholder,  I will fix it and not use your code...  But it is so nice "..
							"This is the world known as Kinzoku (metal). This is an experimental server"..
							" without moderation besides keeping the server up and running. Feel "..
							" free to say whatever you want in chat. Griefing in any form whatsoever"..
							" is permitted (destroying structures, lava casting, spawn killing). "..
							"For those who are easily offended, either bug off, deal"..
							" with the lack of rules or leave if you can't handle anarchy.\n\n"..
							"This server has a very simple crafting system in place."..
							"Crafting is all forms of steelblocks. "..
							"All armor is equal in strength. "..
							"Now for the fun stuff...\n\n"..
							"Good luck "..player:get_player_name()..", you will need it as you will "..
							" start with nothing. And oh, I forgot, food is apples...\n\n"..
							"By continuing on this server, you agree to the rules and "..
							" that the administrator of this server is in no way "..
							" whatsoever liable for your actions or those of other players.\n\n"..
							"Some useful chat commands..\n\n"..
							"/killme: -> You return to your last bed (simple set home) or back at spawn\n"..

							"]button_exit[9,7;2,1;continue;Continue]"

	minetest.show_formspec(player:get_player_name(), "welcome:welcome", formspec)

end
