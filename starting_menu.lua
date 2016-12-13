local images = require("images")
local sounds = require("sounds")
require("tablebackground")
require("utils")

local selected = 1
local show_controls = false
local control = ({
	"blue-potion.png",
	"green-potion.png",
	"red-potion.png",
	"bomb.png",
	"coin.png",
})[3]

function render_menu()

	getLavaTable():render()
	if show_controls then
		love.graphics.draw(images["controls_menu.png"], 220, 160, 0, 2, 2)
	else
		love.graphics.draw(images["new_game.png"], 300, 220, 0, 2.0, 2.0)
		love.graphics.draw(images["controls.png"], 300, 320, 0, 2.0, 2.0)
		love.graphics.draw(images[control], 280, 220 + ((selected - 1) *100), 0, 2.0, 2.0)
	end

end

function menu_key_pressed(key, scancode, is_repeat)
	if show_controls then
		show_controls = false
		return
	end
	if scancode == "up" or scancode == "w" then
		selected = selected - 1
	elseif scancode == "down" or scancode == "s" then
		selected = selected + 1
	elseif scancode == "return" or scancode == "space" then
		if selected == 2 then
			show_controls = true
		end
		if selected == 1 then
			is_menu = false
			sounds["music3.wav"]:stop()
		end
	end
	selected = math.clamp(1, selected, 2)
end

function update_menu(dt)
	getLavaTable():update(dt)
	sounds["music3.wav"]:play()
end
