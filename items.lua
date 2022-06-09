local S = cheese.S
--[[ 					curd -cooking-> default_cheese
						 /		 -aging-> aged_cheeses
milk -boiling-> whey -cooking-> ricotta
		| \------------ \-centrifugation-> cream -craft-> ice_cream
		 \-------------------------------------- \-churning-> butter
]]--
minetest.register_craftitem("cheese:curd", {
	description = S("Curd"),
	inventory_image = "curd.png",
	groups = {milk_product = 1},
})
minetest.register_craftitem("cheese:whey", {
	description = S("Whey"),
	inventory_image = "whey.png",
	groups = {milk_product = 1},
})

minetest.register_craftitem("cheese:ricotta", {
	description = S("Ricotta"),
	inventory_image = "ricotta.png",
	on_use = minetest.item_eat(5),
	groups = {food_cheese = 1, food_cream = 1, food = 5},
})
minetest.register_craft({
	type = "cooking",
	output = "cheese:ricotta",
	recipe = "cheese:whey",
	cooktime = 15,
})

local default = "cheese:toma"
if minetest.get_modpath("mobs") then
	default = "mobs:cheese"
elseif minetest.get_modpath("petz") then
	default = "petz:cheese"
end

if minetest.get_modpath("mobs") then
	--delete the craft from mob milk bucket + farming salt and the cooking cheese one
	minetest.clear_craft({output = "mobs:butter"})
	minetest.clear_craft({output = "mobs:cheese"})
	minetest.register_craft({
		type = "shapeless",
		output = default.." 9",
		recipe = {"mobs:cheeseblock"},
	})
end
if cheese.cv then
	minetest.clear_craft({output = "cucina_vegana:imitation_butter"})
	minetest.clear_craft({output = "cucina_vegana:imitation_cheese"})
end

if minetest.get_modpath("petz") then -- petz hard-depens on farming
	minetest.clear_craft({output = "petz:cheese"})

	minetest.override_item("petz:blueberry_cheese_cake",{
		groups = {flammable = 2, food = 2},
	})
	-- minetest.after(1) cucina_vegana also override the craft, and that has priority
	minetest.clear_craft({output = "petz:blueberry_cheese_cake"})
	minetest.register_craft({
		type = "shapeless",
		output = "petz:blueberry_cheese_cake",
		recipe = {"default:blueberries", "farming:wheat", "group:food_cream", "group:food_egg"},
	})
end
-- def here because im clearing crafts for those cheeses, otherwise this gets cleared too
minetest.register_craft({
	type = "cooking",
	output = default,
	recipe = "cheese:curd",
	cooktime = 20,
})

for k, v in pairs(cheese.aged_cheeses) do
	local aged = {
		description = S(""..v:gsub("_", " "):gsub("(%a)(%a+)", function(a, b) return string.upper(a) .. string.lower(b) end) ),
		inventory_image = v..".png",
		on_use = minetest.item_eat(2),
		groups = {food = 2, food_cheese = 1},
	}
	--[[ there is no need now of this, as there are no food recipes yet
	if v == "gorgonzola" or v == "stracchino" then
		aged.groups = {food = 1, food_cheese = 1, food_creamy_cheese = 1},
	else aged.groups = {food = 1, food_cheese = 1, food_hard_cheese = 1},
	end]]--
	minetest.register_craftitem("cheese:"..v, aged )
	if cheese.ui then
		unified_inventory.register_craft({
			type = "cheese_rack_aging",
			items = {"cheese:curd"},
			output = "cheese:"..v
		})
	end
	if cheese.i3 then
		i3.register_craft({
			type = "cheese_rack_aging",
			items = {"cheese:curd"},
			result = "cheese:"..v
		})
	end
end

-- curd + curd + curd + water bucket + salt = pasta filata -> mozzarella caciocavallo scamorza
-- can be done even with bare minimum mods, as water can be boiled to get salt
minetest.register_craftitem("cheese:stretched_cheese", {
	description = S("Stretched Cheese"),
	inventory_image = "stretched_cheese.png",
	groups = {milk_product = 1},
})
minetest.register_craft({
	type = "shapeless",
	output = "cheese:stretched_cheese 4",
	recipe = {"cheese:curd", "cheese:curd", "cheese:curd", "bucket:bucket_water", "group:food_salt"},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}},
})
if minetest.get_modpath("wooden_bucket") then
	minetest.register_craft({
		type = "shapeless",
		output = "cheese:stretched_cheese 4",
		recipe = {"cheese:curd", "cheese:curd", "cheese:curd", "bucket_wooden:bucket_water", "group:food_salt"},
		replacements = {{"bucket_wooden:bucket_water", "bucket_wooden:bucket_empty"}},
	})
