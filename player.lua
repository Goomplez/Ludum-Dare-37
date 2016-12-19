local images = require("images")
local function player_update(self, dt)
	key = love.keyboard
	if key.isDown("w") then
		self.y = self.y - self.speed * dt
	end
	if key.isDown("s") then
		self.y = self.y + self.speed * dt
	end
	if key.isDown("d") then
		self.x = self.x + self.speed * dt
		self.scale.x = math.copysign(self.scale.x, 1)
	end
	if key.isDown("a") then
		self.x = self.x - self.speed * dt
		self.scale.x = math.copysign(self.scale.x, -1)
	end

	-- Tick up the invuln frames
	if self.hit_timer <= self.hit_delay then
		self.hit_timer = self.hit_timer + dt
		if self.hit_timer >= self.hit_delay then
			self.rm_render = false
			addRenderable(self)
		else
			self.rm_render = not self.rm_render
			if not self.rm_render then
				addRenderable(self)
			end
		end
	end

	if not self.can_shoot then
		self.shot_timer = self.shot_timer + dt
	end
	if self.shot_timer > self.shot_time then
		self.can_shoot = true
		self.shot_timer = 0
	end


	if curr_music == "music2.wav" then
		keys = {"up", "down", "left", "right"}
		for i=1, #keys do
			if key.isDown(keys[i]) and self.can_shoot then
				--off = self.spell_offset
				local spell = spawn_spell(
					self.x,-- + off.x,
					self.y, -- + off.y,
					 keys[i])
				addRenderable(spell)
				addUpdateable(spell)
				addPlayerSpell(spell)
				self.can_shoot = false
				sounds["explosion.wav"]:stop()
				sounds["explosion.wav"]:play()
				break
			end
		end
	end

	local xbounds = self.bounds.x
	local ybounds = self.bounds.y
	local w = self.w * 2
	local h = self.h * 2
	if (self.x) < xbounds.min then
		self.x = xbounds.min
	end
	if (self.y) < ybounds.min then
		self.y = ybounds.min
	end

	if (self.x ) > xbounds.max then
		self.x = xbounds.max
	end
	if (self.y ) > ybounds.max then
		self.y = ybounds.max
	end
end

-- Renderable, Updatable player
function get_new_player( ... )
return {
	-- Renderable
	x = 0,
	y = 0,
	scale = {
		x = 2.0,
		y = 2.0
	},
	rotation = 0,
	image = images["Wizard.png"],

	-- Bounding
	bounds = {
		x = { min = 0, max = g_width },
		y = { min = 0, max = g_height },
	},
	w = 0,
	h = 0,

	-- Flags for collections
	rm_render = false,
	rm_update = false,
	rm_collidable = false,

	-- Updatable
	update = player_update,

	-- Custom player information
	speed = 200,
	shot_time = .2,
	shot_timer = 0,
	offset = {
		x = 10,
		y = 10,
	},
	spell_offset = { x = 20, y = 20 },
	can_shoot = false,
	scaled = function (self, name)
		return self[name] * self.scale
	end,
	-- HP, to be used by player_health
	HP = 4,
	hit_timer = 2.1,
	hit_delay = 2,
	is_vulnerable = function (self)
		return self.hit_timer > self.hit_delay
	end,
	heal = function(self, damage)
		self.HP = self.HP + damage
		self.HP = math.clamp(0, self.HP, 4)
		sounds["pickup.wav"]:play()
	end,
	harm = function (self, damage)
		self.HP = self.HP - damage
		self.HP = math.clamp(0, self.HP, 4)
		self.hit_timer = 0
		sounds["hurt2.wav"]:play()
	end
}
end

return get_new_player()
