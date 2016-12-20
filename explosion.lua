-- An explosion that happens when an enemy dies
local images = require("images")
local sounds = require("sounds")

--
local function update(self, dt)
  self.timer = self.timer + dt
  if self.timer > self.duration then
    self.rm_update = true
    self.rm_render = true
    return
  end
  for i=1, #self.parts do
    if self.timer > self.duration - (self.duration / 2) then
      self.parts[i]:setEmissionRate(0)
    end
    self.parts[i]:update(dt)
  end
end

-- What do I want to do for explosions?
-- I think every

local function render(self)
  -- love.graphics.draw(images["explosion1-gray.png"], 0, 2, 2)
  for i=1, #self.parts do
    love.graphics.draw(self.parts[i], self.x, self.y, 0, 2, 2)
  end
end

function spawn_explosion(x, y, duration)
  local particles = love.graphics.newParticleSystem(images["explosion1-gray.png"], 100)
  particles:setParticleLifetime(0, duration)
  particles:setEmissionRate(10)
  particles:setSizeVariation(1)
  particles:setAreaSpread('normal', 2, 2)
  particles:setLinearAcceleration(-0, -0, 0, 0)
  particles:setColors(255, 255, 255, 255, 255, 255, 255, 0)

  return {
    -- Renderable
    x = x,
    y = y,
    scale = {
      x = 2.0,
      y = 2.0
    },
    parts = { particles },
    duration = duration,
    timer = 0,
    cloud_spawn_timer = love.math.random(5) * .1,
    render = render,
    update = update,
    rm_update = false,
    rm_render = false,
  }
end