end

minetest.register_craftitem("cheese:mozzarella", {
	description = S("Mozzarella"),
	inventory_image = "mozzarella.png",
	on_use = minetest.item_eat(4),
	groups = {food = 4, food_cheese = 1},
})
minetest.register_craft({
	output = "cheese:mozzarella 4",
	recipe = {
		{"", "cheese:stretched_cheese", ""},
		{"cheese:stretched_cheese", "cheese:stretched_cheese", "cheese:stretched_cheese"},
		{"", "cheese:stretched_cheese", ""},
	}
})
local strip = "farming:string" -- the string is also present in a "vanilla" mt game, just not the redo. i can skip the leather strip

minetest.register_node("cheese:fresh_caciocavallo", {
	description = S("Fresh Caciocavallo"),
	inventory_image = "fresh_caciocavallo.png",
	wield_image = "fresh_caciocavallo.png",
	tiles = {
		"fresh_caciocavallo_top.png",
		"fresh_caciocavallo_bottom.png",
		"fresh_caciocavallo_right.png",
		"fresh_caciocavallo_left.png",
		"fresh_caciocavallo_back.png",
		"fresh_caciocavallo_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand = 3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.3125, -0.0625, 0.1875, 0.125, 0.125}, -- body
			{-0.0625, 0.0625, -0.0625, 0.125, 0.1875, 0.125}, -- neck
			{-0.125, 0.1875, -0.0625, 0.0625, 0.3125, 0.125}, -- head
			{0, 0.1875, 0, 0.125, 0.5, 0.0625}, -- strip
			{-0.1875, -0.25, -0.0625, 0.25, 0.0625, 0.125}, -- body2
			{-0.125, -0.25, -0.125, 0.1875, 0.0625, 0.1875}, -- body3
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.3125, -0.125, 0.25, 0.5, 0.1875}, -- selection
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.3125, -0.125, 0.25, 0.5, 0.1875}, -- selection
		}
	},
	on_construct = function(pos)
		local timer = minetest.get_node_timer(pos)
		timer:start( 70 + math.random(-5.0 , 5.0) )

	end,
  after_place_node = function(pos, placer, itemstack, pointed_thing)
		if placer:is_player() and itemstack:is_empty() == false then
			local above_name = minetest.get_node(vector.add(pos, vector.new(0, 1, 0))).name
			--minetest.chat_send_player("singleplayer", "Node ".. minetest.get_node(pos).name .. " and Above "..above_name.."Light at Node is ".. minetest.get_node_light(pos))

			if above_name ~= "ignore" and minetest.get_item_group( above_name , "wood" ) == 0 then
				minetest.set_node(pos, {name = "air"})
				minetest.add_item(pos, "cheese:fresh_caciocavallo")
			end
		end
	end,
	on_timer = function(pos)
		local timer = minetest.get_node_timer(pos)
		local above_name = minetest.get_node(vector.add(pos, vector.new(0, 1, 0))).name -- fakes a reverse group:attached behaviour
		if above_name ~= "ignore" and minetest.get_item_group( above_name , "wood" ) > 0 then
			if minetest.get_node_light(pos) <= 7 and minetest.get_node_light(pos) >= 12 or math.random() > 0.1 then
				return true
			end
		else
			timer:stop()
			minetest.set_node(pos, {name = "air"})
			minetest.add_item(pos, "cheese:fresh_caciocavallo")
			return false
		end
		local node = minetest.get_node(pos)
		if node.name ~= "ignore" then
			minetest.set_node(pos, {name = "cheese:caciocavallo", param2= node.param2})
			return false
		end
		return true
	end,
})
minetest.register_craft({
	output = "cheese:fresh_caciocavallo 4",
	recipe = {
		{"", strip, "cheese:stretched_cheese"},
		{"cheese:stretched_cheese", "cheese:stretched_cheese", strip},
		{"cheese:stretched_cheese", "cheese:stretched_cheese", ""},
	}
})
minetest.register_node("cheese:caciocavallo", {
	description = S("Caciocavallo"),
	inventory_image = "caciocavallo.png",
	wield_image = "caciocavallo.png",
	tiles = {
		"caciocavallo_top.png",
		"caciocavallo_bottom.png",
		"caciocavallo_right.png",
		"caciocavallo_left.png",
		"caciocavallo_back.png",
		"caciocavallo_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {food = 8, food_cheese = 1, oddly_breakable_by_hand = 3},
	on_use = minetest.item_eat(8),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.3125, -0.0625, 0.1875, 0.125, 0.125}, -- body
			{-0.0625, 0.0625, -0.0625, 0.125, 0.1875, 0.125}, -- neck
			{-0.125, 0.1875, -0.0625, 0.0625, 0.3125, 0.125}, -- head
			{0, 0.1875, 0, 0.125, 0.5, 0.0625}, -- strip
			{-0.1875, -0.25, -0.0625, 0.25, 0.0625, 0.125}, -- body2
			{-0.125, -0.25, -0.125, 0.1875, 0.0625, 0.1875}, -- body3
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.3125, -0.125, 0.25, 0.5, 0.1875}, -- selection
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.3125, -0.125, 0.25, 0.5, 0.1875}, -- selection
		}
	},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		if placer:is_player() and itemstack:is_empty() == false then
			local above_name = minetest.get_node(vector.add(pos, vector.new(0, 1, 0))).name

			if minetest.get_item_group( above_name , "wood" ) == 0 then
				minetest.set_node(pos, {name = "air"})
				minetest.add_item(pos, "cheese:fresh_caciocavallo")
			end
		end
	end,
})

