-- moobloom support

-- the code is exaclty the same, except for the given item

minetest.registered_entities["flower_cow:flower_cow"].on_rightclick = function(self, clicker)

	-- feed or tame
	if mobs:feed_tame(self, clicker, 8, true, true) then

		-- if fed 7x wheat or grass then cow can be milked again
		if self.food and self.food > 6 then
			self.gotten = false
		end

		return
	end

	if mobs:protect(self, clicker) then return end
	if mobs:capture_mob(self, clicker, 0, 5, 60, false, nil) then return end

	local tool = clicker:get_wielded_item()
	local name = clicker:get_player_name()

	-- milk cow with empty bucket
	if tool:get_name() == "bucket:bucket_empty" then

		--if self.gotten == true
		if self.child == true then
			return
		end

		if self.gotten == true then
			minetest.chat_send_player(name,
				"Flower cow already milked!")
			return
		end

		local inv = clicker:get_inventory()

		tool:take_item()
		clicker:set_wielded_item(tool)

		if inv:room_for_item("main", {name = "cheese:bucket_blooming_essence"}) then
			clicker:get_inventory():add_item("main", "cheese:bucket_blooming_essence") -- instead of mobs:bucket_milk , something more appropriate
		else
			local pos = self.object:get_pos()
			pos.y = pos.y + 0.5
			minetest.add_item(pos, {name = "cheese:bucket_blooming_essence"})
		end

		self.gotten = true -- milked

		return
	end
end

minetest.register_craftitem("cheese:bucket_blooming_essence", {
	description = "Bucket of Blooming Essence",
	inventory_image = "bucket_blooming_essence.png",
	on_use = minetest.item_eat(4, "bucket:bucket_empty"),
	groups = {food = 4},
})