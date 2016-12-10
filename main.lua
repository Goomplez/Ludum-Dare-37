-- TODO:

-- 
require("lovedebug")

local g_width, g_height  = 0, 0

-- Things that can be rendered with an x, y, and blittable image
local renderables = {}

-- Renderable
local player = {
	x = 0,
	y = 0,
	scale = 4.0,
	rotation = 0
}
local images = {}

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end 

function loadAssetsIntoTable()
	local fs = love.filesystem
	local images = {}
	local files = fs.getDirectoryItems("assets")
	for i, file in ipairs(files) do
		if fs.isFile("assets/" ..file) and string.ends(file, ".png")  then
			images[file] = love.graphics.newImage("assets/"..file)
		end
	end

	return images
end

function love.load() 
	love.graphics.setDefaultFilter('linear', 'nearest')
	images = loadAssetsIntoTable()
	player.image = images["WizardLightning.png"]
	table.insert(renderables, player)
	g_width, g_height = love.graphics.getDimensions()
	player.x = g_width / 2
	player.y = g_height / 2 
end

function love.draw() 
	for i, surface in ipairs(renderables) do
		love.graphics.draw(surface.image, surface.x, surface.y, surface.rotation, surface.scale)
	end
end