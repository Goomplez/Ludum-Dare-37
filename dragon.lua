local images = require("images")
local sounds = require("sounds")
local flux   = require("flux")
require("utils")

function spawn_dragon()
	local dragon = {
		-- Renderable
		x = 0,
		y = 50,
		scale = {
			x = 2.0,
			y = 2.0
		},
		rotation = 0,
		image = images["dragon1.png"],
		offset = {
			x = 96 / 2,
			y = 64 / 2,
		},
		xStart = 50,
		xEnd = 900,
		xspeed = 140,

		-- Bounding
		w = 0,
		h = 0,

		-- Flags for collections
		rm_render = false,
		rm_update = false,
		rm_enemy = false,

		-- Custom player information
		speed = 200,
		shot_time = .2,
		shot_timer = 0,

		fly_timer = 0,
		can_shoot = false,

		r = 40,
		-- HP, to be used by player_health
		HP = 50,
		hit_timer = 2.1,
		hit_delay = 2,
	}

	function dragon.is_vulnerable(self)
		return self.hit_timer > self.hit_delay
	end

	function dragon.harm (self, damage)
		self.HP = self.HP - 1
		self.HP = math.clamp(0, self.HP, 50)
		self.hit_timer = 0
		sounds["hurt1.wav"]:play()
	end

	function dragon.update(self, dt)
		get_boss_attack(dt)
		self.fly_timer = self.fly_timer + dt
		if self.fly_timer > 2.2 then
			self.fly_timer = 0
		elseif self.fly_timer > 2 then
			self.image = images["dragon1.png"]
		elseif self.fly_timer > 1.5 then
			self.image = images["dragon3.png"]
		elseif self.fly_timer > 1 then
			self.image = images["dragon2.png"]
		elseif self.fly_timer > .5 then
			self.image = images["dragon1.png"]
		end

		self.x = self.x + (self.xspeed * dt)
		self.x = math.clamp(self.xStart, self.x, self.xEnd)
		if self.x == self.xStart then
			self.xspeed = math.copysign(self.xspeed, 1)
		end
		if self.x == self.xEnd then
			self.xspeed = math.copysign(self.xspeed, -1)
		end

		if self.xspeed > 0 then
			self.scale.x = math.copysign(self.scale.x, -1)
		else
			self.scale.x = math.copysign(self.scale.x, 1)
		end
		if self.hit_timer < self.hit_delay then
			self.hit_timer = self.hit_timer + dt
		end
		if self.HP == 0 then
			self.rm_enemy = true
			self.rm_update = true
			self.rm_render = true
		end
	end
	return dragon
end
