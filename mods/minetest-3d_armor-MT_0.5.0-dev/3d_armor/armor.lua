-- support for i18n
local S = armor_i18n.gettext

armor:register_armor("3d_armor:helmet_admin", {
	description = S("Admin Helmet"),
	inventory_image = "3d_armor_inv_helmet_admin.png",
	armor_groups = {fleshy=100},
	groups = {armor_head=1, armor_heal=100, armor_use=0, armor_water=1,
			not_in_creative_inventory=1},
	on_drop = function(itemstack, dropper, pos)
		return
	end,
})

armor:register_armor("3d_armor:chestplate_admin", {
	description = S("Admin Chestplate"),
	inventory_image = "3d_armor_inv_chestplate_admin.png",
	armor_groups = {fleshy=100},
	groups = {armor_torso=1, armor_heal=100, armor_use=0,
			not_in_creative_inventory=1},
	on_drop = function(itemstack, dropper, pos)
		return
	end,
})

armor:register_armor("3d_armor:leggings_admin", {
	description = S("Admin Leggings"),
	inventory_image = "3d_armor_inv_leggings_admin.png",
	armor_groups = {fleshy=100},
	groups = {armor_legs=1, armor_heal=100, armor_use=0,
			not_in_creative_inventory=1},
	on_drop = function(itemstack, dropper, pos)
		return
	end,
})

armor:register_armor("3d_armor:boots_admin", {
	description = S("Admin Boots"),
	inventory_image = "3d_armor_inv_boots_admin.png",
	armor_groups = {fleshy=100},
	groups = {armor_feet=1, armor_heal=100, armor_use=0,
			not_in_creative_inventory=1},
	on_drop = function(itemstack, dropper, pos)
		return
	end,
})

minetest.register_alias("adminboots", "3d_armor:boots_admin")
minetest.register_alias("adminhelmet", "3d_armor:helmet_admin")
minetest.register_alias("adminchestplate", "3d_armor:chestplate_admin")
minetest.register_alias("adminleggings", "3d_armor:leggings_admin")

