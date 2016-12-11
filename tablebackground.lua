function getTableBounds()
	local scale = 2
	local w = 16 * scale
	local h = 16 * scale
	local xBounds = { min = 32, max = 32 + (w * 22) }
	local yBounds = { min = 64, max = 64 + (h * 12) }
	return {
		x = xBounds,
		y = yBounds
	}
end


local function update(self, dt) 
	self.lava_timer = self.lava_timer + dt
	if self.lava_timer >= 12 then
		self.lavaPictureName = "lava.png"
		self.lava_timer = 0
	elseif self.lava_timer >= 9 then
		self.lavaPictureName = "lava-dark.png"
	elseif self.lava_timer >= 6 then
		self.lavaPictureName = "lava.png"
	elseif self.lava_timer >= 3 then
		self.lavaPictureName = "lava-bright.png"
	end
end

-- How the table is rendered
local function renderTable(self)
	lavaPictureName = self.lavaPictureName
	love.graphics.push()
	love.graphics.translate(32, 64)
	local draw = love.graphics.draw

	-- render 22x11 table
	local scale = 2
	-- If the scale changes, change it in getTableBounds() as well
	local w = 16 * scale
	local h = 16 * scale

	for j=0, 11, 1 do
		for i=0, 21, 1 do
			draw(images["wood.png"], i * w, j * h, 0, scale)
		end
	end
	-- Table bottom at 12
	local j = 12
	for i=0, 21, 1 do
		draw(images["wood-vertical.png"], i * w, j * h, 0, scale)
	end

	-- render cave all above table
	j = -2
	for i=-1, 22, 1 do
		draw(images["cavewall.png"], i * w, j * h, 0, scale)
	end

	-- render lava around table
	j = -1
	for i=-1, 22, 1 do
		draw(images[lavaPictureName], i * w, j * h, 0, scale)
	end

	j = 13
	for i=-1, 22, 1 do
		draw(images[lavaPictureName], i * w, j * h, 0, scale)
	end

	local i = -1
	for j=0, 12, 1 do
		draw(images[lavaPictureName], i * w, j * h, 0, scale)
	end
	i = 22
	for j=0, 12, 1 do
		draw(images[lavaPictureName], i * w, j * h, 0, scale)
	end
	love.graphics.pop()
end

local lavaTable = {
	lava_timer = 0,
	lavaPictureName = "lava.png",
	render = renderTable,
	update = update,
	rm_render = false,
	rm_update = false,
}

addRenderable(lavaTable)
addUpdateable(lavaTable)
