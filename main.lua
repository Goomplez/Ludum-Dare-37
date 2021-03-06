-- require("lovedebug")
require("utils")
require("spells")
require("tablebackground")
require("enemies")
require("zombie")
require("skeleton")
require("dragon")
require("player_health")
local blitty = require("blitty")
local font = require("fonts")
local curse = require("curse")
local flux = require("flux")
local images = require("images")
local player = require("player")
local sounds = require("sounds")
local count_down = require("countdown")
local typecheck = require("typecheck")

g_height = 0
g_width = 0

-- Things that can be rendered with an x, y, and blittable image
local renderables = {}
local updateables = {}
local enemies = {}
local player_spells = {}
local other_spells = {}
dragon = {}
local fs = love.filesystem
local spawned_enemies = 0
local paused = false
local game_over = false
local end_game_timer = 0
local shake_timer = .26
local shake_time = .125
local shake_mag = 2
local enemy_num = 100
local has_boss = false
local dragon_updates = 0
local fireball_timer = 0
local fireball_time = 5

function love.load()
	love.window.setMode(768, 513)
	require("starting_menu")
	loadStart()
	sounds["explosion.wav"]:setVolume(1.5)
	sounds["music.wav"]:setVolume(.25)
	sounds["music2.wav"]:setVolume(.15)
	sounds["music3.wav"]:setVolume(.15)
end

is_menu = true
local rand2 = math.prandom

local function get_dragon_ball()
	local bounds = getTableBounds()
	if is_boss then
		return spawn_fireball(rand2(32 - dragon.x , dragon.x + 32), rand2(0, 10), "down")
	else
		return spawn_fireball(rand2(bounds.x.min, bounds.x.max), rand2(0, -10), "down")
	end

end

function get_boss_attack(dt)
	fireball_timer = fireball_timer + dt
	if fireball_timer > fireball_time then
		addOtherSpell(get_dragon_ball())
		addOtherSpell(get_dragon_ball())
		fireball_timer = 0
	end
end

