-- Zombie logic
local images = require("images")
local sounds = require("sounds")
local player = require("player")

local function harm_z(self)
	if self.hurt_timer >= self.hurt_time then
		self.HP = self.HP - 1
		self.hurt_timer = 0
		if self.HP == 0 then
			self.hurt_timer = self.hurt_time + 0.001	
			self.rm_render = true
			self.rm_update = true
			self.rm_enemy = true
		end
	end
end
-- Update fuction for zombie
local function update_z(self, dt)
	local angle = math.angle(self.x, self.y, player.x, player.y)
	local oldX = self.x
	self.x, self.y = offsetByVector({x = self.x, y = self.y}, angle, self.speed * dt)
	if (oldX - self.x) > 0 then
		self.scale.x = math.copysign(self.scale.x, 1)
	else 
		self.scale.x = math.copysign(self.scale.x, -1)
	end
	if self.hurt_timer < self.hurt_time then
		self.hurt_timer = self.hurt_timer + dt
		if self.hurt_timer >= self.hurt_time then
			self.rm_render = false
			addRenderable(self)
		else
			self.rm_render = true
		end
	end
end

function spawn_zombie(x, y, dir)
	-- body
	local zzombie = {
		-- Renderable
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
		-- Enemy
		r = 20,
		speed = 128,
		-- Update
		update = update_z,
		-- Zombie
		HP = 10,
		hurt_time = .1,
		hurt_timer = .11,
		harm = harm_z,

		-- Collection flags
		rm_render = false,
		rm_update = false,
		rm_enemy = false,
	}
	return zzombie
end