local images = require("images")
local sounds = require("sounds")


local function update_dragon(self, dt)


end

return {
	-- Renderable
	x = 0,
	y = 5,
	scale = {
		x = 2.0,
		y = 2.0
	},
	rotation = 0,
	image = images["dragon1.png"],
	offset = {
		x = 10,
		y = 10,
	},
	xStart = 50,
	xEnd = 

	-- Bounding
	w = 0,
	h = 0,

	-- Flags for collections
	rm_render = false,
	rm_update = false,

	-- Updatable
	update = player_update,

	-- Custom player information
	speed = 200,
	shot_time = .2,
	shot_timer = 0,
	spell_offset = { x = 20, y = 20 },
	can_shoot = false,
	scaled = function (self, name)
		return self[name] * self.scale 
	end,
	-- HP, to be used by player_health
	HP = 4,
	hit_timer = 2.1,
	hit_delay = 2,
	is_vulnerable = function (self)
		return self.hit_timer > self.hit_delay
	end,
	harm = function (self, damage)
		self.HP = self.HP - 1
		self.HP = math.clamp(0, self.HP, 4)
		self.hit_timer = 0
		sounds["hurt2.wav"]:play()
	end
}