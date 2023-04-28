local S = minetest.get_translator("pep")
local ppa = minetest.get_modpath("playerphysics")

pep = {}
function pep.register_potion(potiondef)
	local on_use
	if(potiondef.effect_type ~= nil) then
		on_use = function(itemstack, user, pointed_thing)
			playereffects.apply_effect_type(potiondef.effect_type, potiondef.duration, user)
			itemstack:take_item()
			return itemstack
		end
	else
		on_use = function(itemstack, user, pointed_thing)
			itemstack:take_item()
			return itemstack
		end
	end
	minetest.register_craftitem("pep:"..potiondef.basename, {
		description = S("Glass Bottle (@1)", potiondef.contentstring),
		_doc_items_longdesc = potiondef.longdesc,
		_doc_items_usagehelp = S("Hold it in your hand, then left-click to drink it."),
		inventory_image = "pep_"..potiondef.basename..".png",
		wield_image = "pep_"..potiondef.basename..".png",
		on_use = on_use,
	})
end

pep.moles = {}

function pep.enable_mole_mode(playername)
	pep.moles[playername] = true
end

function pep.disable_mole_mode(playername)
	pep.moles[playername] = false
end

function pep.yaw_to_vector(yaw)
	local tau = math.pi*2

	yaw = yaw % tau
	if yaw < tau/8 then
		return { x=0, y=0, z=1}
	elseif yaw < (3/8)*tau then
		return { x=-1, y=0, z=0 }
	elseif yaw < (5/8)*tau then
		return { x=0, y=0, z=-1 }
	elseif yaw < (7/8)*tau then
		return { x=1, y=0, z=0 }
	else
		return { x=0, y=0, z=1}
	end
end

function pep.moledig(playername)
	local player = minetest.get_player_by_name(playername)

	local yaw = player:get_look_horizontal()

	local pos = vector.round(player:get_pos())

	local v = pep.yaw_to_vector(yaw)

	local digpos1 = vector.add(pos, v)
	local digpos2 = { x = digpos1.x, y = digpos1.y+1, z = digpos1.z }

	local try_dig = function(pos)
		local n = minetest.get_node(pos)
		local ndef = minetest.registered_nodes[n.name]
		if ndef.walkable and ndef.diggable then
			if ndef.can_dig ~= nil then
				if ndef.can_dig() then
					return true
				else
					return false
				end
			else
				return true
			end
		else
			return false
		end
	end

	local dig = function(pos)
		if try_dig(pos) then
			local n = minetest.get_node(pos)
			local ndef = minetest.registered_nodes[n.name]
			if ndef and ndef.sounds and ndef.sounds.dug then
				minetest.sound_play(ndef.sounds.dug, { pos = pos })
			end
			-- TODO: Replace this code as soon Minetest removes support for this function
			local drops = minetest.get_node_drops(n.name, "default:pick_steel")
			minetest.dig_node(pos)
			local inv = player:get_inventory()
			local leftovers = {}
			for i=1,#drops do
				table.insert(leftovers, inv:add_item("main", drops[i]))
			end
			for i=1,#leftovers do
				minetest.add_item(pos, leftovers[i])
			end
		end
	end

	dig(digpos1)
	dig(digpos2)
end

pep.timer = 0

minetest.register_globalstep(function(dtime)
	pep.timer = pep.timer + dtime
	if pep.timer > 0.5 then
		for playername, is_mole in pairs(pep.moles) do
			if is_mole then
				pep.moledig(playername)
			end
		end
		pep.timer = 0
	end
end)

local add_physic = function(player, attribute, value)
	if ppa then
		playerphysics.add_physics_factor(player, attribute, "pep:"..attribute, value)
	else
		player:set_physics_override({[attribute]=value})
	end
end
local remove_physic = function(player, attribute)
	if ppa then
		playerphysics.remove_physics_factor(player, attribute, "pep:"..attribute)
	else
		player:set_physics_override({[attribute]=1})
	end
end

playereffects.register_effect_type("pepspeedplus", S("High speed"), "pep_speedplus.png", {"speed"},
	function(player)
		add_physic(player, "speed", 2)
	end,
	function(effect, player)
		remove_physic(player, "speed")
	end
)
playereffects.register_effect_type("pepspeedminus", S("Low speed"), "pep_speedminus.png", {"speed"},
	function(player)
		add_physic(player, "speed", 0.5)
	end,
	function(effect, player)
		remove_physic(player, "speed")
	end
)
playereffects.register_effect_type("pepspeedreset", S("Speed neutralizer"), "pep_speedreset.png", {"speed"},
	function() end, function() end)
playereffects.register_effect_type("pepjumpplus", S("High jump"), "pep_jumpplus.png", {"jump"},
	function(player)
		add_physic(player, "jump", 2)
	end,
	function(effect, player)
		remove_physic(player, "jump")
	end
)
playereffects.register_effect_type("pepjumpminus", S("Low jump"), "pep_jumpminus.png", {"jump"},
	function(player)
		add_physic(player, "jump", 0.5)
	end,
	function(effect, player)
		remove_physic(player, "jump")
	end
)
playereffects.register_effect_type("pepjumpreset", S("Jump height neutralizer"), "pep_jumpreset.png", {"jump"},
	function() end, function() end)
