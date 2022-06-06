--awards compatibility
local S = cheese.S

awards.register_award("cheese:eat_it", {
	title = S("Cheese!"),
	icon = "cheese_award_eat_it.png",
	description = S("Eat a piece of cheese."),
	trigger = {
		type = "eat",
		item = "group:food_cheese",
		target = 1
	}
})

awards.register_award("cheese:make_mouse_jealous", {
	title = S("To make a mouse jealous."),
	icon = "cheese_award_make_mouse_jealous.png",
	description = S("Eat 50 pieces of cheese."),
	trigger = {
		type = "eat",
		item = "group:food_cheese",
		target = 50
	}
})

awards.register_award("cheese:eat_it_fantasy", {
	title = S("How? Why? Who cares!\nMore Cheese!"),
	icon = "cheese_award_eat_it_fantasy.png",
	description = S("Eat a piece of special cheese."),
	trigger = {
		type = "eat",
		item = "group:food_fantasy_cheese",
		target = 1
	}
})


awards.register_award("cheese:milky_way", {
	title = S("The Milky Way."),
	icon = "cheese_award_milky_way.png",
	description = S("Place a Copper Cauldron. You can use it to boil milk."),
	trigger = {
		type   = "place",
		node   = "cheese:milk_cauldron",
		target = 1,
	}
})

awards.register_award("cheese:ready_set_cheese", {
	title = S("Ready. Set. Cheese!"),
	icon = "cheese_award_ready_set_cheese.png",
	description = S("Place a Cheese Aging Rack."),
	trigger = {
		type   = "place",
		node   = "group:cheese_rack",
		target = 1,
	}
})

awards.register_award("cheese:cream_sweet_cream", {
	title = S("Cream, Sweet Cream!"),
	icon = "cheese_award_cream_sweet_cream.png",
	description = S("Place a Cream Separator."),
	trigger = {
		type   = "place",
		node   = "cheese:cream_separator",
		target = 1,
	}
})

awards.register_award("cheese:golden_butter", {
	title = S("Golden Butter."),
	icon = "cheese_award_golden_butter.png",
	description = S("Place a Churn."),
	trigger = {
		type   = "place",
		node   = "cheese:churn",
		target = 1,
	}
})

awards.register_award("cheese:tomato_and_dough", {
	title = S("Almost a pizza."),
	icon = "cheese_award_tomato_and_dough.png",
	description = S("Craft Stretched Cheese, then shape it to get Mozzarella. If only you had tomato sauce and dough ..."),
	trigger = {
		type = "craft",
		item = "cheese:mozzarella",
		target = 1
	}
})

awards.register_award("cheese:hang_this", {
	title = S("I need to hang this?!"),
	icon = "cheese_award_hang_this.png",
	description = S("Craft Stretched Cheese, then shape it to get a Caciocavallo and let it age, by hanging it at the ceiling."),
	trigger = {
		type = "place",
		node = "cheese:fresh_caciocavallo",
		target = 1
	}
})
