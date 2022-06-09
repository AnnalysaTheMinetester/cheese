local S = cheese.S
local rack_types = {
	--craft material			tiles					rack name			name	 	aging time (MIN 3!)
	{"default:obsidian", 	"obsidian", 	"obsidian",	"Obsidian",	75.0},
}
local slab = "stairs:slab_"
if minetest.get_modpath("moreblocks") then
	slab = "moreblocks:slab_"
end
local fantasy_cheeses = {
	-- cheese name, 		aged from item, mana+, status effect
	{"sparkling_cheese",	"cheese:curd", 10, "manaregen"},
}
local gelatin = ""

local juicer = ""
if cheese.farming then
	juicer = "farming:juicer"
	gelatin = "group:food_gelatin"
	table.insert(fantasy_cheeses, {"rose_ambrosia",	"farming:rose_water", 10, "regen"})
end
if minetest.get_modpath("ethereal") == nil then
	-- def copied from ethereal. if it isnt present, you can at least have something more than aging curd!
	minetest.register_craftitem("cheese:bucket_cactus", {
		description = S("Bucket of Cactus Pulp"),
		inventory_image = "bucket_cactus.png",
		wield_image = "bucket_cactus.png",
		stack_max = 1,
		groups = {vessel = 1, drink = 1},
		on_use = minetest.item_eat(2, "bucket:bucket_empty"),
	})

	minetest.register_craft({
		output = "cheese:bucket_cactus",
		recipe = {
			{"bucket:bucket_empty","default:cactus", juicer},
		}
	})
	table.insert(fantasy_cheeses, {"desert_delicacy",			"cheese:bucket_cactus", 0, "regen"})
else
	table.insert(fantasy_cheeses, {"desert_delicacy",			"ethereal:bucket_cactus", 0, "regen", "snailing"})
	table.insert(fantasy_cheeses, {"blazing_exquisitess",	"ethereal:firethorn_jelly", 20, "haste", "impetus"})
	table.insert(fantasy_cheeses, {"frosted_tomme",				"cheese:frosted_spume", 20, "chill_fall", "impetus"})
	table.insert(fantasy_cheeses, {"shining_formage",			"cheese:shining_spume", 20, "regenm"})

	gelatin = "group:food_gelatin"

	minetest.register_craftitem("cheese:shining_spume", {
		description = S("Shining Spume"),
		inventory_image = "shining_spume.png",
		groups = {bucket = 1},
		--light_source = 9
	})
	minetest.register_craft({
		output = "cheese:shining_spume",
		recipe = {
			{"ethereal:yellowleaves", "ethereal:willow_twig", "ethereal:yellowleaves"},
			{juicer, "group:food_lemon", gelatin},
			{"", "bucket:bucket_river_water", ""},
		},
		replacements = { {"bucket:bucket_river_water", "bucket:bucket_empty"} }
	})

	minetest.register_craftitem("cheese:frosted_spume", {
		description = S("Frosted Spume"),
		inventory_image = "frosted_spume.png",
		groups = {bucket = 1},
	})
	minetest.register_craft({
		output = "cheese:frosted_spume",
		recipe = {
			{"ethereal:frost_leaves", "ethereal:crystalgrass", "ethereal:frost_leaves"},
			{juicer, "group:food_lemon", gelatin},
			{"", "bucket:bucket_river_water", ""},
		},
		replacements = { {"bucket:bucket_river_water", "bucket:bucket_empty"} }
	})
end
if minetest.get_modpath("flower_cow") then
	table.insert(fantasy_cheeses, {"rose_ambrosia",		"cheese:bucket_blooming_essence", 10, "regen"})
end

local heal = function(player, value)
	local hp = player:get_hp() + value
	if hp >= 20 then
		player:set_hp(20)
	else player:set_hp(hp)
	end
end
local cleanse = function(player)
	local status = playereffects.get_player_effects(player:get_player_name())
	for i=1, #status do
		if status[i].effect_type_id == "snailing" or status[i].effect_type_id == "burden" or status[i].effect_type_id == "miasma" then
			playereffects.cancel_effect(status[i].effect_id)
		end
	end

end