local function spawn()
	if --[[math.random(5) == 5]] true then
		for i=1, math.clamp(1, math.log10(#enemies), 10), 1 do
			addOtherSpell(get_dragon_ball())
		end
	end
	local spawns = {
		spawn_goblin,
		spawn_goblin,
		spawn_goblin,
		spawn_goblin,
		spawn_goblin,
	 	spawn_skeleton,
		spawn_skeleton,
		spawn_skeleton,
		spawn_zombie}
	return spawns[math.random(#spawns)]
end
local lava = 0
local lavaPictureName = "lava.png"

function love.keypressed(key, scancode, isrepeat)
	if is_menu then
		menu_key_pressed(key, scancode, isrepeat)
	end
	if scancode == "p" then
		paused = not paused
	end
	if scancode == "q" then
		love.event.quit()
	end
	if scancode == "return" and (player.HP == 0 or (count_down:isBoss() and dragon.HP <= 0))  then
		love.event.quit("restart")
	end
end

function love.update(dt)
	if is_menu then
		update_menu(dt)
		return
	end

	if shake_timer < shake_time then
		shake_timer = shake_timer + dt
	end
	-- Play the curse music if it's on queue
	if curse:enabled() then
		sounds["music2.wav"]:stop()
		sounds["music.wav"]:play()
	else
		sounds["music.wav"]:stop()
		sounds["music2.wav"]:play()
	end
	if paused then
		return
	end
	if player.HP == 0 or count_down:isBoss() and dragon.HP == 0 then
		end_game_timer = end_game_timer + dt
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
				shake_timer = 0
				if enemy.rm_enemy and enemy.rm_player_spell == nil then
					spawn_new = true
				end
			end
		end
	end
	if player:is_vulnerable() then
		for i, enemy in ipairs(enemies) do
			if not enemy.rm_enemy and math.dist(enemy.x, enemy.y, player.x, player.y) < enemy.r then
				player:harm(1)
				break
			end
		end
	end
	for i=1, #other_spells do
		local _spell = other_spells[i]
		if (not _spell.rm_other_spell) and math.dist(_spell.x, _spell.y, player.x, player.y) < _spell.r  then
			_spell:collide()
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
	nilTable(other_spells, "rm_other_spell")
	if spawn_new then
		count_down:tick()
		if count_down:isBoss() and dragon_updates < 5 then
			addEnemy(dragon)
			dragon_updates = dragon_updates + 1
		end
		spawn_new = false
		local boop = flux.to({x = 0}, 1.5, { x = 1})
		boop:oncomplete(function()
			if count_down:isBoss() then return end
			local bounds = getTableBounds()
			local xbounds = bounds.x
			local ybounds = bounds.y
			local enemy = spawn()(math.prandom(xbounds.min, xbounds.max), math.prandom(ybounds.min, ybounds.max), "left")
			addEnemy(enemy)
		end)
		-- Spawn an extra enemy every 10 enemies
		if count_down.total % 5 == 0 then
			boop:oncomplete(function()
				if count_down:isBoss() then return end
				local bounds = getTableBounds()
				local xbounds = bounds.x
				local ybounds = bounds.y
				local enemy = spawn()(math.prandom(xbounds.min, xbounds.max), math.prandom(ybounds.min, ybounds.max), "left")
				addEnemy(enemy)
			end)
		end
	end
end

function loadStart()
	load_lava_table()
	-- count_down:setCountDown(enemy_num)
	player.bounds = getTableBounds()
	player.image = images["Wizard.png"]
	g_height, g_width = love.graphics.getDimensions()
	player.x = g_width / 2
	player.y = g_height / 2
	player.w, player.h = player.image:getDimensions()
	addRenderable(player)
	addUpdateable(player)
	addUpdateable(font)
	addRenderable(curse)
	addUpdateable(curse)
	count_down.total = 0

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
	load_hp_bar()
	addEnemy(brainzzzz)
	dragon = spawn_dragon()
	-- addEnemy(dragon)

	addRenderable(count_down)
end

function love.draw()
	if is_menu then
		render_menu()
		return
	end
	if shake_timer < shake_time then
		love.graphics.push()
		love.graphics.translate(math.prandom(-shake_mag, shake_mag), math.prandom(-shake_mag, shake_mag))
	end
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
	local fps = tostring(love.timer.getFPS())
	font.printLineRightAligned(768, 460, fps .. " FPS")
	if player.HP == 0 then
		w, h = images["game_over2.png"]:getDimensions()
		love.graphics.draw(images["game_over2.png"], g_height / 2, g_width / 2, 0, 2, 2, w/2, h/2)
	elseif count_down:isBoss() and dragon.HP == 0 then
		w, h = images["you_win2.png"]:getDimensions()
		love.graphics.draw(images["you_win2.png"], g_height / 2, g_width / 2, 0, 2, 2, w/2, h/2)
	end
	if shake_timer < shake_time then
		love.graphics.pop()
	end
end

local isUpdatable = typecheck.checker({
	rm_update = "boolean",
	update = "function",
})

function addUpdateable(item)
	valid, msg = isUpdatable(item, update_reqs)
	if valid then
		table.insert(updateables, item)
	else
		print(msg)
		error("Tried to add non-updatable to updateables")
	end
end

local isEnemy = typecheck.checker({
	rm_enemy = "boolean",
	x = "number",
	y = "number",
	r = "number",
	harm = "function",
})

local isPlayerSpell = typecheck.checker({
	rm_player_spell = "boolean",
	x = "number",
	y = "number",
	r = "number",
})

local isOtherSpell = typecheck.checker({
	rm_other_spell = "boolean",
	x = "number",
	y = "number",
	r = "number",
	collide = "function",
})

function addOtherSpell(item)
	valid, msg = isOtherSpell(item)
	if valid then
		table.insert(other_spells, item)
		addRenderable(item)
		addUpdateable(item)
	else
		print(msg)
		error("Tried to add non-updatable to updateables")
	end
end

function addPlayerSpell(item)
	valid, msg = isPlayerSpell(item, player_spell_reqs)
	if valid then
		table.insert(player_spells, item)
	else
		print(msg)
		error("Tried to add non-updatable to updateables")
	end
end

function addEnemy(item)
	valid, msg = isEnemy(item, enemy_reqs)
	if valid then
		addRenderable(item)
		addUpdateable(item)
		table.insert(enemies, item)
	else
		print(msg)
		error("Tried to add non-updatable to updateables")
	end
end

local isRenderFunc = typecheck.checker({
	rm_render = "boolean",
	render = "function",
})

local canRender = typecheck.checker({
	rm_render = "boolean",
	image = "userdata",
	x = "number",
	y = "number",
	rotation = "number",
	scale = "table",
})

function addRenderable(item)
	valid, msg = isRenderFunc(item)
	valid2, msg2 = canRender(item)
	if valid or valid2 then
		table.insert(renderables, item)
	else
		print (msg)
		print (msg2)
		error("Tried to add non-renderable to renerables")
	end
end
