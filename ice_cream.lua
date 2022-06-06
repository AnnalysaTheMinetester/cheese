local S = cheese.S

if minetest.get_modpath("icecream") then

	local ingredients = {
		{"apple", 		"default:apple"},
		{"blueberries", "default:blueberries"},
		{"banana", 		"ethereal:banana"},
		{"orange", 		"ethereal:orange"},
		{"strawberry", 	"ethereal:strawberry"},
		{"carrot", 		"farming:carrot"},
		{"chocolate", 	"farming:chocolate_dark"},
		{"pineapple", 	"farming:pineapple"},
		{"pumpkin", 	"farming:pumpkin_slice"},
		{"watermelon", 	"farming:melon_slice"},
		{"vanilla", 	"farming:vanilla"},
		{"mint", 		"farming:mint_leaf"},
	}
	for k,v in pairs(ingredients) do
		minetest.clear_craft({output = "icecream:"..v[1]})

		minetest.register_craft({
			output = "icecream:"..v[1],
			recipe = {
				{v[2],v[2],v[2]},
				{"", "group:food_icecream_base", ""},
				{"", "icecream:cone", ""},
			}
		})
	end

end

minetest.register_craftitem("cheese:ice_cream_base", {
	description = S("Ice Cream"),
	inventory_image = "ice_cream_base.png",
	on_use = minetest.item_eat(3),
	groups = {milk_product = 1, food = 5, food_icecream = 1, food_icecream_base = 1},
})
minetest.register_craft({
	type = "shapeless",
	output = "cheese:ice_cream_base 4",
	recipe = {"group:food_milk", "cheese:milk_cream", "cheese:milk_cream", "group:food_sugar", "default:snow"},
	replacements = {{"group:food_milk", "bucket:bucket_empty"}},
})

minetest.register_craftitem("cheese:vegan_ice_cream_base", {
	description = S("Vegan Ice Cream"),
	inventory_image = "vegan_ice_cream_base.png",
	on_use = minetest.item_eat(3),
	groups = {vegan_alternative = 1, food = 5, food_icecream = 1, food_icecream_base = 1},
})
if cheese.cv then
	minetest.register_craft({
		type = "shapeless",
		output = "cheese:vegan_ice_cream_base 4",
		recipe = {"cucina_vegana:soy_milk", "cheese:coconut_cream", "cheese:coconut_cream", "group:food_sugar", "default:snow"},
		replacements = {{"cucina_vegana:soy_milk", "vessels:drinking_glass"} },
	})
end
if cheese.moretrees then
	minetest.register_craft({
		type = "shapeless",
		output = "cheese:vegan_ice_cream_base 4",
		recipe = {"moretrees:coconut_milk", "moretrees:coconut_milk", "cheese:coconut_cream", "cheese:coconut_cream", "group:food_sugar", "default:snow"},
		replacements = {{"moretrees:coconut_milk", "vessels:drinking_glass"}, {"moretrees:coconut_milk", "vessels:drinking_glass"}},
	})
end

if cheese.farming then
	minetest.register_craftitem("cheese:neapolitan_ice_cream", {
		description = S("Neapolitan Ice Cream"),
		inventory_image = "neapolitan_ice_cream.png",
		on_use = minetest.item_eat(11),
		groups = {food = 11, food_icecream = 1},
	})

	minetest.register_craft({
		output = "cheese:neapolitan_ice_cream 4",
		recipe = {
			{"", "", "group:food_strawberry"},
			{"farming:vanilla_extract", "group:food_chocolate", "group:food_strawberry"},
			{"group:food_icecream_base", "group:food_icecream_base", "group:food_icecream_base"},
		},
		replacements = {{"farming:vanilla_extract", "vessels:glass_bottle"} },
	})

	minetest.register_craft({
		output = "cheese:neapolitan_ice_cream 4",
		recipe = {
			{"", "", "group:food_strawberry"},
			{"farming:vanilla_extract", "farming:chocolate_dark", "group:food_strawberry"},
			{"group:food_icecream_base", "group:food_icecream_base", "group:food_icecream_base"},
		},
		replacements = {{"farming:vanilla_extract", "vessels:glass_bottle"} },
	})
end
