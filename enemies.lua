-- Enemies
local images = require("images")
local sounds = require("sounds")
local flux = require("flux")

local function collides(self, spells) 

end

local function next_path(self)
	-- Current x and y are set up already
	self.path.selectedIdx = self.path.selectedIdx + 1
	if self.path.selectedIdx > #self.path then
		self.path.selectedIdx = 1
	end
	local dest_pair = self.path:current()
	self.traveling_on = ({"x", "y"})[math.random(2)]
	local dimension = self.traveling_on
	local dest = {}
	dest[dimension] = dest_pair[dimension]
	if dest.x then
		self.scale.x = math.copysign(self.scale.x, self.x - dest.x)
	end
	self.tween = flux.to(self, dest_pair.time, dest)
	self.tween:ease("quartinout")
	self.tween:oncomplete(function()
		self:switch_xy()
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
	self.tween:ease("quartinout")
	self.tween:oncomplete(function()
		self:next_path()
	end)
end

local function update(self, dt)
	flux.update(dt)
end

function get_random_path(start_point, bounds)
	local startx, starty, xBounds, yBounds
	startx, starty = start_point.x, start_point.y
	xBounds, yBounds = bounds.x, bounds.y
	-- body
	path = {
		selectedIdx = 1
	}
	for q = 1, 1 + math.random(10), 1 do 
		local _x = xBounds.min + math.random(xBounds.max - xBounds.min)
		local _y = yBounds.min + math.random(yBounds.max - yBounds.min)
		local _time = 0.0035 * math.dist(_x, _y, startx, starty)
		table.insert(path,{x = _x , y = _y, time = _time})
		startx = _x
		starty = _y
	end
	path.current = function (self)
		return self[self.selectedIdx]
	end
	return path
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
			x = 10,
			y = 10, 
		},
		r = 5,
		rotation = dirToAngle(dir),

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