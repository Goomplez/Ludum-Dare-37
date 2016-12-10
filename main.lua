-- TODO:

-- 

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


function love.load() 
	local playerSprite = love.graphics.newImage("assets/Wizard.png")
	player.image = playerSprite
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
