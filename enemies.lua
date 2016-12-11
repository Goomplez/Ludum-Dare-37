-- Enemies
local images = require("images")
local sounds = require("sounds")
local flux = require("flux")
local player = require("player")

local function next_path(self)
	-- Current x and y are set up already
	self.path.selectedIdx = self.path.selectedIdx + 1
	if self.path.selectedIdx > #self.path then
		self.path.selectedIdx = 1
	end
	local dest_pair = self.path:current()
	local dest = {}
	if self.traveling_on then
		self.traveling_on = ({"x", "y"})[math.random(2)]
		local dimension = self.traveling_on
		dest[dimension] = dest_pair[dimension]

	else
		dest.x = dest_pair.x
		dest.y = dest_pair.y
	end
	if dest.x then
		self.scale.x = math.copysign(self.scale.x, self.x - dest.x)
	end

	self.tween = flux.to(self, dest_pair.time, dest)
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
	local dest = {}
	dest[dimension] = dest_pair[dimension]
	if dest.x then
		self.scale.x = math.copysign(self.scale.x, self.x - dest.x)
	end
	self.tween = flux.to(self, dest_pair.time, dest)
	self.tween:ease("linear")
	self.tween:oncomplete(function()
		self:next_path()
	end)
end


function get_random_path(start_point, bounds)
	local startx, starty, xBounds, yBounds
	startx, starty = start_point.x, start_point.y
	xBounds, yBounds = bounds.x, bounds.y
	-- body
	path = {
		selectedIdx = 1
	}
	for q = 1, 5 + math.random(5), 1 do 
		local _x = xBounds.min + math.random(xBounds.max - xBounds.min)
		local _y = yBounds.min + math.random(yBounds.max - yBounds.min)
		local _time = 0.0065 * math.dist(_x, _y, startx, starty)
		table.insert(path,{x = _x , y = _y, time = _time})
		startx = _x
		starty = _y
	end
	path.current = function (self)
		return self[self.selectedIdx]
	end
	return path
end

local function update(self, dt)
end

local function brainz(self, dt)
	local angle = math.angle(self.x, self.y, player.x, player.y)
	self.x, self.y = offsetByVector({x = self.x, y = self.y}, angle, self.speed * dt)

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
		update = brainz,
		HP = 20,
		harm = harm_z,

		rm_render = false,
		rm_update = false,
		rm_enemy = false,
	}
	return zzombie
end

function spawn_goblin(x,y, dir)
	local gob = {
		-- Renderable
		x = x,
		y = y,
		image = images["goblin-invert.png"],
		scale = {
			x = 2.0,
			y = 2.0,
		},
		offset = {
			x = 10,
			y = 10, 
		},
		r = 10,
		rotation = dirToAngle(dir),
		tween_chain = { selectedIdx = 1, next_path },

		-- Collideable
		collides = collides,
		-- Update
		update = update,
		-- Skeleton AI info
		path = get_random_path({x = x, y = y} , getTableBounds()),
		traveling_on = nil,
		travel_timer = 0,
		prev_x  = x,
		prev_y = y,
		-- Used for the tweening function to call per frame
		next_path = next_path,
		switch_xy = switch_xy,
		rm_update = false,
		rm_render = false,
		rm_enemy  = false,
	}
	gob:next_path()
	return gob
	-- body
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
		update = update,
		-- Skeleton AI info
		path = get_random_path({x = x, y = y} , getTableBounds()),
		traveling_on = "",
		travel_timer = 0,
		prev_x  = x,
		prev_y = y,
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