playereffects.register_effect_type("pepgrav0", S("No gravity"), "pep_grav0.png", {"gravity"},
	function(player)
		add_physic(player, "gravity", 0)
	end,
	function(effect, player)
		remove_physic(player, "gravity")
	end
)
playereffects.register_effect_type("pepgravreset", S("Gravity neutralizer"), "pep_gravreset.png", {"gravity"},
	function() end, function() end)
playereffects.register_effect_type("pepregen", S("Regeneration"), "pep_regen.png", {"health"},
	function(player)
		player:set_hp(player:get_hp()+1)
	end,
	nil, nil, nil, 2
)
playereffects.register_effect_type("pepregen2", S("Strong regeneration"), "pep_regen2.png", {"health"},
	function(player)
		player:set_hp(player:get_hp()+2)
	end,
	nil, nil, nil, 1
)

if minetest.get_modpath("mana") ~= nil then
	playereffects.register_effect_type("pepmanaregen", S("Weak mana boost"), "pep_manaregen.png", {"mana"},
		function(player)
			local name = player:get_player_name()
			mana.setregen(name, mana.getregen(name) + 0.5)
		end,
		function(effect, player)
			local name = player:get_player_name()
			mana.setregen(name, mana.getregen(name) - 0.5)
		end
	)
	playereffects.register_effect_type("pepmanaregen2", S("Strong mana boost"), "pep_manaregen2.png", {"mana"},
		function(player)
			local name = player:get_player_name()
			mana.setregen(name, mana.getregen(name) + 1)
		end,
		function(effect, player)
			local name = player:get_player_name()
			mana.setregen(name, mana.getregen(name) - 1)
		end
	)
end


playereffects.register_effect_type("pepbreath", S("Perfect breath"), "pep_breath.png", {"breath"},
	function(player)
		player:set_breath(player:get_breath()+2)
	end,
	nil, nil, nil, 1
)
playereffects.register_effect_type("pepmole", S("Mole mode"), "pep_mole.png", {"autodig"},
	function(player)
		pep.enable_mole_mode(player:get_player_name())
	end,
	function(effect, player)
		pep.disable_mole_mode(player:get_player_name())
	end
)

pep.register_potion({
	basename = "speedplus",
	contentstring = S("Running Potion"),
	longdesc = S("Drinking it will make you run faster for 30 seconds."),
	effect_type = "pepspeedplus",
	duration = 30,
})
pep.register_potion({
	basename = "speedminus",
	contentstring = S("Slug Potion"),
	longdesc = S("Drinking it will make you walk slower for 30 seconds."),
	effect_type = "pepspeedminus",
	duration = 30,
})
pep.register_potion({
	basename = "speedreset",
	contentstring = S("Speed Neutralizer"),
	longdesc = S("Drinking it will stop all speed effects you may currently have."),
	effect_type = "pepspeedreset",
	duration = 0
})
pep.register_potion({
	basename = "breath",
	contentstring = S("Air Potion"),
	longdesc = S("Drinking it gives you breath underwater for 30 seconds."),
	effect_type = "pepbreath",
	duration = 30,
})
pep.register_potion({
	basename = "regen",
	contentstring = S("Weak Healing Potion"),
	longdesc = S("Drinking it makes you regenerate health. Every 2 seconds, you get 1 HP, 10 times in total."),
	effect_type = "pepregen",
	duration = 10,
})
pep.register_potion({
	basename = "regen2",
	contentstring = S("Strong Healing Potion"),
	longdesc = S("Drinking it makes you regenerate health quickly. Every second you get 2 HP, 10 times in total."),
	effect_type = "pepregen2",
	duration = 10,
})
pep.register_potion({
	basename = "grav0",
	contentstring = S("Non-Gravity Potion"),
	longdesc = S("When you drink this potion, gravity stops affecting you, as if you were in space. The effect lasts for 20 seconds."),
	effect_type = "pepgrav0",
	duration = 20,
})
pep.register_potion({
	basename = "gravreset",
	contentstring = S("Gravity Neutralizer"),
	longdesc = S("Drinking it will stop all gravity effects you currently have."),
	effect_type = "pepgravreset",
	duration = 0,
})
pep.register_potion({
	basename = "jumpplus",
	contentstring = S("High Jumping Potion"),
	longdesc = S("Drinking it will make you jump higher for 30 seconds."),
	effect_type = "pepjumpplus",
	duration = 30,
})
pep.register_potion({
	basename = "jumpminus",
	contentstring = S("Low Jumping Potion"),
	longdesc = S("Drinking it will make you jump lower for 30 seconds."),
	effect_type = "pepjumpminus",
	duration = 30,
})
pep.register_potion({
	basename = "jumpreset",
	contentstring = S("Jump Neutralizer"),
	longdesc = S("Drinking it will stop all jumping effects you may currently have."),
	effect_type = "pepjumpreset",
	duration = 0,
})
pep.register_potion({
	basename = "mole",
	contentstring = S("Mole Potion"),
	longdesc = S("Drinking it will start an effect which will magically attempt to mine any two blocks in front of you horizontally, as if you were using a steel pickaxe on them. The effect lasts for 18 seconds."),
	effect_type = "pepmole",
	duration = 18,
})
if(minetest.get_modpath("mana")~=nil) then
	pep.register_potion({
		basename = "manaregen",
		contentstring = S("Weak Mana Potion"),
		effect_type = "pepmanaregen",
		duration = 10,
		longdesc = S("Drinking it will increase your mana regeneration rate by 0.5 for 10 seconds."),
	})
	pep.register_potion({
		basename = "manaregen2",
		contentstring = S("Strong Mana Potion"),
		effect_type = "pepmanaregen2",
		duration = 10,
		longdesc = S("Drinking it will increase your mana regeneration rate by 1 for 10 seconds."),
	})