minetest.register_craftitem("cheese:scamorza", { -- less hunger, unless cooked aka "smoked"
	description = S("Scamorza"),
	inventory_image = "scamorza.png",
	on_use = minetest.item_eat(4),
	groups = {food = 4, food_cheese = 1},
})
minetest.register_craft({
	output = "cheese:scamorza 4",
	recipe = {
		{"", "cheese:stretched_cheese", ""},
		{"cheese:stretched_cheese", "cheese:stretched_cheese", ""},
		{"cheese:stretched_cheese", "cheese:stretched_cheese", ""},
	}
})
minetest.register_craftitem("cheese:smoked_scamorza", {
	description = S("Smoked Scamorza"),
	inventory_image = "smoked_scamorza.png",
	on_use = minetest.item_eat(7),
	groups = {food = 7, food_cheese = 1},
})
minetest.register_craft({
	type = "cooking",
	output = "cheese:smoked_scamorza",
	recipe = "cheese:scamorza",
	cooktime = 11,
})

minetest.register_craftitem("cheese:fondue", {
	description = S("Fondue"),
	inventory_image = "fondue.png",
	on_use = minetest.item_eat(8, "default:copper_ingot 3"),
	groups = {food = 8},
})
minetest.register_craft({
	output = "cheese:fondue",
	recipe = {
		{"group:food_cheese", "", "group:food_cheese"},
		{"default:copper_ingot", "group:food_cheese", "default:copper_ingot"},
		{"", "default:copper_ingot", ""},
	}
})

if cheese.ethereal and cheese.farming then
	minetest.register_craftitem("cheese:fruit_tonic", {
		description = S("Fruit Tonic"),
		inventory_image = "fruit_tonic.png",
		on_use = minetest.item_eat(8, "vessels:glass_bottle"),
		groups = {food = 8, vessel = 1},
	})
	minetest.register_craft({
		output = "cheese:fruit_tonic",
		recipe = {
			{"group:food_grapes", "group:food_orange", "group:food_apple"},
			{"group:food_apple", "group:food_grapes", "group:food_orange"},
			{"vessels:glass_bottle", "cheese:whey", "vessels:glass_bottle"},
		},
	})
end -- if ingredients are present, apple:default, grapes:farming, orange:ethereal

if cheese.farming then
	minetest.register_craft({
		output = "farming:porridge",
		type = "shapeless",
		recipe = {"farming:oat", "farming:oat", "farming:oat" ,"farming:oat", "group:food_bowl", "cheese:whey"},
	})
end

if minetest.get_modpath("pie") then
	minetest.clear_craft({output = "pie:rvel_0"})
	minetest.register_craft({
		output = "pie:rvel_0",
		recipe = {
			{"group:food_cocoa", "group:food_milk", "dye:red"},
			{"group:food_sugar", "group:food_egg", "group:food_sugar"},
			{"group:food_flour", "group:food_cream", "group:food_flour"}
		},
		replacements = {{"mobs:bucket_milk", "bucket:bucket_empty"},
										{"animalia:bucket_milk", "bucket:bucket_empty"},
										{"petz:bucket_milk", "bucket:bucket_empty"},
										{"cucina_vegana:soy_milk", "vessels:glass_bottle"},}
	})

	minetest.clear_craft({output = "pie:scsk_0"})
	minetest.register_craft({
		output = "pie:scsk_0",
		recipe = {
			{"group:food_strawberry", "group:food_cream", "group:food_strawberry"},
			{"group:food_sugar", "group:food_egg", "group:food_sugar"},
			{"group:food_wheat", "group:food_flour", "group:food_wheat"}
		},
	})
end
