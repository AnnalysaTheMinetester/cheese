local S = cheese.S

local inactive_nodebox = {
  type = "fixed",
  fixed = {
    {-0.3125, -0.3125, -0.3125, 0.3125, 0.4375, 0.3125}, -- core
    {-0.4375, -0.5, -0.4375, -0.25, -0.4375, -0.25}, -- foot1base
    {-0.375, -0.4375, -0.375, -0.25, -0.25, -0.25}, -- foot1
    {0.25, -0.5, -0.4375, 0.4375, -0.4375, -0.25}, -- foot2base
    {0.25, -0.4375, -0.375, 0.375, -0.25, -0.25}, -- foot2
    {0.25, -0.5, 0.25, 0.4375, -0.4375, 0.4375}, -- foot3base
    {0.25, -0.4375, 0.25, 0.375, -0.25, 0.375}, -- foot3
    {-0.4375, -0.5, 0.25, -0.25, -0.4375, 0.4375}, -- foot4base
    {-0.375, -0.4375, 0.25, -0.25, -0.25, 0.375}, -- foot4
    {-0.375, -0.1875, -0.375, 0.375, 0.3125, 0.375}, -- side1
    {-0.4375, -0.0625, -0.4375, 0.4375, 0.25, 0.4375}, -- outerside1
    {-0.3125, 0.4375, -0.375, 0.3125, 0.5, -0.3125}, -- edge1
    {-0.3125, 0.4375, 0.3125, 0.3125, 0.5, 0.375}, -- edge2
    {-0.375, 0.4375, -0.3125, -0.3125, 0.5, 0.3125}, -- edge3
    {0.3125, 0.4375, -0.3125, 0.375, 0.5, 0.3125}, -- edge4
    {-0.25, -0.5, -0.25, 0.25, -0.375, 0.25}, -- logs
  }
}
local active_nodebox = {
  type = "fixed",
  fixed = {
    {-0.3125, -0.3125, -0.3125, 0.3125, 0.4375, 0.3125}, -- core
    {-0.4375, -0.5, -0.4375, -0.25, -0.4375, -0.25}, -- foot1base
    {-0.375, -0.4375, -0.375, -0.25, -0.25, -0.25}, -- foot1
    {0.25, -0.5, -0.4375, 0.4375, -0.4375, -0.25}, -- foot2base
    {0.25, -0.4375, -0.375, 0.375, -0.25, -0.25}, -- foot2
    {0.25, -0.5, 0.25, 0.4375, -0.4375, 0.4375}, -- foot3base
    {0.25, -0.4375, 0.25, 0.375, -0.25, 0.375}, -- foot3
    {-0.4375, -0.5, 0.25, -0.25, -0.4375, 0.4375}, -- foot4base
    {-0.375, -0.4375, 0.25, -0.25, -0.25, 0.375}, -- foot4
    {-0.375, -0.1875, -0.375, 0.375, 0.3125, 0.375}, -- side1
    {-0.4375, -0.0625, -0.4375, 0.4375, 0.25, 0.4375}, -- outerside1
    {-0.3125, 0.4375, -0.375, 0.3125, 0.5, -0.3125}, -- edge1
    {-0.3125, 0.4375, 0.3125, 0.3125, 0.5, 0.375}, -- edge2
    {-0.375, 0.4375, -0.3125, -0.3125, 0.5, 0.3125}, -- edge3
    {0.3125, 0.4375, -0.3125, 0.375, 0.5, 0.3125}, -- edge4
    {-0.25, -0.5, -0.25, 0.25, -0.3125, 0.25}, -- logs_fire
  }
}
local selection = {
  type = "fixed",
  fixed = {
    {-0.4375, -0.5, -0.4375, 0.4375, 0.5, 0.4375}, -- selection
  }
}

local allowed_recipes = {
  -- input item,  output item, second item, replacement, boiling time
  {"cheese:whey", "cheese:ricotta", nil ,     nil ,        15 },
}
-- the cooking recipes for these items should NOT be removed. Boiling is a separate process.