end


--[=[ register crafts ]=]
--[[ normal potions ]]
if(minetest.get_modpath("vessels")~=nil) then
if(minetest.get_modpath("default")~=nil) then
	minetest.register_craft({
		type = "shapeless",
		output = "pep:breath",
		recipe = { "default:coral_cyan", "default:coral_green", "default:coral_pink", "vessels:glass_bottle" }
	})
	minetest.register_craft({
		type = "shapeless",
		output = "pep:speedminus",
		recipe = { "default:dry_grass_1", "default:ice", "vessels:glass_bottle" }
	})
	if(minetest.get_modpath("flowers") ~= nil) then
		minetest.register_craft({
			type = "shapeless",
			output = "pep:jumpplus",
			recipe = { "flowers:flower_tulip", "default:grass_1", "default:mese_crystal_fragment",
				   "default:mese_crystal_fragment", "vessels:glass_bottle" }
		})
		minetest.register_craft({
			type = "shapeless",
			output = "pep:poisoner",
			recipe = { "flowers:mushroom_red", "flowers:mushroom_red", "flowers:mushroom_red", "vessels:glass_bottle" }
		})

		if(minetest.get_modpath("farming") ~= nil) then
			minetest.register_craft({
				type = "shapeless",
				output = "pep:regen",
				recipe = { "default:cactus", "farming:flour", "flowers:mushroom_brown", "vessels:glass_bottle" }
			})
		end
	end
	if(minetest.get_modpath("farming") ~= nil) then
		minetest.register_craft({
			type = "shapeless",
			output = "pep:regen2",
			recipe = { "default:gold_lump", "farming:flour", "pep:regen" }
		})
		if minetest.get_modpath("mana") ~= nil then
			minetest.register_craft({
				type = "shapeless",
				output = "pep:manaregen",
				recipe = { "default:dry_shrub", "default:dry_shrub", "farming:seed_cotton", "default:mese_crystal_fragment",
					   "vessels:glass_bottle" }
			})
		end
	end
	if minetest.get_modpath("mana") ~= nil then
		minetest.register_craft({
			type = "shapeless",
			output = "pep:manaregen2",
			recipe = { "default:dry_shrub", "default:dry_shrub", "default:dry_shrub", "default:dry_shrub", "default:junglesapling",
				   "default:marram_grass_1", "default:mese_crystal_fragment", "pep:manaregen" }
		})
	end

	minetest.register_craft({
		type = "shapeless",
		output = "pep:jumpminus",
		recipe = { "default:leaves", "default:jungleleaves", "default:iron_lump", "flowers:dandelion_yellow", "vessels:glass_bottle" }
	})
	minetest.register_craft({
		type = "shapeless",
		output = "pep:grav0",
		recipe = { "default:mese_crystal", "vessels:glass_bottle" }
	})
	minetest.register_craft({
		type = "shapeless",
		output = "pep:mole",
		recipe = { "default:pick_steel", "default:shovel_steel", "vessels:glass_bottle" },
	})
	minetest.register_craft({
		type = "shapeless",
		output = "pep:gravreset" ,
		recipe = { "pep:grav0", "default:iron_lump" }
	})
end
if(minetest.get_modpath("flowers") ~= nil) then
	minetest.register_craft({
		type = "shapeless",
		output = "pep:speedplus",
		recipe = { "default:pine_sapling", "default:cactus", "flowers:dandelion_yellow", "default:junglegrass", "vessels:glass_bottle" }
	})
end
end

--[[ independent crafts ]]

minetest.register_craft({
	type = "shapeless",
	output = "pep:speedreset",
	recipe = { "pep:speedplus", "pep:speedminus" }
})
minetest.register_craft({
	type = "shapeless",
	output = "pep:jumpreset",
	recipe = { "pep:jumpplus", "pep:jumpminus" }
})