for k, v in pairs(fantasy_cheeses) do
	--the check should be done each and evry time a player eats!!!
	local use
	-- only if you use mana you get an effect
	if cheese.mana then
		if cheese.playereffects then
			use = function(itemstack, player, pointed_thing)
				if v[3] > 0 then
					mana.add_up_to(player:get_player_name(), v[3])
				else mana.subtract_up_to(player:get_player_name(), -v[3])
				end
				if v[4] then playereffects.apply_effect_type(v[4], 20, player) end
				if v[5] then playereffects.apply_effect_type(v[5], 20, player) end
				if v[1] == "shining_formage" then heal(player,8)
				elseif v[1] == "rose_ambrosia" then cleanse(player)
				end
				return minetest.do_item_eat(4, nil, itemstack, player, pointed_thing)
			end
		else
			use = function(itemstack, player, pointed_thing)
					if v[3] > 0 then
						mana.add_up_to(player:get_player_name(), v[3])
					else mana.subtract_up_to(player:get_player_name(), -v[3])
					end
					if v[1] == "shining_formage" then heal(player,8)
					elseif v[1] == "rose_ambrosia" then cleanse(player)
					end
					return minetest.do_item_eat(4, nil, itemstack, player, pointed_thing)
			end
		end
	else
		use = function(itemstack, player, pointed_thing)
			if v[1] == "shining_formage" then heal(player,8)
			elseif v[1] == "rose_ambrosia" then cleanse(player)
			end
			return minetest.do_item_eat(4, nil, itemstack, player, pointed_thing)
		end
	end
	minetest.register_craftitem("cheese:"..v[1], {
			description = S(""..v[1]:gsub("_", " "):gsub("(%a)(%a+)", function(a, b) return string.upper(a) .. string.lower(b) end) ),
			inventory_image = v[1]..".png",
			on_use = use,
			groups = {food = 4, food_cheese = 1, food_fantasy_cheese = 1},
		})
	--[[
	if cheese.ui then
		unified_inventory.register_craft({
			type = "cheese_rack_aging",
			items = {v[2]..""},
			output = "cheese:"..v[1]
		})
	end
	if cheese.i3 then
		i3.register_craft({
			type = "cheese_rack_aging",
			items = {v[2]..""},
			result = "cheese:"..v[1]
		})
	end
	]]--

end

local function is_accettable_source(item_name)
	for k, v in pairs(fantasy_cheeses) do
		if item_name == v[2] then
			return true, v[1]
		end
	end
	return false, fantasy_cheeses[1][1]
end


local function should_return (item_name)
	if item_name == "ethereal:bucket_cactus" or item_name == "cheese:frosted_spume" or item_name == "cheese:shining_spume" or item_name == "cheese:bucket_blooming_essence" then
		return "bucket:bucket_empty"
	elseif item_name == "ethereal:firethorn_jelly" or item_name == "farming:rose_water" then
		return "vessels:glass_bottle"
	end
	return "no"
end

if cheese.astral then
	-- bad cheese
	minetest.register_craftitem("cheese:noxious_cheddar", {
		description = S("Noxious Cheddar"),
		inventory_image = "noxious_cheddar.png",
		on_use = function(itemstack, player, pointed_thing)
			if cheese.mana then
				mana.subtract_up_to(player:get_player_name(), 40)
				if cheese.playereffects then
					local status = playereffects.get_player_effects(player:get_player_name())
					for i=1, #status do
						if status[i].effect_type_id == "regen" or status[i].effect_type_id == "regenm" then
							playereffects.cancel_effect(status[i].effect_id)
						end
					end
					playereffects.apply_effect_type("snailing", 15, player)
					playereffects.apply_effect_type("burden", 15, player)
					playereffects.apply_effect_type("miasma", 15, player, 1)
				end
			end
			return minetest.do_item_eat(5, nil, itemstack, player, pointed_thing)
		end,
		groups = {food = 5, not_in_creative_inventory = 1, food_cheese = 1},
	})
end

