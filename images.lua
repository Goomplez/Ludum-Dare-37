-- Just load the iamges in here.
local fs = love.filesystem
local images = {}
local files = fs.getDirectoryItems("assets")
for i, file in ipairs(files) do
	if fs.isFile("assets/" .. file) and string.ends(file, ".png") then
		images[file] = love.graphics.newImage("assets/" .. file)
	end
end
local to_darken = {
	{ name ="wood.png", factor = .5 },
	{ name = "wood-vertical.png", factor = .5},
	{ name = "lava.png", factor = .85},
	{ name = "lava-dark.png", factor = .85},
	{ name = "lava-bright.png", factor = .85},
}

for i, im in ipairs(to_darken) do
	local data = images[im.name]:getData()
	data:mapPixel(function (x, y, r, g, b, a)
		return r * im.factor , g * im.factor , b * im.factor , a
	end)
	images[im.name]:refresh()
end

return images