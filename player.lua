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
end

-- Renderable, Updatable player
return {
	x = 0,
	y = 0,
	scale = 2.0,
	rotation = 0,
	speed = 200,
	update = player_update
}