-- Skeleton
local images = require("images")
local sounds = require("sounds")
local flux = require("flux")

local function next_path(self)
	-- Current x and y are set up already
	self.path.selectedIdx = self.path.selectedIdx + 1
	if self.path.selectedIdx > #self.path then
		self.path.selectedIdx = 1
	end
	local dest_pair = self.path:current()
	local dest = {}
	local dimension = ""
	if self.traveling_on then
		self.traveling_on = ({"x", "y"})[math.random(2)]
		dimension = self.traveling_on
		dest[dimension] = dest_pair[dimension]
	else
		dest.x = dest_pair.x
		dest.y = dest_pair.y
	end
	if dest.x then
		self.scale.x = math.copysign(self.scale.x, self.x - dest.x)
	end

	self.tween = flux.to(self,
		math.abs(dest_pair[dimension] - self[dimension]) / (100 * love.math.random(3))
		, dest)
	self.tween:ease("linear")
	self.tween:oncomplete(function()
		if self.traveling_on then
			self:switch_xy()
		else
			self:next_path()
		end
	end)
end

local function switch_xy(self)
	local dest_pair = self.path:current()
	if self.traveling_on == "x" then
		self.traveling_on = "y"
	else
		self.traveling_on = "x"
	end
	local dimension = self.traveling_on
	-- Only ever set the x or y value
	local dest = {}
	dest[dimension] = dest_pair[dimension]
	-- Handle the direction the skeleton is facing
	if dest.x then
		self.scale.x = math.copysign(self.scale.x, self.x - dest.x)
	end
	self.tween = flux.to(self, math.abs(dest_pair[dimension] - self[dimension]) / 200 , dest)
	self.tween:ease("linear")
	self.tween:oncomplete(function()
		self:next_path()
	end)
end


local function harm_skeleton(self, amount)
	if self.hurt_timer >= self.hurt_time then
		sounds["hurt1.wav"]:stop()
		sounds["hurt1.wav"]:play()

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
	self.walk_timer = self.walk_timer + dt
	if self.walk_timer > self.walk_time then
		self.image = images['skeleton.png']
		self.walk_timer = 0
	elseif self.walk_timer > self.walk_time / 2 then
		self.image = images['skeleton2.png']
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

		walk_time = .25,
		walk_timer = 0,

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