if armor.materials.steel then
	armor:register_armor("3d_armor:helmet_steel", {
		description = S("Steel Helmet"),
		inventory_image = "3d_armor_inv_helmet_steel.png",
		groups = {armor_head=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:chestplate_steel", {
		description = S("Steel Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_steel.png",
		groups = {armor_torso=1, armor_heal=0, armor_use=800,
			physics_speed=-0.04, physics_gravity=0.04},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:leggings_steel", {
		description = S("Steel Leggings"),
		inventory_image = "3d_armor_inv_leggings_steel.png",
		groups = {armor_legs=1, armor_heal=0, armor_use=800,
			physics_speed=-0.03, physics_gravity=0.03},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:boots_steel", {
		description = S("Steel Boots"),
		inventory_image = "3d_armor_inv_boots_steel.png",
		groups = {armor_feet=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
end

if armor.materials.steel_blue then
	armor:register_armor("3d_armor:helmet_steel_blue", {
		description = S("Blue Steel Helmet"),
		inventory_image = "3d_armor_inv_helmet_steel.png^[colorize:#015dbb99",
		groups = {armor_head=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:chestplate_steel_blue", {
		description = S("Blue Steel Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_steel.png^[colorize:#015dbb99",
		groups = {armor_torso=1, armor_heal=0, armor_use=800,
			physics_speed=-0.04, physics_gravity=0.04},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:leggings_steel_blue", {
		description = S("Blue Steel Leggings"),
		inventory_image = "3d_armor_inv_leggings_steel.png^[colorize:#015dbb99",
		groups = {armor_legs=1, armor_heal=0, armor_use=800,
			physics_speed=-0.03, physics_gravity=0.03},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:boots_steel_blue", {
		description = S("Blue Steel Boots"),
		inventory_image = "3d_armor_inv_boots_steel.png^[colorize:#015dbb99",
		groups = {armor_feet=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
end

if armor.materials.steel_red then
	armor:register_armor("3d_armor:helmet_steel_red", {
		description = S("Red Steel Helmet"),
		inventory_image = "3d_armor_inv_helmet_steel.png^[colorize:#ff000099",
		groups = {armor_head=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:chestplate_steel_red", {
		description = S("Red Steel Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_steel.png^[colorize:#ff000099",
		groups = {armor_torso=1, armor_heal=0, armor_use=800,
			physics_speed=-0.04, physics_gravity=0.04},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:leggings_steel_red", {
		description = S("Red Steel Leggings"),
		inventory_image = "3d_armor_inv_leggings_steel.png^[colorize:#ff000099",
		groups = {armor_legs=1, armor_heal=0, armor_use=800,
			physics_speed=-0.03, physics_gravity=0.03},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:boots_steel_red", {
		description = S("Red Steel Boots"),
		inventory_image = "3d_armor_inv_boots_steel.png^[colorize:#ff000099",
		groups = {armor_feet=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
end

if armor.materials.steel_green then
	armor:register_armor("3d_armor:helmet_steel_green", {
		description = S("Green Steel Helmet"),
		inventory_image = "3d_armor_inv_helmet_steel.png^[colorize:#61ff0199",
		groups = {armor_head=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:chestplate_steel_green", {
		description = S("Green Steel Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_steel.png^[colorize:#61ff0199",
		groups = {armor_torso=1, armor_heal=0, armor_use=800,
			physics_speed=-0.04, physics_gravity=0.04},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:leggings_steel_green", {
		description = S("Green Steel Leggings"),
		inventory_image = "3d_armor_inv_leggings_steel.png^[colorize:#61ff0199",
		groups = {armor_legs=1, armor_heal=0, armor_use=800,
			physics_speed=-0.03, physics_gravity=0.03},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:boots_steel_green", {
		description = S("Green Steel Boots"),
		inventory_image = "3d_armor_inv_boots_steel.png^[colorize:#61ff0199",
		groups = {armor_feet=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
end

if armor.materials.steel_yellow then
	armor:register_armor("3d_armor:helmet_steel_yellow", {
		description = S("Yellow Steel Helmet"),
		inventory_image = "3d_armor_inv_helmet_steel.png^[colorize:#61ff0199",
		groups = {armor_head=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:chestplate_steel_yellow", {
		description = S("Yellow Steel Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_steel.png^[colorize:#e3ff0099",
		groups = {armor_torso=1, armor_heal=0, armor_use=800,
			physics_speed=-0.04, physics_gravity=0.04},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:leggings_steel_yellow", {
		description = S("Yellow Steel Leggings"),
		inventory_image = "3d_armor_inv_leggings_steel.png^[colorize:#e3ff0099",
		groups = {armor_legs=1, armor_heal=0, armor_use=800,
			physics_speed=-0.03, physics_gravity=0.03},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:boots_steel_yellow", {
		description = S("Yellow Steel Boots"),
		inventory_image = "3d_armor_inv_boots_steel.png^[colorize:#e3ff0099",
		groups = {armor_feet=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
end

if armor.materials.steel_orange then
	armor:register_armor("3d_armor:helmet_steel_orange", {
		description = S("Orange Steel Helmet"),
		inventory_image = "3d_armor_inv_helmet_steel.png^[colorize:#ff840199",
		groups = {armor_head=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:chestplate_steel_orange", {
		description = S("Orange Steel Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_steel.png^[colorize:#ff840199",
		groups = {armor_torso=1, armor_heal=0, armor_use=800,
			physics_speed=-0.04, physics_gravity=0.04},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:leggings_steel_orange", {
		description = S("Orange Steel Leggings"),
		inventory_image = "3d_armor_inv_leggings_steel.png^[colorize:#ff840199",
		groups = {armor_legs=1, armor_heal=0, armor_use=800,
			physics_speed=-0.03, physics_gravity=0.03},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:boots_steel_orange", {
		description = S("Orange Steel Boots"),
		inventory_image = "3d_armor_inv_boots_steel.png^[colorize:#ff840199",
		groups = {armor_feet=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
end

if armor.materials.steel_violet then
	armor:register_armor("3d_armor:helmet_steel_violet", {
		description = S("Violet Steel Helmet"),
		inventory_image = "3d_armor_inv_helmet_steel.png^[colorize:#2000c999",
		groups = {armor_head=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:chestplate_steel_violet", {
		description = S("Violet Steel Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_steel.png^[colorize:#2000c999",
		groups = {armor_torso=1, armor_heal=0, armor_use=800,
			physics_speed=-0.04, physics_gravity=0.04},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:leggings_steel_violet", {
		description = S("Violet Steel Leggings"),
		inventory_image = "3d_armor_inv_leggings_steel.png^[colorize:#2000c999",
		groups = {armor_legs=1, armor_heal=0, armor_use=800,
			physics_speed=-0.03, physics_gravity=0.03},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:boots_steel_violet", {
		description = S("Violet Steel Boots"),
		inventory_image = "3d_armor_inv_boots_steel.png^[colorize:#2000c999",
		groups = {armor_feet=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
end

if armor.materials.steel_brown then
	armor:register_armor("3d_armor:helmet_steel_brown", {
		description = S("Brown Steel Helmet"),
		inventory_image = "3d_armor_inv_helmet_steel.png^[colorize:#a78c4599",
		groups = {armor_head=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:chestplate_steel_brown", {
		description = S("Brown Steel Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_steel.png^[colorize:#a78c4599",
		groups = {armor_torso=1, armor_heal=0, armor_use=800,
			physics_speed=-0.04, physics_gravity=0.04},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:leggings_steel_brown", {
		description = S("Brown Steel Leggings"),
		inventory_image = "3d_armor_inv_leggings_steel.png^[colorize:#a78c4599",
		groups = {armor_legs=1, armor_heal=0, armor_use=800,
			physics_speed=-0.03, physics_gravity=0.03},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:boots_steel_brown", {
		description = S("Brown Steel Boots"),
		inventory_image = "3d_armor_inv_boots_steel.png^[colorize:#a78c4599",
		groups = {armor_feet=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
end

if armor.materials.steel_blue_royal then
	armor:register_armor("3d_armor:helmet_steel_blue_royal", {
		description = S("Blue Royal Steel Helmet"),
		inventory_image = "3d_armor_inv_helmet_steel.png^[colorize:#00008099",
		groups = {armor_head=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:chestplate_steel_blue_royal", {
		description = S("Blue Royal Steel Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_steel.png^[colorize:#00008099",
		groups = {armor_torso=1, armor_heal=0, armor_use=800,
			physics_speed=-0.04, physics_gravity=0.04},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:leggings_steel_blue_royal", {
		description = S("Blue Royal Steel Leggings"),
		inventory_image = "3d_armor_inv_leggings_steel.png^[colorize:#00008099",
		groups = {armor_legs=1, armor_heal=0, armor_use=800,
			physics_speed=-0.03, physics_gravity=0.03},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	armor:register_armor("3d_armor:boots_steel_blue_royal", {
		description = S("Blue Royal Steel Boots"),
		inventory_image = "3d_armor_inv_boots_steel.png^[colorize:#00008099",
		groups = {armor_feet=1, armor_heal=0, armor_use=800,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
end


for k, v in pairs(armor.materials) do
	minetest.register_craft({
		output = "3d_armor:helmet_"..k,
		recipe = {
			{v, v, v},
			{v, "", v},
			{"", "", ""},
		},
	})
	minetest.register_craft({
		output = "3d_armor:chestplate_"..k,
		recipe = {
			{v, "", v},
			{v, v, v},
			{v, v, v},
		},
	})
	minetest.register_craft({
		output = "3d_armor:leggings_"..k,
		recipe = {
			{v, v, v},
			{v, "", v},
			{v, "", v},
		},
	})
	minetest.register_craft({
		output = "3d_armor:boots_"..k,
		recipe = {
			{v, "", v},
			{v, "", v},
		},
	})
end