if minetest.registered_items["mobs:bucket_milk"] then
  table.insert(allowed_recipes,
    {"mobs:bucket_milk", "cheese:curd", "cheese:whey", "bucket:bucket_empty", 8 } )
end
if minetest.registered_items["petz:bucket_milk"] then
  table.insert(allowed_recipes,
    {"petz:bucket_milk", "cheese:curd", "cheese:whey", "bucket:bucket_empty", 8 } )
end
if minetest.registered_items["animalia:bucket_milk"] then
  table.insert(allowed_recipes,
    {"animalia:bucket_milk", "cheese:curd", "cheese:whey", "bucket:bucket_empty", 8 } )
end

local salt = ""
if cheese.farming then
  salt = "farming:salt"
elseif minetest.get_modpath("x_farming") then
  salt = "x_farming:salt"
elseif minetest.get_modpath("bbq") then
  salt = "bbq:sea_salt"
end
-- a way to craft pasta filata MUST be provided
if salt == "" then
  minetest.register_node("cheese:salt", {
  	description = S("Salt"),
    drawtype = "plantlike",
    tiles = {"cheese_salt.png"},
  	inventory_image = "cheese_salt.png",
  	wield_image = "cheese_salt.png",
    paramtype = "light",
    walkable = true,
    groups = {food_salt = 1, vessel = 1, dig_immediate = 3, attached_node = 1},
  	sounds = default.node_sound_glass_defaults(),
  })
  salt = "cheese:salt"
end
--[[ what if you dont have farming installed??? should i create a mortar and pestle just for this?!
if minetest.get_modpath("caverealms") then
  minetest.register_craft({
  	type = "shapeless",
  	output = salt .. " 4",
  	recipe = {"caverealms:salt_crystal", "group:food_mortar_pestle"},
  	replacements = {{"group:food_mortar_pestle", "farming:mortar_pestle"}},
  })
end ]]--
table.insert(allowed_recipes,
  {"bucket:bucket_water", salt, nil, "bucket:bucket_empty", 8 } )

if minetest.get_modpath("bucket_wooden") then
  table.insert(allowed_recipes,
  {"bucket_wooden:bucket_water", salt, nil, "bucket_wooden:bucket_empty", 8 } )

  if minetest.get_modpath("mobs_animal") then
    table.insert(allowed_recipes,
    {"mobs:wooden_bucket_milk", "cheese:curd", "cheese:whey", "bucket_wooden:bucket_empty", 8 } )
  end -- if mobs_animal is installed, it registeres another milk_bucket

end -- if wooden_bucket

local bc = "cheese:bucket_cactus"
if minetest.registered_items["ethereal:bucket_cactus"] then
  bc = "ethereal:bucket_cactus"
end
table.insert(allowed_recipes,
{bc, "cheese:desert_delicacy", nil, "bucket:bucket_empty", 22 } )

for k,v in pairs(allowed_recipes) do
  if cheese.ui then
      unified_inventory.register_craft({
        type = "cauldron_boiling",
        items = {v[1]},
        output = v[2]
      })
      if v[3] ~= nil then
        unified_inventory.register_craft({
    			type = "cauldron_boiling",
    			items = {v[1]},
    			output = v[3]
    		})
      end -- if second_item
  end -- if ui
  if cheese.i3 then
    i3.register_craft({
      type = "cauldron_boiling",
      items = {v[1]},
      result = v[2]
    })
    if v[3] ~= nil then
      i3.register_craft({
  			type = "cauldron_boiling",
  			items = {v[1]},
  			result = v[3]
  		})
    end -- if second_item
  end -- if i3
end -- for


-- boiling cauldron utility functions

local function is_milk_bucket(itemname)
  local bool = false
  if (minetest.get_item_group( itemname , "food_milk" ) > 0 and minetest.get_item_group( itemname , "food_vegan" ) == 0) then
    bool = true
  elseif string.find(itemname, "bucket") and string.find(itemname, "milk") then
    bool = true
  end
  return bool
end

