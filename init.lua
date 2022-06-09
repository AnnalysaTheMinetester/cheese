cheese = {}
cheese.aged_cheeses = {"parmesan","fontal","gruyere","emmental","monteray_jack","asiago","toma","gouda","gorgonzola","stilton","brie","stracchino"}-- full list of cheeses
cheese.italian_cheeses = {"parmesan","fontal","asiago","toma","gorgonzola","stracchino"}

-- the check is done only once, otherwise it would check them many many times
cheese.ui = minetest.get_modpath("unified_inventory") ~= nil
cheese.i3 = minetest.get_modpath("i3") ~= nil
cheese.astral = minetest.get_modpath("astral") ~= nil
cheese.farming = (minetest.global_exists("farming") and farming.mod == "redo")
cheese.ethereal = minetest.get_modpath("ethereal")
cheese.moretrees =  minetest.get_modpath("moretrees") ~= nil
cheese.cv = minetest.get_modpath("cucina_vegana") ~= nil
cheese.mana = minetest.get_modpath("mana") ~= nil
cheese.playereffects = minetest.get_modpath("playereffects") ~= nil
cheese.there_is_milk = minetest.get_modpath("mobs_animal") or
                       minetest.get_modpath("petz") or
                       minetest.get_modpath("animalia")

local S
if(minetest.get_translator) then
   S = minetest.get_translator(minetest.get_current_modname())
else
    S = function ( s ) return s end
end
cheese.S = S

local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

local craft_type_table = {
	-- type name,					description,				icon
	{"cauldron_boiling", S("Boiling"), "milk_cauldron_active_side.png"},
	{"cheese_rack_aging", S("Cheese Rack Aging"), "default_wood.png^cheese_front.png"},
	{"churning", S("Churning"), "churn.png"},
	{"centrifugation", S("Centrifugation"), "cream_separator_front.png"},
}
-- each register craft recipe is in their own respective file
for k,v in pairs(craft_type_table) do
	if cheese.ui then
		unified_inventory.register_craft_type(v[1], {
		   description = v[2],
		   icon = v[3],
		   width = 1,
		   height = 1,
		   uses_crafting_grid = false
		})
	end
	if cheese.i3 then
		i3.register_craft_type(v[1], {
			description = v[2],
			icon = v[3],
		})
	end
end

dofile(path .. "items.lua")
dofile(path .. "milk_cauldron.lua")
dofile(path .. "churn.lua")
dofile(path .. "centrifuge.lua")
dofile(path .. "cheese_rack.lua")
if cheese.playereffects then
	dofile(path .. "fantasy_effects.lua")
end
dofile(path .. "fantasy.lua")
dofile(path .. "ice_cream.lua")
if minetest.get_modpath("flower_cow") then
	dofile(path .. "moobloom.lua")
end
if minetest.get_modpath("awards") then
	dofile(path .. "awards.lua")
end
