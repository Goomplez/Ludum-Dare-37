require("lovedebug")
require("utils")
require("tablebackground")
require("spells")
images = {} -- require("images")
player = {} -- require("player")
sounds = {} -- require("sounds")

g_width, g_height  = 0, 0

-- Things that can be rendered with an x, y, and blittable image
local renderables = {}
local updateables = {}
local collidables = {}
local fs = love.filesystem
local lava = 0
local lavaPictureName = "lava.png"


function string.ends(String,End)
   return End=='' or string.sub(String, -string.len(End))==End
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
	images = require("images")
	sounds = require("sounds")
	player = require("player")
	sounds = loadSounds()
	images = loadAssetsIntoTable()
	player.image = images["WizardLightning.png"]
	player.bounds = getTableBounds()
	g_height, g_width = love.graphics.getDimensions()
	player.x = g_width / 2
	player.y = g_height / 2 
	player.w, player.h = player.image:getDimensions()
	addRenderable(player)
	addUpdateable(player)
end

function love.draw() 
	renderTable(lavaPictureName)
	for i, surface in ipairs(renderables) do
		if surface.offset then
			local offset = surface.offset
			love.graphics.draw(
				surface.image,
				surface.x,
				surface.y,
				surface.rotation,
				surface.scale,
				surface.scale,
				offset.x,
				offset.y)
		else
			love.graphics.draw(surface.image, surface.x, surface.y, surface.rotation, surface.scale)
		end
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