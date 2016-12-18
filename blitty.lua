local images = require("images")
local typecheck = require("typecheck")

-- This is a file to building renderables

local blitty = {}

blitty.renderables = {}

local props = {"x", "y", "scale", "rotation", "offset", "image"}

local render_func_reqs = {
	rm_render = "boolean",
	render = "function",
}

local render_reqs = {
	rm_render = "boolean",
	image = "userdata",
	x = "number",
	y = "number",
	rotation = "number",
	scale = "table",
}

local prototype = {
	x = 0,
	y = 0,
	scale = {
		x = 1,
		y = 1,
	},
	rotation = 0,
	offset = {
		x = 0,
		y = 0,
	},
	image = images["error.png"]
}

-- Set the defaults for renderables
function blitty.setDefaults(args)
	for i=1, #props do
		local k = props[i]
		-- Only try to assign things that have been assigned to in args.
		if args[k] then
			-- Handle scale and offset
			if type(prototype[k]) == "table" then
				for ik, v in pairs(prototype[k]) do
					if (args[k][ik]) then
						prototype[k][ik] =args[k][ik]
					end
				end
			else
				--Default action
				prototype[k] = args[k]
			end
		end
	end
end

-- Use a table for the optinal attributes to set
-- Everything else pulls from the proptype
function blitty.attach(newTable, args)
	for i=1, #props do
		local k = props[i]
		if args[k] then
			newTable[k] = args[k]
		else
			newTable[k] = prototype[k]
			-- Handle table copy
			if type(prototype[k]) == "table" then
				newTable[k] = {}
				for ik, v in pairs(prototype[k]) do
					newTable[k][ik] = prototype[k][ik]
				end
			end
		end
	end
end

-- Add a renderable
function blitty.addRenderable(self, item) 
	valid, msg = typecheck.matches(item, render_func_reqs)
	valid2, msg2 = typecheck.matches(item, render_reqs)
	if valid or valid2 then
		table.insert(self.renderables, item)
	else 
		print (msg)
		print (msg2)
		error("Tried to add non-renderable to renerables")
	end
end

-- Remove all the items
function blitty.cleanRenderables(self)
	for i=1, #self.renderables do
		if self.renderables[i].rm_render then
			table.remove(self.renderables, i)
		end
	end
end

return blitty