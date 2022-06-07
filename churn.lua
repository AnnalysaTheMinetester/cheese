local S = cheese.S

local churnable = {
	{"group:food_milk",			"cheese:butter"},
	{"cheese:milk_cream",		"cheese:butter 2"},
}

minetest.register_craftitem("cheese:vegetable_butter_prep", {
	description = S("Vegetable Butter Preparation"),
	inventory_image = "vegetable_butter_prep.png",
	groups = {vegan_alternative = 1},
})
minetest.register_craftitem("cheese:vegetable_butter", {
	description = S("Vegetable Butter"),
	inventory_image = "vegetable_butter.png",
	groups = {food_butter = 1, vegan_alternative = 1, food_vegan = 1},
})
local vegetable_milks = {"group:food_coconut_milk"} -- all are in vessels:drinking_glass
if cheese.farming ~= nil then
	table.insert(vegetable_milks, "farming:soy_milk" )
end
if cheese.cv then
	table.insert(vegetable_milks, "cucina_vegana:soy_milk" )
end

--ethereal has olive, cucina_vegana has lots and farming has the least favourite hemp oil, still there could be no item belonging to the group:food_oil
if not ( cheese.farming or minetest.get_modpath("ethereal") or cheese.cv ) and cheese.moretrees then
	minetest.register_craftitem("cheese:nut_oil", {
		description = S("Nut Oil"),
		inventory_image = "nut_oil.png",
		groups = {food_oil = 1, vegan_alternative = 1, vessel = 1},
	})
	local nuts = {"moretrees:spruce_nuts", "moretrees:fir_nuts", "moretrees:cedar_nuts"}
	for i=1,#nuts do
		minetest.override_item(nuts[i], {
			groups = {food = 1, food_nut = 1},
		})
	end
	minetest.register_craft({
		output = "cheese:nut_oil",
		type = "shapeless",
		recipe = { "vessels:glass_bottle", "group:food_nut", "group:food_nut", "group:food_nut", "group:food_nut", "group:food_nut" },
	})
end -- id there is no known food oil, but there is moretrees

for i=1,#vegetable_milks do
	minetest.register_craft({
		output = "cheese:vegetable_butter_prep",
		type = "shapeless",
		recipe = { "group:food_oil" , "cheese:coconut_cream", "cheese:coconut_cream", vegetable_milks[i], vegetable_milks[i] },
		replacements = {{vegetable_milks[i] , "vessels:drinking_glass"},
										{vegetable_milks[i] , "vessels:drinking_glass"},
										{"group:food_oil" , "vessels:glass_bottle"}, },
	})
end

table.insert(churnable, {"cheese:vegetable_butter_prep", "cheese:vegetable_butter 2"})

for k, v in pairs(churnable) do
	if cheese.ui then
		unified_inventory.register_craft({
			type = "churning",
			items = {v[1]},
			output = v[2]
		})
	end -- if ui
	if cheese.i3 then
		i3.register_craft({
			type = "churning",
			items = {v[1]},
			result = v[2]
		})
	end -- if i3
end -- for

local function is_accettable_source(item_name)
	for k, v in pairs(churnable) do
		if item_name == v[1] or (minetest.get_item_group( item_name , "food_milk" ) > 0 and minetest.get_item_group( item_name , "food_vegan" ) == 0) then -- cow milk, not vegan
			return true, v[2]
		end
	end
	return false, "no"
end

local function should_return (item_name) -- only inside the is_accettable_source check therefor there is no need for the food_vegan check
	if minetest.get_item_group( item_name , "food_milk") > 0 then
		return "bucket:bucket_empty"
	end
	return "no"
end


minetest.register_node("cheese:churn", {
	description = S("Churn"),
	tiles = {
		"churn_top.png",
		"churn_bottom.png",
		"churn.png",
		"churn.png",
		"churn.png",
		"churn.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, -0.3125, 0.375}, -- Bottom
			{-0.3125, -0.3125, -0.3125, 0.3125, -0.125, 0.3125}, -- Middle
			{-0.25, -0.125, -0.25, 0.25, 0.0625, 0.25}, -- Top
			{-0.0625, 0.0625, -0.0625, 0.0625, 0.5, 0.0625}, -- Pole
			{-0.25, 0.0625, -0.25, 0.25, 0.125, -0.1875}, -- Side1
			{-0.25, 0.0625, 0.1875, 0.25, 0.125, 0.25}, -- Side2
			{-0.25, 0.0625, -0.1875, -0.1875, 0.125, 0.1875}, -- Side3
			{0.1875, 0.0625, -0.1875, 0.25, 0.125, 0.1875}, -- Side4
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, -0.3125, 0.375}, -- Bottom
			{-0.3125, -0.3125, -0.3125, 0.3125, -0.125, 0.3125}, -- Middle
			{-0.25, -0.125, -0.25, 0.25, 0.125, 0.25},
			{-0.0625, 0.0625, -0.0625, 0.0625, 0.5, 0.0625}, -- Pole
		}
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, -0.3125, 0.375}, -- Bottom
			{-0.3125, -0.3125, -0.3125, 0.3125, -0.125, 0.3125}, -- Middle
			{-0.25, -0.125, -0.25, 0.25, 0.125, 0.25},
			{-0.0625, 0.0625, -0.0625, 0.0625, 0.5, 0.0625}, -- Pole
		}
	},
	groups = {choppy = 2, cracky = 1, attached_node = 1},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if player:is_player() and itemstack:is_empty() == false then
			local itemname = itemstack:get_name()
			local accettable, given = is_accettable_source(itemname)
			if accettable then

				minetest.sound_play( {name = "churn".. math.random(1, 3), pos = pos, max_hear_distance = 16, gain = 1.0, })

				local inv = player:get_inventory()
				if inv:room_for_item("main", given) then
					leftover = inv:add_item("main", given)
					itemstack:take_item()
					if not leftover:is_empty() then
						minetest.add_item(player:get_pos(), leftover)
					end
				else
					itemstack:take_item()
					minetest.add_item(player:get_pos(), given)
				end
				local sr = should_return ( itemname )
				if not( sr == "no" )then
					if inv:room_for_item("main", sr) then
						inv:add_item("main", sr)
					else
						minetest.add_item(player:get_pos(), sr)
					end
				end
			end
		end
		return itemstack
	end,
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		meta:set_string('infotext', S('Churn') ..'\n'.. S('Makes butter from milk, or milk cream.'))
	end,
	on_rotate = function(pos, node)
		return false
	end,
})

minetest.register_craft({
	output = "cheese:churn",
	recipe = {
		{"", "default:stick", ""},
		{"", "default:wood", ""},
		{"default:wood", "default:steel_ingot", "default:wood"},
	}
})