local function get_boiling_results(table_src)
  --table_src has the form of {stack1,,,9}
  local output = {
    item = "",
    time = 0,
  }
  local src = ItemStack(table_src.items[1])

  local src_name = src:to_string()
  local s = string.split(src_name ," ")[1]
  if s ~= nil  then
    src_name = s
  end
  for k,v in pairs(allowed_recipes) do
    if v[1] == src_name then
      output.item = v[2]
      output.second_item = v[3]
      output.replacement = v[4]
      output.time = v[5]
      src:take_item()
    elseif is_milk_bucket(src_name) then
      output.item = "cheese:curd"
      output.second_item = "cheese:whey"
      output.replacement = "bucket:bucket_empty"
      output.time = 8
      src:take_item()
    end
  end
  return output, {items = {src}}
end

local function get_from_src_list (srcslotslist, size)
  -- src slots list has the shape of {stack1,,9}
  local ssl = srcslotslist
  local stack
  if ssl ~= nil then
    for i=1,size do
      if not ssl[i]:is_empty() then
        stack = ssl[i]
        --ssl[i]:take_item()
        -- do i care about it being the "correct" stack?
      end -- if there is stack
    end -- cycle through the inventory slots
  end -- if ssl is not null
  return stack
end

local function get_stack_count (list, size)
  -- not how many items there are, just stacks
  local count = 0
  local l = list
  --local str = "list: "
  if l ~= nil then
    for i=1,size do
      if l[i]:is_empty() == false then
        count = count + 1
        --str = str.. l[i]:to_string() ..", "
      end -- if stack is not empty
    end -- for
  end -- if l is not null
  --minetest.chat_send_all(str)
  return count
end

-- from default/furnace.lua

local function get_cauldron_active_formspec(fuel_percent, item_percent)
	return "formspec_version[5]" ..
    "size[10.5,11]" ..
    "list[context;src_slots;0.5,0.5;3,4]" ..
    "list[context;src;4.7,1.3;1,1]" ..
    "list[context;fuel;4.7,3.5;1,1]" ..
    "image[4.7,2.4;1,1;default_furnace_fire_bg.png^[lowpart:" ..
    (fuel_percent)..":default_furnace_fire_fg.png]"..
    "image[6.2,2.4;1,1;gui_furnace_arrow_bg.png^[lowpart:" ..
    (item_percent)..":gui_furnace_arrow_fg.png^[transformR270]"..
    "list[context;dst;7.7,0.5;2,4]" ..
    "list[current_player;main;0.4,5.75;8,1]" ..
    "list[current_player;main;0.4,7;8,3;8]" ..
    "listring[context;dst]" ..
    "listring[current_player;main]" ..
    "listring[context;src]" ..
    "listring[current_player;main]" ..
    "listring[context;src_slots]" ..
    "listring[current_player;main]" ..
    "listring[context;fuel]" ..
    "listring[current_player;main]" ..
		default.get_hotbar_bg(0, 4.25)
end

local function get_cauldron_inactive_formspec()
	return "formspec_version[5]" ..
    "size[10.5,11]" ..
    "list[context;src_slots;0.5,0.5;3,4]" ..
    "list[context;src;4.7,1.3;1,1]" ..
    "list[context;fuel;4.7,3.5;1,1]" ..
    "image[4.7,2.4;1,1;default_furnace_fire_bg.png]" ..
    "image[6.2,2.4;1,1;gui_furnace_arrow_bg.png^[transformR270]" ..
    "list[context;dst;7.7,0.5;2,4]" ..
    "list[current_player;main;0.4,5.75;8,1]" ..
    "list[current_player;main;0.4,7;8,3;8]" ..
    "listring[context;dst]" ..
    "listring[current_player;main]" ..
    "listring[context;src]" ..
    "listring[current_player;main]" ..
    "listring[context;src_slots]" ..
    "listring[current_player;main]" ..
    "listring[context;fuel]" ..
    "listring[current_player;main]" ..
		default.get_hotbar_bg(0, 4.25)
end

--
-- Node callback functions that are the same for active and inactive furnace
--

