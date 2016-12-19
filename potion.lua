-- Potion logic
local images = require("images")
local sounds = require("sounds")
local player = require("player")

-- Pickup function for potion
local function pickup(self)
	if self.HP == 0 then
		sounds["pickup.wav"]:stop()
		sounds["pickup.wav"]:play()
		player:harm(-1)
		self.rm_render = true
		self.rm_update = true
		self.rm_enemy = true
	end
end

-- Update fuction for potion
local function update_p(self, dt)
	--[[ local angle = math.angle(self.x, self.y, player.x, player.y)
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
	--]]
end

-- Spawn potion function
function spawn_potion(x, y)
	local ppotion = {
		-- Renderable
		x = x,
		y = y,
		image = images["red-potion.png"],
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
		update = update_p,
		-- Potion
		HP = 5,
		hurt_time = .1,
		hurt_timer = .11,
		harm = pickup,

		-- Collection flags
		rm_render = false,
		rm_update = false,
		rm_enemy = false,
	}
	return ppotion
end