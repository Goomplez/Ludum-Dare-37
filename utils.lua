
-- Take all the nil-ed elements in the array part of the table and remove them.
function compactArray(input)
	local n = #input
	local j=0
	for i=1,n do
	        if input[i]~=nil then
	                j=j+1
	                input[j]=input[i]
	        end
	end
	for i=j+1,n do
	        input[i]=nil
	end
end