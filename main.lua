require("lovedebug")
require("utils")
-- require("tablebackground")
require("spells")
flux = require("flux")
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
	flux.update(dt)
	local spawn_new = false
	for i, enemy in ipairs(enemies) do
		for i, shot in ipairs(player_spells) do
			if (math.dist(enemy.x, enemy.y, shot.x, shot.y) < (enemy.r + shot.r)) then
				shot.rm_update = true
				shot.rm_render = true
				shot.rm_player_spell = true

				enemy.rm_render = true
				enemy.rm_update = true
				enemy.rm_enemy = true
				spawn_new = true
			end
		end
	end

	for i, v in ipairs(updateables) do
		v:update(dt)
	end

	function nilTable(array, key) 
		for i=#array, 1, -1 do
			if array[i][key] then
				table.remove(array, i)
			end
		end
	end

	nilTable(updateables, "rm_update")
	nilTable(renderables, "rm_render")
	nilTable(enemies, "rm_enemy")
	nilTable(player_spells, "rm_player_spell")

	--compactArray(updateables)
	--compactArray(renderables)
	--compactArray(enemies)
	-- compactArray(player_spells)
	sounds["music.wav"]:play()
	if spawn_new then 
		spawn_new = false
		local boop = flux.to({x = 0}, 1.5, { x = 1})
		boop:oncomplete(function()
			local bounds = getTableBounds()
			local xbounds = bounds.x
			local ybounds = bounds.y
			local skelly = spawn_skeleton(math.prandom(xbounds.min, xbounds.max), math.prandom(ybounds.min, ybounds.max), "left")
			addUpdateable(skelly)
			addRenderable(skelly)
			addEnemy(skelly)

		end)
	end

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
	addEnemy(skelly)
	sounds["explosion.wav"]:setVolume(1.5)
	sounds["music.wav"]:setVolume(.25)
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
	love.graphics.print("Spells:".. #player_spells, 0, 0)
	love.graphics.print("Renderables:" .. #renderables, 0, 10)
	love.graphics.print("Updateables:".. #updateables, 0, 20)
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
	valid, msg = type_check(item, update_reqs)
	if valid then
		table.insert(updateables, item)
	else
		print(msg)
		error("Tried to add non-updatable to updateables")
	end
end

local enemy_reqs = {
	rm_enemy = "boolean",
	x = "number",
	y = "number",
	r = "number",
}

local player_spell_reqs = {
	rm_player_spell = "boolean",
	x = "number",
	y = "number",
	r = "number",
}

function addPlayerSpell(item) 
	valid, msg = type_check(item, player_spell_reqs)
	if valid then
		table.insert(player_spells, item)
	else
		print(msg)
		error("Tried to add non-updatable to updateables")
	end

end

function addEnemy(item)
	valid, msg = type_check(item, enemy_reqs)
	if valid then
		table.insert(enemies, item)
	else
		print(msg)
		error("Tried to add non-updatable to updateables")
	end

	-- body
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