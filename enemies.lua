-- Enemies
local images = require("images")
local sounds = require("sounds")


function spawn_skelton(x, y, dir)
	return {
		x = x,
		y = y,
		image = images["skelton.png"],
		scale = 2.0,
		rotation = dirToAngle(dir),
	}
end