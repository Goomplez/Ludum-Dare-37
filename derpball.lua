-- Derpball
local curse = require("curse")
local images = require("images")
local sounds = require("sounds")
local player = require("player")
require ("utils")

local function update(self, dt)
	local angle = math.angle(self.x, self.y, player.x, player.y)
	self.x, self.y = offsetByVector({x = self.x, y = self.y}, angle, self.velocity * dt)
  self.rotation = angle

  self.life_timer = self.life_timer + dt
  if self.life_timer > self.life_time then
    self.rm_render = true
    self.rm_update = true
    self.rm_other_spell = true
  end
end

local function collide(self)
  self.rm_render = true
  self.rm_update = true
  self.rm_other_spell = true
  curse:enable()
end

function spawn_derpball(x,y)
	return {
		-- Renderable
		x = x,
		y = y,
		r = 10,
		image = images["derpball.png"],
		rotation = 0,
		scale = { x = -2.0, y = 2.0, },
		offset = {
			x = 5,
			y = 4,
		},

    life_timer = 0,
    life_time = 5,

		-- Updateable
		velocity = 150,
		update = update,
    -- Other spell
    collide = collide,

		-- Removal flags
		rm_render = false,
		rm_update = false,
		rm_other_spell = false,
	}
end