local function get_fantasy_cheese( aged_product )

	if cheese.astral then
		local event, event_name = astral.get_astral_event()
		if not ( event == nil or event == "none" or  event == "normal" ) then

			if event_name == "Blue Moon" and aged_product == "frosted_tomme" then
				return "cheese:".. aged_product .." "..math.random(4,5)

			elseif event_name == "Blood Moon" and aged_product == "blazing_exquisitess" then
				return "cheese:".. aged_product .." "..math.random(4,5)

			elseif event_name == "Blood Moon" and aged_product == "shining_formage" then
				return "cheese:noxious_cheddar"..math.random(4,5)

			elseif event_name == "Black Moon" and aged_product == "shining_formage" then
				return "cheese:noxious_cheddar"..math.random(4,5)

			elseif event_name == "White Moon" and aged_product == "desert_delicacy" then
				return "cheese:".. aged_product .." "..math.random(4,5)

			elseif event_name == "Super Moon" then
				return "cheese:".. aged_product .." "..math.random(5,7)

			elseif event_name == "Rainbow Sun" and aged_product == "rose_ambrosia" then
				return "cheese:".. aged_product .." "..math.random(4,5)

			elseif event_name == "Ring Sun" or event_name == "Crescent Sun" then -- ring_sun = sun eclipse
				return "cheese:".. aged_product .." "..math.random(4,5)
			end
		end
	end
	return "cheese:".. aged_product .." "..math.random(2,4)

end

local cheese_rack_empty = {
	description = "Cheese Rack",
	drawtype = "nodebox",
	--paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 4,},
	sounds = default.node_sound_stone_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, -0.375, 0.375}, -- base
			{-0.5, 0.375, -0.4375, 0.5, 0.5, 0.375}, -- top
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- back
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375}, -- right
			{-0.5, -0.375, -0.375, -0.375, 0.375, 0.375}, -- left
			{-0.4375, -0.0625, -0.4375, 0.4375, 0.0625, 0.375}, -- middle
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5}, -- selection
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5}, -- selection
		}
	},
}

local cheese_rack_with_aging_cheese = {
	description = "Cheese Rack with Aging Cheese",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 4, not_in_creative_inventory = 1},
	sounds = default.node_sound_stone_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, -0.375, 0.375}, -- base
			{-0.5, 0.375, -0.4375, 0.5, 0.5, 0.375}, -- top
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- back
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375}, -- right
			{-0.5, -0.375, -0.375, -0.375, 0.375, 0.375}, -- left
			{-0.4375, -0.0625, -0.4375, 0.4375, 0.0625, 0.375}, -- middle
			{-0.375, -0.375, -0.3125, 0.375, 0.375, 0.375}, -- cheese1
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5}, -- selection
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5}, -- selection
		}
	},
}

local cheese_rack_with_cheese = {
	description = "Cheese Rack with Cheese",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 4, not_in_creative_inventory = 1},
	sounds = default.node_sound_stone_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, -0.375, 0.375}, -- base
			{-0.5, 0.375, -0.4375, 0.5, 0.5, 0.375}, -- top
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5}, -- back
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375}, -- right
			{-0.5, -0.375, -0.375, -0.375, 0.375, 0.375}, -- left
			{-0.4375, -0.0625, -0.4375, 0.4375, 0.0625, 0.375}, -- middle
			{-0.375, -0.375, -0.3125, 0.375, 0.375, 0.375}, -- cheese1
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5}, -- selection
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5}, -- selection
		}
	},
}

