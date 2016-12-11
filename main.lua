require("lovedebug")
require("utils")
-- require("tablebackground")
require("spells")
images = {} -- require("images")
player = {} -- require("player")
sounds = {} -- require("sounds")

g_width, g_height  = 0, 0

-- Things that can be rendered with an x, y, and blittable image
local renderables = {}
local updateables = {}
local enemies = {}
local player_spells = {}
local enemy_spells = {}
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

end

function love.load() 
	love.graphics.setDefaultFilter('linear', 'nearest')
	love.window.setMode(768, 600)
	require("tablebackground")
	require("enemies")
	images = require("images")
	sounds = require("sounds")
	player = require("player")
	player.image = images["WizardLightning.png"]
	player.bounds = getTableBounds()
	g_height, g_width = love.graphics.getDimensions()
	player.x = g_width / 2
	player.y = g_height / 2 
	player.w, player.h = player.image:getDimensions()
	addRenderable(player)
	addUpdateable(player)
	local bounds = getTableBounds()
	local skel_x = math.prandom(bounds.x.min, bounds.x.max)
	local skel_y = math.prandom(bounds.y.min, bounds.y.max)
	local skelly = spawn_skeleton(skel_x, skel_y, "left")
	addUpdateable(skelly)
	addRenderable(skelly)
end

function love.draw() 
	--renderTable(lavaPictureName)
	for i, surface in ipairs(renderables) do
		if surface.render then
			-- Some objects need to control how they render
			surface:render()
		elseif surface.offset then
			-- Other objects embed images/information
			local offset = surface.offset
			love.graphics.draw(
				surface.image,
				surface.x,
				surface.y,
				surface.rotation,
				surface.scale.x,
				surface.scale.y,
				offset.x,
				offset.y)
		else
			love.graphics.draw(surface.image, surface.x, surface.y, surface.rotation, surface.scale.x, surface.scale.y)
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
			-- print(k, _type, type(item[k]))
			return false, k .. " " .. _type ..  " " .. type(item[k])
		end
	end
	return true, nil
end

function addUpdateable(item) 
	if type_check(item, update_reqs) then
		table.insert(updateables, item)
	else
		error("Tried to add non-updatable to updateables")
	end
end

local render_func_reqs = {
	rm_render = "boolean",
	render = "function",
}

local render_reqs = {
	rm_render = "boolean",
	image = "userdata",
	x = "number",
	y = "number",
	rotation = "number",
	scale = "table",
}

function addRenderable(item) 
	valid, msg = type_check(item, render_func_reqs)
	valid2, msg2 = type_check(item, render_reqs)
	if valid or valid2 then
		table.insert(renderables, item)
	else 
		print (msg)
		print (msg2)
		error("Tried to add non-renderable to renerables")
	end
end