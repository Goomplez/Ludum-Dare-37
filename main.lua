-- require("lovedebug")
require("utils")
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
local spawned_enemies = 0
local paused = false
local game_over = false

local lava = 0
local lavaPictureName = "lava.png"

function string.ends(String,End)
   return End=='' or string.sub(String, -string.len(End))==End
end 

function love.keypressed(key, scancode, isrepeat)
	if scancode == "p" then
		paused = not paused
	end
end

function love.update(dt)
	sounds["music2.wav"]:play()
	if paused then
		return
	end
	if player.HP == 0 then

		return
	end

	flux.update(dt)
	local spawn_new = false
	for i, enemy in ipairs(enemies) do
		for i, shot in ipairs(player_spells) do
			if (math.dist(enemy.x, enemy.y, shot.x, shot.y) < (enemy.r + shot.r)) then
				shot.rm_update = true
				shot.rm_render = true
				shot.rm_player_spell = true
				enemy:harm(1)
				if enemy.rm_enemy then
					spawn_new = true
				end
			end
		end
	end
	if player:is_vulnerable() then
		for i, enemy in ipairs(enemies) do
			if not enemy.rm_enemy and math.dist(enemy.x, enemy.y, player.x, player.y) < enemy.r then
				player:harm(1)
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
	if spawn_new then 
		spawned_enemies = spawned_enemies + 1
		spawn_new = false
		local boop = flux.to({x = 0}, 1.5, { x = 1})
		boop:oncomplete(function()
			local bounds = getTableBounds()
			local xbounds = bounds.x
			local ybounds = bounds.y
			local spawn = ({spawn_skeleton, spawn_goblin, spawn_zombie})[math.random(3)]
			local enemy = spawn(math.prandom(xbounds.min, xbounds.max), math.prandom(ybounds.min, ybounds.max), "left")
			addEnemy(enemy)
		end)
		if spawned_enemies % 10 == 0 then
			boop:oncomplete(function()
				local bounds = getTableBounds()
				local xbounds = bounds.x
				local ybounds = bounds.y
				local spawn = ({spawn_skeleton, spawn_goblin, spawn_zombie})[math.random(3)]
				local enemy = spawn(math.prandom(xbounds.min, xbounds.max), math.prandom(ybounds.min, ybounds.max), "left")
				addEnemy(enemy)
			end)
		end
	end

end

function loadStart() 
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
	addEnemy(skelly)
	local gob_x = math.prandom(bounds.x.min, bounds.x.max)
	local gob_y = math.prandom(bounds.y.min, bounds.y.max)
	local gobs = spawn_goblin(gob_x, gob_y, "left")
	addEnemy(gobs)
	local z_x = math.prandom(bounds.x.min, bounds.x.max)
	local z_y = math.prandom(bounds.y.min, bounds.y.max)
	local brainzzzz = spawn_zombie(z_x, z_y, "left")
	addEnemy(brainzzzz)
end

function love.load() 
	love.graphics.setDefaultFilter('linear', 'nearest')
	love.window.setMode(768, 600)
	require("tablebackground")
	require("enemies")
	require("zombie")
	require("skeleton")
	images = require("images")
	sounds = require("sounds")
	player = require("player")
	require("player_health")
	player.image = images["WizardLightning.png"]
	sounds["explosion.wav"]:setVolume(1.5)
	sounds["music.wav"]:setVolume(.25)
	sounds["music2.wav"]:setVolume(.15)
	loadStart()
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
	harm = "function",
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
		addRenderable(item)
		addUpdateable(item)
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