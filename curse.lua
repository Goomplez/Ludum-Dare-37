-- Show the cursed stuff here
local font = require("fonts")

local curse = {
  x = 0,
  y = 0,
  blink_time = .50,
  blink_timer = 0,
  enabled_time = 5,
  enabled_timer = 5.1,
  rm_update = false,
  rm_render = false,
}

function curse.enable(self)
  self.enabled_timer = 0
end

function curse.enabled(self)
  return self.enabled_timer < self.enabled_time
end

function curse.update(self, dt)
  if not self:enabled() then
    return
  end

  self.enabled_timer = self.enabled_timer + dt
  self.blink_timer = self.blink_timer + dt
  if self.blink_timer > self.blink_time then
    self.blink_timer = 0
  end
end

function curse.render(self, dt)
  if not self:enabled() then
    return
  end
  if self.blink_timer > (self.blink_time / 2) then
    font.print(self.x, self.y, "CURSED!!")
  end
end

return curse
