require("utils")
-- Load sounds here
local fs = love.filesystem
local sounds = {}
for i, file in ipairs(fs.getDirectoryItems("sounds")) do
	if fs.isFile("sounds/" .. file) and string.ends(file, ".wav") then
		sounds[file] = love.audio.newSource("sounds/" .. file)
	end
end
return sounds