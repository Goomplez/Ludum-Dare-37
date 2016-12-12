-- Skeleton
local images = require("images")
local sounds = require("sounds")
require("enemies")

local function harm_skeleton(self, amount)
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

local function update_skeleton(self, dt)
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

function spawn_skeleton(x, y, dir)

	local skel = {
		-- Renderable
		x = x,
		y = y,
		image = images["skeleton.png"],
		scale = {
			x = 2.0,
			y = 2.0,
		},
		offset = {
			x = 7,
			y = 10, 
		},
		r = 10,
		rotation = dirToAngle(dir),
		tween_chain = { idx= 1, next_path, switch_xy },

		-- Collideable
		collides = collides,
		-- Update
		update = update_skeleton,
		-- Skeleton AI info
		path = get_random_path({x = x, y = y} , getTableBounds()),
		traveling_on = "",
		travel_timer = 0,
		prev_x  = x,
		prev_y = y,

		-- Harming
		harm = harm_skeleton,
		-- HP
		HP = 3,
		hurt_time = .1,
		hurt_timer = .11,

		-- Used for the tweening function to call per frame
		next_path = next_path,
		switch_xy = switch_xy,
		rm_update = false,
		rm_render = false,
		rm_enemy  = false,
	}
	skel:next_path()
	return skel
end