-- Potion logic
local images = require("images")
local sounds = require("sounds")
local player = require("player")

-- Pickup function for potion
local function pickup(self)
	-- if self.HP == 0 then
		player:heal(2)
		self.rm_render = true
		self.rm_update = true
		self.rm_other_spell = true
	-- end
end

-- Update fuction for potion
local function update_p(self, dt)
	self.bob_timer = self.bob_timer + math.copysign(dt, self.bob_dir)
	if math.abs(self.bob_timer) > self.bob_time then
		self.bob_dir = -1 * self.bob_dir
	end
	self.y = self.yBase + self.bob_timer * 3
end

-- Spawn potion function
function spawn_potion(x, y)
	local potion = {
		-- Renderable
		x = x,
		y = y,
		xBase = x,
		yBase = y,


		image = images["red-potion.png"],
		scale = {
			x = 2.0,
			y = 2.0,
		},
		offset = {
			x = 10,
			y = 10,
		},
		rotation = 0,
		-- Hit radius
		r = 30,
		-- Update
		update = update_p,

		-- Potion
		bob_time = .5,
		bob_timer = 0,
		bob_dir = 1,
		collide = pickup,

		-- Collection flags
		rm_render = false,
		rm_update = false,
		rm_other_spell = false,
	}
	return potion
end
