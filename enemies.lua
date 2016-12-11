-- Enemies
local images = require("images")
local sounds = require("sounds")

local function collides(self, spells) 

end

local function update(self, dt)
	local dest = self.path:current()

	local dimension = self.traveling_on
	local self[dimension] = math.lerp()

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
		traveling_on = "x",
		travel_timer = 0,
		prev_x  = x,
		prev_y = y
	}
end