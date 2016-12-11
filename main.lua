require("lovedebug")
require("utils")
require("tablebackground")
require("spells")
player = require("player")

g_width, g_height  = 0, 0

-- Things that can be rendered with an x, y, and blittable image
local renderables = {}
local updateables = {}
local fs = love.filesystem
local lava = 0
local lavaPictureName = "lava.png"


images = {}
sounds = {}

function string.ends(String,End)
   return End=='' or string.sub(String, -string.len(End))==End
end 

function loadSounds()
	local sounds = {}
	for i, file in ipairs(fs.getDirectoryItems("sounds")) do
		if fs.isFile("sounds/" .. file) and string.ends(file, ".wav") then
			sounds[file] = love.audio.newSource("sounds/" .. file)
		end
	end
	return sounds
end

function loadAssetsIntoTable()
	local images = {}
	local files = fs.getDirectoryItems("assets")
	for i, file in ipairs(files) do
		if fs.isFile("assets/" .. file) and string.ends(file, ".png") then
			images[file] = love.graphics.newImage("assets/" .. file)
		end
	end
	return images
end

function love.update(dt)
	for i, v in ipairs(updateables) do
		v:update(dt)
	end
	for i, v in ipairs(updateables) do 
		if v.rm_update then
			updateables[i] = nil
		end
	end
	for i,v in ipairs(renderables) do 
		if v.rm_render then
			renderables[i] = nil
		end
	end

	compactArray(updateables)
	compactArray(renderables)
	lava = lava + dt
	if lava >= 12 then
		lavaPictureName = "lava.png"
		lava = 0
	elseif lava >= 9 then
		lavaPictureName = "lava-dark.png"
	elseif lava >= 6 then
		lavaPictureName = "lava.png"
	elseif lava >= 3 then
		lavaPictureName = "lava-bright.png"
	end
end

function love.load() 
	love.graphics.setDefaultFilter('linear', 'nearest')
	love.window.setMode(768, 600)
	sounds = loadSounds()
	images = loadAssetsIntoTable()
	player.image = images["WizardLightning.png"]
	player.bounds = getTableBounds()
	g_height, g_width = love.graphics.getDimensions()
	player.x = g_width / 2
	player.y = g_height / 2 
	player.w, player.h = player.image:getDimensions()
	-- player.bounds.x.max = g_height
	-- player.bounds.y.max = g_width
	addRenderable(player)
	table.insert(updateables, player)
end

function love.draw() 
	renderTable(lavaPictureName)
	for i, surface in ipairs(renderables) do
		love.graphics.draw(surface.image, surface.x, surface.y, surface.rotation, surface.scale)
	end

end

local update_reqs = {
	rm_update = "boolean",
	update = "function",
}

function type_check(item, fields)
	for k, _type in pairs(fields) do
		if type(item[k]) ~= _type then
			print(k, _type, type(item[k]))
			return false
		end
	end
	return true
end

function addUpdateable(item) 
	if type_check(item, update_reqs) then
		table.insert(updateables, item)
	else
		error("Tried to add non-updatable to updateables")
	end
end

local render_reqs = {
	rm_render = "boolean",
	image = "userdata",
	x = "number",
	y = "number",
	rotation = "number",
	scale = "number",
}

function addRenderable(item) 
	if type_check(item, render_reqs) then
		table.insert(renderables, item)
	else 
		error("Tried to add non-renderable to renerables")
	end
end