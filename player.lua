function player_update(self, dt)
	key = love.keyboard
	if key.isDown("w") then
		self.y = self.y - self.speed * dt
	end
	if key.isDown("s") then
		self.y = self.y + self.speed * dt
	end
	if key.isDown("d") then
		self.x = self.x + self.speed * dt
	end
	if key.isDown("a") then
		self.x = self.x - self.speed * dt
	end

	local xbounds = self.bounds.x
	local ybounds = self.bounds.y
	local w = self.w * 2
	local h = self.h * 2
	if (self.x) < xbounds.min then
		self.x = xbounds.min
	end
	if (self.y + (5 * (w / 4))) < ybounds.min then
		self.y = ybounds.min - (5 *(w / 4))
	end

	if (self.x + w) > xbounds.max then
		self.x = xbounds.max - w
	end
	if (self.y + h) > ybounds.max then
		self.y = ybounds.max - h
	end
end

-- Renderable, Updatable player
return {
	x = 0,
	y = 0,
	w = 0,
	h = 0,
	scaled = function (self, name)
		return self[name] * self.scale 
	end,
	scale = 2.0,
	rotation = 0,
	speed = 200,
	bounds = {
		x = { min = 0, max = g_width },
		y = { min = 0, max = g_height },
	},
	update = player_update
}