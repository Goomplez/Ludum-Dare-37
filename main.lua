require("lovedebug")
require("tablebackground")
player = require("player")

local g_width, g_height  = 0, 0

-- Things that can be rendered with an x, y, and blittable image
local renderables = {}
local updateables = {}

images = {}

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



function love.update(dt)
	for i, v in ipairs(updateables) do
		v:update(dt)
	end
end

function love.load() 
	love.graphics.setDefaultFilter('linear', 'nearest')
	images = loadAssetsIntoTable()
	player.image = images["WizardLightning.png"]
	g_width, g_height = love.graphics.getDimensions()
	player.x = g_width / 2
	player.y = g_height / 2 

	table.insert(renderables, player)
	table.insert(updateables, player)
end

function love.draw() 
	renderTable()
	for i, surface in ipairs(renderables) do
		love.graphics.draw(surface.image, surface.x, surface.y, surface.rotation, surface.scale)
	end
end