for k, v in pairs(rack_types) do
	cheese_rack_empty.description = S( v[4] .." Cheese Rack")
	cheese_rack_with_aging_cheese.description = S( v[4] .." Cheese Rack with Aging Cheese")
	cheese_rack_with_cheese.description = S( v[4] .." Cheese Rack with Cheese")

	cheese_rack_empty.tiles = {"default_"..v[2]..".png"}
	cheese_rack_with_aging_cheese.tiles = {
		"default_"..v[2]..".png",
		"default_"..v[2]..".png",
		"default_"..v[2]..".png",
		"default_"..v[2]..".png",
		"default_"..v[2]..".png",
		"default_"..v[2]..".png^fresh_cheese_front.png"
	}
	cheese_rack_with_cheese.tiles = {
		"default_"..v[2]..".png",
		"default_"..v[2]..".png",
		"default_"..v[2]..".png",
		"default_"..v[2]..".png",
		"default_"..v[2]..".png",
		"default_"..v[2]..".png^cheese_front.png"
	}

	cheese_rack_empty.groups = {cracky = 1, cheese_rack = 1 }
	cheese_rack_with_aging_cheese.groups = {cracky = 1, not_in_creative_inventory = 1, cheese_rack = 1 }
	cheese_rack_with_cheese.groups = {cracky = 1, not_in_creative_inventory = 1, cheese_rack = 1 }

	cheese_rack_empty.sounds = default.node_sound_stone_defaults()
	cheese_rack_with_aging_cheese.sounds = default.node_sound_stone_defaults()
	cheese_rack_with_cheese.sounds = default.node_sound_stone_defaults()

	cheese_rack_empty.on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if player:is_player() then
		local accettable, given = is_accettable_source(itemstack:get_name())
			if accettable then
				local sr = should_return ( itemstack:get_name() )
				if cheese.mana then
					local success = mana.subtract(player:get_player_name(), 40)
					if success == false then
						minetest.chat_send_player(player:get_player_name(), S("You dont have enough mana to use the obsidian shelf.") )
						return itemstack
					end
					minetest.chat_send_player(player:get_player_name(), S("You used 10 mana points."))
				end
				itemstack:take_item()
				minetest.sound_play("ftsp_0".. math.random(1, 2) ,
					{pos = pos, max_hear_distance = 8, gain = 0.5})
				if not( sr == "no" )then
					local inv = player:get_inventory()
					if inv:room_for_item("main", sr) then
						leftover = inv:add_item("main", sr)
						if not leftover:is_empty() then
							minetest.add_item(player:get_pos(), leftover)
						end
					end
				end
				minetest.set_node(pos, {name = "cheese:"..v[3].."_cheese_rack_with_aging_cheese", param2 = node.param2})
				local meta = minetest.get_meta(pos)
				meta:set_string("aging", given )
			end
		end
		return itemstack
	end

	cheese_rack_with_aging_cheese.on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		if meta:get_string("aging") == nil or meta:get_string("aging") == "" then
			meta:set_string("aging", "sparkling_cheese")
		end
		local timer = minetest.get_node_timer(pos)
		timer:start( v[5] + math.random(-3.0 , 3.0) )
	end

	cheese_rack_with_aging_cheese.on_timer = function(pos)
		if minetest.get_node_light(pos) <= 11 and math.random(1,10) <= 1 then
			local node = minetest.get_node(pos)
			local aging = minetest.get_meta(pos):get_string("aging")
			if node.name ~= "ignore" then
				minetest.set_node(pos, {name = "cheese:"..v[3].."_cheese_rack_with_cheese", param2 = node.param2})
				local meta = minetest.get_meta(pos)
				meta:set_string("aging", aging)
				return false
			end
			return true
		end
	end

	cheese_rack_with_cheese.on_punch = function(pos, node, player, pointed_thing)
		local inv
		local leftover
		local product = minetest.get_meta(pos):get_string("aging")
		if product == nil or product == "" then
			product = "sparkling_cheese" --default if the node is placed with creative or something
		end
		local given = get_fantasy_cheese(product)

		if player:is_player() then
			minetest.sound_play("ftspw_0".. math.random(1, 3) ,
				{pos = pos, max_hear_distance = 8, gain = 0.5})

			inv = player:get_inventory()
			if inv:room_for_item("main", given) then
				leftover = inv:add_item("main", given)
				if not leftover:is_empty() then
					minetest.add_item(player:get_pos(), leftover)
				end
			else
				minetest.add_item(player:get_pos(), given)
			end
			local node = minetest.get_node(pos)
			minetest.set_node(pos, {name = "cheese:"..v[3].."_cheese_rack_empty", param2 = node.param2})
		end
	end

	cheese_rack_with_aging_cheese.drop = "cheese:"..v[3].."_cheese_rack_empty"
	cheese_rack_with_cheese.drop = "cheese:"..v[3].."_cheese_rack_empty"

	minetest.register_node ("cheese:"..v[3].."_cheese_rack_empty", table.copy(cheese_rack_empty))
	minetest.register_node ("cheese:"..v[3].."_cheese_rack_with_aging_cheese", table.copy(cheese_rack_with_aging_cheese))
	minetest.register_node ("cheese:"..v[3].."_cheese_rack_with_cheese", table.copy(cheese_rack_with_cheese))

	minetest.register_craft({
	output = "cheese:"..v[3].."_cheese_rack_empty",
	recipe = {
		{""..v[1], slab..v[2], ""..v[1]},
		{""..v[1], slab..v[2], ""..v[1]},
		{""..v[1], slab..v[2], ""..v[1]},
	}
})

end
