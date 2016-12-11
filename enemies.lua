-- Enemies
local images = require("images")
local sounds = require("sounds")
local flux = require("flux")

local function collides(self, spells) 

end

local function next_path(self)
	-- Current x and y are set up already
	self.path.selectedIdx = self.path.selectedIdx + 1
	if self.path.selectedIdx < #self.path.selectedIdx then
		self.path.selectedIdx = 1
	end
	local dest_pair = self.path:current()
	self.traveling_on = ({"x", "y"})[math.random(2)]
	local dimension = self.traveling_on
	local dest = {}
	dest[dimension] = dest_pair[dimension]
	self.tween = flux.to(self, dest_pair.time, dest)
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
	self.tween = flux.to(self, dest_pair.time, dest)
	self.tween:oncomplete(function()
		self:next_path()
	end)
end

local function update(self, dt)
	-- So we have 3 states to consider: Moving on x, monving on y, and when 
	if tween then
		tween:update(dt)
	else 
		self:next_path()
	end

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
		local _time = 0.0075 * math.dist(_x, _y, startx, starty)
		table.insert(path,{x = _x , y = _y, time = _time})
		startx = _x
		starty = _y
	end
	path.current = function (self)
		return self[self.selectedIdx]
	end
	return path
end

function spawn_skelton(x, y, dir)

	return {
		-- Renderable
		x = x,
		y = y,
		image = images["skelton.png"],
		scale = 2.0,
		rotation = dirToAngle(dir),

		-- Collideable
		collides = collides,
		-- Skeleton AI info
		path = get_random_path(x, y, getTableBounds()),
		traveling_on = "",
		travel_timer = 0,
		prev_x  = x,
		prev_y = y,
		-- Used for the tweening function to call per frame
		tween = nil,

	}
end