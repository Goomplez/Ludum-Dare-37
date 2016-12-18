-- Make a folder to handle fonts here

-- Just load the iamges in here.
local fs = love.filesystem
local font = {}
local files = fs.getDirectoryItems("assets/font")
for i, file in ipairs(files) do
	if fs.isFile("assets/font/" .. file) and string.ends(file, ".png") then
		images[file] = love.graphics.newImage("assets/font/" .. file)
	end
end

return font