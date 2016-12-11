-- Just load the iamges in here.
local fs = love.filesystem
local images = {}
local files = fs.getDirectoryItems("assets")
for i, file in ipairs(files) do
	if fs.isFile("assets/" .. file) and string.ends(file, ".png") then
		images[file] = love.graphics.newImage("assets/" .. file)
	end
end
return images