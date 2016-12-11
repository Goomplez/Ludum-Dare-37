local sp = {}

-- Valid angles are "Up", "Down", "Right", "Left"
function sp.update(self, dt) 
	self.x, self.y = offsetByVector(self, self.rotation + (math.pi), dt * self.velocity)


	if self.x < -10 or self.y < -10 or self.y > g_height or self.x > g_height then
		rm_render = true
		rm_update = true
	end
end

function offsetByVector (point, angle, length)
	local x = math.cos(angle) * length
	local y = math.sin(angle) * length
	return point.x + x, point.y + y
end

function dirToAngle(dir) 
	if dir == "up" then
		return - 3 * math.pi / 2
	elseif dir == "down" then
		return - math.pi / 2
	elseif dir == "right" then
		return math.pi
	elseif dir == "left" then
		return 0
	end
end

function spawn_spell(x, y, direction)
	-- Renderable, updateable, colliable
	return {
		x = x,
		y = y,
		image = images["iceball.png"],
		velocity = 300,
		rotation = dirToAngle(direction),
		update = sp.update,
		scale = 2.0,
		offset = {
			x = 5,
			y = 4,
		},
		rm_render = false,
		rm_update = false,
		rm_collide = false,
	}
end