local images = require("images")
local sounds = require("sounds")
local player = require("player")
local derpball = require("derpball")
local function update(self, dt)
	self.x, self.y = offsetByVector(self, self.rotation + (math.pi), dt * self.velocity)
	if self.x < -10 or self.y < -10 or self.y > g_height or self.x > g_height then
		self.rm_render = true
		self.rm_update = true
		self.rm_player_spell = true
		self.rm_enemy = true
	end
end

function spawn_fireball(x, y, direction)
	if love.math.random(10) < 3 then
		return spawn_derpball(x, y)
	end
	-- body
	-- Renderable, updateable, colliable
	return {
		-- Renderable
		x = x,
		y = y,
		r = 5,
		image = images["fireball.png"],
		rotation = dirToAngle(direction) - (math.pi * 3 / 32) + (math.random(5) * math.pi / 32),
		scale = { x = 2.0, y = 2.0, },
		offset = {
			x = 5,
			y = 4,
		},

		-- Updateable
		velocity = 150,
		update = update,
		-- Can't kill a fireball
		collide = function (self)
			if not self.other_spell then
				player:harm(1)
			end
			self.rm_update = true
			self.rm_render = true
			self.rm_other_spell = true
		end,

		-- Removal flags
		rm_render = false,
		rm_update = false,
		rm_other_spell = false,
	}
end

local function update_shot(self, dt)
	self.x, self.y = offsetByVector(self, self.rotation + (math.pi / 2), dt * self.velocity)
	if self.x < -10 or self.y < -10 or self.y > g_height or self.x > g_height then
		self.rm_render = true
		self.rm_update = true
		self.rm_player_spell = true
		self.rm_enemy = true
	end
	self.toggle_timer = self.toggle_timer + dt
	if self.toggle_timer > self.toggle_time then
		self.toggle_timer = 0
		self.image = images["lightning1.png"]
	elseif self.toggle_timer > (self.toggle_time / 2) then
		self.image = images["lightning2.png"]
	end
end

function spawn_spell(x, y, direction)
	-- Renderable, updateable, colliable
	return {
		-- Renderable
		x = x,
		y = y,
		r = 5,
		image = images["lightning1.png"],
		rotation = dirToAngle(direction) + (math.pi / 2) - (math.pi * 3 / 64) + ( math.random(5) * math.pi / 64),
		scale = { x =2.0, y = 2.0, },
		offset = {
			x = 5,
			y = 4,
		},

		-- Updateable
		velocity = 300,
		update = update_shot,

		toggle_time = .2,
		toggle_timer = 0,

		-- Removal flags
		rm_render = false,
		rm_update = false,
		rm_player_spell = false,
	}
end
