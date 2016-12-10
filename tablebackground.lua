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
-- How the table is rendered
function renderTable()
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
		draw(images["lava.png"], i * w, j * h, 0, scale)
	end

	j = 13
	for i=-1, 22, 1 do
		draw(images["lava.png"], i * w, j * h, 0, scale)
	end

	local i = -1
	for j=0, 12, 1 do
		draw(images["lava.png"], i * w, j * h, 0, scale)
	end
	i = 22
	for j=0, 12, 1 do
		draw(images["lava.png"], i * w, j * h, 0, scale)
	end

	love.graphics.pop()
end