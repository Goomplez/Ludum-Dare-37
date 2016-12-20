local images = require("images")
local sounds = require("sounds")
local font = require("fonts")
local flux = require("flux")
require("tablebackground")
require("utils")

local selected = 1
local show_controls = false
local show_credits = false
local control = ({
	"blue-potion.png",
	"green-potion.png",
	"red-potion.png",
	"bomb.png",
	"coin.png",
})[love.math.random(5)]

local controls_text =
'MOVE=WASD\n\n' ..
'ATTACK=udrl\n\n' ..
'PAUSE=P\n\n' ..
'QUIT=Q\n\n'

local credits =
'CODE BY\n  YUMAIKAS\n\n' ..
'ART BY\n  GOOMPLEZ\n\n'

function render_menu()
	getLavaTable():render()
	local titlex = getTableBounds().x.min
	local titley = getTableBounds().y.min
	if show_controls then
		-- love.graphics.draw(images["scroll.png"], 110, 80, 0, .25, .25)
		font.print(230, 170, controls_text)
	elseif show_credits then
		-- love.graphics.draw(images["controls_menu.png"], 220, 160, 0, 2, 2)
		-- love.graphics.draw(images["backdrop.png"], 220, 160, 0, 2, 2)
		font.print(230, 170, credits)
	else
		font.printLarge(titlex + 80, titley + 32, "FATEFUL CAVERN")
		local menu_anchorx = 290
		local menu_anchory = 200
		local menu_items = {
			{menu_anchorx, menu_anchory, "NEW GAME"},
			{menu_anchorx, menu_anchory + 50, "CONTROLS"},
			{menu_anchorx, menu_anchory + 100, "CREDITS"}
		}
		for i=1, #menu_items do
			if selected == i then
				font.printAnimated(unpack(menu_items[i]))
			else
				font.print(unpack(menu_items[i]))
			end
		end
		--font.print(300, 220, "NEW GAME")
		-- font.print(300, 320, "CONTROLS")
		love.graphics.draw(images[control], menu_anchorx - 20, menu_anchory + ((selected - 1) *50), 0, 2.0, 2.0)
	end
end

function menu_key_pressed(key, scancode, is_repeat)
	if show_controls then
		show_controls = false
		return
	end
	if show_credits then
		show_credits = false
		return
	end
	if scancode == "up" or scancode == "w" then
		selected = selected - 1
	elseif scancode == "down" or scancode == "s" then
		selected = selected + 1
	elseif scancode == "return" or scancode == "space" then
		if selected == 3 then
			show_credits = true
		end
		if selected == 2 then
			show_controls = true
		end
		if selected == 1 then
			is_menu = false
			sounds["music3.wav"]:stop()
		end
	end
	selected = math.clamp(1, selected, 3)
end

function update_menu(dt)
	getLavaTable():update(dt)
	flux.update(dt)
	font:update(dt)
	sounds["music3.wav"]:play()
end