local function can_dig(pos, player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("fuel") and inv:is_empty("dst") and
         inv:is_empty("src") and inv:is_empty("src_slots")
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if listname == "fuel" then
		if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
			if inv:is_empty("src") then
				meta:set_string("infotext", S("Cauldron is empty"))
			end
      return stack:get_count()
    else
      return 0
		end
	elseif listname == "src" then
		return stack:get_count()
	elseif listname == "src_slots" then
		return stack:get_count()
	elseif listname == "dst" then
		return 0
	end
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name or node.name == "ignore" then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end

local function cauldron_node_timer(pos, elapsed)
	--
	-- Initialize metadata
	--
	local meta = minetest.get_meta(pos)
	local fuel_time = meta:get_float("fuel_time") or 0
	local src_time = meta:get_float("src_time") or 0
	local fuel_totaltime = meta:get_float("fuel_totaltime") or 0

	local inv = meta:get_inventory()
	local srclist, fuellist, dstlist
  local srcslotslist, src_slot_size --------------------------------------------
  local dst_full = false

	local timer_elapsed = meta:get_int("timer_elapsed") or 0
	meta:set_int("timer_elapsed", timer_elapsed + 1)

	local cookable, cooked
	local fuel

	local update = true
	while elapsed > 0 and update do
		update = false

		srclist = inv:get_list("src")
		fuellist = inv:get_list("fuel")
    srcslotslist = inv:get_list("src_slots") -----------------------------------
    src_slot_size = inv:get_size("src_slots")

    dstlist = inv:get_list("dst") ----------------------------------------------
    dstsize = inv:get_size("dst")
    if get_stack_count(dstlist, dstsize) == dstsize then
      dst_full = true
    end
    -- dst_full checks # of stacks, this one make it work even when dst is full,
    -- yet there is indeed room for just the cooked item (its stack isnt full)
    -- otherwise the cauldron gets stuck with 1 src item and using all fuel.
    -- if dst gets full due to normal boiling, it stops. it should be like this.
    local still_room_for_cooked_item = false

		--
		-- Cooking
		--

		-- Check if we have cookable content
		local aftercooked
		--cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		cooked, aftercooked = get_boiling_results( {items = srclist} )
    -- cooked is the output table with item, second_item, time, replacement
    -- aftercooked is the scrlist with itemstack[1].take_item()
		cookable = cooked.time ~= 0

		local el = math.min(elapsed, fuel_totaltime - fuel_time)
		if cookable then -- fuel lasts long enough, adjust el to cooking duration
			el = math.min(el, cooked.time - src_time)
      still_room_for_cooked_item = inv:room_for_item("dst", cooked.item)
		end
    --minetest.chat_send_all("still room = ".. tostring()still_room_for_cooked_item))

		-- Check if we have enough fuel to burn
		if fuel_time < fuel_totaltime then
			-- The furnace is currently active and has enough fuel
			fuel_time = fuel_time + el
			-- If there is a cookable item then check if it is ready yet
			if cookable then
				src_time = src_time + el
				if src_time >= cooked.time then
					-- Place result in dst list if possible
					if still_room_for_cooked_item then
            local leftover = inv:add_item("dst", cooked.item)
            local above = vector.new(pos.x, pos.y + 1, pos.z)
            local drop_pos = minetest.find_node_near(above, 1, {"air"}) or above

            if not leftover:is_empty() then
              minetest.item_drop(cooked.item, nil, drop_pos)
              still_room_for_cooked_item = false
            end -- if leftover of item is not empty

            if cooked.second_item ~= nil and inv:room_for_item("dst", cooked.second_item) then
              leftover = inv:add_item("dst", cooked.second_item)
              if not leftover:is_empty() then
                dst_full = true
                still_room_for_cooked_item = false
                minetest.item_drop(cooked.second_item, nil, drop_pos)
              end -- if leftover of second item is not empty

            end -- if there is a second item and there is room for it

            if cooked.replacement ~= nil and inv:room_for_item("dst", cooked.replacement) then
              leftover = inv:add_item("dst", cooked.replacement)
              if not leftover:is_empty() then
                dst_full = true
                still_room_for_cooked_item = false
                minetest.item_drop(cooked.replacement, nil, drop_pos)
              end -- if leftover of replacement is not empty

            end -- if there is a replacement and there is room for it

            inv:set_stack("src", 1, aftercooked.items[1] )
            src_time = src_time - cooked.time

            -- if src is now empty, try to take another item from src_slots ----
            if inv:is_empty("src") and inv:is_empty("src_slots") == false then
              if srcslotslist ~= nil then
                local new_src = get_from_src_list(srcslotslist, src_slot_size)
                if new_src ~= nil then
                  inv:remove_item("src_slots", new_src)
                  --inv:set_list("src_slots", ssl)
                  inv:set_stack("src", 1, new_src)
                end
              end
            end

						update = true
					else
						dst_full = true
					end
					-- Play cooling sound
					minetest.sound_play("default_cool_lava",
						{pos = pos, max_hear_distance = 16, gain = 0.1}, true)
				else
					-- Item could not be cooked: probably missing fuel
					update = true
				end
			end
		else
			-- Furnace ran out of fuel
			if cookable and still_room_for_cooked_item then --------------------------
				-- We need to get new fuel
				local afterfuel
				fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})

				if fuel.time == 0 then
					-- No valid fuel in fuel list
					fuel_totaltime = 0
					src_time = 0
				else
					-- Take fuel from fuel list
					inv:set_stack("fuel", 1, afterfuel.items[1])
					-- Put replacements in dst list or drop them on the furnace.
					local replacements = fuel.replacements
					if replacements[1] then
						local leftover = inv:add_item("dst", replacements[1])
						if not leftover:is_empty() then
							local above = vector.new(pos.x, pos.y + 1, pos.z)
							local drop_pos = minetest.find_node_near(above, 1, {"air"}) or above
							minetest.item_drop(replacements[1], nil, drop_pos)
						end
					end
					update = true
					fuel_totaltime = fuel.time + (fuel_totaltime - fuel_time)
				end
			else
				-- We don't need to get new fuel since there is no cookable item
				fuel_totaltime = 0
				src_time = 0
			end
			fuel_time = 0
		end

		elapsed = elapsed - el
	end

	if fuel and fuel_totaltime > fuel.time then
		fuel_totaltime = fuel.time
	end
	if srclist and srclist[1]:is_empty() then
		src_time = 0
	end

	--
	-- Update formspec, infotext and node
	--
	local formspec
	local item_state
	local item_percent = 0
	if cookable then
		item_percent = math.floor(src_time / cooked.time * 100)
		if dst_full or still_room_for_cooked_item == false then --------------------
			item_state = S("100% (output full)")
		else
			item_state = S("@1%", item_percent)
		end
	else
		if srclist and not srclist[1]:is_empty() then
			item_state = S("Cannot be boiled")
		else
			item_state = S("Empty")
		end
	end
  --[-[
  local remaining_inputs = get_stack_count(srcslotslist, src_slot_size) --------
  local slot_state
  if srcslotslist and remaining_inputs > 0 then
    slot_state = remaining_inputs .. S(" Stacks in Input Slots")
  else
    slot_state = S("Input Slot Empty")
  end
  --]]--

	local fuel_state = S("No Fuel")
	local active = false
	local result = false

	if fuel_totaltime ~= 0 and dst_full == false then ---------- dst_full == false
		active = true
		local fuel_percent = 100 - math.floor(fuel_time / fuel_totaltime * 100)
		fuel_state = S("@1%", fuel_percent)
		formspec = get_cauldron_active_formspec(fuel_percent, item_percent)
		swap_node(pos, "cheese:milk_cauldron_active")
		-- make sure timer restarts automatically
		result = true

		-- Play sound every 9 seconds while the furnace is active
		if timer_elapsed == 0 or (timer_elapsed+1) % 9 == 0 then
			minetest.sound_play("cooking_without_cover_01",
				{pos = pos, max_hear_distance = 16, gain = 0.5}, true)
		end
	else
		if fuellist and not fuellist[1]:is_empty() then
			fuel_state = S("@1%", 0)
		end
		formspec = get_cauldron_inactive_formspec()
		swap_node(pos, "cheese:milk_cauldron")
		-- stop timer on the inactive furnace
		minetest.get_node_timer(pos):stop()
		meta:set_int("timer_elapsed", 0)
	end


	local infotext
	if active then
		infotext = S("Cauldron boiling")
	else
		infotext = S("Cauldron inactive")
	end
	infotext = infotext .. "\n" .. S("(Item: @1; Fuel: @2)", item_state, fuel_state)
             .. "\n(" .. slot_state .. ")" -------------------------------------

	--
	-- Set meta values
	--
	meta:set_float("fuel_totaltime", fuel_totaltime)
	meta:set_float("fuel_time", fuel_time)
	meta:set_float("src_time", src_time)
  meta:set_int("remaining_inputs", remaining_inputs) ---------------------------
	meta:set_string("formspec", formspec)
	meta:set_string("infotext", infotext)

	return result
