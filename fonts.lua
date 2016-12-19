--TODO: Fix some of the duplication here...
local flux = require("flux")
-- Make sure that we have the correct image filter set.
love.graphics.setDefaultFilter('linear', 'nearest')
-- Alias love.filesystem
local fs = love.filesystem

-- The table to hold characters and the print function
local font = {}
-- All of the needed files
local files = fs.getDirectoryItems("assets/font")
for i, file in ipairs(files) do
	if fs.isFile("assets/font/" .. file) and string.ends(file, ".png") then
		local charName = file:gsub(".png", "")
	--	print(charName)
		font[charName] = love.graphics.newImage("assets/font/" .. charName .. ".png")
		--print(font[charName])
	end
	-- Map "/" to it's image
	font["/"] = font["slash"]
	font["."] = font["period"]
end

local function font_print(x, y, text, rotation, scalex, scaley, shearx, sheary)
	love.graphics.push()
	love.graphics.translate(x, y)
	local lines = 0
	local chars = 0
	for i=1, #text do
		chars = chars + 1
		local c = text:sub(i,i)
		if font[c] then
			local h = font[c]:getHeight() * scalex
			local w = font[c]:getWidth() * scaley
			-- Print the char
			love.graphics.draw(
				font[c],
				(chars*w) + w/(scalex),
				(lines * h + lines) + (h/(scaley)),
				rotation,
				scalex, scaley, w/(scalex * 2), h /(scaley * 2), shearx, sheary)
		elseif c == " " then
		elseif c == "\n" then
			-- Effect a newline here.
			lines = lines + 1
			chars = 0
		else
			error("Missing graphic for character " .. c)
		end
	end
	love.graphics.pop()
end

-- Print text at x/y location
-- Intended to be called from love.draw()
function font.print(x, y, text)
	font_print(x,y, text, 0, 2, 2, 0, 0)
end

function font.printAnimated(x, y, text)
	font_print(x,y, text, font.rotation, 2, 2, font.shearx, font.sheary)
end

function font.printLarge(x, y, text)
	font_print(x,y, text, 0, 4, 4, 0, 0)
end

font.shearx = 0
font.sheary = 0
font.rotation = math.pi / 16
font.rm_update = false

font.shear_dir = -1

local target = { shearx = .25, rotation = -font.rotation }
local function continueShearing()
	local target = {
		shearx = -font.shearx,
		rotation = -font.rotation
	}
	local tween =flux.to(font, 1, target)
	tween:ease("quartinout"):oncomplete(continueShearing)
 end
-- Kick off the shearing of the menu
flux.to(font, 1, target):ease("quartinout"):oncomplete(continueShearing)
-- function

function font.update(self, dt)
end

-- Print a single line of text where the text ends at the x location
function font.printLineRightAligned(x, y, text)
	local w = font["0"]:getWidth() * 2
	-- local x = 32 + getTableBounds().x.max - w
	for i = 1, #text do
	    local c = text:sub(-i,-i)
			-- print(x, y, c)
			if not font[c] then
				-- Just skip this char
			else
		    love.graphics.draw(font[c], x - (i * w), y, 0, 2, 2)
			end
	end
end

function font.getDimensions(text)
	local h = font['0']:getHeight() * 2
	local w = font['0']:getWidth() * 2
	local xMax = 0
	local yMax = 0
	local x = 0
	local y = 0
	for i=1, #text do
		local c = text:sub(i,i)
		if font[c] then
			x = x + w
		elseif c == " " then
			x = x + w
		elseif c == "\n" or c == "\r" then
			-- Effect a newline here.
			y = y + h
			x = 0
		else
			error("Missing graphic for character " .. c)
		end
		if x > xMax then xMax = x end
		if y > yMax then yMax = x end
	end
	return xMax + w, yMax + h
end

return font
