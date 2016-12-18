-- Very basic typechecking facilities
local typecheck = {}

-- Does the item in question have the requested fields of their types?
function typecheck.matches(item, fields)
	for k, _type in pairs(fields) do
		if type(item[k]) ~= _type then
			-- print(k, _type, type(item[k]))
			return false, k .. " " .. _type ..  " " .. type(item[k])
		end
	end
	return true, nil
end

return typecheck