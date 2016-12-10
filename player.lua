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
	local halfw = self.w 
	local halfh = self.h
	if (self.x + halfw) < xbounds.min then
		self.x = xbounds.min - halfw
	end
	if (self.y + halfh) < ybounds.min then
		self.y = ybounds.min - halfh
	end

	if (self.x + halfw) > xbounds.max then
		self.x = xbounds.max - halfw
	end
	if (self.y + halfh) > ybounds.max then
		self.y = ybounds.max - halfh
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