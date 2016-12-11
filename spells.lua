-- local sp = {}

-- Valid angles are "Up", "Down", "Right", "Left"
local function update(self, dt) 
	self.x, self.y = offsetByVector(self, self.rotation + (math.pi), dt * self.velocity)


	if self.x < -10 or self.y < -10 or self.y > g_height or self.x > g_height then
		rm_render = true
		rm_update = true
	end
end

local function collides(self, shape)

end

function spawn_spell(x, y, direction)
	-- Renderable, updateable, colliable
	return {
		-- Renderable
		x = x,
		y = y,
		image = images["iceball.png"],
		rotation = dirToAngle(direction),
		scale = { x =2.0, y = 2.0, },
		offset = {
			x = 5,
			y = 4,
		},

		-- Updateable
		velocity = 300,
		update = update,

		-- Removal flags
		rm_render = false,
		rm_update = false,
		rm_collide = false,
	}
end