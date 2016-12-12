local player = require("player")
local images = require("images")

local hp_images = {
	[0] = images["hp0.png"],
	images["hp25.png"],
	images["hp50.png"],
	images["hp75.png"],
	images["hp100.png"],
}
-- 
local function update(self, dt)
	self.image = hp_images[player.HP]
end

local bounds = getTableBounds()

x, y = 0, bounds.y.max + 32 * 3

local HP_bar = {
	x = x,
	y = y,
	scale = {
		x = 2.0,
		y = 2.0
	},
	offset = {x = 0, y = 0},
	rotation = 0,
	image = hp_images[player.HP],

	update = update,
	rm_update = false,
	rm_render = false,
}

function load_hp_bar()
	addRenderable(HP_bar)
	addUpdateable(HP_bar)
end