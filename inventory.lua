local player = require("player")
local types = require("typecheck")

local isPlayerUseable = types.checker({
	rm_player_inventory = "boolean",
	use = "function",
})
-- For now, this is just going to be items that can be
-- used at a later time
function get_inventory()
	local inventory = {
		slots = {}
	}
	function inventory.addUsable(item) 
		valid, msg = isPlayerUseable(item)
		if valid then
			table.insert(inventory.slots, item)
		else
			print (msg)
			error("Tried to add a non-useable to the player inventory")
		end
	end

end