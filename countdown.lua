---[[
--local images = require("images")
local sounds = require("sounds")
local font = require("fonts")
require("utils")

local numbers = { }
for i=0, 9 do
	numbers[tostring(i)] = font[i .. ".png"]
end


local function render(self)
	str = tostring(self.total)
	local w = numbers["0"]:getWidth() * 2
	local x = 32 + getTableBounds().x.max - w

	for i = 1, #str do
	    local c = str:sub(-i,-i)
	    love.graphics.draw(numbers[c], x - (i * w), 0, 0, 2, 2)
	end

end

local function update(self, dt) 

end

function setCountDown(self, val)
	self.total = val
end

function tick(self)
	self.total = self.total - 1
	self.total =  math.clamp(0, self.total, 100)
end

return {
	x = 0,
	y = 0,
	total = 100,
	render = render,
	udpate = update,
	setCountDown = setCountDown,
	tick = tick,
	rm_render = false,
	rm_update = false
}
--]]