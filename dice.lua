-- Dice
images = require("images")

local dice_images = {
	images["die-bomb.png"],
	images["die-dragon.png"],
	images["die-fireball.png"],
	images["die-goblin.png"],
	images["die-skeleton.png"],
	images["die-zombie.png"],
}

local function update(self, dt)
	
end

function spawn_die(x, y, state)
	local d6 = {
		x = x,
		y = y,
		image = images["zombie-invert.png"],
		scale = {
			x = 2.0,
			y = 2.0,
		},
		offset = {
			x = 10,
			y = 10, 
		},
		rotation = dirToAngle(dir),
		-- Update
		update = update,

		-- Die
		roll_timer = 0,
		roll_time = 2,

		-- Collection flags
		rm_render = false,
		rm_update = false,
		rm_enemy = false,
	}
end

-- return 