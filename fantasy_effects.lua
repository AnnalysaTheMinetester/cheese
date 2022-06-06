local S = cheese.S

-- from player effect potion aka pep mod
local ppa = minetest.get_modpath("playerphysics")
--playereffects.apply_effect_type(effect_type_id, duration, player, repeat_interval_time_left)

local add_physic = function(player, attribute, value)
	if ppa then
		playerphysics.add_physics_factor(player, attribute, "cheese:"..attribute, value)
	else
		player:set_physics_override({[attribute]=value})
	end
end
local remove_physic = function(player, attribute)
	if ppa then
		playerphysics.remove_physics_factor(player, attribute, "cheese:"..attribute)
	else
		player:set_physics_override({[attribute]=1})
	end
end

-- playereffects.register_effect_type(effect_type_id, description, icon, groups, apply, cancel, hidden, cancel_on_death, repeat_interval)
playereffects.register_effect_type("haste", S("Haste"), "haste.png", {"speed"},
	function(player)
		add_physic(player, "speed", 1.5)
	end,
	function(effect, player)
		remove_physic(player, "speed")
	end
)

playereffects.register_effect_type("snailing", S("Snailing"), "snailing.png", {"speed"},
	function(player)
		add_physic(player, "speed", 0.5)
	end,
	function(effect, player)
		remove_physic(player, "speed")
	end
)

playereffects.register_effect_type("impetus", S("Impetus"), "impetus.png", {"jump"},
	function(player)
		add_physic(player, "jump", 1.2)
	end,
	function(effect, player)
		remove_physic(player, "jump")
	end
)
playereffects.register_effect_type("burden", S("Burden"), "burden.png", {"jump"}, --low jump
	function(player)
		add_physic(player, "jump", 0.7)
	end,
	function(effect, player)
		remove_physic(player, "jump")
	end
)

playereffects.register_effect_type("chill_fall", S("Chill Fall"), "chill_fall.png", {"gravity"},
	function(player)
		add_physic(player, "gravity", 0.7)
	end,
	function(effect, player)
		remove_physic(player, "gravity")
	end
)

playereffects.register_effect_type("regen", S("Regen"), "regen.png", {"health"},
	function(player)
		player:set_hp(player:get_hp()+1)
	end,
	nil, nil, nil, 3
)

playereffects.register_effect_type("regenm", S("Major Regen"), "regen.png", {"health"},
	function(player)
		player:set_hp(player:get_hp()+2)
	end,
	nil, nil, nil, 1
)

if minetest.get_modpath("mana") ~= nil then
	playereffects.register_effect_type("manaregen", S("Mana Regen"), "mana_regen.png", {"mana"},
		function(player)
			local name = player:get_player_name()
			mana.setregen(name, mana.getregen(name) + 0.5)
		end,
		function(effect, player)
			local name = player:get_player_name()
			mana.setregen(name, mana.getregen(name) - 0.5)
		end
	)
end

playereffects.register_effect_type("miasma", S("Miasma"), "miasma.png", {"breath"},
	function(player)
		player:set_breath(player:get_breath()-4)
		if player:get_breath() < 4 then
			player:set_breath(1)
		end
	end,
	nil, nil, nil, 1
)
