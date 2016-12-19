---[[
--local images = require("images")
local sounds = require("sounds")
local font = require("fonts")
require("utils")

local function render(self)
	str = tostring(self.total) .. "/" .. tostring(self.out_of)
	font.printLineRightAligned(768, 1, str)
end

local function update(self, dt)
end

function setCountDown(self, val)
	self.total = val
end

function tick(self)
	self.total = self.total + 1
	self.total = math.clamp(0, self.total, 100)
end

return {
	x = 0,
	y = 0,
	total = 0,
	out_of = 100,
	render = render,
	udpate = update,
	setCountDown = setCountDown,
	tick = tick,
	rm_render = false,
	rm_update = false
}