end

--
-- Node definitions
--

minetest.register_node("cheese:milk_cauldron", {
	description = S("Milk Cauldron"),
  drawtype = "nodebox",
  --mesh = "kettle_idle.obj",
  tiles = {
    "milk_cauldron_top.png",
    "milk_cauldron_top.png",
    "milk_cauldron_side.png",
    "milk_cauldron_side.png",
    "milk_cauldron_side.png",
    "milk_cauldron_side.png",
  },
  node_box = inactive_nodebox,
  selection_box = selection,
  collision_box = selection,
  paramtype = "light",
	----paramtype2 = "facedir",
	groups = { cracky = 2, },
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),

	can_dig = can_dig,

	on_timer = cauldron_node_timer,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size('src', 1)
    inv:set_size('src_slots', 12) -----------------------------------------------
		inv:set_size('fuel', 1)
		inv:set_size('dst', 8)
		cauldron_node_timer(pos, 0)
	end,

	on_metadata_inventory_move = function(pos)
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_metadata_inventory_put = function(pos)
		-- start timer function, it will sort out whether furnace can burn or not.
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_metadata_inventory_take = function(pos)
		-- check whether the furnace is empty or not.
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_blast = function(pos)
		local drops = {}
    default.get_inventory_drops(pos, "src_slots", drops) -----------------------
		default.get_inventory_drops(pos, "src", drops)
		default.get_inventory_drops(pos, "fuel", drops)
		default.get_inventory_drops(pos, "dst", drops)
		drops[#drops+1] = "cheese:milk_cauldron"
		minetest.remove_node(pos)
		return drops
	end,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_node("cheese:milk_cauldron_active", {
	description = S("Milk Cauldron"),
  drawtype = "nodebox",
  --mesh = "kettle_inuse.obj",
	tiles = {
    {
      image = "milk_cauldron_active_top.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 2.5
			},
    },
    "milk_cauldron_top.png",
    "milk_cauldron_active_side.png",
    "milk_cauldron_active_side.png",
    "milk_cauldron_active_side.png",
    "milk_cauldron_active_side.png",
	},
	node_box = active_nodebox,
  selection_box = selection,
  collision_box = selection,
  paramtype = "light",
	--paramtype2 = "facedir",
	light_source = 8,
	drop = "cheese:milk_cauldron",
	groups = {cracky=2, not_in_creative_inventory=1},
	is_ground_content = false,
	sounds = default.node_sound_metal_defaults(),
	on_timer = cauldron_node_timer,

	can_dig = can_dig,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_craft({
  output = "cheese:milk_cauldron",
  recipe = {
    {"default:copper_ingot", "", "default:copper_ingot"},
    {"default:copper_ingot", "", "default:copper_ingot"},
    {"default:copper_ingot", "default:copper_ingot", "default:copper_ingot"},
  }
})

if minetest.get_modpath("hopper") then
  hopper:add_container({
  	{"top", "cheese:milk_cauldron", "dst"}, -- take cooked items from above into hopper below
  	{"bottom", "cheese:milk_cauldron", "src"}, -- insert items below to be cooked from hopper above
  	{"side", "cheese:milk_cauldron", "fuel"}, -- replenish furnace fuel from hopper at side
  	{"top", "cheese:milk_cauldron_active", "dst"},
  	{"bottom", "cheese:milk_cauldron_active", "src"},
  	{"side", "cheese:milk_cauldron_active", "fuel"},
  })
end
