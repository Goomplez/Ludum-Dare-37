local player = require("player")
local images = require("images")

-- This brings in getTableBounds()
require("tablebackground")

-- Because this is local, it won't be visible outside this file
local hp_images = {
	[0] = images["hp0.png"],
	images["hp25.png"],
	images["hp50.png"],
	images["hp75.png"],
	images["hp100.png"],
}

-- getTableBounds is in global scope becaue tablebackground was require
local bounds = getTableBounds()

local HP_bar = {
	-- Start of things this table needs to be rendered
	x = 0,  
	y = bounds.y.max + 32 * 3,
	scale = {
		x = 2.0,
		y = 2.0
	},
	offset = {x = 0, y = 0},
	rotation = 0,
	image = hp_images[player.HP],

	-- If this needs to be removed from the list of rendered things, HP_bar.update should set rm_render to true
	rm_render = false,
	-- End of things the object needs to be rendered

	-- The flag for if this should be removed from the list of updatable things
	rm_update = false,
}

-- This adds the update function to the HP_bar table. The update function needs to be there for it to be updateable.
function HP_bar.update(self, dt)
	self.image = hp_images[player.HP]
end

-- Becaue we didn't make this function local, anywhere file that does require("player_health") will be able to see it.
function load_hp_bar()
	addRenderable(HP_bar)
	addUpdateable(HP_bar)
end